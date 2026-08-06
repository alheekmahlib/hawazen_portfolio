/**
 * Build-time data layer.
 *
 * Fetches everything from the dashboard at build time (server-side, so no CORS
 * concerns). Re-implements the field mapping that lived in
 * `lib/features/content/data/dashboard_api_client.dart` so the output matches
 * the Flutter site exactly.
 */
import {
  DASHBOARD_COMPANY,
  DASHBOARD_ORIGIN,
  SITE,
} from "@/config";
import { absolutizeMedia } from "@/lib/utils";
import type {
  ActionLink,
  DesignGallery,
  Locale,
  PortfolioData,
  PortfolioItem,
  PortfolioSection,
  ProfileContent,
} from "@/lib/types";

const API_BASE = DASHBOARD_ORIGIN;
const SECTION_ENTRIES_URL = `${API_BASE}/api/sections/hawazen-site/entries`;

/* -------------------------------------------------------------------------- */
/*  Low-level fetch helpers                                                   */
/* -------------------------------------------------------------------------- */

type FetchInit = RequestInit & { revalidate?: number };

async function getJSON<T>(url: string, init?: FetchInit): Promise<T | null> {
  try {
    const res = await fetch(url, {
      headers: { accept: "application/json" },
      ...init,
    });
    if (!res.ok) {
      console.warn(`[data] ${res.status} ${res.statusText} for ${url}`);
      return null;
    }
    return (await res.json()) as T;
  } catch (err) {
    console.warn(`[data] fetch failed for ${url}:`, err);
    return null;
  }
}

/** Build a composite item id mirroring the Dart `slugify(name)-<apiId>`. */
function itemId(nameEn: string, apiId: number | string): string {
  const slug = nameEn
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
  return `${slug}-${apiId}`;
}

/* -------------------------------------------------------------------------- */
/*  Apps                                                                      */
/* -------------------------------------------------------------------------- */

interface LocalizedName {
  lang: string;
  name: string;
}

interface LocalizedBody {
  lang: string;
  value: string;
}

interface RawApp {
  id: number;
  slug?: string;
  /** Localized name as a language-tagged array (e.g. [{ lang: "ar", name: "…" }]). */
  appName?: LocalizedName[];
  companyName?: string;
  appLogo?: string;
  appBanner?: string;
  banners?: string[];
  /** Localized description as a language-tagged array (e.g. [{ lang: "ar", value: "…" }]). */
  body?: LocalizedBody[];
  urlAppStore?: string;
  urlPlayStore?: string;
  urlAppGallery?: string;
  urlMacAppStore?: string;
  tags?: string[];
}

/**
 * Pick a localized string out of a language-tagged array from the API.
 * Falls back to the other locale, then to the first available entry.
 */
function localizedValue<T extends { lang: string }>(
  arr: T[] | undefined,
  valueKey: keyof T,
  locale: Locale,
): string | undefined {
  if (!arr || arr.length === 0) return undefined;
  const exact = arr.find((e) => e.lang === locale);
  if (exact) return String(exact[valueKey] ?? "").trim() || undefined;
  const other = arr.find((e) => e.lang !== locale);
  if (other) return String(other[valueKey] ?? "").trim() || undefined;
  return String(arr[0][valueKey] ?? "").trim() || undefined;
}

function mapApp(raw: RawApp): PortfolioItem {
  const actions: ActionLink[] = [];
  if (raw.urlAppStore)
    actions.push({ key: "appstore", label: "App Store", href: raw.urlAppStore });
  if (raw.urlPlayStore)
    actions.push({
      key: "playstore",
      label: "Google Play",
      href: raw.urlPlayStore,
    });
  if (raw.urlAppGallery)
    actions.push({
      key: "appgallery",
      label: "AppGallery",
      href: raw.urlAppGallery,
    });
  if (raw.urlMacAppStore)
    actions.push({
      key: "macappstore",
      label: "Mac App Store",
      href: raw.urlMacAppStore,
    });

  // Resolve localized name/description from the API's language-tagged arrays.
  const nameEn = localizedValue(raw.appName, "name", "en");
  const nameAr = localizedValue(raw.appName, "name", "ar");
  const descEn = localizedValue(raw.body, "value", "en");
  const descAr = localizedValue(raw.body, "value", "ar");

  // Prefer the slug for a stable id; fall back to the (Latin) English name.
  const idSeed = raw.slug ?? nameEn ?? `app-${raw.id}`;

  return {
    id: itemId(idSeed, raw.id),
    name: { en: nameEn ?? nameAr ?? "App", ar: nameAr ?? nameEn },
    description: { en: descEn ?? descAr ?? "", ar: descAr ?? descEn ?? "" },
    banner: absolutizeMedia(raw.appBanner) ?? absolutizeMedia(raw.appLogo),
    gallery: (raw.banners ?? [])
      .map((b) => absolutizeMedia(b))
      .filter((b): b is string => Boolean(b)),
    actions,
    tags: raw.tags ?? [],
  };
}

async function fetchApps(): Promise<PortfolioItem[]> {
  const data = await getJSON<{ apps?: RawApp[] }>(`${API_BASE}/api/apps`);
  if (!data?.apps) return [];
  return data.apps
    .filter((a) => a.companyName === DASHBOARD_COMPANY)
    .map(mapApp);
}

/* -------------------------------------------------------------------------- */
/*  Packages                                                                  */
/* -------------------------------------------------------------------------- */

interface RawPackage {
  id: number;
  packageName?: string;
  companyName?: string;
  packageBanner?: string;
  packageLogo?: string;
  body?: string;
  docsUrl?: string;
  pubUrl?: string;
  githubUrl?: string;
}

function mapPackage(raw: RawPackage): PortfolioItem {
  const actions: ActionLink[] = [];
  if (raw.docsUrl)
    actions.push({ key: "docs", label: "Documentation", href: raw.docsUrl });
  if (raw.pubUrl) actions.push({ key: "pub", label: "pub.dev", href: raw.pubUrl });
  if (raw.githubUrl)
    actions.push({ key: "github", label: "GitHub", href: raw.githubUrl });

  return {
    id: itemId(raw.packageName ?? `package-${raw.id}`, raw.id),
    name: { en: raw.packageName ?? "Package" },
    description: { en: raw.body ?? "" },
    banner: absolutizeMedia(raw.packageBanner) ?? absolutizeMedia(raw.packageLogo),
    gallery: [],
    actions,
    tags: [],
  };
}

async function fetchPackages(): Promise<PortfolioItem[]> {
  const data = await getJSON<{ packages?: RawPackage[] }>(
    `${API_BASE}/api/packages`,
  );
  if (!data?.packages) return [];
  return data.packages
    .filter((p) => p.companyName === DASHBOARD_COMPANY)
    .map(mapPackage);
}

/* -------------------------------------------------------------------------- */
/*  Websites                                                                  */
/* -------------------------------------------------------------------------- */

interface RawWebsite {
  id: number;
  websiteName?: string;
  websiteNameEn?: string;
  websiteTitle?: string;
  companyName?: string;
  websiteBanner?: string;
  websiteLogo?: string;
  body?: string;
  urlLive?: string;
  urlGithub?: string;
  tags?: string[];
}

function mapWebsite(raw: RawWebsite): PortfolioItem {
  const actions: ActionLink[] = [];
  if (raw.urlLive)
    actions.push({ key: "live", label: "Visit Website", href: raw.urlLive });
  if (raw.githubUrl ?? raw.urlGithub)
    actions.push({
      key: "github",
      label: "GitHub",
      href: (raw.githubUrl ?? raw.urlGithub)!,
    });

  return {
    id: itemId(raw.websiteNameEn ?? raw.websiteName ?? `website-${raw.id}`, raw.id),
    name: {
      en: raw.websiteNameEn ?? raw.websiteName ?? "Website",
      ar: raw.websiteTitle,
    },
    description: { en: raw.body ?? "" },
    banner: absolutizeMedia(raw.websiteBanner) ?? absolutizeMedia(raw.websiteLogo),
    gallery: [],
    actions,
    tags: raw.tags ?? [],
  };
}

async function fetchWebsites(): Promise<PortfolioItem[]> {
  const data = await getJSON<{ websites?: RawWebsite[] }>(
    `${API_BASE}/api/websites`,
  );
  if (!data?.websites) return [];
  return data.websites
    .filter((w) => w.companyName === DASHBOARD_COMPANY)
    .map(mapWebsite);
}

/* -------------------------------------------------------------------------- */
/*  Profile content + designs (hawazen-site section)                          */
/* -------------------------------------------------------------------------- */

interface SectionEntry {
  id: number;
  values?: Record<string, string | string[] | boolean | null>;
}

interface SectionEntriesResponse {
  entries?: SectionEntry[];
}

/** Resolve a localized text pair from the dashboard entry values. */
function pick(
  values: Record<string, unknown>,
  enKey: string,
  arKey: string,
): { en: string; ar?: string } {
  const en = String(values[enKey] ?? "").trim();
  const ar = String(values[arKey] ?? "").trim();
  return { en, ar: ar || undefined };
}

async function fetchProfile(): Promise<ProfileContent> {
  const data = await getJSON<SectionEntriesResponse>(SECTION_ENTRIES_URL);
  const values = (data?.entries?.[0]?.values ?? {}) as Record<string, unknown>;
  return {
    profileSummary: pick(values, "profile_summary_text_en", "profile_summary_text_ar"),
    technicalSkills: pick(values, "technical_skills_text_en", "technical_skills_text_ar"),
    designSkills: pick(values, "design_skills_text_en", "design_skills_text_ar"),
    education: pick(values, "education_text_en", "education_text_ar"),
  };
}

/**
 * Designs gallery. Reads the `designs_photos` image-gallery field from the
 * dashboard section. The field is currently empty in the CMS — once the owner
 * uploads images, this section appears automatically (no code change needed).
 */
async function fetchDesigns(): Promise<DesignGallery | null> {
  const data = await getJSON<SectionEntriesResponse>(SECTION_ENTRIES_URL);
  const values = (data?.entries?.[0]?.values ?? {}) as Record<string, unknown>;
  const raw = values.designs_photos;
  const images = Array.isArray(raw)
    ? raw
        .map((src) => absolutizeMedia(String(src)))
        .filter((src): src is string => Boolean(src))
    : [];
  if (images.length === 0) return null;
  return {
    title: { en: "Designs", ar: "التصاميم" },
    images,
  };
}

/* -------------------------------------------------------------------------- */
/*  Public entry point                                                        */
/* -------------------------------------------------------------------------- */

/**
 * Resolve the full portfolio payload. Called from the page at build time.
 * Requests are cached for 1 hour to keep repeated builds cheap.
 */
export async function getPortfolioData(): Promise<PortfolioData> {
  const cache: FetchInit = { revalidate: 3600 };

  const [apps, packages, websites, profile, designs] = await Promise.all([
    fetchApps(),
    fetchPackages(),
    fetchWebsites(),
    fetchProfile(),
    fetchDesigns(),
  ]);

  const sections: PortfolioSection[] = [
    { slug: "apps", title: { en: "Apps", ar: "التطبيقات" }, items: apps },
    {
      slug: "packages",
      title: { en: "Libraries", ar: "المكتبات" },
      items: packages,
    },
    {
      slug: "websites",
      title: { en: "Websites", ar: "المواقع" },
      items: websites,
    },
  ].filter((s) => s.items.length > 0);

  return { site: SITE, sections, designs, profile };
}
