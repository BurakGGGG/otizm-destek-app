/// Backend `DevelopmentNoteDto` karşılığı (gelişim notu).
class DevelopmentNote {
  const DevelopmentNote({
    required this.id,
    required this.title,
    this.content,
    this.category,
    this.mood,
    this.noteDate,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? content;
  final String? category;
  final String? mood;
  final DateTime? noteDate;
  final DateTime? createdAt;

  factory DevelopmentNote.fromJson(Map<String, dynamic> json) {
    return DevelopmentNote(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String?,
      category: json['category'] as String?,
      mood: json['mood'] as String?,
      noteDate: DateTime.tryParse(json['noteDate']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
