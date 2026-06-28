import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../i18n/strings.g.dart';
import '../../profile/presentation/profile_tab.dart';
import '../../progress/presentation/progress_tab.dart';
import '../../specialists/presentation/specialists_tab.dart';
import 'home_tab.dart';

/// Yetişkin (veli/uzman/eğitimci) için alt navigasyonlu uygulama kabuğu.
/// Sekmeler: Ana Sayfa, Uzmanlar, Gelişim, Profil.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  static const _tabs = [
    HomeTab(),
    SpecialistsTab(),
    ProgressTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.volunteer_activism,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Text(t.app.name),
          ],
        ),
        actions: [
          IconButton(
            tooltip: t.home.messages,
            onPressed: () => context.push('/messages'),
            icon: const Icon(Icons.chat_bubble_outline),
          ),
          IconButton(
            tooltip: t.home.assistant,
            onPressed: () => context.push('/chat'),
            icon: const Icon(Icons.smart_toy_outlined),
          ),
          IconButton(
            tooltip: t.home.notifications,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.common.comingSoon)),
            ),
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: t.nav.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.groups_outlined),
              selectedIcon: const Icon(Icons.groups),
              label: t.nav.specialists,
            ),
            NavigationDestination(
              icon: const Icon(Icons.insights_outlined),
              selectedIcon: const Icon(Icons.insights),
              label: t.nav.progress,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: t.nav.profile,
            ),
          ],
        ),
      ),
    );
  }
}
