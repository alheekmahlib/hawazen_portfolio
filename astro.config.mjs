// @ts-check
import { defineConfig } from "astro/config";
import react from "@astrojs/react";
import tailwind from "@astrojs/tailwind";
import sitemap from "@astrojs/sitemap";

// Canonical domain — pinned in CI via the SITE_ORIGIN env var.
const SITE_ORIGIN =
  process.env.SITE_ORIGIN ?? "https://hawazen.vexaltech.dev";

// https://astro.build/config
export default defineConfig({
  site: SITE_ORIGIN,
  integrations: [
    react(),
    tailwind({ applyBaseStyles: false }),
    sitemap({
      i18n: {
        defaultLocale: "en",
        locales: { en: "en", ar: "ar" },
      },
    }),
  ],
  build: {
    // Inline small stylesheets to keep the request count down on Cloudflare Pages.
    inlineStylesheets: "auto",
  },
  vite: {
    ssr: {
      // motion ships ESM that needs to be externalised during the SSR build.
      noExternal: ["motion"],
    },
  },
});
