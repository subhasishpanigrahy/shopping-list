import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/data/store_catalog.dart';
import 'package:shopping_list/models/product_category.dart';
import 'package:shopping_list/services/category_detector.dart';

void main() {
  group('Category & Brand Engine Tests', () {
    test('Sneakers & Fashion detection', () {
      final res = CategoryDetector.detect('Nike Air Max 270');
      expect(res.category, ProductCategory.fashion);
      expect(res.brand, 'Nike');

      final res2 = CategoryDetector.detect(
        'Adidas Ultraboost Light Running Shoes',
      );
      expect(res2.category, ProductCategory.fashion);
      expect(res2.brand, 'Adidas');

      final res3 = CategoryDetector.detect('Zara Oversized Denim Jacket');
      expect(res3.category, ProductCategory.fashion);
      expect(res3.brand, 'Zara');
    });

    test('Electronics & Tech detection', () {
      final res = CategoryDetector.detect('MacBook Air M3 16GB');
      expect(res.category, ProductCategory.electronics);
      expect(res.brand, 'Apple');

      final res2 = CategoryDetector.detect('Samsung Galaxy S24 Ultra');
      expect(res2.category, ProductCategory.electronics);
      expect(res2.brand, 'Samsung');

      final res3 = CategoryDetector.detect('Sony PS5 Wireless Controller');
      expect(res3.category, ProductCategory.electronics);
      expect(res3.brand, 'Sony');
    });

    test('Groceries detection', () {
      final res = CategoryDetector.detect('Almond Butter');
      expect(res.category, ProductCategory.groceries);

      final res2 = CategoryDetector.detect('Organic Rolled Oats 1kg');
      expect(res2.category, ProductCategory.groceries);

      final res3 = CategoryDetector.detect('Amul Butter 500g');
      expect(res3.category, ProductCategory.groceries);
      expect(res3.brand, 'Amul');
    });

    test('Beauty & Skincare detection', () {
      final res = CategoryDetector.detect('CeraVe Hydrating Cleanser');
      expect(res.category, ProductCategory.beauty);
      expect(res.brand, 'CeraVe');

      final res2 = CategoryDetector.detect('The Ordinary Niacinamide Serum');
      expect(res2.category, ProductCategory.beauty);
      expect(res2.brand, 'The Ordinary');

      final res3 = CategoryDetector.detect('tongue cleaner');
      expect(res3.category, ProductCategory.beauty);
    });

    test('Home & Living detection', () {
      final res = CategoryDetector.detect('IKEA Ergonomic Desk Chair');
      expect(res.category, ProductCategory.home);
      expect(res.brand, 'IKEA');
    });

    test('Store Prioritization for tongue cleaner includes Meesho and Myntra', () {
      final detection = CategoryDetector.detect('tongue cleaner');
      final prioritization = StoreCatalog.getPrioritizedStores(
        query: 'tongue cleaner',
        category: detection.category,
      );

      final relevantIds = prioritization.relevantStores.map((s) => s.id).toList();
      final otherIds = prioritization.otherStores.map((s) => s.id).toList();

      expect(relevantIds, contains('meesho'));
      expect(relevantIds, contains('myntra'));
      expect(relevantIds, contains('ajio'));
      expect(relevantIds, contains('nykaa'));
      expect(relevantIds, contains('blinkit'));
      expect(relevantIds, contains('amazon'));

      // Irrelevant single-brand stores must be in otherStores
      expect(otherIds, contains('nike_official'));
      expect(otherIds, contains('apple_store'));
    });

    test('Mosquito stick detection and Store Prioritization includes Blinkit, Zepto, Instamart, BigBasket', () {
      final detection = CategoryDetector.detect('mosquito stick');
      expect(detection.category, ProductCategory.groceries);

      final prioritization = StoreCatalog.getPrioritizedStores(
        query: 'mosquito stick',
        category: detection.category,
      );

      final relevantIds = prioritization.relevantStores.map((s) => s.id).toList();
      final otherIds = prioritization.otherStores.map((s) => s.id).toList();

      // Quick commerce & general marketplaces must be in relevantStores
      expect(relevantIds, contains('blinkit'));
      expect(relevantIds, contains('zepto'));
      expect(relevantIds, contains('swiggy_instamart'));
      expect(relevantIds, contains('bigbasket'));
      expect(relevantIds, contains('jiomart'));
      expect(relevantIds, contains('amazon'));
      expect(relevantIds, contains('flipkart'));
      expect(relevantIds, contains('meesho'));

      // Specialty apparel & single-brand tech stores must be hidden in otherStores
      expect(otherIds, contains('nike_official'));
      expect(otherIds, contains('apple_store'));
      expect(otherIds, contains('zara'));
      expect(otherIds, contains('croma'));
    });

    test('General everyday items fallback prioritizes Quick Commerce and general marketplaces', () {
      final prioritization = StoreCatalog.getPrioritizedStores(
        query: 'gift wrapping paper and tape',
        category: ProductCategory.general,
      );

      final relevantIds = prioritization.relevantStores.map((s) => s.id).toList();
      final otherIds = prioritization.otherStores.map((s) => s.id).toList();

      expect(relevantIds, contains('blinkit'));
      expect(relevantIds, contains('zepto'));
      expect(relevantIds, contains('swiggy_instamart'));
      expect(relevantIds, contains('bigbasket'));
      expect(relevantIds, contains('amazon'));
      expect(relevantIds, contains('flipkart'));

      expect(otherIds, contains('nike_official'));
      expect(otherIds, contains('apple_store'));
    });
  });
}
