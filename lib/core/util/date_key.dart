/// Yerel (cihaz saati) gün anahtarı — `yyyy-MM-dd`.
///
/// Backend `LocalDate` alanları (ruh hali `entryDate`, görev `dueDate` vb.)
/// saat dilimsizdir; UTC'ye çevirmek gece yarısı civarında günü kaydırır.
String localDateKey(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}
