const express = require('express');
const { getRecentOrders, getAllOrders } =
    require('../../controllers/admin-controllers/admin-order-controller');
// const { exportData } = require('../../controllers/admin-controllers/admin-export-controller');



const router = express.Router();


//Path /admin/control/orders/
router.get('/', getAllOrders);

//Path /admin/control/orders/recent-orders
router.get('/recent-orders', getRecentOrders);

//admin/control/orders/export-data
// router.post('/export-data', exportData);



module.exports = router;