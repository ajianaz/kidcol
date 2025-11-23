import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/routes/app_pages.dart';
import 'i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize slang
  LocaleSettings.setLocale(AppLocale.en);

  runApp(
    TranslationProvider(
      child: GetMaterialApp(
        title: "Kids Coloring Zone",
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocaleUtils.supportedLocales,
        locale: LocaleSettings.currentLocale.flutterLocale,
      ),
    ),
  );
}
