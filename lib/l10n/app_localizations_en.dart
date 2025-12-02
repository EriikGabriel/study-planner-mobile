// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Study Planner';

  @override
  String get appTagline =>
      'More than a planner, your ally on the academic journey.';

  @override
  String get mandatoryField => 'Mandatory Field!';

  @override
  String get success => 'Success';

  @override
  String get userCreated => 'User Created';

  @override
  String get error => 'Error';

  @override
  String get wrongUserOrPassword => 'Wrong user or password';

  @override
  String get somethingWrong => 'Something went wrong. Please try again';

  @override
  String get musicForEveryone => 'Music for everyone';

  @override
  String get username => 'Fullname';

  @override
  String get password => 'Password';

  @override
  String get orLabel => ' OR ';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginSigninTitle => 'Sign in with';

  @override
  String get loginSignupTitle => 'Create your account';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginButtonSignup => 'Register';

  @override
  String get loginToggleSignup => 'Don\'t have an account? Register';

  @override
  String get loginToggleSignin => 'Already have an account? Sign in';

  @override
  String get loginSuccess => 'Signed in successfully!';

  @override
  String get loginEmailRequired => 'Email is required';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginInvalidEmail => 'Invalid email';

  @override
  String get loginInvalidCredentials =>
      'Invalid email or password. Check your data.';

  @override
  String get loginUserNotFound => 'User not found. Please register first.';

  @override
  String get loginWrongPassword => 'Incorrect password. Try again.';

  @override
  String get loginUserDisabled => 'User disabled. Contact support.';

  @override
  String get loginTooManyRequests =>
      'Too many login attempts. Try again later.';

  @override
  String get loginGenericError => 'Error while signing in';

  @override
  String get loginConnectionError => 'Connection error';

  @override
  String get signupUsernameRequired => 'Username is required';

  @override
  String get signupPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get signupAccountCreationError =>
      'Email already registered or error while creating account';

  @override
  String get signupUfscarInvalidCredentials =>
      'Invalid email or password on the UFSCar platform.';

  @override
  String get signupSaveDataError => 'Failed to save data. Please try again.';

  @override
  String get signupGenericError => 'Error while creating account';

  @override
  String get signupEmailAlreadyExists => 'This email is already registered';

  @override
  String get signupWeakPassword => 'Weak password. Use at least 6 characters.';

  @override
  String get signupOperationNotAllowed =>
      'Operation not allowed. Try again later.';

  @override
  String get signupApiConnectionError => 'Error connecting to the API';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsEditProfile => 'Edit Profile';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsComingSoon => 'In development';

  @override
  String get settingsAutoPresenceTitle => 'Automatic attendance';

  @override
  String get settingsAutoPresenceSubtitle =>
      'Mark attendance automatically for new subjects';

  @override
  String get settingsAutoPresenceSaveError => 'Error saving setting';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageDialogTitle => 'Select Language';

  @override
  String get settingsAboutApp => 'About the App';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfUse => 'Terms of Use';

  @override
  String get settingsLogoutButton => 'Sign out';

  @override
  String get settingsLogoutTitle => 'Sign out';

  @override
  String get settingsLogoutMessage => 'Are you sure you want to sign out?';

  @override
  String get settingsLogoutCancel => 'Cancel';

  @override
  String get settingsLogoutConfirm => 'Sign out';

  @override
  String get settingsThemeTitle => 'Dark Mode';

  @override
  String get settingsThemeEnabled => 'Enabled';

  @override
  String get settingsThemeDisabled => 'Disabled';

  @override
  String get languagePortuguese => 'Portuguese';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageFrench => 'French';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get mainTabAgenda => 'Schedule';

  @override
  String get mainTabActivities => 'Activities';

  @override
  String get mainTabRooms => 'Rooms';

  @override
  String get mainTabNotifications => 'Notifications';

  @override
  String get mainTabSettings => 'Settings';

  @override
  String get agendaFilterAll => 'All';

  @override
  String get agendaDefaultSectionTitle => 'My Subjects';

  @override
  String get agendaClearFilter => 'View all';

  @override
  String get agendaGoToToday => 'Today';

  @override
  String get agendaEmptyTitle => 'No subjects found';

  @override
  String get agendaEmptyAction => 'Reload';

  @override
  String get agendaEmptyDayTitle => 'No subjects on this day';

  @override
  String get agendaEmptyDayAction => 'View all subjects';

  @override
  String agendaSubjectsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'subjects',
      one: 'subject',
    );
    return '($count $_temp0)';
  }

  @override
  String get agendaNoSchedule => 'Schedule not defined';

  @override
  String agendaClassLabel(Object group, Object year, Object term) {
    return 'Class $group • $year/$term';
  }

  @override
  String get agendaNoName => 'Untitled subject';

  @override
  String get agendaNoDayDefined => 'No day defined';

  @override
  String get agendaDayMonday => 'Monday';

  @override
  String get agendaDayTuesday => 'Tuesday';

  @override
  String get agendaDayWednesday => 'Wednesday';

  @override
  String get agendaDayThursday => 'Thursday';

  @override
  String get agendaDayFriday => 'Friday';

  @override
  String get agendaDaySaturday => 'Saturday';

  @override
  String get agendaDaySunday => 'Sunday';

  @override
  String get attendanceDialogTitle => 'Edit counts';

  @override
  String get attendanceDialogAttendedLabel => 'Classes held (already happened)';

  @override
  String get attendanceDialogMissedLabel => 'Absences (missed classes)';

  @override
  String get attendanceDialogCancel => 'Cancel';

  @override
  String get attendanceDialogSave => 'Save';

  @override
  String attendancePresence(int percentage) {
    return 'Attendance: $percentage%';
  }

  @override
  String attendanceAttendedLabel(int count) {
    return 'Classes held: $count';
  }

  @override
  String attendanceMissedLabel(int count) {
    return 'Absences: $count';
  }

  @override
  String get attendanceAddClass => 'Add class';

  @override
  String get attendanceMarkAbsence => 'Mark absence';

  @override
  String get attendanceEditCounts => 'Edit counts';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonReload => 'Reload';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCreate => 'Create';

  @override
  String get activitySectionToday => 'Today';

  @override
  String get activitySectionTomorrow => 'Tomorrow';

  @override
  String get activityMigrationStart => 'Starting color migration...';

  @override
  String activityMigrationDone(int count) {
    return 'Migration finished: $count items updated';
  }

  @override
  String get activityMarkedDone => 'Activity marked as completed';

  @override
  String get activityMarkedPending => 'Activity marked as pending';

  @override
  String get activityDeleteTitle => 'Delete activity';

  @override
  String get activityDeleteMessage => 'Do you want to delete this activity?';

  @override
  String get activityDeleted => 'Activity deleted';

  @override
  String get activityDeleteError => 'Error deleting activity';

  @override
  String get activityFilterPending => 'Pending';

  @override
  String get activityFilterCompleted => 'Completed';

  @override
  String get activityEmptyTitle => 'No activities found';

  @override
  String get activityNewButton => 'New activity';

  @override
  String get activityDialogTitleEdit => 'Edit task';

  @override
  String get activityDialogTitleCreate => 'Create task';

  @override
  String get activityNameHint => 'Name';

  @override
  String get activityStartLabel => 'Start';

  @override
  String get activityEndLabel => 'End';

  @override
  String get activityDeadlineLabel => 'Due date';

  @override
  String get activityCategoryLabel => 'Category';

  @override
  String get activityCategoryAssignment => 'Assignment';

  @override
  String get activityCategoryExam => 'Exam';

  @override
  String get activityDetailsHint => 'Details...';

  @override
  String get activityNameRequired => 'Name is required';

  @override
  String get activityCreateError => 'Error saving activity';

  @override
  String get activitySaveButton => 'Save';

  @override
  String get activityCreateButton => 'Create';

  @override
  String get activityUntitled => 'Untitled';

  @override
  String get activityMenuEdit => 'Edit';

  @override
  String get activityMenuDelete => 'Delete';

  @override
  String get activityMenuMarkComplete => 'Mark as completed';

  @override
  String get activityMenuUnmarkComplete => 'Mark as pending';

  @override
  String activityTimeRange(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get roomsEmptyTitle => 'No courses found';

  @override
  String get roomsNoName => 'Untitled course';

  @override
  String roomsSubtitle(Object group, Object year, Object term) {
    return 'Class $group • $year / $term';
  }

  @override
  String get roomsNewPostTitle => 'New post';

  @override
  String get roomsPostTitleHint => 'Title';

  @override
  String get roomsPostBodyHint => 'Write your question or summary...';

  @override
  String get roomsAttachPdf => 'Attach PDF';

  @override
  String get roomsNoAttachment => 'No attachment';

  @override
  String get roomsAttachmentReadError => 'Could not read the attached file';

  @override
  String roomsAttachmentTooLarge(int maxSize) {
    return 'File too large — maximum allowed is $maxSize MB';
  }

  @override
  String get roomsUploading => 'Uploading...';

  @override
  String get roomsPublishButton => 'Publish';

  @override
  String get roomsDeletePostTitle => 'Delete post';

  @override
  String get roomsDeletePostMessage => 'Do you want to delete this post?';

  @override
  String get roomsDeletePost => 'Delete';

  @override
  String get roomsReplyTitle => 'Reply';

  @override
  String get roomsReplyHint => 'Write your reply...';

  @override
  String get roomsReplyButton => 'Reply';

  @override
  String roomsRepliesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'replies',
      one: 'reply',
    );
    return '$count $_temp0';
  }

  @override
  String get roomsRespondAction => 'Reply';

  @override
  String get roomsNoPosts => 'No posts yet. Create the first one!';

  @override
  String get roomsNewPostFab => 'New post';

  @override
  String get roomsAttachmentDefaultName => 'Attachment.pdf';

  @override
  String get roomsAnonymous => 'Anonymous';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsDefaultTitle => 'Notification';
}
