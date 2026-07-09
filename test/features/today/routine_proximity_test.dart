import 'package:flutter_test/flutter_test.dart';

import 'package:my_week_done_app/features/today/domain/routine_proximity.dart';

void main() {
  final date = DateTime(2026, 7, 9);

  DateTime at(int hour, [int minute = 0]) =>
      DateTime(2026, 7, 9, hour, minute);

  DateTime blockAt(int hour, [int minute = 0]) =>
      DateTime(2000, 1, 1, hour, minute);

  group('routineProximityHighlight', () {
    test('retorna none quando concluída', () {
      expect(
        routineProximityHighlight(
          date: date,
          now: at(6, 55),
          blockStartTime: blockAt(7),
          completed: true,
        ),
        RoutineProximityHighlight.none,
      );
    });

    test('retorna none fora do dia atual', () {
      expect(
        routineProximityHighlight(
          date: date,
          now: DateTime(2026, 7, 10, 6, 55),
          blockStartTime: blockAt(7),
          completed: false,
        ),
        RoutineProximityHighlight.none,
      );
    });

    test('retorna none com mais de 1h de antecedência', () {
      expect(
        routineProximityHighlight(
          date: date,
          now: at(5, 30),
          blockStartTime: blockAt(7),
          completed: false,
        ),
        RoutineProximityHighlight.none,
      );
    });

    test('retorna approaching entre 1h e 5min antes', () {
      expect(
        routineProximityHighlight(
          date: date,
          now: at(6, 30),
          blockStartTime: blockAt(7),
          completed: false,
        ),
        RoutineProximityHighlight.approaching,
      );
    });

    test('retorna imminent a 5min ou menos do início', () {
      expect(
        routineProximityHighlight(
          date: date,
          now: at(6, 56),
          blockStartTime: blockAt(7),
          completed: false,
        ),
        RoutineProximityHighlight.imminent,
      );
    });

    test('mantém imminent após o horário até fim do dia', () {
      expect(
        routineProximityHighlight(
          date: date,
          now: at(10),
          blockStartTime: blockAt(7),
          completed: false,
        ),
        RoutineProximityHighlight.imminent,
      );
    });
  });
}
