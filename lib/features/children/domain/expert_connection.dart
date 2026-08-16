/// Uzman–çocuk erişim bağlantısı (`/api/patients/connections/...`).
///
/// Backend serbest `Map` döner: `{id, expertId, expertName, childId,
/// childName, parentName, createdAt}`. Bekleyen istekler PENDING, onaylılar
/// APPROVED bağlantılardır (durum ayrı uç noktalarla ayrıldığı için gövdede
/// taşınmaz).
class ExpertConnection {
  const ExpertConnection({
    required this.id,
    this.expertId,
    this.expertName,
    this.childId,
    this.childName,
    this.createdAt,
  });

  final String id;
  final String? expertId;
  final String? expertName;
  final String? childId;
  final String? childName;
  final DateTime? createdAt;

  factory ExpertConnection.fromJson(Map<String, dynamic> json) {
    return ExpertConnection(
      id: json['id']?.toString() ?? '',
      expertId: json['expertId']?.toString(),
      expertName: json['expertName'] as String?,
      childId: json['childId']?.toString(),
      childName: json['childName'] as String?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
