/// Backend `SleepEntryDto` karşılığı (gecelik uyku kaydı; gün başına tek kayıt).
class SleepEntry {
  const SleepEntry({
    required this.id,
    required this.childId,
    required this.sleepDate,
    this.bedtime,
    this.wakeTime,
    this.durationMinutes,
    this.quality,
    this.nightWakings = 0,
    this.notes,
  });

  final String id;
  final String childId;
  final String sleepDate; // "YYYY-MM-DD"
  final String? bedtime; // "HH:mm"
  final String? wakeTime; // "HH:mm"
  final int? durationMinutes; // backend hesaplar
  final int? quality; // 1-5
  final int nightWakings;
  final String? notes; // SleepNotes formatında serileştirilmiş

  DateTime? get date => DateTime.tryParse(sleepDate);

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id']?.toString() ?? '',
      childId: json['childId']?.toString() ?? '',
      sleepDate: json['sleepDate']?.toString() ?? '',
      bedtime: json['bedtime'] as String?,
      wakeTime: json['wakeTime'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      quality: (json['quality'] as num?)?.toInt(),
      nightWakings: (json['nightWakings'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
    );
  }
}

/// Uyku notu içine gömülü duyusal/çevresel faktörler.
///
/// Web ile paylaşılan format (birebir korunmalı):
/// `Weighted:true|Sensory:false|Melatonin:true|Disturbance:false|Notes:metin`
class SleepNotes {
  const SleepNotes({
    this.weightedBlanket = false,
    this.sensoryIssues = false,
    this.melatonin = false,
    this.noiseLightDisturbance = false,
    this.text = '',
  });

  final bool weightedBlanket;
  final bool sensoryIssues;
  final bool melatonin;
  final bool noiseLightDisturbance;
  final String text;

  bool get hasFactors =>
      weightedBlanket || sensoryIssues || melatonin || noiseLightDisturbance;

  String serialize() =>
      'Weighted:$weightedBlanket|Sensory:$sensoryIssues|Melatonin:$melatonin'
      '|Disturbance:$noiseLightDisturbance|Notes:$text';

  factory SleepNotes.parse(String? serialized) {
    final raw = serialized ?? '';
    if (!raw.startsWith('Weighted:')) return SleepNotes(text: raw);
    var weighted = false, sensory = false, melatonin = false, noise = false;
    var text = '';
    for (final part in raw.split('|')) {
      final idx = part.indexOf(':');
      if (idx == -1) continue;
      final key = part.substring(0, idx);
      final value = part.substring(idx + 1);
      switch (key) {
        case 'Weighted':
          weighted = value == 'true';
        case 'Sensory':
          sensory = value == 'true';
        case 'Melatonin':
          melatonin = value == 'true';
        case 'Disturbance':
          noise = value == 'true';
        case 'Notes':
          text = value;
      }
    }
    return SleepNotes(
      weightedBlanket: weighted,
      sensoryIssues: sensory,
      melatonin: melatonin,
      noiseLightDisturbance: noise,
      text: text,
    );
  }
}
