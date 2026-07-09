///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$en app = _Translations$app$en._(_root);
	@override late final _Translations$common$en common = _Translations$common$en._(_root);
	@override late final _Translations$language$en language = _Translations$language$en._(_root);
	@override late final _Translations$theme$en theme = _Translations$theme$en._(_root);
	@override late final _Translations$roles$en roles = _Translations$roles$en._(_root);
	@override late final _Translations$auth$en auth = _Translations$auth$en._(_root);
	@override late final _Translations$forgotPassword$en forgotPassword = _Translations$forgotPassword$en._(_root);
	@override late final _Translations$resetPassword$en resetPassword = _Translations$resetPassword$en._(_root);
	@override late final _Translations$register$en register = _Translations$register$en._(_root);
	@override late final _Translations$nav$en nav = _Translations$nav$en._(_root);
	@override late final _Translations$chat$en chat = _Translations$chat$en._(_root);
	@override late final _Translations$messages$en messages = _Translations$messages$en._(_root);
	@override late final _Translations$home$en home = _Translations$home$en._(_root);
	@override late final _Translations$specialists$en specialists = _Translations$specialists$en._(_root);
	@override late final _Translations$progress$en progress = _Translations$progress$en._(_root);
	@override late final _Translations$goalForm$en goalForm = _Translations$goalForm$en._(_root);
	@override late final _Translations$noteForm$en noteForm = _Translations$noteForm$en._(_root);
	@override late final _Translations$notifications$en notifications = _Translations$notifications$en._(_root);
	@override late final _Translations$knowledge$en knowledge = _Translations$knowledge$en._(_root);
	@override late final _Translations$appointments$en appointments = _Translations$appointments$en._(_root);
	@override late final _Translations$expertDetail$en expertDetail = _Translations$expertDetail$en._(_root);
	@override late final _Translations$booking$en booking = _Translations$booking$en._(_root);
	@override late final _Translations$routines$en routines = _Translations$routines$en._(_root);
	@override late final _Translations$routineForm$en routineForm = _Translations$routineForm$en._(_root);
	@override late final _Translations$dailyTracker$en dailyTracker = _Translations$dailyTracker$en._(_root);
	@override late final _Translations$sleep$en sleep = _Translations$sleep$en._(_root);
	@override late final _Translations$meds$en meds = _Translations$meds$en._(_root);
	@override late final _Translations$wall$en wall = _Translations$wall$en._(_root);
	@override late final _Translations$crisis$en crisis = _Translations$crisis$en._(_root);
	@override late final _Translations$calendar$en calendar = _Translations$calendar$en._(_root);
	@override late final _Translations$emergency$en emergency = _Translations$emergency$en._(_root);
	@override late final _Translations$behavior$en behavior = _Translations$behavior$en._(_root);
	@override late final _Translations$analytics$en analytics = _Translations$analytics$en._(_root);
	@override late final _Translations$children$en children = _Translations$children$en._(_root);
	@override late final _Translations$account$en account = _Translations$account$en._(_root);
	@override late final _Translations$help$en help = _Translations$help$en._(_root);
	@override late final _Translations$profile$en profile = _Translations$profile$en._(_root);
	@override late final _Translations$errors$en errors = _Translations$errors$en._(_root);
}

// Path: app
class _Translations$app$en extends Translations$app$tr {
	_Translations$app$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get name => 'Autism Support';
}

// Path: common
class _Translations$common$en extends Translations$common$tr {
	_Translations$common$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading';
	@override String get comingSoon => 'This section is coming soon.';
	@override String get seeAll => 'See All';
	@override String get more => 'More';
	@override String get retry => 'Retry';
	@override String get loadError => 'Could not load data.';
	@override List<String> get monthsShort => [
		'Jan',
		'Feb',
		'Mar',
		'Apr',
		'May',
		'Jun',
		'Jul',
		'Aug',
		'Sep',
		'Oct',
		'Nov',
		'Dec',
	];
}

// Path: language
class _Translations$language$en extends Translations$language$tr {
	_Translations$language$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Language';
	@override String get turkish => 'Türkçe';
	@override String get english => 'English';
}

// Path: theme
class _Translations$theme$en extends Translations$theme$tr {
	_Translations$theme$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Theme';
	@override String get system => 'System';
	@override String get light => 'Light';
	@override String get dark => 'Dark';
}

// Path: roles
class _Translations$roles$en extends Translations$roles$tr {
	_Translations$roles$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get parent => 'Parent';
	@override String get expert => 'Specialist';
	@override String get admin => 'Admin';
}

// Path: auth
class _Translations$auth$en extends Translations$auth$tr {
	_Translations$auth$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Sign in to your account or create a new one.';
	@override String get emailLabel => 'Email Address';
	@override String get emailHint => 'example@email.com';
	@override String get passwordLabel => 'Password';
	@override String get passwordHint => '••••••••';
	@override String get rememberMe => 'Remember me';
	@override String get forgotPassword => 'Forgot password';
	@override String get loginButton => 'Sign In';
	@override String get noAccount => 'Don\'t have an account?';
	@override String get registerParent => 'Sign up as a parent';
	@override String get registerExpert => 'Sign up as a specialist';
	@override String get errorEmptyFields => 'Please enter your email and password.';
	@override String registerComingSoon({required Object role}) => '${role} sign-up screen is coming soon.';
}

// Path: forgotPassword
class _Translations$forgotPassword$en extends Translations$forgotPassword$tr {
	_Translations$forgotPassword$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Forgot Password';
	@override String get subtitle => 'Enter your email and we\'ll send you a password reset link.';
	@override String get submit => 'Send Reset Link';
	@override String get sentTitle => 'Link sent';
	@override String get sentBody => 'If an account exists for this email, a password reset link will arrive in your inbox.';
	@override String get haveCode => 'I have a reset code';
	@override String get backToLogin => 'Back to login';
	@override String get errorEmailRequired => 'Please enter your email.';
	@override String get errorEmailInvalid => 'Please enter a valid email.';
}

// Path: resetPassword
class _Translations$resetPassword$en extends Translations$resetPassword$tr {
	_Translations$resetPassword$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reset Password';
	@override String get subtitle => 'Enter the reset code from your email and your new password.';
	@override String get tokenLabel => 'Reset Code';
	@override String get tokenHint => 'The code from the email link';
	@override String get newPasswordLabel => 'New Password';
	@override String get confirmLabel => 'Confirm New Password';
	@override String get submit => 'Update Password';
	@override String get success => 'Your password has been updated. You can sign in now.';
	@override String get errorTokenRequired => 'Please enter the reset code.';
	@override String get errorPasswordShort => 'Password must be at least 8 characters.';
	@override String get errorMismatch => 'Passwords do not match.';
}

// Path: register
class _Translations$register$en extends Translations$register$tr {
	_Translations$register$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get titleParent => 'Create Parent Account';
	@override String get titleExpert => 'Create Specialist Account';
	@override String get roleQuestion => 'How would you like to sign up?';
	@override String get fullNameLabel => 'Full Name';
	@override String get fullNameHint => 'Your first and last name';
	@override String get phoneLabel => 'Phone (optional)';
	@override String get phoneHint => '05XX XXX XX XX';
	@override String get cityLabel => 'City (optional)';
	@override String get cityHint => 'Your city';
	@override String get expertTitleLabel => 'Professional Title';
	@override String get expertTitleHint => 'e.g. Child Psychologist';
	@override String get institutionLabel => 'Institution (optional)';
	@override String get institutionHint => 'Where you work';
	@override String get licenseNumberLabel => 'License / Diploma No';
	@override String get licenseNumberHint => 'Your professional license number';
	@override String get bioLabel => 'About (optional)';
	@override String get bioHint => 'Briefly describe your experience';
	@override String get specializationsLabel => 'Areas of Expertise (optional)';
	@override String get specializationsHint => 'Separate with commas (Autism, ADHD)';
	@override String get kvkkConsent => 'I have read and accept the data protection (KVKK) notice.';
	@override String get submit => 'Sign Up';
	@override String get haveAccount => 'Already have an account? Sign in';
	@override String get errorFullNameRequired => 'Please enter your full name.';
	@override String get errorEmailRequired => 'Please enter your email.';
	@override String get errorEmailInvalid => 'Please enter a valid email.';
	@override String get errorPasswordShort => 'Password must be at least 8 characters.';
	@override String get errorExpertTitleRequired => 'Please enter your professional title.';
	@override String get errorKvkkRequired => 'KVKK consent is required to continue.';
}

// Path: nav
class _Translations$nav$en extends Translations$nav$tr {
	_Translations$nav$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get specialists => 'Specialists';
	@override String get progress => 'Progress';
	@override String get profile => 'Profile';
}

// Path: chat
class _Translations$chat$en extends Translations$chat$tr {
	_Translations$chat$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'AI Assistant';
	@override String get greeting => 'Hi! I\'ll try to answer your questions about autism and child development.';
	@override String get inputHint => 'Ask a question...';
	@override String get errorGeneric => 'Couldn\'t get a response, please try again.';
}

// Path: messages
class _Translations$messages$en extends Translations$messages$tr {
	_Translations$messages$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Messages';
	@override String get noConversations => 'You have no conversations yet.';
	@override String get noMessages => 'No messages yet. Send the first one.';
	@override String get inputHint => 'Type a message...';
	@override String get connecting => 'Connecting...';
}

// Path: home
class _Translations$home$en extends Translations$home$tr {
	_Translations$home$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get notifications => 'Notifications';
	@override String get assistant => 'AI Assistant';
	@override String get messages => 'Messages';
	@override String greeting({required Object name}) => 'Hello, ${name}';
	@override String get greetingFallback => 'Parent';
	@override String get subtitle => 'What can we do for development today?';
	@override String get childProgressTitle => 'Child Development';
	@override String get weeklySummary => 'Weekly Progress Summary';
	@override String increaseBadge({required Object value}) => '${value}% Increase';
	@override String remainingToGoal({required Object value}) => 'Remaining to goal: ${value}%';
	@override String get statusCognitiveGood => 'Cognitive: Good';
	@override String get statusCommunicationImproving => 'Communication: Improving';
	@override String get upcomingAppointments => 'Upcoming Appointments';
	@override String get recommendedArticles => 'Recommended Articles';
	@override String get childrenTitle => 'My Children';
	@override String get noChildren => 'You haven\'t added a child yet.';
	@override String get addChild => 'Add Child';
	@override String ageYears({required Object years}) => '${years} yrs';
	@override String get noAppointments => 'You have no upcoming appointments.';
	@override String get noArticles => 'No articles to show.';
}

// Path: specialists
class _Translations$specialists$en extends Translations$specialists$tr {
	_Translations$specialists$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Find a Specialist';
	@override String get searchHint => 'Search by name or expertise...';
	@override String get filterAll => 'All';
	@override String get filterPsychologist => 'Psychologist';
	@override String get filterSpecialEducation => 'Special Education';
	@override String get filterSpeech => 'Speech & Language';
	@override String get noResults => 'No specialists match your search.';
	@override String get ratingNew => 'New';
	@override String reviews({required Object count}) => '${count} reviews';
}

// Path: progress
class _Translations$progress$en extends Translations$progress$tr {
	_Translations$progress$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Progress Tracking';
	@override String get subtitle => 'Goals and development notes.';
	@override String get addRecord => 'Add New Record';
	@override String get goalsTitle => 'Goals';
	@override String get recentNotes => 'Recent Development Notes';
	@override String get noGoals => 'No goals added yet.';
	@override String get noNotes => 'No development notes yet.';
	@override String get noChild => 'Add a child first to track development.';
	@override String goalProgress({required Object done, required Object total}) => '${done} / ${total}';
	@override String get addGoal => 'Add Goal';
	@override String get addNote => 'Add Note';
	@override String get addToken => 'Add Token';
	@override String get tokenAdded => 'Token added 🎉';
	@override String get tokenRemoved => 'Token removed.';
	@override String get goalCompleted => 'Goal completed! 🎉';
	@override String rewardLine({required Object title}) => 'Reward: ${title}';
}

// Path: goalForm
class _Translations$goalForm$en extends Translations$goalForm$tr {
	_Translations$goalForm$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Add Goal';
	@override String get nameLabel => 'Title';
	@override String get nameHint => 'e.g. Making eye contact';
	@override String get categoryLabel => 'Category';
	@override String get targetLabel => 'Target Count';
	@override String get descriptionLabel => 'Description (optional)';
	@override String get descriptionHint => 'Details about the goal';
	@override String get save => 'Save';
	@override String get errorTitle => 'Please enter a title.';
	@override String get created => 'Goal added.';
}

// Path: noteForm
class _Translations$noteForm$en extends Translations$noteForm$tr {
	_Translations$noteForm$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Add Note';
	@override String get nameLabel => 'Title';
	@override String get nameHint => 'e.g. Today\'s progress';
	@override String get contentLabel => 'Content (optional)';
	@override String get contentHint => 'Write your observations';
	@override String get categoryLabel => 'Category (optional)';
	@override String get moodLabel => 'Mood (optional)';
	@override String get moodHappy => 'Happy';
	@override String get moodCalm => 'Calm';
	@override String get moodSad => 'Sad';
	@override String get dateLabel => 'Date';
	@override String get save => 'Save';
	@override String get errorTitle => 'Please enter a title.';
	@override String get created => 'Note added.';
}

// Path: notifications
class _Translations$notifications$en extends Translations$notifications$tr {
	_Translations$notifications$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get show => 'Show';
	@override String get title => 'Notifications';
	@override String get empty => 'You have no notifications yet.';
	@override String get markAllRead => 'Mark all as read';
	@override String dateLine({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}';
}

// Path: knowledge
class _Translations$knowledge$en extends Translations$knowledge$tr {
	_Translations$knowledge$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Knowledge Base';
	@override String get empty => 'No articles yet.';
	@override String get noResults => 'No content matches this filter.';
	@override String get filterAll => 'All';
	@override String get formatArticle => 'Article';
	@override String get formatVideo => 'Video';
	@override String get formatPodcast => 'Podcast';
	@override String views({required Object count}) => '${count} views';
	@override String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
	@override String get videoLink => 'Video link';
	@override String get podcastLink => 'Podcast link';
}

// Path: appointments
class _Translations$appointments$en extends Translations$appointments$tr {
	_Translations$appointments$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Appointments';
	@override String get empty => 'You don\'t have any appointments yet.';
	@override String get upcoming => 'Upcoming';
	@override String get past => 'Past';
	@override String get statusPending => 'Pending';
	@override String get statusConfirmed => 'Confirmed';
	@override String get statusCompleted => 'Completed';
	@override String get statusCancelled => 'Cancelled';
	@override String get typeOnline => 'Online session';
	@override String get typeFaceToFace => 'In person';
	@override String withChild({required Object name}) => 'Child: ${name}';
	@override String dateLine({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}';
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Confirm';
	@override String get complete => 'Complete';
	@override String get joinMeeting => 'Join meeting';
	@override String get cancelTitle => 'Cancel appointment';
	@override String get cancelConfirm => 'Are you sure you want to cancel this appointment?';
	@override String get cancelReasonLabel => 'Cancellation reason (optional)';
	@override String cancelReasonShown({required Object reason}) => 'Cancellation reason: ${reason}';
	@override String get keepIt => 'Keep';
	@override String get cancelled => 'Appointment cancelled.';
	@override String get confirmed => 'Appointment confirmed.';
	@override String get completed => 'Appointment marked as completed.';
	@override String get reschedule => 'Reschedule';
	@override String get rescheduleTitle => 'Reschedule Appointment';
	@override String get rescheduleConfirm => 'Confirm New Time';
	@override String get rescheduled => 'Appointment rescheduled.';
}

// Path: expertDetail
class _Translations$expertDetail$en extends Translations$expertDetail$tr {
	_Translations$expertDetail$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get bookAppointment => 'Book Appointment';
	@override String get sendMessage => 'Send Message';
	@override String get specializationsTitle => 'Specializations';
	@override String articleCount({required Object count}) => '${count} articles';
	@override String get notAcceptingPatients => 'This expert is not accepting appointments right now.';
}

// Path: booking
class _Translations$booking$en extends Translations$booking$tr {
	_Translations$booking$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Book Appointment';
	@override String get childLabel => 'Child';
	@override String get noChild => 'Add a child first to book an appointment.';
	@override String get typeLabel => 'Appointment Type';
	@override String get dateLabel => 'Date';
	@override String get selectDate => 'Select date';
	@override String dateValue({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
	@override String get timeLabel => 'Time';
	@override String get selectDateFirst => 'Select a date to see available times.';
	@override String get noSlots => 'No available times for this day.';
	@override String get notesLabel => 'Note (optional)';
	@override String get notesHint => 'A note for the expert';
	@override String get confirm => 'Confirm Appointment';
	@override String get created => 'Appointment created.';
	@override String get errorSelectChild => 'Please select a child.';
	@override String get errorSelectTime => 'Please select a time.';
}

// Path: routines
class _Translations$routines$en extends Translations$routines$tr {
	_Translations$routines$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routines';
	@override String get empty => 'No routines for this child yet.';
	@override String get noChild => 'Add a child first to create routines.';
	@override String get add => 'Add Routine';
	@override String get addItem => 'Add Step';
	@override String get noItems => 'No steps added yet.';
	@override String get deleteRoutineTitle => 'Delete Routine';
	@override String deleteRoutineConfirm({required Object name}) => 'Are you sure you want to delete the routine "${name}"?';
	@override String get delete => 'Delete';
	@override String get cancel => 'Cancel';
	@override String get created => 'Routine added.';
	@override String get itemAdded => 'Step added.';
	@override String get deleted => 'Routine deleted.';
	@override String get itemTitleLabel => 'Step Title';
	@override String get itemTitleHint => 'e.g. Brush teeth';
	@override String get itemTimeLabel => 'Time (optional)';
	@override String get selectTime => 'Select time';
	@override String get itemIconLabel => 'Icon';
	@override String get itemSave => 'Add';
	@override String get errorItemTitle => 'Please enter a step title.';
}

// Path: routineForm
class _Translations$routineForm$en extends Translations$routineForm$tr {
	_Translations$routineForm$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Add Routine';
	@override String get nameLabel => 'Routine Name';
	@override String get nameHint => 'e.g. Morning Routine';
	@override String get descriptionLabel => 'Description (optional)';
	@override String get descriptionHint => 'What is this routine for?';
	@override String get save => 'Save';
	@override String get errorName => 'Please enter a routine name.';
}

// Path: dailyTracker
class _Translations$dailyTracker$en extends Translations$dailyTracker$tr {
	_Translations$dailyTracker$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Daily Tracker';
	@override String get tabMood => 'Mood';
	@override String get tabSleep => 'Sleep';
	@override String get tabMeds => 'Medication';
	@override String get todayTitle => 'How was today?';
	@override String get today => 'Today';
	@override String get mood1 => 'Very Bad';
	@override String get mood2 => 'Bad';
	@override String get mood3 => 'Okay';
	@override String get mood4 => 'Good';
	@override String get mood5 => 'Great';
	@override String get triggersLabel => 'Possible triggers (optional)';
	@override String get notesLabel => 'Note (optional)';
	@override String get notesHint => 'Your observations about today';
	@override String get save => 'Save';
	@override String get update => 'Update';
	@override String get saved => 'Mood saved.';
	@override String get historyTitle => 'Past Entries';
	@override String get empty => 'No entries yet. Add the first one today.';
	@override String get noChild => 'Add a child first to use the daily tracker.';
	@override String get deleteTitle => 'Delete Entry';
	@override String deleteConfirm({required Object date}) => 'Are you sure you want to delete the entry dated ${date}?';
	@override String get delete => 'Delete';
	@override String get cancel => 'Cancel';
	@override String get deleted => 'Entry deleted.';
	@override String get errorSelectMood => 'Please select a mood.';
	@override String dateLine({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}';
}

// Path: sleep
class _Translations$sleep$en extends Translations$sleep$tr {
	_Translations$sleep$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get todayTitle => 'Last Night / This Morning';
	@override String get bedtime => 'Bedtime';
	@override String get wakeTime => 'Wake Time';
	@override String get quality => 'Sleep Quality';
	@override String get nightWakings => 'Night wakings';
	@override String get factorsLabel => 'Sensory and environmental factors';
	@override String get factorWeighted => '🛏️ Weighted Blanket';
	@override String get factorSensory => '👕 Sensory Sensitivity';
	@override String get factorMelatonin => '💊 Melatonin Support';
	@override String get factorNoise => '🔊 Noise / Light';
	@override String get saved => 'Sleep saved.';
	@override String get empty => 'No sleep entries yet. Add the first one today.';
	@override String deleteConfirm({required Object date}) => 'Are you sure you want to delete the sleep entry dated ${date}?';
	@override String get deleted => 'Sleep entry deleted.';
	@override String duration({required Object h, required Object m}) => '${h} h ${m} min';
	@override String wakings({required Object count}) => 'woke ${count} times';
}

// Path: meds
class _Translations$meds$en extends Translations$meds$tr {
	_Translations$meds$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get safetyTitle => 'Medication safety';
	@override String get safetyBody => 'Medication reminders are for support only. Decisions about starting, stopping, changing doses or side effects should be made only with your doctor.';
	@override String get add => 'Add Medication';
	@override String get addTitle => 'Add New Medication';
	@override String get editTitle => 'Edit Medication';
	@override String get empty => 'No medications yet. Add your child\'s medications and supplements here.';
	@override String get name => 'Medication / Supplement Name';
	@override String get nameHint => 'E.g. Omega-3';
	@override String get dosage => 'Dose';
	@override String get unit => 'Unit';
	@override String get frequency => 'Frequency';
	@override String get freqDaily => 'Once a day';
	@override String get freqTwiceDaily => 'Twice a day';
	@override String get freqThreeDaily => '3 times a day';
	@override String get freqAsNeeded => 'As needed';
	@override String get freqWeekly => 'Weekly';
	@override String get timesLabel => 'Dose times';
	@override String get addTime => 'Add Time';
	@override String get noTime => 'No time';
	@override String get added => 'Medication added.';
	@override String get updated => 'Medication updated.';
	@override String get deleteTitle => 'Delete Medication';
	@override String deleteConfirm({required Object name}) => '${name} and its dose logs will be permanently deleted. Are you sure?';
	@override String get deleted => 'Medication deleted.';
	@override String get errorName => 'Please enter the medication name.';
	@override String get logTitle => 'Dose Log';
	@override String get taken => 'Medication taken';
	@override String get sideEffectsLabel => 'Observed side effects';
	@override String get logNotesLabel => 'Observation notes (optional)';
	@override String get logNotesHint => 'Anything you want to share with your doctor?';
	@override String get logSaved => 'Dose log saved.';
}

// Path: wall
class _Translations$wall$en extends Translations$wall$tr {
	_Translations$wall$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Support Wall';
	@override String get subtitle => 'Share your feelings and support each other. Posts can be anonymous.';
	@override String get empty => 'No posts yet. Be the first to share.';
	@override String get add => 'Share';
	@override String get addTitle => 'Support Post';
	@override String get editTitle => 'Edit Post';
	@override String get titleLabel => 'Title (optional)';
	@override String get titleHint => 'A short title';
	@override String get contentLabel => 'How are you feeling?';
	@override String get contentHint => 'You can let it out; you\'re not alone here.';
	@override String get anonymous => 'Post anonymously';
	@override String get anonymousUser => 'Anonymous User';
	@override String get post => 'Share';
	@override String get posted => 'Your post was added to the wall.';
	@override String get updated => 'Post updated.';
	@override String get deleteTitle => 'Delete Post';
	@override String get deleteConfirm => 'Are you sure you want to delete this post?';
	@override String get deleted => 'Post deleted.';
	@override String get errorContent => 'Please write something.';
	@override String supportCount({required Object count}) => '${count} support';
	@override String commentCount({required Object count}) => '${count} comments';
	@override String get detailTitle => 'Post';
	@override String get commentsTitle => 'Support Messages';
	@override String get commentHint => 'Write a message of support…';
	@override String get commentSend => 'Send';
	@override String get commentSent => 'Support message sent.';
	@override String get commentEmpty => 'No support messages yet. Be the first.';
	@override String get commentDeleteTitle => 'Delete Comment';
	@override String get commentDeleteConfirm => 'Are you sure you want to delete this support message?';
	@override String get commentDeleted => 'Comment deleted.';
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get cancel => 'Cancel';
	@override String get save => 'Save';
	@override String get justNow => 'just now';
	@override String minsAgo({required Object count}) => '${count} min ago';
	@override String hoursAgo({required Object count}) => '${count} h ago';
	@override String daysAgo({required Object count}) => '${count} d ago';
}

// Path: crisis
class _Translations$crisis$en extends Translations$crisis$tr {
	_Translations$crisis$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crisis Guide';
	@override String get heroTitle => 'What To Do in Hard Moments?';
	@override String get heroSubtitle => 'A quick guide to help you stay calm and take the right steps when your child is overwhelmed.';
	@override String get breathingTitle => 'Breathing Regulator';
	@override String get breathingSubtitle => 'Calm yourself first. Start and match your breathing to the ring\'s expand-and-shrink pace.';
	@override String get breathingStart => 'Start Exercise';
	@override String get breathingStop => 'Stop';
	@override String get breathingReady => 'Ready';
	@override String get breathingReadyHint => 'Tap to start';
	@override String get breathingInhale => 'Breathe In';
	@override String get breathingExhale => 'Breathe Out';
	@override String get breathingSeconds => 'seconds';
	@override String get stepsLabel => 'What To Do?';
	@override String get avoidLabel => 'What To Avoid';
	@override String get emergencyLabel => 'Suggested Emergency Line';
	@override String get contactsTitle => 'Emergency Numbers';
	@override String get disclaimer => 'This guide is for general information; in emergencies or medical situations always call your local emergency number.';
	@override String get contact112Label => 'Emergency Health and Safety';
	@override String get contact112Desc => 'Ambulance, Police, Fire';
	@override String get contact183Label => 'Social Support Line';
	@override String get contact183Desc => 'Family, Children and Social Services';
	@override late final _Translations$crisis$cards$en cards = _Translations$crisis$cards$en._(_root);
}

// Path: calendar
class _Translations$calendar$en extends Translations$calendar$tr {
	_Translations$calendar$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Calendar';
	@override String get subtitle => 'Child-specific therapy, doctor and activity schedule.';
	@override String get noChild => 'Add a child first to use the calendar.';
	@override String get empty => 'No events yet. Add the first one.';
	@override String get add => 'Add Event';
	@override String get addTitle => 'New Event';
	@override String get editTitle => 'Edit Event';
	@override String get eventType => 'Event Type';
	@override String get typeTerapi => 'Therapy';
	@override String get typeDoktor => 'Doctor';
	@override String get typeEgitim => 'Education';
	@override String get typeAktivite => 'Activity';
	@override String get typeAppointment => 'Appointment';
	@override String get typeDiger => 'Other';
	@override String get eventTitle => 'Title';
	@override String get titleHint => 'Event name';
	@override String get location => 'Location';
	@override String get locationHint => 'Clinic name, address';
	@override String get description => 'Description';
	@override String get start => 'Start';
	@override String get end => 'End (optional)';
	@override String get reminder => 'Reminder';
	@override String get reminderOff => 'Off';
	@override String reminderMin({required Object count}) => '${count} min before';
	@override String reminderHour({required Object count}) => '${count} h before';
	@override String get reminderDay => '1 day before';
	@override String get statusPlanned => 'Planned';
	@override String get statusCompleted => 'Completed';
	@override String get statusCancelled => 'Cancelled';
	@override String get markCompleted => 'Mark completed';
	@override String get markPlanned => 'Mark planned';
	@override String get markCancelled => 'Cancel event';
	@override String get today => 'Today';
	@override String get tomorrow => 'Tomorrow';
	@override String get save => 'Save';
	@override String get saved => 'Event saved.';
	@override String get deleteTitle => 'Delete Event';
	@override String deleteConfirm({required Object title}) => 'Are you sure you want to delete "${title}"?';
	@override String get deleted => 'Event deleted.';
	@override String get errorTitle => 'Please enter a title.';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
}

// Path: emergency
class _Translations$emergency$en extends Translations$emergency$tr {
	_Translations$emergency$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Emergency Card';
	@override String get subtitle => 'Information to show to anyone who meets your child in an emergency.';
	@override String get noChild => 'Add a child first to create an emergency card.';
	@override String lastUpdated({required Object date}) => 'Last updated ${date}';
	@override String get notSaved => 'This card has not been saved yet.';
	@override String get save => 'Save';
	@override String get saved => 'Emergency card saved.';
	@override String get call => 'Call';
	@override String get sectionChild => 'Child Information';
	@override String get sectionContacts => 'Emergency Contacts';
	@override String get sectionMedical => 'Medical Information';
	@override String get sectionBehavior => 'Behavioral Information';
	@override String get childName => 'Full Name';
	@override String get birthDate => 'Date of Birth';
	@override String get diagnosis => 'Diagnosis';
	@override String get bloodType => 'Blood Type';
	@override String get communicationLevel => 'Communication Level';
	@override String get languages => 'Language(s) Spoken';
	@override String get warningsLabel => 'Special condition warnings';
	@override String get selfInjury => 'May exhibit self-injury';
	@override String get wandering => 'Risk of wandering / getting lost';
	@override String get nonVerbal => 'Non-verbal';
	@override String get contact1 => 'First Contact';
	@override String get contact2 => 'Second Contact';
	@override String get doctor => 'Doctor / Hospital';
	@override String get name => 'Full Name';
	@override String get phone => 'Phone';
	@override String get relation => 'Relationship';
	@override String get doctorName => 'Doctor Name';
	@override String get doctorPhone => 'Doctor Phone';
	@override String get hospital => 'Hospital';
	@override String get medications => 'Current Medications';
	@override String get medicationsHint => 'Name - dose - time (one medication per line)';
	@override String get allergies => 'Allergies';
	@override String get allergiesHint => 'Food, drug, substance allergies';
	@override String get conditions => 'Other Medical Conditions';
	@override String get conditionsHint => 'Epilepsy, heart condition, etc.';
	@override String get triggers => 'Triggers (to avoid)';
	@override String get triggersHint => 'What causes a crisis? E.g. sudden noise, crowds';
	@override String get calming => 'Calming Strategies';
	@override String get calmingHint => 'What helps? E.g. favorite music, quiet room';
	@override String get avoid => 'Things to Never Do';
	@override String get avoidHint => 'E.g. don\'t shout, don\'t restrain, don\'t force eye contact';
	@override String get special => 'Special Instructions';
	@override String get specialHint => 'Extra notes for emergency services or caregivers';
	@override String get select => 'Select...';
}

// Path: behavior
class _Translations$behavior$en extends Translations$behavior$tr {
	_Translations$behavior$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Behavior Journal';
	@override String get subtitle => 'ABC (Antecedent-Behavior-Consequence) observation log';
	@override String get add => 'Add Entry';
	@override String get addTitle => 'New ABC Entry';
	@override String get empty => 'No behavior entries yet. Add the first observation.';
	@override String get noChild => 'Add a child first to use the behavior journal.';
	@override String get date => 'Date';
	@override String get time => 'Time';
	@override String get category => 'Category';
	@override String get location => 'Location';
	@override String get antecedentLabel => 'A — Antecedent (Trigger)';
	@override String get antecedentHint => 'Describe the trigger';
	@override String get behaviorLabel => 'B — Behavior (What happened?)';
	@override String get behaviorHint => 'Describe the behavior in detail';
	@override String get consequenceLabel => 'C — Consequence (What did you do?)';
	@override String get consequenceHint => 'Describe your intervention';
	@override String get other => 'Other...';
	@override String get intensityLabel => 'Intensity';
	@override String get intensity1 => 'Very Mild';
	@override String get intensity2 => 'Mild';
	@override String get intensity3 => 'Moderate';
	@override String get intensity4 => 'Severe';
	@override String get intensity5 => 'Very Severe';
	@override String get notesLabel => 'Additional notes (optional)';
	@override String get save => 'Save';
	@override String get saved => 'ABC entry created.';
	@override String get deleteTitle => 'Delete Entry';
	@override String deleteConfirm({required Object date}) => 'Are you sure you want to delete the ABC entry dated ${date}?';
	@override String get deleted => 'Entry deleted.';
	@override String get errorRequired => 'Please fill the required fields (category, location, A, B, C).';
}

// Path: analytics
class _Translations$analytics$en extends Translations$analytics$tr {
	_Translations$analytics$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Development Panel';
	@override String get subtitle => 'Development trends over the last 6 months.';
	@override String get milestones => 'Milestones';
	@override String get milestonesUnit => 'achievements per month';
	@override String get mood => 'Average Mood';
	@override String get moodUnit => 'monthly average (1-5)';
	@override String get sleep => 'Average Sleep';
	@override String get sleepUnit => 'hours per night (monthly average)';
	@override String get behavior => 'Behavior Logs';
	@override String get behaviorUnit => 'entries per month';
	@override String get noData => 'No data in this range yet.';
	@override String get noChild => 'Add a child first to see the development panel.';
}

// Path: children
class _Translations$children$en extends Translations$children$tr {
	_Translations$children$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'My Children';
	@override String get addTitle => 'Add Child';
	@override String get editTitle => 'Edit Child';
	@override String get empty => 'You haven\'t added any children yet.';
	@override String get add => 'Add Child';
	@override String get nameLabel => 'Full Name';
	@override String get nameHint => 'Child\'s name';
	@override String get birthDateLabel => 'Birth Date (optional)';
	@override String get birthDateSelect => 'Select date';
	@override String get genderLabel => 'Gender (optional)';
	@override String get genderMale => 'Boy';
	@override String get genderFemale => 'Girl';
	@override String get diagnosisLabel => 'Diagnosis Info (optional)';
	@override String get diagnosisHint => 'Diagnosis info, if any';
	@override String get educationLabel => 'Education Program (optional)';
	@override String get educationHint => 'Current education program';
	@override String get therapiesLabel => 'Therapies (optional)';
	@override String get therapiesHint => 'Therapies received';
	@override String ageYears({required Object years}) => '${years} yrs';
	@override String get save => 'Save';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
	@override String get deleteTitle => 'Delete Child';
	@override String deleteConfirm({required Object name}) => 'Are you sure you want to delete ${name}\'s profile?';
	@override String get errorNameRequired => 'Please enter the child\'s name.';
	@override String get created => 'Child profile created.';
	@override String get updated => 'Child profile updated.';
	@override String get deleted => 'Child profile deleted.';
}

// Path: account
class _Translations$account$en extends Translations$account$tr {
	_Translations$account$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Account Information';
	@override String get emailLabel => 'Email';
	@override String get fullNameLabel => 'Full Name';
	@override String get phoneLabel => 'Phone';
	@override String get phoneHint => '05XX XXX XX XX';
	@override String get cityLabel => 'City';
	@override String get expertTitleLabel => 'Expert Title';
	@override String get institutionLabel => 'Institution';
	@override String get licenseNumberLabel => 'License Number';
	@override String get bioLabel => 'About';
	@override String get bioHint => 'Briefly describe your experience';
	@override String get save => 'Save';
	@override String get saved => 'Profile updated.';
	@override String get errorFullName => 'Full name must be at least 2 characters.';
}

// Path: help
class _Translations$help$en extends Translations$help$tr {
	_Translations$help$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Help & About';
	@override String get aboutTitle => 'About Otizm Destek';
	@override String get aboutBody => 'Otizm Destek is a mobile app that helps you track your child\'s development, connect with experts, and book appointments.';
	@override String get tipsTitle => 'Tips';
	@override String get tip1 => 'Add your children under "My Children"; track goals and notes in the "Progress" tab.';
	@override String get tip2 => 'Pick an expert under "Experts" to book an appointment or send a message.';
	@override String get tip3 => 'Ask the AI Assistant questions about autism and child development.';
	@override String get contactTitle => 'Contact';
	@override String get contactBody => 'Reach us from within the app for any questions or suggestions.';
	@override String version({required Object version}) => 'Version ${version}';
}

// Path: profile
class _Translations$profile$en extends Translations$profile$tr {
	_Translations$profile$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get defaultUser => 'User';
	@override String get accountInfo => 'Account Information';
	@override String get myChildren => 'My Children';
	@override String get notificationSettings => 'Notification Settings';
	@override String get help => 'Help';
	@override String get signOut => 'Sign Out';
}

// Path: errors
class _Translations$errors$en extends Translations$errors$tr {
	_Translations$errors$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get timeout => 'Could not reach the server, please try again.';
	@override String get noConnection => 'You appear to be offline.';
	@override String generic({required Object code}) => 'An error occurred (${code}).';
	@override String get cancelled => 'Request cancelled.';
	@override String get unexpected => 'An unexpected error occurred.';
	@override String get unexpectedResponse => 'Unexpected server response.';
	@override String get operationFailed => 'Operation failed.';
	@override String get noUserInResponse => 'No user information in the server response.';
}

// Path: crisis.cards
class _Translations$crisis$cards$en extends Translations$crisis$cards$tr {
	_Translations$crisis$cards$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _Translations$crisis$cards$meltdown$en meltdown = _Translations$crisis$cards$meltdown$en._(_root);
	@override late final _Translations$crisis$cards$sensory$en sensory = _Translations$crisis$cards$sensory$en._(_root);
	@override late final _Translations$crisis$cards$aggression$en aggression = _Translations$crisis$cards$aggression$en._(_root);
	@override late final _Translations$crisis$cards$anxiety$en anxiety = _Translations$crisis$cards$anxiety$en._(_root);
}

// Path: crisis.cards.meltdown
class _Translations$crisis$cards$meltdown$en extends Translations$crisis$cards$meltdown$tr {
	_Translations$crisis$cards$meltdown$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crisis / Meltdown';
	@override String get subtitle => 'Loss of control, crying, screaming, self-harm attempts';
	@override List<String> get steps => [
		'Stay calm — your voice and body language transfer to the child.',
		'Create a safe space: move away sharp or hard objects.',
		'Keep verbal input minimal; single words or short sentences.',
		'Reduce sensory input: dim the lights, lower the sound.',
		'Stay nearby — don\'t leave, but don\'t touch.',
		'Once the crisis passes, reassure with a calm tone.',
	];
	@override List<String> get avoid => [
		'Don\'t speak loudly.',
		'Don\'t try to reason or explain.',
		'Don\'t punish or threaten.',
		'Don\'t leave them in a crowd.',
	];
	@override String get emergency => '112 — Emergency Health Line';
}

// Path: crisis.cards.sensory
class _Translations$crisis$cards$sensory$en extends Translations$crisis$cards$sensory$tr {
	_Translations$crisis$cards$sensory$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sensory Overload';
	@override String get subtitle => 'Covering ears, avoiding light/sound, freezing';
	@override List<String> get steps => [
		'Move to a calmer, less stimulating environment right away.',
		'Offer favorite sensory objects (weighted blanket, squishy).',
		'Speak briefly in a predictable, calm tone.',
		'Deep pressure (firm hug) may help if the child consents.',
		'Give time — stay quiet for a few minutes.',
		'Note the trigger and take precautions going forward.',
	];
	@override List<String> get avoid => [
		'Don\'t keep giving verbal directions without changing the environment.',
		'Don\'t force them to hold anything.',
		'Don\'t say "Why are you overreacting?"',
	];
}

// Path: crisis.cards.aggression
class _Translations$crisis$cards$aggression$en extends Translations$crisis$cards$aggression$tr {
	_Translations$crisis$cards$aggression$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aggression / Self-Harm';
	@override String get subtitle => 'Hitting, biting, head-banging, throwing objects';
	@override List<String> get steps => [
		'Keep a safe distance; move others away if nearby.',
		'Give low, short, calm directives ("Stop", "Here").',
		'Remove provoking objects and people from the area.',
		'Offer an alternative outlet: hitting a pillow, running.',
		'Once it passes, note the event; analyze the trigger.',
	];
	@override List<String> get avoid => [
		'Avoid using physical force (unless necessary).',
		'Don\'t fuel it by drawing attention or creating an audience.',
		'Don\'t reward during the behavior.',
	];
	@override String get emergency => '112 — Emergency Call Center';
}

// Path: crisis.cards.anxiety
class _Translations$crisis$cards$anxiety$en extends Translations$crisis$cards$anxiety$tr {
	_Translations$crisis$cards$anxiety$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Intense Anxiety / Panic';
	@override String get subtitle => 'Trembling, shortness of breath, crying, withdrawing';
	@override List<String> get steps => [
		'Say in a calm tone, "I\'m here, you\'re safe."',
		'Do a deep breathing exercise: 4 seconds in, 6 seconds out.',
		'Use the "see 5 things, touch 4 things" grounding exercise.',
		'Offer a safe person or object (favorite toy, headphones).',
		'Give time for it to pass; don\'t rush them.',
	];
	@override List<String> get avoid => [
		'Don\'t belittle it by saying "Calm down, it\'s fine."',
		'Don\'t keep asking and applying pressure.',
		'Don\'t add new demands during anxiety.',
	];
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Autism Support',
			'common.loading' => 'Loading',
			'common.comingSoon' => 'This section is coming soon.',
			'common.seeAll' => 'See All',
			'common.more' => 'More',
			'common.retry' => 'Retry',
			'common.loadError' => 'Could not load data.',
			'common.monthsShort.0' => 'Jan',
			'common.monthsShort.1' => 'Feb',
			'common.monthsShort.2' => 'Mar',
			'common.monthsShort.3' => 'Apr',
			'common.monthsShort.4' => 'May',
			'common.monthsShort.5' => 'Jun',
			'common.monthsShort.6' => 'Jul',
			'common.monthsShort.7' => 'Aug',
			'common.monthsShort.8' => 'Sep',
			'common.monthsShort.9' => 'Oct',
			'common.monthsShort.10' => 'Nov',
			'common.monthsShort.11' => 'Dec',
			'language.title' => 'Language',
			'language.turkish' => 'Türkçe',
			'language.english' => 'English',
			'theme.title' => 'Theme',
			'theme.system' => 'System',
			'theme.light' => 'Light',
			'theme.dark' => 'Dark',
			'roles.parent' => 'Parent',
			'roles.expert' => 'Specialist',
			'roles.admin' => 'Admin',
			'auth.subtitle' => 'Sign in to your account or create a new one.',
			'auth.emailLabel' => 'Email Address',
			'auth.emailHint' => 'example@email.com',
			'auth.passwordLabel' => 'Password',
			'auth.passwordHint' => '••••••••',
			'auth.rememberMe' => 'Remember me',
			'auth.forgotPassword' => 'Forgot password',
			'auth.loginButton' => 'Sign In',
			'auth.noAccount' => 'Don\'t have an account?',
			'auth.registerParent' => 'Sign up as a parent',
			'auth.registerExpert' => 'Sign up as a specialist',
			'auth.errorEmptyFields' => 'Please enter your email and password.',
			'auth.registerComingSoon' => ({required Object role}) => '${role} sign-up screen is coming soon.',
			'forgotPassword.title' => 'Forgot Password',
			'forgotPassword.subtitle' => 'Enter your email and we\'ll send you a password reset link.',
			'forgotPassword.submit' => 'Send Reset Link',
			'forgotPassword.sentTitle' => 'Link sent',
			'forgotPassword.sentBody' => 'If an account exists for this email, a password reset link will arrive in your inbox.',
			'forgotPassword.haveCode' => 'I have a reset code',
			'forgotPassword.backToLogin' => 'Back to login',
			'forgotPassword.errorEmailRequired' => 'Please enter your email.',
			'forgotPassword.errorEmailInvalid' => 'Please enter a valid email.',
			'resetPassword.title' => 'Reset Password',
			'resetPassword.subtitle' => 'Enter the reset code from your email and your new password.',
			'resetPassword.tokenLabel' => 'Reset Code',
			'resetPassword.tokenHint' => 'The code from the email link',
			'resetPassword.newPasswordLabel' => 'New Password',
			'resetPassword.confirmLabel' => 'Confirm New Password',
			'resetPassword.submit' => 'Update Password',
			'resetPassword.success' => 'Your password has been updated. You can sign in now.',
			'resetPassword.errorTokenRequired' => 'Please enter the reset code.',
			'resetPassword.errorPasswordShort' => 'Password must be at least 8 characters.',
			'resetPassword.errorMismatch' => 'Passwords do not match.',
			'register.titleParent' => 'Create Parent Account',
			'register.titleExpert' => 'Create Specialist Account',
			'register.roleQuestion' => 'How would you like to sign up?',
			'register.fullNameLabel' => 'Full Name',
			'register.fullNameHint' => 'Your first and last name',
			'register.phoneLabel' => 'Phone (optional)',
			'register.phoneHint' => '05XX XXX XX XX',
			'register.cityLabel' => 'City (optional)',
			'register.cityHint' => 'Your city',
			'register.expertTitleLabel' => 'Professional Title',
			'register.expertTitleHint' => 'e.g. Child Psychologist',
			'register.institutionLabel' => 'Institution (optional)',
			'register.institutionHint' => 'Where you work',
			'register.licenseNumberLabel' => 'License / Diploma No',
			'register.licenseNumberHint' => 'Your professional license number',
			'register.bioLabel' => 'About (optional)',
			'register.bioHint' => 'Briefly describe your experience',
			'register.specializationsLabel' => 'Areas of Expertise (optional)',
			'register.specializationsHint' => 'Separate with commas (Autism, ADHD)',
			'register.kvkkConsent' => 'I have read and accept the data protection (KVKK) notice.',
			'register.submit' => 'Sign Up',
			'register.haveAccount' => 'Already have an account? Sign in',
			'register.errorFullNameRequired' => 'Please enter your full name.',
			'register.errorEmailRequired' => 'Please enter your email.',
			'register.errorEmailInvalid' => 'Please enter a valid email.',
			'register.errorPasswordShort' => 'Password must be at least 8 characters.',
			'register.errorExpertTitleRequired' => 'Please enter your professional title.',
			'register.errorKvkkRequired' => 'KVKK consent is required to continue.',
			'nav.home' => 'Home',
			'nav.specialists' => 'Specialists',
			'nav.progress' => 'Progress',
			'nav.profile' => 'Profile',
			'chat.title' => 'AI Assistant',
			'chat.greeting' => 'Hi! I\'ll try to answer your questions about autism and child development.',
			'chat.inputHint' => 'Ask a question...',
			'chat.errorGeneric' => 'Couldn\'t get a response, please try again.',
			'messages.title' => 'Messages',
			'messages.noConversations' => 'You have no conversations yet.',
			'messages.noMessages' => 'No messages yet. Send the first one.',
			'messages.inputHint' => 'Type a message...',
			'messages.connecting' => 'Connecting...',
			'home.notifications' => 'Notifications',
			'home.assistant' => 'AI Assistant',
			'home.messages' => 'Messages',
			'home.greeting' => ({required Object name}) => 'Hello, ${name}',
			'home.greetingFallback' => 'Parent',
			'home.subtitle' => 'What can we do for development today?',
			'home.childProgressTitle' => 'Child Development',
			'home.weeklySummary' => 'Weekly Progress Summary',
			'home.increaseBadge' => ({required Object value}) => '${value}% Increase',
			'home.remainingToGoal' => ({required Object value}) => 'Remaining to goal: ${value}%',
			'home.statusCognitiveGood' => 'Cognitive: Good',
			'home.statusCommunicationImproving' => 'Communication: Improving',
			'home.upcomingAppointments' => 'Upcoming Appointments',
			'home.recommendedArticles' => 'Recommended Articles',
			'home.childrenTitle' => 'My Children',
			'home.noChildren' => 'You haven\'t added a child yet.',
			'home.addChild' => 'Add Child',
			'home.ageYears' => ({required Object years}) => '${years} yrs',
			'home.noAppointments' => 'You have no upcoming appointments.',
			'home.noArticles' => 'No articles to show.',
			'specialists.title' => 'Find a Specialist',
			'specialists.searchHint' => 'Search by name or expertise...',
			'specialists.filterAll' => 'All',
			'specialists.filterPsychologist' => 'Psychologist',
			'specialists.filterSpecialEducation' => 'Special Education',
			'specialists.filterSpeech' => 'Speech & Language',
			'specialists.noResults' => 'No specialists match your search.',
			'specialists.ratingNew' => 'New',
			'specialists.reviews' => ({required Object count}) => '${count} reviews',
			'progress.title' => 'Progress Tracking',
			'progress.subtitle' => 'Goals and development notes.',
			'progress.addRecord' => 'Add New Record',
			'progress.goalsTitle' => 'Goals',
			'progress.recentNotes' => 'Recent Development Notes',
			'progress.noGoals' => 'No goals added yet.',
			'progress.noNotes' => 'No development notes yet.',
			'progress.noChild' => 'Add a child first to track development.',
			'progress.goalProgress' => ({required Object done, required Object total}) => '${done} / ${total}',
			'progress.addGoal' => 'Add Goal',
			'progress.addNote' => 'Add Note',
			'progress.addToken' => 'Add Token',
			'progress.tokenAdded' => 'Token added 🎉',
			'progress.tokenRemoved' => 'Token removed.',
			'progress.goalCompleted' => 'Goal completed! 🎉',
			'progress.rewardLine' => ({required Object title}) => 'Reward: ${title}',
			'goalForm.title' => 'Add Goal',
			'goalForm.nameLabel' => 'Title',
			'goalForm.nameHint' => 'e.g. Making eye contact',
			'goalForm.categoryLabel' => 'Category',
			'goalForm.targetLabel' => 'Target Count',
			'goalForm.descriptionLabel' => 'Description (optional)',
			'goalForm.descriptionHint' => 'Details about the goal',
			'goalForm.save' => 'Save',
			'goalForm.errorTitle' => 'Please enter a title.',
			'goalForm.created' => 'Goal added.',
			'noteForm.title' => 'Add Note',
			'noteForm.nameLabel' => 'Title',
			'noteForm.nameHint' => 'e.g. Today\'s progress',
			'noteForm.contentLabel' => 'Content (optional)',
			'noteForm.contentHint' => 'Write your observations',
			'noteForm.categoryLabel' => 'Category (optional)',
			'noteForm.moodLabel' => 'Mood (optional)',
			'noteForm.moodHappy' => 'Happy',
			'noteForm.moodCalm' => 'Calm',
			'noteForm.moodSad' => 'Sad',
			'noteForm.dateLabel' => 'Date',
			'noteForm.save' => 'Save',
			'noteForm.errorTitle' => 'Please enter a title.',
			'noteForm.created' => 'Note added.',
			'notifications.show' => 'Show',
			'notifications.title' => 'Notifications',
			'notifications.empty' => 'You have no notifications yet.',
			'notifications.markAllRead' => 'Mark all as read',
			'notifications.dateLine' => ({required Object day, required Object month, required Object time}) => '${day} ${month} · ${time}',
			'knowledge.title' => 'Knowledge Base',
			'knowledge.empty' => 'No articles yet.',
			'knowledge.noResults' => 'No content matches this filter.',
			'knowledge.filterAll' => 'All',
			'knowledge.formatArticle' => 'Article',
			'knowledge.formatVideo' => 'Video',
			'knowledge.formatPodcast' => 'Podcast',
			'knowledge.views' => ({required Object count}) => '${count} views',
			'knowledge.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'knowledge.videoLink' => 'Video link',
			'knowledge.podcastLink' => 'Podcast link',
			'appointments.title' => 'Appointments',
			'appointments.empty' => 'You don\'t have any appointments yet.',
			'appointments.upcoming' => 'Upcoming',
			'appointments.past' => 'Past',
			'appointments.statusPending' => 'Pending',
			'appointments.statusConfirmed' => 'Confirmed',
			'appointments.statusCompleted' => 'Completed',
			'appointments.statusCancelled' => 'Cancelled',
			'appointments.typeOnline' => 'Online session',
			'appointments.typeFaceToFace' => 'In person',
			'appointments.withChild' => ({required Object name}) => 'Child: ${name}',
			'appointments.dateLine' => ({required Object day, required Object month, required Object year, required Object time}) => '${day} ${month} ${year} · ${time}',
			'appointments.cancel' => 'Cancel',
			'appointments.confirm' => 'Confirm',
			'appointments.complete' => 'Complete',
			'appointments.joinMeeting' => 'Join meeting',
			'appointments.cancelTitle' => 'Cancel appointment',
			'appointments.cancelConfirm' => 'Are you sure you want to cancel this appointment?',
			'appointments.cancelReasonLabel' => 'Cancellation reason (optional)',
			'appointments.cancelReasonShown' => ({required Object reason}) => 'Cancellation reason: ${reason}',
			'appointments.keepIt' => 'Keep',
			'appointments.cancelled' => 'Appointment cancelled.',
			'appointments.confirmed' => 'Appointment confirmed.',
			'appointments.completed' => 'Appointment marked as completed.',
			'appointments.reschedule' => 'Reschedule',
			'appointments.rescheduleTitle' => 'Reschedule Appointment',
			'appointments.rescheduleConfirm' => 'Confirm New Time',
			'appointments.rescheduled' => 'Appointment rescheduled.',
			'expertDetail.bookAppointment' => 'Book Appointment',
			'expertDetail.sendMessage' => 'Send Message',
			'expertDetail.specializationsTitle' => 'Specializations',
			'expertDetail.articleCount' => ({required Object count}) => '${count} articles',
			'expertDetail.notAcceptingPatients' => 'This expert is not accepting appointments right now.',
			'booking.title' => 'Book Appointment',
			'booking.childLabel' => 'Child',
			'booking.noChild' => 'Add a child first to book an appointment.',
			'booking.typeLabel' => 'Appointment Type',
			'booking.dateLabel' => 'Date',
			'booking.selectDate' => 'Select date',
			'booking.dateValue' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'booking.timeLabel' => 'Time',
			'booking.selectDateFirst' => 'Select a date to see available times.',
			'booking.noSlots' => 'No available times for this day.',
			'booking.notesLabel' => 'Note (optional)',
			'booking.notesHint' => 'A note for the expert',
			'booking.confirm' => 'Confirm Appointment',
			'booking.created' => 'Appointment created.',
			'booking.errorSelectChild' => 'Please select a child.',
			'booking.errorSelectTime' => 'Please select a time.',
			'routines.title' => 'Routines',
			'routines.empty' => 'No routines for this child yet.',
			'routines.noChild' => 'Add a child first to create routines.',
			'routines.add' => 'Add Routine',
			'routines.addItem' => 'Add Step',
			'routines.noItems' => 'No steps added yet.',
			'routines.deleteRoutineTitle' => 'Delete Routine',
			'routines.deleteRoutineConfirm' => ({required Object name}) => 'Are you sure you want to delete the routine "${name}"?',
			'routines.delete' => 'Delete',
			'routines.cancel' => 'Cancel',
			'routines.created' => 'Routine added.',
			'routines.itemAdded' => 'Step added.',
			'routines.deleted' => 'Routine deleted.',
			'routines.itemTitleLabel' => 'Step Title',
			'routines.itemTitleHint' => 'e.g. Brush teeth',
			'routines.itemTimeLabel' => 'Time (optional)',
			'routines.selectTime' => 'Select time',
			'routines.itemIconLabel' => 'Icon',
			'routines.itemSave' => 'Add',
			'routines.errorItemTitle' => 'Please enter a step title.',
			'routineForm.title' => 'Add Routine',
			'routineForm.nameLabel' => 'Routine Name',
			'routineForm.nameHint' => 'e.g. Morning Routine',
			'routineForm.descriptionLabel' => 'Description (optional)',
			'routineForm.descriptionHint' => 'What is this routine for?',
			'routineForm.save' => 'Save',
			'routineForm.errorName' => 'Please enter a routine name.',
			'dailyTracker.title' => 'Daily Tracker',
			'dailyTracker.tabMood' => 'Mood',
			'dailyTracker.tabSleep' => 'Sleep',
			'dailyTracker.tabMeds' => 'Medication',
			'dailyTracker.todayTitle' => 'How was today?',
			'dailyTracker.today' => 'Today',
			'dailyTracker.mood1' => 'Very Bad',
			'dailyTracker.mood2' => 'Bad',
			'dailyTracker.mood3' => 'Okay',
			'dailyTracker.mood4' => 'Good',
			'dailyTracker.mood5' => 'Great',
			'dailyTracker.triggersLabel' => 'Possible triggers (optional)',
			'dailyTracker.notesLabel' => 'Note (optional)',
			'dailyTracker.notesHint' => 'Your observations about today',
			'dailyTracker.save' => 'Save',
			'dailyTracker.update' => 'Update',
			'dailyTracker.saved' => 'Mood saved.',
			'dailyTracker.historyTitle' => 'Past Entries',
			'dailyTracker.empty' => 'No entries yet. Add the first one today.',
			'dailyTracker.noChild' => 'Add a child first to use the daily tracker.',
			'dailyTracker.deleteTitle' => 'Delete Entry',
			'dailyTracker.deleteConfirm' => ({required Object date}) => 'Are you sure you want to delete the entry dated ${date}?',
			'dailyTracker.delete' => 'Delete',
			'dailyTracker.cancel' => 'Cancel',
			'dailyTracker.deleted' => 'Entry deleted.',
			'dailyTracker.errorSelectMood' => 'Please select a mood.',
			'dailyTracker.dateLine' => ({required Object day, required Object month, required Object year}) => '${day} ${month} ${year}',
			'sleep.todayTitle' => 'Last Night / This Morning',
			'sleep.bedtime' => 'Bedtime',
			'sleep.wakeTime' => 'Wake Time',
			'sleep.quality' => 'Sleep Quality',
			'sleep.nightWakings' => 'Night wakings',
			'sleep.factorsLabel' => 'Sensory and environmental factors',
			'sleep.factorWeighted' => '🛏️ Weighted Blanket',
			'sleep.factorSensory' => '👕 Sensory Sensitivity',
			'sleep.factorMelatonin' => '💊 Melatonin Support',
			'sleep.factorNoise' => '🔊 Noise / Light',
			'sleep.saved' => 'Sleep saved.',
			'sleep.empty' => 'No sleep entries yet. Add the first one today.',
			'sleep.deleteConfirm' => ({required Object date}) => 'Are you sure you want to delete the sleep entry dated ${date}?',
			'sleep.deleted' => 'Sleep entry deleted.',
			'sleep.duration' => ({required Object h, required Object m}) => '${h} h ${m} min',
			'sleep.wakings' => ({required Object count}) => 'woke ${count} times',
			'meds.safetyTitle' => 'Medication safety',
			'meds.safetyBody' => 'Medication reminders are for support only. Decisions about starting, stopping, changing doses or side effects should be made only with your doctor.',
			'meds.add' => 'Add Medication',
			'meds.addTitle' => 'Add New Medication',
			'meds.editTitle' => 'Edit Medication',
			'meds.empty' => 'No medications yet. Add your child\'s medications and supplements here.',
			'meds.name' => 'Medication / Supplement Name',
			'meds.nameHint' => 'E.g. Omega-3',
			'meds.dosage' => 'Dose',
			'meds.unit' => 'Unit',
			'meds.frequency' => 'Frequency',
			'meds.freqDaily' => 'Once a day',
			'meds.freqTwiceDaily' => 'Twice a day',
			'meds.freqThreeDaily' => '3 times a day',
			'meds.freqAsNeeded' => 'As needed',
			'meds.freqWeekly' => 'Weekly',
			'meds.timesLabel' => 'Dose times',
			'meds.addTime' => 'Add Time',
			'meds.noTime' => 'No time',
			'meds.added' => 'Medication added.',
			'meds.updated' => 'Medication updated.',
			'meds.deleteTitle' => 'Delete Medication',
			'meds.deleteConfirm' => ({required Object name}) => '${name} and its dose logs will be permanently deleted. Are you sure?',
			'meds.deleted' => 'Medication deleted.',
			'meds.errorName' => 'Please enter the medication name.',
			'meds.logTitle' => 'Dose Log',
			'meds.taken' => 'Medication taken',
			'meds.sideEffectsLabel' => 'Observed side effects',
			'meds.logNotesLabel' => 'Observation notes (optional)',
			'meds.logNotesHint' => 'Anything you want to share with your doctor?',
			'meds.logSaved' => 'Dose log saved.',
			'wall.title' => 'Support Wall',
			'wall.subtitle' => 'Share your feelings and support each other. Posts can be anonymous.',
			'wall.empty' => 'No posts yet. Be the first to share.',
			'wall.add' => 'Share',
			'wall.addTitle' => 'Support Post',
			'wall.editTitle' => 'Edit Post',
			'wall.titleLabel' => 'Title (optional)',
			'wall.titleHint' => 'A short title',
			'wall.contentLabel' => 'How are you feeling?',
			'wall.contentHint' => 'You can let it out; you\'re not alone here.',
			'wall.anonymous' => 'Post anonymously',
			'wall.anonymousUser' => 'Anonymous User',
			'wall.post' => 'Share',
			'wall.posted' => 'Your post was added to the wall.',
			'wall.updated' => 'Post updated.',
			'wall.deleteTitle' => 'Delete Post',
			'wall.deleteConfirm' => 'Are you sure you want to delete this post?',
			'wall.deleted' => 'Post deleted.',
			'wall.errorContent' => 'Please write something.',
			'wall.supportCount' => ({required Object count}) => '${count} support',
			'wall.commentCount' => ({required Object count}) => '${count} comments',
			'wall.detailTitle' => 'Post',
			'wall.commentsTitle' => 'Support Messages',
			'wall.commentHint' => 'Write a message of support…',
			'wall.commentSend' => 'Send',
			'wall.commentSent' => 'Support message sent.',
			'wall.commentEmpty' => 'No support messages yet. Be the first.',
			'wall.commentDeleteTitle' => 'Delete Comment',
			'wall.commentDeleteConfirm' => 'Are you sure you want to delete this support message?',
			'wall.commentDeleted' => 'Comment deleted.',
			'wall.edit' => 'Edit',
			'wall.delete' => 'Delete',
			'wall.cancel' => 'Cancel',
			'wall.save' => 'Save',
			'wall.justNow' => 'just now',
			'wall.minsAgo' => ({required Object count}) => '${count} min ago',
			'wall.hoursAgo' => ({required Object count}) => '${count} h ago',
			'wall.daysAgo' => ({required Object count}) => '${count} d ago',
			'crisis.title' => 'Crisis Guide',
			'crisis.heroTitle' => 'What To Do in Hard Moments?',
			'crisis.heroSubtitle' => 'A quick guide to help you stay calm and take the right steps when your child is overwhelmed.',
			'crisis.breathingTitle' => 'Breathing Regulator',
			'crisis.breathingSubtitle' => 'Calm yourself first. Start and match your breathing to the ring\'s expand-and-shrink pace.',
			'crisis.breathingStart' => 'Start Exercise',
			'crisis.breathingStop' => 'Stop',
			'crisis.breathingReady' => 'Ready',
			'crisis.breathingReadyHint' => 'Tap to start',
			'crisis.breathingInhale' => 'Breathe In',
			'crisis.breathingExhale' => 'Breathe Out',
			'crisis.breathingSeconds' => 'seconds',
			'crisis.stepsLabel' => 'What To Do?',
			'crisis.avoidLabel' => 'What To Avoid',
			'crisis.emergencyLabel' => 'Suggested Emergency Line',
			'crisis.contactsTitle' => 'Emergency Numbers',
			'crisis.disclaimer' => 'This guide is for general information; in emergencies or medical situations always call your local emergency number.',
			'crisis.contact112Label' => 'Emergency Health and Safety',
			'crisis.contact112Desc' => 'Ambulance, Police, Fire',
			'crisis.contact183Label' => 'Social Support Line',
			'crisis.contact183Desc' => 'Family, Children and Social Services',
			'crisis.cards.meltdown.title' => 'Crisis / Meltdown',
			'crisis.cards.meltdown.subtitle' => 'Loss of control, crying, screaming, self-harm attempts',
			'crisis.cards.meltdown.steps.0' => 'Stay calm — your voice and body language transfer to the child.',
			'crisis.cards.meltdown.steps.1' => 'Create a safe space: move away sharp or hard objects.',
			'crisis.cards.meltdown.steps.2' => 'Keep verbal input minimal; single words or short sentences.',
			'crisis.cards.meltdown.steps.3' => 'Reduce sensory input: dim the lights, lower the sound.',
			'crisis.cards.meltdown.steps.4' => 'Stay nearby — don\'t leave, but don\'t touch.',
			'crisis.cards.meltdown.steps.5' => 'Once the crisis passes, reassure with a calm tone.',
			'crisis.cards.meltdown.avoid.0' => 'Don\'t speak loudly.',
			'crisis.cards.meltdown.avoid.1' => 'Don\'t try to reason or explain.',
			'crisis.cards.meltdown.avoid.2' => 'Don\'t punish or threaten.',
			'crisis.cards.meltdown.avoid.3' => 'Don\'t leave them in a crowd.',
			'crisis.cards.meltdown.emergency' => '112 — Emergency Health Line',
			'crisis.cards.sensory.title' => 'Sensory Overload',
			'crisis.cards.sensory.subtitle' => 'Covering ears, avoiding light/sound, freezing',
			'crisis.cards.sensory.steps.0' => 'Move to a calmer, less stimulating environment right away.',
			'crisis.cards.sensory.steps.1' => 'Offer favorite sensory objects (weighted blanket, squishy).',
			'crisis.cards.sensory.steps.2' => 'Speak briefly in a predictable, calm tone.',
			'crisis.cards.sensory.steps.3' => 'Deep pressure (firm hug) may help if the child consents.',
			'crisis.cards.sensory.steps.4' => 'Give time — stay quiet for a few minutes.',
			'crisis.cards.sensory.steps.5' => 'Note the trigger and take precautions going forward.',
			'crisis.cards.sensory.avoid.0' => 'Don\'t keep giving verbal directions without changing the environment.',
			'crisis.cards.sensory.avoid.1' => 'Don\'t force them to hold anything.',
			'crisis.cards.sensory.avoid.2' => 'Don\'t say "Why are you overreacting?"',
			'crisis.cards.aggression.title' => 'Aggression / Self-Harm',
			'crisis.cards.aggression.subtitle' => 'Hitting, biting, head-banging, throwing objects',
			'crisis.cards.aggression.steps.0' => 'Keep a safe distance; move others away if nearby.',
			'crisis.cards.aggression.steps.1' => 'Give low, short, calm directives ("Stop", "Here").',
			'crisis.cards.aggression.steps.2' => 'Remove provoking objects and people from the area.',
			'crisis.cards.aggression.steps.3' => 'Offer an alternative outlet: hitting a pillow, running.',
			'crisis.cards.aggression.steps.4' => 'Once it passes, note the event; analyze the trigger.',
			'crisis.cards.aggression.avoid.0' => 'Avoid using physical force (unless necessary).',
			'crisis.cards.aggression.avoid.1' => 'Don\'t fuel it by drawing attention or creating an audience.',
			'crisis.cards.aggression.avoid.2' => 'Don\'t reward during the behavior.',
			'crisis.cards.aggression.emergency' => '112 — Emergency Call Center',
			'crisis.cards.anxiety.title' => 'Intense Anxiety / Panic',
			'crisis.cards.anxiety.subtitle' => 'Trembling, shortness of breath, crying, withdrawing',
			'crisis.cards.anxiety.steps.0' => 'Say in a calm tone, "I\'m here, you\'re safe."',
			'crisis.cards.anxiety.steps.1' => 'Do a deep breathing exercise: 4 seconds in, 6 seconds out.',
			'crisis.cards.anxiety.steps.2' => 'Use the "see 5 things, touch 4 things" grounding exercise.',
			'crisis.cards.anxiety.steps.3' => 'Offer a safe person or object (favorite toy, headphones).',
			'crisis.cards.anxiety.steps.4' => 'Give time for it to pass; don\'t rush them.',
			'crisis.cards.anxiety.avoid.0' => 'Don\'t belittle it by saying "Calm down, it\'s fine."',
			'crisis.cards.anxiety.avoid.1' => 'Don\'t keep asking and applying pressure.',
			'crisis.cards.anxiety.avoid.2' => 'Don\'t add new demands during anxiety.',
			'calendar.title' => 'Calendar',
			'calendar.subtitle' => 'Child-specific therapy, doctor and activity schedule.',
			'calendar.noChild' => 'Add a child first to use the calendar.',
			'calendar.empty' => 'No events yet. Add the first one.',
			'calendar.add' => 'Add Event',
			'calendar.addTitle' => 'New Event',
			'calendar.editTitle' => 'Edit Event',
			'calendar.eventType' => 'Event Type',
			'calendar.typeTerapi' => 'Therapy',
			'calendar.typeDoktor' => 'Doctor',
			'calendar.typeEgitim' => 'Education',
			'calendar.typeAktivite' => 'Activity',
			'calendar.typeAppointment' => 'Appointment',
			'calendar.typeDiger' => 'Other',
			'calendar.eventTitle' => 'Title',
			'calendar.titleHint' => 'Event name',
			'calendar.location' => 'Location',
			'calendar.locationHint' => 'Clinic name, address',
			'calendar.description' => 'Description',
			'calendar.start' => 'Start',
			'calendar.end' => 'End (optional)',
			'calendar.reminder' => 'Reminder',
			'calendar.reminderOff' => 'Off',
			'calendar.reminderMin' => ({required Object count}) => '${count} min before',
			'calendar.reminderHour' => ({required Object count}) => '${count} h before',
			'calendar.reminderDay' => '1 day before',
			'calendar.statusPlanned' => 'Planned',
			'calendar.statusCompleted' => 'Completed',
			'calendar.statusCancelled' => 'Cancelled',
			'calendar.markCompleted' => 'Mark completed',
			'calendar.markPlanned' => 'Mark planned',
			'calendar.markCancelled' => 'Cancel event',
			'calendar.today' => 'Today',
			'calendar.tomorrow' => 'Tomorrow',
			'calendar.save' => 'Save',
			'calendar.saved' => 'Event saved.',
			'calendar.deleteTitle' => 'Delete Event',
			'calendar.deleteConfirm' => ({required Object title}) => 'Are you sure you want to delete "${title}"?',
			'calendar.deleted' => 'Event deleted.',
			'calendar.errorTitle' => 'Please enter a title.',
			'calendar.cancel' => 'Cancel',
			'calendar.delete' => 'Delete',
			'emergency.title' => 'Emergency Card',
			'emergency.subtitle' => 'Information to show to anyone who meets your child in an emergency.',
			'emergency.noChild' => 'Add a child first to create an emergency card.',
			'emergency.lastUpdated' => ({required Object date}) => 'Last updated ${date}',
			'emergency.notSaved' => 'This card has not been saved yet.',
			'emergency.save' => 'Save',
			'emergency.saved' => 'Emergency card saved.',
			'emergency.call' => 'Call',
			'emergency.sectionChild' => 'Child Information',
			'emergency.sectionContacts' => 'Emergency Contacts',
			'emergency.sectionMedical' => 'Medical Information',
			'emergency.sectionBehavior' => 'Behavioral Information',
			'emergency.childName' => 'Full Name',
			'emergency.birthDate' => 'Date of Birth',
			'emergency.diagnosis' => 'Diagnosis',
			'emergency.bloodType' => 'Blood Type',
			'emergency.communicationLevel' => 'Communication Level',
			'emergency.languages' => 'Language(s) Spoken',
			'emergency.warningsLabel' => 'Special condition warnings',
			'emergency.selfInjury' => 'May exhibit self-injury',
			'emergency.wandering' => 'Risk of wandering / getting lost',
			'emergency.nonVerbal' => 'Non-verbal',
			'emergency.contact1' => 'First Contact',
			'emergency.contact2' => 'Second Contact',
			'emergency.doctor' => 'Doctor / Hospital',
			'emergency.name' => 'Full Name',
			'emergency.phone' => 'Phone',
			'emergency.relation' => 'Relationship',
			_ => null,
		} ?? switch (path) {
			'emergency.doctorName' => 'Doctor Name',
			'emergency.doctorPhone' => 'Doctor Phone',
			'emergency.hospital' => 'Hospital',
			'emergency.medications' => 'Current Medications',
			'emergency.medicationsHint' => 'Name - dose - time (one medication per line)',
			'emergency.allergies' => 'Allergies',
			'emergency.allergiesHint' => 'Food, drug, substance allergies',
			'emergency.conditions' => 'Other Medical Conditions',
			'emergency.conditionsHint' => 'Epilepsy, heart condition, etc.',
			'emergency.triggers' => 'Triggers (to avoid)',
			'emergency.triggersHint' => 'What causes a crisis? E.g. sudden noise, crowds',
			'emergency.calming' => 'Calming Strategies',
			'emergency.calmingHint' => 'What helps? E.g. favorite music, quiet room',
			'emergency.avoid' => 'Things to Never Do',
			'emergency.avoidHint' => 'E.g. don\'t shout, don\'t restrain, don\'t force eye contact',
			'emergency.special' => 'Special Instructions',
			'emergency.specialHint' => 'Extra notes for emergency services or caregivers',
			'emergency.select' => 'Select...',
			'behavior.title' => 'Behavior Journal',
			'behavior.subtitle' => 'ABC (Antecedent-Behavior-Consequence) observation log',
			'behavior.add' => 'Add Entry',
			'behavior.addTitle' => 'New ABC Entry',
			'behavior.empty' => 'No behavior entries yet. Add the first observation.',
			'behavior.noChild' => 'Add a child first to use the behavior journal.',
			'behavior.date' => 'Date',
			'behavior.time' => 'Time',
			'behavior.category' => 'Category',
			'behavior.location' => 'Location',
			'behavior.antecedentLabel' => 'A — Antecedent (Trigger)',
			'behavior.antecedentHint' => 'Describe the trigger',
			'behavior.behaviorLabel' => 'B — Behavior (What happened?)',
			'behavior.behaviorHint' => 'Describe the behavior in detail',
			'behavior.consequenceLabel' => 'C — Consequence (What did you do?)',
			'behavior.consequenceHint' => 'Describe your intervention',
			'behavior.other' => 'Other...',
			'behavior.intensityLabel' => 'Intensity',
			'behavior.intensity1' => 'Very Mild',
			'behavior.intensity2' => 'Mild',
			'behavior.intensity3' => 'Moderate',
			'behavior.intensity4' => 'Severe',
			'behavior.intensity5' => 'Very Severe',
			'behavior.notesLabel' => 'Additional notes (optional)',
			'behavior.save' => 'Save',
			'behavior.saved' => 'ABC entry created.',
			'behavior.deleteTitle' => 'Delete Entry',
			'behavior.deleteConfirm' => ({required Object date}) => 'Are you sure you want to delete the ABC entry dated ${date}?',
			'behavior.deleted' => 'Entry deleted.',
			'behavior.errorRequired' => 'Please fill the required fields (category, location, A, B, C).',
			'analytics.title' => 'Development Panel',
			'analytics.subtitle' => 'Development trends over the last 6 months.',
			'analytics.milestones' => 'Milestones',
			'analytics.milestonesUnit' => 'achievements per month',
			'analytics.mood' => 'Average Mood',
			'analytics.moodUnit' => 'monthly average (1-5)',
			'analytics.sleep' => 'Average Sleep',
			'analytics.sleepUnit' => 'hours per night (monthly average)',
			'analytics.behavior' => 'Behavior Logs',
			'analytics.behaviorUnit' => 'entries per month',
			'analytics.noData' => 'No data in this range yet.',
			'analytics.noChild' => 'Add a child first to see the development panel.',
			'children.title' => 'My Children',
			'children.addTitle' => 'Add Child',
			'children.editTitle' => 'Edit Child',
			'children.empty' => 'You haven\'t added any children yet.',
			'children.add' => 'Add Child',
			'children.nameLabel' => 'Full Name',
			'children.nameHint' => 'Child\'s name',
			'children.birthDateLabel' => 'Birth Date (optional)',
			'children.birthDateSelect' => 'Select date',
			'children.genderLabel' => 'Gender (optional)',
			'children.genderMale' => 'Boy',
			'children.genderFemale' => 'Girl',
			'children.diagnosisLabel' => 'Diagnosis Info (optional)',
			'children.diagnosisHint' => 'Diagnosis info, if any',
			'children.educationLabel' => 'Education Program (optional)',
			'children.educationHint' => 'Current education program',
			'children.therapiesLabel' => 'Therapies (optional)',
			'children.therapiesHint' => 'Therapies received',
			'children.ageYears' => ({required Object years}) => '${years} yrs',
			'children.save' => 'Save',
			'children.cancel' => 'Cancel',
			'children.delete' => 'Delete',
			'children.deleteTitle' => 'Delete Child',
			'children.deleteConfirm' => ({required Object name}) => 'Are you sure you want to delete ${name}\'s profile?',
			'children.errorNameRequired' => 'Please enter the child\'s name.',
			'children.created' => 'Child profile created.',
			'children.updated' => 'Child profile updated.',
			'children.deleted' => 'Child profile deleted.',
			'account.title' => 'Account Information',
			'account.emailLabel' => 'Email',
			'account.fullNameLabel' => 'Full Name',
			'account.phoneLabel' => 'Phone',
			'account.phoneHint' => '05XX XXX XX XX',
			'account.cityLabel' => 'City',
			'account.expertTitleLabel' => 'Expert Title',
			'account.institutionLabel' => 'Institution',
			'account.licenseNumberLabel' => 'License Number',
			'account.bioLabel' => 'About',
			'account.bioHint' => 'Briefly describe your experience',
			'account.save' => 'Save',
			'account.saved' => 'Profile updated.',
			'account.errorFullName' => 'Full name must be at least 2 characters.',
			'help.title' => 'Help & About',
			'help.aboutTitle' => 'About Otizm Destek',
			'help.aboutBody' => 'Otizm Destek is a mobile app that helps you track your child\'s development, connect with experts, and book appointments.',
			'help.tipsTitle' => 'Tips',
			'help.tip1' => 'Add your children under "My Children"; track goals and notes in the "Progress" tab.',
			'help.tip2' => 'Pick an expert under "Experts" to book an appointment or send a message.',
			'help.tip3' => 'Ask the AI Assistant questions about autism and child development.',
			'help.contactTitle' => 'Contact',
			'help.contactBody' => 'Reach us from within the app for any questions or suggestions.',
			'help.version' => ({required Object version}) => 'Version ${version}',
			'profile.defaultUser' => 'User',
			'profile.accountInfo' => 'Account Information',
			'profile.myChildren' => 'My Children',
			'profile.notificationSettings' => 'Notification Settings',
			'profile.help' => 'Help',
			'profile.signOut' => 'Sign Out',
			'errors.timeout' => 'Could not reach the server, please try again.',
			'errors.noConnection' => 'You appear to be offline.',
			'errors.generic' => ({required Object code}) => 'An error occurred (${code}).',
			'errors.cancelled' => 'Request cancelled.',
			'errors.unexpected' => 'An unexpected error occurred.',
			'errors.unexpectedResponse' => 'Unexpected server response.',
			'errors.operationFailed' => 'Operation failed.',
			'errors.noUserInResponse' => 'No user information in the server response.',
			_ => null,
		};
	}
}
