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

    final hero = GlassContainer(
      padding: const EdgeInsets.all(22),
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
              for (final s in sections)
                FilledButton.tonalIcon(
                  onPressed: () {
                    context.go('/${s.slug}');
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(s.title.resolve(localeCode)),
                ),
              OutlinedButton.icon(
                onPressed: () => context.go('/contact'),
                icon: const Icon(Icons.mail_outline_rounded),
                label: Text(
                  AppStrings.tr(Localizations.localeOf(context), 'nav.contact'),
                ),
              ),
            ],
          ),
        ],
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
}
