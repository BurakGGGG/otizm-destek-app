/// Destek Grubu — kategori bazlı aile/uzman topluluğu (grup sohbeti dahil).
///
/// Backend `GroupDto` karşılığı. `category` metni veri olarak saklanır
/// (web `groupCategories` ile birebir) — çevrilmez.
class Group {
  const Group({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.verified = false,
    this.avatarUrl,
    this.memberCount = 0,
    this.expertCount = 0,
    this.isMember = false,
    this.conversationId,
    this.createdByUserId,
  });

  final String id;
  final String name;
  final String? description;
  final String? category;
  final bool verified;
  final String? avatarUrl;
  final int memberCount;
  final int expertCount;
  final bool isMember;
  final String? conversationId;
  final String? createdByUserId;

  Group copyWith({bool? isMember, int? memberCount}) {
    return Group(
      id: id,
      name: name,
      description: description,
      category: category,
      verified: verified,
      avatarUrl: avatarUrl,
      memberCount: memberCount ?? this.memberCount,
      expertCount: expertCount,
      isMember: isMember ?? this.isMember,
      conversationId: conversationId,
      createdByUserId: createdByUserId,
    );
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      verified: json['verified'] == true,
      avatarUrl: json['avatarUrl'] as String?,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      expertCount: (json['expertCount'] as num?)?.toInt() ?? 0,
      isMember: json['isMember'] == true,
      conversationId: json['conversationId']?.toString(),
      createdByUserId: json['createdByUserId']?.toString(),
    );
  }
}

/// Grup kategorileri (web `groupCategories` ile birebir). Kategori metni DB'de
/// veri olarak saklandığı için çevrilmez.
const kGroupCategories = <String>[
  'Konuşma Gecikmesi',
  'Duyusal İşleme',
  'Sosyal Beceriler',
  'Erken Müdahale',
  'Okul Dönemi',
  'Ergen Dönemi',
  'Genel',
];

/// Grup buluşması (`GroupMeetingDto`) — üyeler görür, grubu kuran
/// planlar.
///
/// `startTime`/`endTime` saat dilimsiz `LocalDateTime`
/// (`yyyy-MM-ddTHH:mm:ss`), takvim etkinliklerindeki gibi.
class GroupMeeting {
  const GroupMeeting({
    required this.id,
    required this.title,
    required this.startTime,
    this.description,
    this.meetingUrl,
    this.endTime,
  });

  final String id;
  final String title;
  final DateTime startTime;
  final String? description;
  final String? meetingUrl;
  final DateTime? endTime;

  factory GroupMeeting.fromJson(Map<String, dynamic> json) {
    return GroupMeeting(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      startTime:
          DateTime.tryParse(json['startTime']?.toString() ?? '') ??
              DateTime.now(),
      description: (json['description'] as String?)?.trim(),
      meetingUrl: (json['meetingUrl'] as String?)?.trim(),
      endTime: DateTime.tryParse(json['endTime']?.toString() ?? ''),
    );
  }
}

/// Grup üyesi (`UserDto`'nun mobilde kullanılan alanları).
class GroupMember {
  const GroupMember({
    required this.id,
    required this.fullName,
    this.role,
    this.expertTitle,
    this.city,
    this.profileImageUrl,
  });

  final String id;
  final String fullName;
  final String? role;
  final String? expertTitle;
  final String? city;
  final String? profileImageUrl;

  bool get isExpert => role == 'EXPERT';

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id']?.toString() ?? '',
      fullName: (json['fullName'] as String?)?.trim() ?? '',
      role: json['role'] as String?,
      expertTitle: (json['expertTitle'] as String?)?.trim(),
      city: (json['city'] as String?)?.trim(),
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}
