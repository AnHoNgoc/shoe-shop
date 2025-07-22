import { getCartItems, addToCart, incrementCartItem, decrementCartItem, removeFromCart, clearCart } from "../service/cartService";

const handleGetCartItem = async (req, res) => {

    const cartId = Number(req.user.cartId);

    if (!Number.isInteger(cartId)) {
        return res.status(400).json({
            EM: "Invalid or missing cartId",
            EC: 1,
            DT: []
        });
    }

    try {
        const data = await getCartItems(cartId);

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });

    } catch (error) {
        return res.status(500).json({
            EM: "Error from controller",
            EC: -1,
        });
    }
};

const handleAddToCart = async (req, res) => {

    const cartId = Number(req.user.cartId);
    const { productId } = req.body;

    if (!Number.isInteger(cartId)) {
        return res.status(400).json({
            EM: "Invalid or missing cartId",
            EC: 1
        });
    }

    if (!productId || isNaN(Number(productId))) {
        return res.status(400).json({
            EM: "Missing or invalid productId",
            EC: 1
        });
    }

    try {
        const data = await addToCart(cartId, productId);

        let statusCode = 201;

        if (data.EC === 1) {
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
        return res.status(500).json({
            EM: "Error from controller",
            EC: -1,
        });
    }
};

const handleIncrementCartItem = async (req, res) => {

    const cartId = Number(req.user.cartId);
    const { productId } = req.body;

    if (!Number.isInteger(cartId)) {
        return res.status(400).json({
            EM: "Invalid or missing cartId",
            EC: 1
        });
    }

    if (!productId || isNaN(Number(productId))) {
        return res.status(400).json({
            EM: "Missing or invalid productId",
            EC: 1
        });
    }


    try {
        const data = await incrementCartItem(cartId, productId);

        if (data.EC === 0) {
            return res.status(200).json({
                EM: data.EM,
                EC: data.EC,
            });
        }


        return res.status(400).json({
            EM: data.EM || "Something went wrong",
            EC: data.EC || 1,
        });

    } catch (error) {
        return res.status(500).json({
            EM: "Error from controller",
            EC: -1,
        });
    }
};

const handleDecrementCartItem = async (req, res) => {

    const cartId = Number(req.user.cartId);
    const { productId } = req.body;

    if (!Number.isInteger(cartId)) {
        return res.status(400).json({
            EM: "Invalid or missing cartId",
            EC: 1
        });
    }

    if (!productId || isNaN(Number(productId))) {
        return res.status(400).json({
            EM: "Missing or invalid productId",
            EC: 1
        });
    }


    try {
        const data = await decrementCartItem(cartId, productId);

        if (data.EC === 0) {
            return res.status(200).json({
                EM: data.EM,
                EC: data.EC,
            });
        }


        return res.status(400).json({
            EM: data.EM || "Something went wrong",
            EC: data.EC || 1,
        });

    } catch (error) {
        return res.status(500).json({
            EM: "Error from controller",
            EC: -1,
        });
    }
};

const handleRemoveFromCart = async (req, res) => {

    const cartId = Number(req.user.cartId);
    const { productId } = req.body;

    if (!Number.isInteger(cartId)) {
        return res.status(400).json({
            EM: "Invalid or missing cartId",
            EC: 1
        });
    }

    if (!productId || isNaN(Number(productId))) {
        return res.status(400).json({
            EM: "Missing or invalid productId",
            EC: 1
        });
    }

    try {
        const data = await removeFromCart(cartId, productId);


        let statusCode = 200;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
        });

    } catch (error) {
        return res.status(500).json({
            EM: "Error from controller",
            EC: -1,
        });
    }
};

const handleClearCart = async () => {

    const cartId = Number(req.user.cartId);

    if (!Number.isInteger(cartId)) {
        return res.status(400).json({
            EM: "Invalid or missing cartId",
            EC: 1
        });
    }

    try {
        const data = await clearCart(cartId);

        let statusCode = 200;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
        });


    } catch (error) {
        return res.status(500).json({
            EM: "Error from controller",
            EC: -1,
        });
    }

}

export {
    handleGetCartItem, handleAddToCart, handleIncrementCartItem, handleDecrementCartItem, handleRemoveFromCart, handleClearCart
}