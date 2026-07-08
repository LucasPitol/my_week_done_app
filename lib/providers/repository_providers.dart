import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/local_routine_repository.dart';
import '../domain/repositories/routine_repository.dart';

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return LocalRoutineRepository();
});
