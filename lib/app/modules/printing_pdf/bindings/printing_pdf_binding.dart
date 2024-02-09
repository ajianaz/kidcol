import 'package:get/get.dart';

import '../controllers/printing_pdf_controller.dart';

class PrintingPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrintingPdfController>(
      () => PrintingPdfController(),
    );
  }
}
