import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/nav_layout_metrics.dart';
import '../../domain/routine_proximity.dart';
import '../../providers/today_providers.dart';
import '../../../floating_tasks/presentation/widgets/floating_task_tile.dart';
import '../../../floating_tasks/providers/floating_task_providers.dart';
import 'day_block_tile.dart';
import 'block_detail_sheet.dart';

class DayPage extends ConsumerWidget {
  const DayPage({
    super.key,
    required this.date,
    required this.today,
  });

  final DateTime date;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final blocks = ref.watch(dayBlocksProvider(date.weekday));
    final completionsAsync = ref.watch(dayCompletionsProvider(date));
    final floatingTasks = ref.watch(visibleFloatingTasksProvider(date));
    final now = ref.watch(nowProvider).valueOrNull ?? DateTime.now();

    return completionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
      skipLoadingOnReload: true,
      data: (completions) {
        final completionLookup = buildCompletionLookup(completions);

        return ListView(
          padding: NavLayoutMetrics.scrollPadding(context),
          children: [
            if (blocks.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      size: 40,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhuma rotina neste dia',
                      style: theme.textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toque no botão + para criar uma rotina.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...blocks.map((block) {
                final completion =
                    completionLookup[completionKey(block.id, date)];
                final completed = completion?.completed ?? false;
                final note = completion?.note;

                return DayBlockTile(
                  block: block,
                  completed: completed,
                  hasNote: note != null && note.trim().isNotEmpty,
                  proximityHighlight: routineProximityHighlight(
                    date: date,
                    now: now,
                    blockStartTime: block.startTime,
                    completed: completed,
                  ),
                  onToggle: () => toggleBlockCompletion(
                    ref,
                    routineBlockId: block.id,
                    date: date,
                    completed: !completed,
                  ),
                  onOpenDetail: () => showBlockDetailSheet(
                    context: context,
                    ref: ref,
                    block: block,
                    date: date,
                    completed: completed,
                    note: note,
                  ),
                );
              }),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Tarefas soltas',
                style: theme.textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 8),
            if (floatingTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Nenhuma tarefa solta',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...floatingTasks.map(
                (task) => FloatingTaskTile(
                  task: task,
                  viewDate: date,
                  onToggle: () => toggleFloatingTaskCompletion(
                    ref,
                    id: task.id,
                    completed: !task.completed,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
