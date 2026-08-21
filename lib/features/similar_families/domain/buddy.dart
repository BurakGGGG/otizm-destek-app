/// Aile bağlantısı (buddy / mentor) — backend `BuddyDto` karşılığı.
///
/// `/api/buddies/my-list` kabul edilmiş bağlantıları, `/api/buddies/pending`
/// kullanıcıya **gelen** bekleyen istekleri döner. `status`: PENDING /
/// ACCEPTED / REJECTED / NONE.
class Buddy {
  const Buddy({
    required this.buddyId,
    required this.fullName,
    this.relationshipId,
    this.city,
    this.profileImageUrl,
    this.distanceKm,
    this.mentorRelation = false,
    this.requestMessage,
    this.status = 'NONE',
  });

  final String buddyId;
  final String fullName;

  /// İlişki kimliği — kabul/ret/kaldırma uç noktaları bunu ister.
  final String? relationshipId;
  final String? city;
  final String? profileImageUrl;
  final double? distanceKm;
  final bool mentorRelation;

  /// İstek gönderilirken yazılan tanışma notu (yalnızca bekleyen isteklerde).
  final String? requestMessage;
  final String status;

  factory Buddy.fromJson(Map<String, dynamic> json) {
    return Buddy(
      buddyId: '${json['buddyId'] ?? ''}',
      fullName: (json['fullName'] as String?)?.trim() ?? '',
      relationshipId: json['relationshipId'] == null
          ? null
          : '${json['relationshipId']}',
      city: (json['city'] as String?)?.trim(),
      profileImageUrl: json['profileImageUrl'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      mentorRelation: json['isMentorRelation'] == true,
      requestMessage: (json['requestMessage'] as String?)?.trim(),
      status: '${json['status'] ?? 'NONE'}',
    );
  }
}
