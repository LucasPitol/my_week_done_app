import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:my_week_done_app/data/local/app_database.dart';
import 'package:my_week_done_app/data/repositories/local_routine_repository.dart';
import 'package:my_week_done_app/domain/entities/routine_block.dart';
import 'package:my_week_done_app/features/blocks/providers/blocks_providers.dart';
import 'package:my_week_done_app/providers/repository_providers.dart';

void main() {
  late AppDatabase database;
  late LocalRoutineRepository repository;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalRoutineRepository(database, uuid: const Uuid());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        routineRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  group('BlockActions', () {
    test('cria bloco em múltiplos dias', () async {
      final actions = container.read(blockActionsProvider);

      await actions.createBlocks(
        title: 'Malhão',
        startTime: DateTime(2000, 1, 1, 7),
        weekdays: {1, 2, 3, 4, 5},
        category: 'saude',
      );

      final blocks = await repository.watchRoutineBlocks().first;
      expect(blocks, hasLength(5));
      expect(blocks.map((b) => b.title).toSet(), {'Malhão'});
      expect(blocks.map((b) => b.weekday).toSet(), {1, 2, 3, 4, 5});
      expect(blocks.every((b) => b.category == 'saude'), isTrue);
    });

    test('atualiza bloco existente', () async {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 2,
          startTime: DateTime(2000, 1, 1, 8),
          title: 'Trabalho',
        ),
      );

      final actions = container.read(blockActionsProvider);
      await actions.updateBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 3,
          startTime: DateTime(2000, 1, 1, 9),
          title: 'Trabalho remoto',
          category: 'trabalho',
        ),
      );

      final blocks = await repository.watchRoutineBlocks().first;
      expect(blocks.single.title, 'Trabalho remoto');
      expect(blocks.single.weekday, 3);
      expect(blocks.single.startTime.hour, 9);
      expect(blocks.single.category, 'trabalho');
    });

    test('exclui bloco', () async {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 1,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
        ),
      );

      await container.read(blockActionsProvider).deleteBlock('block-1');

      final blocks = await repository.watchRoutineBlocks().first;
      expect(blocks, isEmpty);
    });
  });
}
