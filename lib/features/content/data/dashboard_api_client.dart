import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/dashboard_api_config.dart';
import '../../../core/utils/slugify.dart';
import '../domain/portfolio_models.dart';

/// Fetches the `apps`, `packages`, and `websites` entities from the remote
/// Dashboard API and converts them into the site's own
/// [PortfolioSection] / [SectionItem] schema, so the generic UI widgets can
/// render them without any special-casing.
///
/// Filtering: only items whose `companyName` equals
/// [DashboardApiConfig.filterCompany] are kept. Each endpoint is fetched
/// independently — a failure in one does not break the others.
class DashboardApiClient {
  DashboardApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Fetches all configured API sections in parallel.
  ///
  /// Returns the successfully converted sections in the canonical order
  /// defined by [DashboardApiConfig.endpoints]. A failed endpoint simply
  /// contributes nothing; the call never throws.
  Future<List<PortfolioSection>> fetchSections() async {
    final results = await Future.wait(
      DashboardApiConfig.endpoints.entries.map((entry) async {
        try {
          final items = await _fetchList(entry.value);
          return _convertSection(entry.key, items);
        } catch (_) {
          // Swallow per-endpoint errors: a single broken endpoint must not
          // hide the rest of the sections.
          return null;
        }
      }),
    );
    return results.whereType<PortfolioSection>().toList();
  }

  // ── Networking ───────────────────────────────────────────────────────────

  Future<List<Map<String, Object?>>> _fetchList(String url) async {
    final response = await _client.get(Uri.parse(url));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('HTTP ${response.statusCode} from $url');
    }
    final decoded = jsonDecode(response.body);
    // Endpoints return an object wrapping an array, e.g. `{ "apps": [...] }`.
    if (decoded is Map<String, Object?>) {
      for (final value in decoded.values) {
        if (value is List) {
          return value
              .whereType<Map<String, Object?>>()
              .toList(growable: false);
        }
      }
    }
    if (decoded is List) {
      return decoded.whereType<Map<String, Object?>>().toList(growable: false);
    }
    throw StateError('Unexpected API response shape');
  }

  // ── Conversion dispatch ──────────────────────────────────────────────────

  PortfolioSection? _convertSection(
    String slug,
    List<Map<String, Object?>> rawItems,
  ) {
    final filtered = rawItems.where(_matchesCompany).toList();
    if (filtered.isEmpty) return null;

    switch (slug) {
      case 'apps':
        return _convertApps(filtered);
      case 'packages':
        return _convertPackages(filtered);
      case 'websites':
        return _convertWebsites(filtered);
      default:
        return null;
    }
  }

  bool _matchesCompany(Map<String, Object?> item) {
    final company = item['companyName']?.toString();
    return company == DashboardApiConfig.filterCompany;
  }

  // ── Apps ─────────────────────────────────────────────────────────────────

  PortfolioSection _convertApps(List<Map<String, Object?>> items) {
    return PortfolioSection(
      id: 'sec_apps_api',
      slug: 'apps',
      title: const L10nText({'en': 'Apps', 'ar': 'التطبيقات'}),
      enabled: true,
      fieldDefinitions: const [
        FieldDefinition(
          key: 'name',
          label: L10nText({'en': 'Name', 'ar': 'الاسم'}),
          type: FieldType.string,
          required: true,
          localized: true,
        ),
        FieldDefinition(
          key: 'banner',
          label: L10nText({'en': 'Banner', 'ar': 'بنر'}),
          type: FieldType.image,
          required: true,
        ),
        FieldDefinition(
          key: 'description',
          label: L10nText({'en': 'Description', 'ar': 'الوصف'}),
          type: FieldType.markdown,
          localized: true,
        ),
        FieldDefinition(
          key: 'screens',
          label: L10nText({'en': 'Screenshots', 'ar': 'الصور'}),
          type: FieldType.image,
          multiple: true,
        ),
        FieldDefinition(
          key: 'appstore',
          label: L10nText({'en': 'App Store', 'ar': 'آب ستور'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'playstore',
          label: L10nText({'en': 'Google Play', 'ar': 'جوجل بلاي'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'appgallery',
          label: L10nText({'en': 'AppGallery', 'ar': 'آب جاليري'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'macappstore',
          label: L10nText({'en': 'Mac App Store', 'ar': 'ماك آب ستور'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'tags',
          label: L10nText({'en': 'Tags', 'ar': 'الوسوم'}),
          type: FieldType.tagList,
          multiple: true,
        ),
      ],
      cardLayout: const CardLayout(
        titleField: 'name',
        subtitleField: 'description',
        mediaField: 'banner',
      ),
      detailLayout: DetailLayout(
        titleField: 'name',
        mediaField: 'banner',
        galleryField: 'screens',
        bodyFields: const ['description'],
        actionFields: const [
          'appstore',
          'playstore',
          'appgallery',
          'macappstore',
        ],
      ),
      items: items.map(_appItem).toList(),
    );
  }

  SectionItem _appItem(Map<String, Object?> raw) {
    final nameAr = raw['appTitle']?.toString().trim();
    final nameEn = raw['appName']?.toString().trim();
    final body = raw['body']?.toString().trim() ?? '';
    final id = _uniqueId(_firstNonEmpty([nameEn, nameAr]) ?? 'app', raw);
    final banners = _stringList(raw['banners']).map(absolutizeMedia).toList();

    return SectionItem(
      id: id,
      enabled: true,
      fields: {
        'name': {
          'en': _firstNonEmpty([nameEn, nameAr]) ?? '',
          'ar': _firstNonEmpty([nameAr, nameEn]) ?? '',
        },
        'banner': absolutizeMedia(raw['appBanner']?.toString()),
        'description': {
          'en': body,
          'ar': body,
        },
        'screens': banners,
        if (raw['urlAppStore'] != null)
          'appstore': raw['urlAppStore'].toString(),
        if (raw['urlPlayStore'] != null)
          'playstore': raw['urlPlayStore'].toString(),
        if (raw['urlAppGallery'] != null)
          'appgallery': raw['urlAppGallery'].toString(),
        if (raw['urlMacAppStore'] != null)
          'macappstore': raw['urlMacAppStore'].toString(),
        'tags': _stringList(raw['tags']),
      },
    );
  }

  // ── Packages ─────────────────────────────────────────────────────────────

  PortfolioSection _convertPackages(List<Map<String, Object?>> items) {
    return PortfolioSection(
      id: 'sec_packages_api',
      slug: 'packages',
      title: const L10nText({'en': 'Libraries', 'ar': 'المكتبات'}),
      enabled: true,
      fieldDefinitions: const [
        FieldDefinition(
          key: 'name',
          label: L10nText({'en': 'Name', 'ar': 'الاسم'}),
          type: FieldType.string,
          required: true,
          localized: true,
        ),
        FieldDefinition(
          key: 'banner',
          label: L10nText({'en': 'Banner', 'ar': 'بنر'}),
          type: FieldType.image,
          required: true,
        ),
        FieldDefinition(
          key: 'description',
          label: L10nText({'en': 'Description', 'ar': 'الوصف'}),
          type: FieldType.markdown,
          localized: true,
        ),
        FieldDefinition(
          key: 'docs',
          label: L10nText({'en': 'Docs', 'ar': 'التوثيق'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'pub',
          label: L10nText({'en': 'pub.dev', 'ar': 'pub.dev'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'github',
          label: L10nText({'en': 'GitHub', 'ar': 'GitHub'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'tags',
          label: L10nText({'en': 'Tags', 'ar': 'الوسوم'}),
          type: FieldType.tagList,
          multiple: true,
        ),
      ],
      cardLayout: const CardLayout(
        titleField: 'name',
        subtitleField: 'description',
        mediaField: 'banner',
      ),
      detailLayout: const DetailLayout(
        titleField: 'name',
        mediaField: 'banner',
        bodyFields: ['description'],
        actionFields: ['docs', 'pub', 'github'],
      ),
      items: items.map(_packageItem).toList(),
    );
  }

  SectionItem _packageItem(Map<String, Object?> raw) {
    final name = raw['packageName']?.toString().trim() ?? '';
    final body = raw['body']?.toString().trim() ?? '';
    final id = _uniqueId(name.isNotEmpty ? name : 'package', raw);

    return SectionItem(
      id: id,
      enabled: true,
      fields: {
        'name': {'en': name, 'ar': name},
        'banner': absolutizeMedia(_firstNonEmpty([
          raw['packageBanner']?.toString(),
          raw['packageLogo']?.toString(),
        ])),
        'description': {'en': body, 'ar': body},
        if (raw['docsUrl'] != null) 'docs': raw['docsUrl'].toString(),
        if (raw['pubUrl'] != null) 'pub': raw['pubUrl'].toString(),
        if (raw['githubUrl'] != null) 'github': raw['githubUrl'].toString(),
        'tags': _stringList(raw['tags']),
      },
    );
  }

  // ── Websites ─────────────────────────────────────────────────────────────

  PortfolioSection _convertWebsites(List<Map<String, Object?>> items) {
    return PortfolioSection(
      id: 'sec_websites_api',
      slug: 'websites',
      title: const L10nText({'en': 'Websites', 'ar': 'المواقع'}),
      enabled: true,
      fieldDefinitions: const [
        FieldDefinition(
          key: 'name',
          label: L10nText({'en': 'Name', 'ar': 'الاسم'}),
          type: FieldType.string,
          required: true,
          localized: true,
        ),
        FieldDefinition(
          key: 'banner',
          label: L10nText({'en': 'Logo', 'ar': 'الشعار'}),
          type: FieldType.image,
        ),
        FieldDefinition(
          key: 'description',
          label: L10nText({'en': 'Description', 'ar': 'الوصف'}),
          type: FieldType.markdown,
          localized: true,
        ),
        FieldDefinition(
          key: 'live',
          label: L10nText({'en': 'Live Site', 'ar': 'الموقع'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'github',
          label: L10nText({'en': 'GitHub', 'ar': 'GitHub'}),
          type: FieldType.link,
        ),
        FieldDefinition(
          key: 'tags',
          label: L10nText({'en': 'Tags', 'ar': 'الوسوم'}),
          type: FieldType.tagList,
          multiple: true,
        ),
      ],
      cardLayout: const CardLayout(
        titleField: 'name',
        subtitleField: 'description',
        mediaField: 'banner',
      ),
      detailLayout: const DetailLayout(
        titleField: 'name',
        mediaField: 'banner',
        bodyFields: ['description'],
        actionFields: ['live', 'github'],
      ),
      items: items.map(_websiteItem).toList(),
    );
  }

  SectionItem _websiteItem(Map<String, Object?> raw) {
    final nameAr = raw['websiteTitle']?.toString().trim() ?? '';
    final nameEn =
        raw['websiteNameEn']?.toString().trim() ??
        raw['websiteName']?.toString().trim() ??
        '';
    final body = raw['body']?.toString().trim() ?? '';
    final logo = raw['websiteLogo']?.toString();
    final id = _uniqueId(_firstNonEmpty([nameEn, nameAr]) ?? 'website', raw);

    return SectionItem(
      id: id,
      enabled: true,
      fields: {
        'name': {
          'en': _firstNonEmpty([nameEn, nameAr]) ?? '',
          'ar': _firstNonEmpty([nameAr, nameEn]) ?? '',
        },
        if (logo != null && logo.isNotEmpty) 'banner': absolutizeMedia(logo),
        'description': {'en': body, 'ar': body},
        if (raw['urlLive'] != null) 'live': raw['urlLive'].toString(),
        if (raw['urlGithub'] != null) 'github': raw['urlGithub'].toString(),
        'tags': _stringList(raw['tags']),
      },
    );
  }

  // ── Shared helpers ───────────────────────────────────────────────────────

  /// Builds a stable, unique item id from [base]. Uniqueness across the
  /// original numeric API ids is guaranteed by keeping the source id as a
  /// suffix, so deep links never collide even for duplicate names.
  String _uniqueId(String base, Map<String, Object?> raw) {
    final apiId = raw['id']?.toString();
    final slug = slugify(base);
    if (apiId == null || apiId.isEmpty) return slug;
    return '$slug-$apiId';
  }

  List<String> _stringList(Object? value) {
    if (value is List) {
      return value.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    }
    return const [];
  }

  String? _firstNonEmpty(List<String?> candidates) {
    for (final c in candidates) {
      if (c != null && c.trim().isNotEmpty) return c.trim();
    }
    return null;
  }
}
