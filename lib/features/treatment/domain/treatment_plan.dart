/// Web `treatmentPlan.tsx` portu — destek planı üretici.
///
/// DİKKAT: Buradaki tüm şablon metinleri web ile **birebir aynı Türkçe** kalır
/// (çevrilmez). Şablon hedef etiketleri `templateGoalToggles` anahtarı, oyunların
/// `linkedGoal` değeri ise `gameSessions` içinde paylaşılan DB blob'una yazılır;
/// metin değişirse web↔mobil veri tutarlılığı bozulur.
library;

import '../../appointments/domain/appointment.dart';
import '../../calendar/domain/calendar_event.dart';
import '../../notes/domain/development_note.dart';
import 'treatment_state.dart';

/// Odak alanı anahtarları (web `FocusKey`).
const kFocusKeys = [
  'communication',
  'social',
  'sensory',
  'motor',
  'behavior',
  'education',
];

/// Odak alanı → kısa Türkçe etiket (web `FOCUS_OPTIONS` — veri düzeni).
const kFocusLabels = <String, String>{
  'communication': 'İletişim',
  'social': 'Sosyal',
  'sensory': 'Duyusal',
  'motor': 'Motor',
  'behavior': 'Davranış',
  'education': 'Eğitim',
};

class FocusArea {
  const FocusArea({required this.key, required this.label, required this.reason});
  final String key;
  final String label;
  final String reason;
}

class GoalItem {
  const GoalItem({required this.label, required this.status});
  final String label;
  final String status; // done | active | upcoming
}

class GoalGroup {
  const GoalGroup({
    required this.key,
    required this.title,
    required this.percent,
    required this.items,
    required this.templateItems,
    required this.tone,
    required this.summary,
  });

  final String key;
  final String title;
  final int percent;
  final List<GoalItem> items;
  final List<GoalItem> templateItems;
  final String tone; // sky | violet
  final String summary;

  GoalGroup copyWith({int? percent, List<GoalItem>? items}) => GoalGroup(
        key: key,
        title: title,
        percent: percent ?? this.percent,
        items: items ?? this.items,
        templateItems: templateItems,
        tone: tone,
        summary: summary,
      );
}

class TherapyGame {
  const TherapyGame({
    required this.id,
    required this.key,
    required this.title,
    required this.skill,
    required this.approach,
    required this.benefit,
    required this.duration,
    required this.instruction,
    required this.tip,
    required this.tone,
    required this.linkedGoal,
    required this.linkedTool,
  });

  final String id;
  final String key;
  final String title;
  final String skill;
  final String approach;
  final String benefit;
  final String duration;
  final String instruction;
  final String tip;
  final String tone; // sky | emerald | amber
  final String linkedGoal;
  final String linkedTool;
}

class StoryCard {
  const StoryCard({
    required this.key,
    required this.title,
    required this.meta,
    required this.icon,
    required this.linkedGoal,
  });

  final String key;
  final String title;
  final String meta;
  final String icon;
  final String linkedGoal;
}

class TodayPlanStep {
  const TodayPlanStep({
    required this.id,
    required this.title,
    required this.detail,
    required this.duration,
    required this.linkedGoal,
    required this.linkedTool,
  });

  final String id;
  final String title;
  final String detail;
  final String duration;
  final String linkedGoal;
  final String linkedTool;
}

class SmartSuggestion {
  const SmartSuggestion({
    required this.id,
    required this.title,
    required this.detail,
  });

  final String id;
  final String title;
  final String detail;
}

/// Terapi bilgisi girilmemişse kullanılan varsayılan program etiketi
/// (web `treatmentPlan.tsx` birebir). Arayüz bu değeri gördüğünde
/// `<etiket> planı aktif` kalıbını kullanmaz — web'de "Günlük destek planı
/// planı aktif" gibi tekrar eden bir metin çıkıyor.
const String kDefaultProgramLabel = 'Günlük destek planı';

class SupportPlan {
  const SupportPlan({
    required this.focusAreas,
    required this.goalGroups,
    required this.stories,
    required this.games,
    required this.todayPlan,
    required this.smartSuggestions,
    required this.triggerSummary,
    required this.activeProgramLabel,
  });

  final List<FocusArea> focusAreas;
  final List<GoalGroup> goalGroups;
  final List<StoryCard> stories;
  final List<TherapyGame> games;
  final List<TodayPlanStep> todayPlan;
  final List<SmartSuggestion> smartSuggestions;
  final String triggerSummary;
  final String activeProgramLabel;
}

/// Web `splitTherapies` — serbest metni terapi listesine böler.
List<String> splitTherapies(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  return raw
      .split(RegExp(r'[\n,;]+'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

/// Web `normalizeText` — TR küçük harf + ASCII'leştirme.
String normalizeTreatmentText(String value) {
  return value
      .toLowerCase()
      .replaceAll('ç', 'c')
      .replaceAll('ğ', 'g')
      .replaceAll('ı', 'i')
      .replaceAll('İ', 'i')
      .replaceAll('ö', 'o')
      .replaceAll('ş', 's')
      .replaceAll('ü', 'u');
}

/// Web `getMoodLabel` — not ruh hâli rozeti.
String treatmentMoodLabel(String? mood) {
  if (mood == null || mood.isEmpty) return 'Gözlem';
  final n = normalizeTreatmentText(mood);
  if (n.contains('iyi') || n.contains('mutlu')) return 'Olumlu';
  if (n.contains('zor') || n.contains('kayg')) return 'Takip';
  return mood;
}

/// Web `sensoryValueLabel`.
String sensoryValueLabel(int value, {bool reverse = false}) {
  if (reverse) {
    if (value >= 70) return 'Normal';
    if (value >= 45) return 'Orta';
    return 'Düşük';
  }
  if (value >= 70) return 'Yüksek';
  if (value >= 45) return 'Orta';
  return 'Düşük';
}

/// Web `percentFromItems`.
int percentFromItems(List<GoalItem> items) {
  if (items.isEmpty) return 0;
  final done = items.where((i) => i.status == 'done').length;
  return ((done / items.length) * 100).round();
}

/// Web `CUSTOM_GOAL_GROUP_META` — yalnız özel hedef içeren gruplar için.
const _customGoalGroupMeta = <String, ({String title, String tone, String summary})>{
  'communication': (
    title: 'İletişim hedefleri',
    tone: 'sky',
    summary: 'Eklediğiniz iletişim hedefleri bu alanda takip edilir.',
  ),
  'social': (
    title: 'Sosyal Beceriler',
    tone: 'violet',
    summary: 'Eklediğiniz sosyal beceri hedefleri bu alanda takip edilir.',
  ),
  'sensory': (
    title: 'Duyusal düzenleme',
    tone: 'sky',
    summary: 'Eklediğiniz duyusal düzenleme hedefleri bu alanda takip edilir.',
  ),
  'motor': (
    title: 'Motor Beceriler',
    tone: 'sky',
    summary: 'Eklediğiniz motor beceri hedefleri bu alanda takip edilir.',
  ),
  'behavior': (
    title: 'Davranış Desteği',
    tone: 'violet',
    summary: 'Eklediğiniz davranış destek hedefleri bu alanda takip edilir.',
  ),
  'education': (
    title: 'Eğitim Becerileri',
    tone: 'sky',
    summary: 'Eklediğiniz eğitim beceri hedefleri bu alanda takip edilir.',
  ),
};

List<GoalItem> _mapCustomGoalsToItems(
  List<EditableGoal> customGoals,
  String focusKey,
) {
  return customGoals
      .where((goal) => goal.focusKey == focusKey)
      .map((goal) =>
          GoalItem(label: goal.title, status: goal.done ? 'done' : 'active'))
      .toList();
}

/// Web `mergeGoalGroups` — şablon + özel hedefleri birleştirir.
List<GoalGroup> mergeGoalGroups(
  List<GoalGroup> baseGroups,
  List<EditableGoal> customGoals, [
  Map<String, bool> templateGoalToggles = const {},
]) {
  final merged = baseGroups.map((group) {
    final mapped = _mapCustomGoalsToItems(customGoals, group.key);
    final withToggles = group.items
        .map((item) => templateGoalToggles[item.label] == true
            ? GoalItem(label: item.label, status: 'done')
            : item)
        .toList();
    final items = [...withToggles, ...mapped];
    return group.copyWith(items: items, percent: percentFromItems(items));
  }).toList();

  final existingKeys = merged.map((g) => g.key).toSet();
  for (final focusKey in kFocusKeys) {
    if (existingKeys.contains(focusKey)) continue;
    final items = _mapCustomGoalsToItems(customGoals, focusKey);
    if (items.isEmpty) continue;
    final meta = _customGoalGroupMeta[focusKey]!;
    merged.add(GoalGroup(
      key: focusKey,
      title: meta.title,
      percent: percentFromItems(items),
      items: items,
      templateItems: const [],
      tone: meta.tone,
      summary: meta.summary,
    ));
  }
  return merged;
}

/// Web `detectFocusAreas` — terapiler + son notlardan odak alanı çıkarımı.
List<FocusArea> detectFocusAreas(
  List<String> therapies,
  List<DevelopmentNote> notes,
) {
  final joined = normalizeTreatmentText(therapies.join(' '));
  final recentNoteText = notes
      .take(3)
      .map((note) =>
          normalizeTreatmentText('${note.title} ${note.content ?? ''}'))
      .join(' ');
  final source = '$joined $recentNoteText';

  final hasCommunication = source.contains('konus') ||
      source.contains('iletisim') ||
      source.contains('dil') ||
      source.contains('istek');
  final hasSensory = source.contains('duy') ||
      source.contains('ergoter') ||
      source.contains('hassas') ||
      source.contains('regul');
  final hasSocial = source.contains('aba') ||
      source.contains('sosyal') ||
      source.contains('goz temasi');
  final hasMotor = source.contains('motor') ||
      source.contains('fizyo') ||
      source.contains('koordinas') ||
      source.contains('hareket');
  final hasBehavior = source.contains('puan') ||
      source.contains('token') ||
      source.contains('sakinles');
  final hasEducation = source.contains('egitim') ||
      source.contains('okul') ||
      source.contains('akademik') ||
      source.contains('renk') ||
      source.contains('sayi');

  final focusAreas = <FocusArea>[];

  if (hasCommunication || therapies.isEmpty) {
    focusAreas.add(const FocusArea(
      key: 'communication',
      label: 'İletişim',
      reason: 'İstek belirtme, seçim yapma ve ifade etme desteği',
    ));
  }
  if (hasSocial || therapies.isEmpty) {
    focusAreas.add(const FocusArea(
      key: 'social',
      label: 'Sosyal beceri',
      reason: 'Göz teması, sıra alma ve birlikte oyun akışı',
    ));
  }
  if (hasSensory || therapies.isEmpty) {
    focusAreas.add(const FocusArea(
      key: 'sensory',
      label: 'Duyusal düzenleme',
      reason: 'Geçişler, uyaran toleransı ve sakinleşme desteği',
    ));
  }
  if (hasMotor && focusAreas.length < 3) {
    focusAreas.add(const FocusArea(
      key: 'motor',
      label: 'Motor beceri',
      reason: 'El-göz koordinasyonu ve kaba/ince motor gelişimi',
    ));
  }
  if (hasBehavior && focusAreas.length < 3) {
    focusAreas.add(const FocusArea(
      key: 'behavior',
      label: 'Davranış desteği',
      reason: 'Sakinleşme stratejileri ve olumlu davranış güçlendirme',
    ));
  }
  if (hasEducation && focusAreas.length < 3) {
    focusAreas.add(const FocusArea(
      key: 'education',
      label: 'Eğitim becerileri',
      reason: 'Renk, şekil, sayı ve akademik hazırlık',
    ));
  }

  if (focusAreas.isEmpty) {
    focusAreas.addAll(const [
      FocusArea(
        key: 'communication',
        label: 'İletişim',
        reason: 'Günlük ifade ve seçim yapma becerileri',
      ),
      FocusArea(
        key: 'social',
        label: 'Sosyal beceri',
        reason: 'Birlikte oyun ve ortak dikkat akışı',
      ),
    ]);
  }

  return focusAreas.take(3).toList();
}

/// Web `buildGoalGroups` — odak alanı başına şablon hedefler.
/// Etiketler `templateGoalToggles` anahtarıdır — DEĞİŞTİRME.
List<GoalGroup> buildGoalGroups(List<FocusArea> focusAreas) {
  return focusAreas.map((area) {
    switch (area.key) {
      case 'communication':
        const items = [
          GoalItem(label: 'İstek cümleleri kurma', status: 'upcoming'),
          GoalItem(label: 'Selamlama kelimeleri', status: 'upcoming'),
          GoalItem(label: '2 kelimeli cümle', status: 'upcoming'),
          GoalItem(label: 'Soru sormayı öğrenme', status: 'upcoming'),
        ];
        return GoalGroup(
          key: 'communication',
          title: 'İletişim hedefleri',
          percent: percentFromItems(items),
          items: items,
          templateItems: items,
          tone: 'sky',
          summary: 'PECS, seçim kartları ve istek oyunları aynı hedefi destekler.',
        );
      case 'social':
        const items = [
          GoalItem(label: 'Göz teması kurma', status: 'upcoming'),
          GoalItem(label: 'Paylaşma becerileri', status: 'upcoming'),
          GoalItem(label: 'Sıra bekleme', status: 'upcoming'),
          GoalItem(label: 'Grup oyununa katılım', status: 'upcoming'),
        ];
        return GoalGroup(
          key: 'social',
          title: 'Sosyal Beceriler',
          percent: percentFromItems(items),
          items: items,
          templateItems: items,
          tone: 'violet',
          summary: 'Sosyal hikâyeler ve sıra alma oyunlarıyla desteklenir.',
        );
      case 'motor':
        const items = [
          GoalItem(label: 'Top tutma ve fırlatma', status: 'upcoming'),
          GoalItem(label: 'İnce motor: boncuk dizme', status: 'upcoming'),
          GoalItem(label: 'Makası düzgün kullanma', status: 'upcoming'),
          GoalItem(label: 'Denge tahtasında durma', status: 'upcoming'),
        ];
        return GoalGroup(
          key: 'motor',
          title: 'Motor Beceriler',
          percent: percentFromItems(items),
          items: items,
          templateItems: items,
          tone: 'sky',
          summary:
              'Fiziksel aktiviteler ve el-göz koordinasyonu egzersizleriyle desteklenir.',
        );
      case 'behavior':
        const items = [
          GoalItem(label: 'Sakinleşme köşesini kullanma', status: 'upcoming'),
          GoalItem(label: 'Hayal kırıklığını ifade etme', status: 'upcoming'),
          GoalItem(label: 'Yönergeye 3 saniyede yanıt', status: 'upcoming'),
          GoalItem(label: 'Bekleme süresini uzatma', status: 'upcoming'),
        ];
        return GoalGroup(
          key: 'behavior',
          title: 'Davranış Desteği',
          percent: percentFromItems(items),
          items: items,
          templateItems: items,
          tone: 'violet',
          summary: 'Token ekonomisi ve görsel destek sistemleriyle desteklenir.',
        );
      case 'education':
        const items = [
          GoalItem(label: '5 rengi eşleştirme', status: 'upcoming'),
          GoalItem(label: '1-10 sayı dizisi', status: 'upcoming'),
          GoalItem(label: 'Temel şekilleri tanıma', status: 'upcoming'),
          GoalItem(label: 'Adını yazmaya başlama', status: 'upcoming'),
        ];
        return GoalGroup(
          key: 'education',
          title: 'Eğitim Becerileri',
          percent: percentFromItems(items),
          items: items,
          templateItems: items,
          tone: 'sky',
          summary:
              'Görsel materyaller ve oyun tabanlı öğrenme aktiviteleriyle desteklenir.',
        );
      default:
        const items = [
          GoalItem(label: 'Ses geçişlerinde sakin kalma', status: 'upcoming'),
          GoalItem(label: 'Duyusal mola isteme', status: 'upcoming'),
          GoalItem(label: 'Basınçlı aktiviteye yönelme', status: 'upcoming'),
          GoalItem(label: 'Uyaran toleransını uzatma', status: 'upcoming'),
        ];
        return GoalGroup(
          key: 'sensory',
          title: 'Duyusal düzenleme',
          percent: percentFromItems(items),
          items: items,
          templateItems: items,
          tone: 'sky',
          summary:
              'Duyusal mola, profil ve sakinleşme oyunlarıyla birlikte çalışır.',
        );
    }
  }).toList();
}

/// Web `buildStories` — hazır sosyal hikâye kartları.
List<StoryCard> buildStories(List<FocusArea> focusAreas) {
  final stories = <StoryCard>[];
  bool has(String key) => focusAreas.any((a) => a.key == key);
  if (has('social')) {
    stories.add(const StoryCard(
      key: 'social',
      title: 'Okula Gidiyorum',
      meta: '8 görsel adım - Sabah rutini',
      icon: '🏫',
      linkedGoal: 'Sosyal Beceriler',
    ));
  }
  if (has('communication')) {
    stories.add(const StoryCard(
      key: 'communication',
      title: 'İstediğimi Söylüyorum',
      meta: '6 görsel adım - İletişim rutini',
      icon: '💬',
      linkedGoal: 'İletişim hedefleri',
    ));
  }
  if (has('behavior')) {
    stories.add(const StoryCard(
      key: 'behavior',
      title: 'Sakinleşiyorum',
      meta: '5 görsel adım - Sakinleşme rutini',
      icon: '🧸',
      linkedGoal: 'Davranış Desteği',
    ));
  }
  stories.add(const StoryCard(
    key: 'sensory',
    title: 'Duyusal Mola Veriyorum',
    meta: '5 görsel adım - Geçiş rutini',
    icon: '🧘',
    linkedGoal: 'Duyusal düzenleme',
  ));
  return stories;
}

/// Web `buildRecommendedGames`'teki `gameLibrary` — id/linkedGoal veridir.
const kGameLibrary = <String, List<TherapyGame>>{
  'communication': [
    TherapyGame(
      id: 'request-cards',
      key: 'communication',
      title: 'İstek Kartları',
      skill: 'İletişim ve ifade etme',
      approach: 'Seçim yapma',
      benefit:
          'Çocuğun isteme, işaret etme ve kelime kullanma becerisini destekler.',
      duration: '5 dk',
      instruction:
          'İki seçenek sunun ve çocuktan bakarak, işaret ederek veya söyleyerek birini seçmesini bekleyin.',
      tip:
          'Bu oyunda açık uçlu soru yerine iki net seçenek vermek iletişimi kolaylaştırır.',
      tone: 'sky',
      linkedGoal: 'İletişim hedefleri',
      linkedTool: 'PECS Kart Kütüphanesi',
    ),
    TherapyGame(
      id: 'joint-attention-pointing',
      key: 'communication',
      title: 'Bak ve Göster',
      skill: 'Ortak dikkat',
      approach: 'Ortak dikkat',
      benefit:
          'Aynı nesneye birlikte odaklanma ve dikkat paylaşma becerisini güçlendirir.',
      duration: '4 dk',
      instruction:
          'Sevdiği bir nesneyi uzakta gösterin. Önce siz bakın ve işaret edin, sonra çocuğun bakmasını veya işaret etmesini bekleyin.',
      tip:
          'Çocuk nesneye kısa da olsa baktığında hemen sözel olarak fark ettiğinizi belirtin.',
      tone: 'sky',
      linkedGoal: 'İletişim hedefleri',
      linkedTool: 'AAC Dijital Tahta',
    ),
    TherapyGame(
      id: 'mirror-imitation',
      key: 'communication',
      title: 'Ayna Taklidi',
      skill: 'Taklit ve karşılıklı etkileşim',
      approach: 'Taklit',
      benefit: 'Yüz ifadesi, jest ve basit sesleri taklit etmeyi destekler.',
      duration: '5 dk',
      instruction:
          'Ayna karşısında el sallama, alkış, dudak büzme gibi çok kısa hareketler yapın ve çocuğun sizi kopyalamasını bekleyin.',
      tip:
          'Zor gelirse önce çocuğun yaptığı hareketi siz taklit edin, sonra sırayı yavaşça değiştirin.',
      tone: 'sky',
      linkedGoal: 'İletişim hedefleri',
      linkedTool: 'PECS Kart Kütüphanesi',
    ),
  ],
  'social': [
    TherapyGame(
      id: 'turn-taking',
      key: 'social',
      title: 'Sıra Alma Oyunu',
      skill: 'Bekleme ve ortak dikkat',
      approach: 'Sıra alma',
      benefit: 'Önce-ben-sonra-sen ritmini ve kısa bekleme süresini öğretir.',
      duration: '6 dk',
      instruction:
          'Top atma veya blok koyma oyunu oynayın. Her turda önce ben sonra sen kalıbını kullanın.',
      tip:
          'Sosyal hikâyeyle kısa bir hazırlık yapmak oyunu daha anlaşılır hale getirir.',
      tone: 'emerald',
      linkedGoal: 'Sosyal Beceriler',
      linkedTool: 'AAC Dijital Tahta',
    ),
    TherapyGame(
      id: 'build-together',
      key: 'social',
      title: 'Beraber Kule Kur',
      skill: 'Birlikte oyun',
      approach: 'Çocuk liderliğinde oyun',
      benefit:
          'Aynı oyunda kalma, partneri fark etme ve küçük ortak hedef kurma becerisini destekler.',
      duration: '7 dk',
      instruction:
          'Blokları ortada toplayın. Bir bloğu siz, bir bloğu çocuk koysun. Kule bitince birlikte kutlama yapın.',
      tip:
          'Çocuk farklı bir kule kurmak isterse oyunu tamamen bozmak yerine onun fikrine eşlik edin.',
      tone: 'emerald',
      linkedGoal: 'Sosyal Beceriler',
      linkedTool: 'AAC Dijital Tahta',
    ),
    TherapyGame(
      id: 'emotion-faces',
      key: 'social',
      title: 'Duygu Yüzleri',
      skill: 'Duygu fark etme',
      approach: 'Sosyal ipucu',
      benefit:
          'Mutlu, şaşkın, üzgün gibi temel yüz ifadelerini ayırt etmeye yardım eder.',
      duration: '4 dk',
      instruction:
          'İki yüz ifadesi kartı seçin. Siz ifadeyi yapın, çocuk doğru kartı bulsun veya aynı yüzü taklit etsin.',
      tip: 'İlk turda sadece iki duygu kullanın; seçenek sayısını yavaş yavaş artırın.',
      tone: 'emerald',
      linkedGoal: 'Sosyal Beceriler',
      linkedTool: 'Sosyal Hikâye Kartları',
    ),
  ],
  'sensory': [
    TherapyGame(
      id: 'sensory-break',
      key: 'sensory',
      title: 'Duyusal Mola',
      skill: 'Düzenleme ve sakinleşme',
      approach: 'Kısa düzenleme',
      benefit: 'Geçiş öncesi bedeni sakinleştirip oyuna hazırlar.',
      duration: '4 dk',
      instruction:
          'Minder itme, sarılma yastığı veya nefes hareketi ile kısa bir mola verin.',
      tip:
          'Duyusal profil kartındaki yüksek uyaranlar görüldüğünde bu oyunu önceleyin.',
      tone: 'amber',
      linkedGoal: 'Duyusal düzenleme',
      linkedTool: 'Duyusal Destek Kutusu',
    ),
    TherapyGame(
      id: 'heavy-work-station',
      key: 'sensory',
      title: 'Ağır İş İstasyonu',
      skill: 'Vücut farkındalığı',
      approach: 'Basınç ve taşıma',
      benefit:
          'İtme, çekme ve taşıma aktiviteleriyle bedensel düzenlemeyi destekler.',
      duration: '6 dk',
      instruction:
          'Yastık taşıma, minder itme veya oyuncak kutusunu kısa mesafede götürme gibi iki-üç ağır iş görevi seçin.',
      tip:
          'Kısa süreli ve ritmik tekrarlar genelde uzun tek bir etkinlikten daha iyi tolere edilir.',
      tone: 'amber',
      linkedGoal: 'Duyusal düzenleme',
      linkedTool: 'Duyusal Destek Kutusu',
    ),
    TherapyGame(
      id: 'sound-transition',
      key: 'sensory',
      title: 'Ses Geçiş Provası',
      skill: 'Uyaran toleransı',
      approach: 'Kademeli geçiş',
      benefit:
          'Sesli ortamlara hazırlık ve geçişlerde kaygıyı azaltmaya yardımcı olur.',
      duration: '3 dk',
      instruction:
          'Kısa bir zamanlayıcı açın, sessizden biraz daha sesli ortama geçmeden önce görsel geri sayım ve kulaklık seçeneği sunun.',
      tip: 'Amaç sese maruz bırakmak değil, geçişi öngörülebilir hale getirmektir.',
      tone: 'amber',
      linkedGoal: 'Duyusal düzenleme',
      linkedTool: 'Duyusal Destek Kutusu',
    ),
  ],
  'motor': [
    TherapyGame(
      id: 'ball-catch',
      key: 'motor',
      title: 'Top Yakalama',
      skill: 'El-göz koordinasyonu',
      approach: 'Kaba motor',
      benefit: 'El-göz koordinasyonunu ve tepki süresini geliştirir.',
      duration: '5 dk',
      instruction:
          'Önce büyük ve yavaş topla başlayın. Kısa mesafeden yavaşça atın, çocuğun tutmasını bekleyin.',
      tip:
          '"Neredeyse!" gibi teşvik ifadeleri başarısız denemelerde motivasyonu korur.',
      tone: 'emerald',
      linkedGoal: 'Motor Beceriler',
      linkedTool: 'Motor Aktivite Seti',
    ),
    TherapyGame(
      id: 'bead-threading',
      key: 'motor',
      title: 'Boncuk Dizme',
      skill: 'İnce motor beceri',
      approach: 'İnce motor',
      benefit:
          'Parmak kaslarını güçlendirir ve el-göz koordinasyonunu destekler.',
      duration: '6 dk',
      instruction:
          'Kalın ipli ve büyük delikli boncuklarla başlayın. Önce siz bir tane dizin, ardından çocuktan devam etmesini isteyin.',
      tip: 'Boncukları renge göre sıralamak hem motor hem bilişsel beceriyi destekler.',
      tone: 'emerald',
      linkedGoal: 'Motor Beceriler',
      linkedTool: 'Motor Aktivite Seti',
    ),
    TherapyGame(
      id: 'balance-walk',
      key: 'motor',
      title: 'Denge Çizgisi',
      skill: 'Denge ve vücut farkındalığı',
      approach: 'Kaba motor',
      benefit: 'Denge ve proprioseptif farkındalığı güçlendirir.',
      duration: '4 dk',
      instruction:
          'Zemine bant yapıştırarak çizgi oluşturun. Çocuktan çizgi üzerinde yürümesini isteyin. Hem ileri hem geri yürüyüşü deneyin.',
      tip: 'Elleri yana açık tutmak dengeyi kolaylaştırır; önce bunu gösterin.',
      tone: 'emerald',
      linkedGoal: 'Motor Beceriler',
      linkedTool: 'Motor Aktivite Seti',
    ),
  ],
  'behavior': [
    TherapyGame(
      id: 'calm-corner',
      key: 'behavior',
      title: 'Sakinleşme Köşesi',
      skill: 'Öz düzenleme',
      approach: 'Olumlu davranış desteği',
      benefit: 'Yoğun duyguları yönetmeyi ve sakinleşmeyi öğretir.',
      duration: '5 dk',
      instruction:
          'Özel bir "sakinleşme köşesi" oluşturun. Stres belirtilerini görünce çocuğu oraya yönlendirin ve 3 derin nefes almasına eşlik edin.',
      tip:
          'Köşeyi çocukla birlikte düzenlemek ona sahiplik hissi verir ve kullanımını artırır.',
      tone: 'amber',
      linkedGoal: 'Davranış Desteği',
      linkedTool: 'Token Ekonomisi Panosu',
    ),
    TherapyGame(
      id: 'token-board',
      key: 'behavior',
      title: 'Puan Tablosu Oyunu',
      skill: 'Motivasyon ve pekiştirme',
      approach: 'Token ekonomisi',
      benefit: 'Olumlu davranışları ödüllendirerek tekrarlanmasını sağlar.',
      duration: '10 dk',
      instruction:
          'Hedef davranışı sergileyen çocuğa bir puan verin. Belirlenen sayıya ulaşınca seçtiği bir ödülü kazanır.',
      tip: 'Başlangıçta ödüle ulaşmayı kolaylaştırın; başarı deneyimi motivasyonu artırır.',
      tone: 'amber',
      linkedGoal: 'Davranış Desteği',
      linkedTool: 'Token Ekonomisi Panosu',
    ),
    TherapyGame(
      id: 'waiting-practice',
      key: 'behavior',
      title: 'Bekleme Pratiği',
      skill: 'Erteleme toleransı',
      approach: 'Kademeli bekleme',
      benefit: 'Hayal kırıklığına toleransı ve bekleme kapasitesini artırır.',
      duration: '4 dk',
      instruction:
          'Çocuk bir şey istediğinde görsel zamanlayıcı ile kısa bekleme ekleyin (10 sn ile başlayın). Her gün 5-10 saniye artırın.',
      tip: 'Bekleme sırasında ne yapabileceğini göstermek süreci kolaylaştırır.',
      tone: 'amber',
      linkedGoal: 'Davranış Desteği',
      linkedTool: 'Token Ekonomisi Panosu',
    ),
  ],
  'education': [
    TherapyGame(
      id: 'color-match',
      key: 'education',
      title: 'Renk Eşleştirme',
      skill: 'Renk tanıma ve sınıflandırma',
      approach: 'Görsel eşleştirme',
      benefit: 'Renkleri tanımayı ve sınıflandırmayı öğretir.',
      duration: '5 dk',
      instruction:
          'Renkli kartları veya nesneleri karıştırın. Çocuktan aynı renkleri bir araya getirmesini isteyin. 3 renkle başlayın.',
      tip: 'Rengi söyleyerek eşleştirme yapmak dil gelişimini de destekler.',
      tone: 'sky',
      linkedGoal: 'Eğitim Becerileri',
      linkedTool: 'Öğrenme Aktivite Kutusu',
    ),
    TherapyGame(
      id: 'number-sequence',
      key: 'education',
      title: 'Sayı Dizisi',
      skill: 'Sayı tanıma ve sıralama',
      approach: 'Sayısal sıralama',
      benefit: "1'den 10'a kadar sayı sırasını ve sayı-miktar ilişkisini öğretir.",
      duration: '6 dk',
      instruction:
          "Numaralı kartları karıştırın. Çocuktan 1'den başlayarak sırayla dizip saymalarını isteyin.",
      tip: 'Her sayıyı söylerken o kadar nesneyi göstermek soyut sayıyı somutlaştırır.',
      tone: 'sky',
      linkedGoal: 'Eğitim Becerileri',
      linkedTool: 'Öğrenme Aktivite Kutusu',
    ),
    TherapyGame(
      id: 'shape-sort',
      key: 'education',
      title: 'Şekil Bul',
      skill: 'Şekil tanıma ve eşleştirme',
      approach: 'Görsel ayrım',
      benefit: 'Temel geometrik şekilleri tanımayı ve ayrıştırmayı öğretir.',
      duration: '4 dk',
      instruction:
          'Farklı şekillerdeki kartları veya blokları karıştırın. Çocuktan şekilleri gruplandırmasını isteyin.',
      tip:
          '"Daire nerede?" gibi sorular keşfi teşvik eder; şekil adlarını söyleyerek yönlendirin.',
      tone: 'sky',
      linkedGoal: 'Eğitim Becerileri',
      linkedTool: 'Öğrenme Aktivite Kutusu',
    ),
  ],
};

List<TherapyGame> buildRecommendedGames(List<FocusArea> focusAreas) {
  return focusAreas
      .expand((area) => kGameLibrary[area.key] ?? const <TherapyGame>[])
      .toList();
}

/// Web `buildTodayPlan` — adım id'leri `completedPlanSteps` anahtarıdır.
List<TodayPlanStep> buildTodayPlan(List<FocusArea> focusAreas) {
  bool has(String key) => focusAreas.any((a) => a.key == key);
  final steps = <TodayPlanStep>[];
  if (has('sensory')) {
    steps.add(const TodayPlanStep(
      id: 'prep-break',
      title: 'Duyusal hazırlık',
      detail:
          'Oyuna geçmeden önce 4 dakikalık nefes, baskı veya minder itme molası verin.',
      duration: '4 dk',
      linkedGoal: 'Duyusal düzenleme',
      linkedTool: 'Duyusal Destek Kutusu',
    ));
  }
  if (has('behavior')) {
    steps.add(const TodayPlanStep(
      id: 'behavior-prep',
      title: 'Sakinleşme köşesi hazırlık',
      detail: 'Aktiviteye başlamadan önce sakinleşme köşesini birlikte hazırlayın.',
      duration: '3 dk',
      linkedGoal: 'Davranış Desteği',
      linkedTool: 'Token Ekonomisi Panosu',
    ));
  }
  if (has('communication')) {
    steps.add(const TodayPlanStep(
      id: 'request-flow',
      title: 'İstek kartlarıyla seçim',
      detail:
          'İki seçenek sunup çocuğun isteme, bakma veya işaret etme cevabını bekleyin.',
      duration: '5 dk',
      linkedGoal: 'İletişim hedefleri',
      linkedTool: 'PECS Kart Kütüphanesi',
    ));
  }
  if (has('motor')) {
    steps.add(const TodayPlanStep(
      id: 'motor-warmup',
      title: 'Motor ısınma',
      detail:
          'Aktiviteye başlamadan önce 3 dakikalık kol ve el ısınma hareketi yapın.',
      duration: '3 dk',
      linkedGoal: 'Motor Beceriler',
      linkedTool: 'Motor Aktivite Seti',
    ));
  }
  if (has('social')) {
    steps.add(const TodayPlanStep(
      id: 'turn-flow',
      title: 'Sıra alma oyunu',
      detail: 'Top, blok ya da kartla önce ben sonra sen ritmi kurun.',
      duration: '6 dk',
      linkedGoal: 'Sosyal Beceriler',
      linkedTool: 'AAC Dijital Tahta',
    ));
  }
  if (has('education')) {
    steps.add(const TodayPlanStep(
      id: 'education-activity',
      title: 'Öğrenme aktivitesi',
      detail: 'Renk, sayı veya şekil eşleştirme oyunu oynayın.',
      duration: '5 dk',
      linkedGoal: 'Eğitim Becerileri',
      linkedTool: 'Öğrenme Aktivite Kutusu',
    ));
  }
  steps.add(TodayPlanStep(
    id: 'story-close',
    title: 'Görsel hikâye ile kapanış',
    detail: 'Günlük destek akışını kısa bir sosyal hikâye ile tamamlayın.',
    duration: '3 dk',
    linkedGoal: has('social') ? 'Sosyal Beceriler' : 'Duyusal düzenleme',
    linkedTool: 'Sosyal Hikâye Kartları',
  ));
  return steps.take(5).toList();
}

/// Web `buildSmartSuggestions`.
List<SmartSuggestion> buildSmartSuggestions(
  List<FocusArea> focusAreas,
  List<DevelopmentNote> notes,
  List<Appointment> appointments,
  List<CalendarEvent> events,
) {
  bool has(String key) => focusAreas.any((a) => a.key == key);
  final hasSchedule = appointments.length + events.length > 0;
  final suggestions = <SmartSuggestion>[];

  if (has('sensory') && hasSchedule) {
    suggestions.add(const SmartSuggestion(
      id: 'prep-transition',
      title: 'Geçişlerden önce duyusal mola',
      detail:
          'Bugün planlı bir akış görünüyor. Etkinlik veya randevu öncesi kısa mola iyi gelebilir.',
    ));
  }
  if (has('communication')) {
    suggestions.add(const SmartSuggestion(
      id: 'communication-cue',
      title: 'İki seçenekle iletişim başlat',
      detail:
          'Oyun sırasında açık soru yerine iki seçenek sunmak isteme becerisini güçlendirir.',
    ));
  }
  if (has('social')) {
    suggestions.add(const SmartSuggestion(
      id: 'social-bridge',
      title: 'Hikâye sonra oyun akışı',
      detail:
          'Önce görsel hikâyeyi gösterip sonra sıra alma oyununa geçmek sosyal beklentiyi netleştirir.',
    ));
  }
  if (has('motor')) {
    suggestions.add(const SmartSuggestion(
      id: 'motor-cue',
      title: 'Kısa motor molası',
      detail: 'Her 20 dakikada bir 3 dakikalık motor aktivite eklemek odaklanmayı artırır.',
    ));
  }
  if (has('behavior')) {
    suggestions.add(const SmartSuggestion(
      id: 'behavior-cue',
      title: 'Olumlu pekiştirmeyi erken ver',
      detail:
          'Hedef davranış başladığında hemen onaylamak davranışın tekrarlanma olasılığını artırır.',
    ));
  }
  if (notes.isNotEmpty) {
    suggestions.add(SmartSuggestion(
      id: 'latest-note',
      title: 'Son nottan çıkan odak',
      detail:
          '${notes.first.title} notuna göre bu hafta aynı beceriyi kısa tekrarlarla desteklemek iyi olur.',
    ));
  }
  return suggestions.take(3).toList();
}

/// Web `buildSupportPlan` — ana giriş noktası.
SupportPlan buildSupportPlan(
  List<String> therapies,
  List<DevelopmentNote> notes,
  List<Appointment> appointments,
  List<CalendarEvent> events,
) {
  final focusAreas = detectFocusAreas(therapies, notes);
  final activeProgramLabel =
      therapies.isNotEmpty ? therapies.first : kDefaultProgramLabel;
  final triggerSummary = focusAreas.any((a) => a.key == 'sensory')
      ? 'Son notlarda geçişler ve ses uyaranları duyusal destek ihtiyacını güçlendiriyor.'
      : 'Son notlarda büyük bir duyusal zorlanma sinyali yok, rutin desteği ile ilerleniyor.';
  final hasSchedule = appointments.length + events.length > 0;

  return SupportPlan(
    focusAreas: focusAreas,
    goalGroups: buildGoalGroups(focusAreas),
    stories: buildStories(focusAreas),
    games: buildRecommendedGames(focusAreas),
    todayPlan: buildTodayPlan(focusAreas),
    smartSuggestions:
        buildSmartSuggestions(focusAreas, notes, appointments, events),
    triggerSummary: hasSchedule
        ? '$triggerSummary Takvim ve seans akışı bu hedeflerle eşleştirildi.'
        : triggerSummary,
    activeProgramLabel: activeProgramLabel,
  );
}
