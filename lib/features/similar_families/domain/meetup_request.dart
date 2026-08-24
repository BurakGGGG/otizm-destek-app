/// Aileler arası buluşma isteği türleri — backend'e yazılan kodlar
/// (web `MeetupRequestDto.type` birebir; veri, çevrilmez).
const String kMeetupRequestOnline = 'ONLINE';
const String kMeetupRequestInPerson = 'YUZEYUZE';

/// Durum kodları.
const String kMeetupRequestPending = 'PENDING';
const String kMeetupRequestAccepted = 'ACCEPTED';
const String kMeetupRequestDeclined = 'DECLINED';
const String kMeetupRequestCancelled = 'CANCELLED';

/// `GET /api/meetup-requests` — kullanıcının gönderdiği + aldığı istekler.
class MeetupRequest {
  const MeetupRequest({
    required this.id,
    required this.requesterId,
    required this.recipientId,
    required this.type,
    required this.proposedDate,
    required this.proposedTime,
    this.requesterName,
    this.recipientName,
    this.location,
    this.message,
    this.status = kMeetupRequestPending,
  });

  final String id;
  final String requesterId;
  final String recipientId;

  /// ONLINE | YUZEYUZE
  final String type;

  /// `yyyy-MM-dd` (LocalDate) ve `HH:mm`.
  final String proposedDate;
  final String proposedTime;
  final String? requesterName;
  final String? recipientName;
  final String? location;
  final String? message;
  final String status;

  bool get isPending => status == kMeetupRequestPending;

  /// İsteği ben mi gönderdim? (Gelen isteklerde onay/ret, giden isteklerde
  /// iptal gösterilir.)
  bool sentByMe(String? userId) => userId != null && requesterId == userId;

  /// Karşı tarafın adı.
  String? otherName(String? userId) =>
      sentByMe(userId) ? recipientName : requesterName;

  factory MeetupRequest.fromJson(Map<String, dynamic> json) {
    return MeetupRequest(
      id: json['id']?.toString() ?? '',
      requesterId: json['requesterId']?.toString() ?? '',
      recipientId: json['recipientId']?.toString() ?? '',
      type: json['type'] as String? ?? kMeetupRequestOnline,
      proposedDate: json['proposedDate']?.toString() ?? '',
      proposedTime: json['proposedTime']?.toString() ?? '',
      requesterName: json['requesterName'] as String?,
      recipientName: json['recipientName'] as String?,
      location: json['location'] as String?,
      message: json['message'] as String?,
      status: json['status'] as String? ?? kMeetupRequestPending,
    );
  }
}
