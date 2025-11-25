import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/account_status.dart';
import '../../utils/env_config.dart';
import '../../utils/logger.dart';

/// Service for managing account status and providing global access to account information
class AccountService extends GetxService {
  late final AccountStatusController _accountController;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Initialize the account service
  @override
  Future<void> onInit() async {
    super.onInit();
    _accountController = Get.put(AccountStatusController());
    await _initializeAccountStatus();
  }

  /// Initialize account status from environment variables
  Future<void> _initializeAccountStatus() async {
    try {
      // Get account information from environment variables
      final accountType = EnvConfig.accountType;
      final collectionLimit = EnvConfig.isFreeAccount
          ? EnvConfig.limitFree
          : 999999; // High limit for paid accounts

      // Get detailed device information
      String deviceInfo = '';
      String deviceId = '';
      try {
        if (GetPlatform.isAndroid) {
          final androidInfo = await _deviceInfoPlugin.androidInfo;
          deviceInfo =
              'Android ${androidInfo.version.release} - ${androidInfo.model} (${androidInfo.brand})';
          deviceId = androidInfo.id;
        } else if (GetPlatform.isIOS) {
          final iosInfo = await _deviceInfoPlugin.iosInfo;
          deviceInfo =
              'iOS ${iosInfo.systemVersion} - ${iosInfo.model} (${iosInfo.name})';
          deviceId = iosInfo.identifierForVendor ??
              'ios_${DateTime.now().millisecondsSinceEpoch}';
        } else {
          deviceInfo = 'Unknown Platform';
          deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
        }
      } catch (e) {
        deviceInfo = 'Unknown Device';
        deviceId = 'error_${DateTime.now().millisecondsSinceEpoch}';
        Logger.error('Error getting device info: $e',
            tag: 'AccountService', error: e);
      }

      // Initialize the account status
      _accountController.initializeAccountStatus(
        accountType: accountType,
        collectionLimit: collectionLimit,
        currentCollectionCount: 0, // Will be updated from local storage
        deviceInfo: deviceInfo,
        deviceId: deviceId,
        isDeviceVerified: accountType.toLowerCase() ==
            'free', // Free accounts don't need device verification
      );

      Logger.log(
          'Account status initialized: $accountType with limit $collectionLimit, Device ID: $deviceId',
          tag: 'AccountService');
    } catch (e) {
      Logger.error('Error initializing account status: $e',
          tag: 'AccountService', error: e);
      // Initialize with default values in case of error
      _accountController.initializeAccountStatus(
        accountType: 'free',
        collectionLimit: 10,
        currentCollectionCount: 0,
        deviceInfo: 'Unknown Device',
        deviceId: 'error_${DateTime.now().millisecondsSinceEpoch}',
        isDeviceVerified: true, // Free accounts don't need device verification
      );
    }
  }

  /// Check if the user has a free account
  bool isFreeAccount() {
    return _accountController.isFreeAccount;
  }

  /// Check if the user has a paid account
  bool isPaidAccount() {
    return _accountController.isPaidAccount;
  }

  /// Get the collection limit based on account type
  int getCollectionLimit() {
    return _accountController.accountStatus?.collectionLimit ?? 10;
  }

  /// Get the current collection count
  int getCurrentCollectionCount() {
    return _accountController.accountStatus?.currentCollectionCount ?? 0;
  }

  /// Update the current collection count
  void updateCollectionCount(int count) {
    _accountController.updateCollectionCount(count);
  }

  /// Increment the collection count when a new collection is added
  void incrementCollectionCount() {
    _accountController.incrementCollectionCount();
  }

  /// Decrement the collection count when a collection is removed
  void decrementCollectionCount() {
    _accountController.decrementCollectionCount();
  }

  /// Check if the user can add more collections
  bool canAddMoreCollections() {
    return _accountController.canAddMoreCollections();
  }

  /// Get the number of remaining collections the user can add
  int getRemainingCollections() {
    return _accountController.remainingCollections;
  }

  /// Check if account status has been initialized
  bool isInitialized() {
    return _accountController.isInitialized;
  }

  /// Get the account status controller for direct access
  AccountStatusController get accountController => _accountController;

  /// Get the current account status
  AccountStatus? getAccountStatus() {
    return _accountController.accountStatus;
  }

  /// Check account status with an endpoint (placeholder for future implementation)
  Future<bool> checkAccountStatusWithEndpoint() async {
    try {
      // This is a placeholder for future implementation
      // In the future, this will make an API call to check the account status

      // For now, we'll just return true to indicate the account is valid
      Logger.log('Checking account status with endpoint (placeholder)',
          tag: 'AccountService');

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // In the future, this would:
      // 1. Make an API call to check account status
      // 2. Update the account status based on the response
      // 3. Return true if the account is valid, false otherwise

      return true;
    } catch (e) {
      Logger.error('Error checking account status with endpoint: $e',
          tag: 'AccountService', error: e);
      return false;
    }
  }

  /// Refresh account status from environment variables
  Future<void> refreshAccountStatus() async {
    await _initializeAccountStatus();
  }

  /// Update account type (for future use when implementing account upgrades)
  Future<void> updateAccountType(String newAccountType) async {
    try {
      final collectionLimit = newAccountType.toLowerCase() == 'free'
          ? EnvConfig.limitFree
          : 999999; // High limit for paid accounts

      final currentStatus = _accountController.accountStatus;
      if (currentStatus != null) {
        _accountController.updateAccountStatus(
          currentStatus.copyWith(
            accountType: newAccountType,
            collectionLimit: collectionLimit,
            lastChecked: DateTime.now(),
          ),
        );

        Logger.log(
            'Account type updated to: $newAccountType with limit $collectionLimit',
            tag: 'AccountService');
      }
    } catch (e) {
      Logger.error('Error updating account type: $e',
          tag: 'AccountService', error: e);
    }
  }

  /// Get device information
  String getDeviceInfo() {
    return _accountController.accountStatus?.deviceInfo ?? 'Unknown Device';
  }

  /// Get last checked timestamp
  DateTime? getLastCheckedTimestamp() {
    return _accountController.accountStatus?.lastChecked;
  }

  /// Get device ID
  String getDeviceId() {
    return _accountController.accountStatus?.deviceId ?? '';
  }

  /// Get phone number
  String? getPhoneNumber() {
    return _accountController.accountStatus?.phoneNumber;
  }

  /// Update phone number
  void updatePhoneNumber(String? phoneNumber) {
    final currentStatus = _accountController.accountStatus;
    if (currentStatus != null) {
      _accountController.updateAccountStatus(
        currentStatus.copyWith(
          phoneNumber: phoneNumber,
          lastChecked: DateTime.now(),
        ),
      );
      Logger.log('Phone number updated to: $phoneNumber',
          tag: 'AccountService');
    }
  }

  /// Check if phone number is set
  bool hasPhoneNumber() {
    return _accountController.accountStatus?.phoneNumber != null &&
        _accountController.accountStatus!.phoneNumber!.isNotEmpty;
  }

  /// Check if device is verified
  bool isDeviceVerified() {
    return _accountController.accountStatus?.isDeviceVerified ?? false;
  }

  /// Check if WhatsApp is verified
  bool isWhatsAppVerified() {
    return _accountController.accountStatus?.isWhatsAppVerified ?? false;
  }

  /// Verify current device
  Future<bool> verifyCurrentDevice() async {
    try {
      // Get current device information
      String currentDeviceId = '';
      try {
        if (GetPlatform.isAndroid) {
          final androidInfo = await _deviceInfoPlugin.androidInfo;
          currentDeviceId = androidInfo.id;
        } else if (GetPlatform.isIOS) {
          final iosInfo = await _deviceInfoPlugin.iosInfo;
          currentDeviceId = iosInfo.identifierForVendor ??
              'ios_${DateTime.now().millisecondsSinceEpoch}';
        } else {
          currentDeviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
        }
      } catch (e) {
        Logger.error('Error getting current device info: $e',
            tag: 'AccountService', error: e);
        return false;
      }

      // Check if current device matches stored device ID
      final storedDeviceId = getDeviceId();
      if (storedDeviceId.isEmpty) {
        Logger.warning('No stored device ID found', tag: 'AccountService');
        return false;
      }

      final isMatch = currentDeviceId == storedDeviceId;

      // Update device verification status
      final currentStatus = _accountController.accountStatus;
      if (currentStatus != null) {
        _accountController.updateAccountStatus(
          currentStatus.copyWith(
            isDeviceVerified: isMatch,
            lastChecked: DateTime.now(),
          ),
        );
      }

      Logger.log(
          'Device verification: $isMatch (Current: $currentDeviceId, Stored: $storedDeviceId)',
          tag: 'AccountService');
      return isMatch;
    } catch (e) {
      Logger.error('Error verifying device: $e',
          tag: 'AccountService', error: e);
      return false;
    }
  }

  /// Lock account to current device
  Future<bool> lockAccountToDevice() async {
    try {
      // Get current device information
      String deviceInfo = '';
      String deviceId = '';
      try {
        if (GetPlatform.isAndroid) {
          final androidInfo = await _deviceInfoPlugin.androidInfo;
          deviceInfo =
              'Android ${androidInfo.version.release} - ${androidInfo.model} (${androidInfo.brand})';
          deviceId = androidInfo.id;
        } else if (GetPlatform.isIOS) {
          final iosInfo = await _deviceInfoPlugin.iosInfo;
          deviceInfo =
              'iOS ${iosInfo.systemVersion} - ${iosInfo.model} (${iosInfo.name})';
          deviceId = iosInfo.identifierForVendor ??
              'ios_${DateTime.now().millisecondsSinceEpoch}';
        } else {
          deviceInfo = 'Unknown Platform';
          deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
        }
      } catch (e) {
        Logger.error('Error getting device info for locking: $e',
            tag: 'AccountService', error: e);
        return false;
      }

      // Update account status with new device info and mark as verified
      final currentStatus = _accountController.accountStatus;
      if (currentStatus != null) {
        _accountController.updateAccountStatus(
          currentStatus.copyWith(
            deviceInfo: deviceInfo,
            deviceId: deviceId,
            isDeviceVerified: true,
            lastChecked: DateTime.now(),
          ),
        );
        Logger.log('Account locked to device: $deviceInfo (ID: $deviceId)',
            tag: 'AccountService');
        return true;
      }
      return false;
    } catch (e) {
      Logger.error('Error locking account to device: $e',
          tag: 'AccountService', error: e);
      return false;
    }
  }

  /// Send WhatsApp verification code (placeholder implementation)
  Future<bool> sendWhatsAppVerificationCode(String phoneNumber) async {
    try {
      // This is a placeholder for sending verification code
      // In a real implementation, this would integrate with a WhatsApp API

      Logger.log('Sending WhatsApp verification code to: $phoneNumber',
          tag: 'AccountService');

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, we'll always return true
      // In a real implementation, this would return the success status of the API call
      return true;
    } catch (e) {
      Logger.error('Error sending WhatsApp verification code: $e',
          tag: 'AccountService', error: e);
      return false;
    }
  }

  /// Verify WhatsApp code and lock account to that number
  Future<bool> verifyWhatsAppCodeAndLock(
      String phoneNumber, String verificationCode) async {
    try {
      // This is a placeholder for verifying the code
      // In a real implementation, this would validate the code with your backend

      Logger.log(
          'Verifying WhatsApp code for: $phoneNumber with code: $verificationCode',
          tag: 'AccountService');

      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, we'll accept any 6-digit code
      final isValidCode = verificationCode.length == 6 &&
          int.tryParse(verificationCode) != null;

      if (isValidCode) {
        // Update account status with verified WhatsApp number
        final currentStatus = _accountController.accountStatus;
        if (currentStatus != null) {
          _accountController.updateAccountStatus(
            currentStatus.copyWith(
              phoneNumber: phoneNumber,
              isWhatsAppVerified: true,
              lastChecked: DateTime.now(),
            ),
          );
          Logger.log('WhatsApp number verified and locked: $phoneNumber',
              tag: 'AccountService');
          return true;
        }
      }

      return false;
    } catch (e) {
      Logger.error('Error verifying WhatsApp code: $e',
          tag: 'AccountService', error: e);
      return false;
    }
  }

  /// Check if paid user is properly verified
  bool isPaidUserVerified() {
    if (isFreeAccount()) {
      return true; // Free users don't need verification
    }

    return isDeviceVerified() && isWhatsAppVerified();
  }

  /// Check if account access is allowed based on verification status
  bool isAccountAccessAllowed() {
    // Free users always have access
    if (isFreeAccount()) {
      return true;
    }

    // Paid users need both device and WhatsApp verification
    return isDeviceVerified() && isWhatsAppVerified();
  }
}
