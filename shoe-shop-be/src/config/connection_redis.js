import { createClient } from 'redis';
import dotenv from 'dotenv';

dotenv.config();

const client = createClient({
    url: process.env.REDIS_URL,
    socket: {
        tls: true
    }
});

client.on('connect', () => {
    console.log('✅ Redis connected successfully');
});

client.on('error', (err) => {
    console.error('❌ Redis connection error:', err);
});

const connectRedis = async () => {
    try {
        await client.connect();
    } catch (error) {
        console.error('❌ Redis connect failed:', error);
    }
};

connectRedis();

export default client;