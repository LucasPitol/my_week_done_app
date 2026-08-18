import '../entities/daily_completion.dart';
import '../entities/floating_task.dart';
import '../entities/routine_block.dart';

abstract class RoutineRepository {
  Stream<List<RoutineBlock>> watchRoutineBlocks();

  Stream<List<DailyCompletion>> watchCompletionsForDate(DateTime date);

  Stream<List<DailyCompletion>> watchCompletionsForWeek(DateTime weekStart);

  Stream<List<DailyCompletion>> watchCompletionsForRange(
    DateTime start,
    DateTime end,
  );

  Future<void> saveRoutineBlock(RoutineBlock block);

  Future<void> deleteRoutineBlock(String id);

  Future<void> toggleCompletion({
    required String routineBlockId,
    required DateTime date,
    required bool completed,
  });

  Future<void> updateCompletionNote({
    required String routineBlockId,
    required DateTime date,
    required String? note,
  });

  Future<double> adherenceForWeek(DateTime weekStart);

  Stream<List<FloatingTask>> watchFloatingTasks();

  Future<void> saveFloatingTask(FloatingTask task);

  Future<void> deleteFloatingTask(String id);

  Future<void> toggleFloatingTaskCompletion({
    required String id,
    required bool completed,
  });
}
