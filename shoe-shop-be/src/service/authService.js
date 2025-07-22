import dotenv from 'dotenv';
dotenv.config();
import db from "../models/index";
import bcrypt from "bcrypt";
import { createJWT, createRefreshToken } from "../middleware/JWTAction";

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

        // Kiểm tra mật khẩu
        let isCorrectPassword = await checkPassword(rawData.password, user.password);
        if (isCorrectPassword) {

            let group = await getGroupWithRoles(user);


            let payload = {
                id: user.id,
                username: user.username,
                group: group,
                cartId: user.Cart?.id || null
            }


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
                    group: group,
                    cartId: user.Cart?.id || null
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

export {
    registerNewUser, loginUser, getGroupWithRoles, hashUserPassword, checkPassword
};

