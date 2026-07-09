import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/week_utils.dart';

class WeekDayHeader extends StatelessWidget {
  const WeekDayHeader({
    super.key,
    required this.weekDays,
    required this.today,
    required this.focusedDate,
    required this.dayColumnWidth,
    required this.timeColumnWidth,
    this.showTimeColumn = true,
  });

  final List<DateTime> weekDays;
  final DateTime today;
  final DateTime focusedDate;
  final double dayColumnWidth;
  final double timeColumnWidth;
  final bool showTimeColumn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayFormatter = DateFormat.E('pt_BR');
    final dateFormatter = DateFormat.d('pt_BR');

    return Row(
      children: [
        if (showTimeColumn)
          SizedBox(
            width: timeColumnWidth,
            child: Text(
              'Hora',
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ...weekDays.map((day) {
          final isToday = isSameDay(day, today);
          final isFocused = isSameDay(day, focusedDate);

          return Container(
            width: dayColumnWidth,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isFocused
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : isToday
                      ? theme.colorScheme.secondaryContainer
                          .withValues(alpha: 0.35)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isFocused
                  ? Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    )
                  : isToday
                      ? Border.all(
                          color: theme.colorScheme.outlineVariant,
                        )
                      : null,
            ),
            child: Column(
              children: [
                Text(
                  dayFormatter.format(day).replaceAll('.', ''),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight:
                        isFocused || isToday ? FontWeight.w700 : FontWeight.w500,
                    color: isFocused
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  dateFormatter.format(day),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isFocused
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
