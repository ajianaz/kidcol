import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/error_handler.dart';

class KoleksiController extends GetxController {
  final service = Get.find<IsarService>();

  Future<void> simpanKoleksi(String value) async {
    try {
      final data = Koleksi()..title = value;
      await service.saveKoleksi(data);
      // Optionally show success message
    } catch (e) {
      AppErrorHandler.handleError(e,
          context: 'KoleksiController.simpanKoleksi');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Don't close database - singleton instance is shared across all controllers
    super.onClose();
  }
}
