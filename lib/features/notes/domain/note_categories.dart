/// Gelişim notu kategorileri — web NotesPage `categories` dizisiyle **birebir**
/// aynı Türkçe değerler. Paylaşılan DB'de saklanan VERİdir, uygulama diline
/// göre değişmez (goal kategorilerinden ayrıdır: web notlar için bu kümeyi
/// kullanır).
const List<String> kNoteCategories = [
  'Dil Gelişimi',
  'Sosyal Beceri',
  'Motor Gelişim',
  'Davranış',
  'Eğitim',
  'Genel',
];

/// Gelişim notu ruh hâli kodları — web NotesPage `moods` ile **birebir**
/// (`happy` / `neutral` / `sad`). Paylaşılan VERİ, çevrilmez.
const List<String> kNoteMoods = ['happy', 'neutral', 'sad'];
