/**
 * LazyImage — adapted from the @efferd/lazy-image block.
 * Uses motion/react's useInView for deferred loading of off-screen images, with
 * a graceful fallback when the source fails. Preserves the same API surface.
 */
"use client";
import * as React from "react";
import { useInView } from "motion/react";
import { cn } from "@/lib/utils";

type LazyImageProps = {
  alt: string;
  src: string;
  ratio: number;
  /** Fallback image URL shown when `src` errors. */
  fallback?: string;
  /** Only load the image when it scrolls into view (default false). */
  inView?: boolean;
  className?: string;
  containerClassName?: string;
};

export function LazyImage({
  alt,
  src,
  ratio,
  fallback,
  inView = false,
  className,
  containerClassName,
}: LazyImageProps) {
  const ref = React.useRef<HTMLDivElement | null>(null);
  const imgRef = React.useRef<HTMLImageElement | null>(null);
  const isInView = useInView(ref, { once: true });

  const [imgSrc, setImgSrc] = React.useState<string | undefined>(
    inView ? undefined : src,
  );
  const [isLoading, setIsLoading] = React.useState(true);

  const handleError = () => {
    if (fallback) setImgSrc(fallback);
    setIsLoading(false);
  };

  const handleLoad = React.useCallback(() => setIsLoading(false), []);

  React.useEffect(() => {
    if (inView && isInView && !imgSrc) setImgSrc(src);
  }, [inView, isInView, src, imgSrc]);

  React.useEffect(() => {
    if (imgRef.current?.complete) handleLoad();
  }, [handleLoad]);

  return (
    <div
      ref={ref}
      className={cn(
        "relative size-full overflow-hidden rounded-xl border border-border/50 bg-accent/20",
        containerClassName,
      )}
      style={{ aspectRatio: String(ratio) }}
    >
      {imgSrc && (
        // biome-ignore lint: dynamic image source
        <img
          ref={imgRef}
          src={imgSrc}
          alt={alt}
          decoding="async"
          loading="lazy"
          onError={handleError}
          onLoad={handleLoad}
          className={cn(
            "size-full object-cover transition-opacity duration-500",
            isLoading ? "opacity-0" : "opacity-100",
            className,
          )}
        />
      )}
    </div>
  );
}
