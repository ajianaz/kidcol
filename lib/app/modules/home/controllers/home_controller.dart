import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/models/asset.dart';
import 'package:kidcol/app/data/models/assets_response.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/app_string.dart';
import 'package:kidcol/app/utils/api_config.dart';

class HomeController extends GetxController {
  final service = IsarService();

  // bool isLoaded = false;

  final dio = Dio();

  RxInt page = RxInt(1);
  RxInt limit = RxInt(30);
  RxInt totalPage = RxInt(1);

  late ScrollController scrollController;
  RxBool isLoading = RxBool(true);

  List<Asset> assets = List.empty(growable: true);

  List<Koleksi> koleksis = List.empty(growable: true);

  requestData() async {
    isLoading.value = true;
    try {
      var response = await dio.get(
          '${ApiConfig.baseUrl}/api/coloring-images/endless?page=${page.value}&limit=${limit.value}',
          options: ApiConfig.gatewayKey.isNotEmpty
              ? Options(headers: {'gateway_key': ApiConfig.gatewayKey})
              : null);
      // debugPrint('${response.data}');

      var result = AssetsResponse.fromJson(response.data);

      assets.addAll(result.assets as List<Asset>);
      totalPage.value = result.totalPages as int;
      isLoading.value = false;
      update();
    } catch (e) {
      debugPrint("$e");
    }
  }

  isKoleksiEmpty() async {
    try {
      var result = true;
      final data = await service.getAllKoleksis();
      result = data.isEmpty;
      return result;
    } catch (e) {
      debugPrint("Error checking if koleksi is empty: $e");
      return true; // Assume empty on error
    }
  }

  dialogAddKoleksi() {
    Get.defaultDialog(
        title: "Tidak Ada Koleksi",
        content: Text("Mohon tambahkan koleksi terlebih dahulu."));
  }

  resetData() {
    assets.clear();
    page.value = 1;
  }

  //Get All Koleksi dari local DB
  getAllKoleksi() async {
    try {
      var result = await service.getAllKoleksis();
      koleksis = result;
      update();
      debugPrint("Total data : ${koleksis.length}");
    } catch (e) {
      debugPrint("Error getting all koleksis: $e");
      // Show error to user if needed
    }
  }

  //// ADDING THE SCROLL LISTINER
  void scrollListener() {
    // debugPrint(
    //     "current ${scrollController.offset}  max: ${scrollController.position.maxScrollExtent}");

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      // isLoading.value = true;

      // if (isLoading.value) {
      if (page.value < totalPage.value) {
        page.value = page.value + 1;
        // debugPrint("Load More");
        requestData();
      } else if (page.value == totalPage.value) {
        Get.defaultDialog(
          title: "Perhatian",
          content: Text("Gambar sudah habis."),
        );
      }
      // }
    }
  }

  @override
  void onInit() {
    super.onInit();

    getAllKoleksi();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("READY");
    scrollController = ScrollController()..addListener(scrollListener);
    update();

    requestData();
  }

  @override
  void onClose() {
    // Close database connection when controller is disposed
    service.close();
    super.onClose();
  }
}
