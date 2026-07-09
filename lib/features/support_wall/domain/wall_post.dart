/// Dertleşme Duvarı paylaşımı — forum'un `SUPPORT_WALL` kategorisindeki gönderi.
///
/// Backend `ForumPostDto` karşılığı (yalnızca duvarda kullanılan alanlar).
class WallPost {
  const WallPost({
    required this.id,
    required this.title,
    required this.content,
    this.anonymous = true,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByMe = false,
    this.ownedByMe = false,
    this.authorName,
    this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final bool anonymous;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;
  final bool ownedByMe;
  final String? authorName;
  final DateTime? createdAt;

  /// Gösterilecek yazar adı: anonimse null döner (arayüz "Anonim" yazar).
  String? get displayAuthor => anonymous ? null : authorName;

  WallPost copyWith({
    int? likeCount,
    bool? likedByMe,
    int? commentCount,
  }) {
    return WallPost(
      id: id,
      title: title,
      content: content,
      anonymous: anonymous,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likedByMe: likedByMe ?? this.likedByMe,
      ownedByMe: ownedByMe,
      authorName: authorName,
      createdAt: createdAt,
    );
  }

  factory WallPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    return WallPost(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      anonymous: json['anonymous'] == true,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      likedByMe: json['likedByMe'] == true,
      ownedByMe: json['ownedByMe'] == true,
      authorName:
          author is Map<String, dynamic> ? author['fullName'] as String? : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

/// Dertleşme paylaşımına gelen destek yorumu (backend `ForumCommentDto`).
class WallComment {
  const WallComment({
    required this.id,
    required this.content,
    this.anonymous = true,
    this.ownedByMe = false,
    this.authorName,
    this.createdAt,
  });

  final String id;
  final String content;
  final bool anonymous;
  final bool ownedByMe;
  final String? authorName;
  final DateTime? createdAt;

  String? get displayAuthor => anonymous ? null : authorName;

  factory WallComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    return WallComment(
      id: json['id']?.toString() ?? '',
      content: json['content'] as String? ?? '',
      anonymous: json['anonymous'] == true,
      ownedByMe: json['ownedByMe'] == true,
      authorName:
          author is Map<String, dynamic> ? author['fullName'] as String? : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
