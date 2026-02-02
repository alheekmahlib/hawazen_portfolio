import 'package:flutter/material.dart';

import '../../../content/domain/portfolio_models.dart';
import '../../state/admin_controller.dart';

class MiniToggle extends StatelessWidget {
  const MiniToggle({
    super.key,
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

class AdminCardLayoutEditor extends StatelessWidget {
  const AdminCardLayoutEditor({
    super.key,
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

class AdminDetailLayoutEditor extends StatelessWidget {
  const AdminDetailLayoutEditor({
    super.key,
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
        AdminMultiSelectChips(
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
        AdminMultiSelectChips(
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

class AdminMultiSelectChips extends StatelessWidget {
  const AdminMultiSelectChips({
    super.key,
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
