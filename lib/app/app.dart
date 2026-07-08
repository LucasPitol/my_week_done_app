import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import 'main_shell.dart';

class MyWeekDoneApp extends StatelessWidget {
  const MyWeekDoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light(),
      home: const MainShell(),
    );
  }
}
