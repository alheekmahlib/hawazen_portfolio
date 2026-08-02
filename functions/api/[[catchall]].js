// Cloudflare Pages Function — CORS proxy for the Dashboard API.
//
// Why this exists: the dashboard at dash.vexaltech.dev serves JSON but does
// NOT send CORS headers, so a browser-hosted Flutter Web app cannot fetch it
// directly. This serverless function runs on the same origin as the site
// (hawazen.vexaltech.dev), fetches the upstream JSON server-side (where CORS
// does not apply), and returns it with permissive CORS headers.
//
// Routing: any request to `/api/<anything>` is proxied to
// `https://dash.vexaltech.dev/api/<anything>`, preserving the path and query
// string. This keeps the client generic — add a new dashboard endpoint and it
// works with zero changes here.
//
// Path is intentionally a catch-all (`[[catchall]]`) so unknown `/api/*`
// sub-paths 404 upstream rather than falling through to the SPA.

const UPSTREAM_ORIGIN = 'https://dash.vexaltech.dev';

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Max-Age': '86400',
};

export async function onRequestOptions() {
  // Browser preflight: respond 204 with the CORS headers, no upstream call.
  return new Response(null, { status: 204, headers: CORS_HEADERS });
}

export async function onRequestGet(context) {
  const { request } = context;
  const url = new URL(request.url);

  // Rebuild the upstream URL: same path + query, different origin.
  const upstream = new URL(url.pathname + url.search, UPSTREAM_ORIGIN);

  let upstreamResponse;
  try {
    upstreamResponse = await fetch(upstream, {
      method: 'GET',
      // Forward no cookies/credentials — the dashboard API is public JSON.
      headers: { Accept: 'application/json' },
      cf: { cacheTtl: 300, cacheEverything: true },
    });
  } catch (e) {
    return jsonResponse(
      { error: 'Upstream fetch failed', detail: String(e && e.message || e) },
      502,
    );
  }

  // Forward the body and content-type, then layer our CORS headers on top.
  const headers = new Headers();
  headers.set(
    'Content-Type',
    upstreamResponse.headers.get('Content-Type') || 'application/json',
  );
  for (const [k, v] of Object.entries(CORS_HEADERS)) headers.set(k, v);

  // Respect upstream caching hints where possible.
  const cache = upstreamResponse.headers.get('Cache-Control');
  if (cache) headers.set('Cache-Control', cache);

  return new Response(upstreamResponse.body, {
    status: upstreamResponse.status,
    headers,
  });
}

function jsonResponse(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
