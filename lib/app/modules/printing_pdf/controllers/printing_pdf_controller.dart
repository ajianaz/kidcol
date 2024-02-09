import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/app_string.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingPdfController extends GetxController {
  late Koleksi koleksi;
  IsarService service = IsarService();

  List<Gambar> gambars = List.empty(growable: true);

  List<pw.ImageProvider> netImages = List.empty(growable: true);

  getGambarKoleksi(Koleksi koleksi) async {
    gambars = await service.getGambarKoleksi(koleksi);
    // debugPrint("Data Total: ${gambars.length}");
    addImage();
    update();
  }

  addImage() async {
    gambars.forEach((element) async {
      var netImage = await networkImage("$baseUrl/images/${element.endpoint}");
      netImages.add(netImage);
      update();
    });
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
