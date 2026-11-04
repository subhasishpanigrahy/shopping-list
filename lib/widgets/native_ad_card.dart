import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// FILE: native_ad_card.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Represents a "Native Ad (Blended Deal Card)". Formatted to look like one of
/// our luxury store cards or checklist tiles with a discreet "Sponsored Deal" badge.
/// It feels natural, non-disruptive, and achieves high click-through rates.
/// ============================================================================
class NativeDealAdCard extends StatefulWidget {
  final EdgeInsetsGeometry margin;

  const NativeDealAdCard({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  State<NativeDealAdCard> createState() => _NativeDealAdCardState();
}

class _NativeDealAdCardState extends State<NativeDealAdCard> {
  BannerAd? _ad;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() {
    if (_ad != null) return;

    _ad = BannerAd(
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
          debugPrint('[NativeDealAdCard] Ad failed to load: $error');
          ad.dispose();
          _ad = null;
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
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _ad == null) {
      return const SizedBox.shrink();
    }

    final theme = AppTheme.of(context);

    return Container(
      margin: widget.margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.accentAmber.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with "Featured Deal" & "Sponsored" badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.accentAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.local_offer_rounded,
                      size: 13,
                      color: theme.accentAmber,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Featured Deal & Shopping Offer',
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: theme.accentAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: theme.accentAmber.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Ad',
                  style: TextStyle(
                    color: theme.accentAmber,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Render the AdMob Ad Widget centered
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: _ad!.size.width.toDouble(),
                height: _ad!.size.height.toDouble(),
                child: AdWidget(ad: _ad!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

