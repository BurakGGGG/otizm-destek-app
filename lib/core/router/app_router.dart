import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/app_user.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';
import '../../features/behavior/presentation/behavior_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/chatbot/presentation/chat_screen.dart';
import '../../features/community/presentation/meetups_screen.dart';
import '../../features/community/presentation/weekly_question_screen.dart';
import '../../features/children/presentation/children_screen.dart';
import '../../features/community/presentation/community_screen.dart';
import '../../features/crisis/presentation/crisis_screen.dart';
import '../../features/emergency/presentation/emergency_screen.dart';
import '../../features/groups/presentation/groups_screen.dart';
import '../../features/guide/presentation/guide_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/knowledge/presentation/knowledge_screen.dart';
import '../../features/legal/presentation/legal_screen.dart';
import '../../features/messaging/presentation/conversation_thread_screen.dart';
import '../../features/messaging/presentation/conversations_screen.dart';
import '../../features/mood/presentation/daily_tracker_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/account_screen.dart';
import '../../features/profile/presentation/help_screen.dart';
import '../../features/routines/presentation/routines_screen.dart';
import '../../features/settings/presentation/kvkk_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/similar_families/presentation/similar_families_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/forum/presentation/forum_screen.dart';
import '../../features/support_wall/presentation/support_wall_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/treatment/presentation/treatment_screen.dart';
import '../providers.dart';

/// Uygulama rotaları. Oturum durumuna göre yönlendirir (role duyarlı kabuk
/// Faz 3'te genişletilecek).
final goRouterProvider = Provider<GoRouter>((ref) {
  // Oturum durumu değişince router'ı tazelemek için köprü.
  final refresh = ValueNotifier<int>(0);
  // Oturum durumu VE onboarding bayrağı yönlendirmeyi etkilediği için ikisi de
  // dinlenir (sihirbaz bitince kullanıcı ana sayfaya geçebilmeli).
  ref.listen(
    authControllerProvider.select(
      (s) => (s.status, s.user?.onboardingCompleted ?? true),
    ),
    (_, _) {
      refresh.value++;
    },
  );
  ref.onDispose(refresh.dispose);

  // Firebase hazırsa ekran geçişlerini Analytics'e bildiren observer ekle.
  final observers = <NavigatorObserver>[
    if (ref.watch(firebaseReadyProvider))
      FirebaseAnalyticsObserver(analytics: ref.watch(analyticsProvider)),
  ];

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    observers: observers,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final status = auth.status;
      final loc = state.matchedLocation;

      if (status == AuthStatus.unknown) {
        return loc == '/splash' ? null : '/splash';
      }
      // Yasal metinler oturum gerektirmez: kayıt ekranındaki KVKK onayından
      // önce okunabilmeli (web'de de genel sayfalardır).
      final isPublicPage = loc.startsWith('/legal');
      final onAuthScreen = loc == '/login' ||
          loc == '/register' ||
          loc == '/forgot-password' ||
          loc == '/reset-password' ||
          loc == '/verify-email' ||
          isPublicPage;
      if (status == AuthStatus.unauthenticated) {
        return onAuthScreen ? null : '/login';
      }
      // authenticated
      // İlk giriş sihirbazı tamamlanmadıysa (backend `onboardingCompleted`)
      // kullanıcı önce oraya alınır — web `/baslangic` ile aynı davranış.
      final needsOnboarding = !(auth.user?.onboardingCompleted ?? true);
      if (needsOnboarding && !isPublicPage) {
        return loc == '/onboarding' ? null : '/onboarding';
      }
      if (loc == '/onboarding' && !needsOnboarding) return '/home';
      // Yasal metinler oturum açıkken de doğrudan açılabilir.
      if ((onAuthScreen && !isPublicPage) || loc == '/splash') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (_, state) {
          final isExpert = state.uri.queryParameters['role'] == 'expert';
          return RegisterScreen(
            initialRole: isExpert ? UserRole.expert : UserRole.parent,
          );
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (_, state) =>
            ResetPasswordScreen(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return VerifyEmailScreen(
            email: q['email'],
            token: q['token'],
            pendingApproval: q['approval'] == '1',
          );
        },
      ),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(
        path: '/home',
        builder: (_, state) => HomeShell(
          initialTab:
              int.tryParse(state.uri.queryParameters['tab'] ?? '') ?? 0,
        ),
      ),
      GoRoute(path: '/chat', builder: (_, _) => const ChatScreen()),
      GoRoute(path: '/children', builder: (_, _) => const ChildrenScreen()),
      GoRoute(path: '/account', builder: (_, _) => const AccountScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/kvkk', builder: (_, _) => const KvkkScreen()),
      GoRoute(path: '/legal', builder: (_, _) => const LegalIndexScreen()),
      GoRoute(
        path: '/legal/:kind',
        builder: (_, state) => LegalDocumentScreen(
          kind: legalKindFromName(state.pathParameters['kind']),
        ),
      ),
      GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
      GoRoute(path: '/guide', builder: (_, _) => const GuideScreen()),
      GoRoute(
        path: '/community',
        builder: (_, _) => const CommunityScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/appointments',
        builder: (_, _) => const AppointmentsScreen(),
      ),
      GoRoute(path: '/knowledge', builder: (_, _) => const KnowledgeScreen()),
      GoRoute(path: '/routines', builder: (_, _) => const RoutinesScreen()),
      GoRoute(
        path: '/daily-tracker',
        builder: (_, _) => const DailyTrackerScreen(),
      ),
      GoRoute(path: '/analytics', builder: (_, _) => const AnalyticsScreen()),
      GoRoute(path: '/behavior', builder: (_, _) => const BehaviorScreen()),
      GoRoute(path: '/emergency', builder: (_, _) => const EmergencyScreen()),
      GoRoute(path: '/calendar', builder: (_, _) => const CalendarScreen()),
      GoRoute(path: '/crisis', builder: (_, _) => const CrisisScreen()),
      GoRoute(
        path: '/support-wall',
        builder: (_, _) => const SupportWallScreen(),
      ),
      GoRoute(
        path: '/weekly-question',
        builder: (_, _) => const WeeklyQuestionScreen(),
      ),
      GoRoute(path: '/meetups', builder: (_, _) => const MeetupsScreen()),
      GoRoute(
        path: '/similar-families',
        builder: (_, _) => const SimilarFamiliesScreen(),
      ),
      GoRoute(path: '/groups', builder: (_, _) => const GroupsScreen()),
      GoRoute(path: '/treatment', builder: (_, _) => const TreatmentScreen()),
      GoRoute(path: '/tasks', builder: (_, _) => const TasksScreen()),
      GoRoute(path: '/notes', builder: (_, _) => const NotesScreen()),
      GoRoute(path: '/forum', builder: (_, _) => const ForumScreen()),
      GoRoute(
        path: '/messages',
        builder: (_, _) => const ConversationsScreen(),
      ),
      GoRoute(
        path: '/messages/thread',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ConversationThreadScreen(
            conversationId: extra?['id'] as String? ?? '',
            title: extra?['title'] as String? ?? '',
          );
        },
      ),
    ],
  );
});
