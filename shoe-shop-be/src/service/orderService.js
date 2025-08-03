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

const getOrderList = async ({ page, status, sort }) => {
    try {
        const limit = 5;
        const offset = (page - 1) * limit;

        const whereClause = {};
        if (status) {
            whereClause.status = status;
        }

        const orderClause = [['created_at', sort.toLowerCase() === 'asc' ? 'ASC' : 'DESC']];

        const { count, rows: orders } = await db.Order.findAndCountAll({
            where: whereClause,
            limit,
            offset,
            order: orderClause,
            distinct: true,
            include: [
                {
                    model: db.Product,
                    attributes: ['name', 'price'],
                    through: { attributes: ['quantity'] }
                },
                {
                    model: db.User,
                    attributes: ['username']
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
            user: {
                username: order.User?.username || null
            },
            products: order.Products.map(product => ({
                name: product.name,
                price: product.price,
                quantity: product.OrderDetail.quantity
            }))
        }));

        return {
            EM: 'Fetched order list successfully',
            EC: 0,
            DT: {
                totalItems: count,
                totalPages: Math.ceil(count / limit),
                currentPage: page,
                orders: formattedOrders
            }
        };
    } catch (error) {
        console.error('Error in getOrderList:', error);
        return {
            EM: 'Error fetching order list',
            EC: -1,
            DT: null
        };
    }
};


const updateOrderStatus = async (orderId, status) => {
    const t = await db.sequelize.transaction();
    try {
        const allowedStatuses = ['pending', 'confirmed', 'shipping', 'completed', 'cancelled'];

        if (!allowedStatuses.includes(status)) {
            return {
                EM: 'Invalid status value',
                EC: 1
            };
        }

        const order = await db.Order.findByPk(orderId, {
            include: [{ model: db.OrderDetail }],
            transaction: t
        });

        if (!order) {
            await t.rollback();
            return {
                EM: 'Order not found',
                EC: 1
            };
        }

        // Cộng lại tồn kho nếu huỷ đơn hàng
        if (status === 'cancelled' && order.status !== 'cancelled') {
            for (const item of order.OrderDetails) {
                await db.Product.increment(
                    { quantity: item.quantity },
                    { where: { id: item.product_id }, transaction: t }
                );
            }
        }

        order.status = status;
        await order.save({ transaction: t });
        await t.commit();

        return {
            EM: 'Order status updated successfully',
            EC: 0,
        };
    } catch (error) {
        await t.rollback();
        console.error('Error in updateOrderStatus:', error);
        return {
            EM: 'Error updating order',
            EC: -1,
        };
    }
};

const deleteOrderById = async (orderId) => {
    try {
        const order = await db.Order.findByPk(orderId);

        if (!order) {
            return {
                EM: 'Order not found',
                EC: 1
            };
        }

        await order.destroy();

        return {
            EM: 'Order deleted successfully',
            EC: 0
        };
    } catch (error) {
        console.error('Error in deleteOrderById:', error);
        return {
            EM: 'Error deleting order',
            EC: -1
        };
    }
};


export {
    checkout, getOrdersByUserId, updateOrderStatus, deleteOrderById, getOrderList
};
