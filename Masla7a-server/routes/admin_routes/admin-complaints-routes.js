const express = require('express');
const { getComplaints } =
    require('../../controllers/admin-controllers/admin-complaints-controller');


const router = express.Router();


router.get('/', getComplaints);


module.exports = router;