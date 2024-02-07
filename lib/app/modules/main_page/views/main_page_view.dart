// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_page_controller.dart';

class MainPageView extends GetView<MainPageController> {
  const MainPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kids Colouring'),
          centerTitle: true,
        ),
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.collections, title: 'Koleksi'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          onTap: (int i) => controller.activeIndex.value = i,
        ),
        body: Obx(() => controller.mainContents[controller.activeIndex.value]));
  }
}
