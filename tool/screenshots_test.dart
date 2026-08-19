// Ekran görüntüsü üreteci (test değil, araç).
//
//   flutter test tool/screenshots_test.dart --update-goldens
//
// Çıktılar `build/screens/*.png` altına yazılır (git dışında). Ekranlar
// sahte verilerle kurulur; ağ ya da oturum gerekmez. `flutter test` yalnızca
// `test/` klasörünü çalıştırdığı için bu dosya normal takıma girmez.
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/providers.dart';
import 'package:otizm_destek_app/core/realtime/stomp_service.dart';
import 'package:otizm_destek_app/core/storage/secure_storage.dart';
import 'package:otizm_destek_app/core/theme/app_theme.dart';
import 'package:otizm_destek_app/features/analytics/data/analytics_repository.dart';
import 'package:otizm_destek_app/features/analytics/domain/analytics_trends.dart';
import 'package:otizm_destek_app/features/analytics/presentation/analytics_screen.dart';
import 'package:otizm_destek_app/features/appointments/data/appointment_repository.dart';
import 'package:otizm_destek_app/features/appointments/domain/appointment.dart';
import 'package:otizm_destek_app/features/appointments/presentation/appointments_screen.dart';
import 'package:otizm_destek_app/features/appointments/presentation/widgets/appointment_detail_sheet.dart';
import 'package:otizm_destek_app/features/auth/domain/app_user.dart';
import 'package:otizm_destek_app/features/auth/presentation/auth_controller.dart';
import 'package:otizm_destek_app/features/children/data/child_repository.dart';
import 'package:otizm_destek_app/features/children/data/connection_repository.dart';
import 'package:otizm_destek_app/features/children/domain/child.dart';
import 'package:otizm_destek_app/features/community/presentation/community_screen.dart';
import 'package:otizm_destek_app/features/crisis/presentation/crisis_screen.dart';
import 'package:otizm_destek_app/features/guide/presentation/guide_screen.dart';
import 'package:otizm_destek_app/features/home/data/daily_plan_provider.dart';
import 'package:otizm_destek_app/features/home/domain/daily_plan.dart';
import 'package:otizm_destek_app/features/home/presentation/home_tab.dart';
import 'package:otizm_destek_app/features/knowledge/data/knowledge_repository.dart';
import 'package:otizm_destek_app/features/knowledge/domain/article.dart';
import 'package:otizm_destek_app/features/knowledge/presentation/knowledge_screen.dart';
import 'package:otizm_destek_app/features/messaging/data/messaging_repository.dart';
import 'package:otizm_destek_app/features/messaging/domain/conversation.dart';
import 'package:otizm_destek_app/features/messaging/domain/message.dart';
import 'package:otizm_destek_app/features/messaging/presentation/conversation_thread_screen.dart';
import 'package:otizm_destek_app/features/messaging/presentation/conversations_screen.dart';
import 'package:otizm_destek_app/features/specialists/data/expert_repository.dart';
import 'package:otizm_destek_app/features/specialists/domain/expert.dart';
import 'package:otizm_destek_app/features/specialists/domain/expert_review.dart';
import 'package:otizm_destek_app/features/specialists/presentation/expert_detail_screen.dart';
import 'package:otizm_destek_app/features/specialists/presentation/specialists_tab.dart';
import 'package:otizm_destek_app/features/tags/data/tag_repository.dart';
import 'package:otizm_destek_app/features/tags/domain/symptom_tag.dart';
import 'package:otizm_destek_app/core/util/date_key.dart';
import 'package:otizm_destek_app/features/behavior/data/abc_repository.dart';
import 'package:otizm_destek_app/features/behavior/domain/abc_entry.dart';
import 'package:otizm_destek_app/features/behavior/presentation/behavior_screen.dart';
import 'package:otizm_destek_app/features/calendar/data/calendar_repository.dart';
import 'package:otizm_destek_app/features/calendar/domain/calendar_event.dart';
import 'package:otizm_destek_app/features/calendar/presentation/calendar_screen.dart';
import 'package:otizm_destek_app/features/children/presentation/children_screen.dart';
import 'package:otizm_destek_app/features/goals/data/goal_repository.dart';
import 'package:otizm_destek_app/features/goals/domain/goal.dart';
import 'package:otizm_destek_app/features/medications/data/medication_repository.dart';
import 'package:otizm_destek_app/features/medications/domain/medication.dart';
import 'package:otizm_destek_app/features/mood/data/mood_repository.dart';
import 'package:otizm_destek_app/features/mood/domain/mood_entry.dart';
import 'package:otizm_destek_app/features/mood/presentation/daily_tracker_screen.dart';
import 'package:otizm_destek_app/features/notes/data/note_repository.dart';
import 'package:otizm_destek_app/features/notes/domain/development_note.dart';
import 'package:otizm_destek_app/features/notes/presentation/notes_screen.dart';
import 'package:otizm_destek_app/features/progress/presentation/progress_tab.dart';
import 'package:otizm_destek_app/features/sleep/data/sleep_repository.dart';
import 'package:otizm_destek_app/features/sleep/domain/sleep_entry.dart';
import 'package:otizm_destek_app/features/tasks/data/tasks_repository.dart';
import 'package:otizm_destek_app/features/tasks/domain/expert_task.dart';
import 'package:otizm_destek_app/features/tasks/presentation/tasks_screen.dart';
import 'package:otizm_destek_app/features/forum/data/forum_repository.dart';
import 'package:otizm_destek_app/features/forum/domain/forum_post.dart';
import 'package:otizm_destek_app/features/forum/presentation/forum_screen.dart';
import 'package:otizm_destek_app/features/groups/data/group_repository.dart';
import 'package:otizm_destek_app/features/groups/domain/group.dart';
import 'package:otizm_destek_app/features/groups/presentation/groups_screen.dart';
import 'package:otizm_destek_app/features/notifications/data/notification_repository.dart';
import 'package:otizm_destek_app/features/notifications/domain/app_notification.dart';
import 'package:otizm_destek_app/features/notifications/presentation/notifications_screen.dart';
import 'package:otizm_destek_app/features/settings/data/kvkk_repository.dart';
import 'package:otizm_destek_app/features/settings/domain/kvkk.dart';
import 'package:otizm_destek_app/features/support_wall/data/wall_repository.dart';
import 'package:otizm_destek_app/features/support_wall/domain/wall_post.dart';
import 'package:otizm_destek_app/features/support_wall/presentation/support_wall_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

// ---------------------------------------------------------------------------
// Sahte depolar
// ---------------------------------------------------------------------------

class _FakeSecureStorage extends SecureStorage {
  final _values = <String, String>{};

  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<String?> readPreference(String key) async => _values[key];

  @override
  Future<void> savePreference(String key, String value) async {
    _values[key] = value;
  }
}

final _parent = const AppUser(
  id: 'u1',
  email: 'veli@example.com',
  fullName: 'Elif Yılmaz',
  role: UserRole.parent,
);

class _FakeAuth extends AuthController {
  @override
  AuthState build() =>
      AuthState(status: AuthStatus.authenticated, user: _parent);
}

class _FakeChildRepository extends ChildRepository {
  _FakeChildRepository() : super(Dio());

  @override
  Future<List<Child>> getChildren() async => [
        Child(
          id: 'c1',
          name: 'Ada Yılmaz',
          birthDate: DateTime(2019, 4, 12),
          diagnosisInfo: 'Otizm Spektrum Bozukluğu',
        ),
        Child(
          id: 'c2',
          name: 'Deniz Yılmaz',
          birthDate: DateTime(2021, 9, 3),
        ),
      ];
}

class _FakeAppointmentRepository extends AppointmentRepository {
  _FakeAppointmentRepository() : super(Dio());

  @override
  Future<List<Appointment>> getAppointments() async {
    final now = DateTime.now();
    return [
      Appointment(
        id: 'a1',
        date: now.add(const Duration(days: 1)),
        time: '14:30',
        status: 'CONFIRMED',
        expertId: 'e1',
        expertName: 'Uzm. Psk. Selin Aksoy',
        expertTitle: 'Klinik Psikolog',
        childName: 'Ada',
        type: 'ONLINE',
        duration: 50,
        appointmentTopic: 'Dil gelişimi değerlendirmesi',
        notes: 'Ada son iki haftadır iki kelimelik cümleler kuruyor.',
        meetingLink: 'https://meet.example.com/ada-selin',
      ),
      Appointment(
        id: 'a2',
        date: now.add(const Duration(days: 6)),
        time: '11:00',
        status: 'PENDING',
        expertId: 'e2',
        expertName: 'Dr. Mert Kaya',
        expertTitle: 'Çocuk Nöroloji',
        childName: 'Ada',
        type: 'FACE_TO_FACE',
        duration: 40,
      ),
      Appointment(
        id: 'a3',
        date: now.subtract(const Duration(days: 9)),
        time: '16:00',
        status: 'COMPLETED',
        expertId: 'e1',
        expertName: 'Uzm. Psk. Selin Aksoy',
        childName: 'Ada',
        type: 'ONLINE',
        duration: 50,
        sessionSummary: 'Ortak dikkat çalışmaları tekrar edildi.',
        rating: 5,
      ),
    ];
  }

  @override
  Future<List<AppointmentHistoryEntry>> getHistory(String id) async => [
        AppointmentHistoryEntry(
          newStatus: 'PENDING',
          changedByName: 'Elif Yılmaz',
          changedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        AppointmentHistoryEntry(
          oldStatus: 'PENDING',
          newStatus: 'CONFIRMED',
          changedByName: 'Uzm. Psk. Selin Aksoy',
          note: 'Görüşme bağlantısı eklendi.',
          changedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

  @override
  Future<({String date, String time})?> getNextAvailable(
    String expertId, {
    int? duration,
  }) async =>
      (date: '2026-08-24', time: '10:30');
}

class _FakeKnowledgeRepository extends KnowledgeRepository {
  _FakeKnowledgeRepository() : super(Dio());

  static final _tags = [
    const SymptomTag(id: 't1', name: 'Uyku düzeni', category: 'DAVRANIS'),
    const SymptomTag(id: 't2', name: 'Ortak dikkat', category: 'SOSYAL'),
  ];

  static final _articles = [
    Article(
      id: 'k1',
      title: 'Uyku rutinini kurmanın beş adımı',
      category: 'Sağlık',
      summary:
          'Akşam rutinini sabitlemek, uyku öncesi uyaranları azaltmak ve '
          'görsel program kullanmak uykuya geçişi kolaylaştırıyor.',
      format: 'TEXT',
      tags: _tags,
      createdAt: DateTime(2026, 7, 18),
    ),
    Article(
      id: 'k2',
      title: 'Ortak dikkat için günlük oyun önerileri',
      category: 'Eğitim',
      summary:
          'Beş dakikalık kısa oyunlarla göz teması ve sıra alma becerisini '
          'destekleyen etkinlikler.',
      format: 'VIDEO',
      tags: [_tags[1]],
      bookmarked: true,
      createdAt: DateTime(2026, 7, 2),
    ),
    Article(
      id: 'k3',
      title: 'Duyusal aşırı yüklenmede sakinleşme alanı',
      category: 'Duyusal Gelişim',
      summary:
          'Evde hazırlanabilecek sakinleşme köşesi ve kriz anında işe '
          'yarayan basit düzenlemeler.',
      format: 'TEXT',
      createdAt: DateTime(2026, 6, 21),
    ),
  ];

  @override
  Future<ArticlePage> search(
    ArticleQuery query, {
    int page = 0,
    int size = 12,
  }) async =>
      (items: _articles, hasMore: false);

  @override
  Future<List<Article>> getRecommendations() async => _articles.take(2).toList();
}

class _FakeTagRepository extends TagRepository {
  _FakeTagRepository() : super(Dio());

  @override
  Future<Map<String, List<SymptomTag>>> getGrouped() async => {
        'DAVRANIS': [
          const SymptomTag(id: 't1', name: 'Uyku düzeni', category: 'DAVRANIS'),
          const SymptomTag(id: 't3', name: 'Öfke nöbeti', category: 'DAVRANIS'),
        ],
        'SOSYAL': [
          const SymptomTag(id: 't2', name: 'Ortak dikkat', category: 'SOSYAL'),
        ],
        'ILETISIM': [
          const SymptomTag(id: 't4', name: 'Sözel olmayan', category: 'ILETISIM'),
        ],
      };
}

class _FakeExpertRepository extends ExpertRepository {
  _FakeExpertRepository() : super(Dio());

  static const _selin = Expert(
    id: 'e1',
    fullName: 'Uzm. Psk. Selin Aksoy',
    expertTitle: 'Klinik Psikolog',
    city: 'İstanbul',
    institution: 'Mavi Gelişim Merkezi',
    specializations: ['ABA', 'Erken Müdahale'],
    avgRating: 4.8,
    reviewCount: 24,
    articleCount: 6,
    verified: true,
    licenseVerified: true,
    bio: 'On yıldır otizmli çocuklar ve aileleriyle çalışıyorum. '
        'Erken müdahale ve aile eğitimi üzerine uzmanlaştım.',
    ageGroups: ['3-6', '7-12'],
    supportTopics: ['Dil gelişimi', 'Sosyal beceri', 'Davranış yönetimi'],
    spokenLanguages: ['Türkçe', 'İngilizce'],
    sessionDurationMinutes: 50,
    cancellationPolicy: 'Randevudan 24 saat önce ücretsiz iptal.',
    sessionFeeMin: 900,
    sessionFeeMax: 1200,
  );

  @override
  Future<List<Expert>> getExperts({String? city, String? specialization}) async {
    return const [
      _selin,
      Expert(
        id: 'e2',
        fullName: 'Dr. Mert Kaya',
        expertTitle: 'Çocuk Nöroloji',
        city: 'Ankara',
        institution: 'Şehir Hastanesi',
        specializations: ['Tanı', 'İlaç Takibi'],
        avgRating: 4.5,
        reviewCount: 11,
        verified: true,
        offersOnline: false,
        sessionFeeMin: 1500,
      ),
      Expert(
        id: 'e3',
        fullName: 'Uzm. Ece Demir',
        expertTitle: 'Dil ve Konuşma Terapisti',
        city: 'İzmir',
        specializations: ['Dil Gelişimi', 'PECS'],
        verified: true,
        sessionDurationMinutes: 45,
      ),
    ];
  }

  @override
  Future<ExpertReviewSummary> getReviews(String expertId) async =>
      ExpertReviewSummary(
        averageRating: 4.8,
        totalCount: 2,
        reviews: [
          ExpertReview(
            id: 'r1',
            reviewerId: 'u9',
            reviewerName: 'Ayşe K.',
            rating: 5,
            comment: 'Ada ile ilk seanstan itibaren çok iyi iletişim kurdu.',
            createdAt: DateTime(2026, 7, 30),
          ),
          ExpertReview(
            id: 'r2',
            reviewerId: 'u8',
            reviewerName: 'Murat T.',
            rating: 4,
            comment: 'Ev programı çok işimize yaradı.',
            createdAt: DateTime(2026, 6, 12),
          ),
        ],
      );
}

/// Ağ bağlantısı kurmayan STOMP (ekran görüntüsünde canlı abonelik gerekmez).
class _FakeStompService extends StompService {
  _FakeStompService() : super(_FakeSecureStorage());

  @override
  Future<void Function()> subscribe(
    String destination,
    void Function(StompFrame) callback,
  ) async =>
      () {};

  @override
  void dispose() {}
}

class _FakeMessagingRepository extends MessagingRepository {
  _FakeMessagingRepository() : super(Dio());

  @override
  Future<List<Conversation>> getConversations() async => [
        Conversation(
          id: 'cv1',
          type: 'DIRECT',
          unreadCount: 2,
          participants: const [
            Participant(id: 'u1', fullName: 'Elif Yılmaz', role: 'PARENT'),
            Participant(
              id: 'e1',
              fullName: 'Uzm. Psk. Selin Aksoy',
              role: 'EXPERT',
            ),
          ],
          lastMessage: const Message(
            id: 'm9',
            conversationId: 'cv1',
            senderId: 'e1',
            content: 'Bu hafta ortak dikkat çalışmasını deneyelim.',
          ),
          lastMessageAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        Conversation(
          id: 'cv2',
          type: 'GROUP',
          title: 'Okul Öncesi Aileler',
          participants: const [
            Participant(id: 'u1', fullName: 'Elif Yılmaz', role: 'PARENT'),
          ],
          lastMessage: const Message(
            id: 'm8',
            conversationId: 'cv2',
            senderId: 'u5',
            content: 'Açım',
          ),
          muted: true,
          lastMessageAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];

  @override
  Future<List<Message>> getMessages(
    String conversationId, {
    int page = 0,
    int size = 30,
  }) async =>
      [
        const Message(
          id: 'm1',
          conversationId: 'cv1',
          senderId: 'e1',
          senderName: 'Uzm. Psk. Selin Aksoy',
          content: 'Merhaba Elif Hanım, Ada bu hafta nasıldı?',
        ),
        const Message(
          id: 'm2',
          conversationId: 'cv1',
          senderId: 'u1',
          content: 'Uyku düzeni oturdu, akşam rutinini uyguluyoruz.',
        ),
        const Message(
          id: 'm3',
          conversationId: 'cv1',
          senderId: 'u1',
          content: 'Mutluyum',
        ),
        const Message(
          id: 'm4',
          conversationId: 'cv1',
          senderId: 'e1',
          senderName: 'Uzm. Psk. Selin Aksoy',
          content: 'Harika! Kartlarla iletişimi sürdürelim.',
          reactions: {
            '👍': ReactionSummary(count: 1, reactedByMe: true),
            '🙏': ReactionSummary(count: 2, reactedByMe: false),
          },
        ),
        const Message(
          id: 'm5',
          conversationId: 'cv1',
          senderId: 'u1',
          content: 'Görsel programı da ekledim.',
          messageType: kMessageTypeFile,
          fileUrl: '/api/upload/gorsel-program.pdf',
          fileName: 'gorsel-program.pdf',
          fileType: 'application/pdf',
          replyToId: 'm4',
          replyToContent: 'Harika! Kartlarla iletişimi sürdürelim.',
          replyToSenderName: 'Uzm. Psk. Selin Aksoy',
        ),
      ];

  @override
  Future<void> markAsRead(String conversationId) async {}
}


class _FakeNoteRepository extends NoteRepository {
  _FakeNoteRepository() : super(Dio());

  static final _notes = [
    DevelopmentNote(
      id: 'n1',
      title: 'Sıra alma çalışması',
      content: 'Ada oyun sırasında iki kez sırasını bekledi.',
      category: 'Sosyal Beceri',
      mood: 'happy',
      noteDate: DateTime(2026, 8, 18),
    ),
    DevelopmentNote(
      id: 'n2',
      title: 'Markette zorlanma',
      content: 'Kalabalıkta kulaklık işe yaradı, kriz olmadı.',
      category: 'Davranış',
      mood: 'neutral',
      noteDate: DateTime(2026, 8, 15),
    ),
  ];

  @override
  Future<List<DevelopmentNote>> getRecentNotes(String childId) async => _notes;

  @override
  Future<NotesPage> getNotes(String childId, {int page = 0}) async =>
      NotesPage(notes: _notes, totalPages: 1);
}

class _FakeGoalRepository extends GoalRepository {
  _FakeGoalRepository() : super(Dio());

  @override
  Future<List<Goal>> getGoals(String childId) async => [
        Goal(
          id: 'g1',
          title: 'Günde 10 dakika ortak oyun',
          targetCount: 10,
          category: 'Sosyal Beceri',
          tokenEmoji: '⭐',
          rewardTitle: 'Parkta ekstra süre',
          entries: [
            for (var i = 0; i < 6; i++) {'date': '2026-08-1$i'},
          ],
        ),
        const Goal(
          id: 'g2',
          title: 'İki kelimelik istek cümlesi',
          targetCount: 20,
          category: 'Dil Gelişimi',
        ),
      ];
}

class _FakeMoodRepository extends MoodRepository {
  _FakeMoodRepository() : super(Dio());

  @override
  Future<List<MoodEntry>> getEntries(String childId) async => [
        MoodEntry(
          id: 'md1',
          childId: childId,
          entryDate: localDateKey(DateTime.now()),
          moodLevel: 4,
          notes: 'Sabah okulda iyiydi.',
          triggers: const ['Gürültü'],
        ),
      ];
}

class _FakeSleepRepository extends SleepRepository {
  _FakeSleepRepository() : super(Dio());

  @override
  Future<List<SleepEntry>> getEntries(String childId) async => [
        SleepEntry(
          id: 'sl1',
          childId: childId,
          sleepDate: localDateKey(DateTime.now()),
          bedtime: '21:15',
          wakeTime: '07:00',
          durationMinutes: 585,
          quality: 4,
          nightWakings: 1,
        ),
      ];
}

class _FakeMedicationRepository extends MedicationRepository {
  _FakeMedicationRepository() : super(Dio());

  @override
  Future<List<Medication>> getMedications(String childId) async => [
        Medication(
          id: 'md1',
          childId: childId,
          name: 'D vitamini',
          dosage: '3 damla',
          scheduledTimes: const ['09:00'],
          todayLogs: [
            MedicationLog(
              id: 'lg1',
              medicationId: 'md1',
              logDate: localDateKey(DateTime.now()),
              scheduledTime: '09:00',
              taken: true,
            ),
          ],
        ),
        Medication(
          id: 'md2',
          childId: childId,
          name: 'Omega-3',
          dosage: '1 kapsül',
          scheduledTimes: const ['20:00'],
        ),
      ];
}

class _FakeCalendarRepository extends CalendarRepository {
  _FakeCalendarRepository() : super(Dio());

  @override
  Future<List<CalendarEvent>> getByChild(String childId) async => [
        CalendarEvent(
          id: 'ev1',
          title: 'Dil terapisi',
          startTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
          eventType: 'TERAPI',
          location: 'Mavi Gelişim Merkezi',
          childId: childId,
        ),
        CalendarEvent(
          id: 'ev2',
          title: 'Okul veli toplantısı',
          startTime: DateTime.now().add(const Duration(days: 4)),
          eventType: 'EGITIM',
          childId: childId,
        ),
      ];
}

class _FakeAbcRepository extends AbcRepository {
  _FakeAbcRepository() : super(Dio());

  @override
  Future<List<AbcEntry>> getByChild(String childId) async => [
        AbcEntry(
          id: 'ab1',
          childId: childId,
          entryDate: localDateKey(DateTime.now()),
          entryTime: '17:30',
          antecedent: 'Markette kalabalık ve yüksek ses',
          behavior: 'Kulaklarını kapatıp yere oturdu',
          consequence: 'Sessiz köşeye geçtik, 5 dakikada sakinleşti',
          intensity: 3,
          category: 'Duyusal',
          location: 'Market',
        ),
      ];
}

class _FakeTasksRepository extends TasksRepository {
  _FakeTasksRepository() : super(Dio());

  @override
  Future<List<ExpertTask>> getMyTasks() async => [
        ExpertTask(
          id: 'tk1',
          title: 'Günde 3 kez isim çağırma çalışması',
          description: 'Ada başka bir şeyle ilgilenirken adını söyleyin.',
          category: 'Ortak dikkat',
          difficulty: 'EASY',
          frequency: 'Her gün',
          dueDate: DateTime.now().add(const Duration(days: 2)),
        ),
        const ExpertTask(
          id: 'tk2',
          title: 'Akşam rutin kartlarını birlikte dizin',
          description: 'Rutin kartlarını Ada ile sırayla yerleştirin.',
          category: 'Rutin',
          difficulty: 'MEDIUM',
          status: kTaskCompleted,
        ),
      ];

  @override
  Future<List<TaskSubmission>> getSubmissions(String taskId) async => const [];
}


class _FakeForumRepository extends ForumRepository {
  _FakeForumRepository() : super(Dio());

  @override
  Future<ForumPageResult> getPosts({
    String? type,
    List<String> tagIds = const [],
    String? query,
    String sort = 'new',
    int page = 0,
    int size = 20,
  }) async =>
      ForumPageResult(
        totalPages: 1,
        posts: [
          ForumPost(
            id: 'f1',
            title: 'Okula uyum sürecinde ne işe yaradı?',
            content:
                'İlk hafta yarım gün gittik, öğretmenle görsel program '
                'paylaştık. Üçüncü haftada tam güne geçtik.',
            postType: 'DENEYIM',
            likeCount: 12,
            commentCount: 5,
            authorName: 'Zeynep A.',
            createdAt: DateTime(2026, 8, 16),
            tags: const [
              SymptomTag(id: 't5', name: 'Okula uyum', category: 'EGITIM'),
            ],
          ),
          ForumPost(
            id: 'f2',
            title: 'Uyku öncesi rutini nasıl kısalttınız?',
            content: 'Bizde rutin 1 saati buluyor, önerisi olan var mı?',
            postType: 'QUESTION',
            likeCount: 3,
            commentCount: 8,
            answered: true,
            authorName: 'Emre K.',
            createdAt: DateTime(2026, 8, 14),
          ),
        ],
      );
}

class _FakeGroupRepository extends GroupRepository {
  _FakeGroupRepository() : super(Dio());

  static const _groups = [
    Group(
      id: 'gr1',
      name: 'Okul Öncesi Aileler',
      description: 'Anaokulu ve kreş sürecindeki aileler için destek grubu.',
      category: 'Yaş Grubu',
      memberCount: 128,
      expertCount: 3,
      isMember: true,
      conversationId: 'cv2',
    ),
    Group(
      id: 'gr2',
      name: 'Duyusal Destek',
      description: 'Duyusal profil ve regülasyon deneyimleri.',
      category: 'Konu',
      memberCount: 64,
      expertCount: 1,
    ),
  ];

  @override
  Future<List<Group>> getMyGroups() async =>
      _groups.where((g) => g.isMember).toList();

  @override
  Future<List<Group>> search(String query) async => _groups;

  @override
  Future<List<Group>> getByCategory(String category) async => _groups;
}

class _FakeWallRepository extends WallRepository {
  _FakeWallRepository() : super(Dio());

  @override
  Future<List<WallPost>> getPosts({int page = 0}) async => [
        WallPost(
          id: 'w1',
          title: 'Bugün zor bir gündü',
          content:
              'Markette kriz yaşadık, çevrenin bakışları çok yordu. '
              'Yalnız olmadığımı bilmek iyi geliyor.',
          likeCount: 24,
          commentCount: 6,
          createdAt: DateTime(2026, 8, 18),
        ),
        WallPost(
          id: 'w2',
          title: 'Küçük bir zafer',
          content: 'Ada ilk kez "su ver" dedi. Bir saat ağladım.',
          likeCount: 57,
          commentCount: 12,
          anonymous: false,
          authorName: 'Elif Y.',
          createdAt: DateTime(2026, 8, 12),
        ),
      ];
}

class _FakeNotificationRepository extends NotificationRepository {
  _FakeNotificationRepository() : super(Dio());

  @override
  Future<int> getUnreadCount() async => 2;

  @override
  Future<({List<AppNotification> items, bool hasMore})> getPage(
    int page, {
    int size = 20,
  }) async =>
      (
        hasMore: false,
        items: [
          AppNotification(
            id: 'nt1',
            title: 'Randevunuz onaylandı',
            body: 'Uzm. Psk. Selin Aksoy yarın 14:30 randevusunu onayladı.',
            type: 'APPOINTMENT_CONFIRMED',
            link: '/randevular',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          AppNotification(
            id: 'nt2',
            title: 'Yeni mesaj',
            body: 'Uzm. Psk. Selin Aksoy: Bu hafta ortak dikkat çalışalım.',
            type: 'MESSAGE',
            link: '/mesajlar',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          AppNotification(
            id: 'nt3',
            title: 'Görev teslimi değerlendirildi',
            body: 'Uzmanınız "isim çağırma" görevine geri bildirim yazdı.',
            type: 'TASK_REVIEWED',
            read: true,
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ],
      );
}


class _FakeAnalyticsRepository extends AnalyticsRepository {
  _FakeAnalyticsRepository() : super(Dio());

  static List<TrendPoint> _series(List<double> values) => [
        for (var i = 0; i < values.length; i++)
          TrendPoint(month: '2026-0${i + 3}', value: values[i]),
      ];

  @override
  Future<AnalyticsTrends> getTrends(String childId, {int months = 6}) async =>
      AnalyticsTrends(
        milestones: _series([1, 0, 2, 1, 3, 2]),
        moods: _series([3.2, 3.6, 3.4, 4.0, 4.2, 4.1]),
        sleeps: _series([520, 545, 530, 560, 575, 585]),
        behaviors: _series([6, 5, 7, 4, 3, 2]),
      );
}

class _FakeKvkkRepository extends KvkkRepository {
  _FakeKvkkRepository() : super(Dio());

  @override
  Future<ConsentOverview> getConsents() async => ConsentOverview(
        current: const {'AI_ANALIZ': true},
        policyVersion: '2026-01',
        acceptedPolicyVersion: '2026-01',
      );
}

// ---------------------------------------------------------------------------
// Yardımcılar
// ---------------------------------------------------------------------------

/// Metin ve ikonların kutu yerine gerçek glif olarak çizilmesi için SDK
/// içindeki fontları yükler (tema 'Inter' istiyor, cihazda sistem fontuna
/// düşüyor; burada Roboto ile temsil edilir).
const _emojiFamily = 'Noto Color Emoji';

Future<void> _loadFonts() async {
  const root = '/home/burak/flutter/bin/cache/artifacts/material_fonts';
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      final path = file.startsWith('/') ? file : '$root/$file';
      final bytes = await File(path).readAsBytes();
      loader.addFont(
        Future.value(ByteData.view(Uint8List.fromList(bytes).buffer)),
      );
    }
    await loader.load();
  }

  await load('Inter', ['Roboto-Regular.ttf', 'Roboto-Medium.ttf']);
  await load('Roboto', ['Roboto-Regular.ttf', 'Roboto-Medium.ttf']);
  await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
  // Not: uygulamadaki bazı `TextStyle`lar aile belirtmiyor (ör. bazı çip
  // etiketleri). Cihazda sistem fontuna düşerler; başsız render'da ise motor
  // varsayılan test fontunu kullandığı için kutu çizilirler. Aile adıyla font
  // yüklemek bunu değiştirmiyor — görüntülerde beklenen bir kusurdur.

  // Emoji: cihazda sistem fontundan gelir. Kendi ailesine yüklenip yalnızca
  // yedek (fallback) olarak verilir; aynı aileye eklenirse metin fontunun
  // yerine geçip bütün etiketleri kutuya çeviriyor.
  const emojiPath = '/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf';
  if (File(emojiPath).existsSync()) {
    await load(_emojiFamily, [emojiPath]);
  }
}

// `Override` tipi flutter_riverpod'un dar export listesinde olmadığı için
// listeler dynamic taşınıp ProviderScope'a `cast()` ile veriliyor.
Widget _app(Widget home, {List<dynamic> overrides = const []}) {
  return TranslationProvider(
    child: ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
        authControllerProvider.overrideWith(_FakeAuth.new),
        childRepositoryProvider.overrideWithValue(_FakeChildRepository()),
        appointmentRepositoryProvider
            .overrideWithValue(_FakeAppointmentRepository()),
        knowledgeRepositoryProvider
            .overrideWithValue(_FakeKnowledgeRepository()),
        tagRepositoryProvider.overrideWithValue(_FakeTagRepository()),
        expertRepositoryProvider.overrideWithValue(_FakeExpertRepository()),
        messagingRepositoryProvider
            .overrideWithValue(_FakeMessagingRepository()),
        stompServiceProvider.overrideWithValue(_FakeStompService()),
        noteRepositoryProvider.overrideWithValue(_FakeNoteRepository()),
        goalRepositoryProvider.overrideWithValue(_FakeGoalRepository()),
        moodRepositoryProvider.overrideWithValue(_FakeMoodRepository()),
        sleepRepositoryProvider.overrideWithValue(_FakeSleepRepository()),
        medicationRepositoryProvider
            .overrideWithValue(_FakeMedicationRepository()),
        calendarRepositoryProvider.overrideWithValue(_FakeCalendarRepository()),
        abcRepositoryProvider.overrideWithValue(_FakeAbcRepository()),
        tasksRepositoryProvider.overrideWithValue(_FakeTasksRepository()),
        forumRepositoryProvider.overrideWithValue(_FakeForumRepository()),
        groupRepositoryProvider.overrideWithValue(_FakeGroupRepository()),
        wallRepositoryProvider.overrideWithValue(_FakeWallRepository()),
        notificationRepositoryProvider
            .overrideWithValue(_FakeNotificationRepository()),
        analyticsRepositoryProvider
            .overrideWithValue(_FakeAnalyticsRepository()),
        kvkkRepositoryProvider.overrideWithValue(_FakeKvkkRepository()),
        connectionRequestsProvider.overrideWith((ref) async => const []),
        ...overrides.cast(),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Emoji fontu yalnızca yedek olarak eklenir (cihazda sistem fontu
        // aynı işi yapıyor).
        theme: AppTheme.light.copyWith(
          textTheme: AppTheme.light.textTheme.apply(
            fontFamilyFallback: const [_emojiFamily],
          ),
        ),
        home: home,
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    LocaleSettings.setLocaleSync(AppLocale.tr);
    await _loadFonts();
  });

  Future<void> shoot(
    WidgetTester tester,
    String name,
    Widget home, {
    List<dynamic> overrides = const [],
    Future<void> Function(WidgetTester tester)? after,
  }) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(780, 1688); // ~390x844 mantıksal
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(home, overrides: overrides));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    if (after != null) await after(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../build/screens/$name.png'),
    );
  }

  testWidgets('01 ana sayfa', (tester) async {
    await shoot(
      tester,
      '01-ana-sayfa',
      const Scaffold(body: HomeTab()),
      overrides: [
        dailyPlanInputProvider.overrideWith((ref) async => DailyPlanInput(
              now: DateTime.now(),
              hasChild: true,
              childName: 'Ada',
              pendingMedicationSlots: 1,
              unreadMessages: 2,
              recentNotes: 3,
              nextEventTitle: 'Terapi seansı',
              nextEventStart: DateTime.now().add(const Duration(hours: 5)),
            )),
      ],
    );
  });

  testWidgets('02 ana sayfa kaydırılmış', (tester) async {
    await shoot(
      tester,
      '02-ana-sayfa-plan',
      const Scaffold(body: HomeTab()),
      overrides: [
        dailyPlanInputProvider.overrideWith((ref) async => DailyPlanInput(
              now: DateTime.now(),
              hasChild: true,
              childName: 'Ada',
              hasMoodToday: true,
              recentNotes: 2,
              visitedCommunity: true,
              hasEmergencyCard: true,
            )),
      ],
      after: (tester) async {
        await tester.drag(find.byType(ListView).first, const Offset(0, -420));
        await tester.pump();
      },
    );
  });

  testWidgets('03 uzmanlar', (tester) async {
    await shoot(tester, '03-uzmanlar', const Scaffold(body: SpecialistsTab()));
  });

  testWidgets('04 uzman profili', (tester) async {
    await shoot(
      tester,
      '04-uzman-profili',
      const ExpertDetailScreen(expert: _FakeExpertRepository._selin),
    );
  });

  testWidgets('05 randevular', (tester) async {
    await shoot(tester, '05-randevular', const AppointmentsScreen());
  });

  testWidgets('06 randevu detayı', (tester) async {
    final appt = (await _FakeAppointmentRepository().getAppointments()).first;
    await shoot(
      tester,
      '06-randevu-detayi',
      Scaffold(body: AppointmentDetailSheet(appointment: appt)),
    );
  });

  testWidgets('07 bilgi bankası', (tester) async {
    await shoot(tester, '07-bilgi-bankasi', const KnowledgeScreen());
  });

  testWidgets('08 mesajlar', (tester) async {
    await shoot(tester, '08-mesajlar', const ConversationsScreen());
  });

  testWidgets('09 sohbet ve PECS', (tester) async {
    await shoot(
      tester,
      '09-sohbet-pecs',
      const ConversationThreadScreen(
        conversationId: 'cv1',
        title: 'Uzm. Psk. Selin Aksoy',
      ),
      after: (tester) async {
        await tester.tap(find.text('🧸'));
        await tester.pump();
      },
    );
  });

  testWidgets('09b sohbet tepki ve yanıt', (tester) async {
    await shoot(
      tester,
      '09b-sohbet-tepki-yanit',
      const ConversationThreadScreen(
        conversationId: 'cv1',
        title: 'Uzm. Psk. Selin Aksoy',
      ),
    );
  });

  testWidgets('13 çocuklarım', (tester) async {
    await shoot(tester, '13-cocuklarim', const ChildrenScreen());
  });

  testWidgets('14 notlarım', (tester) async {
    await shoot(tester, '14-notlarim', const NotesScreen());
  });

  testWidgets('15 günlük takip', (tester) async {
    await shoot(tester, '15-gunluk-takip', const DailyTrackerScreen());
  });

  testWidgets('16 ödevlerim', (tester) async {
    await shoot(tester, '16-odevlerim', const TasksScreen());
  });

  testWidgets('17 takvim', (tester) async {
    await shoot(tester, '17-takvim', const CalendarScreen());
  });

  testWidgets('18 davranış günlüğü', (tester) async {
    await shoot(tester, '18-davranis-gunlugu', const BehaviorScreen());
  });

  testWidgets('19 gelişim', (tester) async {
    await shoot(tester, '19-gelisim', const Scaffold(body: ProgressTab()));
  });

  testWidgets('24 gelişim paneli', (tester) async {
    await shoot(tester, '24-gelisim-paneli', const AnalyticsScreen());
  });

  testWidgets('20 forum', (tester) async {
    await shoot(tester, '20-forum', const ForumScreen());
  });

  testWidgets('21 destek grupları', (tester) async {
    await shoot(tester, '21-gruplar', const GroupsScreen());
  });

  testWidgets('22 dertleşme duvarı', (tester) async {
    await shoot(tester, '22-dertlesme-duvari', const SupportWallScreen());
  });

  testWidgets('23 bildirimler', (tester) async {
    await shoot(tester, '23-bildirimler', const NotificationsScreen());
  });

  testWidgets('10 kriz rehberi', (tester) async {
    await shoot(tester, '10-kriz-rehberi', const CrisisScreen());
  });

  testWidgets('11 kullanıcı rehberi', (tester) async {
    await shoot(tester, '11-kullanici-rehberi', const GuideScreen());
  });

  testWidgets('12 topluluk', (tester) async {
    await shoot(tester, '12-topluluk', const CommunityScreen());
  });
}
