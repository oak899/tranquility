const ALLOWED_METHODS = 'GET,POST,PATCH,DELETE,OPTIONS';

function getAllowedOrigin(req) {
  const origin = req.headers.origin || req.headers.Origin || '';
  const list = (process.env.CORS_ORIGINS || '*').split(',').map((s) => s.trim());
  if (list.includes('*')) return origin || '*';
  if (origin && list.includes(origin)) return origin;
  return list[0] || '';
}

function applyCors(req, res) {
  const origin = getAllowedOrigin(req);
  if (origin) {
    res.setHeader('Access-Control-Allow-Origin', origin);
    res.setHeader('Vary', 'Origin');
  }
  res.setHeader('Access-Control-Allow-Methods', ALLOWED_METHODS);
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Max-Age', '86400');
}

function handleCors(req, res) {
  applyCors(req, res);
  if (req.method === 'OPTIONS') {
    res.statusCode = 204;
    res.end();
    return true;
  }
  return false;
}

function json(res, status, body) {
  res.statusCode = status;
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  res.end(JSON.stringify(body));
}

async function readJsonBody(req) {
  const chunks = [];
  for await (const chunk of req) {
    chunks.push(chunk);
  }
  const raw = Buffer.concat(chunks).toString('utf8');
  if (!raw) return {};
  return JSON.parse(raw);
}

module.exports = { handleCors, json, readJsonBody, applyCors };
