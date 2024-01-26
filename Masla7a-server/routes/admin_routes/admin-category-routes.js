const express = require('express');
const { getAllCategories,
    getAllServicesInCategory,
    addCategory,
    editCategory,
    deleteCategory,
    getTopCategories } =
    require('../../controllers/admin-controllers/admin-category-controller');
const multerConfig = require("../../images/images-controller/multer");
// const { exportData } = require('../../controllers/admin-controllers/admin-export-controller');


const router = express.Router();


router.get('/', getAllCategories);

router.get('/top-categories', getTopCategories);

router.get('/:categoryId', getAllServicesInCategory);

router.post('/add-category', multerConfig, addCategory);

router.post('/edit-category/:categoryId', multerConfig, editCategory);

router.get('/delete-category/:categoryId', deleteCategory);

//admin/control/categories/export-data
// router.post('/services/export-data', exportData);

module.exports = router;