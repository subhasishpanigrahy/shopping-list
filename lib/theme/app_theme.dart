import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  final Color bg;
  final Color cardBg;
  final Color cardSurface;
  final Color borderSubtle;
  final Color borderActive;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accentEmerald;
  final Color accentCyan;
  final Color accentIndigo;
  final Color accentRose;
  final Color accentAmber;
  final bool isDark;

  const AppColors({
    required this.bg,
    required this.cardBg,
    required this.cardSurface,
    required this.borderSubtle,
    required this.borderActive,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentEmerald,
    required this.accentCyan,
    required this.accentIndigo,
    required this.accentRose,
    required this.accentAmber,
    required this.isDark,
  });
}

class AppTheme {
  // Static dark palette fallbacks
  static const Color obsidianBg = Color(0xFF0B0F17);
  static const Color cardBg = Color(0xFF131A26);
  static const Color cardSurface = Color(0xFF1A2234);
  static const Color borderSubtle = Color(0xFF243047);
  static const Color borderActive = Color(0xFF38496B);

  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentAmber = Color(0xFFF59E0B);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Dynamic Theme Colors
  static const AppColors darkColors = AppColors(
    bg: Color(0xFF0B0F17),
    cardBg: Color(0xFF131A26),
    cardSurface: Color(0xFF1A2234),
    borderSubtle: Color(0xFF243047),
    borderActive: Color(0xFF38496B),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    accentEmerald: Color(0xFF10B981),
    accentCyan: Color(0xFF06B6D4),
    accentIndigo: Color(0xFF6366F1),
    accentRose: Color(0xFFF43F5E),
    accentAmber: Color(0xFFF59E0B),
    isDark: true,
  );

  static const AppColors lightColors = AppColors(
    bg: Color(0xFFF8FAFC),
    cardBg: Color(0xFFFFFFFF),
    cardSurface: Color(0xFFF1F5F9),
    borderSubtle: Color(0xFFE2E8F0),
    borderActive: Color(0xFFCBD5E1),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF94A3B8),
    accentEmerald: Color(0xFF059669),
    accentCyan: Color(0xFF0891B2),
    accentIndigo: Color(0xFF4F46E5),
    accentRose: Color(0xFFE11D48),
    accentAmber: Color(0xFFD97706),
    isDark: false,
  );

  /// Resolves the current theme colors reactively from BuildContext
  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkColors : lightColors;
  }

  // --- DARK THEME DEFINITION ---
  static ThemeData get darkTheme {
    final fontFamily = GoogleFonts.plusJakartaSans().fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: darkColors.bg,
      cardColor: darkColors.cardBg,
      primaryColor: darkColors.accentEmerald,
      colorScheme: ColorScheme.dark(
        primary: darkColors.accentEmerald,
        secondary: darkColors.accentCyan,
        surface: darkColors.cardBg,
        onSurface: darkColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: darkColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: darkColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
            color: darkColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            color: darkColors.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: darkColors.textPrimary),
        bodyMedium: TextStyle(color: darkColors.textSecondary),
        bodySmall: TextStyle(color: darkColors.textMuted),
      ),
      cardTheme: CardThemeData(
        color: darkColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: darkColors.borderSubtle, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkColors.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: darkColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: darkColors.textPrimary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkColors.cardBg,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkColors.cardBg,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColors.cardSurface,
        hintStyle: TextStyle(color: darkColors.textMuted, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: darkColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: darkColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: darkColors.accentEmerald, width: 1.5),
        ),
      ),
    );
  }

  // --- LIGHT THEME DEFINITION ---
  static ThemeData get lightTheme {
    final fontFamily = GoogleFonts.plusJakartaSans().fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: lightColors.bg,
      cardColor: lightColors.cardBg,
      primaryColor: lightColors.accentEmerald,
      colorScheme: ColorScheme.light(
        primary: lightColors.accentEmerald,
        secondary: lightColors.accentCyan,
        surface: lightColors.cardBg,
        onSurface: lightColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: lightColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: lightColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
            color: lightColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            color: lightColors.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: lightColors.textPrimary),
        bodyMedium: TextStyle(color: lightColors.textSecondary),
        bodySmall: TextStyle(color: lightColors.textMuted),
      ),
      cardTheme: CardThemeData(
        color: lightColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: lightColors.borderSubtle, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightColors.bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: lightColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: lightColors.textPrimary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightColors.cardBg,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightColors.cardBg,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColors.cardSurface,
        hintStyle: TextStyle(color: lightColors.textMuted, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: lightColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: lightColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: lightColors.accentEmerald, width: 1.5),
        ),
      ),
    );
  }
}
