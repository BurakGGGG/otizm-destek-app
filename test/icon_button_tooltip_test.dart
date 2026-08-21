import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Simge düğmeleri ekran okuyucuya yalnızca `tooltip` üzerinden isim verir:
/// `Icon` kendi başına anlamsızdır, etiketsiz düğme TalkBack/VoiceOver'da
/// sadece "düğme" diye okunur. Uygulamanın erişilebilirlik bölümü olduğu
/// için bu kuralı kaynak taramasıyla koruyoruz.
void main() {
  testWidgets('tooltipsiz simge düğmesinin erişilebilirlik adı yok',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Row(children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
          IconButton(
            tooltip: 'Sil',
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
        ]),
      ),
    ));

    final nodes = tester
        .widgetList<IconButton>(find.byType(IconButton))
        .map((button) => tester.getSemantics(find.byWidget(button)))
        .toList();
    // Tooltip, adı `label` yerine anlamsal `tooltip` alanında taşır.
    expect('${nodes.first.label}${nodes.first.tooltip}', isEmpty);
    expect('${nodes.last.label}${nodes.last.tooltip}', contains('Sil'));
    handle.dispose();
  });

  test('lib/ içinde etiketsiz simge düğmesi kalmadı', () {
    // `IconButton.styleFrom(` bir biçim yardımcısı — düğme değil.
    final pattern =
        RegExp(r'\bIconButton(\.(filled|filledTonal|outlined))?\(');
    final violations = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final source = entity.readAsStringSync();
      for (final match in pattern.allMatches(source)) {
        var depth = 0;
        var index = match.end - 1;
        while (index < source.length) {
          final char = source[index];
          if (char == '(') depth++;
          if (char == ')') {
            depth--;
            if (depth == 0) break;
          }
          index++;
        }
        final body = source.substring(match.end, index);
        if (body.contains('tooltip:')) continue;
        final line = '\n'.allMatches(source.substring(0, match.start)).length;
        violations.add('${entity.path}:${line + 1}');
      }
    }

    expect(violations, isEmpty,
        reason: 'Bu simge düğmelerine tooltip eklenmeli:\n'
            '${violations.join('\n')}');
  });
}
