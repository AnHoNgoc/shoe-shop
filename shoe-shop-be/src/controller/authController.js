import { registerNewUser, loginUser, googleLoginService } from "../service/authService.js";
import { verifyRefreshToken } from "../middleware/JWTAction.js";
import jwt from 'jsonwebtoken';
import redisClient from "../config/connection_redis.js";


const testAPI = (req, res) => {
    return res.status(200).json({
        message: "ok",
        data: "test API"
    })
}

const handleRegister = async (req, res) => {
    try {
        const data = await registerNewUser(req.body);


        let statusCode = 201;

        if (data.EC === 1) {
            statusCode = 409;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
        });

    } catch (e) {
        console.error("Register error:", e);
        return res.status(500).json({
            EM: "Error from server",
            EC: -1,
        });
    }
};

const handleLogin = async (req, res) => {
    try {
        const data = await loginUser(req.body);

        if (data.EC === 0) {
            return res.status(200).json({
                EM: data.EM,
                EC: 0,
                DT: { ...data.DT }
            });
        }

        if (data.EC === -1) {
            return res.status(500).json({
                EM: data.EM || "Server error",
                EC: -1,
            });
        }

        return res.status(401).json({
            EM: data.EM || "Invalid credentials",
            EC: 1,
            DT: {}
        });

    } catch (e) {
        console.error("Unexpected controller error:", e);
        return res.status(500).json({
            EM: "Unexpected server error",
            EC: -1,
        });
    }
};

const handleLogout = async (req, res) => {

    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(400).json({
                EM: "Missing refresh token",
                EC: 1,
            });
        }

        const decoded = await verifyRefreshToken(refreshToken);

        if (!decoded || !decoded.id) {
            return res.status(401).json({
                EM: "Invalid token",
                EC: 1,
            });
        }

        const userId = decoded.id;

        await redisClient.del(`refreshToken:${userId}`);

        return res.status(200).json({
            EM: "User logged out successfully",
            EC: 0,
        });

    } catch (e) {
        console.error("Logout error:", e);
        return res.status(500).json({
            EM: "Server error",
            EC: -1,
        });
    }
};


const createNewToken = async (req, res) => {

    const { refreshToken } = req.body;

    if (!refreshToken) {
        return res.status(400).json({
            EM: 'Refresh token is required',
            EC: 1,
        });
    }

    try {
        const decoded = await verifyRefreshToken(refreshToken);

        if (!decoded) {
            return res.status(403).json({
                EM: 'Invalid or expired refresh token',
                EC: 1,
            });
        }

        const payload = {
            id: decoded.id,
            username: decoded.username,
            group: decoded.group,
            cartId: decoded.cartId
        };

        const accessToken = jwt.sign(payload, process.env.ACCESS_TOKEN_SECRET, {
            expiresIn: process.env.JWT_ACCESS_EXPRIES_IN,
        });

        return res.status(200).json({
            EM: "Created new token successfully",
            EC: 0,
            DT: {
                accessToken: accessToken
            }
        });

    } catch (error) {
        console.error('Error refreshing token:', error.message);
        return res.status(500).json({
            EM: 'Server error while refreshing token',
            EC: -1,
        });
    }
};

const handleGoogleLogin = async (req, res) => {
    try {
        const { idToken } = req.body;

        if (!idToken) {
            return res.status(400).json({
                EM: "Missing Google ID token",
                EC: 1,
                DT: {}
            });
        }

        const data = await googleLoginService(idToken);

        if (data.EC === 0) {
            return res.status(200).json({
                EM: data.EM,
                EC: 0,
                DT: data.DT
            });
        }

        return res.status(401).json({
            EM: data.EM || "Google login failed",
            EC: 1,
            DT: {}
        });

    } catch (e) {
        console.error("Google Login error:", e);
        return res.status(500).json({
            EM: "Server error",
            EC: -1,
            DT: {}
        });
    }
};



export {
    testAPI, handleRegister, handleLogin, handleLogout, createNewToken, handleGoogleLogin
};