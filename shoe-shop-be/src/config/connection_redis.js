import { createClient } from 'redis';  // Import redis

const client = createClient({
    url: 'redis://127.0.0.1:6379'
});

client.on('connect', () => {
    console.log('Redis client connected');
});

client.on('error', (err) => {
    console.log('Redis Client Error', err);
});

async function connectRedis() {
    await client.connect();
    client.ping()
        .then((pong) => {
            console.log(pong); // Should log 'PONG'
        })
        .catch((err) => {
            console.log('Ping error:', err);
        });
}

connectRedis();

export default client; 