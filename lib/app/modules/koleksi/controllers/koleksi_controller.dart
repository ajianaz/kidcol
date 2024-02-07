import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/services/isar_service.dart';

class KoleksiController extends GetxController {
  final service = IsarService();

  simpanKoleksi(String value){
    final data = Koleksi()..title = value;
    service.saveKoleksi(data);
  }
  
  @override
  void onInit() {
    super.onInit();
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
