import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/tasks/domain/expert_task.dart';

ExpertTask _task(
  String id, {
  String status = kTaskPending,
  DateTime? dueDate,
}) {
  return ExpertTask(id: id, title: id, status: status, dueDate: dueDate);
}

void main() {
  group('ExpertTask (web TasksPage mantığı birebir)', () {
    test('fromJson alanları okur', () {
      final task = ExpertTask.fromJson(const {
        'id': 'a1',
        'title': 'İki seçenekli tercih çalışması',
        'category': 'Dil & İletişim',
        'difficulty': 'MEDIUM',
        'frequency': 'Günde 2 kez',
        'materialUrl': 'https://example.com/kart.pdf',
        'dueDate': '2026-07-20',
        'status': 'PENDING',
      });
      expect(task.category, 'Dil & İletişim');
      expect(task.difficulty, 'MEDIUM');
      expect(task.dueDate, DateTime(2026, 7, 20));
      expect(task.isPending, isTrue);
      expect(task.isCompleted, isFalse);
    });

    test('isOverdue: dünü geçmiş sayar, bugünü ve tamamlananı saymaz', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final today = DateTime(now.year, now.month, now.day);

      expect(_task('gec', dueDate: yesterday).isOverdue, isTrue);
      expect(_task('bugun', dueDate: today).isOverdue, isFalse);
      expect(_task('tarihsiz').isOverdue, isFalse);
      expect(
        _task('bitti', status: kTaskCompleted, dueDate: yesterday).isOverdue,
        isFalse,
      );
    });

    test(
        'sortTasksForDisplay: bekleyenler tarihe göre önce (tarihsiz sona), '
        'sonra tamamlananlar; CANCELLED listelenmez', () {
      final sorted = sortTasksForDisplay([
        _task('bitti', status: kTaskCompleted),
        _task('tarihsiz'),
        _task('iptal', status: kTaskCancelled),
        _task('yarin', dueDate: DateTime(2026, 7, 12)),
        _task('bugun', dueDate: DateTime(2026, 7, 11)),
      ]);
      expect(
        sorted.map((task) => task.id),
        ['bugun', 'yarin', 'tarihsiz', 'bitti'],
      );
    });
  });

  test('TaskSubmission.fromJson uzman geri bildirimini okur', () {
    final sub = TaskSubmission.fromJson(const {
      'id': 's1',
      'taskId': 'a1',
      'parentNote': 'Çok rahat tamamladı',
      'evidenceUrl': 'https://drive.example/video',
      'expertFeedback': 'Harika ilerleme!',
      'expertReviewed': true,
      'submittedAt': '2026-07-10T14:30:00',
    });
    expect(sub.parentNote, 'Çok rahat tamamladı');
    expect(sub.expertReviewed, isTrue);
    expect(sub.expertFeedback, 'Harika ilerleme!');
    expect(sub.submittedAt, DateTime(2026, 7, 10, 14, 30));
  });
}
