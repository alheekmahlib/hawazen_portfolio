/**
 * Hero — adapted from the @efferd/hero-1 block.
 * A centered hero with a radial top glow, the name as a gradient headline, the
 * role/subtitle/bio, quick-nav buttons (profile/skills/education), and a
 * connect block with social + contact links.
 */
"use client";
import * as React from "react";
import { cn } from "@/lib/utils";
import type { Locale, ProfileContent, SiteInfo } from "@/lib/types";

interface QuickLink {
  key: string;
  label: string;
}

interface HeroProps {
  site: SiteInfo;
  profile: ProfileContent;
  locale: Locale;
  quickLinks: QuickLink[];
  /** Fired when a quick-section button is clicked. */
  onQuickOpen: (key: string) => void;
  ui: {
    connect: string;
    contact: string;
    email: string;
    whatsapp: string;
  };
}

export function Hero({
  site,
  locale,
  quickLinks,
  onQuickOpen,
  ui,
}: HeroProps) {
  const name = (locale === "ar" && site.name.ar) || site.name.en;
  const role = (locale === "ar" && site.role.ar) || site.role.en;
  const subtitle = (locale === "ar" && site.subtitle.ar) || site.subtitle.en;
  const bio = (locale === "ar" && site.bio.ar) || site.bio.en;

  return (
    <section className="relative mx-auto w-full max-w-[1100px] px-4 pt-28 pb-10 md:pt-36">
      {/* Top radial glow (decorative) */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-x-0 -top-10 -z-10 h-64 bg-[radial-gradient(60%_100%_at_50%_0%,rgb(33_158_188/0.18),transparent)]"
      />

      <div className="flex flex-col items-center gap-5 text-center animate-fade-in">
        {/* Role pill */}
        <span className="inline-flex items-center gap-2 rounded-full border border-border bg-card/40 px-4 py-1.5 text-xs font-medium text-foreground/80 backdrop-blur-sm">
          <span className="size-1.5 rounded-full bg-brand-secondary" />
          {subtitle}
        </span>

        {/* Name — gradient headline */}
        <h1 className="text-balance text-4xl font-extrabold leading-[1.05] tracking-tight md:text-6xl">
          <span className="text-gradient">{name}</span>
        </h1>

        {/* Role + bio */}
        <p className="max-w-2xl text-pretty text-base text-foreground/85 md:text-lg">
          {role}
        </p>
        <p className="max-w-xl text-pretty text-sm text-foreground/60 md:text-base">
          {bio}
        </p>

        {/* Quick-section buttons + Connect */}
        <div className="mt-2 flex flex-col items-center gap-4">
          <div className="flex flex-wrap items-center justify-center gap-2">
            {quickLinks.map((q) => (
              <button
                key={q.key}
                type="button"
                onClick={() => onQuickOpen(q.key)}
                className="group inline-flex items-center gap-1.5 rounded-full border border-border bg-card/30 px-4 py-2 text-sm font-medium text-foreground/90 backdrop-blur-sm transition-all hover:bg-muted/60 hover:scale-[1.03] cursor-pointer"
              >
                {q.label}
                <ArrowIcon className="size-3.5 transition-transform group-hover:translate-x-0.5 rtl:group-hover:-translate-x-0.5" />
              </button>
            ))}
            <a
              href="#contact"
              className="inline-flex items-center gap-1.5 rounded-full bg-brand-surface px-4 py-2 text-sm font-semibold text-white shadow-lg shadow-brand-surface/30 transition-all hover:scale-[1.03] hover:bg-brand-secondary"
            >
              {ui.contact}
            </a>
          </div>

          {/* Connect — social + email/whatsapp */}
          <ConnectBlock site={site} ui={ui} />
        </div>
      </div>
    </section>
  );
}

function ConnectBlock({
  site,
  ui,
}: {
  site: SiteInfo;
  ui: HeroProps["ui"];
}) {
  return (
    <div className="glass mt-4 w-full max-w-md rounded-2xl p-3">
      <p className="mb-2 px-1 text-xs font-medium uppercase tracking-wider text-foreground/50">
        {ui.connect}
      </p>
      <div className="grid grid-cols-2 gap-2">
        {site.social.map((s) => (
          <a
            key={s.url}
            href={s.url}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center justify-center gap-2 rounded-xl border border-border bg-card/30 px-3 py-2 text-xs font-medium text-foreground/90 transition-colors hover:bg-muted/60"
          >
            <SocialIcon label={s.label} />
            {s.label}
          </a>
        ))}
        <a
          href={`mailto:${site.contact.email}`}
          className="inline-flex items-center justify-center gap-2 rounded-xl border border-border bg-card/30 px-3 py-2 text-xs font-medium text-foreground/90 transition-colors hover:bg-muted/60"
        >
          <MailIcon />
          {ui.email}
        </a>
        <a
          href={site.contact.whatsapp}
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center justify-center gap-2 rounded-xl border border-border bg-card/30 px-3 py-2 text-xs font-medium text-foreground/90 transition-colors hover:bg-muted/60"
        >
          <WhatsAppIcon />
          {ui.whatsapp}
        </a>
      </div>
    </div>
  );
}

function ArrowIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12h14M13 6l6 6-6 6" />
    </svg>
  );
}
function MailIcon() {
  return (
    <svg className="size-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <rect x="2" y="4" width="20" height="16" rx="2" />
      <path d="m2 7 10 6 10-6" />
    </svg>
  );
}
function WhatsAppIcon() {
  return (
    <svg className="size-3.5" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12.04 2C6.58 2 2.13 6.45 2.13 11.91c0 1.75.46 3.45 1.32 4.95L2 22l5.25-1.38a9.9 9.9 0 0 0 4.79 1.22h.01c5.46 0 9.91-4.45 9.91-9.91 0-2.65-1.03-5.14-2.9-7.01A9.82 9.82 0 0 0 12.04 2Zm5.8 14.13c-.24.68-1.4 1.3-1.94 1.34-.5.04-1.13.2-3.7-.77-3.1-1.18-5.08-4.34-5.24-4.55-.15-.2-1.25-1.66-1.25-3.16 0-1.5.79-2.24 1.07-2.54.27-.3.6-.38.8-.38l.57.01c.18.01.43-.07.68.52.24.59.83 2.04.9 2.19.07.15.12.32.02.52-.1.2-.15.32-.3.5-.15.18-.31.39-.45.53-.15.15-.3.31-.13.6.17.3.76 1.25 1.63 2.02 1.12 1 2.06 1.31 2.36 1.46.3.15.47.13.64-.08.17-.2.74-.86.94-1.16.2-.3.4-.25.67-.15.27.1 1.7.8 2 .95.3.15.5.22.57.35.07.12.07.72-.17 1.4Z" />
    </svg>
  );
}
function SocialIcon({ label }: { label: string }) {
  const common = "size-3.5";
  if (/github/i.test(label)) {
    return (
      <svg className={common} viewBox="0 0 24 24" fill="currentColor">
        <path d="M12 2C6.48 2 2 6.58 2 12.25c0 4.53 2.87 8.37 6.84 9.73.5.1.68-.22.68-.49v-1.7c-2.78.62-3.37-1.37-3.37-1.37-.45-1.18-1.11-1.5-1.11-1.5-.91-.64.07-.62.07-.62 1 .07 1.53 1.06 1.53 1.06.9 1.57 2.36 1.12 2.94.85.09-.66.35-1.12.63-1.38-2.22-.26-4.56-1.14-4.56-5.07 0-1.12.39-2.03 1.03-2.75-.1-.26-.45-1.3.1-2.71 0 0 .84-.27 2.75 1.05a9.4 9.4 0 0 1 5 0c1.91-1.32 2.75-1.05 2.75-1.05.55 1.41.2 2.45.1 2.71.64.72 1.03 1.63 1.03 2.75 0 3.94-2.34 4.81-4.57 5.06.36.32.68.94.68 1.9v2.82c0 .27.18.6.69.49A10.26 10.26 0 0 0 22 12.25C22 6.58 17.52 2 12 2Z" />
      </svg>
    );
  }
  // LinkedIn
  return (
    <svg className={common} viewBox="0 0 24 24" fill="currentColor">
      <path d="M20.45 20.45h-3.56v-5.57c0-1.33-.02-3.04-1.85-3.04-1.85 0-2.14 1.45-2.14 2.94v5.67H9.35V9h3.42v1.56h.05c.48-.9 1.64-1.85 3.37-1.85 3.6 0 4.27 2.37 4.27 5.46v6.28ZM5.34 7.43a2.07 2.07 0 1 1 0-4.14 2.07 2.07 0 0 1 0 4.14ZM7.12 20.45H3.55V9h3.57v11.45ZM22.22 0H1.77C.8 0 0 .78 0 1.74v20.52C0 23.22.8 24 1.77 24h20.45c.98 0 1.78-.78 1.78-1.74V1.74C24 .78 23.2 0 22.22 0Z" />
    </svg>
  );
}
