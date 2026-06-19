const express  = require('express');
const router   = express.Router();
const ctrl     = require('../controllers/prospectController');

router.get('/',                  ctrl.getAllProspects);
router.get('/:id/notes',         ctrl.getProspectNotes);
router.post('/',                 ctrl.createProspect);
router.patch('/:id/status',      ctrl.updateStatus);
router.patch('/:id/followup',    ctrl.updateFollowUpDate);
router.put('/:id',               ctrl.updateProspect);
router.post('/:id/notes',        ctrl.addNote);
router.delete('/:id',            ctrl.deleteProspect);

module.exports = router;