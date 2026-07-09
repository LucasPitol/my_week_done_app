import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/week_utils.dart';
import '../../../../domain/entities/daily_completion.dart';
import '../../../../domain/entities/routine_block.dart';
import '../../providers/today_providers.dart';
import 'week_day_header.dart';
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

  static double daysWidth(int dayCount) =>
      (dayColumnWidth + 4) * dayCount;

  static double gridWidth(int dayCount) =>
      timeColumnWidth + daysWidth(dayCount);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final blocksAsync = ref.watch(routineBlocksProvider);
    final completionsAsync = ref.watch(weekCompletionsProvider);

    return blocksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
      skipLoadingOnReload: true,
      data: (blocks) => completionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar: $error')),
        skipLoadingOnReload: true,
        data: (completions) => _WeekGridBody(
          theme: theme,
          blocks: blocks,
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
        ),
      ),
    );
  }
}

class _WeekGridBody extends StatefulWidget {
  const _WeekGridBody({
    required this.theme,
    required this.blocks,
    required this.completions,
    required this.weekStart,
    required this.today,
    required this.focusedDate,
    required this.onToggle,
  });

  final ThemeData theme;
  final List<RoutineBlock> blocks;
  final List<DailyCompletion> completions;
  final DateTime weekStart;
  final DateTime today;
  final DateTime focusedDate;
  final Future<void> Function(
    RoutineBlock block,
    DateTime date,
    bool completed,
  ) onToggle;

  @override
  State<_WeekGridBody> createState() => _WeekGridBodyState();
}

class _WeekGridBodyState extends State<_WeekGridBody> {
  late final ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = daysOfWeek(widget.weekStart);
    final hours = hourSlotsForBlocks(widget.blocks);
    final completionLookup = buildCompletionLookup(widget.completions);
    final daysWidth = WeekGrid.daysWidth(weekDays.length);
    final gridWidth = WeekGrid.gridWidth(weekDays.length);

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
              child: ClipRect(
                child: AnimatedBuilder(
                  animation: _horizontalScrollController,
                  builder: (context, child) {
                    final offset = _horizontalScrollController.hasClients
                        ? _horizontalScrollController.offset
                        : 0.0;

                    return Transform.translate(
                      offset: Offset(-offset, 0),
                      child: child,
                    );
                  },
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
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: widget.blocks.isEmpty
              ? _EmptyWeekState(theme: widget.theme)
              : SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalScrollController,
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
          ),
      ],
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
              'Crie rotinas na aba Rotinas.',
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
