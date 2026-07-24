/// Doz birimleri — DB'de düz metin saklanır, web ile aynı liste (çevrilmez).
const kMedicationUnits = ['mg', 'ml', 'damla', 'tablet', 'kapsül', 'IU', 'mcg'];

/// Sıklık enum değerleri (DB'ye yazılır); etiketleri i18n'den gelir.
const kMedicationFrequencies = [
  'DAILY',
  'TWICE_DAILY',
  'THREE_DAILY',
  'AS_NEEDED',
  'WEEKLY',
];

/// Yaygın yan etkiler — web `COMMON_SIDE_EFFECTS` ile birebir aynı düz metin.
/// DB'de bu string'ler saklandığı için ÇEVRİLMEZ.
const kMedicationSideEffects = [
  'Uyku Hali',
  'İştahsızlık',
  'Huzursuzluk',
  'Hiperaktivite',
  'Bulantı / Kusma',
  'Baş Ağrısı',
  'Ağız Kuruluğu',
  'Kabızlık / İshal',
];

/// Backend `MedicationLogDto` karşılığı (bir dozun günlük kaydı).
class MedicationLog {
  const MedicationLog({
    required this.id,
    required this.medicationId,
    required this.logDate,
    required this.scheduledTime,
    required this.taken,
    this.notes,
    this.sideEffects = const [],
  });

  final String id;
  final String medicationId;
  final String logDate; // "YYYY-MM-DD"
  final String scheduledTime; // "HH:mm" veya '' (saatsiz)
  final bool taken;
  final String? notes;
  final List<String> sideEffects;

  factory MedicationLog.fromJson(Map<String, dynamic> json) {
    return MedicationLog(
      id: json['id']?.toString() ?? '',
      medicationId: json['medicationId']?.toString() ?? '',
      logDate: json['logDate']?.toString() ?? '',
      scheduledTime: json['scheduledTime']?.toString() ?? '',
      taken: json['taken'] == true,
      notes: json['notes'] as String?,
      sideEffects: (json['sideEffects'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

/// Backend `MedicationDto` karşılığı (ilaç/takviye tanımı + bugünün dozları).
class Medication {
  const Medication({
    required this.id,
    required this.childId,
    required this.name,
    this.dosage,
    this.unit,
    this.frequency,
    this.scheduledTimes = const [],
    this.notes,
    this.isActive = true,
    this.todayLogs = const [],
  });

  final String id;
  final String childId;
  final String name;
  final String? dosage;
  final String? unit;
  final String? frequency; // kMedicationFrequencies
  final List<String> scheduledTimes; // "HH:mm"
  final String? notes;
  final bool isActive;
  final List<MedicationLog> todayLogs;

  /// Bir doz saatinin bugünkü kaydı (varsa).
  MedicationLog? logFor(String time) {
    for (final log in todayLogs) {
      if (log.scheduledTime == time) return log;
    }
    return null;
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id']?.toString() ?? '',
      childId: json['childId']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      dosage: json['dosage'] as String?,
      unit: json['unit'] as String?,
      frequency: json['frequency'] as String?,
      scheduledTimes: (json['scheduledTimes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      // Lombok `isActive` alanı JSON'da "active" olarak serileşir.
      isActive: (json['active'] ?? json['isActive'] ?? true) == true,
      todayLogs: (json['todayLogs'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(MedicationLog.fromJson)
              .toList() ??
          const [],
    );
  }
}
