/**
 * Header — adapted from the @efferd/header-2 block.
 * Sticky nav that gains a glass background once scrolled, a mobile drawer, and a
 * language toggle. Tracks which section is currently in view and highlights the
 * matching nav link (mirrors the Flutter PortfolioScrollController behaviour).
 */
"use client";
import * as React from "react";
import { cn } from "@/lib/utils";

export interface NavLink {
  /** A hash anchor like "#apps" (empty/"#" for the home link). */
  href: string;
  label: string;
}

interface HeaderProps {
  links: NavLink[];
  /** "العربية" when in EN, "English" when in AR — the target language label. */
  langToggleLabel: string;
  /** Target locale to switch to ("ar" | "en"). */
  langToggleTarget: "en" | "ar";
  /** Path to navigate to for the target locale ("/" or "/ar/"). */
  langToggleHref: string;
  logoSrc: string;
  brandLabel: string;
}

/** Detects scroll past a threshold (with hysteresis) to toggle the glass style. */
function useScrolled(threshold = 10) {
  const [scrolled, setScrolled] = React.useState(false);
  React.useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > threshold);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, [threshold]);
  return scrolled;
}

/**
 * Tracks the section whose heading is closest to the top of the viewport.
 * Returns the active anchor id (e.g. "apps", "contact") or "" for home.
 */
function useActiveSection(links: NavLink[]) {
  const [active, setActive] = React.useState("");

  React.useEffect(() => {
    // Collect the actual scroll targets (skip the home link which has no target).
    const targets = links
      .map((l) => {
        if (!l.href.startsWith("#")) return null;
        const id = l.href.slice(1);
        const el = id ? document.getElementById(id) : null;
        return el ? { id, el } : null;
      })
      .filter((t): t is { id: string; el: HTMLElement } => t !== null);

    if (targets.length === 0) return;

    const onScroll = () => {
      const scrollTop = window.scrollY;
      const docHeight = document.documentElement.scrollHeight;
      const maxScroll = docHeight - window.innerHeight;
      const probe = scrollTop + window.innerHeight * 0.4;
      // If we've scrolled to (or near) the very bottom, force the last section.
      const atBottom = scrollTop >= maxScroll - 4;

      let current = "";
      for (const { id, el } of targets) {
        const top = el.offsetTop;
        const bottom = top + el.offsetHeight;
        const isLast = id === targets[targets.length - 1].id;
        if (top <= probe && bottom >= probe) current = id;
        else if (isLast && atBottom) current = id;
      }
      // If we're near the very top, treat as home (no highlight).
      if (scrollTop < window.innerHeight * 0.2) current = "";
      setActive(current);
    };

    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    return () => {
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
    };
  }, [links]);

  return active;
}

export function Header({
  links,
  langToggleLabel,
  langToggleHref,
  logoSrc,
  brandLabel,
}: HeaderProps) {
  const scrolled = useScrolled(10);
  const [menuOpen, setMenuOpen] = React.useState(false);
  const active = useActiveSection(links);

  const isActive = (link: NavLink) => {
    if (!link.href.startsWith("#")) return active === ""; // home link
    return active === link.href.slice(1);
  };

  const switchLang = () => {
    window.location.href = langToggleHref;
  };

  const navLinkClasses = (link: NavLink) =>
    cn(
      "rounded-lg px-3 py-2 text-sm font-medium transition-colors cursor-pointer",
      isActive(link)
        ? "bg-brand-surface/25 text-white ring-1 ring-brand-surface/40"
        : "text-white/90 hover:bg-white/10 hover:text-white",
    );

  return (
    <header
      className={cn(
        "fixed inset-x-0 top-0 z-50 transition-all duration-300 ease-out",
        scrolled
          ? "border-b border-border md:top-2 md:mx-auto md:max-w-[1100px] md:rounded-2xl md:border md:shadow-2xl md:shadow-black/40"
          : "border-b border-transparent bg-transparent",
      )}
      style={
        scrolled
          ? {
              // Dark, near-opaque backdrop so nav text stays readable over any
              // content behind it (glass-strong alone is too transparent here).
              backgroundColor: "rgb(2 48 71 / 0.85)",
              backdropFilter: "blur(16px)",
              WebkitBackdropFilter: "blur(16px)",
            }
          : undefined
      }
    >
      <nav className="mx-auto flex h-16 max-w-[1200px] items-center justify-between gap-3 px-4 md:h-14">
        {/* Brand */}
        <a
          href="/"
          aria-label={brandLabel}
          className="flex items-center gap-2 rounded-lg p-1 transition-colors hover:bg-muted/60"
        >
          <img src={logoSrc} alt="" className="h-8 w-8" />
        </a>

        {/* Desktop nav */}
        <div className="hidden items-center gap-1 md:flex">
          {links.map((link) => (
            <a key={link.href} href={link.href} className={navLinkClasses(link)}>
              {link.label}
            </a>
          ))}
          <button
            type="button"
            onClick={switchLang}
            className="ml-2 rounded-lg border border-border px-3 py-1.5 text-sm font-medium text-foreground transition-colors hover:bg-muted/60 cursor-pointer"
          >
            {langToggleLabel}
          </button>
        </div>

        {/* Mobile toggle */}
        <button
          type="button"
          className="flex h-10 w-10 items-center justify-center rounded-lg border border-border text-foreground md:hidden cursor-pointer"
          aria-label="Toggle menu"
          aria-expanded={menuOpen}
          onClick={() => setMenuOpen((v) => !v)}
        >
          {menuOpen ? <CloseIcon /> : <MenuIcon />}
        </button>
      </nav>

      {/* Mobile drawer */}
      {menuOpen && (
        <div className="glass-strong animate-scale-in border-t border-border md:hidden">
          <nav className="mx-auto flex max-w-[1200px] flex-col gap-1 px-4 py-3">
            {links.map((link) => (
              <a
                key={link.href}
                href={link.href}
                onClick={() => setMenuOpen(false)}
                className={navLinkClasses(link)}
              >
                {link.label}
              </a>
            ))}
            <button
              type="button"
              onClick={switchLang}
              className="mt-1 rounded-lg border border-border px-3 py-2.5 text-left text-sm font-medium text-foreground transition-colors hover:bg-muted/60 cursor-pointer"
            >
              {langToggleLabel}
            </button>
          </nav>
        </div>
      )}
    </header>
  );
}

function MenuIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
      <path d="M4 6h16M4 12h16M4 18h16" />
    </svg>
  );
}
function CloseIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
      <path d="M6 6l12 12M18 6L6 18" />
    </svg>
  );
}
