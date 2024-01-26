const express = require('express');
const { getFavourites,
    addToFavourites,
    removeFromFavourites } = require('../controllers/favourites-controller');

const { extractingToken } = require('../controllers/user-auth')


const router = express.Router();


router.use(extractingToken);

router.get('/', getFavourites);

router.post('/add-favourite', addToFavourites);

router.get('/remove-favourite/:serviceProviderId', removeFromFavourites);


module.exports = router;