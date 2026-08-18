import 'package:flutter/material.dart';

import '../../core/theme/glass/glass_layout_metrics.dart';
import '../../core/widgets/glass/bottom_content_fade.dart';
import '../../core/widgets/glass/glass_fab.dart';
import '../../core/widgets/glass/glass_tab_bar.dart';
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
      extendBody: true,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: GlassLayoutMetrics.tabBarBottom(context) +
                GlassLayoutMetrics.tabBarHeight,
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: BottomContentFade(),
            ),
          ),
          if (showFab)
            Positioned(
              right: GlassLayoutMetrics.fabRightInset,
              bottom: GlassLayoutMetrics.fabBottom(context),
              child: GlassFab(onPressed: _openCreateForm),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassTabBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: defaultGlassTabDestinations,
            ),
          ),
        ],
      ),
    );
  }
}
