import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");

  runApp(
    GetMaterialApp(
      title: "KidCol",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
