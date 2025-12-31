const { supabase, isDemoMode } = require('../config/database');

// Obtener todos los planes de acción con filtros
async function getPlanesAccion(req, res) {
    try {
        // Demo mode: return empty array
        if (isDemoMode || !supabase) {
            return res.json([]);
        }

        const { empresa_id, locacion_id, fecha_desde, fecha_hasta, estado } = req.query;

        let query = supabase
            .from('planes_accion')
            .select(`
                *,
                empresa:empresas(id, nombre),
                locacion:locaciones(id, nombre)
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
        res.status(500).json({ error: error.message });
    }
}

// Obtener empresas
async function getEmpresas(req, res) {
    try {
        // Demo mode: return empty array
        if (isDemoMode || !supabase) {
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
        res.status(500).json({ error: error.message });
    }
}

// Obtener locaciones
async function getLocaciones(req, res) {
    try {
        // Demo mode: return empty array
        if (isDemoMode || !supabase) {
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
        res.status(500).json({ error: error.message });
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

module.exports = {
    getPlanesAccion,
    getEmpresas,
    getLocaciones,
    viewPlanesAccion
};
