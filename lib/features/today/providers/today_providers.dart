import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/week_utils.dart';
import '../../../domain/entities/daily_completion.dart';
import '../../../domain/entities/routine_block.dart';
import '../../../providers/repository_providers.dart';
import '../domain/day_index.dart';

export '../domain/completion_utils.dart';
import '../providers/today_view_providers.dart';

final currentWeekStartProvider = Provider<DateTime>((ref) {
  return startOfWeek(ref.watch(selectedDayProvider));
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

final dayCompletionsProvider =
    StreamProvider.family<List<DailyCompletion>, DateTime>((ref, date) {
  final normalized = normalizeDay(date);
  return ref
      .watch(routineRepositoryProvider)
      .watchCompletionsForDate(normalized);
});

final dayBlocksProvider = Provider.family<List<RoutineBlock>, int>((ref, weekday) {
  final blocks = ref.watch(routineBlocksProvider).valueOrNull ?? [];
  final filtered = blocks.where((block) => block.weekday == weekday).toList()
    ..sort((a, b) {
      final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
      final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
      return aMinutes.compareTo(bMinutes);
    });
  return filtered;
});

/// Atualiza a cada 30s para transições de destaque temporal na visão Dia.
final nowProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});

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
