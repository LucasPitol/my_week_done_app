import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_lifecycle_provider.dart';
import '../providers/theme_mode_provider.dart';
import 'main_shell.dart';

class MyWeekDoneApp extends ConsumerStatefulWidget {
  const MyWeekDoneApp({super.key});

  @override
  ConsumerState<MyWeekDoneApp> createState() => _MyWeekDoneAppState();
}

class _MyWeekDoneAppState extends ConsumerState<MyWeekDoneApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appLifecycleRefreshProvider.notifier).state++;
    }
  }

  @override
  Widget build(BuildContext context) {
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
