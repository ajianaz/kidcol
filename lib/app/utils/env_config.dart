import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration utility class
class EnvConfig {
  static late DotEnv _env;

  /// Initialize environment configuration
  static Future<void> init() async {
    // dotenv is already initialized in main.dart, so we just need to reference it
    _env = dotenv;
  }

  /// Get the limit for free users
  static int get limitFree {
    final limitStr = _env.env['limit_FREE'] ?? '10';
    return int.tryParse(limitStr) ?? 10;
  }

  /// Get the account type
  static String get accountType {
    return _env.env['account_type'] ?? 'free';
  }

  /// Check if the account is free
  static bool get isFreeAccount {
    return accountType.toLowerCase() == 'free';
  }

  /// Check if the account is paid
  static bool get isPaidAccount {
    return accountType.toLowerCase() == 'paid';
  }

  /// Check if verification is enabled
  static bool get enableVerification {
    return _env.env['enable_verification']?.toLowerCase() == 'true';
  }
}
