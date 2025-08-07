'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Cart extends Model {
        /**
         * Helper method for defining associations.
         * This method is not a part of Sequelize lifecycle.
         * The `models/index` file will call this method automatically.
         */
        static associate(models) {
            // Một giỏ hàng thuộc về một người dùng
            Cart.belongsTo(models.User, { foreignKey: 'user_id' });
            // Một giỏ hàng có thể chứa nhiều sản phẩm thông qua bảng trung gian 'Cart_Product'
            Cart.belongsToMany(models.Product, { through: 'cart_item', foreignKey: 'cart_id' });
        }
    }
    Cart.init({
        total_amount: DataTypes.DECIMAL,
        user_id: DataTypes.INTEGER,
    }, {
        sequelize,
        modelName: 'Cart',
        tableName: 'cart',
        underscored: true,
        timestamps: true
    });
    return Cart;
};