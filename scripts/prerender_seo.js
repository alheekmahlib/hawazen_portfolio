#!/usr/bin/env node
/**
 * SEO Pre-renderer for Flutter Web SPA
 *
 * Fetches content.json and generates static HTML files for every route
 * so search engines can index the site without executing JavaScript.
 *
 * Usage: node scripts/prerender_seo.js <build-dir> <base-href> [content-url]
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// ── Config ──────────────────────────────────────────────────────────────────
const args = process.argv.slice(2);
const BUILD_DIR = args[0] || 'build/web';
const BASE_HREF = args[1] || '/';
const CONTENT_URL =
  args[2] ||
  'https://raw.githubusercontent.com/alheekmahlib/data/main/websites/hawazen_portfolio/content.json';
const FALLBACK_URL =
  'https://gitlab.com/haozo89/data/-/raw/main/websites/hawazen_portfolio/content.json';
const SITE_ORIGIN = 'https://hawazenmahmood.github.io'; // update if custom domain

function joinUrl(base, ...segments) {
  // Normalize: ensure single slashes, no trailing double slashes
  let result = base.replace(/\/+$/, '');
  for (const seg of segments) {
    const clean = seg.replace(/^\/+/, '').replace(/\/+$/, '');
    if (clean) result += '/' + clean;
  }
  return result || '/';
}

// ── Helpers ─────────────────────────────────────────────────────────────────

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, { headers: { 'User-Agent': 'prerender-seo' } }, (res) => {
        if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
          return fetchJson(res.headers.location).then(resolve).catch(reject);
        }
        if (res.statusCode < 200 || res.statusCode >= 300) {
          return reject(new Error(`HTTP ${res.statusCode} from ${url}`));
        }
        let body = '';
        res.on('data', (c) => (body += c));
        res.on('end', () => {
          try {
            resolve(JSON.parse(body));
          } catch (e) {
            reject(e);
          }
        });
      })
      .on('error', reject);
  });
}

function localized(obj, locale) {
  if (!obj || typeof obj === 'string') return obj || '';
  return obj[locale] || obj.en || Object.values(obj)[0] || '';
}

// ── Template ────────────────────────────────────────────────────────────────

function buildHtml({ title, description, canonicalPath, ogImage, jsonLd, originalHtml }) {
  const fullUrl = SITE_ORIGIN + joinUrl(BASE_HREF, canonicalPath);
  const og = ogImage || '';

  // Extract the body content and style from original
  const bodyStyleMatch = originalHtml.match(/<body([^>]*)>/);
  const bodyStyle = bodyStyleMatch ? bodyStyleMatch[1] : '';
  const styleMatch = originalHtml.match(/<style[^>]*>([\s\S]*?)<\/style>/);
  const styleBlock = styleMatch ? styleMatch[0] : '';

  // Build extra meta tags
  const metaTags = `
  <title>${escapeHtml(title)}</title>
  <meta name="description" content="${escapeHtml(description)}">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="${escapeHtml(fullUrl)}">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="${escapeHtml(title)}">
  <meta property="og:description" content="${escapeHtml(description)}">
  <meta property="og:url" content="${escapeHtml(fullUrl)}">
  ${og ? `<meta property="og:image" content="${escapeHtml(og)}">` : ''}
  <meta property="og:site_name" content="Hawazen Mahmood">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="${og ? 'summary_large_image' : 'summary'}">
  <meta name="twitter:title" content="${escapeHtml(title)}">
  <meta name="twitter:description" content="${escapeHtml(description)}">
  ${og ? `<meta name="twitter:image" content="${escapeHtml(og)}">` : ''}

  <!-- Alternates -->
  <link rel="alternate" hreflang="en" href="${escapeHtml(fullUrl)}?lang=en">
  <link rel="alternate" hreflang="ar" href="${escapeHtml(fullUrl)}?lang=ar">
  <link rel="alternate" hreflang="x-default" href="${escapeHtml(fullUrl)}">
`;

  // Build JSON-LD
  const jsonLdBlock = jsonLd
    ? `\n  <script type="application/ld+json">\n${JSON.stringify(jsonLd, null, 2)}\n  </script>`
    : '';

  return `<!DOCTYPE html>
<html>
<head>
  <base href="${BASE_HREF}">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">${metaTags}${jsonLdBlock}

  <!-- iOS meta tags & icons -->
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Hawazen Mahmood">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <link rel="manifest" href="manifest.json">
  ${styleBlock}
</head>
<body${bodyStyle}>
  <script src="flutter_bootstrap.js" async></script>
</body>
</html>`;
}

// ── Route generation ────────────────────────────────────────────────────────

function buildPersonLd(data) {
  const site = data.site || {};
  return {
    '@context': 'https://schema.org',
    '@type': 'Person',
    name: localized(site.name, 'en'),
    jobTitle: localized(site.role, 'en'),
    description: localized(site.bio, 'en'),
    url: SITE_ORIGIN + joinUrl(BASE_HREF),
    email: site.contact?.email || '',
    telephone: site.contact?.phone || '',
    sameAs: (site.social || []).map((s) => s.url),
  };
}

function buildWebPageLd(title, description, url) {
  return {
    '@context': 'https://schema.org',
    '@type': 'WebPage',
    name: title,
    description: description,
    url: url,
  };
}

function buildSoftwareAppLd(item, section) {
  const fields = item.fields || {};
  return {
    '@context': 'https://schema.org',
    '@type': 'SoftwareApplication',
    name: localized(fields.name, 'en'),
    description: localized(fields.description, 'en'),
    applicationCategory: section.slug === 'apps' ? 'MobileApplication' : 'DeveloperApplication',
    image: fields.banner || '',
    offers: {
      '@type': 'Offer',
      price: '0',
      priceCurrency: 'USD',
    },
  };
}

function generateRoutes(data) {
  const site = data.site || {};
  const routes = [];
  const personLd = buildPersonLd(data);

  // Homepage
  routes.push({
    path: '/',
    title: `${localized(site.name, 'en')} – ${localized(site.role, 'en')}`,
    description: localized(site.bio, 'en'),
    jsonLd: personLd,
    ogImage: '',
  });

  // Sections & items
  for (const section of data.sections || []) {
    if (!section.enabled) continue;
    const sectionTitle = localized(section.title, 'en');
    const sectionDesc = `${sectionTitle} by ${localized(site.name, 'en')}`;

    // Section page
    routes.push({
      path: `/${section.slug}/`,
      title: `${sectionTitle} – ${localized(site.name, 'en')}`,
      description: sectionDesc,
      jsonLd: buildWebPageLd(sectionTitle, sectionDesc, SITE_ORIGIN + joinUrl(BASE_HREF, section.slug)),
      ogImage: '',
    });

    // Item pages
    for (const item of section.items || []) {
      if (!item.enabled) continue;
      const fields = item.fields || {};
      const itemName = localized(fields.name, 'en');
      const itemDesc = localized(fields.description, 'en');
      const banner = fields.banner || '';

      routes.push({
        path: `/${section.slug}/${item.id}/`,
        title: `${itemName} – ${localized(site.name, 'en')}`,
        description: itemDesc,
        jsonLd: buildSoftwareAppLd(item, section),
        ogImage: banner,
      });
    }
  }

  return routes;
}

function writeHtml(dir, html) {
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, 'index.html'), html, 'utf8');
}

// ── Main ────────────────────────────────────────────────────────────────────

async function main() {
  console.log('🔍 SEO Pre-renderer');
  console.log(`   Build dir: ${BUILD_DIR}`);
  console.log(`   Base href: ${BASE_HREF}`);
  console.log(`   Content URL: ${CONTENT_URL}`);

  // Read original index.html
  const originalPath = path.join(BUILD_DIR, 'index.html');
  const originalHtml = fs.readFileSync(originalPath, 'utf8');

  // Fetch content
  let data;
  try {
    console.log('📥 Fetching content.json from GitHub...');
    data = await fetchJson(CONTENT_URL);
  } catch (e) {
    console.log(`⚠️  GitHub failed (${e.message}), trying GitLab fallback...`);
    data = await fetchJson(FALLBACK_URL);
  }
  console.log('✅ Content loaded');

  // Generate routes
  const routes = generateRoutes(data);
  console.log(`📄 Generating ${routes.length} pages...`);

  let written = 0;
  for (const route of routes) {
    const html = buildHtml({
      title: route.title,
      description: route.description,
      canonicalPath: route.path === '/' ? '/' : joinUrl(BASE_HREF, route.path),
      ogImage: route.ogImage,
      jsonLd: route.jsonLd,
      originalHtml,
    });

    // Root path → overwrite build/web/index.html
    // Other paths → build/web/{slug}/index.html
    const dir = route.path === '/'
      ? BUILD_DIR
      : path.join(BUILD_DIR, ...route.path.split('/').filter(Boolean));

    writeHtml(dir, html);
    written++;
    console.log(`   ✓ ${route.path} → ${route.title}`);
  }

  // Generate sitemap.xml
  const sitemapUrls = routes.map((r) => {
    const fullUrl = SITE_ORIGIN + joinUrl(BASE_HREF, r.path);
    return `  <url>\n    <loc>${escapeHtml(fullUrl)}</loc>\n    <changefreq>weekly</changefreq>\n    <priority>${r.path === '/' ? '1.0' : r.path.endsWith('/') && r.path.split('/').length === 3 ? '0.8' : '0.6'}</priority>\n  </url>`;
  });

  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${sitemapUrls.join('\n')}
</urlset>`;

  fs.writeFileSync(path.join(BUILD_DIR, 'sitemap.xml'), sitemap, 'utf8');
  console.log(`🗺️  sitemap.xml generated (${routes.length} URLs)`);

  // Generate robots.txt
  const robots = `User-agent: *
Allow: /

Sitemap: ${SITE_ORIGIN + joinUrl(BASE_HREF, 'sitemap.xml')}
`;
  fs.writeFileSync(path.join(BUILD_DIR, 'robots.txt'), robots, 'utf8');
  console.log('🤖 robots.txt generated');

  console.log(`\n✨ Done! ${written} pages pre-rendered.`);
}

main().catch((e) => {
  console.error('❌ Pre-render failed:', e.message);
  process.exit(1);
});
