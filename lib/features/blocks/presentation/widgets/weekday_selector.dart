import 'package:flutter/material.dart';

import '../../../../core/utils/week_utils.dart';

class WeekdaySelector extends StatelessWidget {
  const WeekdaySelector({
    super.key,
    required this.selectedWeekdays,
    required this.onChanged,
    this.singleSelection = false,
  });

  final Set<int> selectedWeekdays;
  final ValueChanged<Set<int>> onChanged;
  final bool singleSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var day = 1; day <= 7; day++)
          FilterChip(
            label: Text(weekdayLabels[day]!),
            selected: selectedWeekdays.contains(day),
            onSelected: (selected) {
              if (singleSelection) {
                onChanged(selected ? {day} : {});
                return;
              }

              final updated = Set<int>.from(selectedWeekdays);
              if (selected) {
                updated.add(day);
              } else {
                updated.remove(day);
              }
              onChanged(updated);
            },
            selectedColor:
                theme.colorScheme.primary.withValues(alpha: 0.15),
            checkmarkColor: theme.colorScheme.primary,
          ),
      ],
    );
  }
}
