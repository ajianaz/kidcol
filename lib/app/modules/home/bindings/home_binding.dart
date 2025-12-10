import 'package:get/get.dart';
import 'package:kidcol/app/data/services/filter_service.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilterService>(() => FilterService());
    
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
