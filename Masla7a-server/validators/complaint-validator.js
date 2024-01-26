const Joi = require('joi');

exports.validateComplaint = (complaint) => {
    const schema = Joi.object({
        userName: Joi.string().required(),
        complaintType: Joi.string().required(),
        description: Joi.string().required(),
        
    });

    return schema.validate(complaint);
};