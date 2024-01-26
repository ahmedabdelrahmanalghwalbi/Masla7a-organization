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



exports.validateAddingAdmin = (user) => {
    const schema = Joi.object({
        name: Joi.string().min(3).max(55).required(),
        email: Joi.string().min(10).max(255).email().required(),
        password: passwordComplexity(complexityOptions).required(),
        userName: Joi.string().required(),
    });

    return schema.validate(user);
};


exports.validateAdminLogIn = (user) => {
    const schema = Joi.object({
        email: Joi.string().min(10).max(255).email().required(),
        password: passwordComplexity(complexityOptions).required()
    });

    return schema.validate(user);
};