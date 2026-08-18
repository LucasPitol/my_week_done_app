import 'package:flutter/material.dart';

/// Dimensões compartilhadas da camada de navegação glass.
abstract final class GlassLayoutMetrics {
  static const tabBarHeight = 64.0;
  static const tabBarHorizontalInset = 16.0;
  static const tabBarBottomInset = 8.0;

  static const fabSize = 56.0;
  static const fabRightInset = 20.0;
  static const fabGapAboveTabBar = 16.0;

  static const bottomFadeHeight = 72.0;

  static double tabBarBottom(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom + tabBarBottomInset;
  }

  static double fabBottom(BuildContext context) {
    return tabBarBottom(context) + tabBarHeight + fabGapAboveTabBar;
  }

  /// Espaço extra para listas rolarem acima da tab bar + FAB.
  static double scrollBottomInset(BuildContext context) {
    return fabBottom(context) + fabSize + 12;
  }

  static EdgeInsets scrollPadding(BuildContext context) {
    return EdgeInsets.only(bottom: scrollBottomInset(context));
  }
}
