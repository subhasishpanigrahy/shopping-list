import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/store_info.dart';

/// ============================================================================
/// FILE: affiliate_service.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Powers developer monetization across external store search URLs. When users tap
/// a store card, this service seamlessly attaches your publisher tracking tags
/// (e.g. Cuelinks universal multi-store or Amazon Associates) so purchases
/// within the 24-hour cookie window earn affiliate commissions for you.
///
/// NOTE ON SECURITY & ARCHITECTURE:
/// Publisher IDs are baked directly into the app as developer defaults.
/// End users cannot view, edit, or tamper with your publisher credentials.
/// ============================================================================
class AffiliateService {
  /// ==========================================================================
  /// DEVELOPER AFFILIATE CREDENTIALS (EMBEDDED FOR ALL APP USERS)
  /// --------------------------------------------------------------------------
  /// Paste your credentials here before building your production release.
  /// All app installs will automatically credit affiliate commissions to you.
  /// ==========================================================================
  static const String defaultCuelinksPubId = ''; // e.g. '195432' from cuelinks.com
  static const String defaultAmazonTag = '';    // e.g. 'yourtag-21' from affiliate-program.amazon.in
  static const String defaultFlipkartId = '';   // e.g. 'youraffid' from affiliate.flipkart.com

  static const String _keyCuelinksId = 'affiliate_cuelinks_pub_id';
  static const String _keyAmazonTag = 'affiliate_amazon_tag';
  static const String _keyFlipkartId = 'affiliate_flipkart_id';
  static const String _keyEnabled = 'affiliate_enabled';

  static String _cuelinksPubId = defaultCuelinksPubId;
  static String _amazonTag = defaultAmazonTag;
  static String _flipkartId = defaultFlipkartId;
  static bool _isEnabled = true;
  static bool _isInitialized = false;

  /// Loads persisted affiliate credentials from disk with developer defaults
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCuelinks = prefs.getString(_keyCuelinksId);
      _cuelinksPubId = (savedCuelinks != null && savedCuelinks.isNotEmpty)
          ? savedCuelinks
          : defaultCuelinksPubId;

      final savedAmazon = prefs.getString(_keyAmazonTag);
      _amazonTag = (savedAmazon != null && savedAmazon.isNotEmpty)
          ? savedAmazon
          : defaultAmazonTag;

      final savedFlipkart = prefs.getString(_keyFlipkartId);
      _flipkartId = (savedFlipkart != null && savedFlipkart.isNotEmpty)
          ? savedFlipkart
          : defaultFlipkartId;

      _isEnabled = prefs.getBool(_keyEnabled) ?? true;
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing AffiliateService: $e');
    }
  }

  // --- GETTERS ---
  static String get cuelinksPubId => _cuelinksPubId;
  static String get amazonTag => _amazonTag;
  static String get flipkartId => _flipkartId;
  static bool get isEnabled => _isEnabled;

  /// Updates affiliate credentials and saves to disk
  static Future<void> updateConfig({
    String? cuelinksPubId,
    String? amazonTag,
    String? flipkartId,
    bool? isEnabled,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (cuelinksPubId != null) {
        _cuelinksPubId = cuelinksPubId.trim();
        await prefs.setString(_keyCuelinksId, _cuelinksPubId);
      }
      if (amazonTag != null) {
        _amazonTag = amazonTag.trim();
        await prefs.setString(_keyAmazonTag, _amazonTag);
      }
      if (flipkartId != null) {
        _flipkartId = flipkartId.trim();
        await prefs.setString(_keyFlipkartId, _flipkartId);
      }
      if (isEnabled != null) {
        _isEnabled = isEnabled;
        await prefs.setBool(_keyEnabled, _isEnabled);
      }
    } catch (e) {
      debugPrint('Error updating affiliate config: $e');
    }
  }

  /// Transforms a clean store search URL into an affiliate tracking URL
  static String wrapUrl(String targetUrl, StoreInfo store) {
    if (!_isEnabled) return targetUrl;

    // 1. Direct Amazon Associates Tag
    if (store.id == 'amazon' && _amazonTag.isNotEmpty) {
      final separator = targetUrl.contains('?') ? '&' : '?';
      return '$targetUrl${separator}tag=$_amazonTag';
    }

    // 2. Direct Flipkart Affiliate ID
    if (store.id == 'flipkart' && _flipkartId.isNotEmpty) {
      final separator = targetUrl.contains('?') ? '&' : '?';
      return '$targetUrl${separator}affid=$_flipkartId';
    }

    // 3. Universal Multi-Store Network (Cuelinks covers 1,000+ stores in India)
    // Applies to Myntra, Ajio, Nykaa, Blinkit, Tata CLiQ, Croma, Purplle, etc.
    if (_cuelinksPubId.isNotEmpty && targetUrl.startsWith('http')) {
      final encodedUrl = Uri.encodeComponent(targetUrl);
      return 'https://linksredirect.com/?pub_id=$_cuelinksPubId&subid=shoppinglist&source=linkkit&url=$encodedUrl';
    }

    // Return unaltered if no affiliate credentials are configured yet
    return targetUrl;
  }
}

