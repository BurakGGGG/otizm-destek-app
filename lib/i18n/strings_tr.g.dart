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
	late final Translations$forgotPassword$tr forgotPassword = Translations$forgotPassword$tr.internal(_root);
	late final Translations$resetPassword$tr resetPassword = Translations$resetPassword$tr.internal(_root);
	late final Translations$register$tr register = Translations$register$tr.internal(_root);
	late final Translations$nav$tr nav = Translations$nav$tr.internal(_root);
	late final Translations$chat$tr chat = Translations$chat$tr.internal(_root);
	late final Translations$messages$tr messages = Translations$messages$tr.internal(_root);
	late final Translations$home$tr home = Translations$home$tr.internal(_root);
	late final Translations$specialists$tr specialists = Translations$specialists$tr.internal(_root);
	late final Translations$progress$tr progress = Translations$progress$tr.internal(_root);
	late final Translations$goalForm$tr goalForm = Translations$goalForm$tr.internal(_root);
	late final Translations$noteForm$tr noteForm = Translations$noteForm$tr.internal(_root);
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

	/// tr: 'Devam etmek için KVKK onayı gereklidir.'
	String get errorKvkkRequired => 'Devam etmek için KVKK onayı gereklidir.';
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

	/// tr: 'Sakin'
	String get moodCalm => 'Sakin';

	/// tr: 'Üzgün'
	String get moodSad => 'Üzgün';

	/// tr: 'Tarih'
	String get dateLabel => 'Tarih';

	/// tr: 'Kaydet'
	String get save => 'Kaydet';

	/// tr: 'Lütfen bir başlık girin.'
	String get errorTitle => 'Lütfen bir başlık girin.';

	/// tr: 'Not eklendi.'
	String get created => 'Not eklendi.';
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

	/// tr: 'Bildirim Ayarları'
	String get notificationSettings => 'Bildirim Ayarları';

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
			'register.errorKvkkRequired' => 'Devam etmek için KVKK onayı gereklidir.',
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
			'noteForm.nameLabel' => 'Başlık',
			'noteForm.nameHint' => 'Örn. Bugünkü gelişme',
			'noteForm.contentLabel' => 'İçerik (isteğe bağlı)',
			'noteForm.contentHint' => 'Gözlemlerinizi yazın',
			'noteForm.categoryLabel' => 'Kategori (isteğe bağlı)',
			'noteForm.moodLabel' => 'Ruh Hali (isteğe bağlı)',
			'noteForm.moodHappy' => 'Mutlu',
			'noteForm.moodCalm' => 'Sakin',
			'noteForm.moodSad' => 'Üzgün',
			'noteForm.dateLabel' => 'Tarih',
			'noteForm.save' => 'Kaydet',
			'noteForm.errorTitle' => 'Lütfen bir başlık girin.',
			'noteForm.created' => 'Not eklendi.',
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
			_ => null,
		} ?? switch (path) {
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
			'profile.notificationSettings' => 'Bildirim Ayarları',
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
