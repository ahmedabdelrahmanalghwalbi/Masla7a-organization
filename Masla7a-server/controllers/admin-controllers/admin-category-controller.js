const mongoose = require('mongoose');
const _ = require("lodash");
const Fuse = require('fuse.js');
const fs = require("fs");
const cloud = require("../../images/images-controller/cloudinary");
const categoryValidator = require("../../validators/category-validator");
const User = require('../../models/user-model')
const { Notification } = require("../../models/notification");
const Category = require("../../models/category-model");
const Service = require('../../models/service-model');
const Order = require('../../models/order-model');
const { cleanObj } = require('../../utils/filterHelpers')



const options = {
    minMatchCharLength: 1,
    threshold: 0.2,
    keys: [
        'serviceName'
    ]
};


exports.getAllCategories = async (req, res) => {

    if (req.user.role !== 'admin')
        return res.status(403).json({
            message: 'You are not authorized to access this end-point, only admins'
        });

    try {


        {
            // let queryData = {
            //     status: { $in: ['completed', 'pending'] }
            // };
            // let serviceCraetionDateQuery = {}


            // if (req.query.date_from && req.query.date_to) {
            //     if (new Date(req.query.date_from) >= new Date(req.query.date_to))
            //         return res.status(400).json({
            //             message: 'The Start Date is Greater Than The End Date.'
            //         })
            // }

            // const orderDate = {
            //     $gte: !req.query.date_from ?
            //         undefined : new Date(req.query.date_from),
            //     $lte: !req.query.date_to ?
            //         undefined : new Date(req.query.date_to)
            // };

            // cleanObj(orderDate);



            // if (Object.keys(orderDate).length > 0) {
            //     queryData = {
            //         'orderDate': orderDate
            //     };

            //     serviceCraetionDateQuery.serviceCreationDate = orderDate
            // }

            // console.log(serviceCraetionDateQuery)


            // const orders = await Order
            //     .aggregate([
            //         {
            //             $match: queryData
            //         },
            //         {
            //             $lookup: {
            //                 from: 'services',
            //                 localField: 'serviceId',
            //                 foreignField: '_id',
            //                 as: 'serviceId'
            //             }
            //         },
            //         {
            //             $group: {
            //                 _id: { $first: '$serviceId.categoryId' },
            //                 numberOfOrders: {
            //                     $sum: 1
            //                 }
            //             }
            //         }
            //     ]);


            // console.log(orders)


            // const categories = await Category
            //     .aggregate([
            //         {
            //             $unwind: {
            //                 path: '$servicesList',
            //                 preserveNullAndEmptyArrays: true
            //             }
            //         },
            //         {
            //             $lookup: {
            //                 from: 'services',
            //                 localField: 'servicesList',
            //                 foreignField: '_id',
            //                 as: 'servicesList'
            //             }
            //         },
            //         {
            //             $set: {
            //                 serviceCreationDate: {
            //                     $convert: {
            //                         input: { $first: '$servicesList._id' },
            //                         to: 'date'
            //                     }
            //                 }
            //             }
            //         },
            //         {
            //             $match: serviceCraetionDateQuery
            //         },
            //         {
            //             $group: {
            //                 _id: {
            //                     _id: '$_id',
            //                     name: '$name',
            //                     coverPhoto: '$coverPhoto',
            //                     icon: '$icon'
            //                 },
            //                 numberOfServices: {
            //                     $sum: {
            //                         $cond: [
            //                             { $ne: ['$serviceCreationDate', undefined] },
            //                             1,
            //                             0
            //                         ]
            //                     }
            //                 }
            //             }
            //         },
            //         {
            //             $set: {
            //                 orders: {
            //                     $filter: {
            //                         input: orders,
            //                         as: 'order',
            //                         cond: { $eq: ['$$order._id', '$_id._id'] }
            //                     }
            //                 }
            //             }
            //         },
            //         {
            //             $project: {
            //                 _id: '$_id._id',
            //                 name: '$_id.name',
            //                 coverPhoto: '$_id.coverPhoto',
            //                 icon: '$_id.icon',
            //                 numberOfServices: true,
            //                 numberOfOrders: {
            //                     $ifNull: [
            //                         {
            //                             $first: '$orders.numberOfOrders'
            //                         },
            //                         0
            //                     ]
            //                 }
            //             }
            //         },
            //         {
            //             $sort: sortBy(req.query.sort)
            //         }
            //     ]);
        }

        const categories = await Category
            .aggregate([
                {
                    $lookup: {
                        from: 'services',
                        localField: 'servicesList',
                        foreignField: '_id',
                        as: 'servicesList'
                    }
                },
                {
                    $unwind: {
                        path: '$servicesList',
                        preserveNullAndEmptyArrays: true
                    }
                },
                {
                    $set: {
                        serviceCreationDate: {
                            $convert: {
                                input: '$servicesList._id',
                                to: 'date'
                            }
                        }
                    }
                },
                {
                    $group: {
                        _id: {
                            _id: '$_id',
                            name: '$name',
                            coverPhoto: '$coverPhoto',
                            icon: '$icon'
                        },
                        numberOfServices: {
                            $sum: {
                                $cond: [
                                    { $ne: ['$serviceCreationDate', undefined] },
                                    1,
                                    0
                                ]
                            }
                        },
                        numberOfOrders: {
                            $sum: {
                                $size: {
                                    $ifNull: [
                                        '$servicesList.ordersList',
                                        []
                                    ]
                                }
                            }
                        }
                    }
                },
                {
                    $project: {
                        _id: '$_id._id',
                        name: '$_id.name',
                        coverPhoto: '$_id.coverPhoto',
                        icon: '$_id.icon',
                        numberOfServices: true,
                        numberOfOrders: true
                    }
                },
                {
                    $sort: sortBy(req.query.sort)
                }
            ]);

        if (categories.length === 0)
            return res.status(200).json({
                message: 'No Categories Have Orders At This Time'
            });


        res.status(200).json({
            count: categories.length,
            categories: categories
        });

    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};

exports.addCategory = async (req, res) => {
    if (req.user.role !== "admin")
        return res.status(403).json({
            message: "you are not allowed to make changes here",
        });



    const result = categoryValidator.validateCreateCategory(req.body).error;
    if (result)
        return res.status(400).json({ message: result.details[0].message });

    try {
        const category = await new Category({
            name: req.body.name,
            icon: '',
            coverPhoto: ''
        });


        if (req.files) {
            for (var i = 0; i < req.files.length; i++) {
                console.log(req.files[i].fieldname)
                if (req.files[i].fieldname === "icon") {
                    const result = await cloud.uploads(req.files[i].path);
                    category.icon = result.url;
                    fs.unlinkSync(req.files[i].path);
                }
                else if (req.files[i].fieldname === "coverPhoto") {
                    const result = await cloud.uploads(req.files[i].path);
                    category.coverPhoto = result.url;
                    fs.unlinkSync(req.files[i].path);
                }
            }
        }

        await category.save();

        res.status(201).json({
            category: category,
        });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

exports.editCategory = async (req, res) => {
    if (req.user.role !== "admin")
        return res.status(403).json({
            message: "you are not allowed to make changes here",
        });


    if (!mongoose.isValidObjectId(req.params.categoryId))
        return res.status(400).json({
            message: 'The Category ID Is Invalid'
        });


    const result = categoryValidator.validateEditCategory(req.body).error;
    if (result)
        return res.status(400).json({ message: result.details[0].message });


    try {
        const category = await Category
            .findByIdAndUpdate(
                req.params.categoryId,
                { $set: req.body },
                { new: true }
            )
            .select({
                name: true,
                icon: true,
                coverPhoto: true
            });

        if (!category)
            return res.status(400).json({
                message: "The Category You Chose Doesn't Exist",
            });

        if (req.files) {
            for (var i = 0; i < req.files.length; i++) {
                if (req.files[i].fieldname === "icon") {
                    const result = await cloud.uploads(req.files[i].path);
                    category.icon = result.url;
                    fs.unlinkSync(req.files[i].path);
                } else if (req.files[i].fieldname === "coverPhoto") {
                    const result = await cloud.uploads(req.files[i].path);
                    category.coverPhoto = result.url;
                    fs.unlinkSync(req.files[i].path);
                }
            }
        }

        await category.save();

        res.status(201).json({
            category: category,
        });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

exports.deleteCategory = async (req, res) => {
    if (req.user.role !== "admin")
        return res.status(403).json({
            message: "you are not allowed to make changes here",
        });

    if (!mongoose.isValidObjectId(req.params.categoryId))
        return res.status(400).json({
            message: 'The Category ID Is Invalid'
        });

    try {
        const othersCategory = await Category
            .findOne({ name: /.*other.*/i });

        if (!othersCategory)
            return res.status(400).json({
                status: 'Failed',
                message: "The Category 'Others' not Found",
            });

        if (req.params.categoryId === othersCategory._id)
            return res.status(400).json({
                status: 'Failed',
                message: 'You Can not Delete This Category'
            });

        const deletedCategory = await Category
            .findByIdAndDelete(req.params.categoryId);

        if (!deletedCategory)
            return res.status(400).json({
                status: 'Failed',
                message: "The Category You Chose Doesn't Exist",
            });

        deletedCategory.servicesList.forEach(servcieId => {
            const service = Service.findByIdAndUpdate(
                servcieId,
                { $set: { categoryId: othersCategory._id } }
            )
                .then(result => {
                    return result;
                })
                .catch(err => {
                    return res.status(500).json({
                        message: err.message
                    });
                });

            othersCategory.servicesList.push(servcieId);
        });
        //Notifications
        deletedCategory.servicesList.map(async (serviceID) => {
            console.log('Notification')
            const serviceProvider = await User.findOne({serviceId: serviceID});
            const notification = await new Notification({
                title: "Maslaha Admins",
                body: `Maslaha Admins Wants To Inform You That Your Service has been moved to Other Services Category`,
                senderUser: req.user._id,
                targetUsers:  serviceProvider._id,
                subjectType: "Category",
                subject: othersCategory._id,
              })
              await notification.save();
        
            //push firebase notification
            await serviceProvider.user_send_notification(
                notification.toFirebaseNotification()
              );
        });
        await othersCategory.save();

        res.status(201).json({
            status: 'Succeeded',
            message: "Category Deleted Successfully",
        });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

exports.getAllServicesInCategory = async (req, res) => {
    if (req.user.role !== "admin")
        return res.status(403).json({
            message: "you are not allowed to make changes here",
        });

    if (!mongoose.isValidObjectId(req.params.categoryId))
        return res.status(400).json({
            message: 'The Category ID Is Invalid'
        });

    try {

        let queryData = {};

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
        }


        const category = await Category
            .findById(req.params.categoryId);


        if (!category)
            return res.status(200).json({
                message: "The Category You Are Trying To Access Doesn't Exist",
            });


        const orders = await Order
            .aggregate([
                {
                    $match: queryData
                },
                {
                    $group: {
                        _id: '$serviceProviderId',
                        numberOfOrders: {
                            $sum: 1
                        }
                    }
                }
            ]);


        let services = await Service
            .aggregate([
                {
                    $match: {
                        categoryId: mongoose.Types.ObjectId(req.params.categoryId)
                    }
                },
                {
                    $set: {
                        orders: {
                            $filter: {
                                input: orders,
                                as: 'order',
                                cond: { $eq: ['$$order._id', '$serviceProviderId'] }
                            }
                        }
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
                        serviceName: true,
                        averageRating: {
                            $ifNull: ['$averageRating', 0]
                        },
                        numberOfRatings: {
                            $ifNull: ['$numberOfRatings', 0]
                        },
                        numberOfOrders: {
                            $ifNull: [
                                { $first: '$orders.numberOfOrders' },
                                0
                            ]
                        },
                        initialPrice: '$servicePrice',
                        serviceProfit: '$servicePrice',
                        serviceProvider: {
                            _id: { $first: '$serviceProviderId._id' },
                            name: { $first: '$serviceProviderId.name' },
                            profilePic: { $first: '$serviceProviderId.profilePic' },
                            userName: { $first: '$serviceProviderId.userName' }
                        }
                    }
                },
                {
                    $sort: sortBy(req.query.sort)
                }
            ]);


        if (req.query.search) {
            let servicesList = [];
            const fuse = new Fuse(services, options);

            fuse.search(req.query.search).forEach(service => {
                servicesList.push(service.item)
            });

            services = servicesList;
        }


        if (services.length === 0)
            return res.status(200).json({
                message: `The ${category.name} Doesn't Contain Any Service`,
            });

        res.status(200).json({
            servicesCount: services.length,
            services: services,
        });
    } catch (err) {
        res.status(500).json({
            errorMessage: err.message,
        });
    }
};

exports.getTopCategories = async (req, res) => {

    if (req.user.role !== 'admin')
        return res.status(403).json({
            message: 'You are not authorized to access this end-point, only admins'
        });

    try {

        let queryData = {};

        if (req.query.date_from && req.query.date_to) {
            if (new Date(req.query.date_from) >= new Date(req.query.date_to))
                return res.status(400).json({
                    message: 'The Start Date is Greater Than The End Date.'
                })
        }

        const orderDate = {
            $gte: !req.query.date_from ?
                undefined : new Date(req.query.date_from),
            $lte: !req.query.date_to ?
                undefined : new Date(req.query.date_to)
        };

        cleanObj(orderDate);


        if (Object.keys(orderDate).length > 0) {
            queryData = {
                'orderDate': orderDate
            }
        }

        const orders = await Order
            .aggregate([
                {
                    $match: queryData
                },
                {
                    $lookup: {
                        from: 'services',
                        localField: 'serviceId',
                        foreignField: '_id',
                        as: 'serviceId'
                    }
                },
                {
                    $group: {
                        _id: { $first: '$serviceId.categoryId' },
                        numberOfOrders: {
                            $sum: 1
                        }
                    }
                }
            ]);


        const categories = await Category
            .aggregate([
                {
                    $set: {
                        orders: {
                            $filter: {
                                input: orders,
                                as: 'order',
                                cond: { $eq: ['$$order._id', '$_id'] }
                            }
                        }
                    }
                },
                {
                    $project: {
                        _id: '$_id',
                        name: '$name',
                        coverPhoto: '$coverPhoto',
                        icon: '$icon',
                        numberOfServices: true,
                        numberOfOrders: {
                            $ifNull: [
                                {
                                    $first: '$orders.numberOfOrders'
                                },
                                0
                            ]
                        }
                    }
                },
                {
                    $sort: {
                        numberOfOrders: -1
                    }
                }
            ]);


        if (categories.length === 0)
            return res.status(200).json({
                message: 'No Categories Have Orders At This Time'
            });



        res.status(200).json({
            count: categories.length,
            categories: categories
        });

    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};



function sortBy(sortFactor) {
    switch (sortFactor) {
        case 'name_asc':
            return { name: 1 };
        case 'name_desc':
            return { name: -1 };
        case 'orders_asc':
            return { numberOfOrders: 1 };
        case 'orders_desc':
            return { numberOfOrders: -1 };
        case 'rating_asc':
            return { averageRating: 1 };
        case 'rating_desc':
            return { averageRating: -1 };
        case 'services_asc':
            return { numberOfServices: 1 };
        case 'services_desc':
            return { numberOfServices: -1 };
        default:
            return { _id: 1 };
    }
}

// {
//     // to delete services with no servie providers
//     async function deleteUnUsedService(service_id, categoryId) {
//         // const service = await Service.findByIdAndDelete(service_id)

//         const category = await Category.findById(categoryId).populate();
//         console.log(category.servicesList.length)
//         const index = category.servicesList.indexOf(service_id);
//         if (index > -1) {
//             category.servicesList.splice(index, 1);
//         }
//         console.log(category.servicesList.length)
//         await category.save();

//     };

//     deleteUnUsedService('60fcfd970a64329841965345', '60f599b8b97f2e96fce9a590');
// }