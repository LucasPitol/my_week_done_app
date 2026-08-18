import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/entities/floating_task.dart';
import '../../../floating_tasks/domain/floating_task_visibility.dart';

class WeekFloatingTaskChip extends StatelessWidget {
  const WeekFloatingTaskChip({
    super.key,
    required this.task,
    required this.viewDate,
    required this.onToggle,
  });

  final FloatingTask task;
  final DateTime viewDate;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgency = floatingTaskDeadlineUrgency(task, viewDate);
    final colors = _chipColors(theme: theme, urgency: urgency);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        key: ValueKey('floating-task-${task.id}'),
        color: colors.background,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            HapticFeedback.lightImpact();
            onToggle();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              children: [
                Icon(
                  Icons.circle_outlined,
                  size: 12,
                  color: colors.foreground.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipColors {
  const _ChipColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}

_ChipColors _chipColors({
  required ThemeData theme,
  required FloatingTaskDeadlineUrgency urgency,
}) {
  switch (urgency) {
    case FloatingTaskDeadlineUrgency.overdue:
      final accent = theme.colorScheme.error;
      return _ChipColors(
        background: accent.withValues(alpha: 0.18),
        foreground: accent,
      );
    case FloatingTaskDeadlineUrgency.dueToday:
      final accent = theme.colorScheme.tertiary;
      return _ChipColors(
        background: accent.withValues(alpha: 0.18),
        foreground: accent,
      );
    case FloatingTaskDeadlineUrgency.none:
      return _ChipColors(
        background: theme.colorScheme.surfaceContainerHighest,
        foreground: theme.colorScheme.onSurface,
      );
  }
}
