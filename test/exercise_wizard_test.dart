import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/tasks/domain/exercise_outcome.dart';
import 'package:otizm_destek_app/features/tasks/domain/expert_task.dart';

ExpertTask _task(String id, {String status = kTaskPending, DateTime? due}) {
  return ExpertTask(id: id, title: id, status: status, dueDate: due);
}

void main() {
  group('teslim notu (web outcomeNote birebir)', () {
    test('önek + not birleşir', () {
      expect(
        exerciseSubmissionNote(ExerciseOutcome.easy, 'Çok keyif aldı'),
        '[🎉 Kolayca Yaptık] Çok keyif aldı',
      );
      expect(
        exerciseSubmissionNote(ExerciseOutcome.supported, 'İpucu verdik'),
        '[🙂 Destekle Yaptık] İpucu verdik',
      );
    });

    test('not boşsa yalnızca önek gider', () {
      expect(
        exerciseSubmissionNote(ExerciseOutcome.hard, ''),
        '[💬 Bugün Zorlandık]',
      );
      expect(
        exerciseSubmissionNote(ExerciseOutcome.hard, null),
        '[💬 Bugün Zorlandık]',
      );
    });

    test('önekler paylaşılan veri — çevrilmez', () {
      expect(
        ExerciseOutcome.values.map((o) => o.notePrefix).toList(),
        ['[🎉 Kolayca Yaptık]', '[🙂 Destekle Yaptık]', '[💬 Bugün Zorlandık]'],
      );
      expect(
        ExerciseOutcome.values.map((o) => o.code).toList(),
        ['EASY', 'SUPPORTED', 'HARD'],
      );
    });
  });

  group('ilerleme seviyesi', () {
    test('web eşikleri: %25 / %50 / %75', () {
      expect(exerciseStageFor(completed: 0, total: 4), ExerciseStage.seed);
      expect(exerciseStageFor(completed: 1, total: 4), ExerciseStage.sprout);
      expect(exerciseStageFor(completed: 2, total: 4), ExerciseStage.flower);
      expect(exerciseStageFor(completed: 3, total: 4), ExerciseStage.tree);
      expect(exerciseStageFor(completed: 4, total: 4), ExerciseStage.tree);
    });

    test('yüzde yuvarlanarak hesaplanır (web Math.round)', () {
      // 1/3 = %33 → Filiz, 2/3 = %67 → Çiçek.
      expect(exerciseStageFor(completed: 1, total: 3), ExerciseStage.sprout);
      expect(exerciseStageFor(completed: 2, total: 3), ExerciseStage.flower);
      // 3/7 = %42,86 → yuvarlanınca %43, hâlâ Filiz.
      expect(exerciseStageFor(completed: 3, total: 7), ExerciseStage.sprout);
    });

    test('görev yoksa tohum', () {
      expect(exerciseStageFor(completed: 0, total: 0), ExerciseStage.seed);
    });
  });

  group('sihirbaz sırası', () {
    test('bekleyenler son tarihe göre önde, iptaller düşer', () {
      final tasks = wizardTasks([
        _task('done', status: kTaskCompleted),
        _task('iptal', status: kTaskCancelled),
        _task('geç', due: DateTime(2026, 8, 20)),
        _task('tarihsiz'),
        _task('yakın', due: DateTime(2026, 8, 17)),
      ]);
      expect(
        tasks.map((task) => task.id).toList(),
        ['yakın', 'geç', 'tarihsiz', 'done'],
      );
    });

    test('sihirbaz ilk bekleyen görevle açılır', () {
      final tasks = wizardTasks([
        _task('a', status: kTaskCompleted),
        _task('b', status: kTaskCompleted),
        _task('c'),
      ]);
      // Sıralama bekleyeni öne aldığı için indeks 0.
      expect(firstPendingIndex(tasks), 0);
      expect(tasks[firstPendingIndex(tasks)].id, 'c');
    });

    test('hepsi tamamlandıysa baştan başlar', () {
      final tasks = wizardTasks([
        _task('a', status: kTaskCompleted),
        _task('b', status: kTaskCompleted),
      ]);
      expect(firstPendingIndex(tasks), 0);
    });
  });
}
