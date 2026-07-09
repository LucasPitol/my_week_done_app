import '../../../core/utils/week_utils.dart';

/// Destaque temporal de rotinas na visão Dia — ver [docs/styles.md].
enum RoutineProximityHighlight {
  none,
  /// Dentro de 1h e antes de 5min do início — aviso (#E8B86E).
  approaching,
  /// A partir de 5min antes do início até fim do dia ou conclusão — primário.
  imminent,
}

RoutineProximityHighlight routineProximityHighlight({
  required DateTime date,
  required DateTime now,
  required DateTime blockStartTime,
  required bool completed,
}) {
  if (completed || !isSameDay(date, now)) return RoutineProximityHighlight.none;

  final scheduledStart = DateTime(
    date.year,
    date.month,
    date.day,
    blockStartTime.hour,
    blockStartTime.minute,
  );

  final oneHourBefore = scheduledStart.subtract(const Duration(hours: 1));
  final fiveMinutesBefore = scheduledStart.subtract(const Duration(minutes: 5));
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

  if (now.isBefore(oneHourBefore) || now.isAfter(endOfDay)) {
    return RoutineProximityHighlight.none;
  }

  if (now.isBefore(fiveMinutesBefore)) {
    return RoutineProximityHighlight.approaching;
  }

  return RoutineProximityHighlight.imminent;
}
