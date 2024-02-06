import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/models/asset.dart';
import 'package:kidcol/app/data/models/assets_response.dart';
import 'package:kidcol/app/utils/app_string.dart';

class HomeController extends GetxController {
  final dio = Dio();

  RxInt page = RxInt(1);
  RxInt limit = RxInt(10);

  List<Asset> assets = List.empty();

  requestData() async {
    var response = await dio
        .get('$baseUrl/assets/endless?page=${page.value}&limit=${limit.value}');
    debugPrint('${response.data}');

    var result = AssetsResponse.fromJson(response.data);
    assets = result.assets as List<Asset>;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("READY");
    requestData();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
