import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_container.dart';
import '../../content/domain/portfolio_models.dart';
import '../../content/state/content_controller.dart';
import 'item_bottom_sheet.dart';
import 'portfolio_scaffold.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({
    super.key,
    required this.sectionSlug,
    required this.itemId,
  });

  final String sectionSlug;
  final String? itemId;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  String? _openedFor;
  late final ContentController _contentController;
  late final LocaleController _localeController;
  Worker? _contentWorker;

  @override
  void didUpdateWidget(covariant SectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId != widget.itemId) {
      _openedFor = null;
      _maybeOpen();
    }
  }

  @override
  void initState() {
    super.initState();
    _contentController = Get.find<ContentController>();
    _localeController = Get.find<LocaleController>();
    _contentWorker = ever<PortfolioContent?>(_contentController.content, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpen());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpen());
  }

  @override
  void dispose() {
    _contentWorker?.dispose();
    super.dispose();
  }

  void _maybeOpen() {
    final itemId = widget.itemId;
    if (itemId == null || itemId.isEmpty) return;
    if (_openedFor == itemId) return;

    final content = _contentController.content.value;
    if (content == null) return;

    final section = content.sections
        .where((s) => s.slug == widget.sectionSlug)
        .firstOrNull;
    if (section == null) return;

    final item = section.items.where((i) => i.id == itemId).firstOrNull;
    if (item == null) return;

    _openedFor = itemId;

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
      if (mounted) {
        context.go('/${widget.sectionSlug}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      child: Obx(() {
        final locale = _localeController.locale.value;
        final content = _contentController.content.value;
        final isLoading = _contentController.loading.value;
        final error = _contentController.error.value;

        if (content != null) {
          final section = content.sections.firstWhere(
            (s) => s.slug == widget.sectionSlug,
            orElse: () => PortfolioSection(
              id: 'missing',
              slug: widget.sectionSlug,
              title: const L10nText({"en": "Missing", "ar": "غير موجود"}),
              enabled: false,
              fieldDefinitions: const [],
              cardLayout: const CardLayout(titleField: 'name'),
              detailLayout: const DetailLayout(titleField: 'name'),
              items: const [],
            ),
          );

          final items = section.items.where((i) => i.enabled).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlassContainer(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              section.title.resolve(locale.languageCode),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: Colors.white.withAlpha(12),
                              border: Border.all(
                                color: Colors.white.withAlpha(20),
                              ),
                            ),
                            child: Text(
                              '${items.length}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final crossAxisCount = w >= 1100
                            ? 3
                            : w >= 760
                            ? 2
                            : 1;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 16 / 10.6,
                              ),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _ItemCard(
                              section: section,
                              item: item,
                              localeCode: locale.languageCode,
                              onTap: () =>
                                  context.go('/${section.slug}/${item.id}'),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (isLoading) {
          return Center(child: Text(AppStrings.tr(locale, 'common.loading')));
        }

        return Center(child: Text(error ?? 'Failed to load'));
      }),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.section,
    required this.item,
    required this.localeCode,
    required this.onTap,
  });

  final PortfolioSection section;
  final SectionItem item;
  final String localeCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final layout = section.cardLayout;
    final title = _fieldText(layout.titleField);
    final subtitle = layout.subtitleField == null
        ? null
        : _fieldText(layout.subtitleField!);
    final mediaUrl = layout.mediaField == null
        ? null
        : _fieldString(layout.mediaField!);

    final radius = BorderRadius.circular(26);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: GlassContainer(
        padding: const EdgeInsets.all(0),
        borderRadius: radius,
        child: Stack(
          children: [
            if (mediaUrl != null && mediaUrl.isNotEmpty)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: radius,
                  child: Image.network(
                    mediaUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withAlpha(210),
                      Colors.black.withAlpha(25),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: GlassContainer(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (subtitle != null && subtitle.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _plain(subtitle),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                      height: 1.4,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _ArrowDot(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _plain(String s) {
    return s
        .replaceAll(RegExp(r'[#*_`>\\-]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _fieldText(String key) {
    final def = section.fieldDefinitions.where((d) => d.key == key).firstOrNull;
    final value = item.fields[key];
    if (def == null || value == null) return '';
    if (!def.localized) return value.toString();
    if (value is Map) {
      final map = value
          .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
          .cast<String, String>();
      return L10nText(map).resolve(localeCode);
    }
    return value.toString();
  }

  String? _fieldString(String key) {
    final v = item.fields[key];
    return v?.toString();
  }
}

class _ArrowDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppTheme.surface, AppTheme.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(90),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
