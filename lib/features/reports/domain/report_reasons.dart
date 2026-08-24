/// Şikayet hedef türleri — backend `Report.targetType` alanına yazılır.
const String kReportTargetPost = 'POST';
const String kReportTargetComment = 'COMMENT';
const String kReportTargetExpert = 'EXPERT';

/// Uzman profili şikayet nedenleri — web ProfilePage `REPORT_REASONS`
/// birebir. Metin sunucuya olduğu gibi yazılır (moderasyon ekibi okuyor),
/// bu yüzden **paylaşılan veridir, çevrilmez.**
const List<String> kExpertReportReasons = [
  'Sahte/yanıltıcı profil bilgileri',
  'Lisans belgesi doğrulanamıyor',
  'Uygunsuz veya zararlı içerik',
  'Taciz veya kötüye kullanım',
  'İzinsiz reklam/ticari mesaj',
  'Diğer',
];

/// Seçilen neden + isteğe bağlı açıklama tek metne çevrilir (web birebir:
/// açıklama yeni satırla eklenir).
String composeReportReason(String reason, String? note) {
  final extra = note?.trim() ?? '';
  return extra.isEmpty ? reason : '$reason\n$extra';
}
