import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/data/entities/koleksi.dart';
import 'package:kidcol/app/data/models/account_status.dart';
import 'package:kidcol/app/data/services/isar_service.dart';
import 'package:kidcol/app/data/services/account_service.dart';
import 'package:kidcol/app/data/services/filter_service.dart';
import 'package:kidcol/app/modules/home/controllers/home_controller.dart';

// Mock implementation using noSuchMethod for simplicity
class MockIsarService extends GetxService implements IsarService {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Return appropriate default values based on return type
    if (invocation.isGetter) {
      if (invocation.memberName == #db) {
        return Future.value(null);
      }
      if (invocation.memberName == #isInitialized) {
        return false;
      }
    }

    // For methods that return Future
    final returnType = invocation.memberName.toString();
    if (returnType.contains('Future')) {
      if (returnType.contains('List')) {
        return Future.value([]);
      }
      if (returnType.contains('bool')) {
        return Future.value(true);
      }
      if (returnType.contains('int')) {
        return Future.value(0);
      }
      return Future.value(null);
    }

    // For Stream methods
    if (returnType.contains('Stream')) {
      return Stream.empty();
    }

    // For synchronous methods
    if (returnType.contains('List')) {
      return [];
    }
    if (returnType.contains('bool')) {
      return true;
    }
    if (returnType.contains('int')) {
      return 0;
    }

    return super.noSuchMethod(invocation);
  }

  // Override only the methods we actually need for testing
  @override
  Future<List<Koleksi>> getAllKoleksis() async => [];
}

class MockAccountService extends GetxService implements AccountService {
  @override
  Future<void> onInit() async {
    // Mock implementation - do nothing
    super.onInit();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Return appropriate default values
    if (invocation.isGetter) {
      if (invocation.memberName == #accountController) {
        return null;
      }
    }

    final returnType = invocation.memberName.toString();
    if (returnType.contains('Future')) {
      if (returnType.contains('bool')) {
        return Future.value(true);
      }
      return Future.value(null);
    }

    if (returnType.contains('bool')) {
      return true;
    }
    if (returnType.contains('int')) {
      return 10;
    }
    if (returnType.contains('String')) {
      return 'test';
    }

    return super.noSuchMethod(invocation);
  }

  // Override only the methods we actually need for testing
  @override
  bool isAccountAccessAllowed() => true;

  @override
  bool isDeviceVerified() => true;

  @override
  bool isPaidAccount() => false;

  @override
  bool isWhatsAppVerified() => true;

  @override
  AccountStatus? getAccountStatus() => null;
}

void main() {
  group('HomeController Filter Tests', () {
    setUpAll(() {
      // Initialize GetX testing
      Get.testMode = true;
    });

    setUp(() {
      // Register mock services
      Get.put<IsarService>(MockIsarService());
      Get.put<AccountService>(MockAccountService());
      Get.put<FilterService>(FilterService());
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize with no active filters', () {
      // Act
      final controller = HomeController();

      // Assert
      expect(controller.selectedLevel.value, isNull);
      expect(controller.selectedCategory.value, isNull);
      expect(controller.hasActiveFilters.value, isFalse);
    });

    test('should update filter status when level is set', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(level: 2);

      // Assert
      expect(controller.selectedLevel.value, 2);
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should update filter status when category is set', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(category: 'Animal');

      // Assert
      expect(controller.selectedCategory.value, 'Animal');
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should update filter status when both filters are set', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(level: 2, category: 'Animal');

      // Assert
      expect(controller.selectedLevel.value, 2);
      expect(controller.selectedCategory.value, 'Animal');
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should reset filter status when both filters are null', () {
      // Arrange
      final controller = HomeController();
      controller.setFilters(level: 2, category: 'Animal');
      expect(controller.hasActiveFilters.value, isTrue);

      // Act
      controller.resetFilters();

      // Assert
      expect(controller.selectedLevel.value, isNull);
      expect(controller.selectedCategory.value, isNull);
      expect(controller.hasActiveFilters.value, isFalse);
    });

    test('should set filters correctly', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(level: 3, category: 'Food');

      // Assert
      expect(controller.selectedLevel.value, 3);
      expect(controller.selectedCategory.value, 'Food');
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should set filters with only level', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(level: 1);

      // Assert
      expect(controller.selectedLevel.value, 1);
      expect(controller.selectedCategory.value, isNull);
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should set filters with only category', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(category: 'Vehicle');

      // Assert
      expect(controller.selectedLevel.value, isNull);
      expect(controller.selectedCategory.value, 'Vehicle');
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should reset all filters', () {
      // Arrange
      final controller = HomeController();
      controller.setFilters(level: 2, category: 'Animal');

      // Act
      controller.resetFilters();

      // Assert
      expect(controller.selectedLevel.value, isNull);
      expect(controller.selectedCategory.value, isNull);
      expect(controller.hasActiveFilters.value, isFalse);
      expect(controller.page.value, 1);
      expect(controller.assets.length, 0);
    });

    test('should apply filters and reset data', () {
      // Arrange
      final controller = HomeController();
      controller.selectedLevel.value = 3;
      controller.selectedCategory.value = 'Food';

      // Act
      controller.applyFilters();

      // Assert
      expect(controller.page.value, 1); // Should reset to page 1
      expect(controller.assets.length, 0); // Should clear assets
      expect(controller.hasActiveFilters.value,
          isTrue); // Should update filter status
    });

    test('should handle null filters gracefully', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(level: null, category: null);

      // Assert
      expect(controller.selectedLevel.value, isNull);
      expect(controller.selectedCategory.value, isNull);
      expect(controller.hasActiveFilters.value, isFalse);
    });

    test('should clear assets when resetting data', () {
      // Arrange
      final controller = HomeController();
      // Simulate having some assets
      controller.page.value = 3;

      // Act
      controller.resetData();

      // Assert
      expect(controller.assets.length, 0);
      expect(controller.page.value, 1);
      expect(controller.retryCount.value, 0);
    });

    test('should maintain filter state after applying filters', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.setFilters(level: 4, category: 'Scene');

      // Assert
      expect(controller.selectedLevel.value, 4);
      expect(controller.selectedCategory.value, 'Scene');
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should update hasActiveFilters when only level is set', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.selectedLevel.value = 3;
      controller.applyFilters();

      // Assert
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should update hasActiveFilters when only category is set', () {
      // Arrange
      final controller = HomeController();

      // Act
      controller.selectedCategory.value = 'Toy';
      controller.applyFilters();

      // Assert
      expect(controller.hasActiveFilters.value, isTrue);
    });

    test('should not have active filters when both are null', () {
      // Arrange
      final controller = HomeController();
      controller.setFilters(level: 2, category: 'Animal');

      // Act
      controller.selectedLevel.value = null;
      controller.selectedCategory.value = null;
      controller.applyFilters();

      // Assert
      expect(controller.hasActiveFilters.value, isFalse);
    });
  });
}
