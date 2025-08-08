'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class User extends Model {
        /**
         * Helper method for defining associations.
         * This method is not a part of Sequelize lifecycle.
         * The `models/index` file will call this method automatically.t
         */
        static associate(models) {
            User.belongsTo(models.Group, { foreignKey: 'group_id' });
            User.hasMany(models.Order, { foreignKey: 'user_id' });
            User.hasOne(models.Cart, { foreignKey: 'user_id' });
            User.hasMany(models.Favorite, { foreignKey: 'user_id' })
            User.hasMany(models.Review, { foreignKey: 'user_id' })
        }
    }
    User.init({
        username: DataTypes.STRING,
        profile_image: DataTypes.STRING,
        password: DataTypes.STRING,
        group_id: DataTypes.INTEGER,
    }, {
        sequelize,
        modelName: 'User',
        tableName: 'user',
        underscored: true,
        timestamps: true
    });
    return User;
};