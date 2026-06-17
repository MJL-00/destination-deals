const express = require('express');
const router = express.Router();
const dealController = require('../controllers/dealController');

// ── Read routes ───────────────────────────────────────────────
router.get('/',                                          dealController.getAllDealsEnriched);
router.get('/day/:day',                                  dealController.getDealsByDay);
router.get('/category/:category',                        dealController.getDealsByCategory);
router.get('/location/:city',                            dealController.getDealsByLocation);
router.get('/location/:city/category/:category',         dealController.getDealsByLocationAndCategory);
router.get('/location/:city/day/:day',                   dealController.getDealsByLocationAndDay);
router.get('/location/:city/category/:category/day/:day',dealController.getDealsByLocationCategoryAndDay);
router.get('/:id',                                       dealController.getDealById);

// ── Write routes ──────────────────────────────────────────────
router.post('/',                  dealController.createDeal);
router.patch('/:id/active',       dealController.toggleDealActive);
router.delete('/:id',             dealController.deleteDeal);

module.exports = router;