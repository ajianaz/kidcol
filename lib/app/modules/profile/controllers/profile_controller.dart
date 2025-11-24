import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kidcol/i18n/translations.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final isEnglish = true.obs;
  final deviceId = ''.obs;
  static const String _deviceIdKey = 'kidcol_device_id';

  @override
  void onInit() {
    super.onInit();
    // Initialize language based on current locale
    isEnglish.value = LocaleSettings.currentLocale == AppLocale.en;
    // Initialize device ID
    _initializeDeviceId();
  }

  Future<void> _initializeDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if device ID already exists
      String? storedDeviceId = prefs.getString(_deviceIdKey);
      if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
        deviceId.value = storedDeviceId;
        return;
      }

      // Generate new device ID if not exists
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String newDeviceId;

      if (Theme.of(Get.context!).platform == TargetPlatform.android) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // Use androidId as the base for device ID
        final androidId = androidInfo.id;
        newDeviceId = 'KIDCOL-ANDROID-${androidId.substring(0, 8)}';
      } else if (Theme.of(Get.context!).platform == TargetPlatform.iOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        // Use identifierForVendor as the base for device ID
        final identifierForVendor = iosInfo.identifierForVendor ?? 'UNKNOWN';
        newDeviceId = 'KIDCOL-IOS-${identifierForVendor.substring(0, 8)}';
      } else {
        // Fallback for other platforms
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final randomSuffix = timestamp.substring(timestamp.length - 8);
        newDeviceId = 'KIDCOL-OTHER-${randomSuffix}';
      }

      // Store the device ID
      await prefs.setString(_deviceIdKey, newDeviceId);
      deviceId.value = newDeviceId;
    } catch (e) {
      // Fallback in case of any error
      try {
        final prefs = await SharedPreferences.getInstance();
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final randomSuffix = timestamp.substring(timestamp.length - 8);
        final fallbackId = 'KIDCOL-FALLBACK-${randomSuffix}';

        await prefs.setString(_deviceIdKey, fallbackId);
        deviceId.value = fallbackId;
      } catch (e) {
        // Last resort fallback
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final randomSuffix = timestamp.substring(timestamp.length - 8);
        deviceId.value = 'KIDCOL-EMERGENCY-${randomSuffix}';
      }
    }
  }

  void toggleLanguage() {
    if (isEnglish.value) {
      LocaleSettings.setLocale(AppLocale.id);
    } else {
      LocaleSettings.setLocale(AppLocale.en);
    }
    isEnglish.toggle();
  }

  void openTermsOfService() async {
    const url = 'https://ajianaz.dev/kidcol-terms-of-service/';
    if (!await launchUrl(Uri.parse(url))) {
      Get.snackbar(t.common.error, t.messages.error_occurred);
    }
  }

  void openPrivacyPolicy() async {
    const url = 'https://ajianaz.dev/kidcol-privacy-policy/';
    if (!await launchUrl(Uri.parse(url))) {
      Get.snackbar(t.common.error, t.messages.error_occurred);
    }
  }

  void copyDeviceId() async {
    await Clipboard.setData(ClipboardData(text: deviceId.value));
    Get.snackbar(
      t.settings.device_id_copied,
      '',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
