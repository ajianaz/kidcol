import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/dialog.dart';

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
    dialogKonfirmasi(
        title: "Konfirmasi",
        subtitle: "Apa anda yakin akan menghapus data tersebut?",
        onConfirm: () {
          Get.back();
          deleteKoleksiData();
        },
        textConfirm: "Hapus");
  }

  Future<void> deleteKoleksiData() async {
    try {
      await service.deleteKoleksi(koleksi);
      dialogKonfirmasi(
          title: "Perhatian",
          subtitle: "Berhasil menghapus data.",
          onConfirm: () {
            Get.back();
            Get.back();
          });
    } catch (e) {
      debugPrint("Error deleting koleksi: $e");
      // Show error to user
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
