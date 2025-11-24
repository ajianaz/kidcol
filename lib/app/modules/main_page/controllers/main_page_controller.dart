import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/modules/home/views/home_view.dart';
import 'package:kidcol/app/modules/koleksi/views/koleksi_view.dart';
import 'package:kidcol/app/modules/setting/views/setting_view.dart';

class MainPageController extends GetxController {
  // Use getter instead of final list to ensure controllers are available
  List<Widget> get mainContents =>
      [const HomeView(), KoleksiView(), const SettingView()];

  RxInt activeIndex = RxInt(0);

  void navigateToPage(int index) {
    debugPrint(
        'MainPageController: navigateToPage called with index: $index, current activeIndex: ${activeIndex.value}');
    activeIndex.value = index;
    debugPrint(
        'MainPageController: activeIndex updated to: ${activeIndex.value}');
  }
}
