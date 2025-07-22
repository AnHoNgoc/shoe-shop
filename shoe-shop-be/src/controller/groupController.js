import { getGroupList } from "../service/groupService";

const handleGetGroupList = async (req, res) => {
    try {

        const data = await getGroupList();

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
        })
    }
}

export {
    handleGetGroupList
}
