const express = require('express');
const {postRequest} = require('../controllers/request');
const { extractingToken } = require('../controllers/user-auth');
const router = express.Router();

//Post A Request      PATH /request/ 
router.post('/:id', extractingToken, postRequest);

module.exports = router;



