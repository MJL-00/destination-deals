const express = require('express');
const router = express.Router();

const locationController =
    require('../controllers/locationController');

router.get('/',
    locationController.getAllLocations);

router.get('/:city',
    locationController.getBusinessesByLocation);

module.exports = router;