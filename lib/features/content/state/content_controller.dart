import 'package:get/get.dart';

import '../../../core/config/dashboard_api_config.dart';
import '../data/content_repository.dart';
import '../data/dashboard_api_client.dart';
import '../domain/portfolio_models.dart';

class ContentController extends GetxController {
  ContentController({
    required ContentRepository repository,
    DashboardApiClient? dashboardApi,
  })  : _repository = repository,
        _dashboardApi = dashboardApi ?? DashboardApiClient();

  final ContentRepository _repository;
  final DashboardApiClient _dashboardApi;

  final Rxn<PortfolioContent> content = Rxn<PortfolioContent>();
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    load(forceRefresh: false);
    Future.microtask(forceReload);
  }

  Future<void> load({required bool forceRefresh}) async {
    loading.value = true;
    error.value = null;
    update();

    try {
      final c = await _repository.load(forceRefresh: forceRefresh);
      // Replace the API-driven sections (apps/packages/websites) with live
      // data from the dashboard. The repository content stays the source of
      // truth for everything else (site info, designs, education, ...).
      content.value = await _withDashboardSections(c);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
      update();
    }
  }

  /// Merges dashboard-sourced sections into [content].
  ///
  /// API sections always win over any manually-defined section with the same
  /// slug. The visible order is fixed by [_sectionOrder]: apps → packages →
  /// websites, then the remaining content.json sections in their original
  /// order. If the dashboard is unreachable, [content] is returned unchanged.
  Future<PortfolioContent> _withDashboardSections(PortfolioContent content) async {
    final List<PortfolioSection> apiSections;
    try {
      apiSections = await _dashboardApi.fetchSections();
    } catch (_) {
      return content;
    }
    if (apiSections.isEmpty) return content;
    return _mergeSections(content, apiSections);
  }

  /// Canonical display order for dashboard-backed sections, applied on top of
  /// whatever order the JSON happens to use. Apps → Packages → Websites keeps
  /// the primary work on top and Websites just before Designs.
  static const List<String> _sectionOrder = ['apps', 'packages', 'websites'];

  PortfolioContent _mergeSections(
    PortfolioContent content,
    List<PortfolioSection> apiSections,
  ) {
    final apiSlugs = DashboardApiConfig.apiSlugs;
    final bySlug = {for (final s in apiSections) s.slug: s};

    // Sections from content.json that are NOT dashboard-backed, original order.
    final kept =
        content.sections.where((s) => !apiSlugs.contains(s.slug)).toList();

    // Dashboard sections in the canonical order, skipping any that weren't
    // returned (e.g. websites was empty after filtering).
    final orderedApi = [
      for (final slug in _sectionOrder)
        if (bySlug[slug] != null) bySlug[slug]!,
    ];

    return content.copyWith(sections: [...orderedApi, ...kept]);
  }

  Future<void> reload({bool forceRefresh = false}) =>
      load(forceRefresh: forceRefresh);

  Future<void> forceReload() => load(forceRefresh: true);
}
