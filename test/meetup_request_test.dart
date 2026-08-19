import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/similar_families/domain/meetup_request.dart';

void main() {
  MeetupRequest request({
    String requesterId = 'me',
    String status = kMeetupRequestPending,
  }) {
    return MeetupRequest.fromJson({
      'id': 'r1',
      'requesterId': requesterId,
      'requesterName': 'Elif Y.',
      'recipientId': 'other',
      'recipientName': 'Zeynep A.',
      'type': 'YUZEYUZE',
      'proposedDate': '2026-09-02',
      'proposedTime': '15:00',
      'location': 'Kadıköy Parkı',
      'message': 'Çocuklar birlikte oynayabilir.',
      'status': status,
    });
  }

  group('aileler arası buluşma isteği', () {
    test('alanlar okunur', () {
      final r = request();
      expect(r.type, kMeetupRequestInPerson);
      expect(r.proposedDate, '2026-09-02');
      expect(r.proposedTime, '15:00');
      expect(r.location, 'Kadıköy Parkı');
      expect(r.isPending, isTrue);
    });

    test('gönderen bense karşı taraf alıcıdır', () {
      final r = request();
      expect(r.sentByMe('me'), isTrue);
      expect(r.otherName('me'), 'Zeynep A.');
    });

    test('bana gelen istekte karşı taraf gönderendir', () {
      final r = request(requesterId: 'other');
      expect(r.sentByMe('me'), isFalse);
      expect(r.otherName('me'), 'Elif Y.');
    });

    test('bekleyen olmayan istek şeritte gösterilmez', () {
      expect(request(status: kMeetupRequestAccepted).isPending, isFalse);
      expect(request(status: kMeetupRequestCancelled).isPending, isFalse);
    });

    test('eksik tür varsayılanı online', () {
      final r = MeetupRequest.fromJson({'id': 'x'});
      expect(r.type, kMeetupRequestOnline);
      expect(r.status, kMeetupRequestPending);
    });
  });
}
