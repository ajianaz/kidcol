import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Controller
/// Manages app theme (light/dark mode) with persistent storage
class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';

  // Observable theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme != null) {
        _themeMode.value =
            savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
        Get.changeThemeMode(_themeMode.value);
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(_themeMode.value);
    await _saveThemeMode();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _saveThemeMode();
  }

  /// Save theme mode to shared preferences
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, isDarkMode ? 'dark' : 'light');
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }
}
