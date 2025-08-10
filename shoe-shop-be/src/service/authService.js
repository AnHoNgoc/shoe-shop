import dotenv from 'dotenv';
dotenv.config();
import db from "../models/index.js"
import bcrypt from "bcrypt";
import { createJWT, createRefreshToken } from "../middleware/JWTAction.js";
import { OAuth2Client } from "google-auth-library";


const hashUserPassword = async (userPassword) => {
    try {
        const salt = await bcrypt.genSalt(10);
        return bcrypt.hash(userPassword, salt);
    } catch (error) {
        console.error('Error hashing password:', error);
        throw error;
    }
}

const checkUser = async (username) => {
    let user = await db.User.findOne({
        where: { username: username }
    })
    if (user) {
        return true;
    }
    return false;
}

const checkPassword = async (inputPassword, hashPassword) => {
    try {
        return await bcrypt.compare(inputPassword, hashPassword);
    } catch (error) {
        console.error('Error comparing password:', error);
        throw error;
    }
}

const registerNewUser = async (rawUserData) => {

    const t = await db.sequelize.transaction();

    try {
        let isUserExist = await checkUser(rawUserData.username);
        if (isUserExist) {
            return {
                EM: "Account is already exist",
                EC: 1
            };
        }

        let hashPassword = await hashUserPassword(rawUserData.password);

        const newUser = await db.User.create({
            username: rawUserData.username,
            password: hashPassword,
            group_id: 3
        }, { transaction: t });


        await db.Cart.create({
            user_id: newUser.id
        }, { transaction: t });


        await t.commit();

        return {
            EM: "Account is created successfully",
            EC: 0
        };

    } catch (error) {
        await t.rollback();
        console.error("Error in registerNewUser:", error);
        return {
            EM: "Internal server error",
            EC: -1
        };
    }
};

const getGroupWithRoles = async (user) => {

    let roles = await db.Group.findOne({
        where: { id: user.group_id },
        attributes: ["id", "name"],
        include: {
            model: db.Role,
            attributes: ["id", "url"],
            through: { attributes: [] }
        },

    })
    return roles ? roles : null
}


const loginUser = async (rawData) => {
    try {

        let user = await db.User.findOne({
            where: {
                username: rawData.valueLogin
            },
            include: {
                model: db.Cart,
                attributes: ['id']
            }
        });

        if (!user) {
            return {
                EM: "Invalid login information",
                EC: 1
            };
        }

        let isCorrectPassword = await checkPassword(rawData.password, user.password);
        if (isCorrectPassword) {

            let group = await getGroupWithRoles(user);

            let permissions = group.Roles.map(role => role.url);

            let payload = {
                id: user.id,
                username: user.username,
                groupName: group.name,
                permissions,
                cartId: user.Cart && user.Cart.id || null
            };


            let accessToken = createJWT(payload);
            let refreshToken = await createRefreshToken(payload);

            return {
                EM: "Login successfully",
                EC: 0,
                DT: {
                    access_token: accessToken,
                    refresh_token: refreshToken,
                    username: user.username,
                    id: user.id,
                    groupName: group.name,
                    cartId: user.Cart && user.Cart.id || null
                }
            };

        } else {
            return {
                EM: "Invalid login information",
                EC: 1
            };
        }
    } catch (error) {
        console.error("Error during login:", error);
        return {
            EM: "Server error",
            EC: -1
        };
    }
};


const CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const client = new OAuth2Client(CLIENT_ID);


async function verifyGoogleToken(idToken) {
    const ticket = await client.verifyIdToken({
        idToken,
        audience: CLIENT_ID
    });
    return ticket.getPayload();
}


const googleLoginService = async (idToken) => {
    const t = await db.sequelize.transaction();

    try {

        // 1. Xác thực token với Google
        const googleData = await verifyGoogleToken(idToken);
        const googleId = googleData.sub;
        const email = googleData.email;
        const name = googleData.name;
        const avatar = googleData.picture;

        // 2. Kiểm tra social account
        let socialAccount = await db.SocialAccount.findOne({
            where: { provider: 'google', provider_user_id: googleId },
            include: db.User
        });

        let user;
        if (socialAccount) {
            user = socialAccount.User;
            // Lấy cart nếu chưa include
            if (!user.Cart) {
                user.Cart = await db.Cart.findOne({ where: { user_id: user.id } });
            }
        } else {
            // 3. Tạo user mới + cart + social account
            user = await db.User.create({
                username: email,
                profile_image: avatar,
                password: null,
                group_id: 3
            }, { transaction: t });

            const cart = await db.Cart.create({
                user_id: user.id
            }, { transaction: t });

            await db.SocialAccount.create({
                user_id: user.id,
                provider: 'google',
                provider_user_id: googleId,
                email
            }, { transaction: t });

            user.Cart = cart;

            await t.commit();
        }

        // 4. Lấy group + permissions
        const group = await getGroupWithRoles(user);
        const permissions = group.Roles.map(role => role.url);

        // 5. Payload thống nhất
        const payload = {
            id: user.id,
            username: user.username,
            groupName: group.name,
            permissions,
            cartId: user.Cart && user.Cart.id || null
        };

        // 6. Tạo token (refresh token tự lưu vào Redis)
        const accessToken = createJWT(payload);
        const refreshToken = await createRefreshToken(payload);

        return {
            EM: "Google login successful",
            EC: 0,
            DT: {
                access_token: accessToken,
                refresh_token: refreshToken,
                username: user.username,
                id: user.id,
                groupName: group.name,
                cartId: user.Cart && user.Cart.id || null
            }
        };

    } catch (error) {
        await t.rollback();
        console.error("googleLoginService error:", error);
        return {
            EM: "Invalid Google token",
            EC: -1,
            DT: {}
        };
    }
};

export {
    registerNewUser, loginUser, getGroupWithRoles, hashUserPassword, checkPassword, googleLoginService
};

