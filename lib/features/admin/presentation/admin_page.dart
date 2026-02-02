// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_controller.dart';
import '../state/admin_controller.dart';
import 'widgets/admin_section_editor.dart';
import 'widgets/admin_sections_panel.dart';
import 'widgets/admin_top_bar.dart';

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
    text.dispose();
    slug.dispose();
    titleEn.dispose();
    titleAr.dispose();
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
        AdminTopBar(
          locale: locale,
          urlController: _url,
          onSaveUrl: () => controller.setContentUrl(_url.text),
          onReload: () => controller.reload(forceRefresh: true),
          onImport: () => _importDialog(context),
          onExport: _exportJson,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 980;
                final left = AdminSectionsPanel(
                  sections: content.sections,
                  selectedId: selectedId,
                  onSelect: controller.selectSection,
                  onAdd: () => _addSectionDialog(context),
                  onReorder: controller.reorderSections,
                );

                final right = selected == null
                    ? const SizedBox.shrink()
                    : AdminSectionEditor(
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

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
