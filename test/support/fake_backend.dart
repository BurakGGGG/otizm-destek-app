// Ekran testleri ve ekran görüntüsü üreteci için ortak sahte backend.
//
// Buradaki depolar ağa çıkmaz; ekranlar gerçek widget ağacıyla, gerçek
// sağlayıcılarla ama sabit veriyle kurulur. `test/screens_build_test.dart`
// bunları çizip hata olmadığını doğrular, `tool/screenshots_test.dart` ise
// aynı listeden PNG üretir.

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/providers.dart';
import 'package:otizm_destek_app/core/realtime/stomp_service.dart';
import 'package:otizm_destek_app/core/storage/secure_storage.dart';
import 'package:otizm_destek_app/core/theme/app_colors.dart';
import 'package:otizm_destek_app/core/theme/app_theme.dart';
import 'package:otizm_destek_app/features/analytics/data/analytics_repository.dart';
import 'package:otizm_destek_app/features/analytics/domain/analytics_trends.dart';
import 'package:otizm_destek_app/features/analytics/presentation/analytics_screen.dart';
import 'package:otizm_destek_app/features/appointments/data/appointment_repository.dart';
import 'package:otizm_destek_app/features/appointments/domain/appointment.dart';
import 'package:otizm_destek_app/features/appointments/presentation/appointment_booking_screen.dart';
import 'package:otizm_destek_app/features/appointments/presentation/appointments_screen.dart';
import 'package:otizm_destek_app/features/appointments/presentation/widgets/appointment_detail_sheet.dart';
import 'package:otizm_destek_app/features/auth/domain/app_user.dart';
import 'package:otizm_destek_app/features/auth/presentation/forgot_password_screen.dart';
import 'package:otizm_destek_app/features/auth/presentation/login_screen.dart';
import 'package:otizm_destek_app/features/auth/presentation/register_screen.dart';
import 'package:otizm_destek_app/features/auth/presentation/verify_email_screen.dart';
import 'package:otizm_destek_app/features/auth/presentation/auth_controller.dart';
import 'package:otizm_destek_app/features/children/data/child_repository.dart';
import 'package:otizm_destek_app/features/children/data/connection_repository.dart';
import 'package:otizm_destek_app/features/children/domain/expert_connection.dart';
import 'package:otizm_destek_app/features/children/presentation/child_detail_screen.dart';
import 'package:otizm_destek_app/features/children/presentation/child_form_screen.dart';
import 'package:otizm_destek_app/features/children/presentation/expert_access_screen.dart';
import 'package:otizm_destek_app/features/children/data/milestone_repository.dart';
import 'package:otizm_destek_app/features/children/data/screening_repository.dart';
import 'package:otizm_destek_app/features/children/domain/screening_result.dart';
import 'package:otizm_destek_app/features/children/domain/milestone.dart';
import 'package:otizm_destek_app/features/children/domain/child.dart';
import 'package:otizm_destek_app/features/community/presentation/community_screen.dart';
import 'package:otizm_destek_app/features/crisis/presentation/crisis_screen.dart';
import 'package:otizm_destek_app/features/guide/presentation/guide_screen.dart';
import 'package:otizm_destek_app/features/home/data/daily_plan_provider.dart';
import 'package:otizm_destek_app/features/home/domain/daily_plan.dart';
import 'package:otizm_destek_app/features/home/presentation/home_tab.dart';
import 'package:otizm_destek_app/features/knowledge/data/knowledge_repository.dart';
import 'package:otizm_destek_app/features/knowledge/domain/article.dart';
import 'package:otizm_destek_app/features/knowledge/domain/article_comment.dart';
import 'package:otizm_destek_app/features/knowledge/presentation/article_detail_screen.dart';
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
import 'package:otizm_destek_app/features/goals/presentation/goal_form_screen.dart';
import 'package:otizm_destek_app/features/goals/domain/goal.dart';
import 'package:otizm_destek_app/features/medications/data/medication_repository.dart';
import 'package:otizm_destek_app/features/medications/domain/medication.dart';
import 'package:otizm_destek_app/features/mood/data/mood_repository.dart';
import 'package:otizm_destek_app/features/mood/domain/mood_entry.dart';
import 'package:otizm_destek_app/features/mood/presentation/daily_tracker_screen.dart';
import 'package:otizm_destek_app/features/notes/data/note_repository.dart';
import 'package:otizm_destek_app/features/notes/domain/development_note.dart';
import 'package:otizm_destek_app/features/notes/presentation/note_form_screen.dart';
import 'package:otizm_destek_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:otizm_destek_app/features/notes/presentation/notes_screen.dart';
import 'package:otizm_destek_app/features/progress/presentation/progress_tab.dart';
import 'package:otizm_destek_app/features/sleep/data/sleep_repository.dart';
import 'package:otizm_destek_app/features/sleep/domain/sleep_entry.dart';
import 'package:otizm_destek_app/features/tasks/data/tasks_repository.dart';
import 'package:otizm_destek_app/features/tasks/domain/expert_task.dart';
import 'package:otizm_destek_app/features/tasks/presentation/tasks_screen.dart';
import 'package:otizm_destek_app/features/forum/data/forum_repository.dart';
import 'package:otizm_destek_app/features/forum/domain/forum_post.dart';
import 'package:otizm_destek_app/features/forum/presentation/forum_post_detail_screen.dart';
import 'package:otizm_destek_app/features/forum/presentation/forum_screen.dart';
import 'package:otizm_destek_app/features/auth/presentation/reset_password_screen.dart';
import 'package:otizm_destek_app/features/legal/domain/legal_documents.dart';
import 'package:otizm_destek_app/features/legal/presentation/legal_screen.dart';
import 'package:otizm_destek_app/features/groups/data/group_repository.dart';
import 'package:otizm_destek_app/features/groups/domain/group.dart';
import 'package:otizm_destek_app/features/groups/presentation/group_detail_screen.dart';
import 'package:otizm_destek_app/features/groups/presentation/groups_screen.dart';
import 'package:otizm_destek_app/features/notifications/data/notification_repository.dart';
import 'package:otizm_destek_app/features/notifications/domain/app_notification.dart';
import 'package:otizm_destek_app/features/notifications/presentation/notifications_screen.dart';
import 'package:otizm_destek_app/features/search/data/search_repository.dart';
import 'package:otizm_destek_app/features/search/domain/search_result.dart';
import 'package:otizm_destek_app/features/search/presentation/search_screen.dart';
import 'package:otizm_destek_app/features/community/data/community_repository.dart';
import 'package:otizm_destek_app/features/community/domain/community_meetup.dart';
import 'package:otizm_destek_app/features/community/domain/weekly_question.dart';
import 'package:otizm_destek_app/features/chatbot/presentation/chat_screen.dart';
import 'package:otizm_destek_app/features/community/presentation/meetups_screen.dart';
import 'package:otizm_destek_app/features/community/presentation/weekly_question_detail_screen.dart';
import 'package:otizm_destek_app/features/community/presentation/weekly_question_screen.dart';
import 'package:otizm_destek_app/features/emergency/data/emergency_repository.dart';
import 'package:otizm_destek_app/features/emergency/domain/emergency_card.dart';
import 'package:otizm_destek_app/features/emergency/presentation/emergency_screen.dart';
import 'package:otizm_destek_app/features/settings/data/kvkk_repository.dart';
import 'package:otizm_destek_app/features/settings/presentation/blocked_users_screen.dart';
import 'package:otizm_destek_app/features/settings/presentation/settings_screen.dart';
import 'package:otizm_destek_app/features/treatment/data/treatment_repository.dart';
import 'package:otizm_destek_app/features/treatment/domain/treatment_state.dart';
import 'package:otizm_destek_app/features/treatment/presentation/treatment_screen.dart';
import 'package:otizm_destek_app/features/profile/data/block_repository.dart';
import 'package:otizm_destek_app/features/similar_families/data/buddy_repository.dart';
import 'package:otizm_destek_app/features/similar_families/data/matching_repository.dart';
import 'package:otizm_destek_app/features/similar_families/domain/buddy.dart';
import 'package:otizm_destek_app/features/similar_families/data/meetup_request_repository.dart';
import 'package:otizm_destek_app/features/similar_families/domain/meetup_request.dart';
import 'package:otizm_destek_app/features/similar_families/domain/similar_family.dart';
import 'package:otizm_destek_app/features/similar_families/presentation/similar_families_screen.dart';
import 'package:otizm_destek_app/features/settings/domain/kvkk.dart';
import 'package:otizm_destek_app/features/profile/presentation/account_screen.dart';
import 'package:otizm_destek_app/features/profile/presentation/help_screen.dart';
import 'package:otizm_destek_app/features/routines/data/routine_repository.dart';
import 'package:otizm_destek_app/features/routines/domain/routine.dart';
import 'package:otizm_destek_app/features/routines/presentation/routine_form_screen.dart';
import 'package:otizm_destek_app/features/routines/presentation/routines_screen.dart';
import 'package:otizm_destek_app/features/settings/presentation/kvkk_screen.dart';
import 'package:otizm_destek_app/features/support_wall/data/wall_repository.dart';
import 'package:otizm_destek_app/features/support_wall/domain/wall_post.dart';
import 'package:otizm_destek_app/features/support_wall/presentation/support_wall_detail_screen.dart';
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
  city: 'İstanbul',
  supportIntents: ['DENEYIM_PAYLASIMI'],
  communicationPreferences: ['YAZISMA'],
);

class _FakeAuth extends AuthController {
  @override
  AuthState build() =>
      AuthState(status: AuthStatus.authenticated, user: _parent);
}

class _FakeChildRepository extends ChildRepository {
  _FakeChildRepository() : super(Dio());

  @override
  Future<Child> getChild(String id) async {
    final children = await getChildren();
    return children.firstWhere(
      (child) => child.id == id,
      orElse: () => children.first,
    );
  }

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
        recurringGroupId: 'rg1',
        recurrenceIndex: 2,
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
      Appointment(
        id: 'a4',
        date: now.subtract(const Duration(days: 2)),
        time: '10:00',
        status: 'COMPLETED',
        expertId: 'e2',
        expertName: 'Dr. Mert Kaya',
        childName: 'Ada',
        type: 'FACE_TO_FACE',
        duration: 40,
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
  Future<Article> getArticle(String id) async => Article(
        id: id,
        title: 'Uyku rutinini kurmanın beş adımı',
        category: 'Sağlık',
        format: 'TEXT',
        authorName: 'Uzm. Psk. Selin Aksoy',
        viewCount: 412,
        createdAt: DateTime(2026, 7, 18),
        tags: _tags,
        content: 'Akşam rutinini her gün aynı saatte başlatmak, uykuya '
            'geçişi kolaylaştırıyor. Işıkları kısın, ekranları rutinden '
            'en az bir saat önce kapatın ve sıralamayı görsel kartlarla '
            'gösterin. İlk hafta küçük gerilemeler olabilir; rutini '
            'değiştirmeden sürdürmek en etkili yol.',
      );

  @override
  Future<List<Article>> getRelated(String id) async =>
      _articles.where((a) => a.id != id).take(2).toList();

  @override
  Future<List<ArticleComment>> getComments(
    String articleId, {
    int page = 0,
    int size = 20,
  }) async =>
      [
        ArticleComment(
          id: 'ac1',
          content: 'Görsel kart fikrini denedik, üçüncü günde oturdu.',
          authorName: 'Zeynep A.',
          createdAt: DateTime(2026, 8, 2),
        ),
        ArticleComment(
          id: 'ac2',
          content: 'Ekran süresini erken kesmek bizde de işe yaradı.',
          authorName: 'Uzm. Ece Demir',
          authorRole: 'EXPERT',
          createdAt: DateTime(2026, 8, 5),
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
  Future<Conversation?> findConversation(String id) async => const Conversation(
        id: 'cv2',
        type: 'GROUP',
        title: 'Okul Öncesi Aileler',
        participants: [
          Participant(id: 'u1', fullName: 'Elif Yılmaz', role: 'PARENT'),
          Participant(
            id: 'u5',
            fullName: 'Uzm. Psk. Selin Aksoy',
            role: 'EXPERT',
          ),
        ],
      );

  @override
  Future<Conversation> updateGroupTitle(String id, String title) async =>
      Conversation(id: id, type: 'GROUP', title: title);

  @override
  Future<Conversation> addMember(String id, String userId) async =>
      Conversation(id: id, type: 'GROUP');

  @override
  Future<Conversation> removeMember(String id, String userId) async =>
      Conversation(id: id, type: 'GROUP');

  @override
  Future<Conversation> createGroup(
    String title,
    List<String> participantIds,
  ) async =>
      Conversation(id: 'cvNew', type: 'GROUP', title: title);

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
        for (var i = 0; i < 10; i++)
          MoodEntry(
            id: 'md$i',
            childId: childId,
            entryDate: localDateKey(
              DateTime.now().subtract(Duration(days: i)),
            ),
            moodLevel: [4, 3, 5, 4, 4, 2, 3, 5, 4, 3][i],
            notes: i == 0 ? 'Sabah okulda iyiydi.' : null,
            triggers: i == 0 ? const ['Gürültü'] : const [],
          ),
      ];
}

class _FakeSleepRepository extends SleepRepository {
  _FakeSleepRepository() : super(Dio());

  @override
  Future<List<SleepEntry>> getEntries(String childId) async => [
        for (var i = 0; i < 10; i++)
          SleepEntry(
            id: 'sl$i',
            childId: childId,
            sleepDate: localDateKey(
              DateTime.now().subtract(Duration(days: i)),
            ),
            bedtime: '21:15',
            wakeTime: '07:00',
            durationMinutes: [585, 540, 600, 510, 570, 480, 555, 600, 525, 540][i],
            quality: [4, 3, 5, 3, 4, 2, 4, 5, 3, 4][i],
            nightWakings: i.isEven ? 1 : 0,
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

  @override
  Future<List<MedicationLog>> getChildLogs(String childId) async {
    final today = DateTime.now();
    String key(int daysAgo) =>
        localDateKey(today.subtract(Duration(days: daysAgo)));
    return [
      MedicationLog(
        id: 'lg1',
        medicationId: 'md1',
        logDate: key(0),
        scheduledTime: '09:00',
        taken: true,
      ),
      MedicationLog(
        id: 'lg2',
        medicationId: 'md2',
        logDate: key(0),
        scheduledTime: '20:00',
        taken: false,
        sideEffects: const ['Uykusuzluk'],
      ),
      MedicationLog(
        id: 'lg3',
        medicationId: 'md1',
        logDate: key(1),
        scheduledTime: '09:00',
        taken: true,
      ),
    ];
  }
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
  Future<ForumPost> getPost(String id) async => ForumPost(
        id: id,
        title: 'Okula uyum sürecinde ne işe yaradı?',
        content:
            'İlk hafta yarım gün gittik, öğretmenle görsel programı '
            'paylaştık. Üçüncü haftada tam güne geçtik; sabah ayrılma '
            'anını kısa tutmak en çok işe yarayan şey oldu.',
        postType: 'DENEYIM',
        likeCount: 12,
        commentCount: 2,
        authorName: 'Zeynep A.',
        createdAt: DateTime(2026, 8, 16),
      );

  @override
  Future<List<ForumComment>> getComments(String postId) async => [
        ForumComment(
          id: 'fc1',
          content: 'Görsel program bizde de ayrılma kaygısını azalttı.',
          authorName: 'Emre K.',
          likeCount: 4,
          createdAt: DateTime(2026, 8, 17),
        ),
        ForumComment(
          id: 'fc2',
          content: 'Öğretmenle ortak dil kurmak çok önemli. '
              'Haftalık kısa bir not defteri öneririm.',
          authorName: 'Uzm. Psk. Selin Aksoy',
          authorRole: 'EXPERT',
          expertApproved: true,
          likeCount: 9,
          createdAt: DateTime(2026, 8, 17),
        ),
      ];

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

class _FakeRoutineRepository extends RoutineRepository {
  _FakeRoutineRepository() : super(Dio());

  @override
  Future<List<Routine>> getRoutines(String childId) async => const [
        Routine(
          id: 'r1',
          name: 'Sabah rutini',
          description: 'Okul öncesi sıralı adımlar',
          items: [
            RoutineItem(
              id: 'ri1',
              title: 'Uyanma ve sarılma',
              scheduledTime: '07:00',
              iconName: 'morning',
            ),
            RoutineItem(
              id: 'ri2',
              title: 'Diş fırçalama',
              scheduledTime: '07:20',
              iconName: 'brush',
            ),
            RoutineItem(
              id: 'ri3',
              title: 'Kahvaltı',
              scheduledTime: '07:35',
              iconName: 'eat',
            ),
          ],
        ),
        Routine(
          id: 'r2',
          name: 'Akşam rutini',
          items: [
            RoutineItem(
              id: 'ri4',
              title: 'Işıkları kıs',
              scheduledTime: '20:30',
            ),
          ],
        ),
      ];
}

class _FakeConnectionRepository extends ConnectionRepository {
  _FakeConnectionRepository() : super(Dio());

  @override
  Future<List<ExpertConnection>> getRequests() async => [
        ExpertConnection(
          id: 'cn1',
          expertName: 'Uzm. Psk. Selin Aksoy',
          childName: 'Ada',
          createdAt: DateTime(2026, 8, 18),
        ),
      ];

  @override
  Future<List<ExpertConnection>> getActive() async => [
        ExpertConnection(
          id: 'cn2',
          expertName: 'Uzm. Ece Demir',
          childName: 'Ada',
          createdAt: DateTime(2026, 6, 2),
        ),
      ];
}

class _FakeGroupRepository extends GroupRepository {
  _FakeGroupRepository() : super(Dio());

  static const _groups = [
    Group(
      id: 'gr1',
      name: 'Okul Öncesi Aileler',
      description: 'Anaokulu ve kreş sürecindeki aileler için destek grubu.',
      category: 'Okul Dönemi',
      memberCount: 128,
      expertCount: 3,
      isMember: true,
      conversationId: 'cv2',
      createdByUserId: 'u1',
    ),
    Group(
      id: 'gr2',
      name: 'Duyusal Destek',
      description: 'Duyusal profil ve regülasyon deneyimleri.',
      category: 'Duyusal İşleme',
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

  @override
  Future<List<GroupMember>> getMembers(String id) async => const [
        GroupMember(
          id: 'u1',
          fullName: 'Elif Yılmaz',
          role: 'PARENT',
          city: 'İstanbul',
        ),
        GroupMember(
          id: 'u5',
          fullName: 'Uzm. Psk. Selin Aksoy',
          role: 'EXPERT',
          expertTitle: 'Klinik Psikolog',
          city: 'İzmir',
        ),
      ];

  @override
  Future<List<GroupMeeting>> getMeetings(String id) async => [
        GroupMeeting(
          id: 'gm1',
          title: 'Okula uyum sohbeti',
          startTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
          description: 'Eylül döneminde okula başlama deneyimleri.',
          meetingUrl: 'https://meet.example.com/okul-uyum',
        ),
      ];

  @override
  Future<void> deleteMeeting(String id, String meetingId) async {}

  @override
  Future<Group> update(
    String id, {
    required String name,
    String? description,
    String? category,
  }) async =>
      Group(id: id, name: name, description: description, category: category);

  @override
  Future<void> delete(String id) async {}
}

class _FakeWallRepository extends WallRepository {
  _FakeWallRepository() : super(Dio());

  @override
  Future<WallPost> getPost(String id) async => WallPost(
        id: id,
        title: 'Bugün zor bir gündü',
        content:
            'Markette kriz yaşadık, çevrenin bakışları çok yordu. '
            'Eve dönünce ikimiz de sakinleştik ama içimde kalan yorgunluk '
            'sürüyor. Yalnız olmadığımı bilmek iyi geliyor.',
        likeCount: 24,
        commentCount: 2,
        createdAt: DateTime(2026, 8, 18),
      );

  @override
  Future<List<WallComment>> getComments(String postId, {int page = 0}) async =>
      [
        WallComment(
          id: 'wc1',
          content: 'Aynısını geçen ay yaşadık. Yalnız değilsin.',
          createdAt: DateTime(2026, 8, 18),
        ),
        WallComment(
          id: 'wc2',
          content: 'Kulaklık ve sakin köşe bizde çok işe yaradı.',
          createdAt: DateTime(2026, 8, 19),
        ),
      ];

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


class _FakeMilestoneRepository extends MilestoneRepository {
  _FakeMilestoneRepository() : super(Dio());

  @override
  Future<List<Milestone>> getByChild(String childId) async => [
        Milestone(
          id: 'ms1',
          title: 'İki kelimelik istek cümlesi',
          category: 'Dil ve İletişim',
          achievedDate: DateTime.now().subtract(const Duration(days: 6)),
        ),
        Milestone(
          id: 'ms2',
          title: 'Sırasını bekledi',
          category: 'Sosyal Beceriler',
          achievedDate: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];
}

class _FakeScreeningRepository extends ScreeningRepository {
  _FakeScreeningRepository() : super(Dio());

  @override
  Future<List<ScreeningResult>> getByChild(String childId) async => [
        ScreeningResult(
          id: 'sc1',
          testType: 'M-CHAT-R',
          score: 7,
          riskLevel: 'MEDIUM',
          createdAt: DateTime(2026, 5, 12),
        ),
      ];
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


class _FakeSearchRepository extends SearchRepository {
  _FakeSearchRepository() : super(Dio());

  @override
  Future<List<SearchResult>> search(String query, {String? type}) async => [
        SearchResult(
          id: 'k1',
          type: kSearchTypeArticle,
          title: 'Uyku rutinini kurmanın beş adımı',
          excerpt: 'Akşam rutinini sabitlemek uykuya geçişi kolaylaştırıyor.',
          createdAt: DateTime(2026, 7, 18),
        ),
        SearchResult(
          id: 'f2',
          type: kSearchTypePost,
          title: 'Uyku öncesi rutini nasıl kısalttınız?',
          excerpt: 'Bizde rutin 1 saati buluyor, önerisi olan var mı?',
          createdAt: DateTime(2026, 8, 14),
        ),
        SearchResult(
          id: 'e1',
          type: kSearchTypeExpert,
          title: 'Uzm. Psk. Selin Aksoy',
          excerpt: 'Klinik Psikolog · İstanbul',
        ),
      ];
}


class _FakeMatchingRepository extends MatchingRepository {
  _FakeMatchingRepository() : super(Dio());

  @override
  Future<List<SimilarFamily>> findSimilarFamilies(String childId) async => [
        const SimilarFamily(
          parentId: 'p2',
          parentName: 'Zeynep A.',
          childAgeRange: '4-6 yaş',
          parentCity: 'İstanbul',
          childName: 'Kaan',
          similarityScore: 0.82,
          tagScore: 0.9,
          ageScore: 1,
          sensoryScore: 0.45,
          therapyScore: 0.6,
          educationScore: 0.3,
          totalCommonTags: 3,
          commonTags: [
            FamilyTag(id: 't1', name: 'Uyku düzeni', category: 'DAVRANIS'),
            FamilyTag(id: 't2', name: 'Ortak dikkat', category: 'SOSYAL'),
          ],
          matchReasons: [
            'Aynı yaş aralığında çocuk',
            'Üç ortak destek etiketi',
          ],
        ),
        const SimilarFamily(
          parentId: 'p3',
          parentName: 'Emre K.',
          childAgeRange: '4-6 yaş',
          parentCity: 'Ankara',
          similarityScore: 0.74,
          tagScore: 0.6,
          ageScore: 0.9,
          relationshipStatus: 'PENDING',
          relationshipId: 'r9',
          requestedByMe: true,
          communicationPreferences: ['YAZISMA', 'AKSAM'],
        ),
      ];

  @override
  Future<bool> getMatchingStatus() async => true;
}

class _FakeMeetupRequestRepository extends MeetupRequestRepository {
  _FakeMeetupRequestRepository() : super(Dio());

  @override
  Future<List<MeetupRequest>> getMyRequests() async => const [
        MeetupRequest(
          id: 'mr1',
          requesterId: 'p2',
          requesterName: 'Zeynep A.',
          recipientId: 'u1',
          recipientName: 'Elif Yılmaz',
          type: kMeetupRequestInPerson,
          proposedDate: '2026-09-02',
          proposedTime: '15:00',
          location: 'Kadıköy Parkı',
          message: 'Çocuklar birlikte oynayabilir.',
        ),
      ];
}


class _FakeBuddyRepository extends BuddyRepository {
  _FakeBuddyRepository() : super(Dio());

  @override
  Future<List<Buddy>> getMyBuddies() async => const [
        Buddy(
          buddyId: 'p2',
          fullName: 'Zeynep A.',
          relationshipId: 'r1',
          city: 'İstanbul',
          distanceKm: 3.4,
        ),
        Buddy(
          buddyId: 'p5',
          fullName: 'Uzm. Psk. Selin Aksoy',
          relationshipId: 'r2',
          city: 'İzmir',
          mentorRelation: true,
        ),
      ];

  @override
  Future<List<Buddy>> getPendingRequests() async => const [
        Buddy(
          buddyId: 'p7',
          fullName: 'Merve D.',
          relationshipId: 'r3',
          city: 'Bursa',
          status: 'PENDING',
          requestMessage:
              'Merhaba, oğlum da dil terapisine yeni başladı. Tanışmak isterim.',
        ),
      ];

  @override
  Future<void> accept(String relationshipId) async {}

  @override
  Future<void> reject(String relationshipId) async {}

  @override
  Future<void> remove(String relationshipId) async {}

  @override
  Future<void> withdraw(String relationshipId) async {}
}

class _FakeBlockRepository extends BlockRepository {
  _FakeBlockRepository() : super(Dio());

  @override
  Future<List<AppUser>> getBlocked() async => const [
        AppUser(
          id: 'u9',
          email: 'engelli@example.com',
          fullName: 'Kerem T.',
          role: UserRole.parent,
          city: 'Ankara',
        ),
      ];

  @override
  Future<void> block(String userId) async {}

  @override
  Future<void> unblock(String userId) async {}
}

class _FakeTreatmentRepository extends TreatmentRepository {
  _FakeTreatmentRepository() : super(Dio());

  @override
  Future<TreatmentPageState> getState(String childId) async =>
      const TreatmentPageState();

  @override
  Future<TreatmentPageState> saveState(
    String childId,
    TreatmentPageState state,
  ) async =>
      state;
}

class _FakeCommunityRepository extends CommunityRepository {
  _FakeCommunityRepository() : super(Dio());

  @override
  Future<List<CommunityMeetup>> getMeetups({String? city}) async => [
        CommunityMeetup(
          id: 'mt1',
          title: 'Parkta duyusal dostu buluşma',
          city: 'İstanbul',
          district: 'Kadıköy',
          venue: 'Özgürlük Parkı',
          date: DateTime(2026, 8, 24),
          time: '11:00',
          description: 'Sakin köşesi olan, gölgeli bir alanda buluşuyoruz.',
          organizer: 'Zeynep A.',
          attendees: 7,
          emoji: '🌳',
        ),
        CommunityMeetup(
          id: 'mt2',
          title: 'Kahve sohbeti (yalnızca veliler)',
          city: 'İstanbul',
          date: DateTime(2026, 9, 5),
          time: '14:30',
          attendees: 3,
          joined: true,
          emoji: '☕',
        ),
      ];

  @override
  Future<List<WeeklyQuestion>> getWeeklyQuestions() async => [
        WeeklyQuestion(
          id: 'wq1',
          question: 'Çocuğunuzla iletişimde işe yarayan küçük bir alışkanlık?',
          weekLabel: '34. hafta',
          answers: [
            WeeklyAnswer(
              id: 'wa1',
              author: 'Elif Y.',
              rawText: 'Sabah rutinini görsel kartlarla anlatıyoruz.',
              city: 'İstanbul',
              likes: 12,
            ),
            WeeklyAnswer(
              id: 'wa2',
              author: 'Uzm. Selin A.',
              rawText: 'Cümlelerimizi kısalttık, bekleme süresini uzattık.',
              authorRole: 'EXPERT',
              expertTitle: 'Klinik Psikolog',
              likes: 21,
            ),
          ],
        ),
      ];
}

class _FakeEmergencyRepository extends EmergencyRepository {
  _FakeEmergencyRepository() : super(Dio());

  @override
  Future<EmergencyCard?> getCard(String childId) async => EmergencyCard(
        childId: childId,
        childName: 'Ada Yılmaz',
        birthDate: '2019-04-12',
        bloodType: '0 Rh+',
        communicationLevel: 'Sözel, kısa cümleler',
        contactName1: 'Elif Yılmaz',
        contactPhone1: '0555 000 00 00',
        contactName2: 'Mert Yılmaz',
        contactPhone2: '0555 111 11 11',
        doctorName: 'Dr. Mert Kaya',
        medications: 'D vitamini (günlük)',
        allergies: 'Fındık',
        triggersList: 'Ani yüksek ses, kalabalık',
        calmingStrategies: 'Kulaklık, sakin köşe, sayma oyunu',
        avoidList: 'Ani dokunma, yüksek sesle uyarma',
      );

  @override
  Future<EmergencyShareStatus> shareStatus(String childId) async =>
      const EmergencyShareStatus(consentGranted: true, shareEnabled: false);
}

// ---------------------------------------------------------------------------
// Yardımcılar
// ---------------------------------------------------------------------------

/// Metin ve ikonların kutu yerine gerçek glif olarak çizilmesi için SDK
/// içindeki fontları yükler (tema 'Inter' istiyor, cihazda sistem fontuna
/// düşüyor; burada Roboto ile temsil edilir).

/// Görüntü varyantı: normal (açık tema), karanlık tema ya da erişilebilirlik
/// (büyük yazı + yüksek kontrast) ayarları. Uygulamadaki `app.dart` ile aynı
/// palet dönüşümü kullanılır.
enum ShotVariant { light, dark, accessible }

Widget hostApp(
  Widget home, {
  List<dynamic> overrides = const [],
  ShotVariant variant = ShotVariant.light,
  List<String> fontFallback = const [],
}) {
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
        routineRepositoryProvider.overrideWithValue(_FakeRoutineRepository()),
        connectionRepositoryProvider
            .overrideWithValue(_FakeConnectionRepository()),
        groupRepositoryProvider.overrideWithValue(_FakeGroupRepository()),
        wallRepositoryProvider.overrideWithValue(_FakeWallRepository()),
        notificationRepositoryProvider
            .overrideWithValue(_FakeNotificationRepository()),
        analyticsRepositoryProvider
            .overrideWithValue(_FakeAnalyticsRepository()),
        milestoneRepositoryProvider
            .overrideWithValue(_FakeMilestoneRepository()),
        screeningRepositoryProvider
            .overrideWithValue(_FakeScreeningRepository()),
        kvkkRepositoryProvider.overrideWithValue(_FakeKvkkRepository()),
        searchRepositoryProvider.overrideWithValue(_FakeSearchRepository()),
        matchingRepositoryProvider.overrideWithValue(_FakeMatchingRepository()),
        buddyRepositoryProvider.overrideWithValue(_FakeBuddyRepository()),
        blockRepositoryProvider.overrideWithValue(_FakeBlockRepository()),
        meetupRequestRepositoryProvider
            .overrideWithValue(_FakeMeetupRequestRepository()),
        treatmentRepositoryProvider
            .overrideWithValue(_FakeTreatmentRepository()),
        communityRepositoryProvider
            .overrideWithValue(_FakeCommunityRepository()),
        emergencyRepositoryProvider
            .overrideWithValue(_FakeEmergencyRepository()),
        ...overrides.cast(),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Emoji fontu yalnızca yedek olarak eklenir (cihazda sistem fontu
        // aynı işi yapıyor).
        theme: _themeFor(variant).copyWith(
          textTheme: _themeFor(variant).textTheme.apply(
                fontFamilyFallback: fontFallback,
              ),
        ),
        builder: (context, child) {
          if (variant != ShotVariant.accessible) {
            return child ?? const SizedBox.shrink();
          }
          // Büyük yazı tercihi (%112,5) uygulamadaki gibi MediaQuery ile.
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(textScaler: const TextScaler.linear(1.125)),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: home,
      ),
    ),
  );
}

ThemeData _themeFor(ShotVariant variant) => switch (variant) {
      ShotVariant.light => AppTheme.light,
      ShotVariant.dark => AppTheme.dark,
      // Erişilebilirlik: yüksek kontrast paleti + büyük yazı.
      ShotVariant.accessible => AppTheme.themeFor(
          palette: AppPalette.light.highContrast,
          brightness: Brightness.light,
          reduceMotion: true,
        ),
    };

/// Detay sayfası karesinde kullanılan örnek randevu.
final Appointment sampleAppointment = Appointment(
  id: 'a1',
  date: DateTime.now().add(const Duration(days: 1)),
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
);

/// Bir ekran karesi: adı, kurucusu ve varsa varyantı/override'ları.
class ScreenShot {
  const ScreenShot(
    this.name,
    this.build, {
    this.variant = ShotVariant.light,
    this.overrides = const [],
    this.after,
  });

  /// Dosya adı ve test başlığı olarak kullanılır.
  final String name;
  final Widget Function() build;
  final ShotVariant variant;
  final List<dynamic> overrides;

  /// Kare alınmadan önce çalışacak etkileşim (kaydırma, dokunma).
  final Future<void> Function(WidgetTester tester)? after;
}

/// Kurulup doğrulanan ekranların tamamı. Yeni ekran eklendiğinde buraya bir
/// satır eklemek hem çökme testini hem de ekran görüntüsünü kapsar.
List<ScreenShot> screenCatalog() => [
  ScreenShot(
    '01-ana-sayfa',
    () => const Scaffold(body: HomeTab()),
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
  ),
  ScreenShot(
    '02-ana-sayfa-plan',
    () => const Scaffold(body: HomeTab()),
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
  ),
  ScreenShot(
    '03-uzmanlar',
    () => const Scaffold(body: SpecialistsTab()),
  ),
  ScreenShot(
    '04-uzman-profili',
    () => const ExpertDetailScreen(expert: _FakeExpertRepository._selin),
  ),
  ScreenShot(
    '05-randevular',
    () => const AppointmentsScreen(),
  ),
  // Kart üzerindeki ikincil eylemler (ertele/iptal) taşma menüsünde:
  // menünün ve tema diyalog biçiminin çizimi de görüntüye girsin.
  ScreenShot(
    '05b-randevu-secenekleri',
    () => const AppointmentsScreen(),
    after: (tester) async {
      await tester.tap(find.byType(PopupMenuButton<VoidCallback>).first);
      // Geri sayım sayacı süregeldiği için pumpAndSettle kullanılmıyor.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    },
  ),
  ScreenShot(
    '06-randevu-detayi',
    () => Scaffold(
      body: AppointmentDetailSheet(appointment: sampleAppointment),
    ),
  ),
  ScreenShot(
    '07-bilgi-bankasi',
    () => const KnowledgeScreen(),
  ),
  ScreenShot(
    '08-mesajlar',
    () => const ConversationsScreen(),
  ),
  ScreenShot(
    '09-sohbet-pecs',
    () => const ConversationThreadScreen(
        conversationId: 'cv1',
        title: 'Uzm. Psk. Selin Aksoy',
      ),
    after: (tester) async {
        await tester.tap(find.text('🧸'));
        await tester.pump();
      },
  ),
  ScreenShot(
    '09b-sohbet-tepki-yanit',
    () => const ConversationThreadScreen(
        conversationId: 'cv1',
        title: 'Uzm. Psk. Selin Aksoy',
      ),
  ),
  ScreenShot(
    '13-cocuklarim',
    () => const ChildrenScreen(),
  ),
  ScreenShot(
    '14-notlarim',
    () => const NotesScreen(),
  ),
  ScreenShot(
    '15-gunluk-takip',
    () => const DailyTrackerScreen(),
  ),
  ScreenShot(
    '16-odevlerim',
    () => const TasksScreen(),
  ),
  ScreenShot(
    '17-takvim',
    () => const CalendarScreen(),
  ),
  ScreenShot(
    '18-davranis-gunlugu',
    () => const BehaviorScreen(),
  ),
  ScreenShot(
    '19-gelisim',
    () => const Scaffold(body: ProgressTab()),
  ),
  ScreenShot(
    '52-giris',
    () => const LoginScreen(),
  ),
  ScreenShot(
    '53-kayit',
    () => const RegisterScreen(),
  ),
  ScreenShot(
    '54-sifremi-unuttum',
    () => const ForgotPasswordScreen(),
  ),
  ScreenShot(
    '55-eposta-dogrulama',
    () => const VerifyEmailScreen(email: 'veli@example.com'),
  ),
  ScreenShot(
    '56-ilk-kurulum',
    () => const OnboardingScreen(),
  ),
  ScreenShot(
    '57-cocuk-formu',
    () => const ChildFormScreen(),
  ),
  ScreenShot(
    '58-hedef-formu',
    () => const GoalFormScreen(childId: 'c1'),
  ),
  ScreenShot(
    '59-not-formu',
    () => const NoteFormScreen(childId: 'c1'),
  ),
  ScreenShot(
    '60-rutin-formu',
    () => const RoutineFormScreen(childId: 'c1'),
  ),
  ScreenShot(
    '61-randevu-alma',
    () => const AppointmentBookingScreen(expert: _FakeExpertRepository._selin),
  ),
  ScreenShot(
    '62-ai-asistan',
    () => const ChatScreen(),
  ),
  ScreenShot(
    '45-ana-sayfa-karanlik',
    () => const Scaffold(body: HomeTab()),
    variant: ShotVariant.dark,
    overrides: [
        dailyPlanInputProvider.overrideWith((ref) async => DailyPlanInput(
              now: DateTime.now(),
              hasChild: true,
              childName: 'Ada',
              pendingMedicationSlots: 1,
              recentNotes: 2,
            )),
      ],
  ),
  ScreenShot(
    '46-gelisim-paneli-karanlik',
    () => const AnalyticsScreen(),
    variant: ShotVariant.dark,
  ),
  ScreenShot(
    '47-sohbet-karanlik',
    () => const ConversationThreadScreen(
        conversationId: 'cv1',
        title: 'Uzm. Psk. Selin Aksoy',
      ),
    variant: ShotVariant.dark,
  ),
  ScreenShot(
    '48-kriz-rehberi-karanlik',
    () => const CrisisScreen(),
    variant: ShotVariant.dark,
  ),
  ScreenShot(
    '49-ana-sayfa-erisilebilir',
    () => const Scaffold(body: HomeTab()),
    variant: ShotVariant.accessible,
    overrides: [
        dailyPlanInputProvider.overrideWith((ref) async => DailyPlanInput(
              now: DateTime.now(),
              hasChild: true,
              childName: 'Ada',
              pendingMedicationSlots: 1,
              recentNotes: 2,
            )),
      ],
  ),
  ScreenShot(
    '50-gunluk-takip-erisilebilir',
    () => const DailyTrackerScreen(),
    variant: ShotVariant.accessible,
  ),
  ScreenShot(
    '51-odevlerim-erisilebilir',
    () => const TasksScreen(),
    variant: ShotVariant.accessible,
  ),
  ScreenShot(
    '33-rutinler',
    () => const RoutinesScreen(),
  ),
  ScreenShot(
    '34-uzman-erisimi',
    () => const ExpertAccessScreen(),
  ),
  ScreenShot(
    '35-cocuk-detayi',
    () => const ChildDetailScreen(childId: 'c1'),
  ),
  ScreenShot(
    '36-makale-detayi',
    () => const ArticleDetailScreen(id: 'k1', initialTitle: 'Uyku rutini'),
  ),
  ScreenShot(
    '37-forum-gonderisi',
    () => const ForumPostDetailScreen(postId: 'f1'),
  ),
  ScreenShot(
    '38-duvar-gonderisi',
    () => const SupportWallDetailScreen(postId: 'w1'),
  ),
  ScreenShot(
    '39-haftanin-sorusu-detayi',
    () => const WeeklyQuestionDetailScreen(questionId: 'wq1'),
  ),
  ScreenShot(
    '40-kvkk',
    () => const KvkkScreen(),
  ),
  ScreenShot(
    '41-yasal-metinler',
    () => const LegalIndexScreen(),
  ),
  ScreenShot(
    '41b-yasal-metin',
    () => const LegalDocumentScreen(kind: LegalDocumentKind.kvkk),
  ),
  ScreenShot(
    '41c-sifre-sifirla',
    () => const ResetPasswordScreen(token: 'demo-token'),
  ),
  ScreenShot(
    '42-hesap',
    () => const AccountScreen(),
  ),
  ScreenShot(
    '43-yardim',
    () => const HelpScreen(),
  ),
  ScreenShot(
    '27-tedavi-paneli',
    () => const TreatmentScreen(),
  ),
  ScreenShot(
    '28-bulusmalar',
    () => const MeetupsScreen(),
  ),
  ScreenShot(
    '29-haftanin-sorusu',
    () => const WeeklyQuestionScreen(),
  ),
  ScreenShot(
    '30-acil-kart',
    () => const EmergencyScreen(),
  ),
  ScreenShot(
    '31-ayarlar',
    () => const SettingsScreen(),
  ),
  ScreenShot(
    '31b-engellenenler',
    () => const BlockedUsersScreen(),
  ),
  ScreenShot(
    '26-benzer-aileler',
    () => const SimilarFamiliesScreen(),
  ),
  ScreenShot(
    '26b-benzer-aileler-cemberim',
    () => const SimilarFamiliesScreen(),
    after: (tester) async {
      final t = AppLocale.tr.buildSync();
      await tester.tap(find.text(t.similar.tabCircle));
      await tester.pumpAndSettle();
    },
  ),
  ScreenShot(
    '24b-gelisim-paneli-grafikler',
    () => const AnalyticsScreen(),
    after: (tester) async {
        final t = AppLocale.tr.buildSync();
        await tester.dragUntilVisible(
          find.text(t.analytics.dailySleep),
          find.byType(Scrollable).last,
          const Offset(0, -200),
        );
        await tester.pump();
      },
  ),
  ScreenShot(
    '25-arama',
    () => const SearchScreen(),
    after: (tester) async {
        await tester.enterText(find.byType(TextField).first, 'uyku');
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
      },
  ),
  ScreenShot(
    '24-gelisim-paneli',
    () => const AnalyticsScreen(),
  ),
  ScreenShot(
    '20-forum',
    () => const ForumScreen(),
  ),
  ScreenShot(
    '21-gruplar',
    () => const GroupsScreen(),
  ),
  ScreenShot(
    '21c-grup-detayi-karanlik',
    () => const GroupDetailScreen(
      group: Group(
        id: 'gr1',
        name: 'Okul Öncesi Aileler',
        description: 'Anaokulu ve kreş sürecindeki aileler için destek grubu.',
        category: 'Okul Dönemi',
        memberCount: 128,
        expertCount: 3,
        isMember: true,
        createdByUserId: 'u1',
      ),
    ),
    variant: ShotVariant.dark,
  ),
  ScreenShot(
    '21b-grup-detayi',
    () => const GroupDetailScreen(
      group: Group(
        id: 'gr1',
        name: 'Okul Öncesi Aileler',
        description: 'Anaokulu ve kreş sürecindeki aileler için destek grubu.',
        category: 'Okul Dönemi',
        memberCount: 128,
        expertCount: 3,
        isMember: true,
        createdByUserId: 'u1',
      ),
    ),
  ),
  ScreenShot(
    '22-dertlesme-duvari',
    () => const SupportWallScreen(),
  ),
  ScreenShot(
    '23-bildirimler',
    () => const NotificationsScreen(),
  ),
  ScreenShot(
    '10-kriz-rehberi',
    () => const CrisisScreen(),
  ),
  ScreenShot(
    '11-kullanici-rehberi',
    () => const GuideScreen(),
  ),
  ScreenShot(
    '12-topluluk',
    () => const CommunityScreen(),
  ),
  // --- Boş durumlar: veri yokken ekranların ne gösterdiği --------------
  ScreenShot(
    '63-ana-sayfa-bos',
    () => const Scaffold(body: HomeTab()),
    overrides: [
      childrenProvider.overrideWith((ref) async => const <Child>[]),
      appointmentsProvider.overrideWith((ref) async => const <Appointment>[]),
      dailyPlanInputProvider.overrideWith(
        (ref) async => DailyPlanInput(now: DateTime.now()),
      ),
    ],
  ),
  ScreenShot(
    '64-notlarim-bos',
    () => const NotesScreen(),
    overrides: [
      childrenProvider.overrideWith((ref) async => const <Child>[]),
    ],
  ),
  ScreenShot(
    '65-randevular-bos',
    () => const AppointmentsScreen(),
    overrides: [
      appointmentsProvider.overrideWith((ref) async => const <Appointment>[]),
    ],
  ),
  ScreenShot(
    '66-mesajlar-bos',
    () => const ConversationsScreen(),
    overrides: [
      conversationsProvider.overrideWith((ref) async => const <Conversation>[]),
    ],
  ),
  ScreenShot(
    '67-odevlerim-bos',
    () => const TasksScreen(),
    overrides: [
      myTasksProvider.overrideWith((ref) async => const <ExpertTask>[]),
    ],
  ),
  ScreenShot(
    '68-uzmanlar-bos',
    () => const Scaffold(body: SpecialistsTab()),
    overrides: [
      expertsProvider.overrideWith((ref) async => const <Expert>[]),
    ],
  ),
  ScreenShot(
    '69-gelisim-paneli-bos',
    () => const AnalyticsScreen(),
    overrides: [
      childrenProvider.overrideWith((ref) async => const <Child>[]),
    ],
  ),
];


/// Flutter SDK'sının font önbelleği — `flutter test` çalıştıran dart
/// yorumlayıcısının konumundan bulunur (sabit yol yazılmaz).
String? _materialFontsDir() {
  final exe = Platform.resolvedExecutable; // .../flutter/bin/cache/dart-sdk/bin/dart
  var dir = Directory(exe).parent;
  for (var i = 0; i < 6; i++) {
    final candidate = Directory('${dir.path}/artifacts/material_fonts');
    if (candidate.existsSync()) return candidate.path;
    dir = dir.parent;
  }
  return null;
}

/// Emoji için sistem fontu (varsa) — yalnızca yedek aile olarak verilir.
const String emojiFontFamily = 'Noto Color Emoji';
const String _emojiFontPath =
    '/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf';

/// Metin ve ikonları gerçek gliflerle çizmek için fontları yükler.
///
/// Bu şart: test motorunun varsayılan fontu her karakteri sabit genişlikte
/// bir kutu olarak çizdiği için metinler gerçekte olduğundan geniş görünür ve
/// olmayan taşma hataları üretir.
Future<void> loadTestFonts() async {
  final root = _materialFontsDir();
  if (root == null) return;

  Future<void> load(String family, List<String> paths) async {
    final loader = FontLoader(family);
    for (final path in paths) {
      final file = File(path.startsWith('/') ? path : '$root/$path');
      if (!file.existsSync()) continue;
      final bytes = await file.readAsBytes();
      loader.addFont(
        Future.value(ByteData.view(Uint8List.fromList(bytes).buffer)),
      );
    }
    await loader.load();
  }

  await load('Inter', ['Roboto-Regular.ttf', 'Roboto-Medium.ttf']);
  await load('Roboto', ['Roboto-Regular.ttf', 'Roboto-Medium.ttf']);
  await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
  if (File(_emojiFontPath).existsSync()) {
    await load(emojiFontFamily, [_emojiFontPath]);
  }
}

/// Telefon boyutunda yüzey (390x844 mantıksal, 2x).
void usePhoneSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = const Size(780, 1688);
  addTearDown(tester.view.reset);
}

/// Zincirli sağlayıcılar (kaynaklar → özet) birkaç tur sonra çözülüyor.
Future<void> settleScreen(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}