import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/routine_block.dart';
import '../../../providers/repository_providers.dart';
import '../domain/block_group_utils.dart';

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
    final groupId = _uuid.v4();
    final trimmedTitle = title.trim();

    for (final weekday in weekdays) {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: _uuid.v4(),
          weekday: weekday,
          startTime: startTime,
          title: trimmedTitle,
          category: category,
          groupId: groupId,
        ),
      );
    }
  }

  Future<void> updateBlock({
    required RoutineBlock block,
    required List<RoutineBlock> groupMembers,
    required String title,
    required DateTime startTime,
    required Set<int> weekdays,
    required String? category,
    required bool applyToAll,
  }) async {
    if (applyToAll) {
      await _updateEntireGroup(
        block: block,
        groupMembers: groupMembers,
        title: title,
        startTime: startTime,
        weekdays: weekdays,
        category: category,
      );
      return;
    }

    await _updateSingleBlock(
      block: block,
      title: title,
      startTime: startTime,
      weekdays: weekdays,
      category: category,
    );
  }

  Future<void> deleteBlock({
    required RoutineBlock block,
    required List<RoutineBlock> groupMembers,
    required bool deleteAll,
  }) async {
    final repository = _ref.read(routineRepositoryProvider);

    if (deleteAll) {
      for (final member in groupMembers) {
        await repository.deleteRoutineBlock(member.id);
      }
      return;
    }

    await repository.deleteRoutineBlock(block.id);
  }

  Future<void> _updateEntireGroup({
    required RoutineBlock block,
    required List<RoutineBlock> groupMembers,
    required String title,
    required DateTime startTime,
    required Set<int> weekdays,
    required String? category,
  }) async {
    final repository = _ref.read(routineRepositoryProvider);
    final groupId = block.groupId ?? _uuid.v4();
    final trimmedTitle = title.trim();
    final existingByWeekday = {
      for (final member in groupMembers) member.weekday: member,
    };

    for (final weekday in weekdays) {
      final existing = existingByWeekday[weekday];
      if (existing != null) {
        await repository.saveRoutineBlock(
          existing.copyWith(
            title: trimmedTitle,
            startTime: startTime,
            category: category,
            groupId: groupId,
          ),
        );
      } else {
        await repository.saveRoutineBlock(
          RoutineBlock(
            id: _uuid.v4(),
            weekday: weekday,
            startTime: startTime,
            title: trimmedTitle,
            category: category,
            groupId: groupId,
          ),
        );
      }
    }

    for (final member in groupMembers) {
      if (!weekdays.contains(member.weekday)) {
        await repository.deleteRoutineBlock(member.id);
      }
    }
  }

  Future<void> _updateSingleBlock({
    required RoutineBlock block,
    required String title,
    required DateTime startTime,
    required Set<int> weekdays,
    required String? category,
  }) async {
    final repository = _ref.read(routineRepositoryProvider);
    final weekday = resolveWeekdayForSingleEdit(
      selectedWeekdays: weekdays,
      originalWeekday: block.weekday,
    );

    await repository.saveRoutineBlock(
      block.copyWith(
        title: title.trim(),
        startTime: startTime,
        category: category,
        weekday: weekday,
        clearGroupId: true,
      ),
    );
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
