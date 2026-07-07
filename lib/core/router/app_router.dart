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
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/chatbot/presentation/chat_screen.dart';
import '../../features/children/presentation/children_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/knowledge/presentation/knowledge_screen.dart';
import '../../features/messaging/presentation/conversation_thread_screen.dart';
import '../../features/messaging/presentation/conversations_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/account_screen.dart';
import '../../features/profile/presentation/help_screen.dart';
import '../../features/routines/presentation/routines_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../providers.dart';

/// Uygulama rotaları. Oturum durumuna göre yönlendirir (role duyarlı kabuk
/// Faz 3'te genişletilecek).
final goRouterProvider = Provider<GoRouter>((ref) {
  // Oturum durumu değişince router'ı tazelemek için köprü.
  final refresh = ValueNotifier<int>(0);
  ref.listen(authControllerProvider.select((s) => s.status), (_, _) {
    refresh.value++;
  });
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
      final status = ref.read(authControllerProvider).status;
      final loc = state.matchedLocation;

      if (status == AuthStatus.unknown) {
        return loc == '/splash' ? null : '/splash';
      }
      final onAuthScreen = loc == '/login' ||
          loc == '/register' ||
          loc == '/forgot-password' ||
          loc == '/reset-password';
      if (status == AuthStatus.unauthenticated) {
        return onAuthScreen ? null : '/login';
      }
      // authenticated
      if (onAuthScreen || loc == '/splash') return '/home';
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
      GoRoute(path: '/home', builder: (_, _) => const HomeShell()),
      GoRoute(path: '/chat', builder: (_, _) => const ChatScreen()),
      GoRoute(path: '/children', builder: (_, _) => const ChildrenScreen()),
      GoRoute(path: '/account', builder: (_, _) => const AccountScreen()),
      GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
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
