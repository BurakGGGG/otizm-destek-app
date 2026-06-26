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
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final String messageType;
  final DateTime? sentAt;
  final bool read;

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
    );
  }
}
