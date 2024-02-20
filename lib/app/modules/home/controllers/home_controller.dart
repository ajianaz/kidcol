import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/models/asset.dart';
import 'package:kidcol/app/data/models/assets_response.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/utils/app_string.dart';

class HomeController extends GetxController {
  final service = IsarService();

  // bool isLoaded = false;

  final dio = Dio();

  RxInt page = RxInt(1);
  RxInt limit = RxInt(10);
  RxInt totalPage = RxInt(1);

  late ScrollController scrollController;
  RxBool isLoading = RxBool(true);

  List<Asset> assets = List.empty(growable: true);

  List<Koleksi> koleksis = List.empty(growable: true);

  requestData() async {
    isLoading.value = true;
    try {
      var response = await dio.get(
          '$baseUrl/assets/endless?page=${page.value}&limit=${limit.value}');
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
    var result = true;
    service
        .getAllKoleksis()
        .then((data) => data.isEmpty ? result = true : result = false);
    return result;
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
    var result = await service.getAllKoleksis();
    koleksis = result;
    update();
    debugPrint("Total data : ${koleksis.length}");
  }

  //// ADDING THE SCROLL LISTINER
  void scrollListener() {
    debugPrint(
        "current ${scrollController.offset}  max: ${scrollController.position.maxScrollExtent}");

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      // isLoading.value = true;

      // if (isLoading.value) {
      if (page.value < totalPage.value) {
        page.value = page.value + 1;
        debugPrint("Load More");
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

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Loads a banner ad.
  getAds() {
    BannerAdListener bannerAdListener = BannerAdListener(
      onAdWillDismissScreen: (ad) {
        ad.dispose();
      },
      onAdClosed: (ad) {
        debugPrint("Ads Get Closed");
      },
      onAdLoaded: (ad) {
        debugPrint('$ad loaded.');
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (ad, err) {
        debugPrint('BannerAd failed to load: $err');
        // Dispose the ad here to free resources.
        ad.dispose();
      },
    );

    BannerAd? bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: bannerAdListener,
    )..load();

    return SizedBox(
      width: bannerAd.size.width.toDouble(),
      height: 100,
      child: AdWidget(ad: bannerAd),
    );
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
    super.onClose();
  }
}
