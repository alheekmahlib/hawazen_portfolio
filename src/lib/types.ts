/**
 * Domain types for the portfolio.
 *
 * The dashboard API returns snake_case field names per entity
 * (see lib/features/content/data/dashboard_api_client.dart for the original
 * Dart mapping). These typed models are the canonical shape consumed by the UI.
 */

export type Locale = "en" | "ar";

/** A value that may be localized per-locale, with `en` as the fallback. */
export type L10n = { en: string; ar?: string };

/** A named external action button shown on a detail modal (App Store, GitHub…). */
export interface ActionLink {
  /** Stable key used for icon + label resolution in the modal. */
  key:
    | "appstore"
    | "playstore"
    | "appgallery"
    | "macappstore"
    | "pub"
    | "github"
    | "docs"
    | "live";
  label: string;
  href: string;
}

/** A single portfolio item (app, package, or website). */
export interface PortfolioItem {
  /** Composite id like `quran-1` (slug-name + api id). */
  id: string;
  name: L10n;
  description: L10n;
  banner: string | null;
  /** Gallery/screenshots — full URLs. */
  gallery: string[];
  actions: ActionLink[];
  tags: string[];
}

export interface PortfolioSection {
  /** Canonical slug: `apps` | `packages` | `websites`. */
  slug: string;
  title: L10n;
  items: PortfolioItem[];
}

/** A design gallery entry (driven by the dashboard `designs_photos` field). */
export interface DesignGallery {
  title: L10n;
  images: string[];
}

/** Static profile/skills content — sourced from the dashboard `hawazen-site` section. */
export interface ProfileContent {
  profileSummary: L10n;
  technicalSkills: L10n;
  designSkills: L10n;
  education: L10n;
}

/** Static site info — authored in src/config.ts (rarely changes). */
export interface SiteInfo {
  name: L10n;
  role: L10n;
  subtitle: L10n;
  bio: L10n;
  social: { label: string; url: string }[];
  contact: { email: string; phone: string; whatsapp: string };
  domain: string;
}

/** The fully-resolved payload handed to the page. */
export interface PortfolioData {
  site: SiteInfo;
  sections: PortfolioSection[];
  designs: DesignGallery | null;
  profile: ProfileContent;
}
