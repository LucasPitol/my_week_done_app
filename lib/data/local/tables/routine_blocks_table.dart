import 'package:drift/drift.dart';

@DataClassName('RoutineBlockRow')
class RoutineBlocks extends Table {
  TextColumn get id => text()();
  IntColumn get weekday => integer()();
  TextColumn get startTime => text()();
  TextColumn get title => text()();
  TextColumn get category => text().nullable()();
  TextColumn get groupId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
