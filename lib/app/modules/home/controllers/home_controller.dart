import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/models/asset.dart';
import 'package:kidcol/app/data/models/assets_response.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/app_string.dart';

class HomeController extends GetxController {
  final service = IsarService();

  final dio = Dio();

  RxInt page = RxInt(1);
  RxInt limit = RxInt(10);
  RxInt totalPage = RxInt(1);

  late ScrollController scrollController;
  bool isLoading = true; //

  List<Asset> assets = List.empty(growable: true);

  List<Koleksi> koleksis = List.empty(growable: true);

  requestData() async {
    isLoading = true;
    try {
      var response = await dio.get(
          '$baseUrl/assets/endless?page=${page.value}&limit=${limit.value}');
      // debugPrint('${response.data}');

      var result = AssetsResponse.fromJson(response.data);

      debugPrint("Befor Add ALL : ${assets.length}");
      assets.addAll(result.assets as List<Asset>);
      debugPrint("After Add ALL : ${assets.length}");
      totalPage.value = result.totalPages as int;
      isLoading = false;
      update();
    } catch (e) {
      debugPrint("$e");
    }
  }

  resetData() {
    assets.clear();
    page.value = 1;
  }

  //Get All Koleksi dari local DB
  getAllKoleksi() async {
    var result = await service.getAllKoleksis();
    koleksis = result;
    update();
    debugPrint("Total data : ${koleksis.length}");
  }

  //// ADDING THE SCROLL LISTINER
  void scrollListener() {
    // debugPrint(
    //     "current ${scrollController.offset}  max: ${scrollController.position.maxScrollExtent}");

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      debugPrint("comes to bottom $isLoading");
      isLoading = true;

      if (isLoading) {
        debugPrint("RUNNING LOAD MORE");

        if (page.value < totalPage.value) {
          page.value = page.value + 1;
          requestData();
        } else if (page.value == totalPage.value) {
          Get.defaultDialog(
            title: "Perhatian",
            content: Text("Gambar sudah habis."),
          );
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(scrollListener);
    getAllKoleksi();
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
