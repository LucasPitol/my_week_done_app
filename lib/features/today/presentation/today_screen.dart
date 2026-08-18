import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/week_utils.dart';
import '../domain/calendar_scope.dart';
import '../domain/day_index.dart';
import '../domain/today_view_mode.dart';
import '../providers/calendar_scope_providers.dart';
import '../providers/today_view_providers.dart';
import 'widgets/calendar_scope_toggle.dart';
import 'widgets/day_header.dart';
import 'widgets/day_view_pager.dart';
import 'widgets/month_grid.dart';
import 'widgets/view_mode_toggle.dart';
import 'widgets/week_grid.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewMode = ref.watch(todayViewModeProvider);
    final calendarScope = ref.watch(calendarScopeProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final today = normalizeDay(DateTime.now());
    final weekStart = startOfWeek(selectedDay);
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange = DateFormat('d MMM', 'pt_BR').format(weekStart);
    final weekRangeEnd = DateFormat('d MMM', 'pt_BR').format(weekEnd);
    final monthLabel = _formatMonthLabel(startOfMonth(selectedDay));

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
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: [
                      if (calendarScope == CalendarScope.month) ...[
                        IconButton(
                          tooltip: 'Mês anterior',
                          onPressed: () {
                            ref.read(selectedDayProvider.notifier).state =
                                shiftMonth(selectedDay, -1);
                          },
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Expanded(
                          child: Text(
                            monthLabel,
                            style: theme.textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Próximo mês',
                          onPressed: () {
                            ref.read(selectedDayProvider.notifier).state =
                                shiftMonth(selectedDay, 1);
                          },
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ] else
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$weekRange – $weekRangeEnd',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      const CalendarScopeToggle(),
                    ],
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
                child: calendarScope == CalendarScope.month
                    ? MonthGrid(
                        month: startOfMonth(selectedDay),
                        today: today,
                        focusedDate: selectedDay,
                      )
                    : WeekGrid(
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

String _formatMonthLabel(DateTime month) {
  final raw = DateFormat('MMMM yyyy', 'pt_BR').format(month);
  if (raw.isEmpty) return raw;
  return raw[0].toUpperCase() + raw.substring(1);
}
