/// Bir rutin adımı (backend `RoutineItemDto`).
class RoutineItem {
  const RoutineItem({
    required this.id,
    required this.title,
    this.description,
    this.scheduledTime,
    this.iconName,
  });

  final String id;
  final String title;
  final String? description;
  final String? scheduledTime; // "HH:mm"
  final String? iconName;

  factory RoutineItem.fromJson(Map<String, dynamic> json) {
    return RoutineItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      scheduledTime: json['scheduledTime'] as String?,
      iconName: json['iconName'] as String?,
    );
  }
}

/// Bir rutin / görsel program (backend `RoutineDto`).
class Routine {
  const Routine({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
    this.items = const [],
  });

  final String id;
  final String name;
  final String? description;
  final bool isActive;
  final List<RoutineItem> items;

  factory Routine.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(RoutineItem.fromJson)
              .toList()
        : <RoutineItem>[];
    // Saate göre sırala (saati olanlar önce, kronolojik).
    items.sort((a, b) {
      final at = a.scheduledTime ?? '99:99';
      final bt = b.scheduledTime ?? '99:99';
      return at.compareTo(bt);
    });
    return Routine(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? json['active'] as bool? ?? true,
      items: items,
    );
  }
}
