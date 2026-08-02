// Cloudflare Pages Function — CORS proxy for dashboard media assets.
//
// Why this exists: Flutter Web loads images through XMLHttpRequest (to decode
// them onto a canvas), which is subject to CORS. The dashboard media server at
// dash.vexaltech.dev/media/* does NOT send `Access-Control-Allow-Origin`, so
// every image is blocked in the browser (net::ERR_FAILED). This function runs
// on the same origin as the site and re-serves the media with permissive CORS
// headers, making the images load as same-origin requests.
//
// Routing: any request to `/media/<path>` is proxied to
// `https://dash.vexaltech.dev/media/<path>`, preserving the path and query
// string. Only GET/HEAD/OPTIONS are handled; other methods 405.

const UPSTREAM_ORIGIN = 'https://dash.vexaltech.dev';

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, HEAD, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Max-Age': '86400',
};

export async function onRequestOptions() {
  return new Response(null, { status: 204, headers: CORS_HEADERS });
}

export async function onRequestGet(context) {
  return proxy(context);
}

export async function onRequestHead(context) {
  return proxy(context);
}

async function proxy(context) {
  const { request } = context;
  const url = new URL(request.url);

  // Rebuild the upstream URL: same path + query, different origin.
  const upstream = new URL(url.pathname + url.search, UPSTREAM_ORIGIN);

  let upstreamResponse;
  try {
    upstreamResponse = await fetch(upstream, {
      method: request.method,
      // Media is public; forward no credentials.
      headers: { Accept: '*/*' },
      cf: { cacheTtl: 86400, cacheEverything: true },
    });
  } catch (e) {
    return new Response('Upstream fetch failed', {
      status: 502,
      headers: CORS_HEADERS,
    });
  }

  // Forward the body and content-type, then layer our CORS headers on top.
  const headers = new Headers();
  for (const key of [
    'Content-Type',
    'Content-Length',
    'ETag',
    'Cache-Control',
    'Last-Modified',
  ]) {
    const value = upstreamResponse.headers.get(key);
    if (value) headers.set(key, value);
  }
  for (const [k, v] of Object.entries(CORS_HEADERS)) headers.set(k, v);

  // Immutable media should cache aggressively at the edge and in the browser.
  if (!headers.has('Cache-Control')) {
    headers.set('Cache-Control', 'public, max-age=31536000, immutable');
  }

  return new Response(upstreamResponse.body, {
    status: upstreamResponse.status,
    headers,
  });
}
