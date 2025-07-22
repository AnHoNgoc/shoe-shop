'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Review extends Model {
    static associate(models) {
      // Mỗi review thuộc về một user
      Review.belongsTo(models.User, { foreignKey: 'user_id' });

      // Mỗi review thuộc về một sản phẩm
      Review.belongsTo(models.Product, { foreignKey: 'product_id' });
    }
  }
  Review.init({
    rating: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        min: 1,
        max: 5
      }
    },
    comment: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    product_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Review',
    underscored: true,
    timestamps: true
  });
  return Review;
};