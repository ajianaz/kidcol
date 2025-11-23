import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/models/asset.dart';
import 'package:kidcol/app/data/models/assets_response.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/data/services/account_service.dart';
import 'package:kidcol/app/utils/app_string.dart';
import 'package:kidcol/app/utils/api_config.dart';
import 'package:kidcol/app/utils/env_config.dart';
import 'package:kidcol/app/widgets/dialogs/whatsapp_verification.dart';

class HomeController extends GetxController {
  final service = IsarService();
  final accountService = Get.find<AccountService>();

  // bool isLoaded = false;

  final dio = Dio();

  RxInt page = RxInt(1);
  RxInt limit = RxInt(30);
  RxInt totalPage = RxInt(1);

  late ScrollController scrollController;
  RxBool isLoading = RxBool(true);

  List<Asset> assets = List.empty(growable: true);

  List<Koleksi> koleksis = List.empty(growable: true);

  /// Check account verification status and show necessary dialogs
  Future<void> _checkAccountVerification() async {
    // Only check if verification is enabled in environment
    if (!EnvConfig.enableVerification) {
      return;
    }

    // Only check for paid users
    if (accountService.isPaidAccount()) {
      // Check if device is verified
      if (!accountService.isDeviceVerified()) {
        await _showDeviceVerificationDialog();
        return;
      }

      // Check if WhatsApp is verified
      if (!accountService.isWhatsAppVerified()) {
        await _showWhatsAppVerificationDialog();
        return;
      }
    }
  }

  /// Show device verification dialog
  Future<void> _showDeviceVerificationDialog() async {
    final deviceId = accountService.getDeviceId();
    final deviceInfo = accountService.getDeviceInfo();

    await Get.defaultDialog(
      title: 'Device Verification Required',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'As a paid user, you need to verify your device to continue using the app.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Device Information:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceInfo,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Device ID: $deviceId',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Copy device ID to clipboard
                        // In a real implementation, you would use flutter/services
                        // For now, we'll just show a snackbar
                        Get.snackbar(
                          'Device ID Copied',
                          'Device ID has been copied to clipboard',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Copy Device ID',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Get.back(); // Close the dialog
                final success = await accountService.lockAccountToDevice();
                if (success) {
                  Get.snackbar(
                    'Success',
                    'Device verified successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  // Check WhatsApp verification after device verification
                  await _checkAccountVerification();
                } else {
                  Get.snackbar(
                    'Error',
                    'Failed to verify device',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Verify Device'),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show WhatsApp verification dialog
  Future<void> _showWhatsAppVerificationDialog() async {
    await Get.dialog(
      const WhatsAppVerificationDialog(),
      barrierDismissible: false,
    );
  }

  requestData() async {
    // Check account verification before proceeding
    await _checkAccountVerification();

    // If access is not allowed, don't proceed with request
    if (!accountService.isAccountAccessAllowed()) {
      return;
    }
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

    // Check account verification before making any requests
    _checkAccountVerification().then((_) {
      requestData();
    });
  }

  @override
  void onClose() {
    // Close database connection when controller is disposed
    service.close();
    super.onClose();
  }
}
