DateTime startOfMonth(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  return DateTime(normalized.year, normalized.month, 1);
}

DateTime endOfMonth(DateTime date) {
  final start = startOfMonth(date);
  return DateTime(start.year, start.month + 1, 0);
}

/// Grade fixa de 6 semanas (42 dias), começando na segunda da semana do dia 1.
List<DateTime> daysForMonthGrid(DateTime month) {
  final first = startOfMonth(month);
  final gridStart = first.subtract(Duration(days: first.weekday - 1));
  return List.generate(42, (index) => gridStart.add(Duration(days: index)));
}

bool isSameMonth(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month;
}

DateTime clampDayInMonth(DateTime referenceDay, DateTime targetMonth) {
  final lastDay = endOfMonth(targetMonth).day;
  final day = referenceDay.day > lastDay ? lastDay : referenceDay.day;
  return DateTime(targetMonth.year, targetMonth.month, day);
}

DateTime shiftMonth(DateTime date, int delta) {
  var month = date.month + delta;
  var year = date.year;
  while (month > 12) {
    month -= 12;
    year += 1;
  }
  while (month < 1) {
    month += 12;
    year -= 1;
  }
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = date.day > lastDay ? lastDay : date.day;
  return DateTime(year, month, day);
}
