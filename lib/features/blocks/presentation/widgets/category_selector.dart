import 'package:flutter/material.dart';

import '../../domain/block_form_utils.dart';
import '../../../../core/theme/category_colors.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Nenhuma'),
          selected: selectedCategory == null,
          onSelected: (_) => onChanged(null),
        ),
        for (final option in BlockCategories.options)
          ChoiceChip(
            label: Text(option.label),
            selected: selectedCategory == option.id,
            avatar: CircleAvatar(
              radius: 6,
              backgroundColor: categoryColor(option.id, theme.colorScheme),
            ),
            onSelected: (_) => onChanged(option.id),
          ),
      ],
    );
  }
}
