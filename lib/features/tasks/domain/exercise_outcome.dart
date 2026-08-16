/// Günlük Egzersiz Sihirbazı iş kuralları (web `DailyExerciseWizard` birebir).
///
/// **Önek metinleri paylaşılan veridir, çevrilmez:** veli notunun başına
/// eklenen `[🎉 Kolayca Yaptık]` gibi işaretler backend'e yazılır ve web'de
/// aynı biçimde okunur.
library;

import 'expert_task.dart';

/// Egzersiz sonucu — web `'EASY' | 'SUPPORTED' | 'HARD'`.
enum ExerciseOutcome {
  easy('EASY', '[🎉 Kolayca Yaptık]'),
  supported('SUPPORTED', '[🙂 Destekle Yaptık]'),
  hard('HARD', '[💬 Bugün Zorlandık]');

  const ExerciseOutcome(this.code, this.notePrefix);

  /// Backend'e gitmez; yalnızca notu işaretlemek için kullanılır.
  final String code;

  /// Veli notunun başına eklenen işaret (paylaşılan veri).
  final String notePrefix;
}

/// Teslim edilecek not: sonuç öneki + velinin yazdığı not (web `outcomeNote`
/// birebir — not boşsa yalnızca önek gider).
String exerciseSubmissionNote(ExerciseOutcome outcome, String? note) {
  return '${outcome.notePrefix} ${note ?? ''}'.trim();
}

/// İlerleme ağacındaki seviyeler (0-3). Etiketler arayüz metnidir (i18n),
/// eşikler web ile birebir.
enum ExerciseStage {
  seed('🌱'),
  sprout('🌿'),
  flower('🌸'),
  tree('🌳');

  const ExerciseStage(this.emoji);

  final String emoji;
}

/// Tamamlanan görev oranına göre seviye — web: %75+ Ağaç, %50+ Çiçek,
/// %25+ Filiz, altı Tohum (yüzde yuvarlanarak hesaplanır).
ExerciseStage exerciseStageFor({required int completed, required int total}) {
  if (total <= 0) return ExerciseStage.seed;
  final percent = (completed / total * 100).round();
  if (percent >= 75) return ExerciseStage.tree;
  if (percent >= 50) return ExerciseStage.flower;
  if (percent >= 25) return ExerciseStage.sprout;
  return ExerciseStage.seed;
}

/// Sihirbazda gezilecek görevler: iptal edilenler düşer, bekleyenler son
/// tarihe göre önde ([sortTasksForDisplay] ile aynı sıra) — böylece sihirbaz
/// en acil egzersizle açılır.
List<ExpertTask> wizardTasks(List<ExpertTask> tasks) =>
    sortTasksForDisplay(tasks);

/// Sihirbazın açılacağı görev sırası: ilk bekleyen görev (hepsi tamamlanmışsa
/// listenin başı).
int firstPendingIndex(List<ExpertTask> tasks) {
  final index = tasks.indexWhere((task) => task.isPending);
  return index < 0 ? 0 : index;
}
