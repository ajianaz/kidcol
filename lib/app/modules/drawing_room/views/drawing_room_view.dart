// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:kidcol/app/utils/responsive_helper.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../../../utils/drawing_painter.dart';
import '../../../utils/app_dialogs.dart';
import '../controllers/drawing_room_controller.dart';

class DrawingRoomView extends GetView<DrawingRoomController> {
  const DrawingRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await AppDialogs.showConfirmation(
          title: t.common.warning,
          message:
              'Are you sure you want to exit? Unsaved changes will be lost.',
          confirmText: t.common.yes,
          cancelText: t.common.cancel,
          isDestructive: true,
        );

        if (shouldPop == true) {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.drawing.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await AppDialogs.showConfirmation(
                title: t.common.warning,
                message:
                    'Are you sure you want to exit? Unsaved changes will be lost.',
                confirmText: t.common.yes,
                cancelText: t.common.cancel,
                isDestructive: true,
              );

              if (shouldPop == true) {
                Get.back();
              }
            },
          ),
        ),
        // backgroundColor: Color(0xFF34495e),
        body: ConstrainedBox(
          constraints:
              ResponsiveHelper.getResponsiveContainerConstraints(context),
          child: GetBuilder<DrawingRoomController>(
            init: DrawingRoomController(),
            builder: (_) {
              return Stack(
                children: [
                  /// Zoomable Image & Canvas Area
                  InteractiveViewer(
                    minScale: 0.1,
                    maxScale: 5.0,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (controller.urlImage != null)
                            Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Image.network(
                                controller.urlImage!,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(Icons.error,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  );
                                },
                              ),
                            ),

                          /// Drawing Canvas (Overlay)
                          Positioned.fill(
                            child: GestureDetector(
                              onPanStart: controller.onPanStart,
                              onPanUpdate: controller.onPanUpdate,
                              onPanEnd: (_) => controller.onPanEnd(),
                              child: CustomPaint(
                                painter: DrawingPainter(
                                  drawingPoints: controller.drawingPoints,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Color Palette
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: ResponsiveHelper.isTablet(context) ? 100 : 80,
                      padding: EdgeInsets.all(
                          ResponsiveHelper.isTablet(context) ? 16 : 12),
                      margin: ResponsiveHelper.isDesktop(context)
                          ? EdgeInsets.symmetric(
                              horizontal: (MediaQuery.of(context).size.width -
                                      ResponsiveHelper
                                          .getResponsiveContainerWidth(
                                              context)) /
                                  2)
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: 0.9),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.avaiableColor.length,
                        separatorBuilder: (_, __) => SizedBox(
                            width:
                                ResponsiveHelper.isTablet(context) ? 16 : 12),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => controller.updateSelectedColor(index),
                            child: Container(
                              width:
                                  ResponsiveHelper.isTablet(context) ? 40 : 32,
                              height:
                                  ResponsiveHelper.isTablet(context) ? 40 : 32,
                              decoration: BoxDecoration(
                                color: controller.avaiableColor[index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              foregroundDecoration: BoxDecoration(
                                border: controller.selectedColor ==
                                        controller.avaiableColor[index]
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 3,
                                      )
                                    : null,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  /// Pencil Size Slider
                  Positioned(
                    top: ResponsiveHelper.isTablet(context) ? 120 : 100,
                    right: 0,
                    bottom: 100,
                    child: Center(
                      child: Container(
                        height: ResponsiveHelper.isTablet(context) ? 350 : 300,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow
                                  .withValues(alpha: 0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: controller.selectedWidth,
                            min: 1,
                            max: 20,
                            activeColor: controller.selectedColor,
                            onChanged: (value) {
                              controller.updateSelectedWidth(value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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
      ),
    );
  }
}
