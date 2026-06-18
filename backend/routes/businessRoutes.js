const express = require('express');
const router  = express.Router();
const businessController = require('../controllers/businessController');

router.get('/',                   businessController.getAllBusinesses);
router.get('/lookup',             businessController.getBusinessLookup);
router.get('/:id',                businessController.getBusinessById);
router.post('/',                  businessController.createBusiness);
router.put('/:id',                businessController.updateBusiness);
router.patch('/:id/verify',       businessController.verifyBusiness);
router.post('/:id/website-click',    businessController.incrementWebsiteClick);
router.post('/:id/directions-click', businessController.incrementDirectionsClick);
router.delete('/:id',             businessController.deleteBusiness);

module.exports = router;