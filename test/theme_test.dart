import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/providers/theme_provider.dart';
import 'package:shopping_list/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider & AppTheme Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('ThemeProvider initializes with dark mode by default', () async {
      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.isDarkMode, isTrue);
      expect(provider.themeMode, equals(ThemeMode.dark));
    });

    test('ThemeProvider toggles between light and dark modes and persists', () async {
      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      // Toggle to light mode
      await provider.toggleTheme();
      expect(provider.isDarkMode, isFalse);
      expect(provider.themeMode, equals(ThemeMode.light));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('smart_shopping_theme_mode_v1'), equals('light'));

      // Toggle back to dark mode
      await provider.toggleTheme();
      expect(provider.isDarkMode, isTrue);
      expect(provider.themeMode, equals(ThemeMode.dark));
      expect(prefs.getString('smart_shopping_theme_mode_v1'), equals('dark'));
    });

    test('ThemeProvider loads saved preference from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'smart_shopping_theme_mode_v1': 'light',
      });

      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(provider.isDarkMode, isFalse);
      expect(provider.themeMode, equals(ThemeMode.light));
    });

    testWidgets('AppTheme.of resolves lightColors and darkColors dynamically',
        (tester) async {
      AppColors? capturedColors;

      // 1. Test Light Theme
      await tester.pumpWidget(
        MaterialApp(
          key: const ValueKey('light_app'),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: Builder(
            builder: (context) {
              capturedColors = AppTheme.of(context);
              return Container();
            },
          ),
        ),
      );
      await tester.pump();

      expect(capturedColors, isNotNull);
      expect(capturedColors!.isDark, isFalse);
      expect(capturedColors!.bg, equals(AppTheme.lightColors.bg));
      expect(capturedColors!.cardBg, equals(const Color(0xFFFFFFFF)));

      // 2. Test Dark Theme
      await tester.pumpWidget(
        MaterialApp(
          key: const ValueKey('dark_app'),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) {
              capturedColors = AppTheme.of(context);
              return Container();
            },
          ),
        ),
      );
      await tester.pump();

      expect(capturedColors, isNotNull);
      expect(capturedColors!.isDark, isTrue);
      expect(capturedColors!.bg, equals(AppTheme.darkColors.bg));
      expect(capturedColors!.cardBg, equals(const Color(0xFF131A26)));
    });
  });
}
