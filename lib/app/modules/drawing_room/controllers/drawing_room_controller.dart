import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/drawing_point.dart';

class DrawingRoomController extends GetxController {
  final dio = Dio();
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
  ];

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  DrawingPoint? currentDrawingPoint;
  String? urlImage;

  redo() {
    if (drawingPoints.length < historyDrawingPoints.length) {
      // 6 length 7
      final index = drawingPoints.length;
      drawingPoints.add(historyDrawingPoints[index]);
      update();
    }
  }

  undo() {
    if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
      drawingPoints.removeLast();
      update();
    }
  }

  updateSelectedWidth(double value) {
    selectedWidth = value;
    update();
  }

  updateSelectedColor(int index) {
    selectedColor = avaiableColor[index];
    update();
  }

  onPanStart(DragStartDetails details) {
    currentDrawingPoint = DrawingPoint(
      id: DateTime.now().microsecondsSinceEpoch,
      offsets: [
        details.localPosition,
      ],
      color: selectedColor,
      width: selectedWidth,
    );

    if (currentDrawingPoint == null) return;
    drawingPoints.add(currentDrawingPoint!);
    historyDrawingPoints = List.of(drawingPoints);
    update();
  }

  onPanUpdate(DragUpdateDetails details) {
    if (currentDrawingPoint == null) return;

    currentDrawingPoint = currentDrawingPoint?.copyWith(
      offsets: currentDrawingPoint!.offsets..add(details.localPosition),
    );
    drawingPoints.last = currentDrawingPoint!;
    historyDrawingPoints = List.of(drawingPoints);
    update();
  }

  onPanEnd() {
    currentDrawingPoint = null;
  }

  getArgument() {
    if (Get.arguments != null) {
      urlImage = Get.arguments;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getArgument();
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
