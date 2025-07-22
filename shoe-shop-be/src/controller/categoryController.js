import { getCategoryList } from "../service/categoryService";

const handleGetCategoryList = async (req, res) => {
    try {
        const data = await getCategoryList();

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({
            EM: "error from controller",
            EC: -1,
        });
    }
};

export {
    handleGetCategoryList
}