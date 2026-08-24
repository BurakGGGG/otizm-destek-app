import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/input_rules.dart';
import '../../../i18n/strings.g.dart';
import '../domain/app_user.dart';
import '../domain/login_throttle.dart';
import 'auth_controller.dart';

/// Giriş ekranı — Stitch "Giriş Yap" tasarımı.
///
/// Kimlik backend'in JWT'siyle kurulur. Art arda başarısız denemede cihazda
/// bekleme uygulanır (bkz. [LoginThrottle]); sunucu tarafındaki asıl sınır
/// `/api/auth/login` üzerindeki 429 kuralıdır.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  /// Varsayılan açık: bugüne kadarki davranış oturumu saklıyordu.
  bool _rememberMe = true;

  /// Art arda başarısız giriş sayısı ve kalan bekleme (saniye).
  int _failedAttempts = 0;
  int _cooldownLeft = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Geri sayımı başlatır; süre dolunca düğme yeniden açılır.
  void _startCooldown(Duration wait) {
    _cooldownTimer?.cancel();
    setState(() => _cooldownLeft = wait.inSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _cooldownLeft--);
      if (_cooldownLeft <= 0) timer.cancel();
    });
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
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volunteer_activism,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.app.name,
                        textAlign: TextAlign.center,
                        style: text.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.auth.subtitle,
                        textAlign: TextAlign.center,
                        style: text.bodySmall,
                      ),
                      const SizedBox(height: 24),
                      // İki alan aynı autofill grubunda: şifre yöneticisi
                      // ikisini birlikte doldurup kaydedebilsin.
                      AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Field(
                              label: t.auth.emailLabel,
                              controller: _email,
                              hint: t.auth.emailHint,
                              icon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.username],
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            _Field(
                              label: t.auth.passwordLabel,
                              controller: _password,
                              hint: t.auth.passwordHint,
                              icon: Icons.lock_outline,
                              obscure: _obscure,
                              autofillHints: const [AutofillHints.password],
                              // Klavyedeki "bitti" doğrudan giriş yapsın.
                              textInputAction: TextInputAction.done,
                              onSubmitted:
                                  isBusy || _cooldownLeft > 0 ? null : _onLogin,
                              trailing: IconButton(
                                tooltip: _obscure
                                    ? t.common.a11y.showPassword
                                    : t.common.a11y.hidePassword,
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: context.colors.textTertiary,
                                ),
                              ),
                            ),
                          ],
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
                            child: Text(
                              t.auth.rememberMe,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.push('/forgot-password'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              minimumSize: const Size(0, 40),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(t.auth.forgotPassword),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        // Bekleme sırasında düğme kapalı ve kalan süreyi yazar.
                        onPressed: isBusy || _cooldownLeft > 0
                            ? null
                            : _onLogin,
                        child: isBusy
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _cooldownLeft > 0
                                    ? t.errors.retryInSeconds(
                                        count: _cooldownLeft,
                                      )
                                    : t.auth.loginButton,
                              ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              t.auth.noAccount,
                              style: text.bodySmall,
                            ),
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
    final t = context.t;
    if (_cooldownLeft > 0) {
      _showError(t.errors.retryInSeconds(count: _cooldownLeft));
      return;
    }
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      _showError(t.auth.errorEmptyFields);
      return;
    }
    if (!isValidEmail(email)) {
      _showError(t.errors.invalidEmail);
      return;
    }
    final failure = await ref
        .read(authControllerProvider.notifier)
        .signIn(email, password, rememberMe: _rememberMe);
    if (failure == null) {
      _failedAttempts = 0;
      // Şifre yöneticisine "kaydedeyim mi?" istemini tetikler.
      TextInput.finishAutofillContext();
      return; // router otomatik ana sayfaya yönlendirir
    }
    if (!mounted) return;

    // Art arda başarısız denemede cihaz tarafında bekleme uygula; sunucu
    // 429 döndüyse doğrudan sunucu penceresi kadar bekle.
    _failedAttempts++;
    final wait = failure.isRateLimited
        ? LoginThrottle.rateLimited
        : LoginThrottle.cooldownAfter(_failedAttempts);
    if (wait > Duration.zero) _startCooldown(wait);

    final error = failure.message;
    // Backend doğrulanmamış e-postada girişi engelliyor ("Giriş yapmadan önce
    // e-posta adresinizi doğrulayın"); kullanıcıyı çıkmaz sokakta bırakmamak
    // için doğrulama ekranına kısayol sun.
    if (_isEmailVerificationError(error)) {
      _showError(
        error,
        action: SnackBarAction(
          label: context.t.auth.resendVerification,
          onPressed: () => context.go(
            Uri(
              path: '/verify-email',
              queryParameters: {'email': email},
            ).toString(),
          ),
        ),
      );
      return;
    }
    _showError(error);
  }

  /// Backend mesajları her zaman Türkçe döner (uygulama diline bakmaz).
  bool _isEmailVerificationError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('doğrula') && lower.contains('e-posta');
  }

  void _onRegister(UserRole role) {
    final query = role == UserRole.expert ? '?role=expert' : '?role=parent';
    context.go('/register$query');
  }

  void _showError(String message, {SnackBarAction? action}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: action == null
            ? const Duration(seconds: 4)
            : const Duration(seconds: 8),
      ),
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
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
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
          autofillHints: autofillHints,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted == null ? null : (_) => onSubmitted!(),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: context.colors.textTertiary),
            suffixIcon: trailing,
            fillColor: context.colors.surfaceVariant,
          ),
        ),
      ],
    );
  }
}
