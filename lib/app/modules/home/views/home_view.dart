import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/utils/app_string.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              ? Container(
                  child: ListView.builder(
                    itemCount: controller.assets.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(4),
                        child: CachedNetworkImage(
                          imageUrl:
                              "$baseUrl/images/${controller.assets[index].name}",
                        ),
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
