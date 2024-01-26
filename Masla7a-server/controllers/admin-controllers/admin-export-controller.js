const fast_csv = require('fast-csv');
const fs = require('fs');
const path = require('path');


const options = {
    headers: true
};


exports.exportData = async (req, res) => {

    if (req.user.role !== "admin")
        return res.status(403).json({
            message: "you are not allowed to make changes here",
        });


    if (!req.body.data)
        return res.status(400).json({
            status: 'Failed',
            message: 'No Data To Epxort'
        });

    try {

        const fileName =
            filterData(req);
        // `${new Date().getTime()}_${req.user.userName}.csv`;

        if (!fileName)
            return res.status(400).json({
                status: 'Failed',
                message: 'Data Not Supported To Be Exported'
            });

        const filePath = path.join(__dirname, '../../public/dataFiles', fileName);

        fast_csv.writeToPath(filePath, req.body.data, options)
            .on('error', err => {
                fs.unlinkSync(filePath);
                return res.status(500).json({
                    message: err.message
                });
            })
            .on('finish', () => {
                res.header('Content-Type', 'text/csv');
                res.header('Content-Disposition', `attachment; filename=${fileName}`);
                res.status(200).json({
                    status: 'Success',
                    message: 'The Data Exported Successfully'
                });
                fs.unlinkSync(filePath);
            });

    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};



function filterData(req) {
    switch (req.query.endpoint) {
        case 'allCustomers':
        case 'allServiceProviders':
            {
                req.body.data.forEach(user => {
                    delete user._id;
                    delete user.profilePic;
                });

                if (req.query.endpoint('Customers')) {
                    return `customers_${new Date().getTime()}_${req.user.userName}.csv`;
                } else {
                    return `serviceProviders_${new Date().getTime()}_${req.user.userName}.csv`;
                }
            };
        case 'allServices': {
            req.body.data.forEach(service => {
                // service.serviceProviderName = service.serviceProvider.name;
                service.serviceProviderUserName = service.serviceProvider.userName;
                delete service._id;
                delete service.serviceProvider;
            });
            return `services_${new Date().getTime()}_${req.user.userName}.csv`;
        };
        case 'allOrder': {
            req.body.data.forEach((order, index) => {
                // order.serviceProviderName = order.serviceProvider.name;
                order.serviceProviderUserName = order.serviceProvider.userName;
                // order.customerName = order.customer.name;
                order.customerUserName = order.customer.userName;
                order.categoryName = order.category.name;
                delete order._id;
                delete order.serviceProvider;
                delete order.customer;
                delete order.category;
            });
            return `orders_${new Date().getTime()}_${req.user.userName}.csv`;
        };
        case 'customerData': {
            req.body.data.forEach((order, index) => {
                // order.serviceProviderName = order.serviceProvider.name;
                order.serviceProviderUserName = order.serviceProvider.userName;
                delete order._id;
                delete order.serviceProvider;
            });
            return `customer_orders_${new Date().getTime()}_${req.user.userName}.csv`;
        };
        case 'serviceProviderData': {
            req.body.data.forEach((order, index) => {
                // order.customerName = order.customer.name;
                order.customerUserName = order.customer.userName;
                delete order._id;
                delete order.customer;
            });
            return `serviceProvider_orders_${new Date().getTime()}_${req.user.userName}.csv`;
        }
    }
}


// function filterData(req) {
//     switch (req.originalUrl) {
//         case '/admin/control/users/customers/export-data':
//         case '/admin/control/users/service-providers/export-data':
//             {
//                 req.body.data.forEach(user => {
//                     delete user._id;
//                     delete user.profilePic;
//                 });

//                 if (req.originalUrl.includes('customers')) {
//                     return `customers_${new Date().getTime()}_${req.user.userName}.csv`;
//                 } else {
//                     return `serviceProviders_${new Date().getTime()}_${req.user.userName}.csv`;
//                 }
//             };
//         case '/admin/control/categories/services/export-data': {
//             req.body.data.forEach(service => {
//                 // service.serviceProviderName = service.serviceProvider.name;
//                 service.serviceProviderUserName = service.serviceProvider.userName;
//                 delete service._id;
//                 delete service.serviceProvider;
//             });
//             return `services_${new Date().getTime()}_${req.user.userName}.csv`;
//         };
//         case '/admin/control/orders/export-data': {
//             req.body.data.forEach((order, index) => {
//                 // order.serviceProviderName = order.serviceProvider.name;
//                 order.serviceProviderUserName = order.serviceProvider.userName;
//                 // order.customerName = order.customer.name;
//                 order.customerUserName = order.customer.userName;
//                 order.categoryName = order.category.name;
//                 delete order._id;
//                 delete order.serviceProvider;
//                 delete order.customer;
//                 delete order.category;
//             });
//             return `orders_${new Date().getTime()}_${req.user.userName}.csv`;
//         }
//     }
// }