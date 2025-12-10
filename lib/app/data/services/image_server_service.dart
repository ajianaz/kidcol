import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/utils/logger.dart';

/// Service to manage image server with automatic failover to backup server
class ImageServerService extends GetxService {
  static const String primaryImageServer = 'https://s3.azfirazka.com';
  static const String backupImageServer = 'https://cdn.ajianaz.dev';
  static const String healthCheckUrl = 'https://s31.ajianaz.dev';

  final Dio _dio = Dio();

  // Current active image server
  final _currentImageServer = primaryImageServer.obs;
  String get currentImageServer => _currentImageServer.value;

  // Server health status
  final _isPrimaryServerHealthy = true.obs;
  bool get isPrimaryServerHealthy => _isPrimaryServerHealthy.value;

  @override
  void onInit() {
    super.onInit();
    Logger.log('ImageServerService initialized', tag: 'ImageServerService');
  }

  /// Check primary server health on app start
  Future<void> checkServerHealth() async {
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'ImageServerService');
    Logger.log('🏥 Checking primary image server health...',
        tag: 'ImageServerService');
    Logger.log('Health check URL: $healthCheckUrl', tag: 'ImageServerService');

    try {
      final response = await _dio.get(
        healthCheckUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        _isPrimaryServerHealthy.value = true;
        _currentImageServer.value = primaryImageServer;
        Logger.log('✅ Primary server is healthy', tag: 'ImageServerService');
        Logger.log('Using: $primaryImageServer', tag: 'ImageServerService');
      } else {
        _handleServerDown();
      }
    } catch (e) {
      Logger.warning('⚠️  Health check failed: $e', tag: 'ImageServerService');
      _handleServerDown();
    }

    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'ImageServerService');
  }

  void _handleServerDown() {
    _isPrimaryServerHealthy.value = false;
    _currentImageServer.value = backupImageServer;
    Logger.warning('❌ Primary server is down', tag: 'ImageServerService');
    Logger.log('🔄 Switching to backup server: $backupImageServer',
        tag: 'ImageServerService');
  }

  /// Replace image URL with current active server
  String getImageUrl(String originalUrl) {
    if (originalUrl.isEmpty) return originalUrl;

    // If using backup server, replace primary URL with backup
    if (!_isPrimaryServerHealthy.value) {
      if (originalUrl.contains(primaryImageServer)) {
        final replacedUrl = originalUrl.replaceAll(
          primaryImageServer,
          backupImageServer,
        );
        Logger.log('🔄 URL replaced: $primaryImageServer → $backupImageServer',
            tag: 'ImageServerService');
        return replacedUrl;
      }
    }

    return originalUrl;
  }

  /// Get list of image URLs with proper server
  List<String> getImageUrls(List<String> originalUrls) {
    return originalUrls.map((url) => getImageUrl(url)).toList();
  }

  /// Manually switch to backup server
  void switchToBackupServer() {
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'ImageServerService');
    Logger.log('🔄 Manually switching to backup server',
        tag: 'ImageServerService');
    _isPrimaryServerHealthy.value = false;
    _currentImageServer.value = backupImageServer;
    Logger.log('Using: $backupImageServer', tag: 'ImageServerService');
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'ImageServerService');
  }

  /// Manually switch to primary server
  void switchToPrimaryServer() {
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'ImageServerService');
    Logger.log('🔄 Manually switching to primary server',
        tag: 'ImageServerService');
    _isPrimaryServerHealthy.value = true;
    _currentImageServer.value = primaryImageServer;
    Logger.log('Using: $primaryImageServer', tag: 'ImageServerService');
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'ImageServerService');
  }

  /// Retry health check
  Future<void> retryHealthCheck() async {
    Logger.log('🔄 Retrying health check...', tag: 'ImageServerService');
    await checkServerHealth();
  }
}
