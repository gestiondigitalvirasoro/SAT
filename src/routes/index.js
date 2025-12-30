const express = require('express');
const router = express.Router();
const pageController = require('../controllers/pageController');
const AuthController = require('../controllers/authController');
const planesAccionController = require('../controllers/planesAccionController');
const reportsController = require('../controllers/reportsController');

router.get('/', pageController.home);
router.get('/login', AuthController.renderLogin);
router.get('/dashboard', AuthController.renderDashboard);
router.get('/faq', pageController.faq);
router.get('/about', pageController.about);
router.get('/reports/planes-accion', planesAccionController.viewPlanesAccion);
router.get('/reports/visitas-formulario', reportsController.viewVisitasFormulario);
router.get('/reports/vencimientos-equipos', reportsController.viewVencimientosEquipos);
router.get('/reports/calendario-clientes', reportsController.viewCalendarioClientes);
router.get('/reports/calendario-servicios', reportsController.viewCalendarioServicios);
router.get('/reports/notificaciones-servicios', reportsController.viewNotificacionesServicios);

module.exports = router;
