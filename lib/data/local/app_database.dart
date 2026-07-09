import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import 'tables/daily_completions_table.dart';
import 'tables/floating_tasks_table.dart';
import 'tables/routine_blocks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [RoutineBlocks, DailyCompletions, FloatingTasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'my_week_done'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(routineBlocks, routineBlocks.groupId);
            await _backfillRoutineBlockGroups();
          }
          if (from < 3) {
            await migrator.createTable(floatingTasks);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _backfillRoutineBlockGroups() async {
    const uuid = Uuid();
    final rows = await select(routineBlocks).get();
    final assigned = <String>{};

    for (final row in rows) {
      if (row.groupId != null) continue;

      final signature =
          '${row.title}\0${row.startTime}\0${row.category ?? ''}';
      if (assigned.contains(signature)) continue;

      final siblings = rows.where(
        (other) =>
            other.title == row.title &&
            other.startTime == row.startTime &&
            other.category == row.category,
      );

      final groupId = uuid.v4();
      for (final sibling in siblings) {
        await (update(routineBlocks)..where((t) => t.id.equals(sibling.id)))
            .write(RoutineBlocksCompanion(groupId: Value(groupId)));
      }

      assigned.add(signature);
    }
  }
}
