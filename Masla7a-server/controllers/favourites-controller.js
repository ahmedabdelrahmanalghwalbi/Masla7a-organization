const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const config = require('config');
const geolib = require('geolib');
const User = require('../models/user-model');
const Service = require('../models/service-model');



exports.getFavourites = async (req, res, next) => {

    try {

        const user = await User.findById(req.user._id);

        if (!user)
            return res.status(400).json({
                message: 'The User Id not found'
            });

        const favourites = await User
            .aggregate([
                {
                    $match: {
                        _id: mongoose.Types.ObjectId(req.user._id)
                    }
                },
                {
                    $lookup: {
                        from: 'services',
                        localField: 'favouritesList',
                        foreignField: '_id',
                        as: 'service'
                    }
                },
                {
                    $unwind: {
                        path: '$service',
                        preserveNullAndEmptyArrays: false
                    }
                },
                {
                    $lookup: {
                        from: 'users',
                        localField: 'service.serviceProviderId',
                        foreignField: '_id',
                        as: 'serviceProvider'
                    }
                },
                {
                    $unwind: {
                        path: '$serviceProvider',
                        preserveNullAndEmptyArrays: false
                    }
                },
                {
                    $set: {
                        'service.averageRating': {
                            $ifNull: ['$service.averageRating', 1]
                        },
                        'service.numberOfRatings': {
                            $ifNull: ['$service.numberOfRatings', 0]
                        }

                    }
                },
                {
                    $project: {
                        _id: 0,
                        'location.coordinates': 1,
                        serviceProvider: {
                            _id: 1,
                            name: 1,
                            profilePic: 1,
                            availability: 1,
                            'location.coordinates': 1
                        },
                        service: {
                            _id: 1,
                            serviceName: 1,
                            servicePrice: 1,
                            averageRating: 1,
                            numberOfRatings: 1,
                            servicePrice: 1
                        }
                    }
                },
            ]);


        if (favourites.length === 0)
            return res.status(200).json({
                count: favourites.length,
                message: 'Your Favorites list is empty.'
            });


        favourites.forEach(element => {
            element.distance = (geolib.getPreciseDistance(
                {
                    latitude: element.location.coordinates[1],
                    longitude: element.location.coordinates[0]
                },
                {
                    latitude: element.serviceProvider.location.coordinates[1],
                    longitude: element.serviceProvider.location.coordinates[0]
                },
                10
            ) / 1000);
            delete element.location;
            delete element.serviceProvider.location;
        });

        return res.status(200).json({
            count: favourites.length,
            favourites: favourites,
        });

    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};


exports.addToFavourites = async (req, res, next) => {

    if ((!mongoose.isValidObjectId(req.body.serviceProviderId)) ||
        (req.body.serviceProviderId === undefined)) {
        return res.status(400).json({
            message: 'The account you are trying to add to your favourites is invalid'
        });
    }

    try {

        if (req.body.serviceProviderId === req.user._id)
            return res.status(400).json({
                status: 'Failed',
                message: 'You Can not Add Yourself To Your Favorites.'
            });

        const user = await User.findById(req.user._id);

        if (!user)
            return res.status(400).json({
                message: 'The User not found'
            });

        const service = await Service.findOne({
            serviceProviderId: req.body.serviceProviderId
        }).populate('serviceProviderId');


        if (!service)
            return res.status(400).json({
                message: 'The Service Provider not found'
            });


        const isFavourite =
            user.favouritesList.includes(service._id);

        if (isFavourite)
            return res.status(400).json({
                message: 'The Service Provider Already Added To Favourites'
            });

        user.favouritesList.push(service._id);

        await user.save();

        return res.status(201).json({
            status: true,
            message: 'Added Successfully'
        });

    } catch (err) {
        res.status(500).json({
            message: err.message,
            status: false
        });
    }
};


exports.removeFromFavourites = async (req, res, next) => {

    if ((!mongoose.isValidObjectId(req.params.serviceProviderId)) ||
        (req.params.serviceProviderId === undefined)) {
        return res.status(400).json({
            message: 'The account you are trying to add to your favourites is not a valid'
        });
    }

    try {

        const user = await User.findById(req.user._id);

        if (!user)
            return res.status(400).json({
                message: 'The User not found'
            });


        const service = await Service.findOne({
            serviceProviderId: req.params.serviceProviderId
        }).populate('serviceProviderId');


        if (!service)
            return res.status(400).json({
                message: 'The Service Provider not found'
            });



        const index =
            user.favouritesList.indexOf(service._id);

        if (index === -1)
            return res.status(400).json({
                message: 'The Service Provider Already not Favourite'
            });

        user.favouritesList.splice(index, 1);

        await user.save();

        return res.status(200).json({
            status: true,
            message: 'Deleted Successfully'
        });

    } catch (err) {
        res.status(500).json({
            status: false,
            message: err.message
        });
    }
};