import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/daily_completion.dart';
import '../../domain/entities/routine_block.dart';
import '../../domain/repositories/routine_repository.dart';
import '../local/app_database.dart';
import '../mappers/routine_mappers.dart';

/// Persistência local v1 via SQLite (Drift).
class LocalRoutineRepository implements RoutineRepository {
  LocalRoutineRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<RoutineBlock>> watchRoutineBlocks() {
    return (_db.select(_db.routineBlocks)
          ..orderBy([
            (t) => OrderingTerm.asc(t.weekday),
            (t) => OrderingTerm.asc(t.startTime),
          ]))
        .watch()
        .map((rows) => rows.map(routineBlockFromRow).toList(growable: false));
  }

  @override
  Stream<List<DailyCompletion>> watchCompletionsForDate(DateTime date) {
    final key = formatDateKey(normalizeDate(date));
    return (_db.select(_db.dailyCompletions)
          ..where((t) => t.date.equals(key)))
        .watch()
        .map(
          (rows) => rows.map(dailyCompletionFromRow).toList(growable: false),
        );
  }

  @override
  Stream<List<DailyCompletion>> watchCompletionsForWeek(DateTime weekStart) {
    final start = normalizeDate(weekStart);
    final end = start.add(const Duration(days: 6));
    final startKey = formatDateKey(start);
    final endKey = formatDateKey(end);

    return (_db.select(_db.dailyCompletions)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(startKey) &
                t.date.isSmallerOrEqualValue(endKey),
          ))
        .watch()
        .map(
          (rows) => rows.map(dailyCompletionFromRow).toList(growable: false),
        );
  }

  @override
  Future<void> saveRoutineBlock(RoutineBlock block) async {
    await _db.into(_db.routineBlocks).insertOnConflictUpdate(
          routineBlockToCompanion(block),
        );
  }

  @override
  Future<void> deleteRoutineBlock(String id) async {
    await (_db.delete(_db.routineBlocks)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> toggleCompletion({
    required String routineBlockId,
    required DateTime date,
    required bool completed,
  }) async {
    final normalized = normalizeDate(date);
    final key = formatDateKey(normalized);

    final existing = await (_db.select(_db.dailyCompletions)
          ..where(
            (t) =>
                t.routineBlockId.equals(routineBlockId) & t.date.equals(key),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.dailyCompletions)
            ..where((t) => t.id.equals(existing.id)))
          .write(DailyCompletionsCompanion(completed: Value(completed)));
    } else {
      await _db.into(_db.dailyCompletions).insert(
            DailyCompletionsCompanion.insert(
              id: _uuid.v4(),
              routineBlockId: routineBlockId,
              date: key,
              completed: Value(completed),
            ),
          );
    }
  }

  @override
  Future<void> updateCompletionNote({
    required String routineBlockId,
    required DateTime date,
    required String? note,
  }) async {
    final normalized = normalizeDate(date);
    final key = formatDateKey(normalized);

    final existing = await (_db.select(_db.dailyCompletions)
          ..where(
            (t) =>
                t.routineBlockId.equals(routineBlockId) & t.date.equals(key),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.dailyCompletions)
            ..where((t) => t.id.equals(existing.id)))
          .write(DailyCompletionsCompanion(note: Value(note)));
    } else {
      await _db.into(_db.dailyCompletions).insert(
            DailyCompletionsCompanion.insert(
              id: _uuid.v4(),
              routineBlockId: routineBlockId,
              date: key,
              note: Value(note),
            ),
          );
    }
  }

  @override
  Future<double> adherenceForWeek(DateTime weekStart) async {
    final start = normalizeDate(weekStart);
    final blocks = await _db.select(_db.routineBlocks).get();
    final completions = await _db.select(_db.dailyCompletions).get();

    var total = 0;
    var done = 0;

    for (var day = 0; day < 7; day++) {
      final date = start.add(Duration(days: day));
      final weekday = date.weekday;
      final key = formatDateKey(date);
      final blocksForDay = blocks.where((b) => b.weekday == weekday);
      total += blocksForDay.length;

      for (final block in blocksForDay) {
        final completion = completions.where(
          (c) =>
              c.routineBlockId == block.id &&
              c.date == key &&
              c.completed,
        );
        if (completion.isNotEmpty) done++;
      }
    }

    if (total == 0) return 0;
    return done / total;
  }
}
