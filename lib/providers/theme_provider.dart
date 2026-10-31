import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// FILE: theme_provider.dart
/// ----------------------------------------------------------------------------
/// WHY IT IS MADE:
/// Manages the application's visual theme mode (Dark, Light, or System).
/// Persists the user's choice to local storage and reactively notifies listeners
/// so the entire app transitions smoothly between Dark and Light mode.
///
/// WHAT IT DOES:
/// 1. Holds active [ThemeMode] (defaults to system / dark).
/// 2. Persists selection across app restarts via SharedPreferences.
/// 3. Provides [toggleTheme] for 1-tap sun/moon switching in the AppBar.
/// 4. Provides [setThemeMode] for explicit settings modal selection.
/// ============================================================================
class ThemeProvider extends ChangeNotifier {
  static const String _storageKey = 'smart_shopping_theme_mode_v1';

  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLoaded = false;

  ThemeProvider() {
    _loadFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _isLoaded;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_storageKey);
      if (savedMode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedMode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (savedMode == 'system') {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.dark;
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _themeMode = ThemeMode.dark;
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Toggles between Light and Dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Sets specific ThemeMode and saves to disk
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final value = mode == ThemeMode.light
          ? 'light'
          : mode == ThemeMode.dark
              ? 'dark'
              : 'system';
      await prefs.setString(_storageKey, value);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}

