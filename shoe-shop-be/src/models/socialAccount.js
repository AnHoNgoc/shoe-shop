'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
    class SocialAccount extends Model {
        static associate(models) {
            // Mỗi SocialAccount thuộc về 1 User
            SocialAccount.belongsTo(models.User, { foreignKey: 'user_id' });
        }
    }

    SocialAccount.init({
        user_id: {
            type: DataTypes.INTEGER,
            allowNull: false
        },
        provider: {
            type: DataTypes.STRING(50),
            allowNull: false
        },
        provider_user_id: {
            type: DataTypes.STRING(255),
            allowNull: false
        },
        email: {
            type: DataTypes.STRING(255),
            allowNull: true
        }
    }, {
        sequelize,
        modelName: 'SocialAccount',
        tableName: 'social_accounts',
        underscored: true,
        timestamps: true
    });

    return SocialAccount;
};