import 'package:get/get.dart';

/// Model to represent the account status of the user
class AccountStatus {
  /// Account type (free or paid)
  final String accountType;

  /// Collection limit based on account type
  final int collectionLimit;

  /// Current number of collections
  final int currentCollectionCount;

  /// Device information
  final String deviceInfo;

  /// Device ID for tracking
  final String deviceId;

  /// Phone number for account validation
  final String? phoneNumber;

  /// WhatsApp verification status
  final bool isWhatsAppVerified;

  /// Device verification status
  final bool isDeviceVerified;

  /// Timestamp of last status check
  final DateTime lastChecked;

  AccountStatus({
    required this.accountType,
    required this.collectionLimit,
    required this.currentCollectionCount,
    required this.deviceInfo,
    required this.deviceId,
    this.phoneNumber,
    this.isWhatsAppVerified = false,
    this.isDeviceVerified = false,
    required this.lastChecked,
  });

  /// Create an AccountStatus from JSON
  factory AccountStatus.fromJson(Map<String, dynamic> json) {
    return AccountStatus(
      accountType: json['accountType'] ?? 'free',
      collectionLimit: json['collectionLimit'] ?? 10,
      currentCollectionCount: json['currentCollectionCount'] ?? 0,
      deviceInfo: json['deviceInfo'] ?? '',
      deviceId: json['deviceId'] ?? '',
      phoneNumber: json['phoneNumber'],
      isWhatsAppVerified: json['isWhatsAppVerified'] ?? false,
      isDeviceVerified: json['isDeviceVerified'] ?? false,
      lastChecked: DateTime.tryParse(json['lastChecked']) ?? DateTime.now(),
    );
  }

  /// Convert AccountStatus to JSON
  Map<String, dynamic> toJson() {
    return {
      'accountType': accountType,
      'collectionLimit': collectionLimit,
      'currentCollectionCount': currentCollectionCount,
      'deviceInfo': deviceInfo,
      'deviceId': deviceId,
      'phoneNumber': phoneNumber,
      'isWhatsAppVerified': isWhatsAppVerified,
      'isDeviceVerified': isDeviceVerified,
      'lastChecked': lastChecked.toIso8601String(),
    };
  }

  /// Check if the user can add more collections
  bool canAddMoreCollections() {
    return currentCollectionCount < collectionLimit;
  }

  /// Get remaining collections allowed
  int get remainingCollections {
    return (collectionLimit - currentCollectionCount).clamp(0, collectionLimit);
  }

  /// Check if this is a free account
  bool get isFreeAccount {
    return accountType.toLowerCase() == 'free';
  }

  /// Check if this is a paid account
  bool get isPaidAccount {
    return accountType.toLowerCase() == 'paid';
  }

  /// Create a copy with updated values
  AccountStatus copyWith({
    String? accountType,
    int? collectionLimit,
    int? currentCollectionCount,
    String? deviceInfo,
    String? deviceId,
    String? phoneNumber,
    bool? isWhatsAppVerified,
    bool? isDeviceVerified,
    DateTime? lastChecked,
  }) {
    return AccountStatus(
      accountType: accountType ?? this.accountType,
      collectionLimit: collectionLimit ?? this.collectionLimit,
      currentCollectionCount:
          currentCollectionCount ?? this.currentCollectionCount,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      deviceId: deviceId ?? this.deviceId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isWhatsAppVerified: isWhatsAppVerified ?? this.isWhatsAppVerified,
      isDeviceVerified: isDeviceVerified ?? this.isDeviceVerified,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }

  @override
  String toString() {
    return 'AccountStatus(accountType: $accountType, collectionLimit: $collectionLimit, currentCollectionCount: $currentCollectionCount, deviceInfo: $deviceInfo, deviceId: $deviceId, phoneNumber: $phoneNumber, isWhatsAppVerified: $isWhatsAppVerified, isDeviceVerified: $isDeviceVerified, lastChecked: $lastChecked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountStatus &&
        other.accountType == accountType &&
        other.collectionLimit == collectionLimit &&
        other.currentCollectionCount == currentCollectionCount &&
        other.deviceInfo == deviceInfo &&
        other.deviceId == deviceId &&
        other.phoneNumber == phoneNumber &&
        other.isWhatsAppVerified == isWhatsAppVerified &&
        other.isDeviceVerified == isDeviceVerified &&
        other.lastChecked == lastChecked;
  }

  @override
  int get hashCode {
    return accountType.hashCode ^
        collectionLimit.hashCode ^
        currentCollectionCount.hashCode ^
        deviceInfo.hashCode ^
        deviceId.hashCode ^
        phoneNumber.hashCode ^
        isWhatsAppVerified.hashCode ^
        isDeviceVerified.hashCode ^
        lastChecked.hashCode;
  }
}

/// Controller for managing account status globally using GetX
class AccountStatusController extends GetxController {
  final _accountStatus = Rx<AccountStatus?>(null);

  /// Get the current account status
  AccountStatus? get accountStatus => _accountStatus.value;

  /// Check if account status has been initialized
  bool get isInitialized => _accountStatus.value != null;

  /// Update the account status
  void updateAccountStatus(AccountStatus newStatus) {
    _accountStatus.value = newStatus;
  }

  /// Initialize account status with default values
  void initializeAccountStatus({
    required String accountType,
    required int collectionLimit,
    int currentCollectionCount = 0,
    String deviceInfo = '',
    String deviceId = '',
    String? phoneNumber,
    bool isWhatsAppVerified = false,
    bool isDeviceVerified = false,
  }) {
    _accountStatus.value = AccountStatus(
      accountType: accountType,
      collectionLimit: collectionLimit,
      currentCollectionCount: currentCollectionCount,
      deviceInfo: deviceInfo,
      deviceId: deviceId,
      phoneNumber: phoneNumber,
      isWhatsAppVerified: isWhatsAppVerified,
      isDeviceVerified: isDeviceVerified,
      lastChecked: DateTime.now(),
    );
  }

  /// Update the current collection count
  void updateCollectionCount(int newCount) {
    if (_accountStatus.value != null) {
      _accountStatus.value = _accountStatus.value!.copyWith(
        currentCollectionCount: newCount,
        lastChecked: DateTime.now(),
      );
    }
  }

  /// Increment the collection count
  void incrementCollectionCount() {
    if (_accountStatus.value != null) {
      updateCollectionCount(_accountStatus.value!.currentCollectionCount + 1);
    }
  }

  /// Decrement the collection count
  void decrementCollectionCount() {
    if (_accountStatus.value != null &&
        _accountStatus.value!.currentCollectionCount > 0) {
      updateCollectionCount(_accountStatus.value!.currentCollectionCount - 1);
    }
  }

  /// Check if the user can add more collections
  bool canAddMoreCollections() {
    return _accountStatus.value?.canAddMoreCollections() ?? false;
  }

  /// Get remaining collections allowed
  int get remainingCollections {
    return _accountStatus.value?.remainingCollections ?? 0;
  }

  /// Check if this is a free account
  bool get isFreeAccount {
    return _accountStatus.value?.isFreeAccount ?? true;
  }

  /// Check if this is a paid account
  bool get isPaidAccount {
    return _accountStatus.value?.isPaidAccount ?? false;
  }
}
