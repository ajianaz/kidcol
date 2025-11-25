import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('${prefix}ℹ️ $message');
    }
  }

  static void error(String message, {String? tag, dynamic error}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('${prefix}❌ $message');
      if (error != null) debugPrint('${prefix}🔍 $error');
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('${prefix}⚠️ $message');
    }
  }
}
