/**
 * PortfolioApp — the interactive client island that owns modal state.
 *
 * The Flutter app drove everything (item details, quick-sections) from a single
 * page with shared modal state. We mirror that here: this component renders the
 * hero, the section grids, and the modals, holding which item or quick-section
 * is currently open. Header/Contact/Footer are server-rendered by Astro.
 */
"use client";
import * as React from "react";
import { Header, type NavLink } from "@/components/header/header";
import { Hero } from "@/components/hero/hero";
import { SectionGrid } from "@/components/section-grid";
import { ItemModal } from "@/components/item-modal";
import { QuickModal } from "@/components/quick-modal";
import { DesignsGallery } from "@/components/designs-gallery";
import type { Locale, PortfolioData, PortfolioItem } from "@/lib/types";
import { ui as uiTable, t } from "@/i18n/ui";

interface PortfolioAppProps {
  data: PortfolioData;
  locale: Locale;
}

type QuickKey = "profile-summary" | "technical-skills" | "design-skills" | "education";

const QUICK_KEYS: QuickKey[] = ["profile-summary", "technical-skills", "design-skills", "education"];

export function PortfolioApp({ data, locale }: PortfolioAppProps) {
  // Which item modal is open (section slug + item id).
  const [openItem, setOpenItem] = React.useState<{ slug: string; id: string } | null>(null);
  // Which quick-section modal is open.
  const [openQuick, setOpenQuick] = React.useState<QuickKey | null>(null);

  const navLinks: NavLink[] = [
    { label: t(uiTable.nav.home, locale), href: locale === "ar" ? "/ar/" : "/" },
    ...data.sections
      .filter((s) => s.items.length > 0)
      .map((s) => ({ label: t(s.title, locale), href: `#${s.slug}` })),
    // Designs gallery link — only shown when the CMS field has images.
    ...(data.designs && data.designs.images.length > 0
      ? [{ label: t(data.designs.title, locale), href: "#designs" }]
      : []),
    { label: t(uiTable.nav.contact, locale), href: "#contact" },
  ];

  // Resolve the currently-open item object (looked up across all sections).
  const openItemObj: PortfolioItem | undefined = openItem
    ? data.sections.find((s) => s.slug === openItem.slug)?.items.find((i) => i.id === openItem.id)
    : undefined;

  const resolveTitle = (item: PortfolioItem) => t(item.name, locale);
  const resolveSubtitle = (item: PortfolioItem) => t(item.description, locale);

  const quickLinks = QUICK_KEYS.map((key) => ({ key, label: t(uiTable.quick[key], locale) }));

  const quickContent: Record<QuickKey, { title: string; body: string; asList: boolean }> = {
    "profile-summary": {
      title: t(uiTable.quick["profile-summary"], locale),
      body: t(data.profile.profileSummary, locale),
      asList: false,
    },
    "technical-skills": {
      title: t(uiTable.quick["technical-skills"], locale),
      body: t(data.profile.technicalSkills, locale),
      asList: true,
    },
    "design-skills": {
      title: t(uiTable.quick["design-skills"], locale),
      body: t(data.profile.designSkills, locale),
      asList: true,
    },
    education: {
      title: t(uiTable.quick.education, locale),
      body: t(data.profile.education, locale),
      asList: false,
    },
  };

  const modalUi = uiTable.modal;

  return (
    <>
      <Header
        links={navLinks}
        langToggleLabel={t(uiTable.langToggle, locale)}
        langToggleTarget={locale === "en" ? "ar" : "en"}
        langToggleHref={locale === "en" ? "/ar/" : "/"}
        logoSrc="/hawazen.svg"
        brandLabel={t(data.site.name, locale)}
      />

      <Hero
        site={data.site}
        profile={data.profile}
        locale={locale}
        quickLinks={quickLinks}
        onQuickOpen={(key) => setOpenQuick(key as QuickKey)}
        ui={{
          connect: t(uiTable.hero.connect, locale),
          contact: t(uiTable.hero.contact, locale),
          email: t(uiTable.hero.email, locale),
          whatsapp: t(uiTable.hero.whatsapp, locale),
        }}
      />

      {/* Section grids */}
      {data.sections.map((section) => (
        <SectionGrid
          key={section.slug}
          section={{ ...section, title: { en: t(section.title, locale), ar: section.title.ar } }}
          locale={locale}
          onItemOpen={(slug, id) => setOpenItem({ slug, id })}
          resolveTitle={resolveTitle}
          resolveSubtitle={resolveSubtitle}
        />
      ))}

      {/* Designs gallery (hidden until the CMS field is populated) */}
      {data.designs && data.designs.images.length > 0 && (
        <section id="designs" className="mx-auto w-full max-w-[1200px] scroll-mt-24 px-4 py-6">
          <div className="glass mb-4 flex items-center justify-between rounded-2xl px-5 py-3">
            <h2 className="text-lg font-extrabold tracking-tight md:text-xl">{t(data.designs.title, locale)}</h2>
            <span className="rounded-full border border-border bg-muted/40 px-2.5 py-0.5 text-xs font-medium text-foreground/70">{data.designs.images.length}</span>
          </div>
          <DesignsGallery images={data.designs.images} title={t(data.designs.title, locale)} ui={{ prev: t(modalUi.prev, locale), next: t(modalUi.next, locale) }} />
        </section>
      )}

      {/* Item detail modal */}
      {openItemObj && (
        <ItemModal
          item={openItemObj}
          title={t(openItemObj.name, locale)}
          description={t(openItemObj.description, locale)}
          locale={locale}
          open={Boolean(openItem)}
          onClose={() => setOpenItem(null)}
          ui={{
            close: t(modalUi.close, locale),
            description: t(modalUi.description, locale),
            gallery: t(modalUi.gallery, locale),
            links: t(modalUi.links, locale),
            tags: t(modalUi.tags, locale),
            prev: t(modalUi.prev, locale),
            next: t(modalUi.next, locale),
          }}
        />
      )}

      {/* Quick-section modal */}
      {openQuick && (
        <QuickModal
          title={quickContent[openQuick].title}
          body={quickContent[openQuick].body}
          asList={quickContent[openQuick].asList}
          open={Boolean(openQuick)}
          onClose={() => setOpenQuick(null)}
          closeLabel={t(modalUi.close, locale)}
        />
      )}
    </>
  );
}
