import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/models/asset.dart';
import 'package:kidcol/app/data/models/assets_response.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/data/services/account_service.dart';
import 'package:kidcol/app/data/services/filter_service.dart';
import 'package:kidcol/app/utils/api_config.dart';
import 'package:kidcol/app/utils/env_config.dart';
import 'package:kidcol/app/utils/error_handler.dart';
import 'package:kidcol/app/utils/logger.dart';
import 'package:kidcol/app/widgets/dialogs/whatsapp_verification.dart';
import 'package:kidcol/i18n/translations.g.dart';

class HomeController extends GetxController {
  final service = Get.find<IsarService>();
  final accountService = Get.find<AccountService>();
  final filterService = Get.find<FilterService>();

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

  // Filter state variables
  final selectedLevel = Rxn<int>();
  final selectedCategory = Rxn<String>();
  final hasActiveFilters = RxBool(false);

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

    // Track request start time
    final startTime = DateTime.now();

    try {
      var url =
          '/api/coloring-images/endless?page=${page.value}&limit=${limit.value}';

      // Add filter parameters if active
      if (selectedLevel.value != null) {
        url += '&level=${selectedLevel.value}';
      }
      if (selectedCategory.value != null) {
        url += '&category=${selectedCategory.value}';
      }

      // Log request with filters
      Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
          tag: 'HomeController');
      Logger.log('🎨 Requesting images: Page ${page.value}/${totalPage.value}',
          tag: 'HomeController');

      if (hasActiveFilters.value) {
        final filters = <String>[];
        if (selectedLevel.value != null)
          filters.add('Level ${selectedLevel.value}');
        if (selectedCategory.value != null)
          filters.add(selectedCategory.value!);
        Logger.log('🔍 Filters: ${filters.join(", ")}', tag: 'HomeController');
      }

      Logger.log('📤 ${ApiConfig.baseUrl}$url', tag: 'HomeController');

      var response = await dio.get(url,
          options: ApiConfig.gatewayKey.isNotEmpty
              ? Options(headers: ApiConfig.authHeaders)
              : null);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      if (response.statusCode == 200) {
        // Validate response data
        if (response.data == null) {
          Logger.error('❌ Response data is null', tag: 'HomeController');
          Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
              tag: 'HomeController');
          throw Exception('Response data is null');
        }

        // Check if response.data is a Map
        if (response.data is! Map<String, dynamic>) {
          Logger.error('❌ Invalid response type: ${response.data.runtimeType}',
              tag: 'HomeController');
          Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
              tag: 'HomeController');
          throw Exception(
              'Invalid response format: expected Map<String, dynamic>, got ${response.data.runtimeType}');
        }

        AssetsResponse result;
        try {
          result = AssetsResponse.fromJson(response.data);
        } catch (parseError) {
          Logger.error('❌ Parse error: $parseError', tag: 'HomeController');
          Logger.error('Response keys: ${(response.data as Map).keys.toList()}',
              tag: 'HomeController');
          Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
              tag: 'HomeController');
          throw Exception('Failed to parse response: $parseError');
        }

        // Check if empty result
        if (result.assets == null || result.assets!.isEmpty) {
          Logger.log('⚠️  No assets found', tag: 'HomeController');
          if (hasActiveFilters.value) {
            final filters = <String>[];
            if (selectedLevel.value != null)
              filters.add('Level ${selectedLevel.value}');
            if (selectedCategory.value != null)
              filters.add(selectedCategory.value!);
            Logger.log('Active filters: ${filters.join(", ")}',
                tag: 'HomeController');
          }
        }

        Logger.log(
            '✅ Loaded ${result.assets?.length ?? 0} assets (${duration.inMilliseconds}ms)',
            tag: 'HomeController');
        Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
            tag: 'HomeController');

        assets.addAll(result.assets as List<Asset>);
        totalPage.value = result.totalPages as int;
        isLoading.value = false;
        retryCount.value = 0; // Reset retry count on success
        update();
      } else {
        Logger.error('❌ Failed with status code: ${response.statusCode}',
            tag: 'HomeController');
        Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
            tag: 'HomeController');
        throw Exception(
            'Failed to load data: Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      Logger.error(
          '❌ Dio Error [${e.type}]: ${e.message} (${duration.inMilliseconds}ms)',
          tag: 'HomeController');
      if (e.response != null) {
        Logger.error('Status ${e.response?.statusCode}: ${e.response?.data}',
            tag: 'HomeController');
      }
      Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
          tag: 'HomeController');

      // Show error with retry option for connection errors
      if (ApiConfig.isRetryableError(e)) {
        _handleNetworkErrorWithRetry(e);
      } else {
        AppErrorHandler.handleError(e, context: 'HomeController.requestData');
      }

      isLoading.value = false;
      update();
    } catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      Logger.error(
          '❌ Error [${e.runtimeType}]: $e (${duration.inMilliseconds}ms)',
          tag: 'HomeController');
      Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
          tag: 'HomeController');

      // Handle specific error types
      if (e.toString().contains('Network') || e.toString().contains('Socket')) {
        _handleNetworkErrorWithRetry(e);
      } else {
        AppErrorHandler.handleError(e, context: 'HomeController.requestData');
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
      AppErrorHandler.handleErrorWithoutSnackbar(e,
          context: 'HomeController.isKoleksiEmpty');
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

  /// Apply filters and refresh data
  void applyFilters() {
    final filters = <String>[];
    if (selectedLevel.value != null)
      filters.add('Level ${selectedLevel.value}');
    if (selectedCategory.value != null) filters.add(selectedCategory.value!);

    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'HomeController');
    Logger.log(
        '🔄 Applying Filters: ${filters.isNotEmpty ? filters.join(", ") : "None"}',
        tag: 'HomeController');
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'HomeController');

    _updateFilterStatus();
    resetData();
    requestData();
  }

  /// Reset all filters and refresh data
  void resetFilters() {
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'HomeController');
    Logger.log('🔄 Resetting All Filters', tag: 'HomeController');
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'HomeController');

    selectedLevel.value = null;
    selectedCategory.value = null;
    hasActiveFilters.value = false;
    resetData();
    requestData();
  }

  /// Update filter status based on active filters
  void _updateFilterStatus() {
    hasActiveFilters.value =
        selectedLevel.value != null || selectedCategory.value != null;
  }

  /// Set filter values and apply
  void setFilters({int? level, String? category}) {
    final oldFilters = <String>[];
    if (selectedLevel.value != null)
      oldFilters.add('Level ${selectedLevel.value}');
    if (selectedCategory.value != null) oldFilters.add(selectedCategory.value!);

    final newFilters = <String>[];
    if (level != null) newFilters.add('Level $level');
    if (category != null) newFilters.add(category);

    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'HomeController');
    Logger.log(
        '⚙️  Setting Filters: ${newFilters.isNotEmpty ? newFilters.join(", ") : "None"}',
        tag: 'HomeController');
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'HomeController');

    selectedLevel.value = level;
    selectedCategory.value = category;
    applyFilters();
  }

  /// Retry failed request with exponential backoff
  Future<void> retryRequest() async {
    if (retryCount.value >= maxRetries) {
      Logger.warning('Max retries reached, giving up', tag: 'HomeController');
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
    Logger.log('Retrying request, attempt ${retryCount.value}/$maxRetries',
        tag: 'HomeController');

    // Exponential backoff: 1s, 2s, 4s
    final delay = Duration(seconds: (1 << (retryCount.value - 1)));
    await Future.delayed(delay);

    await requestData(isRetry: true);
  }

  //Get All Koleksi dari local DB
  getAllKoleksi() async {
    try {
      Logger.log('Loading all koleksis...', tag: 'HomeController');
      var result = await service.getAllKoleksis();
      koleksis = result;
      update();
      Logger.log("Loaded ${koleksis.length} koleksis", tag: 'HomeController');
    } catch (e) {
      AppErrorHandler.handleError(e, context: 'HomeController.getAllKoleksi');
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
      AppErrorHandler.handleErrorWithoutSnackbar(e,
          context: 'HomeController.scrollListener');
    }
  }

  /// Handle network errors with appropriate actions
  void _handleNetworkErrorWithRetry(dynamic error) {
    String errorMessage = AppErrorHandler.getUserFriendlyMessage(error,
        context: 'HomeController._handleNetworkErrorWithRetry');

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

    // Initialize filter status
    _updateFilterStatus();
  }

  @override
  void onReady() {
    super.onReady();
    Logger.log("Controller ready", tag: 'HomeController');
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

    // Don't close database - singleton instance is shared across all controllers
    super.onClose();
  }
}
