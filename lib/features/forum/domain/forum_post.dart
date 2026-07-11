/// Backend `ForumPostDto` / `ForumCommentDto` / `TagDto` karşılıkları —
/// tam forum (web ForumPage). `postType` ve etiket kategori kodları backend
/// enum'larıdır (etiketleri i18n'den gelir); etiket adları (`Tag.name`)
/// paylaşılan VERİdir, çevrilmez.
library;

/// Gönderi tipi kodları — web TABS birebir.
const List<String> kForumPostTypes = [
  'DENEYIM',
  'QUESTION',
  'TAVSIYE',
  'BASARI_HIKAYESI',
];

/// Etiket kategori kodları — web CATEGORY_LABELS anahtarları birebir.
const List<String> kForumTagCategories = [
  'ILETISIM',
  'SOSYAL',
  'DUYUSAL',
  'DAVRANIS',
  'MOTOR',
  'EGITIM',
];

/// Sıralama kodları — backend `order` parametresi (web sortMode birebir).
const List<String> kForumSortModes = ['new', 'hot', 'unanswered', 'expert'];

class ForumTag {
  const ForumTag({required this.id, required this.name, this.category});

  final String id;

  /// Semptom etiketi adı — paylaşılan veri, çevrilmez.
  final String name;
  final String? category;

  factory ForumTag.fromJson(Map<String, dynamic> json) {
    return ForumTag(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String?,
    );
  }
}

class ForumPost {
  const ForumPost({
    required this.id,
    required this.title,
    required this.content,
    this.postType = 'DENEYIM',
    this.category,
    this.pinned = false,
    this.featured = false,
    this.answered = false,
    this.anonymous = false,
    this.acceptedAnswerId,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByMe = false,
    this.ownedByMe = false,
    this.authorName,
    this.authorRole,
    this.tags = const [],
    this.createdAt,
  });

  final String id;
  final String title;

  /// Web zengin metin düzenleyicisinden geldiği için HTML olabilir.
  final String content;
  final String postType;
  final String? category;
  final bool pinned;
  final bool featured;
  final bool answered;
  final bool anonymous;
  final String? acceptedAnswerId;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;
  final bool ownedByMe;
  final String? authorName;
  final String? authorRole;
  final List<ForumTag> tags;
  final DateTime? createdAt;

  bool get isQuestion => postType == 'QUESTION';
  bool get authorIsExpert => !anonymous && authorRole == 'EXPERT';

  /// Gösterilecek yazar adı: anonimse null (arayüz "Anonim Kullanıcı" yazar).
  String? get displayAuthor => anonymous ? null : authorName;

  ForumPost copyWith({int? likeCount, bool? likedByMe, int? commentCount}) {
    return ForumPost(
      id: id,
      title: title,
      content: content,
      postType: postType,
      category: category,
      pinned: pinned,
      featured: featured,
      answered: answered,
      anonymous: anonymous,
      acceptedAnswerId: acceptedAnswerId,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likedByMe: likedByMe ?? this.likedByMe,
      ownedByMe: ownedByMe,
      authorName: authorName,
      authorRole: authorRole,
      tags: tags,
      createdAt: createdAt,
    );
  }

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    final tags = json['tags'];
    return ForumPost(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      postType: json['postType']?.toString() ?? 'DENEYIM',
      category: json['category'] as String?,
      pinned: json['pinned'] == true,
      featured: json['featured'] == true,
      answered: json['answered'] == true,
      anonymous: json['anonymous'] == true,
      acceptedAnswerId: json['acceptedAnswerId']?.toString(),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      likedByMe: json['likedByMe'] == true,
      ownedByMe: json['ownedByMe'] == true,
      authorName:
          author is Map<String, dynamic> ? author['fullName'] as String? : null,
      authorRole:
          author is Map<String, dynamic> ? author['role']?.toString() : null,
      tags: tags is List
          ? tags
              .whereType<Map<String, dynamic>>()
              .map(ForumTag.fromJson)
              .toList()
          : const [],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

class ForumComment {
  const ForumComment({
    required this.id,
    required this.content,
    this.parentCommentId,
    this.likeCount = 0,
    this.voteCount = 0,
    this.accepted = false,
    this.anonymous = false,
    this.upvotedByMe = false,
    this.downvotedByMe = false,
    this.expertApproved = false,
    this.ownedByMe = false,
    this.authorName,
    this.authorRole,
    this.createdAt,
  });

  final String id;
  final String content;
  final String? parentCommentId;
  final int likeCount;
  final int voteCount;
  final bool accepted;
  final bool anonymous;
  final bool upvotedByMe;
  final bool downvotedByMe;
  final bool expertApproved;
  final bool ownedByMe;
  final String? authorName;
  final String? authorRole;
  final DateTime? createdAt;

  bool get authorIsExpert => !anonymous && authorRole == 'EXPERT';
  String? get displayAuthor => anonymous ? null : authorName;

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    return ForumComment(
      id: json['id']?.toString() ?? '',
      content: json['content'] as String? ?? '',
      parentCommentId: json['parentCommentId']?.toString(),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      voteCount: (json['voteCount'] as num?)?.toInt() ?? 0,
      accepted: json['accepted'] == true,
      anonymous: json['anonymous'] == true,
      upvotedByMe: json['upvotedByMe'] == true,
      downvotedByMe: json['downvotedByMe'] == true,
      expertApproved: json['expertApproved'] == true,
      ownedByMe: json['ownedByMe'] == true,
      authorName:
          author is Map<String, dynamic> ? author['fullName'] as String? : null,
      authorRole:
          author is Map<String, dynamic> ? author['role']?.toString() : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

/// Sayfalı forum sonucu (`PageResponseDto` alt kümesi).
class ForumPageResult {
  const ForumPageResult({
    required this.posts,
    required this.totalPages,
  });

  final List<ForumPost> posts;
  final int totalPages;
}
