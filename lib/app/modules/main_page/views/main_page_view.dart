// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/utils/colors.dart';
import 'package:kidcol/app/utils/navbot_style.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../controllers/main_page_controller.dart';

class MainPageView extends GetView<MainPageController> {
  const MainPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(t.app.name),
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
              TabItem(icon: Icons.home, title: t.app.home),
              TabItem(icon: Icons.featured_play_list, title: t.app.collections),
              TabItem(icon: Icons.settings, title: t.app.settings),
            ],
            onTap: (int i) => controller.navigateToPage(i),
          ),
        ),
        body: Obx(() => controller.mainContents[controller.activeIndex.value]));
  }
}
