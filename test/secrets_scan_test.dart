import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Depoya sır sızmasını engelleyen tarama.
///
/// Anahtarlar (Firebase istemci yapılandırması, imza anahtarı, ortam dosyaları)
/// sürüm kontrolünde tutulmuyor; bu test yalnızca **git'in izlediği** dosyalara
/// bakar, çalışma ağacındaki yerel kopyalar kuralı bozmaz.
///
/// Not: Firebase mobil API anahtarları gizli veri değildir (her APK'nın içinde
/// gider) — asıl koruma güvenlik kuralları ve sunucudaki yetkilendirmedir
/// (`docs/security.md`). Yine de depoda tutulmuyorlar: anahtar kısıtlaması
/// yapılmamış bir anahtarın kopyalanıp başka bir uygulamada kota harcaması
/// kolaylaşmasın.
void main() {
  late final List<String> tracked;

  setUpAll(() {
    final result = Process.runSync('git', ['ls-files', '-z']);
    expect(result.exitCode, 0, reason: 'git ls-files çalışmadı');
    tracked = (result.stdout as String)
        // `-z` NUL ile ayırır: boşluk içeren yol tek parça kalsın.
        .split('\u0000')
        .where((path) => path.isNotEmpty)
        .toList();
    expect(tracked, isNotEmpty);
  });

  test('gizli dosyalar depoda izlenmiyor', () {
    // Şablonlar (.example) yer tutucu değer taşır, kural dışıdır.
    const forbidden = <String>{
      '.env',
      'google-services.json',
      'GoogleService-Info.plist',
      'key.properties',
      'firebase_options.dart',
    };
    final offenders = tracked.where((path) {
      final name = path.split('/').last;
      if (path.endsWith('.example') || path.contains('.example.')) return false;
      if (forbidden.contains(name)) return true;
      if (name.startsWith('.env.')) return true;
      return name.endsWith('.jks') || name.endsWith('.keystore');
    }).toList();

    expect(
      offenders,
      isEmpty,
      reason: 'Bu dosyalar depoya girmemeli: $offenders\n'
          '`git rm --cached <dosya>` ile izlemeden çıkarın; .gitignore kuralı '
          'zaten var.',
    );
  });

  test('izlenen dosyalarda API anahtarı ya da özel anahtar yok', () {
    // Google API anahtarı biçimi (AIza + 35 karakter) ve PEM özel anahtar başlığı.
    final googleKey = RegExp(r'AIza[0-9A-Za-z_\-]{35}');
    final pemKey = RegExp(r'-----BEGIN [A-Z ]*PRIVATE KEY-----');
    final findings = <String>[];

    for (final path in tracked) {
      // Şablonlarda ve bu testin kendi deseninde yer tutucu var.
      if (path.endsWith('.example') || path.contains('.example.')) continue;
      if (path == 'test/secrets_scan_test.dart') continue;
      final file = File(path);
      if (!file.existsSync()) continue; // izlenen ama silinmiş dosya
      String content;
      try {
        content = file.readAsStringSync();
      } on FileSystemException {
        continue; // ikili dosya
      }
      if (googleKey.hasMatch(content)) findings.add('$path (API anahtarı)');
      if (pemKey.hasMatch(content)) findings.add('$path (özel anahtar)');
    }

    expect(
      findings,
      isEmpty,
      reason: 'Sır içeren dosyalar: $findings\n'
          'Değeri koddan çıkarıp yerel yapılandırmaya taşıyın '
          '(bkz. docs/security.md).',
    );
  });
}
