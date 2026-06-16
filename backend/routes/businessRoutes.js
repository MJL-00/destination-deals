const express = require('express');
const router = express.Router();
const businessController = require('../controllers/businessController');

// Get all full business data
router.get('/', businessController.getAllBusinesses);

// Lightweight lookup for admin select fields and the POST route
router.get('/lookup', businessController.getBusinessLookup);
router.post('/', businessController.createBusiness);

module.exports = router;