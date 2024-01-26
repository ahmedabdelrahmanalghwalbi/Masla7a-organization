const Joi = require('joi');

exports.validateReview = (review) => {
    const schema = Joi.object({
        title: Joi.string().required(),
        content: Joi.string().required(),
        rating : Joi.number().min(1).max(5).required()
    });

    return schema.validate(review);
};