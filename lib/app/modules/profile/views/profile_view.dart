import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/i18n/strings.g.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          Card(
            child: ListTile(
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
          ),

          const SizedBox(height: 16),

          // Links Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(t.settings.faq),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => controller.openFAQ(),
                ),
                const Divider(),
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
