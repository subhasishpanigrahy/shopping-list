import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// FILE: ad_banner_widget.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Provides a clean, anchored bottom adaptive banner ad that generates steady
/// impression and click revenue whenever shoppers use the app.
///
/// FEATURES:
/// 1. Graceful degradation: if offline or failed, collapses to zero height.
/// 2. Adaptive width matching device screen width.
/// 3. Styled to blend with current dark/light luxury theme.
/// ============================================================================
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBanner();
  }

  void _loadBanner() {
    if (_bannerAd != null) return;

    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdBannerWidget] Banner failed to load: $error');
          ad.dispose();
          _bannerAd = null;
          if (mounted) {
            setState(() {
              _isLoaded = false;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final theme = AppTheme.of(context);

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.cardBg,
        border: Border(
          top: BorderSide(color: theme.borderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: theme.borderSubtle,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'ADVERTISEMENT',
                      style: TextStyle(
                        color: theme.textMuted,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ],
        ),
      ),
    );
  }
}

