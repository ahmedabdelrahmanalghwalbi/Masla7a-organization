const mongoose = require('mongoose');
const config = require('config');
const jwt = require('jsonwebtoken');
const notificationService = require('../services/notification')
const geocoder = require('../utils/geocoder');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        minlength: 3,
        maxlength: 55,
        trim: true,
        required: true
    },
    email: {
        type: String,
        minlength: 10,
        maxlength: 255,
        trim: true,
        required: true,
        unique: true
    },
    userName: {
        type: String,
        trim: true,
        required: true,
        unique: true
    },
    password: {
        type: String,
        minlength: 8,
        maxlength: 64,
        required: true
    },
    age: {
        type: Number,
        min: 16,
        max: 100,
        required: function () {
            return this.role !== 'admin'
        }
    },
    gender: {
        type: String,
        trim: true,
        required: function () {
            return this.role !== 'admin'
        }
    },
    nationalID: {
        type: String,
        minlength: 14,
        trim: true,
        maxlength: 28,
        required: function () {
            return this.role !== 'admin'
        }
    },
    profilePic: {
        type: String,
        required: false,
        default: function () {
            if (this.gender === 'female')
                return 'https://res.cloudinary.com/maslaha-app/image/upload/v1625175864/WhatsApp_Image_2021-07-01_at_11.22.24_PM_feprza.jpg'
            else {
                return 'https://res.cloudinary.com/maslaha-app/image/upload/v1625175864/WhatsApp_Image_2021-07-01_at_11.21.40_PM_qpjbyx.jpg'
            }
        }
    },
    phone_number: {
        type: String,
        minlength: 11,
        required: function () {
            return this.role !== 'admin';
        }
    },
    address: {
        type: String,
        required: function () {
            return this.role !== 'admin';
        }
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
        formattedAddres: String,
        // zipcode: String,
        city: String,
        streetName: String,
        streetNumber: String,
        countryCode: String
    },
    role: {
        type: String,
        enum: ['customer',
            'serviceProvider',
            'admin'],
        default: 'customer',
        required: true
    },
    serviceId: {
        type: mongoose.Types.ObjectId,
        ref: 'Service'
    },
    availability: {
        type: String,
        enum: ['online',
            'offline',
            'busy'],
        default: 'offline',
        required: true
    },
    favouritesList: [{
        type: mongoose.Types.ObjectId,
        ref: 'User'
    }],
    pushTokens: [
        new mongoose.Schema(
            {
                deviceType: {
                    type: String,
                    enum: ["android", "ios", "web"],
                    default: 'android',
                    required: function () {
                        return this.role !== 'admin';
                    },
                },
                deviceToken: {
                    type: String,
                    required: function () {
                        return this.role !== 'admin';
                    },
                },
            },
            { _id: false }
        ),
    ],
});


userSchema.methods.user_send_notification = async function (message) {
    let changed = false;
    let len = this.pushTokens.length;
    while (len--) {
        const deviceToken = this.pushTokens[len].deviceToken;
        try {
            await notificationService.firebaseSendNotification(deviceToken, message);
        } catch (err) {
            this.pushTokens.splice(len, 1);
            changed = true;
        }
    }
    if (changed) await this.save();
};


userSchema.methods.generateAuthToken = function () {
    const token = jwt.sign({
        _id: this._id,
        email: this.email,
        userName: this.userName,
        role: this.role,
        gotAddress: (this.address !== undefined)
    }, config.get('jwtPrivateKey'));
    return token;
};


userSchema.pre('save', async function (next) {
    if (this.address) {
        let loc = await geocoder.geocode(this.address);
        loc = await geocoder.reverse({ lat: loc[0].latitude, lon: loc[0].longitude })
        this.location = {
            type: 'Point',
            coordinates: [loc[0].longitude, loc[0].latitude],
            formattedAddres: loc[0].formattedAddress,
            city: loc[0].city,
            // zipcode: loc[0].zipcode,
            streetName: loc[0].streetName,
            streetNumber: loc[0].streetNumber,
            countryCode: loc[0].countryCode
        };
        // this.address = loc[0].formattedAddress;
    }
    next();
});


module.exports = mongoose.model('User', userSchema);;