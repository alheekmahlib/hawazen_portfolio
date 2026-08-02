/**
 * CustomCursor — a dot + trailing-ring cursor that replaces the native pointer.
 *
 * The dot tracks the pointer exactly; the ring lags behind with a spring-like
 * interpolation and grows when hovering interactive elements (links, buttons,
 * [data-cursor]). The native cursor is hidden everywhere via the `cursor-none`
 * class on <html>.
 *
 * Disabled on touch devices (no pointer) and when the user prefers reduced
 * motion (keeps the native cursor for accessibility).
 */
"use client";
import * as React from "react";

export function CustomCursor() {
  const dotRef = React.useRef<HTMLDivElement | null>(null);
  const ringRef = React.useRef<HTMLDivElement | null>(null);

  React.useEffect(() => {
    // Skip on touch / coarse-pointer devices.
    if (window.matchMedia("(pointer: coarse)").matches) return;
    // Respect reduced-motion users — keep the native cursor.
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    document.documentElement.classList.add("cursor-none");

    const pos = { x: window.innerWidth / 2, y: window.innerHeight / 2 };
    const ring = { x: pos.x, y: pos.y };
    let hovering = false;
    let raf = 0;

    const onMove = (e: PointerEvent) => {
      pos.x = e.clientX;
      pos.y = e.clientY;
      if (dotRef.current) {
        dotRef.current.style.transform = `translate3d(${pos.x}px, ${pos.y}px, 0) translate(-50%, -50%)`;
      }
    };

    // Grow the ring over anything interactive.
    const interactiveSelector =
      'a, button, [role="button"], input, textarea, select, label, [data-cursor], summary';

    const onOver = (e: Event) => {
      if ((e.target as Element)?.closest(interactiveSelector)) hovering = true;
    };
    const onOut = (e: Event) => {
      if ((e.target as Element)?.closest(interactiveSelector)) hovering = false;
    };

    const onDown = () => document.documentElement.classList.add("cursor-pressed");
    const onUp = () => document.documentElement.classList.remove("cursor-pressed");

    const loop = () => {
      // Ease the ring toward the pointer for a trailing feel.
      ring.x += (pos.x - ring.x) * 0.18;
      ring.y += (pos.y - ring.y) * 0.18;
      const scale = hovering ? 1.8 : 1;
      if (ringRef.current) {
        ringRef.current.style.transform = `translate3d(${ring.x}px, ${ring.y}px, 0) translate(-50%, -50%) scale(${scale})`;
        ringRef.current.style.opacity = hovering ? "1" : "0.7";
      }
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);

    document.addEventListener("pointermove", onMove, { passive: true });
    document.addEventListener("pointerover", onOver, { passive: true });
    document.addEventListener("pointerout", onOut, { passive: true });
    document.addEventListener("pointerdown", onDown);
    document.addEventListener("pointerup", onUp);

    return () => {
      cancelAnimationFrame(raf);
      document.documentElement.classList.remove("cursor-none", "cursor-pressed");
      document.removeEventListener("pointermove", onMove);
      document.removeEventListener("pointerover", onOver);
      document.removeEventListener("pointerout", onOut);
      document.removeEventListener("pointerdown", onDown);
      document.removeEventListener("pointerup", onUp);
    };
  }, []);

  return (
    <>
      <div
        ref={dotRef}
        aria-hidden="true"
        className="app-cursor-dot pointer-events-none fixed left-0 top-0 z-[9999] h-2 w-2 rounded-full bg-brand-secondary will-change-transform transition-transform duration-150"
      />
      <div
        ref={ringRef}
        aria-hidden="true"
        className="pointer-events-none fixed left-0 top-0 z-[9998] h-9 w-9 rounded-full border border-brand-secondary/70 will-change-transform transition-[opacity] duration-200"
      />
    </>
  );
}
