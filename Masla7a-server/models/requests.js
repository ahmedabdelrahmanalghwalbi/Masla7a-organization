const mongoose = require('mongoose');
const geocoder = require('../utils/geocoder');


const requestSchema = new mongoose.Schema({
    customerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    serviceProviderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    serviceName: {
        type: String,
        minlength: true,
        trim: true,
        required: true
    },
    status: {
        type: String,
        enum: ['Accepted', 'pending', 'Rejected'],
        default: 'pending',
        required: true
    },
},
{timestamps:true}
);


module.exports = mongoose.model('Request', requestSchema);