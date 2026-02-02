import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/widgets/glass_container.dart';
import '../../content/state/content_controller.dart';
import 'portfolio_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();
    final localeController = Get.find<LocaleController>();

    return PortfolioScaffold(
      child: Obx(() {
        final locale = localeController.locale.value;
        final content = contentController.content.value;
        final isLoading = contentController.loading.value;
        final error = contentController.error.value;

        if (content != null) {
          final name = content.site.name?.resolve(locale.languageCode) ?? '';
          final role = content.site.role?.resolve(locale.languageCode) ?? '';
          final subtitle =
              content.site.subtitle?.resolve(locale.languageCode) ?? '';
          final bio = content.site.bio?.resolve(locale.languageCode) ?? '';

          final sections = content.sections.where((s) => s.enabled).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;

                    final hero = GlassContainer(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GradientText(
                            text: name,
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium?.copyWith(height: 1.05),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            role,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white.withAlpha(220),
                                  height: 1.2,
                                ),
                          ),
                          if (subtitle.trim().isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                            ),
                          ],
                          if (bio.trim().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              bio,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
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
                                  onPressed: () => context.go('/${s.slug}'),
                                  icon: const Icon(Icons.arrow_forward_rounded),
                                  label: Text(
                                    s.title.resolve(locale.languageCode),
                                  ),
                                ),
                              OutlinedButton.icon(
                                onPressed: () => context.go('/contact'),
                                icon: const Icon(Icons.mail_outline_rounded),
                                label: Text(
                                  AppStrings.tr(locale, 'nav.contact'),
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
                        children: [
                          hero,
                          const SizedBox(height: 14),
                          const _SocialBlock(),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: hero),
                        const SizedBox(width: 14),
                        SizedBox(
                          width: 360,
                          child: Column(children: const [_SocialBlock()]),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }

        if (isLoading) {
          return Center(child: Text(AppStrings.tr(locale, 'common.loading')));
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (error != null) Text(error),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: contentController.forceReload,
                child: Text(AppStrings.tr(locale, 'common.retry')),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SocialBlock extends StatelessWidget {
  const _SocialBlock();

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();

    return Obx(() {
      final content = contentController.content.value;
      if (content == null) return const SizedBox.shrink();

      return GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Links',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
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
              ],
            ),
          ],
        ),
      );
    });
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.displayMedium;
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
        ).createShader(bounds);
      },
      child: Text(text, style: effectiveStyle?.copyWith(color: Colors.white)),
    );
  }
}
