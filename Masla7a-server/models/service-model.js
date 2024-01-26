const mongoose = require('mongoose');


const serviceSchema = new mongoose.Schema({
    serviceName: {
        type: String,
        minlength: 3,
        trim: true,
        required: true
    },
    categoryId: {
        type: mongoose.Types.ObjectId,
        ref: 'Category',
        required: true
    },
    serviceProviderId: {
        type: mongoose.Types.ObjectId,
        ref: 'User',
        required: true
    },
    ordersList: [{
        type: mongoose.Types.ObjectId,
        ref: 'Order',
        required: true
    }],
    servicePrice: {
        type: Number,
        min: 5,
        required: true
    },
    description: {
        type: String,
        minlength: 20,
        maxlength: 1024,
        trim: true
    },
    gallery: [{
        type: String
    }],
    averageRating:{
        type: Number,
        default: 1
    },
    numberOfRatings: {
        type: Number
    }
});



module.exports = mongoose.model('Service', serviceSchema);