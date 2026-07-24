import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// Tema modu (sistem/açık/koyu) — güvenli depoda kalıcı.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _restore();
    return ThemeMode.system;
  }

  Future<void> _restore() async {
    try {
      final raw = await ref.read(secureStorageProvider).readThemeMode();
      final mode = _parse(raw);
      if (mode != null) state = mode;
    } catch (_) {
      // depo okunamazsa sistem modunda kal
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    try {
      await ref.read(secureStorageProvider).saveThemeMode(mode.name);
    } catch (_) {
      // kayıt başarısızsa oturum içinde geçerli kalır
    }
  }

  static ThemeMode? _parse(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
