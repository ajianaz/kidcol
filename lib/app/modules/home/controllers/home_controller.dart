import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/models/asset.dart';
import 'package:kidcol/app/data/models/assets_response.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/data/services/account_service.dart';
import 'package:kidcol/app/utils/api_config.dart';
import 'package:kidcol/app/utils/env_config.dart';
import 'package:kidcol/app/widgets/dialogs/whatsapp_verification.dart';
import 'package:kidcol/i18n/translations.g.dart';

class HomeController extends GetxController {
  final service = IsarService();
  final accountService = Get.find<AccountService>();

  // bool isLoaded = false;

  final dio = Dio(ApiConfig.defaultOptions);

  RxInt page = RxInt(1);
  RxInt limit = RxInt(30);
  RxInt totalPage = RxInt(1);
  RxInt retryCount = RxInt(0);
  static const int maxRetries = 3;

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
      title: t.dialog.device_verification_required,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.dialog.device_verification_message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            t.dialog.device_info,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
                        '${t.dialog.device_id} $deviceId',
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
                          t.dialog.device_id_copied,
                          t.dialog.device_id_copied_message,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: t.dialog.copy_device_id,
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
                    t.common.success,
                    t.dialog.device_verified_successfully,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  // Check WhatsApp verification after device verification
                  await _checkAccountVerification();
                } else {
                  Get.snackbar(
                    t.common.error,
                    t.dialog.failed_to_verify_device,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text(t.dialog.verify_device),
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

  requestData({bool isRetry = false}) async {
    // Check account verification before proceeding
    await _checkAccountVerification();

    // If access is not allowed, don't proceed with request
    if (!accountService.isAccountAccessAllowed()) {
      isLoading.value = false;
      update();
      return;
    }

    isLoading.value = true;
    update();

    try {
      final url =
          '/api/coloring-images/endless?page=${page.value}&limit=${limit.value}';
      debugPrint('Making API request to: ${ApiConfig.baseUrl}$url');
      debugPrint(
          'Using gateway key: ${ApiConfig.gatewayKey.isNotEmpty ? "Yes" : "No"}');
      debugPrint('Retry count: ${retryCount.value}');

      var response = await dio.get(url,
          options: ApiConfig.gatewayKey.isNotEmpty
              ? Options(headers: ApiConfig.authHeaders)
              : null);

      debugPrint('API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var result = AssetsResponse.fromJson(response.data);
        debugPrint('Successfully loaded ${result.assets?.length ?? 0} assets');

        assets.addAll(result.assets as List<Asset>);
        totalPage.value = result.totalPages as int;
        isLoading.value = false;
        retryCount.value = 0; // Reset retry count on success
        update();
      } else {
        throw Exception(
            'Failed to load data: Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      debugPrint('Response data: ${e.response?.data}');
      debugPrint('Status code: ${e.response?.statusCode}');
      debugPrint('Error type: ${e.type}');

      String errorMessage = t.error.failed_to_load_images;

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = t.error.connection_timeout;
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = t.error.server_response_timeout;
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = t.error.no_internet_connection;
      } else if (e.type == DioExceptionType.unknown) {
        // Handle SSL/TLS errors and other network issues
        if (e.error?.toString().contains('SSL') == true ||
            e.error?.toString().contains('certificate') == true) {
          errorMessage =
              'SSL/TLS connection error. Please check your network settings.';
        } else {
          errorMessage = t.error.no_internet_connection;
        }
      } else if (e.response?.statusCode == 401) {
        errorMessage = t.error.authentication_failed;
      } else if (e.response?.statusCode == 403) {
        errorMessage = t.error.access_forbidden;
      } else if (e.response?.statusCode == 404) {
        errorMessage = t.error.api_endpoint_not_found;
      } else if (e.response?.statusCode == 500) {
        errorMessage = t.error.server_error;
      }

      // Show error with retry option for connection errors
      if (ApiConfig.isRetryableError(e)) {
        _handleNetworkError(errorMessage);
      } else {
        Get.snackbar(
          t.error.error_loading_data,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }

      isLoading.value = false;
      update();
    } catch (e) {
      debugPrint('Unexpected error: $e');
      debugPrint('Error type: ${e.runtimeType}');

      String errorMessage = t.error.unexpected_error;

      // Handle specific error types
      if (e.toString().contains('Network') || e.toString().contains('Socket')) {
        errorMessage = t.error.no_internet_connection;
      }

      // Show error with retry option for network errors
      if (errorMessage.contains('Network') || errorMessage.contains('Socket')) {
        _handleNetworkError(errorMessage);
      } else {
        Get.snackbar(
          t.common.error,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }

      isLoading.value = false;
      update();
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
        title: t.dialog.no_collections,
        content: Text(t.dialog.please_add_collection_first));
  }

  resetData() {
    assets.clear();
    page.value = 1;
    retryCount.value = 0; // Reset retry count
    // Reset scroll position to top when refreshing data
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Retry failed request with exponential backoff
  Future<void> retryRequest() async {
    if (retryCount.value >= maxRetries) {
      debugPrint('Max retries reached, giving up');
      Get.snackbar(
        'Error',
        'Failed to load data after $maxRetries attempts. Please check your connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    retryCount.value++;
    debugPrint('Retrying request, attempt ${retryCount.value}/$maxRetries');

    // Exponential backoff: 1s, 2s, 4s
    final delay = Duration(seconds: (1 << (retryCount.value - 1)));
    await Future.delayed(delay);

    await requestData(isRetry: true);
  }

  /// Check if network is available
  Future<bool> _checkNetworkConnectivity() async {
    try {
      // Try to connect to a reliable endpoint
      final response = await dio.head(
        '${ApiConfig.baseUrl}/health',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Network connectivity check failed: $e');
      return false;
    }
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
    // Add null checks to prevent errors
    if (!scrollController.hasClients) return;

    try {
      // debugPrint(
      //     "current ${scrollController.offset}  max: ${scrollController.position.maxScrollExtent}");

      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        // isLoading.value = true;

        // if (isLoading.value) {
        if (page.value < totalPage.value) {
          page.value = page.value + 1;
          // debugPrint("Load More");
          requestData();
        } else if (page.value == totalPage.value) {
          Get.defaultDialog(
            title: t.dialog.attention,
            content: Text(t.dialog.images_finished),
          );
        }
        // }
      }
    } catch (e) {
      debugPrint("Error in scrollListener: $e");
    }
  }

  /// Handle network errors with appropriate actions
  void _handleNetworkError(String errorMessage) {
    Get.snackbar(
      'Network Error',
      errorMessage,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          Get.back();
          retryRequest();
        },
        child: const Text('Retry', style: TextStyle(color: Colors.white)),
      ),
      icon: const Icon(Icons.refresh, color: Colors.white),
    );
  }

  @override
  void onInit() {
    super.onInit();

    // Initialize ScrollController early to prevent errors
    scrollController = ScrollController()..addListener(scrollListener);

    getAllKoleksi();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint("READY");
    update();

    // Check account verification before making any requests
    _checkAccountVerification().then((_) {
      requestData();
    });
  }

  @override
  void onClose() {
    // Dispose ScrollController to prevent memory leaks
    if (scrollController.hasClients) {
      scrollController.removeListener(scrollListener);
    }
    scrollController.dispose();

    // Close database connection when controller is disposed
    service.close();
    super.onClose();
  }
}
