'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Order extends Model {
        /**
         * Helper method for defining associations.
         * This method is not a part of Sequelize lifecycle.
         * The `models/index` file will call this method automatically.
         */
        static associate(models) {
            Order.belongsTo(models.User, { foreignKey: 'user_id' })
            Order.belongsToMany(models.Product, { through: models.OrderDetail, foreignKey: 'order_id' });
            Order.hasMany(models.OrderDetail, { foreignKey: 'order_id' });
        }
    }
    Order.init({
        total_amount: DataTypes.DECIMAL,
        user_id: DataTypes.INTEGER,
        phone_number: {
            type: DataTypes.STRING,
            allowNull: false
        },
        address: {
            type: DataTypes.STRING,
            allowNull: false
        },
        status: {
            type: DataTypes.ENUM(
                'pending',     // Đơn mới được tạo
                'confirmed',   // Nhân viên đã xác nhận đơn
                'shipping',    // Đơn đang giao
                'completed',   // Giao hàng xong
                'cancelled'    // Đơn bị hủy
            ),
            allowNull: false,
        }
    }, {
        sequelize,
        modelName: 'Order',
        tableName: 'order',
        underscored: true,
        timestamps: true
    });
    return Order;
};