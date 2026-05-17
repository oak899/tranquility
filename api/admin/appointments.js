const { handleCors, json } = require('../lib/http');
const { requireAdmin } = require('../lib/auth');
const { getSupabase } = require('../lib/supabase');

module.exports = async function handler(req, res) {
  if (handleCors(req, res)) return;

  if (req.method !== 'GET') {
    return json(res, 405, { error: 'Method not allowed' });
  }

  if (!requireAdmin(req, res)) return;

  try {
    const limit = Math.min(parseInt(req.query?.limit || '100', 10) || 100, 500);
    const supabase = getSupabase();
    const { data, error } = await supabase
      .from('appointments')
      .select('id, created_at, name, phone, email, visit_at, source')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) {
      console.error('admin appointments', error);
      return json(res, 500, { error: 'Failed to load appointments' });
    }

    return json(res, 200, { ok: true, appointments: data || [] });
  } catch (e) {
    console.error(e);
    return json(res, 500, { error: 'Server error' });
  }
};
