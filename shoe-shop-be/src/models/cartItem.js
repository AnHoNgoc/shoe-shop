'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class CartItem extends Model {
        /**
         * Helper method for defining associations.
         * This method is not a part of Sequelize lifecycle.
         * The `models/index` file will call this method automatically.
         */
        static associate(models) {
            // CartItem thuộc về một Cart
            CartItem.belongsTo(models.Cart, { foreignKey: 'cart_id' });
            // CartItem thuộc về một Product
            CartItem.belongsTo(models.Product, { foreignKey: 'product_id' });
        }
    }
    CartItem.init({
        cart_id: DataTypes.INTEGER,
        product_id: DataTypes.INTEGER,
        quantity: {
            type: DataTypes.INTEGER,
            defaultValue: 1
        },
    }, {
        sequelize,
        modelName: 'CartItem',
        tableName: 'Cart_Item',
        underscored: true,
        timestamps: true
    });
    return CartItem;
};