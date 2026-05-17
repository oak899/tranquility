const crypto = require('crypto');

const TOKEN_TTL_MS = 12 * 60 * 60 * 1000;

function secret() {
  return process.env.ADMIN_JWT_SECRET || process.env.SUPABASE_JWT_SECRET || 'change-me';
}

function signAdminToken(username) {
  const payload = {
    sub: username,
    role: 'admin',
    exp: Date.now() + TOKEN_TTL_MS,
  };
  const body = Buffer.from(JSON.stringify(payload)).toString('base64url');
  const sig = crypto.createHmac('sha256', secret()).update(body).digest('base64url');
  return `${body}.${sig}`;
}

function verifyAdminToken(token) {
  if (!token || typeof token !== 'string') return null;
  const parts = token.split('.');
  if (parts.length !== 2) return null;
  const [body, sig] = parts;
  const expected = crypto.createHmac('sha256', secret()).update(body).digest('base64url');
  if (sig.length !== expected.length) return null;
  if (!crypto.timingSafeEqual(Buffer.from(sig), Buffer.from(expected))) return null;
  let payload;
  try {
    payload = JSON.parse(Buffer.from(body, 'base64url').toString('utf8'));
  } catch {
    return null;
  }
  if (!payload.exp || Date.now() > payload.exp) return null;
  if (payload.role !== 'admin') return null;
  return payload;
}

function bearerToken(req) {
  const h = req.headers.authorization || req.headers.Authorization || '';
  const m = /^Bearer\s+(.+)$/i.exec(h);
  return m ? m[1].trim() : null;
}

function requireAdmin(req, res) {
  const payload = verifyAdminToken(bearerToken(req));
  if (!payload) {
    const { json } = require('./http');
    json(res, 401, { error: 'Unauthorized' });
    return null;
  }
  return payload;
}

function safeEqual(a, b) {
  const ba = Buffer.from(String(a));
  const bb = Buffer.from(String(b));
  if (ba.length !== bb.length) return false;
  return crypto.timingSafeEqual(ba, bb);
}

function checkAdminLogin(username, password) {
  const u = process.env.ADMIN_USERNAME || 'admin';
  const p = process.env.ADMIN_PASSWORD;
  if (!p) return false;
  return safeEqual(username || '', u) && safeEqual(password || '', p);
}

module.exports = {
  signAdminToken,
  verifyAdminToken,
  bearerToken,
  requireAdmin,
  checkAdminLogin,
};
