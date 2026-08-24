/// KVKK rıza türleri — backend `ConsentType` enum kodları (veri, çevrilmez).
class ConsentTypes {
  const ConsentTypes._();

  static const String notice = 'KVKK_AYDINLATMA';
  static const String aiAnalysis = 'AI_ANALIZ';
  static const String emergencyCard = 'ACIL_DURUM_KARTI';
  static const String matching = 'ESLESTIRME';
  static const String marketing = 'PAZARLAMA_ILETISIMI';

  /// Ayarlarda gösterilecek sıra (aydınlatma metni ayrı ele alınır).
  static const List<String> toggleable = [
    aiAnalysis,
    emergencyCard,
    matching,
    marketing,
  ];
}

/// Veri sahibi başvuru türleri — backend `RequestType` kodları.
class KvkkRequestTypes {
  const KvkkRequestTypes._();

  static const String info = 'BILGI_TALEBI';
  static const String correction = 'DUZELTME';
  static const String deletion = 'SILME';
  static const String transfer = 'AKTARIM_BILGISI';
  static const String objection = 'ISLEMEYE_ITIRAZ';
  static const String damages = 'ZARARIN_GIDERILMESI';

  static const List<String> all = [
    info,
    correction,
    deletion,
    transfer,
    objection,
    damages,
  ];
}

/// Rıza durumu özeti — `GET /users/me/consents`.
class ConsentOverview {
  const ConsentOverview({
    required this.current,
    required this.policyVersion,
    this.acceptedPolicyVersion,
    this.requiresReconsent = false,
    this.history = const [],
  });

  final Map<String, bool> current;
  final String policyVersion;
  final String? acceptedPolicyVersion;
  final bool requiresReconsent;
  final List<ConsentHistoryEntry> history;

  bool granted(String type) => current[type] ?? false;

  factory ConsentOverview.fromJson(Map<String, dynamic> json) {
    final current = <String, bool>{};
    final rawCurrent = json['current'];
    if (rawCurrent is Map) {
      rawCurrent.forEach((key, value) {
        current[key.toString()] = value == true;
      });
    }
    final rawHistory = json['history'];
    return ConsentOverview(
      current: current,
      policyVersion: json['policyVersion']?.toString() ?? '',
      acceptedPolicyVersion: json['acceptedPolicyVersion']?.toString(),
      requiresReconsent: json['requiresReconsent'] == true,
      history: rawHistory is List
          ? rawHistory
                .whereType<Map<String, dynamic>>()
                .map(ConsentHistoryEntry.fromJson)
                .toList()
          : const [],
    );
  }
}

/// Rıza defteri kaydı (değiştirilemez geçmiş).
class ConsentHistoryEntry {
  const ConsentHistoryEntry({
    required this.consentType,
    required this.granted,
    this.policyVersion,
    this.source,
    this.createdAt,
  });

  final String consentType;
  final bool granted;
  final String? policyVersion;
  final String? source;
  final DateTime? createdAt;

  factory ConsentHistoryEntry.fromJson(Map<String, dynamic> json) {
    return ConsentHistoryEntry(
      consentType: json['consentType']?.toString() ?? '',
      granted: json['granted'] == true,
      policyVersion: json['policyVersion']?.toString(),
      source: json['source']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}

/// Veri sahibi başvurusu — `GET/POST /kvkk/requests`.
class KvkkRequest {
  const KvkkRequest({
    required this.id,
    required this.requestType,
    required this.status,
    this.description = '',
    this.response,
    this.createdAt,
    this.dueAt,
    this.overdue = false,
  });

  final String id;
  final String requestType;
  final String status;
  final String description;
  final String? response;
  final DateTime? createdAt;
  final DateTime? dueAt;
  final bool overdue;

  factory KvkkRequest.fromJson(Map<String, dynamic> json) {
    return KvkkRequest(
      id: json['id']?.toString() ?? '',
      requestType: json['requestType']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      response: json['response']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      dueAt: DateTime.tryParse(json['dueAt']?.toString() ?? ''),
      overdue: json['overdue'] == true,
    );
  }
}
