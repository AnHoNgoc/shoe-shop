import db from "../models/index.js";

const checkout = async (user, address, phoneNumber) => {

    const userId = user.id;
    const cartId = user.cartId;
    console.log('🛒 Deleting cart for cartId:', cartId);

    const t = await db.sequelize.transaction();

    try {
        // Lấy sản phẩm trong giỏ hàng và khóa chúng
        const cartItems = await db.CartItem.findAll({
            where: { cart_id: cartId },
            include: {
                model: db.Product
            },
            transaction: t,
            lock: t.LOCK.UPDATE
        });

        if (cartItems.length === 0) {
            return {
                EM: "Cart is empty",
                EC: 1,
            }
        }

        // Kiểm tra tồn kho
        for (const item of cartItems) {
            if (item.quantity > item.Product.quantity) {
                return {
                    EM: `"${item.Product.name}"out of stock`,
                    EC: 1,
                }
            }
        }

        // Tính tổng tiền
        const total = cartItems.reduce((sum, item) => {
            return sum + item.Product.price * item.quantity;
        }, 0);


        // Tạo đơn hàng
        const order = await db.Order.create({
            user_id: userId,
            total_amount: total,
            status: 'pending',
            address: address,
            phone_number: phoneNumber
        }, { transaction: t });

        // Tạo chi tiết đơn hàng
        const orderDetails = cartItems.map(item => ({
            order_id: order.id,
            product_id: item.product_id,
            quantity: item.quantity,
            price: item.Product.price,
            subtotal: item.Product.price * item.quantity
        }));

        await db.OrderDetail.bulkCreate(orderDetails, { transaction: t });

        // Trừ tồn kho sản phẩm
        for (const item of cartItems) {
            await db.Product.decrement(
                { quantity: item.quantity },
                { where: { id: item.product_id }, transaction: t }
            );
        }

        // Xóa giỏ hàng
        await db.CartItem.destroy({ where: { cart_id: cartId }, transaction: t });

        await t.commit();

        return {
            EM: 'Order created successfully!',
            EC: 0
        };

    } catch (err) {
        console.error('🔥 Transaction failed:', err);
        await t.rollback();
        return {
            EM: 'Error from server',
            EC: -1
        };
    }
};

const checkoutFromStripe = async (userId, address, phoneNumber, cartItems) => {
    const t = await db.sequelize.transaction();
    try {
        if (!cartItems || cartItems.length === 0) {
            return { EM: 'Cart is empty', EC: 1 };
        }

        // Kiểm tra tồn kho
        for (const item of cartItems) {
            const product = await db.Product.findByPk(item.product_id, { transaction: t, lock: t.LOCK.UPDATE });
            if (!product || item.quantity > product.quantity) {
                await t.rollback();
                return { EM: `"${product?.name || 'Product'}" out of stock`, EC: 1 };
            }
        }

        // Tính tổng tiền
        const total = cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0);

        // Tạo đơn hàng
        const order = await db.Order.create({
            user_id: userId,
            total_amount: total,
            status: 'paid', // Stripe đã thanh toán
            address,
            phone_number: phoneNumber
        }, { transaction: t });

        // Tạo chi tiết đơn hàng
        const orderDetails = cartItems.map(item => ({
            order_id: order.id,
            product_id: item.product_id,
            quantity: item.quantity,
            price: item.price,
            subtotal: item.price * item.quantity
        }));

        await db.OrderDetail.bulkCreate(orderDetails, { transaction: t });

        // Trừ tồn kho
        for (const item of cartItems) {
            await db.Product.decrement(
                { quantity: item.quantity },
                { where: { id: item.product_id }, transaction: t }
            );
        }

        await t.commit();
        return { EM: 'Order created successfully', EC: 0 };
    } catch (err) {
        console.error('Stripe Checkout Service Error:', err);
        await t.rollback();
        return { EM: 'Server error', EC: -1 };
    }
};

const getOrdersByUserId = async (userId) => {
    try {
        const orders = await db.Order.findAll({
            where: { user_id: userId },
            order: [['created_at', 'DESC']],
            include: [
                {
                    model: db.Product,
                    attributes: ['name', 'price'],
                    through: {
                        attributes: ['quantity'] // ✅ lấy từ bảng Order_Detail
                    }
                }
            ]
        });

        const formattedOrders = orders.map(order => ({
            id: order.id,
            status: order.status,
            address: order.address,
            phone_number: order.phone_number,
            total_amount: order.total_amount,
            created_at: order.createdAt,
            products: order.Products.map(product => ({
                name: product.name,
                price: product.price,
                quantity: product.OrderDetail.quantity // ✅ quantity nằm ở đây
            }))
        }));

        return {
            EM: 'Fetched order list successfully',
            EC: 0,
            DT: formattedOrders
        };
    } catch (err) {
        console.error('Error in getOrdersByUserId:', err);
        return {
            EM: 'Error fetching orders',
            EC: -1,
            DT: []
        };
    }
};


export {
    checkout, getOrdersByUserId, checkoutFromStripe
};
