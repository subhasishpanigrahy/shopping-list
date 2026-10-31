import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/store_info.dart';
import 'affiliate_service.dart';

enum LaunchTarget {
  smartAuto, // Launches native app if present, otherwise in-app browser
  inAppBrowser, // Opens store website in sleek in-app browser view
  nativeAppOnly, // Tries to launch the native app directly
  externalBrowser, // Opens in external Chrome/Safari browser
}

enum LaunchResultType { nativeApp, inAppBrowser, externalBrowser, failed }

class LaunchResult {
  final LaunchResultType type;
  final String destinationUrl;
  final String? errorMessage;

  const LaunchResult({
    required this.type,
    required this.destinationUrl,
    this.errorMessage,
  });

  bool get isSuccess => type != LaunchResultType.failed;
}

class StoreRouter {
  static final Map<String, bool> _appInstallCache = {};

  /// Custom URI schemes used strictly to detect if the native app is installed
  static List<String> getInstallCheckUris(StoreInfo store) {
    switch (store.id) {
      case 'amazon':
        return ['com.amazon.mobile.shopping.web://amazon.in/s?k=test'];
      case 'flipkart':
        return ['flipkart://test'];
      case 'blinkit':
        return ['blinkit://test', 'grofers://test'];
      case 'meesho':
        return ['supply://open'];
      case 'swiggy_instamart':
        return ['swiggy://test'];
      case 'myntra':
        return ['myntra://myntra.com/test'];
      case 'ajio':
        return ['ajioapps://test'];
      case 'zepto':
        return ['zepto://zeptonow.com/app'];
      case 'bigbasket':
        return ['bigbasket://open'];
      case 'samsung_shop':
        return ['samsungestore://open'];
      default:
        final scheme = store.deepLinkScheme;
        if (scheme != null && !scheme.startsWith('http')) {
          final sample = store.buildDeepLink('test');
          return sample != null ? [sample] : [];
        }
        return [];
    }
  }

  /// Prioritized search deep links that trigger active product searches in the native app
  static List<String> getSearchLaunchUris(StoreInfo store, String query) {
    final encoded = Uri.encodeComponent(query);
    switch (store.id) {
      case 'amazon':
        final amzTag = AffiliateService.amazonTag;
        final amzSuffix = amzTag.isNotEmpty ? '&tag=$amzTag' : '';
        return [
          'com.amazon.mobile.shopping.web://amazon.in/s?k=$encoded$amzSuffix',
          'com.amazon.mobile.shopping.web://www.amazon.in/s?k=$encoded$amzSuffix',
          'https://www.amazon.in/s?k=$encoded$amzSuffix',
        ];
      case 'flipkart':
        final fkId = AffiliateService.flipkartId;
        final fkSuffix = fkId.isNotEmpty ? '&affid=$fkId' : '';
        return [
          'https://dl.flipkart.com/dl/search?q=$encoded$fkSuffix',
          'https://www.flipkart.com/search?q=$encoded$fkSuffix',
          'flipkart://search?q=$encoded$fkSuffix',
        ];
      case 'blinkit':
        return [
          'https://blinkit.com/s?q=$encoded',
          'blinkit://search?q=$encoded',
        ];
      case 'meesho':
        return [
          'https://www.meesho.com/search?q=$encoded',
          'supply://open',
        ];
      case 'swiggy_instamart':
        return [
          'swiggy://instamart/search?query=$encoded',
          'https://www.swiggy.com/instamart/search?custom_back=true&query=$encoded',
        ];
      case 'myntra':
        return [
          'myntra://myntra.com/$encoded',
          'https://www.myntra.com/$encoded',
        ];
      case 'ajio':
        return [
          'https://www.ajio.com/search/?text=$encoded',
        ];
      case 'bigbasket':
        return [
          'https://www.bigbasket.com/ps/?q=$encoded',
          'bigbasket://open',
        ];
      case 'zepto':
        return [
          'https://www.zeptonow.com/search?query=$encoded',
          'zepto://zeptonow.com/app',
        ];
      case 'samsung_shop':
        return [
          'https://www.samsung.com/in/search/?searchvalue=$encoded',
          'samsungestore://open',
        ];
      default:
        final primary = store.buildDeepLink(query);
        final list = <String>[];
        if (primary != null) list.add(primary);
        list.add(store.buildWebSearchUrl(query));
        return list;
    }
  }

  /// Checks whether the native app for the given store is installed on device
  static Future<bool> isAppInstalled(StoreInfo store) async {
    final candidates = getInstallCheckUris(store);
    if (candidates.isEmpty) return false;

    if (_appInstallCache.containsKey(store.id)) {
      return _appInstallCache[store.id]!;
    }

    try {
      for (final link in candidates) {
        final uri = Uri.parse(link);
        if (await canLaunchUrl(uri)) {
          _appInstallCache[store.id] = true;
          return true;
        }
      }
      _appInstallCache[store.id] = false;
      return false;
    } catch (e) {
      debugPrint('Error checking app install for ${store.name}: $e');
      _appInstallCache[store.id] = false;
      return false;
    }
  }

  /// Batch check for multiple stores
  static Future<Map<String, bool>> checkInstalledStores(
    List<StoreInfo> stores,
  ) async {
    final Map<String, bool> results = {};
    for (final store in stores) {
      results[store.id] = await isAppInstalled(store);
    }
    return results;
  }

  /// Clear cache if needed (e.g. app returned from Play Store)
  static void clearInstallCache() {
    _appInstallCache.clear();
  }

  /// Launch store with target strategy
  static Future<LaunchResult> launchStore({
    required StoreInfo store,
    required String query,
    LaunchTarget target = LaunchTarget.smartAuto,
  }) async {
    final baseWebUrl = store.buildWebSearchUrl(query);
    final webUrl = AffiliateService.wrapUrl(baseWebUrl, store);
    final installed = await isAppInstalled(store);

    switch (target) {
      case LaunchTarget.nativeAppOnly:
        final searchUris = getSearchLaunchUris(store, query);
        for (final link in searchUris) {
          try {
            final uri = Uri.parse(link);
            if (await canLaunchUrl(uri)) {
              final ok = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              if (ok) {
                return LaunchResult(
                  type: LaunchResultType.nativeApp,
                  destinationUrl: link,
                );
              }
            }
          } catch (e) {
            debugPrint('Failed to launch native candidate $link for ${store.name}: $e');
          }
        }
        return LaunchResult(
          type: LaunchResultType.failed,
          destinationUrl: searchUris.isNotEmpty ? searchUris.first : webUrl,
          errorMessage: 'Native app for ${store.name} is not installed.',
        );

      case LaunchTarget.inAppBrowser:
        try {
          final uri = Uri.parse(webUrl);
          final ok = await launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
            browserConfiguration: const BrowserConfiguration(showTitle: true),
          );
          if (ok) {
            return LaunchResult(
              type: LaunchResultType.inAppBrowser,
              destinationUrl: webUrl,
            );
          }
        } catch (e) {
          debugPrint('In-app browser launch failed for $webUrl: $e');
          // Fallback to platform default
          try {
            final uri = Uri.parse(webUrl);
            final fallbackOk = await launchUrl(
              uri,
              mode: LaunchMode.platformDefault,
            );
            if (fallbackOk) {
              return LaunchResult(
                type: LaunchResultType.externalBrowser,
                destinationUrl: webUrl,
              );
            }
          } catch (_) {}
        }
        return LaunchResult(
          type: LaunchResultType.failed,
          destinationUrl: webUrl,
          errorMessage: 'Could not open in-app browser view.',
        );

      case LaunchTarget.externalBrowser:
        try {
          final uri = Uri.parse(webUrl);
          final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (ok) {
            return LaunchResult(
              type: LaunchResultType.externalBrowser,
              destinationUrl: webUrl,
            );
          }
        } catch (e) {
          debugPrint('External browser launch failed for $webUrl: $e');
        }
        return LaunchResult(
          type: LaunchResultType.failed,
          destinationUrl: webUrl,
          errorMessage: 'Could not open external browser.',
        );

      case LaunchTarget.smartAuto:
        // 1. If native app is installed, launch search into the native app via externalApplication
        if (installed) {
          final searchUris = getSearchLaunchUris(store, query);
          for (final link in searchUris) {
            try {
              final uri = Uri.parse(link);
              if (await canLaunchUrl(uri)) {
                final appLaunched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (appLaunched) {
                  return LaunchResult(
                    type: LaunchResultType.nativeApp,
                    destinationUrl: link,
                  );
                }
              }
            } catch (e) {
              debugPrint(
                'Smart launch native attempt failed for $link (${store.name}): $e',
              );
            }
          }
        }

        // 2. If app is not installed, open sleek in-app browser view
        try {
          final webUri = Uri.parse(webUrl);
          final inAppOk = await launchUrl(
            webUri,
            mode: LaunchMode.inAppBrowserView,
            browserConfiguration: const BrowserConfiguration(showTitle: true),
          );
          if (inAppOk) {
            return LaunchResult(
              type: LaunchResultType.inAppBrowser,
              destinationUrl: webUrl,
            );
          }
        } catch (e) {
          debugPrint(
            'Smart launch in-app browser fallback failed for $webUrl: $e',
          );
          // Fallback to platform default
          try {
            final webUri = Uri.parse(webUrl);
            final fallbackOk = await launchUrl(
              webUri,
              mode: LaunchMode.platformDefault,
            );
            if (fallbackOk) {
              return LaunchResult(
                type: LaunchResultType.externalBrowser,
                destinationUrl: webUrl,
              );
            }
          } catch (_) {}
        }

        return LaunchResult(
          type: LaunchResultType.failed,
          destinationUrl: webUrl,
          errorMessage: 'Unable to open store link.',
        );
    }
  }
}
