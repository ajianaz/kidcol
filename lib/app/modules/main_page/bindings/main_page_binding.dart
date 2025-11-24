import 'package:get/get.dart';
import 'package:kidcol/app/modules/setting/controllers/setting_controller.dart';

import '../controllers/main_page_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../koleksi/controllers/koleksi_controller.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainPageController>(
      () => MainPageController(),
      fenix: true,
    );
    // Register child controllers so they're available when views are rendered
    // Use fenix:true to prevent disposal during rebuilds (e.g., window resize)
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<KoleksiController>(
      () => KoleksiController(),
      fenix: true,
    );
    Get.lazyPut<SettingController>(
      () => SettingController(),
      fenix: true,
    );
  }
}
