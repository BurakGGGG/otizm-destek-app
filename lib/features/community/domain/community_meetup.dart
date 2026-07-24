/// Yerel Buluşma — ailelerin şehir bazlı buluşma etkinliği.
///
/// Backend `CommunityMeetupDto` karşılığı. `date` LocalDate (`yyyy-MM-dd`),
/// `time` LocalTime (`HH:mm`) — saat dilimsiz.
class CommunityMeetup {
  const CommunityMeetup({
    required this.id,
    required this.title,
    required this.city,
    required this.date,
    this.district,
    this.venue,
    this.time,
    this.description,
    this.organizer,
    this.attendees = 0,
    this.joined = false,
    this.emoji,
    this.createdAt,
  });

  final String id;
  final String title;
  final String city;
  final DateTime date;
  final String? district;
  final String? venue;

  /// `HH:mm` (ilk 5 karaktere kırpılır).
  final String? time;
  final String? description;
  final String? organizer;
  final int attendees;
  final bool joined;
  final String? emoji;
  final DateTime? createdAt;

  /// Konum satırı: "İlçe, Şehir" ya da yalnızca "Şehir".
  String get location =>
      (district != null && district!.isNotEmpty) ? '$district, $city' : city;

  CommunityMeetup copyWith({int? attendees, bool? joined}) {
    return CommunityMeetup(
      id: id,
      title: title,
      city: city,
      date: date,
      district: district,
      venue: venue,
      time: time,
      description: description,
      organizer: organizer,
      attendees: attendees ?? this.attendees,
      joined: joined ?? this.joined,
      emoji: emoji,
      createdAt: createdAt,
    );
  }

  factory CommunityMeetup.fromJson(Map<String, dynamic> json) {
    final rawTime = json['time'] as String?;
    return CommunityMeetup(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      city: json['city'] as String? ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      district: json['district'] as String?,
      venue: json['venue'] as String?,
      time: (rawTime != null && rawTime.length >= 5)
          ? rawTime.substring(0, 5)
          : rawTime,
      description: json['description'] as String?,
      organizer: json['organizer'] as String?,
      attendees: (json['attendees'] as num?)?.toInt() ?? 0,
      joined: json['joined'] == true,
      emoji: json['emoji'] as String?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

/// Buluşma listesi filtresi şehirleri (web `FILTER_CITIES` ile birebir).
/// `Tümü` sunucuya gönderilmez (tüm şehirler).
const kMeetupFilterCities = <String>[
  'Tümü',
  'İstanbul',
  'Ankara',
  'İzmir',
  'Bursa',
  'Antalya',
  'Diğer',
];

/// Türkiye illeri (web `TURKISH_CITIES` ile birebir) — oluşturma formundaki
/// şehir seçici. Şehir adları veri olduğu için çevrilmez.
const kTurkishCities = <String>[
  'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya',
  'Ankara', 'Antalya', 'Ardahan', 'Artvin', 'Aydın', 'Balıkesir', 'Bartın',
  'Batman', 'Bayburt', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur',
  'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakır', 'Düzce',
  'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir', 'Gaziantep',
  'Giresun', 'Gümüşhane', 'Hakkari', 'Hatay', 'Iğdır', 'Isparta', 'İstanbul',
  'İzmir', 'Kahramanmaraş', 'Karabük', 'Karaman', 'Kars', 'Kastamonu',
  'Kayseri', 'Kilis', 'Kırıkkale', 'Kırklareli', 'Kırşehir', 'Kocaeli',
  'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Mardin', 'Mersin', 'Muğla', 'Muş',
  'Nevşehir', 'Niğde', 'Ordu', 'Osmaniye', 'Rize', 'Sakarya', 'Samsun',
  'Şanlıurfa', 'Siirt', 'Sinop', 'Sivas', 'Şırnak', 'Tekirdağ', 'Tokat',
  'Trabzon', 'Tunceli', 'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak',
];
