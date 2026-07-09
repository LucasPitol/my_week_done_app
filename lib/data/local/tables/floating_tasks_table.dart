import 'package:drift/drift.dart';

@DataClassName('FloatingTaskRow')
class FloatingTasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text().nullable()();
  TextColumn get deadline => text().nullable()();
  BoolColumn get completed =>
      boolean().withDefault(const Constant(false))();
  TextColumn get completedAt => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
