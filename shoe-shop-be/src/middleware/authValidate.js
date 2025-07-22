const validateAuth = (schema) => {
    return (req, res, next) => {
        const { error } = schema.validate(req.body, { abortEarly: false }); // check tất cả lỗi
        if (error) {
            const messages = error.details.map((err) => err.message);
            return res.status(400).json({
                EM: messages.join(". "), // nối tất cả message lại
                EC: 1,
                DT: "",
            });
        }
        next();
    };
};

export { validateAuth };