import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../features/blocks/presentation/block_form_screen.dart';
import '../../features/blocks/presentation/blocks_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
// import '../../features/stats/presentation/stats_screen.dart';
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
    ProfileScreen(),
    // StatsScreen(),
  ];

  void _openCreateForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BlockFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showFab = _currentIndex == AppConstants.tabToday ||
        _currentIndex == AppConstants.tabBlocks;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: _openCreateForm,
              tooltip: 'Novo',
              child: const Icon(TablerIcons.plus),
            )
          : null,
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
            label: 'Rotinas',
          ),
          NavigationDestination(
            icon: Icon(TablerIcons.user),
            selectedIcon: Icon(TablerIcons.user_filled),
            label: 'Perfil',
          ),
          // NavigationDestination(
          //   icon: Icon(TablerIcons.chart_pie),
          //   selectedIcon: Icon(TablerIcons.chart_pie_filled),
          //   label: 'Stats',
          // ),
        ],
      ),
    );
  }
}
