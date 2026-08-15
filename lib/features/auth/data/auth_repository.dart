import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/auth_cookies.dart';
import '../../../core/providers.dart';
import '../../../i18n/strings.g.dart';
import '../domain/app_user.dart';

/// Kimlik doğrulama yanıtı: kullanıcı + token çifti ya da bekleme durumu.
///
/// Backend her zaman oturum açmaz: e-posta doğrulaması istendiğinde ya da
/// uzman hesabı yönetici onayı beklediğinde token'sız yanıt döner
/// (`pendingEmailVerification` / `pendingApproval`).
class AuthResult {
  const AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.pendingEmailVerification = false,
    this.pendingApproval = false,
    this.mfaRequired = false,
  });

  final AppUser user;
  final String accessToken;
  final String refreshToken;
  final bool pendingEmailVerification;
  final bool pendingApproval;
  final bool mfaRequired;

  /// Oturum açılabildi mi? (Token yoksa kullanıcı henüz giriş yapamaz.)
  bool get hasSession => accessToken.isNotEmpty;

  /// Yanıtı çözer. Refresh token gövdede yoksa `Set-Cookie` başlığından
  /// okunur (backend onu yalnızca httpOnly çerezle döndürüyor).
  factory AuthResult.fromResponse(Response<dynamic> res) {
    final data = ApiEnvelope.fromJson(res.data).requireMap();
    final userJson = data['user'];
    if (userJson is! Map<String, dynamic>) {
      throw ApiException(t.errors.noUserInResponse);
    }
    final bodyRefresh = data['refreshToken'] as String?;
    return AuthResult(
      user: AppUser.fromJson(userJson),
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: (bodyRefresh != null && bodyRefresh.isNotEmpty)
          ? bodyRefresh
          : refreshTokenFromHeaders(res.headers) ?? '',
      pendingEmailVerification:
          data['pendingEmailVerification'] as bool? ?? false,
      pendingApproval: data['pendingApproval'] as bool? ?? false,
      mfaRequired: data['mfaRequired'] as bool? ?? false,
    );
  }
}

/// Backend JWT auth uç noktalarını saran depo (`/api/auth/*`).
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  static final _noAuth = Options(extra: {'skipAuth': true});

  Future<AuthResult> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
        options: _noAuth,
      );
      return AuthResult.fromResponse(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<AuthResult> register({
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
    try {
      final res = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'kvkkConsent': kvkkConsent,
          'role': role.backendValue,
          'phone': ?phone,
          'city': ?city,
          'expertTitle': ?expertTitle,
          'institution': ?institution,
          'licenseNumber': ?licenseNumber,
          'bio': ?bio,
          'specializations': ?specializations,
        },
        options: _noAuth,
      );
      return AuthResult.fromResponse(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Mevcut oturumu doğrular (token geçerliyse kullanıcıyı döndürür).
  Future<AppUser> me() async {
    try {
      final res = await _dio.get('/auth/me');
      return AppUser.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Profili günceller — `PUT /api/users/me`. Yalnız verilen (null olmayan)
  /// alanlar değiştirilir; güncel kullanıcı döner.
  Future<AppUser> updateProfile({
    String? fullName,
    String? phone,
    String? city,
    String? expertTitle,
    String? institution,
    String? licenseNumber,
    String? bio,
  }) async {
    try {
      final res = await _dio.put(
        '/users/me',
        data: {
          'fullName': ?fullName,
          'phone': ?phone,
          'city': ?city,
          'expertTitle': ?expertTitle,
          'institution': ?institution,
          'licenseNumber': ?licenseNumber,
          'bio': ?bio,
        },
      );
      return AppUser.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Şifre sıfırlama bağlantısı ister (`POST /auth/forgot-password`).
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
        options: _noAuth,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Token + yeni şifre ile sıfırlar (`POST /auth/reset-password`).
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/auth/reset-password',
        data: {'token': token, 'password': password},
        options: _noAuth,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// İlk giriş sihirbazını tamamlandı olarak işaretler
  /// (`POST /users/me/onboarding-complete`) ve güncel kullanıcıyı döner.
  Future<AppUser> completeOnboarding() async {
    try {
      final res = await _dio.post('/users/me/onboarding-complete');
      return AppUser.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// E-postadaki doğrulama kodunu onaylar (`POST /auth/verify-email`).
  Future<void> verifyEmail(String token) async {
    try {
      await _dio.post(
        '/auth/verify-email',
        data: {'token': token},
        options: _noAuth,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Doğrulama e-postasını yeniden gönderir (`POST /auth/resend-verification`).
  /// Backend saatte 3 istekle sınırlar ve hesap yoksa da başarı döner.
  Future<void> resendVerification(String email) async {
    try {
      await _dio.post(
        '/auth/resend-verification',
        data: {'email': email},
        options: _noAuth,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// E-posta adresi kayıt için uygun mu? (`GET /auth/check-email`)
  /// Ağ hatasında kayıt akışını engellememek için `null` döner.
  Future<bool?> isEmailAvailable(String email) async {
    try {
      final res = await _dio.get(
        '/auth/check-email',
        queryParameters: {'email': email},
        options: _noAuth,
      );
      return ApiEnvelope.fromJson(res.data).requireMap()['available'] as bool?;
    } on DioException catch (_) {
      return null;
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
    } on DioException catch (_) {
      // Çıkışta sunucu hatası kullanıcıyı engellememeli.
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});
