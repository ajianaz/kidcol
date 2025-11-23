import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/i18n/translations.g.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingPdfController extends GetxController {
  late Koleksi koleksi;
  IsarService service = IsarService();

  List<Gambar> gambars = List.empty(growable: true);

  List<pw.ImageProvider> netImages = List.empty(growable: true);

  // Progress tracking variables
  var isProcessingImages = false.obs;
  var imageProcessingProgress = 0.0.obs;
  var totalImages = 0.obs;
  var processedImages = 0.obs;
  var processingError = ''.obs;

  getGambarKoleksi(Koleksi koleksi) async {
    try {
      gambars = await service.getGambarKoleksi(koleksi);
      totalImages.value = gambars.length;
      debugPrint("Data Total: ${gambars.length}");
      addImage();
      update();
    } catch (e) {
      debugPrint("Error getting gambar koleksi: $e");
      processingError.value =
          "${t.error.failed_to_load_images}: ${e.toString()}";
      update();
    }
  }

  addImage() async {
    if (gambars.isEmpty) return;

    isProcessingImages.value = true;
    imageProcessingProgress.value = 0.0;
    processedImages.value = 0;
    processingError.value = '';
    netImages.clear();

    debugPrint("Starting to process ${gambars.length} images one by one");

    for (int i = 0; i < gambars.length; i++) {
      try {
        debugPrint(
            "Processing image ${i + 1}/${gambars.length}: ${gambars[i].endpoint}");

        // Process image one by one
        var netImage = await networkImage("${gambars[i].endpoint}");
        netImages.add(netImage);

        // Update progress
        processedImages.value = i + 1;
        imageProcessingProgress.value = (i + 1) / gambars.length;

        debugPrint("Successfully processed image ${i + 1}/${gambars.length}");

        // Add a small delay between processing images to prevent memory spikes
        if (i < gambars.length - 1) {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Update UI after each image is processed
        update();
      } catch (e) {
        debugPrint("Error processing image ${i + 1}: $e");
        processingError.value =
            "${t.error.failed_to_load_images} ${i + 1}: ${e.toString()}";
        // Continue processing other images even if one fails
      }
    }

    isProcessingImages.value = false;
    debugPrint(
        "Finished processing images. Total processed: ${netImages.length}");
    update();
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
    // Close database connection when controller is disposed
    service.close();
    super.onClose();
  }
}
