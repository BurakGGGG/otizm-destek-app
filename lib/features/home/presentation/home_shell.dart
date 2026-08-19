import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/theme/app_colors.dart';
import '../../../i18n/strings.g.dart';
import '../../notifications/data/notification_repository.dart';
import '../../profile/presentation/profile_tab.dart';
import '../../progress/presentation/progress_tab.dart';
import '../../specialists/presentation/specialists_tab.dart';
import 'home_tab.dart';

/// Yetişkin (veli/uzman/eğitimci) için alt navigasyonlu uygulama kabuğu.
/// Sekmeler: Ana Sayfa, Uzmanlar, Gelişim, Profil.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, this.initialTab = 0});

  /// Açılacak sekme (0 ana sayfa, 1 uzmanlar, 2 gelişim, 3 profil) —
  /// `/home?tab=1` gibi bağlantılar doğrudan ilgili sekmeyi açsın diye.
  final int initialTab;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  late int _index = widget.initialTab.clamp(0, _tabs.length - 1);

  @override
  void didUpdateWidget(covariant HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // `/home?tab=1` kabuk zaten açıkken de gelebilir (ör. ana sayfadaki
    // plan kartından uzmanlara geçiş) — sekme o zaman da değişmeli.
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() {
        _index = widget.initialTab.clamp(0, _tabs.length - 1);
      });
    }
  }

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
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volunteer_activism,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(t.app.name),
          ],
        ),
        actions: [
          IconButton(
            tooltip: t.search.title,
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search),
          ),
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
          Consumer(
            builder: (context, ref, _) {
              final unread = ref.watch(unreadCountProvider).asData?.value ?? 0;
              return IconButton(
                tooltip: t.home.notifications,
                onPressed: () => context.push('/notifications'),
                icon: Badge.count(
                  count: unread,
                  isLabelVisible: unread > 0,
                  child: const Icon(Icons.notifications_none),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: context.colors.surface,
          indicatorColor: context.colors.primary.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) {
            if (i != _index) Haptics.selection();
            setState(() => _index = i);
          },
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
