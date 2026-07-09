import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../domain/today_view_mode.dart';
import '../../providers/today_view_providers.dart';

class ViewModeToggle extends ConsumerWidget {
  const ViewModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(todayViewModeProvider);
    final theme = Theme.of(context);

    return SegmentedButton<TodayViewMode>(
      segments: const [
        ButtonSegment(
          value: TodayViewMode.day,
          label: Text('Dia'),
          icon: Icon(TablerIcons.layout_list, size: 18),
        ),
        ButtonSegment(
          value: TodayViewMode.calendar,
          label: Text('Calendário'),
          icon: Icon(TablerIcons.calendar_week, size: 18),
        ),
      ],
      selected: {viewMode},
      onSelectionChanged: (selection) {
        ref.read(todayViewModeProvider.notifier).setMode(selection.first);
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: WidgetStatePropertyAll(theme.textTheme.labelMedium),
      ),
    );
  }
}
