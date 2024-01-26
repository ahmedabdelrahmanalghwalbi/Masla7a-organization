const express = require('express');
const { getUserOrders,
    getOrder,
    createOrder,
    // confirmOrder,
    canceleOrder,
    completeOrder,
    discardOrder } = require('../controllers/order-controller');
const { extractingToken } = require('../controllers/user-auth');


const router = express.Router();


router.get('/', extractingToken, getUserOrders);

router.get('/:orderId', extractingToken, getOrder);

router.post('/create-order', extractingToken, createOrder);

router.delete('/discard-order/:orderId', extractingToken, discardOrder);

// router.post('/confirm-order', extractingToken, confirmOrder);

router.put('/complete-order/:orderId', completeOrder);

router.put('/cancele-order/:orderId', extractingToken, canceleOrder);

module.exports = router;