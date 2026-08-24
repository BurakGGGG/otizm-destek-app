/// Backend kullanıcı rolü (backend: PARENT, EXPERT, ADMIN).
enum UserRole {
  parent,
  expert,
  admin,
  unknown;

  static UserRole fromBackend(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'PARENT':
        return UserRole.parent;
      case 'EXPERT':
        return UserRole.expert;
      case 'ADMIN':
        return UserRole.admin;
      default:
        return UserRole.unknown;
    }
  }

  /// Backend'e gönderilecek değer (register).
  String get backendValue => switch (this) {
    UserRole.expert => 'EXPERT',
    UserRole.admin => 'ADMIN',
    _ => 'PARENT',
  };
}

/// Oturum açmış kullanıcı — backend `UserDto` karşılığı.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phone,
    this.city,
    this.allowDirectMessages = true,
    this.allowFamilyMessages = true,
    this.hideOnlineStatus = false,
    this.approximateLocationOnly = true,
    this.communicationPreferences = const [],
    this.supportIntents = const [],
    this.expertTitle,
    this.institution,
    this.licenseNumber,
    this.bio,
    this.profileImageUrl,
    this.verified = false,
    this.emailVerified = true,
    this.onboardingCompleted = true,
    this.specializations = const [],
  });

  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? phone;
  final String? city;

  /// Sunucuda saklanan gizlilik/eşleşme tercihleri (web Ayarlar > Gizlilik).
  final bool allowDirectMessages;
  final bool allowFamilyMessages;
  final bool hideOnlineStatus;
  final bool approximateLocationOnly;

  /// İletişim tercihi kodları (YAZISMA/GORUNTULU/AKSAM) — veri,
  /// çevrilmez.
  final List<String> communicationPreferences;

  /// Toplulukta ne arıyor (DENEYIM_PAYLASIMI/…) — veri, çevrilmez.
  final List<String> supportIntents;
  final String? expertTitle;
  final String? institution;
  final String? licenseNumber;
  final String? bio;
  final String? profileImageUrl;

  /// Uzman hesabının yönetici onayı (veli hesaplarında anlamsız).
  final bool verified;

  /// E-posta doğrulandı mı? Backend `REQUIRE_EMAIL_VERIFICATION` kapalıysa
  /// kayıtta zaten `true` gelir; alan yoksa doğrulanmış sayılır.
  final bool emailVerified;

  /// İlk giriş sihirbazı tamamlandı mı? (`POST /users/me/onboarding-complete`)
  /// Alan gelmeyen eski yanıtlarda sihirbazı tekrar açmamak için `true`.
  final bool onboardingCompleted;

  final List<String> specializations;

  /// Görünen ad (UI selamlama vb.).
  String get displayName => fullName;

  AppUser copyWith({bool? emailVerified, bool? onboardingCompleted}) {
    return AppUser(
      id: id,
      email: email,
      fullName: fullName,
      role: role,
      phone: phone,
      city: city,
      allowDirectMessages: allowDirectMessages,
      allowFamilyMessages: allowFamilyMessages,
      hideOnlineStatus: hideOnlineStatus,
      approximateLocationOnly: approximateLocationOnly,
      communicationPreferences: communicationPreferences,
      supportIntents: supportIntents,
      expertTitle: expertTitle,
      institution: institution,
      licenseNumber: licenseNumber,
      bio: bio,
      profileImageUrl: profileImageUrl,
      verified: verified,
      emailVerified: emailVerified ?? this.emailVerified,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      specializations: specializations,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      role: UserRole.fromBackend(json['role'] as String?),
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      allowDirectMessages: json['allowDirectMessages'] != false,
      allowFamilyMessages: json['allowFamilyMessages'] != false,
      hideOnlineStatus: json['hideOnlineStatus'] == true,
      approximateLocationOnly: json['approximateLocationOnly'] != false,
      communicationPreferences: _stringList(json['communicationPreferences']),
      supportIntents: _stringList(json['supportIntents']),
      expertTitle: json['expertTitle'] as String?,
      institution: json['institution'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      verified: json['verified'] as bool? ?? false,
      emailVerified: json['emailVerified'] as bool? ?? true,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? true,
      specializations:
          (json['specializations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

/// JSON dizisini güvenle string listesine çevirir.
List<String> _stringList(dynamic value) => value is List
    ? value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
    : const [];
