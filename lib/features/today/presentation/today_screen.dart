import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/week_utils.dart';
import '../domain/day_index.dart';
import '../domain/today_view_mode.dart';
import '../providers/today_view_providers.dart';
import 'widgets/day_header.dart';
import 'widgets/day_view_pager.dart';
import 'widgets/view_mode_toggle.dart';
import 'widgets/week_grid.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewMode = ref.watch(todayViewModeProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final today = normalizeDay(DateTime.now());
    final weekStart = startOfWeek(selectedDay);
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange = DateFormat('d MMM', 'pt_BR').format(weekStart);
    final weekRangeEnd = DateFormat('d MMM', 'pt_BR').format(weekEnd);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoje'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: ViewModeToggle(),
          ),
        ],
        bottom: viewMode == TodayViewMode.calendar
            ? PreferredSize(
                preferredSize: const Size.fromHeight(28),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      '$weekRange – $weekRangeEnd',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewMode == TodayViewMode.day) ...[
            DayHeader(date: selectedDay, today: today),
            DayNeighborIndicator(date: selectedDay),
            Expanded(
              child: DayViewPager(today: today),
            ),
          ] else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: WeekGrid(
                  weekStart: weekStart,
                  today: today,
                  focusedDate: selectedDay,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
