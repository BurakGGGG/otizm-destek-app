import 'package:flutter/services.dart';

/// Hafif dokunsal geri bildirim sarmalayıcısı. Düşük uyarımlı tasarım ilkesine
/// uygun: görsel gösteri yerine ince dokunsal ipuçları. Tek noktadan yönetilir
/// (ileride erişilebilirlik için topluca kapatılabilir).
class Haptics {
  const Haptics._();

  /// Seçim/gezinme (ör. sekme değişimi).
  static void selection() => HapticFeedback.selectionClick();

  /// Başarılı işlem (ör. kayıt oluşturuldu).
  static void success() => HapticFeedback.mediumImpact();

  /// Yıkıcı/uyarı eylemi (ör. sil/iptal).
  static void warning() => HapticFeedback.lightImpact();
}
