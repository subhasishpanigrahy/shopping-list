import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// ============================================================================
/// FILE: ad_service.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Centralized monetization manager for Google AdMob across the application.
/// Manages lifecycle, preloading, rate-limiting, and error-handling for:
/// 1. Adaptive Bottom Banner
/// 2. Interstitial Ads (Full-screen)
/// 3. Native / Blended In-Feed Deal Ads
///
/// SAFETY & COMPLIANCE:
/// Automatically defaults to Google's official Test Ad Unit IDs so developers
/// and testers can run the app safely without risking AdMob policy violations
/// or account suspension for test impressions.
/// ============================================================================
class AdService {
  // --- DEVELOPER PRODUCTION AD UNIT IDS ---
  // When you get your real AdMob unit IDs from admob.google.com, paste them here:
  static const String _prodBannerId = '';
  static const String _prodInterstitialId = '';
  static const String _prodNativeId = '';

  // Google's Official Test Ad Unit IDs (Always safe to test with)
  static const String testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testNativeId = 'ca-app-pub-3940256099942544/2247690410';

  static bool isTestMode = true;
  static bool _isInitialized = false;

  // Interstitial preloaded instance & rate limiting
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialLoading = false;
  static DateTime? _lastInterstitialTime;
  static const Duration _interstitialCooldown = Duration(minutes: 2);

  /// Resolves the active Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (!isTestMode && _prodBannerId.isNotEmpty) {
      return _prodBannerId;
    }
    return testBannerId;
  }

  /// Resolves the active Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (!isTestMode && _prodInterstitialId.isNotEmpty) {
      return _prodInterstitialId;
    }
    return testInterstitialId;
  }

  /// Resolves the active Native Ad Unit ID
  static String get nativeAdUnitId {
    if (!isTestMode && _prodNativeId.isNotEmpty) {
      return _prodNativeId;
    }
    return testNativeId;
  }

  /// Initializes the Google Mobile Ads SDK
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('[AdService] Google Mobile Ads initialized successfully.');
      // Preload the first interstitial ad so it's ready when needed
      loadInterstitialAd();
    } catch (e) {
      debugPrint('[AdService] Failed to initialize MobileAds: $e');
    }
  }

  // ===========================================================================
  // INTERSTITIAL ADS
  // ===========================================================================

  /// Preloads a full-screen interstitial ad in the background
  static void loadInterstitialAd() {
    if (_interstitialAd != null || _isInterstitialLoading) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          debugPrint('[AdService] Interstitial ad preloaded successfully.');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              // Preload next one for subsequent natural pause points
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdService] Failed to show interstitial: $error');
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Interstitial failed to load: $error');
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  /// Shows the interstitial ad if ready and cooldown has elapsed.
  /// Ideal for natural pause points (e.g. after tapping "Clear Completed Items").
  static void showInterstitialAd({VoidCallback? onDismissed}) {
    final now = DateTime.now();

    // Check rate limit (at least 2 minutes between full-screen ads)
    if (_lastInterstitialTime != null &&
        now.difference(_lastInterstitialTime!) < _interstitialCooldown) {
      debugPrint('[AdService] Interstitial skipped due to active cooldown.');
      onDismissed?.call();
      return;
    }

    if (_interstitialAd != null) {
      _lastInterstitialTime = now;
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          onDismissed?.call();
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('[AdService] Failed to show interstitial: $error');
          ad.dispose();
          _interstitialAd = null;
          onDismissed?.call();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      debugPrint('[AdService] Interstitial not ready yet.');
      onDismissed?.call();
      loadInterstitialAd();
    }
  }

  /// Disposes cached ads
  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}

