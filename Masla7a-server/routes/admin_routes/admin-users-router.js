const express = require('express');

const {
    deleteUser,
    getNewUswes,
    getActiveCustomers,
    getAllUsersRole,
    getTopServiceProviders,
    getAllCustomers,
    getAllServiceProviders,
    getCustomer,
    getServiceProvider } =
    require('../../controllers/admin-controllers/admin-users-controller');
// const { exportData } = require('../../controllers/admin-controllers/admin-export-controller');


const router = express.Router();


// //Path /admin/control/users/user/:id
//router.get('/user/:id', getUser);

//Path /admin/control/users/delete/:id
router.delete('/user/delete/:id', deleteUser);


//          General User Routes

//Path /admin/control/users/new-users
router.get('/new-users', getNewUswes);

//Path /admin/control/users/total-users-roles
router.get('/total-users-roles', getAllUsersRole);


//          Customers Routes

//Path /admin/control/users/customers
router.get('/customers', getAllCustomers);

// //Path /admin/control/users/customers/:customerId
router.get('/customers/:customerId', getCustomer);

//Path /admin/control/users/active-customers
router.get('/active-customers', getActiveCustomers);

//admin/control/users/customers/export-data
// router.post('/customers/export-data', exportData);


//          Service Providers Routes

//Path /admin/control/users/service-providers
router.get('/service-providers', getAllServiceProviders);

// //Path /admin/control/users/service-providers/:serviceProviderId
router.get('/service-providers/:serviceProviderId', getServiceProvider);

//Path /admin/control/users/top-service-providers
router.get('/top-service-providers', getTopServiceProviders);

//admin/control/users/service-providers/export-data
// router.post('/service-providers/export-data', exportData);


module.exports = router;