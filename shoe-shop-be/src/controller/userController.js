import dotenv from 'dotenv';
dotenv.config();
import { getUserList, deleteUser, createNewUser, updateUser, getUserById, changePassword } from "../service/userService.js";
import { v2 as cloudinary } from "cloudinary";
import streamifier from "streamifier";

cloudinary.config({
    cloud_name: process.env.CLOUD_NAME,
    api_key: process.env.CLOUD_API_KEY,
    api_secret: process.env.CLOUD_API_SECRET,
});


const streamUpload = (fileBuffer) => {
    return new Promise((resolve, reject) => {
        const stream = cloudinary.uploader.upload_stream(
            { folder: "profile_images" },
            (error, result) => {
                if (result) resolve(result);
                else reject(error);
            }
        );

        streamifier.createReadStream(fileBuffer).pipe(stream);
    });
};

const uploadProfileImage = async (req, res) => {
    if (!req.file) {
        return res.status(400).json({ message: "No file uploaded" });
    }

    try {
        const result = await streamUpload(req.file.buffer);
        return res.status(200).json({ message: "Upload success", url: result.secure_url });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Upload failed", error });
    }
};



const handleGetUserList = async (req, res) => {
    try {
        const page = Number(req.query.page);
        const nameSearch = req.query.nameSearch || '';
        const groupId = req.query.groupId || '';

        if (!Number.isInteger(page) || page < 1) {
            return res.status(400).json({
                EM: "Invalid or missing 'page' parameter",
                EC: 1,
                DT: {}
            });
        }

        const data = await getUserList(page, 3, nameSearch, groupId);

        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        });
    }
};

const handleCreateUser = async (req, res) => {
    try {
        const data = await createNewUser(req.body);

        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        })
    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        })
    }
}

const handleUpdateUser = async (req, res) => {
    try {
        let username = req.body.username;
        let profile_image = req.body.profile_image;

        let id = Number(req.user.id);

        if (!Number.isInteger(id)) {
            return res.status(400).json({
                EM: "Invalid or missing user ID",
                EC: 1,
                DT: {}
            });
        }

        let data = await updateUser(username, profile_image, id);
        console.log("Check update", data);

        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
        })
    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
        })
    }
}

const handleDeleteUser = async (req, res) => {
    try {
        const id = Number(req.params.id);

        if (!Number.isInteger(id) || id < 1) {
            return res.status(400).json({
                EM: "Invalid or missing user ID",
                EC: 1,
                DT: {}
            });
        }

        const data = await deleteUser(id);

        return res.status(200).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        });
    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        });
    }
};

const getUserAccount = async (req, res) => {
    console.log("🔍 req.user:", req.user);

    return res.status(200).json({
        EM: "get user account successfully",
        EC: 0,
        DT: {
            id: req.user.id,
            group: req.user.groupName,
            username: req.user.username
        }
    })
}

const handleGetUserById = async (req, res) => {
    try {
        let id = Number(req.user.id);

        if (!Number.isInteger(id)) {
            return res.status(400).json({
                EM: "Invalid or missing user ID",
                EC: 1,
                DT: {}
            });
        }

        let data = await getUserById(id)

        let statusCode = 200;

        if (data.EC === 1) {
            statusCode = 404;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
            DT: data.DT
        })
    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
        })
    }
}

const handleChangePassword = async (req, res) => {
    try {
        let oldPassword = req.body.oldPassword
        let newPassword = req.body.newPassword;
        const id = Number(req.user.id);

        if (!Number.isInteger(id) || !oldPassword || !newPassword) {
            return res.status(400).json({
                EM: "Missing id or password fields",
                EC: 1,
            });
        }

        let data = await changePassword(oldPassword, newPassword, id)

        let statusCode = 200;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
        })
    } catch (error) {
        console.log("Change password error:", error);
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
        })
    }
}



export {
    handleGetUserList, handleCreateUser, handleUpdateUser, handleDeleteUser, handleGetUserById, getUserAccount, handleChangePassword, uploadProfileImage
};