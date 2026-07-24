enum ChatRole { user, assistant }

/// Sohbet baloncuğu (kullanıcı veya asistan).
class ChatMessage {
  const ChatMessage({required this.role, required this.text});

  final ChatRole role;
  final String text;

  bool get isUser => role == ChatRole.user;

  ChatMessage copyWith({String? text}) =>
      ChatMessage(role: role, text: text ?? this.text);

  /// Backend geçmiş formatı: `{role: "user"|"model", text}`.
  Map<String, String> toHistoryJson() => {
    'role': role == ChatRole.user ? 'user' : 'model',
    'text': text,
  };
}
