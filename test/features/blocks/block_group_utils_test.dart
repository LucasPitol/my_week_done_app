import 'package:flutter_test/flutter_test.dart';

import 'package:my_week_done_app/domain/entities/routine_block.dart';
import 'package:my_week_done_app/features/blocks/domain/block_group_utils.dart';

void main() {
  group('block_group_utils', () {
    test('blocksInGroup retorna blocos com o mesmo groupId', () {
      const groupId = 'group-1';
      final blocks = [
        RoutineBlock(
          id: 'a',
          weekday: 2,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
          groupId: groupId,
        ),
        RoutineBlock(
          id: 'b',
          weekday: 3,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
          groupId: groupId,
        ),
        RoutineBlock(
          id: 'c',
          weekday: 5,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
          groupId: groupId,
        ),
      ];

      final group = blocksInGroup(blocks, blocks.first);
      expect(group, hasLength(3));
      expect(group.map((b) => b.weekday).toList(), [2, 3, 5]);
    });

    test('blocksInGroup retorna só o bloco quando groupId é nulo', () {
      final block = RoutineBlock(
        id: 'solo',
        weekday: 1,
        startTime: DateTime(2000, 1, 1, 7),
        title: 'Leitura',
      );

      expect(blocksInGroup([block], block), [block]);
    });

    test('hasGroupChanges detecta mudança de horário', () {
      final group = [
        RoutineBlock(
          id: 'a',
          weekday: 2,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
          groupId: 'group-1',
        ),
      ];

      expect(
        hasGroupChanges(
          block: group.first,
          groupBlocks: group,
          title: 'Treino',
          startTime: DateTime(2000, 1, 1, 8),
          weekdays: {2},
          category: null,
        ),
        isTrue,
      );
    });
  });
}
