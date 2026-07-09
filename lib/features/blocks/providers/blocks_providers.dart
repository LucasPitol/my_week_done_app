import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/routine_block.dart';
import '../../../providers/repository_providers.dart';

final blockActionsProvider = Provider<BlockActions>((ref) {
  return BlockActions(ref);
});

class BlockActions {
  BlockActions(this._ref);

  final Ref _ref;
  final _uuid = const Uuid();

  Future<void> createBlocks({
    required String title,
    required DateTime startTime,
    required Set<int> weekdays,
    String? category,
  }) async {
    final repository = _ref.read(routineRepositoryProvider);
    for (final weekday in weekdays) {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: _uuid.v4(),
          weekday: weekday,
          startTime: startTime,
          title: title.trim(),
          category: category,
        ),
      );
    }
  }

  Future<void> updateBlock(RoutineBlock block) async {
    await _ref.read(routineRepositoryProvider).saveRoutineBlock(block);
  }

  Future<void> deleteBlock(String id) async {
    await _ref.read(routineRepositoryProvider).deleteRoutineBlock(id);
  }
}

List<RoutineBlock> groupBlocksByWeekday(List<RoutineBlock> blocks) {
  final sorted = List<RoutineBlock>.from(blocks)
    ..sort((a, b) {
      final dayCompare = a.weekday.compareTo(b.weekday);
      if (dayCompare != 0) return dayCompare;
      final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
      final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
      return aMinutes.compareTo(bMinutes);
    });
  return sorted;
}

Map<int, List<RoutineBlock>> blocksGroupedByWeekday(List<RoutineBlock> blocks) {
  final grouped = <int, List<RoutineBlock>>{};
  for (final block in groupBlocksByWeekday(blocks)) {
    grouped.putIfAbsent(block.weekday, () => []).add(block);
  }
  return grouped;
}
