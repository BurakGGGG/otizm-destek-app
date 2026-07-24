import 'package:flutter/material.dart';

/// Stitch "Serene Path" tasarım sistemi renkleri.
///
/// Güven veren, sakin ve erişilebilir bir palet: "Trust Blue" (#2563EB)
/// birincil aksiyon rengi; bol beyaz alan, düşük kontrastlı ince çizgiler.
class AppColors {
  const AppColors._();

  // Birincil — Trust Blue
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF004AC6);
  static const Color primaryContainer = Color(0xFFDBE1FF);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // İkincil — yumuşak indigo (az kullanılır)
  static const Color secondary = Color(0xFF6366F1);
  static const Color secondaryContainer = Color(0xFFE1E0FF);

  // Yüzeyler / katmanlar (tonal)
  static const Color background = Color(0xFFF8FAFC); // sayfa zemini
  static const Color surface = Color(0xFFFFFFFF); // kart
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0); // ince çizgi (gölge yerine)

  // Metin
  static const Color textPrimary = Color(0xFF0F172A); // yüksek kontrast
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Durumlar
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);

  // Yumuşak gölge (Level 2 — modal / sticky buton)
  static const Color shadow = Color(0x0D0F172A); // rgba(15,23,42,0.05)
}

/// Açık/koyu temaya göre çözülen anlamsal renk paleti. Widget'lar
/// `context.colors.X` ile erişir; `AppColors` (sabit, açık) tema kurarken kullanılır.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.success,
    required this.warning,
    required this.error,
  });

  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color success;
  final Color warning;
  final Color error;

  static const light = AppPalette(
    primary: Color(0xFF2563EB),
    primaryContainer: Color(0xFFDBE1FF),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF6366F1),
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF1F5F9),
    border: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textTertiary: Color(0xFF94A3B8),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFDC2626),
  );

  // Sakin, düşük uyarımlı koyu palet (slate tabanlı; saf siyah değil).
  static const dark = AppPalette(
    primary: Color(0xFF60A5FA),
    primaryContainer: Color(0xFF1E3A8A),
    onPrimary: Color(0xFF0B1220),
    secondary: Color(0xFF818CF8),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF334155),
    border: Color(0xFF334155),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFFCBD5E1),
    textTertiary: Color(0xFF94A3B8),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

/// Widget ağacında aktif paleti döndürür: `context.colors.primary`.
extension AppPaletteContext on BuildContext {
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
