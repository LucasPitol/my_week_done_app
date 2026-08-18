import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/category_colors.dart';
import '../../../../domain/entities/routine_block.dart';
import '../../../blocks/domain/block_form_utils.dart';
import '../../domain/routine_proximity.dart';

class DayBlockTile extends StatelessWidget {
  const DayBlockTile({
    super.key,
    required this.block,
    required this.completed,
    required this.onToggle,
    required this.onOpenDetail,
    this.proximityHighlight = RoutineProximityHighlight.none,
    this.hasNote = false,
  });

  final RoutineBlock block;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onOpenDetail;
  final RoutineProximityHighlight proximityHighlight;
  final bool hasNote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = categoryColor(block.category, theme.colorScheme);
    final colors = _tileColors(
      theme: theme,
      completed: completed,
      proximityHighlight: proximityHighlight,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        key: ValueKey('block-${block.id}'),
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onOpenDetail,
          onLongPress: onOpenDetail,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  tooltip: completed ? 'Desmarcar' : 'Marcar como feito',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onToggle();
                  },
                  icon: Icon(
                    completed
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: colors.icon,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  formatBlockTime(block.startTime),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.time,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    block.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      decoration: completed ? TextDecoration.lineThrough : null,
                      color: colors.title,
                    ),
                  ),
                ),
                if (hasNote)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.sticky_note_2_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (block.category != null)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: category,
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

class _TileColors {
  const _TileColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.time,
    required this.title,
  });

  final Color background;
  final Color border;
  final Color icon;
  final Color time;
  final Color title;
}

_TileColors _tileColors({
  required ThemeData theme,
  required bool completed,
  required RoutineProximityHighlight proximityHighlight,
}) {
  if (completed) {
    final accent = theme.colorScheme.primary;
    return _TileColors(
      background: theme.colorScheme.surfaceContainerHighest,
      border: theme.colorScheme.outlineVariant,
      icon: accent,
      time: theme.colorScheme.onSurfaceVariant,
      title: theme.colorScheme.onSurfaceVariant,
    );
  }

  switch (proximityHighlight) {
    case RoutineProximityHighlight.approaching:
      final accent = theme.colorScheme.tertiary;
      return _TileColors(
        background: accent.withValues(alpha: 0.15),
        border: accent.withValues(alpha: 0.55),
        icon: accent,
        time: accent.withValues(alpha: 0.9),
        title: theme.colorScheme.onSurface,
      );
    case RoutineProximityHighlight.imminent:
      final accent = theme.colorScheme.primary;
      return _TileColors(
        background: accent.withValues(alpha: 0.15),
        border: accent.withValues(alpha: 0.55),
        icon: accent,
        time: accent.withValues(alpha: 0.9),
        title: theme.colorScheme.onSurface,
      );
    case RoutineProximityHighlight.none:
      return _TileColors(
        background: theme.colorScheme.surfaceContainerHighest,
        border: theme.colorScheme.outlineVariant,
        icon: theme.colorScheme.onSurfaceVariant,
        time: theme.colorScheme.onSurfaceVariant,
        title: theme.colorScheme.onSurface,
      );
  }
}
