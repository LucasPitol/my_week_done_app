import '../../domain/entities/routine_block.dart';

DateTime startOfWeek(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  return normalized.subtract(Duration(days: normalized.weekday - 1));
}

List<DateTime> daysOfWeek(DateTime weekStart) {
  final start = startOfWeek(weekStart);
  return List.generate(7, (index) => start.add(Duration(days: index)));
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

const weekdayLabels = {
  1: 'Seg',
  2: 'Ter',
  3: 'Qua',
  4: 'Qui',
  5: 'Sex',
  6: 'Sáb',
  7: 'Dom',
};

const weekdayFullLabels = {
  1: 'Segunda',
  2: 'Terça',
  3: 'Quarta',
  4: 'Quinta',
  5: 'Sexta',
  6: 'Sábado',
  7: 'Domingo',
};

List<int> hourSlotsForBlocks(List<RoutineBlock> blocks) {
  if (blocks.isEmpty) {
    return List.generate(17, (index) => index + 6);
  }

  final hours = blocks.map((block) => block.startTime.hour).toSet().toList()
    ..sort();

  final minHour = (hours.first - 1).clamp(5, 23);
  final maxHour = (hours.last + 1).clamp(minHour, 23);
  return List.generate(maxHour - minHour + 1, (index) => minHour + index);
}

String formatHourLabel(int hour) {
  return '${hour.toString().padLeft(2, '0')}:00';
}
