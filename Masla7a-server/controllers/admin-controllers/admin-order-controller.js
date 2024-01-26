const mongoose = require("mongoose");
const Fuse = require('fuse.js');
const Order = require("../../models/order-model");
const { cleanObj } = require('../../utils/filterHelpers');



const customerOptions = {
    minMatchCharLength: 1,
    threshold: 0.2,
    keys: [
        'customer.name'
    ]
};

const serviceProviderOptions = {
    minMatchCharLength: 1,
    threshold: 0.2,
    keys: [
        'serviceProvider.name'
    ]
};



exports.getRecentOrders = async (req, res) => {

    if (req.user.role !== 'admin')
        return res.status(403).json({
            message: 'Access Denied, Only Admins Can Access This'
        });

    try {

        let queryData = {
            // status: { $in: ['completed', 'pending'] }
        };

        if (req.query.date_from && req.query.date_to) {
            if (new Date(req.query.date_from) >= new Date(req.query.date_to))
                return res.status(400).json({
                    message: 'The Start Date is Greater Than The End Date.'
                })
        }

        const dateInterval = {
            $gte: !req.query.date_from ?
                undefined : new Date(req.query.date_from),
            $lte: !req.query.date_to ?
                undefined : new Date(req.query.date_to)
        };

        cleanObj(dateInterval);

        if (Object.keys(dateInterval).length > 0) {
            queryData.orderDate = dateInterval
        } else {
            queryData.orderDate = {
                $lte: new Date()
            }
        }


        const orders = await Order
            .aggregate([
                {
                    $match: queryData
                },
                {
                    $lookup: {
                        from: 'users',
                        localField: 'customerId',
                        foreignField: '_id',
                        as: 'customerId'
                    }
                },
                {
                    $lookup: {
                        from: 'users',
                        localField: 'serviceProviderId',
                        foreignField: '_id',
                        as: 'serviceProviderId'
                    }
                },
                {
                    $project: {
                        _id: true,
                        startsAt: true,
                        price: true,
                        status: true,
                        customer: {
                            _id: { $first: '$customerId._id' },
                            name: { $first: '$customerId.name' },
                            profilePic: { $first: '$customerId.profilePic' }

                        },
                        serviceProvider: {
                            _id: { $first: '$serviceProviderId._id' },
                            name: { $first: '$serviceProviderId.name' },
                            profilePic: { $first: '$serviceProviderId.profilePic' }
                        }
                    }
                },
                {
                    $sort: {
                        startsAt: -1
                    }
                }
            ]);


        if (orders.length === 0)
            return res.status(200).json({
                message: 'Couldn\'t Found Any Orders Made At This Time.'
            });

        return res.status(200).json({
            count: orders.length,
            orders: orders
        });

    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};


exports.getAllOrders = async (req, res) => {

    if (req.user.role !== 'admin')
        return res.status(403).json({
            message: 'Access Denied, Only Admins Can Access This'
        });


    try {
        let queryData = {
            status: !req.query.status ?
                undefined : req.query.status,

            'location.city': !req.query.city ?
                undefined : new RegExp(`.*${req.query.city}.*`, 'i'),

            'serviceId.categoryId': !req.query.categoryId ?
                undefined : mongoose.Types.ObjectId(req.query.categoryId)
        };

        if (req.query.date_from && req.query.date_to) {
            if (new Date(req.query.date_from) >= new Date(req.query.date_to))
                return res.status(400).json({
                    message: 'The Start Date is Greater Than The End Date.'
                })
        }

        const dateInterval = {
            $gte: !req.query.date_from ?
                undefined : new Date(req.query.date_from),
            $lte: !req.query.date_to ?
                undefined : new Date(req.query.date_to)
        };

        cleanObj(dateInterval);
        cleanObj(queryData);


        if (Object.keys(dateInterval).length > 0) {
            queryData.orderDate = dateInterval
        }

        let orders = await Order
            .aggregate([
                {
                    $lookup: {
                        from: 'services',
                        localField: 'serviceId',
                        foreignField: '_id',
                        as: 'serviceId'
                    }
                },
                {
                    $match: queryData
                },
                {
                    $lookup: {
                        from: 'categories',
                        localField: 'serviceId.categoryId',
                        foreignField: '_id',
                        as: 'serviceId.categoryId'
                    }
                },
                {
                    $lookup: {
                        from: 'users',
                        localField: 'serviceProviderId',
                        foreignField: '_id',
                        as: 'serviceProviderId'
                    }
                },
                {
                    $lookup: {
                        from: 'users',
                        localField: 'customerId',
                        foreignField: '_id',
                        as: 'customerId'
                    }
                },
                {
                    $project: {
                        _id: true,
                        orderName: '$serviceName',
                        startsAt: true,
                        city: '$location.city',
                        status: true,
                        price: true,
                        createdAt: true,
                        startsAt: true,
                        endsAt: true,
                        // paymentMethod: true,
                        customer: {
                            _id: { $first: '$customerId._id' },
                            name: { $first: '$customerId.name' },
                            profilePic: { $first: '$customerId.profilePic' },
                            userName: { $first: '$customerId.userName' }
                        },
                        serviceProvider: {
                            _id: { $first: '$serviceProviderId._id' },
                            name: { $first: '$serviceProviderId.name' },
                            profilePic: { $first: '$serviceProviderId.profilePic' },
                            userName: { $first: '$serviceProviderId.userName' }
                        },
                        category: {
                            _id: { $first: '$serviceId.categoryId._id' },
                            name: { $first: '$serviceId.categoryId.name' },
                            coverPhoto: { $first: '$serviceId.categoryId.coverPhoto' },
                        },
                    }
                },
                {
                    $sort: sortBy(req.query.sort)
                }
            ]);


        if (req.query.serach_customer) {
            const ordersList = [];
            const fuse = new Fuse(orders, customerOptions);

            fuse.search(req.query.serach_customer).forEach(order => {
                ordersList.push(order.item);
            });

            orders = ordersList;
        }

        if (req.query.serach_serviceProvider) {
            const ordersList = [];
            const fuse = new Fuse(orders, serviceProviderOptions);

            fuse.search(req.query.serach_serviceProvider).forEach(order => {
                ordersList.push(order.item);
            });
            orders = ordersList;
        }

        if (orders.length === 0)
            return res.status(200).json({
                status: 'Failed',
                message: 'No Orders With These Specifications'
            });


        res.status(200).json({
            count: orders.length,
            orders: orders
        });


    } catch (err) {
        res.status(500).json({
            message: err.message
        })
    }
};


function sortBy(sortFactor) {
    switch (sortFactor) {
        case 'date_asc':
            return { startsAt: 1 };
        case 'date_desc':
            return { startsAt: -1 };
        case 'price_asc':
            return { price: 1 };
        case 'price_desc':
            return { price: -1 };
        default:
            return { _id: 1 };
    }
}