const { handleCors, json, readJsonBody } = require('./lib/http');
const { getSupabase } = require('./lib/supabase');
const { isAllowedKind, validatePayload } = require('./lib/consultations');
const { insertConsultation } = require('./lib/consultationDb');

module.exports = async function handler(req, res) {
  if (handleCors(req, res)) return;

  if (req.method !== 'POST') {
    return json(res, 405, { error: 'Method not allowed' });
  }

  try {
    const body = await readJsonBody(req);
    const kind = String(body.kind || '').trim();
    const payload = body.payload && typeof body.payload === 'object' ? body.payload : body.data;
    const source = String(body.source || 'app').trim() || 'app';

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
      console.error('consultations insert', error);
      return json(res, 500, { error: 'Failed to save consultation' });
    }

    return json(res, 201, { ok: true, consultation: data });
  } catch (e) {
    console.error(e);
    return json(res, 500, { error: 'Server error' });
  }
};
