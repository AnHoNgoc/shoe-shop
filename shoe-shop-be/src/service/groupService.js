import db from "../models/index.js";

const getGroupList = async () => {
    try {
        const data = await db.Group.findAll({
            order: [["name", "ASC"]],
        });

        return {
            EM: "Fetched group list successfully",
            EC: 0,
            DT: data
        };
    } catch (error) {
        console.error(error);
        return {
            EM: "Error from server",
            EC: -1,
        };
    }
};

export {
    getGroupList
}