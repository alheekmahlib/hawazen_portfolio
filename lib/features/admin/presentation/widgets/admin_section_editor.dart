import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/slugify.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../content/domain/portfolio_models.dart';
import '../../state/admin_controller.dart';
import 'admin_field_definitions_editor.dart';
import 'admin_items_editor.dart';
import 'admin_layout_editors.dart';

class AdminSectionEditor extends StatelessWidget {
  const AdminSectionEditor({
    super.key,
    required this.section,
    required this.controller,
    required this.locale,
  });

  final PortfolioSection section;
  final AdminController controller;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    _normalizeStoreLinksOptional();
    final keys = section.fieldDefinitions.map((e) => e.key).toList();
    final imageKeys = section.fieldDefinitions
        .where((d) => d.type == FieldType.image)
        .map((e) => e.key)
        .toList();
    final linkKeys = section.fieldDefinitions
        .where((d) => d.type == FieldType.link)
        .map((e) => e.key)
        .toList();

    final slugController = TextEditingController(text: section.slug);
    final titleEn = TextEditingController(
      text: section.title.values['en'] ?? '',
    );
    final titleAr = TextEditingController(
      text: section.title.values['ar'] ?? '',
    );

    return GlassContainer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${section.title.resolve('en')} (${section.slug})',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: slugController,
                    decoration: InputDecoration(
                      labelText: AppStrings.tr(locale, 'admin.sectionSlug'),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (v) {
                      final safe = slugify(v);
                      controller.upsertSection(section.copyWith(slug: safe));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: section.enabled,
                  onChanged: (v) =>
                      controller.upsertSection(section.copyWith(enabled: v)),
                ),
                Text(AppStrings.tr(locale, 'admin.sectionEnabled')),
                const Spacer(),
                IconButton(
                  tooltip: AppStrings.tr(locale, 'common.delete'),
                  onPressed: () => controller.deleteSection(section.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleEn,
                    decoration: InputDecoration(
                      labelText: AppStrings.tr(locale, 'admin.sectionTitleEn'),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (v) => controller.upsertSection(
                      section.copyWith(
                        title: L10nText({...section.title.values, 'en': v}),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: titleAr,
                    decoration: InputDecoration(
                      labelText: AppStrings.tr(locale, 'admin.sectionTitleAr'),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (v) => controller.upsertSection(
                      section.copyWith(
                        title: L10nText({...section.title.values, 'ar': v}),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.tr(locale, 'admin.items'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.tr(locale, 'admin.itemsHelp'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            AdminItemsEditor(
              section: section,
              controller: controller,
              locale: locale,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.tr(locale, 'admin.fields'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            AdminFieldDefinitionsEditor(
              section: section,
              controller: controller,
              locale: locale,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.tr(locale, 'admin.cardLayout'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            AdminCardLayoutEditor(
              section: section,
              keys: keys,
              controller: controller,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.tr(locale, 'admin.detailLayout'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            AdminDetailLayoutEditor(
              section: section,
              keys: keys,
              imageKeys: imageKeys,
              linkKeys: linkKeys,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  void _normalizeStoreLinksOptional() {
    final needsUpdate = section.fieldDefinitions.any(
      (d) => _isStoreLinkKey(d.key) && d.required,
    );
    if (!needsUpdate) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defs = section.fieldDefinitions
          .map((d) => _isStoreLinkKey(d.key) ? d.copyWith(required: false) : d)
          .toList();
      controller.upsertSection(section.copyWith(fieldDefinitions: defs));
    });
  }

  bool _isStoreLinkKey(String key) {
    final v = key.toLowerCase();
    return v == 'ios' ||
        v == 'android' ||
        v == 'appstore' ||
        v == 'playstore' ||
        v == 'googleplay' ||
        v == 'app_store' ||
        v == 'play_store';
  }
}
