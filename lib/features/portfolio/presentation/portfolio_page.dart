import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../content/domain/portfolio_models.dart';
import '../../content/domain/portfolio_view_model.dart';
import '../../content/state/content_controller.dart';
import '../state/portfolio_scroll_controller.dart';
import 'item_bottom_sheet.dart';
import 'portfolio_scaffold.dart';
import 'widgets/contact_section.dart';
import 'widgets/footer_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/section_block.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    super.key,
    required this.sectionSlug,
    required this.itemId,
  });

  final String? sectionSlug;
  final String? itemId;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  late final ContentController _contentController;
  late final LocaleController _localeController;
  late final PortfolioScrollController _portfolioScroll;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{};
  final GlobalKey _contactKey = GlobalKey();

  Worker? _contentWorker;
  String? _openedFor;
  String? _scrolledFor;

  @override
  void initState() {
    super.initState();
    _contentController = Get.find<ContentController>();
    _localeController = Get.find<LocaleController>();
    _portfolioScroll = Get.find<PortfolioScrollController>();
    _portfolioScroll.attachScrollController(_scrollController);
    _scrollController.addListener(_handleScroll);

    _contentWorker = ever<PortfolioContent?>(_contentController.content, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeScroll();
        _maybeOpen();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeScroll();
      _maybeOpen();
    });
  }

  @override
  void didUpdateWidget(covariant PortfolioPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sectionSlug != widget.sectionSlug) {
      _scrolledFor = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeScroll());
    }

    if (oldWidget.itemId != widget.itemId) {
      _openedFor = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpen());
    }
  }

  @override
  void dispose() {
    _contentWorker?.dispose();
    _portfolioScroll.detachScrollController(_scrollController);
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey _keyForSlug(String slug) {
    final key = _sectionKeys.putIfAbsent(slug, () => GlobalKey());
    _portfolioScroll.registerSectionKey(slug, key);
    return key;
  }

  GlobalKey _keyForContact() {
    _portfolioScroll.registerSectionKey('contact', _contactKey);
    return _contactKey;
  }

  void _maybeScroll() {
    final slug = widget.sectionSlug;
    if (slug == null || slug.isEmpty) return;
    if (_scrolledFor == slug) return;

    final key = slug == 'contact' ? _contactKey : _sectionKeys[slug];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    _scrolledFor = slug;

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      alignment: 0.03,
    );
  }

  void _maybeOpen() {
    final slug = widget.sectionSlug;
    final itemId = widget.itemId;

    if (slug == null || slug.isEmpty) return;
    if (itemId == null || itemId.isEmpty) return;
    if (_openedFor == '$slug/$itemId') return;

    final content = _contentController.content.value;
    if (content == null) return;

    final section = content.sections.where((s) => s.slug == slug).firstOrNull;
    if (section == null) return;

    final item = section.items.where((i) => i.id == itemId).firstOrNull;
    if (item == null) return;

    _openedFor = '$slug/$itemId';

    _maybeScroll();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final locale = _localeController.locale.value;
        return ItemBottomSheet(
          section: section,
          item: item,
          localeCode: locale.languageCode,
        );
      },
    ).whenComplete(() {
      if (!mounted) return;
      context.go('/$slug');
    });
  }

  void _handleScroll() {
    final content = _contentController.content.value;
    if (content == null) return;

    _portfolioScroll.setScrollOffset(_scrollController.offset);

    const threshold = 140.0;
    final candidates = <MapEntry<String, double>>[];

    for (final section in content.sections.where((s) => s.enabled)) {
      final dy = _sectionTop(section.slug);
      if (dy != null) {
        candidates.add(MapEntry(section.slug, dy));
      }
    }

    final contactDy = _sectionTop('contact');
    if (contactDy != null) {
      candidates.add(MapEntry('contact', contactDy));
    }

    final above = candidates.where((e) => e.value <= threshold).toList();
    if (above.isEmpty) {
      _portfolioScroll.setActiveSlug('');
      return;
    }

    above.sort((a, b) => a.value.compareTo(b.value));
    _portfolioScroll.setActiveSlug(above.last.key);
  }

  double? _sectionTop(String slug) {
    final key = slug == 'contact' ? _contactKey : _sectionKeys[slug];
    if (key == null) return null;
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject();
    if (box is! RenderBox || !box.attached) return null;
    final offset = box.localToGlobal(Offset.zero);
    return offset.dy;
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      child: Obx(() {
        final locale = _localeController.locale.value;
        final content = _contentController.content.value;
        final isLoading = _contentController.loading.value;
        final error = _contentController.error.value;

        if (content == null) {
          if (isLoading) {
            return Center(child: Text(AppStrings.tr(locale, 'common.loading')));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (error != null) Text(error),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _contentController.forceReload,
                  child: Text(AppStrings.tr(locale, 'common.retry')),
                ),
              ],
            ),
          );
        }

        final viewModel = PortfolioViewModel.from(content, locale);
        const heroOnlySlugs = {
          'profile-summary',
          'technical-skills',
          'design-skills',
          'education',
        };
        final heroSections = viewModel.sections;
        final sections = viewModel.sections
            .where((s) => !heroOnlySlugs.contains(s.slug))
            .toList();

        return SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSection(
                    name: viewModel.name,
                    role: viewModel.role,
                    subtitle: viewModel.subtitle,
                    bio: viewModel.bio,
                    localeCode: locale.languageCode,
                    sections: heroSections,
                  ),
                  const SizedBox(height: 18),
                  for (final section in sections) ...[
                    SectionBlock(
                      key: _keyForSlug(section.slug),
                      section: section,
                      localeCode: locale.languageCode,
                      onItemTap: (itemId) =>
                          context.go('/${section.slug}/$itemId'),
                    ),
                    const SizedBox(height: 18),
                  ],
                  const SizedBox(height: 18),
                  ContactSection(key: _keyForContact(), locale: locale),
                  const SizedBox(height: 18),
                  FooterSection(locale: locale, sections: sections),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
