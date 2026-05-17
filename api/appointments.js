const { handleCors, json, readJsonBody } = require('./lib/http');
const { getSupabase } = require('./lib/supabase');

module.exports = async function handler(req, res) {
  if (handleCors(req, res)) return;

  if (req.method !== 'POST') {
    return json(res, 405, { error: 'Method not allowed' });
  }

  try {
    const body = await readJsonBody(req);
    const name = String(body.name || '').trim();
    const phone = String(body.phone || '').trim();
    const email = String(body.email || '').trim();
    const visitAt = body.visitAt || body.visit_at;
    const source = String(body.source || 'app').trim() || 'app';

    if (name.length < 2) return json(res, 400, { error: 'Name is required' });
    if (phone.replace(/\D/g, '').length < 10) return json(res, 400, { error: 'Valid phone is required' });
    if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return json(res, 400, { error: 'Valid email is required' });
    if (!visitAt) return json(res, 400, { error: 'visitAt is required' });

    const supabase = getSupabase();
    const { data, error } = await supabase
      .from('appointments')
      .insert({ name, phone, email, visit_at: visitAt, source })
      .select('id, created_at, name, phone, email, visit_at, source')
      .single();

    if (error) {
      console.error('appointments insert', error);
      return json(res, 500, { error: 'Failed to save appointment' });
    }

    return json(res, 201, { ok: true, appointment: data });
  } catch (e) {
    console.error(e);
    return json(res, 500, { error: 'Server error' });
  }
};
