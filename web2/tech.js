(function () {
  const TOKEN_KEY = 'tranquility_admin_token';

  const loginView = document.getElementById('loginView');
  const dashboardView = document.getElementById('dashboardView');
  const loginForm = document.getElementById('loginForm');
  const loginError = document.getElementById('loginError');
  const logoutBtn = document.getElementById('logoutBtn');
  const refreshBtn = document.getElementById('refreshBtn');
  const clientSearch = document.getElementById('clientSearch');
  const clientCount = document.getElementById('clientCount');
  const kindFilters = document.getElementById('kindFilters');
  const clientsList = document.getElementById('clientsList');
  const loadError = document.getElementById('loadError');

  let allClients = [];
  let kindFilter = 'all';
  let searchQuery = '';

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
    logoutBtn.classList.add('hidden');
  }

  function showDashboard() {
    loginView.classList.add('hidden');
    dashboardView.classList.remove('hidden');
    logoutBtn.classList.remove('hidden');
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

  function fmtDate(iso) {
    if (!iso) return '—';
    try {
      return new Date(iso).toLocaleString(undefined, {
        weekday: 'short',
        month: 'short',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
      });
    } catch {
      return iso;
    }
  }

  function fmtServiceDate(iso) {
    if (!iso) return null;
    try {
      return new Date(iso).toLocaleDateString(undefined, {
        weekday: 'short',
        month: 'short',
        day: 'numeric',
      });
    } catch {
      return iso;
    }
  }

  function kindLabel(kind) {
    if (kind === 'head_spa') return 'Head spa';
    if (kind === 'facial') return 'Facial';
    return kind;
  }

  async function api(path, options) {
    const headers = Object.assign({ 'Content-Type': 'application/json' }, options?.headers || {});
    const t = token();
    if (t) headers.Authorization = 'Bearer ' + t;
    const res = await fetch(path, Object.assign({}, options, { headers }));
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
      const err = new Error(data.error || res.statusText || 'Request failed');
      err.status = res.status;
      throw err;
    }
    return data;
  }

  function matchesSearch(c, query) {
    if (!query) return true;
    const q = query.toLowerCase().trim();
    const qDigits = digitsOnly(q);
    const name = (c.name || '').toLowerCase();
    const phone = (c.phone || '').toLowerCase();
    const phoneDigits = digitsOnly(c.phone);
    if (name.includes(q)) return true;
    if (phone.includes(q)) return true;
    if (qDigits.length >= 3 && phoneDigits.includes(qDigits)) return true;
    return false;
  }

  function filteredClients() {
    return allClients.filter(function (c) {
      if (kindFilter !== 'all' && c.kind !== kindFilter) return false;
      return matchesSearch(c, searchQuery);
    });
  }

  function buildClientCard(c) {
    const kindCls = c.kind === 'facial' ? 'kind-facial' : 'kind-head_spa';
    const serviceDate = fmtServiceDate(c.serviceDate);
    const services = (c.services || [])
      .map(function (s) {
        return '<span class="chip">' + escapeHtml(s) + '</span>';
      })
      .join('');
    const addons = (c.addons || [])
      .map(function (s) {
        return '<span class="chip">' + escapeHtml(s) + '</span>';
      })
      .join('');
    const alerts = (c.alerts || [])
      .map(function (a) {
        return '<span class="chip alert-chip">' + escapeHtml(a) + '</span>';
      })
      .join('');

    return (
      '<article class="client-card bg-white rounded-2xl border border-stone-200 shadow-sm overflow-hidden">' +
      '<div class="px-4 py-4">' +
      '<div class="flex items-start justify-between gap-2 mb-3">' +
      '<span class="chip ' +
      kindCls +
      ' font-semibold">' +
      escapeHtml(kindLabel(c.kind)) +
      '</span>' +
      '<span class="text-xs text-stone-400 text-right">' +
      escapeHtml(fmtDate(c.created_at)) +
      '</span>' +
      '</div>' +
      '<h2 class="text-xl font-semibold text-stone-900 leading-tight">' +
      escapeHtml(c.name || 'Unknown') +
      '</h2>' +
      '<div class="mt-3 grid grid-cols-1 gap-2">' +
      '<a href="tel:' +
      escapeHtml(digitsOnly(c.phone)) +
      '" class="flex items-center gap-3 rounded-xl bg-stone-50 border border-stone-100 px-4 py-3 active:bg-stone-100">' +
      '<span class="text-lg">📞</span>' +
      '<span class="min-w-0"><span class="block text-xs text-stone-500 uppercase tracking-wide">Phone</span>' +
      '<span class="block text-base font-medium text-stone-900">' +
      escapeHtml(c.phone || '—') +
      '</span></span>' +
      '</a>' +
      (c.email
        ? '<a href="mailto:' +
          escapeHtml(c.email) +
          '" class="flex items-center gap-3 rounded-xl bg-stone-50 border border-stone-100 px-4 py-3 active:bg-stone-100">' +
          '<span class="text-lg">✉️</span>' +
          '<span class="min-w-0"><span class="block text-xs text-stone-500 uppercase tracking-wide">Email</span>' +
          '<span class="block text-sm font-medium text-stone-900 truncate">' +
          escapeHtml(c.email) +
          '</span></span>' +
          '</a>'
        : '') +
      '</div>' +
      (serviceDate
        ? '<p class="mt-3 text-sm"><span class="text-stone-500">Service date:</span> <strong>' +
          escapeHtml(serviceDate) +
          '</strong></p>'
        : '') +
      (services
        ? '<div class="mt-3"><p class="text-xs text-stone-500 uppercase tracking-wide mb-1">Services</p>' +
          services +
          '</div>'
        : '') +
      (addons
        ? '<div class="mt-2"><p class="text-xs text-stone-500 uppercase tracking-wide mb-1">Add-ons</p>' +
          addons +
          '</div>'
        : '') +
      (alerts
        ? '<div class="mt-3 pt-3 border-t border-stone-100"><p class="text-xs text-red-700 font-semibold uppercase tracking-wide mb-1">Notes for technician</p>' +
          alerts +
          '</div>'
        : '') +
      '</div>' +
      '</article>'
    );
  }

  function renderClients() {
    const rows = filteredClients();
    const total = allClients.length;
    clientCount.textContent =
      rows.length === total
        ? rows.length + ' client' + (rows.length === 1 ? '' : 's')
        : rows.length + ' of ' + total;

    if (!rows.length) {
      clientsList.innerHTML =
        '<div class="bg-white rounded-2xl border border-stone-200 px-6 py-12 text-center text-stone-500">' +
        (searchQuery || kindFilter !== 'all' ? 'No clients match your search.' : 'No active consultations.') +
        '</div>';
      return;
    }
    clientsList.innerHTML = rows.map(buildClientCard).join('');
  }

  async function loadClients() {
    loadError.classList.add('hidden');
    try {
      const data = await api('/api/tech/consultations');
      allClients = data.clients || [];
      renderClients();
    } catch (e) {
      if (e.status === 401) {
        setToken(null);
        showLogin();
        return;
      }
      loadError.textContent = e.message || 'Failed to load';
      loadError.classList.remove('hidden');
    }
  }

  loginForm.addEventListener('submit', async function (ev) {
    ev.preventDefault();
    loginError.classList.add('hidden');
    const fd = new FormData(loginForm);
    try {
      const data = await api('/api/admin/login', {
        method: 'POST',
        body: JSON.stringify({
          username: fd.get('username'),
          password: fd.get('password'),
        }),
      });
      setToken(data.token);
      showDashboard();
      await loadClients();
    } catch (e) {
      loginError.textContent = e.message || 'Login failed';
      loginError.classList.remove('hidden');
    }
  });

  logoutBtn.addEventListener('click', function () {
    setToken(null);
    showLogin();
  });

  refreshBtn.addEventListener('click', loadClients);
  clientSearch.addEventListener('input', function () {
    searchQuery = clientSearch.value;
    renderClients();
  });

  kindFilters.addEventListener('click', function (ev) {
    const btn = ev.target.closest('[data-kind]');
    if (!btn) return;
    kindFilter = btn.getAttribute('data-kind');
    kindFilters.querySelectorAll('.filter-btn').forEach(function (b) {
      b.classList.toggle('active', b === btn);
    });
    renderClients();
  });

  if (token()) {
    showDashboard();
    loadClients();
  } else {
    showLogin();
  }
})();
