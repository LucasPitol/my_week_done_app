import 'package:flutter_test/flutter_test.dart';

import 'package:my_week_done_app/core/utils/calendar_utils.dart';

void main() {
  group('daysForMonthGrid', () {
    test('gera 42 dias começando na segunda da semana do dia 1', () {
      final days = daysForMonthGrid(DateTime(2026, 8, 1));

      expect(days, hasLength(42));
      expect(days.first.weekday, DateTime.monday);
      expect(days.any((day) => day.day == 1 && day.month == 8), isTrue);
    });
  });

  group('shiftMonth', () {
    test('ajusta dia quando o mês de destino é mais curto', () {
      expect(shiftMonth(DateTime(2026, 3, 31), 1), DateTime(2026, 4, 30));
    });

    test('retrocede para o mês anterior', () {
      expect(shiftMonth(DateTime(2026, 8, 15), -1), DateTime(2026, 7, 15));
    });
  });
}
