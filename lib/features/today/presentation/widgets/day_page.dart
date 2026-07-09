import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/today_providers.dart';
import 'day_block_tile.dart';

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

    return completionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
      skipLoadingOnReload: true,
      data: (completions) {
        final completionLookup = buildCompletionLookup(completions);

        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
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
                      'Crie rotinas na aba Rotinas.',
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
                final completed =
                    completionLookup[completionKey(block.id, date)]?.completed ??
                        false;

                return DayBlockTile(
                  block: block,
                  completed: completed,
                  onToggle: () => toggleBlockCompletion(
                    ref,
                    routineBlockId: block.id,
                    date: date,
                    completed: !completed,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Nenhuma tarefa solta',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
