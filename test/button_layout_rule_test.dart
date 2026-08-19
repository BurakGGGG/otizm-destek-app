import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/theme/app_theme.dart';

/// Tema, dolgulu/çerçeveli butonlara `Size.fromHeight(...)` asgari boyutu
/// veriyor; bu **genişliği sonsuz** yapar. Row çocuklarına sınırsız genişlik
/// verdiği için sarmalanmamış bir buton ekranı çökertir. Bu kural bir kez
/// rehber ekranında, bir kez de randevu kartında gerçek hataya yol açtı;
/// burada hem kuralın kendisi hem de kaynak kodda tekrar etmediği doğrulanır.
void main() {
  Widget host(Widget child) =>
      MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

  testWidgets('Row içinde sarmalanmamış buton hata verir', (tester) async {
    await tester.pumpWidget(host(Row(children: [
      FilledButton(onPressed: () {}, child: const Text('x')),
    ])));
    expect(tester.takeException(), isNotNull);
  });

  testWidgets('Expanded ya da satır içi biçim sorunu çözer', (tester) async {
    await tester.pumpWidget(host(Row(children: [
      Expanded(child: FilledButton(onPressed: () {}, child: const Text('x'))),
      OutlinedButton(
        style: AppButtonStyles.inlineOutlined,
        onPressed: () {},
        child: const Text('y'),
      ),
    ])));
    expect(tester.takeException(), isNull);
  });

  test('lib/ içinde sarmalanmamış satır butonu kalmadı', () {
    final violations = <String>[];
    final buttonPattern = RegExp(r'\b(FilledButton|OutlinedButton)(\.\w+)?\(');
    const wrappers = [
      'Expanded(',
      'Flexible(',
      'SizedBox(',
      'ConstrainedBox(',
      'IntrinsicWidth(',
    ];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (!lines[i].contains('Row(')) continue;
        final rowIndent = lines[i].length - lines[i].trimLeft().length;
        for (var j = i + 1; j < lines.length && j < i + 120; j++) {
          final line = lines[j];
          if (line.trim().isEmpty) continue;
          final indent = line.length - line.trimLeft().length;
          final closing = const [');', '),', ')', '],'].contains(line.trim());
          if (indent <= rowIndent && !closing) break;
          if (!buttonPattern.hasMatch(line)) continue;

          // Satır içi biçim verilmişse sorun yok.
          final styled = lines
              .skip(j)
              .take(4)
              .any((l) => l.contains('AppButtonStyles.'));
          if (styled) continue;

          // Butonun üstündeki en yakın dış sarmalayıcıya bak.
          var wrapped = false;
          for (var k = j - 1; k > i; k--) {
            final above = lines[k];
            if (above.trim().isEmpty) continue;
            final aboveIndent = above.length - above.trimLeft().length;
            if (aboveIndent < indent) {
              wrapped = wrappers.any(above.contains);
              break;
            }
          }
          if (!wrapped) {
            violations.add('${entity.path}:${j + 1}  ${line.trim()}');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Row içindeki buton ya Expanded/Flexible ile sarmalanmalı ya da '
          'AppButtonStyles.inlineFilled/inlineOutlined biçimini almalı:\n'
          '${violations.join('\n')}',
    );
  });
}
