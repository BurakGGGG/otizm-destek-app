import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_keys.dart';
import 'core/providers.dart';
import 'core/router/app_router.dart';
import 'core/settings/app_preferences.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/notifications/data/push_service.dart';
import 'i18n/strings.g.dart';

class OtizmDestekApp extends ConsumerWidget {
  const OtizmDestekApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    // TranslationProvider üzerinden mevcut dil; dil değişince yeniden çizilir.
    final locale = TranslationProvider.of(context).flutterLocale;

    // Oturum açılınca FCM token'ını kaydet; çıkınca kaldır (Firebase hazırsa).
    ref.listen(authControllerProvider.select((s) => s.status), (prev, next) {
      if (!ref.read(firebaseReadyProvider)) return;
      final push = ref.read(pushServiceProvider);
      if (next == AuthStatus.authenticated) {
        push.init();
      } else if (next == AuthStatus.unauthenticated &&
          prev == AuthStatus.authenticated) {
        push.unregister();
      }
    });

    // Erişilebilirlik tercihleri tema ve metin ölçeğini uygulama genelinde
    // etkiler (web AccessibilityWidget karşılığı).
    final a11y = ref.watch(accessibilityProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.t.app.name,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: AppTheme.themeFor(
        palette: _palette(AppPalette.light, a11y),
        brightness: Brightness.light,
        reduceMotion: a11y.reduceMotion,
      ),
      darkTheme: AppTheme.themeFor(
        palette: _palette(AppPalette.dark, a11y),
        brightness: Brightness.dark,
        reduceMotion: a11y.reduceMotion,
      ),
      themeMode: themeMode,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        // Sistem yazı ölçeği korunur, büyük yazı tercihi onunla çarpılır.
        final scale = media.textScaler.scale(1) * a11y.textScaleFactor;
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScaler.linear(scale),
            disableAnimations: media.disableAnimations || a11y.reduceMotion,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  /// Erişilebilirlik tercihlerine göre palet dönüşümü. Yüksek kontrast,
  /// sakin görünümün üzerine uygulanır (kontrast okunabilirlik için önceliklidir).
  static AppPalette _palette(AppPalette base, AccessibilitySettings a11y) {
    var palette = base;
    if (a11y.calmMode) palette = palette.calm;
    if (a11y.highContrast) palette = palette.highContrast;
    return palette;
  }
}
