import type { Locale } from "@/lib/types";

/** UI strings (mirrors lib/core/l10n/app_strings.dart). */
export const ui = {
  nav: {
    home: { en: "Home", ar: "الرئيسية" },
    contact: { en: "Contact", ar: "تواصل" },
  },
  hero: {
    connect: { en: "Connect", ar: "تواصل معي" },
    contact: { en: "Contact", ar: "تواصل" },
    email: { en: "Email", ar: "البريد" },
    whatsapp: { en: "WhatsApp", ar: "واتساب" },
  },
  quick: {
    "profile-summary": { en: "Profile Summary", ar: "ملخص الملف الشخصي" },
    "technical-skills": { en: "Technical Skills", ar: "المهارات التقنية" },
    "design-skills": { en: "Design Skills", ar: "مهارات التصميم" },
    education: { en: "Education", ar: "التعليم" },
  },
  contact: {
    title: { en: "Get in touch", ar: "للتواصل" },
    emailLabel: { en: "Email", ar: "البريد الإلكتروني" },
    phoneLabel: { en: "Phone", ar: "الهاتف" },
    email: { en: "Send an email", ar: "أرسل بريداً" },
    whatsapp: { en: "Message on WhatsApp", ar: "راسلني على واتساب" },
  },
  modal: {
    close: { en: "Close", ar: "إغلاق" },
    description: { en: "Description", ar: "الوصف" },
    gallery: { en: "Gallery", ar: "المعرض" },
    links: { en: "Links", ar: "الروابط" },
    tags: { en: "Tags", ar: "الوسوم" },
    prev: { en: "Previous", ar: "السابق" },
    next: { en: "Next", ar: "التالي" },
  },
  footer: {
    about: { en: "About", ar: "نبذة" },
    quickLinks: { en: "Quick Links", ar: "روابط سريعة" },
    connect: { en: "Connect", ar: "تواصل" },
    rights: { en: "All rights reserved.", ar: "جميع الحقوق محفوظة." },
    builtWith: { en: "Built with Astro", ar: "بُني بـ Astro" },
  },
  langToggle: { en: "العربية", ar: "English" },
} as const;

export type UIString = { en: string; ar?: string };

/** Resolve a localized string with `en` fallback. */
export function t(value: UIString | undefined, locale: Locale): string {
  if (!value) return "";
  return (locale === "ar" && value.ar) || value.en;
}

/** Parse the `lang` query param; defaults to `en`. */
export function parseLocale(param: string | URL | undefined | null): Locale {
  const value =
    typeof param === "string"
      ? param
      : param instanceof URL
        ? param.searchParams.get("lang") ?? ""
        : "";
  return value === "ar" ? "ar" : "en";
}
