import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

/** shadcn-style class combiner: merges Tailwind utilities de-duplicating conflicts. */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

/** Absolute-ify a dashboard media path. Relative `/media/...` -> full origin URL. */
export function absolutizeMedia(
  path: string | null | undefined,
  origin = "https://dash.vexaltech.dev",
): string | null {
  if (!path) return null;
  const value = String(path).trim();
  if (!value) return null;
  if (/^https?:\/\//i.test(value) || value.startsWith("data:")) return value;
  if (value.startsWith("/")) return `${origin}${value}`;
  return `${origin}/${value}`;
}
