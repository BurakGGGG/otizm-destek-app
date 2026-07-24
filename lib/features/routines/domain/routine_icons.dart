import 'package:flutter/material.dart';

/// Rutin adımı ikon adı (backend serbest string) ↔ Material ikon eşlemesi.
/// Picker bu anahtarları gösterir; backend'e `iconName` olarak kaydedilir.
const Map<String, IconData> kRoutineIcons = {
  'morning': Icons.wb_sunny_outlined,
  'meal': Icons.restaurant_outlined,
  'school': Icons.school_outlined,
  'play': Icons.sports_esports_outlined,
  'bath': Icons.bathtub_outlined,
  'brush': Icons.cleaning_services_outlined,
  'book': Icons.menu_book_outlined,
  'walk': Icons.directions_walk_outlined,
  'medicine': Icons.medication_outlined,
  'sleep': Icons.bedtime_outlined,
};

/// İkon adından Material ikon (bilinmiyorsa varsayılan).
IconData routineIconFor(String? name) {
  return kRoutineIcons[name] ?? Icons.check_circle_outline;
}
