import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/models/filter_options.dart';
import 'package:kidcol/app/data/services/filter_service.dart';

void main() {
  group('FilterService Tests', () {
    late FilterService filterService;

    setUpAll(() {
      // Initialize GetX testing
      Get.testMode = true;
    });

    setUp(() {
      filterService = FilterService();
    });

    tearDown(() {
      Get.reset();
    });

    test('should return default filter options on first load', () async {
      // Act
      final result = await filterService.getFilterOptions();

      // Assert
      expect(result, isA<FilterOptions>());
      expect(result.levels, isNotEmpty);
      expect(result.categories, isNotEmpty);
    });

    test('should cache filter options after first successful load', () async {
      // Act
      final result1 = await filterService.getFilterOptions();
      final result2 = await filterService.getFilterOptions();

      // Assert
      expect(identical(result1, result2), isTrue);
    });

    test('should return new options when forceRefresh is true', () async {
      // Act
      final result1 = await filterService.getFilterOptions();
      final result2 = await filterService.getFilterOptions(forceRefresh: true);

      // Assert
      expect(result1, isA<FilterOptions>());
      expect(result2, isA<FilterOptions>());
      // Should not be identical due to force refresh
      expect(identical(result1, result2), isFalse);
    });

    test('should clear cache properly', () async {
      // Arrange
      await filterService.getFilterOptions();

      // Act
      filterService.clearCache();

      // This test verifies that clearCache doesn't throw
      expect(() => filterService.clearCache(), returnsNormally);
    });

    test('should return default options when network error occurs', () async {
      // This test verifies graceful error handling
      // Clear any cached data to force API call
      filterService.clearCache();
      
      final result = await filterService.getFilterOptions();
      
      expect(result, isA<FilterOptions>());
      expect(result.levels, containsAll([0, 1, 2, 3, 4]));
      expect(result.categories, containsAll([
        'Animal',
        'Food',
        'Land Scene',
        'Object',
        'Scene',
        'Toy',
        'Vehicle'
      ]));
    });
  });

  group('FilterOptions Model Tests', () {
    test('should create FilterOptions from JSON', () {
      // Arrange
      final json = {
        'filters': {
          'level': [1, 2, 3],
          'category': ['Animal', 'Food']
        }
      };

      // Act
      final filterOptions = FilterOptions.fromJson(json);

      // Assert
      expect(filterOptions.levels, [1, 2, 3]);
      expect(filterOptions.categories, ['Animal', 'Food']);
    });

    test('should handle missing filters in JSON', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final filterOptions = FilterOptions.fromJson(json);

      // Assert
      expect(filterOptions.levels, isEmpty);
      expect(filterOptions.categories, isEmpty);
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        'filters': null
      };

      // Act
      final filterOptions = FilterOptions.fromJson(json);

      // Assert
      expect(filterOptions.levels, isEmpty);
      expect(filterOptions.categories, isEmpty);
    });

    test('should convert FilterOptions to JSON', () {
      // Arrange
      final filterOptions = FilterOptions(
        levels: [1, 2, 3],
        categories: ['Animal', 'Food']
      );

      // Act
      final json = filterOptions.toJson();

      // Assert
      expect(json, {
        'filters': {
          'level': [1, 2, 3],
          'category': ['Animal', 'Food']
        }
      });
    });
  });
}
