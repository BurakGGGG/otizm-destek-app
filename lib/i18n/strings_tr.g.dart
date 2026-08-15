///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsTr = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$tr app = Translations$app$tr.internal(_root);
	late final Translations$common$tr common = Translations$common$tr.internal(_root);
	late final Translations$language$tr language = Translations$language$tr.internal(_root);
	late final Translations$theme$tr theme = Translations$theme$tr.internal(_root);
	late final Translations$roles$tr roles = Translations$roles$tr.internal(_root);
	late final Translations$auth$tr auth = Translations$auth$tr.internal(_root);
	late final Translations$verifyEmail$tr verifyEmail = Translations$verifyEmail$tr.internal(_root);
	late final Translations$forgotPassword$tr forgotPassword = Translations$forgotPassword$tr.internal(_root);
	late final Translations$resetPassword$tr resetPassword = Translations$resetPassword$tr.internal(_root);
	late final Translations$password$tr password = Translations$password$tr.internal(_root);
	late final Translations$register$tr register = Translations$register$tr.internal(_root);
	late final Translations$settings$tr settings = Translations$settings$tr.internal(_root);
	late final Translations$legal$tr legal = Translations$legal$tr.internal(_root);
	late final Translations$kvkk$tr kvkk = Translations$kvkk$tr.internal(_root);
	late final Translations$onboarding$tr onboarding = Translations$onboarding$tr.internal(_root);
	late final Translations$nav$tr nav = Translations$nav$tr.internal(_root);
	late final Translations$chat$tr chat = Translations$chat$tr.internal(_root);
	late final Translations$messages$tr messages = Translations$messages$tr.internal(_root);
	late final Translations$home$tr home = Translations$home$tr.internal(_root);
	late final Translations$specialists$tr specialists = Translations$specialists$tr.internal(_root);
	late final Translations$progress$tr progress = Translations$progress$tr.internal(_root);
	late final Translations$goalForm$tr goalForm = Translations$goalForm$tr.internal(_root);
	late final Translations$noteForm$tr noteForm = Translations$noteForm$tr.internal(_root);
	late final Translations$notesPage$tr notesPage = Translations$notesPage$tr.internal(_root);
	late final Translations$notifications$tr notifications = Translations$notifications$tr.internal(_root);
	late final Translations$knowledge$tr knowledge = Translations$knowledge$tr.internal(_root);
	late final Translations$appointments$tr appointments = Translations$appointments$tr.internal(_root);
	late final Translations$expertDetail$tr expertDetail = Translations$expertDetail$tr.internal(_root);
	late final Translations$booking$tr booking = Translations$booking$tr.internal(_root);
	late final Translations$routines$tr routines = Translations$routines$tr.internal(_root);
	late final Translations$routineForm$tr routineForm = Translations$routineForm$tr.internal(_root);
	late final Translations$dailyTracker$tr dailyTracker = Translations$dailyTracker$tr.internal(_root);
	late final Translations$sleep$tr sleep = Translations$sleep$tr.internal(_root);
	late final Translations$meds$tr meds = Translations$meds$tr.internal(_root);
	late final Translations$wall$tr wall = Translations$wall$tr.internal(_root);
	late final Translations$weekly$tr weekly = Translations$weekly$tr.internal(_root);
	late final Translations$meetup$tr meetup = Translations$meetup$tr.internal(_root);
	late final Translations$similar$tr similar = Translations$similar$tr.internal(_root);
	late final Translations$groups$tr groups = Translations$groups$tr.internal(_root);
	late final Translations$treatment$tr treatment = Translations$treatment$tr.internal(_root);
	late final Translations$tasks$tr tasks = Translations$tasks$tr.internal(_root);
	late final Translations$forum$tr forum = Translations$forum$tr.internal(_root);
	late final Translations$childDetail$tr childDetail = Translations$childDetail$tr.internal(_root);
	late final Translations$crisis$tr crisis = Translations$crisis$tr.internal(_root);
	late final Translations$calendar$tr calendar = Translations$calendar$tr.internal(_root);
	late final Translations$emergency$tr emergency = Translations$emergency$tr.internal(_root);
	late final Translations$behavior$tr behavior = Translations$behavior$tr.internal(_root);
	late final Translations$analytics$tr analytics = Translations$analytics$tr.internal(_root);
	late final Translations$children$tr children = Translations$children$tr.internal(_root);
	late final Translations$account$tr account = Translations$account$tr.internal(_root);
	late final Translations$help$tr help = Translations$help$tr.internal(_root);
	late final Translations$profile$tr profile = Translations$profile$tr.internal(_root);
	late final Translations$errors$tr errors = Translations$errors$tr.internal(_root);
}

// Path: app
class Translations$app$tr {
	Translations$app$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Otizm Destek'
	String get name => 'Otizm Destek';
}

// Path: common
class Translations$common$tr {
	Translations$common$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Vazgeç'
	String get cancel => 'Vazgeç';

	/// tr: 'Yükleniyor'
	String get loading => 'Yükleniyor';

	/// tr: 'Bu bölüm yakında eklenecek.'
	String get comingSoon => 'Bu bölüm yakında eklenecek.';

	/// tr: 'Tümünü Gör'
	String get seeAll => 'Tümünü Gör';

	/// tr: 'Daha Fazla'
	String get more => 'Daha Fazla';

	/// tr: 'Tekrar Dene'
	String get retry => 'Tekrar Dene';

	/// tr: 'Veriler yüklenemedi.'
	String get loadError => 'Veriler yüklenemedi.';

	List<String> get monthsShort => [
		'Oca',
		'Şub',
		'Mar',
		'Nis',
		'May',
		'Haz',
		'Tem',
		'Ağu',
		'Eyl',
		'Eki',
		'Kas',
		'Ara',
	];
}

// Path: language
class Translations$language$tr {
	Translations$language$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Dil'
	String get title => 'Dil';

	/// tr: 'Türkçe'
	String get turkish => 'Türkçe';

	/// tr: 'English'
	String get english => 'English';
}

// Path: theme
class Translations$theme$tr {
	Translations$theme$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Tema'
	String get title => 'Tema';

	/// tr: 'Sistem'
	String get system => 'Sistem';

	/// tr: 'Açık'
	String get light => 'Açık';

	/// tr: 'Koyu'
	String get dark => 'Koyu';
}

// Path: roles
class Translations$roles$tr {
	Translations$roles$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Veli'
	String get parent => 'Veli';

	/// tr: 'Uzman'
	String get expert => 'Uzman';

	/// tr: 'Yönetici'
	String get admin => 'Yönetici';
}

// Path: auth
class Translations$auth$tr {
	Translations$auth$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Hesabınıza giriş yapın veya yeni bir hesap oluşturun.'
	String get subtitle => 'Hesabınıza giriş yapın veya yeni bir hesap oluşturun.';

	/// tr: 'E-posta Adresi'
	String get emailLabel => 'E-posta Adresi';

	/// tr: 'ornek@eposta.com'
	String get emailHint => 'ornek@eposta.com';

	/// tr: 'Şifre'
	String get passwordLabel => 'Şifre';

	/// tr: '••••••••'
	String get passwordHint => '••••••••';

	/// tr: 'Beni hatırla'
	String get rememberMe => 'Beni hatırla';

	/// tr: 'Şifremi unuttum'
	String get forgotPassword => 'Şifremi unuttum';

	/// tr: 'Giriş Yap'
	String get loginButton => 'Giriş Yap';

	/// tr: 'Hesabınız yok mu?'
	String get noAccount => 'Hesabınız yok mu?';

	/// tr: 'Veli hesabı ile kaydol'
	String get registerParent => 'Veli hesabı ile kaydol';

	/// tr: 'Uzman hesabı ile kaydol'
	String get registerExpert => 'Uzman hesabı ile kaydol';

	/// tr: 'Lütfen e-posta ve şifrenizi girin.'
	String get errorEmptyFields => 'Lütfen e-posta ve şifrenizi girin.';

	/// tr: '$role kayıt ekranı yakında eklenecek.'
	String registerComingSoon({required Object role}) => '${role} kayıt ekranı yakında eklenecek.';

	/// tr: 'Bu hesapta iki adımlı doğrulama açık; şimdilik web üzerinden giriş yapın.'
	String get errorMfaRequired => 'Bu hesapta iki adımlı doğrulama açık; şimdilik web üzerinden giriş yapın.';

	/// tr: 'Doğrulama e-postasını yeniden gönder'
	String get resendVerification => 'Doğrulama e-postasını yeniden gönder';
}

// Path: verifyEmail
class Translations$verifyEmail$tr {
	Translations$verifyEmail$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'E-posta Doğrulama'
	String get title => 'E-posta Doğrulama';

	/// tr: 'Gelen kutunuzu kontrol edin'
	String get waitingTitle => 'Gelen kutunuzu kontrol edin';

	/// tr: 'Doğrulama bağlantısını gönderdik. Bağlantıya dokunduktan sonra bu ekrana dönüp giriş yapabilirsiniz.'
	String get waitingBody => 'Doğrulama bağlantısını gönderdik. Bağlantıya dokunduktan sonra bu ekrana dönüp giriş yapabilirsiniz.';

	/// tr: '$email adresine doğrulama bağlantısı gönderdik. Bağlantıya dokunduktan sonra bu ekrana dönüp giriş yapabilirsiniz.'
	String waitingBodyWithEmail({required Object email}) => '${email} adresine doğrulama bağlantısı gönderdik. Bağlantıya dokunduktan sonra bu ekrana dönüp giriş yapabilirsiniz.';

	/// tr: 'E-posta birkaç dakika içinde gelmezse spam/gereksiz klasörünü kontrol edin.'
	String get spamHint => 'E-posta birkaç dakika içinde gelmezse spam/gereksiz klasörünü kontrol edin.';

	/// tr: 'Uzman hesabınız onay bekliyor'
	String get approvalTitle => 'Uzman hesabınız onay bekliyor';

	/// tr: 'Başvurunuz alındı. Lisans bilgileriniz yönetici tarafından doğrulandıktan sonra giriş yapabilirsiniz.'
	String get approvalBody => 'Başvurunuz alındı. Lisans bilgileriniz yönetici tarafından doğrulandıktan sonra giriş yapabilirsiniz.';

	/// tr: 'Doğrulama Kodu'
	String get tokenLabel => 'Doğrulama Kodu';

	/// tr: 'E-postadaki bağlantıda yer alan kod'
	String get tokenHint => 'E-postadaki bağlantıda yer alan kod';

	/// tr: 'Bağlantıyı açamıyorsanız içindeki kodu buraya yapıştırın.'
	String get tokenHelp => 'Bağlantıyı açamıyorsanız içindeki kodu buraya yapıştırın.';

	/// tr: 'Doğrula'
	String get verifyButton => 'Doğrula';

	/// tr: 'E-posta adresiniz doğrulanıyor…'
	String get verifying => 'E-posta adresiniz doğrulanıyor…';

	/// tr: 'E-postayı yeniden gönder'
	String get resendButton => 'E-postayı yeniden gönder';

	/// tr: 'Yeni doğrulama bağlantısı gönderildi. Gelen kutunuzu ve spam klasörünü kontrol edin.'
	String get resent => 'Yeni doğrulama bağlantısı gönderildi. Gelen kutunuzu ve spam klasörünü kontrol edin.';

	/// tr: 'E-posta adresiniz doğrulandı. Artık giriş yapabilirsiniz.'
	String get success => 'E-posta adresiniz doğrulandı. Artık giriş yapabilirsiniz.';

	/// tr: 'Lütfen doğrulama kodunu girin.'
	String get errorTokenRequired => 'Lütfen doğrulama kodunu girin.';

	/// tr: 'Yeniden göndermek için e-posta adresi gerekli.'
	String get errorEmailRequired => 'Yeniden göndermek için e-posta adresi gerekli.';

	/// tr: 'Giriş sayfasına dön'
	String get backToLogin => 'Giriş sayfasına dön';
}

// Path: forgotPassword
class Translations$forgotPassword$tr {
	Translations$forgotPassword$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Şifremi Unuttum'
	String get title => 'Şifremi Unuttum';

	/// tr: 'E-posta adresinizi girin; size bir şifre sıfırlama bağlantısı gönderelim.'
	String get subtitle => 'E-posta adresinizi girin; size bir şifre sıfırlama bağlantısı gönderelim.';

	/// tr: 'Sıfırlama Bağlantısı Gönder'
	String get submit => 'Sıfırlama Bağlantısı Gönder';

	/// tr: 'Bağlantı gönderildi'
	String get sentTitle => 'Bağlantı gönderildi';

	/// tr: 'Bu e-postaya kayıtlı bir hesap varsa, şifre sıfırlama bağlantısı gelen kutunuza ulaşacaktır.'
	String get sentBody => 'Bu e-postaya kayıtlı bir hesap varsa, şifre sıfırlama bağlantısı gelen kutunuza ulaşacaktır.';

	/// tr: 'Sıfırlama kodum var'
	String get haveCode => 'Sıfırlama kodum var';

	/// tr: 'Girişe dön'
	String get backToLogin => 'Girişe dön';

	/// tr: 'Lütfen e-posta girin.'
	String get errorEmailRequired => 'Lütfen e-posta girin.';

	/// tr: 'Geçerli bir e-posta girin.'
	String get errorEmailInvalid => 'Geçerli bir e-posta girin.';
}

// Path: resetPassword
class Translations$resetPassword$tr {
	Translations$resetPassword$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Şifre Sıfırla'
	String get title => 'Şifre Sıfırla';

	/// tr: 'E-postadaki sıfırlama kodunu ve yeni şifrenizi girin.'
	String get subtitle => 'E-postadaki sıfırlama kodunu ve yeni şifrenizi girin.';

	/// tr: 'Sıfırlama Kodu'
	String get tokenLabel => 'Sıfırlama Kodu';

	/// tr: 'E-postadaki bağlantıdaki kod'
	String get tokenHint => 'E-postadaki bağlantıdaki kod';

	/// tr: 'Yeni Şifre'
	String get newPasswordLabel => 'Yeni Şifre';

	/// tr: 'Yeni Şifre (Tekrar)'
	String get confirmLabel => 'Yeni Şifre (Tekrar)';

	/// tr: 'Şifreyi Güncelle'
	String get submit => 'Şifreyi Güncelle';

	/// tr: 'Şifreniz güncellendi. Giriş yapabilirsiniz.'
	String get success => 'Şifreniz güncellendi. Giriş yapabilirsiniz.';

	/// tr: 'Lütfen sıfırlama kodunu girin.'
	String get errorTokenRequired => 'Lütfen sıfırlama kodunu girin.';

	/// tr: 'Şifre en az 8 karakter olmalıdır.'
	String get errorPasswordShort => 'Şifre en az 8 karakter olmalıdır.';

	/// tr: 'Şifreler eşleşmiyor.'
	String get errorMismatch => 'Şifreler eşleşmiyor.';
}

// Path: password
class Translations$password$tr {
	Translations$password$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Şifre gücü'
	String get strengthTitle => 'Şifre gücü';

	/// tr: 'Çok zayıf'
	String get strengthVeryWeak => 'Çok zayıf';

	/// tr: 'Zayıf'
	String get strengthWeak => 'Zayıf';

	/// tr: 'Orta'
	String get strengthMedium => 'Orta';

	/// tr: 'Güçlü'
	String get strengthStrong => 'Güçlü';

	/// tr: 'Çok güçlü'
	String get strengthVeryStrong => 'Çok güçlü';

	/// tr: 'En az 8 karakter'
	String get ruleMinLength => 'En az 8 karakter';

	/// tr: 'Bir büyük harf'
	String get ruleUppercase => 'Bir büyük harf';

	/// tr: 'Bir rakam'
	String get ruleDigit => 'Bir rakam';

	/// tr: 'Bir özel karakter'
	String get ruleSpecial => 'Bir özel karakter';

	/// tr: 'Şifre en az 8 karakter olmalıdır.'
	String get errorTooShort => 'Şifre en az 8 karakter olmalıdır.';

	/// tr: 'Şifre en fazla 64 karakter olabilir.'
	String get errorTooLong => 'Şifre en fazla 64 karakter olabilir.';

	/// tr: 'Şifre en az bir büyük harf içermelidir.'
	String get errorNoUppercase => 'Şifre en az bir büyük harf içermelidir.';

	/// tr: 'Şifre en az bir rakam içermelidir.'
	String get errorNoDigit => 'Şifre en az bir rakam içermelidir.';

	/// tr: 'Şifre en az bir özel karakter (örn. ! ? * . -) içermelidir.'
	String get errorNoSpecial => 'Şifre en az bir özel karakter (örn. ! ? * . -) içermelidir.';

	/// tr: 'Bu şifre çok yaygın ve kolay tahmin edilebilir; lütfen farklı bir şifre seçin.'
	String get errorCommon => 'Bu şifre çok yaygın ve kolay tahmin edilebilir; lütfen farklı bir şifre seçin.';
}

// Path: register
class Translations$register$tr {
	Translations$register$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Veli Hesabı Oluştur'
	String get titleParent => 'Veli Hesabı Oluştur';

	/// tr: 'Uzman Hesabı Oluştur'
	String get titleExpert => 'Uzman Hesabı Oluştur';

	/// tr: 'Nasıl kaydolmak istersiniz?'
	String get roleQuestion => 'Nasıl kaydolmak istersiniz?';

	/// tr: 'Ad Soyad'
	String get fullNameLabel => 'Ad Soyad';

	/// tr: 'Adınız ve soyadınız'
	String get fullNameHint => 'Adınız ve soyadınız';

	/// tr: 'Telefon (isteğe bağlı)'
	String get phoneLabel => 'Telefon (isteğe bağlı)';

	/// tr: '05XX XXX XX XX'
	String get phoneHint => '05XX XXX XX XX';

	/// tr: 'Şehir (isteğe bağlı)'
	String get cityLabel => 'Şehir (isteğe bağlı)';

	/// tr: 'Yaşadığınız şehir'
	String get cityHint => 'Yaşadığınız şehir';

	/// tr: 'Uzmanlık Ünvanı'
	String get expertTitleLabel => 'Uzmanlık Ünvanı';

	/// tr: 'Örn. Çocuk Psikoloğu'
	String get expertTitleHint => 'Örn. Çocuk Psikoloğu';

	/// tr: 'Kurum (isteğe bağlı)'
	String get institutionLabel => 'Kurum (isteğe bağlı)';

	/// tr: 'Çalıştığınız kurum'
	String get institutionHint => 'Çalıştığınız kurum';

	/// tr: 'Lisans / Diploma No'
	String get licenseNumberLabel => 'Lisans / Diploma No';

	/// tr: 'Mesleki lisans numaranız'
	String get licenseNumberHint => 'Mesleki lisans numaranız';

	/// tr: 'Hakkında (isteğe bağlı)'
	String get bioLabel => 'Hakkında (isteğe bağlı)';

	/// tr: 'Deneyiminizi kısaca anlatın'
	String get bioHint => 'Deneyiminizi kısaca anlatın';

	/// tr: 'Uzmanlık Alanları (isteğe bağlı)'
	String get specializationsLabel => 'Uzmanlık Alanları (isteğe bağlı)';

	/// tr: 'Virgülle ayırın (Otizm, DEHB)'
	String get specializationsHint => 'Virgülle ayırın (Otizm, DEHB)';

	/// tr: 'KVKK aydınlatma metnini okudum ve onaylıyorum.'
	String get kvkkConsent => 'KVKK aydınlatma metnini okudum ve onaylıyorum.';

	/// tr: 'Kaydol'
	String get submit => 'Kaydol';

	/// tr: 'Zaten hesabınız var mı? Giriş yapın'
	String get haveAccount => 'Zaten hesabınız var mı? Giriş yapın';

	/// tr: 'Lütfen ad soyad girin.'
	String get errorFullNameRequired => 'Lütfen ad soyad girin.';

	/// tr: 'Lütfen e-posta girin.'
	String get errorEmailRequired => 'Lütfen e-posta girin.';

	/// tr: 'Geçerli bir e-posta girin.'
	String get errorEmailInvalid => 'Geçerli bir e-posta girin.';

	/// tr: 'Şifre en az 8 karakter olmalıdır.'
	String get errorPasswordShort => 'Şifre en az 8 karakter olmalıdır.';

	/// tr: 'Lütfen uzmanlık ünvanını girin.'
	String get errorExpertTitleRequired => 'Lütfen uzmanlık ünvanını girin.';

	/// tr: 'Uzman kaydı için lisans / diploma numarası zorunludur.'
	String get errorLicenseRequired => 'Uzman kaydı için lisans / diploma numarası zorunludur.';

	/// tr: 'Devam etmek için KVKK onayı gereklidir.'
	String get errorKvkkRequired => 'Devam etmek için KVKK onayı gereklidir.';

	/// tr: 'Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.'
	String get emailTaken => 'Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.';

	/// tr: 'Bu e-posta adresi kullanılabilir.'
	String get emailAvailable => 'Bu e-posta adresi kullanılabilir.';
}

// Path: settings
class Translations$settings$tr {
	Translations$settings$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Ayarlar'
	String get title => 'Ayarlar';

	/// tr: 'Bildirimler'
	String get notificationsTitle => 'Bildirimler';

	/// tr: 'Hangi konularda bildirim almak istediğinizi seçin.'
	String get notificationsSubtitle => 'Hangi konularda bildirim almak istediğinizi seçin.';

	/// tr: 'Yeni mesajlar'
	String get notifMessages => 'Yeni mesajlar';

	/// tr: 'Randevu onay ve değişiklikleri'
	String get notifAppointment => 'Randevu onay ve değişiklikleri';

	/// tr: 'Randevudan 24 saat önce hatırlat'
	String get notifApptReminder => 'Randevudan 24 saat önce hatırlat';

	/// tr: 'Uzman notları ve geri bildirimleri'
	String get notifExpertNote => 'Uzman notları ve geri bildirimleri';

	/// tr: 'Yeni ödev atandığında'
	String get notifTaskAssigned => 'Yeni ödev atandığında';

	/// tr: 'Forum ve dertleşme duvarı yanıtları'
	String get notifForum => 'Forum ve dertleşme duvarı yanıtları';

	/// tr: 'Benzer aile eşleşmeleri'
	String get notifMatching => 'Benzer aile eşleşmeleri';

	/// tr: 'Takvim hatırlatmaları'
	String get notifCalendar => 'Takvim hatırlatmaları';

	/// tr: 'Gizlilik'
	String get privacyTitle => 'Gizlilik';

	/// tr: 'Diğer kullanıcıların sizi nasıl göreceğini belirleyin.'
	String get privacySubtitle => 'Diğer kullanıcıların sizi nasıl göreceğini belirleyin.';

	/// tr: 'Profilim diğer ailelere görünsün'
	String get privacyShowProfile => 'Profilim diğer ailelere görünsün';

	/// tr: 'Bana mesaj gönderilebilsin'
	String get privacyAllowMessages => 'Bana mesaj gönderilebilsin';

	/// tr: 'Gelişim özetini bağlı uzmanla paylaş'
	String get privacyShareProgress => 'Gelişim özetini bağlı uzmanla paylaş';

	/// tr: 'Yaklaşık konumum (şehir) paylaşılsın'
	String get privacyApproximateLocation => 'Yaklaşık konumum (şehir) paylaşılsın';

	/// tr: 'Çevrimiçi olduğumu gizle'
	String get privacyHidePresence => 'Çevrimiçi olduğumu gizle';

	/// tr: 'Görünüm ve dil'
	String get appearanceTitle => 'Görünüm ve dil';

	/// tr: 'Erişilebilirlik'
	String get accessibilityTitle => 'Erişilebilirlik';

	/// tr: 'Görünümü ve etkileşimi size uygun hale getirin.'
	String get accessibilitySubtitle => 'Görünümü ve etkileşimi size uygun hale getirin.';

	/// tr: 'Büyük yazı modu'
	String get a11yLargeText => 'Büyük yazı modu';

	/// tr: 'Metinleri daha büyük gösterir.'
	String get a11yLargeTextBody => 'Metinleri daha büyük gösterir.';

	/// tr: 'Sakin görünüm'
	String get a11yCalmMode => 'Sakin görünüm';

	/// tr: 'Göz yormayan yumuşak tonlar kullanır.'
	String get a11yCalmModeBody => 'Göz yormayan yumuşak tonlar kullanır.';

	/// tr: 'Yüksek kontrast'
	String get a11yHighContrast => 'Yüksek kontrast';

	/// tr: 'Yazıları en belirgin renkte tutar.'
	String get a11yHighContrastBody => 'Yazıları en belirgin renkte tutar.';

	/// tr: 'Hareketi azalt'
	String get a11yReduceMotion => 'Hareketi azalt';

	/// tr: 'Sayfa geçişlerini ve animasyonları kapatır.'
	String get a11yReduceMotionBody => 'Sayfa geçişlerini ve animasyonları kapatır.';

	/// tr: 'Basit mod'
	String get a11ySimpleMode => 'Basit mod';

	/// tr: 'Profil menüsünü temel bölümlere indirger.'
	String get a11ySimpleModeBody => 'Profil menüsünü temel bölümlere indirger.';

	/// tr: 'Güvenlik'
	String get securityTitle => 'Güvenlik';

	/// tr: 'Hesabınıza erişimi koruyun.'
	String get securitySubtitle => 'Hesabınıza erişimi koruyun.';

	/// tr: 'Şifre değiştir'
	String get changePassword => 'Şifre değiştir';

	/// tr: 'Şifreyi güncelle'
	String get changePasswordSubmit => 'Şifreyi güncelle';

	/// tr: 'Mevcut şifre'
	String get currentPasswordLabel => 'Mevcut şifre';

	/// tr: 'Yeni şifre'
	String get newPasswordLabel => 'Yeni şifre';

	/// tr: 'Şifreniz güncellendi.'
	String get passwordChanged => 'Şifreniz güncellendi.';

	/// tr: 'Lütfen mevcut şifrenizi girin.'
	String get errorCurrentPasswordRequired => 'Lütfen mevcut şifrenizi girin.';

	/// tr: 'Verileriniz ve KVKK'
	String get dataTitle => 'Verileriniz ve KVKK';

	/// tr: 'Verileriniz üzerindeki haklarınızı buradan kullanabilirsiniz.'
	String get dataSubtitle => 'Verileriniz üzerindeki haklarınızı buradan kullanabilirsiniz.';

	/// tr: 'KVKK hakları ve rızalar'
	String get kvkkPanel => 'KVKK hakları ve rızalar';

	/// tr: 'Rıza tercihleri, başvurular ve aydınlatma metni.'
	String get kvkkPanelBody => 'Rıza tercihleri, başvurular ve aydınlatma metni.';

	/// tr: 'Verilerimi indir'
	String get downloadData => 'Verilerimi indir';

	/// tr: 'Hesabınızdaki tüm veriyi JSON dosyası olarak alın.'
	String get downloadDataBody => 'Hesabınızdaki tüm veriyi JSON dosyası olarak alın.';

	/// tr: 'Otizm Destek — hesap verilerim'
	String get downloadDataSubject => 'Otizm Destek — hesap verilerim';

	/// tr: 'Hesabımı sil'
	String get deleteAccount => 'Hesabımı sil';

	/// tr: 'Hesabınız ve tüm kayıtlarınız kalıcı olarak silinir.'
	String get deleteAccountBody => 'Hesabınız ve tüm kayıtlarınız kalıcı olarak silinir.';

	/// tr: 'Bu işlem geri alınamaz. Çocuk profilleri, notlar, randevular ve mesajlar dâhil tüm verileriniz kalıcı olarak silinir.'
	String get deleteAccountWarning => 'Bu işlem geri alınamaz. Çocuk profilleri, notlar, randevular ve mesajlar dâhil tüm verileriniz kalıcı olarak silinir.';

	/// tr: 'Hesabımı kalıcı olarak sil'
	String get deleteAccountSubmit => 'Hesabımı kalıcı olarak sil';

	/// tr: 'SİL'
	String get deleteKeyword => 'SİL';

	/// tr: 'Onaylamak için "$keyword" yazın'
	String deleteConfirmLabel({required Object keyword}) => 'Onaylamak için "${keyword}" yazın';

	/// tr: 'Onay metni eşleşmiyor.'
	String get errorDeleteConfirm => 'Onay metni eşleşmiyor.';
}

// Path: legal
class Translations$legal$tr {
	Translations$legal$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Yasal metinler'
	String get title => 'Yasal metinler';

	/// tr: 'Aydınlatma metni, gizlilik politikası, kullanım şartları ve tıbbi uyarılar. Metinler bağlayıcı sürüm olduğu için Türkçe gösterilir.'
	String get subtitle => 'Aydınlatma metni, gizlilik politikası, kullanım şartları ve tıbbi uyarılar. Metinler bağlayıcı sürüm olduğu için Türkçe gösterilir.';

	/// tr: 'Metin sürümü $version · Son güncelleme $date'
	String versionLine({required Object version, required Object date}) => 'Metin sürümü ${version} · Son güncelleme ${date}';

	/// tr: 'KVKK aydınlatma metnini oku'
	String get readNotice => 'KVKK aydınlatma metnini oku';
}

// Path: kvkk
class Translations$kvkk$tr {
	Translations$kvkk$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'KVKK ve rızalar'
	String get title => 'KVKK ve rızalar';

	/// tr: 'KVKK md. 11 haklarınız'
	String get rightsTitle => 'KVKK md. 11 haklarınız';

	/// tr: 'Verilerinizin işlenip işlenmediğini öğrenme, düzeltilmesini veya silinmesini isteme, aktarıldığı üçüncü kişileri bilme ve otomatik analiz sonuçlarına itiraz etme hakkınız var. Başvurularınız en geç 30 gün içinde yanıtlanır.'
	String get rightsBody => 'Verilerinizin işlenip işlenmediğini öğrenme, düzeltilmesini veya silinmesini isteme, aktarıldığı üçüncü kişileri bilme ve otomatik analiz sonuçlarına itiraz etme hakkınız var. Başvurularınız en geç 30 gün içinde yanıtlanır.';

	/// tr: 'Rıza tercihleriniz'
	String get consentsTitle => 'Rıza tercihleriniz';

	/// tr: 'Açık rıza amaca özel olmalıdır; her başlığı ayrı ayrı açıp kapatabilirsiniz.'
	String get consentsSubtitle => 'Açık rıza amaca özel olmalıdır; her başlığı ayrı ayrı açıp kapatabilirsiniz.';

	/// tr: 'Aydınlatma metni onayı'
	String get consentNotice => 'Aydınlatma metni onayı';

	/// tr: 'Yapay zekâ analizi'
	String get consentAi => 'Yapay zekâ analizi';

	/// tr: 'Gelişim verisinin yapay zekâ sağlayıcısına (yurt dışına) aktarılmasına izin verir.'
	String get consentAiBody => 'Gelişim verisinin yapay zekâ sağlayıcısına (yurt dışına) aktarılmasına izin verir.';

	/// tr: 'Acil durum kartı paylaşımı'
	String get consentEmergency => 'Acil durum kartı paylaşımı';

	/// tr: 'Acil durum kartınızın bağlantı/QR ile üçüncü kişilere gösterilmesine izin verir.'
	String get consentEmergencyBody => 'Acil durum kartınızın bağlantı/QR ile üçüncü kişilere gösterilmesine izin verir.';

	/// tr: 'Benzer aile eşleştirmesi'
	String get consentMatching => 'Benzer aile eşleştirmesi';

	/// tr: 'Profilinizin eşleştirme motorunda diğer ailelere gösterilmesine izin verir.'
	String get consentMatchingBody => 'Profilinizin eşleştirme motorunda diğer ailelere gösterilmesine izin verir.';

	/// tr: 'Bilgilendirme e-postaları'
	String get consentMarketing => 'Bilgilendirme e-postaları';

	/// tr: 'Zorunlu olmayan duyuru ve bilgilendirme e-postalarını almanızı sağlar.'
	String get consentMarketingBody => 'Zorunlu olmayan duyuru ve bilgilendirme e-postalarını almanızı sağlar.';

	/// tr: 'Aydınlatma metni güncellendi'
	String get reconsentTitle => 'Aydınlatma metni güncellendi';

	/// tr: 'Aydınlatma metni güncellendi (sürüm $version)'
	String reconsentTitleVersion({required Object version}) => 'Aydınlatma metni güncellendi (sürüm ${version})';

	/// tr: 'Verilerinizin nasıl işlendiğini gözden geçirip güncel metni onaylayın.'
	String get reconsentBody => 'Verilerinizin nasıl işlendiğini gözden geçirip güncel metni onaylayın.';

	/// tr: 'Okudum, onaylıyorum'
	String get reconsentAccept => 'Okudum, onaylıyorum';

	/// tr: 'Güncel aydınlatma metni onayınız kaydedildi.'
	String get reconsentSaved => 'Güncel aydınlatma metni onayınız kaydedildi.';

	/// tr: 'Rıza geçmişim'
	String get historyTitle => 'Rıza geçmişim';

	/// tr: 'Başvurularım'
	String get requestsTitle => 'Başvurularım';

	/// tr: 'Verileriniz hakkındaki taleplerinizi buradan iletebilirsiniz.'
	String get requestsSubtitle => 'Verileriniz hakkındaki taleplerinizi buradan iletebilirsiniz.';

	/// tr: 'KVKK başvurusu yap'
	String get newRequest => 'KVKK başvurusu yap';

	/// tr: 'Henüz bir başvurunuz yok.'
	String get requestsEmpty => 'Henüz bir başvurunuz yok.';

	/// tr: 'Başvurular yüklenemedi.'
	String get requestsError => 'Başvurular yüklenemedi.';

	/// tr: 'Başvurunuz alındı. En geç 30 gün içinde yanıtlanacaktır.'
	String get requestCreated => 'Başvurunuz alındı. En geç 30 gün içinde yanıtlanacaktır.';

	/// tr: 'Verilerimin işlenip işlenmediğini öğrenmek istiyorum'
	String get requestInfo => 'Verilerimin işlenip işlenmediğini öğrenmek istiyorum';

	/// tr: 'Eksik veya yanlış işlenen verimin düzeltilmesini istiyorum'
	String get requestCorrection => 'Eksik veya yanlış işlenen verimin düzeltilmesini istiyorum';

	/// tr: 'Verilerimin silinmesini / yok edilmesini istiyorum'
	String get requestDeletion => 'Verilerimin silinmesini / yok edilmesini istiyorum';

	/// tr: 'Verilerimin aktarıldığı üçüncü kişileri öğrenmek istiyorum'
	String get requestTransfer => 'Verilerimin aktarıldığı üçüncü kişileri öğrenmek istiyorum';

	/// tr: 'Otomatik analiz sonucu aleyhime çıkan sonuca itiraz ediyorum'
	String get requestObjection => 'Otomatik analiz sonucu aleyhime çıkan sonuca itiraz ediyorum';

	/// tr: 'Uğradığım zararın giderilmesini talep ediyorum'
	String get requestDamages => 'Uğradığım zararın giderilmesini talep ediyorum';

	/// tr: 'Talebiniz'
	String get descriptionLabel => 'Talebiniz';

	/// tr: 'Talebinizi kısaca açıklayın.'
	String get descriptionHint => 'Talebinizi kısaca açıklayın.';

	/// tr: 'Başvurular en geç 30 gün içinde yanıtlanır.'
	String get responseTime => 'Başvurular en geç 30 gün içinde yanıtlanır.';

	/// tr: 'Başvuruyu gönder'
	String get submitRequest => 'Başvuruyu gönder';

	/// tr: 'Lütfen talebinizi açıklayın.'
	String get errorDescriptionRequired => 'Lütfen talebinizi açıklayın.';

	/// tr: 'Alındı'
	String get statusOpen => 'Alındı';

	/// tr: 'İnceleniyor'
	String get statusReviewing => 'İnceleniyor';

	/// tr: 'Tamamlandı'
	String get statusDone => 'Tamamlandı';

	/// tr: 'Reddedildi'
	String get statusRejected => 'Reddedildi';

	/// tr: '$date tarihinde alındı'
	String receivedOn({required Object date}) => '${date} tarihinde alındı';

	/// tr: 'yanıt son tarihi $date'
	String dueOn({required Object date}) => 'yanıt son tarihi ${date}';
}

// Path: onboarding
class Translations$onboarding$tr {
	Translations$onboarding$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Başlangıç'
	String get title => 'Başlangıç';

	/// tr: 'Atla'
	String get skip => 'Atla';

	/// tr: 'Başlayalım'
	String get start => 'Başlayalım';

	/// tr: 'Geri'
	String get back => 'Geri';

	/// tr: 'Devam et'
	String get continueButton => 'Devam et';

	/// tr: 'Şimdilik atla'
	String get skipForNow => 'Şimdilik atla';

	/// tr: 'Ana sayfaya geç'
	String get finish => 'Ana sayfaya geç';

	/// tr: 'Çocuk Profili'
	String get stepChild => 'Çocuk Profili';

	/// tr: 'Destek Alanları'
	String get stepTags => 'Destek Alanları';

	/// tr: 'Başlangıç Planı'
	String get stepPlan => 'Başlangıç Planı';

	/// tr: 'Hoş geldiniz'
	String get welcomeTitle => 'Hoş geldiniz';

	/// tr: 'Birkaç kısa adımda uygulamayı çocuğunuza göre hazırlayalım. Tüm bilgileri sonradan değiştirebilirsiniz.'
	String get welcomeBody => 'Birkaç kısa adımda uygulamayı çocuğunuza göre hazırlayalım. Tüm bilgileri sonradan değiştirebilirsiniz.';

	/// tr: 'Temel bilgiler'
	String get introChildTitle => 'Temel bilgiler';

	/// tr: 'Ad ve isteğe bağlı kısa bilgiler'
	String get introChildBody => 'Ad ve isteğe bağlı kısa bilgiler';

	/// tr: 'Destek alanları'
	String get introTagsTitle => 'Destek alanları';

	/// tr: 'Gözlemlediğiniz alanları seçin'
	String get introTagsBody => 'Gözlemlediğiniz alanları seçin';

	/// tr: 'Başlangıç önerisi'
	String get introPlanTitle => 'Başlangıç önerisi';

	/// tr: 'İlk yapabileceklerinizi görün'
	String get introPlanBody => 'İlk yapabileceklerinizi görün';

	/// tr: 'Çocuğunuzu tanıyalım'
	String get childTitle => 'Çocuğunuzu tanıyalım';

	/// tr: 'Yalnızca ad zorunlu; diğer alanları daha sonra da doldurabilirsiniz.'
	String get childSubtitle => 'Yalnızca ad zorunlu; diğer alanları daha sonra da doldurabilirsiniz.';

	/// tr: 'Çocuğun adı'
	String get childNameLabel => 'Çocuğun adı';

	/// tr: 'Örn. Elif'
	String get childNameHint => 'Örn. Elif';

	/// tr: 'Doğum tarihi (isteğe bağlı)'
	String get childBirthDateLabel => 'Doğum tarihi (isteğe bağlı)';

	/// tr: 'Seçmek için dokunun'
	String get childBirthDateHint => 'Seçmek için dokunun';

	/// tr: 'Tanı bilgisi (isteğe bağlı)'
	String get childDiagnosisLabel => 'Tanı bilgisi (isteğe bağlı)';

	/// tr: 'Varsa tanı ve kısa notlar'
	String get childDiagnosisHint => 'Varsa tanı ve kısa notlar';

	/// tr: 'Başlangıç odağı'
	String get focusTitle => 'Başlangıç odağı';

	/// tr: 'İletişim şekli'
	String get communicationTitle => 'İletişim şekli';

	/// tr: 'Yararlı olabilecek destek'
	String get supportTitle => 'Yararlı olabilecek destek';

	/// tr: 'Hangi alanlarda destek arıyorsunuz?'
	String get tagsTitle => 'Hangi alanlarda destek arıyorsunuz?';

	/// tr: 'Gözlemlediğiniz alanları seçin; benzer aileler ve içerik önerileri buna göre şekillenir.'
	String get tagsSubtitle => 'Gözlemlediğiniz alanları seçin; benzer aileler ve içerik önerileri buna göre şekillenir.';

	/// tr: 'Başlangıç planınız hazır'
	String get planTitle => 'Başlangıç planınız hazır';

	/// tr: '$name için başlangıç planınız hazır'
	String planTitleNamed({required Object name}) => '${name} için başlangıç planınız hazır';

	/// tr: 'İlk adım olarak şunlardan birini deneyebilirsiniz.'
	String get planSubtitle => 'İlk adım olarak şunlardan birini deneyebilirsiniz.';

	/// tr: 'Bu seçimler yalnızca başlangıç yönlendirmesidir; tüm bölümlere menüden ulaşabilirsiniz.'
	String get planNote => 'Bu seçimler yalnızca başlangıç yönlendirmesidir; tüm bölümlere menüden ulaşabilirsiniz.';

	/// tr: 'Günlük kayıt ekle'
	String get planTrackerTitle => 'Günlük kayıt ekle';

	/// tr: 'Uyku, duygu durumu veya kısa bir gözlem girin.'
	String get planTrackerBody => 'Uyku, duygu durumu veya kısa bir gözlem girin.';

	/// tr: 'Uzmanları incele'
	String get planExpertsTitle => 'Uzmanları incele';

	/// tr: 'Uzmanlara göz atın veya randevu talebi oluşturun.'
	String get planExpertsBody => 'Uzmanlara göz atın veya randevu talebi oluşturun.';

	/// tr: 'Bilgi ve kaynakları keşfet'
	String get planKnowledgeTitle => 'Bilgi ve kaynakları keşfet';

	/// tr: 'Bilgi bankasındaki güvenilir içeriklere göz atın.'
	String get planKnowledgeBody => 'Bilgi bankasındaki güvenilir içeriklere göz atın.';

	/// tr: 'Hoş geldiniz $name'
	String expertTitle({required Object name}) => 'Hoş geldiniz ${name}';

	/// tr: 'Danışan takibi, randevular ve mesajlaşma ana sayfada sizi bekliyor.'
	String get expertBody => 'Danışan takibi, randevular ve mesajlaşma ana sayfada sizi bekliyor.';

	/// tr: 'Çocuğun adı zorunludur.'
	String get errorNameRequired => 'Çocuğun adı zorunludur.';

	/// tr: 'Doğum tarihi gelecekte olamaz.'
	String get errorBirthDateFuture => 'Doğum tarihi gelecekte olamaz.';
}

// Path: nav
class Translations$nav$tr {
	Translations$nav$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Ana Sayfa'
	String get home => 'Ana Sayfa';

	/// tr: 'Uzmanlar'
	String get specialists => 'Uzmanlar';

	/// tr: 'Gelişim'
	String get progress => 'Gelişim';

	/// tr: 'Profil'
	String get profile => 'Profil';
}

// Path: chat
class Translations$chat$tr {
	Translations$chat$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'AI Asistan'
	String get title => 'AI Asistan';

	/// tr: 'Merhaba! Otizm ve çocuk gelişimi hakkındaki sorularınızı yanıtlamaya çalışayım.'
	String get greeting => 'Merhaba! Otizm ve çocuk gelişimi hakkındaki sorularınızı yanıtlamaya çalışayım.';

	/// tr: 'Bir soru sorun...'
	String get inputHint => 'Bir soru sorun...';

	/// tr: 'Yanıt alınamadı, lütfen tekrar deneyin.'
	String get errorGeneric => 'Yanıt alınamadı, lütfen tekrar deneyin.';
}

// Path: messages
class Translations$messages$tr {
	Translations$messages$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Mesajlar'
	String get title => 'Mesajlar';

	/// tr: 'Henüz bir konuşmanız yok.'
	String get noConversations => 'Henüz bir konuşmanız yok.';

	/// tr: 'Henüz mesaj yok. İlk mesajı gönderin.'
	String get noMessages => 'Henüz mesaj yok. İlk mesajı gönderin.';

	/// tr: 'Mesaj yazın...'
	String get inputHint => 'Mesaj yazın...';

	/// tr: 'Bağlanıyor...'
	String get connecting => 'Bağlanıyor...';
}

// Path: home
class Translations$home$tr {
	Translations$home$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Bildirimler'
	String get notifications => 'Bildirimler';

	/// tr: 'AI Asistan'
	String get assistant => 'AI Asistan';

	/// tr: 'Mesajlar'
	String get messages => 'Mesajlar';

	/// tr: 'Merhaba, $name'
	String greeting({required Object name}) => 'Merhaba, ${name}';

	/// tr: 'Veli'
	String get greetingFallback => 'Veli';

	/// tr: 'Bugün gelişim için neler yapabiliriz?'
	String get subtitle => 'Bugün gelişim için neler yapabiliriz?';

	/// tr: 'Çocuk Gelişimi'
	String get childProgressTitle => 'Çocuk Gelişimi';

	/// tr: 'Haftalık İlerleme Özeti'
	String get weeklySummary => 'Haftalık İlerleme Özeti';

	/// tr: '%$value Artış'
	String increaseBadge({required Object value}) => '%${value} Artış';

	/// tr: 'Hedefe Kalan: %$value'
	String remainingToGoal({required Object value}) => 'Hedefe Kalan: %${value}';

	/// tr: 'Bilişsel: İyi'
	String get statusCognitiveGood => 'Bilişsel: İyi';

	/// tr: 'İletişim: Gelişiyor'
	String get statusCommunicationImproving => 'İletişim: Gelişiyor';

	/// tr: 'Yaklaşan Randevular'
	String get upcomingAppointments => 'Yaklaşan Randevular';

	/// tr: 'Önerilen Makaleler'
	String get recommendedArticles => 'Önerilen Makaleler';

	/// tr: 'Çocuklarım'
	String get childrenTitle => 'Çocuklarım';

	/// tr: 'Henüz çocuk eklemediniz.'
	String get noChildren => 'Henüz çocuk eklemediniz.';

	/// tr: 'Çocuk Ekle'
	String get addChild => 'Çocuk Ekle';

	/// tr: '$years yaş'
	String ageYears({required Object years}) => '${years} yaş';

	/// tr: 'Yaklaşan randevunuz yok.'
	String get noAppointments => 'Yaklaşan randevunuz yok.';

	/// tr: 'Gösterilecek makale yok.'
	String get noArticles => 'Gösterilecek makale yok.';
}

// Path: specialists
class Translations$specialists$tr {
	Translations$specialists$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Uzman Bulun'
	String get title => 'Uzman Bulun';

	/// tr: 'İsim veya uzmanlık arayın...'
	String get searchHint => 'İsim veya uzmanlık arayın...';

	/// tr: 'Tümü'
	String get filterAll => 'Tümü';

	/// tr: 'Psikolog'
	String get filterPsychologist => 'Psikolog';

	/// tr: 'Özel Eğitim'
	String get filterSpecialEducation => 'Özel Eğitim';

	/// tr: 'Dil ve Konuşma'
	String get filterSpeech => 'Dil ve Konuşma';

	/// tr: 'Aramanıza uygun uzman bulunamadı.'
	String get noResults => 'Aramanıza uygun uzman bulunamadı.';

	/// tr: 'Yeni'
	String get ratingNew => 'Yeni';

	/// tr: '$count değerlendirme'
	String reviews({required Object count}) => '${count} değerlendirme';
}

// Path: progress
class Translations$progress$tr {
	Translations$progress$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Gelişim Takibi'
	String get title => 'Gelişim Takibi';

	/// tr: 'Hedefler ve gelişim notları.'
	String get subtitle => 'Hedefler ve gelişim notları.';

	/// tr: 'Yeni Kayıt Ekle'
	String get addRecord => 'Yeni Kayıt Ekle';

	/// tr: 'Hedefler'
	String get goalsTitle => 'Hedefler';

	/// tr: 'Son Gelişim Notları'
	String get recentNotes => 'Son Gelişim Notları';

	/// tr: 'Henüz hedef eklenmemiş.'
	String get noGoals => 'Henüz hedef eklenmemiş.';

	/// tr: 'Henüz gelişim notu eklenmemiş.'
	String get noNotes => 'Henüz gelişim notu eklenmemiş.';

	/// tr: 'Gelişim takibi için önce bir çocuk ekleyin.'
	String get noChild => 'Gelişim takibi için önce bir çocuk ekleyin.';

	/// tr: '$done / $total'
	String goalProgress({required Object done, required Object total}) => '${done} / ${total}';

	/// tr: 'Hedef Ekle'
	String get addGoal => 'Hedef Ekle';

	/// tr: 'Not Ekle'
	String get addNote => 'Not Ekle';

	/// tr: 'Jeton Ekle'
	String get addToken => 'Jeton Ekle';

	/// tr: 'Jeton eklendi 🎉'
	String get tokenAdded => 'Jeton eklendi 🎉';

	/// tr: 'Jeton geri alındı.'
	String get tokenRemoved => 'Jeton geri alındı.';

	/// tr: 'Hedef tamamlandı! 🎉'
	String get goalCompleted => 'Hedef tamamlandı! 🎉';

	/// tr: 'Ödül: $title'
	String rewardLine({required Object title}) => 'Ödül: ${title}';
}

// Path: goalForm
class Translations$goalForm$tr {
	Translations$goalForm$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Hedef Ekle'
	String get title => 'Hedef Ekle';

	/// tr: 'Başlık'
	String get nameLabel => 'Başlık';

	/// tr: 'Örn. Göz teması kurma'
	String get nameHint => 'Örn. Göz teması kurma';

	/// tr: 'Kategori'
	String get categoryLabel => 'Kategori';

	/// tr: 'Hedef Sayısı'
	String get targetLabel => 'Hedef Sayısı';

	/// tr: 'Açıklama (isteğe bağlı)'
	String get descriptionLabel => 'Açıklama (isteğe bağlı)';

	/// tr: 'Hedefle ilgili detay'
	String get descriptionHint => 'Hedefle ilgili detay';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Lütfen bir başlık girin.'
	String get errorTitle => 'Lütfen bir başlık girin.';

	/// tr: 'Hedef eklendi.'
	String get created => 'Hedef eklendi.';
}

// Path: noteForm
class Translations$noteForm$tr {
	Translations$noteForm$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Not Ekle'
	String get title => 'Not Ekle';

	/// tr: 'Notu Düzenle'
	String get editTitle => 'Notu Düzenle';

	/// tr: 'Başlık'
	String get nameLabel => 'Başlık';

	/// tr: 'Örn. Bugünkü gelişme'
	String get nameHint => 'Örn. Bugünkü gelişme';

	/// tr: 'İçerik (isteğe bağlı)'
	String get contentLabel => 'İçerik (isteğe bağlı)';

	/// tr: 'Gözlemlerinizi yazın'
	String get contentHint => 'Gözlemlerinizi yazın';

	/// tr: 'Kategori (isteğe bağlı)'
	String get categoryLabel => 'Kategori (isteğe bağlı)';

	/// tr: 'Ruh Hali (isteğe bağlı)'
	String get moodLabel => 'Ruh Hali (isteğe bağlı)';

	/// tr: 'Mutlu'
	String get moodHappy => 'Mutlu';

	/// tr: 'Normal'
	String get moodNeutral => 'Normal';

	/// tr: 'Zor Gün'
	String get moodSad => 'Zor Gün';

	/// tr: 'Tarih'
	String get dateLabel => 'Tarih';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Lütfen bir başlık girin.'
	String get errorTitle => 'Lütfen bir başlık girin.';

	/// tr: 'Not eklendi.'
	String get created => 'Not eklendi.';

	/// tr: 'Not güncellendi.'
	String get updated => 'Not güncellendi.';
}

// Path: notesPage
class Translations$notesPage$tr {
	Translations$notesPage$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Notlarım'
	String get title => 'Notlarım';

	/// tr: 'Not Ekle'
	String get add => 'Not Ekle';

	/// tr: 'Notlarda ara…'
	String get searchHint => 'Notlarda ara…';

	/// tr: 'Henüz gelişim notu yok. İlk notu ekleyerek başlayın.'
	String get empty => 'Henüz gelişim notu yok. İlk notu ekleyerek başlayın.';

	/// tr: 'Sonuç bulunamadı. Filtre veya aramayı değiştirin.'
	String get noResults => 'Sonuç bulunamadı. Filtre veya aramayı değiştirin.';

	/// tr: 'Önce bir çocuk profili ekleyin.'
	String get noChildren => 'Önce bir çocuk profili ekleyin.';

	/// tr: 'Daha Fazla Yükle'
	String get loadMore => 'Daha Fazla Yükle';

	/// tr: 'Düzenle'
	String get edit => 'Düzenle';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'Vazgeç'
	String get cancel => 'Vazgeç';

	/// tr: 'Notu Sil'
	String get deleteTitle => 'Notu Sil';

	/// tr: 'Bu notu silmek istediğinize emin misiniz?'
	String get deleteConfirm => 'Bu notu silmek istediğinize emin misiniz?';

	/// tr: 'Not silindi.'
	String get deleted => 'Not silindi.';
}

// Path: notifications
class Translations$notifications$tr {
	Translations$notifications$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Göster'
	String get show => 'Göster';

	/// tr: 'Bildirimler'
	String get title => 'Bildirimler';

	/// tr: 'Henüz bildiriminiz yok.'
	String get empty => 'Henüz bildiriminiz yok.';

	/// tr: 'Tümünü okundu işaretle'
	String get markAllRead => 'Tümünü okundu işaretle';

	/// tr: '$day $month · $time'
	String dateLine({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}';
}

// Path: knowledge
class Translations$knowledge$tr {
	Translations$knowledge$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Bilgi Bankası'
	String get title => 'Bilgi Bankası';

	/// tr: 'Henüz makale eklenmemiş.'
	String get empty => 'Henüz makale eklenmemiş.';

	/// tr: 'Bu filtreye uygun içerik yok.'
	String get noResults => 'Bu filtreye uygun içerik yok.';

	/// tr: 'Tümü'
	String get filterAll => 'Tümü';

	/// tr: 'Makale'
	String get formatArticle => 'Makale';

	/// tr: 'Video'
	String get formatVideo => 'Video';

	/// tr: 'Podcast'
	String get formatPodcast => 'Podcast';

	/// tr: '$count görüntülenme'
	String views({required Object count}) => '${count} görüntülenme';

	/// tr: '$day $month $year'
	String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';

	/// tr: 'Video bağlantısı'
	String get videoLink => 'Video bağlantısı';

	/// tr: 'Podcast bağlantısı'
	String get podcastLink => 'Podcast bağlantısı';
}

// Path: appointments
class Translations$appointments$tr {
	Translations$appointments$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Randevular'
	String get title => 'Randevular';

	/// tr: 'Henüz randevunuz yok.'
	String get empty => 'Henüz randevunuz yok.';

	/// tr: 'Yaklaşan'
	String get upcoming => 'Yaklaşan';

	/// tr: 'Geçmiş'
	String get past => 'Geçmiş';

	/// tr: 'Onay Bekliyor'
	String get statusPending => 'Onay Bekliyor';

	/// tr: 'Onaylandı'
	String get statusConfirmed => 'Onaylandı';

	/// tr: 'Tamamlandı'
	String get statusCompleted => 'Tamamlandı';

	/// tr: 'İptal Edildi'
	String get statusCancelled => 'İptal Edildi';

	/// tr: 'Online Görüşme'
	String get typeOnline => 'Online Görüşme';

	/// tr: 'Yüz Yüze'
	String get typeFaceToFace => 'Yüz Yüze';

	/// tr: 'Çocuk: $name'
	String withChild({required Object name}) => 'Çocuk: ${name}';

	/// tr: '$day $month $year · $time'
	String dateLine({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}';

	/// tr: 'İptal Et'
	String get cancel => 'İptal Et';

	/// tr: 'Onayla'
	String get confirm => 'Onayla';

	/// tr: 'Tamamla'
	String get complete => 'Tamamla';

	/// tr: 'Görüşmeye Katıl'
	String get joinMeeting => 'Görüşmeye Katıl';

	/// tr: 'Randevuyu İptal Et'
	String get cancelTitle => 'Randevuyu İptal Et';

	/// tr: 'Bu randevuyu iptal etmek istediğinize emin misiniz?'
	String get cancelConfirm => 'Bu randevuyu iptal etmek istediğinize emin misiniz?';

	/// tr: 'İptal nedeni (isteğe bağlı)'
	String get cancelReasonLabel => 'İptal nedeni (isteğe bağlı)';

	/// tr: 'İptal nedeni: $reason'
	String cancelReasonShown({required Object reason}) => 'İptal nedeni: ${reason}';

	/// tr: 'Vazgeç'
	String get keepIt => 'Vazgeç';

	/// tr: 'Randevu iptal edildi.'
	String get cancelled => 'Randevu iptal edildi.';

	/// tr: 'Randevu onaylandı.'
	String get confirmed => 'Randevu onaylandı.';

	/// tr: 'Randevu tamamlandı olarak işaretlendi.'
	String get completed => 'Randevu tamamlandı olarak işaretlendi.';

	/// tr: 'Ertele'
	String get reschedule => 'Ertele';

	/// tr: 'Randevuyu Ertele'
	String get rescheduleTitle => 'Randevuyu Ertele';

	/// tr: 'Yeni Zamanı Onayla'
	String get rescheduleConfirm => 'Yeni Zamanı Onayla';

	/// tr: 'Randevu yeniden planlandı.'
	String get rescheduled => 'Randevu yeniden planlandı.';
}

// Path: expertDetail
class Translations$expertDetail$tr {
	Translations$expertDetail$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Randevu Al'
	String get bookAppointment => 'Randevu Al';

	/// tr: 'Mesaj Gönder'
	String get sendMessage => 'Mesaj Gönder';

	/// tr: 'Uzmanlık Alanları'
	String get specializationsTitle => 'Uzmanlık Alanları';

	/// tr: '$count makale'
	String articleCount({required Object count}) => '${count} makale';

	/// tr: 'Bu uzman şu an randevu kabul etmiyor.'
	String get notAcceptingPatients => 'Bu uzman şu an randevu kabul etmiyor.';
}

// Path: booking
class Translations$booking$tr {
	Translations$booking$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Randevu Al'
	String get title => 'Randevu Al';

	/// tr: 'Çocuk'
	String get childLabel => 'Çocuk';

	/// tr: 'Randevu almak için önce bir çocuk ekleyin.'
	String get noChild => 'Randevu almak için önce bir çocuk ekleyin.';

	/// tr: 'Randevu Tipi'
	String get typeLabel => 'Randevu Tipi';

	/// tr: 'Tarih'
	String get dateLabel => 'Tarih';

	/// tr: 'Tarih seçin'
	String get selectDate => 'Tarih seçin';

	/// tr: '$day $month $year'
	String dateValue({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';

	/// tr: 'Saat'
	String get timeLabel => 'Saat';

	/// tr: 'Uygun saatleri görmek için önce tarih seçin.'
	String get selectDateFirst => 'Uygun saatleri görmek için önce tarih seçin.';

	/// tr: 'Bu gün için uygun saat yok.'
	String get noSlots => 'Bu gün için uygun saat yok.';

	/// tr: 'Not (isteğe bağlı)'
	String get notesLabel => 'Not (isteğe bağlı)';

	/// tr: 'Uzmana iletmek istediğiniz not'
	String get notesHint => 'Uzmana iletmek istediğiniz not';

	/// tr: 'Randevuyu Onayla'
	String get confirm => 'Randevuyu Onayla';

	/// tr: 'Randevu oluşturuldu.'
	String get created => 'Randevu oluşturuldu.';

	/// tr: 'Lütfen bir çocuk seçin.'
	String get errorSelectChild => 'Lütfen bir çocuk seçin.';

	/// tr: 'Lütfen bir saat seçin.'
	String get errorSelectTime => 'Lütfen bir saat seçin.';
}

// Path: routines
class Translations$routines$tr {
	Translations$routines$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Rutinler'
	String get title => 'Rutinler';

	/// tr: 'Bu çocuk için henüz rutin yok.'
	String get empty => 'Bu çocuk için henüz rutin yok.';

	/// tr: 'Rutin oluşturmak için önce bir çocuk ekleyin.'
	String get noChild => 'Rutin oluşturmak için önce bir çocuk ekleyin.';

	/// tr: 'Rutin Ekle'
	String get add => 'Rutin Ekle';

	/// tr: 'Adım Ekle'
	String get addItem => 'Adım Ekle';

	/// tr: 'Henüz adım eklenmemiş.'
	String get noItems => 'Henüz adım eklenmemiş.';

	/// tr: 'Rutini Sil'
	String get deleteRoutineTitle => 'Rutini Sil';

	/// tr: '$name rutinini silmek istediğinize emin misiniz?'
	String deleteRoutineConfirm({required Object name}) => '${name} rutinini silmek istediğinize emin misiniz?';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Rutin eklendi.'
	String get created => 'Rutin eklendi.';

	/// tr: 'Adım eklendi.'
	String get itemAdded => 'Adım eklendi.';

	/// tr: 'Rutin silindi.'
	String get deleted => 'Rutin silindi.';

	/// tr: 'Adım Başlığı'
	String get itemTitleLabel => 'Adım Başlığı';

	/// tr: 'Örn. Dişleri fırçala'
	String get itemTitleHint => 'Örn. Dişleri fırçala';

	/// tr: 'Saat (isteğe bağlı)'
	String get itemTimeLabel => 'Saat (isteğe bağlı)';

	/// tr: 'Saat seç'
	String get selectTime => 'Saat seç';

	/// tr: 'İkon'
	String get itemIconLabel => 'İkon';

	/// tr: 'Ekle'
	String get itemSave => 'Ekle';

	/// tr: 'Lütfen adım başlığı girin.'
	String get errorItemTitle => 'Lütfen adım başlığı girin.';
}

// Path: routineForm
class Translations$routineForm$tr {
	Translations$routineForm$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Rutin Ekle'
	String get title => 'Rutin Ekle';

	/// tr: 'Rutin Adı'
	String get nameLabel => 'Rutin Adı';

	/// tr: 'Örn. Sabah Rutini'
	String get nameHint => 'Örn. Sabah Rutini';

	/// tr: 'Açıklama (isteğe bağlı)'
	String get descriptionLabel => 'Açıklama (isteğe bağlı)';

	/// tr: 'Bu rutin ne için?'
	String get descriptionHint => 'Bu rutin ne için?';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Lütfen bir rutin adı girin.'
	String get errorName => 'Lütfen bir rutin adı girin.';
}

// Path: dailyTracker
class Translations$dailyTracker$tr {
	Translations$dailyTracker$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Günlük Takip'
	String get title => 'Günlük Takip';

	/// tr: 'Duygu'
	String get tabMood => 'Duygu';

	/// tr: 'Uyku'
	String get tabSleep => 'Uyku';

	/// tr: 'İlaç'
	String get tabMeds => 'İlaç';

	/// tr: 'Bugün nasıldı?'
	String get todayTitle => 'Bugün nasıldı?';

	/// tr: 'Bugün'
	String get today => 'Bugün';

	/// tr: 'Çok Kötü'
	String get mood1 => 'Çok Kötü';

	/// tr: 'Kötü'
	String get mood2 => 'Kötü';

	/// tr: 'Orta'
	String get mood3 => 'Orta';

	/// tr: 'İyi'
	String get mood4 => 'İyi';

	/// tr: 'Harika'
	String get mood5 => 'Harika';

	/// tr: 'Olası tetikleyiciler (isteğe bağlı)'
	String get triggersLabel => 'Olası tetikleyiciler (isteğe bağlı)';

	/// tr: 'Not (isteğe bağlı)'
	String get notesLabel => 'Not (isteğe bağlı)';

	/// tr: 'Bugüne dair gözlemleriniz'
	String get notesHint => 'Bugüne dair gözlemleriniz';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Güncelle'
	String get update => 'Güncelle';

	/// tr: 'Ruh hali kaydedildi.'
	String get saved => 'Ruh hali kaydedildi.';

	/// tr: 'Geçmiş Kayıtlar'
	String get historyTitle => 'Geçmiş Kayıtlar';

	/// tr: 'Henüz kayıt yok. İlk kaydı bugün ekleyin.'
	String get empty => 'Henüz kayıt yok. İlk kaydı bugün ekleyin.';

	/// tr: 'Günlük takip için önce bir çocuk ekleyin.'
	String get noChild => 'Günlük takip için önce bir çocuk ekleyin.';

	/// tr: 'Kaydı Sil'
	String get deleteTitle => 'Kaydı Sil';

	/// tr: '$date tarihli kaydı silmek istediğinize emin misiniz?'
	String deleteConfirm({required Object date}) => '${date} tarihli kaydı silmek istediğinize emin misiniz?';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Kayıt silindi.'
	String get deleted => 'Kayıt silindi.';

	/// tr: 'Lütfen bir ruh hali seçin.'
	String get errorSelectMood => 'Lütfen bir ruh hali seçin.';

	/// tr: '$day $month $year'
	String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
}

// Path: sleep
class Translations$sleep$tr {
	Translations$sleep$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Dün Gece / Bu Sabah'
	String get todayTitle => 'Dün Gece / Bu Sabah';

	/// tr: 'Yatış Saati'
	String get bedtime => 'Yatış Saati';

	/// tr: 'Uyanış Saati'
	String get wakeTime => 'Uyanış Saati';

	/// tr: 'Uyku Kalitesi'
	String get quality => 'Uyku Kalitesi';

	/// tr: 'Gece uyanma sayısı'
	String get nightWakings => 'Gece uyanma sayısı';

	/// tr: 'Duyusal ve çevresel faktörler'
	String get factorsLabel => 'Duyusal ve çevresel faktörler';

	/// tr: '🛏️ Ağır Battaniye'
	String get factorWeighted => '🛏️ Ağır Battaniye';

	/// tr: '👕 Duyusal Hassasiyet'
	String get factorSensory => '👕 Duyusal Hassasiyet';

	/// tr: '💊 Melatonin Desteği'
	String get factorMelatonin => '💊 Melatonin Desteği';

	/// tr: '🔊 Gürültü / Işık'
	String get factorNoise => '🔊 Gürültü / Işık';

	/// tr: 'Uyku kaydedildi.'
	String get saved => 'Uyku kaydedildi.';

	/// tr: 'Henüz uyku kaydı yok. İlk kaydı bugün ekleyin.'
	String get empty => 'Henüz uyku kaydı yok. İlk kaydı bugün ekleyin.';

	/// tr: '$date tarihli uyku kaydını silmek istediğinize emin misiniz?'
	String deleteConfirm({required Object date}) => '${date} tarihli uyku kaydını silmek istediğinize emin misiniz?';

	/// tr: 'Uyku kaydı silindi.'
	String get deleted => 'Uyku kaydı silindi.';

	/// tr: '$h sa $m dk'
	String duration({required Object h, required Object m}) => '${h} sa ${m} dk';

	/// tr: '$count kez uyandı'
	String wakings({required Object count}) => '${count} kez uyandı';
}

// Path: meds
class Translations$meds$tr {
	Translations$meds$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'İlaç güvenliği'
	String get safetyTitle => 'İlaç güvenliği';

	/// tr: 'İlaç hatırlatıcıları destek amaçlıdır. İlaç başlama, bırakma, doz değişikliği veya yan etki kararlarını yalnızca doktorunuzla birlikte verin.'
	String get safetyBody => 'İlaç hatırlatıcıları destek amaçlıdır. İlaç başlama, bırakma, doz değişikliği veya yan etki kararlarını yalnızca doktorunuzla birlikte verin.';

	/// tr: 'İlaç Ekle'
	String get add => 'İlaç Ekle';

	/// tr: 'Yeni İlaç Ekle'
	String get addTitle => 'Yeni İlaç Ekle';

	/// tr: 'İlacı Düzenle'
	String get editTitle => 'İlacı Düzenle';

	/// tr: 'Henüz ilaç kaydı yok. Çocuğunuzun ilaç ve takviyelerini buraya ekleyin.'
	String get empty => 'Henüz ilaç kaydı yok. Çocuğunuzun ilaç ve takviyelerini buraya ekleyin.';

	/// tr: 'İlaç / Takviye Adı'
	String get name => 'İlaç / Takviye Adı';

	/// tr: 'Örn: Omega-3'
	String get nameHint => 'Örn: Omega-3';

	/// tr: 'Doz'
	String get dosage => 'Doz';

	/// tr: 'Birim'
	String get unit => 'Birim';

	/// tr: 'Sıklık'
	String get frequency => 'Sıklık';

	/// tr: 'Günde 1'
	String get freqDaily => 'Günde 1';

	/// tr: 'Günde 2'
	String get freqTwiceDaily => 'Günde 2';

	/// tr: 'Günde 3'
	String get freqThreeDaily => 'Günde 3';

	/// tr: 'Gerektiğinde'
	String get freqAsNeeded => 'Gerektiğinde';

	/// tr: 'Haftalık'
	String get freqWeekly => 'Haftalık';

	/// tr: 'Doz saatleri'
	String get timesLabel => 'Doz saatleri';

	/// tr: 'Saat Ekle'
	String get addTime => 'Saat Ekle';

	/// tr: 'Saatsiz'
	String get noTime => 'Saatsiz';

	/// tr: 'İlaç eklendi.'
	String get added => 'İlaç eklendi.';

	/// tr: 'İlaç güncellendi.'
	String get updated => 'İlaç güncellendi.';

	/// tr: 'İlacı Sil'
	String get deleteTitle => 'İlacı Sil';

	/// tr: '$name ve doz kayıtları kalıcı olarak silinecek. Emin misiniz?'
	String deleteConfirm({required Object name}) => '${name} ve doz kayıtları kalıcı olarak silinecek. Emin misiniz?';

	/// tr: 'İlaç silindi.'
	String get deleted => 'İlaç silindi.';

	/// tr: 'Lütfen ilaç adını girin.'
	String get errorName => 'Lütfen ilaç adını girin.';

	/// tr: 'Doz Günlüğü'
	String get logTitle => 'Doz Günlüğü';

	/// tr: 'İlaç alındı'
	String get taken => 'İlaç alındı';

	/// tr: 'Gözlemlenen yan etkiler'
	String get sideEffectsLabel => 'Gözlemlenen yan etkiler';

	/// tr: 'Gözlem notları (isteğe bağlı)'
	String get logNotesLabel => 'Gözlem notları (isteğe bağlı)';

	/// tr: 'Doktorunuza iletmek istediğiniz bir gözlem var mı?'
	String get logNotesHint => 'Doktorunuza iletmek istediğiniz bir gözlem var mı?';

	/// tr: 'Doz günlüğü kaydedildi.'
	String get logSaved => 'Doz günlüğü kaydedildi.';
}

// Path: wall
class Translations$wall$tr {
	Translations$wall$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Dertleşme Duvarı'
	String get title => 'Dertleşme Duvarı';

	/// tr: 'Duygularınızı paylaşın, birbirinize destek olun. Paylaşımlar anonim olabilir.'
	String get subtitle => 'Duygularınızı paylaşın, birbirinize destek olun. Paylaşımlar anonim olabilir.';

	/// tr: 'Henüz paylaşım yok. İlk paylaşımı sen yap.'
	String get empty => 'Henüz paylaşım yok. İlk paylaşımı sen yap.';

	/// tr: 'Paylaş'
	String get add => 'Paylaş';

	/// tr: 'Dertleşme Paylaşımı'
	String get addTitle => 'Dertleşme Paylaşımı';

	/// tr: 'Paylaşımı Düzenle'
	String get editTitle => 'Paylaşımı Düzenle';

	/// tr: 'Başlık (isteğe bağlı)'
	String get titleLabel => 'Başlık (isteğe bağlı)';

	/// tr: 'Kısa bir başlık'
	String get titleHint => 'Kısa bir başlık';

	/// tr: 'Ne hissediyorsun?'
	String get contentLabel => 'Ne hissediyorsun?';

	/// tr: 'İçini dökebilirsin; burada yalnız değilsin.'
	String get contentHint => 'İçini dökebilirsin; burada yalnız değilsin.';

	/// tr: 'Anonim paylaş'
	String get anonymous => 'Anonim paylaş';

	/// tr: 'Anonim Kullanıcı'
	String get anonymousUser => 'Anonim Kullanıcı';

	/// tr: 'Paylaş'
	String get post => 'Paylaş';

	/// tr: 'Paylaşımınız duvara eklendi.'
	String get posted => 'Paylaşımınız duvara eklendi.';

	/// tr: 'Paylaşım güncellendi.'
	String get updated => 'Paylaşım güncellendi.';

	/// tr: 'Paylaşımı Sil'
	String get deleteTitle => 'Paylaşımı Sil';

	/// tr: 'Bu paylaşımı silmek istediğinize emin misiniz?'
	String get deleteConfirm => 'Bu paylaşımı silmek istediğinize emin misiniz?';

	/// tr: 'Paylaşım silindi.'
	String get deleted => 'Paylaşım silindi.';

	/// tr: 'Lütfen bir şeyler yazın.'
	String get errorContent => 'Lütfen bir şeyler yazın.';

	/// tr: '$count destek'
	String supportCount({required Object count}) => '${count} destek';

	/// tr: '$count yorum'
	String commentCount({required Object count}) => '${count} yorum';

	/// tr: 'Paylaşım'
	String get detailTitle => 'Paylaşım';

	/// tr: 'Destek Mesajları'
	String get commentsTitle => 'Destek Mesajları';

	/// tr: 'Bir destek mesajı yaz…'
	String get commentHint => 'Bir destek mesajı yaz…';

	/// tr: 'Gönder'
	String get commentSend => 'Gönder';

	/// tr: 'Destek mesajı gönderildi.'
	String get commentSent => 'Destek mesajı gönderildi.';

	/// tr: 'Henüz destek mesajı yok. İlk desteği sen ver.'
	String get commentEmpty => 'Henüz destek mesajı yok. İlk desteği sen ver.';

	/// tr: 'Yorumu Sil'
	String get commentDeleteTitle => 'Yorumu Sil';

	/// tr: 'Bu destek mesajını silmek istediğinize emin misiniz?'
	String get commentDeleteConfirm => 'Bu destek mesajını silmek istediğinize emin misiniz?';

	/// tr: 'Yorum silindi.'
	String get commentDeleted => 'Yorum silindi.';

	/// tr: 'Düzenle'
	String get edit => 'Düzenle';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'az önce'
	String get justNow => 'az önce';

	/// tr: '$count dk önce'
	String minsAgo({required Object count}) => '${count} dk önce';

	/// tr: '$count sa önce'
	String hoursAgo({required Object count}) => '${count} sa önce';

	/// tr: '$count gün önce'
	String daysAgo({required Object count}) => '${count} gün önce';
}

// Path: weekly
class Translations$weekly$tr {
	Translations$weekly$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Haftanın Sorusu'
	String get title => 'Haftanın Sorusu';

	/// tr: 'Bu hafta ailelere sorduğumuz soru. Deneyimini paylaş, birbirinize destek olun.'
	String get subtitle => 'Bu hafta ailelere sorduğumuz soru. Deneyimini paylaş, birbirinize destek olun.';

	/// tr: 'Henüz haftalık soru yok. Yeni soru yayınlandığında burada olacak.'
	String get empty => 'Henüz haftalık soru yok. Yeni soru yayınlandığında burada olacak.';

	/// tr: 'Aile Cevapları'
	String get answersTitle => 'Aile Cevapları';

	/// tr: '$count cevap'
	String answerCount({required Object count}) => '${count} cevap';

	/// tr: '$count uzman'
	String expertCount({required Object count}) => '${count} uzman';

	/// tr: 'Uzman'
	String get expertBadge => 'Uzman';

	/// tr: 'Anonim Aile'
	String get anonymousUser => 'Anonim Aile';

	/// tr: 'Cevabını Yaz'
	String get yourAnswerTitle => 'Cevabını Yaz';

	/// tr: 'Kısa da olsa değerli. Deneyimini paylaş…'
	String get answerHint => 'Kısa da olsa değerli. Deneyimini paylaş…';

	/// tr: 'Anonim paylaş'
	String get anonymous => 'Anonim paylaş';

	/// tr: 'Etiketler (isteğe bağlı)'
	String get tagsLabel => 'Etiketler (isteğe bağlı)';

	/// tr: 'Paylaş'
	String get send => 'Paylaş';

	/// tr: 'Cevabın paylaşıldı, teşekkürler!'
	String get sent => 'Cevabın paylaşıldı, teşekkürler!';

	/// tr: 'Lütfen bir cevap yazın.'
	String get errorEmpty => 'Lütfen bir cevap yazın.';

	/// tr: 'Henüz cevap yok. İlk cevabı sen paylaş.'
	String get noAnswers => 'Henüz cevap yok. İlk cevabı sen paylaş.';

	/// tr: 'Beğeni kaydedilemedi.'
	String get likeError => 'Beğeni kaydedilemedi.';

	/// tr: 'az önce'
	String get justNow => 'az önce';

	/// tr: '$count dk önce'
	String minsAgo({required Object count}) => '${count} dk önce';

	/// tr: '$count sa önce'
	String hoursAgo({required Object count}) => '${count} sa önce';

	/// tr: '$count gün önce'
	String daysAgo({required Object count}) => '${count} gün önce';
}

// Path: meetup
class Translations$meetup$tr {
	Translations$meetup$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Yerel Buluşmalar'
	String get title => 'Yerel Buluşmalar';

	/// tr: 'Şehrindeki ailelerle tanış, birlikte vakit geçir.'
	String get subtitle => 'Şehrindeki ailelerle tanış, birlikte vakit geçir.';

	/// tr: 'Bu şehirde henüz buluşma yok. İlk buluşmayı sen oluştur.'
	String get empty => 'Bu şehirde henüz buluşma yok. İlk buluşmayı sen oluştur.';

	/// tr: 'Buluşma Oluştur'
	String get add => 'Buluşma Oluştur';

	/// tr: 'Yeni Buluşma'
	String get addTitle => 'Yeni Buluşma';

	/// tr: 'Buluşma Adı'
	String get titleLabel => 'Buluşma Adı';

	/// tr: 'ör: Parkta Sabah Buluşması'
	String get titleHint => 'ör: Parkta Sabah Buluşması';

	/// tr: 'Şehir'
	String get cityLabel => 'Şehir';

	/// tr: 'Şehir seç'
	String get cityHint => 'Şehir seç';

	/// tr: 'İlçe'
	String get districtLabel => 'İlçe';

	/// tr: 'ör: Kadıköy'
	String get districtHint => 'ör: Kadıköy';

	/// tr: 'Buluşma Yeri'
	String get venueLabel => 'Buluşma Yeri';

	/// tr: 'ör: Moda Parkı veya kafe adı'
	String get venueHint => 'ör: Moda Parkı veya kafe adı';

	/// tr: 'Tarih'
	String get dateLabel => 'Tarih';

	/// tr: 'Saat'
	String get timeLabel => 'Saat';

	/// tr: 'Açıklama'
	String get descriptionLabel => 'Açıklama';

	/// tr: 'Kimler katılabilir, ortam nasıl olacak?'
	String get descriptionHint => 'Kimler katılabilir, ortam nasıl olacak?';

	/// tr: 'Oluştur'
	String get create => 'Oluştur';

	/// tr: 'Buluşman oluşturuldu. Diğer aileler görebilecek.'
	String get created => 'Buluşman oluşturuldu. Diğer aileler görebilecek.';

	/// tr: 'Lütfen başlık, şehir ve tarih alanlarını doldurun.'
	String get errorRequired => 'Lütfen başlık, şehir ve tarih alanlarını doldurun.';

	/// tr: '$count katılımcı'
	String attendCount({required Object count}) => '${count} katılımcı';

	/// tr: 'Katıl'
	String get join => 'Katıl';

	/// tr: 'Katılıyorsun'
	String get joined => 'Katılıyorsun';

	/// tr: 'Buluşmaya katılıyorsun!'
	String get joinedMsg => 'Buluşmaya katılıyorsun!';

	/// tr: 'Katılımın iptal edildi.'
	String get leftMsg => 'Katılımın iptal edildi.';

	/// tr: 'Bugün'
	String get today => 'Bugün';

	/// tr: 'Yarın'
	String get tomorrow => 'Yarın';

	/// tr: '$count gün sonra'
	String inDays({required Object count}) => '${count} gün sonra';

	/// tr: 'Geçmiş'
	String get past => 'Geçmiş';

	/// tr: 'Düzenleyen $name'
	String organizerBy({required Object name}) => 'Düzenleyen ${name}';
}

// Path: similar
class Translations$similar$tr {
	Translations$similar$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Benzer Aileler'
	String get title => 'Benzer Aileler';

	/// tr: 'Çocuğunuza yakın gelişim sürecindeki ailelerle tanışın, deneyim paylaşın.'
	String get subtitle => 'Çocuğunuza yakın gelişim sürecindeki ailelerle tanışın, deneyim paylaşın.';

	/// tr: 'Önce bir çocuk ekleyin, sonra benzer aileleri keşfedin.'
	String get noChild => 'Önce bir çocuk ekleyin, sonra benzer aileleri keşfedin.';

	/// tr: 'Eşleştirmede görünürsün'
	String get discoverable => 'Eşleştirmede görünürsün';

	/// tr: 'Eşleştirmede gizlisin'
	String get hidden => 'Eşleştirmede gizlisin';

	/// tr: 'Kapatırsan diğer aileler seni öneriler arasında göremez.'
	String get discoverableHint => 'Kapatırsan diğer aileler seni öneriler arasında göremez.';

	/// tr: 'Şu an eşleşen aile yok. Profilinizi ve etiketlerinizi güncelleyerek eşleşme şansını artırabilirsiniz.'
	String get empty => 'Şu an eşleşen aile yok. Profilinizi ve etiketlerinizi güncelleyerek eşleşme şansını artırabilirsiniz.';

	/// tr: 'uyum'
	String get matchLabel => 'uyum';

	/// tr: 'Ortak alanlar'
	String get commonTagsTitle => 'Ortak alanlar';

	/// tr: '+$count'
	String moreTags({required Object count}) => '+${count}';

	/// tr: 'Neden eşleştiniz'
	String get reasonsTitle => 'Neden eşleştiniz';

	/// tr: 'Yaş $range'
	String ageRange({required Object range}) => 'Yaş ${range}';

	/// tr: 'Mesaj'
	String get message => 'Mesaj';

	/// tr: 'Arkadaş'
	String get buddy => 'Arkadaş';

	/// tr: 'Mentor'
	String get mentor => 'Mentor';

	/// tr: 'İstek bekliyor'
	String get pendingLabel => 'İstek bekliyor';

	/// tr: 'Arkadaş bağlantısı'
	String get buddyLabel => 'Arkadaş bağlantısı';

	/// tr: 'Mentor bağlantısı'
	String get mentorLabel => 'Mentor bağlantısı';

	/// tr: 'Bağlantı isteği'
	String get requestTitle => 'Bağlantı isteği';

	/// tr: 'Mentor isteği'
	String get mentorRequestTitle => 'Mentor isteği';

	/// tr: 'Kısa bir tanışma mesajı yaz (isteğe bağlı)'
	String get requestHint => 'Kısa bir tanışma mesajı yaz (isteğe bağlı)';

	/// tr: 'Merhaba, benzer süreçlerden geçtiğimizi gördüm. Uygunsanız önce burada kısa bir tanışma mesajlaşması yapmak isterim.'
	String get requestDefault => 'Merhaba, benzer süreçlerden geçtiğimizi gördüm. Uygunsanız önce burada kısa bir tanışma mesajlaşması yapmak isterim.';

	/// tr: 'İsteği Gönder'
	String get send => 'İsteği Gönder';

	/// tr: 'Bağlantı isteği gönderildi.'
	String get sent => 'Bağlantı isteği gönderildi.';

	/// tr: 'İptal'
	String get cancel => 'İptal';
}

// Path: groups
class Translations$groups$tr {
	Translations$groups$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Destek Grupları'
	String get title => 'Destek Grupları';

	/// tr: 'Benzer konularda ailelerle bir araya gel, grup sohbetine katıl.'
	String get subtitle => 'Benzer konularda ailelerle bir araya gel, grup sohbetine katıl.';

	/// tr: 'Gruplarım'
	String get tabMy => 'Gruplarım';

	/// tr: 'Keşfet'
	String get tabDiscover => 'Keşfet';

	/// tr: 'Grup ara…'
	String get searchHint => 'Grup ara…';

	/// tr: 'Tümü'
	String get allCategories => 'Tümü';

	/// tr: 'Henüz bir gruba katılmadın. Keşfet sekmesinden gruplara göz at.'
	String get emptyMy => 'Henüz bir gruba katılmadın. Keşfet sekmesinden gruplara göz at.';

	/// tr: 'Bu ölçütlerle grup bulunamadı. Yeni bir grup oluşturabilirsin.'
	String get emptyDiscover => 'Bu ölçütlerle grup bulunamadı. Yeni bir grup oluşturabilirsin.';

	/// tr: '$count üye'
	String memberCount({required Object count}) => '${count} üye';

	/// tr: '$count uzman'
	String expertCount({required Object count}) => '${count} uzman';

	/// tr: 'Onaylı'
	String get verified => 'Onaylı';

	/// tr: 'Katıl'
	String get join => 'Katıl';

	/// tr: 'Katıldın'
	String get joined => 'Katıldın';

	/// tr: 'Ayrıl'
	String get leave => 'Ayrıl';

	/// tr: 'Grup Sohbeti'
	String get chat => 'Grup Sohbeti';

	/// tr: 'Gruba katıldın.'
	String get joinedMsg => 'Gruba katıldın.';

	/// tr: 'Gruptan ayrıldın.'
	String get leftMsg => 'Gruptan ayrıldın.';

	/// tr: 'Gruptan Ayrıl'
	String get leaveTitle => 'Gruptan Ayrıl';

	/// tr: 'Bu gruptan ayrılmak istediğine emin misin?'
	String get leaveConfirm => 'Bu gruptan ayrılmak istediğine emin misin?';

	/// tr: 'Grup Oluştur'
	String get add => 'Grup Oluştur';

	/// tr: 'Yeni Grup'
	String get addTitle => 'Yeni Grup';

	/// tr: 'Grup Adı'
	String get nameLabel => 'Grup Adı';

	/// tr: 'ör: İstanbul Erken Müdahale'
	String get nameHint => 'ör: İstanbul Erken Müdahale';

	/// tr: 'Açıklama'
	String get descriptionLabel => 'Açıklama';

	/// tr: 'Grup ne hakkında, kimler katılabilir?'
	String get descriptionHint => 'Grup ne hakkında, kimler katılabilir?';

	/// tr: 'Kategori'
	String get categoryLabel => 'Kategori';

	/// tr: 'Oluştur'
	String get create => 'Oluştur';

	/// tr: 'Grup oluşturuldu.'
	String get created => 'Grup oluşturuldu.';

	/// tr: 'Lütfen bir grup adı girin.'
	String get errorName => 'Lütfen bir grup adı girin.';
}

// Path: treatment
class Translations$treatment$tr {
	Translations$treatment$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Tedavi Paneli'
	String get title => 'Tedavi Paneli';

	/// tr: 'Günlük Destek Planı'
	String get subtitle => 'Günlük Destek Planı';

	/// tr: '$name planı aktif'
	String programActive({required Object name}) => '${name} planı aktif';

	/// tr: 'Profil seç'
	String get selectChild => 'Profil seç';

	/// tr: 'Henüz çocuk profili yok'
	String get noChildrenTitle => 'Henüz çocuk profili yok';

	/// tr: 'Tedavi planı için önce bir çocuk profili ekleyin.'
	String get noChildrenBody => 'Tedavi planı için önce bir çocuk profili ekleyin.';

	/// tr: 'Çocuk Ekle'
	String get addChild => 'Çocuk Ekle';

	/// tr: 'Tedavi verileri kaydedilemedi, değişiklik geri alındı.'
	String get saveError => 'Tedavi verileri kaydedilemedi, değişiklik geri alındı.';

	/// tr: 'Bugün'
	String get tabToday => 'Bugün';

	/// tr: 'Hedefler'
	String get tabGoals => 'Hedefler';

	/// tr: 'Oyunlar'
	String get tabGames => 'Oyunlar';

	/// tr: 'Araçlar'
	String get tabTools => 'Araçlar';

	List<String> get daysShort => [
		'Paz',
		'Pzt',
		'Sal',
		'Çar',
		'Per',
		'Cum',
		'Cmt',
	];

	/// tr: 'Merhaba! 3 adımda başlayın 👋'
	String get onboardTitle => 'Merhaba! 3 adımda başlayın 👋';

	/// tr: 'Bu sayfa, her gün çocuğunuzla yapabileceğiniz küçük destekleri takip etmenizi sağlar.'
	String get onboardBody => 'Bu sayfa, her gün çocuğunuzla yapabileceğiniz küçük destekleri takip etmenizi sağlar.';

	/// tr: '1. Hedefler sekmesinden bugün takip etmek istediğiniz küçük bir şey yazın.'
	String get onboardStep1 => '1. Hedefler sekmesinden bugün takip etmek istediğiniz küçük bir şey yazın.';

	/// tr: '2. Oyunlar sekmesindeki 5-10 dakikalık etkinlikleri deneyin.'
	String get onboardStep2 => '2. Oyunlar sekmesindeki 5-10 dakikalık etkinlikleri deneyin.';

	/// tr: '3. Oyun sonrası "Kolay geldi / Zorlandı" seçin — gerisini sistem halleder.'
	String get onboardStep3 => '3. Oyun sonrası "Kolay geldi / Zorlandı" seçin — gerisini sistem halleder.';

	/// tr: 'Bugünün kısa planı'
	String get todayTitle => 'Bugünün kısa planı';

	/// tr: 'Bir madde seçin, uygulayın, sonra tamamlandı olarak işaretleyin.'
	String get todaySubtitle => 'Bir madde seçin, uygulayın, sonra tamamlandı olarak işaretleyin.';

	/// tr: '$count gün seri'
	String streakDays({required Object count}) => '${count} gün seri';

	/// tr: '$done/$total yapıldı'
	String doneOf({required Object done, required Object total}) => '${done}/${total} yapıldı';

	/// tr: '$count adım'
	String stepCount({required Object count}) => '${count} adım';

	/// tr: 'Bugün için plan bulunamadı.'
	String get emptyPlanTitle => 'Bugün için plan bulunamadı.';

	/// tr: 'Hedef eklediğinizde burada kısa günlük adımlar görünecek.'
	String get emptyPlanBody => 'Hedef eklediğinizde burada kısa günlük adımlar görünecek.';

	/// tr: 'Bugünün planı tamamlandı.'
	String get planDone => 'Bugünün planı tamamlandı.';

	/// tr: 'Bugünlük bu kadar yeterli.'
	String get planDoneSub => 'Bugünlük bu kadar yeterli.';

	/// tr: 'Bugünkü ruh halini kaydet'
	String get moodSaveTitle => 'Bugünkü ruh halini kaydet';

	/// tr: 'Plan, çocuğun durumuna göre otomatik uyarlanır'
	String get moodSaveSub => 'Plan, çocuğun durumuna göre otomatik uyarlanır';

	/// tr: 'Bugünkü ruh hali: $label'
	String moodTodayLabel({required Object label}) => 'Bugünkü ruh hali: ${label}';

	/// tr: 'Plan bu duruma göre hazırlandı'
	String get moodPlanned => 'Plan bu duruma göre hazırlandı';

	/// tr: 'Zorlanıyor'
	String get moodLevel1 => 'Zorlanıyor';

	/// tr: 'Hassas'
	String get moodLevel2 => 'Hassas';

	/// tr: 'Dengeli'
	String get moodLevel3 => 'Dengeli';

	/// tr: 'İyi'
	String get moodLevel4 => 'İyi';

	/// tr: 'Çok iyi'
	String get moodLevel5 => 'Çok iyi';

	/// tr: 'Bugün dikkat edilecekler'
	String get suggestionsTitle => 'Bugün dikkat edilecekler';

	/// tr: 'Son not'
	String get latestNoteTitle => 'Son not';

	/// tr: 'Uzman Terapist'
	String get defaultExpert => 'Uzman Terapist';

	/// tr: 'Platform Terapi Modülü'
	String get noNoteAuthor => 'Platform Terapi Modülü';

	/// tr: 'Otomatik günlük plan'
	String get noNoteRole => 'Otomatik günlük plan';

	/// tr: 'Henüz uzman notu yok. Bugünün planı, çocuğunuzun kayıtlarına göre hazırlandı.'
	String get noNoteBody => 'Henüz uzman notu yok. Bugünün planı, çocuğunuzun kayıtlarına göre hazırlandı.';

	/// tr: 'Bu nota eklenmiş detay bulunmuyor.'
	String get noteEmptyContent => 'Bu nota eklenmiş detay bulunmuyor.';

	/// tr: 'Haftalık özet'
	String get weeklyTitle => 'Haftalık özet';

	/// tr: 'Bu bölüm sadece genel durumu gösterir.'
	String get weeklySubtitle => 'Bu bölüm sadece genel durumu gösterir.';

	/// tr: 'Oyun'
	String get legendGame => 'Oyun';

	/// tr: 'Hedef'
	String get legendGoal => 'Hedef';

	/// tr: '$count oyun'
	String chartGames({required Object count}) => '${count} oyun';

	/// tr: '%$percent hedef'
	String chartGoal({required Object percent}) => '%${percent} hedef';

	/// tr: 'Bu hafta oyun'
	String get weekGamesTitle => 'Bu hafta oyun';

	/// tr: 'Bu hafta tekrar edilen mini egzersiz sayısı'
	String get weekGamesDetail => 'Bu hafta tekrar edilen mini egzersiz sayısı';

	/// tr: 'Bugün ilk oyunu planlayabilirsiniz'
	String get weekGamesEmpty => 'Bugün ilk oyunu planlayabilirsiniz';

	/// tr: 'Tamamlanan hedef'
	String get weekGoalsTitle => 'Tamamlanan hedef';

	/// tr: 'Tüm aktif beceri alanlarındaki toplam ilerleme'
	String get weekGoalsDetail => 'Tüm aktif beceri alanlarındaki toplam ilerleme';

	/// tr: 'Hedefler sekmesinden hedef ekleyebilirsiniz'
	String get weekGoalsEmpty => 'Hedefler sekmesinden hedef ekleyebilirsiniz';

	/// tr: 'Yaklaşan Seans'
	String get weekSessionsTitle => 'Yaklaşan Seans';

	/// tr: 'Planlanmış randevu veya etkinlik'
	String get weekSessionsDetail => 'Planlanmış randevu veya etkinlik';

	/// tr: 'Henüz randevu planlanmamış'
	String get weekSessionsEmpty => 'Henüz randevu planlanmamış';

	/// tr: 'Gelişim alanları'
	String get microTitle => 'Gelişim alanları';

	/// tr: 'Ayrıntıya gerek olduğunda buraya bakabilirsiniz.'
	String get microSubtitle => 'Ayrıntıya gerek olduğunda buraya bakabilirsiniz.';

	/// tr: 'Destekleyen oyun:'
	String get microLinkedGame => 'Destekleyen oyun:';

	/// tr: 'Günlük Hedef Ekle'
	String get addGoalTitle => 'Günlük Hedef Ekle';

	/// tr: 'Bugün çocuğunuza özel takip etmek istediğiniz küçük bir şey yazın.'
	String get addGoalSubtitle => 'Bugün çocuğunuza özel takip etmek istediğiniz küçük bir şey yazın.';

	/// tr: 'Örn: 2 kez göz teması kurdu'
	String get goalHint => 'Örn: 2 kez göz teması kurdu';

	/// tr: 'Hedef alanı'
	String get focusLabel => 'Hedef alanı';

	/// tr: 'Bitiş tarihi (isteğe bağlı)'
	String get dueDateLabel => 'Bitiş tarihi (isteğe bağlı)';

	/// tr: 'Hedef Ekle'
	String get addGoal => 'Hedef Ekle';

	/// tr: 'Kaydediliyor…'
	String get saving => 'Kaydediliyor…';

	/// tr: 'Sizin eklediğiniz hedefler'
	String get yourGoals => 'Sizin eklediğiniz hedefler';

	/// tr: 'Düzenle'
	String get edit => 'Düzenle';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Vazgeç'
	String get cancel => 'Vazgeç';

	/// tr: 'Yeni hedef eklendi.'
	String get goalAdded => 'Yeni hedef eklendi.';

	/// tr: 'Hedef güncellendi.'
	String get goalUpdated => 'Hedef güncellendi.';

	/// tr: 'Hedef düzenlendi.'
	String get goalEdited => 'Hedef düzenlendi.';

	/// tr: 'Hedef silindi.'
	String get goalDeleted => 'Hedef silindi.';

	/// tr: 'Terapi Hedefleri — Alana Göre İlerleme'
	String get groupsHeader => 'Terapi Hedefleri — Alana Göre İlerleme';

	/// tr: '$done/$total tamamlandı'
	String groupDone({required Object done, required Object total}) => '${done}/${total} tamamlandı';

	/// tr: 'Tamamlandı'
	String get statusDone => 'Tamamlandı';

	/// tr: 'Devam'
	String get statusActive => 'Devam';

	/// tr: 'Sırada'
	String get statusUpcoming => 'Sırada';

	/// tr: 'Henüz terapi hedefi görünmüyor'
	String get emptyGroupsTitle => 'Henüz terapi hedefi görünmüyor';

	/// tr: 'Çocuğunuzun profiline terapi türü eklendiğinde hedefler otomatik olarak burada listelenir.'
	String get emptyGroupsBody => 'Çocuğunuzun profiline terapi türü eklendiğinde hedefler otomatik olarak burada listelenir.';

	/// tr: 'Büyük Bir Başarı Kaydet 🏅'
	String get milestoneTitle => 'Büyük Bir Başarı Kaydet 🏅';

	/// tr: 'Hatırlamak istediğiniz önemli bir an'
	String get milestoneSubtitle => 'Hatırlamak istediğiniz önemli bir an';

	/// tr: 'Örn: İlk kez adını söyledi'
	String get milestoneHint => 'Örn: İlk kez adını söyledi';

	/// tr: 'Kilometre taşı kaydedildi 🎉'
	String get milestoneSaved => 'Kilometre taşı kaydedildi 🎉';

	/// tr: 'Son Gözlem Notları'
	String get notesTitle => 'Son Gözlem Notları';

	/// tr: 'Henüz bu çocuğa ait uzman veya ebeveyn notu yok.'
	String get notesEmpty => 'Henüz bu çocuğa ait uzman veya ebeveyn notu yok.';

	/// tr: 'Yaklaşan Etkinlikler'
	String get upcomingTitle => 'Yaklaşan Etkinlikler';

	/// tr: 'Yakın tarihte planlanmış aktif seans veya etkinlik görünmüyor.'
	String get upcomingEmpty => 'Yakın tarihte planlanmış aktif seans veya etkinlik görünmüyor.';

	/// tr: 'Randevular'
	String get goAppointments => 'Randevular';

	/// tr: 'Takvime Git'
	String get goCalendar => 'Takvime Git';

	/// tr: 'Günlük Aktiviteler'
	String get gamesTitle => 'Günlük Aktiviteler';

	/// tr: 'Çocuğunuzun terapi hedeflerine göre önerilen kısa etkinlikler. Oynadıktan sonra nasıl gittiğini seçin.'
	String get gamesSubtitle => 'Çocuğunuzun terapi hedeflerine göre önerilen kısa etkinlikler. Oynadıktan sonra nasıl gittiğini seçin.';

	/// tr: '$done/$total bugün tamamlandı'
	String todayDone({required Object done, required Object total}) => '${done}/${total} bugün tamamlandı';

	/// tr: 'Tümü'
	String get filterAll => 'Tümü';

	/// tr: 'Hazır'
	String get gameReady => 'Hazır';

	/// tr: '✅ Yapıldı'
	String get gameDoneBadge => '✅ Yapıldı';

	/// tr: 'Yöntem: $name'
	String methodLabel({required Object name}) => 'Yöntem: ${name}';

	/// tr: 'Neden iyi gelir?'
	String get whyGood => 'Neden iyi gelir?';

	/// tr: 'Hedef: $name'
	String goalBadge({required Object name}) => 'Hedef: ${name}';

	/// tr: 'Araç: $name'
	String toolBadge({required Object name}) => 'Araç: ${name}';

	/// tr: 'Bugün oynat'
	String get playToday => 'Bugün oynat';

	/// tr: 'Yapıldı olarak işaretli'
	String get playedToday => 'Yapıldı olarak işaretli';

	/// tr: 'Nasıl gitti? (isteğe bağlı)'
	String get feedbackQuestion => 'Nasıl gitti? (isteğe bağlı)';

	/// tr: 'Henüz sonuç seçilmedi'
	String get fbNone => 'Henüz sonuç seçilmedi';

	/// tr: 'Çok kolay'
	String get fbEasy => 'Çok kolay';

	/// tr: 'Yardımla'
	String get fbAssisted => 'Yardımla';

	/// tr: 'Kendi başına'
	String get fbIndependent => 'Kendi başına';

	/// tr: 'Zorlandı'
	String get fbChallenging => 'Zorlandı';

	/// tr: 'Kolay geldi'
	String get fbEasyLong => 'Kolay geldi';

	/// tr: 'Yardımla yaptı'
	String get fbAssistedLong => 'Yardımla yaptı';

	/// tr: 'Tek başına yaptı'
	String get fbIndependentLong => 'Tek başına yaptı';

	/// tr: 'Zorlandı'
	String get fbChallengingLong => 'Zorlandı';

	/// tr: 'Oyun geri bildirimi kaydedildi.'
	String get feedbackSaved => 'Oyun geri bildirimi kaydedildi.';

	/// tr: '🎉 Bugünün tüm oyunları tamamlandı. Harika gidiyorsunuz!'
	String get allDoneTitle => '🎉 Bugünün tüm oyunları tamamlandı. Harika gidiyorsunuz!';

	/// tr: 'Bugünkü destek akışını tamamladınız; isterseniz notlar bölümüne kısa bir gözlem ekleyebilirsiniz.'
	String get allDoneBody => 'Bugünkü destek akışını tamamladınız; isterseniz notlar bölümüne kısa bir gözlem ekleyebilirsiniz.';

	/// tr: 'Ustalık kazandı! Daha zor varyant deneyin.'
	String get hintMastered => 'Ustalık kazandı! Daha zor varyant deneyin.';

	/// tr: 'Çok kolay geliyor. Zorluk artırın.'
	String get hintEasy => 'Çok kolay geliyor. Zorluk artırın.';

	/// tr: 'Zorlanıyor. Aktiviteyi parçalara bölün.'
	String get hintChallenging => 'Zorlanıyor. Aktiviteyi parçalara bölün.';

	/// tr: 'Uzmana Bildir'
	String get notifyExpert => 'Uzmana Bildir';

	/// tr: '$game aktivitesindeki zorlanma hakkında uzmanınıza kısa bir not gönderin.'
	String notifyBody({required Object game}) => '${game} aktivitesindeki zorlanma hakkında uzmanınıza kısa bir not gönderin.';

	/// tr: '"$game" aktivitesinde son zamanlarda zorlanıyor. Önerisi olan var mı?'
	String notifyDefaultMsg({required Object game}) => '"${game}" aktivitesinde son zamanlarda zorlanıyor. Önerisi olan var mı?';

	/// tr: 'Henüz mesajlaştığınız bir uzman yok. Önce bir uzmanla bağlantı kurmanız gerekiyor.'
	String get notifyNoExpert => 'Henüz mesajlaştığınız bir uzman yok. Önce bir uzmanla bağlantı kurmanız gerekiyor.';

	/// tr: 'Uzmanları Görüntüle'
	String get notifySeeExperts => 'Uzmanları Görüntüle';

	/// tr: 'Gönder'
	String get notifySend => 'Gönder';

	/// tr: 'Uzmana bildirildi.'
	String get notifySent => 'Uzmana bildirildi.';

	/// tr: 'Bu alanda henüz etkinlik önerilmiyor. Çocuğunuzun profil sayfasına terapi bilgisi eklediğinizde etkinlikler burada görünür.'
	String get emptyGames => 'Bu alanda henüz etkinlik önerilmiyor. Çocuğunuzun profil sayfasına terapi bilgisi eklediğinizde etkinlikler burada görünür.';

	/// tr: 'Oyun Geçmişi'
	String get historyTitle => 'Oyun Geçmişi';

	/// tr: 'Oynadığınız etkinliklerin geçmişi burada görünür.'
	String get historySubtitle => 'Oynadığınız etkinliklerin geçmişi burada görünür.';

	/// tr: '$count kayıt'
	String historyCount({required Object count}) => '${count} kayıt';

	/// tr: 'Henüz oyun kaydı yok. İlk kayıt oluşturulduğunda geçmiş burada görünür.'
	String get historyEmpty => 'Henüz oyun kaydı yok. İlk kayıt oluşturulduğunda geçmiş burada görünür.';

	/// tr: '💪 $count etkinlikte "Zorlandı" işaretlenmiş. Zorlanılan etkinlikleri tekrar denerken daha küçük adımlara bölmeyi ya da uzmanınıza bildirmeyi düşünebilirsiniz.'
	String challengingSummary({required Object count}) => '💪 ${count} etkinlikte "Zorlandı" işaretlenmiş. Zorlanılan etkinlikleri tekrar denerken daha küçük adımlara bölmeyi ya da uzmanınıza bildirmeyi düşünebilirsiniz.';

	/// tr: 'Sosyal Hikâyeler ve Görsel Akış'
	String get storiesTitle => 'Sosyal Hikâyeler ve Görsel Akış';

	/// tr: 'Bir etkinliğe başlamadan önce çocuğunuza "Ne olacak?" sorusunu yanıtlayan kısa resimli hikâyeler — geçişleri kolaylaştırır.'
	String get storiesSubtitle => 'Bir etkinliğe başlamadan önce çocuğunuza "Ne olacak?" sorusunu yanıtlayan kısa resimli hikâyeler — geçişleri kolaylaştırır.';

	/// tr: 'Özel hikâye'
	String get customBadge => 'Özel hikâye';

	/// tr: 'Bağlı hedef: $name'
	String linkedGoalBadge({required Object name}) => 'Bağlı hedef: ${name}';

	/// tr: 'Özel Sosyal Hikâye Ekle'
	String get addStoryTitle => 'Özel Sosyal Hikâye Ekle';

	/// tr: 'Hikâye başlığı (örn: Alışverişe Gidiyorum)'
	String get storyTitleHint => 'Hikâye başlığı (örn: Alışverişe Gidiyorum)';

	/// tr: 'Bağlı hedef (isteğe bağlı)'
	String get storyGoalHint => 'Bağlı hedef (isteğe bağlı)';

	/// tr: 'Ekle'
	String get storyAdd => 'Ekle';

	/// tr: 'Sosyal hikâye eklendi.'
	String get storyAdded => 'Sosyal hikâye eklendi.';

	/// tr: 'Hikâye silindi.'
	String get storyDeleted => 'Hikâye silindi.';

	/// tr: 'Hikâyeyi Sil'
	String get deleteStoryTitle => 'Hikâyeyi Sil';

	/// tr: 'Bu hikâyeyi silmek istediğinize emin misiniz?'
	String get deleteStoryConfirm => 'Bu hikâyeyi silmek istediğinize emin misiniz?';

	/// tr: 'Rahatlatan Şeyler Ayarları'
	String get sensoryTitle => 'Rahatlatan Şeyler Ayarları';

	/// tr: 'Ölçüm Kartları'
	String get sensorySubtitle => 'Ölçüm Kartları';

	/// tr: 'Duyusal profil güncellendi.'
	String get sensorySaved => 'Duyusal profil güncellendi.';

	/// tr: 'Duyusal Hassasiyet Seviyeleri'
	String get sliderHeader => 'Duyusal Hassasiyet Seviyeleri';

	/// tr: '🔊 Ses Hassasiyeti'
	String get sliderSound => '🔊 Ses Hassasiyeti';

	/// tr: '🖐️ Dokunsal Hassasiyet'
	String get sliderTouch => '🖐️ Dokunsal Hassasiyet';

	/// tr: '👁️ Görsel Hassasiyet'
	String get sliderVisual => '👁️ Görsel Hassasiyet';

	/// tr: 'Ses hassasiyeti'
	String get metricSound => 'Ses hassasiyeti';

	/// tr: 'Dokunsal hassasiyet'
	String get metricTouch => 'Dokunsal hassasiyet';

	/// tr: 'Görsel uyarı toleransı'
	String get metricVisual => 'Görsel uyarı toleransı';

	/// tr: 'Geçişlerde duyusal mola oyunu ile birlikte izleniyor.'
	String get metricSoundNote => 'Geçişlerde duyusal mola oyunu ile birlikte izleniyor.';

	/// tr: 'Dokunsal uyaranlar sıra alma ve basınç aktiviteleriyle destekleniyor.'
	String get metricTouchNote => 'Dokunsal uyaranlar sıra alma ve basınç aktiviteleriyle destekleniyor.';

	/// tr: 'Görsel hikâyeler ve zaman çizelgesi ile dengede tutuluyor.'
	String get metricVisualNote => 'Görsel hikâyeler ve zaman çizelgesi ile dengede tutuluyor.';

	/// tr: 'Tetikleyici Günlüğü'
	String get triggerTitle => 'Tetikleyici Günlüğü';

	/// tr: 'Dijital Jeton Panosu'
	String get tokenTitle => 'Dijital Jeton Panosu';

	/// tr: 'Çocuğunuzla bir hedef seçin. Görevleri başardıkça yıldız ekleyin. 5 yıldıza ulaştığında hak ettiği ödülü kazansın!'
	String get tokenSubtitle => 'Çocuğunuzla bir hedef seçin. Görevleri başardıkça yıldız ekleyin. 5 yıldıza ulaştığında hak ettiği ödülü kazansın!';

	/// tr: 'Hedeflenen Ödül'
	String get tokenRewardLabel => 'Hedeflenen Ödül';

	/// tr: 'Örn: Salıncağa binmek 🛝'
	String get tokenRewardHint => 'Örn: Salıncağa binmek 🛝';

	/// tr: 'Ödülü Tanımla'
	String get tokenSetReward => 'Ödülü Tanımla';

	/// tr: 'Aktif Ödül'
	String get tokenActive => 'Aktif Ödül';

	/// tr: 'Başarı Yıldızlarını Toplayın ($count/5)'
	String tokenCollect({required Object count}) => 'Başarı Yıldızlarını Toplayın (${count}/5)';

	/// tr: '⭐ Yıldız Ekle'
	String get tokenAdd => '⭐ Yıldız Ekle';

	/// tr: 'Tebrikler! Jeton Kartı Doldu'
	String get tokenFullTitle => 'Tebrikler! Jeton Kartı Doldu';

	/// tr: 'Çocuğunuz bütün adımları başarıyla tamamladı ve $reward hakkı kazandı!'
	String tokenFullBody({required Object reward}) => 'Çocuğunuz bütün adımları başarıyla tamamladı ve ${reward} hakkı kazandı!';

	/// tr: 'Panoyu Sıfırla'
	String get tokenReset => 'Panoyu Sıfırla';

	/// tr: 'Parka Gitmek 🛝'
	String get tokenDefaultReward => 'Parka Gitmek 🛝';

	/// tr: 'Nefes Alıştırması'
	String get breathTitle => 'Nefes Alıştırması';

	/// tr: 'Çocuğunuz aşırı uyarılmış hissettiğinde Kriz Rehberi'ndeki nefes regülatörünü birlikte kullanın.'
	String get breathBody => 'Çocuğunuz aşırı uyarılmış hissettiğinde Kriz Rehberi\'ndeki nefes regülatörünü birlikte kullanın.';

	/// tr: 'Nefes Egzersizini Aç'
	String get breathOpen => 'Nefes Egzersizini Aç';

	/// tr: 'AI ile Sosyal Hikâye'
	String get aiStoryTitle => 'AI ile Sosyal Hikâye';

	/// tr: 'Yeni bir durum için AI Asistan'dan çocuğunuza özel kısa bir sosyal hikâye taslağı isteyin.'
	String get aiStoryBody => 'Yeni bir durum için AI Asistan\'dan çocuğunuza özel kısa bir sosyal hikâye taslağı isteyin.';

	/// tr: 'AI Asistan'ı Aç'
	String get aiStoryOpen => 'AI Asistan\'ı Aç';
}

// Path: tasks
class Translations$tasks$tr {
	Translations$tasks$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Ödevlerim'
	String get title => 'Ödevlerim';

	/// tr: 'Uzmanınızın size atadığı çalışmalar burada görünür; tamamladıkça teslim edebilirsiniz.'
	String get subtitle => 'Uzmanınızın size atadığı çalışmalar burada görünür; tamamladıkça teslim edebilirsiniz.';

	/// tr: 'Bekleyen'
	String get pendingLabel => 'Bekleyen';

	/// tr: 'Tamamlanan'
	String get completedLabel => 'Tamamlanan';

	/// tr: 'Ne kadar tamamlandı'
	String get progressLabel => 'Ne kadar tamamlandı';

	/// tr: '$count görevin son teslim tarihi geçmiş'
	String overdueSummary({required Object count}) => '${count} görevin son teslim tarihi geçmiş';

	/// tr: 'Tümü ($count)'
	String filterAll({required Object count}) => 'Tümü (${count})';

	/// tr: 'Yapılacaklar ($count)'
	String filterPending({required Object count}) => 'Yapılacaklar (${count})';

	/// tr: 'Teslim Edilenler ($count)'
	String filterCompleted({required Object count}) => 'Teslim Edilenler (${count})';

	/// tr: 'Henüz uzman tarafından görev atanmamış. Uzmanınız yeni ödev belirlediğinde burada görebileceksiniz.'
	String get emptyAll => 'Henüz uzman tarafından görev atanmamış. Uzmanınız yeni ödev belirlediğinde burada görebileceksiniz.';

	/// tr: 'Bekleyen görev bulunmuyor.'
	String get emptyPending => 'Bekleyen görev bulunmuyor.';

	/// tr: 'Tamamlanan görev bulunmuyor.'
	String get emptyCompleted => 'Tamamlanan görev bulunmuyor.';

	/// tr: 'Son tarih geçti! Uzmanınız teslimat bekliyor.'
	String get overdueBanner => 'Son tarih geçti! Uzmanınız teslimat bekliyor.';

	/// tr: 'Kolay'
	String get difficultyEasy => 'Kolay';

	/// tr: 'Orta'
	String get difficultyMedium => 'Orta';

	/// tr: 'Zor'
	String get difficultyHard => 'Zor';

	/// tr: 'Son: $date'
	String dueLabel({required Object date}) => 'Son: ${date}';

	/// tr: 'Görev Detayı'
	String get detailLabel => 'Görev Detayı';

	/// tr: 'Gerekli Materyale Git'
	String get openMaterial => 'Gerekli Materyale Git';

	/// tr: 'Görevi Teslim Et'
	String get submitTask => 'Görevi Teslim Et';

	/// tr: 'Görev başarıyla uzmanınıza teslim edildi!'
	String get submitted => 'Görev başarıyla uzmanınıza teslim edildi!';

	/// tr: 'Teslim kaydı yüklenemedi.'
	String get submissionsError => 'Teslim kaydı yüklenemedi.';

	/// tr: 'Bu görev için teslim kaydı bulunamadı (eski görev olabilir).'
	String get noSubmission => 'Bu görev için teslim kaydı bulunamadı (eski görev olabilir).';

	/// tr: 'Sizin Notunuz'
	String get yourNote => 'Sizin Notunuz';

	/// tr: 'Eklenmiş Kanıt / Video'
	String get evidenceLink => 'Eklenmiş Kanıt / Video';

	/// tr: 'Uzman Değerlendirmesi'
	String get expertFeedback => 'Uzman Değerlendirmesi';

	/// tr: 'Uzman onayladı ama not bırakmadı.'
	String get expertApprovedNoNote => 'Uzman onayladı ama not bırakmadı.';

	/// tr: 'Uzman değerlendirmesi bekleniyor…'
	String get awaitingReview => 'Uzman değerlendirmesi bekleniyor…';

	/// tr: 'Görevi Teslim Et'
	String get submitTitle => 'Görevi Teslim Et';

	/// tr: 'Seçili Görev'
	String get selectedTask => 'Seçili Görev';

	/// tr: 'Uzmana İletilecek Not'
	String get noteLabel => 'Uzmana İletilecek Not';

	/// tr: 'Çocuğunuz bu görevi yaparken nasıl hissetti? (Örn: Çok rahat tamamladı)'
	String get noteHint => 'Çocuğunuz bu görevi yaparken nasıl hissetti? (Örn: Çok rahat tamamladı)';

	/// tr: 'Kanıt / Eklenti Bağlantısı (İsteğe Bağlı)'
	String get evidenceLabel => 'Kanıt / Eklenti Bağlantısı (İsteğe Bağlı)';

	/// tr: 'Uzmanınızın görebilmesi için ilgili çalışma anının videosunu veya fotoğrafını bulut bağlantısı olarak ekleyebilirsiniz.'
	String get evidenceHint => 'Uzmanınızın görebilmesi için ilgili çalışma anının videosunu veya fotoğrafını bulut bağlantısı olarak ekleyebilirsiniz.';

	/// tr: 'Teslim Et ve Kapat'
	String get submitConfirm => 'Teslim Et ve Kapat';
}

// Path: forum
class Translations$forum$tr {
	Translations$forum$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Topluluk Forumu'
	String get title => 'Topluluk Forumu';

	/// tr: 'Deneyimler'
	String get typeExperience => 'Deneyimler';

	/// tr: 'Soru-Cevap'
	String get typeQuestion => 'Soru-Cevap';

	/// tr: 'Tavsiyeler'
	String get typeAdvice => 'Tavsiyeler';

	/// tr: 'Başarı Hikayeleri'
	String get typeSuccess => 'Başarı Hikayeleri';

	/// tr: 'İletişim'
	String get catCommunication => 'İletişim';

	/// tr: 'Sosyal'
	String get catSocial => 'Sosyal';

	/// tr: 'Duyusal'
	String get catSensory => 'Duyusal';

	/// tr: 'Davranış'
	String get catBehavior => 'Davranış';

	/// tr: 'Motor'
	String get catMotor => 'Motor';

	/// tr: 'Eğitim'
	String get catEducation => 'Eğitim';

	/// tr: 'az önce'
	String get justNow => 'az önce';

	/// tr: '$count dk önce'
	String minsAgo({required Object count}) => '${count} dk önce';

	/// tr: '$count sa önce'
	String hoursAgo({required Object count}) => '${count} sa önce';

	/// tr: '$count gün önce'
	String daysAgo({required Object count}) => '${count} gün önce';

	/// tr: 'Forumda ara…'
	String get searchHint => 'Forumda ara…';

	/// tr: 'Etiket filtresi'
	String get tagFilter => 'Etiket filtresi';

	/// tr: 'Yeni'
	String get sortNew => 'Yeni';

	/// tr: 'Sıcak'
	String get sortHot => 'Sıcak';

	/// tr: 'Cevapsız'
	String get sortUnanswered => 'Cevapsız';

	/// tr: 'Uzmanlı'
	String get sortExpert => 'Uzmanlı';

	/// tr: 'Henüz gönderi yok. Toplulukla bir deneyiminizi paylaşarak başlayın.'
	String get empty => 'Henüz gönderi yok. Toplulukla bir deneyiminizi paylaşarak başlayın.';

	/// tr: 'Henüz soru yok. İlk soruyu sorarak tartışmayı başlatın.'
	String get emptyQuestion => 'Henüz soru yok. İlk soruyu sorarak tartışmayı başlatın.';

	/// tr: 'Paylaş'
	String get add => 'Paylaş';

	/// tr: 'Daha Fazla Yükle'
	String get loadMore => 'Daha Fazla Yükle';

	/// tr: 'Gönderi paylaşıldı.'
	String get posted => 'Gönderi paylaşıldı.';

	/// tr: 'Anonim Kullanıcı'
	String get anonymousUser => 'Anonim Kullanıcı';

	/// tr: 'Uzman'
	String get expertBadge => 'Uzman';

	/// tr: 'Sabitlenmiş'
	String get pinnedBadge => 'Sabitlenmiş';

	/// tr: 'Cevaplanmış'
	String get answeredBadge => 'Cevaplanmış';

	/// tr: 'Gönderi'
	String get postTitle => 'Gönderi';

	/// tr: 'Yorumlar ($count)'
	String commentsHeader({required Object count}) => 'Yorumlar (${count})';

	/// tr: 'Yorumlar yüklenemedi.'
	String get commentsError => 'Yorumlar yüklenemedi.';

	/// tr: 'Henüz yorum yok. İlk yorumu siz yazın.'
	String get noComments => 'Henüz yorum yok. İlk yorumu siz yazın.';

	/// tr: 'Bir yorum yazın…'
	String get commentHint => 'Bir yorum yazın…';

	/// tr: 'Yanıtınızı yazın…'
	String get replyHint => 'Yanıtınızı yazın…';

	/// tr: '$name kişisine yanıt veriliyor'
	String replyingTo({required Object name}) => '${name} kişisine yanıt veriliyor';

	/// tr: 'Yanıtla'
	String get reply => 'Yanıtla';

	/// tr: 'En İyi Cevap'
	String get acceptAnswer => 'En İyi Cevap';

	/// tr: 'En iyi cevap işaretlendi.'
	String get answerAccepted => 'En iyi cevap işaretlendi.';

	/// tr: 'En İyi Cevap'
	String get acceptedBadge => 'En İyi Cevap';

	/// tr: 'Uzman Onaylı'
	String get expertApproved => 'Uzman Onaylı';

	/// tr: 'Yorumu Düzenle'
	String get editComment => 'Yorumu Düzenle';

	/// tr: 'Yorumu Sil'
	String get deleteCommentTitle => 'Yorumu Sil';

	/// tr: 'Bu yorumu silmek istediğinize emin misiniz?'
	String get deleteCommentConfirm => 'Bu yorumu silmek istediğinize emin misiniz?';

	/// tr: 'Gönderiyi Sil'
	String get deleteTitle => 'Gönderiyi Sil';

	/// tr: 'Bu gönderiyi silmek istediğinize emin misiniz?'
	String get deleteConfirm => 'Bu gönderiyi silmek istediğinize emin misiniz?';

	/// tr: 'Vazgeç'
	String get cancel => 'Vazgeç';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Şikayet Et'
	String get reportTitle => 'Şikayet Et';

	/// tr: 'Şikayet nedeninizi kısaca yazın'
	String get reportHint => 'Şikayet nedeninizi kısaca yazın';

	/// tr: 'Gönder'
	String get reportSend => 'Gönder';

	/// tr: 'Şikayetiniz alındı.'
	String get reportSent => 'Şikayetiniz alındı.';

	/// tr: 'Yeni Gönderi'
	String get newPost => 'Yeni Gönderi';

	/// tr: 'Gönderiyi Düzenle'
	String get editPost => 'Gönderiyi Düzenle';

	/// tr: 'Başlık'
	String get titleLabel => 'Başlık';

	/// tr: 'Sorunuzu kısaca özetleyin'
	String get titleHintQuestion => 'Sorunuzu kısaca özetleyin';

	/// tr: 'Gönderinizin başlığı'
	String get titleHint => 'Gönderinizin başlığı';

	/// tr: 'İçerik'
	String get contentLabel => 'İçerik';

	/// tr: 'Semptom Etiketleri'
	String get tagsLabel => 'Semptom Etiketleri';

	/// tr: 'Anonim Olarak Paylaş'
	String get anonymousTitle => 'Anonim Olarak Paylaş';

	/// tr: 'Profil bilgileriniz gizlenir, "Anonim Kullanıcı" olarak görünürsünüz.'
	String get anonymousBody => 'Profil bilgileriniz gizlenir, "Anonim Kullanıcı" olarak görünürsünüz.';

	/// tr: 'Gizlilik Ayarları'
	String get privacyTitle => 'Gizlilik Ayarları';

	/// tr: 'Gerçek adımı göster'
	String get privacyRealName => 'Gerçek adımı göster';

	/// tr: 'Çocuğumun yaş aralığını göster'
	String get privacyChildAge => 'Çocuğumun yaş aralığını göster';

	/// tr: 'Semptom etiketlerini göster'
	String get privacySymptoms => 'Semptom etiketlerini göster';

	/// tr: 'Tanı detaylarını göster'
	String get privacyDiagnosis => 'Tanı detaylarını göster';

	/// tr: 'Eşleştirme algoritmasında kullanılsın'
	String get privacyMatching => 'Eşleştirme algoritmasında kullanılsın';

	/// tr: 'Paylaş'
	String get share => 'Paylaş';
}

// Path: childDetail
class Translations$childDetail$tr {
	Translations$childDetail$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Çocuk Profili'
	String get title => 'Çocuk Profili';

	/// tr: 'Profili Düzenle'
	String get editProfile => 'Profili Düzenle';

	/// tr: '$age yaş'
	String ageYears({required Object age}) => '${age} yaş';

	/// tr: 'Erkek'
	String get genderBoy => 'Erkek';

	/// tr: 'Kız'
	String get genderGirl => 'Kız';

	/// tr: 'Profil fotoğrafı güncellendi.'
	String get photoUpdated => 'Profil fotoğrafı güncellendi.';

	/// tr: 'Bilgiler'
	String get infoTitle => 'Bilgiler';

	/// tr: 'Henüz tanı/eğitim bilgisi eklenmemiş. Sağ üstten profili düzenleyebilirsiniz.'
	String get infoEmpty => 'Henüz tanı/eğitim bilgisi eklenmemiş. Sağ üstten profili düzenleyebilirsiniz.';

	/// tr: 'Tanı Bilgisi'
	String get diagnosis => 'Tanı Bilgisi';

	/// tr: 'Eğitim Programı'
	String get educationProgram => 'Eğitim Programı';

	/// tr: 'Terapiler'
	String get therapies => 'Terapiler';

	/// tr: 'Semptom Etiketleri'
	String get tagsTitle => 'Semptom Etiketleri';

	/// tr: 'Henüz etiket seçilmemiş. Etiketler benzer aile eşleştirmesinde ve forumda kullanılır.'
	String get tagsEmpty => 'Henüz etiket seçilmemiş. Etiketler benzer aile eşleştirmesinde ve forumda kullanılır.';

	/// tr: 'Etiketleri Düzenle'
	String get tagsEdit => 'Etiketleri Düzenle';

	/// tr: 'Etiketler yüklenemedi.'
	String get tagsError => 'Etiketler yüklenemedi.';

	/// tr: 'Düzenle'
	String get edit => 'Düzenle';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Vazgeç'
	String get cancel => 'Vazgeç';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'Kilometre Taşları'
	String get milestonesTitle => 'Kilometre Taşları';

	/// tr: 'Henüz kilometre taşı eklenmemiş. İlk büyük başarıyı kaydedin!'
	String get milestonesEmpty => 'Henüz kilometre taşı eklenmemiş. İlk büyük başarıyı kaydedin!';

	/// tr: 'Kilometre taşları yüklenemedi.'
	String get milestonesError => 'Kilometre taşları yüklenemedi.';

	/// tr: 'Ekle'
	String get milestoneAdd => 'Ekle';

	/// tr: 'Kilometre Taşını Düzenle'
	String get milestoneEdit => 'Kilometre Taşını Düzenle';

	/// tr: 'Başlık'
	String get milestoneTitleLabel => 'Başlık';

	/// tr: 'Örn: İlk kez göz teması kurdu'
	String get milestoneTitleHint => 'Örn: İlk kez göz teması kurdu';

	/// tr: 'Açıklama (isteğe bağlı)'
	String get milestoneDescLabel => 'Açıklama (isteğe bağlı)';

	/// tr: 'Kilometre Taşı Ekle'
	String get milestoneSave => 'Kilometre Taşı Ekle';

	/// tr: 'Kilometre Taşını Sil'
	String get milestoneDeleteTitle => 'Kilometre Taşını Sil';

	/// tr: 'Bu kaydı silmek istediğinize emin misiniz?'
	String get milestoneDeleteConfirm => 'Bu kaydı silmek istediğinize emin misiniz?';

	/// tr: 'Tarama Sonuçları'
	String get screeningTitle => 'Tarama Sonuçları';

	/// tr: 'Henüz tarama sonucu yok.'
	String get screeningEmpty => 'Henüz tarama sonucu yok.';

	/// tr: '$score/20'
	String scoreOf({required Object score}) => '${score}/20';

	/// tr: 'Düşük risk'
	String get riskLow => 'Düşük risk';

	/// tr: 'Orta risk'
	String get riskMedium => 'Orta risk';

	/// tr: 'Yüksek risk'
	String get riskHigh => 'Yüksek risk';

	/// tr: 'Hızlı Erişim'
	String get shortcutsTitle => 'Hızlı Erişim';

	/// tr: 'Günlük Takip'
	String get shortcutTracker => 'Günlük Takip';

	/// tr: 'Davranış Günlüğü'
	String get shortcutBehavior => 'Davranış Günlüğü';

	/// tr: 'Tedavi Paneli'
	String get shortcutTreatment => 'Tedavi Paneli';

	/// tr: 'Gelişim Paneli'
	String get shortcutAnalytics => 'Gelişim Paneli';
}

// Path: crisis
class Translations$crisis$tr {
	Translations$crisis$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Kriz Rehberi'
	String get title => 'Kriz Rehberi';

	/// tr: 'Zor Anlarda Ne Yapmalı?'
	String get heroTitle => 'Zor Anlarda Ne Yapmalı?';

	/// tr: 'Çocuğunuz bunaldığında sakin kalmanıza ve doğru adımları atmanıza yardımcı olacak hızlı rehber.'
	String get heroSubtitle => 'Çocuğunuz bunaldığında sakin kalmanıza ve doğru adımları atmanıza yardımcı olacak hızlı rehber.';

	/// tr: 'Nefes Regülatörü'
	String get breathingTitle => 'Nefes Regülatörü';

	/// tr: 'Önce siz sakinleşin. Başlatın ve nefesinizi halkanın büyüme-küçülme hızına uydurun.'
	String get breathingSubtitle => 'Önce siz sakinleşin. Başlatın ve nefesinizi halkanın büyüme-küçülme hızına uydurun.';

	/// tr: 'Egzersizi Başlat'
	String get breathingStart => 'Egzersizi Başlat';

	/// tr: 'Durdur'
	String get breathingStop => 'Durdur';

	/// tr: 'Hazır'
	String get breathingReady => 'Hazır';

	/// tr: 'Başlamak için dokunun'
	String get breathingReadyHint => 'Başlamak için dokunun';

	/// tr: 'Nefes Al'
	String get breathingInhale => 'Nefes Al';

	/// tr: 'Nefes Ver'
	String get breathingExhale => 'Nefes Ver';

	/// tr: 'saniye'
	String get breathingSeconds => 'saniye';

	/// tr: 'Ne Yapmalı?'
	String get stepsLabel => 'Ne Yapmalı?';

	/// tr: 'Kaçınılması Gerekenler'
	String get avoidLabel => 'Kaçınılması Gerekenler';

	/// tr: 'Önerilen Acil Hat'
	String get emergencyLabel => 'Önerilen Acil Hat';

	/// tr: 'Acil Numaralar'
	String get contactsTitle => 'Acil Numaralar';

	/// tr: 'Bu rehber genel bilgilendirme amaçlıdır; acil ve tıbbi durumlarda mutlaka 112'yi arayın.'
	String get disclaimer => 'Bu rehber genel bilgilendirme amaçlıdır; acil ve tıbbi durumlarda mutlaka 112\'yi arayın.';

	/// tr: 'Acil Sağlık ve Güvenlik'
	String get contact112Label => 'Acil Sağlık ve Güvenlik';

	/// tr: 'Ambulans, Polis, İtfaiye'
	String get contact112Desc => 'Ambulans, Polis, İtfaiye';

	/// tr: 'Sosyal Destek Hattı'
	String get contact183Label => 'Sosyal Destek Hattı';

	/// tr: 'Kadın, Çocuk ve Sosyal Hizmetler'
	String get contact183Desc => 'Kadın, Çocuk ve Sosyal Hizmetler';

	late final Translations$crisis$cards$tr cards = Translations$crisis$cards$tr.internal(_root);
}

// Path: calendar
class Translations$calendar$tr {
	Translations$calendar$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Takvim'
	String get title => 'Takvim';

	/// tr: 'Çocuğa özel terapi, doktor ve etkinlik planı.'
	String get subtitle => 'Çocuğa özel terapi, doktor ve etkinlik planı.';

	/// tr: 'Takvim için önce bir çocuk ekleyin.'
	String get noChild => 'Takvim için önce bir çocuk ekleyin.';

	/// tr: 'Henüz etkinlik yok. İlk etkinliği ekleyin.'
	String get empty => 'Henüz etkinlik yok. İlk etkinliği ekleyin.';

	/// tr: 'Etkinlik Ekle'
	String get add => 'Etkinlik Ekle';

	/// tr: 'Yeni Etkinlik'
	String get addTitle => 'Yeni Etkinlik';

	/// tr: 'Etkinliği Düzenle'
	String get editTitle => 'Etkinliği Düzenle';

	/// tr: 'Etkinlik Tipi'
	String get eventType => 'Etkinlik Tipi';

	/// tr: 'Terapi'
	String get typeTerapi => 'Terapi';

	/// tr: 'Doktor'
	String get typeDoktor => 'Doktor';

	/// tr: 'Eğitim'
	String get typeEgitim => 'Eğitim';

	/// tr: 'Aktivite'
	String get typeAktivite => 'Aktivite';

	/// tr: 'Randevu'
	String get typeAppointment => 'Randevu';

	/// tr: 'Diğer'
	String get typeDiger => 'Diğer';

	/// tr: 'Başlık'
	String get eventTitle => 'Başlık';

	/// tr: 'Etkinlik adı'
	String get titleHint => 'Etkinlik adı';

	/// tr: 'Konum'
	String get location => 'Konum';

	/// tr: 'Klinik adı, adres'
	String get locationHint => 'Klinik adı, adres';

	/// tr: 'Açıklama'
	String get description => 'Açıklama';

	/// tr: 'Başlangıç'
	String get start => 'Başlangıç';

	/// tr: 'Bitiş (isteğe bağlı)'
	String get end => 'Bitiş (isteğe bağlı)';

	/// tr: 'Hatırlatma'
	String get reminder => 'Hatırlatma';

	/// tr: 'Kapalı'
	String get reminderOff => 'Kapalı';

	/// tr: '$count dk önce'
	String reminderMin({required Object count}) => '${count} dk önce';

	/// tr: '$count saat önce'
	String reminderHour({required Object count}) => '${count} saat önce';

	/// tr: '1 gün önce'
	String get reminderDay => '1 gün önce';

	/// tr: 'Planlandı'
	String get statusPlanned => 'Planlandı';

	/// tr: 'Tamamlandı'
	String get statusCompleted => 'Tamamlandı';

	/// tr: 'İptal'
	String get statusCancelled => 'İptal';

	/// tr: 'Tamamlandı işaretle'
	String get markCompleted => 'Tamamlandı işaretle';

	/// tr: 'Planlandı yap'
	String get markPlanned => 'Planlandı yap';

	/// tr: 'İptal et'
	String get markCancelled => 'İptal et';

	/// tr: 'Bugün'
	String get today => 'Bugün';

	/// tr: 'Yarın'
	String get tomorrow => 'Yarın';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Etkinlik kaydedildi.'
	String get saved => 'Etkinlik kaydedildi.';

	/// tr: 'Etkinliği Sil'
	String get deleteTitle => 'Etkinliği Sil';

	/// tr: '"$title" etkinliğini silmek istediğinize emin misiniz?'
	String deleteConfirm({required Object title}) => '"${title}" etkinliğini silmek istediğinize emin misiniz?';

	/// tr: 'Etkinlik silindi.'
	String get deleted => 'Etkinlik silindi.';

	/// tr: 'Lütfen bir başlık girin.'
	String get errorTitle => 'Lütfen bir başlık girin.';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Sil'
	String get delete => 'Sil';
}

// Path: emergency
class Translations$emergency$tr {
	Translations$emergency$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Acil Durum Kartı'
	String get title => 'Acil Durum Kartı';

	/// tr: 'Acil bir durumda çocuğunuzla karşılaşan kişilere gösterilecek bilgiler.'
	String get subtitle => 'Acil bir durumda çocuğunuzla karşılaşan kişilere gösterilecek bilgiler.';

	/// tr: 'Acil durum kartı için önce bir çocuk ekleyin.'
	String get noChild => 'Acil durum kartı için önce bir çocuk ekleyin.';

	/// tr: 'Son güncelleme $date'
	String lastUpdated({required Object date}) => 'Son güncelleme ${date}';

	/// tr: 'Bu kart henüz kaydedilmedi.'
	String get notSaved => 'Bu kart henüz kaydedilmedi.';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Acil durum kartı kaydedildi.'
	String get saved => 'Acil durum kartı kaydedildi.';

	/// tr: 'QR kod ile paylaş'
	String get shareTitle => 'QR kod ile paylaş';

	/// tr: 'Süreli bir bağlantı oluşturun; öğretmen veya sağlık görevlisi kartı bu bağlantıdan görüntüleyebilir. Bağlantıyı istediğiniz an kapatabilirsiniz.'
	String get shareBody => 'Süreli bir bağlantı oluşturun; öğretmen veya sağlık görevlisi kartı bu bağlantıdan görüntüleyebilir. Bağlantıyı istediğiniz an kapatabilirsiniz.';

	/// tr: 'Paylaşım için "Acil durum kartı paylaşımı" rızasını vermeniz gerekiyor.'
	String get shareConsentRequired => 'Paylaşım için "Acil durum kartı paylaşımı" rızasını vermeniz gerekiyor.';

	/// tr: 'Rıza ayarlarını aç'
	String get shareOpenConsents => 'Rıza ayarlarını aç';

	/// tr: 'Geçerlilik süresi'
	String get shareDuration => 'Geçerlilik süresi';

	/// tr: '24 saat geçerli'
	String get share24h => '24 saat geçerli';

	/// tr: '3 gün geçerli'
	String get share3d => '3 gün geçerli';

	/// tr: '1 hafta geçerli'
	String get share1w => '1 hafta geçerli';

	/// tr: '30 gün geçerli'
	String get share30d => '30 gün geçerli';

	/// tr: 'Paylaşım bağlantısı oluştur'
	String get shareEnable => 'Paylaşım bağlantısı oluştur';

	/// tr: 'Paylaşımı kapat'
	String get shareDisable => 'Paylaşımı kapat';

	/// tr: 'Bağlantı $date tarihine kadar geçerli.'
	String shareValidUntil({required Object date}) => 'Bağlantı ${date} tarihine kadar geçerli.';

	/// tr: 'Bağlantıyı kopyala'
	String get shareCopy => 'Bağlantıyı kopyala';

	/// tr: 'Bağlantı kopyalandı.'
	String get shareCopied => 'Bağlantı kopyalandı.';

	/// tr: 'Paylaş'
	String get shareSend => 'Paylaş';

	/// tr: 'Çocuğumun acil durum kartını buradan görüntüleyebilirsiniz:'
	String get shareMessage => 'Çocuğumun acil durum kartını buradan görüntüleyebilirsiniz:';

	/// tr: 'Ara'
	String get call => 'Ara';

	/// tr: 'Çocuk Bilgileri'
	String get sectionChild => 'Çocuk Bilgileri';

	/// tr: 'Acil İletişim'
	String get sectionContacts => 'Acil İletişim';

	/// tr: 'Tıbbi Bilgiler'
	String get sectionMedical => 'Tıbbi Bilgiler';

	/// tr: 'Davranışsal Bilgiler'
	String get sectionBehavior => 'Davranışsal Bilgiler';

	/// tr: 'Ad Soyad'
	String get childName => 'Ad Soyad';

	/// tr: 'Doğum Tarihi'
	String get birthDate => 'Doğum Tarihi';

	/// tr: 'Tanı'
	String get diagnosis => 'Tanı';

	/// tr: 'Kan Grubu'
	String get bloodType => 'Kan Grubu';

	/// tr: 'İletişim Seviyesi'
	String get communicationLevel => 'İletişim Seviyesi';

	/// tr: 'Konuşulan Dil(ler)'
	String get languages => 'Konuşulan Dil(ler)';

	/// tr: 'Özel durum uyarıları'
	String get warningsLabel => 'Özel durum uyarıları';

	/// tr: 'Öz-zarar davranışı olabilir'
	String get selfInjury => 'Öz-zarar davranışı olabilir';

	/// tr: 'Kaçma / kaybolma riski var'
	String get wandering => 'Kaçma / kaybolma riski var';

	/// tr: 'Sözel iletişim yoktur'
	String get nonVerbal => 'Sözel iletişim yoktur';

	/// tr: 'Birinci Kişi'
	String get contact1 => 'Birinci Kişi';

	/// tr: 'İkinci Kişi'
	String get contact2 => 'İkinci Kişi';

	/// tr: 'Doktor / Hastane'
	String get doctor => 'Doktor / Hastane';

	/// tr: 'Ad Soyad'
	String get name => 'Ad Soyad';

	/// tr: 'Telefon'
	String get phone => 'Telefon';

	/// tr: 'Yakınlık'
	String get relation => 'Yakınlık';

	/// tr: 'Doktor Adı'
	String get doctorName => 'Doktor Adı';

	/// tr: 'Doktor Telefonu'
	String get doctorPhone => 'Doktor Telefonu';

	/// tr: 'Hastane'
	String get hospital => 'Hastane';

	/// tr: 'Kullandığı İlaçlar'
	String get medications => 'Kullandığı İlaçlar';

	/// tr: 'İlaç adı - doz - saat (her satıra bir ilaç)'
	String get medicationsHint => 'İlaç adı - doz - saat (her satıra bir ilaç)';

	/// tr: 'Alerjiler'
	String get allergies => 'Alerjiler';

	/// tr: 'Gıda, ilaç, madde alerjileri'
	String get allergiesHint => 'Gıda, ilaç, madde alerjileri';

	/// tr: 'Diğer Tıbbi Durumlar'
	String get conditions => 'Diğer Tıbbi Durumlar';

	/// tr: 'Epilepsi, kalp hastalığı vb.'
	String get conditionsHint => 'Epilepsi, kalp hastalığı vb.';

	/// tr: 'Tetikleyiciler (kaçınılması gerekenler)'
	String get triggers => 'Tetikleyiciler (kaçınılması gerekenler)';

	/// tr: 'Neler kriz çıkarır? Örn: ani gürültü, kalabalık'
	String get triggersHint => 'Neler kriz çıkarır? Örn: ani gürültü, kalabalık';

	/// tr: 'Sakinleştirme Stratejileri'
	String get calming => 'Sakinleştirme Stratejileri';

	/// tr: 'Ne işe yarar? Örn: sevdiği müzik, sessiz oda'
	String get calmingHint => 'Ne işe yarar? Örn: sevdiği müzik, sessiz oda';

	/// tr: 'Kesinlikle Yapılmaması Gerekenler'
	String get avoid => 'Kesinlikle Yapılmaması Gerekenler';

	/// tr: 'Örn: bağırmayın, tutmayın, göz temasına zorlamayın'
	String get avoidHint => 'Örn: bağırmayın, tutmayın, göz temasına zorlamayın';

	/// tr: 'Özel Talimatlar'
	String get special => 'Özel Talimatlar';

	/// tr: 'Acil servis veya bakıcı için ek notlar'
	String get specialHint => 'Acil servis veya bakıcı için ek notlar';

	/// tr: 'Seçin...'
	String get select => 'Seçin...';
}

// Path: behavior
class Translations$behavior$tr {
	Translations$behavior$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Davranış Günlüğü'
	String get title => 'Davranış Günlüğü';

	/// tr: 'ABC (Öncesi-Davranış-Sonuç) gözlem kayıtları'
	String get subtitle => 'ABC (Öncesi-Davranış-Sonuç) gözlem kayıtları';

	/// tr: 'Kayıt Ekle'
	String get add => 'Kayıt Ekle';

	/// tr: 'Yeni ABC Kaydı'
	String get addTitle => 'Yeni ABC Kaydı';

	/// tr: 'Henüz davranış kaydı yok. İlk gözlemi ekleyin.'
	String get empty => 'Henüz davranış kaydı yok. İlk gözlemi ekleyin.';

	/// tr: 'Davranış günlüğü için önce bir çocuk ekleyin.'
	String get noChild => 'Davranış günlüğü için önce bir çocuk ekleyin.';

	/// tr: 'Tarih'
	String get date => 'Tarih';

	/// tr: 'Saat'
	String get time => 'Saat';

	/// tr: 'Kategori'
	String get category => 'Kategori';

	/// tr: 'Yer'
	String get location => 'Yer';

	/// tr: 'A — Öncesi (Tetikleyici)'
	String get antecedentLabel => 'A — Öncesi (Tetikleyici)';

	/// tr: 'Tetikleyiciyi açıklayın'
	String get antecedentHint => 'Tetikleyiciyi açıklayın';

	/// tr: 'B — Davranış (Ne oldu?)'
	String get behaviorLabel => 'B — Davranış (Ne oldu?)';

	/// tr: 'Davranışı ayrıntılı açıklayın'
	String get behaviorHint => 'Davranışı ayrıntılı açıklayın';

	/// tr: 'C — Sonuç (Ne yaptınız?)'
	String get consequenceLabel => 'C — Sonuç (Ne yaptınız?)';

	/// tr: 'Uyguladığınız müdahaleyi açıklayın'
	String get consequenceHint => 'Uyguladığınız müdahaleyi açıklayın';

	/// tr: 'Diğer...'
	String get other => 'Diğer...';

	/// tr: 'Şiddet Düzeyi'
	String get intensityLabel => 'Şiddet Düzeyi';

	/// tr: 'Çok Hafif'
	String get intensity1 => 'Çok Hafif';

	/// tr: 'Hafif'
	String get intensity2 => 'Hafif';

	/// tr: 'Orta'
	String get intensity3 => 'Orta';

	/// tr: 'Şiddetli'
	String get intensity4 => 'Şiddetli';

	/// tr: 'Çok Şiddetli'
	String get intensity5 => 'Çok Şiddetli';

	/// tr: 'Ek notlar (isteğe bağlı)'
	String get notesLabel => 'Ek notlar (isteğe bağlı)';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'ABC kaydı oluşturuldu.'
	String get saved => 'ABC kaydı oluşturuldu.';

	/// tr: 'Kaydı Sil'
	String get deleteTitle => 'Kaydı Sil';

	/// tr: '$date tarihli ABC kaydını silmek istediğinize emin misiniz?'
	String deleteConfirm({required Object date}) => '${date} tarihli ABC kaydını silmek istediğinize emin misiniz?';

	/// tr: 'Kayıt silindi.'
	String get deleted => 'Kayıt silindi.';

	/// tr: 'Lütfen zorunlu alanları doldurun (kategori, yer, A, B, C).'
	String get errorRequired => 'Lütfen zorunlu alanları doldurun (kategori, yer, A, B, C).';
}

// Path: analytics
class Translations$analytics$tr {
	Translations$analytics$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Gelişim Paneli'
	String get title => 'Gelişim Paneli';

	/// tr: 'Son 6 ayın gelişim eğilimleri.'
	String get subtitle => 'Son 6 ayın gelişim eğilimleri.';

	/// tr: 'Kilometre Taşları'
	String get milestones => 'Kilometre Taşları';

	/// tr: 'aylık kazanım sayısı'
	String get milestonesUnit => 'aylık kazanım sayısı';

	/// tr: 'Ruh Hali Ortalaması'
	String get mood => 'Ruh Hali Ortalaması';

	/// tr: '1-5 arası aylık ortalama'
	String get moodUnit => '1-5 arası aylık ortalama';

	/// tr: 'Ortalama Uyku'
	String get sleep => 'Ortalama Uyku';

	/// tr: 'gecelik saat (aylık ortalama)'
	String get sleepUnit => 'gecelik saat (aylık ortalama)';

	/// tr: 'Davranış Kayıtları'
	String get behavior => 'Davranış Kayıtları';

	/// tr: 'aylık kayıt sayısı'
	String get behaviorUnit => 'aylık kayıt sayısı';

	/// tr: 'Bu aralıkta henüz veri yok.'
	String get noData => 'Bu aralıkta henüz veri yok.';

	/// tr: 'Gelişim paneli için önce bir çocuk ekleyin.'
	String get noChild => 'Gelişim paneli için önce bir çocuk ekleyin.';
}

// Path: children
class Translations$children$tr {
	Translations$children$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Çocuklarım'
	String get title => 'Çocuklarım';

	/// tr: 'Çocuk Ekle'
	String get addTitle => 'Çocuk Ekle';

	/// tr: 'Çocuğu Düzenle'
	String get editTitle => 'Çocuğu Düzenle';

	/// tr: 'Henüz çocuk eklemediniz.'
	String get empty => 'Henüz çocuk eklemediniz.';

	/// tr: 'Çocuk Ekle'
	String get add => 'Çocuk Ekle';

	/// tr: 'Ad Soyad'
	String get nameLabel => 'Ad Soyad';

	/// tr: 'Çocuğun adı'
	String get nameHint => 'Çocuğun adı';

	/// tr: 'Doğum Tarihi (isteğe bağlı)'
	String get birthDateLabel => 'Doğum Tarihi (isteğe bağlı)';

	/// tr: 'Tarih seçin'
	String get birthDateSelect => 'Tarih seçin';

	/// tr: 'Cinsiyet (isteğe bağlı)'
	String get genderLabel => 'Cinsiyet (isteğe bağlı)';

	/// tr: 'Erkek'
	String get genderMale => 'Erkek';

	/// tr: 'Kız'
	String get genderFemale => 'Kız';

	/// tr: 'Tanı Bilgisi (isteğe bağlı)'
	String get diagnosisLabel => 'Tanı Bilgisi (isteğe bağlı)';

	/// tr: 'Varsa tanı bilgisi'
	String get diagnosisHint => 'Varsa tanı bilgisi';

	/// tr: 'Eğitim Programı (isteğe bağlı)'
	String get educationLabel => 'Eğitim Programı (isteğe bağlı)';

	/// tr: 'Devam ettiği eğitim programı'
	String get educationHint => 'Devam ettiği eğitim programı';

	/// tr: 'Terapiler (isteğe bağlı)'
	String get therapiesLabel => 'Terapiler (isteğe bağlı)';

	/// tr: 'Aldığı terapiler'
	String get therapiesHint => 'Aldığı terapiler';

	/// tr: '$years yaş'
	String ageYears({required Object years}) => '${years} yaş';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'İptal'
	String get cancel => 'İptal';

	/// tr: 'Sil'
	String get delete => 'Sil';

	/// tr: 'Çocuğu Sil'
	String get deleteTitle => 'Çocuğu Sil';

	/// tr: '$name profilini silmek istediğinize emin misiniz?'
	String deleteConfirm({required Object name}) => '${name} profilini silmek istediğinize emin misiniz?';

	/// tr: 'Lütfen çocuğun adını girin.'
	String get errorNameRequired => 'Lütfen çocuğun adını girin.';

	/// tr: 'Çocuk profili oluşturuldu.'
	String get created => 'Çocuk profili oluşturuldu.';

	/// tr: 'Çocuk profili güncellendi.'
	String get updated => 'Çocuk profili güncellendi.';

	/// tr: 'Çocuk profili silindi.'
	String get deleted => 'Çocuk profili silindi.';
}

// Path: account
class Translations$account$tr {
	Translations$account$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Hesap Bilgileri'
	String get title => 'Hesap Bilgileri';

	/// tr: 'E-posta'
	String get emailLabel => 'E-posta';

	/// tr: 'Ad Soyad'
	String get fullNameLabel => 'Ad Soyad';

	/// tr: 'Telefon'
	String get phoneLabel => 'Telefon';

	/// tr: '05XX XXX XX XX'
	String get phoneHint => '05XX XXX XX XX';

	/// tr: 'Şehir'
	String get cityLabel => 'Şehir';

	/// tr: 'Uzmanlık Ünvanı'
	String get expertTitleLabel => 'Uzmanlık Ünvanı';

	/// tr: 'Kurum'
	String get institutionLabel => 'Kurum';

	/// tr: 'Lisans / Diploma No'
	String get licenseNumberLabel => 'Lisans / Diploma No';

	/// tr: 'Hakkında'
	String get bioLabel => 'Hakkında';

	/// tr: 'Deneyiminizi kısaca anlatın'
	String get bioHint => 'Deneyiminizi kısaca anlatın';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Profil güncellendi.'
	String get saved => 'Profil güncellendi.';

	/// tr: 'Ad soyad en az 2 karakter olmalıdır.'
	String get errorFullName => 'Ad soyad en az 2 karakter olmalıdır.';
}

// Path: help
class Translations$help$tr {
	Translations$help$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Yardım & Hakkında'
	String get title => 'Yardım & Hakkında';

	/// tr: 'Otizm Destek Hakkında'
	String get aboutTitle => 'Otizm Destek Hakkında';

	/// tr: 'Otizm Destek; çocuğunuzun gelişimini takip etmenize, uzmanlarla iletişim kurmanıza ve randevu almanıza yardımcı olan bir mobil uygulamadır.'
	String get aboutBody => 'Otizm Destek; çocuğunuzun gelişimini takip etmenize, uzmanlarla iletişim kurmanıza ve randevu almanıza yardımcı olan bir mobil uygulamadır.';

	/// tr: 'İpuçları'
	String get tipsTitle => 'İpuçları';

	/// tr: 'Çocuklarınızı "Çocuklarım"dan ekleyin; hedef ve gelişim notlarını "Gelişim" sekmesinden takip edin.'
	String get tip1 => 'Çocuklarınızı "Çocuklarım"dan ekleyin; hedef ve gelişim notlarını "Gelişim" sekmesinden takip edin.';

	/// tr: '"Uzmanlar"dan bir uzman seçip randevu alabilir veya mesaj gönderebilirsiniz.'
	String get tip2 => '"Uzmanlar"dan bir uzman seçip randevu alabilir veya mesaj gönderebilirsiniz.';

	/// tr: 'AI Asistan'a otizm ve çocuk gelişimi hakkında sorular sorabilirsiniz.'
	String get tip3 => 'AI Asistan\'a otizm ve çocuk gelişimi hakkında sorular sorabilirsiniz.';

	/// tr: 'İletişim'
	String get contactTitle => 'İletişim';

	/// tr: 'Soru ve önerileriniz için uygulama içinden bize ulaşabilirsiniz.'
	String get contactBody => 'Soru ve önerileriniz için uygulama içinden bize ulaşabilirsiniz.';

	/// tr: 'Sürüm $version'
	String version({required Object version}) => 'Sürüm ${version}';
}

// Path: profile
class Translations$profile$tr {
	Translations$profile$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Kullanıcı'
	String get defaultUser => 'Kullanıcı';

	/// tr: 'Hesap Bilgileri'
	String get accountInfo => 'Hesap Bilgileri';

	/// tr: 'Çocuklarım'
	String get myChildren => 'Çocuklarım';

	/// tr: 'Tüm bölümleri göster'
	String get showAllSections => 'Tüm bölümleri göster';

	/// tr: 'Yardım'
	String get help => 'Yardım';

	/// tr: 'Çıkış Yap'
	String get signOut => 'Çıkış Yap';
}

// Path: errors
class Translations$errors$tr {
	Translations$errors$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Sunucuya ulaşılamadı, lütfen tekrar deneyin.'
	String get timeout => 'Sunucuya ulaşılamadı, lütfen tekrar deneyin.';

	/// tr: 'İnternet bağlantısı yok gibi görünüyor.'
	String get noConnection => 'İnternet bağlantısı yok gibi görünüyor.';

	/// tr: 'Bir hata oluştu ($code).'
	String generic({required Object code}) => 'Bir hata oluştu (${code}).';

	/// tr: 'İstek iptal edildi.'
	String get cancelled => 'İstek iptal edildi.';

	/// tr: 'Beklenmeyen bir hata oluştu.'
	String get unexpected => 'Beklenmeyen bir hata oluştu.';

	/// tr: 'Beklenmeyen sunucu yanıtı.'
	String get unexpectedResponse => 'Beklenmeyen sunucu yanıtı.';

	/// tr: 'İşlem başarısız.'
	String get operationFailed => 'İşlem başarısız.';

	/// tr: 'Sunucu yanıtında kullanıcı bilgisi yok.'
	String get noUserInResponse => 'Sunucu yanıtında kullanıcı bilgisi yok.';
}

// Path: crisis.cards
class Translations$crisis$cards$tr {
	Translations$crisis$cards$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$crisis$cards$meltdown$tr meltdown = Translations$crisis$cards$meltdown$tr.internal(_root);
	late final Translations$crisis$cards$sensory$tr sensory = Translations$crisis$cards$sensory$tr.internal(_root);
	late final Translations$crisis$cards$aggression$tr aggression = Translations$crisis$cards$aggression$tr.internal(_root);
	late final Translations$crisis$cards$anxiety$tr anxiety = Translations$crisis$cards$anxiety$tr.internal(_root);
}

// Path: crisis.cards.meltdown
class Translations$crisis$cards$meltdown$tr {
	Translations$crisis$cards$meltdown$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Kriz / Meltdown'
	String get title => 'Kriz / Meltdown';

	/// tr: 'Kontrol kaybı, ağlama, bağırma, kendine zarar verme girişimi'
	String get subtitle => 'Kontrol kaybı, ağlama, bağırma, kendine zarar verme girişimi';

	List<String> get steps => [
		'Sakin kalın — sesiniz ve beden diliniz çocuğa geçer.',
		'Güvenli alan oluşturun: keskin/sert nesneleri uzaklaştırın.',
		'Sözel uyarıyı minimuma indirin; tek kelime veya kısa cümleler.',
		'Duyusal uyaranları azaltın: ışıkları kısın, sesi düşürün.',
		'Yanında olmaya devam edin — uzaklaşmayın ama dokunmayın.',
		'Kriz geçtikten sonra sakin ses tonuyla güvence verin.',
	];
	List<String> get avoid => [
		'Yüksek sesle konuşmayın.',
		'Mantık yürütmeye ya da açıklamaya çalışmayın.',
		'Cezalandırma veya tehdit etmeyin.',
		'Kalabalık içinde bırakmayın.',
	];

	/// tr: '112 — Acil Sağlık Hattı'
	String get emergency => '112 — Acil Sağlık Hattı';
}

// Path: crisis.cards.sensory
class Translations$crisis$cards$sensory$tr {
	Translations$crisis$cards$sensory$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Duyusal Aşırı Yüklenme'
	String get title => 'Duyusal Aşırı Yüklenme';

	/// tr: 'Ellerini kulaklarına kapatma, ışıktan/sesten kaçma, donup kalma'
	String get subtitle => 'Ellerini kulaklarına kapatma, ışıktan/sesten kaçma, donup kalma';

	List<String> get steps => [
		'Hemen daha sakin ve az uyarıcı bir ortama geçin.',
		'Sevilen duyusal nesneleri sunun (ağırlıklı battaniye, squishy).',
		'Tahmin edilebilir ve sakin bir ses tonuyla kısaca konuşun.',
		'Derin baskı (sıkı sarılma) çocuk onay verirse uygulanabilir.',
		'Zaman verin — birkaç dakika sessiz kalın.',
		'Tetikleyiciyi not alın, ilerleyen dönemde önlem alın.',
	];
	List<String> get avoid => [
		'Ortamı değiştirmeden sözlü yönlendirmeye devam etmeyin.',
		'Zorla bir şey tutturmaya çalışmayın.',
		'"Neden bu kadar abartıyorsun?" demeyin.',
	];
}

// Path: crisis.cards.aggression
class Translations$crisis$cards$aggression$tr {
	Translations$crisis$cards$aggression$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Saldırganlık / Kendine Zarar Verme'
	String get title => 'Saldırganlık / Kendine Zarar Verme';

	/// tr: 'Vurma, ısırma, kafaya vurma, nesneleri fırlatma'
	String get subtitle => 'Vurma, ısırma, kafaya vurma, nesneleri fırlatma';

	List<String> get steps => [
		'Güvenli mesafe koruyun; yakınlarda başkası varsa uzaklaştırın.',
		'Düşük sesli, kısa ve sakin direktifler verin ("Dur", "Burada").',
		'Tahrik edici nesneleri ve kişileri ortamdan uzaklaştırın.',
		'Alternatif çıkış noktası sunun: yastık vurma, koşu.',
		'Kriz geçince olayı not edin; tetikleyiciyi analiz edin.',
	];
	List<String> get avoid => [
		'Fiziksel güç uygulamaktan kaçının (zorunlu değilse).',
		'Dikkat çekerek ya da izleyici yaratarak ortamı körüklemeyin.',
		'Eylem anında ödüllendirmeyin.',
	];

	/// tr: '112 — Acil Çağrı Merkezi'
	String get emergency => '112 — Acil Çağrı Merkezi';
}

// Path: crisis.cards.anxiety
class Translations$crisis$cards$anxiety$tr {
	Translations$crisis$cards$anxiety$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Yoğun Kaygı / Panik'
	String get title => 'Yoğun Kaygı / Panik';

	/// tr: 'Titreme, nefes darlığı, ağlama, ortalıktan çekilme'
	String get subtitle => 'Titreme, nefes darlığı, ağlama, ortalıktan çekilme';

	List<String> get steps => [
		'Sakin bir ses tonuyla "Yanındayım, güvendesin" deyin.',
		'Derin nefes egzersizi yapın: 4 saniye içeri, 6 saniye dışarı.',
		'"Şu an 5 şey gör, 4 şey dokun" duyusal zemin egzersizi uygulayın.',
		'Güvenli kişi veya nesne sunun (sevdiği oyuncak, kulaklık).',
		'Krizin geçmesi için zaman verin, acele ettirmeyin.',
	];
	List<String> get avoid => [
		'"Sakin ol, sorun yok" diyerek küçümsemeyin.',
		'Sormaya devam edip baskı uygulamayın.',
		'Kaygı anında yeni talep eklemeyin.',
	];
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Otizm Destek',
			'common.cancel' => 'Vazgeç',
			'common.loading' => 'Yükleniyor',
			'common.comingSoon' => 'Bu bölüm yakında eklenecek.',
			'common.seeAll' => 'Tümünü Gör',
			'common.more' => 'Daha Fazla',
			'common.retry' => 'Tekrar Dene',
			'common.loadError' => 'Veriler yüklenemedi.',
			'common.monthsShort.0' => 'Oca',
			'common.monthsShort.1' => 'Şub',
			'common.monthsShort.2' => 'Mar',
			'common.monthsShort.3' => 'Nis',
			'common.monthsShort.4' => 'May',
			'common.monthsShort.5' => 'Haz',
			'common.monthsShort.6' => 'Tem',
			'common.monthsShort.7' => 'Ağu',
			'common.monthsShort.8' => 'Eyl',
			'common.monthsShort.9' => 'Eki',
			'common.monthsShort.10' => 'Kas',
			'common.monthsShort.11' => 'Ara',
			'language.title' => 'Dil',
			'language.turkish' => 'Türkçe',
			'language.english' => 'English',
			'theme.title' => 'Tema',
			'theme.system' => 'Sistem',
			'theme.light' => 'Açık',
			'theme.dark' => 'Koyu',
			'roles.parent' => 'Veli',
			'roles.expert' => 'Uzman',
			'roles.admin' => 'Yönetici',
			'auth.subtitle' => 'Hesabınıza giriş yapın veya yeni bir hesap oluşturun.',
			'auth.emailLabel' => 'E-posta Adresi',
			'auth.emailHint' => 'ornek@eposta.com',
			'auth.passwordLabel' => 'Şifre',
			'auth.passwordHint' => '••••••••',
			'auth.rememberMe' => 'Beni hatırla',
			'auth.forgotPassword' => 'Şifremi unuttum',
			'auth.loginButton' => 'Giriş Yap',
			'auth.noAccount' => 'Hesabınız yok mu?',
			'auth.registerParent' => 'Veli hesabı ile kaydol',
			'auth.registerExpert' => 'Uzman hesabı ile kaydol',
			'auth.errorEmptyFields' => 'Lütfen e-posta ve şifrenizi girin.',
			'auth.registerComingSoon' => ({required Object role}) => '${role} kayıt ekranı yakında eklenecek.',
			'auth.errorMfaRequired' => 'Bu hesapta iki adımlı doğrulama açık; şimdilik web üzerinden giriş yapın.',
			'auth.resendVerification' => 'Doğrulama e-postasını yeniden gönder',
			'verifyEmail.title' => 'E-posta Doğrulama',
			'verifyEmail.waitingTitle' => 'Gelen kutunuzu kontrol edin',
			'verifyEmail.waitingBody' => 'Doğrulama bağlantısını gönderdik. Bağlantıya dokunduktan sonra bu ekrana dönüp giriş yapabilirsiniz.',
			'verifyEmail.waitingBodyWithEmail' => ({required Object email}) => '${email} adresine doğrulama bağlantısı gönderdik. Bağlantıya dokunduktan sonra bu ekrana dönüp giriş yapabilirsiniz.',
			'verifyEmail.spamHint' => 'E-posta birkaç dakika içinde gelmezse spam/gereksiz klasörünü kontrol edin.',
			'verifyEmail.approvalTitle' => 'Uzman hesabınız onay bekliyor',
			'verifyEmail.approvalBody' => 'Başvurunuz alındı. Lisans bilgileriniz yönetici tarafından doğrulandıktan sonra giriş yapabilirsiniz.',
			'verifyEmail.tokenLabel' => 'Doğrulama Kodu',
			'verifyEmail.tokenHint' => 'E-postadaki bağlantıda yer alan kod',
			'verifyEmail.tokenHelp' => 'Bağlantıyı açamıyorsanız içindeki kodu buraya yapıştırın.',
			'verifyEmail.verifyButton' => 'Doğrula',
			'verifyEmail.verifying' => 'E-posta adresiniz doğrulanıyor…',
			'verifyEmail.resendButton' => 'E-postayı yeniden gönder',
			'verifyEmail.resent' => 'Yeni doğrulama bağlantısı gönderildi. Gelen kutunuzu ve spam klasörünü kontrol edin.',
			'verifyEmail.success' => 'E-posta adresiniz doğrulandı. Artık giriş yapabilirsiniz.',
			'verifyEmail.errorTokenRequired' => 'Lütfen doğrulama kodunu girin.',
			'verifyEmail.errorEmailRequired' => 'Yeniden göndermek için e-posta adresi gerekli.',
			'verifyEmail.backToLogin' => 'Giriş sayfasına dön',
			'forgotPassword.title' => 'Şifremi Unuttum',
			'forgotPassword.subtitle' => 'E-posta adresinizi girin; size bir şifre sıfırlama bağlantısı gönderelim.',
			'forgotPassword.submit' => 'Sıfırlama Bağlantısı Gönder',
			'forgotPassword.sentTitle' => 'Bağlantı gönderildi',
			'forgotPassword.sentBody' => 'Bu e-postaya kayıtlı bir hesap varsa, şifre sıfırlama bağlantısı gelen kutunuza ulaşacaktır.',
			'forgotPassword.haveCode' => 'Sıfırlama kodum var',
			'forgotPassword.backToLogin' => 'Girişe dön',
			'forgotPassword.errorEmailRequired' => 'Lütfen e-posta girin.',
			'forgotPassword.errorEmailInvalid' => 'Geçerli bir e-posta girin.',
			'resetPassword.title' => 'Şifre Sıfırla',
			'resetPassword.subtitle' => 'E-postadaki sıfırlama kodunu ve yeni şifrenizi girin.',
			'resetPassword.tokenLabel' => 'Sıfırlama Kodu',
			'resetPassword.tokenHint' => 'E-postadaki bağlantıdaki kod',
			'resetPassword.newPasswordLabel' => 'Yeni Şifre',
			'resetPassword.confirmLabel' => 'Yeni Şifre (Tekrar)',
			'resetPassword.submit' => 'Şifreyi Güncelle',
			'resetPassword.success' => 'Şifreniz güncellendi. Giriş yapabilirsiniz.',
			'resetPassword.errorTokenRequired' => 'Lütfen sıfırlama kodunu girin.',
			'resetPassword.errorPasswordShort' => 'Şifre en az 8 karakter olmalıdır.',
			'resetPassword.errorMismatch' => 'Şifreler eşleşmiyor.',
			'password.strengthTitle' => 'Şifre gücü',
			'password.strengthVeryWeak' => 'Çok zayıf',
			'password.strengthWeak' => 'Zayıf',
			'password.strengthMedium' => 'Orta',
			'password.strengthStrong' => 'Güçlü',
			'password.strengthVeryStrong' => 'Çok güçlü',
			'password.ruleMinLength' => 'En az 8 karakter',
			'password.ruleUppercase' => 'Bir büyük harf',
			'password.ruleDigit' => 'Bir rakam',
			'password.ruleSpecial' => 'Bir özel karakter',
			'password.errorTooShort' => 'Şifre en az 8 karakter olmalıdır.',
			'password.errorTooLong' => 'Şifre en fazla 64 karakter olabilir.',
			'password.errorNoUppercase' => 'Şifre en az bir büyük harf içermelidir.',
			'password.errorNoDigit' => 'Şifre en az bir rakam içermelidir.',
			'password.errorNoSpecial' => 'Şifre en az bir özel karakter (örn. ! ? * . -) içermelidir.',
			'password.errorCommon' => 'Bu şifre çok yaygın ve kolay tahmin edilebilir; lütfen farklı bir şifre seçin.',
			'register.titleParent' => 'Veli Hesabı Oluştur',
			'register.titleExpert' => 'Uzman Hesabı Oluştur',
			'register.roleQuestion' => 'Nasıl kaydolmak istersiniz?',
			'register.fullNameLabel' => 'Ad Soyad',
			'register.fullNameHint' => 'Adınız ve soyadınız',
			'register.phoneLabel' => 'Telefon (isteğe bağlı)',
			'register.phoneHint' => '05XX XXX XX XX',
			'register.cityLabel' => 'Şehir (isteğe bağlı)',
			'register.cityHint' => 'Yaşadığınız şehir',
			'register.expertTitleLabel' => 'Uzmanlık Ünvanı',
			'register.expertTitleHint' => 'Örn. Çocuk Psikoloğu',
			'register.institutionLabel' => 'Kurum (isteğe bağlı)',
			'register.institutionHint' => 'Çalıştığınız kurum',
			'register.licenseNumberLabel' => 'Lisans / Diploma No',
			'register.licenseNumberHint' => 'Mesleki lisans numaranız',
			'register.bioLabel' => 'Hakkında (isteğe bağlı)',
			'register.bioHint' => 'Deneyiminizi kısaca anlatın',
			'register.specializationsLabel' => 'Uzmanlık Alanları (isteğe bağlı)',
			'register.specializationsHint' => 'Virgülle ayırın (Otizm, DEHB)',
			'register.kvkkConsent' => 'KVKK aydınlatma metnini okudum ve onaylıyorum.',
			'register.submit' => 'Kaydol',
			'register.haveAccount' => 'Zaten hesabınız var mı? Giriş yapın',
			'register.errorFullNameRequired' => 'Lütfen ad soyad girin.',
			'register.errorEmailRequired' => 'Lütfen e-posta girin.',
			'register.errorEmailInvalid' => 'Geçerli bir e-posta girin.',
			'register.errorPasswordShort' => 'Şifre en az 8 karakter olmalıdır.',
			'register.errorExpertTitleRequired' => 'Lütfen uzmanlık ünvanını girin.',
			'register.errorLicenseRequired' => 'Uzman kaydı için lisans / diploma numarası zorunludur.',
			'register.errorKvkkRequired' => 'Devam etmek için KVKK onayı gereklidir.',
			'register.emailTaken' => 'Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.',
			'register.emailAvailable' => 'Bu e-posta adresi kullanılabilir.',
			'settings.title' => 'Ayarlar',
			'settings.notificationsTitle' => 'Bildirimler',
			'settings.notificationsSubtitle' => 'Hangi konularda bildirim almak istediğinizi seçin.',
			'settings.notifMessages' => 'Yeni mesajlar',
			'settings.notifAppointment' => 'Randevu onay ve değişiklikleri',
			'settings.notifApptReminder' => 'Randevudan 24 saat önce hatırlat',
			'settings.notifExpertNote' => 'Uzman notları ve geri bildirimleri',
			'settings.notifTaskAssigned' => 'Yeni ödev atandığında',
			'settings.notifForum' => 'Forum ve dertleşme duvarı yanıtları',
			'settings.notifMatching' => 'Benzer aile eşleşmeleri',
			'settings.notifCalendar' => 'Takvim hatırlatmaları',
			'settings.privacyTitle' => 'Gizlilik',
			'settings.privacySubtitle' => 'Diğer kullanıcıların sizi nasıl göreceğini belirleyin.',
			'settings.privacyShowProfile' => 'Profilim diğer ailelere görünsün',
			'settings.privacyAllowMessages' => 'Bana mesaj gönderilebilsin',
			'settings.privacyShareProgress' => 'Gelişim özetini bağlı uzmanla paylaş',
			'settings.privacyApproximateLocation' => 'Yaklaşık konumum (şehir) paylaşılsın',
			'settings.privacyHidePresence' => 'Çevrimiçi olduğumu gizle',
			'settings.appearanceTitle' => 'Görünüm ve dil',
			'settings.accessibilityTitle' => 'Erişilebilirlik',
			'settings.accessibilitySubtitle' => 'Görünümü ve etkileşimi size uygun hale getirin.',
			'settings.a11yLargeText' => 'Büyük yazı modu',
			'settings.a11yLargeTextBody' => 'Metinleri daha büyük gösterir.',
			'settings.a11yCalmMode' => 'Sakin görünüm',
			'settings.a11yCalmModeBody' => 'Göz yormayan yumuşak tonlar kullanır.',
			'settings.a11yHighContrast' => 'Yüksek kontrast',
			'settings.a11yHighContrastBody' => 'Yazıları en belirgin renkte tutar.',
			'settings.a11yReduceMotion' => 'Hareketi azalt',
			'settings.a11yReduceMotionBody' => 'Sayfa geçişlerini ve animasyonları kapatır.',
			'settings.a11ySimpleMode' => 'Basit mod',
			'settings.a11ySimpleModeBody' => 'Profil menüsünü temel bölümlere indirger.',
			'settings.securityTitle' => 'Güvenlik',
			'settings.securitySubtitle' => 'Hesabınıza erişimi koruyun.',
			'settings.changePassword' => 'Şifre değiştir',
			'settings.changePasswordSubmit' => 'Şifreyi güncelle',
			'settings.currentPasswordLabel' => 'Mevcut şifre',
			'settings.newPasswordLabel' => 'Yeni şifre',
			'settings.passwordChanged' => 'Şifreniz güncellendi.',
			'settings.errorCurrentPasswordRequired' => 'Lütfen mevcut şifrenizi girin.',
			'settings.dataTitle' => 'Verileriniz ve KVKK',
			'settings.dataSubtitle' => 'Verileriniz üzerindeki haklarınızı buradan kullanabilirsiniz.',
			'settings.kvkkPanel' => 'KVKK hakları ve rızalar',
			'settings.kvkkPanelBody' => 'Rıza tercihleri, başvurular ve aydınlatma metni.',
			'settings.downloadData' => 'Verilerimi indir',
			'settings.downloadDataBody' => 'Hesabınızdaki tüm veriyi JSON dosyası olarak alın.',
			'settings.downloadDataSubject' => 'Otizm Destek — hesap verilerim',
			'settings.deleteAccount' => 'Hesabımı sil',
			'settings.deleteAccountBody' => 'Hesabınız ve tüm kayıtlarınız kalıcı olarak silinir.',
			'settings.deleteAccountWarning' => 'Bu işlem geri alınamaz. Çocuk profilleri, notlar, randevular ve mesajlar dâhil tüm verileriniz kalıcı olarak silinir.',
			'settings.deleteAccountSubmit' => 'Hesabımı kalıcı olarak sil',
			'settings.deleteKeyword' => 'SİL',
			'settings.deleteConfirmLabel' => ({required Object keyword}) => 'Onaylamak için "${keyword}" yazın',
			'settings.errorDeleteConfirm' => 'Onay metni eşleşmiyor.',
			'legal.title' => 'Yasal metinler',
			'legal.subtitle' => 'Aydınlatma metni, gizlilik politikası, kullanım şartları ve tıbbi uyarılar. Metinler bağlayıcı sürüm olduğu için Türkçe gösterilir.',
			'legal.versionLine' => ({required Object version, required Object date}) => 'Metin sürümü ${version} · Son güncelleme ${date}',
			'legal.readNotice' => 'KVKK aydınlatma metnini oku',
			'kvkk.title' => 'KVKK ve rızalar',
			'kvkk.rightsTitle' => 'KVKK md. 11 haklarınız',
			'kvkk.rightsBody' => 'Verilerinizin işlenip işlenmediğini öğrenme, düzeltilmesini veya silinmesini isteme, aktarıldığı üçüncü kişileri bilme ve otomatik analiz sonuçlarına itiraz etme hakkınız var. Başvurularınız en geç 30 gün içinde yanıtlanır.',
			'kvkk.consentsTitle' => 'Rıza tercihleriniz',
			'kvkk.consentsSubtitle' => 'Açık rıza amaca özel olmalıdır; her başlığı ayrı ayrı açıp kapatabilirsiniz.',
			'kvkk.consentNotice' => 'Aydınlatma metni onayı',
			'kvkk.consentAi' => 'Yapay zekâ analizi',
			'kvkk.consentAiBody' => 'Gelişim verisinin yapay zekâ sağlayıcısına (yurt dışına) aktarılmasına izin verir.',
			'kvkk.consentEmergency' => 'Acil durum kartı paylaşımı',
			'kvkk.consentEmergencyBody' => 'Acil durum kartınızın bağlantı/QR ile üçüncü kişilere gösterilmesine izin verir.',
			'kvkk.consentMatching' => 'Benzer aile eşleştirmesi',
			'kvkk.consentMatchingBody' => 'Profilinizin eşleştirme motorunda diğer ailelere gösterilmesine izin verir.',
			'kvkk.consentMarketing' => 'Bilgilendirme e-postaları',
			'kvkk.consentMarketingBody' => 'Zorunlu olmayan duyuru ve bilgilendirme e-postalarını almanızı sağlar.',
			'kvkk.reconsentTitle' => 'Aydınlatma metni güncellendi',
			'kvkk.reconsentTitleVersion' => ({required Object version}) => 'Aydınlatma metni güncellendi (sürüm ${version})',
			'kvkk.reconsentBody' => 'Verilerinizin nasıl işlendiğini gözden geçirip güncel metni onaylayın.',
			'kvkk.reconsentAccept' => 'Okudum, onaylıyorum',
			'kvkk.reconsentSaved' => 'Güncel aydınlatma metni onayınız kaydedildi.',
			'kvkk.historyTitle' => 'Rıza geçmişim',
			'kvkk.requestsTitle' => 'Başvurularım',
			'kvkk.requestsSubtitle' => 'Verileriniz hakkındaki taleplerinizi buradan iletebilirsiniz.',
			'kvkk.newRequest' => 'KVKK başvurusu yap',
			'kvkk.requestsEmpty' => 'Henüz bir başvurunuz yok.',
			'kvkk.requestsError' => 'Başvurular yüklenemedi.',
			'kvkk.requestCreated' => 'Başvurunuz alındı. En geç 30 gün içinde yanıtlanacaktır.',
			'kvkk.requestInfo' => 'Verilerimin işlenip işlenmediğini öğrenmek istiyorum',
			'kvkk.requestCorrection' => 'Eksik veya yanlış işlenen verimin düzeltilmesini istiyorum',
			'kvkk.requestDeletion' => 'Verilerimin silinmesini / yok edilmesini istiyorum',
			'kvkk.requestTransfer' => 'Verilerimin aktarıldığı üçüncü kişileri öğrenmek istiyorum',
			'kvkk.requestObjection' => 'Otomatik analiz sonucu aleyhime çıkan sonuca itiraz ediyorum',
			'kvkk.requestDamages' => 'Uğradığım zararın giderilmesini talep ediyorum',
			'kvkk.descriptionLabel' => 'Talebiniz',
			'kvkk.descriptionHint' => 'Talebinizi kısaca açıklayın.',
			'kvkk.responseTime' => 'Başvurular en geç 30 gün içinde yanıtlanır.',
			'kvkk.submitRequest' => 'Başvuruyu gönder',
			'kvkk.errorDescriptionRequired' => 'Lütfen talebinizi açıklayın.',
			'kvkk.statusOpen' => 'Alındı',
			'kvkk.statusReviewing' => 'İnceleniyor',
			'kvkk.statusDone' => 'Tamamlandı',
			'kvkk.statusRejected' => 'Reddedildi',
			'kvkk.receivedOn' => ({required Object date}) => '${date} tarihinde alındı',
			'kvkk.dueOn' => ({required Object date}) => 'yanıt son tarihi ${date}',
			'onboarding.title' => 'Başlangıç',
			'onboarding.skip' => 'Atla',
			'onboarding.start' => 'Başlayalım',
			'onboarding.back' => 'Geri',
			'onboarding.continueButton' => 'Devam et',
			'onboarding.skipForNow' => 'Şimdilik atla',
			'onboarding.finish' => 'Ana sayfaya geç',
			'onboarding.stepChild' => 'Çocuk Profili',
			'onboarding.stepTags' => 'Destek Alanları',
			'onboarding.stepPlan' => 'Başlangıç Planı',
			'onboarding.welcomeTitle' => 'Hoş geldiniz',
			'onboarding.welcomeBody' => 'Birkaç kısa adımda uygulamayı çocuğunuza göre hazırlayalım. Tüm bilgileri sonradan değiştirebilirsiniz.',
			'onboarding.introChildTitle' => 'Temel bilgiler',
			'onboarding.introChildBody' => 'Ad ve isteğe bağlı kısa bilgiler',
			'onboarding.introTagsTitle' => 'Destek alanları',
			'onboarding.introTagsBody' => 'Gözlemlediğiniz alanları seçin',
			'onboarding.introPlanTitle' => 'Başlangıç önerisi',
			'onboarding.introPlanBody' => 'İlk yapabileceklerinizi görün',
			'onboarding.childTitle' => 'Çocuğunuzu tanıyalım',
			'onboarding.childSubtitle' => 'Yalnızca ad zorunlu; diğer alanları daha sonra da doldurabilirsiniz.',
			'onboarding.childNameLabel' => 'Çocuğun adı',
			'onboarding.childNameHint' => 'Örn. Elif',
			'onboarding.childBirthDateLabel' => 'Doğum tarihi (isteğe bağlı)',
			'onboarding.childBirthDateHint' => 'Seçmek için dokunun',
			'onboarding.childDiagnosisLabel' => 'Tanı bilgisi (isteğe bağlı)',
			'onboarding.childDiagnosisHint' => 'Varsa tanı ve kısa notlar',
			'onboarding.focusTitle' => 'Başlangıç odağı',
			'onboarding.communicationTitle' => 'İletişim şekli',
			'onboarding.supportTitle' => 'Yararlı olabilecek destek',
			'onboarding.tagsTitle' => 'Hangi alanlarda destek arıyorsunuz?',
			'onboarding.tagsSubtitle' => 'Gözlemlediğiniz alanları seçin; benzer aileler ve içerik önerileri buna göre şekillenir.',
			'onboarding.planTitle' => 'Başlangıç planınız hazır',
			'onboarding.planTitleNamed' => ({required Object name}) => '${name} için başlangıç planınız hazır',
			'onboarding.planSubtitle' => 'İlk adım olarak şunlardan birini deneyebilirsiniz.',
			'onboarding.planNote' => 'Bu seçimler yalnızca başlangıç yönlendirmesidir; tüm bölümlere menüden ulaşabilirsiniz.',
			'onboarding.planTrackerTitle' => 'Günlük kayıt ekle',
			'onboarding.planTrackerBody' => 'Uyku, duygu durumu veya kısa bir gözlem girin.',
			'onboarding.planExpertsTitle' => 'Uzmanları incele',
			'onboarding.planExpertsBody' => 'Uzmanlara göz atın veya randevu talebi oluşturun.',
			'onboarding.planKnowledgeTitle' => 'Bilgi ve kaynakları keşfet',
			'onboarding.planKnowledgeBody' => 'Bilgi bankasındaki güvenilir içeriklere göz atın.',
			'onboarding.expertTitle' => ({required Object name}) => 'Hoş geldiniz ${name}',
			'onboarding.expertBody' => 'Danışan takibi, randevular ve mesajlaşma ana sayfada sizi bekliyor.',
			'onboarding.errorNameRequired' => 'Çocuğun adı zorunludur.',
			'onboarding.errorBirthDateFuture' => 'Doğum tarihi gelecekte olamaz.',
			'nav.home' => 'Ana Sayfa',
			'nav.specialists' => 'Uzmanlar',
			'nav.progress' => 'Gelişim',
			'nav.profile' => 'Profil',
			'chat.title' => 'AI Asistan',
			'chat.greeting' => 'Merhaba! Otizm ve çocuk gelişimi hakkındaki sorularınızı yanıtlamaya çalışayım.',
			'chat.inputHint' => 'Bir soru sorun...',
			'chat.errorGeneric' => 'Yanıt alınamadı, lütfen tekrar deneyin.',
			'messages.title' => 'Mesajlar',
			'messages.noConversations' => 'Henüz bir konuşmanız yok.',
			'messages.noMessages' => 'Henüz mesaj yok. İlk mesajı gönderin.',
			'messages.inputHint' => 'Mesaj yazın...',
			'messages.connecting' => 'Bağlanıyor...',
			'home.notifications' => 'Bildirimler',
			'home.assistant' => 'AI Asistan',
			'home.messages' => 'Mesajlar',
			'home.greeting' => ({required Object name}) => 'Merhaba, ${name}',
			'home.greetingFallback' => 'Veli',
			'home.subtitle' => 'Bugün gelişim için neler yapabiliriz?',
			'home.childProgressTitle' => 'Çocuk Gelişimi',
			'home.weeklySummary' => 'Haftalık İlerleme Özeti',
			'home.increaseBadge' => ({required Object value}) => '%${value} Artış',
			'home.remainingToGoal' => ({required Object value}) => 'Hedefe Kalan: %${value}',
			'home.statusCognitiveGood' => 'Bilişsel: İyi',
			'home.statusCommunicationImproving' => 'İletişim: Gelişiyor',
			'home.upcomingAppointments' => 'Yaklaşan Randevular',
			'home.recommendedArticles' => 'Önerilen Makaleler',
			'home.childrenTitle' => 'Çocuklarım',
			'home.noChildren' => 'Henüz çocuk eklemediniz.',
			'home.addChild' => 'Çocuk Ekle',
			'home.ageYears' => ({required Object years}) => '${years} yaş',
			'home.noAppointments' => 'Yaklaşan randevunuz yok.',
			'home.noArticles' => 'Gösterilecek makale yok.',
			'specialists.title' => 'Uzman Bulun',
			'specialists.searchHint' => 'İsim veya uzmanlık arayın...',
			'specialists.filterAll' => 'Tümü',
			'specialists.filterPsychologist' => 'Psikolog',
			'specialists.filterSpecialEducation' => 'Özel Eğitim',
			'specialists.filterSpeech' => 'Dil ve Konuşma',
			'specialists.noResults' => 'Aramanıza uygun uzman bulunamadı.',
			'specialists.ratingNew' => 'Yeni',
			'specialists.reviews' => ({required Object count}) => '${count} değerlendirme',
			'progress.title' => 'Gelişim Takibi',
			'progress.subtitle' => 'Hedefler ve gelişim notları.',
			'progress.addRecord' => 'Yeni Kayıt Ekle',
			'progress.goalsTitle' => 'Hedefler',
			'progress.recentNotes' => 'Son Gelişim Notları',
			'progress.noGoals' => 'Henüz hedef eklenmemiş.',
			'progress.noNotes' => 'Henüz gelişim notu eklenmemiş.',
			'progress.noChild' => 'Gelişim takibi için önce bir çocuk ekleyin.',
			'progress.goalProgress' => ({required Object done, required Object total}) => '${done} / ${total}',
			'progress.addGoal' => 'Hedef Ekle',
			'progress.addNote' => 'Not Ekle',
			'progress.addToken' => 'Jeton Ekle',
			'progress.tokenAdded' => 'Jeton eklendi 🎉',
			'progress.tokenRemoved' => 'Jeton geri alındı.',
			'progress.goalCompleted' => 'Hedef tamamlandı! 🎉',
			'progress.rewardLine' => ({required Object title}) => 'Ödül: ${title}',
			'goalForm.title' => 'Hedef Ekle',
			'goalForm.nameLabel' => 'Başlık',
			'goalForm.nameHint' => 'Örn. Göz teması kurma',
			'goalForm.categoryLabel' => 'Kategori',
			'goalForm.targetLabel' => 'Hedef Sayısı',
			'goalForm.descriptionLabel' => 'Açıklama (isteğe bağlı)',
			'goalForm.descriptionHint' => 'Hedefle ilgili detay',
			'goalForm.save' => 'Kaydet',
			'goalForm.errorTitle' => 'Lütfen bir başlık girin.',
			'goalForm.created' => 'Hedef eklendi.',
			'noteForm.title' => 'Not Ekle',
			'noteForm.editTitle' => 'Notu Düzenle',
			'noteForm.nameLabel' => 'Başlık',
			'noteForm.nameHint' => 'Örn. Bugünkü gelişme',
			'noteForm.contentLabel' => 'İçerik (isteğe bağlı)',
			'noteForm.contentHint' => 'Gözlemlerinizi yazın',
			'noteForm.categoryLabel' => 'Kategori (isteğe bağlı)',
			'noteForm.moodLabel' => 'Ruh Hali (isteğe bağlı)',
			'noteForm.moodHappy' => 'Mutlu',
			'noteForm.moodNeutral' => 'Normal',
			'noteForm.moodSad' => 'Zor Gün',
			'noteForm.dateLabel' => 'Tarih',
			'noteForm.save' => 'Kaydet',
			'noteForm.errorTitle' => 'Lütfen bir başlık girin.',
			'noteForm.created' => 'Not eklendi.',
			'noteForm.updated' => 'Not güncellendi.',
			'notesPage.title' => 'Notlarım',
			'notesPage.add' => 'Not Ekle',
			'notesPage.searchHint' => 'Notlarda ara…',
			'notesPage.empty' => 'Henüz gelişim notu yok. İlk notu ekleyerek başlayın.',
			'notesPage.noResults' => 'Sonuç bulunamadı. Filtre veya aramayı değiştirin.',
			'notesPage.noChildren' => 'Önce bir çocuk profili ekleyin.',
			'notesPage.loadMore' => 'Daha Fazla Yükle',
			'notesPage.edit' => 'Düzenle',
			'notesPage.delete' => 'Sil',
			'notesPage.cancel' => 'Vazgeç',
			'notesPage.deleteTitle' => 'Notu Sil',
			'notesPage.deleteConfirm' => 'Bu notu silmek istediğinize emin misiniz?',
			'notesPage.deleted' => 'Not silindi.',
			'notifications.show' => 'Göster',
			'notifications.title' => 'Bildirimler',
			'notifications.empty' => 'Henüz bildiriminiz yok.',
			'notifications.markAllRead' => 'Tümünü okundu işaretle',
			'notifications.dateLine' => ({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}',
			'knowledge.title' => 'Bilgi Bankası',
			'knowledge.empty' => 'Henüz makale eklenmemiş.',
			'knowledge.noResults' => 'Bu filtreye uygun içerik yok.',
			'knowledge.filterAll' => 'Tümü',
			'knowledge.formatArticle' => 'Makale',
			'knowledge.formatVideo' => 'Video',
			'knowledge.formatPodcast' => 'Podcast',
			'knowledge.views' => ({required Object count}) => '${count} görüntülenme',
			'knowledge.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'knowledge.videoLink' => 'Video bağlantısı',
			'knowledge.podcastLink' => 'Podcast bağlantısı',
			'appointments.title' => 'Randevular',
			'appointments.empty' => 'Henüz randevunuz yok.',
			'appointments.upcoming' => 'Yaklaşan',
			'appointments.past' => 'Geçmiş',
			'appointments.statusPending' => 'Onay Bekliyor',
			'appointments.statusConfirmed' => 'Onaylandı',
			'appointments.statusCompleted' => 'Tamamlandı',
			'appointments.statusCancelled' => 'İptal Edildi',
			'appointments.typeOnline' => 'Online Görüşme',
			'appointments.typeFaceToFace' => 'Yüz Yüze',
			'appointments.withChild' => ({required Object name}) => 'Çocuk: ${name}',
			'appointments.dateLine' => ({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}',
			'appointments.cancel' => 'İptal Et',
			'appointments.confirm' => 'Onayla',
			'appointments.complete' => 'Tamamla',
			'appointments.joinMeeting' => 'Görüşmeye Katıl',
			'appointments.cancelTitle' => 'Randevuyu İptal Et',
			'appointments.cancelConfirm' => 'Bu randevuyu iptal etmek istediğinize emin misiniz?',
			'appointments.cancelReasonLabel' => 'İptal nedeni (isteğe bağlı)',
			'appointments.cancelReasonShown' => ({required Object reason}) => 'İptal nedeni: ${reason}',
			'appointments.keepIt' => 'Vazgeç',
			'appointments.cancelled' => 'Randevu iptal edildi.',
			'appointments.confirmed' => 'Randevu onaylandı.',
			'appointments.completed' => 'Randevu tamamlandı olarak işaretlendi.',
			'appointments.reschedule' => 'Ertele',
			'appointments.rescheduleTitle' => 'Randevuyu Ertele',
			'appointments.rescheduleConfirm' => 'Yeni Zamanı Onayla',
			'appointments.rescheduled' => 'Randevu yeniden planlandı.',
			'expertDetail.bookAppointment' => 'Randevu Al',
			'expertDetail.sendMessage' => 'Mesaj Gönder',
			'expertDetail.specializationsTitle' => 'Uzmanlık Alanları',
			'expertDetail.articleCount' => ({required Object count}) => '${count} makale',
			'expertDetail.notAcceptingPatients' => 'Bu uzman şu an randevu kabul etmiyor.',
			'booking.title' => 'Randevu Al',
			'booking.childLabel' => 'Çocuk',
			'booking.noChild' => 'Randevu almak için önce bir çocuk ekleyin.',
			'booking.typeLabel' => 'Randevu Tipi',
			'booking.dateLabel' => 'Tarih',
			'booking.selectDate' => 'Tarih seçin',
			'booking.dateValue' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'booking.timeLabel' => 'Saat',
			'booking.selectDateFirst' => 'Uygun saatleri görmek için önce tarih seçin.',
			'booking.noSlots' => 'Bu gün için uygun saat yok.',
			'booking.notesLabel' => 'Not (isteğe bağlı)',
			'booking.notesHint' => 'Uzmana iletmek istediğiniz not',
			'booking.confirm' => 'Randevuyu Onayla',
			'booking.created' => 'Randevu oluşturuldu.',
			'booking.errorSelectChild' => 'Lütfen bir çocuk seçin.',
			'booking.errorSelectTime' => 'Lütfen bir saat seçin.',
			'routines.title' => 'Rutinler',
			'routines.empty' => 'Bu çocuk için henüz rutin yok.',
			'routines.noChild' => 'Rutin oluşturmak için önce bir çocuk ekleyin.',
			'routines.add' => 'Rutin Ekle',
			'routines.addItem' => 'Adım Ekle',
			'routines.noItems' => 'Henüz adım eklenmemiş.',
			'routines.deleteRoutineTitle' => 'Rutini Sil',
			'routines.deleteRoutineConfirm' => ({required Object name}) => '${name} rutinini silmek istediğinize emin misiniz?',
			'routines.delete' => 'Sil',
			'routines.cancel' => 'İptal',
			'routines.created' => 'Rutin eklendi.',
			'routines.itemAdded' => 'Adım eklendi.',
			'routines.deleted' => 'Rutin silindi.',
			'routines.itemTitleLabel' => 'Adım Başlığı',
			'routines.itemTitleHint' => 'Örn. Dişleri fırçala',
			'routines.itemTimeLabel' => 'Saat (isteğe bağlı)',
			'routines.selectTime' => 'Saat seç',
			'routines.itemIconLabel' => 'İkon',
			'routines.itemSave' => 'Ekle',
			'routines.errorItemTitle' => 'Lütfen adım başlığı girin.',
			'routineForm.title' => 'Rutin Ekle',
			'routineForm.nameLabel' => 'Rutin Adı',
			'routineForm.nameHint' => 'Örn. Sabah Rutini',
			'routineForm.descriptionLabel' => 'Açıklama (isteğe bağlı)',
			'routineForm.descriptionHint' => 'Bu rutin ne için?',
			'routineForm.save' => 'Kaydet',
			'routineForm.errorName' => 'Lütfen bir rutin adı girin.',
			'dailyTracker.title' => 'Günlük Takip',
			'dailyTracker.tabMood' => 'Duygu',
			'dailyTracker.tabSleep' => 'Uyku',
			'dailyTracker.tabMeds' => 'İlaç',
			'dailyTracker.todayTitle' => 'Bugün nasıldı?',
			'dailyTracker.today' => 'Bugün',
			'dailyTracker.mood1' => 'Çok Kötü',
			'dailyTracker.mood2' => 'Kötü',
			'dailyTracker.mood3' => 'Orta',
			'dailyTracker.mood4' => 'İyi',
			'dailyTracker.mood5' => 'Harika',
			'dailyTracker.triggersLabel' => 'Olası tetikleyiciler (isteğe bağlı)',
			'dailyTracker.notesLabel' => 'Not (isteğe bağlı)',
			'dailyTracker.notesHint' => 'Bugüne dair gözlemleriniz',
			'dailyTracker.save' => 'Kaydet',
			'dailyTracker.update' => 'Güncelle',
			'dailyTracker.saved' => 'Ruh hali kaydedildi.',
			'dailyTracker.historyTitle' => 'Geçmiş Kayıtlar',
			'dailyTracker.empty' => 'Henüz kayıt yok. İlk kaydı bugün ekleyin.',
			'dailyTracker.noChild' => 'Günlük takip için önce bir çocuk ekleyin.',
			'dailyTracker.deleteTitle' => 'Kaydı Sil',
			'dailyTracker.deleteConfirm' => ({required Object date}) => '${date} tarihli kaydı silmek istediğinize emin misiniz?',
			'dailyTracker.delete' => 'Sil',
			'dailyTracker.cancel' => 'İptal',
			'dailyTracker.deleted' => 'Kayıt silindi.',
			'dailyTracker.errorSelectMood' => 'Lütfen bir ruh hali seçin.',
			'dailyTracker.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'sleep.todayTitle' => 'Dün Gece / Bu Sabah',
			'sleep.bedtime' => 'Yatış Saati',
			'sleep.wakeTime' => 'Uyanış Saati',
			'sleep.quality' => 'Uyku Kalitesi',
			'sleep.nightWakings' => 'Gece uyanma sayısı',
			'sleep.factorsLabel' => 'Duyusal ve çevresel faktörler',
			'sleep.factorWeighted' => '🛏️ Ağır Battaniye',
			'sleep.factorSensory' => '👕 Duyusal Hassasiyet',
			'sleep.factorMelatonin' => '💊 Melatonin Desteği',
			'sleep.factorNoise' => '🔊 Gürültü / Işık',
			'sleep.saved' => 'Uyku kaydedildi.',
			'sleep.empty' => 'Henüz uyku kaydı yok. İlk kaydı bugün ekleyin.',
			'sleep.deleteConfirm' => ({required Object date}) => '${date} tarihli uyku kaydını silmek istediğinize emin misiniz?',
			'sleep.deleted' => 'Uyku kaydı silindi.',
			'sleep.duration' => ({required Object h, required Object m}) => '${h} sa ${m} dk',
			'sleep.wakings' => ({required Object count}) => '${count} kez uyandı',
			'meds.safetyTitle' => 'İlaç güvenliği',
			'meds.safetyBody' => 'İlaç hatırlatıcıları destek amaçlıdır. İlaç başlama, bırakma, doz değişikliği veya yan etki kararlarını yalnızca doktorunuzla birlikte verin.',
			'meds.add' => 'İlaç Ekle',
			'meds.addTitle' => 'Yeni İlaç Ekle',
			'meds.editTitle' => 'İlacı Düzenle',
			_ => null,
		} ?? switch (path) {
			'meds.empty' => 'Henüz ilaç kaydı yok. Çocuğunuzun ilaç ve takviyelerini buraya ekleyin.',
			'meds.name' => 'İlaç / Takviye Adı',
			'meds.nameHint' => 'Örn: Omega-3',
			'meds.dosage' => 'Doz',
			'meds.unit' => 'Birim',
			'meds.frequency' => 'Sıklık',
			'meds.freqDaily' => 'Günde 1',
			'meds.freqTwiceDaily' => 'Günde 2',
			'meds.freqThreeDaily' => 'Günde 3',
			'meds.freqAsNeeded' => 'Gerektiğinde',
			'meds.freqWeekly' => 'Haftalık',
			'meds.timesLabel' => 'Doz saatleri',
			'meds.addTime' => 'Saat Ekle',
			'meds.noTime' => 'Saatsiz',
			'meds.added' => 'İlaç eklendi.',
			'meds.updated' => 'İlaç güncellendi.',
			'meds.deleteTitle' => 'İlacı Sil',
			'meds.deleteConfirm' => ({required Object name}) => '${name} ve doz kayıtları kalıcı olarak silinecek. Emin misiniz?',
			'meds.deleted' => 'İlaç silindi.',
			'meds.errorName' => 'Lütfen ilaç adını girin.',
			'meds.logTitle' => 'Doz Günlüğü',
			'meds.taken' => 'İlaç alındı',
			'meds.sideEffectsLabel' => 'Gözlemlenen yan etkiler',
			'meds.logNotesLabel' => 'Gözlem notları (isteğe bağlı)',
			'meds.logNotesHint' => 'Doktorunuza iletmek istediğiniz bir gözlem var mı?',
			'meds.logSaved' => 'Doz günlüğü kaydedildi.',
			'wall.title' => 'Dertleşme Duvarı',
			'wall.subtitle' => 'Duygularınızı paylaşın, birbirinize destek olun. Paylaşımlar anonim olabilir.',
			'wall.empty' => 'Henüz paylaşım yok. İlk paylaşımı sen yap.',
			'wall.add' => 'Paylaş',
			'wall.addTitle' => 'Dertleşme Paylaşımı',
			'wall.editTitle' => 'Paylaşımı Düzenle',
			'wall.titleLabel' => 'Başlık (isteğe bağlı)',
			'wall.titleHint' => 'Kısa bir başlık',
			'wall.contentLabel' => 'Ne hissediyorsun?',
			'wall.contentHint' => 'İçini dökebilirsin; burada yalnız değilsin.',
			'wall.anonymous' => 'Anonim paylaş',
			'wall.anonymousUser' => 'Anonim Kullanıcı',
			'wall.post' => 'Paylaş',
			'wall.posted' => 'Paylaşımınız duvara eklendi.',
			'wall.updated' => 'Paylaşım güncellendi.',
			'wall.deleteTitle' => 'Paylaşımı Sil',
			'wall.deleteConfirm' => 'Bu paylaşımı silmek istediğinize emin misiniz?',
			'wall.deleted' => 'Paylaşım silindi.',
			'wall.errorContent' => 'Lütfen bir şeyler yazın.',
			'wall.supportCount' => ({required Object count}) => '${count} destek',
			'wall.commentCount' => ({required Object count}) => '${count} yorum',
			'wall.detailTitle' => 'Paylaşım',
			'wall.commentsTitle' => 'Destek Mesajları',
			'wall.commentHint' => 'Bir destek mesajı yaz…',
			'wall.commentSend' => 'Gönder',
			'wall.commentSent' => 'Destek mesajı gönderildi.',
			'wall.commentEmpty' => 'Henüz destek mesajı yok. İlk desteği sen ver.',
			'wall.commentDeleteTitle' => 'Yorumu Sil',
			'wall.commentDeleteConfirm' => 'Bu destek mesajını silmek istediğinize emin misiniz?',
			'wall.commentDeleted' => 'Yorum silindi.',
			'wall.edit' => 'Düzenle',
			'wall.delete' => 'Sil',
			'wall.cancel' => 'İptal',
			'wall.save' => 'Kaydet',
			'wall.justNow' => 'az önce',
			'wall.minsAgo' => ({required Object count}) => '${count} dk önce',
			'wall.hoursAgo' => ({required Object count}) => '${count} sa önce',
			'wall.daysAgo' => ({required Object count}) => '${count} gün önce',
			'weekly.title' => 'Haftanın Sorusu',
			'weekly.subtitle' => 'Bu hafta ailelere sorduğumuz soru. Deneyimini paylaş, birbirinize destek olun.',
			'weekly.empty' => 'Henüz haftalık soru yok. Yeni soru yayınlandığında burada olacak.',
			'weekly.answersTitle' => 'Aile Cevapları',
			'weekly.answerCount' => ({required Object count}) => '${count} cevap',
			'weekly.expertCount' => ({required Object count}) => '${count} uzman',
			'weekly.expertBadge' => 'Uzman',
			'weekly.anonymousUser' => 'Anonim Aile',
			'weekly.yourAnswerTitle' => 'Cevabını Yaz',
			'weekly.answerHint' => 'Kısa da olsa değerli. Deneyimini paylaş…',
			'weekly.anonymous' => 'Anonim paylaş',
			'weekly.tagsLabel' => 'Etiketler (isteğe bağlı)',
			'weekly.send' => 'Paylaş',
			'weekly.sent' => 'Cevabın paylaşıldı, teşekkürler!',
			'weekly.errorEmpty' => 'Lütfen bir cevap yazın.',
			'weekly.noAnswers' => 'Henüz cevap yok. İlk cevabı sen paylaş.',
			'weekly.likeError' => 'Beğeni kaydedilemedi.',
			'weekly.justNow' => 'az önce',
			'weekly.minsAgo' => ({required Object count}) => '${count} dk önce',
			'weekly.hoursAgo' => ({required Object count}) => '${count} sa önce',
			'weekly.daysAgo' => ({required Object count}) => '${count} gün önce',
			'meetup.title' => 'Yerel Buluşmalar',
			'meetup.subtitle' => 'Şehrindeki ailelerle tanış, birlikte vakit geçir.',
			'meetup.empty' => 'Bu şehirde henüz buluşma yok. İlk buluşmayı sen oluştur.',
			'meetup.add' => 'Buluşma Oluştur',
			'meetup.addTitle' => 'Yeni Buluşma',
			'meetup.titleLabel' => 'Buluşma Adı',
			'meetup.titleHint' => 'ör: Parkta Sabah Buluşması',
			'meetup.cityLabel' => 'Şehir',
			'meetup.cityHint' => 'Şehir seç',
			'meetup.districtLabel' => 'İlçe',
			'meetup.districtHint' => 'ör: Kadıköy',
			'meetup.venueLabel' => 'Buluşma Yeri',
			'meetup.venueHint' => 'ör: Moda Parkı veya kafe adı',
			'meetup.dateLabel' => 'Tarih',
			'meetup.timeLabel' => 'Saat',
			'meetup.descriptionLabel' => 'Açıklama',
			'meetup.descriptionHint' => 'Kimler katılabilir, ortam nasıl olacak?',
			'meetup.create' => 'Oluştur',
			'meetup.created' => 'Buluşman oluşturuldu. Diğer aileler görebilecek.',
			'meetup.errorRequired' => 'Lütfen başlık, şehir ve tarih alanlarını doldurun.',
			'meetup.attendCount' => ({required Object count}) => '${count} katılımcı',
			'meetup.join' => 'Katıl',
			'meetup.joined' => 'Katılıyorsun',
			'meetup.joinedMsg' => 'Buluşmaya katılıyorsun!',
			'meetup.leftMsg' => 'Katılımın iptal edildi.',
			'meetup.today' => 'Bugün',
			'meetup.tomorrow' => 'Yarın',
			'meetup.inDays' => ({required Object count}) => '${count} gün sonra',
			'meetup.past' => 'Geçmiş',
			'meetup.organizerBy' => ({required Object name}) => 'Düzenleyen ${name}',
			'similar.title' => 'Benzer Aileler',
			'similar.subtitle' => 'Çocuğunuza yakın gelişim sürecindeki ailelerle tanışın, deneyim paylaşın.',
			'similar.noChild' => 'Önce bir çocuk ekleyin, sonra benzer aileleri keşfedin.',
			'similar.discoverable' => 'Eşleştirmede görünürsün',
			'similar.hidden' => 'Eşleştirmede gizlisin',
			'similar.discoverableHint' => 'Kapatırsan diğer aileler seni öneriler arasında göremez.',
			'similar.empty' => 'Şu an eşleşen aile yok. Profilinizi ve etiketlerinizi güncelleyerek eşleşme şansını artırabilirsiniz.',
			'similar.matchLabel' => 'uyum',
			'similar.commonTagsTitle' => 'Ortak alanlar',
			'similar.moreTags' => ({required Object count}) => '+${count}',
			'similar.reasonsTitle' => 'Neden eşleştiniz',
			'similar.ageRange' => ({required Object range}) => 'Yaş ${range}',
			'similar.message' => 'Mesaj',
			'similar.buddy' => 'Arkadaş',
			'similar.mentor' => 'Mentor',
			'similar.pendingLabel' => 'İstek bekliyor',
			'similar.buddyLabel' => 'Arkadaş bağlantısı',
			'similar.mentorLabel' => 'Mentor bağlantısı',
			'similar.requestTitle' => 'Bağlantı isteği',
			'similar.mentorRequestTitle' => 'Mentor isteği',
			'similar.requestHint' => 'Kısa bir tanışma mesajı yaz (isteğe bağlı)',
			'similar.requestDefault' => 'Merhaba, benzer süreçlerden geçtiğimizi gördüm. Uygunsanız önce burada kısa bir tanışma mesajlaşması yapmak isterim.',
			'similar.send' => 'İsteği Gönder',
			'similar.sent' => 'Bağlantı isteği gönderildi.',
			'similar.cancel' => 'İptal',
			'groups.title' => 'Destek Grupları',
			'groups.subtitle' => 'Benzer konularda ailelerle bir araya gel, grup sohbetine katıl.',
			'groups.tabMy' => 'Gruplarım',
			'groups.tabDiscover' => 'Keşfet',
			'groups.searchHint' => 'Grup ara…',
			'groups.allCategories' => 'Tümü',
			'groups.emptyMy' => 'Henüz bir gruba katılmadın. Keşfet sekmesinden gruplara göz at.',
			'groups.emptyDiscover' => 'Bu ölçütlerle grup bulunamadı. Yeni bir grup oluşturabilirsin.',
			'groups.memberCount' => ({required Object count}) => '${count} üye',
			'groups.expertCount' => ({required Object count}) => '${count} uzman',
			'groups.verified' => 'Onaylı',
			'groups.join' => 'Katıl',
			'groups.joined' => 'Katıldın',
			'groups.leave' => 'Ayrıl',
			'groups.chat' => 'Grup Sohbeti',
			'groups.joinedMsg' => 'Gruba katıldın.',
			'groups.leftMsg' => 'Gruptan ayrıldın.',
			'groups.leaveTitle' => 'Gruptan Ayrıl',
			'groups.leaveConfirm' => 'Bu gruptan ayrılmak istediğine emin misin?',
			'groups.add' => 'Grup Oluştur',
			'groups.addTitle' => 'Yeni Grup',
			'groups.nameLabel' => 'Grup Adı',
			'groups.nameHint' => 'ör: İstanbul Erken Müdahale',
			'groups.descriptionLabel' => 'Açıklama',
			'groups.descriptionHint' => 'Grup ne hakkında, kimler katılabilir?',
			'groups.categoryLabel' => 'Kategori',
			'groups.create' => 'Oluştur',
			'groups.created' => 'Grup oluşturuldu.',
			'groups.errorName' => 'Lütfen bir grup adı girin.',
			'treatment.title' => 'Tedavi Paneli',
			'treatment.subtitle' => 'Günlük Destek Planı',
			'treatment.programActive' => ({required Object name}) => '${name} planı aktif',
			'treatment.selectChild' => 'Profil seç',
			'treatment.noChildrenTitle' => 'Henüz çocuk profili yok',
			'treatment.noChildrenBody' => 'Tedavi planı için önce bir çocuk profili ekleyin.',
			'treatment.addChild' => 'Çocuk Ekle',
			'treatment.saveError' => 'Tedavi verileri kaydedilemedi, değişiklik geri alındı.',
			'treatment.tabToday' => 'Bugün',
			'treatment.tabGoals' => 'Hedefler',
			'treatment.tabGames' => 'Oyunlar',
			'treatment.tabTools' => 'Araçlar',
			'treatment.daysShort.0' => 'Paz',
			'treatment.daysShort.1' => 'Pzt',
			'treatment.daysShort.2' => 'Sal',
			'treatment.daysShort.3' => 'Çar',
			'treatment.daysShort.4' => 'Per',
			'treatment.daysShort.5' => 'Cum',
			'treatment.daysShort.6' => 'Cmt',
			'treatment.onboardTitle' => 'Merhaba! 3 adımda başlayın 👋',
			'treatment.onboardBody' => 'Bu sayfa, her gün çocuğunuzla yapabileceğiniz küçük destekleri takip etmenizi sağlar.',
			'treatment.onboardStep1' => '1. Hedefler sekmesinden bugün takip etmek istediğiniz küçük bir şey yazın.',
			'treatment.onboardStep2' => '2. Oyunlar sekmesindeki 5-10 dakikalık etkinlikleri deneyin.',
			'treatment.onboardStep3' => '3. Oyun sonrası "Kolay geldi / Zorlandı" seçin — gerisini sistem halleder.',
			'treatment.todayTitle' => 'Bugünün kısa planı',
			'treatment.todaySubtitle' => 'Bir madde seçin, uygulayın, sonra tamamlandı olarak işaretleyin.',
			'treatment.streakDays' => ({required Object count}) => '${count} gün seri',
			'treatment.doneOf' => ({required Object done, required Object total}) => '${done}/${total} yapıldı',
			'treatment.stepCount' => ({required Object count}) => '${count} adım',
			'treatment.emptyPlanTitle' => 'Bugün için plan bulunamadı.',
			'treatment.emptyPlanBody' => 'Hedef eklediğinizde burada kısa günlük adımlar görünecek.',
			'treatment.planDone' => 'Bugünün planı tamamlandı.',
			'treatment.planDoneSub' => 'Bugünlük bu kadar yeterli.',
			'treatment.moodSaveTitle' => 'Bugünkü ruh halini kaydet',
			'treatment.moodSaveSub' => 'Plan, çocuğun durumuna göre otomatik uyarlanır',
			'treatment.moodTodayLabel' => ({required Object label}) => 'Bugünkü ruh hali: ${label}',
			'treatment.moodPlanned' => 'Plan bu duruma göre hazırlandı',
			'treatment.moodLevel1' => 'Zorlanıyor',
			'treatment.moodLevel2' => 'Hassas',
			'treatment.moodLevel3' => 'Dengeli',
			'treatment.moodLevel4' => 'İyi',
			'treatment.moodLevel5' => 'Çok iyi',
			'treatment.suggestionsTitle' => 'Bugün dikkat edilecekler',
			'treatment.latestNoteTitle' => 'Son not',
			'treatment.defaultExpert' => 'Uzman Terapist',
			'treatment.noNoteAuthor' => 'Platform Terapi Modülü',
			'treatment.noNoteRole' => 'Otomatik günlük plan',
			'treatment.noNoteBody' => 'Henüz uzman notu yok. Bugünün planı, çocuğunuzun kayıtlarına göre hazırlandı.',
			'treatment.noteEmptyContent' => 'Bu nota eklenmiş detay bulunmuyor.',
			'treatment.weeklyTitle' => 'Haftalık özet',
			'treatment.weeklySubtitle' => 'Bu bölüm sadece genel durumu gösterir.',
			'treatment.legendGame' => 'Oyun',
			'treatment.legendGoal' => 'Hedef',
			'treatment.chartGames' => ({required Object count}) => '${count} oyun',
			'treatment.chartGoal' => ({required Object percent}) => '%${percent} hedef',
			'treatment.weekGamesTitle' => 'Bu hafta oyun',
			'treatment.weekGamesDetail' => 'Bu hafta tekrar edilen mini egzersiz sayısı',
			'treatment.weekGamesEmpty' => 'Bugün ilk oyunu planlayabilirsiniz',
			'treatment.weekGoalsTitle' => 'Tamamlanan hedef',
			'treatment.weekGoalsDetail' => 'Tüm aktif beceri alanlarındaki toplam ilerleme',
			'treatment.weekGoalsEmpty' => 'Hedefler sekmesinden hedef ekleyebilirsiniz',
			'treatment.weekSessionsTitle' => 'Yaklaşan Seans',
			'treatment.weekSessionsDetail' => 'Planlanmış randevu veya etkinlik',
			'treatment.weekSessionsEmpty' => 'Henüz randevu planlanmamış',
			'treatment.microTitle' => 'Gelişim alanları',
			'treatment.microSubtitle' => 'Ayrıntıya gerek olduğunda buraya bakabilirsiniz.',
			'treatment.microLinkedGame' => 'Destekleyen oyun:',
			'treatment.addGoalTitle' => 'Günlük Hedef Ekle',
			'treatment.addGoalSubtitle' => 'Bugün çocuğunuza özel takip etmek istediğiniz küçük bir şey yazın.',
			'treatment.goalHint' => 'Örn: 2 kez göz teması kurdu',
			'treatment.focusLabel' => 'Hedef alanı',
			'treatment.dueDateLabel' => 'Bitiş tarihi (isteğe bağlı)',
			'treatment.addGoal' => 'Hedef Ekle',
			'treatment.saving' => 'Kaydediliyor…',
			'treatment.yourGoals' => 'Sizin eklediğiniz hedefler',
			'treatment.edit' => 'Düzenle',
			'treatment.delete' => 'Sil',
			'treatment.save' => 'Kaydet',
			'treatment.cancel' => 'Vazgeç',
			'treatment.goalAdded' => 'Yeni hedef eklendi.',
			'treatment.goalUpdated' => 'Hedef güncellendi.',
			'treatment.goalEdited' => 'Hedef düzenlendi.',
			'treatment.goalDeleted' => 'Hedef silindi.',
			'treatment.groupsHeader' => 'Terapi Hedefleri — Alana Göre İlerleme',
			'treatment.groupDone' => ({required Object done, required Object total}) => '${done}/${total} tamamlandı',
			'treatment.statusDone' => 'Tamamlandı',
			'treatment.statusActive' => 'Devam',
			'treatment.statusUpcoming' => 'Sırada',
			'treatment.emptyGroupsTitle' => 'Henüz terapi hedefi görünmüyor',
			'treatment.emptyGroupsBody' => 'Çocuğunuzun profiline terapi türü eklendiğinde hedefler otomatik olarak burada listelenir.',
			'treatment.milestoneTitle' => 'Büyük Bir Başarı Kaydet 🏅',
			'treatment.milestoneSubtitle' => 'Hatırlamak istediğiniz önemli bir an',
			'treatment.milestoneHint' => 'Örn: İlk kez adını söyledi',
			'treatment.milestoneSaved' => 'Kilometre taşı kaydedildi 🎉',
			'treatment.notesTitle' => 'Son Gözlem Notları',
			'treatment.notesEmpty' => 'Henüz bu çocuğa ait uzman veya ebeveyn notu yok.',
			'treatment.upcomingTitle' => 'Yaklaşan Etkinlikler',
			'treatment.upcomingEmpty' => 'Yakın tarihte planlanmış aktif seans veya etkinlik görünmüyor.',
			'treatment.goAppointments' => 'Randevular',
			'treatment.goCalendar' => 'Takvime Git',
			'treatment.gamesTitle' => 'Günlük Aktiviteler',
			'treatment.gamesSubtitle' => 'Çocuğunuzun terapi hedeflerine göre önerilen kısa etkinlikler. Oynadıktan sonra nasıl gittiğini seçin.',
			'treatment.todayDone' => ({required Object done, required Object total}) => '${done}/${total} bugün tamamlandı',
			'treatment.filterAll' => 'Tümü',
			'treatment.gameReady' => 'Hazır',
			'treatment.gameDoneBadge' => '✅ Yapıldı',
			'treatment.methodLabel' => ({required Object name}) => 'Yöntem: ${name}',
			'treatment.whyGood' => 'Neden iyi gelir?',
			'treatment.goalBadge' => ({required Object name}) => 'Hedef: ${name}',
			'treatment.toolBadge' => ({required Object name}) => 'Araç: ${name}',
			'treatment.playToday' => 'Bugün oynat',
			'treatment.playedToday' => 'Yapıldı olarak işaretli',
			'treatment.feedbackQuestion' => 'Nasıl gitti? (isteğe bağlı)',
			'treatment.fbNone' => 'Henüz sonuç seçilmedi',
			'treatment.fbEasy' => 'Çok kolay',
			'treatment.fbAssisted' => 'Yardımla',
			'treatment.fbIndependent' => 'Kendi başına',
			'treatment.fbChallenging' => 'Zorlandı',
			'treatment.fbEasyLong' => 'Kolay geldi',
			'treatment.fbAssistedLong' => 'Yardımla yaptı',
			'treatment.fbIndependentLong' => 'Tek başına yaptı',
			'treatment.fbChallengingLong' => 'Zorlandı',
			'treatment.feedbackSaved' => 'Oyun geri bildirimi kaydedildi.',
			'treatment.allDoneTitle' => '🎉 Bugünün tüm oyunları tamamlandı. Harika gidiyorsunuz!',
			'treatment.allDoneBody' => 'Bugünkü destek akışını tamamladınız; isterseniz notlar bölümüne kısa bir gözlem ekleyebilirsiniz.',
			'treatment.hintMastered' => 'Ustalık kazandı! Daha zor varyant deneyin.',
			'treatment.hintEasy' => 'Çok kolay geliyor. Zorluk artırın.',
			'treatment.hintChallenging' => 'Zorlanıyor. Aktiviteyi parçalara bölün.',
			'treatment.notifyExpert' => 'Uzmana Bildir',
			'treatment.notifyBody' => ({required Object game}) => '${game} aktivitesindeki zorlanma hakkında uzmanınıza kısa bir not gönderin.',
			'treatment.notifyDefaultMsg' => ({required Object game}) => '"${game}" aktivitesinde son zamanlarda zorlanıyor. Önerisi olan var mı?',
			'treatment.notifyNoExpert' => 'Henüz mesajlaştığınız bir uzman yok. Önce bir uzmanla bağlantı kurmanız gerekiyor.',
			'treatment.notifySeeExperts' => 'Uzmanları Görüntüle',
			'treatment.notifySend' => 'Gönder',
			'treatment.notifySent' => 'Uzmana bildirildi.',
			'treatment.emptyGames' => 'Bu alanda henüz etkinlik önerilmiyor. Çocuğunuzun profil sayfasına terapi bilgisi eklediğinizde etkinlikler burada görünür.',
			'treatment.historyTitle' => 'Oyun Geçmişi',
			'treatment.historySubtitle' => 'Oynadığınız etkinliklerin geçmişi burada görünür.',
			'treatment.historyCount' => ({required Object count}) => '${count} kayıt',
			'treatment.historyEmpty' => 'Henüz oyun kaydı yok. İlk kayıt oluşturulduğunda geçmiş burada görünür.',
			'treatment.challengingSummary' => ({required Object count}) => '💪 ${count} etkinlikte "Zorlandı" işaretlenmiş. Zorlanılan etkinlikleri tekrar denerken daha küçük adımlara bölmeyi ya da uzmanınıza bildirmeyi düşünebilirsiniz.',
			'treatment.storiesTitle' => 'Sosyal Hikâyeler ve Görsel Akış',
			'treatment.storiesSubtitle' => 'Bir etkinliğe başlamadan önce çocuğunuza "Ne olacak?" sorusunu yanıtlayan kısa resimli hikâyeler — geçişleri kolaylaştırır.',
			'treatment.customBadge' => 'Özel hikâye',
			'treatment.linkedGoalBadge' => ({required Object name}) => 'Bağlı hedef: ${name}',
			'treatment.addStoryTitle' => 'Özel Sosyal Hikâye Ekle',
			'treatment.storyTitleHint' => 'Hikâye başlığı (örn: Alışverişe Gidiyorum)',
			'treatment.storyGoalHint' => 'Bağlı hedef (isteğe bağlı)',
			'treatment.storyAdd' => 'Ekle',
			'treatment.storyAdded' => 'Sosyal hikâye eklendi.',
			'treatment.storyDeleted' => 'Hikâye silindi.',
			'treatment.deleteStoryTitle' => 'Hikâyeyi Sil',
			'treatment.deleteStoryConfirm' => 'Bu hikâyeyi silmek istediğinize emin misiniz?',
			'treatment.sensoryTitle' => 'Rahatlatan Şeyler Ayarları',
			'treatment.sensorySubtitle' => 'Ölçüm Kartları',
			'treatment.sensorySaved' => 'Duyusal profil güncellendi.',
			'treatment.sliderHeader' => 'Duyusal Hassasiyet Seviyeleri',
			'treatment.sliderSound' => '🔊 Ses Hassasiyeti',
			'treatment.sliderTouch' => '🖐️ Dokunsal Hassasiyet',
			'treatment.sliderVisual' => '👁️ Görsel Hassasiyet',
			'treatment.metricSound' => 'Ses hassasiyeti',
			'treatment.metricTouch' => 'Dokunsal hassasiyet',
			'treatment.metricVisual' => 'Görsel uyarı toleransı',
			'treatment.metricSoundNote' => 'Geçişlerde duyusal mola oyunu ile birlikte izleniyor.',
			'treatment.metricTouchNote' => 'Dokunsal uyaranlar sıra alma ve basınç aktiviteleriyle destekleniyor.',
			'treatment.metricVisualNote' => 'Görsel hikâyeler ve zaman çizelgesi ile dengede tutuluyor.',
			'treatment.triggerTitle' => 'Tetikleyici Günlüğü',
			'treatment.tokenTitle' => 'Dijital Jeton Panosu',
			'treatment.tokenSubtitle' => 'Çocuğunuzla bir hedef seçin. Görevleri başardıkça yıldız ekleyin. 5 yıldıza ulaştığında hak ettiği ödülü kazansın!',
			'treatment.tokenRewardLabel' => 'Hedeflenen Ödül',
			'treatment.tokenRewardHint' => 'Örn: Salıncağa binmek 🛝',
			'treatment.tokenSetReward' => 'Ödülü Tanımla',
			'treatment.tokenActive' => 'Aktif Ödül',
			'treatment.tokenCollect' => ({required Object count}) => 'Başarı Yıldızlarını Toplayın (${count}/5)',
			'treatment.tokenAdd' => '⭐ Yıldız Ekle',
			'treatment.tokenFullTitle' => 'Tebrikler! Jeton Kartı Doldu',
			'treatment.tokenFullBody' => ({required Object reward}) => 'Çocuğunuz bütün adımları başarıyla tamamladı ve ${reward} hakkı kazandı!',
			'treatment.tokenReset' => 'Panoyu Sıfırla',
			'treatment.tokenDefaultReward' => 'Parka Gitmek 🛝',
			'treatment.breathTitle' => 'Nefes Alıştırması',
			'treatment.breathBody' => 'Çocuğunuz aşırı uyarılmış hissettiğinde Kriz Rehberi\'ndeki nefes regülatörünü birlikte kullanın.',
			'treatment.breathOpen' => 'Nefes Egzersizini Aç',
			'treatment.aiStoryTitle' => 'AI ile Sosyal Hikâye',
			'treatment.aiStoryBody' => 'Yeni bir durum için AI Asistan\'dan çocuğunuza özel kısa bir sosyal hikâye taslağı isteyin.',
			'treatment.aiStoryOpen' => 'AI Asistan\'ı Aç',
			'tasks.title' => 'Ödevlerim',
			'tasks.subtitle' => 'Uzmanınızın size atadığı çalışmalar burada görünür; tamamladıkça teslim edebilirsiniz.',
			'tasks.pendingLabel' => 'Bekleyen',
			'tasks.completedLabel' => 'Tamamlanan',
			'tasks.progressLabel' => 'Ne kadar tamamlandı',
			'tasks.overdueSummary' => ({required Object count}) => '${count} görevin son teslim tarihi geçmiş',
			'tasks.filterAll' => ({required Object count}) => 'Tümü (${count})',
			'tasks.filterPending' => ({required Object count}) => 'Yapılacaklar (${count})',
			'tasks.filterCompleted' => ({required Object count}) => 'Teslim Edilenler (${count})',
			'tasks.emptyAll' => 'Henüz uzman tarafından görev atanmamış. Uzmanınız yeni ödev belirlediğinde burada görebileceksiniz.',
			'tasks.emptyPending' => 'Bekleyen görev bulunmuyor.',
			'tasks.emptyCompleted' => 'Tamamlanan görev bulunmuyor.',
			'tasks.overdueBanner' => 'Son tarih geçti! Uzmanınız teslimat bekliyor.',
			'tasks.difficultyEasy' => 'Kolay',
			'tasks.difficultyMedium' => 'Orta',
			'tasks.difficultyHard' => 'Zor',
			'tasks.dueLabel' => ({required Object date}) => 'Son: ${date}',
			'tasks.detailLabel' => 'Görev Detayı',
			'tasks.openMaterial' => 'Gerekli Materyale Git',
			'tasks.submitTask' => 'Görevi Teslim Et',
			'tasks.submitted' => 'Görev başarıyla uzmanınıza teslim edildi!',
			'tasks.submissionsError' => 'Teslim kaydı yüklenemedi.',
			'tasks.noSubmission' => 'Bu görev için teslim kaydı bulunamadı (eski görev olabilir).',
			'tasks.yourNote' => 'Sizin Notunuz',
			'tasks.evidenceLink' => 'Eklenmiş Kanıt / Video',
			'tasks.expertFeedback' => 'Uzman Değerlendirmesi',
			'tasks.expertApprovedNoNote' => 'Uzman onayladı ama not bırakmadı.',
			'tasks.awaitingReview' => 'Uzman değerlendirmesi bekleniyor…',
			'tasks.submitTitle' => 'Görevi Teslim Et',
			'tasks.selectedTask' => 'Seçili Görev',
			'tasks.noteLabel' => 'Uzmana İletilecek Not',
			'tasks.noteHint' => 'Çocuğunuz bu görevi yaparken nasıl hissetti? (Örn: Çok rahat tamamladı)',
			'tasks.evidenceLabel' => 'Kanıt / Eklenti Bağlantısı (İsteğe Bağlı)',
			'tasks.evidenceHint' => 'Uzmanınızın görebilmesi için ilgili çalışma anının videosunu veya fotoğrafını bulut bağlantısı olarak ekleyebilirsiniz.',
			'tasks.submitConfirm' => 'Teslim Et ve Kapat',
			'forum.title' => 'Topluluk Forumu',
			'forum.typeExperience' => 'Deneyimler',
			'forum.typeQuestion' => 'Soru-Cevap',
			'forum.typeAdvice' => 'Tavsiyeler',
			'forum.typeSuccess' => 'Başarı Hikayeleri',
			'forum.catCommunication' => 'İletişim',
			'forum.catSocial' => 'Sosyal',
			'forum.catSensory' => 'Duyusal',
			'forum.catBehavior' => 'Davranış',
			'forum.catMotor' => 'Motor',
			'forum.catEducation' => 'Eğitim',
			'forum.justNow' => 'az önce',
			'forum.minsAgo' => ({required Object count}) => '${count} dk önce',
			'forum.hoursAgo' => ({required Object count}) => '${count} sa önce',
			'forum.daysAgo' => ({required Object count}) => '${count} gün önce',
			'forum.searchHint' => 'Forumda ara…',
			'forum.tagFilter' => 'Etiket filtresi',
			'forum.sortNew' => 'Yeni',
			'forum.sortHot' => 'Sıcak',
			'forum.sortUnanswered' => 'Cevapsız',
			'forum.sortExpert' => 'Uzmanlı',
			'forum.empty' => 'Henüz gönderi yok. Toplulukla bir deneyiminizi paylaşarak başlayın.',
			'forum.emptyQuestion' => 'Henüz soru yok. İlk soruyu sorarak tartışmayı başlatın.',
			'forum.add' => 'Paylaş',
			'forum.loadMore' => 'Daha Fazla Yükle',
			'forum.posted' => 'Gönderi paylaşıldı.',
			'forum.anonymousUser' => 'Anonim Kullanıcı',
			'forum.expertBadge' => 'Uzman',
			'forum.pinnedBadge' => 'Sabitlenmiş',
			'forum.answeredBadge' => 'Cevaplanmış',
			'forum.postTitle' => 'Gönderi',
			'forum.commentsHeader' => ({required Object count}) => 'Yorumlar (${count})',
			'forum.commentsError' => 'Yorumlar yüklenemedi.',
			'forum.noComments' => 'Henüz yorum yok. İlk yorumu siz yazın.',
			'forum.commentHint' => 'Bir yorum yazın…',
			'forum.replyHint' => 'Yanıtınızı yazın…',
			'forum.replyingTo' => ({required Object name}) => '${name} kişisine yanıt veriliyor',
			'forum.reply' => 'Yanıtla',
			'forum.acceptAnswer' => 'En İyi Cevap',
			'forum.answerAccepted' => 'En iyi cevap işaretlendi.',
			'forum.acceptedBadge' => 'En İyi Cevap',
			'forum.expertApproved' => 'Uzman Onaylı',
			'forum.editComment' => 'Yorumu Düzenle',
			'forum.deleteCommentTitle' => 'Yorumu Sil',
			'forum.deleteCommentConfirm' => 'Bu yorumu silmek istediğinize emin misiniz?',
			'forum.deleteTitle' => 'Gönderiyi Sil',
			'forum.deleteConfirm' => 'Bu gönderiyi silmek istediğinize emin misiniz?',
			'forum.cancel' => 'Vazgeç',
			'forum.delete' => 'Sil',
			'forum.save' => 'Kaydet',
			'forum.reportTitle' => 'Şikayet Et',
			'forum.reportHint' => 'Şikayet nedeninizi kısaca yazın',
			'forum.reportSend' => 'Gönder',
			'forum.reportSent' => 'Şikayetiniz alındı.',
			'forum.newPost' => 'Yeni Gönderi',
			'forum.editPost' => 'Gönderiyi Düzenle',
			'forum.titleLabel' => 'Başlık',
			'forum.titleHintQuestion' => 'Sorunuzu kısaca özetleyin',
			'forum.titleHint' => 'Gönderinizin başlığı',
			'forum.contentLabel' => 'İçerik',
			'forum.tagsLabel' => 'Semptom Etiketleri',
			'forum.anonymousTitle' => 'Anonim Olarak Paylaş',
			'forum.anonymousBody' => 'Profil bilgileriniz gizlenir, "Anonim Kullanıcı" olarak görünürsünüz.',
			'forum.privacyTitle' => 'Gizlilik Ayarları',
			'forum.privacyRealName' => 'Gerçek adımı göster',
			'forum.privacyChildAge' => 'Çocuğumun yaş aralığını göster',
			'forum.privacySymptoms' => 'Semptom etiketlerini göster',
			'forum.privacyDiagnosis' => 'Tanı detaylarını göster',
			'forum.privacyMatching' => 'Eşleştirme algoritmasında kullanılsın',
			'forum.share' => 'Paylaş',
			'childDetail.title' => 'Çocuk Profili',
			'childDetail.editProfile' => 'Profili Düzenle',
			'childDetail.ageYears' => ({required Object age}) => '${age} yaş',
			'childDetail.genderBoy' => 'Erkek',
			'childDetail.genderGirl' => 'Kız',
			'childDetail.photoUpdated' => 'Profil fotoğrafı güncellendi.',
			'childDetail.infoTitle' => 'Bilgiler',
			'childDetail.infoEmpty' => 'Henüz tanı/eğitim bilgisi eklenmemiş. Sağ üstten profili düzenleyebilirsiniz.',
			'childDetail.diagnosis' => 'Tanı Bilgisi',
			'childDetail.educationProgram' => 'Eğitim Programı',
			'childDetail.therapies' => 'Terapiler',
			'childDetail.tagsTitle' => 'Semptom Etiketleri',
			'childDetail.tagsEmpty' => 'Henüz etiket seçilmemiş. Etiketler benzer aile eşleştirmesinde ve forumda kullanılır.',
			'childDetail.tagsEdit' => 'Etiketleri Düzenle',
			'childDetail.tagsError' => 'Etiketler yüklenemedi.',
			'childDetail.edit' => 'Düzenle',
			'childDetail.save' => 'Kaydet',
			'childDetail.cancel' => 'Vazgeç',
			'childDetail.delete' => 'Sil',
			'childDetail.milestonesTitle' => 'Kilometre Taşları',
			'childDetail.milestonesEmpty' => 'Henüz kilometre taşı eklenmemiş. İlk büyük başarıyı kaydedin!',
			'childDetail.milestonesError' => 'Kilometre taşları yüklenemedi.',
			'childDetail.milestoneAdd' => 'Ekle',
			'childDetail.milestoneEdit' => 'Kilometre Taşını Düzenle',
			'childDetail.milestoneTitleLabel' => 'Başlık',
			'childDetail.milestoneTitleHint' => 'Örn: İlk kez göz teması kurdu',
			'childDetail.milestoneDescLabel' => 'Açıklama (isteğe bağlı)',
			'childDetail.milestoneSave' => 'Kilometre Taşı Ekle',
			'childDetail.milestoneDeleteTitle' => 'Kilometre Taşını Sil',
			'childDetail.milestoneDeleteConfirm' => 'Bu kaydı silmek istediğinize emin misiniz?',
			'childDetail.screeningTitle' => 'Tarama Sonuçları',
			'childDetail.screeningEmpty' => 'Henüz tarama sonucu yok.',
			'childDetail.scoreOf' => ({required Object score}) => '${score}/20',
			'childDetail.riskLow' => 'Düşük risk',
			'childDetail.riskMedium' => 'Orta risk',
			'childDetail.riskHigh' => 'Yüksek risk',
			'childDetail.shortcutsTitle' => 'Hızlı Erişim',
			'childDetail.shortcutTracker' => 'Günlük Takip',
			'childDetail.shortcutBehavior' => 'Davranış Günlüğü',
			'childDetail.shortcutTreatment' => 'Tedavi Paneli',
			'childDetail.shortcutAnalytics' => 'Gelişim Paneli',
			'crisis.title' => 'Kriz Rehberi',
			'crisis.heroTitle' => 'Zor Anlarda Ne Yapmalı?',
			'crisis.heroSubtitle' => 'Çocuğunuz bunaldığında sakin kalmanıza ve doğru adımları atmanıza yardımcı olacak hızlı rehber.',
			'crisis.breathingTitle' => 'Nefes Regülatörü',
			'crisis.breathingSubtitle' => 'Önce siz sakinleşin. Başlatın ve nefesinizi halkanın büyüme-küçülme hızına uydurun.',
			'crisis.breathingStart' => 'Egzersizi Başlat',
			'crisis.breathingStop' => 'Durdur',
			'crisis.breathingReady' => 'Hazır',
			'crisis.breathingReadyHint' => 'Başlamak için dokunun',
			'crisis.breathingInhale' => 'Nefes Al',
			'crisis.breathingExhale' => 'Nefes Ver',
			'crisis.breathingSeconds' => 'saniye',
			_ => null,
		} ?? switch (path) {
			'crisis.stepsLabel' => 'Ne Yapmalı?',
			'crisis.avoidLabel' => 'Kaçınılması Gerekenler',
			'crisis.emergencyLabel' => 'Önerilen Acil Hat',
			'crisis.contactsTitle' => 'Acil Numaralar',
			'crisis.disclaimer' => 'Bu rehber genel bilgilendirme amaçlıdır; acil ve tıbbi durumlarda mutlaka 112\'yi arayın.',
			'crisis.contact112Label' => 'Acil Sağlık ve Güvenlik',
			'crisis.contact112Desc' => 'Ambulans, Polis, İtfaiye',
			'crisis.contact183Label' => 'Sosyal Destek Hattı',
			'crisis.contact183Desc' => 'Kadın, Çocuk ve Sosyal Hizmetler',
			'crisis.cards.meltdown.title' => 'Kriz / Meltdown',
			'crisis.cards.meltdown.subtitle' => 'Kontrol kaybı, ağlama, bağırma, kendine zarar verme girişimi',
			'crisis.cards.meltdown.steps.0' => 'Sakin kalın — sesiniz ve beden diliniz çocuğa geçer.',
			'crisis.cards.meltdown.steps.1' => 'Güvenli alan oluşturun: keskin/sert nesneleri uzaklaştırın.',
			'crisis.cards.meltdown.steps.2' => 'Sözel uyarıyı minimuma indirin; tek kelime veya kısa cümleler.',
			'crisis.cards.meltdown.steps.3' => 'Duyusal uyaranları azaltın: ışıkları kısın, sesi düşürün.',
			'crisis.cards.meltdown.steps.4' => 'Yanında olmaya devam edin — uzaklaşmayın ama dokunmayın.',
			'crisis.cards.meltdown.steps.5' => 'Kriz geçtikten sonra sakin ses tonuyla güvence verin.',
			'crisis.cards.meltdown.avoid.0' => 'Yüksek sesle konuşmayın.',
			'crisis.cards.meltdown.avoid.1' => 'Mantık yürütmeye ya da açıklamaya çalışmayın.',
			'crisis.cards.meltdown.avoid.2' => 'Cezalandırma veya tehdit etmeyin.',
			'crisis.cards.meltdown.avoid.3' => 'Kalabalık içinde bırakmayın.',
			'crisis.cards.meltdown.emergency' => '112 — Acil Sağlık Hattı',
			'crisis.cards.sensory.title' => 'Duyusal Aşırı Yüklenme',
			'crisis.cards.sensory.subtitle' => 'Ellerini kulaklarına kapatma, ışıktan/sesten kaçma, donup kalma',
			'crisis.cards.sensory.steps.0' => 'Hemen daha sakin ve az uyarıcı bir ortama geçin.',
			'crisis.cards.sensory.steps.1' => 'Sevilen duyusal nesneleri sunun (ağırlıklı battaniye, squishy).',
			'crisis.cards.sensory.steps.2' => 'Tahmin edilebilir ve sakin bir ses tonuyla kısaca konuşun.',
			'crisis.cards.sensory.steps.3' => 'Derin baskı (sıkı sarılma) çocuk onay verirse uygulanabilir.',
			'crisis.cards.sensory.steps.4' => 'Zaman verin — birkaç dakika sessiz kalın.',
			'crisis.cards.sensory.steps.5' => 'Tetikleyiciyi not alın, ilerleyen dönemde önlem alın.',
			'crisis.cards.sensory.avoid.0' => 'Ortamı değiştirmeden sözlü yönlendirmeye devam etmeyin.',
			'crisis.cards.sensory.avoid.1' => 'Zorla bir şey tutturmaya çalışmayın.',
			'crisis.cards.sensory.avoid.2' => '"Neden bu kadar abartıyorsun?" demeyin.',
			'crisis.cards.aggression.title' => 'Saldırganlık / Kendine Zarar Verme',
			'crisis.cards.aggression.subtitle' => 'Vurma, ısırma, kafaya vurma, nesneleri fırlatma',
			'crisis.cards.aggression.steps.0' => 'Güvenli mesafe koruyun; yakınlarda başkası varsa uzaklaştırın.',
			'crisis.cards.aggression.steps.1' => 'Düşük sesli, kısa ve sakin direktifler verin ("Dur", "Burada").',
			'crisis.cards.aggression.steps.2' => 'Tahrik edici nesneleri ve kişileri ortamdan uzaklaştırın.',
			'crisis.cards.aggression.steps.3' => 'Alternatif çıkış noktası sunun: yastık vurma, koşu.',
			'crisis.cards.aggression.steps.4' => 'Kriz geçince olayı not edin; tetikleyiciyi analiz edin.',
			'crisis.cards.aggression.avoid.0' => 'Fiziksel güç uygulamaktan kaçının (zorunlu değilse).',
			'crisis.cards.aggression.avoid.1' => 'Dikkat çekerek ya da izleyici yaratarak ortamı körüklemeyin.',
			'crisis.cards.aggression.avoid.2' => 'Eylem anında ödüllendirmeyin.',
			'crisis.cards.aggression.emergency' => '112 — Acil Çağrı Merkezi',
			'crisis.cards.anxiety.title' => 'Yoğun Kaygı / Panik',
			'crisis.cards.anxiety.subtitle' => 'Titreme, nefes darlığı, ağlama, ortalıktan çekilme',
			'crisis.cards.anxiety.steps.0' => 'Sakin bir ses tonuyla "Yanındayım, güvendesin" deyin.',
			'crisis.cards.anxiety.steps.1' => 'Derin nefes egzersizi yapın: 4 saniye içeri, 6 saniye dışarı.',
			'crisis.cards.anxiety.steps.2' => '"Şu an 5 şey gör, 4 şey dokun" duyusal zemin egzersizi uygulayın.',
			'crisis.cards.anxiety.steps.3' => 'Güvenli kişi veya nesne sunun (sevdiği oyuncak, kulaklık).',
			'crisis.cards.anxiety.steps.4' => 'Krizin geçmesi için zaman verin, acele ettirmeyin.',
			'crisis.cards.anxiety.avoid.0' => '"Sakin ol, sorun yok" diyerek küçümsemeyin.',
			'crisis.cards.anxiety.avoid.1' => 'Sormaya devam edip baskı uygulamayın.',
			'crisis.cards.anxiety.avoid.2' => 'Kaygı anında yeni talep eklemeyin.',
			'calendar.title' => 'Takvim',
			'calendar.subtitle' => 'Çocuğa özel terapi, doktor ve etkinlik planı.',
			'calendar.noChild' => 'Takvim için önce bir çocuk ekleyin.',
			'calendar.empty' => 'Henüz etkinlik yok. İlk etkinliği ekleyin.',
			'calendar.add' => 'Etkinlik Ekle',
			'calendar.addTitle' => 'Yeni Etkinlik',
			'calendar.editTitle' => 'Etkinliği Düzenle',
			'calendar.eventType' => 'Etkinlik Tipi',
			'calendar.typeTerapi' => 'Terapi',
			'calendar.typeDoktor' => 'Doktor',
			'calendar.typeEgitim' => 'Eğitim',
			'calendar.typeAktivite' => 'Aktivite',
			'calendar.typeAppointment' => 'Randevu',
			'calendar.typeDiger' => 'Diğer',
			'calendar.eventTitle' => 'Başlık',
			'calendar.titleHint' => 'Etkinlik adı',
			'calendar.location' => 'Konum',
			'calendar.locationHint' => 'Klinik adı, adres',
			'calendar.description' => 'Açıklama',
			'calendar.start' => 'Başlangıç',
			'calendar.end' => 'Bitiş (isteğe bağlı)',
			'calendar.reminder' => 'Hatırlatma',
			'calendar.reminderOff' => 'Kapalı',
			'calendar.reminderMin' => ({required Object count}) => '${count} dk önce',
			'calendar.reminderHour' => ({required Object count}) => '${count} saat önce',
			'calendar.reminderDay' => '1 gün önce',
			'calendar.statusPlanned' => 'Planlandı',
			'calendar.statusCompleted' => 'Tamamlandı',
			'calendar.statusCancelled' => 'İptal',
			'calendar.markCompleted' => 'Tamamlandı işaretle',
			'calendar.markPlanned' => 'Planlandı yap',
			'calendar.markCancelled' => 'İptal et',
			'calendar.today' => 'Bugün',
			'calendar.tomorrow' => 'Yarın',
			'calendar.save' => 'Kaydet',
			'calendar.saved' => 'Etkinlik kaydedildi.',
			'calendar.deleteTitle' => 'Etkinliği Sil',
			'calendar.deleteConfirm' => ({required Object title}) => '"${title}" etkinliğini silmek istediğinize emin misiniz?',
			'calendar.deleted' => 'Etkinlik silindi.',
			'calendar.errorTitle' => 'Lütfen bir başlık girin.',
			'calendar.cancel' => 'İptal',
			'calendar.delete' => 'Sil',
			'emergency.title' => 'Acil Durum Kartı',
			'emergency.subtitle' => 'Acil bir durumda çocuğunuzla karşılaşan kişilere gösterilecek bilgiler.',
			'emergency.noChild' => 'Acil durum kartı için önce bir çocuk ekleyin.',
			'emergency.lastUpdated' => ({required Object date}) => 'Son güncelleme ${date}',
			'emergency.notSaved' => 'Bu kart henüz kaydedilmedi.',
			'emergency.save' => 'Kaydet',
			'emergency.saved' => 'Acil durum kartı kaydedildi.',
			'emergency.shareTitle' => 'QR kod ile paylaş',
			'emergency.shareBody' => 'Süreli bir bağlantı oluşturun; öğretmen veya sağlık görevlisi kartı bu bağlantıdan görüntüleyebilir. Bağlantıyı istediğiniz an kapatabilirsiniz.',
			'emergency.shareConsentRequired' => 'Paylaşım için "Acil durum kartı paylaşımı" rızasını vermeniz gerekiyor.',
			'emergency.shareOpenConsents' => 'Rıza ayarlarını aç',
			'emergency.shareDuration' => 'Geçerlilik süresi',
			'emergency.share24h' => '24 saat geçerli',
			'emergency.share3d' => '3 gün geçerli',
			'emergency.share1w' => '1 hafta geçerli',
			'emergency.share30d' => '30 gün geçerli',
			'emergency.shareEnable' => 'Paylaşım bağlantısı oluştur',
			'emergency.shareDisable' => 'Paylaşımı kapat',
			'emergency.shareValidUntil' => ({required Object date}) => 'Bağlantı ${date} tarihine kadar geçerli.',
			'emergency.shareCopy' => 'Bağlantıyı kopyala',
			'emergency.shareCopied' => 'Bağlantı kopyalandı.',
			'emergency.shareSend' => 'Paylaş',
			'emergency.shareMessage' => 'Çocuğumun acil durum kartını buradan görüntüleyebilirsiniz:',
			'emergency.call' => 'Ara',
			'emergency.sectionChild' => 'Çocuk Bilgileri',
			'emergency.sectionContacts' => 'Acil İletişim',
			'emergency.sectionMedical' => 'Tıbbi Bilgiler',
			'emergency.sectionBehavior' => 'Davranışsal Bilgiler',
			'emergency.childName' => 'Ad Soyad',
			'emergency.birthDate' => 'Doğum Tarihi',
			'emergency.diagnosis' => 'Tanı',
			'emergency.bloodType' => 'Kan Grubu',
			'emergency.communicationLevel' => 'İletişim Seviyesi',
			'emergency.languages' => 'Konuşulan Dil(ler)',
			'emergency.warningsLabel' => 'Özel durum uyarıları',
			'emergency.selfInjury' => 'Öz-zarar davranışı olabilir',
			'emergency.wandering' => 'Kaçma / kaybolma riski var',
			'emergency.nonVerbal' => 'Sözel iletişim yoktur',
			'emergency.contact1' => 'Birinci Kişi',
			'emergency.contact2' => 'İkinci Kişi',
			'emergency.doctor' => 'Doktor / Hastane',
			'emergency.name' => 'Ad Soyad',
			'emergency.phone' => 'Telefon',
			'emergency.relation' => 'Yakınlık',
			'emergency.doctorName' => 'Doktor Adı',
			'emergency.doctorPhone' => 'Doktor Telefonu',
			'emergency.hospital' => 'Hastane',
			'emergency.medications' => 'Kullandığı İlaçlar',
			'emergency.medicationsHint' => 'İlaç adı - doz - saat (her satıra bir ilaç)',
			'emergency.allergies' => 'Alerjiler',
			'emergency.allergiesHint' => 'Gıda, ilaç, madde alerjileri',
			'emergency.conditions' => 'Diğer Tıbbi Durumlar',
			'emergency.conditionsHint' => 'Epilepsi, kalp hastalığı vb.',
			'emergency.triggers' => 'Tetikleyiciler (kaçınılması gerekenler)',
			'emergency.triggersHint' => 'Neler kriz çıkarır? Örn: ani gürültü, kalabalık',
			'emergency.calming' => 'Sakinleştirme Stratejileri',
			'emergency.calmingHint' => 'Ne işe yarar? Örn: sevdiği müzik, sessiz oda',
			'emergency.avoid' => 'Kesinlikle Yapılmaması Gerekenler',
			'emergency.avoidHint' => 'Örn: bağırmayın, tutmayın, göz temasına zorlamayın',
			'emergency.special' => 'Özel Talimatlar',
			'emergency.specialHint' => 'Acil servis veya bakıcı için ek notlar',
			'emergency.select' => 'Seçin...',
			'behavior.title' => 'Davranış Günlüğü',
			'behavior.subtitle' => 'ABC (Öncesi-Davranış-Sonuç) gözlem kayıtları',
			'behavior.add' => 'Kayıt Ekle',
			'behavior.addTitle' => 'Yeni ABC Kaydı',
			'behavior.empty' => 'Henüz davranış kaydı yok. İlk gözlemi ekleyin.',
			'behavior.noChild' => 'Davranış günlüğü için önce bir çocuk ekleyin.',
			'behavior.date' => 'Tarih',
			'behavior.time' => 'Saat',
			'behavior.category' => 'Kategori',
			'behavior.location' => 'Yer',
			'behavior.antecedentLabel' => 'A — Öncesi (Tetikleyici)',
			'behavior.antecedentHint' => 'Tetikleyiciyi açıklayın',
			'behavior.behaviorLabel' => 'B — Davranış (Ne oldu?)',
			'behavior.behaviorHint' => 'Davranışı ayrıntılı açıklayın',
			'behavior.consequenceLabel' => 'C — Sonuç (Ne yaptınız?)',
			'behavior.consequenceHint' => 'Uyguladığınız müdahaleyi açıklayın',
			'behavior.other' => 'Diğer...',
			'behavior.intensityLabel' => 'Şiddet Düzeyi',
			'behavior.intensity1' => 'Çok Hafif',
			'behavior.intensity2' => 'Hafif',
			'behavior.intensity3' => 'Orta',
			'behavior.intensity4' => 'Şiddetli',
			'behavior.intensity5' => 'Çok Şiddetli',
			'behavior.notesLabel' => 'Ek notlar (isteğe bağlı)',
			'behavior.save' => 'Kaydet',
			'behavior.saved' => 'ABC kaydı oluşturuldu.',
			'behavior.deleteTitle' => 'Kaydı Sil',
			'behavior.deleteConfirm' => ({required Object date}) => '${date} tarihli ABC kaydını silmek istediğinize emin misiniz?',
			'behavior.deleted' => 'Kayıt silindi.',
			'behavior.errorRequired' => 'Lütfen zorunlu alanları doldurun (kategori, yer, A, B, C).',
			'analytics.title' => 'Gelişim Paneli',
			'analytics.subtitle' => 'Son 6 ayın gelişim eğilimleri.',
			'analytics.milestones' => 'Kilometre Taşları',
			'analytics.milestonesUnit' => 'aylık kazanım sayısı',
			'analytics.mood' => 'Ruh Hali Ortalaması',
			'analytics.moodUnit' => '1-5 arası aylık ortalama',
			'analytics.sleep' => 'Ortalama Uyku',
			'analytics.sleepUnit' => 'gecelik saat (aylık ortalama)',
			'analytics.behavior' => 'Davranış Kayıtları',
			'analytics.behaviorUnit' => 'aylık kayıt sayısı',
			'analytics.noData' => 'Bu aralıkta henüz veri yok.',
			'analytics.noChild' => 'Gelişim paneli için önce bir çocuk ekleyin.',
			'children.title' => 'Çocuklarım',
			'children.addTitle' => 'Çocuk Ekle',
			'children.editTitle' => 'Çocuğu Düzenle',
			'children.empty' => 'Henüz çocuk eklemediniz.',
			'children.add' => 'Çocuk Ekle',
			'children.nameLabel' => 'Ad Soyad',
			'children.nameHint' => 'Çocuğun adı',
			'children.birthDateLabel' => 'Doğum Tarihi (isteğe bağlı)',
			'children.birthDateSelect' => 'Tarih seçin',
			'children.genderLabel' => 'Cinsiyet (isteğe bağlı)',
			'children.genderMale' => 'Erkek',
			'children.genderFemale' => 'Kız',
			'children.diagnosisLabel' => 'Tanı Bilgisi (isteğe bağlı)',
			'children.diagnosisHint' => 'Varsa tanı bilgisi',
			'children.educationLabel' => 'Eğitim Programı (isteğe bağlı)',
			'children.educationHint' => 'Devam ettiği eğitim programı',
			'children.therapiesLabel' => 'Terapiler (isteğe bağlı)',
			'children.therapiesHint' => 'Aldığı terapiler',
			'children.ageYears' => ({required Object years}) => '${years} yaş',
			'children.save' => 'Kaydet',
			'children.cancel' => 'İptal',
			'children.delete' => 'Sil',
			'children.deleteTitle' => 'Çocuğu Sil',
			'children.deleteConfirm' => ({required Object name}) => '${name} profilini silmek istediğinize emin misiniz?',
			'children.errorNameRequired' => 'Lütfen çocuğun adını girin.',
			'children.created' => 'Çocuk profili oluşturuldu.',
			'children.updated' => 'Çocuk profili güncellendi.',
			'children.deleted' => 'Çocuk profili silindi.',
			'account.title' => 'Hesap Bilgileri',
			'account.emailLabel' => 'E-posta',
			'account.fullNameLabel' => 'Ad Soyad',
			'account.phoneLabel' => 'Telefon',
			'account.phoneHint' => '05XX XXX XX XX',
			'account.cityLabel' => 'Şehir',
			'account.expertTitleLabel' => 'Uzmanlık Ünvanı',
			'account.institutionLabel' => 'Kurum',
			'account.licenseNumberLabel' => 'Lisans / Diploma No',
			'account.bioLabel' => 'Hakkında',
			'account.bioHint' => 'Deneyiminizi kısaca anlatın',
			'account.save' => 'Kaydet',
			'account.saved' => 'Profil güncellendi.',
			'account.errorFullName' => 'Ad soyad en az 2 karakter olmalıdır.',
			'help.title' => 'Yardım & Hakkında',
			'help.aboutTitle' => 'Otizm Destek Hakkında',
			'help.aboutBody' => 'Otizm Destek; çocuğunuzun gelişimini takip etmenize, uzmanlarla iletişim kurmanıza ve randevu almanıza yardımcı olan bir mobil uygulamadır.',
			'help.tipsTitle' => 'İpuçları',
			'help.tip1' => 'Çocuklarınızı "Çocuklarım"dan ekleyin; hedef ve gelişim notlarını "Gelişim" sekmesinden takip edin.',
			'help.tip2' => '"Uzmanlar"dan bir uzman seçip randevu alabilir veya mesaj gönderebilirsiniz.',
			'help.tip3' => 'AI Asistan\'a otizm ve çocuk gelişimi hakkında sorular sorabilirsiniz.',
			'help.contactTitle' => 'İletişim',
			'help.contactBody' => 'Soru ve önerileriniz için uygulama içinden bize ulaşabilirsiniz.',
			'help.version' => ({required Object version}) => 'Sürüm ${version}',
			'profile.defaultUser' => 'Kullanıcı',
			'profile.accountInfo' => 'Hesap Bilgileri',
			'profile.myChildren' => 'Çocuklarım',
			'profile.showAllSections' => 'Tüm bölümleri göster',
			'profile.help' => 'Yardım',
			'profile.signOut' => 'Çıkış Yap',
			'errors.timeout' => 'Sunucuya ulaşılamadı, lütfen tekrar deneyin.',
			'errors.noConnection' => 'İnternet bağlantısı yok gibi görünüyor.',
			'errors.generic' => ({required Object code}) => 'Bir hata oluştu (${code}).',
			'errors.cancelled' => 'İstek iptal edildi.',
			'errors.unexpected' => 'Beklenmeyen bir hata oluştu.',
			'errors.unexpectedResponse' => 'Beklenmeyen sunucu yanıtı.',
			'errors.operationFailed' => 'İşlem başarısız.',
			'errors.noUserInResponse' => 'Sunucu yanıtında kullanıcı bilgisi yok.',
			_ => null,
		};
	}
}
