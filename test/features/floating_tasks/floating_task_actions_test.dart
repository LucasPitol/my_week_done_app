import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:my_week_done_app/data/local/app_database.dart';
import 'package:my_week_done_app/data/repositories/local_routine_repository.dart';
import 'package:my_week_done_app/features/floating_tasks/providers/floating_task_providers.dart';
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

  group('FloatingTaskActions', () {
    test('cria tarefa solta', () async {
      await container.read(floatingTaskActionsProvider).createTask(
            title: 'Comprar presente',
            category: 'lazer',
            deadline: DateTime(2026, 7, 10),
          );

      final tasks = await repository.watchFloatingTasks().first;
      expect(tasks, hasLength(1));
      expect(tasks.first.title, 'Comprar presente');
      expect(tasks.first.category, 'lazer');
      expect(tasks.first.deadline?.day, 10);
    });

    test('atualiza tarefa solta', () async {
      await container.read(floatingTaskActionsProvider).createTask(
            title: 'Original',
          );

      final task = (await repository.watchFloatingTasks().first).first;

      await container.read(floatingTaskActionsProvider).updateTask(
            task: task,
            title: 'Atualizada',
            category: 'trabalho',
            deadline: DateTime(2026, 7, 15),
          );

      final updated = await repository.watchFloatingTasks().first;
      expect(updated.first.title, 'Atualizada');
      expect(updated.first.category, 'trabalho');
      expect(updated.first.deadline?.day, 15);
    });

    test('exclui tarefa solta', () async {
      await container.read(floatingTaskActionsProvider).createTask(
            title: 'Temporária',
          );

      final task = (await repository.watchFloatingTasks().first).first;
      await container.read(floatingTaskActionsProvider).deleteTask(task.id);

      final tasks = await repository.watchFloatingTasks().first;
      expect(tasks, isEmpty);
    });
  });
}
