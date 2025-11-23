import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/modules/home/views/home_view.dart';
import 'package:kidcol/app/modules/koleksi/views/koleksi_view.dart';
import 'package:kidcol/app/routes/app_pages.dart';

class MainPageController extends GetxController {
  final List<Widget> mainContents = [HomeView(), KoleksiView()];

  RxInt activeIndex = RxInt(0);

  void navigateToPage(int index) {
    if (index == 2) {
      // Navigate to Profile page with proper binding
      Get.toNamed(Routes.PROFILE);
    } else {
      activeIndex.value = index;
    }
  }

  @override
  void onInit() {
    super.onInit();
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
