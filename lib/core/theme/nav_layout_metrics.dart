import 'package:flutter/material.dart';

/// Dimensões da tab bar flutuante em pill e do FAB.
abstract final class NavLayoutMetrics {
  static const tabBarHeight = 64.0;
  static const tabBarHorizontalInset = 16.0;
  static const tabBarBottomInset = 8.0;

  static const fabSize = 56.0;
  static const fabGapAboveTabBar = 16.0;

  static double tabBarBottom(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom + tabBarBottomInset;
  }

  static double scrollBottomInset(BuildContext context) {
    return tabBarBottom(context) + tabBarHeight + fabGapAboveTabBar + fabSize + 12;
  }

  static EdgeInsets scrollPadding(BuildContext context) {
    return EdgeInsets.only(bottom: scrollBottomInset(context));
  }
}
