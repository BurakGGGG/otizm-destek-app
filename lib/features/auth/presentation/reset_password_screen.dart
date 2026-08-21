import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/password_rules.dart';
import '../../../core/widgets/password_strength_meter.dart';
import '../../../i18n/strings.g.dart';
import '../data/auth_repository.dart';

/// Şifre sıfırla — token (e-postadaki bağlantıdan/elle) + yeni şifre.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.token});

  /// Deep-link / sorgu parametresiyle gelen sıfırlama tokeni (varsa).
  final String? token;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late final TextEditingController _token;
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _token = TextEditingController(text: widget.token ?? '');
  }

  @override
  void dispose() {
    _token.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    if (_token.text.trim().isEmpty) {
      setState(() => _error = t.resetPassword.errorTokenRequired);
      return;
    }
    if (validatePassword(_password.text) case final issue?) {
      setState(() => _error = passwordIssueMessage(context, issue));
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = t.resetPassword.errorMismatch);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            token: _token.text.trim(),
            password: _password.text,
          );
      if (!mounted) return;
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.resetPassword.success)));
      context.go('/login');
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.resetPassword.title)),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.resetPassword.subtitle, style: text.bodyMedium),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _token,
                        decoration: InputDecoration(
                          labelText: t.resetPassword.tokenLabel,
                          hintText: t.resetPassword.tokenHint,
                          prefixIcon: const Icon(Icons.vpn_key_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _password,
                        obscureText: _obscure,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: t.resetPassword.newPasswordLabel,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _obscure ? context.t.common.a11y.showPassword : context.t.common.a11y.hidePassword,
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                      PasswordStrengthMeter(password: _password.text),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirm,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: t.resetPassword.confirmLabel,
                          prefixIcon: const Icon(Icons.lock_outline),
                          errorText: _error,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _submit,
                        child: _busy
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(t.resetPassword.submit),
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
}
