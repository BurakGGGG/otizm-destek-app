import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/knowledge/data/knowledge_repository.dart';
import 'package:otizm_destek_app/features/knowledge/domain/article.dart';
import 'package:otizm_destek_app/features/knowledge/domain/article_comment.dart';
import 'package:otizm_destek_app/features/knowledge/domain/knowledge_categories.dart';

void main() {
  group('bilgi bankası arama parametreleri (web search birebir)', () {
    test('boş sorgu yalnızca sayfalama gönderir', () {
      const query = ArticleQuery();
      expect(query.isEmpty, isTrue);
      expect(query.toQueryParameters(page: 0), {'page': 0, 'size': 12});
    });

    test('dolu filtreler q/category/format olarak gider', () {
      const query = ArticleQuery(
        text: '  uyku  ',
        category: 'Sağlık',
        format: kFormatVideo,
      );
      expect(query.toQueryParameters(page: 2, size: 20), {
        'q': 'uyku',
        'category': 'Sağlık',
        'format': 'VIDEO',
        'page': 2,
        'size': 20,
      });
    });

    test('filtre temizleme copyWith ile ayrı bayraklarla yapılır', () {
      const query = ArticleQuery(text: 'a', category: 'Aile', format: 'TEXT');
      expect(query.copyWith(clearCategory: true).category, isNull);
      expect(query.copyWith(clearFormat: true).format, isNull);
      // Temizlenmeyen alanlar korunur.
      expect(query.copyWith(clearCategory: true).format, 'TEXT');
    });
  });

  group('kategoriler paylaşılan veri', () {
    test('web CATEGORIES ile aynı anahtarlar', () {
      expect(kKnowledgeCategories.map((c) => c.key).toList(), [
        'İletişim',
        'Davranış',
        'Eğitim',
        'Sağlık',
        'Beslenme',
        'Duyusal Gelişim',
        'Sosyal Beceriler',
        'Aile',
        'Yasal Haklar',
        'Erken Tanı',
        'Genel',
      ]);
    });
  });

  group('makale ve yorum ayrıştırma', () {
    test('yer imi bayrağı okunur ve kopyalanabilir', () {
      final article = Article.fromJson({
        'id': '1',
        'title': 'Uyku',
        'bookmarked': true,
      });
      expect(article.bookmarked, isTrue);
      expect(article.copyWith(bookmarked: false).bookmarked, isFalse);
      expect(article.copyWith(bookmarked: false).title, 'Uyku');
    });

    test('deneyim bayrağı iki anahtardan da okunur', () {
      // Backend Lombok getter'ı yüzünden alan `experience` adıyla dönüyor.
      expect(
        ArticleComment.fromJson({'id': '1', 'experience': true}).isExperience,
        isTrue,
      );
      expect(
        ArticleComment.fromJson({'id': '1', 'isExperience': true}).isExperience,
        isTrue,
      );
      expect(
        ArticleComment.fromJson({'id': '1'}).isExperience,
        isFalse,
      );
    });

    test('uzman rozeti yazar rolünden gelir', () {
      final comment = ArticleComment.fromJson({
        'id': '1',
        'content': 'merhaba',
        'author': {'fullName': 'Uzm. Ayşe', 'role': 'EXPERT'},
      });
      expect(comment.isExpert, isTrue);
      expect(comment.authorName, 'Uzm. Ayşe');
    });
  });
}
