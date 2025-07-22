import db from "../models/index";

const getRoleList = async () => {
    try {
        let data = await db.Role.findAll({
            attributes: ["id", "url", "description"],
        });

        return {
            EM: "Fetched  list role successful",
            EC: 0,
            DT: data
        };
    } catch (error) {
        console.log(error);
        return {
            EM: "Server error",
            EC: -1,
            DT: []
        };
    }
};

const createNewRole = async (roles) => {
    try {
        let currentRole = await db.Role.findAll({
            attributes: ["url", "description"],
        });

        const persists = roles.filter(({ url: url1 }) =>
            !currentRole.some(({ url: url2 }) => url1 === url2)
        );

        if (persists.length === 0) {
            return {
                EM: "Nothing to create...",
                EC: 0,
                DT: []
            };
        }

        await db.Role.bulkCreate(persists);
        return {
            EM: `Create roles succeeds: ${persists.length}`,
            EC: 0,
            DT: []
        };
    } catch (error) {
        console.log(error);
        return {
            EM: "Server error",
            EC: -1,
            DT: []
        };
    }
};

const deleteRole = async (id) => {
    try {
        const role = await db.Role.findOne({ where: { id } });

        if (
            role &&
            (role.url === "/role/create" ||
                role.url === "/role/delete" ||
                role.url === "/role/list")
        ) {
            return {
                EM: "Cannot delete role with this name",
                EC: 1,
                DT: ""
            };
        }

        await db.Role.destroy({
            where: { id }
        });

        return {
            EM: "Delete role successful",
            EC: 0,
            DT: ""
        };
    } catch (error) {
        console.error(`Error deleting role with id ${id}:`, error);
        return {
            EM: "Server error",
            EC: -1,
            DT: ""
        };
    }
};

const fetchRoleByGroup = async (groupId) => {
    try {
        let roles = await db.Group.findOne({
            where: { id: groupId },
            attributes: ["id", "name"],
            include: {
                model: db.Role,
                attributes: ["id", "url"],
                through: { attributes: [] }
            }
        });

        return {
            EM: "Fetched group with role successful",
            EC: 0,
            DT: roles || []
        };
    } catch (error) {
        console.log(error);
        return {
            EM: "Server error",
            EC: -1,
            DT: []
        };
    }
};

const assignRoleToGroup = async (data) => {
    try {
        // Xác minh input
        if (!data.groupId || !Array.isArray(data.groupRoles) || data.groupRoles.length === 0) {
            return {
                EM: "Invalid input data",
                EC: 1,
                DT: null
            };
        }

        // Xóa role cũ của group
        await db.GroupRole.destroy({
            where: { groupId: +data.groupId }
        });

        // Gán role mới
        const created = await db.GroupRole.bulkCreate(data.groupRoles);
        if (!created || created.length === 0) {
            return {
                EM: "Failed to assign roles",
                EC: 1,
                DT: null
            };
        }

        return {
            EM: "Assign Role to Group successful",
            EC: 0,
            DT: data
        };
    } catch (error) {
        console.log(error);
        return {
            EM: "Server error",
            EC: -1,
            DT: null
        };
    }
};

export { getRoleList, createNewRole, deleteRole, fetchRoleByGroup, assignRoleToGroup };