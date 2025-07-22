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
      Group.belongsToMany(models.Role, { through: "Group_Role", foreignKey: 'group_id' });
    }
  }
  Group.init({
    name: DataTypes.STRING,
    description: DataTypes.STRING,
  }, {
    sequelize,
    modelName: 'Group',
    underscored: true,
    timestamps: true
  });
  return Group;
};