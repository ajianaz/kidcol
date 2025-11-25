import 'env_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl => EnvConfig.baseUrl;
  static String get gatewayKey => EnvConfig.gatewayKey;

  /// Get default Dio options with proper timeout settings
  static BaseOptions get defaultOptions {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Kidcol/1.0 (Flutter)',
      },
      validateStatus: (status) {
        // Accept status codes in 200-299 range and also handle common error codes
        return (status != null && status >= 200 && status < 300) ||
            status == 401 ||
            status == 403 ||
            status == 404 ||
            status == 500;
      },
    );
  }

  /// Get the authorization header with Bearer token format
  static Map<String, String> get authHeaders {
    if (gatewayKey.isNotEmpty &&
        gatewayKey != 'REPLACE_WITH_ACTUAL_GATEWAY_KEY') {
      return {
        'Authorization': 'Bearer $gatewayKey',
      };
    }
    return {};
  }

  /// Check if the API configuration is valid
  static bool get isConfigured {
    return baseUrl.isNotEmpty &&
        gatewayKey.isNotEmpty &&
        gatewayKey != 'REPLACE_WITH_ACTUAL_GATEWAY_KEY';
  }

  /// Get the full URL for an API endpoint
  static String getFullUrl(String endpoint) {
    try {
      // Ensure the endpoint starts with /
      if (!endpoint.startsWith('/')) {
        endpoint = '/$endpoint';
      }

      // Ensure the base URL doesn't end with /
      String base = baseUrl;
      if (base.endsWith('/')) {
        base = base.substring(0, base.length - 1);
      }

      final fullUrl = '$base$endpoint';
      debugPrint('Generated full URL: $fullUrl');
      return fullUrl;
    } catch (e) {
      debugPrint('Error generating full URL: $e');
      return '$baseUrl/$endpoint';
    }
  }

  /// Get the full URL for an image
  static String getImageUrl(String? imagePath) {
    try {
      if (imagePath == null || imagePath.trim().isEmpty) {
        debugPrint('Image path is null or empty');
        return '';
      }

      // If it's already a full URL, return as is
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return imagePath;
      }

      // If it starts with /, remove it to avoid double slashes
      if (imagePath.startsWith('/')) {
        imagePath = imagePath.substring(1);
      }

      // Ensure the base URL doesn't end with /
      String base = baseUrl;
      if (base.endsWith('/')) {
        base = base.substring(0, base.length - 1);
      }

      final fullUrl = '$base/$imagePath';
      debugPrint('Generated image URL: $fullUrl');
      return fullUrl;
    } catch (e) {
      debugPrint('Error generating image URL: $e');
      return imagePath ?? '';
    }
  }

  /// Validate if URL is properly formatted
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      debugPrint('Invalid URL: $url, error: $e');
      return false;
    }
  }

  /// Get error message from DioException
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Request timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Server response timeout. Please try again.';
        case DioExceptionType.badResponse:
          return 'Server error: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network.';
        case DioExceptionType.unknown:
          if (error.error?.toString().contains('SSL') == true ||
              error.error?.toString().contains('certificate') == true) {
            return 'SSL/TLS connection error. Please check your network settings.';
          }
          return 'Unknown network error occurred.';
        default:
          return 'Network error occurred.';
      }
    }
    return 'An error occurred.';
  }

  /// Check if error is retryable
  static bool isRetryableError(dynamic error) {
    if (error is DioException) {
      return [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ].contains(error.type);
    }
    return false;
  }
}
