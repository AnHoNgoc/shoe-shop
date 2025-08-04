import db from "../models/index.js";

const createReview = async (userId, productId, rating, comment) => {
    try {

        const product = await db.Product.findByPk(productId);

        if (!product) {
            return {
                EM: "Product does not exist",
                EC: 1,
                DT: {}
            };
        }

        const existing = await db.Review.findOne({
            where: {
                user_id: userId,
                product_id: productId
            }
        });

        if (existing) {
            return {
                EM: "You have already submitted a review",
                EC: 2,
                DT: {}
            };
        }

        const review = await db.Review.create({
            user_id: userId,
            product_id: productId,
            rating: rating,
            comment: comment
        });

        return {
            EM: "Created review successfully",
            EC: 0,
            DT: review
        };
    } catch (error) {
        console.error("Error:", error);
        return {
            EM: "Server error",
            EC: -1,
            DT: {}
        };
    }
};

const getReviewList = async (productId) => {
    try {

        const product = await db.Product.findByPk(productId);

        if (!product) {
            return {
                EM: "Product not found",
                EC: 1,
                DT: [],
            };
        }

        const reviews = await db.Review.findAll({
            where: {
                product_id: productId
            },
            attributes: ['rating', 'comment', 'created_at'],
            include: [
                {
                    model: db.User,
                    attributes: ['username', 'profile_image']
                }
            ],
            order: [['created_at', 'DESC']]
        });

        return {
            EM: reviews.length > 0 ? "Fetched list reviews successfully" : "No reviews found",
            EC: 0,
            DT: reviews
        };

    } catch (error) {
        console.error("Error:", error);
        return {
            EM: "Server error",
            EC: -1,
            DT: [],
        };
    }
};

export { createReview, getReviewList }