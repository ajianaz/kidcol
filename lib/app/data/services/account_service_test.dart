import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/services/account_service.dart';
import 'package:kidcol/app/data/models/account_status.dart';

void main() {
  group('Account Service Tests', () {
    late AccountService accountService;

    setUp(() {
      // Initialize GetX for testing
      Get.testMode = true;
      accountService = AccountService();
    });

    tearDown(() {
      // Reset GetX after each test
      Get.reset();
    });

    test('should initialize with default values', () async {
      // Initialize the service
      await accountService.onInit();

      // Check if the account status is initialized
      expect(accountService.isInitialized(), isTrue);

      // Check default values
      expect(accountService.isFreeAccount(), isTrue);
      expect(accountService.isPaidAccount(), isFalse);
      expect(accountService.getCollectionLimit(), equals(10));
      expect(accountService.getCurrentCollectionCount(), equals(0));
      expect(accountService.canAddMoreCollections(), isTrue);
      expect(accountService.getRemainingCollections(), equals(10));
      expect(accountService.getDeviceId().isNotEmpty, isTrue);
      expect(accountService.hasPhoneNumber(), isFalse);
    });

    test('should update collection count correctly', () async {
      // Initialize the service
      await accountService.onInit();

      // Update collection count
      accountService.updateCollectionCount(5);
      expect(accountService.getCurrentCollectionCount(), equals(5));
      expect(accountService.getRemainingCollections(), equals(5));

      // Increment collection count
      accountService.incrementCollectionCount();
      expect(accountService.getCurrentCollectionCount(), equals(6));
      expect(accountService.getRemainingCollections(), equals(4));

      // Decrement collection count
      accountService.decrementCollectionCount();
      expect(accountService.getCurrentCollectionCount(), equals(5));
      expect(accountService.getRemainingCollections(), equals(5));
    });

    test('should check if user can add more collections', () async {
      // Initialize the service
      await accountService.onInit();

      // Set collection count to limit
      accountService.updateCollectionCount(10);
      expect(accountService.canAddMoreCollections(), isFalse);
      expect(accountService.getRemainingCollections(), equals(0));

      // Decrement to allow adding more
      accountService.decrementCollectionCount();
      expect(accountService.canAddMoreCollections(), isTrue);
      expect(accountService.getRemainingCollections(), equals(1));
    });

    test('should update phone number correctly', () async {
      // Initialize the service
      await accountService.onInit();

      // Initially no phone number
      expect(accountService.hasPhoneNumber(), isFalse);
      expect(accountService.getPhoneNumber(), isNull);

      // Update phone number
      accountService.updatePhoneNumber('+1234567890');
      expect(accountService.hasPhoneNumber(), isTrue);
      expect(accountService.getPhoneNumber(), equals('+1234567890'));
    });

    test('should get account status correctly', () async {
      // Initialize the service
      await accountService.onInit();

      // Get account status
      final accountStatus = accountService.getAccountStatus();
      expect(accountStatus, isNotNull);
      expect(accountStatus!.accountType, equals('free'));
      expect(accountStatus.collectionLimit, equals(10));
      expect(accountStatus.deviceId.isNotEmpty, isTrue);
    });
  });
}
