import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/widgets/glass_container.dart';
import '../../content/state/content_controller.dart';
import 'portfolio_scaffold.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
          final c = content.site.contact;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.tr(locale, 'nav.contact'),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      if (c.email != null)
                        _Row(label: 'Email', value: c.email!),
                      if (c.phone != null)
                        _Row(label: 'Phone', value: c.phone!),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          if (c.email != null)
                            ElevatedButton(
                              onPressed: () => _launch('mailto:${c.email}'),
                              child: const Text('Email'),
                            ),
                          if (c.whatsapp != null)
                            OutlinedButton(
                              onPressed: () => _launch(c.whatsapp!),
                              child: const Text('WhatsApp'),
                            ),
                        ],
                      ),
                    ],
                  ),
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

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
