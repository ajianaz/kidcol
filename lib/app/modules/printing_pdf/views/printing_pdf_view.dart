import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../controllers/printing_pdf_controller.dart';

class PrintingPdfView extends GetView<PrintingPdfController> {
  PrintingPdfView({Key? key}) : super(key: key);

  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrintingPdfController>(
        init: PrintingPdfController(),
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cetak PDF'),
              centerTitle: true,
            ),
            body: controller.gambars.isNotEmpty
                ? PdfPreview(
                    dynamicLayout: false,
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    canDebug: false,
                    build: (format) =>
                        _generatePdf2(format, "Test", controller.gambars),
                  )
                : Center(
                    child: Text("Data not found."),
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
                  // var gambar = gambars[index];
                  // var netImage = await networkImage("$baseUrl/images/${gambar.endpoint}");

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
                // var gambar = gambars[index];
                // var netImage = await networkImage("$baseUrl/images/${gambar.endpoint}");

                return pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Flexible(
                    child: pw.Column(children: [
                      pw.Image(
                        controller.netImages[index],
                        height: size,
                        width: size,
                      ),
                      pw.Text(
                          "Download Aplikasi KidCol di Playstore dan buat buku mewarnaimu sendiri"),
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
