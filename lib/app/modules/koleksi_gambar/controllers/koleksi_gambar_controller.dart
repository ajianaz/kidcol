import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/app_dialogs.dart';
import 'package:kidcol/app/utils/error_handler.dart';
import 'package:kidcol/app/utils/logger.dart';
import 'package:kidcol/i18n/translations.g.dart';

class KoleksiGambarController extends GetxController {
  late Koleksi koleksi;
  IsarService service = Get.find<IsarService>();

  // List<Gambar> gambars = List.empty(growable: true);

  // getGambarKoleksi(Koleksi koleksi) async {
  //   gambars = await service.getGambarKoleksi(koleksi);
  //   update();
  // }

  Future<void> deleteGambarKoleksi(Gambar gambar) async {
    try {
      await service.deleteGambar(gambar);
      // getGambarKoleksi(koleksi);
    } catch (e) {
      AppErrorHandler.handleError(e,
          context: 'KoleksiGambarController.deleteGambarKoleksi');
    }
  }

  konfirmasiHapusKoleksi() {
    AppDialogs.showDeleteConfirmation(
      title: t.common.confirm,
      message: t.messages.confirm_delete,
      confirmText: t.common.delete,
      onConfirm: () => deleteKoleksiData(),
    );
  }

  Future<void> deleteKoleksiData() async {
    try {
      await service.deleteKoleksi(koleksi);

      // Show success and navigate back
      AppDialogs.showSuccess(
        title: t.common.success,
        message: t.messages.collection_deleted,
        onConfirm: () {
          Get.back(); // Close dialog
          Get.back(); // Go back to previous screen
        },
      );
    } catch (e) {
      AppErrorHandler.handleError(e,
          context: 'KoleksiGambarController.deleteKoleksiData');
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      koleksi = Get.arguments;
      Logger.log("Data Diterima: ${koleksi.title}",
          tag: 'KoleksiGambarController');
      // getGambarKoleksi(koleksi);
    }
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
