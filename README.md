# Hawazen Portfolio

Personal portfolio for **Hawazen Mahmood** — Mobile App Developer & Graphic Designer.

Built with **Astro + React + Tailwind**, bilingual (English / Arabic RTL), deployed to
Cloudflare Pages at **[hawazen.vexaltech.dev](https://hawazen.vexaltech.dev)**.

## Stack

- **[Astro](https://astro.build)** — static site generation, per-locale routes (`/` and `/ar/`)
- **[React](https://react.dev)** islands for interactive components (header, hero, card grid, modals, gallery)
- **[Tailwind CSS](https://tailwindcss.com)** + a glassmorphism design system (see `src/styles/global.css`)
- **IBM Plex Sans** (Latin) + **Noto Sans Arabic** (RTL), self-hosted via Fontsource
- Data fetched at build time from the dashboard API at `dash.vexaltech.dev`

## Content sources

| Section            | Source                                                                          |
| ------------------ | ------------------------------------------------------------------------------- |
| Apps / Libraries / Websites | `GET https://dash.vexaltech.dev/api/{apps,packages,websites}` (filtered by company) |
| Profile / Skills / Education | `GET https://dash.vexaltech.dev/api/sections/hawazen-site/entries`            |
| Hero identity / social / contact | Authored in `src/config.ts` (rarely changes)                             |

The field mapping and company filter live in `src/lib/data.ts` (mirrors the original
Flutter `dashboard_api_client.dart`).

## Development

```bash
npm install      # install dependencies
npm run dev      # start the dev server at http://localhost:4321
npm run build    # produce a static build in dist/
npm run preview  # preview the production build locally
```

## Project structure

```
public/              static assets (logo, favicons, manifest, _headers, _redirects)
src/
  components/        React islands (header, hero, section-grid, item-modal, …) + Astro sections
  components/ui/     shadcn primitives (button)
  i18n/ui.ts         UI string table + locale helpers
  layouts/           BaseLayout.astro (fonts, <html dir/lang>, background)
  lib/               data.ts (fetch + map), types.ts, utils.ts
  pages/             index.astro (en) + ar/index.astro (ar)
  styles/global.css  theme tokens, glassmorphism, background
  config.ts          site identity (name, role, social, contact)
astro.config.mjs     integrations (react, tailwind, sitemap) + site origin
```

## Deployment

Pushing to `main` triggers `.github/workflows/deploy_cloudflare_pages.yml`, which runs
`npm ci && npm run build` and deploys `dist/` via Wrangler. Set `SITE_ORIGIN` to pin the
canonical domain (defaults to `https://hawazen.vexaltech.dev`).
