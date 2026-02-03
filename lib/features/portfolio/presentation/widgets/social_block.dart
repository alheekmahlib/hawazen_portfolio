import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../content/state/content_controller.dart';

class SocialBlock extends StatelessWidget {
  const SocialBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Get.find<ContentController>();
    final LocaleController localeController = Get.find<LocaleController>();
    final content = contentController.content.value;
    final c = content!.site.contact;
    final locale = localeController.locale.value;

    return Obx(() {
      final content = contentController.content.value;
      if (content == null) return const SizedBox.shrink();

      return GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
