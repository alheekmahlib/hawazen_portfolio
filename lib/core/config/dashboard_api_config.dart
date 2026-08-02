/// Configuration for the remote Dashboard API that powers the
/// `apps`, `packages`, and `websites` sections.
///
/// Adding a new entity type later is a one-line change in [DashboardApiConfig.endpoints].
class DashboardApiConfig {
  DashboardApiConfig._();

  /// Origin of the dashboard that also hosts the relative media assets
  /// (e.g. `/media/2026/07/xxx.png`). Relative paths are prefixed with it.
  static const String baseMediaUrl = 'https://dash.vexaltech.dev';

  /// Only items whose `companyName` equals this value are shown on the site.
  static const String filterCompany = 'Alheekmah Library';

  /// Maps a section slug to its dashboard API endpoint.
  ///
  /// These are **same-origin relative paths** served by the Cloudflare Pages
  /// Function at `functions/api/[[catchall]].js`, which proxies the dashboard
  /// at [baseMediaUrl] and adds the CORS headers the browser requires. Using a
  /// relative path keeps this working on any deployment (preview, production,
  /// local) with no host configuration, and avoids cross-origin requests.
  ///
  /// To add a new entity type (e.g. `/api/designs`), append an entry here and
  /// add a converter in `DashboardApiClient`.
  static const Map<String, String> endpoints = {
    'apps': '/api/apps',
    'packages': '/api/packages',
    'websites': '/api/websites',
  };

  /// Slugs whose content is fully sourced from the dashboard API. These
  /// sections are replaced (or injected) at load time and are never edited
  /// through the admin panel.
  static final Set<String> apiSlugs = endpoints.keys.toSet();
}

/// Turns a media path returned by the dashboard into an absolute URL.
///
/// - Relative paths (`/media/...`) are prefixed with [DashboardApiConfig.baseMediaUrl].
/// - Already-absolute URLs (`http://...`, `https://...`) and data URIs are
///   returned untouched.
/// - Empty/null values become an empty string.
String absolutizeMedia(String? path) {
  if (path == null) return '';
  final trimmed = path.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.startsWith('http://') ||
      trimmed.startsWith('https://') ||
      trimmed.startsWith('data:')) {
    return trimmed;
  }
  if (trimmed.startsWith('/')) {
    return '${DashboardApiConfig.baseMediaUrl}$trimmed';
  }
  return '${DashboardApiConfig.baseMediaUrl}/$trimmed';
}
