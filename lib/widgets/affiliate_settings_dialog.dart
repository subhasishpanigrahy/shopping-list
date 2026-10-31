import 'package:flutter/material.dart';
import '../services/affiliate_service.dart';
import '../theme/app_theme.dart';

/// Dialog enabling users / developers to configure their affiliate credentials
class AffiliateSettingsDialog extends StatefulWidget {
  const AffiliateSettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => const AffiliateSettingsDialog(),
    );
  }

  @override
  State<AffiliateSettingsDialog> createState() =>
      _AffiliateSettingsDialogState();
}

class _AffiliateSettingsDialogState extends State<AffiliateSettingsDialog> {
  late final TextEditingController _cuelinksController;
  late final TextEditingController _amazonController;
  late final TextEditingController _flipkartController;
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _cuelinksController =
        TextEditingController(text: AffiliateService.cuelinksPubId);
    _amazonController =
        TextEditingController(text: AffiliateService.amazonTag);
    _flipkartController =
        TextEditingController(text: AffiliateService.flipkartId);
    _isEnabled = AffiliateService.isEnabled;
  }

  @override
  void dispose() {
    _cuelinksController.dispose();
    _amazonController.dispose();
    _flipkartController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await AffiliateService.updateConfig(
      cuelinksPubId: _cuelinksController.text.trim(),
      amazonTag: _amazonController.text.trim(),
      flipkartId: _flipkartController.text.trim(),
      isEnabled: _isEnabled,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Affiliate configuration saved successfully!'),
          backgroundColor: AppTheme.accentEmerald,
          duration: Duration(seconds: 2),
        ),
      );
    }
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
          Icon(Icons.monetization_on_rounded, color: theme.accentAmber),
          const SizedBox(width: 10),
          Text(
            'Affiliate Monetization',
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
              'Attach your affiliate publisher IDs to monetize store search queries. Commissions are credited for any purchases within the 24-hr session cookie.',
              style: TextStyle(color: theme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Master Enable Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Affiliate Tracking',
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Switch(
                  value: _isEnabled,
                  activeThumbColor: theme.accentAmber,
                  onChanged: (val) => setState(() => _isEnabled = val),
                ),
              ],
            ),
            Divider(color: theme.borderSubtle),
            const SizedBox(height: 8),

            // 1. Cuelinks Universal Publisher ID (Recommended)
            Text(
              '🌐 Universal Multi-Store (Cuelinks Pub ID)',
              style: TextStyle(
                color: theme.accentCyan,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Monetizes 30+ stores (Myntra, Ajio, Nykaa, Blinkit, Croma, etc.) under 1 single ID from cuelinks.com.',
              style: TextStyle(color: theme.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _cuelinksController,
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'e.g. 195432',
                hintStyle: TextStyle(color: theme.textMuted),
                filled: true,
                fillColor: theme.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.borderSubtle),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 14),

            // 2. Amazon Associates Tag
            const Text(
              '📦 Amazon Associates Tag',
              style: TextStyle(
                color: Color(0xFFFF9900),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'From affiliate-program.amazon.in (e.g. yourtag-21).',
              style: TextStyle(color: theme.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _amazonController,
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'e.g. smartcart-21',
                hintStyle: TextStyle(color: theme.textMuted),
                filled: true,
                fillColor: theme.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.borderSubtle),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 14),

            // 3. Flipkart Affiliate ID
            const Text(
              '🛍️ Flipkart Affiliate ID',
              style: TextStyle(
                color: Color(0xFF2874F0),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'From affiliate.flipkart.com (affid parameter).',
              style: TextStyle(color: theme.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _flipkartController,
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'e.g. smartcart_fk',
                hintStyle: TextStyle(color: theme.textMuted),
                filled: true,
                fillColor: theme.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.borderSubtle),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel',
              style: TextStyle(color: theme.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.accentEmerald,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _save,
          child: const Text('Save IDs',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
