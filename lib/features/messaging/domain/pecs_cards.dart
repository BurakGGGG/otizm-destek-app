/// PECS görsel iletişim kartları — web MessagesPage `PECS_CARDS` birebir.
///
/// Kart gönderildiğinde **etiket metni** mesaj içeriği olarak yazılır ve
/// karşı taraf (web ya da mobil) içeriği bu listeyle eşleştirip emojisini
/// gösterir. Yani etiketler paylaşılan VERİdir — çevrilmez. Kategori adları
/// da eşleşmeyi bozmamak için aynı bırakılır.
class PecsCard {
  const PecsCard(this.id, this.label, this.emoji, this.category);

  final String id;
  final String label;
  final String emoji;
  final String category;
}

const List<String> kPecsCategories = ['Duygular', 'İhtiyaçlar', 'Günlük'];

const List<PecsCard> kPecsCards = [
  PecsCard('happy', 'Mutluyum', '😊', 'Duygular'),
  PecsCard('sad', 'Üzgünüm', '😢', 'Duygular'),
  PecsCard('angry', 'Öfkeliyim', '😠', 'Duygular'),
  PecsCard('scared', 'Korkuyorum', '😨', 'Duygular'),
  PecsCard('hungry', 'Açım', '🍔', 'İhtiyaçlar'),
  PecsCard('thirsty', 'Susadım', '🥤', 'İhtiyaçlar'),
  PecsCard('toilet', 'Tuvalet', '🚽', 'İhtiyaçlar'),
  PecsCard('help', 'Yardım', '🙋', 'İhtiyaçlar'),
  PecsCard('rest', 'Dinlenmek', '🛌', 'İhtiyaçlar'),
  PecsCard('play', 'Oynamak', '🧸', 'Günlük'),
  PecsCard('sleep', 'Uyumak', '😴', 'Günlük'),
  PecsCard('home', 'Eve Gitmek', '🏠', 'Günlük'),
];

/// Mesaj içeriği bir PECS kartıysa kartı, değilse null döner (web mesaj
/// balonunda da içerik etiketle eşleştiriliyor).
PecsCard? pecsCardForContent(String content) {
  final text = content.trim();
  for (final card in kPecsCards) {
    if (card.label == text) return card;
  }
  return null;
}

List<PecsCard> pecsCardsOf(String category) =>
    [for (final card in kPecsCards) if (card.category == category) card];
