const ALLOWED_KINDS = new Set(['facial', 'head_spa']);
const STATUS_ACTIVE = 'active';
const STATUS_DELETED = 'deleted';

function isAllowedKind(kind) {
  return ALLOWED_KINDS.has(kind);
}

function normalizePayload(payload) {
  if (!payload || typeof payload !== 'object' || Array.isArray(payload)) {
    return null;
  }
  return payload;
}

function validatePayload(payload) {
  const p = normalizePayload(payload);
  if (!p) return { ok: false, error: 'payload object is required' };
  const name = String(p.name || '').trim();
  if (name.length < 2) return { ok: false, error: 'Client name is required (min 2 characters)' };
  return { ok: true, payload: p };
}

function activeOnlyFilter(query) {
  return query.or('status.eq.active,status.is.null');
}

function customerSummary(row) {
  const p = row.payload || {};
  const services = Array.isArray(p.services) ? p.services : [];
  const addons = Array.isArray(p.addons) ? p.addons : [];
  const alerts = [];
  if (p.q9_allergies === 'yes') {
    alerts.push(p.q9_specify ? `Allergies: ${p.q9_specify}` : 'Allergies reported');
  }
  if (p.q10_pregnancyOrUnder18 === 'yes') {
    alerts.push('Pregnancy or under 18');
  }
  if (Array.isArray(p.conditions) && p.conditions.length) {
    alerts.push(`Conditions: ${p.conditions.join(', ')}`);
  }
  if (p.conditionsOther) {
    alerts.push(`Conditions (other): ${p.conditionsOther}`);
  }
  return {
    id: row.id,
    kind: row.kind,
    created_at: row.created_at,
    name: String(p.name || '').trim(),
    phone: String(p.phone || '').trim(),
    email: String(p.email || '').trim(),
    serviceDate: p.serviceDate || null,
    services,
    addons,
    alerts,
  };
}

function mergePayload(existing, patch) {
  const base = existing && typeof existing === 'object' ? { ...existing } : {};
  const next = patch && typeof patch === 'object' ? { ...base, ...patch } : base;
  return next;
}

module.exports = {
  ALLOWED_KINDS,
  STATUS_ACTIVE,
  STATUS_DELETED,
  isAllowedKind,
  normalizePayload,
  validatePayload,
  activeOnlyFilter,
  customerSummary,
  mergePayload,
};
