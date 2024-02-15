import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/utils/app_string.dart';
import 'package:kidcol/app/widgets/cards/card_image.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    cardImage({String? imgUrl}) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
                width: 0.2,
              ),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imgUrl.toString(),
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(),
                fadeInCurve: Curves.bounceIn,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      );
    }

    dialogKoleksis(String value) {
      if (controller.koleksis.isNotEmpty) {
        return Get.defaultDialog(
          title: "Pilih Koleksi Tujuanß",
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
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
          body: !controller.isLoading.value
              ? controller.assets.isNotEmpty
                  ? ListView.builder(
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      // ),
                      controller: controller.scrollController,
                      itemCount: controller.assets.length,
                      itemBuilder: (context, index) {
                        var asset = controller.assets[index];
                        return InkWell(
                          onTap: () {
                            if (controller.koleksis.isEmpty) {
                              controller.dialogAddKoleksi();
                            } else {
                              dialogKoleksis(asset.name.toString());
                            }
                          },
                          child: CardImage(
                            imageUrl: "$baseUrl/images/${asset.name}",
                          ),
                        );
                      },
                    )
                  : const SizedBox()
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
