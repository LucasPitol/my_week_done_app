import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/glass/glass_layout_metrics.dart';

import '../../../core/utils/week_utils.dart';
import '../../../domain/entities/floating_task.dart';
import '../../../domain/entities/routine_block.dart';
import '../../floating_tasks/presentation/widgets/floating_task_list_tile.dart';
import '../../floating_tasks/providers/floating_task_providers.dart';
import '../../today/providers/today_providers.dart';
import '../domain/block_group_utils.dart';
import '../providers/blocks_providers.dart';
import 'block_form_screen.dart';
import 'widgets/block_list_tile.dart';
import 'widgets/block_scope_dialog.dart';
import 'widgets/empty_blocks_state.dart';

class BlocksScreen extends ConsumerWidget {
  const BlocksScreen({super.key});

  void _openCreateForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BlockFormScreen(),
      ),
    );
  }

  void _openEditForm(BuildContext context, RoutineBlock block) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlockFormScreen(block: block),
      ),
    );
  }

  void _openDuplicateForm(BuildContext context, RoutineBlock block) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlockFormScreen(duplicateFrom: block),
      ),
    );
  }

  void _openEditFloatingTask(BuildContext context, FloatingTask task) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlockFormScreen(floatingTask: task),
      ),
    );
  }

  Future<void> _confirmDeleteRoutine(
    BuildContext context,
    WidgetRef ref,
    RoutineBlock block,
  ) async {
    final allBlocks = ref.read(routineBlocksProvider).valueOrNull ?? [];
    final groupMembers = blocksInGroup(allBlocks, block);

    var deleteAll = false;
    if (groupMembers.length > 1) {
      final otherDays = formatOtherWeekdaysLabel(
        weekdaysInGroup(groupMembers),
        excludeWeekday: block.weekday,
      );

      final choice = await showBlockScopeDialog(
        context,
        title: 'Excluir rotina?',
        message: 'Esta rotina também existe em $otherDays.',
        allLabel: 'Excluir todas as ocorrências',
        singleLabel: 'Excluir apenas ${weekdayFullLabels[block.weekday]}',
      );

      if (choice == null) return;
      deleteAll = choice == BlockScopeChoice.allInGroup;
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Excluir rotina?'),
          content: Text('A rotina "${block.title}" será removida.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    await ref.read(blockActionsProvider).deleteBlock(
          block: block,
          groupMembers: groupMembers,
          deleteAll: deleteAll,
        );
  }

  Future<void> _confirmDeleteFloatingTask(
    BuildContext context,
    WidgetRef ref,
    FloatingTask task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: Text('A tarefa "${task.title}" será removida.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(floatingTaskActionsProvider).deleteTask(task.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(routineBlocksProvider);
    final floatingTasksAsync = ref.watch(floatingTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas rotinas'),
      ),
      body: blocksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
        skipLoadingOnReload: true,
        data: (blocks) {
          return floatingTasksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Erro ao carregar tarefas: $error')),
            skipLoadingOnReload: true,
            data: (floatingTasks) {
              if (blocks.isEmpty && floatingTasks.isEmpty) {
                return EmptyBlocksState(onCreate: () => _openCreateForm(context));
              }

              final grouped = blocksGroupedByWeekday(blocks);
              final pendingTasks = pendingFloatingTasks(floatingTasks);
              final allCompletedTasks = completedFloatingTasks(floatingTasks);
              final completedTasks = completedFloatingTasks(
                floatingTasks,
                limitToRecentHistory: true,
              );

              return ListView(
                padding: GlassLayoutMetrics.scrollPadding(context),
                children: [
                  if (blocks.isNotEmpty)
                    for (final weekday in grouped.keys.toList()..sort())
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              weekdayFullLabels[weekday]!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          for (final block in grouped[weekday]!)
                            BlockListTile(
                              block: block,
                              onTap: () => _openEditForm(context, block),
                              onDuplicate: () =>
                                  _openDuplicateForm(context, block),
                              onDelete: () =>
                                  _confirmDeleteRoutine(context, ref, block),
                            ),
                        ],
                      )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Nenhuma rotina fixa',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'Tarefas soltas',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (pendingTasks.isEmpty && allCompletedTasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Nenhuma tarefa solta',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    )
                  else ...[
                    for (final task in pendingTasks)
                      FloatingTaskListTile(
                        task: task,
                        onTap: () => _openEditFloatingTask(context, task),
                        onDelete: () =>
                            _confirmDeleteFloatingTask(context, ref, task),
                      ),
                    if (allCompletedTasks.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Concluídas',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ),
                      for (final task in completedTasks)
                        FloatingTaskListTile(
                          task: task,
                          onTap: () => _openEditFloatingTask(context, task),
                          onDelete: () =>
                              _confirmDeleteFloatingTask(context, ref, task),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Text(
                          'Mostrando apenas tarefas concluídas nos últimos 2 meses.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ),
                    ],
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
