import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/widgets/glass_container.dart';
import '../../content/state/content_controller.dart';
import '../state/portfolio_scroll_controller.dart';
import 'portfolio_background.dart';

class PortfolioScaffold extends StatelessWidget {
  const PortfolioScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final contentController = Get.find<ContentController>();
    final scrollController = Get.find<PortfolioScrollController>();

    return Obx(() {
      final locale = localeController.locale.value;
      final content = contentController.content.value;
      final isLoading = contentController.loading.value;
      final error = contentController.error.value;
      final activeSlug = scrollController.activeSlug.value;

      return PortfolioBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            const _Brand(),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _NavButton(
                                      label: AppStrings.tr(locale, 'nav.home'),
                                      selected: activeSlug.isEmpty,
                                      onTap: () => context.go('/'),
                                    ),
                                    const SizedBox(width: 8),
                                    if (content != null)
                                      ...content.sections
                                          .where((s) => s.enabled)
                                          .expand((s) sync* {
                                            yield _NavButton(
                                              label: s.title.resolve(
                                                locale.languageCode,
                                              ),
                                              selected: activeSlug == s.slug,
                                              onTap: () =>
                                                  context.go('/${s.slug}'),
                                            );
                                            yield const SizedBox(width: 8);
                                          }),
                                    if (content == null && isLoading)
                                      Text(
                                        AppStrings.tr(locale, 'common.loading'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    _NavButton(
                                      label: AppStrings.tr(
                                        locale,
                                        'nav.contact',
                                      ),
                                      selected: activeSlug == 'contact',
                                      onTap: () => context.go('/contact'),
                                    ),
                                    if (content == null &&
                                        !isLoading &&
                                        error != null)
                                      const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              tooltip: AppStrings.tr(locale, 'nav.admin'),
                              onPressed: () => context.go('/admin'),
                              icon: const Icon(
                                Icons.admin_panel_settings_outlined,
                              ),
                            ),
                            _LocaleToggle(locale: locale),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'svg/hawazen.svg',
      width: 40,
      height: 40,
      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
    ); // Adjust color as needed
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: selected ? Colors.white : Colors.white70,
        backgroundColor: selected
            ? Colors.white.withAlpha(28)
            : Colors.white.withAlpha(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}

class _LocaleToggle extends StatelessWidget {
  const _LocaleToggle({required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocaleController>();
    final isAr = locale.languageCode == 'ar';

    return TextButton(
      onPressed: () =>
          controller.setLocale(isAr ? const Locale('en') : const Locale('ar')),
      child: Text(isAr ? 'EN' : 'AR'),
    );
  }
}
