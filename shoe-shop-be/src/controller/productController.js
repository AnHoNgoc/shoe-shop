import { getProductList, getAllProducts, createNewProduct, getProductById, deleteProduct } from "../service/productService";

const handleGetProductList = async (req, res) => {
    try {

        const page = Number(req.query.page);
        const nameSearch = req.query.nameSearch || '';
        const minPrice = req.query.minPrice || 0;
        const maxPrice = req.query.maxPrice || 10000;
        const idCategory = req.query.idCategory || '';


        if (!Number.isInteger(page) || page < 1) {
            return res.status(400).json({
                EM: "Invalid or missing 'page' parameter",
                EC: 1,
                DT: {}
            });
        }

        const data = await getProductList(page, 10, nameSearch, minPrice, maxPrice, idCategory);


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
        });

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
        })
    }
}

const handleGetAllProduct = async (req, res) => {
    try {

        let data = await getAllProducts();

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
        });

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
            DT: ""
        })
    }
}

const handleCreateProduct = async (req, res) => {
    try {
        // Kết hợp dữ liệu từ req.body và thông tin file từ req.file
        const productData = {
            name: req.body.name,
            price: req.body.price,
            quantity: req.body.quantity,
            image: req.body.image,
            category_id: req.body.categoryId
        };

        const data = await createNewProduct(productData);


        let statusCode = 201;

        if (data.EC === 1) {
            statusCode = 400;
        } else if (data.EC !== 0) {
            statusCode = 500;
        }

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
        });

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
        });
    }
}

const handleGetProductById = async (req, res) => {
    try {

        let id = Number(req.params.id);

        if (!Number.isInteger(id) || id < 1) {
            return res.status(400).json({
                EM: "Invalid or missing user ID",
                EC: 1,
                DT: {}
            });
        }
        const data = await getProductById(id);

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
        });

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: -1,
        })
    }
}



const handleDeleteProduct = async (req, res) => {
    try {
        let id = req.params.id;
        let data = await deleteProduct(id)

        const statusCode = data.EC === 0 ? 200 : 500;

        return res.status(statusCode).json({
            EM: data.EM,
            EC: data.EC,
        });

    } catch (error) {
        return res.status(500).json({
            EM: "error from server",
            EC: "-1",
        })
    }
}



export {
    handleGetProductList,
    handleGetAllProduct,
    handleCreateProduct,
    handleGetProductById,
    handleDeleteProduct
};