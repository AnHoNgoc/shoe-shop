import express from "express";
import { testAPI, handleRegister, handleLogin, handleLogout, createNewToken } from "../controller/authController.js";
import { validateAuth } from "../middleware/authValidate.js";
import { registerSchema, loginSchema, changePasswordSchema } from "../helpers/validation.js";
import { checkUserJWT, checkUserPermission } from '../middleware/JWTAction.js';
import { handleGetProductList, handleGetAllProduct, handleGetProductById, handleDeleteProduct, handleCreateProduct } from "../controller/productController.js";
import { handleGetGroupList } from "../controller/groupController.js";
import { handleGetUserList, handleCreateUser, handleUpdateUser, handleDeleteUser, getUserAccount, handleGetUserById, handleChangePassword } from "../controller/userController.js";
import { handleGetRoleList, handleCreateRole, handleDeleteRole, handleFetchRolesByGroup, handleAssignRoleToGroup } from "../controller/roleController.js";
import { handleGetCategoryList } from "../controller/categoryController.js";
import { handleGetFavoritesByUser, handleToggleFavorite } from "../controller/favoriteController.js";
import { handleGetCartItem, handleAddToCart, handleIncrementCartItem, handleDecrementCartItem, handleRemoveFromCart, handleClearCart } from "../controller/cartController.js";
import { uploadProfileImage } from "../controller/userController.js";
import { handleCreateReview, handleGetReviewList } from "../controller/reviewController.js";
import { handleCheckout, handleGetOrdersByUser, handleStripeCheckout, handleUpdateOrderStatus, handleDeleteOrder, handleGetOrderList } from "../controller/orderController.js";
import multer from "multer";


const router = express.Router();

const storage = multer.memoryStorage();
const upload = multer({
    storage,
    limits: { fileSize: 5 * 1024 * 1024 },
});


const initAPIRoutes = (app) => {

    router.get("/test", testAPI);
    router.post("/register", validateAuth(registerSchema), handleRegister);
    router.post("/login", validateAuth(loginSchema), handleLogin);
    router.post("/refresh-token", createNewToken);
    router.post("/logout", handleLogout);

    router.get("/product/list", handleGetProductList);
    router.get("/product/all", handleGetAllProduct);
    router.get("/product/detail/:id", handleGetProductById);
    router.get("/category/list", handleGetCategoryList);
    router.get("/review/list", handleGetReviewList);

    router.use(checkUserJWT);
    router.get("/account", getUserAccount);
    router.use(checkUserPermission);

    router.get("/group/list", handleGetGroupList);
    router.get("/favorite/list", handleGetFavoritesByUser);
    router.post("/favorite/toggle", handleToggleFavorite);

    router.get("/cart/list", handleGetCartItem);
    router.post("/cart/add", handleAddToCart);
    router.patch("/cart/increment", handleIncrementCartItem);
    router.patch("/cart/decrement", handleDecrementCartItem);
    router.delete("/cart/delete-item", handleRemoveFromCart);
    router.delete("/cart/clear", handleClearCart);

    router.post("/review/create", handleCreateReview);

    router.post("/order/checkout", handleCheckout);
    router.post("/order/stripe", handleStripeCheckout);
    router.get("/order/user", handleGetOrdersByUser);

    router.get("/user/detail", handleGetUserById);
    router.patch("/user/change-password", validateAuth(changePasswordSchema), handleChangePassword);

    router.put("/user/update", handleUpdateUser);
    router.post("/upload-profile-image", upload.single("profile_image"), uploadProfileImage);

    router.post("/product/create", handleCreateProduct)
    router.delete("/product/delete/:id", handleDeleteProduct)
    router.patch('/order/update-status/:id', handleUpdateOrderStatus);
    router.delete("/order/delete/:id", handleDeleteOrder);
    router.get("/order/list", handleGetOrderList)

    router.post("/user/create", handleCreateUser);
    router.delete("/user/delete/:id", handleDeleteUser);
    router.get("/user/list", handleGetUserList);

    router.get("/role/by-group/:groupId", handleFetchRolesByGroup);
    router.post("/role/assign-to-group", handleAssignRoleToGroup);

    router.get("/role/list", handleGetRoleList);
    router.post("/role/create", handleCreateRole);
    router.delete("/role/delete/:id", handleDeleteRole);

    return app.use("/shoe-shop", router);

}

export default initAPIRoutes;

