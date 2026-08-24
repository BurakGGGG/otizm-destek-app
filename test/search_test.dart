import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/search/domain/search_result.dart';

void main() {
  group('genel arama sonucu', () {
    test('backend alanları okunur', () {
      final result = SearchResult.fromJson({
        'id': 'a1',
        'type': 'ARTICLE',
        'title': 'Uyku rutini',
        'excerpt': 'Akşam rutinini sabitlemek…',
        'createdAt': '2026-08-01T10:00:00',
        'rank': 0.87,
      });
      expect(result.type, kSearchTypeArticle);
      expect(result.title, 'Uyku rutini');
      expect(result.excerpt, startsWith('Akşam'));
      expect(result.createdAt?.year, 2026);
      expect(result.rank, closeTo(0.87, 0.001));
    });

    test('eksik alanlar güvenli varsayılana düşer', () {
      final result = SearchResult.fromJson({'id': 'x'});
      expect(result.title, '');
      expect(result.excerpt, isNull);
      expect(result.rank, 0);
    });

    test('süzgeç sırası tümü ile başlar ve dört türü kapsar', () {
      expect(kSearchTypeFilters.first, isNull);
      expect(kSearchTypeFilters.whereType<String>().toList(), [
        kSearchTypeArticle,
        kSearchTypePost,
        kSearchTypeExpert,
        kSearchTypeGroup,
      ]);
    });
  });
}
