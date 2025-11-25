import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/logger.dart';
import 'package:kidcol/i18n/translations.g.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingPdfController extends GetxController {
  late Koleksi koleksi;
  IsarService service = Get.find<IsarService>();

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
      Logger.log("Data Total: ${gambars.length}", tag: 'PrintingPdfController');
      addImage();
      update();
    } catch (e) {
      Logger.error("Error getting gambar koleksi: $e",
          tag: 'PrintingPdfController', error: e);
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

    Logger.log("Starting to process ${gambars.length} images one by one",
        tag: 'PrintingPdfController');

    for (int i = 0; i < gambars.length; i++) {
      try {
        Logger.log(
            "Processing image ${i + 1}/${gambars.length}: ${gambars[i].endpoint}",
            tag: 'PrintingPdfController');

        // Process image one by one
        var netImage = await networkImage("${gambars[i].endpoint}");
        netImages.add(netImage);

        // Update progress
        processedImages.value = i + 1;
        imageProcessingProgress.value = (i + 1) / gambars.length;

        Logger.log("Successfully processed image ${i + 1}/${gambars.length}",
            tag: 'PrintingPdfController');

        // Add a small delay between processing images to prevent memory spikes
        if (i < gambars.length - 1) {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Update UI after each image is processed
        update();
      } catch (e) {
        Logger.error("Error processing image ${i + 1}: $e",
            tag: 'PrintingPdfController', error: e);
        processingError.value =
            "${t.error.failed_to_load_images} ${i + 1}: ${e.toString()}";
        // Continue processing other images even if one fails
      }
    }

    isProcessingImages.value = false;
    Logger.log(
        "Finished processing images. Total processed: ${netImages.length}",
        tag: 'PrintingPdfController');
    update();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      koleksi = Get.arguments;
      Logger.log("Data Diterima: ${koleksi.title}",
          tag: 'PrintingPdfController');
      getGambarKoleksi(koleksi);
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
