import 'package:get/get.dart';

import '../controllers/drawing_room_controller.dart';

class DrawingRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrawingRoomController>(
      () => DrawingRoomController(),
    );
  }
}
