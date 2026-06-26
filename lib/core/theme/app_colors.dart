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
