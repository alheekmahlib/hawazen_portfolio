/**
 * ClientEffects — site-wide client-side enhancements mounted once per page:
 *  - Lenis smooth scrolling (with reduced-motion fallback to native scroll)
 *  - Custom dot + ring cursor
 *
 * Mounted as a `client:load` island in BaseLayout so it runs on every route.
 */
"use client";
import * as React from "react";
import Lenis from "lenis";
import { CustomCursor } from "@/components/custom-cursor";

export function ClientEffects() {
  React.useEffect(() => {
    const prefersReducedMotion = window.matchMedia(
      "(prefers-reduced-motion: reduce)",
    ).matches;
    if (prefersReducedMotion) return;

    const lenis = new Lenis({
      duration: 1.1,
      easing: (t: number) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
      smoothWheel: true,
      // Keep native touch scrolling — Lenis mainly smooths wheel/trackpad.
      smoothTouch: false,
    });

    let raf = 0;
    const loop = (time: number) => {
      lenis.raf(time);
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);

    // Honour in-page anchor clicks (nav links) with Lenis scrolling.
    const onAnchorClick = (e: MouseEvent) => {
      const target = (e.target as Element)?.closest('a[href^="#"]') as HTMLAnchorElement | null;
      if (!target) return;
      const id = target.getAttribute("href")?.slice(1);
      if (!id) return;
      const el = document.getElementById(id);
      if (el) {
        e.preventDefault();
        lenis.scrollTo(el, { offset: -80 });
      }
    };
    document.addEventListener("click", onAnchorClick);

    return () => {
      cancelAnimationFrame(raf);
      document.removeEventListener("click", onAnchorClick);
      lenis.destroy();
    };
  }, []);

  return <CustomCursor />;
}
