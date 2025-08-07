'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Group extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Group.hasMany(models.User, { foreignKey: 'group_id' });
      Group.belongsToMany(models.Role, { through: "group_role", foreignKey: 'group_id' });
    }
  }
  Group.init({
    name: DataTypes.STRING,
    description: DataTypes.STRING,
  }, {
    sequelize,
    modelName: 'Group',
    tableName: 'group',
    underscored: true,
    timestamps: true
  });
  return Group;
};