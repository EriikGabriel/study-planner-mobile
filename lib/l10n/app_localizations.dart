import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Study Planner'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In pt, this message translates to:
  /// **'Mais que um planner, seu aliado na jornada acadêmica.'**
  String get appTagline;

  /// No description provided for @mandatoryField.
  ///
  /// In pt, this message translates to:
  /// **'Campo obrigatório!'**
  String get mandatoryField;

  /// No description provided for @success.
  ///
  /// In pt, this message translates to:
  /// **'Sucesso'**
  String get success;

  /// No description provided for @userCreated.
  ///
  /// In pt, this message translates to:
  /// **'Usuário criado'**
  String get userCreated;

  /// No description provided for @error.
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;

  /// No description provided for @wrongUserOrPassword.
  ///
  /// In pt, this message translates to:
  /// **'Usuário ou senha incorretos'**
  String get wrongUserOrPassword;

  /// No description provided for @somethingWrong.
  ///
  /// In pt, this message translates to:
  /// **'Algo deu errado. Por favor, tente novamente'**
  String get somethingWrong;

  /// No description provided for @musicForEveryone.
  ///
  /// In pt, this message translates to:
  /// **'Música para todos'**
  String get musicForEveryone;

  /// No description provided for @username.
  ///
  /// In pt, this message translates to:
  /// **'Nome completo'**
  String get username;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @orLabel.
  ///
  /// In pt, this message translates to:
  /// **' OU '**
  String get orLabel;

  /// No description provided for @continueWithGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Continuar com o Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Já tem uma conta? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginSigninTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com'**
  String get loginSigninTitle;

  /// No description provided for @loginSignupTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastre-se'**
  String get loginSignupTitle;

  /// No description provided for @loginEmail.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @loginButtonSignup.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get loginButtonSignup;

  /// No description provided for @loginToggleSignup.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta? Cadastre-se'**
  String get loginToggleSignup;

  /// No description provided for @loginToggleSignin.
  ///
  /// In pt, this message translates to:
  /// **'Já tem uma conta? Entrar'**
  String get loginToggleSignin;

  /// No description provided for @loginSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Login realizado com sucesso!'**
  String get loginSuccess;

  /// No description provided for @loginEmailRequired.
  ///
  /// In pt, this message translates to:
  /// **'Email é obrigatório'**
  String get loginEmailRequired;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In pt, this message translates to:
  /// **'Senha é obrigatória'**
  String get loginPasswordRequired;

  /// No description provided for @loginInvalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'Email inválido'**
  String get loginInvalidEmail;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In pt, this message translates to:
  /// **'Email ou senha inválidos. Verifique seus dados.'**
  String get loginInvalidCredentials;

  /// No description provided for @loginUserNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Usuário não encontrado. Faça o cadastro primeiro.'**
  String get loginUserNotFound;

  /// No description provided for @loginWrongPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha incorreta. Tente novamente.'**
  String get loginWrongPassword;

  /// No description provided for @loginUserDisabled.
  ///
  /// In pt, this message translates to:
  /// **'Usuário desativado. Entre em contato com o suporte.'**
  String get loginUserDisabled;

  /// No description provided for @loginTooManyRequests.
  ///
  /// In pt, this message translates to:
  /// **'Muitas tentativas de login. Tente mais tarde.'**
  String get loginTooManyRequests;

  /// No description provided for @loginGenericError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao fazer login'**
  String get loginGenericError;

  /// No description provided for @loginConnectionError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao conectar'**
  String get loginConnectionError;

  /// No description provided for @signupUsernameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Nome de usuário é obrigatório'**
  String get signupUsernameRequired;

  /// No description provided for @signupPasswordTooShort.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter pelo menos 6 caracteres'**
  String get signupPasswordTooShort;

  /// No description provided for @signupAccountCreationError.
  ///
  /// In pt, this message translates to:
  /// **'Email já cadastrado ou erro ao criar conta'**
  String get signupAccountCreationError;

  /// No description provided for @signupUfscarInvalidCredentials.
  ///
  /// In pt, this message translates to:
  /// **'Email ou senha inválidos na plataforma UFSCar.'**
  String get signupUfscarInvalidCredentials;

  /// No description provided for @signupSaveDataError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar dados. Tente novamente.'**
  String get signupSaveDataError;

  /// No description provided for @signupGenericError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao criar conta'**
  String get signupGenericError;

  /// No description provided for @signupEmailAlreadyExists.
  ///
  /// In pt, this message translates to:
  /// **'Este email já está cadastrado'**
  String get signupEmailAlreadyExists;

  /// No description provided for @signupWeakPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha muito fraca. Use pelo menos 6 caracteres.'**
  String get signupWeakPassword;

  /// No description provided for @signupOperationNotAllowed.
  ///
  /// In pt, this message translates to:
  /// **'Operação não permitida. Tente novamente mais tarde.'**
  String get signupOperationNotAllowed;

  /// No description provided for @signupApiConnectionError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao conectar com a API'**
  String get signupApiConnectionError;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In pt, this message translates to:
  /// **'Aparência'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsAccountSection.
  ///
  /// In pt, this message translates to:
  /// **'Conta'**
  String get settingsAccountSection;

  /// No description provided for @settingsAboutSection.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get settingsAboutSection;

  /// No description provided for @settingsEditProfile.
  ///
  /// In pt, this message translates to:
  /// **'Editar Perfil'**
  String get settingsEditProfile;

  /// No description provided for @settingsChangePassword.
  ///
  /// In pt, this message translates to:
  /// **'Alterar Senha'**
  String get settingsChangePassword;

  /// No description provided for @settingsNotifications.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get settingsNotifications;

  /// No description provided for @settingsComingSoon.
  ///
  /// In pt, this message translates to:
  /// **'Em desenvolvimento'**
  String get settingsComingSoon;

  /// No description provided for @settingsAutoPresenceTitle.
  ///
  /// In pt, this message translates to:
  /// **'Presença automática'**
  String get settingsAutoPresenceTitle;

  /// No description provided for @settingsAutoPresenceSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Marcar presença automaticamente em novas disciplinas'**
  String get settingsAutoPresenceSubtitle;

  /// No description provided for @settingsAutoPresenceSaveError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar configuração'**
  String get settingsAutoPresenceSaveError;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageDialogTitle.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar Idioma'**
  String get settingsLanguageDialogTitle;

  /// No description provided for @settingsAboutApp.
  ///
  /// In pt, this message translates to:
  /// **'Sobre o App'**
  String get settingsAboutApp;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfUse.
  ///
  /// In pt, this message translates to:
  /// **'Termos de Uso'**
  String get settingsTermsOfUse;

  /// No description provided for @settingsLogoutButton.
  ///
  /// In pt, this message translates to:
  /// **'Sair da Conta'**
  String get settingsLogoutButton;

  /// No description provided for @settingsLogoutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sair da Conta'**
  String get settingsLogoutTitle;

  /// No description provided for @settingsLogoutMessage.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja sair?'**
  String get settingsLogoutMessage;

  /// No description provided for @settingsLogoutCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get settingsLogoutCancel;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Modo Escuro'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeEnabled.
  ///
  /// In pt, this message translates to:
  /// **'Ativado'**
  String get settingsThemeEnabled;

  /// No description provided for @settingsThemeDisabled.
  ///
  /// In pt, this message translates to:
  /// **'Desativado'**
  String get settingsThemeDisabled;

  /// No description provided for @languagePortuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageEnglish.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In pt, this message translates to:
  /// **'Espanhol'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In pt, this message translates to:
  /// **'Francês'**
  String get languageFrench;

  /// No description provided for @languageChinese.
  ///
  /// In pt, this message translates to:
  /// **'Chinês'**
  String get languageChinese;

  /// No description provided for @mainTabAgenda.
  ///
  /// In pt, this message translates to:
  /// **'Agenda'**
  String get mainTabAgenda;

  /// No description provided for @mainTabActivities.
  ///
  /// In pt, this message translates to:
  /// **'Atividades'**
  String get mainTabActivities;

  /// No description provided for @mainTabRooms.
  ///
  /// In pt, this message translates to:
  /// **'Salas'**
  String get mainTabRooms;

  /// No description provided for @mainTabNotifications.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get mainTabNotifications;

  /// No description provided for @mainTabSettings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get mainTabSettings;

  /// No description provided for @agendaFilterAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get agendaFilterAll;

  /// No description provided for @agendaDefaultSectionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Minhas matérias'**
  String get agendaDefaultSectionTitle;

  /// No description provided for @agendaClearFilter.
  ///
  /// In pt, this message translates to:
  /// **'Ver todos'**
  String get agendaClearFilter;

  /// No description provided for @agendaGoToToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get agendaGoToToday;

  /// No description provided for @agendaEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma matéria encontrada'**
  String get agendaEmptyTitle;

  /// No description provided for @agendaEmptyAction.
  ///
  /// In pt, this message translates to:
  /// **'Recarregar'**
  String get agendaEmptyAction;

  /// No description provided for @agendaEmptyDayTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma matéria neste dia'**
  String get agendaEmptyDayTitle;

  /// No description provided for @agendaEmptyDayAction.
  ///
  /// In pt, this message translates to:
  /// **'Ver todas as matérias'**
  String get agendaEmptyDayAction;

  /// No description provided for @agendaSubjectsCount.
  ///
  /// In pt, this message translates to:
  /// **'({count} {count, plural, one {matéria} other {matérias}})'**
  String agendaSubjectsCount(int count);

  /// No description provided for @agendaNoSchedule.
  ///
  /// In pt, this message translates to:
  /// **'Horário não definido'**
  String get agendaNoSchedule;

  /// No description provided for @agendaClassLabel.
  ///
  /// In pt, this message translates to:
  /// **'Turma {group} • {year}/{term}'**
  String agendaClassLabel(Object group, Object year, Object term);

  /// No description provided for @agendaNoName.
  ///
  /// In pt, this message translates to:
  /// **'Sem nome'**
  String get agendaNoName;

  /// No description provided for @agendaNoDayDefined.
  ///
  /// In pt, this message translates to:
  /// **'Sem dia definido'**
  String get agendaNoDayDefined;

  /// No description provided for @agendaDayMonday.
  ///
  /// In pt, this message translates to:
  /// **'Segunda-feira'**
  String get agendaDayMonday;

  /// No description provided for @agendaDayTuesday.
  ///
  /// In pt, this message translates to:
  /// **'Terça-feira'**
  String get agendaDayTuesday;

  /// No description provided for @agendaDayWednesday.
  ///
  /// In pt, this message translates to:
  /// **'Quarta-feira'**
  String get agendaDayWednesday;

  /// No description provided for @agendaDayThursday.
  ///
  /// In pt, this message translates to:
  /// **'Quinta-feira'**
  String get agendaDayThursday;

  /// No description provided for @agendaDayFriday.
  ///
  /// In pt, this message translates to:
  /// **'Sexta-feira'**
  String get agendaDayFriday;

  /// No description provided for @agendaDaySaturday.
  ///
  /// In pt, this message translates to:
  /// **'Sábado'**
  String get agendaDaySaturday;

  /// No description provided for @agendaDaySunday.
  ///
  /// In pt, this message translates to:
  /// **'Domingo'**
  String get agendaDaySunday;

  /// No description provided for @attendanceDialogTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar contagem'**
  String get attendanceDialogTitle;

  /// No description provided for @attendanceDialogAttendedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Aulas realizadas (já ocorridas)'**
  String get attendanceDialogAttendedLabel;

  /// No description provided for @attendanceDialogMissedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Faltas (aulas perdidas)'**
  String get attendanceDialogMissedLabel;

  /// No description provided for @attendanceDialogCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get attendanceDialogCancel;

  /// No description provided for @attendanceDialogSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get attendanceDialogSave;

  /// No description provided for @attendancePresence.
  ///
  /// In pt, this message translates to:
  /// **'Presença: {percentage}%'**
  String attendancePresence(int percentage);

  /// No description provided for @attendanceAttendedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Aulas realizadas: {count}'**
  String attendanceAttendedLabel(int count);

  /// No description provided for @attendanceMissedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Faltas: {count}'**
  String attendanceMissedLabel(int count);

  /// No description provided for @attendanceAddClass.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar aula'**
  String get attendanceAddClass;

  /// No description provided for @attendanceMarkAbsence.
  ///
  /// In pt, this message translates to:
  /// **'Marcar falta'**
  String get attendanceMarkAbsence;

  /// No description provided for @attendanceEditCounts.
  ///
  /// In pt, this message translates to:
  /// **'Editar contagem'**
  String get attendanceEditCounts;

  /// No description provided for @commonCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get commonDelete;

  /// No description provided for @commonUndo.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer'**
  String get commonUndo;

  /// No description provided for @commonReload.
  ///
  /// In pt, this message translates to:
  /// **'Recarregar'**
  String get commonReload;

  /// No description provided for @commonConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get commonSave;

  /// No description provided for @commonCreate.
  ///
  /// In pt, this message translates to:
  /// **'Criar'**
  String get commonCreate;

  /// No description provided for @activitySectionToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get activitySectionToday;

  /// No description provided for @activitySectionTomorrow.
  ///
  /// In pt, this message translates to:
  /// **'Amanhã'**
  String get activitySectionTomorrow;

  /// No description provided for @activityMigrationStart.
  ///
  /// In pt, this message translates to:
  /// **'Iniciando migração de cores...'**
  String get activityMigrationStart;

  /// No description provided for @activityMigrationDone.
  ///
  /// In pt, this message translates to:
  /// **'Migração concluída: {count} itens atualizados'**
  String activityMigrationDone(int count);

  /// No description provided for @activityMarkedDone.
  ///
  /// In pt, this message translates to:
  /// **'Atividade marcada como concluída'**
  String get activityMarkedDone;

  /// No description provided for @activityMarkedPending.
  ///
  /// In pt, this message translates to:
  /// **'Atividade marcada como pendente'**
  String get activityMarkedPending;

  /// No description provided for @activityDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir atividade'**
  String get activityDeleteTitle;

  /// No description provided for @activityDeleteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir esta atividade?'**
  String get activityDeleteMessage;

  /// No description provided for @activityDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Atividade excluída'**
  String get activityDeleted;

  /// No description provided for @activityDeleteError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao excluir atividade'**
  String get activityDeleteError;

  /// No description provided for @activityFilterPending.
  ///
  /// In pt, this message translates to:
  /// **'Pendentes'**
  String get activityFilterPending;

  /// No description provided for @activityFilterCompleted.
  ///
  /// In pt, this message translates to:
  /// **'Concluídas'**
  String get activityFilterCompleted;

  /// No description provided for @activityEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma atividade encontrada'**
  String get activityEmptyTitle;

  /// No description provided for @activityNewButton.
  ///
  /// In pt, this message translates to:
  /// **'Nova atividade'**
  String get activityNewButton;

  /// No description provided for @activityDialogTitleEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar tarefa'**
  String get activityDialogTitleEdit;

  /// No description provided for @activityDialogTitleCreate.
  ///
  /// In pt, this message translates to:
  /// **'Criar tarefa'**
  String get activityDialogTitleCreate;

  /// No description provided for @activityNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get activityNameHint;

  /// No description provided for @activityStartLabel.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get activityStartLabel;

  /// No description provided for @activityEndLabel.
  ///
  /// In pt, this message translates to:
  /// **'Término'**
  String get activityEndLabel;

  /// No description provided for @activityDeadlineLabel.
  ///
  /// In pt, this message translates to:
  /// **'Prazo'**
  String get activityDeadlineLabel;

  /// No description provided for @activityCategoryLabel.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get activityCategoryLabel;

  /// No description provided for @activityCategoryAssignment.
  ///
  /// In pt, this message translates to:
  /// **'Atividade'**
  String get activityCategoryAssignment;

  /// No description provided for @activityCategoryExam.
  ///
  /// In pt, this message translates to:
  /// **'Prova'**
  String get activityCategoryExam;

  /// No description provided for @activityDetailsHint.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes...'**
  String get activityDetailsHint;

  /// No description provided for @activityNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Nome é obrigatório'**
  String get activityNameRequired;

  /// No description provided for @activityCreateError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao salvar atividade'**
  String get activityCreateError;

  /// No description provided for @activitySaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get activitySaveButton;

  /// No description provided for @activityCreateButton.
  ///
  /// In pt, this message translates to:
  /// **'Criar'**
  String get activityCreateButton;

  /// No description provided for @activityUntitled.
  ///
  /// In pt, this message translates to:
  /// **'Sem título'**
  String get activityUntitled;

  /// No description provided for @activityMenuEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get activityMenuEdit;

  /// No description provided for @activityMenuDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get activityMenuDelete;

  /// No description provided for @activityMenuMarkComplete.
  ///
  /// In pt, this message translates to:
  /// **'Marcar como concluída'**
  String get activityMenuMarkComplete;

  /// No description provided for @activityMenuUnmarkComplete.
  ///
  /// In pt, this message translates to:
  /// **'Marcar como pendente'**
  String get activityMenuUnmarkComplete;

  /// No description provided for @activityTimeRange.
  ///
  /// In pt, this message translates to:
  /// **'{start} - {end}'**
  String activityTimeRange(Object start, Object end);

  /// No description provided for @roomsEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma disciplina encontrada'**
  String get roomsEmptyTitle;

  /// No description provided for @roomsNoName.
  ///
  /// In pt, this message translates to:
  /// **'Disciplina sem nome'**
  String get roomsNoName;

  /// No description provided for @roomsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Turma {group} • {year} / {term}'**
  String roomsSubtitle(Object group, Object year, Object term);

  /// No description provided for @roomsNewPostTitle.
  ///
  /// In pt, this message translates to:
  /// **'Novo post'**
  String get roomsNewPostTitle;

  /// No description provided for @roomsPostTitleHint.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get roomsPostTitleHint;

  /// No description provided for @roomsPostBodyHint.
  ///
  /// In pt, this message translates to:
  /// **'Escreva sua pergunta ou resumo...'**
  String get roomsPostBodyHint;

  /// No description provided for @roomsAttachPdf.
  ///
  /// In pt, this message translates to:
  /// **'Anexar PDF'**
  String get roomsAttachPdf;

  /// No description provided for @roomsNoAttachment.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum anexo'**
  String get roomsNoAttachment;

  /// No description provided for @roomsAttachmentReadError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível ler o arquivo anexado'**
  String get roomsAttachmentReadError;

  /// No description provided for @roomsAttachmentTooLarge.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo muito grande — máximo permitido: {maxSize} MB'**
  String roomsAttachmentTooLarge(int maxSize);

  /// No description provided for @roomsUploading.
  ///
  /// In pt, this message translates to:
  /// **'Enviando...'**
  String get roomsUploading;

  /// No description provided for @roomsPublishButton.
  ///
  /// In pt, this message translates to:
  /// **'Publicar'**
  String get roomsPublishButton;

  /// No description provided for @roomsDeletePostTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir post'**
  String get roomsDeletePostTitle;

  /// No description provided for @roomsDeletePostMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir este post?'**
  String get roomsDeletePostMessage;

  /// No description provided for @roomsDeletePost.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get roomsDeletePost;

  /// No description provided for @roomsReplyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Responder'**
  String get roomsReplyTitle;

  /// No description provided for @roomsReplyHint.
  ///
  /// In pt, this message translates to:
  /// **'Escreva sua resposta...'**
  String get roomsReplyHint;

  /// No description provided for @roomsReplyButton.
  ///
  /// In pt, this message translates to:
  /// **'Responder'**
  String get roomsReplyButton;

  /// No description provided for @roomsRepliesCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} {count, plural, one {resposta} other {respostas}}'**
  String roomsRepliesCount(int count);

  /// No description provided for @roomsRespondAction.
  ///
  /// In pt, this message translates to:
  /// **'Responder'**
  String get roomsRespondAction;

  /// No description provided for @roomsNoPosts.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum post ainda. Crie o primeiro!'**
  String get roomsNoPosts;

  /// No description provided for @roomsNewPostFab.
  ///
  /// In pt, this message translates to:
  /// **'Novo post'**
  String get roomsNewPostFab;

  /// No description provided for @roomsAttachmentDefaultName.
  ///
  /// In pt, this message translates to:
  /// **'Anexo.pdf'**
  String get roomsAttachmentDefaultName;

  /// No description provided for @roomsAnonymous.
  ///
  /// In pt, this message translates to:
  /// **'Anônimo'**
  String get roomsAnonymous;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma notificação'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsDefaultTitle.
  ///
  /// In pt, this message translates to:
  /// **'Notificação'**
  String get notificationsDefaultTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
