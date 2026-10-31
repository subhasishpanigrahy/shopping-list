import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/data/store_catalog.dart';
import 'package:shopping_list/services/affiliate_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AffiliateService.initialize();
    await AffiliateService.updateConfig(
      cuelinksPubId: '',
      amazonTag: '',
      flipkartId: '',
      isEnabled: true,
    );
  });

  group('AffiliateService Tests', () {
    test('Unaltered URL when no affiliate IDs are set', () {
      final amazon = StoreCatalog.allStores.firstWhere((s) => s.id == 'amazon');
      final originalUrl = amazon.buildWebSearchUrl('shoes');
      final wrapped = AffiliateService.wrapUrl(originalUrl, amazon);

      expect(wrapped, equals(originalUrl));
      expect(wrapped, isNot(contains('tag=')));
    });

    test('Amazon Associates tag is appended correctly', () async {
      await AffiliateService.updateConfig(amazonTag: 'smartcart-21');
      final amazon = StoreCatalog.allStores.firstWhere((s) => s.id == 'amazon');
      final originalUrl = amazon.buildWebSearchUrl('shoes');
      final wrapped = AffiliateService.wrapUrl(originalUrl, amazon);

      expect(wrapped, contains('tag=smartcart-21'));
      expect(wrapped, startsWith('https://www.amazon.in/s?k=shoes&tag=smartcart-21'));
    });

    test('Flipkart Affiliate ID is appended correctly', () async {
      await AffiliateService.updateConfig(flipkartId: 'myflipkartaff');
      final flipkart = StoreCatalog.allStores.firstWhere((s) => s.id == 'flipkart');
      final originalUrl = flipkart.buildWebSearchUrl('phone');
      final wrapped = AffiliateService.wrapUrl(originalUrl, flipkart);

      expect(wrapped, contains('affid=myflipkartaff'));
    });

    test('Cuelinks universal redirect wraps third-party stores (Myntra, Ajio, Blinkit)', () async {
      await AffiliateService.updateConfig(cuelinksPubId: '987654');
      final myntra = StoreCatalog.allStores.firstWhere((s) => s.id == 'myntra');
      final originalUrl = myntra.buildWebSearchUrl('saree');
      final wrapped = AffiliateService.wrapUrl(originalUrl, myntra);

      expect(wrapped, startsWith('https://linksredirect.com/?pub_id=987654'));
      expect(wrapped, contains(Uri.encodeComponent(originalUrl)));
    });

    test('Disabled state bypasses affiliate wrapping', () async {
      await AffiliateService.updateConfig(
        amazonTag: 'smartcart-21',
        isEnabled: false,
      );
      final amazon = StoreCatalog.allStores.firstWhere((s) => s.id == 'amazon');
      final originalUrl = amazon.buildWebSearchUrl('shoes');
      final wrapped = AffiliateService.wrapUrl(originalUrl, amazon);

      expect(wrapped, equals(originalUrl));
      expect(wrapped, isNot(contains('tag=')));
    });
  });
}

