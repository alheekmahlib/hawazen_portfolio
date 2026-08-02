# Content Schema

This portfolio is driven by two content sources, both fetched at **build time** from the
dashboard API at `dash.vexaltech.dev`. There is no longer a local `content.json` (the
Flutter app used one; the Astro site reads directly from the dashboard).

## 1. Entity sections — Apps / Packages / Websites

`GET https://dash.vexaltech.dev/api/{apps,packages,websites}`

Each endpoint returns `{ "<slug>": [ ...items ] }`. Only items whose `companyName`
equals **`Alheekmah Library`** are kept. Field mapping (see `src/lib/data.ts`):

### Apps

| API field        | Model field       | Notes                          |
| ---------------- | ----------------- | ------------------------------ |
| `appName`        | `name.en`         | falls back to `appTitle`       |
| `appTitle`       | `name.ar`         |                                |
| `appBanner`      | `banner`          | `/media/...` → absolute URL    |
| `banners`        | `gallery`         | array of screenshot URLs       |
| `body`           | `description`     | shared by en + ar              |
| `urlAppStore`    | action `appstore` |                                |
| `urlPlayStore`   | action `playstore`|                                |
| `urlAppGallery`  | action `appgallery`|                               |
| `urlMacAppStore` | action `macappstore`|                              |
| `tags`           | `tags`            |                                |

### Packages

| API field        | Model field    |
| ---------------- | -------------- |
| `packageName`    | `name`         |
| `packageBanner`/`packageLogo` | `banner` |
| `body`           | `description`  |
| `docsUrl`        | action `docs`  |
| `pubUrl`         | action `pub`   |
| `githubUrl`      | action `github`|

### Websites

| API field        | Model field    |
| ---------------- | -------------- |
| `websiteNameEn`/`websiteName` | `name.en` |
| `websiteTitle`   | `name.ar`      |
| `websiteBanner`  | `banner` (falls back to `websiteLogo`) |
| `body`           | `description`  |
| `urlLive`        | action `live`  |
| `urlGithub`      | action `github`|
| `tags`           | `tags`         |

## 2. Profile content — `hawazen-site` section

`GET https://dash.vexaltech.dev/api/sections/hawazen-site/entries`

Returns `{ entries: [ { values: { ... } } ], section: {...} }`. The first entry's `values`
object holds localized pairs:

| Field key                       | Model                |
| ------------------------------- | -------------------- |
| `profile_summary_text_en/ar`    | `profileSummary`     |
| `technical_skills_text_en/ar`   | `technicalSkills`    |
| `design_skills_text_en/ar`      | `designSkills`       |
| `education_text_en/ar`          | `education`          |
| `designs_photos` (image-gallery)| `designs.images`     |

The `designs_photos` field powers the Designs gallery; while it is empty in the CMS the
section is hidden. Upload images there to make the section appear — no code change needed.

## 3. Static site info — `src/config.ts`

The hero identity (name, role, subtitle, bio), social links, and contact details are
authored directly in `src/config.ts` because they rarely change and don't belong in the CMS.
