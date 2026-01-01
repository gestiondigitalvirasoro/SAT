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

// Rutas de formularios para crear nuevos registros
router.get('/visitas', requireAuth, (req, res) => {
  res.render('layouts/dashboard', { 
    title: 'Visitas - POTENCIA ACTIVA',
    page: '../pages/visitas',
    user: req.session.user
  });
});

router.get('/nueva-visita', requireAuth, (req, res) => {
  res.render('layouts/dashboard', { 
    title: 'Nueva Visita - POTENCIA ACTIVA',
    page: '../pages/nueva-visita',
    user: req.session.user
  });
});

router.get('/nueva-empresa', requireAuth, (req, res) => {
  res.render('layouts/dashboard', { 
    title: 'Nueva Empresa - POTENCIA ACTIVA',
    page: '../pages/nueva-empresa',
    user: req.session.user
  });
});

// Rutas protegidas de reportes
router.get('/reports/planes-accion', requireAuth, planesAccionController.viewPlanesAccion);
router.get('/reports/visitas-formulario', requireAuth, reportsController.viewVisitasFormulario);
router.get('/reports/vencimientos-equipos', requireAuth, reportsController.viewVencimientosEquipos);
router.get('/reports/calendario-clientes', requireAuth, reportsController.viewCalendarioClientes);
router.get('/reports/calendario-servicios', requireAuth, reportsController.viewCalendarioServicios);
router.get('/reports/notificaciones-servicios', requireAuth, reportsController.viewNotificacionesServicios);

// Rutas públicas de reportes (sin autenticación)
router.get('/public/reports/planes-accion', planesAccionController.viewPlanesAccion);
router.get('/public/reports/visitas-formulario', reportsController.viewVisitasFormulario);
router.get('/public/reports/vencimientos-equipos', reportsController.viewVencimientosEquipos);
router.get('/public/reports/calendario-clientes', reportsController.viewCalendarioClientes);
router.get('/public/reports/calendario-servicios', reportsController.viewCalendarioServicios);
router.get('/public/reports/notificaciones-servicios', reportsController.viewNotificacionesServicios);

module.exports = router;
