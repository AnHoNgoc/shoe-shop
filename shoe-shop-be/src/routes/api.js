import express from "express";
import { testAPI, handleRegister, handleLogin, handleLogout, createNewToken } from "../controller/authController";
import { validateAuth } from "../middleware/authValidate";
import { registerSchema, loginSchema, changePasswordSchema } from "../helpers/validation";
import { checkUserJWT, checkUserPermission } from '../middleware/JWTAction';
import { handleGetProductList, handleGetAllProduct, handleGetProductById } from "../controller/productController";
import { handleGetGroupList } from "../controller/groupController";
import { handleGetUserList, handleCreateUser, handleUpdateUser, handleDeleteUser, getUserAccount, handleGetUserById, handleChangePassword } from "../controller/userController";
import { handleGetRoleList, handleCreateRole, handleDeleteRole, handleFetchRolesByGroup, handleAssignRoleToGroup } from "../controller/roleController";
import { handleGetCategoryList } from "../controller/categoryController";
import { handleGetFavoritesByUser, handleToggleFavorite } from "../controller/favoriteController";
import { handleGetCartItem, handleAddToCart, handleIncrementCartItem, handleDecrementCartItem, handleRemoveFromCart, handleClearCart } from "../controller/cartController";
import { uploadProfileImage } from "../controller/userController";
import { handleCreateReview, handleGetReviewList } from "../controller/reviewController";
import { handleCheckout, handleGetOrders, handleStripeCheckout } from "../controller/orderController";
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
    router.get("/product/list", handleGetProductList);
    router.get("/product/all", handleGetAllProduct);
    router.get("/product/detail/:id", handleGetProductById);
    router.get("/category/list", handleGetCategoryList);
    router.post("/refresh-token", createNewToken);
    router.get("/review/list", handleGetReviewList);

    router.use(checkUserJWT);
    router.get("/account", getUserAccount);
    router.delete("/logout", handleLogout);



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
    router.get("/order/list", handleGetOrders);


    router.get("/group/list", handleGetGroupList);

    router.get("/user/list", handleGetUserList);
    router.get("/user/detail", handleGetUserById);
    router.patch("/user/change-password", validateAuth(changePasswordSchema), handleChangePassword);
    router.post("/user/create", handleCreateUser);
    router.put("/user/update", handleUpdateUser);
    router.delete("/user/delete/:id", handleDeleteUser);
    router.post("/upload-profile-image", upload.single("profile_image"), uploadProfileImage);

    router.get("/role/by-group/:groupId", handleFetchRolesByGroup);
    router.post("/role/assign-to-group", handleAssignRoleToGroup);

    router.get("/role/list", handleGetRoleList);
    router.post("/role/create", handleCreateRole);
    router.delete("/role/delete/:id", handleDeleteRole);

    return app.use("/api", router);

}

export default initAPIRoutes;

