import { createReview, getReviewList } from "../service/reviewService.js";

const handleCreateReview = async (req, res) => {
    try {
        const userId = Number(req.user.id);
        const { rating, productId, comment } = req.body;

        if (!Number.isInteger(userId) || userId < 1 ||
            !Number.isInteger(productId) || productId < 1) {
            return res.status(400).json({
                EM: "Missing or invalid user/product ID",
                EC: 1,
            });
        }

        if (!Number.isInteger(rating) || rating < 1 || rating > 5) {
            return res.status(400).json({
                EM: "Invalid rating (must be an integer between 1 and 5)",
                EC: 1,
            });
        }
        const data = await createReview(userId, productId, rating, comment);


        let statusCode = 201;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC === 2) {
            statusCode = 409;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

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

const handleGetReviewList = async (req, res) => {
    try {

        const productId = Number(req.query.productId);

        if (!Number.isInteger(productId) || productId < 1) {
            return res.status(400).json({
                EM: "Invalid or missing productId",
                EC: 1,
                DT: [],
            });
        }

        const data = await getReviewList(productId);

        let statusCode = 200;

        if (data.EC === 1) {
            statusCode = 404;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

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

export { handleCreateReview, handleGetReviewList };