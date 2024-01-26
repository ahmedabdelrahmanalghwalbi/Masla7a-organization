const Joi = require('joi');

exports.validateOffer = (offer) => {
    const schema = Joi.object({
        title: Joi.string().required(),
        description: Joi.string().required(),
        cover: Joi.string(),
        daysValidFor: Joi.number().required(),
    });

    return schema.validate(offer);
};