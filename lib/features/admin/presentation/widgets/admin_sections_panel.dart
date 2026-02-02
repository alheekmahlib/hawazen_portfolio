import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_container.dart';
import '../../../content/domain/portfolio_models.dart';

class AdminSectionsPanel extends StatelessWidget {
  const AdminSectionsPanel({
    super.key,
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
