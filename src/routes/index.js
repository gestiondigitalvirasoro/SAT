const express = require('express');
const router = express.Router();
const pageController = require('../controllers/pageController');

router.get('/', pageController.home);
router.get('/login', pageController.login);
router.get('/faq', pageController.faq);
router.get('/about', pageController.about);

module.exports = router;
