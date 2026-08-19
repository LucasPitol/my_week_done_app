import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../providers/theme_mode_provider.dart';
import 'main_shell.dart';

class MyWeekDoneApp extends ConsumerWidget {
  const MyWeekDoneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(resolvedThemeModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const MainShell(),
      showSemanticsDebugger: false,
    );
  }
}
