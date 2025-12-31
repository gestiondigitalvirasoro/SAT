const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

let supabase = null;
let isDemoMode = false;

// Verificar si las credenciales de Supabase están configuradas
if (!supabaseUrl || !supabaseKey || 
    supabaseUrl === 'your_supabase_url_here' || 
    supabaseKey === 'your_supabase_anon_key_here') {
  console.log('⚠️  Supabase no configurado - usando modo demo');
  console.log('📖 Lee SETUP_SUPABASE.md para configurar la base de datos real');
  isDemoMode = true;
} else {
  try {
    supabase = createClient(supabaseUrl, supabaseKey);
    console.log('✅ Supabase conectado correctamente');
  } catch (error) {
    console.error('❌ Error al conectar con Supabase:', error.message);
    isDemoMode = true;
  }
}

module.exports = {
  supabase,
  isDemoMode
};