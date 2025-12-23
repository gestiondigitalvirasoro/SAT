const express = require('express');
const router = express.Router();
const reportsController = require('../controllers/reportsController');

router.get('/reports', reportsController.list);
router.post('/reports', reportsController.create);
router.get('/reports/:id', reportsController.getById);
router.put('/reports/:id', reportsController.update);

module.exports = router;
