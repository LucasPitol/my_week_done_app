import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/week_utils.dart';
import '../../../domain/entities/daily_completion.dart';
import '../../../domain/entities/routine_block.dart';
import '../../../providers/repository_providers.dart';

final currentWeekStartProvider = Provider<DateTime>((ref) {
  return startOfWeek(DateTime.now());
});

final routineBlocksProvider = StreamProvider<List<RoutineBlock>>((ref) {
  return ref.watch(routineRepositoryProvider).watchRoutineBlocks();
});

final weekCompletionsProvider = StreamProvider<List<DailyCompletion>>((ref) {
  final weekStart = ref.watch(currentWeekStartProvider);
  return ref
      .watch(routineRepositoryProvider)
      .watchCompletionsForWeek(weekStart);
});

String completionKey(String blockId, DateTime date) {
  return '$blockId-${date.year}-${date.month}-${date.day}';
}

Map<String, DailyCompletion> buildCompletionLookup(
  List<DailyCompletion> completions,
) {
  return {
    for (final completion in completions)
      completionKey(completion.routineBlockId, completion.date): completion,
  };
}

Future<void> toggleBlockCompletion(
  WidgetRef ref, {
  required String routineBlockId,
  required DateTime date,
  required bool completed,
}) {
  return ref.read(routineRepositoryProvider).toggleCompletion(
        routineBlockId: routineBlockId,
        date: date,
        completed: completed,
      );
}
