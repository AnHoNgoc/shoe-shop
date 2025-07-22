'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable('Order', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
            },
            total_amount: {
                type: Sequelize.DECIMAL(10, 2)
            },
            status: {
                type: Sequelize.ENUM(
                    'pending',         // Đơn mới được tạo
                    'confirmed',       // Nhân viên đã xác nhận đơn
                    'shipping',        // Đơn đang giao
                    'completed',       // Giao hàng xong
                    'cancelled'        // Đơn bị hủy
                ),
                allowNull: false,
            },
            phone_number: {
                type: Sequelize.STRING,
                allowNull: false
            },
            address: {
                type: Sequelize.STRING,
                allowNull: false
            },
            user_id: {
                type: Sequelize.INTEGER,
                references: {
                    model: 'User',
                    key: 'id'
                },
                onDelete: "CASCADE"
            },
            created_at: {
                allowNull: false,
                type: Sequelize.DATE,
                defaultValue: Sequelize.fn("NOW"),
            },
            updated_at: {
                allowNull: false,
                type: Sequelize.DATE,
                defaultValue: Sequelize.fn("NOW"),
            }
        });
    },
    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable('Order');
    }
};