import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/week_utils.dart';
import '../../../domain/entities/routine_block.dart';
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

  Future<void> _confirmDelete(
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(routineBlocksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas rotinas'),
      ),
      body: blocksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
        skipLoadingOnReload: true,
        data: (blocks) {
          if (blocks.isEmpty) {
            return EmptyBlocksState(onCreate: () => _openCreateForm(context));
          }

          final grouped = blocksGroupedByWeekday(blocks);

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
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
                        onDuplicate: () => _openDuplicateForm(context, block),
                        onDelete: () => _confirmDelete(context, ref, block),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
