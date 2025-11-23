import 'env_config.dart';

class ApiConfig {
  static String get baseUrl => EnvConfig.baseUrl;
  static String get gatewayKey => EnvConfig.gatewayKey;

  /// Get the authorization header with Bearer token format
  static Map<String, String> get authHeaders {
    if (gatewayKey.isNotEmpty) {
      return {'authorization': 'Bearer $gatewayKey'};
    }
    return {};
  }
}
