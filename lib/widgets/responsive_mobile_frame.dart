import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// FILE: responsive_mobile_frame.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// When running on desktop browsers (Brave, Chrome, Edge) or wide monitors,
/// native mobile shopping apps look disproportionate if stretched across a 1920px
/// screen. This wrapper detects desktop viewports and embeds the app inside a
/// realistic, luxury obsidian smartphone frame with a Dynamic Island notch
/// and device bezel, while remaining 100% full-screen edge-to-edge on real phones.
///
/// WHAT IT DOES:
/// 1. Inspects viewport width via [MediaQuery.sizeOf].
/// 2. If width <= 550px: Renders edge-to-edge with zero overhead.
/// 3. If width > 550px: Displays an obsidian device frame (390×844 ratio)
///    with simulated status notch, speaker grill, home bar, and glowing shadow.
/// 4. Provides a toggle button in the header so desktop users can switch between
///    "📱 Mobile View" and "🖥️ Full Screen".
/// ============================================================================
class ResponsiveMobileFrame extends StatefulWidget {
  final Widget child;

  const ResponsiveMobileFrame({super.key, required this.child});

  @override
  State<ResponsiveMobileFrame> createState() => _ResponsiveMobileFrameState();
}

class _ResponsiveMobileFrameState extends State<ResponsiveMobileFrame> {
  bool _forceFullScreen = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final isDesktopWidth = kIsWeb && screenSize.width > 550;

    // On actual mobile screens or if user opted into full-width mode
    if (!isDesktopWidth || _forceFullScreen) {
      return Stack(
        children: [
          widget.child,
          if (isDesktopWidth && _forceFullScreen)
            Positioned(
              top: 14,
              right: 14,
              child: _buildViewToggle(theme: theme, isMobileMode: false),
            ),
        ],
      );
    }

    // Centered luxury smartphone mockup on desktop
    return Scaffold(
      backgroundColor: theme.isDark ? const Color(0xFF06090E) : const Color(0xFFE2E8F0),
      body: SafeArea(
        child: Column(
          children: [
            // Top desktop control bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: theme.accentEmerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.smartphone_rounded,
                          size: 16,
                          color: theme.accentEmerald,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Smart List Mobile Experience',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  _buildViewToggle(theme: theme, isMobileMode: true),
                ],
              ),
            ),

            // Smartphone frame container
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 420,
                      maxHeight: 890,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.bg,
                        borderRadius: BorderRadius.circular(42),
                        border: Border.all(
                          color: theme.isDark ? const Color(0xFF263248) : const Color(0xFFCBD5E1),
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: theme.isDark ? 0.7 : 0.15),
                            blurRadius: 40,
                            spreadRadius: 6,
                            offset: const Offset(0, 14),
                          ),
                          BoxShadow(
                            color: theme.accentEmerald.withValues(alpha: 0.08),
                            blurRadius: 50,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(38),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final mediaQuery = MediaQuery.of(context);
                            return MediaQuery(
                              data: mediaQuery.copyWith(
                                size: Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                ),
                                padding: const EdgeInsets.only(
                                  top: 24,
                                  bottom: 12,
                                ),
                                viewPadding: const EdgeInsets.only(
                                  top: 24,
                                  bottom: 12,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Main Application Content
                                  Positioned.fill(
                                    child: widget.child,
                                  ),

                                  // Simulated Dynamic Island Notch at Top
                                  Positioned(
                                    top: 8,
                                    left: 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      child: Center(
                                        child: Container(
                                          width: 96,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(
                                                    right: 12),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF141E2E),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Simulated Bottom Home Indicator Bar
                                  Positioned(
                                    bottom: 6,
                                    left: 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      child: Center(
                                        child: Container(
                                          width: 110,
                                          height: 3.5,
                                          decoration: BoxDecoration(
                                            color: (theme.isDark ? Colors.white : Colors.black)
                                                .withValues(alpha: 0.25),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle({required AppColors theme, required bool isMobileMode}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            _forceFullScreen = !_forceFullScreen;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: theme.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isMobileMode ? Icons.fullscreen_rounded : Icons.phone_iphone_rounded,
                size: 15,
                color: theme.accentCyan,
              ),
              const SizedBox(width: 5),
              Text(
                isMobileMode ? 'Full Screen' : 'Mobile Frame',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
