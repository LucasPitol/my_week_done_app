import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/calendar_utils.dart';
import '../../../../core/utils/week_utils.dart';
import '../../../../domain/entities/daily_completion.dart';
import '../../../../domain/entities/floating_task.dart';
import '../../../../domain/entities/routine_block.dart';
import '../../../floating_tasks/domain/floating_task_visibility.dart';
import '../../../floating_tasks/providers/floating_task_providers.dart';
import '../../domain/day_adherence.dart';
import '../../domain/day_index.dart';
import '../../providers/calendar_scope_providers.dart';
import '../../providers/today_view_providers.dart';
import '../../providers/today_providers.dart';
import 'month_day_cell.dart';

class MonthGrid extends ConsumerWidget {
  const MonthGrid({
    super.key,
    required this.month,
    required this.today,
    required this.focusedDate,
  });

  final DateTime month;
  final DateTime today;
  final DateTime focusedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final blocksAsync = ref.watch(routineBlocksProvider);
    final completionsAsync = ref.watch(monthCompletionsProvider);
    final floatingTasksAsync = ref.watch(floatingTasksProvider);
    final gridDays = daysForMonthGrid(month);

    return blocksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
      skipLoadingOnReload: true,
      data: (blocks) => completionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
        skipLoadingOnReload: true,
        data: (completions) => floatingTasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Erro ao carregar tarefas: $error')),
          skipLoadingOnReload: true,
          data: (floatingTasks) {
            final hasFloatingTasksInMonth = hasFloatingTasksDueInRange(
              floatingTasks,
              gridDays.first,
              gridDays.last,
            );
            if (blocks.isEmpty && !hasFloatingTasksInMonth) {
              return _EmptyMonthState(theme: theme);
            }

            final completionLookup = buildCompletionLookup(completions);

            return LayoutBuilder(
              builder: (context, constraints) {
                const rowCount = 6;
                const colCount = 7;
                const hSpacing = 8.0;
                const vSpacing = 8.0;
                const headerHeight = 28.0;

                final cellWidth =
                    (constraints.maxWidth - hSpacing * (colCount - 1)) /
                        colCount;
                final availableHeight =
                    constraints.maxHeight - headerHeight - vSpacing;
                final cellHeight =
                    (availableHeight - vSpacing * (rowCount - 1)) / rowCount;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: headerHeight,
                      child: Row(
                        children: [
                          for (final weekday in [1, 2, 3, 4, 5, 6, 7])
                            SizedBox(
                              width: cellWidth,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: weekday == 7 ? 0 : hSpacing,
                                ),
                                child: Text(
                                  weekdayLabels[weekday]!,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          for (var row = 0; row < rowCount; row++) ...[
                            if (row > 0) const SizedBox(height: vSpacing),
                            Row(
                              children: [
                                for (var col = 0; col < colCount; col++) ...[
                                  if (col > 0) const SizedBox(width: hSpacing),
                                  SizedBox(
                                    width: cellWidth,
                                    height: cellHeight,
                                    child: _buildDayCell(
                                      ref: ref,
                                      gridDays: gridDays,
                                      index: row * colCount + col,
                                      blocks: blocks,
                                      floatingTasks: floatingTasks,
                                      completionLookup: completionLookup,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayCell({
    required WidgetRef ref,
    required List<DateTime> gridDays,
    required int index,
    required List<RoutineBlock> blocks,
    required List<FloatingTask> floatingTasks,
    required Map<String, DailyCompletion> completionLookup,
  }) {
    final day = gridDays[index];
    final adherence = computeDayAdherence(
      date: day,
      today: today,
      blocks: blocks,
      completions: completionLookup,
    );
    final deadlineTasks = floatingTasksDueOnDate(floatingTasks, day);

    return MonthDayCell(
      date: day,
      month: month,
      today: today,
      focusedDate: focusedDate,
      adherence: adherence,
      deadlineTasks: deadlineTasks,
      onTap: () {
        ref.read(selectedDayProvider.notifier).state = normalizeDay(day);
      },
    );
  }
}

class _EmptyMonthState extends StatelessWidget {
  const _EmptyMonthState({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma rotina neste mês',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Toque no botão + para criar sua primeira rotina.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
