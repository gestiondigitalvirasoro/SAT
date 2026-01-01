const { supabase, isDemoMode } = require('../config/database');

// Obtener todos los planes de acción con filtros
async function getPlanesAccion(req, res) {
    try {
        if (!supabase) {
            return res.json([]);
        }

        const { empresa_id, locacion_id, fecha_desde, fecha_hasta, estado } = req.query;

        let query = supabase
            .from('planes_accion')
            .select(`
                *,
                empresa:empresa_id(id, nombre),
                locacion:locacion_id(id, nombre)
            `);

        if (empresa_id) query = query.eq('empresa_id', empresa_id);
        if (locacion_id) query = query.eq('locacion_id', locacion_id);
        if (estado) query = query.eq('estado', estado);
        
        if (fecha_desde) {
            query = query.gte('fecha', fecha_desde);
        }
        if (fecha_hasta) {
            query = query.lte('fecha', fecha_hasta);
        }

        const { data, error } = await query.order('fecha', { ascending: false });

        if (error) throw error;

        res.json(data || []);
    } catch (error) {
        console.error('Error:', error);
        res.json([]); // Return empty array on error instead of error response
    }
}

// Obtener empresas
async function getEmpresas(req, res) {
    try {
        if (!supabase) {
            return res.json([]);
        }

        const { data, error } = await supabase
            .from('empresas')
            .select('*')
            .order('nombre');

        if (error) throw error;
        res.json(data || []);
    } catch (error) {
        console.error('Error:', error);
        res.json([]); // Return empty array on error
    }
}

// Obtener locaciones
async function getLocaciones(req, res) {
    try {
        if (!supabase) {
            return res.json([]);
        }

        const { data, error } = await supabase
            .from('locaciones')
            .select('*')
            .order('nombre');

        if (error) throw error;
        res.json(data || []);
    } catch (error) {
        console.error('Error:', error);
        res.json([]); // Return empty array on error
    }
}

// Ver página de planes de acción
async function viewPlanesAccion(req, res) {
    try {
        res.render('pages/planes-accion', {
            user: req.session.user
        });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).render('pages/error', { error: error.message });
    }
}

// Crear nueva empresa
async function createEmpresa(req, res) {
    try {
        const { nombre, rubro, contacto, telefono, email, direccion, cuit } = req.body;

        if (!nombre) {
            return res.status(400).json({ error: 'El nombre de la empresa es requerido' });
        }

        if (!supabase) {
            // En modo demo, retornar fake data
            return res.status(201).json({
                id: 'demo-' + Date.now(),
                nombre,
                rubro,
                contacto,
                telefono,
                email,
                direccion,
                cuit,
                created_at: new Date().toISOString()
            });
        }

        const { data, error } = await supabase
            .from('empresas')
            .insert([{
                nombre,
                rubro,
                contacto,
                telefono,
                email,
                direccion,
                cuit,
                created_at: new Date().toISOString()
            }])
            .select();

        if (error) throw error;
        
        res.status(201).json(data[0]);
    } catch (error) {
        console.error('Error creando empresa:', error);
        res.status(500).json({ error: 'Error al guardar la empresa' });
    }
}

module.exports = {
    getPlanesAccion,
    getEmpresas,
    getLocaciones,
    viewPlanesAccion,
    createEmpresa
};
