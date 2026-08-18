import 'package:flutter_test/flutter_test.dart';

import 'package:my_week_done_app/domain/entities/daily_completion.dart';
import 'package:my_week_done_app/domain/entities/routine_block.dart';
import 'package:my_week_done_app/features/today/domain/completion_utils.dart';
import 'package:my_week_done_app/features/today/domain/day_adherence.dart';

void main() {
  final today = DateTime(2026, 8, 3);

  RoutineBlock block({
    required String id,
    required int weekday,
  }) {
    return RoutineBlock(
      id: id,
      weekday: weekday,
      startTime: DateTime(2000, 1, 1, 7),
      title: 'Treino',
    );
  }

  DailyCompletion completion({
    required String blockId,
    required DateTime date,
    bool completed = true,
  }) {
    return DailyCompletion(
      id: '$blockId-${date.toIso8601String()}',
      routineBlockId: blockId,
      date: date,
      completed: completed,
    );
  }

  group('computeDayAdherence', () {
    test('dia sem rotina retorna estado neutro', () {
      final adherence = computeDayAdherence(
        date: DateTime(2026, 8, 4),
        today: today,
        blocks: [block(id: 'a', weekday: DateTime.monday)],
        completions: const {},
      );

      expect(adherence.status, DayAdherenceStatus.noRoutine);
    });

    test('dia completo retorna complete', () {
      final date = DateTime(2026, 8, 3);
      final item = completion(blockId: 'a', date: date);
      final adherence = computeDayAdherence(
        date: date,
        today: today,
        blocks: [block(id: 'a', weekday: today.weekday)],
        completions: {
          completionKey(item.routineBlockId, item.date): item,
        },
      );

      expect(adherence.status, DayAdherenceStatus.complete);
    });

    test('hoje parcial retorna inProgress', () {
      final item = completion(blockId: 'a', date: today);
      final adherence = computeDayAdherence(
        date: today,
        today: today,
        blocks: [
          block(id: 'a', weekday: today.weekday),
          block(id: 'b', weekday: today.weekday),
        ],
        completions: {
          completionKey(item.routineBlockId, item.date): item,
        },
      );

      expect(adherence.status, DayAdherenceStatus.inProgress);
      expect(adherence.completed, 1);
      expect(adherence.expected, 2);
    });

    test('dia futuro com rotina permanece neutro', () {
      final adherence = computeDayAdherence(
        date: DateTime(2026, 8, 10),
        today: today,
        blocks: [block(id: 'a', weekday: DateTime.monday)],
        completions: const {},
      );

      expect(adherence.status, DayAdherenceStatus.noRoutine);
      expect(adherence.expected, 1);
    });
  });
}
