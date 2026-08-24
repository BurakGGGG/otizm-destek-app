import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/settings/app_preferences.dart';
import 'package:otizm_destek_app/core/theme/app_colors.dart';
import 'package:otizm_destek_app/core/theme/app_theme.dart';

const _off = AccessibilitySettings(
  largeText: false,
  reduceMotion: false,
  highContrast: false,
  calmMode: false,
  simpleMode: false,
);

double _contrast(Color a, Color b) {
  final l1 = a.computeLuminance();
  final l2 = b.computeLuminance();
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('erişilebilirlik tercihleri', () {
    test('büyük yazı ölçek çarpanı web ile aynı (%112,5)', () {
      expect(_off.textScaleFactor, 1.0);
      const large = AccessibilitySettings(
        largeText: true,
        reduceMotion: false,
        highContrast: false,
        calmMode: false,
        simpleMode: false,
      );
      expect(large.textScaleFactor, 1.125);
    });

    test('varsayılan tercih anahtarları web localStorage adlarıyla eşleşir', () {
      expect(AppPreference.a11yLargeText.key, 'access-large-text');
      expect(AppPreference.a11yCalmMode.key, 'access-calm-mode');
      expect(AppPreference.a11yHighContrast.key, 'access-high-contrast');
      expect(AppPreference.a11ySimpleMode.key, 'access-simple-mode');
      expect(AppPreference.a11yLargeText.defaultValue, isFalse);
    });
  });

  group('palet dönüşümleri', () {
    test('sakin mod ana rengi yumuşatır, arka planı sakinleştirir', () {
      final calm = AppPalette.light.calm;
      expect(calm.primary, isNot(AppPalette.light.primary));
      expect(calm.background, isNot(AppPalette.light.background));
      // Doygunluk düşer: sakin ana renk daha az mavi-parlaktır.
      expect(
        HSLColor.fromColor(calm.primary).saturation,
        lessThan(HSLColor.fromColor(AppPalette.light.primary).saturation),
      );
    });

    test('yüksek kontrast metin/arka plan oranı WCAG AAA üstünde', () {
      final light = AppPalette.light.highContrast;
      final dark = AppPalette.dark.highContrast;
      expect(_contrast(light.textPrimary, light.background), greaterThan(7));
      expect(_contrast(dark.textPrimary, dark.background), greaterThan(7));
      // İkincil metin de en az AA (4.5) sağlamalı.
      expect(_contrast(light.textSecondary, light.surface), greaterThan(4.5));
      expect(_contrast(dark.textSecondary, dark.surface), greaterThan(4.5));
    });

    test('koyu palette de sakin/kontrast dönüşümü koyu kalır', () {
      expect(AppPalette.dark.calm.background.computeLuminance(), lessThan(0.2));
      expect(
        AppPalette.dark.highContrast.background.computeLuminance(),
        lessThan(0.2),
      );
    });
  });

  group('tema', () {
    test('hareket azaltma sayfa geçişlerini kaldırır', () {
      final normal = AppTheme.themeFor(
        palette: AppPalette.light,
        brightness: Brightness.light,
      );
      final reduced = AppTheme.themeFor(
        palette: AppPalette.light,
        brightness: Brightness.light,
        reduceMotion: true,
      );
      expect(normal.splashFactory, isNot(NoSplash.splashFactory));
      expect(reduced.splashFactory, NoSplash.splashFactory);
      expect(
        reduced.pageTransitionsTheme.builders[TargetPlatform.android]
            .runtimeType.toString(),
        contains('NoTransitions'),
      );
    });
  });
}
