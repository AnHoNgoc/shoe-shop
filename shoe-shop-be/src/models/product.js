'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class Product extends Model {
        /**
         * Helper method for defining associations.
         * This method is not a part of Sequelize lifecycle.
         * The `models/index` file will call this method automatically.
         */
        static associate(models) {
            Product.belongsTo(models.Category, { foreignKey: 'category_id' });
            Product.hasMany(models.Favorite, { foreignKey: 'product_id' });
            Product.hasMany(models.Review, { foreignKey: 'product_id' });
            Product.belongsToMany(models.Order, { through: models.OrderDetail, foreignKey: 'product_id' });
        }
    }
    Product.init({
        name: DataTypes.STRING,
        price: DataTypes.DECIMAL,
        quantity: DataTypes.INTEGER,
        image: DataTypes.STRING,
        category_id: DataTypes.INTEGER,
    }, {
        sequelize,
        modelName: 'Product',
        tableName: 'product',
        underscored: true,
        timestamps: true
    });
    return Product;
};