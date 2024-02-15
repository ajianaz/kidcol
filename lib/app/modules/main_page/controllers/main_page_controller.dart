import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/modules/home/views/home_view.dart';
import 'package:kidcol/app/modules/koleksi/views/koleksi_view.dart';
// import 'package:kidcol/app/modules/profile/views/profile_view.dart';

class MainPageController extends GetxController {
  final List<Widget> mainContents = [
    HomeView(),
    KoleksiView(),
    // ProfileView()
  ];

  RxInt activeIndex = RxInt(0);

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
