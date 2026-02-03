import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../content/state/content_controller.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();
    final content = contentController.content.value;
    if (content == null) return const SizedBox.shrink();

    final c = content.site.contact;
    final hasAny = c.email != null || c.phone != null || c.whatsapp != null;
    if (!hasAny) return const SizedBox.shrink();

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.tr(locale, 'nav.contact'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (c.email != null) ContactRow(label: 'Email', value: c.email!),
            if (c.phone != null) ContactRow(label: 'Phone', value: c.phone!),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
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
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class ContactRow extends StatelessWidget {
  const ContactRow({super.key, required this.label, required this.value});

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
