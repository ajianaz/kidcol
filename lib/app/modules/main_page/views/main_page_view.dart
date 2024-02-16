// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/utils/colors.dart';
import 'package:kidcol/app/utils/navbot_style.dart';

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
        bottomNavigationBar: StyleProvider(
          style: Style(),
          child: ConvexAppBar(
            backgroundColor: blueCuracao,
            // activeColor: Colors.transparent,
            // color: Colors.amber,
            top: 0.0,
            items: [
              TabItem(icon: Icons.home, title: 'Home'),
              TabItem(icon: Icons.featured_play_list, title: 'Koleksi'),
              // TabItem(icon: Icons.people, title: 'Profile'),
            ],
            onTap: (int i) => controller.activeIndex.value = i,
          ),
        ),
        body: Obx(() => controller.mainContents[controller.activeIndex.value]));
  }
}
