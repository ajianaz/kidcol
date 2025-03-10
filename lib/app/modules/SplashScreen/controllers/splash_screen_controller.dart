import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/routes/app_pages.dart';
import 'package:kidcol/app/utils/dialog.dart';

class SplashScreenController extends GetxController {
  startTimer() {
    Timer(Duration(seconds: 3), () {
      // Navigasi ke halaman berikutnya
      checkDate();
    });
  }

  void checkDate() {
    debugPrint("Check Date Running");
    DateTime currentDate = DateTime.now();
    DateTime checkDate = DateTime(2026, 05, 05);

    debugPrint("Hari : $checkDate - $currentDate");

    if (currentDate.isAfter(checkDate)) {
      needUpdate();
    } else {
      Get.offAndToNamed(Routes.MAIN_PAGE);
    }
  }

  void needUpdate() {
    // Add logic or functions to execute if an update is needed here
    dialogPopUp(
        title: "Notification",
        subtitle: "An update is available. Please update the app.",
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
