import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';

/// Hesap bilgileri — `PUT /api/users/me` ile düzenlenebilir profil.
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  late final TextEditingController _city;
  late final TextEditingController _expertTitle;
  late final TextEditingController _institution;
  late final TextEditingController _licenseNumber;
  late final TextEditingController _bio;

  bool _saving = false;
  String? _fullNameError;

  @override
  void initState() {
    super.initState();
    final u = ref.read(authControllerProvider).user;
    _fullName = TextEditingController(text: u?.fullName ?? '');
    _phone = TextEditingController(text: u?.phone ?? '');
    _city = TextEditingController(text: u?.city ?? '');
    _expertTitle = TextEditingController(text: u?.expertTitle ?? '');
    _institution = TextEditingController(text: u?.institution ?? '');
    _licenseNumber = TextEditingController(text: u?.licenseNumber ?? '');
    _bio = TextEditingController(text: u?.bio ?? '');
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _city.dispose();
    _expertTitle.dispose();
    _institution.dispose();
    _licenseNumber.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = context.t;
    if (_fullName.text.trim().length < 2) {
      setState(() => _fullNameError = t.account.errorFullName);
      return;
    }
    setState(() {
      _fullNameError = null;
      _saving = true;
    });

    final isExpert =
        ref.read(authControllerProvider).user?.role == UserRole.expert;
    final error = await ref
        .read(authControllerProvider.notifier)
        .updateProfile(
          fullName: _fullName.text.trim(),
          phone: _phone.text.trim(),
          city: _city.text.trim(),
          expertTitle: isExpert ? _expertTitle.text.trim() : null,
          institution: isExpert ? _institution.text.trim() : null,
          licenseNumber: isExpert ? _licenseNumber.text.trim() : null,
          bio: isExpert ? _bio.text.trim() : null,
        );

    if (!mounted) return;
    setState(() => _saving = false);
    final messenger = ScaffoldMessenger.of(context);
    if (error == null) {
      Haptics.success();
      messenger.showSnackBar(SnackBar(content: Text(t.account.saved)));
      Navigator.of(context).pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final user = ref.watch(authControllerProvider).user;
    final isExpert = user?.role == UserRole.expert;

    return Scaffold(
      appBar: AppBar(title: Text(t.account.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            // E-posta (salt okunur) — TextFormField kendi controller'ını yönetir.
            TextFormField(
              initialValue: user?.email ?? '',
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                labelText: t.account.emailLabel,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fullName,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t.account.fullNameLabel,
                errorText: _fullNameError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: t.account.phoneLabel,
                hintText: t.account.phoneHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _city,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: t.account.cityLabel),
            ),
            if (isExpert) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _expertTitle,
                decoration: InputDecoration(
                  labelText: t.account.expertTitleLabel,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _institution,
                decoration: InputDecoration(
                  labelText: t.account.institutionLabel,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _licenseNumber,
                decoration: InputDecoration(
                  labelText: t.account.licenseNumberLabel,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bio,
                minLines: 2,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: t.account.bioLabel,
                  hintText: t.account.bioHint,
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.account.save),
            ),
          ],
        ),
      ),
    );
  }
}
