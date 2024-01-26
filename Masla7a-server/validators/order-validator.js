const Joi = require('joi');

exports.validateCreateOrder = (order) => {
    const schema = Joi.object({
        customerId: Joi.string().min(24).required(),
        serviceName: Joi.string(),
        orderDate: Joi.date().required(),
        startsAt: Joi.date().required(),
        endsAt: Joi.date().required(),
        price: Joi.number().min(5).required(),
        address: Joi.string().required(),
        notes: Joi.string().max(2048)
    });

    return schema.validate(order);
};