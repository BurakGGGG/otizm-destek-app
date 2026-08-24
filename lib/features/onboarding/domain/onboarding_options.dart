/// İlk giriş sihirbazındaki seçenekler — web `OnboardingPage` birebir.
///
/// Bu metinler çocuk kaydının serbest metin alanlarına (educationProgram,
/// therapies) yazılıp web'de de okunduğu için **veridir, çevrilmez**.
library;

/// Başlangıç odağı — `educationProgram` alanına `Başlangıç odağı: X` yazılır.
const List<String> kOnboardingFocusOptions = [
  'İletişim',
  'Sosyal oyun',
  'Duyusal düzenleme',
  'Davranış takibi',
];

/// İletişim şekli — `therapies` alanına ' · ' ile birleştirilir.
const List<String> kOnboardingCommunicationOptions = [
  'Tek sözcük',
  'Kısa cümle',
  'Jest/mimik',
  'Henüz sınırlı',
];

/// Yararlı olabilecek destek — `therapies` alanının ikinci parçası.
const List<String> kOnboardingSupportOptions = [
  'Görsel destek',
  'Kısa yönerge',
  'Rutin planı',
  'Duyusal mola',
];

/// `educationProgram` ön eki (web ile aynı).
const String kOnboardingFocusPrefix = 'Başlangıç odağı: ';
