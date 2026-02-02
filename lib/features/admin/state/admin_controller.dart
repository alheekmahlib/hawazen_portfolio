import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/utils/slugify.dart';
import '../../content/data/content_repository.dart';
import '../../content/domain/portfolio_models.dart';

@immutable
class AdminDraft {
  const AdminDraft({
    required this.contentUrl,
    required this.content,
    required this.selectedSectionId,
  });

  final String? contentUrl;
  final PortfolioContent content;
  final String? selectedSectionId;

  AdminDraft copyWith({
    String? contentUrl,
    PortfolioContent? content,
    String? selectedSectionId,
  }) {
    return AdminDraft(
      contentUrl: contentUrl ?? this.contentUrl,
      content: content ?? this.content,
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
    );
  }
}

class AdminController extends GetxController {
  AdminController({required ContentRepository repository}) : _repo = repository;

  final ContentRepository _repo;

  final Rxn<AdminDraft> draft = Rxn<AdminDraft>();
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    reload(forceRefresh: false);
  }

  Future<void> reload({bool forceRefresh = false}) async {
    loading.value = true;
    error.value = null;
    update();

    try {
      final url = await _repo.getContentUrl();
      final content = await _repo.load(forceRefresh: forceRefresh);
      final selected = content.sections.isEmpty
          ? null
          : content.sections.first.id;
      draft.value = AdminDraft(
        contentUrl: url,
        content: content,
        selectedSectionId: selected,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<void> setContentUrl(String? url) async {
    await _repo.setContentUrl(url);
    final current = draft.value;
    if (current == null) return;
    draft.value = current.copyWith(contentUrl: url);
    update();
  }

  void selectSection(String id) {
    final current = draft.value;
    if (current == null) return;
    draft.value = current.copyWith(selectedSectionId: id);
    update();
  }

  void upsertSection(PortfolioSection section) {
    final current = draft.value;
    if (current == null) return;
    final sections = [...current.content.sections];
    final index = sections.indexWhere((s) => s.id == section.id);
    if (index >= 0) {
      sections[index] = section;
    } else {
      sections.add(section);
    }
    draft.value = current.copyWith(
      content: current.content.copyWith(sections: sections),
    );
    update();
  }

  void deleteSection(String sectionId) {
    final current = draft.value;
    if (current == null) return;
    final sections = current.content.sections
        .where((s) => s.id != sectionId)
        .toList();
    final selected = sections.isEmpty ? null : sections.first.id;
    draft.value = current.copyWith(
      content: current.content.copyWith(sections: sections),
      selectedSectionId: selected,
    );
    update();
  }

  PortfolioSection addSection({
    required String slug,
    required String titleEn,
    required String titleAr,
  }) {
    final current = draft.value;
    if (current == null) throw StateError('Not ready');

    final slugs = current.content.sections.map((s) => s.slug).toSet();
    final safeSlug = ensureUniqueSlug(slugify(slug), slugs);

    final section = PortfolioSection(
      id: 'sec_${DateTime.now().millisecondsSinceEpoch}',
      slug: safeSlug,
      title: L10nText({'en': titleEn.trim(), 'ar': titleAr.trim()}),
      enabled: true,
      fieldDefinitions: const [
        FieldDefinition(
          key: 'name',
          label: L10nText({'en': 'Name', 'ar': 'الاسم'}),
          type: FieldType.string,
          required: true,
          localized: true,
        ),
        FieldDefinition(
          key: 'banner',
          label: L10nText({'en': 'Banner', 'ar': 'بنر'}),
          type: FieldType.image,
          required: true,
        ),
      ],
      cardLayout: const CardLayout(titleField: 'name', mediaField: 'banner'),
      detailLayout: const DetailLayout(
        titleField: 'name',
        mediaField: 'banner',
        galleryField: null,
        bodyFields: [],
        actionFields: [],
      ),
      items: const [],
    );

    upsertSection(section);
    selectSection(section.id);
    return section;
  }

  void reorderSections(int oldIndex, int newIndex) {
    final current = draft.value;
    if (current == null) return;
    final sections = [...current.content.sections];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = sections.removeAt(oldIndex);
    sections.insert(newIndex, item);
    draft.value = current.copyWith(
      content: current.content.copyWith(sections: sections),
    );
    update();
  }

  SectionItem addItem(PortfolioSection section, {required String localeCode}) {
    final titleKey = section.cardLayout.titleField;
    final existingIds = section.items.map((i) => i.id).toSet();

    final id = ensureUniqueSlug('item', existingIds);
    final def = section.fieldDefinitions
        .where((d) => d.key == titleKey)
        .firstOrNull;

    final initialTitleValue = (def != null && def.localized)
        ? <String, Object?>{'en': '', 'ar': ''}
        : '';

    final item = SectionItem(
      id: id,
      enabled: true,
      fields: {titleKey: initialTitleValue},
    );

    final updated = section.copyWith(items: [...section.items, item]);
    upsertSection(updated);
    return item;
  }

  void updateItem(PortfolioSection section, SectionItem item) {
    final current = draft.value;
    if (current == null) return;
    final latest = current.content.sections
        .where((s) => s.id == section.id)
        .firstOrNull;
    final base = latest ?? section;

    final items = [...base.items];
    final idx = items.indexWhere((i) => i.id == item.id);
    if (idx < 0) return;
    items[idx] = item;
    upsertSection(base.copyWith(items: items));
  }

  void deleteItem(PortfolioSection section, String itemId) {
    upsertSection(
      section.copyWith(
        items: section.items.where((i) => i.id != itemId).toList(),
      ),
    );
  }

  void regenerateItemIdFromTitle(PortfolioSection section, SectionItem item) {
    final titleKey = section.cardLayout.titleField;
    final def = section.fieldDefinitions
        .where((d) => d.key == titleKey)
        .firstOrNull;
    if (def == null) return;

    String title = '';
    final v = item.fields[titleKey];
    if (def.localized && v is Map) {
      title = (v['en'] ?? v['ar'] ?? '').toString();
    } else {
      title = v?.toString() ?? '';
    }

    final base = slugify(title);
    final existing = section.items
        .where((i) => i.id != item.id)
        .map((i) => i.id);
    final newId = ensureUniqueSlug(base, existing);

    final renamed = item.copyWith(id: newId);
    final items = section.items
        .map((i) => i.id == item.id ? renamed : i)
        .toList();
    upsertSection(section.copyWith(items: items));
  }

  String exportPrettyJson() {
    final current = draft.value;
    if (current == null) throw StateError('Not ready');
    final encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(current.content.toJson());
  }

  bool importJson(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, Object?>) return false;
      final content = PortfolioContent.fromJson(decoded);
      final selected = content.sections.isEmpty
          ? null
          : content.sections.first.id;
      final current = draft.value;
      draft.value = (current == null)
          ? AdminDraft(
              contentUrl: null,
              content: content,
              selectedSectionId: selected,
            )
          : current.copyWith(content: content, selectedSectionId: selected);
      update();
      return true;
    } catch (_) {
      return false;
    }
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
