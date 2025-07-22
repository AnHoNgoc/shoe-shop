import db from "../models/index";

const toggleFavorite = async (userId, productId) => {
    try {

        const existing = await db.Favorite.findOne({
            where: { user_id: userId, product_id: productId }
        });

        if (existing) {

            const newFavoriteStatus = !existing.is_favorite;

            await db.Favorite.update(
                { is_favorite: newFavoriteStatus },
                { where: { user_id: userId, product_id: productId } }
            );

            return {
                EM: newFavoriteStatus ? "Added to favorites" : "Removed from favorites",
                EC: 0,
                DT: newFavoriteStatus
            };
        } else {

            const favorite = await db.Favorite.create({ user_id: userId, product_id: productId, is_favorite: true });

            return {
                EM: "Added to favorites successfully",
                EC: 0,
                DT: favorite
            };
        }
    } catch (error) {
        console.error("Error in toggleFavorite:", error);
        return {
            EM: "Server error",
            EC: -1,
            DT: {}
        };
    }
};

const getFavoritesByUser = async (userId) => {
    try {
        const favorites = await db.Favorite.findAll({
            where: { user_id: userId },
            include: {
                model: db.Product,
                attributes: ['id', 'name', 'price', 'image', 'quantity', 'category_id']
            }
        });

        return {
            EM: "Fetched favorite products successfully",
            EC: 0,
            DT: favorites
        };

    } catch (error) {
        console.error("Error in getFavoritesByUser:", error);
        return {
            EM: "Server error",
            EC: -1,
            DT: []
        };
    }
};

export { toggleFavorite, getFavoritesByUser }