import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/services/store_url_helper.dart';

void main() {
  group('StoreUrlHelper Smart Parser Tests', () {
    test('Domain extraction tests', () {
      expect(StoreUrlHelper.extractDomain('https://www.decathlon.in/'), 'decathlon.in');
      expect(StoreUrlHelper.extractDomain('vegnonveg.com'), 'vegnonveg.com');
      expect(StoreUrlHelper.extractDomain('http://store.nike.com/in/'), 'store.nike.com');
      expect(StoreUrlHelper.extractDomain('www.etsy.com/shop'), 'etsy.com');
    });

    test('Search URL generation from raw domain or homepage', () {
      expect(
        StoreUrlHelper.buildSearchUrlTemplate('decathlon.in'),
        'https://decathlon.in/search?q={query}',
      );
      expect(
        StoreUrlHelper.buildSearchUrlTemplate('https://www.vegnonveg.com/'),
        'https://www.vegnonveg.com/search?q={query}',
      );
    });

    test('Search URL preservation if {query} is already present', () {
      expect(
        StoreUrlHelper.buildSearchUrlTemplate('https://custom.shop/find?term={query}'),
        'https://custom.shop/find?term={query}',
      );
    });

    test('Search URL replacement of existing search query keywords', () {
      expect(
        StoreUrlHelper.buildSearchUrlTemplate('https://www.etsy.com/search?q=leather+wallet'),
        'https://www.etsy.com/search?q={query}',
      );
      expect(
        StoreUrlHelper.buildSearchUrlTemplate('https://site.com/products?search=shoes'),
        'https://site.com/products?search={query}',
      );
    });

    test('Brand logo URL generation via unavatar', () {
      expect(
        StoreUrlHelper.buildLogoUrl('decathlon.in'),
        'https://unavatar.io/decathlon.in',
      );
    });

    test('Store name suggestion from domain', () {
      expect(StoreUrlHelper.suggestStoreName('vegnonveg.com'), 'Vegnonveg');
      expect(StoreUrlHelper.suggestStoreName('decathlon.in'), 'Decathlon');
    });
  });
}
