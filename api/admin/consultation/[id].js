const { handleCors, json, readJsonBody } = require('../../lib/http');
const { requireAdmin } = require('../../lib/auth');
const { getSupabase } = require('../../lib/supabase');
const {
  isAllowedKind,
  validatePayload,
  mergePayload,
  STATUS_DELETED,
} = require('../../lib/consultations');
const {
  getConsultationById,
  updateConsultation,
  softDeleteConsultation,
} = require('../../lib/consultationDb');

module.exports = async function handler(req, res) {
  if (handleCors(req, res)) return;
  if (!requireAdmin(req, res)) return;

  const id = String(req.query?.id || '').trim();
  if (!id) return json(res, 400, { error: 'Consultation id is required' });

  const supabase = getSupabase();

  if (req.method === 'PATCH') {
    try {
      const body = await readJsonBody(req);
      const { data: existing, error: fetchErr } = await getConsultationById(supabase, id);

      if (fetchErr) {
        console.error('consultation fetch', fetchErr);
        return json(res, 500, { error: 'Failed to load consultation', detail: fetchErr.message });
      }
      if (!existing) return json(res, 404, { error: 'Consultation not found' });
      if (existing.status === STATUS_DELETED) {
        return json(res, 410, { error: 'Consultation was deleted' });
      }

      const kind = body.kind != null ? String(body.kind).trim() : existing.kind;
      if (!isAllowedKind(kind)) {
        return json(res, 400, { error: 'kind must be facial or head_spa' });
      }

      const mergedPayload = mergePayload(
        existing.payload,
        body.payload && typeof body.payload === 'object' ? body.payload : {}
      );
      const validated = validatePayload(mergedPayload);
      if (!validated.ok) return json(res, 400, { error: validated.error });

      const patch = { kind, payload: validated.payload };
      if (body.source != null) {
        patch.source = String(body.source).trim() || existing.source;
      }

      const { data, error } = await updateConsultation(supabase, id, patch);

      if (error) {
        console.error('consultation update', error);
        return json(res, 500, { error: 'Failed to update consultation', detail: error.message });
      }
      return json(res, 200, { ok: true, consultation: data });
    } catch (e) {
      console.error(e);
      return json(res, 500, { error: 'Server error' });
    }
  }

  if (req.method === 'DELETE') {
    try {
      const { data, error } = await softDeleteConsultation(supabase, id);

      if (error) {
        console.error('consultation soft delete', error);
        const msg = error.message || 'Failed to delete consultation';
        return json(res, 500, { error: msg });
      }
      if (!data) return json(res, 404, { error: 'Consultation not found' });
      return json(res, 200, { ok: true, id: data.id, status: data.status });
    } catch (e) {
      console.error(e);
      return json(res, 500, { error: 'Server error' });
    }
  }

  return json(res, 405, { error: 'Method not allowed' });
};
