// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/utils/slugify.dart';
import '../../../core/widgets/glass_container.dart';
import '../../content/domain/portfolio_models.dart';
import '../state/admin_controller.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0C),
      body: SafeArea(
        child: Obx(() {
          final locale = localeController.locale.value;
          return GetBuilder<AdminController>(
            builder: (admin) {
              if (admin.loading.value) {
                return Center(
                  child: Text(AppStrings.tr(locale, 'common.loading')),
                );
              }
              if (admin.error.value != null) {
                return Center(child: Text(admin.error.value!));
              }
              final draft = admin.draft.value;
              if (draft == null) {
                return Center(
                  child: Text(AppStrings.tr(locale, 'common.loading')),
                );
              }
              return _AdminBody(
                draft: draft,
                controller: admin,
                locale: locale,
              );
            },
          );
        }),
      ),
    );
  }
}

class _AdminBody extends StatefulWidget {
  const _AdminBody({
    required this.draft,
    required this.controller,
    required this.locale,
  });

  final AdminDraft draft;
  final AdminController controller;
  final Locale locale;

  @override
  State<_AdminBody> createState() => _AdminBodyState();
}

class _AdminBodyState extends State<_AdminBody> {
  late final TextEditingController _url;

  @override
  void initState() {
    super.initState();
    _url = TextEditingController(text: widget.draft.contentUrl ?? '');
  }

  @override
  void didUpdateWidget(covariant _AdminBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.draft.contentUrl ?? '') != (widget.draft.contentUrl ?? '')) {
      _url.text = widget.draft.contentUrl ?? '';
    }
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale;
    final controller = widget.controller;

    final content = widget.draft.content;
    final selectedId = widget.draft.selectedSectionId;
    final selected = selectedId == null
        ? null
        : content.sections.where((s) => s.id == selectedId).firstOrNull;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _url,
                    decoration: InputDecoration(
                      labelText: AppStrings.tr(locale, 'admin.contentUrl'),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (v) => controller.setContentUrl(v),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => controller.setContentUrl(_url.text),
                  icon: const Icon(Icons.save_outlined),
                  label: Text(AppStrings.tr(locale, 'common.save')),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => controller.reload(forceRefresh: true),
                  icon: const Icon(Icons.refresh),
                  label: Text(AppStrings.tr(locale, 'admin.reload')),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => _importDialog(context),
                  icon: const Icon(Icons.file_open_outlined),
                  label: Text(AppStrings.tr(locale, 'common.import')),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: () => _exportJson(),
                  icon: const Icon(Icons.download_outlined),
                  label: Text(AppStrings.tr(locale, 'common.export')),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 980;
                final left = _SectionsPanel(
                  sections: content.sections,
                  selectedId: selectedId,
                  onSelect: controller.selectSection,
                  onAdd: () => _addSectionDialog(context),
                  onReorder: controller.reorderSections,
                );

                final right = selected == null
                    ? const SizedBox.shrink()
                    : _SectionEditor(
                        section: selected,
                        controller: controller,
                        locale: locale,
                      );

                if (!isWide) {
                  return Column(
                    children: [
                      SizedBox(height: 260, child: left),
                      const SizedBox(height: 12),
                      Expanded(child: right),
                    ],
                  );
                }

                return Row(
                  children: [
                    SizedBox(width: 360, child: left),
                    const SizedBox(width: 12),
                    Expanded(child: right),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _exportJson() {
    final json = widget.controller.exportPrettyJson();
    final bytes = html.Blob([json], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(bytes);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'content.json')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  final text = TextEditingController();

  Future<void> _importDialog(BuildContext context) async {
    final locale = widget.locale;
    final controller = widget.controller;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppStrings.tr(locale, 'common.import')),
          content: SizedBox(
            width: 720,
            child: TextField(
              controller: text,
              maxLines: 18,
              decoration: const InputDecoration(
                hintText: '{\n  "schemaVersion": "1.0",\n  ...\n}',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppStrings.tr(locale, 'common.cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppStrings.tr(locale, 'common.import')),
            ),
          ],
        );
      },
    );

    if (ok != true) return;
    final success = controller.importJson(text.text);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid JSON')));
    }
  }

  final slug = TextEditingController();
  final titleEn = TextEditingController();
  final titleAr = TextEditingController();

  Future<void> _addSectionDialog(BuildContext context) async {
    final locale = widget.locale;
    final controller = widget.controller;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppStrings.tr(locale, 'admin.addSection')),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: slug,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(locale, 'admin.sectionSlug'),
                    hintText: 'packages',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleEn,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(locale, 'admin.sectionTitleEn'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleAr,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(locale, 'admin.sectionTitleAr'),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppStrings.tr(locale, 'common.cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppStrings.tr(locale, 'common.add')),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    controller.addSection(
      slug: slug.text,
      titleEn: titleEn.text,
      titleAr: titleAr.text,
    );
  }
}

class _SectionsPanel extends StatelessWidget {
  const _SectionsPanel({
    required this.sections,
    required this.selectedId,
    required this.onSelect,
    required this.onAdd,
    required this.onReorder,
  });

  final List<PortfolioSection> sections;
  final String? selectedId;
  final void Function(String id) onSelect;
  final VoidCallback onAdd;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sections',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: sections.length,
              onReorder: onReorder,
              itemBuilder: (context, index) {
                final s = sections[index];
                final selected = s.id == selectedId;
                return ListTile(
                  key: ValueKey(s.id),
                  selected: selected,
                  title: Text('${s.title.resolve('en')} (${s.slug})'),
                  trailing: const Icon(Icons.drag_handle),
                  onTap: () => onSelect(s.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionEditor extends StatelessWidget {
  const _SectionEditor({
    required this.section,
    required this.controller,
    required this.locale,
  });

  final PortfolioSection section;
  final AdminController controller;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
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
            _ItemsEditor(
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
            _FieldDefinitionsEditor(
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
            _CardLayoutEditor(
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
            _DetailLayoutEditor(
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
}

class _FieldDefinitionsEditor extends StatelessWidget {
  const _FieldDefinitionsEditor({
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
                    _MiniToggle(
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
                    _MiniToggle(
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
                    _MiniToggle(
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

class _MiniToggle extends StatelessWidget {
  const _MiniToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
      ],
    );
  }
}

class _CardLayoutEditor extends StatelessWidget {
  const _CardLayoutEditor({
    required this.section,
    required this.keys,
    required this.controller,
  });

  final PortfolioSection section;
  final List<String> keys;
  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    final layout = section.cardLayout;

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _valid(layout.titleField, keys),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'titleField',
            ),
            items: keys
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              controller.upsertSection(
                section.copyWith(cardLayout: layout.copyWith(titleField: v)),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String?>(
            initialValue: _validNullable(layout.subtitleField, keys),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'subtitleField',
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('(none)')),
              ...keys.map((k) => DropdownMenuItem(value: k, child: Text(k))),
            ],
            onChanged: (v) => controller.upsertSection(
              section.copyWith(cardLayout: layout.copyWith(subtitleField: v)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String?>(
            initialValue: _validNullable(layout.mediaField, keys),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'mediaField',
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('(none)')),
              ...keys.map((k) => DropdownMenuItem(value: k, child: Text(k))),
            ],
            onChanged: (v) => controller.upsertSection(
              section.copyWith(cardLayout: layout.copyWith(mediaField: v)),
            ),
          ),
        ),
      ],
    );
  }

  String _valid(String v, List<String> keys) =>
      keys.contains(v) ? v : keys.first;
  String? _validNullable(String? v, List<String> keys) =>
      (v != null && keys.contains(v)) ? v : null;
}

class _DetailLayoutEditor extends StatelessWidget {
  const _DetailLayoutEditor({
    required this.section,
    required this.keys,
    required this.imageKeys,
    required this.linkKeys,
    required this.controller,
  });

  final PortfolioSection section;
  final List<String> keys;
  final List<String> imageKeys;
  final List<String> linkKeys;
  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    final layout = section.detailLayout;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _valid(layout.titleField, keys),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'titleField',
                ),
                items: keys
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  controller.upsertSection(
                    section.copyWith(
                      detailLayout: layout.copyWith(titleField: v),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String?>(
                initialValue: _validNullable(layout.subtitleField, keys),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'subtitleField',
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('(none)')),
                  ...keys.map(
                    (k) => DropdownMenuItem(value: k, child: Text(k)),
                  ),
                ],
                onChanged: (v) => controller.upsertSection(
                  section.copyWith(
                    detailLayout: layout.copyWith(subtitleField: v),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String?>(
                initialValue: _validNullable(layout.mediaField, keys),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'mediaField',
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('(none)')),
                  ...keys.map(
                    (k) => DropdownMenuItem(value: k, child: Text(k)),
                  ),
                ],
                onChanged: (v) => controller.upsertSection(
                  section.copyWith(
                    detailLayout: layout.copyWith(mediaField: v),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String?>(
          initialValue: _validNullable(layout.galleryField, imageKeys),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'galleryField (image list)',
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('(none)')),
            ...imageKeys.map((k) => DropdownMenuItem(value: k, child: Text(k))),
          ],
          onChanged: (v) => controller.upsertSection(
            section.copyWith(detailLayout: layout.copyWith(galleryField: v)),
          ),
        ),
        const SizedBox(height: 10),
        _MultiSelectChips(
          title: 'bodyFields',
          options: keys,
          selected: layout.bodyFields.toSet(),
          onChanged: (set) => controller.upsertSection(
            section.copyWith(
              detailLayout: layout.copyWith(bodyFields: set.toList()),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _MultiSelectChips(
          title: 'actionFields (links)',
          options: linkKeys,
          selected: layout.actionFields.toSet(),
          onChanged: (set) => controller.upsertSection(
            section.copyWith(
              detailLayout: layout.copyWith(actionFields: set.toList()),
            ),
          ),
        ),
      ],
    );
  }

  String _valid(String v, List<String> keys) =>
      keys.contains(v) ? v : keys.first;
  String? _validNullable(String? v, List<String> keys) =>
      (v != null && keys.contains(v)) ? v : null;
}

class _MultiSelectChips extends StatelessWidget {
  const _MultiSelectChips({
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final o in options)
              FilterChip(
                label: Text(o),
                selected: selected.contains(o),
                onSelected: (v) {
                  final next = {...selected};
                  v ? next.add(o) : next.remove(o);
                  onChanged(next);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _ItemsEditor extends StatelessWidget {
  const _ItemsEditor({
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                final item = controller.addItem(
                  section,
                  localeCode: locale.languageCode,
                );
                _editItem(context, section, item);
              },
              icon: const Icon(Icons.add),
              label: Text(AppStrings.tr(locale, 'admin.addItem')),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (section.items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              locale.languageCode == 'ar'
                  ? 'لا توجد عناصر بعد. اضغط “إضافة عنصر” ثم “تحرير”.'
                  : 'No items yet. Click “Add item” then “Edit”.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ),
        for (final i in section.items)
          Card(
            color: Colors.white.withAlpha(15),
            child: ListTile(
              title: Text(
                '${i.id}  •  ${_itemTitle(section, i, locale.languageCode)}',
              ),
              subtitle: Text(i.enabled ? 'enabled' : 'disabled'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Regenerate ID from title',
                    onPressed: () =>
                        controller.regenerateItemIdFromTitle(section, i),
                    icon: const Icon(Icons.tag_outlined),
                  ),
                  IconButton(
                    onPressed: () => _editItem(context, section, i),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => controller.deleteItem(section, i.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              onTap: () => _editItem(context, section, i),
            ),
          ),
      ],
    );
  }

  String _itemTitle(
    PortfolioSection section,
    SectionItem item,
    String localeCode,
  ) {
    final titleKey = section.cardLayout.titleField;
    final def = section.fieldDefinitions
        .where((d) => d.key == titleKey)
        .firstOrNull;
    final v = item.fields[titleKey];
    if (def == null || v == null) return '';
    if (!def.localized) return v.toString();
    if (v is Map) {
      final map = v
          .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
          .cast<String, String>();
      return L10nText(map).resolve(localeCode);
    }
    return v.toString();
  }

  Future<void> _editItem(
    BuildContext context,
    PortfolioSection section,
    SectionItem item,
  ) async {
    final result = await showDialog<SectionItem>(
      context: context,
      builder: (context) => _ItemEditorDialog(
        section: section,
        item: item,
        locale: locale,
        onLiveChange: (updated) => controller.updateItem(section, updated),
      ),
    );

    if (result != null) {
      controller.updateItem(section, result);
    }
  }
}

class _ItemEditorDialog extends StatefulWidget {
  const _ItemEditorDialog({
    required this.section,
    required this.item,
    required this.locale,
    this.onLiveChange,
  });

  final PortfolioSection section;
  final SectionItem item;
  final Locale locale;
  final ValueChanged<SectionItem>? onLiveChange;

  @override
  State<_ItemEditorDialog> createState() => _ItemEditorDialogState();
}

class _ItemEditorDialogState extends State<_ItemEditorDialog> {
  late Map<String, Object?> _fields;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _fields = Map<String, Object?>.from(widget.item.fields);
    _enabled = widget.item.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.locale.languageCode == 'ar'
            ? 'تحرير العنصر: ${widget.item.id}'
            : 'Edit item: ${widget.item.id}',
      ),
      content: SizedBox(
        width: 720,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                value: _enabled,
                onChanged: (v) {
                  setState(() => _enabled = v);
                  _emitLive();
                },
                title: Text(
                  widget.locale.languageCode == 'ar' ? 'مفعل' : 'Enabled',
                ),
              ),
              const SizedBox(height: 8),
              for (final def in widget.section.fieldDefinitions) ...[
                _FieldInput(
                  def: def,
                  localeCode: widget.locale.languageCode,
                  value: _fields[def.key],
                  onChanged: (v) {
                    setState(() => _fields[def.key] = v);
                    _emitLive();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.tr(widget.locale, 'common.cancel')),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop(widget.item.copyWith(enabled: _enabled, fields: _fields));
          },
          child: Text(AppStrings.tr(widget.locale, 'common.save')),
        ),
      ],
    );
  }

  void _emitLive() {
    final callback = widget.onLiveChange;
    if (callback == null) return;
    callback(widget.item.copyWith(enabled: _enabled, fields: _fields));
  }
}

class _FieldInput extends StatefulWidget {
  const _FieldInput({
    required this.def,
    required this.localeCode,
    required this.value,
    required this.onChanged,
  });

  final FieldDefinition def;
  final String localeCode;
  final Object? value;
  final ValueChanged<Object?> onChanged;

  @override
  State<_FieldInput> createState() => _FieldInputState();
}

class _FieldInputState extends State<_FieldInput> {
  TextEditingController? _controller;
  TextEditingController? _controllerEn;
  TextEditingController? _controllerAr;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant _FieldInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controllerEn?.dispose();
    _controllerAr?.dispose();
    super.dispose();
  }

  void _initControllers() {
    if (widget.def.localized) {
      final map = _asLocalizedMap(widget.value);
      _controllerEn = TextEditingController(text: map['en'] ?? '');
      _controllerAr = TextEditingController(text: map['ar'] ?? '');
      _controllerEn!.addListener(() {
        if (_updating) return;
        _emitLocalized();
      });
      _controllerAr!.addListener(() {
        if (_updating) return;
        _emitLocalized();
      });
      return;
    }

    final text = _stringValue(widget.value);
    _controller = TextEditingController(text: text);
    _controller!.addListener(() {
      if (_updating) return;
      if (widget.def.type == FieldType.tagList) {
        final tags = _controller!.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        widget.onChanged(tags);
      } else {
        widget.onChanged(_controller!.text);
      }
    });
  }

  void _syncControllers() {
    _updating = true;
    try {
      if (widget.def.localized) {
        final map = _asLocalizedMap(widget.value);
        if (_controllerEn?.text != (map['en'] ?? '')) {
          _controllerEn?.text = map['en'] ?? '';
        }
        if (_controllerAr?.text != (map['ar'] ?? '')) {
          _controllerAr?.text = map['ar'] ?? '';
        }
        return;
      }

      final text = _stringValue(widget.value);
      if (_controller?.text != text) {
        _controller?.text = text;
      }
    } finally {
      _updating = false;
    }
  }

  void _emitLocalized() {
    final map = {
      'en': _controllerEn?.text ?? '',
      'ar': _controllerAr?.text ?? '',
    };
    widget.onChanged(map);
  }

  Map<String, String> _asLocalizedMap(Object? value) {
    final map = <String, String>{'en': '', 'ar': ''};
    if (value is Map) {
      for (final entry in value.entries) {
        map[entry.key.toString()] = entry.value?.toString() ?? '';
      }
    }
    return map;
  }

  String _stringValue(Object? value) {
    if (widget.def.type == FieldType.tagList) {
      if (value is List) return value.join(', ');
    }
    return value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.def.label.resolve(widget.localeCode);

    if (widget.def.type == FieldType.boolean) {
      final v = (widget.value is bool) ? widget.value as bool : false;
      return SwitchListTile(
        value: v,
        onChanged: (b) => widget.onChanged(b),
        title: Text(label),
      );
    }

    if (widget.def.type == FieldType.image && widget.def.multiple) {
      final list = widget.value is List
          ? (widget.value as List).map((e) => e.toString()).toList()
          : <String>[];
      return _StringListInput(
        label: label,
        values: list,
        onChanged: (v) => widget.onChanged(v),
      );
    }

    if (widget.def.localized) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controllerEn,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'EN',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controllerAr,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'AR',
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return TextField(
      controller: _controller,
      maxLines: widget.def.type == FieldType.markdown ? 6 : 1,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        hintText: switch (widget.def.type) {
          FieldType.image => 'https://.../image.png',
          FieldType.link => 'https://...',
          FieldType.markdown =>
            widget.localeCode == 'ar'
                ? 'اكتب Markdown هنا…'
                : 'Write markdown here…',
          FieldType.date => 'YYYY-MM-DD',
          _ => null,
        },
      ),
    );
  }
}

class _StringListInput extends StatefulWidget {
  const _StringListInput({
    required this.label,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_StringListInput> createState() => _StringListInputState();
}

class _StringListInputState extends State<_StringListInput> {
  late List<String> _items;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _items = [...widget.values];
    if (_items.isEmpty) _items.add('');
    _controllers = _items
        .map((value) => TextEditingController(text: value))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _StringListInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_listEquals(oldWidget.values, widget.values)) {
      _items = [...widget.values];
      if (_items.isEmpty) _items.add('');
      for (final c in _controllers) {
        c.dispose();
      }
      _controllers = _items
          .map((value) => TextEditingController(text: value))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        for (var i = 0; i < _items.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controllers[i],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'URL ${i + 1}',
                  ),
                  onChanged: (v) {
                    _items[i] = v;
                    widget.onChanged(
                      _items.where((e) => e.trim().isNotEmpty).toList(),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _items.removeAt(i);
                    _controllers.removeAt(i).dispose();
                    if (_items.isEmpty) {
                      _items.add('');
                      _controllers.add(TextEditingController(text: ''));
                    }
                    widget.onChanged(
                      _items.where((e) => e.trim().isNotEmpty).toList(),
                    );
                  });
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: () => setState(() {
              _items.add('');
              _controllers.add(TextEditingController(text: ''));
            }),
            icon: const Icon(Icons.add),
            label: const Text('Add URL'),
          ),
        ),
      ],
    );
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
