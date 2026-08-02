// Cloudflare Pages Function — CORS proxy for the Dashboard API.
//
// Why this exists: the dashboard at dash.vexaltech.dev serves JSON but does
// NOT send CORS headers, so a browser-hosted Flutter Web app cannot fetch it
// directly. This serverless function runs on the same origin as the site
// (hawazen.vexaltech.dev), fetches the upstream JSON server-side (where CORS
// does not apply), and returns it with permissive CORS headers.
//
// Media rewriting: dashboard media paths look like `/media/2026/07/x.png`. The
// dashboard media server sends no CORS headers either, so Flutter Web (which
// fetches images via XMLHttpRequest) cannot load them cross-origin. To make
// images load without depending on client-side rewriting (which a stale CDN
// copy of main.dart.js could bypass), this proxy rewrites every `/media/...`
// path in the JSON response to an absolute same-origin URL served by the
// `/media/*` proxy function. This is the single source of truth for media URLs.
//
// Routing: any request to `/api/<anything>` is proxied to
// `https://dash.vexaltech.dev/api/<anything>`, preserving the path and query
// string.

const UPSTREAM_ORIGIN = 'https://dash.vexaltech.dev';

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Max-Age': '86400',
};

export async function onRequestOptions() {
  return new Response(null, { status: 204, headers: CORS_HEADERS });
}

export async function onRequestGet(context) {
  const { request } = context;
  const url = new URL(request.url);

  const upstream = new URL(url.pathname + url.search, UPSTREAM_ORIGIN);

  let upstreamResponse;
  try {
    upstreamResponse = await fetch(upstream, {
      method: 'GET',
      headers: { Accept: 'application/json' },
      cf: { cacheTtl: 300, cacheEverything: true },
    });
  } catch (e) {
    return jsonResponse(
      { error: 'Upstream fetch failed', detail: String((e && e.message) || e) },
      502,
    );
  }

  const contentType = upstreamResponse.headers.get('Content-Type') || '';
  const headers = new Headers();
  headers.set('Content-Type', contentType || 'application/json');
  for (const [k, v] of Object.entries(CORS_HEADERS)) headers.set(k, v);
  const cache = upstreamResponse.headers.get('Cache-Control');
  if (cache) headers.set('Cache-Control', cache);

  // Only JSON responses may contain media paths to rewrite. Pass everything
  // else (e.g. error pages) through untouched.
  if (!contentType.includes('json')) {
    return new Response(upstreamResponse.body, {
      status: upstreamResponse.status,
      headers,
    });
  }

  // Rewrite /media/* paths to absolute same-origin URLs so the browser loads
  // them through the /media proxy (CORS-safe), regardless of client version.
  const body = await upstreamResponse.text();
  const rewritten = rewriteMediaPaths(body, request);

  // Recompute Content-Length since the body changed.
  headers.delete('Content-Length');
  return new Response(rewritten, {
    status: upstreamResponse.status,
    headers,
  });
}

// Replace `/media/...` occurrences with absolute same-origin URLs. Matches the
// value inside JSON string values (e.g. "appBanner": "/media/2026/..."). Leaves
// already-absolute URLs (http/https) and data: URIs untouched.
function rewriteMediaPaths(jsonText, request) {
  const origin = new URL(request.url).origin;
  // Match "/media/ followed by a non-quote path, only when it's a value
  // (preceded by a quote). This avoids touching the literal string elsewhere.
  return jsonText.replace(
    /"(\/media\/[^"]+)"/g,
    (match, path) => `"${origin}${path}"`,
  );
}

function jsonResponse(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}

