import 'package:drift/drift.dart';

import 'routine_blocks_table.dart';

@DataClassName('DailyCompletionRow')
@TableIndex(
  name: 'idx_completion_block_date',
  columns: {#routineBlockId, #date},
  unique: true,
)
class DailyCompletions extends Table {
  TextColumn get id => text()();
  TextColumn get routineBlockId =>
      text().references(RoutineBlocks, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text()();
  BoolColumn get completed =>
      boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
