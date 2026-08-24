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

    test('etiketler web gibi virgülle birleştirilmiş tek parametre', () {
      const query = ArticleQuery(tagIds: ['t1', 't2']);
      expect(query.isEmpty, isFalse);
      expect(query.toQueryParameters(page: 0)['tagIds'], 't1,t2');
      // Etiket yoksa parametre hiç gönderilmez.
      expect(
        const ArticleQuery().toQueryParameters(page: 0).containsKey('tagIds'),
        isFalse,
      );
    });

    test('toggleTag seçimi ekler ve kaldırır', () {
      const query = ArticleQuery(tagIds: ['t1']);
      expect(query.toggleTag('t2').tagIds, ['t1', 't2']);
      expect(query.toggleTag('t1').tagIds, isEmpty);
      // Diğer filtreler korunur.
      const full = ArticleQuery(text: 'uyku', category: 'Sağlık');
      expect(full.toggleTag('t9').text, 'uyku');
      expect(full.toggleTag('t9').category, 'Sağlık');
    });

    test('eşitlik etiket sırasından etkilenmez (gereksiz istek atılmaz)', () {
      const a = ArticleQuery(tagIds: ['t1', 't2']);
      const b = ArticleQuery(tagIds: ['t2', 't1']);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == const ArticleQuery(tagIds: ['t1']), isFalse);
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

    test('makale etiketleri okunur (paylaşılan veri)', () {
      final article = Article.fromJson({
        'id': '1',
        'title': 'Uyku',
        'tags': [
          {'id': 't1', 'name': 'Uyku sorunu', 'category': 'DAVRANIS'},
          {'id': 't2', 'name': 'Rutin'},
        ],
      });
      expect(article.tags.map((t) => t.name).toList(),
          ['Uyku sorunu', 'Rutin']);
      expect(article.tags.first.category, 'DAVRANIS');
      // Kopyalamada etiketler korunur.
      expect(article.copyWith(bookmarked: true).tags.length, 2);
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
