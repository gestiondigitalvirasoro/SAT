const express = require('express');
const router = express.Router();
const reportsController = require('../controllers/reportsController');
const planesAccionController = require('../controllers/planesAccionController');

router.get('/reports', reportsController.list);
router.post('/reports', reportsController.create);
router.get('/reports/:id', reportsController.getById);
router.put('/reports/:id', reportsController.update);

// Planes de Acción
router.get('/planes-accion', planesAccionController.getPlanesAccion);
router.get('/empresas', planesAccionController.getEmpresas);
router.get('/locaciones', planesAccionController.getLocaciones);

// Crear nuevas empresas
router.post('/empresas', planesAccionController.createEmpresa);

// Visitas por Formulario
router.get('/visitas-formulario', reportsController.getVisitasFormulario);

// Crear nueva visita
router.post('/visitas', reportsController.createVisita);

// Vencimientos de Equipos
router.get('/vencimientos-equipos', reportsController.getVencimientosEquipos);

// Calendario de Clientes
router.get('/calendario-clientes', reportsController.getCalendarioClientes);

// Calendario de Servicios
router.get('/calendario-servicios', reportsController.getCalendarioServicios);

// Notificaciones de Servicios
router.get('/notificaciones-servicios', reportsController.getNotificacionesServicios);

module.exports = router;
