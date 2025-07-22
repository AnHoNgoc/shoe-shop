import Joi from "joi";

const registerSchema = Joi.object({
    username: Joi.string()
        .min(6)
        .max(30)
        .pattern(/^[a-zA-Z0-9_]+$/)
        .required()
        .messages({
            "string.empty": "Username cannot be empty",
            "string.min": "Username must be at least {#limit} characters long",
            "string.max": "Username must not exceed {#limit} characters",
            "string.pattern.base": "Username can only contain letters, numbers, and underscores",
            "any.required": "Username is required"
        }),

    password: Joi.string()
        .min(6)
        .max(30)
        .required()
        .messages({
            "string.empty": "Password cannot be empty",
            "string.min": "Password must be at least {#limit} characters long",
            "string.max": "Password must not exceed {#limit} characters",
            "any.required": "Password is required"
        }),
});

const loginSchema = Joi.object({
    valueLogin: Joi.string()
        .min(6)
        .max(30)
        .pattern(/^[a-zA-Z0-9_]+$/)
        .required()
        .messages({
            "string.empty": "Username cannot be empty",
            "string.min": "Username must be at least {#limit} characters long",
            "string.max": "Username must not exceed {#limit} characters",
            "string.pattern.base": "Username can only contain letters, numbers, and underscores",
            "any.required": "Username is required"
        }),

    password: Joi.string()
        .min(6)
        .max(30)
        .required()
        .messages({
            "string.empty": "Password cannot be empty",
            "string.min": "Password must be at least {#limit} characters long",
            "string.max": "Password must not exceed {#limit} characters",
            "any.required": "Password is required"
        }),
});

const changePasswordSchema = Joi.object({
    oldPassword: Joi.string()
        .min(6)
        .max(30)
        .required()
        .messages({
            "string.empty": "Password cannot be empty",
            "string.min": "Password must be at least {#limit} characters long",
            "string.max": "Password must not exceed {#limit} characters",
            "any.required": "Password is required"
        }),

    newPassword: Joi.string()
        .min(6)
        .max(30)
        .required()
        .messages({
            "string.empty": "Password cannot be empty",
            "string.min": "Password must be at least {#limit} characters long",
            "string.max": "Password must not exceed {#limit} characters",
            "any.required": "Password is required"
        }),
});

export { registerSchema, loginSchema, changePasswordSchema };