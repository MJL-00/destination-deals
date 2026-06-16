const express = require('express');
const router = express.Router();
const dealController = require('../controllers/dealController');

// Existing Query Routes
router.get('/', dealController.getAllDeals);
router.get('/day/:day', dealController.getDealsByDay);
router.get('/category/:category', dealController.getDealsByCategory);
router.get('/location/:city', dealController.getDealsByLocation);
router.get('/location/:city/category/:category', dealController.getDealsByLocationAndCategory);
router.get('/location/:city/day/:day', dealController.getDealsByLocationAndDay);
router.get('/location/:city/category/:category/day/:day', dealController.getDealsByLocationCategoryAndDay);

// Creating a new deal from the admin portal
router.post('/', dealController.createDeal);

module.exports = router;