# Portfolio Content JSON (schema v1.0)

The app reads a single JSON file (host it on GitHub and use the **raw** URL).

Key rules:
- `sections[].slug` is used for routing: `/#/<slug>`.
- `/#/<slug>/<itemId>` opens the item bottom sheet.
- `id` fields must be URL-safe (`kebab-case`).
- Localized text uses `{ "en": "...", "ar": "..." }`.

## Top level

- `schemaVersion`: string (currently `"1.0"`)
- `defaultLocale`: `"en"`
- `locales`: `["en", "ar"]`
- `site`: global site info (name/role/bio/social/contact)
- `sections`: array of dynamic sections

## Section

- `id`: stable id (not used in URLs)
- `slug`: URL slug (unique, kebab-case) e.g. `packages`
- `title`: localized title
- `enabled`: boolean
- `fieldDefinitions`: define item fields
- `cardLayout`: choose what appears on grid cards
- `detailLayout`: choose what appears in the bottom sheet
- `items`: list of items

## Item

- `id`: item id used in deep links
- `enabled`: boolean
- `fields`: map of `fieldDefinitions.key -> value`

See `assets/content/content.sample.json` for a complete example.
