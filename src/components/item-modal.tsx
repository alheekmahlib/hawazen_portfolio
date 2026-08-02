/**
 * ItemModal — adapted from Flutter's ItemBottomSheet.
 * A full-screen detail modal for a portfolio item: hero banner, title +
 * description (markdown-ish plain text), screenshot gallery with a lightbox,
 * action links (store/pub/github/docs/live), and tags. Includes keyboard
 * (Esc) + backdrop-click close and body-scroll lock.
 */
"use client";
import * as React from "react";
import { cn } from "@/lib/utils";
import type { ActionLink, Locale, PortfolioItem } from "@/lib/types";

interface ItemModalProps {
  item: PortfolioItem;
  title: string;
  description: string;
  locale: Locale;
  open: boolean;
  onClose: () => void;
  ui: {
    close: string;
    description: string;
    gallery: string;
    links: string;
    tags: string;
    prev: string;
    next: string;
  };
}

export function ItemModal({
  item,
  title,
  description,
  open,
  onClose,
  ui,
}: ItemModalProps) {
  // Esc to close + lock body scroll while open.
  React.useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    document.addEventListener("keydown", onKey);
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = prev;
    };
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-[100] flex items-end justify-center sm:items-center" role="dialog" aria-modal="true" aria-label={title}>
      {/* Backdrop */}
      <button
        type="button"
        aria-label={ui.close}
        onClick={onClose}
        className="absolute inset-0 cursor-default bg-black/70 backdrop-blur-sm animate-fade-in"
      />

      {/* Sheet */}
      <div className="glass-strong relative z-10 max-h-[92vh] w-full max-w-[980px] overflow-y-auto rounded-t-3xl sm:rounded-3xl animate-scale-in">
        {/* Close button */}
        <button
          type="button"
          onClick={onClose}
          aria-label={ui.close}
          className="absolute end-4 top-4 z-20 flex size-9 items-center justify-center rounded-full border border-border bg-card/60 text-foreground backdrop-blur-md transition-colors hover:bg-muted/70 cursor-pointer"
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round"><path d="M6 6l12 12M18 6L6 18" /></svg>
        </button>

        {/* Hero banner */}
        {item.banner && (
          <div className="relative aspect-[16/9] w-full overflow-hidden rounded-t-3xl sm:rounded-t-3xl">
            <img src={item.banner} alt={title} className="size-full object-cover" />
            <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent" />
          </div>
        )}

        <div className="p-5 md:p-8">
          {/* Title */}
          <h2 className="text-2xl font-extrabold tracking-tight md:text-3xl">{title}</h2>

          {/* Tags */}
          {item.tags.length > 0 && (
            <div className="mt-3 flex flex-wrap gap-2">
              {item.tags.map((tag) => (
                <span key={tag} className="rounded-full border border-border bg-muted/40 px-2.5 py-0.5 text-xs text-foreground/70">{tag}</span>
              ))}
            </div>
          )}

          {/* Description */}
          {description && (
            <div className="mt-5">
              <h3 className="mb-2 text-xs font-semibold uppercase tracking-wider text-foreground/50">{ui.description}</h3>
              <p className="whitespace-pre-line text-pretty text-sm leading-relaxed text-foreground/80 md:text-base">{description}</p>
            </div>
          )}

          {/* Action links */}
          {item.actions.length > 0 && (
            <div className="mt-6">
              <h3 className="mb-2 text-xs font-semibold uppercase tracking-wider text-foreground/50">{ui.links}</h3>
              <div className="flex flex-wrap gap-2">
                {item.actions.map((a) => (
                  <ActionBadge key={a.key} action={a} />
                ))}
              </div>
            </div>
          )}

          {/* Gallery */}
          {item.gallery.length > 0 && (
            <div className="mt-6">
              <h3 className="mb-2 text-xs font-semibold uppercase tracking-wider text-foreground/50">{ui.gallery}</h3>
              <Gallery images={item.gallery} title={title} ui={ui} />
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

/** A pill-shaped external link button with a per-platform icon. */
function ActionBadge({ action }: { action: ActionLink }) {
  return (
    <a
      href={action.href}
      target="_blank"
      rel="noopener noreferrer"
      className="inline-flex items-center gap-2 rounded-xl bg-brand-surface px-3.5 py-2 text-sm font-medium text-white shadow-md shadow-brand-surface/30 transition-all hover:scale-[1.03] hover:bg-brand-secondary"
    >
      <ActionIcon actionKey={action.key} />
      {action.label}
    </a>
  );
}

function ActionIcon({ actionKey }: { actionKey: ActionLink["key"] }) {
  const cls = "size-4";
  switch (actionKey) {
    case "github":
      return (
        <svg className={cls} viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.58 2 12.25c0 4.53 2.87 8.37 6.84 9.73.5.1.68-.22.68-.49v-1.7c-2.78.62-3.37-1.37-3.37-1.37-.45-1.18-1.11-1.5-1.11-1.5-.91-.64.07-.62.07-.62 1 .07 1.53 1.06 1.53 1.06.9 1.57 2.36 1.12 2.94.85.09-.66.35-1.12.63-1.38-2.22-.26-4.56-1.14-4.56-5.07 0-1.12.39-2.03 1.03-2.75-.1-.26-.45-1.3.1-2.71 0 0 .84-.27 2.75 1.05a9.4 9.4 0 0 1 5 0c1.91-1.32 2.75-1.05 2.75-1.05.55 1.41.2 2.45.1 2.71.64.72 1.03 1.63 1.03 2.75 0 3.94-2.34 4.81-4.57 5.06.36.32.68.94.68 1.9v2.82c0 .27.18.6.69.49A10.26 10.26 0 0 0 22 12.25C22 6.58 17.52 2 12 2Z" /></svg>
      );
    case "docs":
      return (
        <svg className={cls} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" /><path d="M14 2v6h6M9 13h6M9 17h6" /></svg>
      );
    case "live":
      return (
        <svg className={cls} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M15 13a5 5 0 0 0-7.5.5l-3 3a5 5 0 0 0 7 7l3-3" /><path d="m9 11 5-5" /><circle cx="14" cy="10" r="1.5" /></svg>
      );
    default:
      // store-style icon (apple/play/appgallery)
      return (
        <svg className={cls} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="3" width="18" height="18" rx="4" /><path d="M9 8v8M9 12h6" /></svg>
      );
  }
}

/** Horizontal gallery strip + click-to-open lightbox carousel. */
function Gallery({ images, title, ui }: { images: string[]; title: string; ui: ItemModalProps["ui"] }) {
  const [lightboxIndex, setLightboxIndex] = React.useState<number | null>(null);
  const close = () => setLightboxIndex(null);
  const prev = () => setLightboxIndex((i) => (i === null ? i : (i - 1 + images.length) % images.length));
  const next = () => setLightboxIndex((i) => (i === null ? i : (i + 1) % images.length));

  React.useEffect(() => {
    if (lightboxIndex === null) return;
    const isRtl = document.documentElement.dir === "rtl";
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") close();
      // In RTL, the arrow semantics flip so Left/Right still match what the
      // user sees (left key = go forward in reading order = next image).
      if (e.key === "ArrowLeft") isRtl ? next() : prev();
      if (e.key === "ArrowRight") isRtl ? prev() : next();
    };
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, [lightboxIndex, images.length]);

  const isRtl = typeof document !== "undefined" && document.documentElement.dir === "rtl";
  // Logical "back/forward" handlers flip their physical action in RTL so the
  // arrow on screen always does what it points at.
  const onBack = (e: React.MouseEvent) => {
    e.stopPropagation();
    isRtl ? next() : prev();
  };
  const onForward = (e: React.MouseEvent) => {
    e.stopPropagation();
    isRtl ? prev() : next();
  };

  return (
    <>
      <div className="flex gap-3 overflow-x-auto pb-2">
        {images.map((src, i) => (
          <button
            key={src + i}
            type="button"
            onClick={() => setLightboxIndex(i)}
            className="relative h-32 w-auto shrink-0 overflow-hidden rounded-xl border border-border transition-transform hover:scale-[1.03] cursor-pointer"
          >
            <img src={src} alt={`${title} ${i + 1}`} className="h-full w-auto object-cover" loading="lazy" />
          </button>
        ))}
      </div>

      {lightboxIndex !== null && (
        <div className="fixed inset-0 z-[110] flex items-center justify-center bg-black/95 animate-fade-in" onClick={close}>
          <button
            type="button"
            onClick={onBack}
            aria-label={ui.prev}
            className="absolute start-4 flex size-12 items-center justify-center rounded-full border border-border bg-card/50 text-white transition-colors hover:bg-muted/70 cursor-pointer"
          >
            <svg className="rtl:-scale-x-100" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round"><path d="M15 18l-6-6 6-6" /></svg>
          </button>
          <img
            src={images[lightboxIndex]}
            alt={`${title} ${lightboxIndex + 1}`}
            className="max-h-[90vh] max-w-[92vw] object-contain"
            onClick={(e) => e.stopPropagation()}
          />
          <button
            type="button"
            onClick={onForward}
            aria-label={ui.next}
            className="absolute end-4 flex size-12 items-center justify-center rounded-full border border-border bg-card/50 text-white transition-colors hover:bg-muted/70 cursor-pointer"
          >
            <svg className="rtl:-scale-x-100" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round"><path d="M9 18l6-6-6-6" /></svg>
          </button>
          <span className="absolute bottom-5 rounded-full bg-card/60 px-3 py-1 text-xs text-white/80">{lightboxIndex + 1} / {images.length}</span>
        </div>
      )}
    </>
  );
}
