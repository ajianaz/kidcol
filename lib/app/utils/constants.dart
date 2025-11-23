import 'package:flutter/material.dart';

class AppPadding {
  // Standard padding values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Default padding
  static const double defaultPadding = md;

  // Horizontal padding
  static const double horizontalPadding = md;
  static const EdgeInsets horizontalPaddingEdgeInsets =
      EdgeInsets.symmetric(horizontal: horizontalPadding);

  // Vertical padding
  static const double verticalPadding = md;
  static const EdgeInsets verticalPaddingEdgeInsets =
      EdgeInsets.symmetric(vertical: verticalPadding);

  // All around padding
  static const EdgeInsets allPadding = EdgeInsets.all(defaultPadding);
  static const EdgeInsets allSmallPadding = EdgeInsets.all(sm);
  static const EdgeInsets allLargePadding = EdgeInsets.all(lg);

  // Symmetric padding
  static const EdgeInsets symmetricPadding = EdgeInsets.symmetric(
    horizontal: horizontalPadding,
    vertical: verticalPadding,
  );

  // Responsive padding methods
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return const EdgeInsets.symmetric(horizontal: sm);
    } else if (screenWidth < 900) {
      return const EdgeInsets.symmetric(horizontal: md);
    } else {
      return const EdgeInsets.symmetric(horizontal: lg);
    }
  }

  static EdgeInsets getResponsiveVerticalPadding(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 800) {
      return const EdgeInsets.symmetric(vertical: sm);
    } else if (screenHeight < 1200) {
      return const EdgeInsets.symmetric(vertical: md);
    } else {
      return const EdgeInsets.symmetric(vertical: lg);
    }
  }

  static EdgeInsets getResponsiveAllPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return const EdgeInsets.all(sm);
    } else if (screenWidth < 900) {
      return const EdgeInsets.all(md);
    } else {
      return const EdgeInsets.all(lg);
    }
  }
}

class AppSpacing {
  // Standard spacing values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Grid spacing
  static const double gridSpacing = sm;
  static const double gridCrossAxisSpacing = sm;
  static const double gridMainAxisSpacing = sm;
}
