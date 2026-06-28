import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';

/// Statik Yardım & Hakkında ekranı (backend gerektirmez).
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.help.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.volunteer_activism,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(t.app.name, style: text.titleLarge),
                  Text(
                    t.help.version(version: _appVersion),
                    style: text.bodySmall?.copyWith(
                        color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: t.help.aboutTitle,
              child: Text(t.help.aboutBody, style: text.bodyMedium),
            ),
            _Section(
              title: t.help.tipsTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Tip(text: t.help.tip1),
                  _Tip(text: t.help.tip2),
                  _Tip(text: t.help.tip3),
                ],
              ),
            ),
            _Section(
              title: t.help.contactTitle,
              child: Text(t.help.contactBody, style: text.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.check_circle_outline,
                size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
