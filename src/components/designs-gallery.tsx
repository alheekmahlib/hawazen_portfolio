/**
 * DesignsGallery — adapted from the @efferd/image-gallery-1 block.
 *
 * The efferd block creates its masonry feel by giving each tile a different
 * aspect ratio (alternating 16:9 horizontal / 9:16 vertical). We achieve the
 * same varied look by respecting each image's NATURAL aspect ratio instead of
 * cropping it: tiles are distributed across N columns and render at full width
 * with height:auto, so square, portrait, and landscape images interleave into
 * a masonry flow. Click an image to open a lightbox.
 *
 * Populated from the dashboard `designs_photos` image-gallery field. Hidden by
 * the page while that field is empty.
 */
"use client";
import * as React from "react";

interface DesignsGalleryProps {
  images: string[];
  title: string;
  ui: { prev: string; next: string };
}

export function DesignsGallery({ images, title, ui }: DesignsGalleryProps) {
  const [lightboxIndex, setLightboxIndex] = React.useState<number | null>(null);
  const close = () => setLightboxIndex(null);
  const next = () => setLightboxIndex((i) => (i === null ? i : (i + 1) % images.length));
  const prev = () => setLightboxIndex((i) => (i === null ? i : (i - 1 + images.length) % images.length));

  React.useEffect(() => {
    if (lightboxIndex === null) return;
    const isRtl = document.documentElement.dir === "rtl";
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") close();
      // In RTL, the arrow semantics flip so Left/Right match the reading flow.
      if (e.key === "ArrowLeft") isRtl ? next() : prev();
      if (e.key === "ArrowRight") isRtl ? prev() : next();
    };
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, [lightboxIndex, images.length]);

  const isRtl = typeof document !== "undefined" && document.documentElement.dir === "rtl";
  const onBack = (e: React.MouseEvent) => {
    e.stopPropagation();
    isRtl ? next() : prev();
  };
  const onForward = (e: React.MouseEvent) => {
    e.stopPropagation();
    isRtl ? prev() : next();
  };

  // Distribute images round-robin across columns for a balanced masonry flow.
  const columns = 4;
  const cols: string[][] = Array.from({ length: columns }, () => []);
  images.forEach((src, i) => cols[i % columns].push(src));

  return (
    <>
      <div className="mx-auto grid w-full max-w-[1100px] grid-cols-2 gap-4 px-4 py-2 md:grid-cols-4 md:gap-6">
        {cols.map((col, ci) => (
          <div key={ci} className="flex flex-col gap-4 md:gap-6">
            {col.map((src, ii) => {
              const idx = ci + ii * columns; // original index in the flat list
              return (
                <button
                  key={src + idx}
                  type="button"
                  onClick={() => setLightboxIndex(idx)}
                  className="group relative block overflow-hidden rounded-2xl border border-border/50 bg-card/30 transition-transform duration-200 hover:scale-[1.02] focus-visible:scale-[1.02] cursor-pointer"
                >
                  {/*
                    width:100% + height:auto keeps each image's NATURAL aspect
                    ratio, so portrait/square/landscape tiles interleave into a
                    masonry layout (no cropping, no forced uniform sizes).
                  */}
                  <img
                    src={src}
                    alt={`${title} ${idx + 1}`}
                    loading="lazy"
                    decoding="async"
                    className="block h-auto w-full object-cover transition-transform duration-500 group-hover:scale-105"
                  />
                </button>
              );
            })}
          </div>
        ))}
      </div>

      {lightboxIndex !== null && (
        <div
          className="fixed inset-0 z-[110] flex items-center justify-center bg-black/95 animate-fade-in"
          onClick={close}
        >
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

          <span className="absolute bottom-5 rounded-full bg-card/60 px-3 py-1 text-xs text-white/80">
            {lightboxIndex + 1} / {images.length}
          </span>
        </div>
      )}
    </>
  );
}
