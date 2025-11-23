// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/utils/colors.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../controllers/main_page_controller.dart';

class MainPageView extends GetView<MainPageController> {
  const MainPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for a more immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: child,
                    );
                  },
                  child: Obx(() =>
                      controller.mainContents[controller.activeIndex.value]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavBar(),
    );
  }

  Widget _buildModernBottomNavBar() {
    return Container(
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.activeIndex.value,
            onTap: (int i) => controller.navigateToPage(i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: cornFlower,
            unselectedItemColor: Colors.grey[600],
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,
                    color: controller.activeIndex.value == 0
                        ? cornFlower
                        : Colors.grey[600]),
                activeIcon: Icon(Icons.home, color: cornFlower),
                label: t.app.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.featured_play_list_outlined,
                    color: controller.activeIndex.value == 1
                        ? cornFlower
                        : Colors.grey[600]),
                activeIcon: Icon(Icons.featured_play_list, color: cornFlower),
                label: t.app.collections,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined,
                    color: controller.activeIndex.value == 2
                        ? cornFlower
                        : Colors.grey[600]),
                activeIcon: Icon(Icons.settings, color: cornFlower),
                label: t.app.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
