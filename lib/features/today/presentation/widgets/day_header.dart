import 'package:flutter/material.dart';

import '../../../../core/utils/week_utils.dart';
import '../../domain/day_index.dart';

class DayHeader extends StatelessWidget {
  const DayHeader({
    super.key,
    required this.date,
    required this.today,
  });

  final DateTime date;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = isSameDay(date, today);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              formatDayHeader(date),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Visibility(
            visible: isToday,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                'Hoje',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DayNeighborIndicator extends StatelessWidget {
  const DayNeighborIndicator({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previous = date.subtract(const Duration(days: 1));
    final next = date.add(const Duration(days: 1));

    TextStyle styleFor(DateTime day, {required bool isCurrent}) {
      return theme.textTheme.labelMedium!.copyWith(
        color: isCurrent
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(weekdayLabels[previous.weekday]!, style: styleFor(previous, isCurrent: false)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.circle,
              size: 6,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(weekdayLabels[date.weekday]!, style: styleFor(date, isCurrent: true)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.circle,
              size: 6,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ),
          Text(weekdayLabels[next.weekday]!, style: styleFor(next, isCurrent: false)),
        ],
      ),
    );
  }
}
