import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/env_config.dart';
import 'app/data/services/account_service.dart';
import 'i18n/translations.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize environment configuration
  await EnvConfig.init();

  // Initialize GetX services
  Get.put(AccountService());

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
