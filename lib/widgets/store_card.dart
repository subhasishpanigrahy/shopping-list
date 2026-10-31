import 'package:flutter/material.dart';
import '../models/store_info.dart';
import '../services/store_router.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// FILE: store_card.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Renders an individual store result inside the [StoreSheet]. Each card must
/// clearly communicate whether it represents a locally installed native app,
/// an external web destination, or a user-added custom store.
///
/// WHAT IT DOES:
/// 1. Displays store logo (with an offline-safe fallback avatar of brand initials).
/// 2. Highlights verified official brand portals and user-added custom stores.
/// 3. Displays installed vs web status badges.
/// 4. Executes 1-tap smart launch on card press.
/// 5. Provides an overflow menu allowing the user to select In-App Browser,
///    External Browser, Native App, or Delete (for custom stores).
/// ============================================================================
class StoreCard extends StatelessWidget {
  final StoreInfo store;
  final String query;
  final bool isInstalled;
  final bool isHighlighted;
  final VoidCallback? onLaunched;
  final VoidCallback? onDelete;

  const StoreCard({
    super.key,
    required this.store,
    required this.query,
    this.isInstalled = false,
    this.isHighlighted = false,
    this.onLaunched,
    this.onDelete,
  });

  Future<void> _handleLaunch(BuildContext context, LaunchTarget target) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final result = await StoreRouter.launchStore(
      store: store,
      query: query,
      target: target,
    );

    if (result.isSuccess) {
      onLaunched?.call();
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Could not launch ${store.name}'),
          backgroundColor: AppTheme.accentRose,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.isDark ? theme.cardSurface : theme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? AppTheme.accentCyan.withValues(alpha: 0.5)
              : isInstalled
                  ? AppTheme.accentEmerald.withValues(alpha: 0.4)
                  : store.isCustom
                      ? store.brandColor.withValues(alpha: 0.4)
                      : theme.borderSubtle,
          width: isHighlighted || isInstalled || store.isCustom ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleLaunch(context, LaunchTarget.smartAuto),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Store Logo / Avatar
                _buildLogo(),
                const SizedBox(width: 14),

                // Title & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              store.name,
                              style: TextStyle(
                                color: theme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (store.isVerifiedOfficial) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: AppTheme.accentCyan,
                            ),
                          ],
                          if (store.isCustom) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppTheme.accentAmber,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        store.tagline,
                        style: TextStyle(
                          color: theme.textMuted,
                          fontSize: 12.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Badges Row
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          // Installed status badge
                          if (isInstalled)
                            _buildBadge(
                              label: '📱 Installed App',
                              color: AppTheme.accentEmerald,
                              textColor: const Color(0xFFD1FAE5),
                            )
                          else
                            _buildBadge(
                              label: '🌐 Instant Web',
                              color: AppTheme.accentIndigo,
                              textColor: const Color(0xFFE0E7FF),
                            ),

                          // Custom Store Badge (e.g., "⭐ Custom Store", "Official Brand Store")
                          _buildBadge(
                            label: store.badgeText,
                            color: store.isCustom
                                ? store.brandColor
                                : isHighlighted
                                    ? AppTheme.accentCyan
                                    : const Color(0xFF334155),
                            textColor: store.isCustom
                                ? const Color(0xFFFEF3C7)
                                : isHighlighted
                                    ? const Color(0xFFCFFAFE)
                                    : AppTheme.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Launch CTA Button & Overflow Menu
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isInstalled
                            ? AppTheme.accentEmerald.withValues(alpha: 0.15)
                            : AppTheme.accentIndigo.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isInstalled
                              ? AppTheme.accentEmerald.withValues(alpha: 0.3)
                              : AppTheme.accentIndigo.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isInstalled
                                ? Icons.open_in_new_rounded
                                : Icons.travel_explore_rounded,
                            size: 14,
                            color: isInstalled
                                ? AppTheme.accentEmerald
                                : AppTheme.accentIndigo,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isInstalled ? 'Launch' : 'View',
                            style: TextStyle(
                              color: isInstalled
                                  ? AppTheme.accentEmerald
                                  : AppTheme.accentIndigo,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        color: theme.textMuted,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: theme.cardBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.borderSubtle),
                      ),
                      onSelected: (action) {
                        if (action == 'native') {
                          _handleLaunch(context, LaunchTarget.nativeAppOnly);
                        } else if (action == 'in_app') {
                          _handleLaunch(context, LaunchTarget.inAppBrowser);
                        } else if (action == 'external') {
                          _handleLaunch(context, LaunchTarget.externalBrowser);
                        } else if (action == 'delete') {
                          onDelete?.call();
                        }
                      },
                      itemBuilder: (ctx) => [
                        if (store.deepLinkScheme != null)
                          const PopupMenuItem(
                            value: 'native',
                            child: Row(
                              children: [
                                Icon(Icons.phone_android_rounded, size: 18, color: AppTheme.accentEmerald),
                                SizedBox(width: 8),
                                Text('Launch Native App', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'in_app',
                          child: Row(
                            children: [
                              Icon(Icons.tab_unselected_rounded, size: 18, color: AppTheme.accentIndigo),
                              SizedBox(width: 8),
                              Text('In-App Browser', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'external',
                          child: Row(
                            children: [
                              Icon(Icons.open_in_browser_rounded, size: 18, color: AppTheme.accentCyan),
                              SizedBox(width: 8),
                              Text('External Browser', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        if (store.isCustom && onDelete != null) ...[
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.accentRose),
                                SizedBox(width: 8),
                                Text('Remove Store', style: TextStyle(color: AppTheme.accentRose, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the store brand avatar, falling back to initials if offline or image fails.
  Widget _buildLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: store.brandColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: store.brandColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          store.logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Stylized initials fallback
            final initials = store.name
                .split(' ')
                .take(2)
                .map((w) => w.isNotEmpty ? w[0] : '')
                .join()
                .toUpperCase();

            return Center(
              child: Text(
                initials.isNotEmpty ? initials : '?',
                style: TextStyle(
                  color: store.brandColor == Colors.white
                      ? Colors.white
                      : store.brandColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: -0.5,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(store.brandColor),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
