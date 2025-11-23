import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:kidcol/i18n/translations.g.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.startTimer;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/launcher/ic_launcher.png',
                  height: 250,
                  width: 250,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  t.app.name,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  t.home.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
