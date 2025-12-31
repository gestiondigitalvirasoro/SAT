const express = require('express');
const router = express.Router();
const pageController = require('../controllers/pageController');
const AuthController = require('../controllers/authController');
const planesAccionController = require('../controllers/planesAccionController');
const reportsController = require('../controllers/reportsController');

// Middleware de autenticación
const requireAuth = (req, res, next) => {
  if (!req.session || !req.session.user) {
    return res.redirect('/login');
  }
  next();
};

router.get('/', pageController.home);
router.get('/login', AuthController.renderLogin);
router.get('/dashboard', AuthController.renderDashboard);
router.get('/faq', pageController.faq);
router.get('/about', pageController.about);

// Rutas protegidas de reportes
router.get('/reports/planes-accion', requireAuth, planesAccionController.viewPlanesAccion);
router.get('/reports/visitas-formulario', requireAuth, reportsController.viewVisitasFormulario);
router.get('/reports/vencimientos-equipos', requireAuth, reportsController.viewVencimientosEquipos);
router.get('/reports/calendario-clientes', requireAuth, reportsController.viewCalendarioClientes);
router.get('/reports/calendario-servicios', requireAuth, reportsController.viewCalendarioServicios);
router.get('/reports/notificaciones-servicios', requireAuth, reportsController.viewNotificacionesServicios);

module.exports = router;
