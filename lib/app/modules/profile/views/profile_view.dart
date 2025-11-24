import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/controllers/theme_controller.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          Card(
            child: Column(
              children: [
                // Language Toggle
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(t.settings.language),
                  trailing: Obx(() => Switch(
                        value: controller.isEnglish.value,
                        onChanged: (value) => controller.toggleLanguage(),
                      )),
                  subtitle: Obx(() => Text(
                        controller.isEnglish.value
                            ? t.settings.english
                            : t.settings.indonesian,
                      )),
                ),
                const Divider(),
                // Dark Mode Toggle
                ListTile(
                  leading: Obx(() => Icon(
                        themeController.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      )),
                  title: const Text('Dark Mode'),
                  trailing: Obx(() => Switch(
                        value: themeController.isDarkMode,
                        onChanged: (value) => themeController.toggleTheme(),
                      )),
                  subtitle: Obx(() => Text(
                        themeController.isDarkMode ? 'Dark' : 'Light',
                      )),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Links Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(t.settings.terms_of_service),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => controller.openTermsOfService(),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(t.settings.privacy_policy),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => controller.openPrivacyPolicy(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Device ID Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.device_hub),
              title: Text(t.settings.device_id),
              subtitle: Obx(() => Text(
                    controller.deviceId.value,
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  )),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => controller.copyDeviceId(),
                tooltip: t.settings.copy_device_id,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(t.settings.about),
              subtitle: Text('${t.settings.version} 1.1.0+3-b'),
            ),
          ),
        ],
      ),
    );
  }
}
