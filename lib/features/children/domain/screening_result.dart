/// Backend `ScreeningResultDto` karşılığı — dönemsel tarama sonucu.
/// Mobil yalnızca GÖSTERİR: web'de de tarama anketi arayüzü yok
/// (`/tarama` → `/cocuklarim` yönlendirmesi); sonuçlar başka kanallardan
/// üretilir. Skor 20 üzerinden; risk LOW/MEDIUM/HIGH.
class ScreeningResult {
  const ScreeningResult({
    required this.id,
    required this.testType,
    required this.score,
    this.riskLevel,
    this.createdAt,
  });

  final String id;
  final String testType;
  final int score;
  final String? riskLevel;
  final DateTime? createdAt;

  factory ScreeningResult.fromJson(Map<String, dynamic> json) {
    return ScreeningResult(
      id: json['id']?.toString() ?? '',
      testType: json['testType'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      riskLevel: json['riskLevel']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
