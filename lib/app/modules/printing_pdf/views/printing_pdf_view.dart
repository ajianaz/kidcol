import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../controllers/printing_pdf_controller.dart';

class PrintingPdfView extends GetView<PrintingPdfController> {
  PrintingPdfView({super.key});

  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrintingPdfController>(
        init: PrintingPdfController(),
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(t.printing.title),
              centerTitle: true,
            ),
            body: Column(
              children: [
                // Progress indicator section
                if (controller.isProcessingImages.value)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "${t.printing.processing_images} ${controller.processedImages.value}/${controller.totalImages.value}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: controller.imageProcessingProgress.value,
                          backgroundColor: Theme.of(Get.context!)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(Get.context!).colorScheme.primary),
                        ),
                        const SizedBox(height: 8),
                        if (controller.processingError.value.isNotEmpty)
                          Text(
                            controller.processingError.value,
                            style: TextStyle(
                                color: Theme.of(Get.context!).colorScheme.error,
                                fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),

                // PDF preview or loading/not found message
                Expanded(
                  child: controller.gambars.isNotEmpty &&
                          !controller.isProcessingImages.value
                      ? PdfPreview(
                          dynamicLayout: false,
                          canChangePageFormat: false,
                          canChangeOrientation: false,
                          canDebug: false,
                          build: (format) => _generatePdf2(
                              format, t.printing.title, controller.gambars),
                        )
                      : controller.isProcessingImages.value
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(t.printing.preparing_images),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(t.printing.data_not_found),
                            ),
                ),
              ],
            ),
          );
        });
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, List<Gambar> gambars) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final font = await PdfGoogleFonts.nunitoExtraLight();

    debugPrint("Gambars : ${gambars.length}");

    debugPrint("Total Gambar : ${controller.netImages.length}");

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Container(
            child: pw.Flexible(
              child: pw.ListView.builder(
                itemCount: gambars.length,
                itemBuilder: (context, index) {
                  debugPrint("index : $index");

                  return pw.Container(
                    child: pw.Flexible(
                      child: pw.Image(controller.netImages[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generatePdf2(
      PdfPageFormat format, String title, List<Gambar> gambars) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
    );

    var size = 440.0;

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(1.0),
        pageFormat: const PdfPageFormat(
            21 * PdfPageFormat.cm, 33 * PdfPageFormat.cm,
            marginAll: 0.5 * PdfPageFormat.cm),
        build: (context) {
          return [
            pw.ListView.builder(
              itemCount: gambars.length,
              itemBuilder: (context, index) {
                debugPrint("index : $index");

                return pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Flexible(
                    child: pw.Column(children: [
                      pw.Image(
                        controller.netImages[index],
                        height: size,
                        width: size,
                      ),
                      pw.Text(t.printing.download_app_message),
                    ]),
                  ),
                );
              },
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
