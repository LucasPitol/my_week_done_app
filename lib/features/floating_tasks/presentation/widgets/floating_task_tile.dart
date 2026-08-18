import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/category_colors.dart';
import '../../../../domain/entities/floating_task.dart';
import '../../domain/floating_task_visibility.dart';

class FloatingTaskTile extends StatelessWidget {
  const FloatingTaskTile({
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
    final category = categoryColor(task.category, theme.colorScheme);
    final urgency = floatingTaskDeadlineUrgency(task, viewDate);
    final colors = _tileColors(
      theme: theme,
      completed: task.completed,
      urgency: urgency,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        key: ValueKey('floating-task-${task.id}'),
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
            onToggle();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  task.completed
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: colors.icon,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      decoration:
                          task.completed ? TextDecoration.lineThrough : null,
                      color: colors.title,
                    ),
                  ),
                ),
                if (task.deadline != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    formatFloatingTaskDeadline(task.deadline!),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.deadline,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
                if (task.category != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: category,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TileColors {
  const _TileColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.title,
    required this.deadline,
  });

  final Color background;
  final Color border;
  final Color icon;
  final Color title;
  final Color deadline;
}

_TileColors _tileColors({
  required ThemeData theme,
  required bool completed,
  required FloatingTaskDeadlineUrgency urgency,
}) {
  if (completed) {
    final accent = theme.colorScheme.primary;
    return _TileColors(
      background: theme.colorScheme.surfaceContainerHighest,
      border: theme.colorScheme.outlineVariant,
      icon: accent,
      title: theme.colorScheme.onSurfaceVariant,
      deadline: theme.colorScheme.onSurfaceVariant,
    );
  }

  switch (urgency) {
    case FloatingTaskDeadlineUrgency.overdue:
      final accent = theme.colorScheme.error;
      return _TileColors(
        background: accent.withValues(alpha: 0.15),
        border: accent.withValues(alpha: 0.55),
        icon: accent,
        title: theme.colorScheme.onSurface,
        deadline: accent,
      );
    case FloatingTaskDeadlineUrgency.dueToday:
      final accent = theme.colorScheme.tertiary;
      return _TileColors(
        background: accent.withValues(alpha: 0.15),
        border: accent.withValues(alpha: 0.55),
        icon: accent,
        title: theme.colorScheme.onSurface,
        deadline: accent,
      );
    case FloatingTaskDeadlineUrgency.none:
      return _TileColors(
        background: theme.colorScheme.surfaceContainerHighest,
        border: theme.colorScheme.outlineVariant,
        icon: theme.colorScheme.onSurfaceVariant,
        title: theme.colorScheme.onSurface,
        deadline: theme.colorScheme.onSurfaceVariant,
      );
  }
}
