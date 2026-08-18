import 'package:flutter/material.dart';

import '../../../../core/utils/calendar_utils.dart';
import '../../../../core/utils/week_utils.dart';
import '../../../../domain/entities/floating_task.dart';
import '../../../floating_tasks/domain/floating_task_visibility.dart';
import '../../domain/day_adherence.dart';

class MonthDayCell extends StatelessWidget {
  const MonthDayCell({
    super.key,
    required this.date,
    required this.month,
    required this.today,
    required this.focusedDate,
    required this.adherence,
    required this.deadlineTasks,
    required this.onTap,
  });

  final DateTime date;
  final DateTime month;
  final DateTime today;
  final DateTime focusedDate;
  final DayAdherence adherence;
  final List<FloatingTask> deadlineTasks;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inMonth = isSameMonth(date, month);
    final isToday = isSameDay(date, today);
    final isFocused = isSameDay(date, focusedDate);
    final colors = _cellColors(
      theme: theme,
      adherence: adherence,
      inMonth: inMonth,
      isToday: isToday,
      isFocused: isFocused,
    );

    return Material(
      color: colors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.border,
              width: isFocused ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${date.day}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.dayNumber,
                  fontWeight: isToday || isFocused ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: _buildIndicator(theme, colors),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _taskDotColor(ThemeData theme, FloatingTask task) {
    return switch (floatingTaskDeadlineUrgency(task, date)) {
      FloatingTaskDeadlineUrgency.overdue => theme.colorScheme.error,
      FloatingTaskDeadlineUrgency.dueToday => theme.colorScheme.tertiary,
      FloatingTaskDeadlineUrgency.none => theme.colorScheme.onSurfaceVariant,
    };
  }

  Widget _buildIndicator(ThemeData theme, _CellColors colors) {
    switch (adherence.status) {
      case DayAdherenceStatus.complete:
        return Icon(Icons.check_circle_rounded, size: 18, color: colors.indicator);
      case DayAdherenceStatus.inProgress:
        return Text(
          '${adherence.completed}/${adherence.expected}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.indicator,
            fontWeight: FontWeight.w700,
          ),
        );
      case DayAdherenceStatus.partial:
        return Container(
          height: 5,
          decoration: BoxDecoration(
            color: colors.indicator.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: adherence.expected == 0
                  ? 0
                  : adherence.completed / adherence.expected,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.indicator,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        );
      case DayAdherenceStatus.noRoutine:
        if (deadlineTasks.isEmpty) return const SizedBox.shrink();
        return Icon(
          Icons.circle,
          size: 10,
          color: _taskDotColor(theme, deadlineTasks.first),
        );
    }
  }
}

class _CellColors {
  const _CellColors({
    required this.background,
    required this.border,
    required this.dayNumber,
    required this.indicator,
  });

  final Color background;
  final Color border;
  final Color dayNumber;
  final Color indicator;
}

_CellColors _cellColors({
  required ThemeData theme,
  required DayAdherence adherence,
  required bool inMonth,
  required bool isToday,
  required bool isFocused,
}) {
  final primary = theme.colorScheme.primary;
  final muted = theme.colorScheme.onSurfaceVariant.withValues(
    alpha: inMonth ? 1 : 0.4,
  );

  if (isFocused) {
    return _CellColors(
      background: primary.withValues(alpha: 0.12),
      border: primary,
      dayNumber: primary,
      indicator: primary,
    );
  }

  if (isToday) {
    return _CellColors(
      background: theme.colorScheme.surfaceContainerHighest,
      border: primary.withValues(alpha: 0.5),
      dayNumber: primary,
      indicator: primary,
    );
  }

  switch (adherence.status) {
    case DayAdherenceStatus.complete:
      return _CellColors(
        background: primary.withValues(alpha: 0.1),
        border: theme.colorScheme.outlineVariant,
        dayNumber: inMonth ? theme.colorScheme.onSurface : muted,
        indicator: primary,
      );
    case DayAdherenceStatus.inProgress:
    case DayAdherenceStatus.partial:
      return _CellColors(
        background: theme.colorScheme.surfaceContainerHighest,
        border: theme.colorScheme.outlineVariant,
        dayNumber: inMonth ? theme.colorScheme.onSurface : muted,
        indicator: primary,
      );
    case DayAdherenceStatus.noRoutine:
      return _CellColors(
        background: Colors.transparent,
        border: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        dayNumber: muted,
        indicator: muted,
      );
  }
}
