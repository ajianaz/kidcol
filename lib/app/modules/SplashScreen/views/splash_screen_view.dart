import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
                  "Kids Coloring Zone",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Unleash creativity together \nwith your little ones",
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
