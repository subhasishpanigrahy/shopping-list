import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/main.dart';
import 'package:shopping_list/models/product_category.dart';
import 'package:shopping_list/models/store_info.dart';
import 'package:shopping_list/widgets/shopping_item_tile.dart';
import 'package:shopping_list/widgets/store_card.dart';
import 'package:shopping_list/widgets/store_sheet.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Full User Workflow Integration Tests', () {
    testWidgets('Complete End-to-End Shopping List Workflow', (WidgetTester tester) async {
      // 1. Boot Application
      await tester.pumpWidget(const SmartListApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 2. Verify Root Header and Metrics Bar
      expect(find.text('Shopping List'), findsOneWidget);
      expect(find.text('Universal Store & Web Aggregator'), findsOneWidget);

      // Verify default seeded items loaded
      expect(find.text('Nike Air Max 270'), findsOneWidget);
      expect(find.text('MacBook Air M3'), findsOneWidget);
      expect(find.text('Almond Butter'), findsOneWidget);
      expect(find.text('CeraVe Hydrating Cleanser'), findsOneWidget);

      // Verify initial stats (4 To Buy, 0 Done)
      expect(find.text('To Buy'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // 3. Test Add Item with Ambient AI Detection
      final inputField = find.byType(TextField);
      expect(inputField, findsOneWidget);

      // Type an item: "Sony PS5 DualSense"
      await tester.enterText(inputField, 'Sony PS5 DualSense');
      await tester.pump();

      // Verify ambient categorization chip appeared in AddItemBar
      expect(find.text('Auto-detected:'), findsOneWidget);
      expect(find.text('Tech & Gadgets'), findsAtLeast(1));
      expect(find.text('Sony'), findsAtLeast(1));

      // Submit the item
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify new item is prepended at the top of the list
      expect(find.text('Sony PS5 DualSense'), findsOneWidget);
      expect(find.text('5'), findsOneWidget); // 5 items To Buy now

      // 4. Test Strike-through Toggle
      final firstTile = find.widgetWithText(ShoppingItemTile, 'Nike Air Max 270');
      expect(firstTile, findsOneWidget);

      final checkFinder = find.descendant(
        of: firstTile,
        matching: find.byWidgetPredicate((widget) =>
            widget.key != null &&
            widget.key.toString().contains('checkbox_')),
      );
      await tester.tap(checkFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify completion metrics updated (4 To Buy, 1 Done)
      expect(find.text('1'), findsOneWidget);

      // 5. Test Category Filter Chips
      final fashionChip = find.text('Sneakers & Fashion');
      expect(fashionChip, findsAtLeast(1));
      await tester.tap(fashionChip.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // "Nike Air Max 270" should be visible, non-fashion items should be hidden
      expect(find.text('Nike Air Max 270'), findsOneWidget);
      expect(find.text('Almond Butter'), findsNothing);

      // Tap "All Items" to restore full view
      await tester.tap(find.text('All Items'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Almond Butter'), findsOneWidget);

      // 6. Test StoreSheet Modal Trigger
      await tester.tap(find.text('Almond Butter'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify StoreSheet opened
      expect(find.byType(StoreSheet), findsOneWidget);
      expect(find.text('Universal Store Aggregator'), findsOneWidget);

      // Verify StoreSheet search refinement bar is pre-populated
      expect(find.widgetWithText(TextField, 'Almond Butter'), findsOneWidget);

      // Verify Quick Commerce & Grocery Stores are indexed in the sheet
      expect(find.byType(StoreCard), findsWidgets);
      expect(find.text('Blinkit'), findsOneWidget);

      // Close the StoreSheet
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(StoreSheet), findsNothing);
    });

    test('StoreInfo custom store serialization test', () {
      const custom = StoreInfo(
        id: 'custom_123',
        name: 'Decathlon',
        category: ProductCategory.fashion,
        webSearchUrlTemplate: 'https://decathlon.in/search?q={query}',
        logoUrl: 'https://unavatar.io/decathlon.in',
        brandColor: Color(0xFF0082C3),
        isCustom: true,
        badgeText: '⭐ Custom Store',
        tagline: 'Sports gear & apparel',
      );

      final json = custom.toJson();
      expect(json['isCustom'], isTrue);
      expect(json['name'], 'Decathlon');

      final deserialized = StoreInfo.fromJson(json);
      expect(deserialized.id, 'custom_123');
      expect(deserialized.name, 'Decathlon');
      expect(deserialized.isCustom, isTrue);
      expect(deserialized.buildWebSearchUrl('running shoes'), 'https://decathlon.in/search?q=running%20shoes');
    });
  });
}
