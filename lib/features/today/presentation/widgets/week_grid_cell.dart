import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/entities/routine_block.dart';

class WeekGridCell extends StatelessWidget {
  const WeekGridCell({
    super.key,
    required this.date,
    required this.blocks,
    required this.isCompleted,
    required this.onToggle,
    required this.onOpenDetail,
    required this.isTodayColumn,
    required this.isFocusedColumn,
    required this.width,
    required this.height,
  });

  final DateTime date;
  final List<RoutineBlock> blocks;
  final bool Function(RoutineBlock block) isCompleted;
  final Future<void> Function(RoutineBlock block, bool completed) onToggle;
  final void Function(RoutineBlock block) onOpenDetail;
  final bool isTodayColumn;
  final bool isFocusedColumn;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayTint = isFocusedColumn
        ? theme.colorScheme.primary.withValues(alpha: 0.06)
        : isTodayColumn
            ? theme.colorScheme.primary.withValues(alpha: 0.03)
            : Colors.transparent;

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: todayTint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: blocks.isEmpty
          ? null
          : Column(
              children: [
                for (final block in blocks)
                  Expanded(
                    child: _BlockChip(
                      block: block,
                      completed: isCompleted(block),
                      onToggle: onToggle,
                      onOpenDetail: () => onOpenDetail(block),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _BlockChip extends StatelessWidget {
  const _BlockChip({
    required this.block,
    required this.completed,
    required this.onToggle,
    required this.onOpenDetail,
  });

  final RoutineBlock block;
  final bool completed;
  final Future<void> Function(RoutineBlock block, bool completed) onToggle;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = completed
        ? theme.colorScheme.primary.withValues(alpha: 0.85)
        : theme.colorScheme.surfaceContainerHighest;
    final foreground = completed
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        key: ValueKey('block-${block.id}'),
        color: background,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            HapticFeedback.lightImpact();
            onToggle(block, !completed);
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            onOpenDetail();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      completed
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 12,
                      color: foreground.withValues(alpha: 0.9),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        _formatTime(block.startTime),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foreground.withValues(alpha: 0.85),
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: Text(
                    block.title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foreground,
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

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
