import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/category_colors.dart';
import '../../../../domain/entities/routine_block.dart';
import '../../../blocks/domain/block_form_utils.dart';

class DayBlockTile extends StatelessWidget {
  const DayBlockTile({
    super.key,
    required this.block,
    required this.completed,
    required this.onToggle,
  });

  final RoutineBlock block;
  final bool completed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = categoryColor(block.category, theme.colorScheme);
    final background = completed
        ? color.withValues(alpha: 0.15)
        : theme.colorScheme.surfaceContainerHighest;
    final borderColor = completed
        ? color.withValues(alpha: 0.6)
        : theme.colorScheme.outlineVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        key: ValueKey('block-${block.id}'),
        color: background,
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
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: completed ? color : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  formatBlockTime(block.startTime),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    block.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      decoration: completed ? TextDecoration.lineThrough : null,
                      color: completed
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (block.category != null)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
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
