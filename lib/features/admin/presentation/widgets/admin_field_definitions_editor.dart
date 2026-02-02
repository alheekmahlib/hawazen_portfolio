import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/slugify.dart';
import '../../../content/domain/portfolio_models.dart';
import '../../state/admin_controller.dart';
import 'admin_layout_editors.dart';

class AdminFieldDefinitionsEditor extends StatelessWidget {
  const AdminFieldDefinitionsEditor({
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
    return Column(
      children: [
        for (final d in section.fieldDefinitions)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: d.key,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'key',
                    ),
                    onFieldSubmitted: (v) {
                      final newKey = slugify(v).replaceAll('-', '_');
                      final defs = section.fieldDefinitions
                          .map(
                            (e) => e.key == d.key ? e.copyWith(key: newKey) : e,
                          )
                          .toList();
                      controller.upsertSection(
                        section.copyWith(fieldDefinitions: defs),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<FieldType>(
                    initialValue: d.type,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'type',
                    ),
                    items: FieldType.values
                        .map(
                          (t) =>
                              DropdownMenuItem(value: t, child: Text(t.name)),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      final defs = section.fieldDefinitions
                          .map((e) => e.key == d.key ? e.copyWith(type: v) : e)
                          .toList();
                      controller.upsertSection(
                        section.copyWith(fieldDefinitions: defs),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    MiniToggle(
                      label: 'req',
                      value: d.required,
                      onChanged: (v) {
                        final defs = section.fieldDefinitions
                            .map(
                              (e) =>
                                  e.key == d.key ? e.copyWith(required: v) : e,
                            )
                            .toList();
                        controller.upsertSection(
                          section.copyWith(fieldDefinitions: defs),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    MiniToggle(
                      label: 'l10n',
                      value: d.localized,
                      onChanged: (v) {
                        final defs = section.fieldDefinitions
                            .map(
                              (e) =>
                                  e.key == d.key ? e.copyWith(localized: v) : e,
                            )
                            .toList();
                        controller.upsertSection(
                          section.copyWith(fieldDefinitions: defs),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    MiniToggle(
                      label: 'list',
                      value: d.multiple,
                      onChanged: (v) {
                        final defs = section.fieldDefinitions
                            .map(
                              (e) =>
                                  e.key == d.key ? e.copyWith(multiple: v) : e,
                            )
                            .toList();
                        controller.upsertSection(
                          section.copyWith(fieldDefinitions: defs),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    final defs = section.fieldDefinitions
                        .where((e) => e.key != d.key)
                        .toList();
                    controller.upsertSection(
                      section.copyWith(fieldDefinitions: defs),
                    );
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: () {
              final defs = [...section.fieldDefinitions];
              final existing = defs.map((e) => e.key).toSet();
              final key = ensureUniqueSlug(
                'field',
                existing,
              ).replaceAll('-', '_');
              defs.add(
                FieldDefinition(
                  key: key,
                  label: const L10nText({'en': 'Field', 'ar': 'حقل'}),
                  type: FieldType.string,
                  required: false,
                  localized: false,
                  multiple: false,
                ),
              );
              controller.upsertSection(
                section.copyWith(fieldDefinitions: defs),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add field'),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => _addStoreLink(
                key: 'appgallery',
                label: const L10nText({'en': 'AppGallery', 'ar': 'AppGallery'}),
              ),
              icon: const Icon(Icons.add_link),
              label: Text(AppStrings.tr(locale, 'admin.addAppGalleryField')),
            ),
            OutlinedButton.icon(
              onPressed: () => _addStoreLink(
                key: 'macappstore',
                label: const L10nText({
                  'en': 'Mac App Store',
                  'ar': 'Mac App Store',
                }),
              ),
              icon: const Icon(Icons.add_link),
              label: Text(AppStrings.tr(locale, 'admin.addMacAppStoreField')),
            ),
          ],
        ),
      ],
    );
  }

  void _addStoreLink({required String key, required L10nText label}) {
    final defs = [...section.fieldDefinitions];
    final hasField = defs.any((e) => e.key == key);
    if (!hasField) {
      defs.add(
        FieldDefinition(
          key: key,
          label: label,
          type: FieldType.link,
          required: false,
          localized: false,
          multiple: false,
        ),
      );
    }

    final layout = section.detailLayout;
    final actions = {...layout.actionFields, key}.toList();

    controller.upsertSection(
      section.copyWith(
        fieldDefinitions: defs,
        detailLayout: layout.copyWith(actionFields: actions),
      ),
    );
  }
}
