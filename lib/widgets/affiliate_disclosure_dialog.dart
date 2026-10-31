import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Official Affiliate Disclosure & App Transparency Dialog required for Google Play & FTC compliance
class AffiliateDisclosureDialog extends StatelessWidget {
  const AffiliateDisclosureDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => const AffiliateDisclosureDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AlertDialog(
      backgroundColor: theme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.borderSubtle),
      ),
      title: Row(
        children: [
          Icon(Icons.verified_user_rounded, color: theme.accentEmerald),
          const SizedBox(width: 10),
          Text(
            'About & Transparency',
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shopping List v1.0.0',
              style: TextStyle(
                color: theme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Universal Store & Web Aggregator with 31+ major retail integrations.',
              style: TextStyle(color: theme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // FTC / Google Play Affiliate Disclosure
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: theme.accentAmber, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Affiliate Disclosure',
                        style: TextStyle(
                          color: theme.accentAmber,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Shopping List is completely free to use. When you search and click on external store links to make purchases (including on Amazon, Flipkart, Myntra, and partner stores), we may earn an affiliate commission at absolutely zero additional cost to you.\n\nThis commission helps fund the app development, server uptime, and ongoing improvements.',
                    style:
                        TextStyle(color: theme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Privacy Guarantee
            Text(
              '🔒 100% Private & Local',
              style: TextStyle(
                color: theme.accentCyan,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your shopping items, quantities, and notes are saved exclusively in your device local storage. We do not track, collect, or store your personal identity or checklist data on remote servers.',
              style: TextStyle(color: theme.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.accentEmerald,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got It',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
