import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';

class KoleksiGambarController extends GetxController {
  late Koleksi koleksi;
  IsarService service = IsarService();

  List<Gambar> gambars = List.empty(growable: true);

  getGambarKoleksi(Koleksi koleksi) async {
    gambars = await service.getGambarKoleksi(koleksi);
    update();
  }

  deleteGambarKoleksi(Gambar gambar){
    service.deleteGambar(gambar);
    getGambarKoleksi(koleksi);
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      koleksi = Get.arguments;
      debugPrint("Data Diterima: ${koleksi.title}");
      getGambarKoleksi(koleksi);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
