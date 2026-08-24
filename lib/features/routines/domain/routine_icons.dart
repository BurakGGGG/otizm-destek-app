import 'package:flutter/material.dart';

/// Rutin adımı ikon adı ↔ Material ikon eşlemesi.
///
/// **Anahtarlar paylaşılan veridir:** backend'e `iconName` olarak yazılır ve
/// web aynı değerleri emojiye çevirir (`ICON_OPTIONS`, RoutinesPage). Bu yüzden
/// liste web ile birebir aynı sırada ve aynı değerlerle tutulur — çevrilmez,
/// yeniden adlandırılmaz. Karşılığı olmayan bir değer gelirse nötr bir ikon
/// çizilir (web'de "•").
const Map<String, IconData> kRoutineIcons = {
  'morning': Icons.wb_sunny_outlined, // 🌅 Sabah
  'eat': Icons.restaurant_outlined, // 🍽️ Yemek
  'brush': Icons.cleaning_services_outlined, // 🪥 Diş fırçalama
  'shower': Icons.shower_outlined, // 🚿 Banyo
  'dress': Icons.checkroom_outlined, // 👕 Giyinme
  'school': Icons.school_outlined, // 🎒 Okul
  'homework': Icons.menu_book_outlined, // 📚 Ödev
  'play': Icons.sports_esports_outlined, // 🎮 Oyun
  'sleep': Icons.bedtime_outlined, // 🌙 Uyku
  'medicine': Icons.medication_outlined, // 💊 İlaç
  'walk': Icons.directions_walk_outlined, // 🚶 Yürüyüş
  'therapy': Icons.extension_outlined, // 🧩 Terapi
};

/// İkon adından Material ikon (bilinmiyorsa nötr işaret).
IconData routineIconFor(String? name) {
  return kRoutineIcons[name] ?? Icons.circle_outlined;
}
