import 'dart:async';

import 'package:get/get.dart';
import 'package:kidcol/app/routes/app_pages.dart';
import 'package:kidcol/app/utils/dialog.dart';
import 'package:kidcol/app/utils/logger.dart';
import 'package:kidcol/i18n/translations.g.dart';

class SplashScreenController extends GetxController {
  startTimer() {
    Logger.log("Timer started: 3 seconds", tag: 'SplashScreenController');
    Timer(const Duration(seconds: 3), () {
      Logger.log("Timer finished", tag: 'SplashScreenController');
      checkDate();
    });
  }

  void checkDate() {
    Logger.log("Checking date...", tag: 'SplashScreenController');
    DateTime currentDate = DateTime.now();
    DateTime checkDate = DateTime(2026, 05, 05);

    Logger.log("Current: $currentDate, Check: $checkDate",
        tag: 'SplashScreenController');

    if (currentDate.isAfter(checkDate)) {
      Logger.warning("Update needed", tag: 'SplashScreenController');
      needUpdate();
    } else {
      Logger.log("Navigating to MAIN_PAGE", tag: 'SplashScreenController');
      Get.offNamed(Routes.MAIN_PAGE);
    }
  }

  void needUpdate() {
    // Add logic or functions to execute if an update is needed here
    dialogPopUp(
        title: t.common.warning,
        subtitle: t.messages.update_available,
        onCancel: () {
          Get.back();
        });
  }

  @override
  void onInit() {
    super.onInit();
    Logger.log("Controller initialized", tag: 'SplashScreenController');
    startTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
