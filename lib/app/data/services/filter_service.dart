import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/models/filter_options.dart';
import 'package:kidcol/app/utils/error_handler.dart';
import 'package:kidcol/app/utils/logger.dart';

class FilterService extends GetxService {
  final Dio _dio = Dio();
  FilterOptions? _cachedOptions;

  static const String filterUrl =
      'https://auto.ajianaz.dev/webhook/filters-kidcol';

  Future<FilterOptions> getFilterOptions({bool forceRefresh = false}) async {
    // Log cache status
    if (_cachedOptions != null && !forceRefresh) {
      Logger.log('✓ Returning cached filter options', tag: 'FilterService');
      Logger.log('  - Categories: ${_cachedOptions!.categories.length}',
          tag: 'FilterService');
      Logger.log('  - Levels: ${_cachedOptions!.levels.length}',
          tag: 'FilterService');
      return _cachedOptions!;
    }

    // Log request start
    final startTime = DateTime.now();
    Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        tag: 'FilterService');
    Logger.log('🌐 Starting filter API request', tag: 'FilterService');
    Logger.log('  - URL: $filterUrl', tag: 'FilterService');
    Logger.log('  - Force Refresh: $forceRefresh', tag: 'FilterService');
    Logger.log('  - Timestamp: ${startTime.toIso8601String()}',
        tag: 'FilterService');

    try {
      Logger.log('📤 Sending GET request...', tag: 'FilterService');

      final response = await _dio.get(
        filterUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Log response details
      Logger.log('📥 Response received', tag: 'FilterService');
      Logger.log('  - Status Code: ${response.statusCode}',
          tag: 'FilterService');
      Logger.log('  - Duration: ${duration.inMilliseconds}ms',
          tag: 'FilterService');
      Logger.log('  - Response Headers: ${response.headers}',
          tag: 'FilterService');

      if (response.statusCode == 200) {
        _cachedOptions = FilterOptions.fromJson(response.data);

        // Log successful parsing
        Logger.log('✅ Filter options parsed successfully',
            tag: 'FilterService');
        Logger.log(
            '  - Categories (${_cachedOptions!.categories.length}): ${_cachedOptions!.categories.join(", ")}',
            tag: 'FilterService');
        Logger.log(
            '  - Levels (${_cachedOptions!.levels.length}): ${_cachedOptions!.levels.join(", ")}',
            tag: 'FilterService');
        Logger.log('  - Cache updated', tag: 'FilterService');
        Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
            tag: 'FilterService');

        return _cachedOptions!;
      } else {
        Logger.error('❌ Failed with status code: ${response.statusCode}',
            tag: 'FilterService');
        Logger.error('  - Response data: ${response.data}',
            tag: 'FilterService');
        Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
            tag: 'FilterService');
        throw Exception(
            'Failed to load filter options: Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      Logger.error('❌ Dio error occurred', tag: 'FilterService');
      Logger.error('  - Error Type: ${e.type}', tag: 'FilterService');
      Logger.error('  - Error Message: ${e.message}', tag: 'FilterService');
      Logger.error('  - Duration: ${duration.inMilliseconds}ms',
          tag: 'FilterService');

      if (e.response != null) {
        Logger.error('  - Response Status: ${e.response?.statusCode}',
            tag: 'FilterService');
        Logger.error('  - Response Data: ${e.response?.data}',
            tag: 'FilterService');
      }

      Logger.error('  - Stack Trace: ${e.stackTrace}', tag: 'FilterService');
      Logger.log('⚠️  Falling back to default filter options',
          tag: 'FilterService');
      Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
          tag: 'FilterService');

      AppErrorHandler.handleError(e, context: 'FilterService.getFilterOptions');

      // Return default options on error
      return _getDefaultFilterOptions();
    } catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      Logger.error('❌ Unexpected error occurred', tag: 'FilterService');
      Logger.error('  - Error Type: ${e.runtimeType}', tag: 'FilterService');
      Logger.error('  - Error: $e', tag: 'FilterService');
      Logger.error('  - Duration: ${duration.inMilliseconds}ms',
          tag: 'FilterService');
      Logger.log('⚠️  Falling back to default filter options',
          tag: 'FilterService');
      Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
          tag: 'FilterService');

      AppErrorHandler.handleError(e, context: 'FilterService.getFilterOptions');

      // Return default options on error
      return _getDefaultFilterOptions();
    }
  }

  FilterOptions _getDefaultFilterOptions() {
    Logger.log('📋 Using default filter options', tag: 'FilterService');
    final defaultOptions = FilterOptions(
      levels: [0, 1, 2, 3, 4],
      categories: [
        'Animal',
        'Food',
        'Land Scene',
        'Object',
        'Scene',
        'Toy',
        'Vehicle'
      ],
    );
    Logger.log(
        '  - Default Categories (${defaultOptions.categories.length}): ${defaultOptions.categories.join(", ")}',
        tag: 'FilterService');
    Logger.log(
        '  - Default Levels (${defaultOptions.levels.length}): ${defaultOptions.levels.join(", ")}',
        tag: 'FilterService');
    return defaultOptions;
  }

  void clearCache() {
    Logger.log('🗑️  Clearing filter options cache', tag: 'FilterService');
    _cachedOptions = null;
    Logger.log('✓ Filter options cache cleared', tag: 'FilterService');
  }

  @override
  void onInit() {
    super.onInit();
    Logger.log('FilterService initialized', tag: 'FilterService');
  }
}
