import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../theme/glass/glass_layout_metrics.dart';
import '../../theme/glass/glass_tokens.dart';
import 'glass_surface.dart';

class GlassTabDestination {
  const GlassTabDestination({
    required this.icon,
    required this.selectedIcon,
    required this.tooltip,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String tooltip;
}

class GlassTabBar extends StatelessWidget {
  const GlassTabBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<GlassTabDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        GlassLayoutMetrics.tabBarHorizontalInset,
        0,
        GlassLayoutMetrics.tabBarHorizontalInset,
        GlassLayoutMetrics.tabBarBottom(context),
      ),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(GlassLayoutMetrics.tabBarHeight / 2),
        blurSigma: GlassTokens.tabBarBlur,
        backgroundOpacity: GlassTokens.tabBarOpacity,
        child: SizedBox(
          height: GlassLayoutMetrics.tabBarHeight,
          child: Row(
            children: [
              for (var index = 0; index < destinations.length; index++)
                Expanded(
                  child: _GlassTabItem(
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

class _GlassTabItem extends StatelessWidget {
  const _GlassTabItem({
    required this.destination,
    required this.selected,
    required this.primaryColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final GlassTabDestination destination;
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

/// Destinos padrão do app — espelham a bottom nav anterior.
const defaultGlassTabDestinations = [
  GlassTabDestination(
    icon: TablerIcons.calendar_week,
    selectedIcon: TablerIcons.calendar_event,
    tooltip: 'Hoje',
  ),
  GlassTabDestination(
    icon: TablerIcons.list_details,
    selectedIcon: TablerIcons.list,
    tooltip: 'Rotinas',
  ),
  GlassTabDestination(
    icon: TablerIcons.user,
    selectedIcon: TablerIcons.user_filled,
    tooltip: 'Perfil',
  ),
];
