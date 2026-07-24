import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Serene Path tasarım sistemi ölçüleri.
class AppRadius {
  const AppRadius._();
  static const double sm = 8; // çip, mini etiket
  static const double md = 12; // input, küçük buton
  static const double lg = 16; // kart
  static const double xl = 24; // büyük yüzey / bottom sheet
  static const double full = 9999;
}

class AppSpacing {
  const AppSpacing._();
  static const double margin = 20; // mobil yan boşluk (1.25rem)
  static const double gutter = 16;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

/// Uygulama teması (Serene Path). Otizm dostu: bol boşluk, sade tipografi,
/// gölge yerine ince çizgi/tonal katman, büyük dokunma hedefleri.
class AppTheme {
  const AppTheme._();

  static const String _fontFamily = 'Inter';
  static const double minTapTarget = 48;

  static ThemeData get light => _build(AppPalette.light, Brightness.light);
  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: p.primary,
          brightness: brightness,
        ).copyWith(
          primary: p.primary,
          onPrimary: p.onPrimary,
          primaryContainer: p.primaryContainer,
          secondary: p.secondary,
          surface: p.surface,
          error: p.error,
          outline: p.border,
          outlineVariant: p.border,
          onSurface: p.textPrimary,
          onSurfaceVariant: p.textSecondary,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      fontFamily: _fontFamily,
      visualDensity: VisualDensity.comfortable,
      splashFactory: InkRipple.splashFactory,
      extensions: [p],
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: p.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: p.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          minimumSize: const Size.fromHeight(minTapTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          minimumSize: const Size.fromHeight(minTapTarget),
          side: BorderSide(color: p.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.primary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.primary.withValues(alpha: 0.10),
        labelStyle: TextStyle(
          color: p.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: p.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.primary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.surface,
        selectedItemColor: p.primary,
        unselectedItemColor: p.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          height: 1.33,
          letterSpacing: -0.01,
          color: p.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          height: 1.4,
          color: p.textPrimary,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.4,
          color: p.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: p.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: p.textPrimary),
        bodySmall: TextStyle(fontSize: 13, height: 1.5, color: p.textSecondary),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: p.textSecondary,
        ),
      ),
    );
  }
}
