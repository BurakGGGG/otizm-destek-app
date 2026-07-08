/// İletişim seviyesi seçenekleri — web ile birebir aynı düz metin (çevrilmez,
/// serbest JSON içinde saklanır).
const kCommunicationLevels = [
  'Sözel İletişim Yok',
  'Birkaç Kelime',
  'Kısa Cümleler',
  'Cümle Kurar',
  'Akıcı Konuşma',
  'AAC Cihazı Kullanır',
];

/// Kan grubu seçenekleri — web ile birebir aynı.
const kBloodTypes = [
  '',
  'A Rh+',
  'A Rh-',
  'B Rh+',
  'B Rh-',
  'AB Rh+',
  'AB Rh-',
  '0 Rh+',
  '0 Rh-',
  'Bilinmiyor',
];

/// Acil Durum Kartı — backend serbest JSON blob'u (`/api/emergency-card/{childId}`).
///
/// Alan anahtarları web `EmergencyProfile` ile birebir aynı olmalı ki veri
/// mobil ve web arasında ortak kalsın.
class EmergencyCard {
  const EmergencyCard({
    required this.childId,
    this.updatedAt = '',
    this.childName = '',
    this.birthDate = '',
    this.diagnosisInfo = 'Otizm Spektrum Bozukluğu (OSB)',
    this.communicationLevel = '',
    this.languages = 'Türkçe',
    this.bloodType = '',
    this.contactName1 = '',
    this.contactPhone1 = '',
    this.contactRelation1 = 'Anne',
    this.contactName2 = '',
    this.contactPhone2 = '',
    this.contactRelation2 = 'Baba',
    this.doctorName = '',
    this.doctorPhone = '',
    this.hospital = '',
    this.medications = '',
    this.allergies = '',
    this.medicalConditions = '',
    this.triggersList = '',
    this.calmingStrategies = '',
    this.avoidList = '',
    this.specialInstructions = '',
    this.selfInjury = false,
    this.wandering = false,
    this.nonVerbal = false,
  });

  final String childId;
  final String updatedAt;
  final String childName;
  final String birthDate;
  final String diagnosisInfo;
  final String communicationLevel;
  final String languages;
  final String bloodType;
  final String contactName1;
  final String contactPhone1;
  final String contactRelation1;
  final String contactName2;
  final String contactPhone2;
  final String contactRelation2;
  final String doctorName;
  final String doctorPhone;
  final String hospital;
  final String medications;
  final String allergies;
  final String medicalConditions;
  final String triggersList;
  final String calmingStrategies;
  final String avoidList;
  final String specialInstructions;
  final bool selfInjury;
  final bool wandering;
  final bool nonVerbal;

  /// Boş başlangıç kartı — çocuğun adı/doğum tarihi önden doldurulur.
  factory EmergencyCard.empty({
    required String childId,
    String childName = '',
    String birthDate = '',
  }) {
    return EmergencyCard(
      childId: childId,
      childName: childName,
      birthDate: birthDate,
    );
  }

  static String _s(dynamic v) => v?.toString() ?? '';
  static bool _b(dynamic v) => v == true;

  factory EmergencyCard.fromJson(Map<String, dynamic> json) {
    return EmergencyCard(
      childId: _s(json['childId']),
      updatedAt: _s(json['updatedAt']),
      childName: _s(json['childName']),
      birthDate: _s(json['birthDate']),
      diagnosisInfo: json['diagnosisInfo'] != null
          ? _s(json['diagnosisInfo'])
          : 'Otizm Spektrum Bozukluğu (OSB)',
      communicationLevel: _s(json['communicationLevel']),
      languages: json['languages'] != null ? _s(json['languages']) : 'Türkçe',
      bloodType: _s(json['bloodType']),
      contactName1: _s(json['contactName1']),
      contactPhone1: _s(json['contactPhone1']),
      contactRelation1:
          json['contactRelation1'] != null ? _s(json['contactRelation1']) : 'Anne',
      contactName2: _s(json['contactName2']),
      contactPhone2: _s(json['contactPhone2']),
      contactRelation2:
          json['contactRelation2'] != null ? _s(json['contactRelation2']) : 'Baba',
      doctorName: _s(json['doctorName']),
      doctorPhone: _s(json['doctorPhone']),
      hospital: _s(json['hospital']),
      medications: _s(json['medications']),
      allergies: _s(json['allergies']),
      medicalConditions: _s(json['medicalConditions']),
      triggersList: _s(json['triggersList']),
      calmingStrategies: _s(json['calmingStrategies']),
      avoidList: _s(json['avoidList']),
      specialInstructions: _s(json['specialInstructions']),
      selfInjury: _b(json['selfInjury']),
      wandering: _b(json['wandering']),
      nonVerbal: _b(json['nonVerbal']),
    );
  }

  /// Kaydetme gövdesi — web ile aynı anahtarlar. [updatedAt] çağıran tarafça
  /// ISO zaman damgasına ayarlanır.
  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'updatedAt': updatedAt,
      'childName': childName,
      'birthDate': birthDate,
      'diagnosisInfo': diagnosisInfo,
      'communicationLevel': communicationLevel,
      'languages': languages,
      'bloodType': bloodType,
      'contactName1': contactName1,
      'contactPhone1': contactPhone1,
      'contactRelation1': contactRelation1,
      'contactName2': contactName2,
      'contactPhone2': contactPhone2,
      'contactRelation2': contactRelation2,
      'doctorName': doctorName,
      'doctorPhone': doctorPhone,
      'hospital': hospital,
      'medications': medications,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'triggersList': triggersList,
      'calmingStrategies': calmingStrategies,
      'avoidList': avoidList,
      'specialInstructions': specialInstructions,
      'selfInjury': selfInjury,
      'wandering': wandering,
      'nonVerbal': nonVerbal,
    };
  }
}
