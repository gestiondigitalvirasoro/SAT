const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

// Verificar si las credenciales de Supabase están configuradas
if (!supabaseUrl || !supabaseKey || 
    supabaseUrl === 'your_supabase_url_here' || 
    supabaseKey === 'your_supabase_anon_key_here') {
  console.log('⚠️  Supabase no configurado - usando modo demo');
  console.log('📖 Lee SETUP_SUPABASE.md para configurar la base de datos real');
  module.exports = null; // Sin conexión real a Supabase
} else {
  try {
    const supabase = createClient(supabaseUrl, supabaseKey);
    console.log('✅ Supabase conectado correctamente');
    module.exports = supabase;
  } catch (error) {
    console.error('❌ Error al conectar con Supabase:', error.message);
    module.exports = null;
  }
}