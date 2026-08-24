/// Bilgi bankası kategorileri — web `KnowledgePage.CATEGORIES` birebir.
///
/// Anahtarlar makale kaydında saklanan **paylaşılan veridir**; etiketler de
/// web'de gösterilen Türkçe adlardır (çevrilmez).
library;

class KnowledgeCategory {
  const KnowledgeCategory(this.key, this.label);

  final String key;
  final String label;
}

const List<KnowledgeCategory> kKnowledgeCategories = [
  KnowledgeCategory('İletişim', 'İletişim'),
  KnowledgeCategory('Davranış', 'Davranış'),
  KnowledgeCategory('Eğitim', 'Eğitim'),
  KnowledgeCategory('Sağlık', 'Sağlık'),
  KnowledgeCategory('Beslenme', 'Beslenme & Diyet'),
  KnowledgeCategory('Duyusal Gelişim', 'Duyusal Gelişim'),
  KnowledgeCategory('Sosyal Beceriler', 'Sosyal Beceriler'),
  KnowledgeCategory('Aile', 'Aile & Ebeveynlik'),
  KnowledgeCategory('Yasal Haklar', 'Yasal Haklar & Haklar'),
  KnowledgeCategory('Erken Tanı', 'Erken Tanı & Takip'),
  KnowledgeCategory('Genel', 'Genel'),
];

/// İçerik türü filtresi kodları (web `TYPE_TO_FORMAT`): metin/video/podcast.
const String kFormatText = 'TEXT';
const String kFormatVideo = 'VIDEO';
const String kFormatPodcast = 'PODCAST';
