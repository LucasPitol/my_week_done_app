import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../core/utils/week_utils.dart';
import '../../../domain/entities/routine_block.dart';
import '../../today/providers/today_providers.dart';
import '../providers/blocks_providers.dart';
import 'block_form_screen.dart';
import 'widgets/block_list_tile.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir bloco?'),
        content: Text('O bloco "${block.title}" será removido da sua rotina.'),
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

    if (confirmed == true) {
      await ref.read(blockActionsProvider).deleteBlock(block.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(routineBlocksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocos'),
        actions: [
          IconButton(
            onPressed: () => _openCreateForm(context),
            icon: const Icon(TablerIcons.plus),
            tooltip: 'Criar bloco',
          ),
        ],
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
      floatingActionButton: blocksAsync.maybeWhen(
        data: (blocks) => blocks.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _openCreateForm(context),
                tooltip: 'Novo bloco',
                child: const Icon(TablerIcons.plus),
              )
            : null,
        orElse: () => null,
      ),
    );
  }
}
