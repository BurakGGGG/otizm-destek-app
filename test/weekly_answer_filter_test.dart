import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/community/domain/weekly_question.dart';

/// Haftanın Sorusu cevap süzgeçleri (web `filteredAnswers` ile aynı kurallar).
void main() {
  WeeklyAnswer answer({
    required String id,
    required String text,
    String author = 'Veli',
    String? city,
    String? role,
    String? title,
    int likes = 0,
    bool anonymous = false,
  }) =>
      WeeklyAnswer(
        id: id,
        author: author,
        rawText: WeeklyAnswer.encode(text: text, anonymous: anonymous),
        city: city,
        authorRole: role,
        expertTitle: title,
        likes: likes,
      );

  final list = [
    answer(id: '1', text: 'Sabah rutini işe yaradı', city: 'İzmir', likes: 2),
    answer(
      id: '2',
      text: 'Duyusal mola öneriyorum',
      author: 'Uzm. Psk. Selin',
      role: 'EXPERT',
      title: 'Klinik Psikolog',
      city: 'İstanbul',
      likes: 9,
    ),
    answer(
      id: '3',
      text: 'Bizde kulaklık çok işe yarıyor',
      author: 'Ayşe',
      city: 'İzmir',
      likes: 5,
      anonymous: true,
    ),
  ];

  test('varsayılan süzgeç hepsini sırayla verir', () {
    final result = filterWeeklyAnswers(list);
    expect(result.map((a) => a.id), ['1', '2', '3']);
  });

  test('uzman süzgeci yalnızca uzman cevaplarını verir', () {
    final result =
        filterWeeklyAnswers(list, filter: WeeklyAnswerFilter.expert);
    expect(result.map((a) => a.id), ['2']);
  });

  test('popüler süzgeci beğeniye göre sıralar', () {
    final result =
        filterWeeklyAnswers(list, filter: WeeklyAnswerFilter.popular);
    expect(result.map((a) => a.id), ['2', '3', '1']);
  });

  test('şehrim süzgeci anonim cevapları dışarıda bırakır', () {
    final result = filterWeeklyAnswers(
      list,
      filter: WeeklyAnswerFilter.local,
      userCity: 'izmir',
    );
    expect(result.map((a) => a.id), ['1']);
  });

  test('şehir bilgisi yoksa şehrim süzgeci anonimleri eler, kalanı verir', () {
    final result =
        filterWeeklyAnswers(list, filter: WeeklyAnswerFilter.local);
    expect(result.map((a) => a.id), ['1', '2']);
  });

  test('arama metne, uzman unvanına ve şehre bakar', () {
    expect(filterWeeklyAnswers(list, query: 'kulaklık').map((a) => a.id),
        ['3']);
    expect(filterWeeklyAnswers(list, query: 'klinik').map((a) => a.id), ['2']);
    expect(filterWeeklyAnswers(list, query: 'izmir').map((a) => a.id), ['1']);
  });

  test('anonim cevapta yazar ve şehir aramaya girmez', () {
    // 3 numaralı cevap anonim: adı "Ayşe" ve şehri "İzmir" eşleşmemeli.
    expect(filterWeeklyAnswers(list, query: 'ayşe'), isEmpty);
    final byCity = filterWeeklyAnswers(list, query: 'izmir');
    expect(byCity.map((a) => a.id), isNot(contains('3')));
  });
}
