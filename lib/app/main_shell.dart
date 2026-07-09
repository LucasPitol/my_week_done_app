import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../features/blocks/presentation/blocks_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/today/presentation/today_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = AppConstants.tabToday;

  static const _screens = [
    TodayScreen(),
    BlocksScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(TablerIcons.calendar_week),
            selectedIcon: Icon(TablerIcons.calendar_event),
            label: 'Hoje',
          ),
          NavigationDestination(
            icon: Icon(TablerIcons.list_details),
            selectedIcon: Icon(TablerIcons.list),
            label: 'Blocos',
          ),
          NavigationDestination(
            icon: Icon(TablerIcons.chart_pie),
            selectedIcon: Icon(TablerIcons.chart_pie_filled),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
