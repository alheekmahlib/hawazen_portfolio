/**
 * QuickModal — a lightweight detail modal for the hero "quick sections"
 * (profile summary, technical skills, design skills, education). Mirrors the
 * ItemBottomSheet behaviour but for plain-text content.
 */
"use client";
import * as React from "react";

interface QuickModalProps {
  title: string;
  body: string;
  /** Whether to render the body as a bulleted list (one bullet per line). */
  asList?: boolean;
  open: boolean;
  onClose: () => void;
  closeLabel: string;
}

export function QuickModal({ title, body, asList, open, onClose, closeLabel }: QuickModalProps) {
  React.useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    document.addEventListener("keydown", onKey);
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    // Stop Lenis so the wheel scrolls this modal natively instead of the page.
    const lenis = window.__lenis;
    lenis?.stop();
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = prev;
      lenis?.start();
    };
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-[100] flex items-end justify-center sm:items-center" role="dialog" aria-modal="true" aria-label={title}>
      <button type="button" aria-label={closeLabel} onClick={onClose} className="absolute inset-0 cursor-default bg-black/70 backdrop-blur-sm animate-fade-in" />
      <div data-lenis-prevent className="glass-strong relative z-10 max-h-[88vh] w-full max-w-[680px] overflow-y-auto rounded-t-3xl p-6 sm:rounded-3xl md:p-8 animate-scale-in">
        <button type="button" onClick={onClose} aria-label={closeLabel} className="absolute end-4 top-4 flex size-9 items-center justify-center rounded-full border border-border bg-card/60 text-foreground backdrop-blur-md transition-colors hover:bg-muted/70 cursor-pointer">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round"><path d="M6 6l12 12M18 6L6 18" /></svg>
        </button>
        <h2 className="mb-4 text-xl font-extrabold tracking-tight md:text-2xl">{title}</h2>
        {asList ? (
          <ul className="space-y-2">
            {body.split("\n").map((line, i) => line.trim() && (
              <li key={i} className="flex items-start gap-2 text-sm text-foreground/80 md:text-base">
                <span className="mt-2 size-1.5 shrink-0 rounded-full bg-brand-secondary" />
                <span>{line.trim()}</span>
              </li>
            ))}
          </ul>
        ) : (
          <p className="whitespace-pre-line text-pretty text-sm leading-relaxed text-foreground/80 md:text-base">{body}</p>
        )}
      </div>
    </div>
  );
}
