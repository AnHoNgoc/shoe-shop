'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Favorite extends Model {
    static associate(models) {
      // Favorite thuộc về một user
      Favorite.belongsTo(models.User, { foreignKey: 'user_id' });

      // Favorite thuộc về một product
      Favorite.belongsTo(models.Product, { foreignKey: 'product_id' });
    }
  }
  Favorite.init({
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    product_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    is_favorite: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    },
  }, {
    sequelize,
    modelName: 'Favorite',
    underscored: true,
    timestamps: true
  });
  return Favorite;
};