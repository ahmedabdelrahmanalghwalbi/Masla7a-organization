const express = require('express');
const { extractingToken } = require('../controllers/user-auth');
const adminUserRouter = require('./admin_routes/admin-users-router');
const adminCategoryRouter = require('./admin_routes/admin-category-routes');
const adminOrdersRouter = require('./admin_routes/admin-orders-routes');
const adminAuthRouter = require('./admin_routes/admin-auth-routes');
const adminComplaintsRouter = require('./admin_routes/admin-complaints-routes');
const { exportData } = require('../controllers/admin-controllers/admin-export-controller');



const router = express.Router();




//admin/control/admins
router.use('/admins', adminAuthRouter);


router.use(extractingToken);

//admin user routes /admin/control/users
router.use('/users', adminUserRouter)

//admin category routes /admin/control/categories
router.use('/categories', adminCategoryRouter);

//admin/control/orders
router.use('/orders', adminOrdersRouter);

//admin/control/complaints
router.use('/complaints', adminComplaintsRouter);

//admin/control/export-data
router.post('/export-data', exportData);





module.exports = router;
