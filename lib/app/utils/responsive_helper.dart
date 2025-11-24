import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoint constants for easy reference
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopMaxContentWidth = 1200;

  // Helper method to determine responsive column count
  static int getCrossAxisCount(BuildContext context) {
    try {
      double screenWidth = MediaQuery.of(context).size.width;

      // Ensure minimum width to prevent layout errors
      if (screenWidth <= 0) {
        debugPrint(
            'Warning: Invalid screen width detected: $screenWidth, using default');
        return 2; // Default to mobile layout
      }

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
    } catch (e) {
      debugPrint('Error in getCrossAxisCount: $e, returning default value');
      return 2; // Default to mobile layout on error
    }
  }

  // Helper method to determine if device is mobile
  static bool isMobile(BuildContext context) {
    try {
      double width = MediaQuery.of(context).size.width;
      return width < mobileBreakpoint;
    } catch (e) {
      debugPrint('Error in isMobile: $e, returning true (mobile)');
      return true; // Default to mobile on error
    }
  }

  // Helper method to determine if device is tablet
  static bool isTablet(BuildContext context) {
    try {
      double width = MediaQuery.of(context).size.width;
      return width >= mobileBreakpoint && width < tabletBreakpoint;
    } catch (e) {
      debugPrint('Error in isTablet: $e, returning false');
      return false; // Default to not tablet on error
    }
  }

  // Helper method to determine if device is desktop
  static bool isDesktop(BuildContext context) {
    try {
      double width = MediaQuery.of(context).size.width;
      return width >= tabletBreakpoint;
    } catch (e) {
      debugPrint('Error in isDesktop: $e, returning false');
      return false; // Default to not desktop on error
    }
  }

  /// Returns the maximum width for content on desktop (1200px)
  /// For mobile and tablet, returns the full screen width
  static double getMaxContentWidth(BuildContext context) {
    try {
      double screenWidth = MediaQuery.of(context).size.width;

      // Ensure minimum width to prevent layout errors
      if (screenWidth <= 0) {
        debugPrint(
            'Warning: Invalid screen width detected: $screenWidth, using default');
        return 600; // Default mobile width
      }

      if (isDesktop(context)) {
        return desktopMaxContentWidth;
      }
      return screenWidth;
    } catch (e) {
      debugPrint('Error in getMaxContentWidth: $e, returning default value');
      return 600; // Default mobile width on error
    }
  }

  /// Returns padding for centering content on desktop
  /// For desktop: calculates horizontal padding to center content within max width
  /// For mobile and tablet: returns default padding
  static EdgeInsets getCenteredContentPadding(BuildContext context) {
    try {
      double screenWidth = MediaQuery.of(context).size.width;

      // Ensure minimum width to prevent layout errors
      if (screenWidth <= 0) {
        debugPrint(
            'Warning: Invalid screen width detected: $screenWidth, using default padding');
        return const EdgeInsets.all(16.0);
      }

      if (isDesktop(context)) {
        double horizontalPadding = (screenWidth - desktopMaxContentWidth) / 2;
        // Ensure minimum padding of 16px
        horizontalPadding = horizontalPadding.clamp(16.0, double.infinity);
        return EdgeInsets.symmetric(horizontal: horizontalPadding);
      }

      // Default padding for mobile and tablet
      return const EdgeInsets.all(16.0);
    } catch (e) {
      debugPrint(
          'Error in getCenteredContentPadding: $e, returning default padding');
      return const EdgeInsets.all(16.0);
    }
  }

  /// Returns the appropriate navigation type based on screen size
  /// - Mobile: BottomNavigationBar
  /// - Tablet: NavigationRail
  /// - Desktop: NavigationRail or Drawer based on preference
  static String getAdaptiveNavigationType(BuildContext context) {
    if (isMobile(context)) {
      return 'bottomNav';
    } else if (isTablet(context)) {
      return 'navigationRail';
    } else {
      // Desktop
      return 'navigationRail';
    }
  }

  /// Returns responsive dialog width based on screen size
  /// - Mobile: Full width with small margin
  /// - Tablet: 80% of screen width
  /// - Desktop: Fixed width of 500px or 50% of screen width, whichever is smaller
  static double getResponsiveDialogWidth(BuildContext context) {
    try {
      double screenWidth = MediaQuery.of(context).size.width;

      // Ensure minimum width to prevent layout errors
      if (screenWidth <= 0) {
        debugPrint(
            'Warning: Invalid screen width detected: $screenWidth, using default dialog width');
        return 300; // Default dialog width
      }

      if (isMobile(context)) {
        return (screenWidth - 32).clamp(
            200.0, double.infinity); // Full width with 16px margin on each side
      } else if (isTablet(context)) {
        return (screenWidth * 0.8).clamp(300.0, 600.0);
      } else {
        // Desktop
        return (screenWidth * 0.5).clamp(400.0, 600.0);
      }
    } catch (e) {
      debugPrint(
          'Error in getResponsiveDialogWidth: $e, returning default dialog width');
      return 300; // Default dialog width on error
    }
  }

  /// Returns responsive container width with max width constraint
  /// Useful for creating centered layouts with maximum width
  /// - Mobile: Full width
  /// - Tablet: Full width
  /// - Desktop: Max width of 1200px, centered
  static double getResponsiveContainerWidth(BuildContext context) {
    try {
      double screenWidth = MediaQuery.of(context).size.width;

      // Ensure minimum width to prevent layout errors
      if (screenWidth <= 0) {
        debugPrint(
            'Warning: Invalid screen width detected: $screenWidth, using default container width');
        return 600; // Default container width
      }

      if (isDesktop(context)) {
        return screenWidth > desktopMaxContentWidth
            ? desktopMaxContentWidth
            : screenWidth;
      }
      return screenWidth;
    } catch (e) {
      debugPrint(
          'Error in getResponsiveContainerWidth: $e, returning default container width');
      return 600; // Default container width on error
    }
  }

  /// Returns a BoxConstraints object for responsive container
  /// Useful for ConstrainedBox or Container widgets
  static BoxConstraints getResponsiveContainerConstraints(
      BuildContext context) {
    try {
      double maxWidth = getResponsiveContainerWidth(context);
      double minWidth =
          isMobile(context) ? 0 : 300; // Minimum width for tablet and desktop

      // Ensure reasonable constraints to prevent layout errors
      maxWidth = maxWidth.clamp(200.0, double.infinity);
      minWidth = minWidth.clamp(0.0, maxWidth);

      return BoxConstraints(
        maxWidth: maxWidth,
        minWidth: minWidth,
      );
    } catch (e) {
      debugPrint(
          'Error in getResponsiveContainerConstraints: $e, returning default constraints');
      return const BoxConstraints(
        minWidth: 0,
        maxWidth: double.infinity,
      );
    }
  }

  /// Returns whether to use centered layout on desktop
  /// This can be used to conditionally apply centered layouts
  static bool shouldUseCenteredLayout(BuildContext context) {
    try {
      return isDesktop(context);
    } catch (e) {
      debugPrint('Error in shouldUseCenteredLayout: $e, returning false');
      return false; // Default to not centered on error
    }
  }

  /// Safe method to get screen size with error handling
  static Size getScreenSize(BuildContext context) {
    try {
      return MediaQuery.of(context).size;
    } catch (e) {
      debugPrint('Error getting screen size: $e, returning default size');
      return const Size(600, 800); // Default mobile size
    }
  }

  /// Safe method to check if context is still valid
  static bool isContextValid(BuildContext context) {
    try {
      return context.mounted && MediaQuery.of(context).size.width > 0;
    } catch (e) {
      debugPrint('Error checking context validity: $e');
      return false;
    }
  }

  /// Debounce helper for resize events to prevent excessive rebuilds
  static Duration getResizeDebounceDuration() {
    return const Duration(milliseconds: 300);
  }

  /// Method to handle layout changes safely
  static void handleLayoutChange(
    BuildContext context,
    VoidCallback onLayoutChanged,
  ) {
    if (isContextValid(context)) {
      try {
        onLayoutChanged();
      } catch (e) {
        debugPrint('Error handling layout change: $e');
      }
    }
  }
}
