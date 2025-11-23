import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/utils/constants.dart';
import 'package:kidcol/app/utils/responsive_helper.dart';
import 'package:kidcol/app/widgets/cards/card_image.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dialogKoleksis(String value) {
      if (controller.koleksis.isNotEmpty) {
        return Get.defaultDialog(
          title: t.collections.view_images,
          content: SingleChildScrollView(
            child: Container(
              height: 200.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: ListView.builder(
                itemCount: controller.koleksis.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var koleksi = controller.koleksis[index];
                  return InkWell(
                    onTap: () {
                      var data = Gambar()..endpoint = value;
                      data.koleksis.add(koleksi);
                      controller.service.saveGambar(data);
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: AppPadding.xs, horizontal: AppPadding.xs),
                      padding: EdgeInsets.symmetric(
                          vertical: AppPadding.xs, horizontal: AppPadding.sm),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text("${koleksi.title}"),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    }

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (val) {
        return Scaffold(
          body: Stack(
            children: [
              !controller.isLoading.value
                  ? controller.assets.isNotEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            return Padding(
                              padding:
                                  AppPadding.getResponsiveAllPadding(context),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      ResponsiveHelper.getCrossAxisCount(
                                          context),
                                  crossAxisSpacing:
                                      AppSpacing.gridCrossAxisSpacing,
                                  mainAxisSpacing:
                                      AppSpacing.gridMainAxisSpacing,
                                  childAspectRatio:
                                      0.8, // Adjust aspect ratio as needed
                                ),
                                controller: controller.scrollController,
                                itemCount: controller.assets.length,
                                itemBuilder: (context, index) {
                                  var asset = controller.assets[index];
                                  return InkWell(
                                    onTap: () {
                                      if (controller.koleksis.isEmpty) {
                                        controller.dialogAddKoleksi();
                                      } else {
                                        dialogKoleksis(
                                            asset.imageUrl.toString());
                                      }
                                    },
                                    onDoubleTap: () {
                                      Get.toNamed(Routes.DRAWING_ROOM,
                                          arguments: "${asset.imageUrl}");
                                    },
                                    child: CardImage(
                                      imageUrl: "${asset.imageUrl}",
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : const SizedBox()
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}
