
import db from "../models/index"
import { Op } from 'sequelize';

const getProductList = async (page, limit, nameSearch, minPrice, maxPrice, idCategory) => {
    try {
        let offset = (page - 1) * limit;

        let whereCondition = {
            name: {
                [Op.like]: `%${nameSearch}%`
            },
            price: {
                [Op.between]: [minPrice, maxPrice]
            }
        };
        // Nếu có idCategory thì thêm điều kiện lọc categoryId
        if (idCategory && idCategory !== 1) {
            whereCondition.category_id = idCategory;
        }

        const { count, rows } = await db.Product.findAndCountAll({
            where: whereCondition,
            offset: offset,
            limit: limit
        });

        let totalPages = Math.ceil(count / limit);

        let data = {
            totalRows: count,
            totalPages: totalPages,
            products: rows
        }

        return ({
            EM: rows.length > 0 ? "Fetched list product successfully" : "Not found data",
            EC: 0,
            DT: data
        });

    } catch (error) {
        console.log(error);

        return ({
            EM: "Error from server",
            EC: -1,
            DT: []
        });
    }
}

const getAllProducts = async () => {
    try {
        const data = await db.Product.findAll();

        return {
            EM: data.length > 0 ? "Fetched list product successfully" : "No products found",
            EC: 0,
            DT: data
        };

    } catch (error) {
        return {
            EM: "Error from server",
            EC: -1,
            DT: []
        };
    }
};

const createNewProduct = async (data) => {
    try {
        const product = await db.Product.create(data);

        if (product) {
            return {
                EM: "Create new product successful",
                EC: 0,
            };
        } else {
            return {
                EM: "Failed to create product",
                EC: 1,
            };
        }
    } catch (error) {
        return {
            EM: "Error from server",
            EC: -1,
        };
    }
};

const getProductById = async (id) => {
    try {
        const data = await db.Product.findOne({
            where: { id },
            include: [
                {
                    model: db.Category,
                    attributes: ['id', 'name', 'image'],
                },
                {
                    model: db.Review,
                    attributes: ['rating', 'comment', 'created_at'],
                    include: [
                        {
                            model: db.User,
                            attributes: ['id', 'username', 'profile_image'],
                        },
                    ],
                    separate: true,
                    order: [['created_at', 'DESC']],
                },
            ],
        });

        if (data) {
            return {
                EM: "Fetched product by ID successfully",
                EC: 0,
                DT: data,
            };
        } else {
            return {
                EM: "Product not found",
                EC: 1,
                DT: {},
            };
        }
    } catch (error) {
        return {
            EM: "Error from server",
            EC: -1,
            DT: {},
        };
    }
};

export {
    getProductList, getAllProducts, createNewProduct, getProductById
}

