import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/app_user.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/splash/splash_screen.dart';

/// Uygulama rotaları. Oturum durumuna göre yönlendirir (role duyarlı kabuk
/// Faz 3'te genişletilecek).
final goRouterProvider = Provider<GoRouter>((ref) {
  // Oturum durumu değişince router'ı tazelemek için köprü.
  final refresh = ValueNotifier<int>(0);
  ref.listen(authControllerProvider.select((s) => s.status), (_, _) {
    refresh.value++;
  });
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider).status;
      final loc = state.matchedLocation;

      if (status == AuthStatus.unknown) {
        return loc == '/splash' ? null : '/splash';
      }
      final onAuthScreen = loc == '/login' || loc == '/register';
      if (status == AuthStatus.unauthenticated) {
        return onAuthScreen ? null : '/login';
      }
      // authenticated
      if (onAuthScreen || loc == '/splash') return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
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
        path: '/home',
        builder: (_, _) => const HomeShell(),
      ),
    ],
  );
});
