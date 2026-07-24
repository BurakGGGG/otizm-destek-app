/// Haftanın Sorusu — topluluk sorusu ve aileden gelen cevaplar.
///
/// Backend `WeeklyQuestionDto` karşılığı. Cevap metnine web ile aynı biçimde
/// meta veri gömülür (`[ANONYMOUS_META:true]`, `[TAGS:a,b]` önekleri).
class WeeklyQuestion {
  const WeeklyQuestion({
    required this.id,
    required this.question,
    this.tag,
    this.weekLabel,
    this.answers = const [],
  });

  final String id;
  final String question;
  final String? tag;
  final String? weekLabel;
  final List<WeeklyAnswer> answers;

  /// Uzman (EXPERT) cevabı sayısı — kartta rozet olarak gösterilir.
  int get expertCount => answers.where((a) => a.isExpert).length;

  factory WeeklyQuestion.fromJson(Map<String, dynamic> json) {
    final list = json['answers'];
    return WeeklyQuestion(
      id: json['id']?.toString() ?? '',
      question: json['question'] as String? ?? '',
      tag: (json['tag'] as String?)?.trim().isEmpty ?? true
          ? null
          : json['tag'] as String?,
      weekLabel: json['weekLabel'] as String?,
      answers: list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(WeeklyAnswer.fromJson)
              .toList()
          : const [],
    );
  }
}

/// Haftanın Sorusu'na verilen bir cevap (`WeeklyAnswerDto`).
class WeeklyAnswer {
  const WeeklyAnswer({
    required this.id,
    required this.author,
    required this.rawText,
    this.city,
    this.authorRole,
    this.expertTitle,
    this.likes = 0,
    this.liked = false,
    this.createdAt,
  });

  final String id;
  final String author;

  /// Ham metin (meta önekleri dahil). Görüntüleme için [displayText] kullan.
  final String rawText;
  final String? city;
  final String? authorRole;
  final String? expertTitle;
  final int likes;
  final bool liked;
  final DateTime? createdAt;

  /// Meta öneklerinden arındırılmış görüntü metni.
  String get displayText => _parsed.text;

  /// Cevap sahibi anonim paylaşmış mı (metne gömülü meta).
  bool get isAnonymous => _parsed.anonymous;

  /// Cevaba iliştirilen etiketler (metne gömülü meta).
  List<String> get tags => _parsed.tags;

  /// Uzman cevabı mı — rol EXPERT ya da ad "Uzm."/"Dr." içerir (web ile aynı).
  bool get isExpert =>
      authorRole == 'EXPERT' ||
      author.contains('Uzm.') ||
      author.contains('Dr.');

  /// Anonimse gizlenmiş yazar; değilse gerçek ad.
  String? get displayAuthor => isAnonymous ? null : author;

  _ParsedAnswer get _parsed => _ParsedAnswer.of(rawText);

  WeeklyAnswer copyWith({int? likes, bool? liked}) {
    return WeeklyAnswer(
      id: id,
      author: author,
      rawText: rawText,
      city: city,
      authorRole: authorRole,
      expertTitle: expertTitle,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
      createdAt: createdAt,
    );
  }

  factory WeeklyAnswer.fromJson(Map<String, dynamic> json) {
    return WeeklyAnswer(
      id: json['id']?.toString() ?? '',
      author: json['author'] as String? ?? '',
      rawText: json['text'] as String? ?? '',
      city: json['city'] as String?,
      authorRole: json['authorRole'] as String?,
      expertTitle: json['expertTitle'] as String?,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      liked: json['liked'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }

  /// Web ile birebir aynı meta önekli ham metni üretir (gönderim için).
  static String encode({
    required String text,
    bool anonymous = false,
    List<String> tags = const [],
  }) {
    final buffer = StringBuffer();
    if (anonymous) buffer.write('[ANONYMOUS_META:true]');
    if (tags.isNotEmpty) buffer.write('[TAGS:${tags.join(',')}]');
    buffer.write(text.trim());
    return buffer.toString();
  }
}

/// Cevap metnindeki meta önekleri çözer (web `parseAnswerText` ile birebir).
class _ParsedAnswer {
  const _ParsedAnswer(this.text, this.anonymous, this.tags);

  final String text;
  final bool anonymous;
  final List<String> tags;

  static final _tagsRe = RegExp(r'^\[TAGS:(.*?)\]');

  factory _ParsedAnswer.of(String raw) {
    var text = raw;
    var anonymous = false;
    var tags = <String>[];

    if (text.startsWith('[ANONYMOUS_META:true]')) {
      anonymous = true;
      text = text.replaceFirst('[ANONYMOUS_META:true]', '');
    }
    final match = _tagsRe.firstMatch(text);
    if (match != null) {
      tags = (match.group(1) ?? '')
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList();
      text = text.replaceFirst(_tagsRe, '');
    }
    return _ParsedAnswer(text, anonymous, tags);
  }
}

/// Cevaba iliştirilebilen etiketler (web `AVAILABLE_TAGS` ile birebir; kodlar
/// metne gömüldüğü için çevrilmez).
const kWeeklyAnswerTags = <String>[
  'Oyun',
  'Duyusal',
  'Rutin',
  'Eğitim',
  'Kriz Yönetimi',
];
