import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_week_done_app/app/app.dart';

void main() {
  testWidgets('App inicia na aba Hoje', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyWeekDoneApp(),
      ),
    );

    expect(find.text('Seletor de dia, lista de blocos e anel de aderência'), findsOneWidget);
    expect(find.text('Blocos'), findsWidgets);
    expect(find.text('Stats'), findsWidgets);
  });
}
