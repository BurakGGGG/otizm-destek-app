import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/auth_repository.dart';

/// Şifremi unuttum — e-posta ile sıfırlama bağlantısı ister.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;
  String? _error;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    final email = _email.text.trim();
    if (email.isEmpty) {
      setState(() => _error = t.forgotPassword.errorEmailRequired);
      return;
    }
    if (!_emailRe.hasMatch(email)) {
      setState(() => _error = t.forgotPassword.errorEmailInvalid);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await ref.read(authRepositoryProvider).forgotPassword(email);
      if (mounted) setState(() => _sent = true);
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
      appBar: AppBar(title: Text(t.forgotPassword.title)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _sent ? _sentView(t, text) : _formView(t, text),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formView(Translations t, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(t.forgotPassword.subtitle, style: text.bodyMedium),
        const SizedBox(height: 20),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.username],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!_busy) _submit();
          },
          decoration: InputDecoration(
            labelText: t.auth.emailLabel,
            hintText: t.auth.emailHint,
            prefixIcon: const Icon(Icons.mail_outline),
            errorText: _error,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(t.forgotPassword.submit),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.push('/reset-password'),
          child: Text(t.forgotPassword.haveCode),
        ),
      ],
    );
  }

  Widget _sentView(Translations t, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.mark_email_read_outlined,
            size: 48, color: context.colors.success),
        const SizedBox(height: 16),
        Text(t.forgotPassword.sentTitle,
            textAlign: TextAlign.center, style: text.titleLarge),
        const SizedBox(height: 8),
        Text(t.forgotPassword.sentBody,
            textAlign: TextAlign.center, style: text.bodyMedium),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.push('/reset-password'),
          child: Text(t.forgotPassword.haveCode),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(t.forgotPassword.backToLogin),
        ),
      ],
    );
  }
}
