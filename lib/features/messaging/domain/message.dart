/// Bir emoji tepkisinin özeti (`ReactionSummaryDto`).
class ReactionSummary {
  const ReactionSummary({required this.count, required this.reactedByMe});

  final int count;
  final bool reactedByMe;

  factory ReactionSummary.fromJson(Map<String, dynamic> json) {
    return ReactionSummary(
      count: (json['count'] as num?)?.toInt() ?? 0,
      reactedByMe: json['reactedByMe'] == true,
    );
  }
}

/// Hızlı tepki emojileri — web `QUICK_EMOJIS` birebir (sunucuya emoji metni
/// yazıldığı için paylaşılan veridir).
const List<String> kQuickReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

/// Backend'in kabul ettiği mesaj türleri.
const String kMessageTypeText = 'TEXT';
const String kMessageTypeImage = 'IMAGE';
const String kMessageTypeFile = 'FILE';
const String kMessageTypePecs = 'PECS';

/// Backend `MessageDto` karşılığı (sohbet mesajı).
class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.content = '',
    this.messageType = 'TEXT',
    this.sentAt,
    this.read = false,
    this.fileUrl,
    this.fileName,
    this.fileType,
    this.replyToId,
    this.replyToContent,
    this.replyToSenderName,
    this.reactions = const {},
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final String messageType;
  final DateTime? sentAt;
  final bool read;

  /// Ek dosya (varsa). `fileType` MIME tipidir (`image/png` gibi).
  final String? fileUrl;
  final String? fileName;
  final String? fileType;

  /// Yanıtlanan mesaj (alıntı balonu için).
  final String? replyToId;
  final String? replyToContent;
  final String? replyToSenderName;

  /// Emoji → özet. Sunucu güncel hâlini döndüğü için iyimser güncelleme yok.
  final Map<String, ReactionSummary> reactions;

  bool get hasImage =>
      (fileUrl?.isNotEmpty ?? false) &&
      ((fileType ?? '').startsWith('image/') || messageType == kMessageTypeImage);

  bool get hasFile => (fileUrl?.isNotEmpty ?? false) && !hasImage;

  bool isMine(String? userId) => userId != null && senderId == userId;

  /// STOMP frame'i bir mesaj mı (yoksa READ_RECEIPT gibi bir olay mı)?
  static bool isMessagePayload(Map<String, dynamic> json) {
    return json['type'] != 'READ_RECEIPT' && json['id'] != null;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName'] as String?,
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String? ?? 'TEXT',
      sentAt: DateTime.tryParse(json['sentAt']?.toString() ?? ''),
      read: json['read'] as bool? ?? false,
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileType: json['fileType'] as String?,
      replyToId: json['replyToId']?.toString(),
      replyToContent: json['replyToContent'] as String?,
      replyToSenderName: json['replyToSenderName'] as String?,
      reactions: _reactionsFrom(json['reactions']),
    );
  }
}

Map<String, ReactionSummary> _reactionsFrom(Object? raw) {
  if (raw is! Map) return const {};
  final result = <String, ReactionSummary>{};
  raw.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      result[key.toString()] = ReactionSummary.fromJson(value);
    }
  });
  return result;
}
