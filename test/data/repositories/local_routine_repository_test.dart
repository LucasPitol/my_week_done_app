import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:my_week_done_app/data/local/app_database.dart';
import 'package:my_week_done_app/data/repositories/local_routine_repository.dart';
import 'package:my_week_done_app/domain/entities/routine_block.dart';

void main() {
  late AppDatabase database;
  late LocalRoutineRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalRoutineRepository(database, uuid: const Uuid());
  });

  tearDown(() async {
    await database.close();
  });

  group('routine_blocks', () {
    test('salva e observa blocos de rotina', () async {
      final block = RoutineBlock(
        id: 'block-1',
        weekday: 1,
        startTime: DateTime(2000, 1, 1, 7, 30),
        title: 'Treino',
        category: 'saude',
        groupId: 'group-1',
      );

      await repository.saveRoutineBlock(block);

      final blocks = await repository.watchRoutineBlocks().first;
      expect(blocks, hasLength(1));
      expect(blocks.first.id, 'block-1');
      expect(blocks.first.weekday, 1);
      expect(blocks.first.title, 'Treino');
      expect(blocks.first.category, 'saude');
      expect(blocks.first.groupId, 'group-1');
      expect(blocks.first.startTime.hour, 7);
      expect(blocks.first.startTime.minute, 30);
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

      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 2,
          startTime: DateTime(2000, 1, 1, 9),
          title: 'Trabalho remoto',
          category: 'trabalho',
        ),
      );

      final blocks = await repository.watchRoutineBlocks().first;
      expect(blocks, hasLength(1));
      expect(blocks.first.title, 'Trabalho remoto');
      expect(blocks.first.startTime.hour, 9);
      expect(blocks.first.category, 'trabalho');
    });

    test('exclui bloco e completions em cascata', () async {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 3,
          startTime: DateTime(2000, 1, 1, 12),
          title: 'Almoço',
        ),
      );

      final date = DateTime(2026, 7, 8);
      await repository.toggleCompletion(
        routineBlockId: 'block-1',
        date: date,
        completed: true,
      );

      await repository.deleteRoutineBlock('block-1');

      final blocks = await repository.watchRoutineBlocks().first;
      final completions =
          await repository.watchCompletionsForDate(date).first;

      expect(blocks, isEmpty);
      expect(completions, isEmpty);
    });
  });

  group('daily_completions', () {
    test('cria e alterna conclusão por dia', () async {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 1,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
        ),
      );

      final date = DateTime(2026, 7, 7);

      await repository.toggleCompletion(
        routineBlockId: 'block-1',
        date: date,
        completed: true,
      );

      var completions = await repository.watchCompletionsForDate(date).first;
      expect(completions, hasLength(1));
      expect(completions.first.completed, isTrue);

      await repository.toggleCompletion(
        routineBlockId: 'block-1',
        date: date,
        completed: false,
      );

      completions = await repository.watchCompletionsForDate(date).first;
      expect(completions.first.completed, isFalse);
    });

    test('salva nota opcional na conclusão', () async {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 4,
          startTime: DateTime(2000, 1, 1, 20),
          title: 'Ler',
        ),
      );

      final date = DateTime(2026, 7, 10);
      await repository.updateCompletionNote(
        routineBlockId: 'block-1',
        date: date,
        note: 'Capítulo 3',
      );

      final completions = await repository.watchCompletionsForDate(date).first;
      expect(completions, hasLength(1));
      expect(completions.first.note, 'Capítulo 3');
      expect(completions.first.completed, isFalse);
    });
  });

  group('adherenceForWeek', () {
    test('calcula aderência da semana', () async {
      final weekStart = DateTime(2026, 7, 6);

      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'mon',
          weekday: weekStart.weekday,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
        ),
      );
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'tue',
          weekday: weekStart.add(const Duration(days: 1)).weekday,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
        ),
      );

      await repository.toggleCompletion(
        routineBlockId: 'mon',
        date: weekStart,
        completed: true,
      );

      final adherence = await repository.adherenceForWeek(weekStart);
      expect(adherence, closeTo(0.5, 0.001));
    });

    test('retorna zero quando não há blocos', () async {
      final adherence =
          await repository.adherenceForWeek(DateTime(2026, 7, 6));
      expect(adherence, 0);
    });
  });

  group('watchCompletionsForWeek', () {
    test('observa completions da semana', () async {
      await repository.saveRoutineBlock(
        RoutineBlock(
          id: 'block-1',
          weekday: 1,
          startTime: DateTime(2000, 1, 1, 7),
          title: 'Treino',
        ),
      );

      final weekStart = DateTime(2026, 7, 6);
      await repository.toggleCompletion(
        routineBlockId: 'block-1',
        date: weekStart,
        completed: true,
      );
      await repository.toggleCompletion(
        routineBlockId: 'block-1',
        date: weekStart.add(const Duration(days: 8)),
        completed: true,
      );

      final completions =
          await repository.watchCompletionsForWeek(weekStart).first;

      expect(completions, hasLength(1));
      expect(completions.first.completed, isTrue);
    });
  });
}
