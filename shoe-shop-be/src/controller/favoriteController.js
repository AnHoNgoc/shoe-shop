import { toggleFavorite, getFavoritesByUser } from "../service/favoriteService";

const handleToggleFavorite = async (req, res) => {

    try {
        const productId = Number(req.body.productId);
        const userId = Number(req.user.id);

        if (!userId || !productId || !Number.isInteger(productId) || !Number.isInteger(userId)) {
            return res.status(400).json({
                EM: "Invalid or missing required parameters",
                EC: 1,
                DT: null
            });
        }
        const data = await toggleFavorite(userId, productId);

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });

    } catch (error) {

        return res.status(500).json({
            EM: "Server error",
            EC: -1,
        });
    }
};

const handleGetFavoritesByUser = async (req, res) => {
    try {
        const userId = Number(req.user.id);

        if (!Number.isInteger(userId)) {
            return res.status(400).json({
                EM: "Invalid or missing user ID",
                EC: 1,
            });
        }

        const data = await getFavoritesByUser(userId);

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({
            EM: "Error from server",
            EC: -1,
        });
    }
};

export { handleToggleFavorite, handleGetFavoritesByUser };