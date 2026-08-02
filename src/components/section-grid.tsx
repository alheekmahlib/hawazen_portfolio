/**
 * SectionGrid — adapted from the @efferd/blogs-3 block.
 * Renders a responsive 1/2/3-column card grid for a portfolio section. Each card
 * mirrors the Flutter SectionItemCard: a cover image with a bottom→top scrim, a
 * glass caption with title + subtitle, and a gradient arrow-dot.
 */
"use client";
import * as React from "react";
import { LazyImage } from "@/components/lazy-image";
import { cn } from "@/lib/utils";
import type { Locale, PortfolioItem, PortfolioSection } from "@/lib/types";

interface SectionGridProps {
  section: PortfolioSection;
  locale: Locale;
  onItemOpen: (sectionSlug: string, itemId: string) => void;
  resolveTitle: (item: PortfolioItem) => string;
  resolveSubtitle: (item: PortfolioItem) => string;
}

export function SectionGrid({
  section,
  locale: _locale,
  onItemOpen,
  resolveTitle,
  resolveSubtitle,
}: SectionGridProps) {
  return (
    <section id={section.slug} className="mx-auto w-full max-w-[1200px] scroll-mt-24 px-4 py-6">
      {/* Section header — glass bar with title + count pill */}
      <div className="glass mb-4 flex items-center justify-between rounded-2xl px-5 py-3">
        <h2 className="text-lg font-extrabold tracking-tight md:text-xl">
          {section.title.en}
        </h2>
        <span className="rounded-full border border-border bg-muted/40 px-2.5 py-0.5 text-xs font-medium text-foreground/70">
          {section.items.length}
        </span>
      </div>

      <div className="grid grid-cols-1 gap-3.5 sm:grid-cols-2 lg:grid-cols-3">
        {section.items.map((item) => (
          <Card
            key={item.id}
            item={item}
            title={resolveTitle(item)}
            subtitle={resolveSubtitle(item)}
            onOpen={() => onItemOpen(section.slug, item.id)}
          />
        ))}
      </div>
    </section>
  );
}

interface CardProps {
  item: PortfolioItem;
  title: string;
  subtitle: string;
  onOpen: () => void;
}

function Card({ item, title, subtitle, onOpen }: CardProps) {
  const [hovered, setHovered] = React.useState(false);
  return (
    <button
      type="button"
      onClick={onOpen}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      className={cn(
        "group relative overflow-hidden rounded-3xl text-left transition-transform duration-200 ease-out cursor-pointer",
        hovered ? "scale-[1.02]" : "scale-100",
      )}
      style={{ aspectRatio: "16 / 10.6" }}
    >
      {/* Cover image */}
      {item.banner ? (
        <LazyImage
          alt={title}
          src={item.banner}
          ratio={16 / 10.6}
          inView
          containerClassName="absolute inset-0 size-full rounded-3xl border-0"
          className="group-hover:scale-105"
        />
      ) : (
        <div className="absolute inset-0 size-full rounded-3xl bg-gradient-to-br from-brand-surface/30 to-brand-bg-end" />
      )}

      {/* Bottom→top scrim */}
      <div className="pointer-events-none absolute inset-0 rounded-3xl bg-gradient-to-t from-black/80 via-black/10 to-black/10" />

      {/* Glass caption */}
      <div className="absolute inset-x-3.5 bottom-3.5">
        <div className="glass flex items-start gap-2.5 rounded-2xl p-3">
          <div className="min-w-0 flex-1">
            <h3 className="truncate text-sm font-extrabold md:text-base">{title}</h3>
            {subtitle && (
              <p className="mt-1.5 line-clamp-2 text-xs text-foreground/70">{subtitle}</p>
            )}
          </div>
          <ArrowDot />
        </div>
      </div>
    </button>
  );
}

/** Gradient circular arrow — matches Flutter ArrowDot (#219EBC → #22D3EE). */
function ArrowDot() {
  return (
    <span
      className="flex size-10 shrink-0 items-center justify-center rounded-full text-white shadow-lg shadow-black/40"
      style={{
        background: "linear-gradient(135deg, #219EBC, #22D3EE)",
      }}
    >
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" className="rtl:-scale-x-100">
        <path d="M5 12h14M13 6l6 6-6 6" />
      </svg>
    </span>
  );
}
