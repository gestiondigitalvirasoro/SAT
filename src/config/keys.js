module.exports = {
  supabaseUrl: process.env.SUPABASE_URL || '',
  supabaseKey: process.env.SUPABASE_ANON_KEY || '',
  port: process.env.PORT || 3000,
  sessionSecret: process.env.SESSION_SECRET || 'change_me'
};
