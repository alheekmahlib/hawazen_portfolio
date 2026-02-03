import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../content/domain/portfolio_models.dart';
import 'gradient_text.dart';
import 'social_block.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.name,
    required this.role,
    required this.subtitle,
    required this.bio,
    required this.localeCode,
    required this.sections,
  });

  final String name;
  final String role;
  final String subtitle;
  final String bio;
  final String localeCode;
  final List<PortfolioSection> sections;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final quickSections = _quickSections();

    final hero = GlassContainer(
      padding: const EdgeInsets.all(22),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              text: name,
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(height: 1.05),
            ),
            const SizedBox(height: 12),
            Text(
              role,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white.withAlpha(220),
                height: 1.2,
              ),
            ),
            if (subtitle.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ],
            if (bio.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                bio,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.7,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final entry in quickSections)
                  FilledButton.tonalIcon(
                    onPressed: entry.item == null
                        ? () => context.go('/${entry.section.slug}')
                        : () => context.go(
                            '/${entry.section.slug}/${entry.item!.id}',
                          ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(_sectionLabel(entry.section)),
                  ),
                OutlinedButton.icon(
                  onPressed: () => context.go('/contact'),
                  icon: const Icon(Icons.mail_outline_rounded),
                  label: Text(
                    AppStrings.tr(
                      Localizations.localeOf(context),
                      'nav.contact',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [hero, const SizedBox(height: 14), const SocialBlock()],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: hero),
        const SizedBox(width: 14),
        const SizedBox(width: 360, child: SocialBlock()),
      ],
    );
  }

  String _sectionLabel(PortfolioSection section) {
    final label = section.title.resolve(localeCode);
    if (label.trim().isNotEmpty) return label;
    return _defaultLabelForSlug(section.slug);
  }

  List<_QuickSectionEntry> _quickSections() {
    const desired = <String, String>{
      'profile-summary': 'PROFILE SUMMARY',
      'technical-skills': 'TECHNICAL SKILLS',
      'design-skills': 'DESIGN SKILLS',
      'education': 'EDUCATION',
    };

    final results = <_QuickSectionEntry>[];
    for (final entry in desired.entries) {
      final section = sections
          .where((s) => s.slug == entry.key && s.enabled)
          .firstOrNull;
      if (section == null) continue;
      final item = section.items.where((i) => i.enabled).firstOrNull;
      results.add(_QuickSectionEntry(section: section, item: item));
    }
    return results;
  }

  String _defaultLabelForSlug(String slug) {
    switch (slug) {
      case 'profile-summary':
        return 'PROFILE SUMMARY';
      case 'technical-skills':
        return 'TECHNICAL SKILLS';
      case 'design-skills':
        return 'DESIGN SKILLS';
      case 'education':
        return 'EDUCATION';
      default:
        return slug.replaceAll('-', ' ').toUpperCase();
    }
  }
}

class _QuickSectionEntry {
  const _QuickSectionEntry({required this.section, required this.item});

  final PortfolioSection section;
  final SectionItem? item;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
