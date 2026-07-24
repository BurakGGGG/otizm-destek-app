import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/util/html_text.dart';
import 'package:otizm_destek_app/features/knowledge/domain/article.dart';

void main() {
  group('htmlToPlainText', () {
    test('etiketleri temizler ve varlıkları çözer', () {
      final out = htmlToPlainText('<p>Merhaba&nbsp;<b>dünya</b> &amp; herkes</p>');
      expect(out, 'Merhaba dünya & herkes');
    });

    test('blok ve <br> satır sonuna, <li> madde imine çevrilir', () {
      final out = htmlToPlainText('<li>bir</li><li>iki</li>satır<br>alt');
      expect(out, '• bir\n• iki\nsatır\nalt');
    });

    test('fazla satır sonları sadeleşir', () {
      expect(htmlToPlainText('a<br><br><br><br>b'), 'a\n\nb');
    });
  });

  group('Article.parsedContent', () {
    test('MEDIA video ön ekini ayıklar ve metni çıkarır', () {
      const a = Article(
        id: '1',
        title: 't',
        content: '[MEDIA:video:https://youtu.be/abc]\n<p>Açıklama</p>',
      );
      final p = a.parsedContent;
      expect(p.media, ArticleMedia.video);
      expect(p.mediaUrl, 'https://youtu.be/abc');
      expect(p.text, 'Açıklama');
    });

    test('ön ek yoksa format VIDEO medya türünü belirler', () {
      const a = Article(
        id: '1',
        title: 't',
        format: 'VIDEO',
        mediaUrl: 'https://x/y',
        content: 'düz metin',
      );
      final p = a.parsedContent;
      expect(p.media, ArticleMedia.video);
      expect(p.mediaUrl, 'https://x/y');
      expect(p.text, 'düz metin');
    });

    test('düz makale medyasız döner', () {
      const a = Article(id: '1', title: 't', content: 'sadece yazı');
      final p = a.parsedContent;
      expect(p.media, ArticleMedia.none);
      expect(p.mediaUrl, isNull);
      expect(p.text, 'sadece yazı');
    });
  });
}
