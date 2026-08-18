import '../../../core/utils/week_utils.dart';
import '../../../domain/entities/daily_completion.dart';
import '../../../domain/entities/routine_block.dart';
import 'completion_utils.dart';

enum DayAdherenceStatus {
  noRoutine,
  inProgress,
  partial,
  complete,
}

class DayAdherence {
  const DayAdherence({
    required this.status,
    required this.expected,
    required this.completed,
  });

  final DayAdherenceStatus status;
  final int expected;
  final int completed;
}

DayAdherence computeDayAdherence({
  required DateTime date,
  required DateTime today,
  required List<RoutineBlock> blocks,
  required Map<String, DailyCompletion> completions,
}) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  final normalizedToday = DateTime(today.year, today.month, today.day);
  final blocksForDay =
      blocks.where((block) => block.weekday == normalizedDate.weekday);
  final expected = blocksForDay.length;

  if (expected == 0) {
    return const DayAdherence(
      status: DayAdherenceStatus.noRoutine,
      expected: 0,
      completed: 0,
    );
  }

  var completedCount = 0;
  for (final block in blocksForDay) {
    if (completions[completionKey(block.id, normalizedDate)]?.completed ??
        false) {
      completedCount++;
    }
  }

  if (normalizedDate.isAfter(normalizedToday)) {
    return DayAdherence(
      status: DayAdherenceStatus.noRoutine,
      expected: expected,
      completed: completedCount,
    );
  }

  if (isSameDay(normalizedDate, normalizedToday)) {
    if (completedCount == expected) {
      return DayAdherence(
        status: DayAdherenceStatus.complete,
        expected: expected,
        completed: completedCount,
      );
    }

    return DayAdherence(
      status: DayAdherenceStatus.inProgress,
      expected: expected,
      completed: completedCount,
    );
  }

  if (completedCount == expected) {
    return DayAdherence(
      status: DayAdherenceStatus.complete,
      expected: expected,
      completed: completedCount,
    );
  }

  return DayAdherence(
    status: DayAdherenceStatus.partial,
    expected: expected,
    completed: completedCount,
  );
}
