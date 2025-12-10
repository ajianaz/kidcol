import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/data/models/filter_options.dart';
import 'package:kidcol/app/modules/home/controllers/home_controller.dart';
import 'package:kidcol/app/modules/home/widgets/filter_dialog.dart';

void main() {
  group('FilterDialog Widget Tests', () {
    late HomeController controller;
    late FilterOptions testFilterOptions;

    setUpAll(() {
      // Initialize GetX testing
      Get.testMode = true;
    });

    setUp(() {
      controller = HomeController();
      Get.put<HomeController>(controller);
      
      testFilterOptions = FilterOptions(
        levels: [0, 1, 2, 3, 4],
        categories: ['Animal', 'Food', 'Land Scene', 'Object', 'Scene', 'Toy', 'Vehicle'],
      );
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: FilterDialog(filterOptions: testFilterOptions),
        ),
      );
    }

    testWidgets('should display filter dialog with all components', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify header
      expect(find.text('Filter Gambar'), findsOneWidget);
      expect(find.text('Pilih kategori dan level gambar'), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Verify category section
      expect(find.text('Kategori'), findsOneWidget);
      expect(find.text('Pilih Kategori'), findsOneWidget);

      // Verify level section
      expect(find.text('Level'), findsOneWidget);
      
      // Verify level chips
      expect(find.text('Level 0'), findsOneWidget);
      expect(find.text('Level 1'), findsOneWidget);
      expect(find.text('Level 2'), findsOneWidget);
      expect(find.text('Level 3'), findsOneWidget);
      expect(find.text('Level 4'), findsOneWidget);

      // Verify action buttons
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Terapkan'), findsOneWidget);
    });

    testWidgets('should display all category options', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on dropdown to open it
      await tester.tap(find.text('Pilih Kategori'));
      await tester.pumpAndSettle();

      // Verify all categories are displayed
      expect(find.text('Semua Kategori'), findsOneWidget);
      expect(find.text('Animal'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Land Scene'), findsOneWidget);
      expect(find.text('Object'), findsOneWidget);
      expect(find.text('Scene'), findsOneWidget);
      expect(find.text('Toy'), findsOneWidget);
      expect(find.text('Vehicle'), findsOneWidget);
    });

    testWidgets('should select category when tapped', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on dropdown to open it
      await tester.tap(find.text('Pilih Kategori'));
      await tester.pumpAndSettle();

      // Tap on Animal category
      await tester.tap(find.text('Animal'));
      await tester.pumpAndSettle();

      // Verify the selection is reflected
      expect(find.text('Animal'), findsOneWidget);
    });

    testWidgets('should select level chip when tapped', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find level 2 chip
      final level2Chip = find.widgetWithText(GestureDetector, 'Level 2');
      expect(level2Chip, findsOneWidget);

      // Tap on level 2 chip
      await tester.tap(level2Chip);
      await tester.pumpAndSettle();

      // Verify the chip is selected (it should have different styling)
      // Note: We can't easily verify styling changes in widget tests, 
      // but we can verify the interaction doesn't cause errors
    });

    testWidgets('should reset filters when reset button is tapped', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // First select a category
      await tester.tap(find.text('Pilih Kategori'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Animal'));
      await tester.pumpAndSettle();

      // Select a level
      final level2Chip = find.widgetWithText(GestureDetector, 'Level 2');
      await tester.tap(level2Chip);
      await tester.pumpAndSettle();

      // Tap reset button
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // Verify dropdown shows placeholder again
      expect(find.text('Pilih Kategori'), findsOneWidget);
    });

    testWidgets('should close dialog when close button is tapped', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify dialog is closed (no longer present in widget tree)
      expect(find.text('Filter Gambar'), findsNothing);
    });

    testWidgets('should apply filters when Terapkan button is tapped', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select a category
      await tester.tap(find.text('Pilih Kategori'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Animal'));
      await tester.pumpAndSettle();

      // Select a level
      final level2Chip = find.widgetWithText(GestureDetector, 'Level 2');
      await tester.tap(level2Chip);
      await tester.pumpAndSettle();

      // Tap apply button
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Filter Gambar'), findsNothing);
    });

    testWidgets('should handle empty filter options gracefully', (WidgetTester tester) async {
      // Create filter options with no levels or categories
      final emptyFilterOptions = FilterOptions(
        levels: [],
        categories: [],
      );

      // Build widget with empty options
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDialog(filterOptions: emptyFilterOptions),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify dialog still displays correctly
      expect(find.text('Filter Gambar'), findsOneWidget);
      expect(find.text('Kategori'), findsOneWidget);
      expect(find.text('Level'), findsOneWidget);
      
      // Verify no level chips are displayed (since levels list is empty)
      expect(find.text('Level 0'), findsNothing);
    });

    testWidgets('should animate correctly on open', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(createTestWidget());

      // Check initial state (should be faded/scaled)
      expect(find.text('Filter Gambar'), findsOneWidget);

      // Pump animation frames
      await tester.pump(const Duration(milliseconds: 150));
      
      // Should still be animating
      expect(find.text('Filter Gambar'), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();

      // Should be fully visible
      expect(find.text('Filter Gambar'), findsOneWidget);
    });
  });
}
