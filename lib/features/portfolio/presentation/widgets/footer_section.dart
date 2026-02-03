import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../content/domain/portfolio_models.dart';
import '../../../content/state/content_controller.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({
    super.key,
    required this.locale,
    required this.sections,
  });

  final Locale locale;
  final List<PortfolioSection> sections;

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();
    final content = contentController.content.value;
    if (content == null) return const SizedBox.shrink();

    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final name = content.site.name?.resolve(locale.languageCode) ?? 'Portfolio';
    final role = content.site.role?.resolve(locale.languageCode) ?? '';
    final subtitle = content.site.subtitle?.resolve(locale.languageCode) ?? '';
    final c = content.site.contact;

    final year = DateTime.now().year;
    final rights = locale.languageCode == 'ar'
        ? '© $year $name — جميع الحقوق محفوظة'
        : '© $year $name — All rights reserved';
    final builtWith = locale.languageCode == 'ar'
        ? 'مبني بـ Flutter •'
        : 'Built with Flutter •';

    final about = SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          if (role.isNotEmpty)
            Text(
              role,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          if (subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white60),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            builtWith,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );

    final links = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.languageCode == 'ar' ? 'روابط سريعة' : 'Quick links',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in sections)
              OutlinedButton(
                onPressed: () => context.go('/${s.slug}'),
                child: Text(s.title.resolve(locale.languageCode)),
              ),
            OutlinedButton(
              onPressed: () => context.go('/contact'),
              child: Text(AppStrings.tr(locale, 'nav.contact')),
            ),
          ],
        ),
      ],
    );

    final social = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.languageCode == 'ar' ? 'تواصل' : 'Connect',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final s in content.site.social)
              OutlinedButton.icon(
                onPressed: () => _launch(s.url),
                icon: const Icon(Icons.open_in_new),
                label: Text(s.label),
              ),
            if (c.email != null)
              OutlinedButton.icon(
                onPressed: () => _launch('mailto:${c.email}'),
                icon: const Icon(Icons.mail_outline),
                label: const Text('Email'),
              ),
            if (c.whatsapp != null)
              OutlinedButton.icon(
                onPressed: () => _launch(c.whatsapp!),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('WhatsApp'),
              ),
          ],
        ),
      ],
    );

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: about),
                const SizedBox(width: 18),
                Expanded(child: links),
                const SizedBox(width: 18),
                Expanded(child: social),
              ],
            )
          else ...[
            about,
            const SizedBox(height: 16),
            links,
            const SizedBox(height: 16),
            social,
          ],
          const SizedBox(height: 16),
          Divider(color: Colors.white.withAlpha(20)),
          const SizedBox(height: 10),
          Text(
            rights,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
