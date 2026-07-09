import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_week_done_app/app/app.dart';
import 'package:my_week_done_app/data/local/app_database.dart';
import 'package:my_week_done_app/data/repositories/local_routine_repository.dart';
import 'package:my_week_done_app/domain/entities/routine_block.dart';
import 'package:my_week_done_app/providers/repository_providers.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('pt_BR');
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required AppDatabase database,
    required LocalRoutineRepository repository,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          routineRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MyWeekDoneApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('App inicia na visão Dia por padrão', (WidgetTester tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = LocalRoutineRepository(database);

    await repository.saveRoutineBlock(
      RoutineBlock(
        id: 'treino',
        weekday: DateTime.now().weekday,
        startTime: DateTime(2000, 1, 1, 7),
        title: 'Treino',
      ),
    );

    await pumpApp(tester, database: database, repository: repository);

    expect(find.text('Treino'), findsOneWidget);
    expect(find.text('Hoje'), findsWidgets);
    expect(find.text('Dia'), findsOneWidget);
    expect(find.text('Calendário'), findsOneWidget);
    expect(find.text('Tarefas soltas'), findsOneWidget);
    expect(find.text('Hora'), findsNothing);

    await database.close();
  });

  testWidgets('Toggle alterna para visão Calendário', (WidgetTester tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = LocalRoutineRepository(database);

    await repository.saveRoutineBlock(
      RoutineBlock(
        id: 'treino',
        weekday: DateTime.now().weekday,
        startTime: DateTime(2000, 1, 1, 7),
        title: 'Treino',
      ),
    );

    await pumpApp(tester, database: database, repository: repository);

    await tester.tap(find.text('Calendário'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Hora'), findsOneWidget);
    expect(find.text('Treino'), findsOneWidget);

    await database.close();
  });

  testWidgets('Tap no bloco alterna conclusão', (WidgetTester tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = LocalRoutineRepository(database);
    final today = DateTime.now();

    await repository.saveRoutineBlock(
      RoutineBlock(
        id: 'treino',
        weekday: today.weekday,
        startTime: DateTime(2000, 1, 1, 7),
        title: 'Treino',
      ),
    );

    await pumpApp(tester, database: database, repository: repository);

    await tester.ensureVisible(find.byKey(const ValueKey('block-treino')));
    await tester.tap(find.byKey(const ValueKey('block-treino')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final rows = await database.select(database.dailyCompletions).get();
    expect(rows, hasLength(1));
    expect(rows.first.completed, isTrue);

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('block-treino')));
    await tester.tap(find.byKey(const ValueKey('block-treino')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final updated = await database.select(database.dailyCompletions).get();
    expect(updated.first.completed, isFalse);

    await database.close();
  });
}
