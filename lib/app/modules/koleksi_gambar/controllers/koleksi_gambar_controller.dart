import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/app_dialogs.dart';
import 'package:kidcol/i18n/translations.g.dart';

class KoleksiGambarController extends GetxController {
  late Koleksi koleksi;
  IsarService service = IsarService();

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
      debugPrint("Error deleting gambar: $e");
      // Show error to user
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
      debugPrint("Error deleting koleksi: $e");

      // Show error to user
      AppDialogs.showError(
        title: t.common.error,
        message: 'Failed to delete collection',
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      koleksi = Get.arguments;
      debugPrint("Data Diterima: ${koleksi.title}");
      // getGambarKoleksi(koleksi);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Close database connection when controller is disposed
    service.close();
    super.onClose();
  }
}
