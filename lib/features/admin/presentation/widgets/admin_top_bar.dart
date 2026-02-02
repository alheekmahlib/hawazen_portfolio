import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/glass_container.dart';

class AdminTopBar extends StatelessWidget {
  const AdminTopBar({
    super.key,
    required this.locale,
    required this.urlController,
    required this.onSaveUrl,
    required this.onReload,
    required this.onImport,
    required this.onExport,
  });

  final Locale locale;
  final TextEditingController urlController;
  final VoidCallback onSaveUrl;
  final VoidCallback onReload;
  final VoidCallback onImport;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: AppStrings.tr(locale, 'admin.contentUrl'),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => onSaveUrl(),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: onSaveUrl,
              icon: const Icon(Icons.save_outlined),
              label: Text(AppStrings.tr(locale, 'common.save')),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: onReload,
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.tr(locale, 'admin.reload')),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.file_open_outlined),
              label: Text(AppStrings.tr(locale, 'common.import')),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: onExport,
              icon: const Icon(Icons.download_outlined),
              label: Text(AppStrings.tr(locale, 'common.export')),
            ),
          ],
        ),
      ),
    );
  }
}
