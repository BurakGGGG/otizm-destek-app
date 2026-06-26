import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../i18n/strings.g.dart';

/// Açılış ekranı. Oturum durumu çözülene kadar gösterilir.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.volunteer_activism,
                size: 56, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(context.t.app.name),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
