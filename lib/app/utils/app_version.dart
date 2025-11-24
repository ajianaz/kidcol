import 'package:package_info_plus/package_info_plus.dart';

/// Utility class to get app version from the running application metadata
class AppVersion {
  static String? _cachedVersion;
  static PackageInfo? _cachedPackageInfo;

  /// Gets the app version from the running application metadata
  /// Returns the version string (e.g., "1.1.1+4")
  static Future<String> getAppVersion() async {
    // Return cached version if already loaded
    if (_cachedVersion != null) {
      return _cachedVersion!;
    }

    try {
      // Get package info from the running application
      final packageInfo = await _getPackageInfo();

      // Combine version and build number in the same format as pubspec.yaml
      final version = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;

      _cachedVersion =
          buildNumber.isNotEmpty ? '$version+$buildNumber' : version;
      return _cachedVersion!;
    } catch (e) {
      // Return a default version if there's an error
      return 'Unknown';
    }
  }

  /// Gets the PackageInfo object with caching to avoid repeated calls
  static Future<PackageInfo> _getPackageInfo() async {
    if (_cachedPackageInfo != null) {
      return _cachedPackageInfo!;
    }

    _cachedPackageInfo = await PackageInfo.fromPlatform();
    return _cachedPackageInfo!;
  }

  /// Gets the app version synchronously (returns cached version or 'Loading...')
  static String getAppVersionSync() {
    return _cachedVersion ?? 'Loading...';
  }

  /// Clears the cached version and package info
  static void clearCache() {
    _cachedVersion = null;
    _cachedPackageInfo = null;
  }
}
