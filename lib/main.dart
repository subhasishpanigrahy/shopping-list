import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/shopping_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'services/affiliate_service.dart';
import 'theme/app_theme.dart';
import 'widgets/responsive_mobile_frame.dart';

/// ============================================================================
/// FILE: main.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Serves as the root entry point for the Smart List application on both native
/// mobile devices (Android/iOS) and web browsers. It configures the global
/// provider state, obsidian dark theme, system status bar overlays, and the
/// responsive device frame wrapper.
///
/// WHAT IT DOES:
/// 1. Initializes Flutter bindings and sets transparent/obsidian system UI styles.
/// 2. Binds the top-level [ShoppingProvider] via [ChangeNotifierProvider].
/// 3. Wraps the app inside [ResponsiveMobileFrame] via [MaterialApp.builder] so
///    desktop browser users experience a realistic smartphone frame (Dynamic
///    Island, bezels, home bar, and fullscreen toggle), while native mobile
///    users get a full edge-to-edge experience.
/// 4. Mounts [HomeScreen] as the root home route.
///
/// HOW IT DOES:
/// Uses [WidgetsFlutterBinding.ensureInitialized], sets system overlay style,
/// and delegates building to [MaterialApp] with [AppTheme.darkTheme].
/// ============================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AffiliateService.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.obsidianBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SmartListApp());
}

class SmartListApp extends StatelessWidget {
  const SmartListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final isDark = themeProvider.isDarkMode;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
              systemNavigationBarColor:
                  isDark ? AppTheme.darkColors.bg : AppTheme.lightColors.bg,
              systemNavigationBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
            ),
          );
          return MaterialApp(
            title: 'Shopping List',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            builder: (context, child) => ResponsiveMobileFrame(
              child: child ?? const SizedBox.shrink(),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
