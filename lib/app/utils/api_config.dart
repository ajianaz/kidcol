import 'env_config.dart';

class ApiConfig {
  static String get baseUrl => EnvConfig.baseUrl;
  static String get gatewayKey => EnvConfig.gatewayKey;

  /// Get the authorization header with Bearer token format
  static Map<String, String> get authHeaders {
    if (gatewayKey.isNotEmpty &&
        gatewayKey != 'REPLACE_WITH_ACTUAL_GATEWAY_KEY') {
      return {'authorization': 'Bearer $gatewayKey'};
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
    // Ensure the endpoint starts with /
    if (!endpoint.startsWith('/')) {
      endpoint = '/$endpoint';
    }

    // Ensure the base URL doesn't end with /
    String base = baseUrl;
    if (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }

    return '$base$endpoint';
  }

  /// Get the full URL for an image
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
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

    return '$base/$imagePath';
  }
}
