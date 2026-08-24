// ŞABLON — gerçek dosya (`lib/firebase_options.dart`) depoya girmez.
//
// Kurulum:
//   flutterfire configure --project=<proje-id> --platforms=android,ios
// ya da bu dosyayı `firebase_options.dart` adıyla kopyalayıp değerleri
// Firebase konsolundan doldurun. Değerler eksikse `main.dart` Firebase
// başlatmayı sessizce atlar; uygulama push/analytics olmadan çalışır.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'API_ANAHTARI',
    appId: 'UYGULAMA_ID',
    messagingSenderId: 'GONDEREN_ID',
    projectId: 'PROJE_ID',
    storageBucket: 'PROJE_ID.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'API_ANAHTARI',
    appId: 'UYGULAMA_ID',
    messagingSenderId: 'GONDEREN_ID',
    projectId: 'PROJE_ID',
    storageBucket: 'PROJE_ID.firebasestorage.app',
    iosBundleId: 'PAKET_ADI',
  );
}
