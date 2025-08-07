import { Sequelize } from "sequelize";
import dotenv from "dotenv";

dotenv.config();

console.log("🔥 DB_HOST:", process.env.DB_HOST);
console.log("🔥 DB_PORT:", process.env.DB_PORT);

const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        dialect: 'mysql',
        logging: false,
    }
);

const connection = async () => {
    try {
        await sequelize.authenticate();
        console.log('✅ Connected to Railway MySQL successfully.');
    } catch (error) {
        console.error('❌ Connection error:', error);
    }
};

export default connection;