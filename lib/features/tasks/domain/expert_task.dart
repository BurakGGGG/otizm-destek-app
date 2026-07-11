/// Backend `ExpertTaskDto` / `TaskSubmissionDto` karşılıkları — uzmanın veliye
/// atadığı ödevler (web `/gorevler` TasksPage). `category` uzmanın yazdığı
/// serbest Türkçe metindir (paylaşılan veri, çevrilmez); `difficulty` ve
/// `status` enum kodlarıdır (etiketleri i18n'den gelir).
library;

/// Görev durumu kodları (backend `TaskStatus`).
const String kTaskPending = 'PENDING';
const String kTaskCompleted = 'COMPLETED';
const String kTaskCancelled = 'CANCELLED';

class ExpertTask {
  const ExpertTask({
    required this.id,
    required this.title,
    this.expertId,
    this.parentId,
    this.childId,
    this.description,
    this.category,
    this.difficulty,
    this.frequency,
    this.materialUrl,
    this.dueDate,
    this.status = kTaskPending,
  });

  final String id;
  final String title;
  final String? expertId;
  final String? parentId;
  final String? childId;
  final String? description;

  /// Serbest kategori metni (ör. 'Dil & İletişim') — web ile paylaşılan veri.
  final String? category;

  /// EASY / MEDIUM / HARD.
  final String? difficulty;
  final String? frequency;
  final String? materialUrl;

  /// `yyyy-MM-dd` (LocalDate) — saat bilgisi yok.
  final DateTime? dueDate;
  final String status;

  bool get isPending => status == kTaskPending;
  bool get isCompleted => status == kTaskCompleted;

  /// Son teslim tarihi geçti mi? Web `isOverdue` birebir: yalnızca bekleyen
  /// görevlerde, gün bazında (bugün son gün ise gecikmiş sayılmaz).
  bool get isOverdue {
    final due = dueDate;
    if (!isPending || due == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(due.year, due.month, due.day).isBefore(today);
  }

  factory ExpertTask.fromJson(Map<String, dynamic> json) {
    return ExpertTask(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      expertId: json['expertId']?.toString(),
      parentId: json['parentId']?.toString(),
      childId: json['childId']?.toString(),
      description: json['description'] as String?,
      category: json['category'] as String?,
      difficulty: json['difficulty'] as String?,
      frequency: json['frequency'] as String?,
      materialUrl: json['materialUrl'] as String?,
      dueDate: DateTime.tryParse(json['dueDate']?.toString() ?? ''),
      status: json['status']?.toString() ?? kTaskPending,
    );
  }
}

/// Web TasksPage sıralaması birebir: bekleyenler son tarihe göre artan
/// (tarihi olmayan sona), ardından tamamlananlar. CANCELLED listelenmez.
List<ExpertTask> sortTasksForDisplay(List<ExpertTask> tasks) {
  final pending = tasks.where((task) => task.isPending).toList()
    ..sort((a, b) {
      final ad = a.dueDate;
      final bd = b.dueDate;
      if (ad == null && bd == null) return 0;
      if (ad == null) return 1;
      if (bd == null) return -1;
      return ad.compareTo(bd);
    });
  final done = tasks.where((task) => task.isCompleted).toList();
  return [...pending, ...done];
}

class TaskSubmission {
  const TaskSubmission({
    required this.id,
    required this.taskId,
    this.parentId,
    this.parentNote,
    this.evidenceUrl,
    this.expertFeedback,
    this.expertReviewed = false,
    this.submittedAt,
  });

  final String id;
  final String taskId;
  final String? parentId;
  final String? parentNote;
  final String? evidenceUrl;
  final String? expertFeedback;
  final bool expertReviewed;
  final DateTime? submittedAt;

  factory TaskSubmission.fromJson(Map<String, dynamic> json) {
    return TaskSubmission(
      id: json['id']?.toString() ?? '',
      taskId: json['taskId']?.toString() ?? '',
      parentId: json['parentId']?.toString(),
      parentNote: json['parentNote'] as String?,
      evidenceUrl: json['evidenceUrl'] as String?,
      expertFeedback: json['expertFeedback'] as String?,
      expertReviewed: json['expertReviewed'] == true,
      submittedAt: DateTime.tryParse(json['submittedAt']?.toString() ?? ''),
    );
  }
}
