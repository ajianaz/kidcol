import 'package:get/get.dart';

import '../modules/SplashScreen/bindings/splash_screen_binding.dart';
import '../modules/SplashScreen/views/splash_screen_view.dart';
import '../modules/drawing_room/bindings/drawing_room_binding.dart';
import '../modules/drawing_room/views/drawing_room_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/koleksi/bindings/koleksi_binding.dart';
import '../modules/koleksi/views/koleksi_view.dart';
import '../modules/koleksi_gambar/bindings/koleksi_gambar_binding.dart';
import '../modules/koleksi_gambar/views/koleksi_gambar_view.dart';
import '../modules/main_page/bindings/main_page_binding.dart';
import '../modules/main_page/views/main_page_view.dart';
import '../modules/printing_pdf/bindings/printing_pdf_binding.dart';
import '../modules/printing_pdf/views/printing_pdf_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.KOLEKSI,
      page: () => KoleksiView(),
      binding: KoleksiBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_PAGE,
      page: () => const MainPageView(),
      binding: MainPageBinding(),
    ),
    GetPage(
      name: _Paths.KOLEKSI_GAMBAR,
      page: () => const KoleksiGambarView(),
      binding: KoleksiGambarBinding(),
    ),
    GetPage(
      name: _Paths.PRINTING_PDF,
      page: () => PrintingPdfView(),
      binding: PrintingPdfBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.DRAWING_ROOM,
      page: () => const DrawingRoomView(),
      binding: DrawingRoomBinding(),
    ),
  ];
}
