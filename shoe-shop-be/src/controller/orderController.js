import dotenv from 'dotenv';
dotenv.config();
import { checkout, getOrdersByUserId, updateOrderStatus, deleteOrderById, getOrderList } from "../service/orderService";
import Stripe from 'stripe';
import db from "../models/index.js";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const handleCheckout = async (req, res) => {

    try {
        const user = req.user;
        const { address, phoneNumber } = req.body;

        if (!user) {
            return res.status(400).json({
                EM: 'User is required',
                EC: 1,
            });
        }

        if (!address || !phoneNumber) {
            return res.status(400).json({
                EM: 'Address and phone number are required',
                EC: 1,
            });
        }

        const data = await checkout(user, address, phoneNumber);

        let statusCode = 201;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({
            EM: "Error from server",
            EC: -1,
        });
    }
};

const handleStripeCheckout = async (req, res) => {

    try {
        const user = req.user;
        const { address, phoneNumber } = req.body;

        if (!user || !address || !phoneNumber) {
            return res.status(400).json({
                EM: 'Missing required fields',
                EC: 1
            });
        }

        const cartItems = await db.CartItem.findAll({
            where: { cart_id: user.cartId },
            include: { model: db.Product }
        });

        if (!cartItems || cartItems.length === 0) {
            return res.status(400).json({
                EM: 'Cart is empty',
                EC: 1
            });
        }

        const line_items = cartItems.map(item => ({
            price_data: {
                currency: 'usd',
                product_data: {
                    name: item.Product.name
                },
                unit_amount: Math.round(item.Product.price * 100), // giá theo cent
            },
            quantity: item.quantity
        }));

        // Tạo checkout session từ Stripe
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            mode: 'payment',
            line_items,
            success_url: 'myapp://checkout-success',
            cancel_url: 'myapp://checkout-cancel',
            metadata: {
                userId: user.id,
                address,
                phoneNumber,
            }
        });

        return res.status(200).json({ url: session.url });

    } catch (err) {
        console.error('Stripe Checkout Error:', err);
        return res.status(500).json({
            EM: 'Stripe checkout failed',
            EC: -1
        });
    }
};

const handleStripeWebhook = async (req, res) => {

    const sig = req.headers['stripe-signature'];

    try {
        const event = stripe.webhooks.constructEvent(
            req.body,
            sig,
            process.env.STRIPE_WEBHOOK_SECRET
        );

        if (event.type === 'checkout.session.completed') {

            const session = event.data.object;

            if (!session.metadata) {
                return res.status(400).send('Missing metadata');
            }

            const { userId, address, phoneNumber } = session.metadata;
            console.log(session.metadata);


            const userWithCart = await db.User.findOne({
                where: { id: parseInt(userId) },
                include: {
                    model: db.Cart
                }
            });

            if (!userWithCart || !userWithCart.Cart) {
                return res.status(404).send('Cart not found');
            }

            const user = {
                id: userWithCart.id,
                cartId: userWithCart.Cart.id
            };

            const data = await checkout(user, address, phoneNumber);

            let statusCode = 201;

            if (data.EC === 1) {
                statusCode = 400;
            } else if (data.EC !== 0) {
                statusCode = 500;
            }

            return res.status(statusCode).json({
                EM: data.EM,
                EC: data.EC
            });
        }
    } catch (err) {
        console.error('Webhook error:', err.message);
        return res.status(500).send(`Webhook Error: ${err.message}`);
    }
};


const handleGetOrdersByUser = async (req, res) => {
    try {
        const user = req.user;

        if (!user) {
            return res.status(400).json({
                EM: 'User is required',
                EC: 1,
            });
        }

        const data = await getOrdersByUserId(user.id);

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({
            EM: "Error from server",
            EC: -1,
        });
    }
};

const handleGetOrderList = async (req, res) => {
    try {
        const { page, status, sort } = req.query;

        const data = await getOrderList({
            page: parseInt(page) || 1,
            status: status || null,
            sort: sort || 'desc'
        });

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });
    } catch (err) {
        console.error('Error in handleGetOrderList:', err);
        return res.status(500).json({
            EM: "Error from server",
            EC: -1
        });
    }
};

const handleUpdateOrderStatus = async (req, res) => {
    try {
        const orderId = req.params.id;
        const { status } = req.body;

        const data = await updateOrderStatus(orderId, status);

        let statusCode = 200;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC
        });

    } catch (err) {
        console.error('Error updating order status:', err);
        return res.status(500).json({
            EM: 'Error from server',
            EC: -1
        });
    }
};

const handleDeleteOrder = async (req, res) => {
    try {
        const orderId = req.params.id;

        const data = await deleteOrderById(orderId);

        let statusCode = 200;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC
        });

    } catch (err) {
        console.error('Error deleting order:', err);
        return res.status(500).json({
            EM: 'Error from server',
            EC: -1
        });
    }
};



export { handleCheckout, handleGetOrdersByUser, handleStripeCheckout, handleStripeWebhook, handleUpdateOrderStatus, handleDeleteOrder, handleGetOrderList };