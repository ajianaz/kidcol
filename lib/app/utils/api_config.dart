import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://gateway.ajianaz.dev';
  static String get gatewayKey => dotenv.env['GATEWAY_KEY'] ?? '';
}
