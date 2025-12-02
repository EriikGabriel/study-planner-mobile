// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Study Planner';

  @override
  String get appTagline =>
      'Plus qu\'un planner, votre allié dans le parcours académique.';

  @override
  String get mandatoryField => 'Champ obligatoire !';

  @override
  String get success => 'Succès';

  @override
  String get userCreated => 'Utilisateur créé';

  @override
  String get error => 'Erreur';

  @override
  String get wrongUserOrPassword => 'Utilisateur ou mot de passe incorrect';

  @override
  String get somethingWrong =>
      'Quelque chose s\'est mal passé. Veuillez réessayer';

  @override
  String get musicForEveryone => 'Musique pour tous';

  @override
  String get username => 'Nom complet';

  @override
  String get password => 'Mot de passe';

  @override
  String get orLabel => ' OU ';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get loginSigninTitle => 'Connectez-vous avec';

  @override
  String get loginSignupTitle => 'Créez votre compte';

  @override
  String get loginEmail => 'E-mail';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginButtonSignup => 'S\'inscrire';

  @override
  String get loginToggleSignup => 'Pas de compte ? Inscrivez-vous';

  @override
  String get loginToggleSignin => 'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get loginSuccess => 'Connexion réalisée avec succès !';

  @override
  String get loginEmailRequired => 'L\'e-mail est obligatoire';

  @override
  String get loginPasswordRequired => 'Le mot de passe est obligatoire';

  @override
  String get loginInvalidEmail => 'E-mail invalide';

  @override
  String get loginInvalidCredentials =>
      'E-mail ou mot de passe invalide. Vérifiez vos données.';

  @override
  String get loginUserNotFound =>
      'Utilisateur introuvable. Inscrivez-vous d\'abord.';

  @override
  String get loginWrongPassword => 'Mot de passe incorrect. Réessayez.';

  @override
  String get loginUserDisabled =>
      'Utilisateur désactivé. Contactez le support.';

  @override
  String get loginTooManyRequests =>
      'Trop de tentatives de connexion. Réessayez plus tard.';

  @override
  String get loginGenericError => 'Erreur lors de la connexion';

  @override
  String get loginConnectionError => 'Erreur de connexion';

  @override
  String get signupUsernameRequired => 'Le nom d\'utilisateur est obligatoire';

  @override
  String get signupPasswordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get signupAccountCreationError =>
      'E-mail déjà enregistré ou erreur lors de la création du compte';

  @override
  String get signupUfscarInvalidCredentials =>
      'E-mail ou mot de passe invalide sur la plateforme UFSCar.';

  @override
  String get signupSaveDataError =>
      'Erreur lors de l\'enregistrement des données. Réessayez.';

  @override
  String get signupGenericError => 'Erreur lors de la création du compte';

  @override
  String get signupEmailAlreadyExists => 'Cet e-mail est déjà enregistré';

  @override
  String get signupWeakPassword =>
      'Mot de passe trop faible. Utilisez au moins 6 caractères.';

  @override
  String get signupOperationNotAllowed =>
      'Opération non autorisée. Réessayez plus tard.';

  @override
  String get signupApiConnectionError => 'Erreur de connexion à l\'API';

  @override
  String get settingsAppearanceSection => 'Apparence';

  @override
  String get settingsAccountSection => 'Compte';

  @override
  String get settingsAboutSection => 'À propos';

  @override
  String get settingsEditProfile => 'Modifier le profil';

  @override
  String get settingsChangePassword => 'Changer le mot de passe';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsComingSoon => 'En développement';

  @override
  String get settingsAutoPresenceTitle => 'Présence automatique';

  @override
  String get settingsAutoPresenceSubtitle =>
      'Marquer automatiquement la présence dans les nouvelles matières';

  @override
  String get settingsAutoPresenceSaveError =>
      'Erreur lors de l\'enregistrement';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageDialogTitle => 'Sélectionner la langue';

  @override
  String get settingsAboutApp => 'À propos de l\'application';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsTermsOfUse => 'Conditions d\'utilisation';

  @override
  String get settingsLogoutButton => 'Se déconnecter';

  @override
  String get settingsLogoutTitle => 'Se déconnecter';

  @override
  String get settingsLogoutMessage => 'Êtes-vous sûr de vouloir quitter ?';

  @override
  String get settingsLogoutCancel => 'Annuler';

  @override
  String get settingsLogoutConfirm => 'Quitter';

  @override
  String get settingsThemeTitle => 'Mode sombre';

  @override
  String get settingsThemeEnabled => 'Activé';

  @override
  String get settingsThemeDisabled => 'Désactivé';

  @override
  String get languagePortuguese => 'Portugais';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageChinese => 'Chinois';

  @override
  String get mainTabAgenda => 'Agenda';

  @override
  String get mainTabActivities => 'Activités';

  @override
  String get mainTabRooms => 'Salles';

  @override
  String get mainTabNotifications => 'Notifications';

  @override
  String get mainTabSettings => 'Paramètres';

  @override
  String get agendaFilterAll => 'Tous';

  @override
  String get agendaDefaultSectionTitle => 'Mes matières';

  @override
  String get agendaClearFilter => 'Voir tout';

  @override
  String get agendaGoToToday => 'Aujourd\'hui';

  @override
  String get agendaEmptyTitle => 'Aucune matière trouvée';

  @override
  String get agendaEmptyAction => 'Recharger';

  @override
  String get agendaEmptyDayTitle => 'Aucune matière ce jour-là';

  @override
  String get agendaEmptyDayAction => 'Voir toutes les matières';

  @override
  String agendaSubjectsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'matières',
      one: 'matière',
    );
    return '($count $_temp0)';
  }

  @override
  String get agendaNoSchedule => 'Horaire non défini';

  @override
  String agendaClassLabel(Object group, Object year, Object term) {
    return 'Groupe $group • $year/$term';
  }

  @override
  String get agendaNoName => 'Sans nom';

  @override
  String get agendaNoDayDefined => 'Aucun jour défini';

  @override
  String get agendaDayMonday => 'Lundi';

  @override
  String get agendaDayTuesday => 'Mardi';

  @override
  String get agendaDayWednesday => 'Mercredi';

  @override
  String get agendaDayThursday => 'Jeudi';

  @override
  String get agendaDayFriday => 'Vendredi';

  @override
  String get agendaDaySaturday => 'Samedi';

  @override
  String get agendaDaySunday => 'Dimanche';

  @override
  String get attendanceDialogTitle => 'Modifier les compteurs';

  @override
  String get attendanceDialogAttendedLabel => 'Cours réalisés (déjà effectués)';

  @override
  String get attendanceDialogMissedLabel => 'Absences (cours manqués)';

  @override
  String get attendanceDialogCancel => 'Annuler';

  @override
  String get attendanceDialogSave => 'Enregistrer';

  @override
  String attendancePresence(int percentage) {
    return 'Présence : $percentage%';
  }

  @override
  String attendanceAttendedLabel(int count) {
    return 'Cours réalisés : $count';
  }

  @override
  String attendanceMissedLabel(int count) {
    return 'Absences : $count';
  }

  @override
  String get attendanceAddClass => 'Ajouter un cours';

  @override
  String get attendanceMarkAbsence => 'Marquer une absence';

  @override
  String get attendanceEditCounts => 'Modifier les compteurs';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonUndo => 'Annuler l\'action';

  @override
  String get commonReload => 'Recharger';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonCreate => 'Créer';

  @override
  String get activitySectionToday => 'Aujourd\'hui';

  @override
  String get activitySectionTomorrow => 'Demain';

  @override
  String get activityMigrationStart => 'Début de la migration des couleurs...';

  @override
  String activityMigrationDone(int count) {
    return 'Migration terminée : $count éléments mis à jour';
  }

  @override
  String get activityMarkedDone => 'Activité marquée comme terminée';

  @override
  String get activityMarkedPending => 'Activité marquée comme en attente';

  @override
  String get activityDeleteTitle => 'Supprimer l\'activité';

  @override
  String get activityDeleteMessage => 'Voulez-vous supprimer cette activité ?';

  @override
  String get activityDeleted => 'Activité supprimée';

  @override
  String get activityDeleteError =>
      'Erreur lors de la suppression de l\'activité';

  @override
  String get activityFilterPending => 'En attente';

  @override
  String get activityFilterCompleted => 'Terminées';

  @override
  String get activityEmptyTitle => 'Aucune activité trouvée';

  @override
  String get activityNewButton => 'Nouvelle activité';

  @override
  String get activityDialogTitleEdit => 'Modifier la tâche';

  @override
  String get activityDialogTitleCreate => 'Créer une tâche';

  @override
  String get activityNameHint => 'Nom';

  @override
  String get activityStartLabel => 'Début';

  @override
  String get activityEndLabel => 'Fin';

  @override
  String get activityDeadlineLabel => 'Échéance';

  @override
  String get activityCategoryLabel => 'Catégorie';

  @override
  String get activityCategoryAssignment => 'Activité';

  @override
  String get activityCategoryExam => 'Examen';

  @override
  String get activityDetailsHint => 'Détails...';

  @override
  String get activityNameRequired => 'Le nom est obligatoire';

  @override
  String get activityCreateError =>
      'Erreur lors de l\'enregistrement de l\'activité';

  @override
  String get activitySaveButton => 'Enregistrer';

  @override
  String get activityCreateButton => 'Créer';

  @override
  String get activityUntitled => 'Sans titre';

  @override
  String get activityMenuEdit => 'Modifier';

  @override
  String get activityMenuDelete => 'Supprimer';

  @override
  String get activityMenuMarkComplete => 'Marquer comme terminée';

  @override
  String get activityMenuUnmarkComplete => 'Marquer comme en attente';

  @override
  String activityTimeRange(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get roomsEmptyTitle => 'Aucune matière trouvée';

  @override
  String get roomsNoName => 'Matière sans nom';

  @override
  String roomsSubtitle(Object group, Object year, Object term) {
    return 'Groupe $group • $year / $term';
  }

  @override
  String get roomsNewPostTitle => 'Nouveau post';

  @override
  String get roomsPostTitleHint => 'Titre';

  @override
  String get roomsPostBodyHint => 'Écrivez votre question ou résumé...';

  @override
  String get roomsAttachPdf => 'Joindre un PDF';

  @override
  String get roomsNoAttachment => 'Aucune pièce jointe';

  @override
  String get roomsAttachmentReadError => 'Impossible de lire le fichier joint';

  @override
  String roomsAttachmentTooLarge(int maxSize) {
    return 'Fichier trop volumineux — taille maximale $maxSize Mo';
  }

  @override
  String get roomsUploading => 'Téléversement...';

  @override
  String get roomsPublishButton => 'Publier';

  @override
  String get roomsDeletePostTitle => 'Supprimer le post';

  @override
  String get roomsDeletePostMessage => 'Voulez-vous supprimer ce post ?';

  @override
  String get roomsDeletePost => 'Supprimer';

  @override
  String get roomsReplyTitle => 'Répondre';

  @override
  String get roomsReplyHint => 'Écrivez votre réponse...';

  @override
  String get roomsReplyButton => 'Répondre';

  @override
  String roomsRepliesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'réponses',
      one: 'réponse',
    );
    return '$count $_temp0';
  }

  @override
  String get roomsRespondAction => 'Répondre';

  @override
  String get roomsNoPosts => 'Aucun post pour le moment. Créez le premier !';

  @override
  String get roomsNewPostFab => 'Nouveau post';

  @override
  String get roomsAttachmentDefaultName => 'Piece-jointe.pdf';

  @override
  String get roomsAnonymous => 'Anonyme';

  @override
  String get notificationsEmptyTitle => 'Aucune notification';

  @override
  String get notificationsDefaultTitle => 'Notification';
}
