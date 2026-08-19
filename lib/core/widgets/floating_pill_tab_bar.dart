import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../theme/nav_layout_metrics.dart';

class PillTabDestination {
  const PillTabDestination({
    required this.icon,
    required this.selectedIcon,
    required this.tooltip,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String tooltip;
}

class FloatingPillTabBar extends StatelessWidget {
  const FloatingPillTabBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<PillTabDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        NavLayoutMetrics.tabBarHorizontalInset,
        0,
        NavLayoutMetrics.tabBarHorizontalInset,
        NavLayoutMetrics.tabBarBottom(context),
      ),
      child: Material(
        elevation: 4,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.25),
        color: theme.colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NavLayoutMetrics.tabBarHeight / 2),
          side: BorderSide(color: theme.colorScheme.outline),
        ),
        child: SizedBox(
          height: NavLayoutMetrics.tabBarHeight,
          child: Row(
            children: [
              for (var index = 0; index < destinations.length; index++)
                Expanded(
                  child: _PillTabItem(
                    destination: destinations[index],
                    selected: selectedIndex == index,
                    primaryColor: theme.colorScheme.primary,
                    inactiveColor: theme.colorScheme.onSurfaceVariant,
                    onTap: () {
                      if (selectedIndex != index) {
                        HapticFeedback.selectionClick();
                        onDestinationSelected(index);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillTabItem extends StatelessWidget {
  const _PillTabItem({
    required this.destination,
    required this.selected,
    required this.primaryColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final PillTabDestination destination;
  final bool selected;
  final Color primaryColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? primaryColor : inactiveColor;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.tooltip,
      child: Tooltip(
        message: destination.tooltip,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  key: ValueKey(selected),
                  color: color,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const defaultPillTabDestinations = [
  PillTabDestination(
    icon: TablerIcons.calendar_week,
    selectedIcon: TablerIcons.calendar_event,
    tooltip: 'Hoje',
  ),
  PillTabDestination(
    icon: TablerIcons.list_details,
    selectedIcon: TablerIcons.list,
    tooltip: 'Rotinas',
  ),
  PillTabDestination(
    icon: TablerIcons.user,
    selectedIcon: TablerIcons.user_filled,
    tooltip: 'Perfil',
  ),
];
