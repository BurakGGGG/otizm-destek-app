import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/theme/app_theme.dart';
import 'package:otizm_destek_app/features/analytics/data/ai_insights_repository.dart';
import 'package:otizm_destek_app/features/analytics/presentation/widgets/ai_insights_card.dart';

void main() {
  test('analiz türleri backend enum kodlarıyla aynı', () {
    expect(kAnalysisTypes, ['GENERAL', 'BEHAVIORAL', 'PROGRESS', 'WEEKLY']);
  });

  testWidgets('markdown benzeri çıktı başlık, madde ve kalın ayırır',
      (tester) async {
    late List<Widget> blocks;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            blocks = aiInsightBlocks(
              context,
              '## Özet\n'
              '- Uyku **iyileşiyor**\n'
              '\n'
              'Genel gidişat olumlu.',
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    // Başlık + madde + boşluk + paragraf.
    expect(blocks.length, 4);
    expect(blocks.whereType<SizedBox>().length, 1);
  });
}
