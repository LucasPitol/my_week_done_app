import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../../domain/entities/daily_completion.dart' as domain;
import '../../domain/entities/routine_block.dart' as domain;

/// Data de referência para horários — só importa hora:minuto.
final _timeEpoch = DateTime(2000, 1, 1);

String formatDateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime parseDateKey(String key) {
  final parts = key.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

String formatStartTime(DateTime time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

DateTime parseStartTime(String value) {
  final parts = value.split(':').map(int.parse).toList();
  return DateTime(
    _timeEpoch.year,
    _timeEpoch.month,
    _timeEpoch.day,
    parts[0],
    parts[1],
  );
}

DateTime normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

domain.RoutineBlock routineBlockFromRow(RoutineBlockRow row) {
  return domain.RoutineBlock(
    id: row.id,
    weekday: row.weekday,
    startTime: parseStartTime(row.startTime),
    title: row.title,
    category: row.category,
  );
}

RoutineBlocksCompanion routineBlockToCompanion(domain.RoutineBlock block) {
  return RoutineBlocksCompanion.insert(
    id: block.id,
    weekday: block.weekday,
    startTime: formatStartTime(block.startTime),
    title: block.title,
    category: Value(block.category),
  );
}

domain.DailyCompletion dailyCompletionFromRow(DailyCompletionRow row) {
  return domain.DailyCompletion(
    id: row.id,
    routineBlockId: row.routineBlockId,
    date: parseDateKey(row.date),
    completed: row.completed,
    note: row.note,
  );
}

DailyCompletionsCompanion dailyCompletionToCompanion(
  domain.DailyCompletion completion,
) {
  return DailyCompletionsCompanion.insert(
    id: completion.id,
    routineBlockId: completion.routineBlockId,
    date: formatDateKey(completion.date),
    completed: Value(completion.completed),
    note: Value(completion.note),
  );
}
