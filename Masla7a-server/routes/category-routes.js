const express = require('express');
const { getAllCategories } = require('../controllers/category-controller');
const { filterServices } = require('../controllers/serviceProvider-controller');


const router = express.Router();


router.get('/', getAllCategories);

router.get('/:categoryId', filterServices);

module.exports = router;