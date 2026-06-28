import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

/// Oturum durumu.
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({required this.status, this.user, this.isBusy = false});

  final AuthStatus status;
  final AppUser? user;
  final bool isBusy;

  AuthState copyWith({AuthStatus? status, AppUser? user, bool? isBusy}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  static const initial = AuthState(status: AuthStatus.unknown);
}

/// Backend JWT auth ile oturum kontrolcüsü.
class AuthController extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  SecureStorage get _storage => ref.read(secureStorageProvider);

  @override
  AuthState build() {
    _restore();
    return AuthState.initial;
  }

  /// Açılışta: depolanan token varsa /me ile oturumu geri yükle.
  Future<void> _restore() async {
    try {
      final token = await _storage.readAccessToken();
      if (token == null || token.isEmpty) {
        state = const AuthState(status: AuthStatus.unauthenticated);
        return;
      }
      final user = await _repo.me();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      try {
        await _storage.clear();
      } catch (_) {}
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Giriş. Başarılıysa `null`, hatadaysa kullanıcıya gösterilecek mesaj döner.
  Future<String?> signIn(String email, String password) async {
    state = state.copyWith(isBusy: true);
    try {
      final result = await _repo.login(email.trim(), password);
      await _storage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
      return null;
    } on ApiException catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return e.message;
    }
  }

  /// Kayıt (Veli/Uzman). Başarılıysa `null`, hatadaysa mesaj döner.
  Future<String?> register({
    required String email,
    required String password,
    required String fullName,
    required bool kvkkConsent,
    UserRole role = UserRole.parent,
    String? phone,
    String? city,
    String? expertTitle,
    String? institution,
    String? licenseNumber,
    String? bio,
    List<String>? specializations,
  }) async {
    state = state.copyWith(isBusy: true);
    try {
      final result = await _repo.register(
        email: email.trim(),
        password: password,
        fullName: fullName.trim(),
        kvkkConsent: kvkkConsent,
        role: role,
        phone: phone,
        city: city,
        expertTitle: expertTitle,
        institution: institution,
        licenseNumber: licenseNumber,
        bio: bio,
        specializations: specializations,
      );
      await _storage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
      return null;
    } on ApiException catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return e.message;
    }
  }

  /// Profili günceller. Başarılıysa `null`, hatadaysa mesaj döner.
  Future<String?> updateProfile({
    String? fullName,
    String? phone,
    String? city,
    String? expertTitle,
    String? institution,
    String? licenseNumber,
    String? bio,
  }) async {
    try {
      final updated = await _repo.updateProfile(
        fullName: fullName,
        phone: phone,
        city: city,
        expertTitle: expertTitle,
        institution: institution,
        licenseNumber: licenseNumber,
        bio: bio,
      );
      state = state.copyWith(user: updated);
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    final rt = await _storage.readRefreshToken();
    if (rt != null && rt.isNotEmpty) {
      await _repo.logout(rt);
    }
    await _storage.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Refresh interceptor yenilemeyi başaramazsa çağrılır.
  void onSessionExpired() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
