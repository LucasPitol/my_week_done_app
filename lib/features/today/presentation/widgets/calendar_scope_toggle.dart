import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../domain/calendar_scope.dart';
import '../../providers/calendar_scope_providers.dart';

class CalendarScopeToggle extends ConsumerWidget {
  const CalendarScopeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(calendarScopeProvider);
    final theme = Theme.of(context);

    return SegmentedButton<CalendarScope>(
      segments: const [
        ButtonSegment(
          value: CalendarScope.week,
          label: Text('Semana'),
          icon: Icon(TablerIcons.calendar_week, size: 18),
        ),
        ButtonSegment(
          value: CalendarScope.month,
          label: Text('Mês'),
          icon: Icon(TablerIcons.calendar_month, size: 18),
        ),
      ],
      selected: {scope},
      onSelectionChanged: (selection) {
        ref.read(calendarScopeProvider.notifier).setScope(selection.first);
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: WidgetStatePropertyAll(theme.textTheme.labelMedium),
      ),
    );
  }
}
