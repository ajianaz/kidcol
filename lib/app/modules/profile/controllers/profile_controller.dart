import 'package:get/get.dart';
import 'package:kidcol/i18n/translations.g.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final isEnglish = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize language based on current locale
    isEnglish.value = LocaleSettings.currentLocale == AppLocale.en;
  }

  void toggleLanguage() {
    if (isEnglish.value) {
      LocaleSettings.setLocale(AppLocale.id);
    } else {
      LocaleSettings.setLocale(AppLocale.en);
    }
    isEnglish.toggle();
  }

  void openFAQ() async {
    const url = 'https://example.com/faq';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(t.common.error, t.messages.error_occurred);
    }
  }

  void openTermsOfService() async {
    const url = 'https://example.com/terms';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(t.common.error, t.messages.error_occurred);
    }
  }

  void openPrivacyPolicy() async {
    const url = 'https://example.com/privacy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(t.common.error, t.messages.error_occurred);
    }
  }
}
