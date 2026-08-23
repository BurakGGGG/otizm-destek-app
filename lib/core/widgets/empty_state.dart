import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../../i18n/strings.g.dart';

/// Boş liste/içerik durumu — ikon + mesaj + opsiyonel eylem butonu (CTA).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    final hasAction = actionLabel != null && onAction != null;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // İkon tonlu dairenin içinde: boş ekranın ortasında tek başına
            // duran gri simge "bir şey yüklenemedi" izlenimi veriyordu.
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: colors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text.titleSmall?.copyWith(color: colors.textSecondary),
            ),
            if (hasAction) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                // Satır içi biçim: temanın sonsuz asgari genişliği butonu
                // gereksizce ekran boyuna yayıyordu.
                style: AppButtonStyles.inlineFilled,
                onPressed: onAction,
                icon: Icon(actionIcon ?? Icons.add, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Hata durumu — ikon + mesaj + tekrar dene butonu.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 34,
                color: context.colors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message ?? t.common.loadError,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: context.colors.textSecondary),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              style: AppButtonStyles.inlineTonal(context),
              onPressed: onRetry,
              child: Text(t.common.retry),
            ),
          ],
        ),
      ),
    );
  }
}
