import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/config/env.dart';

import 'dart:convert';
import 'dart:io';

/// Uygulamanın konuştuğu bütün adresler HTTPS olmalı.
///
/// Android tarafında açık metin trafiği `network_security_config.xml` ile
/// zaten kapalı (istek çalışma anında düşer); bu test aynı kuralı derleme
/// öncesinde yakalar: bir profil yanlışlıkla `http://` gösterirse takım kırılır.
void main() {
  test('varsayılan adresler https', () {
    expect(Env.apiBaseUrl, startsWith('https://'));
    expect(Env.webBaseUrl, startsWith('https://'));
    expect(Env.wsUrl, startsWith('https://'));
  });

  test('ortam profilleri https', () {
    final profiles = Directory('config')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'));
    expect(profiles, isNotEmpty, reason: 'config/*.json bulunamadı');

    for (final file in profiles) {
      final values = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final key in ['API_BASE_URL', 'WEB_BASE_URL']) {
        final value = values[key];
        if (value == null) continue;
        expect(
          value.toString(),
          startsWith('https://'),
          reason: '${file.path} → $key açık metin adres taşıyor',
        );
      }
    }
  });

  test('Android sürüm derlemesinde açık metin kapalı', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    expect(manifest, contains('android:usesCleartextTraffic="false"'));
    expect(manifest, contains('@xml/network_security_config'));

    final config = File(
      'android/app/src/main/res/xml/network_security_config.xml',
    ).readAsStringSync();
    expect(config, contains('cleartextTrafficPermitted="false"'));
    // Sürüm yapılandırmasında hiçbir alan adı için istisna olmamalı.
    expect(config.contains('cleartextTrafficPermitted="true"'), isFalse);
  });
}
