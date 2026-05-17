const { handleCors, json } = require('../lib/http');
const { requireAdmin } = require('../lib/auth');
const { getSupabase } = require('../lib/supabase');
const { customerSummary } = require('../lib/consultations');
const { listConsultations } = require('../lib/consultationDb');

module.exports = async function handler(req, res) {
  if (handleCors(req, res)) return;

  if (req.method !== 'GET') {
    return json(res, 405, { error: 'Method not allowed' });
  }

  if (!requireAdmin(req, res)) return;

  try {
    const limit = Math.min(parseInt(req.query?.limit || '200', 10) || 200, 500);
    const kind = String(req.query?.kind || '').trim();
    const supabase = getSupabase();
    const { data, error } = await listConsultations(supabase, {
      limit,
      kind: kind === 'facial' || kind === 'head_spa' ? kind : undefined,
    });
    if (error) {
      console.error('tech consultations', error);
      return json(res, 500, { error: 'Failed to load consultations', detail: error.message });
    }
    const clients = (data || []).map(customerSummary);
    return json(res, 200, { ok: true, clients });
  } catch (e) {
    console.error(e);
    return json(res, 500, { error: 'Server error' });
  }
};
