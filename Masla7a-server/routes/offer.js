const express = require('express');
const { addAnOffer, fetchAllOffers } = require('../controllers/offer');
const {extractingToken } = require('../controllers/user-auth');
const multerconfig = require('../images/images-controller/multer')

const router = express.Router();

router.post('/',multerconfig, extractingToken, addAnOffer);
router.get('/', fetchAllOffers);

module.exports = router;