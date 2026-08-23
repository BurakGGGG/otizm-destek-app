import 'core/util/app_log.dart';
import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/providers.dart';
import 'features/notifications/data/push_service.dart';
import 'firebase_options.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  var firebaseReady = false;

  // Tüm başlatma + uygulama, yakalanmamış async hataları Crashlytics'e
  // iletmek için tek bir zone içinde çalışır.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Cihaz diline göre başlat (desteklenmiyorsa temel dil tr).
      LocaleSettings.useDeviceLocale();

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        firebaseReady = true;
      } catch (e) {
        // Native yapılandırma eksikse (ör. iOS plist) uygulama yine de açılsın.
        logDebugError('Firebase başlatılamadı', e);
      }

      if (firebaseReady) {
        // Debug'da toplama kapalı (gürültü olmasın); sürümde açık.
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          !kDebugMode,
        );
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
          !kDebugMode,
        );

        // Arka plan/kapalı push'lar için handler (token kaydı oturum açınca yapılır).
        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );

        // Flutter framework hatalarını Crashlytics'e yönlendir.
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        // Framework dışı (platform) async hataları da yakala.
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      runApp(
        TranslationProvider(
          child: ProviderScope(
            overrides: [firebaseReadyProvider.overrideWithValue(firebaseReady)],
            child: const OtizmDestekApp(),
          ),
        ),
      );
    },
    (error, stack) {
      // Zone'da yakalanan hatalar (Firebase hazırsa) Crashlytics'e gider.
      logDebugError('Yakalanmamış hata', error);
      if (firebaseReady) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}
