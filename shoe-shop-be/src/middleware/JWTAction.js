import dotenv from 'dotenv';
dotenv.config();
import jwt from "jsonwebtoken";
import redisClient from "../config/connection_redis.js";

const createJWT = (payload) => {
    let key = process.env.ACCESS_TOKEN_SECRET;
    let token = null;
    try {
        token = jwt.sign(payload, key, { expiresIn: process.env.JWT_ACCESS_EXPRIES_IN });

    } catch (error) {
        console.log(error);
    }
    return token;

};

const createRefreshToken = async (payload) => {
    const key = process.env.REFRESH_TOKEN_SECRET;
    let token = null;

    try {
        token = jwt.sign(payload, key, { expiresIn: process.env.JWT_REFRESH_EXPRIES_IN });

        const userId = payload.id;

        await redisClient.set(`refreshToken:${userId}`, token, {
            EX: 60 * 60 * 24 * 7,
        });

    } catch (error) {
        console.log(error);
    }
    return token;
};


const verifyAccessToken = (token) => {
    let key = process.env.ACCESS_TOKEN_SECRET;
    let data = null;

    try {
        let decoded = jwt.verify(token, key);
        data = decoded;
    } catch (error) {
        throw error;
    }

    return data;
};

const verifyRefreshToken = async (token) => {
    const key = process.env.REFRESH_TOKEN_SECRET;

    try {
        // Xác thực token trước
        const decoded = jwt.verify(token, key); // verify đảm bảo token hợp lệ và không bị giả mạo

        const userId = decoded.id;
        if (!userId) {
            throw new Error('Invalid token payload');
        }

        const tokenInRedis = await redisClient.get(`refreshToken:${userId}`);
        if (!tokenInRedis) {
            throw new Error('Refresh token not found in Redis');
        }

        if (token !== tokenInRedis) {
            throw new Error('Refresh token mismatch or expired');
        }

        return decoded; // verified and valid token payload

    } catch (error) {
        console.error('Error verifying refresh token:', error.message);
        throw error;
    }
};

const extractToken = (req) => {
    if (req.headers.authorization && req.headers.authorization.split(" ")[0] === "Bearer") {
        return req.headers.authorization.split(" ")[1];
    }
    return null
}

const checkUserJWT = (req, res, next) => {
    let token = null;

    // 1. Ưu tiên lấy token từ header
    const tokenFromHeader = extractToken(req);
    if (tokenFromHeader) {
        token = tokenFromHeader;
    }

    // 2. Nếu không có thì fallback về cookie
    else if (req.cookies && req.cookies.jwt) {
        token = req.cookies.jwt;
    }

    // 3. Nếu không có token thì báo lỗi
    if (!token) {
        return res.status(401).json({
            EC: 1,
            DT: "",
            EM: "Not authenticated the user"
        });
    }

    try {
        // 4. Verify token
        const decoded = verifyAccessToken(token);

        // 5. Gắn thông tin user vào request
        if (decoded) {
            req.user = decoded;
            req.token = token;
            next();
        }

    } catch (error) {

        // Kiểm tra lỗi hết hạn
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                EC: 1,
                DT: "",
                EM: "Token has expired."
            });
        }

        // Kiểm tra token không hợp lệ
        if (error.name === 'JsonWebTokenError') {
            return res.status(401).json({
                EC: 1,
                DT: "",
                EM: "Invalid token."
            });
        }

        // Xử lý các lỗi khác (nếu có)
        return res.status(500).json({
            EC: -1,
            DT: "",
            EM: "Token verification failed."
        });
    }
};

const checkUserPermission = (req, res, next) => {
    if (req.user) {
        let permissions = req.user.permissions;
        let currentUrl = req.path;
        let staticUrl = currentUrl.replace(/\/\d+$/, '');

        if (!permissions || permissions.length === 0) {
            return res.status(403).json({
                EM: "You don't have permission",
                EC: 1,
                DT: "",
            });
        }

        let canAccess = permissions.includes(staticUrl);

        console.log("Access allowed?", canAccess);

        if (canAccess) {
            return next();
        } else {
            return res.status(403).json({
                EM: "You don't have permission",
                EC: 1,
                DT: "",
            });
        }

    } else {
        return res.status(401).json({
            EC: 1,
            DT: "",
            EM: "Not authenticated the user"
        });
    }
};

// const checkUserPermission = (req, res, next) => {
//     if (!req.user) {
//         return res.status(401).json({
//             EC: 1,
//             DT: "",
//             EM: "Not authenticated the user"
//         });
//     }

//     const roles = req.user.group?.Roles || [];
//     const currentUrl = req.path;
//     const method = req.method;

//     if (roles.length === 0) {
//         return res.status(403).json({
//             EM: "You don't have permission",
//             EC: 1,
//             DT: "",
//         });
//     }

//     const canAccess = roles.some(role => {
//         if (role.method !== method) return false;

//         // Create a matcher function
//         const matcher = match(role.url, { decode: decodeURIComponent });

//         return matcher(currentUrl); // true if path matches role pattern
//     });

//     if (canAccess) {
//         return next();
//     }

//     return res.status(403).json({
//         EM: "You don't have permission",
//         EC: 1,
//         DT: "",
//     });
// };

export {
    createJWT, createRefreshToken, verifyAccessToken, verifyRefreshToken, checkUserJWT, checkUserPermission,
}