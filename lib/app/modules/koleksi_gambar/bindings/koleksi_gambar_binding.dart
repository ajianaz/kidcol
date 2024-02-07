import 'package:get/get.dart';

import '../controllers/koleksi_gambar_controller.dart';

class KoleksiGambarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KoleksiGambarController>(
      () => KoleksiGambarController(),
    );
  }
}
