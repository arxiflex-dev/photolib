// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get actionAddToAlbum => 'إضافة إلى ألبوم';

  @override
  String get actionArchive => 'أرشفة';

  @override
  String get actionCopyTo => 'نسخ إلى…';

  @override
  String get actionDeleteForever => 'حذف نهائي';

  @override
  String get actionFavourite => 'إضافة إلى المفضّلة';

  @override
  String get actionHide => 'إخفاء';

  @override
  String get actionMoveTo => 'نقل إلى…';

  @override
  String get actionRename => 'إعادة تسمية';

  @override
  String get actionRestore => 'استعادة';

  @override
  String get actionShare => 'مشاركة';

  @override
  String get actionTrash => 'نقل إلى سلة المهملات';

  @override
  String get actionUnarchive => 'إلغاء الأرشفة';

  @override
  String get actionUndo => 'تراجع';

  @override
  String get actionUnfavourite => 'إزالة من المفضّلة';

  @override
  String get actionUnhide => 'إظهار';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'نشط',
      'disabled': 'معطّل',
      'invited': 'مدعو',
      'deleted': 'محذوف',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'الحسابات';

  @override
  String get adminAddAccount => 'إضافة حساب';

  @override
  String get adminAddExternalLibrary => 'إضافة مكتبة خارجية';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts محاولة',
      many: '$attempts محاولة',
      few: '$attempts محاولات',
      two: 'محاولتان',
      one: 'محاولة واحدة',
      zero: 'لم يتم تشغيلها بعد',
    );
    return '$status، $_temp0';
  }

  @override
  String get adminAudit => 'سجل التدقيق';

  @override
  String get adminBackUpNow => 'نسخ احتياطي الآن';

  @override
  String get adminBackupQueued =>
      'النسخة الاحتياطية في قائمة الانتظار، ويليها تمرين استعادة';

  @override
  String get adminBackups => 'النسخ الاحتياطية لقاعدة البيانات';

  @override
  String get adminCancelJob => 'إلغاء المهمة';

  @override
  String get adminCapabilities => 'الإمكانيات';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'المكتبات المُدارة',
      'uploads': 'الرفع من الأجهزة والويب وسطر الأوامر',
      'folder_browser': 'متصفح المجلدات',
      'device_folders': 'مجلدات الجهاز في التطبيقات المتصلة',
      'sharing': 'المشاركة والروابط العامة',
      'edits': 'التعديلات',
      'deletes': 'الحذف',
      'xmp_writes': 'كتابة ملفات XMP',
      'face_recognition': 'التعرّف على الوجوه',
      'ml_search': 'البحث الذكي',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'ناجح',
      'warn': 'تحذير',
      'fail': 'فاشل',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'تم النسخ';

  @override
  String get adminCopyBundle => 'نسخ بيانات التشخيص للإبلاغ عن خطأ';

  @override
  String get adminCopyLink => 'نسخ الرابط';

  @override
  String get adminDelete => 'حذف';

  @override
  String get adminDeviceBackups => 'النسخ الاحتياطية للأجهزة';

  @override
  String get adminDevices => 'أجهزتك';

  @override
  String get adminDisable => 'تعطيل';

  @override
  String adminDrillFailed(String detail) {
    return 'فشل آخر تمرين استعادة: $detail';
  }

  @override
  String get adminEdit => 'تعديل';

  @override
  String get adminEmail => 'البريد الإلكتروني';

  @override
  String get adminEnable => 'تفعيل';

  @override
  String get adminErrorSignIn => 'سجّل الدخول كمشرف';

  @override
  String get adminFacesDefault =>
      'يكون التعرّف على الوجوه مفعّلًا تلقائيًا للحسابات الجديدة';

  @override
  String get adminFiles => 'الملفات حسب النوع';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'تالف',
      'missing': 'مفقود',
      'size': 'حجم خاطئ',
      'hash': 'مستبدَل',
      'orphan': 'ملف يتيم',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size متاحة';
  }

  @override
  String get adminFreeDisk =>
      'إيقاف عمليات الرفع مؤقتًا عندما تقل المساحة الفارغة على القرص عن هذه النسبة المئوية، من 0 إلى 50';

  @override
  String get adminFreeDiskGb =>
      'أو عندما تقل عن هذه المساحة بالغيغابايت إن كانت أقل، من 0 إلى 100000';

  @override
  String get adminHandle => 'اسم تسجيل الدخول';

  @override
  String get adminIntegrity => 'السلامة';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر',
      many: '$countString عنصرًا',
      few: '$countString عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'في قائمة الانتظار',
      'running': 'قيد التشغيل',
      'done': 'مكتملة',
      'dead': 'فاشلة',
      'cancelled': 'ملغاة',
      'other': 'الكل',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'نوع المهمة، مثل render';

  @override
  String get adminJobs => 'المهام';

  @override
  String adminLastSeen(String time) {
    return 'آخر ظهور $time';
  }

  @override
  String get adminLibraries => 'المكتبات';

  @override
  String get adminLibraryOwner => 'المالك';

  @override
  String get adminLibraryRoot => 'مجلد على الخادم، مثل /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'متصلة',
      'offline': 'غير متصلة',
      'scanning': 'جارٍ الفحص',
      'error': 'خطأ',
      'other': 'غير معروفة',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'سجل الخادم';

  @override
  String get adminName => 'الاسم';

  @override
  String get adminNothing => 'لا يوجد شيء هنا بعد';

  @override
  String get adminOutOfRange => 'خارج النطاق';

  @override
  String get adminOverview => 'نظرة عامة';

  @override
  String get adminPair => 'إقران جهاز';

  @override
  String get adminPairBody =>
      'امسح هذا الرمز أو أرسل الرابط، ثم الصقه في «إضافة خادم» في Photolib على الجهاز الجديد: فهو يحمل كل عناوين هذا الخادم وشهادته، فلا يحتاج أحد إلى كتابتها.';

  @override
  String get adminPasswordSetup => 'رابط تعيين كلمة المرور';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'أرسل هذا الرابط إلى $name بأي وسيلة، أو دعه يمسح الرمز. يعيّن كلمة مرور مرة واحدة، حتى $date.';
  }

  @override
  String get adminPause => 'إيقاف نوع من المهام مؤقتًا';

  @override
  String adminPauseMinutes(int max) {
    return 'الدقائق، من 1 إلى $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return 'تم إيقاف $type مؤقتًا حتى $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر متبقٍ للنسخ الاحتياطي',
      many: '$countString عنصرًا متبقيًا للنسخ الاحتياطي',
      few: '$countString عناصر متبقية للنسخ الاحتياطي',
      two: 'عنصران متبقيان للنسخ الاحتياطي',
      one: 'عنصر واحد متبقٍ للنسخ الاحتياطي',
      zero: 'لا شيء متبقٍ للنسخ الاحتياطي',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'السياسات';

  @override
  String get adminPolicyReset => 'استخدام قيمة المستوى الأعلى';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'مفعّل تلقائيًا',
      'server': 'محدد للخادم',
      'user': 'محدد لهذا الحساب',
      'library': 'محدد لهذه المكتبة',
      'config': 'محدد في ملف الإعدادات',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'تطبيق إعداد مسبق';

  @override
  String get adminPresetBody =>
      'يحدد الإعداد المسبق كل إمكانية للخادم ويمحو ما حددته الحسابات والمكتبات. ويبقى كل شيء قابلًا للتعديل.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'عارض الأرشيف',
      'family_backup': 'النسخ الاحتياطي العائلي',
      'personal': 'شخصي',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'المكتبات الخارجية للقراءة فقط هي المرجع الوحيد: لا رفع ولا مكتبات مُدارة ولا مجلدات جهاز ولا تعديلات ولا حذف ولا كتابة XMP',
      'family_backup': 'كل شيء مفعّل باستثناء كتابة XMP',
      'personal': 'كل شيء مفعّل باستثناء المشاركة والروابط العامة',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'رمز QR للرابط';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString مهمة في قائمة الانتظار',
      many: '$countString مهمة في قائمة الانتظار',
      few: '$countString مهام في قائمة الانتظار',
      two: 'مهمتان في قائمة الانتظار',
      one: 'مهمة واحدة في قائمة الانتظار',
      zero: 'لا شيء للتنفيذ',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'حصة التخزين بالغيغابايت؛ اترك الحقل فارغًا لعدم تحديد حصة';

  @override
  String get adminRemote => 'الوصول عن بُعد';

  @override
  String get adminRemoteBody =>
      'صِل إلى الخادم من أي مكان دون فتح منفذ على الموجّه. اختر طريقة؛ كل منها يمنحه عنوان HTTPS لإضافته إلى التطبيقات. ثم اختبره من الخارج.';

  @override
  String get adminRemoteCloudflare =>
      'يتصل cloudflared إلى الخارج بخدمة Cloudflare التي تقدّم نطاقك عبر HTTPS. تحدّ الخطة المجانية الطلب بـ 100 ميغابايت، ولا تبلغها النسخ الاحتياطية أبدًا: فهي ترسل 8 ميبيبايت في كل مرة.';

  @override
  String get adminRemoteNoAddress =>
      'أضف عنوان https:// للخادم إلى هذا التطبيق لاختباره من الخارج.';

  @override
  String get adminRemoteReachable => 'يمكن الوصول إليه من الخارج.';

  @override
  String get adminRemoteTailscale =>
      'ثبّت Tailscale على جهاز الخادم وعلى كل جهاز، في الشبكة tailnet نفسها أو في Headscale الخاص بك، ثم شغّل هذا على جهاز الخادم واضبط public_url على العنوان الذي يطبعه.';

  @override
  String get adminRemoteTest => 'اختبار من الخارج';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return 'سيفتح $host العنوان $url من خوادمه حول العالم، وبذلك يعرف هذا العنوان. هل تريد المتابعة؟';
  }

  @override
  String get adminRemoteUnreachable =>
      'لا يمكن الوصول إليه من الخارج: تحقّق من الطريقة التي اخترتها ثم اختبر مرة أخرى.';

  @override
  String get adminRemoteWireguard =>
      'تحتاج إلى منفذ UDP مفتوح واحد في جهة الخادم أو على عقدة وسيطة. هذه إعدادات جهاز؛ أنشئ المفاتيح باستخدام wg genkey.';

  @override
  String get adminRepair => 'أعِده من نسخة احتياطية أو من جهاز ما زال يحتفظ به';

  @override
  String get adminRepairOrphan =>
      'لا تشير إليه أي صورة: افحصه ثم احذفه أو احتفظ به';

  @override
  String get adminReprocess => 'إعادة المعالجة';

  @override
  String get adminReprocessFaces => 'إعادة اكتشاف الوجوه';

  @override
  String get adminReprocessFolder =>
      'المجلد، مثل 2024/05؛ اترك الحقل فارغًا لمعالجة المكتبة بأكملها';

  @override
  String get adminReprocessMetadata => 'إعادة قراءة البيانات الوصفية';

  @override
  String get adminReprocessRenditions =>
      'إعادة إنشاء الصور المصغّرة والمعاينات';

  @override
  String get adminRestore => 'استعادة';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'فشلت استعادة $name: $detail';
  }

  @override
  String get adminRestoreUnverified => 'لم ينجح أي تمرين استعادة بعد';

  @override
  String adminRestoreVerified(String when) {
    return 'آخر استعادة تم التحقق منها: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'يتوقف photolibd، ثم يستبدل قاعدة البيانات كلها بـ $name عند تشغيله مجددًا. يضيع ما تغيّر منذ تلك النسخة، وتُزامن كل الأجهزة من البداية.';
  }

  @override
  String get adminRestoring => 'يتوقف photolibd لاستعادة النسخة الاحتياطية';

  @override
  String get adminResume => 'استئناف';

  @override
  String get adminRetry => 'إعادة المحاولة';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'مشرف',
      'user': 'مستخدم',
      'viewer': 'مشاهد',
      'other': 'غير معروف',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'تم الحفظ';

  @override
  String get adminScan => 'افحص الآن';

  @override
  String get adminScrubDays => 'أيام فحص كل أصل، من 1 إلى 3650';

  @override
  String get adminScrubNever => 'أول فحص كامل قيد التنفيذ';

  @override
  String adminScrubbed(String time) {
    return 'آخر فحص كامل $time';
  }

  @override
  String get adminSecondAdmin =>
      'اجعل شخصًا ثانيًا مسؤولًا، ليتمكن غيرك من تشغيل الخادم واستعادته إن لم تستطع ذلك.';

  @override
  String adminSilent(String time) {
    return 'صامت منذ $time';
  }

  @override
  String get adminSilentHours =>
      'ساعات بلا تقرير حتى يُعدّ النسخ الاحتياطي للجهاز صامتًا، من 1 إلى 8760';

  @override
  String get adminStores => 'التخزين';

  @override
  String get adminThisDevice => 'هذا الجهاز';

  @override
  String get adminTitle => 'إدارة الخادم';

  @override
  String get adminTrashDays => 'عدد الأيام في سلة المهملات، من 1 إلى 3650';

  @override
  String get adminTwoFactor => 'يجب على كل الحسابات إعداد عامل مصادقة ثانٍ';

  @override
  String get adminUsage => 'الاستخدام حسب الحساب';

  @override
  String get albumCover => 'استخدام كغلاف';

  @override
  String get albumEmpty => 'هذا الألبوم فارغ';

  @override
  String get albumHideMemories => 'إخفاء من الذكريات';

  @override
  String get albumHideTimeline => 'إخفاء من الجدول الزمني';

  @override
  String get albumNew => 'ألبوم جديد';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'أي تاريخ';

  @override
  String get backupCap => 'أكبر عنصر';

  @override
  String get backupCharging => 'أثناء الشحن فقط';

  @override
  String backupCompleted(String time) {
    return 'آخر نسخ احتياطي كامل: $time';
  }

  @override
  String backupContact(String time) {
    return 'آخر اتصال بالخادم: $time';
  }

  @override
  String get backupEnabled => 'نسخ هذا الجهاز احتياطيًا';

  @override
  String get backupFolderNo => 'ليس هذا';

  @override
  String get backupFolderYes => 'انسخها احتياطيًا';

  @override
  String backupHours(int count) {
    return '$count س';
  }

  @override
  String get backupMetered =>
      'على الشبكات المحدودة، مثل بيانات الجوال أو نقطة الاتصال';

  @override
  String get backupNever => 'لا يوجد نسخ احتياطي كامل بعد';

  @override
  String backupNewFolder(String name) {
    return 'مجلد جديد $name: هل تنسخه احتياطيًا؟';
  }

  @override
  String get backupNoLimit => 'بلا حد';

  @override
  String get backupNothing => 'لا شيء في الانتظار';

  @override
  String get backupNow => 'النسخ الاحتياطي الآن';

  @override
  String backupOverdue(int hours, String items) {
    return 'لا يوجد نسخ احتياطي كامل منذ $hours س. في الانتظار: $items';
  }

  @override
  String get backupOverdueTitle => 'لم يكتمل النسخ الاحتياطي';

  @override
  String backupPending(String items) {
    return 'في الانتظار: $items';
  }

  @override
  String backupRetry(String time) {
    return 'محاولة أخرى: $time';
  }

  @override
  String get backupRoaming => 'النسخ الاحتياطي أثناء التجوال';

  @override
  String get backupSignIn => 'سجّل الدخول إلى خادم لنسخ هذا الجهاز احتياطيًا';

  @override
  String get backupSignedOut =>
      'توقف النسخ الاحتياطي: سجّل الخادم خروج هذا الجهاز. سجّل الدخول مجددًا من الإعدادات.';

  @override
  String get backupSince => 'الملتقطة منذ';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'ينتظر النسخ الاحتياطي حتى يصبح الخادم متاحًا',
      'charging': 'ينتظر النسخ الاحتياطي حتى يُشحن الجهاز',
      'battery_low': 'ينتظر النسخ الاحتياطي: البطارية منخفضة',
      'roaming': 'ينتظر النسخ الاحتياطي أثناء التجوال',
      'quota': 'توقف النسخ الاحتياطي: مساحتك على الخادم ممتلئة',
      'second_factor':
          'توقف النسخ الاحتياطي: يطلب الخادم عاملًا ثانيًا لهذا الحساب',
      'other': 'توقف النسخ الاحتياطي: أجاب الخادم $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'النسخ الاحتياطي';

  @override
  String get backupWaiting => 'غير منسوخ احتياطيًا';

  @override
  String get backupWarnAfter => 'التنبيه إذا لم يكتمل خلال';

  @override
  String get backupWhat => 'ما الذي يُنسخ احتياطيًا';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'في مجلد لم تختره',
      'folder_new': 'في مجلد جديد: اختر ما إذا كنت ستنسخه احتياطيًا',
      'type_excluded': 'نوع عناصر لم تختره',
      'before_date': 'التُقط قبل التاريخ الذي اخترته',
      'selected': 'ينتظر دوره',
      'server_restored': 'فقده الخادم أثناء الاستعادة: يُرسَل مجددًا',
      'working': 'قيد النسخ الاحتياطي',
      'waiting_for_icloud': 'ينتظر تنزيله من iCloud',
      'metered': 'ينتظر شبكة غير محدودة',
      'metered_cap': 'أكبر من أن تحمله شبكة محدودة',
      'unreadable': 'لا يستطيع هذا الجهاز قراءته',
      'changed': 'تغيّر أثناء إرساله',
      'quota': 'مساحتك على الخادم ممتلئة',
      'other': 'رفضه الخادم: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld => 'لم يعد الخادم يعمل مع هذا الإصدار من Photolib.';

  @override
  String get checkAppTooOldNext => 'حدّث Photolib.';

  @override
  String get checkChanged => 'شهادة الخادم ليست الشهادة التي وثقت بها.';

  @override
  String get checkChangedNext =>
      'إن استبدلها المسؤول فثق بالجديدة. وإلا فربما يتنصّت أحد: لا تتابع.';

  @override
  String get checkClock =>
      'تختلف ساعة هذا الجهاز عن ساعة الخادم بأكثر من خمس دقائق.';

  @override
  String get checkClockNext => 'اسمح لجهازك بضبط التاريخ والوقت تلقائيًا.';

  @override
  String get checkDnsFailed => 'اسم الخادم لا يؤدي إلى أي عنوان.';

  @override
  String get checkDnsFailedNext => 'تحقّق من العنوان، أو اتصل بشبكة الخادم.';

  @override
  String checkExpired(String date) {
    return 'انتهت صلاحية شهادة الخادم في $date.';
  }

  @override
  String get checkFailed => 'فشل';

  @override
  String get checkMetered =>
      'أنت على شبكة محدودة الاستهلاك، مثل بيانات الجوال.';

  @override
  String get checkMeteredNext => 'اتصل بشبكة Wi-Fi قبل النسخ الاحتياطي الكبير.';

  @override
  String get checkNotPhotolib =>
      'يستجيب شيء غير Photolib، مثل صفحة خطأ من وكيل أو صفحة تسجيل دخول إلى شبكة Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'سجّل الدخول إلى شبكة Wi-Fi في المتصفح، أو اطلب من المسؤول فحص الوكيل.';

  @override
  String get checkOtherServer => 'يستجيب خادم Photolib آخر على هذا العنوان.';

  @override
  String get checkPassed => 'نجح';

  @override
  String get checkRefused => 'لا شيء يستجيب على هذا العنوان.';

  @override
  String get checkRefusedNext =>
      'تأكّد من أن الخادم يعمل وأنك على شبكته أو شبكته الافتراضية الخاصة.';

  @override
  String get checkRun => 'افحص الاتصال';

  @override
  String get checkRunning => 'جارٍ الفحص';

  @override
  String get checkSelfSigned =>
      'يستخدم الخادم شهادة خاصة به لا يعرفها هذا الجهاز بعد.';

  @override
  String get checkSkipped => 'لم يُفحص';

  @override
  String get checkStepAuth => 'تسجيل دخولك';

  @override
  String get checkStepClock => 'ساعة جهازك';

  @override
  String get checkStepDns => 'العثور على عنوان الخادم';

  @override
  String get checkStepNetwork => 'شبكتك';

  @override
  String get checkStepServer => 'Photolib على الخادم';

  @override
  String get checkStepTcp => 'الوصول إلى الخادم';

  @override
  String get checkStepTls => 'الاتصال الآمن والشهادة';

  @override
  String get checkStepUpload => 'عمليات الرفع الكبيرة عبر الوكلاء';

  @override
  String get checkTimedOut => 'يستغرق الخادم وقتًا طويلًا جدًا للرد.';

  @override
  String get checkTimedOutNext => 'تحقّق من اتصالك ثم حاول مرة أخرى.';

  @override
  String get checkTitle => 'فحص الاتصال';

  @override
  String get checkTlsFailed => 'فشل الاتصال الآمن.';

  @override
  String get checkTrustNext => 'لا تثق بها إلا إذا طابقت بصمتها بصمة خادمك.';

  @override
  String get checkUntrusted =>
      'شهادة الخادم صادرة عن جهة لا يثق بها هذا الجهاز.';

  @override
  String get checkUploadCap =>
      'يرفض وكيل في الطريق عمليات الرفع الكبيرة، لذا يصبح النسخ الاحتياطي أبطأ وعلى أجزاء صغيرة.';

  @override
  String get checkUploadCapNext =>
      'اطلب من المسؤول السماح بمرور طلبات بحجم 64 ميغابايت عبر الوكيل.';

  @override
  String get collectionAlbums => 'الألبومات';

  @override
  String collectionHide(String name) {
    return 'إخفاء $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'نقل $name لأسفل';
  }

  @override
  String collectionMoveUp(String name) {
    return 'نقل $name لأعلى';
  }

  @override
  String get collectionPeople => 'الأشخاص';

  @override
  String collectionPin(String name) {
    return 'تثبيت $name';
  }

  @override
  String get collectionPlaces => 'الأماكن';

  @override
  String collectionShow(String name) {
    return 'إظهار $name';
  }

  @override
  String get collectionTags => 'العلامات';

  @override
  String collectionUnpin(String name) {
    return 'إلغاء تثبيت $name';
  }

  @override
  String get collectionsCustomise => 'تخصيص';

  @override
  String get collectionsDone => 'تم';

  @override
  String get commandPalette => 'لوحة الأوامر';

  @override
  String get commandPaletteHint => 'اكتب أمرًا';

  @override
  String get dateFormatDefault => 'الافتراضي للغة';

  @override
  String get dateFormatDmy => 'يوم-شهر-سنة';

  @override
  String get dateFormatMdy => 'شهر-يوم-سنة';

  @override
  String get dateFormatYmd => 'سنة-شهر-يوم';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر على هذا الجهاز ومنسوخة احتياطيًا',
      many: '$countString عنصرًا على هذا الجهاز ومنسوخة احتياطيًا',
      few: '$countString عناصر على هذا الجهاز ومنسوخة احتياطيًا',
      two: 'عنصران على هذا الجهاز ومنسوخان احتياطيًا',
      one: 'عنصر واحد على هذا الجهاز ومنسوخ احتياطيًا',
      zero: '$countString على هذا الجهاز ومنسوخة احتياطيًا',
    );
    return '$_temp0';
  }

  @override
  String deleteDevice(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر على هذا الجهاز فقط، بلا نسخة احتياطية',
      many: '$countString عنصرًا على هذا الجهاز فقط، بلا نسخة احتياطية',
      few: '$countString عناصر على هذا الجهاز فقط، بلا نسخة احتياطية',
      two: 'عنصران على هذا الجهاز فقط، بلا نسخة احتياطية',
      one: 'عنصر واحد على هذا الجهاز فقط، بلا نسخة احتياطية',
      zero: '$countString على هذا الجهاز فقط، بلا نسخة احتياطية',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'عند تشغيل صور iCloud، تختفي العناصر المحذوفة من هذا الجهاز أيضًا من iCloud ومن أجهزة Apple الأخرى لديك.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر في مكتبتك فقط',
      many: '$countString عنصرًا في مكتبتك فقط',
      few: '$countString عناصر في مكتبتك فقط',
      two: 'عنصران في مكتبتك فقط',
      one: 'عنصر واحد في مكتبتك فقط',
      zero: '$countString في مكتبتك فقط',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'إزالة من هذا الجهاز';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر منسوخ احتياطيًا؛ تحتفظ بها مكتبتك',
      many: '$countString عنصرًا منسوخًا احتياطيًا؛ تحتفظ بها مكتبتك',
      few: 'العناصر الـ $countString المنسوخة احتياطيًا؛ تحتفظ بها مكتبتك',
      two: 'العنصران المنسوخان احتياطيًا؛ تحتفظ بهما مكتبتك',
      one: 'العنصر المنسوخ احتياطيًا؛ تحتفظ به مكتبتك',
      zero: '$countString عنصر منسوخ احتياطيًا؛ تحتفظ بها مكتبتك',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'تنتقل النسخ الموجودة على هذا الجهاز إلى سلة المهملات فيه: تُستعاد المساحة بعد إفراغها.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $countString عنصر؟',
      many: 'حذف $countString عنصرًا؟',
      few: 'حذف $countString عناصر؟',
      two: 'حذف عنصرين؟',
      one: 'حذف عنصر واحد؟',
      zero: 'حذف $countString عنصر؟',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'من هذا الجهاز ومن مكتبتك',
      'device': 'من هذا الجهاز فقط',
      'other': 'من مكتبتك',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'غير موجود';

  @override
  String get deviceFolderCard => 'بطاقة SD';

  @override
  String get deviceFolderExclude => 'استبعاد';

  @override
  String get deviceFolderExcludeThis => 'استبعاد هذا المجلد';

  @override
  String get deviceFolderExcludedNotice => 'مجلد هذا العنصر مستبعد من مكتبتك';

  @override
  String get deviceFolderForget => 'إزالة من القائمة';

  @override
  String get deviceFolderInternal => 'مساحة التخزين الداخلية';

  @override
  String get deviceFolderKeep => 'إبقاء';

  @override
  String deviceFolderNew(String name, String items) {
    return 'مجلد جديد: $name، $items';
  }

  @override
  String get deviceFolders => 'مجلدات الجهاز';

  @override
  String get deviceFoldersAll => 'عرض كل المجلدات باستثناء المستبعدة';

  @override
  String get deviceFoldersChosen => 'عرض المجلدات المختارة فقط';

  @override
  String get deviceFoldersExcludedNow => 'استُبعد من المكتبة';

  @override
  String get deviceFoldersSearch => 'البحث في المجلدات';

  @override
  String get diagnosticsAdvanced => 'إظهار التشخيص';

  @override
  String get diagnosticsAllLoggers => 'كل المصادر';

  @override
  String get diagnosticsCopied => 'تم نسخ السجل';

  @override
  String get diagnosticsCopy => 'نسخ السجل المعروض';

  @override
  String get diagnosticsEmpty => 'لا توجد إدخالات في السجل بعد';

  @override
  String get diagnosticsExport => 'تصدير حزمة التشخيص';

  @override
  String get diagnosticsExported => 'تم حفظ حزمة التشخيص';

  @override
  String get diagnosticsLevel => 'المستوى';

  @override
  String get diagnosticsLogger => 'المصدر';

  @override
  String get diagnosticsTitle => 'التشخيص';

  @override
  String get download => 'تنزيل';

  @override
  String get downloadCurrent => 'الإصدار الحالي مع تعديلاته';

  @override
  String get downloadFailed => 'تعذّر التنزيل';

  @override
  String get downloadOriginal => 'الأصلي';

  @override
  String downloadSaved(String name) {
    return 'تم حفظ $name';
  }

  @override
  String get downloadVersion => 'أي إصدار؟';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'جارٍ تنزيل $countString عنصر',
      many: 'جارٍ تنزيل $countString عنصرًا',
      few: 'جارٍ تنزيل $countString عناصر',
      two: 'جارٍ تنزيل عنصرين',
      one: 'جارٍ تنزيل عنصر واحد',
      zero: 'لا يتم تنزيل أي عنصر',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'تحسين تلقائي';

  @override
  String get editorCrop => 'قص';

  @override
  String get editorCropOriginal => 'الأصلي';

  @override
  String get editorCropSquare => 'مربع';

  @override
  String get editorEdit => 'تعديل';

  @override
  String get editorFlip => 'قلب';

  @override
  String get editorRotate => 'تدوير';

  @override
  String get editorSaveCopy => 'حفظ نسخة';

  @override
  String get editorSaveFailed => 'تعذّر حفظ النسخة';

  @override
  String get editorSaveVersion => 'حفظ';

  @override
  String get editorSaved => 'تم الحفظ كنسخة';

  @override
  String get editorVersionFailed => 'تعذّر حفظ الإصدار';

  @override
  String get editorVersionSaved => 'تم الحفظ كإصدار جديد';

  @override
  String get editorVersionsUnsupported =>
      'لا يستطيع هذا الخادم حفظ إصدارات الصور المعدّلة بعد';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم التراجع عن $countString تغيير: رفضها الخادم.',
      many: 'تم التراجع عن $countString تغييرًا: رفضها الخادم.',
      few: 'تم التراجع عن $countString تغييرات: رفضها الخادم.',
      two: 'تم التراجع عن تغييرين: رفضهما الخادم.',
      one: 'تم التراجع عن تغيير واحد: رفضه الخادم.',
      zero: 'تم التراجع عن $countString تغيير: رفضها الخادم.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'إغلاق';

  @override
  String get editsRejectedForbidden =>
      'يمكنك عرض العناصر لكن لا يمكنك تغييرها.';

  @override
  String get editsRejectedInvalid => 'تعذّر على الخادم قبول التغييرات.';

  @override
  String get editsRejectedNotFound => 'حُذفت العناصر أو لم تعد مشتركة معك.';

  @override
  String get errorNotFound => 'هذه الصفحة غير موجودة';

  @override
  String get errorRetry => 'إعادة المحاولة';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String faceNumber(int number) {
    return 'الوجه $number';
  }

  @override
  String get facesAgree => 'أوافق';

  @override
  String get facesAura => 'وصف الوجوه باستخدام AuraFace (تنزيل أكبر)';

  @override
  String get facesNotNow => 'ليس الآن';

  @override
  String get facesNoticeKeep =>
      'ما يُعثر عليه يبقى مع صورك على أجهزتك وخادمك. لا تُعرض الأوصاف ولا تُشارك أبدًا، ويُحذف كل شيء عند التوقف أو عند حذف الصورة.';

  @override
  String get facesNoticeOptional =>
      'هذا اختياري. كل ما عداه في Photolib يعمل بدونه، ويمكنك التوقف في أي وقت من الإعدادات.';

  @override
  String get facesNoticeTitle => 'العثور على الوجوه في صورك؟';

  @override
  String get facesNoticeWhat =>
      'يبحث Photolib عن الوجوه في صورك ومقاطع الفيديو، ويحتفظ لكل وجه بمكانه وقائمة أرقام تصفه، ليتمكن من العثور على الشخص نفسه مجددًا. قد يُعدّ هذا الوصف بيانات بيومترية.';

  @override
  String get facesNoticeWhere =>
      'يحدث ذلك على هذا الجهاز، وعلى خادمك الخاص إن كنت مسجّلًا الدخول. ولا يحدث أبدًا على خدمة نديرها نحن أو أي جهة أخرى.';

  @override
  String get facesServerFailed => 'تعذّر إبلاغ خادمك. حاول مرة أخرى.';

  @override
  String get facesServerOff => 'لا يعثر خادمك على وجوه لأجلك';

  @override
  String get facesServerOn => 'يعثر خادمك على الوجوه لأجلك';

  @override
  String get facesServerUnavailable => 'لا يقدّم خادمك التعرف على الوجوه';

  @override
  String facesStatusDownloading(int percent) {
    return 'تنزيل نماذج الوجوه: $percent%';
  }

  @override
  String get facesStatusMissing => 'لم يثبّت خادمك نماذج الوجوه';

  @override
  String get facesStatusNoDecoder =>
      'العثور على الوجوه غير متاح: لم يُعثر على مكتبة الصور (libvips). أعد تثبيت Photolib أو ثبّت libvips ثم أعد تشغيله.';

  @override
  String get facesStatusRunning => 'جارٍ العثور على الوجوه على هذا الجهاز';

  @override
  String get facesStatusUnavailable =>
      'لا يمكن العثور على الوجوه على هذا الجهاز';

  @override
  String get facesStatusWaiting => 'تُنزَّل نماذج الوجوه عبر Wi-Fi';

  @override
  String get facesSwitch => 'العثور على الوجوه في صوري';

  @override
  String get facesSwitchOff => 'متوقف. لا يُحسب أي شيء عن الوجوه حتى توافق.';

  @override
  String get facesSwitchOn => 'مفعّل. يعثر Photolib على الوجوه في صورك.';

  @override
  String get facesTitle => 'الوجوه والأشخاص';

  @override
  String get facesWithdraw => 'احذف وتوقف';

  @override
  String get facesWithdrawBody =>
      'سيحذف هذا كل وجه ووصف وشخص عثر عليه Photolib لك، على هذا الجهاز وعلى خادمك. لن تتغير صورك.';

  @override
  String get facesWithdrawTitle => 'التوقف عن العثور على الوجوه؟';

  @override
  String fileSize(double size, String unit) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    String _temp0 = intl.Intl.selectLogic(unit, {
      'kB': 'كيلوبايت',
      'MB': 'ميغابايت',
      'GB': 'غيغابايت',
      'TB': 'تيرابايت',
      'other': 'بايت',
    });
    return '$sizeString $_temp0';
  }

  @override
  String filesFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'ملفات لم تتغير: $countString';
  }

  @override
  String get folderAllow => 'السماح بالوصول إلى هذا المجلد';

  @override
  String get folderDelete => 'حذف المجلد';

  @override
  String folderDeleteBody(String name) {
    return 'هل تريد نقل الصور والفيديوهات في $name إلى سلة المهملات؟';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر',
      many: '$countString عنصرًا',
      few: '$countString عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'مجلد جديد';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'غير متصل، $countString عنصر',
      many: 'غير متصل، $countString عنصرًا',
      few: 'غير متصل، $countString عناصر',
      two: 'غير متصل، عنصران',
      one: 'غير متصل، عنصر واحد',
      zero: 'غير متصل، لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'هذا المجلد موجود بالفعل في المكتبة، أو يقع داخل مجلد موجود فيها أو يحتوي عليه';

  @override
  String get folderRemove => 'إزالة المجلد';

  @override
  String folderRemoveBody(String folder) {
    return 'ستتم إزالة صور وفيديوهات $folder من المكتبة، وستبقى الملفات على القرص دون أي تغيير.';
  }

  @override
  String get folderRemoveConfirm => 'إزالة';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'جارٍ الفحص، $countString عنصر حتى الآن',
      many: 'جارٍ الفحص، $countString عنصرًا حتى الآن',
      few: 'جارٍ الفحص، $countString عناصر حتى الآن',
      two: 'جارٍ الفحص، عنصران حتى الآن',
      one: 'جارٍ الفحص، عنصر واحد حتى الآن',
      zero: 'جارٍ الفحص، لا عناصر حتى الآن',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'السماح بالوصول';

  @override
  String get foldersHideExcluded => 'إخفاء المجلدات المستبعدة';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لم يعد بإمكان Photolib قراءة $countString مجلد.',
      many: 'لم يعد بإمكان Photolib قراءة $countString مجلدًا.',
      few: 'لم يعد بإمكان Photolib قراءة $countString مجلدات.',
      two: 'لم يعد بإمكان Photolib قراءة مجلدين.',
      one: 'لم يعد بإمكان Photolib قراءة مجلد واحد.',
      zero: 'لم يعد بإمكان Photolib قراءة أي مجلد.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'إظهار المجلدات المستبعدة ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'لا يمكن لهذا المتصفح الاحتفاظ بمجلد ليكون مكتبتك. افتح Photolib في Chrome أو Edge على كمبيوتر، أو استخدم تطبيق سطح المكتب.';

  @override
  String get galleryButtons => 'الأزرار';

  @override
  String get galleryChips => 'الشرائح';

  @override
  String get galleryGrid => 'الشبكة';

  @override
  String get galleryMenus => 'القوائم واللوحات';

  @override
  String get galleryShowSheet => 'عرض لوحة';

  @override
  String get galleryTitle => 'المكوّنات';

  @override
  String hiddenCollections(int count) {
    return 'المخفية ($count)';
  }

  @override
  String get indexingAllowMetered => 'التنزيل عبر بيانات الجوّال';

  @override
  String get indexingAllowSaver => 'في وضع توفير الطاقة أيضًا';

  @override
  String get indexingBattery => 'البطارية اللازمة دون شاحن';

  @override
  String get indexingChargingOnly => 'أثناء الشحن فقط';

  @override
  String indexingDownloading(int percent) {
    return 'جارٍ تنزيل نموذج البحث: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تعذّرت قراءة $count صورة',
      many: 'تعذّرت قراءة $count صورة',
      few: 'تعذّرت قراءة $count صور',
      two: 'تعذّرت قراءة صورتين',
      one: 'تعذّرت قراءة صورة واحدة',
      zero: 'لا صور تعذّرت قراءتها',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'يفهرس هذا الجهاز صوره الجديدة فقط';

  @override
  String get indexingMissing => 'لم يثبّت خادمك نموذج البحث';

  @override
  String get indexingModels => 'البحث على هذا الجهاز';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'ينزّل نموذج البحث ($megabytesString م.ب) من $host';
  }

  @override
  String get indexingNoDecoder =>
      'البحث وقراءة النص غير متاحين: لم يُعثر على مكتبة الصور (libvips). أعد تثبيت Photolib أو ثبّت libvips ثم أعد تشغيله.';

  @override
  String indexingPausedBattery(int percent) {
    return 'متوقفة مؤقتًا ما دامت البطارية أقل من $percent%';
  }

  @override
  String get indexingPausedCharger => 'متوقفة مؤقتًا حتى يبدأ شحن الجهاز';

  @override
  String get indexingPausedHeat => 'متوقفة مؤقتًا ما دام الجهاز ساخنًا';

  @override
  String get indexingPausedSaver =>
      'متوقفة مؤقتًا ما دام توفير البطارية مفعّلًا';

  @override
  String indexingPercent(int percent) {
    return '$percent%';
  }

  @override
  String indexingProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'الصور المفهرسة: $doneString من $totalString';
  }

  @override
  String get indexingText => 'قراءة النص في الصور';

  @override
  String indexingTextDownloading(int percent) {
    return 'جارٍ تنزيل نماذج النص: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'ينزّل نماذج النص ($megabytesString ميغابايت) من $host؛ يعثر على الكلمات في صورك';
  }

  @override
  String get indexingTextMissing => 'لم يثبّت خادمك نماذج النص';

  @override
  String get indexingTextPlatform =>
      'يستخدم التعرّف على النص المدمج في هاتفك؛ لا شيء للتنزيل. يقرأ الصور الجديدة';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'صور قُرئ نصها: $doneString من $totalString';
  }

  @override
  String get indexingTextUnavailable => 'قراءة النص غير متاحة هنا';

  @override
  String get indexingTextWaiting => 'تُنزَّل نماذج النص عبر Wi-Fi';

  @override
  String get indexingUnavailable => 'البحث على هذا الجهاز غير متاح هنا';

  @override
  String get indexingWaiting => 'يُنزَّل نموذج البحث عبر Wi-Fi';

  @override
  String get infoAddName => 'إضافة اسم';

  @override
  String get infoAddTag => 'إضافة وسم';

  @override
  String get infoAlbums => 'الألبومات';

  @override
  String get infoAllMetadata => 'عرض كل البيانات الوصفية';

  @override
  String get infoAuto => 'تلقائي';

  @override
  String get infoBackedUp => 'تم النسخ الاحتياطي';

  @override
  String get infoCamera => 'الكاميرا';

  @override
  String get infoChangeAdjust => 'عُدّلت الألوان';

  @override
  String get infoChangeCrop => 'قُصّت الصورة';

  @override
  String get infoChangeFlip => 'عُكست الصورة';

  @override
  String get infoChangeInpaint => 'مُلئت منطقة';

  @override
  String get infoChangeLocal => 'عُدّلت منطقة';

  @override
  String get infoChangeLut => 'طُبّق مظهر لوني';

  @override
  String get infoChangeOther => 'تم التحرير';

  @override
  String get infoChangeTurn => 'دُوّرت الصورة';

  @override
  String get infoCompare => 'مقارنة بالأصل';

  @override
  String infoConfidence(String percent) {
    return 'الثقة: $percent';
  }

  @override
  String get infoCopyPath => 'نسخ المسار';

  @override
  String get infoCurrent => 'الحالي';

  @override
  String get infoDescription => 'إضافة وصف';

  @override
  String get infoEditDate => 'تعديل التاريخ';

  @override
  String infoEditNumber(int number) {
    return 'التعديل $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'نسخة معدّلة من $name';
  }

  @override
  String get infoFaces => 'الوجوه';

  @override
  String get infoFile => 'الملف';

  @override
  String get infoFromFileName => 'من اسم الملف';

  @override
  String get infoHistory => 'سجل التعديلات';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'الموقع';

  @override
  String get infoMap => 'خريطة مكان التقاطها';

  @override
  String get infoMapAgree =>
      'تأتي مربعات الخريطة من الإنترنت وتكشف المنطقة التي تنظر إليها';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels ميغابكسل';
  }

  @override
  String infoNewTag(String path) {
    return 'وسم جديد: $path';
  }

  @override
  String get infoNoAlbum => 'ليس في أي ألبوم';

  @override
  String get infoOnDevice => 'على هذا الجهاز';

  @override
  String get infoOriginal => 'الأصل';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString بكسل';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'إزالة من $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'إزالة $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'تمت الإزالة من $album';
  }

  @override
  String get infoRevert => 'استعادة';

  @override
  String get infoSaveCopy => 'حفظ كنسخة';

  @override
  String get infoShared => 'مشترك';

  @override
  String get infoShowFaces => 'إظهار الوجوه على الصورة';

  @override
  String get infoShowMap => 'عرض الخريطة';

  @override
  String get infoTags => 'الوسوم';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إصدار',
      many: '$count إصدارًا',
      few: '$count إصدارات',
      two: 'إصداران',
      one: 'إصدار واحد',
      zero: 'لا إصدارات',
    );
    return '$_temp0 · آخرها $time';
  }

  @override
  String get infoWhy => 'لماذا هذا التاريخ؟';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'مقروء من الملف، في $tag',
      'name': 'مقروء من اسم الملف',
      'folder': 'مقروء من اسم مجلد',
      'host': 'مقدَّم من الخدمة التي جاء منها الملف',
      'unknown': 'لا شيء في الملف يحدد تاريخه، لذا يُستخدم تاريخ آخر تعديل له',
      'other': 'لم تتم قراءة الملف بعد، لذا يُستخدم التاريخ الذي يقدمه الجهاز',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'القائمة',
      'other': 'الشبكة',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'الاسم',
      'taken': 'تاريخ الالتقاط',
      'modified': 'تاريخ التعديل',
      'size': 'الحجم',
      'random': 'عشوائي',
      'extension': 'النوع',
      'custom': 'ترتيب الألبوم',
      'other': 'تاريخ الالتقاط',
    });
    return '$_temp0';
  }

  @override
  String get keyAlt => 'Alt';

  @override
  String get keyControl => 'Ctrl';

  @override
  String get keyMeta => 'Cmd';

  @override
  String get keyShift => 'Shift';

  @override
  String get languageDevice => 'لغة الجهاز';

  @override
  String get languageName => 'العربية';

  @override
  String get libraryAddFolder => 'إضافة مجلد';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'بلا نسخة احتياطية',
      'backed_up': 'منسوخ احتياطيًا',
      'cloud_only': 'في السحابة فقط',
      'other': 'الكل',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'كل شيء منسوخ احتياطيًا',
      'backed_up': 'لم يُنسخ أي شيء احتياطيًا بعد',
      'cloud_only': 'لا شيء موجود على الخادم فقط',
      'other': 'لا شيء هنا',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'شارات النسخ الاحتياطي';

  @override
  String get libraryEmpty => 'ستظهر صورك هنا';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'التجميع حسب الأسبوع',
      'month': 'التجميع حسب الشهر',
      'other': 'التجميع حسب اليوم',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'إخفاء العناصر المخفية والمؤرشفة مجددًا';

  @override
  String get libraryNoKeyring =>
      'يحفظ Photolib مفتاح مكتبتك في سلسلة مفاتيح النظام، وهي غير مشغّلة أو مقفلة. شغّل سلسلة مفاتيح أو افتح قفلها، مثل GNOME Keyring أو KWallet، ثم أعد المحاولة.';

  @override
  String get libraryRevealExcluded => 'عرض المجلدات المستبعدة لمدة 5 دقائق';

  @override
  String get libraryShowVeiled =>
      'إظهار العناصر المخفية والمؤرشفة لمدة 5 دقائق';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'المضافة مؤخرًا',
      'other': 'تاريخ الالتقاط',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'تعذّر على Photolib فتح المكتبة المحفوظة على هذا الجهاز';

  @override
  String get libraryViewOptions => 'خيارات العرض';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'جارٍ تجهيز الصور المصغّرة: $doneString من $totalString';
  }

  @override
  String get libraryZoomIn => 'صور مصغّرة أكبر';

  @override
  String get libraryZoomOut => 'صور مصغّرة أصغر';

  @override
  String get mapAddTrack => 'إضافة مسار GPX';

  @override
  String get mapArea => 'منطقة الخريطة';

  @override
  String get mapAttribution => '© المساهمون في OpenStreetMap';

  @override
  String get mapClearLasso => 'إلغاء التحديد';

  @override
  String get mapEmpty => 'لا توجد صور بموقع بعد';

  @override
  String get mapHeat => 'خريطة حرارية';

  @override
  String get mapLasso => 'حدّد بالرسم حول الصور';

  @override
  String get mapLoading => 'جارٍ وضع الصور على الخريطة';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'الصور: $countString';
  }

  @override
  String get mapSearchHere => 'ابحث في هذه المنطقة';

  @override
  String get mapSplit => 'عرض الصور تحت الخريطة';

  @override
  String get mapTilesAgree =>
      'تأتي خلفية الخريطة من خادم OpenStreetMap (tile.openstreetmap.org) الذي يرى المنطقة التي تنظر إليها';

  @override
  String get mapTilesShow => 'عرض الخلفية';

  @override
  String get mapTime => 'النطاق الزمني';

  @override
  String get mapTitle => 'الخريطة';

  @override
  String get mapTrackBad => 'لا يحتوي هذا الملف على مسارات GPX';

  @override
  String get mapTrips => 'الرحلات';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'مفضّل',
      'hidden': 'مخفي',
      'archived': 'مؤرشف',
      'offline': 'محفوظ على هذا الجهاز',
      'offline': 'محفوظ على هذا الجهاز',
      'offline': 'محفوظ على هذا الجهاز',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'السماح بالوصول';

  @override
  String get mediaAccessNone =>
      'يحتاج Photolib إلى إذن الوصول إلى صورك وفيديوهاتك لعرضها.';

  @override
  String get mediaAccessPartial =>
      'لا يرى Photolib إلا الصور والفيديوهات التي اخترتها. ويحتاج تطبيق المعرض إلى إذن الوصول إليها كلها.';

  @override
  String get mediaAccessSelect => 'اختيار المزيد من الصور';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get nextAddRoot =>
      'أضف المجلد إلى external_roots في إعدادات الخادم، ثم أعد تشغيل الخادم.';

  @override
  String get nextAskAdmin => 'اسأل مسؤول الخادم.';

  @override
  String get nextAskOwner =>
      'اطلب من مالك المكتبة أن يسمح لك بإضافة الصور إليها.';

  @override
  String get nextCheckConnection => 'افحص الاتصال لمعرفة السبب.';

  @override
  String get nextCheckEntry => 'تحقّق مما أدخلته ثم حاول مرة أخرى.';

  @override
  String get nextConfirm => 'تحقّق من عدد العناصر المتأثرة ثم أكّد.';

  @override
  String get nextDeleteWebhook =>
      'احذف خطاف ويب لم تعد تستخدمه، ثم حاول مرة أخرى.';

  @override
  String get nextEditConfig => 'غيّره في إعدادات الخادم، ثم أعد تشغيل الخادم.';

  @override
  String get nextFreeSpace => 'أفرغ بعض المساحة، أو اطلب المزيد من المسؤول.';

  @override
  String get nextNewLink => 'اطلب رابطًا جديدًا من المسؤول.';

  @override
  String get nextNewestToken => 'انسخ أحدث رمز من سجل photolibd.';

  @override
  String get nextOtherAdmin => 'اجعل حسابًا آخر مسؤولًا أولًا.';

  @override
  String get nextOtherFolder => 'اختر مجلدًا خاصًا بها.';

  @override
  String get nextRefresh => 'حدّث الصفحة ثم حاول مرة أخرى.';

  @override
  String get nextReport =>
      'حاول مرة أخرى. إن تكرر ذلك، فانسخ التفاصيل أدناه للمسؤول.';

  @override
  String get nextSetUpPrivate =>
      'أكمل إعداد المكتبات الخاصة في الإعدادات، ثم حاول مرة أخرى.';

  @override
  String get nextSignIn => 'سجّل الدخول مرة أخرى.';

  @override
  String get nextSignInAccount => 'سجّل الدخول بحسابك ثم حاول مرة أخرى.';

  @override
  String get nextSignInInstead => 'سجّل الدخول بدلًا من ذلك.';

  @override
  String get nextTryAgain => 'حاول مرة أخرى.';

  @override
  String get nextUpdateAndAgree => 'حدّث التطبيق ثم وافق على الإشعار مرة أخرى.';

  @override
  String get nextUseAnother => 'اختر غيره.';

  @override
  String get nextUseHttps =>
      'استخدم عنوان https:// للخادم، أو اتصل من شبكة الخادم نفسها.';

  @override
  String get nextWait => 'انتظر دقيقة ثم حاول مرة أخرى.';

  @override
  String get offlineKeep => 'الاحتفاظ بدون اتصال';

  @override
  String offlineKeepHere(String size) {
    return 'الاحتفاظ على هذا الجهاز ($size)';
  }

  @override
  String get offlineKeptHere => 'محفوظ على هذا الجهاز';

  @override
  String get offlineStopKeeping => 'إيقاف الاحتفاظ بدون اتصال';

  @override
  String get otherFiles => 'ملفات أخرى';

  @override
  String get passphraseCreate =>
      'لا تعمل على هذا الكمبيوتر أي سلسلة مفاتيح (Secret Service) لحفظ مفاتيح Photolib. اختر عبارة مرور من 10 أحرف على الأقل لحمايتها: سيطلبها Photolib في كل مرة يبدأ فيها.';

  @override
  String get passphraseLabel => 'عبارة المرور';

  @override
  String get passphraseMismatch => 'عبارتا المرور غير متطابقتين.';

  @override
  String get passphraseRepeat => 'أعد كتابة عبارة المرور';

  @override
  String get passphraseTooShort => 'استخدم 10 أحرف على الأقل.';

  @override
  String get passphraseUnlock =>
      'أدخل عبارة المرور التي تحمي مفاتيح Photolib على هذا الكمبيوتر.';

  @override
  String get passphraseWrong => 'عبارة المرور غير صحيحة. حاول مرة أخرى.';

  @override
  String photoPosition(int index, int count) {
    return 'الصورة $index من $count';
  }

  @override
  String get privacyCheckKit => 'تحقق من مجموعة الاسترداد';

  @override
  String get privacyDrillDue =>
      'حان وقت تمرين الاسترداد: تحقق من أن مجموعة الاسترداد لا تزال تفتح مكتباتك الخاصة.';

  @override
  String get privacyHonest =>
      'تُشفَّر المكتبات الخاصة على أجهزتك، ولا يستطيع أحد غيرك فتحها: لا الخادم ولا مسؤوله ولا مطورو Photolib. إذا فقدت كلمة المرور ومجموعة الاسترداد معًا، تضيع صورك إلى الأبد، ولن يستطيع أحد استعادتها لك.';

  @override
  String get privacyKitBody =>
      'اكتب هذه الكلمات الأربع والعشرين على ورقة بالترتيب، واحتفظ بها في مكان آمن. فهي تفتح مكتباتك الخاصة إذا نسيت كلمة المرور، لأي شخص يملكها.';

  @override
  String get privacyKitDone => 'مجموعة الاسترداد تعمل.';

  @override
  String get privacyKitOther => 'هذه ليست مجموعة الاسترداد الحالية.';

  @override
  String get privacyKitTitle => 'مجموعة الاسترداد الخاصة بك';

  @override
  String get privacyKitUnverified => 'لم يتم التحقق من مجموعة الاسترداد بعد';

  @override
  String privacyKitVerified(String date) {
    return 'تم التحقق من مجموعة الاسترداد في $date';
  }

  @override
  String get privacyKitWritten => 'كتبتها';

  @override
  String get privacyNotReady =>
      'تبقى عمليات الرفع الخاصة متوقفة حتى تكون لديك طريقتان للفتح وتتحقق من مجموعة الاسترداد.';

  @override
  String get privacyPasswordHelp =>
      'أدخل كلمة مرور حسابك: ستصبح طريقة لفتح مكتباتك الخاصة.';

  @override
  String get privacyPhrase => 'عبارة الاسترداد';

  @override
  String get privacyPhraseHelp => 'الكلمات الأربع والعشرون في مجموعة الاسترداد';

  @override
  String get privacyPhraseInvalid => 'هذه ليست عبارة استرداد. تحقق من كل كلمة.';

  @override
  String get privacyReady => 'عمليات الرفع الخاصة مفعّلة.';

  @override
  String get privacyRecoveryKit => 'مجموعة الاسترداد';

  @override
  String get privacySetUp => 'إعداد';

  @override
  String get privacyShowWords => 'اعرض الكلمات مرة أخرى';

  @override
  String get privacyTitle => 'المكتبات الخاصة';

  @override
  String privacyUnknownWord(int number) {
    return 'الكلمة $number ليست من كلمات مجموعة الاسترداد.';
  }

  @override
  String get privacyVerify => 'تحقق';

  @override
  String get privacyVerifyBody =>
      'اكتب هذه الكلمات من مجموعة الاسترداد لتثبت أنك حفظتها.';

  @override
  String get privacyWays => 'طرق الفتح';

  @override
  String privacyWord(int number) {
    return 'الكلمة $number';
  }

  @override
  String get privacyWordsDiffer =>
      'هذه الكلمات لا تطابق مجموعة الاسترداد. راجع ما كتبته.';

  @override
  String get privacyWrongPassword => 'هذه ليست كلمة مرور حسابك.';

  @override
  String get problemAdminOnly => 'لا يستطيع فعل هذا إلا مسؤول.';

  @override
  String get problemBusy => 'الخادم مشغول أو تجري إعادة تشغيله.';

  @override
  String get problemChanged => 'تغيّر هذا في هذه الأثناء.';

  @override
  String get problemConfirm =>
      'سيخفي هذا أو يحذف عناصر أكثر مما يفعله الخادم دون تأكيد';

  @override
  String get problemContribute => 'لا يمكنك إضافة صور إلى هذه المكتبة.';

  @override
  String get problemCopy => 'نسخ التفاصيل';

  @override
  String get problemDetails => 'التفاصيل';

  @override
  String get problemDiskLow =>
      'قرص الخادم ممتلئ تقريبًا، لذا توقفت عمليات الرفع مؤقتًا.';

  @override
  String get problemEmailTaken => 'حساب آخر يستخدم هذا البريد الإلكتروني.';

  @override
  String get problemExists => 'إنه موجود بالفعل.';

  @override
  String get problemFaceNotice =>
      'يطلب خادمك نسخة أحدث من إشعار الوجوه مما يعرضه هذا التطبيق.';

  @override
  String get problemGone => 'لم يعد موجودًا على الخادم.';

  @override
  String get problemHandleTaken => 'حساب آخر يستخدم اسم تسجيل الدخول هذا.';

  @override
  String get problemInterrupted => 'انقطع الرفع.';

  @override
  String get problemInvalid => 'إحدى القيم غير صالحة';

  @override
  String get problemLastAdmin => 'يحتاج الخادم إلى مسؤول واحد على الأقل.';

  @override
  String get problemLinkInvalid => 'انتهت صلاحية هذا الرابط أو سبق استخدامه.';

  @override
  String get problemLoginFailed =>
      'البريد الإلكتروني أو اسم تسجيل الدخول أو كلمة المرور غير صحيح.';

  @override
  String get problemMaintenanceKey =>
      'لا يمكن إيقاف النسخ الاحتياطي وفحص السلامة والحذف النهائي مؤقتًا إلا بعد تسجيل الدخول، وليس باستخدام مفتاح API';

  @override
  String get problemNotAllowed => 'لا يُسمح لحسابك بهذا.';

  @override
  String get problemNotExternal =>
      'لا يمكن فحص إلا مكتبات المجلدات الخاصة بالخادم.';

  @override
  String get problemOidcClaim =>
      'لم يذكر مزوّد تسجيل الدخول من أنت بطريقة يقبلها هذا الخادم.';

  @override
  String get problemOidcDown => 'مزوّد تسجيل الدخول لا يستجيب للخادم.';

  @override
  String get problemOidcFailed => 'رفض مزوّد تسجيل الدخول تسجيل دخولك.';

  @override
  String get problemOidcNotAllowed =>
      'لا يُسمح لحسابك بتسجيل الدخول بهذه الطريقة.';

  @override
  String get problemOidcTaken =>
      'تسجيل الدخول هذا مرتبط بالفعل بحساب Photolib آخر.';

  @override
  String get problemOidcUnknown =>
      'لم يعد هذا الخادم يتيح طريقة تسجيل الدخول هذه.';

  @override
  String get problemPasskeysOff =>
      'لا تعمل مفاتيح المرور إلا بعد أن يحصل الخادم على عنوانه العام.';

  @override
  String get problemPinned =>
      'هذا الإعداد محدد في ملف الإعدادات ولا يمكن تغييره هنا.';

  @override
  String get problemPolicyOff => 'هذه الميزة متوقفة على هذا الخادم.';

  @override
  String get problemQuota => 'مساحة التخزين الخاصة بك على الخادم ممتلئة.';

  @override
  String get problemRestoreKey =>
      'لا يمكن استعادة نسخة احتياطية إلا بعد تسجيل الدخول، وليس باستخدام مفتاح API.';

  @override
  String get problemRootDiffers => 'هذا المجلد لا يحتوي على ملفات هذه المكتبة';

  @override
  String get problemRootNotAllowed =>
      'هذا المجلد ليس ضمن external_roots في إعدادات الخادم';

  @override
  String get problemRootOverlaps =>
      'هذا المجلد يحتوي على مكتبة أخرى أو على بيانات الخادم نفسه، أو يقع داخلها';

  @override
  String get problemScanning => 'يجري فحص هذه المكتبة بالفعل';

  @override
  String get problemSecondFactor =>
      'يحتاج هذا الحساب إلى عامل ثانٍ، مثل رمز مصادقة أو مفتاح مرور، ولا يمكن لهذا الإصدار من Photolib تقديمه بعد.';

  @override
  String get problemSetupDone => 'لهذا الخادم مسؤول بالفعل.';

  @override
  String get problemSetupExpired => 'استغرق هذا وقتًا طويلًا جدًا.';

  @override
  String get problemSetupToken => 'رمز الإعداد هذا غير صحيح.';

  @override
  String get problemSignedOut => 'لقد سجّلت الخروج من الخادم.';

  @override
  String get problemStepUp => 'يحتاج هذا التغيير إلى كلمة المرور أو رمز أولًا.';

  @override
  String get problemStorage =>
      'لا يستطيع الخادم الوصول إلى مساحة التخزين الخاصة به.';

  @override
  String get problemTooMany => 'محاولات كثيرة في وقت قصير.';

  @override
  String get problemUnexpected => 'حدث خطأ غير متوقع.';

  @override
  String get problemUnreachable => 'لا يستجيب الخادم.';

  @override
  String get problemUploadDamaged => 'تغيّر الملف أو تلف في الطريق.';

  @override
  String get problemUploadExpired =>
      'لم يعد هذا الرفع موجودًا على الخادم: تنتهي صلاحية عمليات الرفع غير المكتملة بعد يوم.';

  @override
  String get problemWebhookLimit =>
      'لدى حسابك أكبر عدد مسموح به من خطافات الويب.';

  @override
  String get problemWebhooksOff => 'خطافات الويب متوقفة على هذا الخادم.';

  @override
  String get recoveryCode => 'رمز الاسترداد';

  @override
  String get recoveryCodeAbout =>
      'يفتح مخزن Photolib على هذا الجهاز إذا فقد مخزن المفاتيح مفتاحه';

  @override
  String get recoveryCodeEnter => 'أدخل رمز الاسترداد';

  @override
  String get recoveryCreate => 'أنشئ رمز استرداد';

  @override
  String get recoveryLater => 'لاحقًا';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'يوجد $countString تغيير على هذا الجهاز وحده. يستعيدها رمز الاسترداد إذا فقد مخزن المفاتيح مفتاح Photolib.',
      many:
          'يوجد $countString تغييرًا على هذا الجهاز وحده. يستعيدها رمز الاسترداد إذا فقد مخزن المفاتيح مفتاح Photolib.',
      few:
          'توجد $countString تغييرات على هذا الجهاز وحده. يستعيدها رمز الاسترداد إذا فقد مخزن المفاتيح مفتاح Photolib.',
      two: 'يوجد تغييران على هذا الجهاز وحده. يستعيدهما رمز الاسترداد إذا فقد مخزن المفاتيح مفتاح Photolib.',
      one: 'يوجد تغيير واحد على هذا الجهاز وحده. يستعيده رمز الاسترداد إذا فقد مخزن المفاتيح مفتاح Photolib.',
      zero: 'لا يوجد أي تغيير على هذا الجهاز وحده.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'اكتب هذه الكلمات الأربع والعشرين واحفظها في مكان آمن: فهي تفتح مخزن Photolib على هذا الجهاز دون مفتاحه في مخزن المفاتيح. وهي تحل محل أي رمز سابق.';

  @override
  String get recoveryUnlock => 'فتح القفل';

  @override
  String get recoveryWrong => 'هذا ليس رمز الاسترداد لهذا المخزن';

  @override
  String get renameFind => 'بحث';

  @override
  String get renamePattern => 'الاسم الجديد';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'طويل جدًا: لا يتجاوز الاسم 255 بايت',
      'invalid': 'اسم ملف غير صالح',
      'duplicate': 'أُعطي لملف آخر أيضًا',
      'exists': 'ملف آخر في هذا المجلد يحمل هذا الاسم',
      'other': 'تتعذر إعادة التسمية',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'استبدال بـ';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'ملفات أُعيدت تسميتها: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'إظهار في Finder',
      'windows': 'إظهار في المستكشف',
      'other': 'إظهار في المجلد',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'الكاميرا';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر',
      many: '$countString عنصرًا',
      few: '$countString عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'التواريخ';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'ابحث في مكتبتك';

  @override
  String get searchFavourites => 'المفضّلة';

  @override
  String get searchFolder => 'المجلد';

  @override
  String get searchHint => 'اسم الملف أو المجلد';

  @override
  String get searchMotionPhotos => 'الصور المتحركة';

  @override
  String get searchNothing => 'لا توجد نتائج مطابقة';

  @override
  String get searchPanoramas => 'الصور البانورامية';

  @override
  String get searchPhotos => 'الصور';

  @override
  String get searchScreenshots => 'لقطات الشاشة';

  @override
  String get searchVideo => 'فيديو';

  @override
  String get searchVideos => 'الفيديوهات';

  @override
  String get securityAddPasskey => 'إضافة مفتاح مرور';

  @override
  String get securityCode => 'الرمز';

  @override
  String get securityCodesHelp =>
      'احفظ هذه الرموز في مكان آمن. يعمل كل رمز مرة واحدة بدلًا من العامل الثاني، ولن تظهر إلا الآن.';

  @override
  String securityCodesLeft(int count) {
    return 'غير المستخدمة: $count';
  }

  @override
  String get securityNewCodes => 'رموز جديدة';

  @override
  String get securityPasskeyNotAdded => 'لم تتم إضافة أي مفتاح مرور.';

  @override
  String get securityRecoveryCodes => 'رموز الاسترداد';

  @override
  String get securityRemovePasskey => 'إزالة مفتاح المرور';

  @override
  String get securitySetUp => 'إعداد';

  @override
  String get securityStepUpBody =>
      'أدخل كلمة المرور، أو رمزًا من تطبيق المصادقة، أو رمز استرداد، لتغيير عوامل المصادقة الثانية.';

  @override
  String get securityStepUpTitle => 'أكّد هويتك';

  @override
  String get securityTitle => 'عوامل المصادقة الثانية';

  @override
  String get securityTotp => 'تطبيق المصادقة';

  @override
  String get securityTotpHelp =>
      'أضف هذا المفتاح إلى تطبيق المصادقة، ثم أدخل الرمز الذي يعرضه.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'مفعّل',
      'other': 'متوقف',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'إيقاف';

  @override
  String get securityWrongCode => 'هذا الرمز غير صحيح.';

  @override
  String get securityWrongProof => 'كلمة المرور أو الرمز غير صحيح.';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get selectionClear => 'إلغاء التحديد';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديد $countString عنصر',
      many: 'تم تحديد $countString عنصرًا',
      few: 'تم تحديد $countString عناصر',
      two: 'تم تحديد عنصرين',
      one: 'تم تحديد عنصر واحد',
      zero: 'لم يتم تحديد أي عنصر',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'عرض العناصر المحددة';

  @override
  String get serverAccount => 'البريد الإلكتروني أو اسم تسجيل الدخول';

  @override
  String get serverAdd => 'إضافة خادم';

  @override
  String get serverAddressInvalid => 'أدخل عناوين مثل photos.example.org';

  @override
  String get serverAddresses => 'العناوين';

  @override
  String get serverAddressesHelp =>
      'عنوان في كل سطر: الخادم على شبكتك أو على الإنترنت أو عبر VPN. يستخدم التطبيق أسرع عنوان يستجيب. أو الصق رابط تعيين كلمة المرور الذي أُرسل إليك.';

  @override
  String get serverCa => 'شهادة مرجع التصديق الخاص (PEM)';

  @override
  String get serverCaChoose => 'اختيار ملف شهادة';

  @override
  String serverCertificateBody(String host) {
    return 'يقدّم $host شهادة لا يثق بها هذا الجهاز. لا تثق بها إلا إذا كانت بصمة SHA-256 هذه هي بصمة خادمك:';
  }

  @override
  String get serverCertificateTitle => 'هل تثق بهذه الشهادة؟';

  @override
  String get serverConfirm => 'تأكيد';

  @override
  String get serverConnect => 'اتصال';

  @override
  String get serverCreateAdmin => 'إنشاء المشرف';

  @override
  String get serverEnded => 'أنهى الخادم هذه الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String get serverHandleHelp =>
      'أحرف صغيرة وأرقام ونقاط وشرطات وشرطات سفلية، ولا يتغيّر أبدًا.';

  @override
  String get serverHeaders => 'ترويسات مخصّصة';

  @override
  String get serverHeadersHelp =>
      'ترويسة في كل سطر بصيغة Name: value، وتُرسل عبر HTTPS فقط';

  @override
  String get serverHeadersInvalid => 'اكتب كل ترويسة بصيغة Name: value';

  @override
  String get serverIdentity => 'شهادة العميل (PKCS#12)';

  @override
  String get serverIdentityChoose => 'اختيار شهادة العميل';

  @override
  String get serverIdentityInvalid =>
      'هذه ليست شهادة PKCS#12، أو أن كلمة مرورها خاطئة.';

  @override
  String get serverIdentityPassword => 'كلمة مرور شهادة العميل';

  @override
  String get serverLoading => 'جارٍ قراءة الخادم المحفوظ على هذا الجهاز';

  @override
  String get serverNearby => 'خوادم على هذه الشبكة';

  @override
  String get serverNeedsHttps =>
      'يحتاج هذا الخادم إلى عنوان HTTPS: خارج شبكتك المحلية، لا يسجّل Photolib الدخول عبر HTTP العادي.';

  @override
  String get serverNoSignIn =>
      'لا يقدّم هذا الخادم أي طريقة لتسجيل الدخول يدعمها هذا الإصدار من Photolib.';

  @override
  String get serverOffline => 'لا يستجيب الخادم. ستبقى مسجّل الدخول.';

  @override
  String get serverPasskeyFailed =>
      'لم يُستخدم أي مفتاح مرور. حاول مرة أخرى، أو استخدم رمزًا.';

  @override
  String get serverPasskeyRequired =>
      'يتطلب هذا الخادم مفتاح مرور، ولا يمكن لهذا الإصدار من Photolib استخدامه بعد.';

  @override
  String get serverPassword => 'كلمة المرور';

  @override
  String get serverPasswordAgain => 'أعد كتابة كلمة المرور';

  @override
  String get serverPasswordSetupInvalid =>
      'رمز إعداد كلمة المرور هذا خاطئ أو مستخدم أو منتهي الصلاحية. اطلب رمزًا جديدًا.';

  @override
  String get serverPasswordSetupToken => 'رمز إعداد كلمة المرور';

  @override
  String get serverPasswordSetupTokenHelp =>
      'من المسؤول لديك، أو يطبعه photolibd admin password-setup على الخادم.';

  @override
  String get serverPasswordsDiffer => 'كلمتا المرور غير متطابقتين.';

  @override
  String get serverPrivateLibrariesBody =>
      'كلمة المرور الجديدة لا تفتحها. أعد فتحها بمجموعة الاسترداد أو بمفتاح مرور أو بجهاز لا يزال مسجّل الدخول.';

  @override
  String get serverPrivateLibrariesGo => 'تعيين كلمة المرور';

  @override
  String get serverPrivateLibrariesTitle => 'تبقى مكتباتك الخاصة مقفلة';

  @override
  String get serverProxy => 'خادم وكيل HTTP بصيغة host:port';

  @override
  String get serverProxyInvalid => 'أدخل الخادم الوكيل بصيغة host:port';

  @override
  String get serverRecoveryCode => 'رمز الاسترداد';

  @override
  String get serverRemove => 'إزالة هذا الخادم';

  @override
  String get serverRequired => 'مطلوب';

  @override
  String get serverSecondFactor =>
      'العامل الثاني لهذا الحساب هو مفتاح مرور، ولا يمكن لهذا الإصدار من Photolib استخدامه بعد.';

  @override
  String get serverSecondFactorCode =>
      'يحتاج هذا الحساب أيضًا إلى رمز من تطبيق المصادقة أو رمز استرداد.';

  @override
  String get serverSecondFactorTitle => 'تأكيد هويتك';

  @override
  String get serverSecondFactorWrong =>
      'لم ينجح ذلك. بعد خمس محاولات، سجّل الدخول مرة أخرى.';

  @override
  String get serverSetPassword => 'تعيين كلمة المرور';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'لـ $handle على $server';
  }

  @override
  String get serverSetPasswordOpen => 'تعيين كلمة مرور';

  @override
  String get serverSetPasswordTitle => 'عيّن كلمة مرورك';

  @override
  String get serverSetUp => 'إعداد خادم جديد';

  @override
  String get serverSetupLinkElsewhere =>
      'لاستخدام هذا الرابط، سجّل الخروج من هذا الخادم أولًا، أو أزِله إن كان الرابط لخادم آخر.';

  @override
  String get serverSetupTitle => 'إعداد الخادم';

  @override
  String get serverSetupToken => 'رمز الإعداد';

  @override
  String get serverSetupTokenHelp =>
      'يكتبه photolibd في سجلّه ما دام الخادم بلا مشرف، ويكتب رمزًا جديدًا عند كل تشغيل.';

  @override
  String get serverSignIn => 'تسجيل الدخول';

  @override
  String get serverSignOut => 'تسجيل الخروج';

  @override
  String serverSignedInAs(String account) {
    return 'تم تسجيل الدخول باسم $account';
  }

  @override
  String get serverSignedOut => 'تم تسجيل الخروج';

  @override
  String get serverSwitch => 'تبديل الحساب';

  @override
  String get serverTotpCode => 'الرمز من تطبيق المصادقة';

  @override
  String get serverTrust => 'ثقة';

  @override
  String get serverUnreadable => 'تعذّرت قراءة الخادم المحفوظ على هذا الجهاز';

  @override
  String get serverUsePasskey => 'استخدام مفتاح مرور';

  @override
  String get serverUseRecoveryCode => 'استخدام رمز استرداد بدلًا من ذلك';

  @override
  String get settingsBackground => 'خلف الصور الشفافة';

  @override
  String get settingsDateFormat => 'تنسيق التاريخ';

  @override
  String get settingsDefaultTab => 'تُفتح المجلدات والألبومات على';

  @override
  String get settingsFolders => 'المجلدات';

  @override
  String get settingsIndexing => 'الفهرسة على هذا الجهاز';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLibrary => 'المكتبة';

  @override
  String get settingsServer => 'الخادم';

  @override
  String get settingsStart => 'شاشة البدء';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'انقر على الحافة اليسرى أو اليمنى للانتقال إلى العنصر السابق أو التالي',
      'oneFingerZoom': 'انقر مرتين واسحب للتكبير بإصبع واحد',
      'swipes': 'اسحب لأعلى أو لأسفل على الجانب الأيسر من الفيديو لضبط السطوع، وعلى الأيمن لضبط الصوت',
      'maxBrightness': 'سطوع كامل أثناء العرض',
      'autoRotate': 'التدوير حسب اتجاه كل صورة أو فيديو',
      'mixAudio': 'تشغيل الفيديوهات مع الصوت الآخر بدلًا من إيقافه مؤقتًا',
      'autoplay': 'تشغيل مقاطع الفيديو عند فتحها',
      'loop': 'تكرار الفيديوهات',
      'autoNext': 'الانتقال إلى العنصر التالي عند انتهاء الفيديو',
      'resume': 'استئناف الفيديوهات من حيث توقفت',
      'other': 'تشغيل الصور المتحركة في الشبكة',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'المدة التي يحتفظ بها Photolib بالعناصر في سلة المهملات';

  @override
  String get settingsViewerBar => 'الأزرار في شريط العارض';

  @override
  String get settingsViewing => 'العرض';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString عنصر مشترك تنتظر حتى يُسمح لـ Photolib بإضافتها إلى مكتبة الصور. تُحذف العناصر غير المحفوظة بعد 7 أيام.',
      many:
          '$countString عنصرًا مشتركًا تنتظر حتى يُسمح لـ Photolib بإضافتها إلى مكتبة الصور. تُحذف العناصر غير المحفوظة بعد 7 أيام.',
      few:
          '$countString عناصر مشتركة تنتظر حتى يُسمح لـ Photolib بإضافتها إلى مكتبة الصور. تُحذف العناصر غير المحفوظة بعد 7 أيام.',
      two: 'عنصران مشتركان ينتظران حتى يُسمح لـ Photolib بإضافتهما إلى مكتبة الصور. تُحذف العناصر غير المحفوظة بعد 7 أيام.',
      one: 'عنصر مشترك واحد ينتظر حتى يُسمح لـ Photolib بإضافته إلى مكتبة الصور. تُحذف العناصر غير المحفوظة بعد 7 أيام.',
      zero: 'لا توجد عناصر مشتركة بانتظار الإضافة إلى مكتبة الصور.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'الحجم كبير جدًا للمشاركة دفعة واحدة: اختر عناصر أقل';

  @override
  String shareTooMany(int count) {
    return 'العدد كبير جدًا للمشاركة دفعة واحدة: اختر $count أو أقل';
  }

  @override
  String get shortcutsTitle => 'اختصارات لوحة المفاتيح';

  @override
  String get slideshow => 'عرض الشرائح';

  @override
  String get slideshowLoop => 'تكرار';

  @override
  String get slideshowOptions => 'خيارات عرض الشرائح';

  @override
  String get slideshowSeconds => 'ثوانٍ لكل عنصر';

  @override
  String get slideshowShuffle => 'ترتيب عشوائي';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'تنازلي',
      'other': 'تصاعدي',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'هذا الجهاز';

  @override
  String sourceHide(String name) {
    return 'إخفاء $name';
  }

  @override
  String get sourceHideOthers => 'إخفاء كل ما عداه هنا';

  @override
  String get sourceLost => 'لا يوجد وصول';

  @override
  String get sourcePartly => 'معروض جزئيًا';

  @override
  String sourceShow(String name) {
    return 'إظهار $name';
  }

  @override
  String get sourceShowEverything => 'إظهار كل ما هنا';

  @override
  String get sourceShowOnly => 'إظهار هذا فقط';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'المخطط الزمني',
      'folders': 'المجلدات والألبومات',
      'favourites': 'المفضّلة',
      'other': 'المخطط الزمني',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'الاحتفاظ بشخص بدون اتصال';

  @override
  String get storageBudget => 'حد التخزين';

  @override
  String get storageClear => 'إزالة النسخ غير المتصلة';

  @override
  String get storageClearAction => 'إزالة';

  @override
  String storageClearBody(String size) {
    return 'سيتم حذف $size المحفوظة على هذا الجهاز وإيقاف الاحتفاظ بالألبومات وعمليات البحث والصور بدون اتصال. مكتبتك على الخادم لن تتأثر.';
  }

  @override
  String get storageKeepLibrary => 'الاحتفاظ بالمكتبة كاملة';

  @override
  String get storageKeepOriginals => 'الاحتفاظ بالأصلية أيضًا';

  @override
  String get storageNoPeople => 'لا يوجد أشخاص مسمّون بعد.';

  @override
  String get storageNoPins =>
      'لا شيء مثبّت. ثبّت ألبومًا أو عملية بحث أو صورة للاحتفاظ بها بدون اتصال.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'ألبوم',
      'search': 'بحث',
      'person': 'شخص',
      'library': 'المكتبة كاملة',
      'asset': 'صورة',
      'other': 'مثبّت',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'لا يتسع في الحد: يلزم $size إضافية';
  }

  @override
  String get storagePinNothing =>
      'لا شيء للتنزيل: صوره موجودة على هذا الجهاز بالفعل';

  @override
  String get storagePinPaused =>
      'في الانتظار: هذا الإعداد لا يحتفظ بشيء بدون اتصال';

  @override
  String get storagePinPlanning => 'جارٍ تحديد ما يجب الاحتفاظ به…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'جارٍ التنزيل: $haveString من $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'متاح بدون اتصال ($size)';
  }

  @override
  String get storagePinWaiting => 'سيتم التنزيل عند الاتصال بالإنترنت';

  @override
  String get storagePins => 'محفوظ بدون اتصال';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'الفهرس فقط',
      'spaceSaver': 'توفير المساحة',
      'travel': 'ألبومات محددة بدون اتصال',
      'everything': 'كل شيء',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'لا يحتفظ بشيء؛ تُحمَّل الصور من خادمك عند فتحها.',
      'spaceSaver': 'يحتفظ بمعاينات مكتبتك كاملة، الأحدث أولًا، ضمن الحد.',
      'travel': 'يحتفظ فقط بما تثبّته: ألبومات وعمليات بحث وصور.',
      'everything':
          'يحتفظ بالصور الأصلية لمكتبتك كاملة، الأحدث أولًا، ضمن الحد.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'ما يحتفظ به هذا الجهاز';

  @override
  String get storageSubtitle => 'النسخ غير المتصلة وحد التخزين';

  @override
  String get storageTitle => 'التخزين';

  @override
  String storageUsed(String used, String budget) {
    return 'مستخدم $used من $budget';
  }

  @override
  String get storageWebNote =>
      'يحتفظ المتصفح بالمعاينات فقط ويمحوها عند تسجيل الخروج.';

  @override
  String get storeNoKeyring =>
      'يحفظ Photolib مفتاح مخزنه المحلي في سلسلة مفاتيح النظام، ولم تستجب. ثبّت gnome-keyring أو KWallet أو KeePassXC وافتح قفله مع تشغيل Secret Service، ثم أعد المحاولة.';

  @override
  String get storeNoKeystore =>
      'تعذّر على Photolib الوصول إلى مخزن المفاتيح في هذا الجهاز، الذي يحفظ مفتاح مخزنه المحلي.';

  @override
  String get storeRebuilt =>
      'لم يعد مخزن المفاتيح في هذا الجهاز يحتوي على مفتاح مخزن Photolib المحلي، لذا أُعيد بناء المخزن. فُقدت إعداداته وما كان موجودًا على هذا الجهاز وحده؛ وستتم مزامنة المكتبات مجددًا وستعود الصور المصغّرة.';

  @override
  String get storeRecoveryNeeded =>
      'لم يعد مخزن المفاتيح في هذا الجهاز يحتوي على مفتاح مخزن Photolib المحلي. أدخل رمز الاسترداد، أو أعد تعيين المخزن وافقد ما يوجد على هذا الجهاز وحده.';

  @override
  String get storeReset => 'إعادة تعيين المخزن';

  @override
  String get storeResetBody =>
      'سيُفقد ما يوجد على هذا الجهاز وحده؛ وستتم مزامنة المكتبات مجددًا وستعود الصور المصغّرة.';

  @override
  String get storeUnavailable =>
      'المخزن على هذا الجهاز غير متاح: لا تُحفظ الإعدادات والمجموعات';

  @override
  String get tabCollections => 'المجموعات';

  @override
  String get tabLibrary => 'المكتبة';

  @override
  String get tabSearch => 'البحث';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get timelineBenchmark => 'اختبار أداء الخط الزمني';

  @override
  String get timelineBenchmarkCopy => 'نسخ النتائج';

  @override
  String get timelineCannotPlay => 'لا يمكن تشغيله في هذا المتصفح';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date، $position من $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date، $position من $count، بلا معاينة';
  }

  @override
  String get timelineExcluded => 'في مجلد مستبعد';

  @override
  String get timelineScrubber => 'التمرير حسب التاريخ';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'تاريخ غير معروف';

  @override
  String timelineWeek(String date) {
    return 'أسبوع $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'إضافة $action إلى الشريط';
  }

  @override
  String toolbarDown(String action) {
    return 'نقل $action لأسفل';
  }

  @override
  String get toolbarInBar => 'في الشريط';

  @override
  String get toolbarInMenu => 'في القائمة ⋮';

  @override
  String toolbarRemove(String action) {
    return 'إزالة $action من الشريط';
  }

  @override
  String get toolbarReset => 'إعادة التعيين إلى الافتراضي';

  @override
  String toolbarUp(String action) {
    return 'نقل $action لأعلى';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'النقل إلى هنا',
      'other': 'النسخ إلى هنا',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'يوجد ملف أو مجلد بهذا الاسم بالفعل',
      'changed': 'لم تطابق النسخة الأصل فأُزيلت',
      'cancelled': 'أُلغي',
      'invalid': 'اسم مجلد غير صالح',
      'other': 'فشل',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'الأخيرة';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هل تريد حذف $countString عنصر نهائيًا؟ لا يمكن التراجع عن ذلك.',
      many: 'هل تريد حذف $countString عنصرًا نهائيًا؟ لا يمكن التراجع عن ذلك.',
      few: 'هل تريد حذف $countString عناصر نهائيًا؟ لا يمكن التراجع عن ذلك.',
      two: 'هل تريد حذف عنصرين نهائيًا؟ لا يمكن التراجع عن ذلك.',
      one: 'هل تريد حذف عنصر واحد نهائيًا؟ لا يمكن التراجع عن ذلك.',
      zero: 'هل تريد حذف $countString عنصر نهائيًا؟ لا يمكن التراجع عن ذلك.',
    );
    return '$_temp0';
  }

  @override
  String trashDaysLeft(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'بقي $daysString يوم',
      many: 'بقي $daysString يومًا',
      few: 'بقيت $daysString أيام',
      two: 'بقي يومان',
      one: 'بقي يوم واحد',
      zero: 'سيُحذف نهائيًا اليوم',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'سلة المهملات فارغة';

  @override
  String get trashEmptyAll => 'إفراغ سلة المهملات';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString يومًا';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'نُقل $countString عنصر إلى سلة المهملات',
      many: 'نُقل $countString عنصرًا إلى سلة المهملات',
      few: 'نُقلت $countString عناصر إلى سلة المهملات',
      two: 'نُقل عنصران إلى سلة المهملات',
      one: 'نُقل عنصر واحد إلى سلة المهملات',
      zero: 'لم يُنقل أي عنصر إلى سلة المهملات',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'إزالة من القائمة';

  @override
  String trashRetention(int days) {
    return 'يحذف Photolib ما يحتفظ به في سلة المهملات نهائيًا بعد $days يومًا؛ ويعرض كل عنصر الوقت المتبقي له.';
  }

  @override
  String get trashTitle => 'سلة المهملات';

  @override
  String get undo => 'تراجع';

  @override
  String get uploadAction => 'رفع الصور ومقاطع الفيديو';

  @override
  String get uploadClear => 'مسح';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'تم رفع $doneString من $totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'فشل: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت أرشفة $countString عنصر',
      many: 'تمت أرشفة $countString عنصرًا',
      few: 'تمت أرشفة $countString عناصر',
      two: 'تمت أرشفة عنصرين',
      one: 'تمت أرشفة عنصر واحد',
      zero: 'لم تتم أرشفة أي عنصر',
    );
    return '$_temp0';
  }

  @override
  String veilHidden(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم إخفاء $countString عنصر',
      many: 'تم إخفاء $countString عنصرًا',
      few: 'تم إخفاء $countString عناصر',
      two: 'تم إخفاء عنصرين',
      one: 'تم إخفاء عنصر واحد',
      zero: 'لم يُخفَ أي عنصر',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'أسود',
      'white': 'أبيض',
      'other': 'رقعة شطرنج',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => 'لا يمكن تشغيل هذا الفيديو على هذا الجهاز';

  @override
  String get viewerCaptions => 'الترجمة';

  @override
  String get viewerCompass => 'قفل البوصلة';

  @override
  String get viewerCopy => 'نسخ';

  @override
  String get viewerCopyText => 'نسخ النص';

  @override
  String get viewerCustomize => 'تخصيص شريط الأدوات…';

  @override
  String get viewerDial =>
      'الاتجاه. انقر للعودة إلى الأمام. اسحب للنظر حولك، ومرّر أو اقرص للتكبير، وانقر مرتين لإعادة الضبط';

  @override
  String get viewerFilmstrip => 'شريط الصور';

  @override
  String get viewerFirst => 'الأول';

  @override
  String get viewerFisheye => 'عين السمكة';

  @override
  String get viewerGyroscope => 'حرّك الجهاز للنظر حولك';

  @override
  String get viewerHdr => 'عرض بتقنية HDR';

  @override
  String get viewerInfo => 'المعلومات';

  @override
  String get viewerInfoLoading => 'جارٍ تحميل معلومات هذا العنصر';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString من $countString';
  }

  @override
  String get viewerLast => 'الأخير';

  @override
  String get viewerLenses => 'اختيار عدسة';

  @override
  String get viewerMap => 'الخريطة';

  @override
  String get viewerMotion => 'تشغيل الحركة';

  @override
  String get viewerMotionDenied =>
      'لم يسمح هذا المتصفح بالوصول إلى مستشعرات الحركة';

  @override
  String get viewerMotionMissing =>
      'لا يحتوي هذا الجهاز على جيروسكوب للنظر حولك';

  @override
  String get viewerMute => 'كتم الصوت';

  @override
  String get viewerNext => 'التالي';

  @override
  String get viewerNextFrame => 'الإطار التالي';

  @override
  String get viewerPause => 'إيقاف مؤقت';

  @override
  String get viewerPlanet => 'كوكب صغير';

  @override
  String get viewerPlay => 'تشغيل';

  @override
  String get viewerPrevious => 'السابق';

  @override
  String get viewerPreviousFrame => 'الإطار السابق';

  @override
  String get viewerRotate => 'تدوير';

  @override
  String get viewerSdr => 'عرض بتقنية SDR';

  @override
  String get viewerSeek => 'الموضع';

  @override
  String get viewerSetAs => 'تعيين كـ';

  @override
  String get viewerShare => 'مشاركة';

  @override
  String get viewerSpeed => 'سرعة التشغيل';

  @override
  String get viewerSphere => 'عرض 360°. اسحب للنظر حولك، واقرص للتكبير';

  @override
  String get viewerText => 'النص في هذه الصورة';

  @override
  String get viewerTextCopied => 'تم نسخ النص';

  @override
  String get viewerTextNone => 'لم يُعثر على نص في هذه الصورة';

  @override
  String get viewerTextUnread => 'لم تُقرأ نصوص هذه الصورة بعد';

  @override
  String get viewerUnmute => 'إلغاء كتم الصوت';

  @override
  String get viewerZoomIn => 'تكبير';

  @override
  String get viewerZoomOut => 'تصغير';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'بطاقة SD',
      'other': 'داخلي',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'تكبير';

  @override
  String get zoomOut => 'تصغير';
}

/// The translations for Arabic (`ar_XB`).
class AppLocalizationsArXb extends AppLocalizationsAr {
  AppLocalizationsArXb() : super('ar_XB');

  @override
  String get actionAddToAlbum => '‏Add to album‏';

  @override
  String get actionArchive => '‏Archive‏';

  @override
  String get actionCopyTo => '‏Copy to…‏';

  @override
  String get actionDeleteForever => '‏Delete forever‏';

  @override
  String get actionFavourite => '‏Favourite‏';

  @override
  String get actionHide => '‏Hide‏';

  @override
  String get actionMoveTo => '‏Move to…‏';

  @override
  String get actionRename => '‏Rename‏';

  @override
  String get actionRestore => '‏Restore‏';

  @override
  String get actionShare => '‏Share‏';

  @override
  String get actionTrash => '‏Move to trash‏';

  @override
  String get actionUnarchive => '‏Unarchive‏';

  @override
  String get actionUndo => '‏Undo‏';

  @override
  String get actionUnfavourite => '‏Remove from favourites‏';

  @override
  String get actionUnhide => '‏Unhide‏';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': '‏Active‏',
      'disabled': '‏Disabled‏',
      'invited': '‏Invited‏',
      'deleted': '‏Deleted‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => '‏Accounts‏';

  @override
  String get adminAddAccount => '‏Add account‏';

  @override
  String get adminAddExternalLibrary => '‏Add an external library‏';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts‏ attempts‏',
      one: '‏1 attempt‏',
      zero: '‏not run yet‏',
    );
    return '$status‏, ‏$_temp0';
  }

  @override
  String get adminAudit => '‏Audit log‏';

  @override
  String get adminBackUpNow => '‏Back up now‏';

  @override
  String get adminBackupQueued =>
      '‏The backup is queued; a restore drill follows it‏';

  @override
  String get adminBackups => '‏Database backups‏';

  @override
  String get adminCancelJob => '‏Cancel job‏';

  @override
  String get adminCapabilities => '‏Capabilities‏';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': '‏Managed libraries‏',
      'uploads': '‏Uploads from devices, the web and the CLI‏',
      'folder_browser': '‏Folder browser‏',
      'device_folders': '‏Device folders in connected apps‏',
      'sharing': '‏Sharing and public links‏',
      'edits': '‏Edits‏',
      'deletes': '‏Deletes‏',
      'xmp_writes': '‏XMP sidecar writes‏',
      'face_recognition': '‏Face recognition‏',
      'ml_search': '‏Smart search‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': '‏OK‏',
      'warn': '‏Warning‏',
      'fail': '‏Failed‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => '‏Copied‏';

  @override
  String get adminCopyBundle => '‏Copy diagnostics for a bug report‏';

  @override
  String get adminCopyLink => '‏Copy link‏';

  @override
  String get adminDelete => '‏Delete‏';

  @override
  String get adminDeviceBackups => '‏Device backups‏';

  @override
  String get adminDevices => '‏Your devices‏';

  @override
  String get adminDisable => '‏Disable‏';

  @override
  String adminDrillFailed(String detail) {
    return '‏The last restore drill failed: ‏$detail';
  }

  @override
  String get adminEdit => '‏Edit‏';

  @override
  String get adminEmail => '‏Email‏';

  @override
  String get adminEnable => '‏Enable‏';

  @override
  String get adminErrorSignIn => '‏Sign in as an administrator‏';

  @override
  String get adminFacesDefault =>
      '‏Face recognition starts on for new accounts‏';

  @override
  String get adminFiles => '‏Files by kind‏';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': '‏Damaged‏',
      'missing': '‏Missing‏',
      'size': '‏Wrong size‏',
      'hash': '‏Replaced‏',
      'orphan': '‏Stray file‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size‏ free‏';
  }

  @override
  String get adminFreeDisk =>
      '‏Pause uploads below this free disk, in percent, 0 to 50‏';

  @override
  String get adminFreeDiskGb =>
      '‏or below this free disk in GB, if less, 0 to 100000‏';

  @override
  String get adminHandle => '‏Sign-in name‏';

  @override
  String get adminIntegrity => '‏Integrity‏';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ items‏',
      one: '‏1 item‏',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': '‏Queued‏',
      'running': '‏Running‏',
      'done': '‏Done‏',
      'dead': '‏Failed‏',
      'cancelled': '‏Cancelled‏',
      'other': '‏All‏',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => '‏Job type, such as render‏';

  @override
  String get adminJobs => '‏Jobs‏';

  @override
  String adminLastSeen(String time) {
    return '‏Last seen ‏$time';
  }

  @override
  String get adminLibraries => '‏Libraries‏';

  @override
  String get adminLibraryOwner => '‏Owner‏';

  @override
  String get adminLibraryRoot => '‏Folder on the server, such as /srv/photos‏';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': '‏Online‏',
      'offline': '‏Offline‏',
      'scanning': '‏Scanning‏',
      'error': '‏Error‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => '‏Server log‏';

  @override
  String get adminName => '‏Name‏';

  @override
  String get adminNothing => '‏Nothing here yet‏';

  @override
  String get adminOutOfRange => '‏Out of range‏';

  @override
  String get adminOverview => '‏Overview‏';

  @override
  String get adminPair => '‏Pair a device‏';

  @override
  String get adminPairBody =>
      '‏Scan this code or send the link, then paste it into Add a server in Photolib on the new device: it brings every address of this server and its certificate, so nobody types them.‏';

  @override
  String get adminPasswordSetup => '‏Password setup link‏';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return '‏Send this link to ‏$name‏ by any channel, or let them scan the code. It sets a password once, until ‏$date‏.‏';
  }

  @override
  String get adminPause => '‏Pause a job type‏';

  @override
  String adminPauseMinutes(int max) {
    return '‏Minutes, 1 to ‏$max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type‏ is paused until ‏$time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ items left to back up‏',
      one: '‏1 item left to back up‏',
      zero: '‏Nothing left to back up‏',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => '‏Policies‏';

  @override
  String get adminPolicyReset => '‏Use the wider level\'s value‏';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': '‏On by default‏',
      'server': '‏Set for the server‏',
      'user': '‏Set for this account‏',
      'library': '‏Set for this library‏',
      'config': '‏Set in config‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => '‏Apply a preset‏';

  @override
  String get adminPresetBody =>
      '‏A preset sets every capability for the server and clears what accounts and libraries set. Each stays editable.‏';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '‏Archive viewer‏',
      'family_backup': '‏Family backup‏',
      'personal': '‏Personal‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '‏The external read-only libraries are the only source of truth: no uploads, managed libraries, device folders, edits, deletes or XMP writes‏',
      'family_backup': '‏Everything on but XMP writes‏',
      'personal': '‏Everything on but sharing and public links‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => '‏QR code of the link‏';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ jobs queued‏',
      one: '‏1 job queued‏',
      zero: '‏Nothing to do‏',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => '‏Storage quota in GB; empty for none‏';

  @override
  String get adminRemote => '‏Remote access‏';

  @override
  String get adminRemoteBody =>
      '‏Reach the server from anywhere without opening a port on your router. Pick one way; each gives it an HTTPS address to add to the apps. Then test it from outside.‏';

  @override
  String get adminRemoteCloudflare =>
      '‏cloudflared connects out to Cloudflare, which serves your domain over HTTPS. The free plan caps a request at 100 MB, which backups never reach: they send 8 MiB at a time.‏';

  @override
  String get adminRemoteNoAddress =>
      '‏Add this server\'s https:// address to this app to test it from outside.‏';

  @override
  String get adminRemoteReachable => '‏Reachable from outside.‏';

  @override
  String get adminRemoteTailscale =>
      '‏Install Tailscale on the server\'s machine and every device, in the same tailnet or your Headscale, then run this on the server\'s machine and set public_url to the address it prints.‏';

  @override
  String get adminRemoteTest => '‏Test from outside‏';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host‏ will open ‏$url‏ from its servers around the world, and so learn this address. Go on?‏';
  }

  @override
  String get adminRemoteUnreachable =>
      '‏Not reachable from outside: check the way you chose, then test again.‏';

  @override
  String get adminRemoteWireguard =>
      '‏Needs one UDP port open on the server\'s side or on a hub. This is the configuration for a device; make keys with wg genkey.‏';

  @override
  String get adminRepair =>
      '‏Put it back from a backup or from a device that still has it‏';

  @override
  String get adminRepairOrphan =>
      '‏No photo names it: check it, then delete or keep it‏';

  @override
  String get adminReprocess => '‏Reprocess‏';

  @override
  String get adminReprocessFaces => '‏Detect faces again‏';

  @override
  String get adminReprocessFolder =>
      '‏Folder, such as 2024/05; empty for the whole library‏';

  @override
  String get adminReprocessMetadata => '‏Read metadata again‏';

  @override
  String get adminReprocessRenditions => '‏Regenerate thumbnails and previews‏';

  @override
  String get adminRestore => '‏Restore‏';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '‏The restore of ‏$name‏ failed: ‏$detail';
  }

  @override
  String get adminRestoreUnverified => '‏No restore drill has passed yet‏';

  @override
  String adminRestoreVerified(String when) {
    return '‏Last verified restore: ‏$when';
  }

  @override
  String adminRestoreWarning(String name) {
    return '‏photolibd stops, then replaces the whole database with ‏$name‏ when it starts again. What changed since that backup is lost, and every device syncs from scratch.‏';
  }

  @override
  String get adminRestoring => '‏photolibd is stopping to restore the backup‏';

  @override
  String get adminResume => '‏Resume‏';

  @override
  String get adminRetry => '‏Retry‏';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': '‏Administrator‏',
      'user': '‏User‏',
      'viewer': '‏Viewer‏',
      'other': '‏Unknown‏',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => '‏Saved‏';

  @override
  String get adminScan => '‏Scan now‏';

  @override
  String get adminScrubDays =>
      '‏Days for the scrub to check every original, 1 to 3650‏';

  @override
  String get adminScrubNever => '‏First full check under way‏';

  @override
  String adminScrubbed(String time) {
    return '‏Last full check ‏$time';
  }

  @override
  String get adminSecondAdmin =>
      '‏Make a second person an administrator, so that someone else can run and restore the server if you cannot.‏';

  @override
  String adminSilent(String time) {
    return '‏Silent since ‏$time';
  }

  @override
  String get adminSilentHours =>
      '‏Hours without a report until a device\'s backup is silent, 1 to 8760‏';

  @override
  String get adminStores => '‏Storage‏';

  @override
  String get adminThisDevice => '‏This device‏';

  @override
  String get adminTitle => '‏Server administration‏';

  @override
  String get adminTrashDays => '‏Days in the trash, 1 to 3650‏';

  @override
  String get adminTwoFactor => '‏Every account must set up a second factor‏';

  @override
  String get adminUsage => '‏Usage by account‏';

  @override
  String get albumCover => '‏Use as cover‏';

  @override
  String get albumEmpty => '‏This album is empty‏';

  @override
  String get albumHideMemories => '‏Hide from memories‏';

  @override
  String get albumHideTimeline => '‏Hide from timeline‏';

  @override
  String get albumNew => '‏New album‏';

  @override
  String get appTitle => '‏Photolib‏';

  @override
  String get backupAnyDate => '‏Any date‏';

  @override
  String get backupCap => '‏Largest item‏';

  @override
  String get backupCharging => '‏Only while charging‏';

  @override
  String backupCompleted(String time) {
    return '‏Last complete backup ‏$time';
  }

  @override
  String backupContact(String time) {
    return '‏Last contact with the server ‏$time';
  }

  @override
  String get backupEnabled => '‏Back up this device‏';

  @override
  String get backupFolderNo => '‏Not this one‏';

  @override
  String get backupFolderYes => '‏Back it up‏';

  @override
  String backupHours(int count) {
    return '$count‏ h‏';
  }

  @override
  String get backupMetered =>
      '‏On metered networks, such as mobile data or a hotspot‏';

  @override
  String get backupNever => '‏No complete backup yet‏';

  @override
  String backupNewFolder(String name) {
    return '‏New folder ‏$name‏: back it up?‏';
  }

  @override
  String get backupNoLimit => '‏No limit‏';

  @override
  String get backupNothing => '‏Nothing waits‏';

  @override
  String get backupNow => '‏Back up now‏';

  @override
  String backupOverdue(int hours, String items) {
    return '‏No complete backup for ‏$hours‏ h. Waiting: ‏$items';
  }

  @override
  String get backupOverdueTitle => '‏Backup has not completed‏';

  @override
  String backupPending(String items) {
    return '‏Waiting: ‏$items';
  }

  @override
  String backupRetry(String time) {
    return '‏Trying again ‏$time';
  }

  @override
  String get backupRoaming => '‏Back up while roaming‏';

  @override
  String get backupSignIn => '‏Sign in to a server to back up this device‏';

  @override
  String get backupSignedOut =>
      '‏Backup stopped: the server signed this device out. Sign in again in Settings.‏';

  @override
  String get backupSince => '‏Taken since‏';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': '‏Backup waits until the server is in reach‏',
      'charging': '‏Backup waits until the device charges‏',
      'battery_low': '‏Backup waits: the battery is low‏',
      'roaming': '‏Backup waits while roaming‏',
      'quota': '‏Backup stopped: your storage on the server is full‏',
      'second_factor':
          '‏Backup stopped: the server asks this account for a second factor‏',
      'other': '‏Backup stopped: the server answered ‏$code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => '‏Backup‏';

  @override
  String get backupWaiting => '‏Not backed up‏';

  @override
  String get backupWarnAfter => '‏Warn when not complete for‏';

  @override
  String get backupWhat => '‏What to back up‏';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': '‏In a folder you did not choose‏',
      'folder_new': '‏In a new folder: choose whether to back it up‏',
      'type_excluded': '‏A kind of item you did not choose‏',
      'before_date': '‏Taken before the date you chose‏',
      'selected': '‏Waiting for its turn‏',
      'server_restored': '‏The server lost it in a restore: sending it again‏',
      'working': '‏Being backed up‏',
      'waiting_for_icloud': '‏Waiting for iCloud to download it‏',
      'metered': '‏Waiting for a network that is not metered‏',
      'metered_cap': '‏Too large for a metered network‏',
      'unreadable': '‏This device cannot read it‏',
      'changed': '‏It changed while it was sent‏',
      'quota': '‏Your storage on the server is full‏',
      'other': '‏The server refused it: ‏$code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      '‏The server no longer works with this version of Photolib.‏';

  @override
  String get checkAppTooOldNext => '‏Update Photolib.‏';

  @override
  String get checkChanged =>
      '‏The server\'s certificate is not the one you trusted.‏';

  @override
  String get checkChangedNext =>
      '‏If your administrator replaced it, trust the new one. If not, someone may be listening in: do not go on.‏';

  @override
  String get checkClock =>
      '‏This device\'s clock and the server\'s differ by more than five minutes.‏';

  @override
  String get checkClockNext =>
      '‏Let your device set its date and time automatically.‏';

  @override
  String get checkDnsFailed =>
      '‏The server\'s name does not lead to an address.‏';

  @override
  String get checkDnsFailedNext =>
      '‏Check the address, or connect to the network the server is on.‏';

  @override
  String checkExpired(String date) {
    return '‏The server\'s certificate expired on ‏$date‏.‏';
  }

  @override
  String get checkFailed => '‏Failed‏';

  @override
  String get checkMetered =>
      '‏You are on a metered network, such as mobile data.‏';

  @override
  String get checkMeteredNext => '‏Connect to Wi-Fi before large backups.‏';

  @override
  String get checkNotPhotolib =>
      '‏Something other than Photolib answers, such as a proxy\'s error page or a Wi-Fi sign-in page.‏';

  @override
  String get checkNotPhotolibNext =>
      '‏Sign in to the Wi-Fi in your browser, or ask your administrator to check the proxy.‏';

  @override
  String get checkOtherServer =>
      '‏A different Photolib server answers at this address.‏';

  @override
  String get checkPassed => '‏Passed‏';

  @override
  String get checkRefused => '‏Nothing answers at this address.‏';

  @override
  String get checkRefusedNext =>
      '‏Check that the server is running and that you are on its network or VPN.‏';

  @override
  String get checkRun => '‏Check the connection‏';

  @override
  String get checkRunning => '‏Checking‏';

  @override
  String get checkSelfSigned =>
      '‏The server uses a certificate of its own, which this device does not know yet.‏';

  @override
  String get checkSkipped => '‏Not checked‏';

  @override
  String get checkStepAuth => '‏Your sign-in‏';

  @override
  String get checkStepClock => '‏Your device\'s clock‏';

  @override
  String get checkStepDns => '‏Finding the server\'s address‏';

  @override
  String get checkStepNetwork => '‏Your network‏';

  @override
  String get checkStepServer => '‏Photolib on the server‏';

  @override
  String get checkStepTcp => '‏Reaching the server‏';

  @override
  String get checkStepTls => '‏Secure connection and certificate‏';

  @override
  String get checkStepUpload => '‏Large uploads through proxies‏';

  @override
  String get checkTimedOut => '‏The server takes too long to answer.‏';

  @override
  String get checkTimedOutNext => '‏Check your connection, then try again.‏';

  @override
  String get checkTitle => '‏Connection check‏';

  @override
  String get checkTlsFailed => '‏The secure connection failed.‏';

  @override
  String get checkTrustNext =>
      '‏Trust it only if its fingerprint matches your server\'s.‏';

  @override
  String get checkUntrusted =>
      '‏The server\'s certificate comes from an authority this device does not trust.‏';

  @override
  String get checkUploadCap =>
      '‏A proxy on the way refuses large uploads, so backups go slower, in small pieces.‏';

  @override
  String get checkUploadCapNext =>
      '‏Ask your administrator to let requests of 64 MB through the proxy.‏';

  @override
  String get collectionAlbums => '‏Albums‏';

  @override
  String collectionHide(String name) {
    return '‏Hide ‏$name';
  }

  @override
  String collectionMoveDown(String name) {
    return '‏Move ‏$name‏ down‏';
  }

  @override
  String collectionMoveUp(String name) {
    return '‏Move ‏$name‏ up‏';
  }

  @override
  String get collectionPeople => '‏People‏';

  @override
  String collectionPin(String name) {
    return '‏Pin ‏$name';
  }

  @override
  String get collectionPlaces => '‏Places‏';

  @override
  String collectionShow(String name) {
    return '‏Show ‏$name';
  }

  @override
  String get collectionTags => '‏Tags‏';

  @override
  String collectionUnpin(String name) {
    return '‏Unpin ‏$name';
  }

  @override
  String get collectionsCustomise => '‏Customise‏';

  @override
  String get collectionsDone => '‏Done‏';

  @override
  String get commandPalette => '‏Command palette‏';

  @override
  String get commandPaletteHint => '‏Type a command‏';

  @override
  String get dateFormatDefault => '‏Language default‏';

  @override
  String get dateFormatDmy => '‏Day-month-year‏';

  @override
  String get dateFormatMdy => '‏Month-day-year‏';

  @override
  String get dateFormatYmd => '‏Year-month-day‏';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ on this device and backed up‏',
      one: '‏1 on this device and backed up‏',
    );
    return '$_temp0';
  }

  @override
  String deleteDevice(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ only on this device, not backed up‏',
      one: '‏1 only on this device, not backed up‏',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      '‏With iCloud Photos on, items deleted from this device also leave iCloud and your other Apple devices.‏';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ only in your library‏',
      one: '‏1 only in your library‏',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => '‏Remove from this device‏';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '‏The ‏$countString‏ backed-up items; your library keeps them‏',
      one: '‏The backed-up item; your library keeps it‏',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      '‏Copies on this device go to its trash: the space returns once it is emptied.‏';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '‏Delete ‏$countString‏ items?‏',
      one: '‏Delete 1 item?‏',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': '‏From this device and your library‏',
      'device': '‏From this device only‏',
      'other': '‏From your library‏',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => '‏Not present‏';

  @override
  String get deviceFolderCard => '‏SD card‏';

  @override
  String get deviceFolderExclude => '‏Exclude‏';

  @override
  String get deviceFolderExcludeThis => '‏Exclude this folder‏';

  @override
  String get deviceFolderExcludedNotice =>
      '‏This item\'s folder is excluded from your library‏';

  @override
  String get deviceFolderForget => '‏Remove from the list‏';

  @override
  String get deviceFolderInternal => '‏Internal storage‏';

  @override
  String get deviceFolderKeep => '‏Keep‏';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name‏, ‏$items‏, is new‏';
  }

  @override
  String get deviceFolders => '‏Device folders‏';

  @override
  String get deviceFoldersAll => '‏Show all folders except the excluded‏';

  @override
  String get deviceFoldersChosen => '‏Show only the chosen folders‏';

  @override
  String get deviceFoldersExcludedNow => '‏Excluded from the library‏';

  @override
  String get deviceFoldersSearch => '‏Search folders‏';

  @override
  String get diagnosticsAdvanced => '‏Show diagnostics‏';

  @override
  String get diagnosticsAllLoggers => '‏All loggers‏';

  @override
  String get diagnosticsCopied => '‏Log copied‏';

  @override
  String get diagnosticsCopy => '‏Copy the log shown‏';

  @override
  String get diagnosticsEmpty => '‏No log entries yet‏';

  @override
  String get diagnosticsExport => '‏Export diagnostic bundle‏';

  @override
  String get diagnosticsExported => '‏Diagnostic bundle saved‏';

  @override
  String get diagnosticsLevel => '‏Level‏';

  @override
  String get diagnosticsLogger => '‏Logger‏';

  @override
  String get diagnosticsTitle => '‏Diagnostics‏';

  @override
  String get download => '‏Download‏';

  @override
  String get downloadCurrent => '‏Current version, with its edits‏';

  @override
  String get downloadFailed => '‏Couldn\'t download‏';

  @override
  String get downloadOriginal => '‏Original‏';

  @override
  String downloadSaved(String name) {
    return '‏Saved ‏$name';
  }

  @override
  String get downloadVersion => '‏Which version?‏';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '‏Downloading ‏$countString‏ items‏',
      one: '‏Downloading 1 item‏',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => '‏Auto-enhance‏';

  @override
  String get editorCrop => '‏Crop‏';

  @override
  String get editorCropOriginal => '‏Original‏';

  @override
  String get editorCropSquare => '‏Square‏';

  @override
  String get editorEdit => '‏Edit‏';

  @override
  String get editorFlip => '‏Flip‏';

  @override
  String get editorRotate => '‏Rotate‏';

  @override
  String get editorSaveCopy => '‏Save copy‏';

  @override
  String get editorSaveFailed => '‏Couldn\'t save the copy‏';

  @override
  String get editorSaveVersion => '‏Save‏';

  @override
  String get editorSaved => '‏Saved as a copy‏';

  @override
  String get editorVersionFailed => '‏Couldn\'t save the version‏';

  @override
  String get editorVersionSaved => '‏Saved as a new version‏';

  @override
  String get editorVersionsUnsupported =>
      '‏This server cannot keep versions of edited photos yet‏';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ changes were undone: the server refused them.‏',
      one: '‏1 change was undone: the server refused it.‏',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => '‏Dismiss‏';

  @override
  String get editsRejectedForbidden =>
      '‏You may view the items but not change them.‏';

  @override
  String get editsRejectedInvalid =>
      '‏The server could not accept the changes.‏';

  @override
  String get editsRejectedNotFound =>
      '‏The items were deleted or are no longer shared with you.‏';

  @override
  String get errorNotFound => '‏This page does not exist‏';

  @override
  String get errorRetry => '‏Try again‏';

  @override
  String get errorTitle => '‏Something went wrong‏';

  @override
  String faceNumber(int number) {
    return '‏Face ‏$number';
  }

  @override
  String get facesAgree => '‏I agree‏';

  @override
  String get facesAura => '‏Describe faces with AuraFace (larger download)‏';

  @override
  String get facesNotNow => '‏Not now‏';

  @override
  String get facesNoticeKeep =>
      '‏What is found stays with your photos, on your devices and your server. The descriptions are never shown or shared, and everything is deleted when you stop or delete the photo.‏';

  @override
  String get facesNoticeOptional =>
      '‏This is optional. Everything else in Photolib works without it, and you can stop at any time in Settings.‏';

  @override
  String get facesNoticeTitle => '‏Find faces in your photos?‏';

  @override
  String get facesNoticeWhat =>
      '‏Photolib looks for faces in your photos and videos and keeps, for each one, where it is and a list of numbers that describes it, so that the same person can be found again. Such a description can count as biometric data.‏';

  @override
  String get facesNoticeWhere =>
      '‏This happens on this device and, if you are signed in, on your own server. Never on a service run by us or anyone else.‏';

  @override
  String get facesServerFailed => '‏Your server could not be told. Try again.‏';

  @override
  String get facesServerOff => '‏Your server finds no faces for you‏';

  @override
  String get facesServerOn => '‏Your server finds faces for you‏';

  @override
  String get facesServerUnavailable =>
      '‏Your server does not offer face recognition‏';

  @override
  String facesStatusDownloading(int percent) {
    return '‏Downloading the face models: ‏$percent‏%‏';
  }

  @override
  String get facesStatusMissing =>
      '‏Your server has not installed the face models‏';

  @override
  String get facesStatusNoDecoder =>
      '‏Face finding is unavailable: the image library (libvips) was not found. Reinstall Photolib, or install libvips and restart it.‏';

  @override
  String get facesStatusRunning => '‏Finding faces on this device‏';

  @override
  String get facesStatusUnavailable => '‏Faces cannot be found on this device‏';

  @override
  String get facesStatusWaiting => '‏The face models download on Wi-Fi‏';

  @override
  String get facesSwitch => '‏Find faces in my photos‏';

  @override
  String get facesSwitchOff =>
      '‏Off. Nothing about faces is computed until you agree.‏';

  @override
  String get facesSwitchOn => '‏On. Photolib finds the faces in your photos.‏';

  @override
  String get facesTitle => '‏Faces and people‏';

  @override
  String get facesWithdraw => '‏Delete and stop‏';

  @override
  String get facesWithdrawBody =>
      '‏This deletes every face, description and person Photolib found for you, on this device and on your server. Your photos are not changed.‏';

  @override
  String get facesWithdrawTitle => '‏Stop finding faces?‏';

  @override
  String fileSize(double size, String unit) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    String _temp0 = intl.Intl.selectLogic(unit, {
      'kB': '‏kB‏',
      'MB': '‏MB‏',
      'GB': '‏GB‏',
      'TB': '‏TB‏',
      'other': '‏B‏',
    });
    return '$sizeString‏ ‏$_temp0';
  }

  @override
  String filesFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '‏Files not changed: ‏$countString';
  }

  @override
  String get folderAllow => '‏Allow access to this folder‏';

  @override
  String get folderDelete => '‏Delete folder‏';

  @override
  String folderDeleteBody(String name) {
    return '‏Move the photos and videos in ‏$name‏ to the trash?‏';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ items‏',
      one: '‏1 item‏',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => '‏New folder‏';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '‏Offline, ‏$countString‏ items‏',
      one: '‏Offline, 1 item‏',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      '‏This folder is already in the library, or inside or around one that is‏';

  @override
  String get folderRemove => '‏Remove folder‏';

  @override
  String folderRemoveBody(String folder) {
    return '‏The photos and videos of ‏$folder‏ leave the library. The files stay on disk, untouched.‏';
  }

  @override
  String get folderRemoveConfirm => '‏Remove‏';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '‏Scanning, ‏$countString‏ items so far‏',
      one: '‏Scanning, 1 item so far‏',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => '‏Allow access‏';

  @override
  String get foldersHideExcluded => '‏Hide excluded folders‏';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '‏Photolib can no longer read ‏$countString‏ folders.‏',
      one: '‏Photolib can no longer read 1 folder.‏',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '‏Show excluded folders (‏$countString‏)‏';
  }

  @override
  String get foldersUnsupported =>
      '‏This browser cannot keep a folder as your library. Open Photolib in Chrome or Edge on a computer, or use the desktop app.‏';

  @override
  String get galleryButtons => '‏Buttons‏';

  @override
  String get galleryChips => '‏Chips‏';

  @override
  String get galleryGrid => '‏Grid‏';

  @override
  String get galleryMenus => '‏Menus and sheets‏';

  @override
  String get galleryShowSheet => '‏Show a sheet‏';

  @override
  String get galleryTitle => '‏Components‏';

  @override
  String hiddenCollections(int count) {
    return '‏Hidden (‏$count‏)‏';
  }

  @override
  String get indexingAllowMetered => '‏Download over mobile data‏';

  @override
  String get indexingAllowSaver => '‏Also in power saving mode‏';

  @override
  String get indexingBattery => '‏Battery needed without a charger‏';

  @override
  String get indexingChargingOnly => '‏Only while charging‏';

  @override
  String indexingDownloading(int percent) {
    return '‏Downloading the search model: ‏$percent‏%‏';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count‏ photos could not be read‏',
      one: '‏1 photo could not be read‏',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => '‏This device indexes only its new photos‏';

  @override
  String get indexingMissing =>
      '‏Your server has not installed the search model‏';

  @override
  String get indexingModels => '‏Search on this device‏';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '‏Downloads the search model (‏$megabytesString‏ MB) from ‏$host';
  }

  @override
  String get indexingNoDecoder =>
      '‏Search and text reading are unavailable: the image library (libvips) was not found. Reinstall Photolib, or install libvips and restart it.‏';

  @override
  String indexingPausedBattery(int percent) {
    return '‏Paused while the battery is below ‏$percent‏%‏';
  }

  @override
  String get indexingPausedCharger => '‏Paused until the device charges‏';

  @override
  String get indexingPausedHeat => '‏Paused while the device is hot‏';

  @override
  String get indexingPausedSaver => '‏Paused while battery saver is on‏';

  @override
  String indexingPercent(int percent) {
    return '$percent‏%‏';
  }

  @override
  String indexingProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '‏Photos indexed: ‏$doneString‏ of ‏$totalString';
  }

  @override
  String get indexingText => '‏Read text in photos‏';

  @override
  String indexingTextDownloading(int percent) {
    return '‏Downloading the text models: ‏$percent‏%‏';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '‏Downloads the text models (‏$megabytesString‏ MB) from ‏$host‏; finds the words in your photos‏';
  }

  @override
  String get indexingTextMissing =>
      '‏Your server has not installed the text models‏';

  @override
  String get indexingTextPlatform =>
      '‏Uses your phone\'s own text recognition; nothing to download. Reads new photos‏';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '‏Photos read for text: ‏$doneString‏ of ‏$totalString';
  }

  @override
  String get indexingTextUnavailable => '‏Reading text is not available here‏';

  @override
  String get indexingTextWaiting => '‏The text models download on Wi-Fi‏';

  @override
  String get indexingUnavailable =>
      '‏Search on this device is not available here‏';

  @override
  String get indexingWaiting => '‏The search model downloads on Wi-Fi‏';

  @override
  String get infoAddName => '‏Add name‏';

  @override
  String get infoAddTag => '‏Add tag‏';

  @override
  String get infoAlbums => '‏Albums‏';

  @override
  String get infoAllMetadata => '‏View all metadata‏';

  @override
  String get infoAuto => '‏Auto‏';

  @override
  String get infoBackedUp => '‏Backed up‏';

  @override
  String get infoCamera => '‏Camera‏';

  @override
  String get infoChangeAdjust => '‏Adjusted colours‏';

  @override
  String get infoChangeCrop => '‏Cropped‏';

  @override
  String get infoChangeFlip => '‏Mirrored‏';

  @override
  String get infoChangeInpaint => '‏Filled an area‏';

  @override
  String get infoChangeLocal => '‏Adjusted an area‏';

  @override
  String get infoChangeLut => '‏Applied a colour look‏';

  @override
  String get infoChangeOther => '‏Edited‏';

  @override
  String get infoChangeTurn => '‏Rotated‏';

  @override
  String get infoCompare => '‏Compare with original‏';

  @override
  String infoConfidence(String percent) {
    return '‏Confidence: ‏$percent';
  }

  @override
  String get infoCopyPath => '‏Copy path‏';

  @override
  String get infoCurrent => '‏Current‏';

  @override
  String get infoDescription => '‏Add a description‏';

  @override
  String get infoEditDate => '‏Edit the date‏';

  @override
  String infoEditNumber(int number) {
    return '‏Edit ‏$number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '‏Edited copy of ‏$name';
  }

  @override
  String get infoFaces => '‏Faces‏';

  @override
  String get infoFile => '‏File‏';

  @override
  String get infoFromFileName => '‏from file name‏';

  @override
  String get infoHistory => '‏Edit history‏';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count‏ items‏',
      one: '$count‏ item‏',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => '‏Location‏';

  @override
  String get infoMap => '‏Map of where it was taken‏';

  @override
  String get infoMapAgree =>
      '‏Map tiles come from the internet and show which area you look at‏';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels‏ MP‏';
  }

  @override
  String infoNewTag(String path) {
    return '‏New tag: ‏$path';
  }

  @override
  String get infoNoAlbum => '‏Not in any album‏';

  @override
  String get infoOnDevice => '‏On this device‏';

  @override
  String get infoOriginal => '‏Original‏';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString‏ × ‏$heightString‏ pixels‏';
  }

  @override
  String infoRemoveFrom(String album) {
    return '‏Remove from ‏$album';
  }

  @override
  String infoRemoveTag(String tag) {
    return '‏Remove ‏$tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return '‏Removed from ‏$album';
  }

  @override
  String get infoRevert => '‏Revert‏';

  @override
  String get infoSaveCopy => '‏Save as copy‏';

  @override
  String get infoShared => '‏shared‏';

  @override
  String get infoShowFaces => '‏Show faces on the photo‏';

  @override
  String get infoShowMap => '‏Show map‏';

  @override
  String get infoTags => '‏Tags‏';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count‏ versions‏',
      one: '$count‏ version‏',
    );
    return '$_temp0‏ · last ‏$time';
  }

  @override
  String get infoWhy => '‏Why this date?‏';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': '‏Read in the file, as ‏$tag',
      'name': '‏Read in the file name‏',
      'folder': '‏Read in the name of a folder‏',
      'host': '‏Given by the service the file came from‏',
      'unknown': '‏Nothing in the file dates it, so the date it last changed stands in‏',
      'other':
          '‏The file is not read yet, so the date the device gives stands in‏',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': '‏List‏',
      'other': '‏Grid‏',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': '‏Name‏',
      'taken': '‏Date taken‏',
      'modified': '‏Date modified‏',
      'size': '‏Size‏',
      'random': '‏Random‏',
      'extension': '‏Type‏',
      'custom': '‏Album order‏',
      'other': '‏Date taken‏',
    });
    return '$_temp0';
  }

  @override
  String get keyAlt => '‏Alt‏';

  @override
  String get keyControl => '‏Ctrl‏';

  @override
  String get keyMeta => '‏Cmd‏';

  @override
  String get keyShift => '‏Shift‏';

  @override
  String get languageDevice => '‏Device language‏';

  @override
  String get languageName => '‏English‏';

  @override
  String get libraryAddFolder => '‏Add folder‏';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '‏Not backed up‏',
      'backed_up': '‏Backed up‏',
      'cloud_only': '‏Cloud only‏',
      'other': '‏All‏',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '‏Everything is backed up‏',
      'backed_up': '‏Nothing is backed up yet‏',
      'cloud_only': '‏Nothing is only on the server‏',
      'other': '‏Nothing here‏',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => '‏Backup badges‏';

  @override
  String get libraryEmpty => '‏Your photos will appear here‏';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': '‏Group by week‏',
      'month': '‏Group by month‏',
      'other': '‏Group by day‏',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => '‏Hide hidden and archived items again‏';

  @override
  String get libraryNoKeyring =>
      '‏Photolib keeps the key to your library in the system keyring, which is not running or is locked. Start or unlock a keyring, such as GNOME Keyring or KWallet, then try again.‏';

  @override
  String get libraryRevealExcluded => '‏Show excluded folders for 5 minutes‏';

  @override
  String get libraryShowVeiled =>
      '‏Show hidden and archived items for 5 minutes‏';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': '‏Recently added‏',
      'other': '‏Date taken‏',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      '‏Photolib could not open the library kept on this device‏';

  @override
  String get libraryViewOptions => '‏View options‏';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '‏Preparing thumbnails: ‏$doneString‏ of ‏$totalString';
  }

  @override
  String get libraryZoomIn => '‏Larger thumbnails‏';

  @override
  String get libraryZoomOut => '‏Smaller thumbnails‏';

  @override
  String get mapAddTrack => '‏Add a GPX track‏';

  @override
  String get mapArea => '‏Map area‏';

  @override
  String get mapAttribution => '‏© OpenStreetMap contributors‏';

  @override
  String get mapClearLasso => '‏Clear the selection‏';

  @override
  String get mapEmpty => '‏No photos with a place yet‏';

  @override
  String get mapHeat => '‏Heatmap‏';

  @override
  String get mapLasso => '‏Select by drawing around photos‏';

  @override
  String get mapLoading => '‏Placing photos on the map‏';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '‏Photos: ‏$countString';
  }

  @override
  String get mapSearchHere => '‏Search this area‏';

  @override
  String get mapSplit => '‏Show photos under the map‏';

  @override
  String get mapTilesAgree =>
      '‏The map background comes from OpenStreetMap\'s server (tile.openstreetmap.org), which sees which area you look at‏';

  @override
  String get mapTilesShow => '‏Show the background‏';

  @override
  String get mapTime => '‏Time range‏';

  @override
  String get mapTitle => '‏Map‏';

  @override
  String get mapTrackBad => '‏That file has no GPX tracks‏';

  @override
  String get mapTrips => '‏Trips‏';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': '‏Favourite‏',
      'hidden': '‏Hidden‏',
      'archived': '‏Archived‏',
      'offline': '‏Kept on this device‏',
      'offline': '‏Kept on this device‏',
      'offline': '‏Kept on this device‏',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => '‏Allow access‏';

  @override
  String get mediaAccessNone =>
      '‏Photolib needs access to your photos and videos to show them.‏';

  @override
  String get mediaAccessPartial =>
      '‏Photolib sees only the photos and videos you selected. A gallery needs access to all of them.‏';

  @override
  String get mediaAccessSelect => '‏Select more photos‏';

  @override
  String get nameLabel => '‏Name‏';

  @override
  String get nextAddRoot =>
      '‏Add the folder to external_roots in the server\'s configuration, then restart the server.‏';

  @override
  String get nextAskAdmin => '‏Ask your server\'s administrator.‏';

  @override
  String get nextAskOwner => '‏Ask the library\'s owner to let you add to it.‏';

  @override
  String get nextCheckConnection => '‏Check the connection to see why.‏';

  @override
  String get nextCheckEntry => '‏Check what you entered and try again.‏';

  @override
  String get nextConfirm => '‏Check how many items it affects, then confirm.‏';

  @override
  String get nextDeleteWebhook =>
      '‏Delete a webhook you no longer use, then try again.‏';

  @override
  String get nextEditConfig =>
      '‏Change it in the server\'s configuration, then restart the server.‏';

  @override
  String get nextFreeSpace =>
      '‏Free some space, or ask your administrator for more.‏';

  @override
  String get nextNewLink => '‏Ask your administrator for a new one.‏';

  @override
  String get nextNewestToken => '‏Copy the newest one from photolibd\'s log.‏';

  @override
  String get nextOtherAdmin => '‏Make another account an administrator first.‏';

  @override
  String get nextOtherFolder => '‏Choose a folder of its own.‏';

  @override
  String get nextRefresh => '‏Refresh and try again.‏';

  @override
  String get nextReport =>
      '‏Try again. If it happens again, copy the details below for your administrator.‏';

  @override
  String get nextSetUpPrivate =>
      '‏Finish setting up private libraries in Settings, then try again.‏';

  @override
  String get nextSignIn => '‏Sign in again.‏';

  @override
  String get nextSignInAccount => '‏Sign in with your account and try again.‏';

  @override
  String get nextSignInInstead => '‏Sign in instead.‏';

  @override
  String get nextTryAgain => '‏Try again.‏';

  @override
  String get nextUpdateAndAgree =>
      '‏Update the app, then agree to the notice again.‏';

  @override
  String get nextUseAnother => '‏Choose another one.‏';

  @override
  String get nextUseHttps =>
      '‏Use the server\'s https:// address, or connect from the server\'s own network.‏';

  @override
  String get nextWait => '‏Wait a minute, then try again.‏';

  @override
  String get offlineKeep => '‏Keep offline‏';

  @override
  String offlineKeepHere(String size) {
    return '‏Keep on this device (‏$size‏)‏';
  }

  @override
  String get offlineKeptHere => '‏Kept on this device‏';

  @override
  String get offlineStopKeeping => '‏Stop keeping offline‏';

  @override
  String get otherFiles => '‏Other files‏';

  @override
  String get passphraseCreate =>
      '‏This computer runs no keyring (Secret Service) to keep Photolib\'s keys. Choose a passphrase of at least 10 characters to protect them: Photolib asks for it each time it starts.‏';

  @override
  String get passphraseLabel => '‏Passphrase‏';

  @override
  String get passphraseMismatch => '‏The passphrases differ.‏';

  @override
  String get passphraseRepeat => '‏Repeat the passphrase‏';

  @override
  String get passphraseTooShort => '‏Use at least 10 characters.‏';

  @override
  String get passphraseUnlock =>
      '‏Enter the passphrase that protects Photolib\'s keys on this computer.‏';

  @override
  String get passphraseWrong => '‏Wrong passphrase. Try again.‏';

  @override
  String photoPosition(int index, int count) {
    return '‏Photo ‏$index‏ of ‏$count';
  }

  @override
  String get privacyCheckKit => '‏Check recovery kit‏';

  @override
  String get privacyDrillDue =>
      '‏Time for a recovery drill: check that your recovery kit still unlocks your private libraries.‏';

  @override
  String get privacyHonest =>
      '‏Private libraries are encrypted on your devices, and nobody else can open them: not the server, not its administrator, not Photolib\'s developers. If you lose both your password and your recovery kit, your photos are lost for good, and nobody can get them back for you.‏';

  @override
  String get privacyKitBody =>
      '‏Write these 24 words on paper, in order, and keep them somewhere safe. They unlock your private libraries if you forget your password, for anyone who has them.‏';

  @override
  String get privacyKitDone => '‏Your recovery kit works.‏';

  @override
  String get privacyKitOther => '‏This is not your current recovery kit.‏';

  @override
  String get privacyKitTitle => '‏Your recovery kit‏';

  @override
  String get privacyKitUnverified => '‏Recovery kit not verified yet‏';

  @override
  String privacyKitVerified(String date) {
    return '‏Recovery kit verified on ‏$date';
  }

  @override
  String get privacyKitWritten => '‏I wrote them down‏';

  @override
  String get privacyNotReady =>
      '‏Private uploads stay off until you have two ways to unlock and have verified your recovery kit.‏';

  @override
  String get privacyPasswordHelp =>
      '‏Enter your account password: it becomes one way to unlock your private libraries.‏';

  @override
  String get privacyPhrase => '‏Recovery phrase‏';

  @override
  String get privacyPhraseHelp => '‏The 24 words of your recovery kit‏';

  @override
  String get privacyPhraseInvalid =>
      '‏This is not a recovery phrase. Check every word.‏';

  @override
  String get privacyReady => '‏Private uploads are on.‏';

  @override
  String get privacyRecoveryKit => '‏Recovery kit‏';

  @override
  String get privacySetUp => '‏Set up‏';

  @override
  String get privacyShowWords => '‏Show the words again‏';

  @override
  String get privacyTitle => '‏Private libraries‏';

  @override
  String privacyUnknownWord(int number) {
    return '‏Word ‏$number‏ is not a recovery kit word.‏';
  }

  @override
  String get privacyVerify => '‏Verify‏';

  @override
  String get privacyVerifyBody =>
      '‏Type these words from your recovery kit to show that you saved it.‏';

  @override
  String get privacyWays => '‏Ways to unlock‏';

  @override
  String privacyWord(int number) {
    return '‏Word ‏$number';
  }

  @override
  String get privacyWordsDiffer =>
      '‏These words do not match your recovery kit. Check what you wrote down.‏';

  @override
  String get privacyWrongPassword => '‏This is not your account\'s password.‏';

  @override
  String get problemAdminOnly => '‏Only an administrator can do this.‏';

  @override
  String get problemBusy => '‏The server is busy or restarting.‏';

  @override
  String get problemChanged => '‏This changed in the meantime.‏';

  @override
  String get problemConfirm =>
      '‏This would hide or delete more items than the server does without a confirmation.‏';

  @override
  String get problemContribute => '‏You may not add photos to this library.‏';

  @override
  String get problemCopy => '‏Copy details‏';

  @override
  String get problemDetails => '‏Details‏';

  @override
  String get problemDiskLow =>
      '‏The server\'s disk is almost full, so uploads are paused.‏';

  @override
  String get problemEmailTaken => '‏Another account has this email.‏';

  @override
  String get problemExists => '‏It exists already.‏';

  @override
  String get problemFaceNotice =>
      '‏Your server asks for a newer version of the faces notice than this app shows.‏';

  @override
  String get problemGone => '‏It is no longer on the server.‏';

  @override
  String get problemHandleTaken => '‏Another account has this sign-in name.‏';

  @override
  String get problemInterrupted => '‏The upload was interrupted.‏';

  @override
  String get problemInvalid => '‏A value is not valid.‏';

  @override
  String get problemLastAdmin =>
      '‏The server needs at least one administrator.‏';

  @override
  String get problemLinkInvalid => '‏This link has expired or was used.‏';

  @override
  String get problemLoginFailed => '‏Wrong email, sign-in name or password.‏';

  @override
  String get problemMaintenanceKey =>
      '‏Backups, scrubs and purges can be paused only when signed in, not with an API key.‏';

  @override
  String get problemNotAllowed => '‏Your account may not do this.‏';

  @override
  String get problemNotExternal =>
      '‏Only libraries of the server\'s own folders can be scanned.‏';

  @override
  String get problemOidcClaim =>
      '‏Your sign-in provider did not say who you are in a way this server accepts.‏';

  @override
  String get problemOidcDown =>
      '‏Your sign-in provider does not answer the server.‏';

  @override
  String get problemOidcFailed =>
      '‏Your sign-in provider refused the sign-in.‏';

  @override
  String get problemOidcNotAllowed =>
      '‏Your account may not sign in this way.‏';

  @override
  String get problemOidcTaken =>
      '‏This sign-in is linked to another Photolib account already.‏';

  @override
  String get problemOidcUnknown =>
      '‏This server no longer offers this way to sign in.‏';

  @override
  String get problemPasskeysOff =>
      '‏Passkeys work only once the server has its public address.‏';

  @override
  String get problemPinned =>
      '‏This is set in the configuration file and cannot be changed here.‏';

  @override
  String get problemPolicyOff => '‏This is switched off on this server.‏';

  @override
  String get problemQuota => '‏Your storage on the server is full.‏';

  @override
  String get problemRestoreKey =>
      '‏A backup can be restored only when signed in, not with an API key.‏';

  @override
  String get problemRootDiffers =>
      '‏This folder does not hold this library\'s files.‏';

  @override
  String get problemRootNotAllowed =>
      '‏This folder is not under the external_roots of the server\'s configuration.‏';

  @override
  String get problemRootOverlaps =>
      '‏This folder holds or lies in another library or the server\'s own data.‏';

  @override
  String get problemScanning => '‏This library is being scanned already.‏';

  @override
  String get problemSecondFactor =>
      '‏This account needs a second factor, such as an authenticator code or a passkey, which this version of Photolib cannot provide yet.‏';

  @override
  String get problemSetupDone => '‏This server already has an administrator.‏';

  @override
  String get problemSetupExpired => '‏This took too long.‏';

  @override
  String get problemSetupToken => '‏This setup token is wrong.‏';

  @override
  String get problemSignedOut => '‏You are signed out of the server.‏';

  @override
  String get problemStepUp =>
      '‏This change needs your password or a code first.‏';

  @override
  String get problemStorage => '‏The server cannot reach its storage.‏';

  @override
  String get problemTooMany => '‏Too many attempts in a short time.‏';

  @override
  String get problemUnexpected => '‏Something unexpected went wrong.‏';

  @override
  String get problemUnreachable => '‏The server does not answer.‏';

  @override
  String get problemUploadDamaged =>
      '‏The file changed or was damaged on the way.‏';

  @override
  String get problemUploadExpired =>
      '‏The server no longer has this upload: unfinished uploads expire after a day.‏';

  @override
  String get problemWebhookLimit =>
      '‏Your account has as many webhooks as it may.‏';

  @override
  String get problemWebhooksOff => '‏Webhooks are turned off on this server.‏';

  @override
  String get recoveryCode => '‏Recovery code‏';

  @override
  String get recoveryCodeAbout =>
      '‏Opens Photolib\'s store on this device if the keystore loses its key‏';

  @override
  String get recoveryCodeEnter => '‏Enter recovery code‏';

  @override
  String get recoveryCreate => '‏Create recovery code‏';

  @override
  String get recoveryLater => '‏Later‏';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString‏ changes exist only on this device. A recovery code gets them back if the keystore loses Photolib\'s key.‏',
      one: '‏1 change exists only on this device. A recovery code gets it back if the keystore loses Photolib\'s key.‏',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      '‏Write these 24 words down and keep them safe: they open Photolib\'s store on this device without its keystore key. They replace any earlier code.‏';

  @override
  String get recoveryUnlock => '‏Unlock‏';

  @override
  String get recoveryWrong => '‏That is not this store\'s recovery code‏';

  @override
  String get renameFind => '‏Find‏';

  @override
  String get renamePattern => '‏New name‏';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': '‏Too long: a name has at most 255 bytes‏',
      'invalid': '‏Not a valid file name‏',
      'duplicate': '‏Given to another file too‏',
      'exists': '‏Another file in this folder has this name‏',
      'other': '‏Cannot be renamed‏',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => '‏Replace with‏';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '‏Files renamed: ‏$countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': '‏Show in Finder‏',
      'windows': '‏Show in Explorer‏',
      'other': '‏Show in folder‏',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => '‏Camera‏';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ items‏',
      one: '‏1 item‏',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => '‏Dates‏';

  @override
  String searchDays(String first, String last) {
    return '$first‏ – ‏$last';
  }

  @override
  String get searchEmpty => '‏Search your library‏';

  @override
  String get searchFavourites => '‏Favourites‏';

  @override
  String get searchFolder => '‏Folder‏';

  @override
  String get searchHint => '‏File name or folder‏';

  @override
  String get searchMotionPhotos => '‏Motion photos‏';

  @override
  String get searchNothing => '‏Nothing matches‏';

  @override
  String get searchPanoramas => '‏Panoramas‏';

  @override
  String get searchPhotos => '‏Photos‏';

  @override
  String get searchScreenshots => '‏Screenshots‏';

  @override
  String get searchVideo => '‏Video‏';

  @override
  String get searchVideos => '‏Videos‏';

  @override
  String get securityAddPasskey => '‏Add a passkey‏';

  @override
  String get securityCode => '‏Code‏';

  @override
  String get securityCodesHelp =>
      '‏Keep these codes somewhere safe. Each works once in place of your second factor, and they are shown only now.‏';

  @override
  String securityCodesLeft(int count) {
    return '‏Unused: ‏$count';
  }

  @override
  String get securityNewCodes => '‏New codes‏';

  @override
  String get securityPasskeyNotAdded => '‏No passkey was added.‏';

  @override
  String get securityRecoveryCodes => '‏Recovery codes‏';

  @override
  String get securityRemovePasskey => '‏Remove passkey‏';

  @override
  String get securitySetUp => '‏Set up‏';

  @override
  String get securityStepUpBody =>
      '‏Enter your password, or a code from your authenticator app or a recovery code, to change your second factors.‏';

  @override
  String get securityStepUpTitle => '‏Confirm it\'s you‏';

  @override
  String get securityTitle => '‏Second factors‏';

  @override
  String get securityTotp => '‏Authenticator app‏';

  @override
  String get securityTotpHelp =>
      '‏Add this key to your authenticator app, then enter the code it shows.‏';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': '‏On‏',
      'other': '‏Off‏',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => '‏Turn off‏';

  @override
  String get securityWrongCode => '‏That code is wrong.‏';

  @override
  String get securityWrongProof => '‏Wrong password or code.‏';

  @override
  String get selectAll => '‏Select all‏';

  @override
  String get selectionClear => '‏Clear selection‏';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ selected‏',
      one: '‏1 selected‏',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => '‏Show selected‏';

  @override
  String get serverAccount => '‏Email or sign-in name‏';

  @override
  String get serverAdd => '‏Add a server‏';

  @override
  String get serverAddressInvalid =>
      '‏Enter addresses such as photos.example.org‏';

  @override
  String get serverAddresses => '‏Addresses‏';

  @override
  String get serverAddressesHelp =>
      '‏One per line: the server on your network, on the internet or through a VPN. The app uses the fastest that answers. Or paste the password setup link you were sent.‏';

  @override
  String get serverCa => '‏Private CA certificate (PEM)‏';

  @override
  String get serverCaChoose => '‏Choose a certificate file‏';

  @override
  String serverCertificateBody(String host) {
    return '$host‏ presents a certificate this device does not trust. Trust it only if this SHA-256 fingerprint is your server\'s:‏';
  }

  @override
  String get serverCertificateTitle => '‏Trust this certificate?‏';

  @override
  String get serverConfirm => '‏Confirm‏';

  @override
  String get serverConnect => '‏Connect‏';

  @override
  String get serverCreateAdmin => '‏Create administrator‏';

  @override
  String get serverEnded => '‏The server ended this session. Sign in again.‏';

  @override
  String get serverHandleHelp =>
      '‏Lowercase letters, digits, dots, dashes and underscores; it never changes.‏';

  @override
  String get serverHeaders => '‏Custom headers‏';

  @override
  String get serverHeadersHelp =>
      '‏One per line, as Name: value, sent over HTTPS only‏';

  @override
  String get serverHeadersInvalid => '‏Write each header as Name: value‏';

  @override
  String get serverIdentity => '‏Client certificate (PKCS#12)‏';

  @override
  String get serverIdentityChoose => '‏Choose a client certificate‏';

  @override
  String get serverIdentityInvalid =>
      '‏This is not a certificate (PKCS#12), or its password is wrong.‏';

  @override
  String get serverIdentityPassword => '‏Client certificate password‏';

  @override
  String get serverLoading => '‏Reading the server kept on this device‏';

  @override
  String get serverNearby => '‏Servers on this network‏';

  @override
  String get serverNeedsHttps =>
      '‏This server needs an HTTPS address: beyond your local network, Photolib does not sign in over plain HTTP.‏';

  @override
  String get serverNoSignIn =>
      '‏This server offers no sign-in this version of Photolib supports.‏';

  @override
  String get serverOffline =>
      '‏The server does not answer. You stay signed in.‏';

  @override
  String get serverPasskeyFailed =>
      '‏No passkey was used. Try again, or use a code.‏';

  @override
  String get serverPasskeyRequired =>
      '‏This server requires a passkey, which this version of Photolib cannot use yet.‏';

  @override
  String get serverPassword => '‏Password‏';

  @override
  String get serverPasswordAgain => '‏Password again‏';

  @override
  String get serverPasswordSetupInvalid =>
      '‏This password setup token is wrong, used or expired. Ask for a new one.‏';

  @override
  String get serverPasswordSetupToken => '‏Password setup token‏';

  @override
  String get serverPasswordSetupTokenHelp =>
      '‏From your administrator, or printed by photolibd admin password-setup on the server.‏';

  @override
  String get serverPasswordsDiffer => '‏The passwords differ.‏';

  @override
  String get serverPrivateLibrariesBody =>
      '‏A new password does not open them. Reopen them with your recovery kit, a passkey or a device that is still signed in.‏';

  @override
  String get serverPrivateLibrariesGo => '‏Set the password‏';

  @override
  String get serverPrivateLibrariesTitle =>
      '‏Your private libraries stay locked‏';

  @override
  String get serverProxy => '‏HTTP proxy, as host:port‏';

  @override
  String get serverProxyInvalid => '‏Enter the proxy as host:port‏';

  @override
  String get serverRecoveryCode => '‏Recovery code‏';

  @override
  String get serverRemove => '‏Remove this server‏';

  @override
  String get serverRequired => '‏Required‏';

  @override
  String get serverSecondFactor =>
      '‏This account\'s second factor is a passkey, which this version of Photolib cannot use yet.‏';

  @override
  String get serverSecondFactorCode =>
      '‏This account also needs a code from your authenticator app, or a recovery code.‏';

  @override
  String get serverSecondFactorTitle => '‏Confirm it\'s you‏';

  @override
  String get serverSecondFactorWrong =>
      '‏That did not work. After five tries, sign in again.‏';

  @override
  String get serverSetPassword => '‏Set password‏';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '‏For ‏$handle‏ on ‏$server';
  }

  @override
  String get serverSetPasswordOpen => '‏Set a password‏';

  @override
  String get serverSetPasswordTitle => '‏Set your password‏';

  @override
  String get serverSetUp => '‏Set up a new server‏';

  @override
  String get serverSetupLinkElsewhere =>
      '‏To use this setup link, sign out of this server first, or remove it if the link is for another one.‏';

  @override
  String get serverSetupTitle => '‏Set up the server‏';

  @override
  String get serverSetupToken => '‏Setup token‏';

  @override
  String get serverSetupTokenHelp =>
      '‏photolibd prints it in its log while the server has no administrator; each start prints a new one.‏';

  @override
  String get serverSignIn => '‏Sign in‏';

  @override
  String get serverSignOut => '‏Sign out‏';

  @override
  String serverSignedInAs(String account) {
    return '‏Signed in as ‏$account';
  }

  @override
  String get serverSignedOut => '‏Signed out‏';

  @override
  String get serverSwitch => '‏Switch account‏';

  @override
  String get serverTotpCode => '‏Code from your authenticator app‏';

  @override
  String get serverTrust => '‏Trust‏';

  @override
  String get serverUnreadable =>
      '‏The server kept on this device cannot be read‏';

  @override
  String get serverUsePasskey => '‏Use a passkey‏';

  @override
  String get serverUseRecoveryCode => '‏Use a recovery code instead‏';

  @override
  String get settingsBackground => '‏Behind transparent images‏';

  @override
  String get settingsDateFormat => '‏Date format‏';

  @override
  String get settingsDefaultTab => '‏Folders and albums open on‏';

  @override
  String get settingsFolders => '‏Folders‏';

  @override
  String get settingsIndexing => '‏Indexing on this device‏';

  @override
  String get settingsLanguage => '‏Language‏';

  @override
  String get settingsLibrary => '‏Library‏';

  @override
  String get settingsServer => '‏Server‏';

  @override
  String get settingsStart => '‏Start screen‏';

  @override
  String get settingsTheme => '‏Theme‏';

  @override
  String get settingsTitle => '‏Settings‏';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': '‏Tap the left or right edge for the previous or next item‏',
      'oneFingerZoom': '‏Double-tap and drag to zoom with one finger‏',
      'swipes': '‏Swipe up or down on a video\'s left side for brightness, right side for volume‏',
      'maxBrightness': '‏Full brightness while viewing‏',
      'autoRotate': '‏Turn to each photo\'s or video\'s orientation‏',
      'mixAudio': '‏Play videos over other audio instead of pausing it‏',
      'autoplay': '‏Play videos as they open‏',
      'loop': '‏Loop videos‏',
      'autoNext': '‏Go to the next item when a video ends‏',
      'resume': '‏Resume videos where they were left‏',
      'other': '‏Play animated images in the grid‏',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      '‏How long Photolib keeps items in its trash‏';

  @override
  String get settingsViewerBar => '‏Buttons in the viewer\'s bar‏';

  @override
  String get settingsViewing => '‏Viewing‏';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString‏ shared photos and videos wait until Photolib may add to your Photos library. Unsaved items are deleted after 7 days.‏',
      one: '‏1 shared photo or video waits until Photolib may add to your Photos library. Unsaved items are deleted after 7 days.‏',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      '‏Too large to share at once: select fewer items‏';

  @override
  String shareTooMany(int count) {
    return '‏Too many to share at once: select ‏$count‏ or fewer‏';
  }

  @override
  String get shortcutsTitle => '‏Keyboard shortcuts‏';

  @override
  String get slideshow => '‏Slideshow‏';

  @override
  String get slideshowLoop => '‏Repeat‏';

  @override
  String get slideshowOptions => '‏Slideshow options‏';

  @override
  String get slideshowSeconds => '‏Seconds per item‏';

  @override
  String get slideshowShuffle => '‏Shuffle‏';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': '‏Descending‏',
      'other': '‏Ascending‏',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => '‏This device‏';

  @override
  String sourceHide(String name) {
    return '‏Hide ‏$name';
  }

  @override
  String get sourceHideOthers => '‏Hide everything else here‏';

  @override
  String get sourceLost => '‏No access‏';

  @override
  String get sourcePartly => '‏Partly shown‏';

  @override
  String sourceShow(String name) {
    return '‏Show ‏$name';
  }

  @override
  String get sourceShowEverything => '‏Show everything here‏';

  @override
  String get sourceShowOnly => '‏Show only this‏';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': '‏Timeline‏',
      'folders': '‏Folders and albums‏',
      'favourites': '‏Favourites‏',
      'other': '‏Timeline‏',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => '‏Keep a person offline‏';

  @override
  String get storageBudget => '‏Storage budget‏';

  @override
  String get storageClear => '‏Remove offline copies‏';

  @override
  String get storageClearAction => '‏Remove‏';

  @override
  String storageClearBody(String size) {
    return '‏This removes ‏$size‏ kept on this device and stops keeping albums, searches and photos offline. Your library on the server is not touched.‏';
  }

  @override
  String get storageKeepLibrary => '‏Keep the whole library‏';

  @override
  String get storageKeepOriginals => '‏Keep originals too‏';

  @override
  String get storageNoPeople => '‏No people are named yet.‏';

  @override
  String get storageNoPins =>
      '‏Nothing is pinned. Pin an album, a search or a photo to keep it offline.‏';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '‏Album‏',
      'search': '‏Search‏',
      'person': '‏Person‏',
      'library': '‏Whole library‏',
      'asset': '‏Photo‏',
      'other': '‏Pinned‏',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return '‏Does not fit the budget: ‏$size‏ more needed‏';
  }

  @override
  String get storagePinNothing =>
      '‏Nothing to download: its photos are on this device already‏';

  @override
  String get storagePinPaused => '‏Waiting: this preset keeps nothing offline‏';

  @override
  String get storagePinPlanning => '‏Looking up what to keep…‏';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return '‏Downloading: ‏$haveString‏ of ‏$filesString';
  }

  @override
  String storagePinReady(String size) {
    return '‏Available offline (‏$size‏)‏';
  }

  @override
  String get storagePinWaiting => '‏Will download when online‏';

  @override
  String get storagePins => '‏Kept offline‏';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '‏Catalogue only‏',
      'spaceSaver': '‏Space saver‏',
      'travel': '‏Selected albums offline‏',
      'everything': '‏Everything‏',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          '‏Keeps nothing; photos load from your server when you open them.‏',
      'spaceSaver': '‏Keeps previews of your whole library, newest first, within the budget.‏',
      'travel': '‏Keeps only what you pin: albums, searches and photos.‏',
      'everything': '‏Keeps the originals of your whole library, newest first, within the budget.‏',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => '‏What this device keeps‏';

  @override
  String get storageSubtitle => '‏Offline copies and storage budget‏';

  @override
  String get storageTitle => '‏Storage‏';

  @override
  String storageUsed(String used, String budget) {
    return '$used‏ of ‏$budget‏ used‏';
  }

  @override
  String get storageWebNote =>
      '‏A browser keeps previews only, and erases them when you sign out.‏';

  @override
  String get storeNoKeyring =>
      '‏Photolib keeps the key of its local store in the system keyring, which did not answer. Install and unlock gnome-keyring, KWallet or KeePassXC with its Secret Service on, then try again.‏';

  @override
  String get storeNoKeystore =>
      '‏Photolib could not reach this device\'s keystore, which holds the key of its local store.‏';

  @override
  String get storeRebuilt =>
      '‏This device\'s keystore no longer had the key of Photolib\'s local store, so the store was rebuilt. Its settings and what existed only on this device are lost; libraries sync again and thumbnails come back.‏';

  @override
  String get storeRecoveryNeeded =>
      '‏This device\'s keystore no longer has the key of Photolib\'s local store. Enter its recovery code, or reset the store and lose what exists only on this device.‏';

  @override
  String get storeReset => '‏Reset store‏';

  @override
  String get storeResetBody =>
      '‏What exists only on this device is lost; libraries sync again and thumbnails come back.‏';

  @override
  String get storeUnavailable =>
      '‏The store on this device is unavailable: settings and collections are not kept‏';

  @override
  String get tabCollections => '‏Collections‏';

  @override
  String get tabLibrary => '‏Library‏';

  @override
  String get tabSearch => '‏Search‏';

  @override
  String get themeDark => '‏Dark‏';

  @override
  String get themeLight => '‏Light‏';

  @override
  String get themeSystem => '‏System‏';

  @override
  String get timelineBenchmark => '‏Timeline benchmark‏';

  @override
  String get timelineBenchmarkCopy => '‏Copy the results‏';

  @override
  String get timelineCannotPlay => '‏Can\'t play in this browser‏';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date‏, ‏$position‏ of ‏$count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date‏, ‏$position‏ of ‏$count‏, no preview‏';
  }

  @override
  String get timelineExcluded => '‏In an excluded folder‏';

  @override
  String get timelineScrubber => '‏Scroll by date‏';

  @override
  String get timelineSphere => '‏360°‏';

  @override
  String get timelineUndated => '‏Date unknown‏';

  @override
  String timelineWeek(String date) {
    return '‏Week of ‏$date';
  }

  @override
  String toolbarAdd(String action) {
    return '‏Add ‏$action‏ to the bar‏';
  }

  @override
  String toolbarDown(String action) {
    return '‏Move ‏$action‏ down‏';
  }

  @override
  String get toolbarInBar => '‏In the bar‏';

  @override
  String get toolbarInMenu => '‏In the ⋮ menu‏';

  @override
  String toolbarRemove(String action) {
    return '‏Remove ‏$action‏ from the bar‏';
  }

  @override
  String get toolbarReset => '‏Reset to default‏';

  @override
  String toolbarUp(String action) {
    return '‏Move ‏$action‏ up‏';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': '‏Move here‏',
      'other': '‏Copy here‏',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': '‏A file or folder of this name is already there‏',
      'changed': '‏The copy did not match the original and was removed‏',
      'cancelled': '‏Cancelled‏',
      'invalid': '‏Not a valid folder name‏',
      'other': '‏Failed‏',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => '‏Recent‏';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '‏Delete ‏$countString‏ items forever? This cannot be undone.‏',
      one: '‏Delete 1 item forever? This cannot be undone.‏',
    );
    return '$_temp0';
  }

  @override
  String trashDaysLeft(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$daysString‏ days left‏',
      one: '‏1 day left‏',
      zero: '‏Deleted forever today‏',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => '‏The trash is empty‏';

  @override
  String get trashEmptyAll => '‏Empty trash‏';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString‏ days‏';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ items moved to the trash‏',
      one: '‏1 item moved to the trash‏',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => '‏Remove from list‏';

  @override
  String trashRetention(int days) {
    return '‏Photolib deletes what it keeps in the trash for good after ‏$days‏ days; each item shows the time it has left.‏';
  }

  @override
  String get trashTitle => '‏Trash‏';

  @override
  String get undo => '‏Undo‏';

  @override
  String get uploadAction => '‏Upload photos and videos‏';

  @override
  String get uploadClear => '‏Clear‏';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '‏Uploaded ‏$doneString‏ of ‏$totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '‏Failed: ‏$countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ items archived‏',
      one: '‏1 item archived‏',
    );
    return '$_temp0';
  }

  @override
  String veilHidden(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString‏ items hidden‏',
      one: '‏1 item hidden‏',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': '‏Black‏',
      'white': '‏White‏',
      'other': '‏Checkerboard‏',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => '‏This video cannot play on this device‏';

  @override
  String get viewerCaptions => '‏Captions‏';

  @override
  String get viewerCompass => '‏Compass lock‏';

  @override
  String get viewerCopy => '‏Copy‏';

  @override
  String get viewerCopyText => '‏Copy text‏';

  @override
  String get viewerCustomize => '‏Customize toolbar…‏';

  @override
  String get viewerDial =>
      '‏Heading. Click to face front. Drag to look around, scroll or pinch to zoom, double-click to reset‏';

  @override
  String get viewerFilmstrip => '‏Filmstrip‏';

  @override
  String get viewerFirst => '‏First‏';

  @override
  String get viewerFisheye => '‏Fisheye‏';

  @override
  String get viewerGyroscope => '‏Move to look around‏';

  @override
  String get viewerHdr => '‏Show in HDR‏';

  @override
  String get viewerInfo => '‏Info‏';

  @override
  String get viewerInfoLoading => '‏Loading this item\'s info‏';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString‏ of ‏$countString';
  }

  @override
  String get viewerLast => '‏Last‏';

  @override
  String get viewerLenses => '‏Choose a lens‏';

  @override
  String get viewerMap => '‏Map‏';

  @override
  String get viewerMotion => '‏Play motion‏';

  @override
  String get viewerMotionDenied =>
      '‏This browser did not allow access to the motion sensors‏';

  @override
  String get viewerMotionMissing =>
      '‏This device has no gyroscope to look around with‏';

  @override
  String get viewerMute => '‏Mute‏';

  @override
  String get viewerNext => '‏Next‏';

  @override
  String get viewerNextFrame => '‏Next frame‏';

  @override
  String get viewerPause => '‏Pause‏';

  @override
  String get viewerPlanet => '‏Little planet‏';

  @override
  String get viewerPlay => '‏Play‏';

  @override
  String get viewerPrevious => '‏Previous‏';

  @override
  String get viewerPreviousFrame => '‏Previous frame‏';

  @override
  String get viewerRotate => '‏Rotate‏';

  @override
  String get viewerSdr => '‏Show in SDR‏';

  @override
  String get viewerSeek => '‏Position‏';

  @override
  String get viewerSetAs => '‏Set as‏';

  @override
  String get viewerShare => '‏Share‏';

  @override
  String get viewerSpeed => '‏Playback speed‏';

  @override
  String get viewerSphere => '‏360° view. Drag to look around, pinch to zoom‏';

  @override
  String get viewerText => '‏Text in this photo‏';

  @override
  String get viewerTextCopied => '‏Text copied‏';

  @override
  String get viewerTextNone => '‏No text found in this photo‏';

  @override
  String get viewerTextUnread => '‏This photo\'s text has not been read yet‏';

  @override
  String get viewerUnmute => '‏Unmute‏';

  @override
  String get viewerZoomIn => '‏Zoom in‏';

  @override
  String get viewerZoomOut => '‏Zoom out‏';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': '‏SD card‏',
      'other': '‏Internal‏',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => '‏Zoom in‏';

  @override
  String get zoomOut => '‏Zoom out‏';
}
