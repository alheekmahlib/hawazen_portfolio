import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../content/domain/portfolio_models.dart';

class SectionBlock extends StatelessWidget {
  const SectionBlock({
    super.key,
    required this.section,
    required this.localeCode,
    required this.onItemTap,
  });

  final PortfolioSection section;
  final String localeCode;
  final ValueChanged<String> onItemTap;

  @override
  Widget build(BuildContext context) {
    final items = section.items.where((i) => i.enabled).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  section.title.resolve(localeCode),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
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
                  border: Border.all(color: Colors.white.withAlpha(20)),
                ),
                child: Text(
                  '${items.length}',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white70),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 16 / 10.6,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return SectionItemCard(
                  section: section,
                  item: item,
                  localeCode: localeCode,
                  onTap: () => onItemTap(item.id),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class SectionItemCard extends StatelessWidget {
  const SectionItemCard({
    super.key,
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
        padding: EdgeInsets.zero,
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
              child: DecoratedBox(
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
                    const ArrowDot(),
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

class ArrowDot extends StatelessWidget {
  const ArrowDot({super.key});

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
