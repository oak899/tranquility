const { handleCors, json, readJsonBody } = require('../lib/http');
const { requireAdmin } = require('../lib/auth');
const { getSupabase } = require('../lib/supabase');
const { isAllowedKind, validatePayload } = require('../lib/consultations');
const { listConsultations, insertConsultation } = require('../lib/consultationDb');

module.exports = async function handler(req, res) {
  if (handleCors(req, res)) return;
  if (!requireAdmin(req, res)) return;

  if (req.method === 'GET') {
    try {
      const limit = Math.min(parseInt(req.query?.limit || '200', 10) || 200, 500);
      const supabase = getSupabase();
      const { data, error } = await listConsultations(supabase, { limit });
      if (error) {
        console.error('admin consultations list', error);
        return json(res, 500, {
          error: 'Failed to load consultations',
          detail: error.message,
        });
      }
      return json(res, 200, { ok: true, consultations: data || [] });
    } catch (e) {
      console.error(e);
      return json(res, 500, { error: 'Server error' });
    }
  }

  if (req.method === 'POST') {
    try {
      const body = await readJsonBody(req);
      const kind = String(body.kind || '').trim();
      const payload = body.payload && typeof body.payload === 'object' ? body.payload : body.data;
      const source = String(body.source || 'admin').trim() || 'admin';

      if (!isAllowedKind(kind)) {
        return json(res, 400, { error: 'kind must be facial or head_spa' });
      }
      const validated = validatePayload(payload);
      if (!validated.ok) return json(res, 400, { error: validated.error });

      const supabase = getSupabase();
      const { data, error } = await insertConsultation(supabase, {
        kind,
        payload: validated.payload,
        source,
      });

      if (error) {
        console.error('admin consultations create', error);
        return json(res, 500, { error: 'Failed to create consultation', detail: error.message });
      }
      return json(res, 201, { ok: true, consultation: data });
    } catch (e) {
      console.error(e);
      return json(res, 500, { error: 'Server error' });
    }
  }

  return json(res, 405, { error: 'Method not allowed' });
};
