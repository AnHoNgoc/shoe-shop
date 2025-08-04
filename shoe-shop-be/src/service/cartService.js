import db from "../models/index.js";


const getCartItems = async (cartId) => {

    try {
        const items = await db.CartItem.findAll({
            where: { cart_id: cartId },
            include: {
                model: db.Product,
                attributes: ['id', 'name', 'price', 'image'],
                include: {
                    model: db.Category,
                    attributes: ['name']
                }
            },
            order: [['created_at', 'DESC']]
        });

        const cartItems = items.map(item => ({
            productId: item.product_id,
            quantity: item.quantity,
            price: parseFloat(item.Product.price),
            name: item.Product.name,
            image: item.Product.image,
            categoryName: item.Product.Category && item.Product.Category.name || null
        }));

        const totalAmount = cartItems.reduce(
            (sum, item) => sum + item.price * item.quantity,
            0
        );

        await db.Cart.update(
            { total_amount: totalAmount },
            { where: { id: cartId } }
        );

        if (items.length === 0) {
            return {
                EM: "Cart is empty",
                EC: 0,
                DT: {
                    items: [],
                    totalAmount: 0
                }
            };
        }

        return {
            EM: "Fetched cart items successfully",
            EC: 0,
            DT: {
                items: cartItems,
                totalAmount: totalAmount
            }
        };

    } catch (error) {
        console.error("Error in getCartItems:", error);
        return {
            EM: "Server error",
            EC: -1,
            DT: []
        };
    }
};


const addToCart = async (cartId, productId) => {
    try {

        const existingItem = await db.CartItem.findOne({
            where: { cart_id: cartId, product_id: productId }
        });

        if (existingItem) {
            return {
                EM: "Product already in cart",
                EC: 1,
                DT: {}
            };
        }

        const newItem = await db.CartItem.create({
            cart_id: cartId,
            product_id: productId,
            quantity: 1,
        });

        return {
            EM: "Added to cart successfully",
            EC: 0,
            DT: newItem
        };
    } catch (error) {
        console.error("Error in addToCart:", error);
        return {
            EM: "Server error",
            EC: -1,
            DT: {}
        };
    }
};

const removeFromCart = async (cartId, productId) => {
    try {

        const result = await db.CartItem.destroy({
            where: { cart_id: cartId, product_id: productId }
        });

        return {
            EM: result ? "Item removed" : "Item not found",
            EC: result ? 0 : 1,
        };
    } catch (error) {
        console.error("Error in removeFromCart:", error);
        return {
            EM: "Server error",
            EC: -1,
        };
    }
};

const clearCart = async (cartId) => {
    try {
        const result = await db.CartItem.destroy({
            where: { cart_id: cartId },
        });

        return {
            EM: result > 0 ? "Cart cleared" : "Cart was already empty",
            EC: result ? 0 : 1,
        };
    } catch (error) {
        console.error("Error in clearCart:", error);
        return {
            EM: "Server error",
            EC: -1,
        };
    }
};

const incrementCartItem = async (cartId, productId) => {
    try {

        const item = await db.CartItem.findOne({ where: { cart_id: cartId, product_id: productId } });
        if (!item) return {
            EM: "Cart item not found",
            EC: 1,
        };

        const product = await db.Product.findOne({ where: { id: productId } });

        if (!product) {
            return {
                EM: "Product not found",
                EC: 1,
            };
        }

        if (item.quantity + 1 > product.quantity) {
            return {
                EM: `Only ${product.quantity} items available`,
                EC: 1,
            };
        }

        item.quantity += 1;
        await item.save();

        return {
            EM: "Item quantity increased",
            EC: 0,
        };
    } catch (error) {
        console.error("Error in incrementCartItem:", error);
        return {
            EM: "Server error",
            EC: -1,
        };
    }
};

const decrementCartItem = async (cartId, productId) => {

    try {
        const item = await db.CartItem.findOne({ where: { cart_id: cartId, product_id: productId } });
        if (!item) return {
            EM: "Cart item not found",
            EC: 1,
        };

        if (item.quantity <= 1) {
            return {
                EM: "Quantity cannot be less than 1",
                EC: 1,
            };
        }

        item.quantity -= 1;
        await item.save();

        return {
            EM: "Item quantity decreased",
            EC: 0,
        };
    } catch (error) {
        console.error("Error in decrementCartItem:", error);
        return {
            EM: "Server error",
            EC: -1,
        };
    }
};



export { getCartItems, addToCart, removeFromCart, clearCart, incrementCartItem, decrementCartItem }