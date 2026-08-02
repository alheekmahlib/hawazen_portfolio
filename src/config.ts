import type { SiteInfo } from "@/lib/types";

/**
 * Static site information.
 *
 * The dashboard `hawazen-site` section holds the dynamic body content
 * (profile/skills/education) but does NOT carry the hero identity, social
 * links, or contact details. Those live here because they change rarely and
 * don't belong in the CMS. Values are mirrored from the original Flutter
 * `content.json` so the rendered site is byte-identical to the live one.
 */
export const SITE: SiteInfo = {
  name: {
    en: "Hawazen Mahmood",
    ar: "هوازن محمود",
  },
  role: {
    en: "Mobile App Developer with proficiencies in Flutter Cross-Platform software development.",
    ar: "مطوّر تطبيقات جوّال متخصّص في تطوير البرمجيات متعددة المنصّات باستخدام إطار عمل Flutter.",
  },
  subtitle: {
    en: "Mobile App Developer",
    ar: "مطوّر تطبيقات",
  },
  bio: {
    en: "I build well-structured Flutter apps and design clean, modern interfaces — turning ideas into polished cross-platform products.",
    ar: "أبني تطبيقات Flutter منظّمة وأصمّم واجهات عصرية وأنيقة — أحوّل الأفكار إلى منتجات متعددة المنصّات متقنة.",
  },
  social: [
    {
      label: "GitHub",
      url: "https://github.com/alheekmahlib",
    },
    {
      label: "LinkedIn",
      url: "https://www.linkedin.com/in/hawazen-sameer-7300b3260/",
    },
  ],
  contact: {
    email: "haozo89@gmail.com",
    phone: "+19712278630",
    whatsapp: "https://wa.me/19712278630",
  },
  domain: "https://hawazen.vexaltech.dev",
};

/** Dashboard origin — media paths are resolved against this. */
export const DASHBOARD_ORIGIN = "https://dash.vexaltech.dev";

/** Company filter — only dashboard items with this company are shown. */
export const DASHBOARD_COMPANY = "Alheekmah Library";

/** Google Search Console verification tokens (preserved from web/index.html). */
export const GSC_TOKENS = [
  "90SjwhWwQVvPPQbxKXGoUgQT9CvCQCSeVKX3ANZQHkY",
  "OIn9l5KsNpj5G2Fulyl_ZjVaXNXbBsZl2HdPzXZc1YM",
];
