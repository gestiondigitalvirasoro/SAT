const supabase = require('../config/database');

const TABLE = 'reports';

module.exports = {
  // List all reports
  async list() {
    const { data, error } = await supabase.from(TABLE).select('*').order('created_at', { ascending: false });
    if (error) throw error;
    return data;
  },

  async create(payload) {
    const { data, error } = await supabase.from(TABLE).insert([payload]).select().single();
    if (error) throw error;
    return data;
  },

  async getById(id) {
    const { data, error } = await supabase.from(TABLE).select('*').eq('id', id).maybeSingle();
    if (error) throw error;
    return data;
  },

  async update(id, payload) {
    const { data, error } = await supabase.from(TABLE).update(payload).eq('id', id).select().single();
    if (error) throw error;
    return data;
  }
};

