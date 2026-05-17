(function () {
  const TOKEN_KEY = 'tranquility_admin_token';
  const apiBase = '';

  const loginView = document.getElementById('loginView');
  const dashboardView = document.getElementById('dashboardView');
  const loginForm = document.getElementById('loginForm');
  const loginError = document.getElementById('loginError');
  const logoutBtn = document.getElementById('logoutBtn');
  const refreshBtn = document.getElementById('refreshBtn');
  const tabAppointments = document.getElementById('tabAppointments');
  const tabConsultations = document.getElementById('tabConsultations');
  const panelAppointments = document.getElementById('panelAppointments');
  const panelConsultations = document.getElementById('panelConsultations');
  const appointmentsBody = document.getElementById('appointmentsBody');
  const consultationsList = document.getElementById('consultationsList');
  const consultSearch = document.getElementById('consultSearch');
  const consultCount = document.getElementById('consultCount');
  const consultFilters = document.getElementById('consultFilters');
  const consultAddBtn = document.getElementById('consultAddBtn');
  const consultModal = document.getElementById('consultModal');
  const consultModalTitle = document.getElementById('consultModalTitle');
  const consultModalClose = document.getElementById('consultModalClose');
  const consultForm = document.getElementById('consultForm');
  const consultFormId = document.getElementById('consultFormId');
  const consultFormKind = document.getElementById('consultFormKind');
  const consultFormName = document.getElementById('consultFormName');
  const consultFormPhone = document.getElementById('consultFormPhone');
  const consultFormEmail = document.getElementById('consultFormEmail');
  const consultFormServiceDate = document.getElementById('consultFormServiceDate');
  const consultFormServices = document.getElementById('consultFormServices');
  const consultFormAddons = document.getElementById('consultFormAddons');
  const consultFormAddonsWrap = document.getElementById('consultFormAddonsWrap');
  const consultFormError = document.getElementById('consultFormError');
  const consultFormCancel = document.getElementById('consultFormCancel');
  const loadError = document.getElementById('loadError');

  let allConsultations = [];
  let consultKindFilter = 'all';
  let consultSearchQuery = '';
  let editingConsultation = null;

  const VALUE_MAPS = {
    yes: 'Yes',
    no: 'No',
    none: 'No makeup',
    light: 'Light makeup',
    full: 'Full makeup',
    here: 'Yes, at Tranquility Hydrotherapy',
    elsewhere: 'Yes, at another spa',
    first: 'No, first time',
    slow: 'Slow',
    med: 'Medium',
    fast: 'Fast',
    light: 'Light',
    medium: 'Medium',
    strong: 'Strong',
    google: 'Google',
    facebook: 'Facebook',
    instagram: 'Instagram',
    tiktok: 'TikTok',
    friend: 'Friend or family',
    email: 'Email or newsletter',
    other: 'Other',
    tangerine: 'Tangerine',
    lemongrass: 'Lemongrass',
    lavender: 'Lavender',
    bergamot: 'Bergamot',
    '100': '100% dry',
    '80': '80% dry',
    '50': '50% dry',
    '98': '98°F',
    '102': '102°F',
    '104': '104°F',
  };

  const FACIAL_SECTIONS = [
    {
      title: "Client information",
      fields: [
        ['name', 'Full name'],
        ['phone', 'Phone'],
        ['email', 'Email'],
        ['serviceDate', 'Service date'],
        ['services', 'Services booked'],
      ],
    },
    {
      title: 'Skin assessment',
      fields: [
        ['skinType', 'Skin type'],
        ['concerns', 'Skin concerns'],
        ['concernsOther', 'Other concerns'],
        ['products', 'Products used'],
        ['productsOther', 'Other products'],
        ['makeupToday', 'Makeup today'],
        ['regularFacials', 'Regular facials'],
        ['conditions', 'Health conditions'],
        ['conditionsOther', 'Other conditions'],
      ],
    },
    {
      title: 'Disclaimer & signature',
      fields: [
        ['signature', 'Client signature'],
        ['signDate', 'Signature date'],
      ],
    },
  ];

  const HEAD_SPA_SECTIONS = [
    {
      title: "Client information",
      fields: [
        ['name', 'Full name'],
        ['phone', 'Phone'],
        ['email', 'Email'],
        ['serviceDate', 'Service date'],
        ['services', 'Services booked'],
        ['addons', 'Enhancement add-ons'],
      ],
    },
    {
      title: 'Preferences & health',
      fields: [
        ['q1', 'Previous experience'],
        ['q2_foreheadMassage', 'Forehead massage'],
        ['q3_pressure', 'Massage pressure'],
        ['q4_rhythm', 'Massage rhythm'],
        ['q5_water', 'Water temperature'],
        ['q6_steamEye', 'Steam eye mask'],
        ['q7_scent', 'Essential oil scent'],
        ['q8_scalp', 'Scalp concerns'],
        ['q8_other', 'Other scalp concerns'],
        ['q9_allergies', 'Allergies or sensitivities'],
        ['q9_specify', 'Allergy details'],
        ['q10_pregnancyOrUnder18', 'Pregnancy or under 18'],
        ['q11_blowDry', 'Post-service hair dryness'],
        ['q12_referral', 'How did you hear about us'],
        ['q12_other', 'Referral (other)'],
      ],
    },
  ];

  function token() {
    return sessionStorage.getItem(TOKEN_KEY);
  }

  function setToken(value) {
    if (value) sessionStorage.setItem(TOKEN_KEY, value);
    else sessionStorage.removeItem(TOKEN_KEY);
  }

  function showLogin() {
    loginView.classList.remove('hidden');
    dashboardView.classList.add('hidden');
  }

  function showDashboard() {
    loginView.classList.add('hidden');
    dashboardView.classList.remove('hidden');
  }

  function setActiveTab(which) {
    const isAppt = which === 'appointments';
    tabAppointments.classList.toggle('border-stone-900', isAppt);
    tabAppointments.classList.toggle('text-stone-900', isAppt);
    tabAppointments.classList.toggle('border-transparent', !isAppt);
    tabAppointments.classList.toggle('text-stone-500', !isAppt);
    tabConsultations.classList.toggle('border-stone-900', !isAppt);
    tabConsultations.classList.toggle('text-stone-900', !isAppt);
    tabConsultations.classList.toggle('border-transparent', isAppt);
    tabConsultations.classList.toggle('text-stone-500', isAppt);
    panelAppointments.classList.toggle('hidden', !isAppt);
    panelConsultations.classList.toggle('hidden', isAppt);
  }

  function fmtDate(iso) {
    if (!iso) return '—';
    try {
      return new Date(iso).toLocaleString(undefined, {
        dateStyle: 'medium',
        timeStyle: 'short',
      });
    } catch {
      return iso;
    }
  }

  function fmtDateOnly(iso) {
    if (!iso) return '—';
    try {
      return new Date(iso).toLocaleDateString(undefined, { dateStyle: 'medium' });
    } catch {
      return iso;
    }
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function digitsOnly(s) {
    return String(s || '').replace(/\D/g, '');
  }

  function contactFromPayload(p) {
    p = p || {};
    return {
      name: String(p.name || '').trim(),
      phone: String(p.phone || '').trim(),
      email: String(p.email || '').trim(),
    };
  }

  function mapValue(v) {
    if (v == null || v === '') return null;
    if (typeof v === 'boolean') return v ? 'Yes' : 'No';
    const key = String(v);
    return VALUE_MAPS[key] || key.replace(/_/g, ' ');
  }

  function formatFieldValue(key, value) {
    if (value == null || value === '') return null;
    if (key === 'serviceDate' || key === 'signDate') return fmtDateOnly(value);
    if (Array.isArray(value)) {
      const items = value.map(mapValue).filter(Boolean);
      return items.length ? items : null;
    }
    if (typeof value === 'object') return JSON.stringify(value);
    return mapValue(value);
  }

  function renderFieldValue(formatted) {
    if (!formatted) {
      return '<span class="text-stone-400">—</span>';
    }
    if (Array.isArray(formatted)) {
      return formatted.map(function (item) {
        return '<span class="chip">' + escapeHtml(item) + '</span>';
      }).join('');
    }
    return '<span class="text-stone-800">' + escapeHtml(formatted) + '</span>';
  }

  function kindLabel(kind) {
    if (kind === 'head_spa') return 'Head spa & skin care';
    if (kind === 'facial') return 'Facial consultation';
    return kind || 'Consultation';
  }

  function kindBadgeClass(kind) {
    return kind === 'facial' ? 'kind-facial' : kind === 'head_spa' ? 'kind-head_spa' : '';
  }

  function matchesConsultSearch(row, query) {
    if (!query) return true;
    const q = query.toLowerCase().trim();
    const qDigits = digitsOnly(q);
    const c = contactFromPayload(row.payload);
    const name = c.name.toLowerCase();
    const phone = c.phone.toLowerCase();
    const phoneDigits = digitsOnly(c.phone);
    if (name.includes(q)) return true;
    if (phone.includes(q)) return true;
    if (qDigits.length >= 3 && phoneDigits.includes(qDigits)) return true;
    return false;
  }

  function filterConsultations() {
    return allConsultations.filter(function (row) {
      if (consultKindFilter !== 'all' && row.kind !== consultKindFilter) return false;
      return matchesConsultSearch(row, consultSearchQuery);
    });
  }

  function buildConsultationCard(row) {
    const p = row.payload || {};
    const c = contactFromPayload(p);
    const sections = row.kind === 'head_spa' ? HEAD_SPA_SECTIONS : FACIAL_SECTIONS;
    const kindCls = kindBadgeClass(row.kind);

    let sectionsHtml = '';
    sections.forEach(function (section) {
      let fieldsHtml = '';
      section.fields.forEach(function (pair) {
        const key = pair[0];
        const label = pair[1];
        const formatted = formatFieldValue(key, p[key]);
        if (formatted == null && (p[key] === undefined || p[key] === null || p[key] === '')) {
          return;
        }
        fieldsHtml +=
          '<div class="grid grid-cols-1 sm:grid-cols-[minmax(9rem,34%)_1fr] gap-1 sm:gap-4 py-2.5 border-b border-stone-100 last:border-0">' +
          '<dt class="text-xs font-medium uppercase tracking-wide text-stone-500">' +
          escapeHtml(label) +
          '</dt>' +
          '<dd class="text-sm">' +
          renderFieldValue(formatted) +
          '</dd>' +
          '</div>';
      });
      if (!fieldsHtml) return;
      sectionsHtml +=
        '<div class="mt-4 first:mt-0">' +
        '<h4 class="text-xs font-semibold uppercase tracking-wider text-stone-400 mb-2">' +
        escapeHtml(section.title) +
        '</h4>' +
        '<dl class="bg-stone-50/60 rounded-xl px-4 py-1">' +
        fieldsHtml +
        '</dl>' +
        '</div>';
    });

    return (
      '<article class="consult-card bg-white rounded-2xl border border-stone-200 shadow-sm overflow-hidden" data-id="' +
      escapeHtml(row.id || '') +
      '">' +
      '<header class="px-5 py-4 border-b border-stone-100 bg-gradient-to-r from-stone-50 to-white">' +
      '<div class="flex flex-wrap items-start justify-between gap-3">' +
      '<div class="min-w-0 flex-1">' +
      '<div class="flex flex-wrap items-center gap-2 mb-1">' +
      '<span class="chip ' +
      kindCls +
      ' font-medium">' +
      escapeHtml(kindLabel(row.kind)) +
      '</span>' +
      '<span class="text-xs text-stone-400">Submitted ' +
      escapeHtml(fmtDate(row.created_at)) +
      '</span>' +
      '</div>' +
      '<h3 class="text-lg font-semibold text-stone-900 truncate">' +
      escapeHtml(c.name || 'Unknown') +
      '</h3>' +
      '<p class="text-sm text-stone-600 mt-0.5">' +
      '<a class="hover:text-stone-900" href="tel:' +
      escapeHtml(digitsOnly(c.phone)) +
      '">' +
      escapeHtml(c.phone || '—') +
      '</a>' +
      (c.email
        ? ' · <a class="hover:text-stone-900" href="mailto:' +
          escapeHtml(c.email) +
          '">' +
          escapeHtml(c.email) +
          '</a>'
        : '') +
      '</p>' +
      '</div>' +
      '<div class="flex flex-wrap gap-2 shrink-0">' +
      '<button type="button" class="consult-edit text-sm text-stone-700 px-3 py-1.5 rounded-lg border border-stone-200 hover:bg-stone-50" data-id="' +
      escapeHtml(row.id) +
      '">Edit</button>' +
      '<button type="button" class="consult-delete text-sm text-red-700 px-3 py-1.5 rounded-lg border border-red-200 hover:bg-red-50" data-id="' +
      escapeHtml(row.id) +
      '">Delete</button>' +
      '<button type="button" class="consult-toggle text-sm text-stone-600 px-3 py-1.5 rounded-lg border border-stone-200" aria-expanded="true">Collapse</button>' +
      '</div>' +
      '</div>' +
      '</header>' +
      '<div class="consult-body px-5 py-4">' +
      sectionsHtml +
      '</div>' +
      '</article>'
    );
  }

  function renderConsultations() {
    const rows = filterConsultations();
    const total = allConsultations.length;
    consultCount.textContent =
      rows.length === total
        ? rows.length + ' submission' + (rows.length === 1 ? '' : 's')
        : rows.length + ' of ' + total + ' shown';

    if (!rows.length) {
      consultationsList.innerHTML =
        '<div class="bg-white rounded-2xl border border-stone-200 px-6 py-12 text-center text-stone-500 text-sm">' +
        (consultSearchQuery || consultKindFilter !== 'all'
          ? 'No consultations match your search.'
          : 'No consultations yet.') +
        '</div>';
      return;
    }

    consultationsList.innerHTML = rows.map(buildConsultationCard).join('');

    consultationsList.querySelectorAll('.consult-toggle').forEach(function (btn) {
      btn.addEventListener('click', function () {
        const card = btn.closest('.consult-card');
        const body = card.querySelector('.consult-body');
        const open = body.classList.toggle('hidden');
        btn.setAttribute('aria-expanded', String(!open));
        btn.textContent = open ? 'Expand' : 'Collapse';
      });
    });

    consultationsList.querySelectorAll('.consult-edit').forEach(function (btn) {
      btn.addEventListener('click', function () {
        const id = btn.getAttribute('data-id');
        const row = allConsultations.find(function (r) {
          return r.id === id;
        });
        if (row) openConsultModal('edit', row);
      });
    });

    consultationsList.querySelectorAll('.consult-delete').forEach(function (btn) {
      btn.addEventListener('click', function () {
        const id = btn.getAttribute('data-id');
        const row = allConsultations.find(function (r) {
          return r.id === id;
        });
        if (!row) return;
        const c = contactFromPayload(row.payload);
        if (
          !confirm(
            'Remove consultation for ' +
              (c.name || 'this client') +
              '?\n\nThis marks it as deleted and hides it from admin and technician views.'
          )
        ) {
          return;
        }
        softDeleteConsultation(id);
      });
    });
  }

  function splitList(value) {
    return String(value || '')
      .split(',')
      .map(function (s) {
        return s.trim();
      })
      .filter(Boolean);
  }

  function joinList(arr) {
    if (!Array.isArray(arr)) return '';
    return arr.join(', ');
  }

  function isoToDateInput(iso) {
    if (!iso) return '';
    try {
      return new Date(iso).toISOString().slice(0, 10);
    } catch {
      return '';
    }
  }

  function dateInputToIso(value) {
    if (!value) return null;
    return new Date(value + 'T12:00:00').toISOString();
  }

  function toggleAddonsField() {
    const isHead = consultFormKind.value === 'head_spa';
    consultFormAddonsWrap.classList.toggle('hidden', !isHead);
  }

  function openConsultModal(mode, row) {
    editingConsultation = row || null;
    consultFormError.classList.add('hidden');
    consultFormError.textContent = '';
    consultModalTitle.textContent = mode === 'edit' ? 'Edit consultation' : 'Add consultation';
    consultFormId.value = row ? row.id : '';

    const p = row && row.payload ? row.payload : {};
    consultFormKind.value = row ? row.kind : 'facial';
    consultFormName.value = p.name || '';
    consultFormPhone.value = p.phone || '';
    consultFormEmail.value = p.email || '';
    consultFormServiceDate.value = isoToDateInput(p.serviceDate);
    consultFormServices.value = joinList(p.services);
    consultFormAddons.value = joinList(p.addons);
    toggleAddonsField();
    consultModal.classList.remove('hidden');
    document.body.classList.add('overflow-hidden');
  }

  function closeConsultModal() {
    consultModal.classList.add('hidden');
    document.body.classList.remove('overflow-hidden');
    editingConsultation = null;
    consultForm.reset();
    consultFormId.value = '';
  }

  function buildPayloadFromForm() {
    const base =
      editingConsultation && editingConsultation.payload
        ? Object.assign({}, editingConsultation.payload)
        : {};
    base.name = consultFormName.value.trim();
    base.phone = consultFormPhone.value.trim();
    base.email = consultFormEmail.value.trim();
    const sd = dateInputToIso(consultFormServiceDate.value);
    if (sd) base.serviceDate = sd;
    else delete base.serviceDate;
    const services = splitList(consultFormServices.value);
    if (services.length) base.services = services;
    else delete base.services;
    if (consultFormKind.value === 'head_spa') {
      const addons = splitList(consultFormAddons.value);
      if (addons.length) base.addons = addons;
      else delete base.addons;
    }
    return base;
  }

  async function saveConsultation(ev) {
    ev.preventDefault();
    consultFormError.classList.add('hidden');
    const kind = consultFormKind.value;
    const payload = buildPayloadFromForm();
    if (payload.name.length < 2) {
      consultFormError.textContent = 'Name is required (min 2 characters).';
      consultFormError.classList.remove('hidden');
      return;
    }
    try {
      if (editingConsultation && editingConsultation.id) {
        await api('/api/admin/consultation/' + editingConsultation.id, {
          method: 'PATCH',
          body: JSON.stringify({ kind, payload }),
        });
      } else {
        await api('/api/admin/consultations', {
          method: 'POST',
          body: JSON.stringify({ kind, payload, source: 'admin' }),
        });
      }
      closeConsultModal();
      await loadData();
    } catch (e) {
      consultFormError.textContent = e.message || 'Could not save';
      consultFormError.classList.remove('hidden');
    }
  }

  async function softDeleteConsultation(id) {
    try {
      await api('/api/admin/consultation/' + id, { method: 'DELETE' });
      allConsultations = allConsultations.filter(function (r) {
        return r.id !== id;
      });
      renderConsultations();
    } catch (e) {
      alert(e.message || 'Could not delete');
    }
  }

  async function api(path, options) {
    const headers = Object.assign({ 'Content-Type': 'application/json' }, options?.headers || {});
    const t = token();
    if (t) headers.Authorization = 'Bearer ' + t;
    const res = await fetch(apiBase + path, Object.assign({}, options, { headers }));
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
      const err = new Error(data.error || res.statusText || 'Request failed');
      err.status = res.status;
      throw err;
    }
    return data;
  }

  function renderAppointments(rows) {
    if (!rows.length) {
      appointmentsBody.innerHTML =
        '<tr><td colspan="6" class="px-4 py-8 text-center text-stone-500">No appointments yet.</td></tr>';
      return;
    }
    appointmentsBody.innerHTML = rows
      .map(function (r) {
        return (
          '<tr class="border-t border-stone-100 hover:bg-stone-50/80">' +
          '<td class="px-4 py-3 text-sm whitespace-nowrap">' +
          escapeHtml(fmtDate(r.created_at)) +
          '</td>' +
          '<td class="px-4 py-3 text-sm font-medium">' +
          escapeHtml(r.name) +
          '</td>' +
          '<td class="px-4 py-3 text-sm">' +
          escapeHtml(r.phone) +
          '</td>' +
          '<td class="px-4 py-3 text-sm">' +
          escapeHtml(r.email) +
          '</td>' +
          '<td class="px-4 py-3 text-sm whitespace-nowrap">' +
          escapeHtml(fmtDate(r.visit_at)) +
          '</td>' +
          '<td class="px-4 py-3 text-sm text-stone-500">' +
          escapeHtml(r.source || 'app') +
          '</td>' +
          '</tr>'
        );
      })
      .join('');
  }

  async function loadData() {
    loadError.classList.add('hidden');
    loadError.textContent = '';
    try {
      const [appt, consult] = await Promise.all([
        api('/api/admin/appointments'),
        api('/api/admin/consultations'),
      ]);
      renderAppointments(appt.appointments || []);
      allConsultations = consult.consultations || [];
      renderConsultations();
    } catch (e) {
      if (e.status === 401) {
        setToken(null);
        showLogin();
        return;
      }
      loadError.textContent = e.message || 'Failed to load data';
      loadError.classList.remove('hidden');
    }
  }

  loginForm.addEventListener('submit', async function (ev) {
    ev.preventDefault();
    loginError.classList.add('hidden');
    const fd = new FormData(loginForm);
    const username = fd.get('username');
    const password = fd.get('password');
    try {
      const data = await api('/api/admin/login', {
        method: 'POST',
        body: JSON.stringify({ username, password }),
      });
      setToken(data.token);
      showDashboard();
      await loadData();
    } catch (e) {
      loginError.textContent = e.message || 'Login failed';
      loginError.classList.remove('hidden');
    }
  });

  logoutBtn.addEventListener('click', function () {
    setToken(null);
    showLogin();
  });

  refreshBtn.addEventListener('click', loadData);

  tabAppointments.addEventListener('click', function () {
    setActiveTab('appointments');
  });
  tabConsultations.addEventListener('click', function () {
    setActiveTab('consultations');
  });

  consultSearch.addEventListener('input', function () {
    consultSearchQuery = consultSearch.value;
    renderConsultations();
  });

  consultFilters.addEventListener('click', function (ev) {
    const btn = ev.target.closest('[data-kind]');
    if (!btn) return;
    consultKindFilter = btn.getAttribute('data-kind');
    consultFilters.querySelectorAll('.filter-btn').forEach(function (b) {
      b.classList.toggle('active', b === btn);
    });
    renderConsultations();
  });

  consultAddBtn.addEventListener('click', function () {
    openConsultModal('add', null);
  });
  consultForm.addEventListener('submit', saveConsultation);
  consultFormKind.addEventListener('change', toggleAddonsField);
  consultModalClose.addEventListener('click', closeConsultModal);
  consultFormCancel.addEventListener('click', closeConsultModal);
  consultModal.querySelector('.consult-modal-backdrop').addEventListener('click', closeConsultModal);

  if (token()) {
    showDashboard();
    loadData();
  } else {
    showLogin();
  }
  setActiveTab('appointments');
})();
