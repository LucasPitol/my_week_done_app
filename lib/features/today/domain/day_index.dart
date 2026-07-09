import '../../../core/utils/week_utils.dart';

DateTime normalizeDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Data-base fixa para índice infinito do PageView.
final dayIndexEpoch = DateTime(2020, 1, 1);

int dayToIndex(DateTime date) {
  return normalizeDay(date).difference(dayIndexEpoch).inDays;
}

DateTime indexToDay(int index) {
  return dayIndexEpoch.add(Duration(days: index));
}

String formatDayHeader(DateTime date) {
  final weekday = weekdayFullLabels[date.weekday]!;
  final monthNames = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  return '$weekday, ${date.day} de ${monthNames[date.month - 1]}';
}
