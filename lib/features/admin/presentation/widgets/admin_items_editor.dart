import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../content/domain/portfolio_models.dart';
import '../../state/admin_controller.dart';

class AdminItemsEditor extends StatelessWidget {
  const AdminItemsEditor({
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
      builder: (context) => AdminItemEditorDialog(
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

class AdminItemEditorDialog extends StatefulWidget {
  const AdminItemEditorDialog({
    super.key,
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
  State<AdminItemEditorDialog> createState() => _AdminItemEditorDialogState();
}

class _AdminItemEditorDialogState extends State<AdminItemEditorDialog> {
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
                AdminFieldInput(
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

class AdminFieldInput extends StatefulWidget {
  const AdminFieldInput({
    super.key,
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
  State<AdminFieldInput> createState() => _AdminFieldInputState();
}

class _AdminFieldInputState extends State<AdminFieldInput> {
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
  void didUpdateWidget(covariant AdminFieldInput oldWidget) {
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
      return AdminStringListInput(
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

class AdminStringListInput extends StatefulWidget {
  const AdminStringListInput({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;

  @override
  State<AdminStringListInput> createState() => _AdminStringListInputState();
}

class _AdminStringListInputState extends State<AdminStringListInput> {
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
  void didUpdateWidget(covariant AdminStringListInput oldWidget) {
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
