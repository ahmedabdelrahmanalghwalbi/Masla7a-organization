const express = require('express');
const {
    addingAdmin,
    loginAdmin } = require('../../controllers/admin-controllers/admin-auth');

const { extractingToken } = require('../../controllers/user-auth');


const router = express.Router();

//Path /admin/control/admins/add-admin
router.post('/add-admin', extractingToken, addingAdmin);

//Path /admin/control/admins/admin-login
router.post('/admin-login', loginAdmin);


module.exports = router;