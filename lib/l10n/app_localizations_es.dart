// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Study Planner';

  @override
  String get appTagline =>
      'Más que un planner, tu aliado en la jornada académica.';

  @override
  String get mandatoryField => '¡Campo obligatorio!';

  @override
  String get success => 'Éxito';

  @override
  String get userCreated => 'Usuario creado';

  @override
  String get error => 'Error';

  @override
  String get wrongUserOrPassword => 'Usuario o contraseña incorrectos';

  @override
  String get somethingWrong => 'Algo salió mal. Por favor, inténtalo de nuevo';

  @override
  String get musicForEveryone => 'Música para todos';

  @override
  String get username => 'Nombre completo';

  @override
  String get password => 'Contraseña';

  @override
  String get orLabel => ' O ';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta? ';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get loginSigninTitle => 'Inicia sesión con';

  @override
  String get loginSignupTitle => 'Crea tu cuenta';

  @override
  String get loginEmail => 'Correo electrónico';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginButtonSignup => 'Registrarse';

  @override
  String get loginToggleSignup => '¿No tienes una cuenta? Regístrate';

  @override
  String get loginToggleSignin => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get loginSuccess => '¡Inicio de sesión exitoso!';

  @override
  String get loginEmailRequired => 'El correo electrónico es obligatorio';

  @override
  String get loginPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get loginInvalidEmail => 'Correo electrónico inválido';

  @override
  String get loginInvalidCredentials =>
      'Correo electrónico o contraseña inválidos. Verifica tus datos.';

  @override
  String get loginUserNotFound => 'Usuario no encontrado. Regístrate primero.';

  @override
  String get loginWrongPassword => 'Contraseña incorrecta. Inténtalo de nuevo.';

  @override
  String get loginUserDisabled => 'Usuario deshabilitado. Contacta al soporte.';

  @override
  String get loginTooManyRequests =>
      'Demasiados intentos de inicio de sesión. Intenta más tarde.';

  @override
  String get loginGenericError => 'Error al iniciar sesión';

  @override
  String get loginConnectionError => 'Error de conexión';

  @override
  String get signupUsernameRequired => 'El nombre de usuario es obligatorio';

  @override
  String get signupPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get signupAccountCreationError =>
      'Correo ya registrado o error al crear la cuenta';

  @override
  String get signupUfscarInvalidCredentials =>
      'Correo o contraseña inválidos en la plataforma UFSCar.';

  @override
  String get signupSaveDataError =>
      'Error al guardar los datos. Inténtalo de nuevo.';

  @override
  String get signupGenericError => 'Error al crear la cuenta';

  @override
  String get signupEmailAlreadyExists => 'Este correo ya está registrado';

  @override
  String get signupWeakPassword =>
      'Contraseña muy débil. Usa al menos 6 caracteres.';

  @override
  String get signupOperationNotAllowed =>
      'Operación no permitida. Inténtalo más tarde.';

  @override
  String get signupApiConnectionError => 'Error al conectar con la API';

  @override
  String get settingsAppearanceSection => 'Apariencia';

  @override
  String get settingsAccountSection => 'Cuenta';

  @override
  String get settingsAboutSection => 'Acerca de';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsChangePassword => 'Cambiar contraseña';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsComingSoon => 'En desarrollo';

  @override
  String get settingsAutoPresenceTitle => 'Asistencia automática';

  @override
  String get settingsAutoPresenceSubtitle =>
      'Marcar asistencia automáticamente en nuevas materias';

  @override
  String get settingsAutoPresenceSaveError =>
      'Error al guardar la configuración';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageDialogTitle => 'Seleccionar idioma';

  @override
  String get settingsAboutApp => 'Sobre la app';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsTermsOfUse => 'Términos de uso';

  @override
  String get settingsLogoutButton => 'Cerrar sesión';

  @override
  String get settingsLogoutTitle => 'Cerrar sesión';

  @override
  String get settingsLogoutMessage => '¿Seguro que deseas salir?';

  @override
  String get settingsLogoutCancel => 'Cancelar';

  @override
  String get settingsLogoutConfirm => 'Salir';

  @override
  String get settingsThemeTitle => 'Modo oscuro';

  @override
  String get settingsThemeEnabled => 'Activado';

  @override
  String get settingsThemeDisabled => 'Desactivado';

  @override
  String get languagePortuguese => 'Portugués';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Francés';

  @override
  String get languageChinese => 'Chino';

  @override
  String get mainTabAgenda => 'Agenda';

  @override
  String get mainTabActivities => 'Actividades';

  @override
  String get mainTabRooms => 'Salas';

  @override
  String get mainTabNotifications => 'Notificaciones';

  @override
  String get mainTabSettings => 'Configuración';

  @override
  String get agendaFilterAll => 'Todos';

  @override
  String get agendaDefaultSectionTitle => 'Mis materias';

  @override
  String get agendaClearFilter => 'Ver todo';

  @override
  String get agendaGoToToday => 'Hoy';

  @override
  String get agendaEmptyTitle => 'No se encontraron materias';

  @override
  String get agendaEmptyAction => 'Recargar';

  @override
  String get agendaEmptyDayTitle => 'No hay materias en este día';

  @override
  String get agendaEmptyDayAction => 'Ver todas las materias';

  @override
  String agendaSubjectsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'materias',
      one: 'materia',
    );
    return '($count $_temp0)';
  }

  @override
  String get agendaNoSchedule => 'Horario no definido';

  @override
  String agendaClassLabel(Object group, Object year, Object term) {
    return 'Clase $group • $year/$term';
  }

  @override
  String get agendaNoName => 'Sin nombre';

  @override
  String get agendaNoDayDefined => 'Sin día definido';

  @override
  String get agendaDayMonday => 'Lunes';

  @override
  String get agendaDayTuesday => 'Martes';

  @override
  String get agendaDayWednesday => 'Miércoles';

  @override
  String get agendaDayThursday => 'Jueves';

  @override
  String get agendaDayFriday => 'Viernes';

  @override
  String get agendaDaySaturday => 'Sábado';

  @override
  String get agendaDaySunday => 'Domingo';

  @override
  String get attendanceDialogTitle => 'Editar conteo';

  @override
  String get attendanceDialogAttendedLabel =>
      'Clases realizadas (ya ocurridas)';

  @override
  String get attendanceDialogMissedLabel => 'Faltas (clases perdidas)';

  @override
  String get attendanceDialogCancel => 'Cancelar';

  @override
  String get attendanceDialogSave => 'Guardar';

  @override
  String attendancePresence(int percentage) {
    return 'Asistencia: $percentage%';
  }

  @override
  String attendanceAttendedLabel(int count) {
    return 'Clases realizadas: $count';
  }

  @override
  String attendanceMissedLabel(int count) {
    return 'Faltas: $count';
  }

  @override
  String get attendanceAddClass => 'Agregar clase';

  @override
  String get attendanceMarkAbsence => 'Marcar falta';

  @override
  String get attendanceEditCounts => 'Editar conteo';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonUndo => 'Deshacer';

  @override
  String get commonReload => 'Recargar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonCreate => 'Crear';

  @override
  String get activitySectionToday => 'Hoy';

  @override
  String get activitySectionTomorrow => 'Mañana';

  @override
  String get activityMigrationStart => 'Iniciando migración de colores...';

  @override
  String activityMigrationDone(int count) {
    return 'Migración finalizada: $count elementos actualizados';
  }

  @override
  String get activityMarkedDone => 'Actividad marcada como completada';

  @override
  String get activityMarkedPending => 'Actividad marcada como pendiente';

  @override
  String get activityDeleteTitle => 'Eliminar actividad';

  @override
  String get activityDeleteMessage => '¿Desea eliminar esta actividad?';

  @override
  String get activityDeleted => 'Actividad eliminada';

  @override
  String get activityDeleteError => 'Error al eliminar la actividad';

  @override
  String get activityFilterPending => 'Pendientes';

  @override
  String get activityFilterCompleted => 'Completadas';

  @override
  String get activityEmptyTitle => 'No se encontraron actividades';

  @override
  String get activityNewButton => 'Nueva actividad';

  @override
  String get activityDialogTitleEdit => 'Editar tarea';

  @override
  String get activityDialogTitleCreate => 'Crear tarea';

  @override
  String get activityNameHint => 'Nombre';

  @override
  String get activityStartLabel => 'Inicio';

  @override
  String get activityEndLabel => 'Fin';

  @override
  String get activityDeadlineLabel => 'Fecha límite';

  @override
  String get activityCategoryLabel => 'Categoría';

  @override
  String get activityCategoryAssignment => 'Actividad';

  @override
  String get activityCategoryExam => 'Examen';

  @override
  String get activityDetailsHint => 'Detalles...';

  @override
  String get activityNameRequired => 'El nombre es obligatorio';

  @override
  String get activityCreateError => 'Error al guardar la actividad';

  @override
  String get activitySaveButton => 'Guardar';

  @override
  String get activityCreateButton => 'Crear';

  @override
  String get activityUntitled => 'Sin título';

  @override
  String get activityMenuEdit => 'Editar';

  @override
  String get activityMenuDelete => 'Eliminar';

  @override
  String get activityMenuMarkComplete => 'Marcar como completada';

  @override
  String get activityMenuUnmarkComplete => 'Marcar como pendiente';

  @override
  String activityTimeRange(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get roomsEmptyTitle => 'No se encontraron asignaturas';

  @override
  String get roomsNoName => 'Asignatura sin nombre';

  @override
  String roomsSubtitle(Object group, Object year, Object term) {
    return 'Clase $group • $year / $term';
  }

  @override
  String get roomsNewPostTitle => 'Nuevo post';

  @override
  String get roomsPostTitleHint => 'Título';

  @override
  String get roomsPostBodyHint => 'Escribe tu pregunta o resumen...';

  @override
  String get roomsAttachPdf => 'Adjuntar PDF';

  @override
  String get roomsNoAttachment => 'Sin archivo';

  @override
  String get roomsAttachmentReadError => 'No se pudo leer el archivo adjunto';

  @override
  String roomsAttachmentTooLarge(int maxSize) {
    return 'Archivo demasiado grande — el máximo permitido es $maxSize MB';
  }

  @override
  String get roomsUploading => 'Subiendo...';

  @override
  String get roomsPublishButton => 'Publicar';

  @override
  String get roomsDeletePostTitle => 'Eliminar post';

  @override
  String get roomsDeletePostMessage => '¿Desea eliminar este post?';

  @override
  String get roomsDeletePost => 'Eliminar';

  @override
  String get roomsReplyTitle => 'Responder';

  @override
  String get roomsReplyHint => 'Escribe tu respuesta...';

  @override
  String get roomsReplyButton => 'Responder';

  @override
  String roomsRepliesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'respuestas',
      one: 'respuesta',
    );
    return '$count $_temp0';
  }

  @override
  String get roomsRespondAction => 'Responder';

  @override
  String get roomsNoPosts => 'Aún no hay publicaciones. ¡Crea la primera!';

  @override
  String get roomsNewPostFab => 'Nuevo post';

  @override
  String get roomsAttachmentDefaultName => 'Adjunto.pdf';

  @override
  String get roomsAnonymous => 'Anónimo';

  @override
  String get notificationsEmptyTitle => 'No hay notificaciones';

  @override
  String get notificationsDefaultTitle => 'Notificación';
}
