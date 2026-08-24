import 'package:dio/dio.dart';

/// Backend'in refresh token'ı taşıdığı httpOnly çerezin adı.
const String kRefreshCookieName = 'refresh_token';

/// Dio başlık adlarını küçük harfe indirger.
const String _kSetCookieHeader = 'set-cookie';

/// `Set-Cookie` başlıklarından refresh token'ı ayıklar.
///
/// Backend `AuthResponse.refreshToken` alanını `@JsonIgnore` ile gövdeden
/// çıkardı; token yalnızca `refresh_token` httpOnly çerezinde dönüyor
/// (`Path=/api/auth`). Tarayıcı çerezi kendi saklar, mobil istemci ise
/// başlıktan okuyup güvenli depoya yazmak zorunda. Token her yenilemede
/// yeniden üretildiği (öncekiler tek kullanımlık) için yenileme yanıtlarında
/// da okunmalıdır.
///
/// Silme yanıtlarında (`refresh_token=; Max-Age=0`) değer boş olduğundan
/// `null` döner.
String? refreshTokenFromHeaders(Headers headers) {
  final cookies = headers[_kSetCookieHeader];
  if (cookies == null) return null;
  for (final raw in cookies) {
    final token = refreshTokenFromSetCookie(raw);
    if (token != null) return token;
  }
  return null;
}

/// Tek bir `Set-Cookie` satırından refresh token değerini okur.
String? refreshTokenFromSetCookie(String header) {
  // Bazı sunucular birden fazla çerezi tek satırda virgülle birleştirir;
  // `Expires` içindeki virgül nedeniyle naif bölme yapılmaz, ad=değer aranır.
  final match = RegExp(
    '(?:^|[;,]\\s*)$kRefreshCookieName=([^;,\\s]+)',
  ).firstMatch(header);
  final value = match?.group(1);
  return (value == null || value.isEmpty) ? null : value;
}
