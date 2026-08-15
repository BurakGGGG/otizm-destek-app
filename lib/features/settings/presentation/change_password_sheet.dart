import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/password_rules.dart';
import '../../../core/widgets/password_strength_meter.dart';
import '../../../i18n/strings.g.dart';
import '../data/settings_repository.dart';

/// Şifre değiştirme formu — `POST /users/change-password`.
class ChangePasswordSheet extends ConsumerStatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  ConsumerState<ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<ChangePasswordSheet> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    if (_current.text.isEmpty) {
      setState(() => _error = t.settings.errorCurrentPasswordRequired);
      return;
    }
    if (validatePassword(_next.text) case final issue?) {
      setState(() => _error = passwordIssueMessage(context, issue));
      return;
    }
    if (_next.text != _confirm.text) {
      setState(() => _error = t.resetPassword.errorMismatch);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await ref
          .read(settingsRepositoryProvider)
          .changePassword(
            currentPassword: _current.text,
            newPassword: _next.text,
          );
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.settings.passwordChanged)));
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.settings.changePassword, style: text.titleMedium),
          const SizedBox(height: 16),
          TextField(
            controller: _current,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: t.settings.currentPasswordLabel,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _next,
            obscureText: _obscure,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: t.settings.newPasswordLabel,
              prefixIcon: const Icon(Icons.lock_reset_outlined),
            ),
          ),
          PasswordStrengthMeter(password: _next.text),
          const SizedBox(height: 16),
          TextField(
            controller: _confirm,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: t.resetPassword.confirmLabel,
              prefixIcon: const Icon(Icons.lock_reset_outlined),
              errorText: _error,
              errorMaxLines: 3,
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
                : Text(t.settings.changePasswordSubmit),
          ),
        ],
      ),
    );
  }
}
