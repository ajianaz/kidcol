import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/routes/app_pages.dart';
import 'package:kidcol/app/utils/dialog.dart';
import 'package:kidcol/i18n/translations.g.dart';

class SplashScreenController extends GetxController {
  startTimer() {
    debugPrint("⏳ Timer started: 3 seconds");
    Timer(const Duration(seconds: 3), () {
      debugPrint("⏰ Timer finished");
      checkDate();
    });
  }

  void checkDate() {
    debugPrint("📅 Checking date...");
    DateTime currentDate = DateTime.now();
    DateTime checkDate = DateTime(2026, 05, 05);

    debugPrint("🗓 Current: $currentDate, Check: $checkDate");

    if (currentDate.isAfter(checkDate)) {
      debugPrint("⚠️ Update needed");
      needUpdate();
    } else {
      debugPrint("🚀 Navigating to MAIN_PAGE");
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
    debugPrint("init");
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
