import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/week_utils.dart';
import '../providers/today_providers.dart';
import 'widgets/week_grid.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weekStart = ref.watch(currentWeekStartProvider);
    final today = DateTime.now();
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekRange = DateFormat('d MMM', 'pt_BR').format(weekStart);
    final weekRangeEnd = DateFormat('d MMM', 'pt_BR').format(weekEnd);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoje'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                '$weekRange – $weekRangeEnd',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: WeekGrid(
          weekStart: startOfWeek(weekStart),
          today: today,
        ),
      ),
    );
  }
}
