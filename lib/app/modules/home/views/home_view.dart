import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/utils/app_string.dart';

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

    return Scaffold(
      // body: Center(child: Text("ABC")),
      // appBar: AppBar(
      //   title: const Text('HomeView'),
      //   centerTitle: true,
      // ),
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (val) {
          return controller.assets.isNotEmpty
              ? controller.isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      child: ListView.builder(
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: 2,
                        // ),
                        controller: controller.scrollController,
                        itemCount: controller.assets.length,
                        itemBuilder: (context, index) {
                          return cardImage(
                            imgUrl:
                                "$baseUrl/images/${controller.assets[index].name}",
                          );
                        },
                      ),
                    )
              : SizedBox();
        },
      ),
    );
  }
}
