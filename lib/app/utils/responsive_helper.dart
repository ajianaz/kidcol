import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Helper method to determine responsive column count
  static int getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mobile
      return 2;
    } else if (screenWidth < 900) {
      // Tablet
      return 3;
    } else if (screenWidth < 1200) {
      // Small Desktop
      return 4;
    } else {
      // Large Desktop
      return 5;
    }
  }

  // Helper method to determine if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Helper method to determine if device is tablet
  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  // Helper method to determine if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }
}
