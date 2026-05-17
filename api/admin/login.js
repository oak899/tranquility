const { handleCors, json, readJsonBody } = require('../lib/http');
const { signAdminToken, checkAdminLogin } = require('../lib/auth');

module.exports = async function handler(req, res) {
  if (handleCors(req, res)) return;

  if (req.method !== 'POST') {
    return json(res, 405, { error: 'Method not allowed' });
  }

  try {
    const body = await readJsonBody(req);
    const username = String(body.username || '').trim();
    const password = String(body.password || '');

    if (!process.env.ADMIN_PASSWORD) {
      return json(res, 503, { error: 'Admin login is not configured' });
    }

    if (!checkAdminLogin(username, password)) {
      return json(res, 401, { error: 'Invalid username or password' });
    }

    const token = signAdminToken(username);
    return json(res, 200, { ok: true, token });
  } catch (e) {
    console.error(e);
    return json(res, 500, { error: 'Server error' });
  }
};
