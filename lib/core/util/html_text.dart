/// Hafif HTML → düz metin dönüştürücü (bağımlılıksız).
///
/// Bilgi bankası içerikleri HTML olabilir; mobilde tam HTML render etmek yerine
/// blok etiketlerini satır sonuna, liste öğelerini madde imine çevirip kalan
/// etiketleri temizler ve yaygın HTML varlıklarını çözer.
String htmlToPlainText(String html) {
  if (html.isEmpty) return '';
  var s = html;

  // Liste öğeleri madde imi olsun.
  s = s.replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), '• ');

  // Blok kapanışları ve <br> satır sonuna dönüşsün.
  s = s.replaceAll(
    RegExp(
      r'<br\s*/?>|</(p|div|li|h[1-6]|ul|ol|tr|section|article)>',
      caseSensitive: false,
    ),
    '\n',
  );

  // Kalan tüm etiketleri kaldır.
  s = s.replaceAll(RegExp(r'<[^>]+>'), '');

  // Yaygın HTML varlıkları.
  const entities = {
    '&nbsp;': ' ',
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&quot;': '"',
    '&#39;': "'",
    '&apos;': "'",
    '&hellip;': '…',
    '&mdash;': '—',
    '&ndash;': '–',
  };
  entities.forEach((k, v) => s = s.replaceAll(k, v));

  // Üçten fazla ardışık satır sonunu ikiye indir, satır içi boşlukları sadeleştir.
  s = s.replaceAll(RegExp(r'[ \t]+'), ' ');
  s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return s.trim();
}
