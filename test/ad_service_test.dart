import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/services/ad_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdService Tests', () {
    setUp(() {
      AdService.isTestMode = true;
    });

    test('AdService defaults to official Google test unit IDs in test mode', () {
      expect(AdService.bannerAdUnitId, equals(AdService.testBannerId));
      expect(AdService.interstitialAdUnitId, equals(AdService.testInterstitialId));
      expect(AdService.nativeAdUnitId, equals(AdService.testNativeId));
    });

    test('AdService showInterstitialAd invokes callback safely if ad not ready', () {
      bool callbackCalled = false;
      AdService.showInterstitialAd(
        onDismissed: () {
          callbackCalled = true;
        },
      );

      expect(callbackCalled, isTrue);
    });
  });
}

