// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Study Planner';

  @override
  String get appTagline => '不仅是日程规划，它是你学业旅程的伙伴。';

  @override
  String get mandatoryField => '必填字段！';

  @override
  String get success => '成功';

  @override
  String get userCreated => '用户已创建';

  @override
  String get error => '错误';

  @override
  String get wrongUserOrPassword => '用户名或密码错误';

  @override
  String get somethingWrong => '出错了。请再试一次';

  @override
  String get musicForEveryone => '为大家提供音乐';

  @override
  String get username => '全名';

  @override
  String get password => '密码';

  @override
  String get orLabel => ' 或 ';

  @override
  String get continueWithGoogle => '使用Google继续';

  @override
  String get dontHaveAccount => '还没有账户？ ';

  @override
  String get alreadyHaveAccount => '已经有账户了？ ';

  @override
  String get loginSigninTitle => '使用以下方式登录';

  @override
  String get loginSignupTitle => '创建你的账户';

  @override
  String get loginEmail => '电子邮件';

  @override
  String get loginPassword => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get loginButtonSignup => '注册';

  @override
  String get loginToggleSignup => '还没有账户？注册';

  @override
  String get loginToggleSignin => '已经有账户？登录';

  @override
  String get loginSuccess => '登录成功！';

  @override
  String get loginEmailRequired => '电子邮件是必填项';

  @override
  String get loginPasswordRequired => '密码是必填项';

  @override
  String get loginInvalidEmail => '电子邮件无效';

  @override
  String get loginInvalidCredentials => '电子邮件或密码无效。请检查你的数据。';

  @override
  String get loginUserNotFound => '未找到用户。请先注册。';

  @override
  String get loginWrongPassword => '密码错误。请重试。';

  @override
  String get loginUserDisabled => '用户已被禁用。请联系支持。';

  @override
  String get loginTooManyRequests => '登录尝试次数过多。请稍后再试。';

  @override
  String get loginGenericError => '登录时发生错误';

  @override
  String get loginConnectionError => '连接错误';

  @override
  String get signupUsernameRequired => '用户名是必填项';

  @override
  String get signupPasswordTooShort => '密码至少需要 6 个字符';

  @override
  String get signupAccountCreationError => '电子邮件已注册或创建账户时出错';

  @override
  String get signupUfscarInvalidCredentials => 'UFSCar 平台上的电子邮件或密码无效。';

  @override
  String get signupSaveDataError => '保存数据时出错。请重试。';

  @override
  String get signupGenericError => '创建账户时发生错误';

  @override
  String get signupEmailAlreadyExists => '该电子邮件已注册';

  @override
  String get signupWeakPassword => '密码太弱。请至少使用 6 个字符。';

  @override
  String get signupOperationNotAllowed => '操作不允许。请稍后再试。';

  @override
  String get signupApiConnectionError => '连接 API 时出错';

  @override
  String get settingsAppearanceSection => '外观';

  @override
  String get settingsAccountSection => '账户';

  @override
  String get settingsAboutSection => '关于';

  @override
  String get settingsEditProfile => '编辑资料';

  @override
  String get settingsChangePassword => '更改密码';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsComingSoon => '开发中';

  @override
  String get settingsAutoPresenceTitle => '自动签到';

  @override
  String get settingsAutoPresenceSubtitle => '为新的课程自动标记出勤';

  @override
  String get settingsAutoPresenceSaveError => '保存设置时出错';

  @override
  String get settingsLanguageTitle => '语言';

  @override
  String get settingsLanguageDialogTitle => '选择语言';

  @override
  String get settingsAboutApp => '关于应用';

  @override
  String get settingsPrivacyPolicy => '隐私政策';

  @override
  String get settingsTermsOfUse => '使用条款';

  @override
  String get settingsLogoutButton => '退出账户';

  @override
  String get settingsLogoutTitle => '退出账户';

  @override
  String get settingsLogoutMessage => '确定要退出吗？';

  @override
  String get settingsLogoutCancel => '取消';

  @override
  String get settingsLogoutConfirm => '退出';

  @override
  String get settingsThemeTitle => '深色模式';

  @override
  String get settingsThemeEnabled => '已启用';

  @override
  String get settingsThemeDisabled => '已停用';

  @override
  String get languagePortuguese => '葡萄牙语';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageSpanish => '西班牙语';

  @override
  String get languageFrench => '法语';

  @override
  String get languageChinese => '中文';

  @override
  String get mainTabAgenda => '日程';

  @override
  String get mainTabActivities => '活动';

  @override
  String get mainTabRooms => '教室';

  @override
  String get mainTabNotifications => '通知';

  @override
  String get mainTabSettings => '设置';

  @override
  String get agendaFilterAll => '全部';

  @override
  String get agendaDefaultSectionTitle => '我的课程';

  @override
  String get agendaClearFilter => '查看全部';

  @override
  String get agendaGoToToday => '今天';

  @override
  String get agendaEmptyTitle => '未找到课程';

  @override
  String get agendaEmptyAction => '重新加载';

  @override
  String get agendaEmptyDayTitle => '这一天没有课程';

  @override
  String get agendaEmptyDayAction => '查看所有课程';

  @override
  String agendaSubjectsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '门课程',
      one: '门课程',
    );
    return '($count $_temp0)';
  }

  @override
  String get agendaNoSchedule => '未定义时间';

  @override
  String agendaClassLabel(Object group, Object year, Object term) {
    return '班级 $group • $year/$term';
  }

  @override
  String get agendaNoName => '未命名课程';

  @override
  String get agendaNoDayDefined => '未设置日期';

  @override
  String get agendaDayMonday => '星期一';

  @override
  String get agendaDayTuesday => '星期二';

  @override
  String get agendaDayWednesday => '星期三';

  @override
  String get agendaDayThursday => '星期四';

  @override
  String get agendaDayFriday => '星期五';

  @override
  String get agendaDaySaturday => '星期六';

  @override
  String get agendaDaySunday => '星期日';

  @override
  String get attendanceDialogTitle => '编辑计数';

  @override
  String get attendanceDialogAttendedLabel => '已上课程（已进行）';

  @override
  String get attendanceDialogMissedLabel => '缺课（错过的课程）';

  @override
  String get attendanceDialogCancel => '取消';

  @override
  String get attendanceDialogSave => '保存';

  @override
  String attendancePresence(int percentage) {
    return '出勤率：$percentage%';
  }

  @override
  String attendanceAttendedLabel(int count) {
    return '已上课程：$count';
  }

  @override
  String attendanceMissedLabel(int count) {
    return '缺课：$count';
  }

  @override
  String get attendanceAddClass => '增加课程';

  @override
  String get attendanceMarkAbsence => '标记缺席';

  @override
  String get attendanceEditCounts => '编辑计数';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDelete => '删除';

  @override
  String get commonUndo => '撤销';

  @override
  String get commonReload => '重新加载';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonSave => '保存';

  @override
  String get commonCreate => '创建';

  @override
  String get activitySectionToday => '今天';

  @override
  String get activitySectionTomorrow => '明天';

  @override
  String get activityMigrationStart => '正在开始颜色迁移...';

  @override
  String activityMigrationDone(int count) {
    return '迁移完成：已更新 $count 个项目';
  }

  @override
  String get activityMarkedDone => '活动已标记为完成';

  @override
  String get activityMarkedPending => '活动已标记为待办';

  @override
  String get activityDeleteTitle => '删除活动';

  @override
  String get activityDeleteMessage => '要删除此活动吗？';

  @override
  String get activityDeleted => '活动已删除';

  @override
  String get activityDeleteError => '删除活动时出错';

  @override
  String get activityFilterPending => '待办';

  @override
  String get activityFilterCompleted => '已完成';

  @override
  String get activityEmptyTitle => '未找到活动';

  @override
  String get activityNewButton => '新建活动';

  @override
  String get activityDialogTitleEdit => '编辑任务';

  @override
  String get activityDialogTitleCreate => '创建任务';

  @override
  String get activityNameHint => '名称';

  @override
  String get activityStartLabel => '开始';

  @override
  String get activityEndLabel => '结束';

  @override
  String get activityDeadlineLabel => '截止日期';

  @override
  String get activityCategoryLabel => '类别';

  @override
  String get activityCategoryAssignment => '活动';

  @override
  String get activityCategoryExam => '考试';

  @override
  String get activityDetailsHint => '详情...';

  @override
  String get activityNameRequired => '名称为必填项';

  @override
  String get activityCreateError => '保存活动时出错';

  @override
  String get activitySaveButton => '保存';

  @override
  String get activityCreateButton => '创建';

  @override
  String get activityUntitled => '未命名';

  @override
  String get activityMenuEdit => '编辑';

  @override
  String get activityMenuDelete => '删除';

  @override
  String get activityMenuMarkComplete => '标记为已完成';

  @override
  String get activityMenuUnmarkComplete => '标记为待办';

  @override
  String activityTimeRange(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get roomsEmptyTitle => '未找到课程';

  @override
  String get roomsNoName => '未命名课程';

  @override
  String roomsSubtitle(Object group, Object year, Object term) {
    return '班级 $group • $year / $term';
  }

  @override
  String get roomsNewPostTitle => '新帖子';

  @override
  String get roomsPostTitleHint => '标题';

  @override
  String get roomsPostBodyHint => '写下你的问题或摘要...';

  @override
  String get roomsAttachPdf => '附加 PDF';

  @override
  String get roomsNoAttachment => '没有附件';

  @override
  String get roomsAttachmentReadError => '无法读取附件';

  @override
  String roomsAttachmentTooLarge(int maxSize) {
    return '文件过大 — 最大允许 $maxSize MB';
  }

  @override
  String get roomsUploading => '正在上传...';

  @override
  String get roomsPublishButton => '发布';

  @override
  String get roomsDeletePostTitle => '删除帖子';

  @override
  String get roomsDeletePostMessage => '要删除此帖子吗？';

  @override
  String get roomsDeletePost => '删除';

  @override
  String get roomsReplyTitle => '回复';

  @override
  String get roomsReplyHint => '写下你的回复...';

  @override
  String get roomsReplyButton => '回复';

  @override
  String roomsRepliesCount(int count) {
    return '$count 条回复';
  }

  @override
  String get roomsRespondAction => '回复';

  @override
  String get roomsNoPosts => '还没有帖子，快来发表第一条吧！';

  @override
  String get roomsNewPostFab => '新帖子';

  @override
  String get roomsAttachmentDefaultName => '附件.pdf';

  @override
  String get roomsAnonymous => '匿名';

  @override
  String get notificationsEmptyTitle => '暂无通知';

  @override
  String get notificationsDefaultTitle => '通知';
}
