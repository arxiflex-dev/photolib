// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get actionAddToAlbum => 'הוספה לאלבום';

  @override
  String get actionArchive => 'העברה לארכיון';

  @override
  String get actionCopyTo => 'העתקה אל…';

  @override
  String get actionDeleteForever => 'מחיקה לצמיתות';

  @override
  String get actionFavourite => 'הוספה למועדפים';

  @override
  String get actionHide => 'הסתרה';

  @override
  String get actionMoveTo => 'העברה אל…';

  @override
  String get actionRename => 'שינוי שם';

  @override
  String get actionRestore => 'שחזור';

  @override
  String get actionShare => 'שיתוף';

  @override
  String get actionTrash => 'העברה לאשפה';

  @override
  String get actionUnarchive => 'הוצאה מהארכיון';

  @override
  String get actionUndo => 'ביטול';

  @override
  String get actionUnfavourite => 'הסרה מהמועדפים';

  @override
  String get actionUnhide => 'הצגה';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'פעיל',
      'disabled': 'מושבת',
      'invited': 'הוזמן',
      'deleted': 'נמחק',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'חשבונות';

  @override
  String get adminAddAccount => 'הוספת חשבון';

  @override
  String get adminAddExternalLibrary => 'הוספת ספרייה חיצונית';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts ניסיונות',
      two: 'שני ניסיונות',
      one: 'ניסיון אחד',
      zero: 'עדיין לא הופעלה',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'יומן ביקורת';

  @override
  String get adminBackUpNow => 'גיבוי עכשיו';

  @override
  String get adminBackupQueued => 'הגיבוי ממתין בתור; אחריו יבוא תרגול שחזור';

  @override
  String get adminBackups => 'גיבויים של מסד הנתונים';

  @override
  String get adminCancelJob => 'ביטול המשימה';

  @override
  String get adminCapabilities => 'יכולות';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'ספריות מנוהלות',
      'uploads': 'העלאות ממכשירים, מהאינטרנט ומשורת הפקודה',
      'folder_browser': 'דפדפן תיקיות',
      'device_folders': 'תיקיות המכשיר באפליקציות מחוברות',
      'sharing': 'שיתוף וקישורים ציבוריים',
      'edits': 'עריכות',
      'deletes': 'מחיקות',
      'xmp_writes': 'כתיבת קובצי XMP',
      'face_recognition': 'זיהוי פנים',
      'ml_search': 'חיפוש חכם',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'תקינה',
      'warn': 'אזהרה',
      'fail': 'נכשלה',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'הועתק';

  @override
  String get adminCopyBundle => 'העתקת נתוני האבחון לדיווח על באג';

  @override
  String get adminCopyLink => 'העתקת הקישור';

  @override
  String get adminDelete => 'מחיקה';

  @override
  String get adminDeviceBackups => 'גיבויי מכשירים';

  @override
  String get adminDevices => 'המכשירים שלך';

  @override
  String get adminDisable => 'השבתה';

  @override
  String adminDrillFailed(String detail) {
    return 'תרגול השחזור האחרון נכשל: $detail';
  }

  @override
  String get adminEdit => 'עריכה';

  @override
  String get adminEmail => 'אימייל';

  @override
  String get adminEnable => 'הפעלה';

  @override
  String get adminErrorSignIn => 'יש להיכנס עם חשבון של מנהל מערכת';

  @override
  String get adminFacesDefault => 'זיהוי פנים מופעל כברירת מחדל בחשבונות חדשים';

  @override
  String get adminFiles => 'קבצים לפי סוג';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'פגום',
      'missing': 'חסר',
      'size': 'גודל שגוי',
      'hash': 'הוחלף',
      'orphan': 'קובץ יתום',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size פנויים';
  }

  @override
  String get adminFreeDisk =>
      'השהיית העלאות כשהמקום הפנוי בדיסק יורד מתחת לאחוז הזה, 0 עד 50';

  @override
  String get adminFreeDiskGb =>
      'או מתחת למקום הפנוי הזה ב-GB, אם הוא קטן יותר, 0 עד 100000';

  @override
  String get adminHandle => 'שם משתמש';

  @override
  String get adminIntegrity => 'שלמות';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString פריטים',
      two: 'שני פריטים',
      one: 'פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'בתור',
      'running': 'פועלת',
      'done': 'הסתיימה',
      'dead': 'נכשלה',
      'cancelled': 'בוטלה',
      'other': 'הכול',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'סוג משימה, למשל render';

  @override
  String get adminJobs => 'משימות';

  @override
  String adminLastSeen(String time) {
    return 'פעילות אחרונה: $time';
  }

  @override
  String get adminLibraries => 'ספריות';

  @override
  String get adminLibraryOwner => 'בעלים';

  @override
  String get adminLibraryRoot => 'תיקייה בשרת, למשל /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'זמינה',
      'offline': 'לא זמינה',
      'scanning': 'בסריקה',
      'error': 'שגיאה',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'יומן השרת';

  @override
  String get adminName => 'שם';

  @override
  String get adminNothing => 'אין כאן עדיין כלום';

  @override
  String get adminOutOfRange => 'מחוץ לטווח';

  @override
  String get adminOverview => 'סקירה כללית';

  @override
  String get adminPair => 'צימוד מכשיר';

  @override
  String get adminPairBody =>
      'אפשר לסרוק את הקוד או לשלוח את הקישור, ואז להדביק אותו ב„הוספת שרת” ב-Photolib במכשיר החדש: הוא מביא את כל הכתובות של השרת הזה ואת האישור שלו, כך שאף אחד לא צריך להקליד אותם.';

  @override
  String get adminPasswordSetup => 'קישור להגדרת סיסמה';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'שלחו את הקישור הזה אל $name בכל דרך, או תנו לסרוק את הקוד. הוא מגדיר סיסמה פעם אחת, עד $date.';
  }

  @override
  String get adminPause => 'השהיית סוג משימות';

  @override
  String adminPauseMinutes(int max) {
    return 'דקות, 1 עד $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return 'משימות מסוג $type מושהות עד $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'נותרו $countString פריטים לגיבוי',
      two: 'נותרו שני פריטים לגיבוי',
      one: 'נותר פריט אחד לגיבוי',
      zero: 'אין מה לגבות',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'מדיניות';

  @override
  String get adminPolicyReset => 'שימוש בערך של הרמה שמעל';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'מופעל כברירת מחדל',
      'server': 'נקבע לשרת',
      'user': 'נקבע לחשבון הזה',
      'library': 'נקבע לספרייה הזו',
      'config': 'נקבע בקובץ התצורה',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'החלת הגדרה מוכנה';

  @override
  String get adminPresetBody =>
      'הגדרה מוכנה קובעת כל יכולת לשרת ומוחקת את מה שחשבונות וספריות קבעו. הכול נשאר ניתן לעריכה.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'צפייה בארכיון',
      'family_backup': 'גיבוי משפחתי',
      'personal': 'אישי',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'הספריות החיצוניות לקריאה בלבד הן מקור האמת היחיד: בלי העלאות, ספריות מנוהלות, תיקיות מכשיר, עריכות, מחיקות או כתיבת XMP',
      'family_backup': 'הכול מופעל מלבד כתיבת XMP',
      'personal': 'הכול מופעל מלבד שיתוף וקישורים ציבוריים',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'קוד QR של הקישור';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString משימות נוספו לתור',
      two: 'שתי משימות נוספו לתור',
      one: 'משימה אחת נוספה לתור',
      zero: 'אין מה לעבד',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'מכסת אחסון ב-GB; להשאיר ריק ללא מכסה';

  @override
  String get adminRemote => 'גישה מרחוק';

  @override
  String get adminRemoteBody =>
      'אפשר להגיע לשרת מכל מקום בלי לפתוח פורט בנתב. בוחרים דרך אחת; כל אחת נותנת לו כתובת HTTPS להוספה לאפליקציות. אחר כך בודקים אותה מבחוץ.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared מתחבר החוצה ל-Cloudflare, שמגיש את הדומיין שלך ב-HTTPS. התוכנית החינמית מגבילה בקשה ל-100 MB, שהגיבויים אף פעם לא מגיעים אליהם: הם שולחים 8 MiB בכל פעם.';

  @override
  String get adminRemoteNoAddress =>
      'כדי לבדוק מבחוץ, יש להוסיף לאפליקציה את כתובת ה-https:// של השרת.';

  @override
  String get adminRemoteReachable => 'נגיש מבחוץ.';

  @override
  String get adminRemoteTailscale =>
      'יש להתקין Tailscale במחשב של השרת ובכל מכשיר, באותו tailnet או ב-Headscale שלך, ואז להריץ את זה במחשב של השרת ולהגדיר את public_url לכתובת שתודפס.';

  @override
  String get adminRemoteTest => 'בדיקה מבחוץ';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host יפתח את $url מהשרתים שלו ברחבי העולם, וכך יכיר את הכתובת הזו. להמשיך?';
  }

  @override
  String get adminRemoteUnreachable =>
      'לא נגיש מבחוץ: כדאי לבדוק את הדרך שנבחרה ולנסות שוב.';

  @override
  String get adminRemoteWireguard =>
      'נדרש פורט UDP פתוח אחד בצד של השרת או בצומת מרכזי. זו התצורה של מכשיר; יוצרים מפתחות עם wg genkey.';

  @override
  String get adminRepair => 'החזירו אותו מגיבוי או ממכשיר שעדיין שומר אותו';

  @override
  String get adminRepairOrphan =>
      'אף תמונה לא מפנה אליו: בדקו אותו ואז מחקו או שמרו';

  @override
  String get adminReprocess => 'עיבוד מחדש';

  @override
  String get adminReprocessFaces => 'זיהוי פנים מחדש';

  @override
  String get adminReprocessFolder =>
      'תיקייה, למשל 2024/05; להשאיר ריק לכל הספרייה';

  @override
  String get adminReprocessMetadata => 'קריאת המטא-נתונים מחדש';

  @override
  String get adminReprocessRenditions =>
      'יצירה מחדש של תמונות ממוזערות ותצוגות מקדימות';

  @override
  String get adminRestore => 'שחזור';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'השחזור של $name נכשל: $detail';
  }

  @override
  String get adminRestoreUnverified => 'אף תרגול שחזור עדיין לא עבר';

  @override
  String adminRestoreVerified(String when) {
    return 'השחזור המאומת האחרון: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd נעצר, ובהפעלה הבאה מחליף את כל מסד הנתונים ב־$name. מה שהשתנה מאז הגיבוי הזה יאבד, וכל מכשיר יסונכרן מההתחלה.';
  }

  @override
  String get adminRestoring => 'photolibd נעצר כדי לשחזר את הגיבוי';

  @override
  String get adminResume => 'המשך';

  @override
  String get adminRetry => 'ניסיון חוזר';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'מנהל מערכת',
      'user': 'משתמש',
      'viewer': 'צופה',
      'other': 'לא ידוע',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'נשמר';

  @override
  String get adminScan => 'סריקה עכשיו';

  @override
  String get adminScrubDays => 'ימים שבהם הבדיקה עוברת על כל מקור, 1 עד 3650';

  @override
  String get adminScrubNever => 'בדיקה מלאה ראשונה מתבצעת';

  @override
  String adminScrubbed(String time) {
    return 'בדיקה מלאה אחרונה $time';
  }

  @override
  String get adminSecondAdmin =>
      'כדאי להפוך אדם נוסף למנהל, כדי שמישהו אחר יוכל להפעיל ולשחזר את השרת כשאין לך אפשרות.';

  @override
  String adminSilent(String time) {
    return 'שקט מאז $time';
  }

  @override
  String get adminSilentHours =>
      'שעות ללא דיווח עד שגיבוי של מכשיר נחשב שקט, 1 עד 8760';

  @override
  String get adminStores => 'אחסון';

  @override
  String get adminThisDevice => 'המכשיר הזה';

  @override
  String get adminTitle => 'ניהול השרת';

  @override
  String get adminTrashDays => 'ימים באשפה, 1 עד 3650';

  @override
  String get adminTwoFactor => 'חובה להגדיר גורם אימות שני בכל החשבונות';

  @override
  String get adminUsage => 'שימוש לפי חשבון';

  @override
  String get albumCover => 'שימוש כעטיפה';

  @override
  String get albumEmpty => 'האלבום הזה ריק';

  @override
  String get albumHideMemories => 'הסתר מהזכרונות';

  @override
  String get albumHideTimeline => 'הסתר מציר הזמן';

  @override
  String get albumNew => 'אלבום חדש';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'כל תאריך';

  @override
  String get backupCap => 'הפריט הגדול ביותר';

  @override
  String get backupCharging => 'רק בזמן טעינה';

  @override
  String backupCompleted(String time) {
    return 'גיבוי מלא אחרון: $time';
  }

  @override
  String backupContact(String time) {
    return 'קשר אחרון עם השרת: $time';
  }

  @override
  String get backupEnabled => 'גיבוי המכשיר הזה';

  @override
  String get backupFolderNo => 'לא את זו';

  @override
  String get backupFolderYes => 'לגבות';

  @override
  String backupHours(int count) {
    return '$count שע׳';
  }

  @override
  String get backupMetered =>
      'ברשתות מוגבלות, כמו נתונים סלולריים או נקודה חמה';

  @override
  String get backupNever => 'אין עדיין גיבוי מלא';

  @override
  String backupNewFolder(String name) {
    return 'תיקייה חדשה $name: לגבות אותה?';
  }

  @override
  String get backupNoLimit => 'ללא הגבלה';

  @override
  String get backupNothing => 'אין פריטים ממתינים';

  @override
  String get backupNow => 'גיבוי עכשיו';

  @override
  String backupOverdue(int hours, String items) {
    return 'אין גיבוי מלא כבר $hours שע׳. ממתינים: $items';
  }

  @override
  String get backupOverdueTitle => 'הגיבוי לא הושלם';

  @override
  String backupPending(String items) {
    return 'ממתינים: $items';
  }

  @override
  String backupRetry(String time) {
    return 'ניסיון חוזר: $time';
  }

  @override
  String get backupRoaming => 'גיבוי בזמן נדידה';

  @override
  String get backupSignIn => 'התחבר לשרת כדי לגבות את המכשיר הזה';

  @override
  String get backupSignedOut =>
      'הגיבוי נעצר: השרת ניתק את המכשיר הזה. התחבר שוב בהגדרות.';

  @override
  String get backupSince => 'צולמו מאז';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'הגיבוי ממתין עד שהשרת יהיה זמין',
      'charging': 'הגיבוי ממתין עד שהמכשיר ייטען',
      'battery_low': 'הגיבוי ממתין: הסוללה חלשה',
      'roaming': 'הגיבוי ממתין בזמן נדידה',
      'quota': 'הגיבוי נעצר: האחסון שלך בשרת מלא',
      'second_factor': 'הגיבוי נעצר: השרת דורש גורם שני לחשבון הזה',
      'other': 'הגיבוי נעצר: השרת השיב $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'גיבוי';

  @override
  String get backupWaiting => 'לא מגובה';

  @override
  String get backupWarnAfter => 'להזהיר אם לא הושלם במשך';

  @override
  String get backupWhat => 'מה לגבות';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'בתיקייה שלא בחרת',
      'folder_new': 'בתיקייה חדשה: בחר אם לגבות אותה',
      'type_excluded': 'סוג פריט שלא בחרת',
      'before_date': 'צולם לפני התאריך שבחרת',
      'selected': 'ממתין לתורו',
      'server_restored': 'השרת איבד אותו בשחזור: נשלח שוב',
      'working': 'מגובה כעת',
      'waiting_for_icloud': 'ממתין להורדה מ-iCloud',
      'metered': 'ממתין לרשת לא מוגבלת',
      'metered_cap': 'גדול מדי לרשת מוגבלת',
      'unreadable': 'המכשיר הזה לא יכול לקרוא אותו',
      'changed': 'השתנה בזמן השליחה',
      'quota': 'האחסון שלך בשרת מלא',
      'other': 'השרת דחה אותו: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld => 'השרת כבר לא עובד עם הגרסה הזו של Photolib.';

  @override
  String get checkAppTooOldNext => 'יש לעדכן את Photolib.';

  @override
  String get checkChanged => 'האישור של השרת הוא לא זה שסמכת עליו.';

  @override
  String get checkChangedNext =>
      'אם המנהל החליף אותו, אפשר לסמוך על החדש. אם לא, ייתכן שמישהו מאזין: לא להמשיך.';

  @override
  String get checkClock =>
      'השעון של המכשיר הזה ושל השרת שונים ביותר מחמש דקות.';

  @override
  String get checkClockNext =>
      'כדאי לאפשר למכשיר לכוון את התאריך והשעה אוטומטית.';

  @override
  String get checkDnsFailed => 'שם השרת לא מוביל לשום כתובת.';

  @override
  String get checkDnsFailedNext =>
      'כדאי לבדוק את הכתובת או להתחבר לרשת של השרת.';

  @override
  String checkExpired(String date) {
    return 'תוקף האישור של השרת פג ב-$date.';
  }

  @override
  String get checkFailed => 'נכשל';

  @override
  String get checkMetered => 'המכשיר ברשת עם חיוב לפי שימוש, כמו חבילת גלישה.';

  @override
  String get checkMeteredNext => 'כדאי להתחבר ל-Wi-Fi לפני גיבויים גדולים.';

  @override
  String get checkNotPhotolib =>
      'משהו שאינו Photolib עונה, למשל דף שגיאה של שרת Proxy או דף התחברות ל-Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'כדאי להתחבר ל-Wi-Fi בדפדפן, או לבקש מהמנהל לבדוק את שרת ה-Proxy.';

  @override
  String get checkOtherServer => 'שרת Photolib אחר עונה בכתובת הזו.';

  @override
  String get checkPassed => 'עבר';

  @override
  String get checkRefused => 'שום דבר לא עונה בכתובת הזו.';

  @override
  String get checkRefusedNext =>
      'כדאי לוודא שהשרת פועל ושהמכשיר ברשת שלו או ב-VPN שלו.';

  @override
  String get checkRun => 'בדיקת החיבור';

  @override
  String get checkRunning => 'בבדיקה';

  @override
  String get checkSelfSigned =>
      'השרת משתמש באישור משלו, שהמכשיר הזה עדיין לא מכיר.';

  @override
  String get checkSkipped => 'לא נבדק';

  @override
  String get checkStepAuth => 'ההתחברות שלך';

  @override
  String get checkStepClock => 'השעון במכשיר';

  @override
  String get checkStepDns => 'איתור כתובת השרת';

  @override
  String get checkStepNetwork => 'הרשת שלך';

  @override
  String get checkStepServer => 'Photolib בשרת';

  @override
  String get checkStepTcp => 'הגעה לשרת';

  @override
  String get checkStepTls => 'חיבור מאובטח ואישור';

  @override
  String get checkStepUpload => 'העלאות גדולות דרך שרתי Proxy';

  @override
  String get checkTimedOut => 'לשרת לוקח יותר מדי זמן לענות.';

  @override
  String get checkTimedOutNext => 'כדאי לבדוק את החיבור ולנסות שוב.';

  @override
  String get checkTitle => 'בדיקת חיבור';

  @override
  String get checkTlsFailed => 'החיבור המאובטח נכשל.';

  @override
  String get checkTrustNext =>
      'כדאי לסמוך עליו רק אם טביעת האצבע שלו תואמת לזו של השרת שלך.';

  @override
  String get checkUntrusted =>
      'האישור של השרת הונפק על ידי רשות שהמכשיר הזה לא סומך עליה.';

  @override
  String get checkUploadCap =>
      'שרת Proxy בדרך דוחה העלאות גדולות, ולכן הגיבויים איטיים יותר, בחלקים קטנים.';

  @override
  String get checkUploadCapNext =>
      'כדאי לבקש מהמנהל לאפשר לבקשות של 64 MB לעבור דרך שרת ה-Proxy.';

  @override
  String get collectionAlbums => 'אלבומים';

  @override
  String collectionHide(String name) {
    return 'הסתרת $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'הזזת $name למטה';
  }

  @override
  String collectionMoveUp(String name) {
    return 'הזזת $name למעלה';
  }

  @override
  String get collectionPeople => 'אנשים';

  @override
  String collectionPin(String name) {
    return 'הצמדת $name';
  }

  @override
  String get collectionPlaces => 'מקומות';

  @override
  String collectionShow(String name) {
    return 'הצגת $name';
  }

  @override
  String get collectionTags => 'תגים';

  @override
  String collectionUnpin(String name) {
    return 'ביטול ההצמדה של $name';
  }

  @override
  String get collectionsCustomise => 'התאמה אישית';

  @override
  String get collectionsDone => 'סיום';

  @override
  String get commandPalette => 'לוח פקודות';

  @override
  String get commandPaletteHint => 'יש להקליד פקודה';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString במכשיר זה ומגובים',
      two: 'שני פריטים במכשיר זה ומגובים',
      one: 'פריט אחד במכשיר זה ומגובה',
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
      other: '$countString במכשיר זה בלבד, לא מגובים',
      two: 'שני פריטים במכשיר זה בלבד, לא מגובים',
      one: 'פריט אחד במכשיר זה בלבד, לא מגובה',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'כשתמונות iCloud מופעלות, פריטים שנמחקים ממכשיר זה נמחקים גם מ-iCloud ומשאר מכשירי Apple שלך.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString בספרייה שלך בלבד',
      two: 'שני פריטים בספרייה שלך בלבד',
      one: 'פריט אחד בספרייה שלך בלבד',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'הסרה ממכשיר זה';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString הפריטים המגובים; הספרייה שלך שומרת אותם',
      two: 'שני הפריטים המגובים; הספרייה שלך שומרת אותם',
      one: 'הפריט המגובה; הספרייה שלך שומרת אותו',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'העותקים במכשיר זה עוברים לאשפה שלו: השטח מתפנה לאחר ריקונה.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'למחוק $countString פריטים?',
      two: 'למחוק שני פריטים?',
      one: 'למחוק פריט אחד?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'ממכשיר זה ומהספרייה שלך',
      'device': 'ממכשיר זה בלבד',
      'other': 'מהספרייה שלך',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'לא קיימת';

  @override
  String get deviceFolderCard => 'כרטיס SD';

  @override
  String get deviceFolderExclude => 'החרגה';

  @override
  String get deviceFolderExcludeThis => 'החרגת התיקייה הזו';

  @override
  String get deviceFolderExcludedNotice =>
      'התיקייה של הפריט הזה מוחרגת מהספרייה';

  @override
  String get deviceFolderForget => 'הסרה מהרשימה';

  @override
  String get deviceFolderInternal => 'אחסון פנימי';

  @override
  String get deviceFolderKeep => 'השארה';

  @override
  String deviceFolderNew(String name, String items) {
    return 'תיקייה חדשה: $name, $items';
  }

  @override
  String get deviceFolders => 'תיקיות במכשיר';

  @override
  String get deviceFoldersAll => 'הצגת כל התיקיות מלבד המוחרגות';

  @override
  String get deviceFoldersChosen => 'הצגת התיקיות שנבחרו בלבד';

  @override
  String get deviceFoldersExcludedNow => 'הוחרג מהספרייה';

  @override
  String get deviceFoldersSearch => 'חיפוש תיקיות';

  @override
  String get diagnosticsAdvanced => 'הצגת אבחון';

  @override
  String get diagnosticsAllLoggers => 'כל המקורות';

  @override
  String get diagnosticsCopied => 'היומן הועתק';

  @override
  String get diagnosticsCopy => 'העתקת היומן המוצג';

  @override
  String get diagnosticsEmpty => 'אין עדיין רשומות ביומן';

  @override
  String get diagnosticsExport => 'ייצוא חבילת אבחון';

  @override
  String get diagnosticsExported => 'חבילת האבחון נשמרה';

  @override
  String get diagnosticsLevel => 'רמה';

  @override
  String get diagnosticsLogger => 'מקור';

  @override
  String get diagnosticsTitle => 'אבחון';

  @override
  String get download => 'הורדה';

  @override
  String get downloadCurrent => 'הגרסה הנוכחית, עם העריכות';

  @override
  String get downloadFailed => 'ההורדה נכשלה';

  @override
  String get downloadOriginal => 'המקור';

  @override
  String downloadSaved(String name) {
    return '$name נשמר';
  }

  @override
  String get downloadVersion => 'איזו גרסה?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'מוריד $countString פריטים',
      two: 'מוריד שני פריטים',
      one: 'מוריד פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'שיפור אוטומטי';

  @override
  String get editorCrop => 'חיתוך';

  @override
  String get editorCropOriginal => 'מקור';

  @override
  String get editorCropSquare => 'ריבוע';

  @override
  String get editorEdit => 'עריכה';

  @override
  String get editorFlip => 'היפוך';

  @override
  String get editorRotate => 'סיבוב';

  @override
  String get editorSaveCopy => 'שמירת עותק';

  @override
  String get editorSaveFailed => 'לא ניתן היה לשמור את העותק';

  @override
  String get editorSaveVersion => 'שמירה';

  @override
  String get editorSaved => 'נשמר כעותק';

  @override
  String get editorVersionFailed => 'לא ניתן היה לשמור את הגרסה';

  @override
  String get editorVersionSaved => 'נשמר כגרסה חדשה';

  @override
  String get editorVersionsUnsupported =>
      'שרת זה עדיין אינו יכול לשמור גרסאות של תמונות ערוכות';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString שינויים בוטלו: השרת דחה אותם.',
      two: 'שני שינויים בוטלו: השרת דחה אותם.',
      one: 'שינוי אחד בוטל: השרת דחה אותו.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'סגירה';

  @override
  String get editsRejectedForbidden => 'אפשר לצפות בפריטים אבל לא לשנות אותם.';

  @override
  String get editsRejectedInvalid => 'השרת לא הצליח לקבל את השינויים.';

  @override
  String get editsRejectedNotFound =>
      'הפריטים נמחקו או שהם כבר לא משותפים איתך.';

  @override
  String get errorNotFound => 'הדף הזה לא קיים';

  @override
  String get errorRetry => 'ניסיון חוזר';

  @override
  String get errorTitle => 'משהו השתבש';

  @override
  String faceNumber(int number) {
    return 'פנים $number';
  }

  @override
  String get facesAgree => 'אני מסכים';

  @override
  String get facesAura => 'תאר פנים באמצעות AuraFace (הורדה גדולה יותר)';

  @override
  String get facesNotNow => 'לא עכשיו';

  @override
  String get facesNoticeKeep =>
      'מה שנמצא נשאר עם התמונות שלך, במכשירים שלך ובשרת שלך. התיאורים אף פעם לא מוצגים או משותפים, והכול נמחק כשתפסיק או תמחק את התמונה.';

  @override
  String get facesNoticeOptional =>
      'זה אופציונלי. כל השאר ב-Photolib עובד בלי זה, ואפשר להפסיק בכל עת בהגדרות.';

  @override
  String get facesNoticeTitle => 'למצוא פנים בתמונות שלך?';

  @override
  String get facesNoticeWhat =>
      'Photolib מחפש פנים בתמונות ובסרטונים שלך ושומר לכל פנים את מיקומן ורשימת מספרים שמתארת אותן, כדי שאפשר יהיה למצוא שוב את אותו אדם. תיאור כזה עשוי להיחשב מידע ביומטרי.';

  @override
  String get facesNoticeWhere =>
      'זה קורה במכשיר הזה, ואם התחברת, גם בשרת שלך. אף פעם לא בשירות שאנחנו או מישהו אחר מפעילים.';

  @override
  String get facesServerFailed => 'לא ניתן היה ליידע את השרת שלך. נסה שוב.';

  @override
  String get facesServerOff => 'השרת שלך לא מוצא פנים עבורך';

  @override
  String get facesServerOn => 'השרת שלך מוצא פנים עבורך';

  @override
  String get facesServerUnavailable => 'השרת שלך לא מציע זיהוי פנים';

  @override
  String facesStatusDownloading(int percent) {
    return 'מוריד את מודלי הפנים: $percent%';
  }

  @override
  String get facesStatusMissing => 'השרת שלך לא התקין את מודלי הפנים';

  @override
  String get facesStatusNoDecoder =>
      'איתור הפנים אינו זמין: ספריית התמונות (libvips) לא נמצאה. התקינו מחדש את Photolib, או התקינו את libvips והפעילו אותה מחדש.';

  @override
  String get facesStatusRunning => 'מחפש פנים במכשיר הזה';

  @override
  String get facesStatusUnavailable => 'אי אפשר למצוא פנים במכשיר הזה';

  @override
  String get facesStatusWaiting => 'מודלי הפנים יורדים ב-Wi-Fi';

  @override
  String get facesSwitch => 'מצא פנים בתמונות שלי';

  @override
  String get facesSwitchOff => 'כבוי. שום דבר על פנים לא מחושב עד שתסכים.';

  @override
  String get facesSwitchOn => 'פועל. Photolib מוצא את הפנים בתמונות שלך.';

  @override
  String get facesTitle => 'פנים ואנשים';

  @override
  String get facesWithdraw => 'מחק והפסק';

  @override
  String get facesWithdrawBody =>
      'פעולה זו מוחקת כל פנים, תיאור ואדם ש-Photolib מצא עבורך, במכשיר הזה ובשרת שלך. התמונות שלך לא משתנות.';

  @override
  String get facesWithdrawTitle => 'להפסיק למצוא פנים?';

  @override
  String fileSize(double size, String unit) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    String _temp0 = intl.Intl.selectLogic(unit, {
      'kB': 'kB',
      'MB': 'MB',
      'GB': 'GB',
      'TB': 'TB',
      'other': 'B',
    });
    return '$sizeString $_temp0';
  }

  @override
  String filesFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'קבצים שלא שונו: $countString';
  }

  @override
  String get folderAllow => 'מתן גישה לתיקייה הזו';

  @override
  String get folderDelete => 'מחיקת תיקייה';

  @override
  String folderDeleteBody(String name) {
    return 'להעביר את התמונות והסרטונים שב-$name לאשפה?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString פריטים',
      two: 'שני פריטים',
      one: 'פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'תיקייה חדשה';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'לא זמינה, $countString פריטים',
      two: 'לא זמינה, שני פריטים',
      one: 'לא זמינה, פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'התיקייה הזו כבר בספרייה, או שהיא נמצאת בתוך תיקייה שבספרייה או מכילה תיקייה כזו';

  @override
  String get folderRemove => 'הסרת התיקייה';

  @override
  String folderRemoveBody(String folder) {
    return 'התמונות והסרטונים מהתיקייה $folder יוסרו מהספרייה. הקבצים יישארו בדיסק ללא שינוי.';
  }

  @override
  String get folderRemoveConfirm => 'הסרה';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'בסריקה, עד כה נמצאו $countString פריטים',
      two: 'בסריקה, עד כה נמצאו שני פריטים',
      one: 'בסריקה, עד כה נמצא פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'אפשר גישה';

  @override
  String get foldersHideExcluded => 'הסתרת תיקיות מוחרגות';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib כבר לא יכול לקרוא $countString תיקיות.',
      two: 'Photolib כבר לא יכול לקרוא שתי תיקיות.',
      one: 'Photolib כבר לא יכול לקרוא תיקייה אחת.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'הצגת תיקיות מוחרגות ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'הדפדפן הזה לא יכול לשמור תיקייה בתור הספרייה שלך. אפשר לפתוח את Photolib ב-Chrome או ב-Edge במחשב, או להשתמש באפליקציה למחשב.';

  @override
  String get galleryButtons => 'לחצנים';

  @override
  String galleryCameraNote(String camera) {
    return 'Your camera app ($camera) decides where its preview opens. Aperture, Open Camera and Fossify Camera open Photolib. The cameras of Pixel, Samsung, Xiaomi and Motorola open their own gallery.';
  }

  @override
  String get galleryChips => 'צ׳יפים';

  @override
  String get galleryEditNone => 'No app on this phone edits pictures.';

  @override
  String get galleryEditNotSaved => 'The edited picture could not be saved.';

  @override
  String get galleryEditWith => 'Edit with…';

  @override
  String get galleryEditorAsk => 'Ask every time';

  @override
  String get galleryEditorSetting => 'Editing app';

  @override
  String get galleryGrid => 'רשת';

  @override
  String get galleryMenus => 'תפריטים וגיליונות';

  @override
  String get galleryOnboardIntro =>
      'Every step is optional. Photolib never asks to run without battery limits, and never asks for access to all files.';

  @override
  String get galleryOnboardTitle => 'Make Photolib your gallery';

  @override
  String get galleryOpenWith => 'Open with…';

  @override
  String get galleryPickTitle => 'Choose photos';

  @override
  String get galleryShortcutAdd => 'Add to home screen';

  @override
  String get galleryShortcutFailed => 'Your launcher cannot add shortcuts.';

  @override
  String get galleryShowSheet => 'הצגת גיליון';

  @override
  String get galleryStepCamera => 'Camera';

  @override
  String get galleryStepDefault => 'Open photos with Photolib';

  @override
  String get galleryStepDefaultWhy =>
      'Without this, a photo you tap in another app opens in another gallery.';

  @override
  String get galleryStepDone => 'Done';

  @override
  String get galleryStepManage => 'Fewer confirmation dialogs';

  @override
  String get galleryStepManageWhy =>
      'Without this, Android asks you each time you trash or delete photos.';

  @override
  String get galleryStepMedia => 'Photos and videos';

  @override
  String get galleryStepMediaWhy =>
      'Without access to all your photos and videos, Photolib cannot show your library.';

  @override
  String get galleryStepNotifications => 'Notifications';

  @override
  String get galleryStepNotificationsWhy =>
      'Without them you will not see that a backup has stalled.';

  @override
  String get galleryStepOpen => 'Open settings';

  @override
  String get galleryTitle => 'רכיבים';

  @override
  String get galleryUninstallWarning =>
      'Your library on this phone is encrypted with a key that uninstalling Photolib deletes. Keep your recovery code safe before you uninstall, or what only this phone holds is lost.';

  @override
  String get galleryWallpaper => 'Set as wallpaper';

  @override
  String get galleryWallpaperBoth => 'Home and lock screens';

  @override
  String get galleryWallpaperDone => 'Wallpaper set';

  @override
  String get galleryWallpaperFailed => 'The wallpaper could not be set.';

  @override
  String get galleryWallpaperHome => 'Home screen';

  @override
  String get galleryWallpaperLock => 'Lock screen';

  @override
  String hiddenCollections(int count) {
    return 'מוסתרים ($count)';
  }

  @override
  String get indexingAllowMetered => 'הורדה בחבילת הגלישה';

  @override
  String get indexingAllowSaver => 'גם במצב חיסכון בסוללה';

  @override
  String get indexingBattery => 'סוללה נדרשת ללא מטען';

  @override
  String get indexingChargingOnly => 'רק בזמן טעינה';

  @override
  String indexingDownloading(int percent) {
    return 'מוריד את מודל החיפוש: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'לא ניתן היה לקרוא $count תמונות',
      two: 'לא ניתן היה לקרוא שתי תמונות',
      one: 'לא ניתן היה לקרוא תמונה אחת',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'המכשיר הזה מאנדקס רק את התמונות החדשות שלו';

  @override
  String get indexingMissing => 'השרת שלך לא התקין את מודל החיפוש';

  @override
  String get indexingModels => 'חיפוש במכשיר הזה';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'מוריד את מודל החיפוש ($megabytesString MB) מ-$host';
  }

  @override
  String get indexingNoDecoder =>
      'החיפוש וקריאת הטקסט אינם זמינים: ספריית התמונות (libvips) לא נמצאה. התקינו מחדש את Photolib, או התקינו את libvips והפעילו אותה מחדש.';

  @override
  String indexingPausedBattery(int percent) {
    return 'מושהה כל עוד הסוללה מתחת ל-$percent%';
  }

  @override
  String get indexingPausedCharger => 'מושהה עד שהמכשיר ייטען';

  @override
  String get indexingPausedHeat => 'מושהה כל עוד המכשיר חם';

  @override
  String get indexingPausedSaver => 'מושהה כל עוד חיסכון בסוללה מופעל';

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

    return 'תמונות באינדקס: $doneString מתוך $totalString';
  }

  @override
  String get indexingText => 'קריאת טקסט בתמונות';

  @override
  String indexingTextDownloading(int percent) {
    return 'מורידים את מודלי הטקסט: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'מוריד את מודלי הטקסט ($megabytesString MB) מ-$host; מוצא מילים בתמונות שלך';
  }

  @override
  String get indexingTextMissing => 'השרת שלך לא התקין את מודלי הטקסט';

  @override
  String get indexingTextPlatform =>
      'משתמש בזיהוי הטקסט של הטלפון שלך; אין מה להוריד. קורא תמונות חדשות';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'תמונות שהטקסט שלהן נקרא: $doneString מתוך $totalString';
  }

  @override
  String get indexingTextUnavailable => 'קריאת טקסט אינה זמינה כאן';

  @override
  String get indexingTextWaiting => 'מודלי הטקסט יורדים ב-Wi-Fi';

  @override
  String get indexingUnavailable => 'חיפוש במכשיר הזה אינו זמין כאן';

  @override
  String get indexingWaiting => 'מודל החיפוש יורד ב-Wi-Fi';

  @override
  String get infoAddName => 'הוספת שם';

  @override
  String get infoAddTag => 'הוספת תגית';

  @override
  String get infoAlbums => 'אלבומים';

  @override
  String get infoAllMetadata => 'הצגת כל המטא-נתונים';

  @override
  String get infoAuto => 'אוטומטי';

  @override
  String get infoBackedUp => 'מגובה';

  @override
  String get infoCamera => 'מצלמה';

  @override
  String get infoChangeAdjust => 'הצבעים כוונו';

  @override
  String get infoChangeCrop => 'נחתך';

  @override
  String get infoChangeFlip => 'התמונה שוקפה';

  @override
  String get infoChangeInpaint => 'אזור מולא';

  @override
  String get infoChangeLocal => 'אזור כוונן';

  @override
  String get infoChangeLut => 'הוחל סגנון צבע';

  @override
  String get infoChangeOther => 'נערך';

  @override
  String get infoChangeTurn => 'הוטה';

  @override
  String get infoCompare => 'השוואה למקור';

  @override
  String infoConfidence(String percent) {
    return 'ודאות: $percent';
  }

  @override
  String get infoCopyPath => 'העתקת הנתיב';

  @override
  String get infoCurrent => 'נוכחית';

  @override
  String get infoDescription => 'הוספת תיאור';

  @override
  String get infoEditDate => 'עריכת התאריך';

  @override
  String infoEditNumber(int number) {
    return 'עריכה $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'עותק ערוך של $name';
  }

  @override
  String get infoFaces => 'פנים';

  @override
  String get infoFile => 'קובץ';

  @override
  String get infoFromFileName => 'משם הקובץ';

  @override
  String get infoHistory => 'היסטוריית עריכה';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count פריטים',
      two: 'שני פריטים',
      one: 'פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'מיקום';

  @override
  String get infoMap => 'מפה של מקום הצילום';

  @override
  String get infoMapAgree =>
      'אריחי המפה מגיעים מהאינטרנט ומראים באיזה אזור אתם מסתכלים';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'תגית חדשה: $path';
  }

  @override
  String get infoNoAlbum => 'לא נמצא באף אלבום';

  @override
  String get infoOnDevice => 'במכשיר הזה';

  @override
  String get infoOriginal => 'מקור';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString פיקסלים';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'הסרה מ$album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'הסרת $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'הוסר מ$album';
  }

  @override
  String get infoRevert => 'שחזור';

  @override
  String get infoSaveCopy => 'שמירה כעותק';

  @override
  String get infoShared => 'משותף';

  @override
  String get infoShowFaces => 'הצגת פנים בתמונה';

  @override
  String get infoShowMap => 'הצגת המפה';

  @override
  String get infoTags => 'תגיות';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count גרסאות',
      two: 'שתי גרסאות',
      one: 'גרסה אחת',
    );
    return '$_temp0 · אחרונה $time';
  }

  @override
  String get infoWhy => 'למה התאריך הזה?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'נקרא מהקובץ, בתור $tag',
      'name': 'נקרא משם הקובץ',
      'folder': 'נקרא משם של תיקייה',
      'host': 'נמסר על ידי השירות שממנו הגיע הקובץ',
      'unknown': 'שום דבר בקובץ אינו מציין את תאריכו, ולכן משמש תאריך השינוי האחרון שלו',
      'other': 'הקובץ עדיין לא נקרא, ולכן משמש התאריך שהמכשיר מוסר',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'רשימה',
      'other': 'רשת',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'שם',
      'taken': 'תאריך צילום',
      'modified': 'תאריך שינוי',
      'size': 'גודל',
      'random': 'אקראי',
      'extension': 'סוג',
      'custom': 'סדר האלבום',
      'other': 'תאריך צילום',
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
  String get languageDevice => 'שפת המכשיר';

  @override
  String get languageName => 'עברית';

  @override
  String get libraryAddFolder => 'הוספת תיקייה';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'ללא גיבוי',
      'backed_up': 'מגובה',
      'cloud_only': 'בענן בלבד',
      'other': 'הכול',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'הכול מגובה',
      'backed_up': 'עדיין לא גובה דבר',
      'cloud_only': 'אין דבר שנמצא בשרת בלבד',
      'other': 'אין כאן דבר',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'תגי גיבוי';

  @override
  String get libraryEmpty => 'התמונות שלך יופיעו כאן';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'קיבוץ לפי שבוע',
      'month': 'קיבוץ לפי חודש',
      'other': 'קיבוץ לפי יום',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'הסתרה מחדש של פריטים מוסתרים ובארכיון';

  @override
  String get libraryNoKeyring =>
      'Photolib שומרת את המפתח לספרייה שלך במחזיק המפתחות של המערכת, שאינו פועל או נעול. יש להפעיל או לבטל את הנעילה של מחזיק מפתחות, כמו GNOME Keyring או KWallet, ולנסות שוב.';

  @override
  String get libraryRevealExcluded => 'הצגת התיקיות המוחרגות למשך 5 דקות';

  @override
  String get libraryShowVeiled => 'הצגת פריטים מוסתרים ובארכיון למשך 5 דקות';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'נוספו לאחרונה',
      'other': 'תאריך צילום',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'ל־Photolib לא הצליחה לפתוח את הספרייה השמורה במכשיר הזה';

  @override
  String get libraryViewOptions => 'אפשרויות תצוגה';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'מכין תמונות ממוזערות: $doneString מתוך $totalString';
  }

  @override
  String get libraryZoomIn => 'תמונות ממוזערות גדולות יותר';

  @override
  String get libraryZoomOut => 'תמונות ממוזערות קטנות יותר';

  @override
  String get mapAddTrack => 'הוספת מסלול GPX';

  @override
  String get mapArea => 'אזור המפה';

  @override
  String get mapAttribution => '© תורמי OpenStreetMap';

  @override
  String get mapClearLasso => 'ניקוי הבחירה';

  @override
  String get mapEmpty => 'עדיין אין תמונות עם מיקום';

  @override
  String get mapHeat => 'מפת חום';

  @override
  String get mapLasso => 'בחירה על ידי ציור סביב תמונות';

  @override
  String get mapLoading => 'מציב את התמונות על המפה';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'תמונות: $countString';
  }

  @override
  String get mapSearchHere => 'חיפוש באזור הזה';

  @override
  String get mapSplit => 'הצגת התמונות מתחת למפה';

  @override
  String get mapTilesAgree =>
      'רקע המפה מגיע משרת OpenStreetMap‏ (tile.openstreetmap.org), שרואה איזה אזור אתם מסתכלים בו';

  @override
  String get mapTilesShow => 'הצגת הרקע';

  @override
  String get mapTime => 'טווח זמן';

  @override
  String get mapTitle => 'מפה';

  @override
  String get mapTrackBad => 'בקובץ הזה אין מסלולי GPX';

  @override
  String get mapTrips => 'טיולים';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'מועדף',
      'hidden': 'מוסתר',
      'archived': 'בארכיון',
      'offline': 'נשמר במכשיר הזה',
      'offline': 'נשמר במכשיר הזה',
      'offline': 'נשמר במכשיר הזה',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'מתן גישה';

  @override
  String get mediaAccessNone =>
      'ל-Photolib נדרשת גישה לתמונות ולסרטונים שלך כדי להציג אותם.';

  @override
  String get mediaAccessPartial =>
      'ל-Photolib יש גישה רק לתמונות ולסרטונים שבחרת. כדי לשמש כגלריה, נדרשת גישה לכולם.';

  @override
  String get mediaAccessSelect => 'בחירת תמונות נוספות';

  @override
  String get nameLabel => 'שם';

  @override
  String get nextAddRoot =>
      'יש להוסיף את התיקייה ל-external_roots בהגדרות השרת ואז להפעיל את השרת מחדש.';

  @override
  String get nextAskAdmin => 'כדאי לפנות למנהל השרת.';

  @override
  String get nextAskOwner =>
      'כדאי לבקש מבעלי הספרייה לאפשר לך להוסיף אליה תמונות.';

  @override
  String get nextCheckConnection => 'כדאי לבדוק את החיבור כדי לראות למה.';

  @override
  String get nextCheckEntry => 'כדאי לבדוק את מה שהוזן ולנסות שוב.';

  @override
  String get nextConfirm => 'כדאי לבדוק כמה פריטים מושפעים ואז לאשר.';

  @override
  String get nextDeleteWebhook =>
      'כדאי למחוק Webhook שכבר לא בשימוש ולנסות שוב.';

  @override
  String get nextEditConfig =>
      'יש לשנות זאת בהגדרות השרת ואז להפעיל את השרת מחדש.';

  @override
  String get nextFreeSpace => 'כדאי לפנות מקום, או לבקש עוד מהמנהל.';

  @override
  String get nextNewLink => 'כדאי לבקש מהמנהל קישור חדש.';

  @override
  String get nextNewestToken => 'יש להעתיק את האחרון מהיומן של photolibd.';

  @override
  String get nextOtherAdmin => 'קודם יש להפוך חשבון אחר למנהל.';

  @override
  String get nextOtherFolder => 'כדאי לבחור תיקייה נפרדת.';

  @override
  String get nextRefresh => 'רענון ואז ניסיון חוזר.';

  @override
  String get nextReport =>
      'כדאי לנסות שוב. אם זה קורה שוב, אפשר להעתיק את הפרטים שלמטה בשביל המנהל.';

  @override
  String get nextSetUpPrivate =>
      'יש להשלים את הגדרת הספריות הפרטיות בהגדרות, ואז לנסות שוב.';

  @override
  String get nextSignIn => 'יש להתחבר שוב.';

  @override
  String get nextSignInAccount => 'כדאי להתחבר עם החשבון שלך ולנסות שוב.';

  @override
  String get nextSignInInstead => 'כדאי להתחבר במקום זאת.';

  @override
  String get nextTryAgain => 'כדאי לנסות שוב.';

  @override
  String get nextUpdateAndAgree => 'עדכן את האפליקציה ואז הסכם להודעה שוב.';

  @override
  String get nextUseAnother => 'כדאי לבחור אחר.';

  @override
  String get nextUseHttps =>
      'יש להשתמש בכתובת https:// של השרת, או להתחבר מהרשת של השרת עצמו.';

  @override
  String get nextWait => 'כדאי לחכות דקה ולנסות שוב.';

  @override
  String get offlineKeep => 'שמירה לא מקוונת';

  @override
  String offlineKeepHere(String size) {
    return 'שמירה במכשיר הזה ($size)';
  }

  @override
  String get offlineKeptHere => 'נשמר במכשיר הזה';

  @override
  String get offlineStopKeeping => 'הפסקת שמירה לא מקוונת';

  @override
  String get otherFiles => 'קבצים אחרים';

  @override
  String get passphraseCreate =>
      'במחשב הזה לא פועל מחזיק מפתחות (Secret Service) ששומר את המפתחות של Photolib. בחרו משפט סיסמה באורך 10 תווים לפחות כדי להגן עליהם: Photolib יבקש אותו בכל הפעלה.';

  @override
  String get passphraseLabel => 'משפט סיסמה';

  @override
  String get passphraseMismatch => 'משפטי הסיסמה לא תואמים.';

  @override
  String get passphraseRepeat => 'משפט הסיסמה שוב';

  @override
  String get passphraseTooShort => 'יש להשתמש ב-10 תווים לפחות.';

  @override
  String get passphraseUnlock =>
      'הזינו את משפט הסיסמה שמגן על המפתחות של Photolib במחשב הזה.';

  @override
  String get passphraseWrong => 'משפט סיסמה שגוי. נסו שוב.';

  @override
  String photoPosition(int index, int count) {
    return 'תמונה $index מתוך $count';
  }

  @override
  String get privacyCheckKit => 'בדיקת ערכת השחזור';

  @override
  String get privacyDrillDue =>
      'הגיע הזמן לתרגול שחזור: בדקו שערכת השחזור עדיין פותחת את הספריות הפרטיות שלך.';

  @override
  String get privacyHonest =>
      'ספריות פרטיות מוצפנות במכשירים שלך, ואף אחד אחר לא יכול לפתוח אותן: לא השרת, לא מנהל השרת ולא המפתחים של Photolib. אם תאבדו גם את הסיסמה וגם את ערכת השחזור, התמונות שלך יאבדו לתמיד, ואף אחד לא יוכל לשחזר אותן עבורך.';

  @override
  String get privacyKitBody =>
      'כתבו את 24 המילים האלה על נייר, לפי הסדר, ושמרו אותן במקום בטוח. הן פותחות את הספריות הפרטיות שלך אם תשכחו את הסיסמה, לכל מי שמחזיק בהן.';

  @override
  String get privacyKitDone => 'ערכת השחזור שלך עובדת.';

  @override
  String get privacyKitOther => 'זו לא ערכת השחזור הנוכחית שלך.';

  @override
  String get privacyKitTitle => 'ערכת השחזור שלך';

  @override
  String get privacyKitUnverified => 'ערכת השחזור עדיין לא אומתה';

  @override
  String privacyKitVerified(String date) {
    return 'ערכת השחזור אומתה ב-$date';
  }

  @override
  String get privacyKitWritten => 'כתבתי אותן';

  @override
  String get privacyNotReady =>
      'העלאות פרטיות נשארות כבויות עד שיהיו לך שתי דרכים לפתיחה ותאמתו את ערכת השחזור.';

  @override
  String get privacyPasswordHelp =>
      'הזינו את סיסמת החשבון: היא תהפוך לדרך אחת לפתוח את הספריות הפרטיות שלך.';

  @override
  String get privacyPhrase => 'צירוף השחזור';

  @override
  String get privacyPhraseHelp => '24 המילים של ערכת השחזור שלך';

  @override
  String get privacyPhraseInvalid => 'זה לא צירוף שחזור. בדקו כל מילה.';

  @override
  String get privacyReady => 'העלאות פרטיות מופעלות.';

  @override
  String get privacyRecoveryKit => 'ערכת שחזור';

  @override
  String get privacySetUp => 'הגדרה';

  @override
  String get privacyShowWords => 'הצגת המילים שוב';

  @override
  String get privacyTitle => 'ספריות פרטיות';

  @override
  String privacyUnknownWord(int number) {
    return 'מילה $number אינה מילה של ערכת שחזור.';
  }

  @override
  String get privacyVerify => 'אימות';

  @override
  String get privacyVerifyBody =>
      'הקלידו את המילים האלה מערכת השחזור כדי להראות ששמרתם אותה.';

  @override
  String get privacyWays => 'דרכים לפתיחה';

  @override
  String privacyWord(int number) {
    return 'מילה $number';
  }

  @override
  String get privacyWordsDiffer =>
      'המילים האלה לא תואמות את ערכת השחזור שלך. בדקו מה כתבתם.';

  @override
  String get privacyWrongPassword => 'זו לא הסיסמה של החשבון שלך.';

  @override
  String get problemAdminOnly => 'רק מנהל יכול לעשות את זה.';

  @override
  String get problemBusy => 'השרת עמוס או מופעל מחדש.';

  @override
  String get problemChanged => 'זה השתנה בינתיים.';

  @override
  String get problemConfirm =>
      'פעולה זו תסתיר או תמחק יותר פריטים ממה שהשרת עושה ללא אישור';

  @override
  String get problemContribute => 'אין לך הרשאה להוסיף תמונות לספרייה הזו.';

  @override
  String get problemCopy => 'העתקת הפרטים';

  @override
  String get problemDetails => 'פרטים';

  @override
  String get problemDiskLow => 'הדיסק של השרת כמעט מלא, ולכן ההעלאות מושהות.';

  @override
  String get problemEmailTaken => 'חשבון אחר משתמש באימייל הזה.';

  @override
  String get problemExists => 'זה כבר קיים.';

  @override
  String get problemFaceNotice =>
      'השרת שלך דורש גרסה חדשה יותר של הודעת הפנים ממה שהאפליקציה הזו מציגה.';

  @override
  String get problemGone => 'זה כבר לא נמצא בשרת.';

  @override
  String get problemHandleTaken => 'חשבון אחר משתמש בשם המשתמש הזה.';

  @override
  String get problemInterrupted => 'ההעלאה נקטעה.';

  @override
  String get problemInvalid => 'ערך לא חוקי';

  @override
  String get problemLastAdmin => 'השרת צריך לפחות מנהל אחד.';

  @override
  String get problemLinkInvalid => 'תוקף הקישור הזה פג או שכבר נעשה בו שימוש.';

  @override
  String get problemLoginFailed => 'האימייל, שם המשתמש או הסיסמה שגויים.';

  @override
  String get problemMaintenanceKey =>
      'אפשר להשהות גיבויים, בדיקות תקינות ומחיקות סופיות רק אחרי כניסה לחשבון, לא באמצעות מפתח API';

  @override
  String get problemNotAllowed => 'לחשבון שלך אין הרשאה לעשות את זה.';

  @override
  String get problemNotExternal =>
      'אפשר לסרוק רק ספריות מהתיקיות של השרת עצמו.';

  @override
  String get problemOidcClaim =>
      'ספק ההתחברות שלך לא ציין מי את/ה בצורה שהשרת הזה מקבל.';

  @override
  String get problemOidcDown => 'ספק ההתחברות שלך לא עונה לשרת.';

  @override
  String get problemOidcFailed => 'ספק ההתחברות שלך דחה את ההתחברות.';

  @override
  String get problemOidcNotAllowed => 'לחשבון שלך אסור להתחבר בדרך הזו.';

  @override
  String get problemOidcTaken => 'ההתחברות הזו כבר מקושרת לחשבון Photolib אחר.';

  @override
  String get problemOidcUnknown => 'השרת הזה כבר לא מציע את דרך ההתחברות הזו.';

  @override
  String get problemPasskeysOff =>
      'מפתחות גישה עובדים רק אחרי שלשרת יש כתובת ציבורית.';

  @override
  String get problemPinned =>
      'ההגדרה נקבעה בקובץ התצורה ואי אפשר לשנות אותה כאן.';

  @override
  String get problemPolicyOff => 'האפשרות הזו כבויה בשרת הזה.';

  @override
  String get problemQuota => 'נפח האחסון שלך בשרת מלא.';

  @override
  String get problemRestoreKey =>
      'אפשר לשחזר גיבוי רק אחרי כניסה לחשבון, לא באמצעות מפתח API.';

  @override
  String get problemRootDiffers =>
      'התיקייה הזו אינה מכילה את הקבצים של הספרייה הזו';

  @override
  String get problemRootNotAllowed =>
      'התיקייה הזו אינה נמצאת תחת external_roots שבהגדרות השרת';

  @override
  String get problemRootOverlaps =>
      'התיקייה הזו מכילה ספרייה אחרת או את הנתונים של השרת עצמו, או נמצאת בתוכם';

  @override
  String get problemScanning => 'הספרייה הזו כבר בסריקה';

  @override
  String get problemSecondFactor =>
      'החשבון הזה דורש גורם אימות נוסף, כמו קוד אימות או מפתח גישה, שגרסה זו של Photolib עדיין לא יכולה לספק.';

  @override
  String get problemSetupDone => 'לשרת הזה כבר יש מנהל.';

  @override
  String get problemSetupExpired => 'זה לקח יותר מדי זמן.';

  @override
  String get problemSetupToken => 'אסימון ההגדרה הזה שגוי.';

  @override
  String get problemSignedOut => 'התנתקת מהשרת.';

  @override
  String get problemStepUp => 'השינוי הזה דורש קודם סיסמה או קוד.';

  @override
  String get problemStorage => 'השרת לא מצליח להגיע לאחסון שלו.';

  @override
  String get problemTooMany => 'יותר מדי ניסיונות בזמן קצר.';

  @override
  String get problemUnexpected => 'משהו לא צפוי השתבש.';

  @override
  String get problemUnreachable => 'השרת לא עונה.';

  @override
  String get problemUploadDamaged => 'הקובץ השתנה או נפגם בדרך.';

  @override
  String get problemUploadExpired =>
      'ההעלאה הזו כבר לא נמצאת בשרת: העלאות שלא הסתיימו פגות אחרי יום.';

  @override
  String get problemWebhookLimit =>
      'לחשבון שלך כבר יש את המספר המרבי של Webhooks.';

  @override
  String get problemWebhooksOff => 'Webhooks כבויים בשרת הזה.';

  @override
  String get recoveryCode => 'קוד שחזור';

  @override
  String get recoveryCodeAbout =>
      'פותח את המאגר של Photolib במכשיר הזה אם מאגר המפתחות מאבד את המפתח שלו';

  @override
  String get recoveryCodeEnter => 'הזנת קוד שחזור';

  @override
  String get recoveryCreate => 'יצירת קוד שחזור';

  @override
  String get recoveryLater => 'אחר כך';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString שינויים קיימים רק במכשיר הזה. קוד שחזור יחזיר אותם אם מאגר המפתחות יאבד את המפתח של Photolib.',
      two: 'שני שינויים קיימים רק במכשיר הזה. קוד שחזור יחזיר אותם אם מאגר המפתחות יאבד את המפתח של Photolib.',
      one: 'שינוי אחד קיים רק במכשיר הזה. קוד שחזור יחזיר אותו אם מאגר המפתחות יאבד את המפתח של Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'כתבו את 24 המילים האלה ושמרו אותן במקום בטוח: הן פותחות את המאגר של Photolib במכשיר הזה בלי המפתח שלו ממאגר המפתחות. הן מחליפות כל קוד קודם.';

  @override
  String get recoveryUnlock => 'ביטול נעילה';

  @override
  String get recoveryWrong => 'זה לא קוד השחזור של המאגר הזה';

  @override
  String get renameFind => 'חיפוש';

  @override
  String get renamePattern => 'שם חדש';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'ארוך מדי: שם הוא לכל היותר 255 בתים',
      'invalid': 'שם קובץ לא חוקי',
      'duplicate': 'ניתן גם לקובץ אחר',
      'exists': 'לקובץ אחר בתיקייה הזו יש את השם הזה',
      'other': 'לא ניתן לשנות את השם',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'החלפה ב';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'קבצים ששמם שונה: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'הצגה ב-Finder',
      'windows': 'הצגה בסייר',
      'other': 'הצגה בתיקייה',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'מצלמה';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString פריטים',
      two: 'שני פריטים',
      one: 'פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'תאריכים';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'חיפוש בספרייה';

  @override
  String get searchFavourites => 'מועדפים';

  @override
  String get searchFolder => 'תיקייה';

  @override
  String get searchHint => 'שם קובץ או תיקייה';

  @override
  String get searchMotionPhotos => 'תמונות בתנועה';

  @override
  String get searchNothing => 'לא נמצאו התאמות';

  @override
  String get searchPanoramas => 'פנורמות';

  @override
  String get searchPhotos => 'תמונות';

  @override
  String get searchScreenshots => 'צילומי מסך';

  @override
  String get searchVideo => 'סרטון';

  @override
  String get searchVideos => 'סרטונים';

  @override
  String get securityAddPasskey => 'הוספת מפתח גישה';

  @override
  String get securityCode => 'קוד';

  @override
  String get securityCodesHelp =>
      'יש לשמור את הקודים האלה במקום בטוח. כל קוד עובד פעם אחת במקום גורם האימות השני, והם מוצגים רק עכשיו.';

  @override
  String securityCodesLeft(int count) {
    return 'לא בשימוש: $count';
  }

  @override
  String get securityNewCodes => 'קודים חדשים';

  @override
  String get securityPasskeyNotAdded => 'לא נוסף מפתח גישה.';

  @override
  String get securityRecoveryCodes => 'קודי שחזור';

  @override
  String get securityRemovePasskey => 'הסרת מפתח גישה';

  @override
  String get securitySetUp => 'הגדרה';

  @override
  String get securityStepUpBody =>
      'כדי לשנות את גורמי האימות השניים, יש להזין סיסמה, קוד מאפליקציית האימות או קוד שחזור.';

  @override
  String get securityStepUpTitle => 'אישור זהות';

  @override
  String get securityTitle => 'גורמי אימות שניים';

  @override
  String get securityTotp => 'אפליקציית אימות';

  @override
  String get securityTotpHelp =>
      'יש להוסיף את המפתח הזה לאפליקציית האימות ולהזין את הקוד שהיא מציגה.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'פעיל',
      'other': 'כבוי',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'כיבוי';

  @override
  String get securityWrongCode => 'הקוד שגוי.';

  @override
  String get securityWrongProof => 'הסיסמה או הקוד שגויים.';

  @override
  String get selectAll => 'בחירת הכול';

  @override
  String get selectionClear => 'ניקוי הבחירה';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'נבחרו $countString פריטים',
      two: 'נבחרו שני פריטים',
      one: 'נבחר פריט אחד',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'הצגת הפריטים שנבחרו';

  @override
  String get serverAccount => 'אימייל או שם משתמש';

  @override
  String get serverAdd => 'הוספת שרת';

  @override
  String get serverAddressInvalid => 'יש להזין כתובות כמו photos.example.org';

  @override
  String get serverAddresses => 'כתובות';

  @override
  String get serverAddressesHelp =>
      'אחת בכל שורה: השרת ברשת שלך, באינטרנט או דרך VPN. האפליקציה משתמשת בכתובת המהירה ביותר שעונה. או הדביקו את הקישור להגדרת סיסמה שקיבלתם.';

  @override
  String get serverCa => 'אישור של רשות אישורים פרטית (PEM)';

  @override
  String get serverCaChoose => 'בחירת קובץ אישור';

  @override
  String serverCertificateBody(String host) {
    return '$host מציג אישור שהמכשיר הזה לא סומך עליו. כדאי לסמוך עליו רק אם טביעת האצבע SHA-256 הזו שייכת לשרת שלך:';
  }

  @override
  String get serverCertificateTitle => 'לסמוך על האישור הזה?';

  @override
  String get serverConfirm => 'אישור';

  @override
  String get serverConnect => 'התחברות';

  @override
  String get serverCreateAdmin => 'יצירת מנהל מערכת';

  @override
  String get serverEnded => 'השרת סיים את ההפעלה הזו. יש להיכנס שוב.';

  @override
  String get serverHandleHelp =>
      'אותיות לטיניות קטנות, ספרות, נקודות, מקפים וקווים תחתונים; הוא אף פעם לא משתנה.';

  @override
  String get serverHeaders => 'כותרות מותאמות אישית';

  @override
  String get serverHeadersHelp =>
      'אחת בכל שורה, בתבנית Name: value; נשלחות דרך HTTPS בלבד';

  @override
  String get serverHeadersInvalid => 'יש לכתוב כל כותרת בתבנית Name: value';

  @override
  String get serverIdentity => 'אישור לקוח (PKCS#12)';

  @override
  String get serverIdentityChoose => 'בחירת אישור לקוח';

  @override
  String get serverIdentityInvalid =>
      'זה אינו אישור PKCS#12, או שהסיסמה שלו שגויה.';

  @override
  String get serverIdentityPassword => 'סיסמת אישור הלקוח';

  @override
  String get serverLoading => 'השרת השמור במכשיר הזה נקרא';

  @override
  String get serverNearby => 'שרתים ברשת הזו';

  @override
  String get serverNeedsHttps =>
      'השרת הזה צריך כתובת HTTPS: מחוץ לרשת המקומית שלך, Photolib לא מתחבר דרך HTTP רגיל.';

  @override
  String get serverNoSignIn =>
      'השרת הזה לא מציע דרך כניסה שגרסה זו של Photolib תומכת בה.';

  @override
  String get serverOffline => 'השרת לא עונה. החיבור לחשבון נשמר.';

  @override
  String get serverPasskeyFailed =>
      'לא נעשה שימוש במפתח גישה. נסו שוב או השתמשו בקוד.';

  @override
  String get serverPasskeyRequired =>
      'השרת הזה דורש מפתח גישה, ש-Photolib בגרסה הזו עדיין לא יכולה להשתמש בו.';

  @override
  String get serverPassword => 'סיסמה';

  @override
  String get serverPasswordAgain => 'הסיסמה שוב';

  @override
  String get serverPasswordSetupInvalid =>
      'אסימון הגדרת הסיסמה הזה שגוי, כבר נוצל או פג תוקפו. בקשו אסימון חדש.';

  @override
  String get serverPasswordSetupToken => 'אסימון הגדרת סיסמה';

  @override
  String get serverPasswordSetupTokenHelp =>
      'מהמנהל שלך, או מודפס על ידי photolibd admin password-setup בשרת.';

  @override
  String get serverPasswordsDiffer => 'הסיסמאות לא תואמות.';

  @override
  String get serverPrivateLibrariesBody =>
      'סיסמה חדשה לא פותחת אותן. פתחו אותן מחדש עם ערכת השחזור, מפתח גישה או מכשיר שעדיין מחובר.';

  @override
  String get serverPrivateLibrariesGo => 'הגדרת הסיסמה';

  @override
  String get serverPrivateLibrariesTitle => 'הספריות הפרטיות שלך נשארות נעולות';

  @override
  String get serverProxy => 'שרת proxy של HTTP, בתבנית host:port';

  @override
  String get serverProxyInvalid => 'יש להזין את ה-proxy בתבנית host:port';

  @override
  String get serverRecoveryCode => 'קוד שחזור';

  @override
  String get serverRemove => 'הסרת השרת הזה';

  @override
  String get serverRequired => 'שדה חובה';

  @override
  String get serverSecondFactor =>
      'גורם האימות השני של החשבון הזה הוא מפתח גישה, ש-Photolib בגרסה הזו עדיין לא יכולה להשתמש בו.';

  @override
  String get serverSecondFactorCode =>
      'החשבון הזה דורש גם קוד מאפליקציית האימות או קוד שחזור.';

  @override
  String get serverSecondFactorTitle => 'אימות זהות';

  @override
  String get serverSecondFactorWrong =>
      'זה לא עבד. אחרי חמישה ניסיונות, יש להתחבר מחדש.';

  @override
  String get serverSetPassword => 'הגדרת סיסמה';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'עבור $handle ב־$server';
  }

  @override
  String get serverSetPasswordOpen => 'הגדרת סיסמה';

  @override
  String get serverSetPasswordTitle => 'הגדירו את הסיסמה שלכם';

  @override
  String get serverSetUp => 'הגדרת שרת חדש';

  @override
  String get serverSetupLinkElsewhere =>
      'כדי להשתמש בקישור הזה, צאו קודם מהשרת הזה, או הסירו אותו אם הקישור מיועד לשרת אחר.';

  @override
  String get serverSetupTitle => 'הגדרת השרת';

  @override
  String get serverSetupToken => 'אסימון הגדרה';

  @override
  String get serverSetupTokenHelp =>
      'photolibd כותב אותו ביומן שלו כל עוד אין לשרת מנהל מערכת; כל הפעלה כותבת אסימון חדש.';

  @override
  String get serverSignIn => 'כניסה';

  @override
  String get serverSignOut => 'יציאה';

  @override
  String serverSignedInAs(String account) {
    return 'מחובר בתור $account';
  }

  @override
  String get serverSignedOut => 'מנותק';

  @override
  String get serverSwitch => 'החלפת חשבון';

  @override
  String get serverTotpCode => 'קוד מאפליקציית האימות';

  @override
  String get serverTrust => 'לסמוך';

  @override
  String get serverUnreadable => 'אי אפשר לקרוא את השרת השמור במכשיר הזה';

  @override
  String get serverUsePasskey => 'שימוש במפתח גישה';

  @override
  String get serverUseRecoveryCode => 'שימוש בקוד שחזור במקום זאת';

  @override
  String get settingsBackground => 'מאחורי תמונות שקופות';

  @override
  String get settingsDefaultTab => 'תיקיות ואלבומים נפתחים בכרטיסייה';

  @override
  String get settingsFolders => 'תיקיות';

  @override
  String get settingsIndexing => 'יצירת אינדקס במכשיר הזה';

  @override
  String get settingsLanguage => 'שפה';

  @override
  String get settingsLibrary => 'ספרייה';

  @override
  String get settingsServer => 'שרת';

  @override
  String get settingsStart => 'מסך פתיחה';

  @override
  String get settingsTheme => 'עיצוב';

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'הקשה על הקצה השמאלי או הימני למעבר לפריט הקודם או הבא',
      'oneFingerZoom': 'הקשה כפולה וגרירה לזום באצבע אחת',
      'swipes':
          'החלקה למעלה או למטה בצד שמאל של סרטון לבהירות, בצד ימין לעוצמת קול',
      'maxBrightness': 'בהירות מלאה בזמן צפייה',
      'autoRotate': 'סיבוב לפי הכיוון של כל תמונה או סרטון',
      'mixAudio': 'הפעלת סרטונים מעל שמע אחר במקום להשהות אותו',
      'autoplay': 'הפעלת סרטונים כשהם נפתחים',
      'loop': 'הפעלת סרטונים בלולאה',
      'autoNext': 'מעבר לפריט הבא כשסרטון מסתיים',
      'resume': 'המשך סרטונים מהמקום שבו נעצרו',
      'other': 'הפעלת תמונות מונפשות ברשת',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'לחצנים בסרגל המציג';

  @override
  String get settingsViewing => 'תצוגה';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString פריטים משותפים ממתינים עד ש-Photolib יורשה להוסיף אותם לספריית התמונות שלך. פריטים שלא נשמרו נמחקים אחרי 7 ימים.',
      two: 'שני פריטים משותפים ממתינים עד ש-Photolib יורשה להוסיף אותם לספריית התמונות שלך. פריטים שלא נשמרו נמחקים אחרי 7 ימים.',
      one: 'פריט משותף אחד ממתין עד ש-Photolib יורשה להוסיף אותו לספריית התמונות שלך. פריטים שלא נשמרו נמחקים אחרי 7 ימים.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge => 'גדול מדי לשיתוף בבת אחת: יש לבחור פחות פריטים';

  @override
  String shareTooMany(int count) {
    return 'יותר מדי לשיתוף בבת אחת: יש לבחור עד $count';
  }

  @override
  String get shortcutsTitle => 'מקשי קיצור';

  @override
  String get slideshow => 'מצגת';

  @override
  String get slideshowLoop => 'חזרה';

  @override
  String get slideshowOptions => 'אפשרויות מצגת';

  @override
  String get slideshowSeconds => 'שניות לכל פריט';

  @override
  String get slideshowShuffle => 'סדר אקראי';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'סדר יורד',
      'other': 'סדר עולה',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'המכשיר הזה';

  @override
  String sourceHide(String name) {
    return 'הסתרת $name';
  }

  @override
  String get sourceHideOthers => 'הסתרת כל השאר כאן';

  @override
  String get sourceLost => 'אין גישה';

  @override
  String get sourcePartly => 'מוצג חלקית';

  @override
  String sourceShow(String name) {
    return 'הצגת $name';
  }

  @override
  String get sourceShowEverything => 'הצגת כל מה שכאן';

  @override
  String get sourceShowOnly => 'הצגת זה בלבד';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'ציר זמן',
      'folders': 'תיקיות ואלבומים',
      'favourites': 'מועדפים',
      'other': 'ציר זמן',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'שמירת אדם לא מקוון';

  @override
  String get storageBudget => 'מגבלת אחסון';

  @override
  String get storageClear => 'הסרת עותקים לא מקוונים';

  @override
  String get storageClearAction => 'הסרה';

  @override
  String storageClearBody(String size) {
    return 'פעולה זו מסירה $size השמורים במכשיר הזה ומפסיקה לשמור אלבומים, חיפושים ותמונות לא מקוונים. הספרייה שלך בשרת לא תושפע.';
  }

  @override
  String get storageKeepLibrary => 'שמירת כל הספרייה';

  @override
  String get storageKeepOriginals => 'לשמור גם את המקוריים';

  @override
  String get storageNoPeople => 'עדיין אין אנשים עם שם.';

  @override
  String get storageNoPins =>
      'שום דבר לא מוצמד. הצמידו אלבום, חיפוש או תמונה כדי לשמור אותם לא מקוונים.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'אלבום',
      'search': 'חיפוש',
      'person': 'אדם',
      'library': 'כל הספרייה',
      'asset': 'תמונה',
      'other': 'מוצמד',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'לא נכנס במגבלה: נדרשים עוד $size';
  }

  @override
  String get storagePinNothing => 'אין מה להוריד: התמונות כבר במכשיר הזה';

  @override
  String get storagePinPaused => 'ממתין: ההגדרה הזו לא שומרת דבר לא מקוון';

  @override
  String get storagePinPlanning => 'בודק מה לשמור…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'מוריד: $haveString מתוך $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'זמין לא מקוון ($size)';
  }

  @override
  String get storagePinWaiting => 'יורד כשתהיו מחוברים';

  @override
  String get storagePins => 'שמור לא מקוון';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'קטלוג בלבד',
      'spaceSaver': 'חיסכון במקום',
      'travel': 'אלבומים נבחרים לא מקוונים',
      'everything': 'הכול',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'לא שומר דבר; תמונות נטענות מהשרת שלכם כשפותחים אותן.',
      'spaceSaver':
          'שומר תצוגות מקדימות של כל הספרייה, החדשות קודם, במסגרת המגבלה.',
      'travel': 'שומר רק את מה שמצמידים: אלבומים, חיפושים ותמונות.',
      'everything':
          'שומר את המקוריים של כל הספרייה, החדשים קודם, במסגרת המגבלה.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'מה המכשיר הזה שומר';

  @override
  String get storageSubtitle => 'עותקים לא מקוונים ומגבלת אחסון';

  @override
  String get storageTitle => 'אחסון';

  @override
  String storageUsed(String used, String budget) {
    return '$used מתוך $budget בשימוש';
  }

  @override
  String get storageWebNote =>
      'דפדפן שומר תצוגות מקדימות בלבד ומוחק אותן ביציאה מהחשבון.';

  @override
  String get storeNoKeyring =>
      'Photolib שומר את המפתח של המאגר המקומי שלו בצרור המפתחות של המערכת, שלא ענה. התקינו ובטלו את הנעילה של gnome-keyring, KWallet או KeePassXC עם Secret Service מופעל, ואז נסו שוב.';

  @override
  String get storeNoKeystore =>
      'Photolib לא הצליח לגשת למאגר המפתחות של המכשיר הזה, שבו שמור המפתח של המאגר המקומי שלו.';

  @override
  String get storeRebuilt =>
      'במאגר המפתחות של המכשיר הזה כבר לא היה המפתח של המאגר המקומי של Photolib, ולכן המאגר נבנה מחדש. ההגדרות שלו ומה שהיה קיים רק במכשיר הזה אבדו; הספריות מסתנכרנות שוב והתמונות הממוזערות יחזרו.';

  @override
  String get storeRecoveryNeeded =>
      'במאגר המפתחות של המכשיר הזה כבר אין את המפתח של המאגר המקומי של Photolib. הזינו את קוד השחזור, או אפסו את המאגר ואבדו את מה שקיים רק במכשיר הזה.';

  @override
  String get storeReset => 'איפוס המאגר';

  @override
  String get storeResetBody =>
      'מה שקיים רק במכשיר הזה יאבד; הספריות מסתנכרנות שוב והתמונות הממוזערות יחזרו.';

  @override
  String get storeUnavailable =>
      'האחסון במכשיר הזה אינו זמין: ההגדרות והאוספים אינם נשמרים';

  @override
  String get tabCollections => 'אוספים';

  @override
  String get tabLibrary => 'ספרייה';

  @override
  String get tabSearch => 'חיפוש';

  @override
  String get themeDark => 'כהה';

  @override
  String get themeLight => 'בהיר';

  @override
  String get themeSystem => 'לפי המערכת';

  @override
  String get timelineBenchmark => 'בדיקת ביצועים של ציר הזמן';

  @override
  String get timelineBenchmarkCopy => 'העתקת התוצאות';

  @override
  String get timelineCannotPlay => 'לא ניתן להפעיל בדפדפן הזה';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position מתוך $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position מתוך $count, ללא תצוגה מקדימה';
  }

  @override
  String get timelineExcluded => 'בתיקייה מוחרגת';

  @override
  String get timelineScrubber => 'גלילה לפי תאריך';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'תאריך לא ידוע';

  @override
  String timelineWeek(String date) {
    return 'השבוע של $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'הוספת $action לסרגל';
  }

  @override
  String toolbarDown(String action) {
    return 'העברת $action למטה';
  }

  @override
  String get toolbarInBar => 'בסרגל';

  @override
  String get toolbarInMenu => 'בתפריט ⋮';

  @override
  String toolbarRemove(String action) {
    return 'הסרת $action מהסרגל';
  }

  @override
  String get toolbarReset => 'איפוס לברירת המחדל';

  @override
  String toolbarUp(String action) {
    return 'העברת $action למעלה';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'העברה לכאן',
      'other': 'העתקה לכאן',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'כבר יש שם קובץ או תיקייה בשם הזה',
      'changed': 'העותק לא תאם את המקור והוסר',
      'cancelled': 'בוטל',
      'invalid': 'שם תיקייה לא חוקי',
      'other': 'נכשל',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'אחרונים';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'למחוק $countString פריטים לצמיתות? אי אפשר לבטל את הפעולה.',
      two: 'למחוק שני פריטים לצמיתות? אי אפשר לבטל את הפעולה.',
      one: 'למחוק פריט אחד לצמיתות? אי אפשר לבטל את הפעולה.',
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
      other: 'נשארו $daysString ימים',
      two: 'נשארו יומיים',
      one: 'נשאר יום אחד',
      zero: 'יימחק לצמיתות היום',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'האשפה ריקה';

  @override
  String get trashEmptyAll => 'ריקון האשפה';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString פריטים הועברו לאשפה',
      two: 'שני פריטים הועברו לאשפה',
      one: 'פריט אחד הועבר לאשפה',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib מוחק לצמיתות את מה שהוא שומר באשפה אחרי $days ימים; כל פריט מציג כמה זמן נשאר לו.';
  }

  @override
  String get trashTitle => 'אשפה';

  @override
  String get undo => 'ביטול פעולה';

  @override
  String get uploadAction => 'העלאת תמונות וסרטונים';

  @override
  String get uploadClear => 'ניקוי';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'הועלו $doneString מתוך $totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'נכשלו: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString פריטים הועברו לארכיון',
      two: 'שני פריטים הועברו לארכיון',
      one: 'פריט אחד הועבר לארכיון',
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
      other: '$countString פריטים הוסתרו',
      two: 'שני פריטים הוסתרו',
      one: 'פריט אחד הוסתר',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'שחור',
      'white': 'לבן',
      'other': 'לוח שחמט',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => 'לא ניתן להפעיל את הסרטון הזה במכשיר הזה';

  @override
  String get viewerCaptions => 'כתוביות';

  @override
  String get viewerCompass => 'נעילת מצפן';

  @override
  String get viewerCopy => 'העתקה';

  @override
  String get viewerCopyText => 'העתקת טקסט';

  @override
  String get viewerCustomize => 'התאמה אישית של סרגל הכלים…';

  @override
  String get viewerDial =>
      'כיוון. לחצו כדי לפנות קדימה. גררו כדי להסתכל מסביב, גללו או צבטו כדי לשנות זום, לחצו פעמיים כדי לאפס';

  @override
  String get viewerFilmstrip => 'רצועת תמונות';

  @override
  String get viewerFirst => 'ראשון';

  @override
  String get viewerFisheye => 'עין דג';

  @override
  String get viewerGyroscope => 'הזזת המכשיר כדי להסתכל מסביב';

  @override
  String get viewerHdr => 'הצגה ב-HDR';

  @override
  String get viewerInfo => 'מידע';

  @override
  String get viewerInfoLoading => 'המידע על הפריט הזה נטען';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString מתוך $countString';
  }

  @override
  String get viewerLast => 'אחרון';

  @override
  String get viewerLenses => 'בחירת עדשה';

  @override
  String get viewerMap => 'מפה';

  @override
  String get viewerMotion => 'הפעלת התנועה';

  @override
  String get viewerMotionDenied => 'הדפדפן הזה לא אפשר גישה לחיישני התנועה';

  @override
  String get viewerMotionMissing =>
      'אין במכשיר הזה ג\'ירוסקופ כדי להסתכל מסביב';

  @override
  String get viewerMute => 'השתקה';

  @override
  String get viewerNext => 'הבא';

  @override
  String get viewerNextFrame => 'הפריים הבא';

  @override
  String get viewerPause => 'השהיה';

  @override
  String get viewerPlanet => 'כוכב לכת קטן';

  @override
  String get viewerPlay => 'הפעלה';

  @override
  String get viewerPrevious => 'הקודם';

  @override
  String get viewerPreviousFrame => 'הפריים הקודם';

  @override
  String get viewerRotate => 'סיבוב';

  @override
  String get viewerSdr => 'הצגה ב-SDR';

  @override
  String get viewerSeek => 'מיקום';

  @override
  String get viewerSetAs => 'הגדרה בתור';

  @override
  String get viewerShare => 'שיתוף';

  @override
  String get viewerSpeed => 'מהירות הפעלה';

  @override
  String get viewerSphere =>
      'תצוגת 360°. גוררים כדי להסתכל מסביב, צובטים כדי לשנות זום';

  @override
  String get viewerText => 'הטקסט בתמונה זו';

  @override
  String get viewerTextCopied => 'הטקסט הועתק';

  @override
  String get viewerTextNone => 'לא נמצא טקסט בתמונה זו';

  @override
  String get viewerTextUnread => 'הטקסט בתמונה זו טרם נקרא';

  @override
  String get viewerUnmute => 'ביטול השתקה';

  @override
  String get viewerZoomIn => 'הגדלה';

  @override
  String get viewerZoomOut => 'הקטנה';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'כרטיס SD',
      'other': 'פנימי',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'הגדלה';

  @override
  String get zoomOut => 'הקטנה';
}
