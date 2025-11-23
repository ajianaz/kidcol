// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../../../utils/drawing_painter.dart';
import '../controllers/drawing_room_controller.dart';

class DrawingRoomView extends GetView<DrawingRoomController> {
  const DrawingRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.drawing.title),
      ),
      // backgroundColor: Color(0xFF34495e),
      body: GetBuilder(
          init: DrawingRoomController(),
          builder: (_) {
            return Stack(
              children: [
                // Image.network(
                //   controller.urlImage.toString(),
                //   height: 1024,
                //   width: 1024,
                // ),

                PhotoView(
                  imageProvider: NetworkImage(
                    controller.urlImage.toString(),
                  ),
                  // Contained = the smallest possible size to fit one dimension of the screen
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  // Covered = the smallest possible size to fit the whole screen
                  maxScale: PhotoViewComputedScale.covered * 2,
                  enableRotation: true,
                  // Set the background color to the "classic white"
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                ),

                /// Canvas
                GestureDetector(
                  onPanStart: (details) {
                    controller.onPanStart(details);
                  },
                  onPanUpdate: (details) {
                    controller.onPanUpdate(details);
                  },
                  onPanEnd: (_) {
                    controller.onPanEnd();
                  },
                  child: CustomPaint(
                    size: Size(1024, 1024),
                    painter: DrawingPainter(
                      drawingPoints: controller.drawingPoints,
                    ),
                    child: SizedBox(
                      height: 1024,
                      width: 1024,
                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),

                /// color pallet
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.avaiableColor.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(width: 8);
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.updateSelectedColor(index);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: controller.avaiableColor[index],
                              shape: BoxShape.circle,
                            ),
                            foregroundDecoration: BoxDecoration(
                              border: controller.selectedColor ==
                                      controller.avaiableColor[index]
                                  ? Border.all(
                                      color: Color(0xFF1C3E66), width: 4)
                                  : null,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                /// pencil size
                Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
                  right: 0,
                  bottom: 150,
                  child: RotatedBox(
                    quarterTurns: 3, // 270 degree
                    child: Slider(
                      value: controller.selectedWidth,
                      min: 1,
                      max: 20,
                      onChanged: (value) {
                        controller.updateSelectedWidth(value);
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Undo",
            onPressed: () {
              controller.undo();
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "Redo",
            onPressed: () {
              controller.redo();
            },
            child: const Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}
