import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/repositories/local_routine_repository.dart';
import '../domain/repositories/routine_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return LocalRoutineRepository(ref.watch(appDatabaseProvider));
});
