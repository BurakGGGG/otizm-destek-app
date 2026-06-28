/// Backend `NotificationDto` karşılığı (uygulama içi bildirim).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    this.type,
    this.body,
    this.link,
    this.read = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? type;
  final String? body;

  /// Web rotası (ör. `/randevular`); mobilde eşlenerek yönlendirilir.
  final String? link;
  final bool read;
  final DateTime? createdAt;

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      title: title,
      type: type,
      body: body,
      link: link,
      read: read ?? this.read,
      createdAt: createdAt,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String?,
      body: json['body'] as String?,
      link: json['link'] as String?,
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
