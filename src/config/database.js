const { createClient } = require('@supabase/supabase-js');
const keys = require('./keys');

const supabase = createClient(keys.supabaseUrl, keys.supabaseKey);

module.exports = supabase;