import 'package:flutter/material.dart';

/// App Theme Colors
/// Centralized color management for consistent UI across the app
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xff546de5); // Cornflower Blue
  static const Color primaryLight = Color(0xff7b8ff0);
  static const Color primaryDark = Color(0xff3d4fb8);

  // Secondary Colors
  static const Color secondary = Color(0xff3dc1d3); // Blue Curacao
  static const Color secondaryLight = Color(0xff6dd5e4);
  static const Color secondaryDark = Color(0xff2a9aa8);

  // Accent Colors
  static const Color accent = Color(0xffff6b81); // Pastel Red
  static const Color accentLight = Color(0xffff8fa3);
  static const Color accentDark = Color(0xffe5495f);

  // Success, Warning, Error
  static const Color success = Color(0xff26de81); // Green
  static const Color successLight = Color(0xff5ee8a5);
  static const Color successDark = Color(0xff1bb968);

  static const Color warning = Color(0xfffeca57); // Yellow
  static const Color warningLight = Color(0xfffed97b);
  static const Color warningDark = Color(0xffe5b13f);

  static const Color error = Color(0xffff6348); // Red
  static const Color errorLight = Color(0xffff8570);
  static const Color errorDark = Color(0xffe54833);

  static const Color info = Color(0xff4bcffa); // Light Blue
  static const Color infoLight = Color(0xff73dafb);
  static const Color infoDark = Color(0xff35b8e0);

  // Neutral Colors
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  static const Color grey50 = Color(0xfffafafa);
  static const Color grey100 = Color(0xfff5f5f5);
  static const Color grey200 = Color(0xffeeeeee);
  static const Color grey300 = Color(0xffe0e0e0);
  static const Color grey400 = Color(0xffbdbdbd);
  static const Color grey500 = Color(0xff9e9e9e);
  static const Color grey600 = Color(0xff757575);
  static const Color grey700 = Color(0xff616161);
  static const Color grey800 = Color(0xff424242);
  static const Color grey900 = Color(0xff212121);

  // Background Colors
  static const Color background = Color(0xffffffff);
  static const Color backgroundLight = Color(0xfffafafa);
  static const Color backgroundDark = Color(0xfff5f5f5);

  // Surface Colors
  static const Color surface = Color(0xffffffff);
  static const Color surfaceLight = Color(0xfffafafa);
  static const Color surfaceDark = Color(0xffeeeeee);

  // Text Colors
  static const Color textPrimary = Color(0xff212121);
  static const Color textSecondary = Color(0xff757575);
  static const Color textTertiary = Color(0xff9e9e9e);
  static const Color textDisabled = Color(0xffbdbdbd);
  static const Color textOnPrimary = Color(0xffffffff);
  static const Color textOnSecondary = Color(0xffffffff);

  // Border Colors
  static const Color border = Color(0xffe0e0e0);
  static const Color borderLight = Color(0xffeeeeee);
  static const Color borderDark = Color(0xffbdbdbd);

  // Shadow Colors
  static const Color shadow = Color(0x1a000000);
  static const Color shadowLight = Color(0x0d000000);
  static const Color shadowDark = Color(0x33000000);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x4d000000);
  static const Color overlayDark = Color(0xb3000000);

  // Gradient Colors
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer Colors
  static const Color shimmerBase = Color(0xffe0e0e0);
  static const Color shimmerHighlight = Color(0xfff5f5f5);

  // Deprecated - for backward compatibility
  @Deprecated('Use AppColors.secondary instead')
  static const Color blueCuracao = secondary;

  @Deprecated('Use AppColors.primary instead')
  static const Color cornFlower = primary;
}

/// App Theme Configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryLight,
        tertiary: AppColors.accent,
        tertiaryContainer: AppColors.accentLight,
        error: AppColors.error,
        errorContainer: AppColors.errorLight,
        surface: AppColors.surface,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey800,
        contentTextStyle: TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
