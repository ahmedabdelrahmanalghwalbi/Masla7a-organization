const express = require('express');
const { addingUser, authUser } = require('../controllers/user-auth');
const multerConfig = require("../images/images-controller/multer");
const router = express.Router();


// PATH '/accounts/sign-up'
router.post('/sign-up', multerConfig, addingUser);

//User login............PATH: 'accounts/login
router.post('/login', authUser);


module.exports = router;
