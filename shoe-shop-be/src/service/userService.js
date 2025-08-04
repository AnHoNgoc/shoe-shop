import db from "../models/index.js";
import { Op } from 'sequelize';
import { checkPassword, hashUserPassword } from "../service/authService.js";



const getUserList = async (page, limit, nameSearch, groupId) => {
    try {
        let offset = (page - 1) * limit

        const whereConditions = {
            username: {
                [Op.like]: `%${nameSearch}%`
            }
        };

        // Chỉ thêm điều kiện groupId nếu groupId có giá trị
        if (groupId) {
            whereConditions.groupId = {
                [Op.eq]: groupId
            };
        }

        const { count, rows } = await db.User.findAndCountAll({
            attributes: ["id", "username", "group_id"],
            include: {
                model: db.Group, attributes: ["id", "name"],
            },
            where: whereConditions,
            offset: offset,
            limit: limit
        });

        let totalPages = Math.ceil(count / limit);

        let data = {
            totalRows: count,
            totalPages: totalPages,
            users: rows
        }

        return {
            EM: data.users.length > 0 ? "Fetched list user successful" : "No users",
            EC: 0,
            DT: data
        };


    } catch (error) {
        return {
            EM: "Server error",
            EC: -1,
            DT: []
        };
    }
}


const checkUserName = async (userName) => {
    let user = await db.User.findOne({
        where: { username: userName }
    })
    if (user) {
        return true;
    }
    return false;
}

const createNewUser = async (data) => {

    const t = await db.sequelize.transaction();

    try {
        let isAccoutExist = await checkUserName(data.userName);

        if (isAccoutExist === true) {
            return {
                EM: "Account is already exist",
                EC: 1
            };
        }

        const hashPass = await hashUserPassword(data.password);
        data.password = hashPass;

        const newUser = await db.User.create(data, { transaction: t });

        await db.Cart.create({ userId: newUser.id }, { transaction: t });

        await t.commit();

        return {
            EM: "Create new user successful",
            EC: 0,
        };
    } catch (error) {
        // Rollback nếu có lỗi
        await ts.rollback();
        console.log(error);
        return {
            EM: "Something went wrong",
            EC: -1,
        };
    }
};

const deleteUser = async (id) => {
    try {
        await db.User.destroy({
            where: {
                id: id,
            },
        });
        return {
            EM: "Delete user successful",
            EC: 0,
        }
    } catch (error) {
        return {
            EM: "Server error",
            EC: -1,
        };
    }
}

const getUserById = async (id) => {
    let data = {};

    try {
        data = await db.User.findOne({
            where: { id: id },
            attributes: ['id', 'username', 'profile_image'],
            include: {
                model: db.Group,
                attributes: ['id', 'name']
            }
        });

        if (data) {
            return {
                EM: "Fetched user by id successful",
                EC: 0,
                DT: data
            };
        } else {
            return {
                EM: "User not found",
                EC: 1,
                DT: {}
            };
        }
    } catch (error) {
        console.log(error);
        return {
            EM: "Server error",
            EC: -1,
            DT: {}
        };
    }
};

const updateUser = async (username, profile_image, id) => {


    if (!id) {
        return {
            EM: "Missing user ID",
            EC: 1,
        };
    }

    try {
        const [affectedRows] = await db.User.update(
            { username, profile_image },
            {
                where: { id },
            }
        );

        if (affectedRows === 0) {
            return {
                EM: "User not found or no change",
                EC: 1,
            };
        }

        return {
            EM: "Update user successful",
            EC: 0,
        };
    } catch (error) {
        console.log(error);
        return {
            EM: "Server error",
            EC: -1,
        };
    }
};

const changePassword = async (oldPassword, newPassword, id) => {
    try {
        const user = await db.User.findOne({ where: { id } });
        if (!user) {
            return {
                EM: "User not found",
                EC: 1,
            };
        }

        const isMatch = await checkPassword(oldPassword, user.password);

        if (!isMatch) {
            return {
                EM: "Old password is incorrect",
                EC: 1,
            };
        }

        const hashPass = await hashUserPassword(newPassword);

        await db.User.update(
            { password: hashPass },
            { where: { id } }
        );

        return {
            EM: "Change password successful",
            EC: 0,
        };
    } catch (error) {
        console.log(error);
        return {
            EM: "Server error",
            EC: -1,
        };
    }
};

export {
    createNewUser, getUserList, deleteUser, getUserById, updateUser, changePassword
}