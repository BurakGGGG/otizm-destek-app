import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../domain/app_user.dart';
import 'auth_controller.dart';

/// Giriş ekranı — Stitch "Giriş Yap" tasarımı.
///
/// Faz 2'de gerçek Firebase Auth (e-posta/şifre + Google) bağlanacak.
/// Şu an butonlar akışı doğrulamak için geçici [AuthController.devSignIn] çağırır.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = ref.watch(authControllerProvider).isBusy;
    final text = Theme.of(context).textTheme;
    final t = context.t;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.volunteer_activism,
                              color: Colors.white, size: 28),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(t.app.name,
                          textAlign: TextAlign.center,
                          style: text.headlineSmall),
                      const SizedBox(height: 6),
                      Text(t.auth.subtitle,
                          textAlign: TextAlign.center, style: text.bodySmall),
                      const SizedBox(height: 24),
                      _Field(
                        label: t.auth.emailLabel,
                        controller: _email,
                        hint: t.auth.emailHint,
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: t.auth.passwordLabel,
                        controller: _password,
                        hint: t.auth.passwordHint,
                        icon: Icons.lock_outline,
                        obscure: _obscure,
                        trailing: IconButton(
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(t.auth.rememberMe,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: const Size(0, 40),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(t.auth.forgotPassword),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: isBusy ? null : _onLogin,
                        child: isBusy
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(t.auth.loginButton),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Text(t.auth.noAccount, style: text.bodySmall),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: isBusy
                            ? null
                            : () => _onRegister(UserRole.parent),
                        icon: const Icon(Icons.person_outline, size: 20),
                        label: Text(t.auth.registerParent),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: isBusy
                            ? null
                            : () => _onRegister(UserRole.expert),
                        icon: const Icon(Icons.work_outline, size: 20),
                        label: Text(t.auth.registerExpert),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      _showError(context.t.auth.errorEmptyFields);
      return;
    }
    final error =
        await ref.read(authControllerProvider.notifier).signIn(email, password);
    if (error != null) _showError(error);
    // Başarılıysa router otomatik ana sayfaya yönlendirir.
  }

  void _onRegister(UserRole role) {
    final query = role == UserRole.expert ? '?role=expert' : '?role=parent';
    context.go('/register$query');
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Etiketi her zaman görünür olan form alanı (bilişsel erişilebilirlik).
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textTertiary),
            suffixIcon: trailing,
            fillColor: AppColors.surfaceVariant,
          ),
        ),
      ],
    );
  }
}
