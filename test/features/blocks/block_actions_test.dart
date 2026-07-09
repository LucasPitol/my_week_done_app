import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:my_week_done_app/data/local/app_database.dart';
import 'package:my_week_done_app/data/repositories/local_routine_repository.dart';
import 'package:my_week_done_app/domain/entities/routine_block.dart';
import 'package:my_week_done_app/features/blocks/domain/block_group_utils.dart';
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
    test('cria bloco em múltiplos dias com o mesmo groupId', () async {
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
      expect(blocks.map((b) => b.groupId).toSet(), hasLength(1));
    });

    test('atualiza todas as ocorrências do grupo', () async {
      final actions = container.read(blockActionsProvider);

      await actions.createBlocks(
        title: 'Treino',
        startTime: DateTime(2000, 1, 1, 7),
        weekdays: {2, 3, 5},
      );

      final blocks = await repository.watchRoutineBlocks().first;
      final tuesday = blocks.firstWhere((b) => b.weekday == 2);
      final groupMembers = blocksInGroup(blocks, tuesday);

      await actions.updateBlock(
        block: tuesday,
        groupMembers: groupMembers,
        title: 'Treino pesado',
        startTime: DateTime(2000, 1, 1, 8),
        weekdays: {2, 3, 5},
        category: 'saude',
        applyToAll: true,
      );

      final updated = await repository.watchRoutineBlocks().first;
      expect(updated, hasLength(3));
      expect(updated.every((b) => b.title == 'Treino pesado'), isTrue);
      expect(updated.every((b) => b.startTime.hour == 8), isTrue);
      expect(updated.every((b) => b.category == 'saude'), isTrue);
      expect(updated.map((b) => b.groupId).toSet(), hasLength(1));
    });

    test('atualiza apenas uma ocorrência e desvincula do grupo', () async {
      final actions = container.read(blockActionsProvider);

      await actions.createBlocks(
        title: 'Treino',
        startTime: DateTime(2000, 1, 1, 7),
        weekdays: {2, 3, 5},
      );

      final blocks = await repository.watchRoutineBlocks().first;
      final tuesday = blocks.firstWhere((b) => b.weekday == 2);
      final groupMembers = blocksInGroup(blocks, tuesday);

      await actions.updateBlock(
        block: tuesday,
        groupMembers: groupMembers,
        title: 'Treino leve',
        startTime: DateTime(2000, 1, 1, 6, 30),
        weekdays: {2, 3, 5},
        category: null,
        applyToAll: false,
      );

      final updated = await repository.watchRoutineBlocks().first;
      final editedTuesday = updated.firstWhere((b) => b.id == tuesday.id);

      expect(editedTuesday.title, 'Treino leve');
      expect(editedTuesday.startTime.hour, 6);
      expect(editedTuesday.startTime.minute, 30);
      expect(editedTuesday.groupId, isNull);

      final others = updated.where((b) => b.id != tuesday.id).toList();
      expect(others.every((b) => b.title == 'Treino'), isTrue);
      expect(others.every((b) => b.startTime.hour == 7), isTrue);
      expect(others.map((b) => b.groupId).toSet(), hasLength(1));
    });

    test('atualiza grupo adicionando e removendo dias', () async {
      final actions = container.read(blockActionsProvider);

      await actions.createBlocks(
        title: 'Treino',
        startTime: DateTime(2000, 1, 1, 7),
        weekdays: {2, 3, 5},
      );

      final blocks = await repository.watchRoutineBlocks().first;
      final tuesday = blocks.firstWhere((b) => b.weekday == 2);

      await actions.updateBlock(
        block: tuesday,
        groupMembers: blocksInGroup(blocks, tuesday),
        title: 'Treino',
        startTime: DateTime(2000, 1, 1, 7),
        weekdays: {2, 4, 5},
        category: null,
        applyToAll: true,
      );

      final updated = await repository.watchRoutineBlocks().first;
      expect(updated.map((b) => b.weekday).toSet(), {2, 4, 5});
    });

    test('exclui apenas uma ocorrência do grupo', () async {
      final actions = container.read(blockActionsProvider);

      await actions.createBlocks(
        title: 'Treino',
        startTime: DateTime(2000, 1, 1, 7),
        weekdays: {2, 3, 5},
      );

      final blocks = await repository.watchRoutineBlocks().first;
      final tuesday = blocks.firstWhere((b) => b.weekday == 2);

      await actions.deleteBlock(
        block: tuesday,
        groupMembers: blocksInGroup(blocks, tuesday),
        deleteAll: false,
      );

      final remaining = await repository.watchRoutineBlocks().first;
      expect(remaining, hasLength(2));
      expect(remaining.map((b) => b.weekday).toSet(), {3, 5});
    });

    test('exclui todas as ocorrências do grupo', () async {
      final actions = container.read(blockActionsProvider);

      await actions.createBlocks(
        title: 'Treino',
        startTime: DateTime(2000, 1, 1, 7),
        weekdays: {2, 3, 5},
      );

      final blocks = await repository.watchRoutineBlocks().first;
      final tuesday = blocks.firstWhere((b) => b.weekday == 2);

      await actions.deleteBlock(
        block: tuesday,
        groupMembers: blocksInGroup(blocks, tuesday),
        deleteAll: true,
      );

      final remaining = await repository.watchRoutineBlocks().first;
      expect(remaining, isEmpty);
    });
  });
}
