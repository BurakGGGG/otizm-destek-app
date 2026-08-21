import 'message.dart';

/// Konuşma katılımcısı (UserDto'nun hafif hâli).
class Participant {
  const Participant({
    required this.id,
    required this.fullName,
    this.profileImageUrl,
    this.role,
  });

  final String id;
  final String fullName;
  final String? profileImageUrl;
  final String? role; // PARENT | EXPERT | ADMIN

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      role: json['role'] as String?,
    );
  }
}

/// Backend `ConversationDto` karşılığı.
class Conversation {
  const Conversation({
    required this.id,
    required this.type,
    this.title,
    this.participants = const [],
    this.lastMessage,
    this.unreadCount = 0,
    this.lastMessageAt,
    this.muted = false,
    this.archived = false,
  });

  final String id;
  final String type; // DIRECT | GROUP
  final String? title;
  final List<Participant> participants;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime? lastMessageAt;
  final bool muted;
  final bool archived;

  bool get isGroup => type == 'GROUP';

  /// Karşı taraf uzman mı (konuşma listesindeki "Uzmanlar" süzgeci).
  bool hasExpert(String? currentUserId) => participants
      .any((p) => p.id != currentUserId && p.role == 'EXPERT');

  /// Görünen başlık: grup/başlık varsa onu, yoksa karşı katılımcının adını verir.
  String displayTitle(String? currentUserId) {
    if (title?.isNotEmpty ?? false) return title!;
    final others = participants.where((p) => p.id != currentUserId).toList();
    if (others.isNotEmpty) return others.first.fullName;
    return participants.isNotEmpty ? participants.first.fullName : '';
  }

  /// Birebir sohbette karşı tarafın kimliği (grupta null).
  String? otherParticipantId(String? currentUserId) {
    if (isGroup) return null;
    final others = participants.where((p) => p.id != currentUserId).toList();
    return others.isNotEmpty ? others.first.id : null;
  }

  String? avatarUrl(String? currentUserId) {
    final others = participants.where((p) => p.id != currentUserId).toList();
    return others.isNotEmpty ? others.first.profileImageUrl : null;
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final last = json['lastMessage'];
    return Conversation(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? 'DIRECT',
      title: json['title'] as String?,
      participants:
          (json['participants'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(Participant.fromJson)
              .toList() ??
          const [],
      lastMessage: last is Map<String, dynamic> ? Message.fromJson(last) : null,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessageAt: DateTime.tryParse(json['lastMessageAt']?.toString() ?? ''),
      muted: json['muted'] == true,
      archived: json['archived'] == true,
    );
  }
}
