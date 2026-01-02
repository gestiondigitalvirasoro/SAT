const Reports = require('../models/Reports');
const { createClient } = require('@supabase/supabase-js');

let supabase = null;

function getSupabase() {
    if (!supabase) {
        supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY);
    }
    return supabase;
}

exports.list = async (req, res, next) => {
  try {
    const data = await Reports.list();
    res.json(data);
  } catch (err) {
    next(err);
  }
};

exports.create = async (req, res, next) => {
  try {
    const payload = req.body;
    const created = await Reports.create(payload);
    res.status(201).json(created);
  } catch (err) {
    next(err);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const id = req.params.id;
    const item = await Reports.getById(id);
    if (!item) return res.status(404).json({ error: 'Not found' });
    res.json(item);
  } catch (err) { 
    next(err); 
  }
};

exports.update = async (req, res, next) => {
  try {
    const id = req.params.id;
    const payload = req.body;
    const updated = await Reports.update(id, payload);
    res.json(updated);
  } catch (err) { 
    next(err); 
  }
};

// Visitas Formulario
exports.getVisitasFormulario = async (req, res, next) => {
  try {
    const { empresa, desde, hasta } = req.query;
    let query = getSupabase().from('visitas_formulario').select('*');
    
    if (empresa) query = query.eq('empresa_id', empresa);
    if (desde) query = query.gte('fecha', desde);
    if (hasta) query = query.lte('fecha', hasta);
    
    const { data, error } = await query;
    if (error) throw error;
    res.json(data || []);
  } catch (err) {
    next(err);
  }
};

exports.viewVisitasFormulario = async (req, res, next) => {
  try {
    let empresas = [];
    
    try {
      const supabaseClient = getSupabase();
      if (supabaseClient) {
        const { data, error } = await supabaseClient.from('empresas').select('*');
        if (!error && data) {
          empresas = data;
        }
      }
    } catch (dbError) {
      console.log('Database error (using demo mode):', dbError.message);
    }
    
    res.render('pages/visitas-formulario', { 
      empresas: empresas || [], 
      user: req.session.user 
    });
  } catch (error) {
    console.error('Error rendering visitas-formulario:', error);
    res.status(500).render('pages/error', { error: error.message });
  }
};

// Vencimientos Equipos
exports.getVencimientosEquipos = async (req, res, next) => {
  try {
    const { empresa, estado } = req.query;
    let query = getSupabase().from('vencimientos_equipos').select('*');
    
    if (empresa) query = query.eq('empresa_id', empresa);
    
    if (estado) {
      const hoy = new Date().toISOString().split('T')[0];
      if (estado === 'vigente') {
        query = query.gt('proximo_vencimiento', hoy);
      } else if (estado === 'proximo') {
        const hace30dias = new Date(Date.now() - 30*24*60*60*1000).toISOString().split('T')[0];
        query = query.lte('proximo_vencimiento', hoy).gte('proximo_vencimiento', hace30dias);
      } else if (estado === 'vencido') {
        query = query.lt('proximo_vencimiento', hoy);
      }
    }
    
    const { data, error } = await query;
    if (error) throw error;
    res.json(data || []);
  } catch (err) {
    next(err);
  }
};

exports.viewVencimientosEquipos = async (req, res, next) => {
  try {
    let empresas = [];
    
    try {
      const supabaseClient = getSupabase();
      if (supabaseClient) {
        const { data, error } = await supabaseClient.from('empresas').select('*');
        if (!error && data) {
          empresas = data;
        }
      }
    } catch (dbError) {
      console.log('Database error (using demo mode):', dbError.message);
    }
    
    res.render('pages/vencimientos-equipos', { 
      empresas: empresas || [], 
      user: req.session.user 
    });
  } catch (error) {
    console.error('Error rendering vencimientos-equipos:', error);
    res.status(500).render('pages/error', { error: error.message });
  }
};

// Calendario Clientes
exports.getCalendarioClientes = async (req, res, next) => {
  try {
    const { empresa, mes } = req.query;
    let query = getSupabase().from('calendario_eventos').select('*').eq('tipo', 'cliente');
    
    if (empresa) query = query.eq('empresa_id', empresa);
    if (mes) {
      const [año, m] = mes.split('-');
      const desde = `${año}-${m}-01`;
      const hasta = `${año}-${m}-31`;
      query = query.gte('fecha', desde).lte('fecha', hasta);
    }
    
    const { data, error } = await query;
    if (error) throw error;
    res.json(data || []);
  } catch (err) {
    next(err);
  }
};

exports.viewCalendarioClientes = async (req, res, next) => {
  try {
    let empresas = [];
    
    try {
      const supabaseClient = getSupabase();
      if (supabaseClient) {
        const { data, error } = await supabaseClient.from('empresas').select('*');
        if (!error && data) {
          empresas = data;
        }
      }
    } catch (dbError) {
      console.log('Database error (using demo mode):', dbError.message);
    }
    
    res.render('pages/calendario-clientes', { 
      empresas: empresas || [], 
      user: req.session.user 
    });
  } catch (error) {
    console.error('Error rendering calendario-clientes:', error);
    res.status(500).render('pages/error', { error: error.message });
  }
};

// Calendario Servicios
exports.getCalendarioServicios = async (req, res, next) => {
  try {
    const { servicio, mes } = req.query;
    let query = getSupabase().from('calendario_eventos').select('*').eq('tipo', 'servicio');
    
    if (servicio) query = query.eq('descripcion', servicio);
    if (mes) {
      const [año, m] = mes.split('-');
      const desde = `${año}-${m}-01`;
      const hasta = `${año}-${m}-31`;
      query = query.gte('fecha', desde).lte('fecha', hasta);
    }
    
    const { data, error } = await query;
    if (error) throw error;
    res.json(data || []);
  } catch (err) {
    next(err);
  }
};

exports.viewCalendarioServicios = async (req, res, next) => {
  try {
    res.render('pages/calendario-servicios', { user: req.session.user });
  } catch (error) {
    res.status(500).render('pages/error', { error: error.message });
  }
};

// Notificaciones Servicios
exports.getNotificacionesServicios = async (req, res, next) => {
  try {
    const { estado, tipo } = req.query;
    let query = getSupabase().from('notificaciones_servicios').select('*').order('fecha', { ascending: false });
    
    if (estado) query = query.eq('estado', estado);
    if (tipo) query = query.eq('tipo', tipo);
    
    const { data, error } = await query.limit(100);
    if (error) throw error;
    res.json(data || []);
  } catch (err) {
    next(err);
  }
};

exports.viewNotificacionesServicios = async (req, res, next) => {
  try {
    res.render('pages/notificaciones-servicios', { user: req.session.user });
  } catch (error) {
    res.status(500).render('pages/error', { error: error.message });
  }
};

// Crear nueva visita
exports.getVisitasPorMes = async (req, res, next) => {
  try {
    const { mes, anio } = req.query;
    
    if (!mes || !anio) {
      return res.status(400).json({ error: 'mes y anio son requeridos' });
    }

    const sb = getSupabase();
    if (!sb) {
      // En modo demo, retornar fake data con datos que coincidan con la tabla visible
      const visitasDemoData = [
        {
          id: 'VL-29648',
          fecha: '2025-11-26',
          empresa: 'Forestal San Matteo',
          locacion: 'Mainumby',
          profesional: 'Ing. Julio Ernesto Rodríguez, Téc. Héctor Vallejos',
          formulario: 'Visita Libre',
          tarea: 'Asesoramiento profesional, Capacitación, Control de cumplimiento de normativa de higiene y seguridad',
          estado: 'firmado'
        },
        {
          id: 'GE-17116',
          fecha: '2025-11-14',
          empresa: 'Pallets Jauregui',
          locacion: 'Establecimiento J1 - J2',
          profesional: 'Ing. Julio Ernesto Rodríguez, Téc. Héctor Vallejos',
          formulario: 'Visita Simple',
          tarea: 'Asesoramiento profesional, Capacitación, Control de cumplimiento de normativa de higiene y seguridad',
          estado: 'firmado'
        },
        {
          id: 'IL-3812',
          fecha: '2025-11-07',
          empresa: 'Pallets Jauregui',
          locacion: 'Establecimiento J1',
          profesional: 'Ing. Julio Ernesto Rodríguez, Téc. Héctor Vallejos',
          formulario: 'Iluminación',
          tarea: '',
          estado: 'firmado'
        },
        {
          id: 'VL-28329',
          fecha: '2025-11-04',
          empresa: 'DT PRODUCCIÓN Y SERVICIOS',
          locacion: 'BOSQUE DEL PLATA',
          profesional: 'Ing. Julio Ernesto Rodríguez, Téc. Hector Vallejos',
          formulario: 'Visita Libre',
          tarea: 'Asesoramiento profesional, Capacitación, Control de cumplimiento de normativa de higiene y seguridad',
          estado: 'firmado'
        }
      ];
      return res.json(visitasDemoData);
    }

    // En producción, consultar a Supabase filtrado por mes
    const { data, error } = await sb
      .from('visitas_formulario')
      .select('*')
      .gte('fecha', `${anio}-${String(mes).padStart(2, '0')}-01`)
      .lte('fecha', `${anio}-${String(mes).padStart(2, '0')}-31`)
      .order('fecha', { ascending: false });

    if (error) throw error;
    res.json(data || []);
  } catch (err) {
    console.error('Error obteniendo visitas por mes:', err);
    res.status(500).json({ error: 'Error al obtener visitas' });
  }
};

exports.createVisita = async (req, res, next) => {
  try {
    const { empresa_id, locacion_id, tipo_formulario, fecha, observaciones } = req.body;
    
    if (!empresa_id || !tipo_formulario || !fecha) {
      return res.status(400).json({ error: 'Faltan campos requeridos' });
    }

    const sb = getSupabase();
    if (!sb) {
      // En modo demo, retornar fake data
      return res.status(201).json({
        id: 'demo-' + Date.now(),
        empresa_id,
        locacion_id,
        tipo_formulario,
        fecha,
        observaciones,
        estado: 'completado',
        created_at: new Date().toISOString()
      });
    }

    const { data, error } = await sb
      .from('visitas_formulario')
      .insert([{
        empresa_id,
        locacion_id,
        tipo_formulario,
        fecha,
        observaciones,
        estado: 'completado',
        created_at: new Date().toISOString()
      }])
      .select();

    if (error) throw error;
    res.status(201).json(data[0]);
  } catch (err) {
    console.error('Error creando visita:', err);
    res.status(500).json({ error: 'Error al guardar la visita' });
  }
};