'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class OrderDetail extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      OrderDetail.belongsTo(models.Order, { foreignKey: 'order_id' });
      OrderDetail.belongsTo(models.Product, { foreignKey: 'product_id' });
    }
  }
  OrderDetail.init({

    quantity: DataTypes.INTEGER,
    price: DataTypes.DECIMAL,
    subtotal: DataTypes.DECIMAL,

    order_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'Order',
        key: 'id'
      }
    },
    product_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'Product',
        key: 'id'
      }
    }
  }, {
    sequelize,
    modelName: 'OrderDetail',
    tableName: 'order_detail',
    underscored: true,
    timestamps: true
  });
  return OrderDetail;
};