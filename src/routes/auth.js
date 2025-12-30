const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/authController');

// Rutas de autenticación
router.get('/login', AuthController.renderLogin);
router.post('/login', AuthController.login);
router.post('/register', AuthController.register);
router.post('/logout', AuthController.logout);
router.get('/dashboard', AuthController.renderDashboard);

module.exports = router;

module.exports = router;