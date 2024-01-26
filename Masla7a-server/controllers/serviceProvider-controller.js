const jwt = require('jsonwebtoken');
const config = require('config');
const mongoose = require('mongoose');
const Fuse = require('fuse.js');
const Service = require('../models/service-model');
const Category = require('../models/category-model');
const User = require('..//models/user-model');
const { cleanObj } = require('../utils/filterHelpers');

const options = {
    minMatchCharLength: 1,
    threshold: 0.2,
    keys: [
        'name'
    ]
};



exports.topServiceProviders = async (req, res, next) => {
    try {

        const serviceProviders = await Service
            .aggregate([
                {
                    $lookup: {
                        from: 'users',
                        localField: 'serviceProviderId',
                        foreignField: '_id',
                        as: 'serviceProviderId'
                    }
                },
                {
                    $set: {
                        favourite: false,
                        averageRating: { $ifNull: ['$averageRating', 1] },
                        numberOfRatings: { $ifNull: ['$numberOfRatings', 0] },
                        serviceProvider: { $first: '$serviceProviderId' }
                    }
                },
                {
                    $project: {
                        _id: true,
                        serviceName: true,
                        servicePrice: true,
                        averageRating: true,
                        numberOfRatings: true,
                        ordersNumber: { $size: { $ifNull: ['$ordersList', []] } },
                        favourite: true,
                        serviceProvider: {
                            _id: true,
                            name: true,
                            gender: true,
                            profilePic: true,
                            availability: true
                        }
                    }
                },
                {
                    $sort: {
                        ordersNumber: -1,
                        numberOfRatings: -1,
                        averageRating: -1
                    }
                }
            ]);

        if (serviceProviders.length === 0)
            return res.status(200).json({
                hasContent: false,
                message: 'No Service Providers Added Yet'
            });


        if (req.user) {

            let user = await User.findById(req.user._id);

            if (!user)
                return res.status(400).json({
                    message: 'The User Sent In The Token not Found'
                });


            if (user.role === 'serviceProvider') {
                for (let i = 0; i < serviceProviders.length; i++) {
                    if (user._id.toString() ===
                        serviceProviders[i].serviceProvider._id.toString()) {
                        serviceProviders.splice(i, 1);
                        break;
                    }
                }
            }


            serviceProviders.forEach(((service, index, arr) => {
                if (user.favouritesList.includes(service._id))
                    service.favourite = true;
            }));
        }
        return res.status(200).json({
            serviceProvidersCount: serviceProviders.length,
            serviceProviders: serviceProviders
        });

    } catch (err) {
        if (err.message.includes('Unexpected token'))
            return res.status(400).json({
                message: 'Invalid Token'
            });

        res.status(500).json({
            message: err.message
        });
    }
};


exports.filterServices = async (req, res, next) => {

    const token = req.header('x-auth-token');

    if ((req.params.categoryId) && (!mongoose.isValidObjectId(req.params.categoryId)))
        return res.status(400).json({
            message: 'The Category You Chose Doesn\'t Exist'
        });

    try {

        let locationData = {};

        let aggregate = [];

        let decodedToken;


        if (token) {
            decodedToken = jwt.verify(token, config.get('jwtPrivateKey'));
            var userToken = await User.findById(decodedToken._id);
            if (!userToken)
                return res.status(400).json({
                    message: 'The User in The Token not found'
                })
        }

        if (req.params.categoryId !== undefined) {
            const category = await Category.findById(req.params.categoryId);

            if (!category)
                return res.status(404).json({
                    message: 'Page Not Found'
                });
        }


        const queryData = {
            'serviceId.categoryId': !req.params.categoryId ?
                undefined : mongoose.Types.ObjectId(req.params.categoryId),

            'serviceId.averageRating': ((!req.query.rating) || (req.query.rating <= 0.4)) ?
                undefined : { $gte: Number(req.query.rating) }
        };


        const servicePrice = {
            $gte: req.query.price_from === undefined ?
                undefined : Number(req.query.price_from),
            $lte: req.query.price_to === undefined ?
                undefined : Number(req.query.price_to)
        };

        {
            //locationData = {
            //     'location.city': req.query.city === undefined ?
            //         undefined : new RegExp(`.*${req.query.city}.*`, 'i')
            // };


            if (token &&
                decodedToken.gotAddress === true) {
                var user = await User.findById(decodedToken._id);
                locationData = {
                    //     'location.city': req.query.city === undefined ?
                    //         user.location.city : new RegExp(`.*${req.query.city}.*`, 'i'),

                    location: (req.query.distance === undefined ||
                        req.query.distance === 0) ?
                        undefined : {
                            $geoWithin: {
                                $centerSphere: [
                                    user.location.coordinates,
                                    (req.query.distance / 6371.1)
                                ]
                            }
                        }
                }
                var userCoordinates = user.location.coordinates;

                aggregate = [
                    {
                        $geoNear: {
                            near: {
                                type: "Point",
                                coordinates: userCoordinates
                            },
                            distanceField: 'distance',
                            spherical: true,
                            distanceMultiplier: 0.001
                        }
                    }
                ];
            }

            cleanObj(locationData)
        }

        cleanObj(queryData);
        cleanObj(servicePrice);


        if (Object.keys(servicePrice).length > 0)
            queryData['serviceId.servicePrice'] = servicePrice;



        let serviceProviders = await User
            .aggregate([
                ...aggregate,
                {
                    $lookup: {
                        from: 'services',
                        localField: 'serviceId',
                        foreignField: '_id',
                        as: 'serviceId'
                    }
                },
                {
                    $set: {
                        serviceId: { $first: '$serviceId' }
                    }
                },
                {
                    $set: {
                        'serviceId.averageRating': {
                            $ifNull:
                                ['$serviceId.averageRating',
                                    1]
                        },
                        'serviceId.numberOfRatings': {
                            $ifNull:
                                ['$serviceId.numberOfRatings',
                                    0]
                        },
                    }
                },
                {
                    $match: { ...queryData, ...locationData, role: 'serviceProvider' }
                },
                {
                    $set: {
                        favourite: false
                    }
                },
                {
                    $project: {
                        _id: true,
                        name: true,
                        userName: true,
                        profilePic: true,
                        availability: true,
                        distance: true,
                        favourite: true,
                        service: {
                            _id: '$serviceId._id',
                            serviceName: '$serviceId.serviceName',
                            servicePrice: '$serviceId.servicePrice',
                            averageRating: '$serviceId.averageRating',
                            numberOfRatings: '$serviceId.numberOfRatings',
                            numberOfOrders: {
                                $size: {
                                    $ifNull:
                                        ['$serviceId.ordersList',
                                            []]
                                }
                            }
                        }
                    }
                },
                {
                    $sort: sortBy(req.query.sort)
                }
            ]);


        if (userToken.role === 'serviceProvider') {
            for (let i = 0; i < serviceProviders.length; i++) {
                if (userToken._id.toString() ===
                    serviceProviders[i]._id.toString()) {
                    serviceProviders.splice(i, 1);
                    break;
                }
            }
        }

        if (userToken) {
            serviceProviders.forEach((serviceProvider => {
                if (userToken.favouritesList.includes(serviceProvider.service._id)) {
                    serviceProvider.favourite = true;
                }
            }));
        }


        if (req.query.search) {
            req.query.search = req.query.search.trim();
            if (req.query.search[0] === '@') {
                options.keys = ['userName'];
                req.query.search = req.query.search.substring(1);
            } else if (req.query.search[0] === '#') {
                options.keys = ['service.serviceName'];
                req.query.search = req.query.search.substring(1);
            }

            let serviceProvidersList = [];
            const fuse = new Fuse(serviceProviders, options);

            fuse.search(req.query.search).forEach(serviceProvider => {
                serviceProvidersList.push(serviceProvider.item);
            });
            serviceProviders = serviceProvidersList;
        }


        // serviceProviders.map(serviceProvider => {
        //     serviceProvider.distance = serviceProvider.distance.toFixed(1);
        // });

        if (serviceProviders.length === 0)
            return res.status(200).json({
                hasContent: false,
                message: 'Could Not Find Any Service Provider'
            });

        res.json({
            count: serviceProviders.length,
            serviceProviders: serviceProviders
        });

    } catch (err) {
        if (err.message.includes('Unexpected token'))
            return res.status(400).json({
                message: 'Invalid Token'
            });
        res.status(500).json({ message: err.message });
    }

};


function sortBy(sortFactor) {
    switch (sortFactor) {
        case 'price_asc':
            return { 'service.servicePrice': 1 };
        case 'price_desc':
            return { 'service.servicePrice': -1 };
        case 'most_rated':
            return {
                'service.averageRating': -1,
                'service.numberOfRatings': -1
            };
        case 'nearest':
            return {
                distance: 1
            };
        case 'popularity':
        default:
            return {
                'service.numberOfOrders': -1,
                'service.numberOfRatings': -1,
            };
    }
}