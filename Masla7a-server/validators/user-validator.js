const Joi = require('joi');
const passwordComplexity = require('joi-password-complexity').default;

const complexityOptions = {
    min: 8,
    max: 64,
    lowerCase: 1,
    upperCase: 1,
    numeric: 1,
    // symbol: 1,
    requirementCount: 4
};

exports.validateSignUp = (user) => {
    const schema = Joi.object({
        name: Joi.string().min(3).max(55).required(),
        email: Joi.string().min(10).max(255).email().required(),
        password: passwordComplexity(complexityOptions).required(),
        birthDate: Joi.string().required(),
        nationalID: Joi.string().min(14).max(28).required(),
        phone_number: Joi.string().min(11).max(18).required(),
        gender: Joi.string().required(),
        userName: Joi.string().required(),
        role: Joi.string().required(),
        address: Joi.string().required(),
        deviceType: Joi.string(),
        deviceToken: Joi.string().required()
    });

    return schema.validate(user);
};

exports.validateLogIn = (user) => {
    const schema = Joi.object({
        email: Joi.string().min(10).max(255).email().required(),
        password: passwordComplexity(complexityOptions).required()
    });

    return schema.validate(user);
};

exports.validateServiceProvider = function validateServiceProvider(user) {
    const schema = Joi.object({
        name: Joi.string().min(3).max(55).required(),
        email: Joi.string().min(10).max(255).email().required(),
        password: passwordComplexity(complexityOptions).required(),
        birthDate: Joi.string().required(),
        nationalID: Joi.string().min(14).max(28).required(),
        phone_number: Joi.string().min(11).max(18).required(),
        gender: Joi.string().required(),
        serviceName: Joi.string().min(3).required(),
        category: Joi.string().required(),
        description: Joi.string().min(20).max(1024),
        servicePrice: Joi.number().required(),
        address: Joi.string().required(),
        userName: Joi.string().required(),
        role: Joi.string().required(),
        deviceType: Joi.string(),
        deviceToken: Joi.string()
    });
    return schema.validate(user);
};


exports.validateEditProfile = (user) => {
    const schema = Joi.object({
        name: Joi.string().min(3).max(55),
        phone_number: Joi.string().min(11).max(18),
        address: Joi.string(),
        birthDate: Joi.string(),
        gender: Joi.string(),
        serviceName: Joi.string().min(3),
        description: Joi.string().min(20).max(1024),
        servicePrice: Joi.number()
    });

    return schema.validate(user);
};


exports.validateChangeEmail = (user) => {
    const schema = Joi.object({
        email: Joi.string().min(10).max(255),
        password: passwordComplexity(complexityOptions).required()
    });

    return schema.validate(user);
};


exports.validateResetPassword = (user) => {
    const schema = Joi.object({
        current_password: passwordComplexity(complexityOptions).required(),
        new_password: passwordComplexity(complexityOptions).required()
    });

    return schema.validate(user);
};