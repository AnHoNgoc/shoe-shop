import db from "../models/index";

const getCategoryList = async () => {

    try {
        const data = await db.Category.findAll({
            attributes: ['id', 'name', 'image']
        });

        return {
            EM: data.length > 0 ? "Fetched category list successfully" : "No category found",
            EC: 0,
            DT: data
        };

    } catch (error) {
        console.error("Error getting category list:", error.message || error);
        return {
            EM: "Error from server",
            EC: -1,
            DT: []
        };
    }
};

export {
    getCategoryList
}
