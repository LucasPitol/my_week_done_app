import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/nav_layout_metrics.dart';
import '../../../../core/utils/week_utils.dart';
import '../../../../domain/entities/daily_completion.dart';
import '../../../../domain/entities/floating_task.dart';
import '../../../../domain/entities/routine_block.dart';
import '../../../floating_tasks/domain/floating_task_visibility.dart';
import '../../../floating_tasks/providers/floating_task_providers.dart';
import '../../providers/today_providers.dart';
import 'block_detail_sheet.dart';
import 'week_day_header.dart';
import 'week_floating_task_chip.dart';
import 'week_grid_cell.dart';

class WeekGrid extends ConsumerWidget {
  const WeekGrid({
    super.key,
    required this.weekStart,
    required this.today,
    required this.focusedDate,
  });

  final DateTime weekStart;
  final DateTime today;
  final DateTime focusedDate;

  static const timeColumnWidth = 52.0;
  static const dayColumnWidth = 72.0;
  static const rowHeight = 68.0;
  static const floatingTasksRowHeight = 56.0;

  static double daysWidth(int dayCount) =>
      (dayColumnWidth + 4) * dayCount;

  static double gridWidth(int dayCount) =>
      timeColumnWidth + daysWidth(dayCount);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final blocksAsync = ref.watch(routineBlocksProvider);
    final completionsAsync = ref.watch(weekCompletionsProvider);
    final floatingTasksAsync = ref.watch(floatingTasksProvider);

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
          data: (floatingTasks) => _WeekGridBody(
            theme: theme,
            blocks: blocks,
            floatingTasks: floatingTasks,
            completions: completions,
            weekStart: weekStart,
            today: today,
            focusedDate: focusedDate,
            onToggle: (block, date, completed) => toggleBlockCompletion(
              ref,
              routineBlockId: block.id,
              date: date,
              completed: completed,
            ),
            onToggleFloatingTask: (task) => toggleFloatingTaskCompletion(
              ref,
              id: task.id,
              completed: !task.completed,
            ),
            onOpenDetail: (block, date) {
              final lookup = buildCompletionLookup(completions);
              final completion = lookup[completionKey(block.id, date)];
              showBlockDetailSheet(
                context: context,
                ref: ref,
                block: block,
                date: date,
                completed: completion?.completed ?? false,
                note: completion?.note,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WeekGridBody extends StatefulWidget {
  const _WeekGridBody({
    required this.theme,
    required this.blocks,
    required this.floatingTasks,
    required this.completions,
    required this.weekStart,
    required this.today,
    required this.focusedDate,
    required this.onToggle,
    required this.onToggleFloatingTask,
    required this.onOpenDetail,
  });

  final ThemeData theme;
  final List<RoutineBlock> blocks;
  final List<FloatingTask> floatingTasks;
  final List<DailyCompletion> completions;
  final DateTime weekStart;
  final DateTime today;
  final DateTime focusedDate;
  final Future<void> Function(
    RoutineBlock block,
    DateTime date,
    bool completed,
  ) onToggle;
  final Future<void> Function(FloatingTask task) onToggleFloatingTask;
  final void Function(RoutineBlock block, DateTime date) onOpenDetail;

  @override
  State<_WeekGridBody> createState() => _WeekGridBodyState();
}

class _WeekGridBodyState extends State<_WeekGridBody> {
  late final ScrollController _horizontalScrollController;
  late final ScrollController _headerScrollController;
  bool _syncingScroll = false;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _headerScrollController = ScrollController();
    _horizontalScrollController.addListener(_syncHeaderScroll);
    _headerScrollController.addListener(_syncGridScroll);
  }

  void _syncHeaderScroll() {
    if (_syncingScroll || !_headerScrollController.hasClients) return;
    _syncingScroll = true;
    _headerScrollController.jumpTo(_horizontalScrollController.offset);
    _syncingScroll = false;
  }

  void _syncGridScroll() {
    if (_syncingScroll || !_horizontalScrollController.hasClients) return;
    _syncingScroll = true;
    _horizontalScrollController.jumpTo(_headerScrollController.offset);
    _syncingScroll = false;
  }

  @override
  void dispose() {
    _horizontalScrollController.removeListener(_syncHeaderScroll);
    _headerScrollController.removeListener(_syncGridScroll);
    _horizontalScrollController.dispose();
    _headerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = daysOfWeek(widget.weekStart);
    final hours = hourSlotsForBlocks(widget.blocks);
    final completionLookup = buildCompletionLookup(widget.completions);
    final daysWidth = WeekGrid.daysWidth(weekDays.length);
    final gridWidth = WeekGrid.gridWidth(weekDays.length);
    final weekEnd = weekDays.last;
    final hasFloatingTasksInWeek = hasFloatingTasksDueInRange(
      widget.floatingTasks,
      widget.weekStart,
      weekEnd,
    );
    final hasGridContent = widget.blocks.isNotEmpty || hasFloatingTasksInWeek;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: WeekGrid.timeColumnWidth,
              child: Text(
                'Hora',
                style: widget.theme.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _headerScrollController,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: daysWidth,
                  child: WeekDayHeader(
                    weekDays: weekDays,
                    today: widget.today,
                    focusedDate: widget.focusedDate,
                    dayColumnWidth: WeekGrid.dayColumnWidth,
                    timeColumnWidth: WeekGrid.timeColumnWidth,
                    showTimeColumn: false,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: !hasGridContent
              ? _EmptyWeekState(theme: widget.theme)
              : SingleChildScrollView(
                  padding: NavLayoutMetrics.scrollPadding(context),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalScrollController,
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      width: gridWidth,
                      child: Column(
                        children: [
                          for (final hour in hours)
                            _HourRow(
                              hour: hour,
                              weekDays: weekDays,
                              blocks: widget.blocks,
                              today: widget.today,
                              focusedDate: widget.focusedDate,
                              completionLookup: completionLookup,
                              onToggle: widget.onToggle,
                              onOpenDetail: widget.onOpenDetail,
                            ),
                          if (hasFloatingTasksInWeek)
                            _FloatingTasksRow(
                              weekDays: weekDays,
                              floatingTasks: widget.floatingTasks,
                              today: widget.today,
                              focusedDate: widget.focusedDate,
                              onToggle: widget.onToggleFloatingTask,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({
    required this.hour,
    required this.weekDays,
    required this.blocks,
    required this.today,
    required this.focusedDate,
    required this.completionLookup,
    required this.onToggle,
    required this.onOpenDetail,
  });

  final int hour;
  final List<DateTime> weekDays;
  final List<RoutineBlock> blocks;
  final DateTime today;
  final DateTime focusedDate;
  final Map<String, DailyCompletion> completionLookup;
  final Future<void> Function(
    RoutineBlock block,
    DateTime date,
    bool completed,
  ) onToggle;
  final void Function(RoutineBlock block, DateTime date) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: WeekGrid.timeColumnWidth,
          height: WeekGrid.rowHeight,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                formatHourLabel(hour),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        for (final day in weekDays)
          WeekGridCell(
            date: day,
            width: WeekGrid.dayColumnWidth,
            height: WeekGrid.rowHeight,
            isTodayColumn: isSameDay(day, today),
            isFocusedColumn: isSameDay(day, focusedDate),
            blocks: blocks
                .where(
                  (block) =>
                      block.weekday == day.weekday &&
                      block.startTime.hour == hour,
                )
                .toList(),
            isCompleted: (block) {
              final completion = completionLookup[completionKey(block.id, day)];
              return completion?.completed ?? false;
            },
            onToggle: (block, completed) => onToggle(block, day, completed),
            onOpenDetail: (block) => onOpenDetail(block, day),
          ),
      ],
    );
  }
}

class _FloatingTasksRow extends StatelessWidget {
  const _FloatingTasksRow({
    required this.weekDays,
    required this.floatingTasks,
    required this.today,
    required this.focusedDate,
    required this.onToggle,
  });

  final List<DateTime> weekDays;
  final List<FloatingTask> floatingTasks;
  final DateTime today;
  final DateTime focusedDate;
  final Future<void> Function(FloatingTask task) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: WeekGrid.timeColumnWidth,
          height: WeekGrid.floatingTasksRowHeight,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Prazo',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        for (final day in weekDays)
          _FloatingTasksCell(
            width: WeekGrid.dayColumnWidth,
            height: WeekGrid.floatingTasksRowHeight,
            isTodayColumn: isSameDay(day, today),
            isFocusedColumn: isSameDay(day, focusedDate),
            tasks: floatingTasksDueOnDate(floatingTasks, day),
            viewDate: day,
            onToggle: onToggle,
          ),
      ],
    );
  }
}

class _FloatingTasksCell extends StatelessWidget {
  const _FloatingTasksCell({
    required this.width,
    required this.height,
    required this.isTodayColumn,
    required this.isFocusedColumn,
    required this.tasks,
    required this.viewDate,
    required this.onToggle,
  });

  final double width;
  final double height;
  final bool isTodayColumn;
  final bool isFocusedColumn;
  final List<FloatingTask> tasks;
  final DateTime viewDate;
  final Future<void> Function(FloatingTask task) onToggle;

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
      child: tasks.isEmpty
          ? null
          : Column(
              children: [
                for (final task in tasks)
                  Expanded(
                    child: WeekFloatingTaskChip(
                      task: task,
                      viewDate: viewDate,
                      onToggle: () => onToggle(task),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _EmptyWeekState extends StatelessWidget {
  const _EmptyWeekState({required this.theme});

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
              Icons.calendar_view_week_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma rotina nesta semana',
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
