const mongoose = require('mongoose');
const geocoder = require('../utils/geocoder');


const orderSchema = new mongoose.Schema({
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
    createdAt: {
        type: Date,
        default: Date.now(),
        required: true
    },
    orderDate: {
        type: Date,
        required: true
    },
    startsAt: {
        type: Date,
        required: true
    },
    endsAt: {
        type: Date,
        required: true
    },
    // paymentMethod:{

    // },
    serviceId: {
        type: mongoose.Types.ObjectId,
        ref: 'Service',
        required: true
    },
    serviceName: {
        type: String,
        minlength: true,
        trim: true,
        required: true
    },
    notes: {
        type: String,
        maxlength: 2048
    },
    price: {
        type: Number,
        min: 5,
        required: true
    },
    status: {
        type: String,
        enum: ['completed', 'pending', 'canceled'],
        default: 'pending',
        required: true
    },
    address: {
        type: String,
        required: true
    },
    location: {
        type: {
            type: String,
            enum: ['Point']
        },
        coordinates: {
            type: [Number],
            index: '2dsphere'
        },
        // zipcode: String,
        formattedAddres: String,
        city: String,
        streetName: String,
        streetNumber: String,
        countryCode: String,
        country: String
    }
});


orderSchema.pre('save', async function (next) {
    let loc = await geocoder.geocode(this.address);
    loc = await geocoder.reverse({ lat: loc[0].latitude, lon: loc[0].longitude })
    this.location = {
        type: 'Point',
        coordinates: [loc[0].longitude, loc[0].latitude],
        formattedAddres: loc[0].formattedAddress,
        // zipcode: loc[0].zipcode,
        city: loc[0].city,
        streetName: loc[0].streetName,
        streetNumber: loc[0].streetNumber,
        countryCode: loc[0].countryCode,
        country: loc[0].country
    };
    // this.address = loc[0].formattedAddress;
    next();
});

module.exports = mongoose.model('Order', orderSchema);