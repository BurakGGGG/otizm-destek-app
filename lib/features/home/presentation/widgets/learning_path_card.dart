import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../../guide/data/watched_videos.dart';

/// Rolün ilk rehber videosu (web `LEARNING_PATH_FIRST_VIDEO` ile aynı).
const Map<UserRole, String> kLearningPathFirstVideo = {
  UserRole.parent: '02',
  UserRole.expert: '16',
  UserRole.admin: '21',
};

/// "Öğrenme yolu" kartının kapatılma durumu (cihazda saklanır — web
/// `dashboard-learning-path-dismissed-v1` anahtarıyla aynı amaç).
class LearningPathDismissed extends Notifier<bool> {
  static const _storageKey = 'dashboard-learning-path-dismissed';

  @override
  bool build() {
    _restore();
    return false;
  }

  Future<void> _restore() async {
    try {
      final raw =
          await ref.read(secureStorageProvider).readPreference(_storageKey);
      if (raw == 'true') state = true;
    } catch (_) {
      // Okunamazsa kart görünür kalır.
    }
  }

  Future<void> dismiss() async {
    state = true;
    try {
      await ref.read(secureStorageProvider).savePreference(_storageKey, 'true');
    } catch (_) {
      // Kayıt başarısızsa kapatma oturum içinde geçerli kalır.
    }
  }
}

final learningPathDismissedProvider =
    NotifierProvider<LearningPathDismissed, bool>(LearningPathDismissed.new);

/// Yeni kullanıcıyı video rehberine yönlendiren kart. Kapatılınca ya da
/// rolün ilk videosu izlenince görünmez (web ile aynı kural).
class LearningPathCard extends ConsumerWidget {
  const LearningPathCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(learningPathDismissedProvider)) {
      return const SizedBox.shrink();
    }
    final role = ref.watch(authControllerProvider).user?.role;
    final firstVideo = kLearningPathFirstVideo[role ?? UserRole.parent];
    final watched = ref.watch(watchedVideosProvider);
    if (firstVideo != null && watched.contains(firstVideo)) {
      return const SizedBox.shrink();
    }

    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t.home.learningPathBadge,
                  style: text.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: t.common.a11y.close,
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    ref.read(learningPathDismissedProvider.notifier).dismiss(),
                icon: Icon(Icons.close, size: 18, color: colors.textTertiary),
              ),
            ],
          ),
          Text(
            t.home.learningPathTitle,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            role == UserRole.expert
                ? t.home.learningPathBodyExpert
                : t.home.learningPathBody,
            style: text.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              style: AppButtonStyles.inlineFilled,
              onPressed: () => context.push('/guide'),
              icon: const Icon(Icons.play_circle_outline, size: 18),
              label: Text(t.home.learningPathCta),
            ),
          ),
        ],
      ),
    );
  }
}
