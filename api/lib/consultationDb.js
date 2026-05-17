const { STATUS_ACTIVE, STATUS_DELETED } = require('./consultations');

const SELECT_FULL = 'id, created_at, updated_at, kind, payload, source, status';
const SELECT_BASE = 'id, created_at, kind, payload, source';

function isMissingColumnError(error) {
  const msg = String(error?.message || error?.details || '').toLowerCase();
  return (
    error?.code === '42703' ||
    msg.includes('does not exist') ||
    (msg.includes('column') && msg.includes('status')) ||
    (msg.includes('column') && msg.includes('updated_at'))
  );
}

function filterActiveRows(rows) {
  return (rows || []).filter(function (row) {
    return !row.status || row.status === STATUS_ACTIVE;
  });
}

async function listConsultations(supabase, { limit = 200, kind } = {}) {
  const cap = Math.min(limit, 500);
  let query = supabase
    .from('consultations')
    .select(SELECT_FULL)
    .order('created_at', { ascending: false })
    .limit(cap);

  if (kind === 'facial' || kind === 'head_spa') {
    query = query.eq('kind', kind);
  }

  let { data, error } = await query;

  if (error && isMissingColumnError(error)) {
    let legacy = supabase
      .from('consultations')
      .select(SELECT_BASE)
      .order('created_at', { ascending: false })
      .limit(cap);
    if (kind === 'facial' || kind === 'head_spa') {
      legacy = legacy.eq('kind', kind);
    }
    ({ data, error } = await legacy);
  }

  if (error) return { data: null, error };
  return { data: filterActiveRows(data), error: null };
}

async function getConsultationById(supabase, id) {
  let { data, error } = await supabase
    .from('consultations')
    .select(SELECT_FULL)
    .eq('id', id)
    .maybeSingle();

  if (error && isMissingColumnError(error)) {
    ({ data, error } = await supabase
      .from('consultations')
      .select(SELECT_BASE)
      .eq('id', id)
      .maybeSingle());
  }

  return { data, error };
}

async function insertConsultation(supabase, row) {
  const fullRow = { ...row, status: row.status || STATUS_ACTIVE };
  let { data, error } = await supabase
    .from('consultations')
    .insert(fullRow)
    .select(SELECT_FULL)
    .single();

  if (error && isMissingColumnError(error)) {
    const { status, updated_at, ...legacyRow } = fullRow;
    ({ data, error } = await supabase
      .from('consultations')
      .insert(legacyRow)
      .select(SELECT_BASE)
      .single());
  }

  return { data, error };
}

async function updateConsultation(supabase, id, patch) {
  const fullPatch = {
    ...patch,
    updated_at: patch.updated_at || new Date().toISOString(),
  };

  let { data, error } = await supabase
    .from('consultations')
    .update(fullPatch)
    .eq('id', id)
    .select(SELECT_FULL)
    .single();

  if (error && isMissingColumnError(error)) {
    const { updated_at, status, ...legacyPatch } = fullPatch;
    ({ data, error } = await supabase
      .from('consultations')
      .update(legacyPatch)
      .eq('id', id)
      .select(SELECT_BASE)
      .single());
  }

  return { data, error };
}

async function softDeleteConsultation(supabase, id) {
  let { data, error } = await supabase
    .from('consultations')
    .update({
      status: STATUS_DELETED,
      updated_at: new Date().toISOString(),
    })
    .eq('id', id)
    .select('id, status')
    .maybeSingle();

  if (error && isMissingColumnError(error)) {
    return {
      data: null,
      error: {
        message:
          'Soft delete requires the status column. Run supabase/migrations/002_consultation_status.sql in Supabase.',
      },
    };
  }

  return { data, error };
}

module.exports = {
  SELECT_FULL,
  SELECT_BASE,
  isMissingColumnError,
  filterActiveRows,
  listConsultations,
  getConsultationById,
  insertConsultation,
  updateConsultation,
  softDeleteConsultation,
};
