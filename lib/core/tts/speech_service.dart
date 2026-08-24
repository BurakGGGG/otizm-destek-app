import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Metni sesli okuyan ince sarmalayıcı (web'deki `speechSynthesis`
/// karşılığı). Kriz anında ekranı okuyamayan bakım verici adımları
/// dinleyebilsin diye kullanılır.
///
/// Cihazda ses motoru ya da dil paketi yoksa sessizce başarısız olur;
/// [speak] bu durumda `false` döner ve arayüz uyarı gösterir.
class SpeechService {
  SpeechService(this._tts);

  final FlutterTts _tts;
  bool _configured = false;

  /// Okuma bittiğinde/iptal edildiğinde tetiklenir.
  void Function()? onDone;

  Future<void> _configure(String languageCode) async {
    // Türkçe için tr-TR, diğer durumlarda en-US; dil yoksa varsayılan kalır.
    final language = languageCode == 'tr' ? 'tr-TR' : 'en-US';
    final available = await _tts.isLanguageAvailable(language);
    if (available == true) await _tts.setLanguage(language);
    await _tts.setSpeechRate(0.45); // web: rate 0.9 (WebSpeech ölçeği farklı)
    if (!_configured) {
      _tts.setCompletionHandler(() => onDone?.call());
      _tts.setCancelHandler(() => onDone?.call());
      _tts.setErrorHandler((_) => onDone?.call());
      _configured = true;
    }
  }

  Future<bool> speak(String text, {required String languageCode}) async {
    if (text.trim().isEmpty) return false;
    try {
      await _configure(languageCode);
      await _tts.stop();
      final result = await _tts.speak(text);
      // Platformlar 1 (başarılı) döner; null gelirse de okuma başlamış sayılır.
      return result == null || result == 1;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // Motor yoksa durdurulacak bir şey de yoktur.
    }
  }
}

final speechServiceProvider = Provider<SpeechService>((ref) {
  final service = SpeechService(FlutterTts());
  ref.onDispose(service.stop);
  return service;
});
