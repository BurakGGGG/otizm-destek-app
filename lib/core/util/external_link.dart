import 'package:url_launcher/url_launcher.dart';

/// Dışarı açılabilecek şemalar. Bağlantıların bir kısmı uzmanın girdiği
/// serbest metinden geliyor (görüşme linki, ödev materyali, makale medyası);
/// `intent://`, `file://`, `market://` gibi şemaların cihazda başka bir
/// uygulamayı tetiklemesini istemiyoruz.
const Set<String> kAllowedLinkSchemes = {'http', 'https'};

/// Bağlantı dışarıda açılabilir mi? (Yalnızca http/https.)
bool isSafeExternalLink(String? raw) => safeExternalUri(raw) != null;

/// Güvenliyse çözümlenmiş adresi, değilse `null` döner.
Uri? safeExternalUri(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  final uri = Uri.tryParse(value);
  if (uri == null || !uri.hasScheme) return null;
  if (!kAllowedLinkSchemes.contains(uri.scheme.toLowerCase())) return null;
  if (uri.host.isEmpty) return null;
  return uri;
}

/// Bağlantıyı tarayıcıda/harici uygulamada açar. Şema güvenli değilse hiçbir
/// şey yapmaz ve `false` döner (arayüz kullanıcıya hata gösterebilir).
Future<bool> openExternalLink(String? raw) async {
  final uri = safeExternalUri(raw);
  if (uri == null) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
