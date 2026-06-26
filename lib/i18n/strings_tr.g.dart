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
	late final Translations$roles$tr roles = Translations$roles$tr.internal(_root);
	late final Translations$auth$tr auth = Translations$auth$tr.internal(_root);
	late final Translations$register$tr register = Translations$register$tr.internal(_root);
	late final Translations$nav$tr nav = Translations$nav$tr.internal(_root);
	late final Translations$home$tr home = Translations$home$tr.internal(_root);
	late final Translations$specialists$tr specialists = Translations$specialists$tr.internal(_root);
	late final Translations$progress$tr progress = Translations$progress$tr.internal(_root);
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

// Path: home
class Translations$home$tr {
	Translations$home$tr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// tr: 'Bildirimler'
	String get notifications => 'Bildirimler';

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
			'home.notifications' => 'Bildirimler',
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
