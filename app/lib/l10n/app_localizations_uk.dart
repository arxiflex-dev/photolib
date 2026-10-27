// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get actionAddToAlbum => 'Додати до альбому';

  @override
  String get actionArchive => 'Архівувати';

  @override
  String get actionCopyTo => 'Копіювати до…';

  @override
  String get actionDeleteForever => 'Видалити назавжди';

  @override
  String get actionFavourite => 'Додати у вибране';

  @override
  String get actionHide => 'Приховати';

  @override
  String get actionMoveTo => 'Перемістити до…';

  @override
  String get actionRename => 'Перейменувати';

  @override
  String get actionRestore => 'Відновити';

  @override
  String get actionShare => 'Поділитися';

  @override
  String get actionTrash => 'Перемістити в кошик';

  @override
  String get actionUnarchive => 'Повернути з архіву';

  @override
  String get actionUndo => 'Скасувати';

  @override
  String get actionUnfavourite => 'Прибрати з вибраного';

  @override
  String get actionUnhide => 'Показати';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Активний',
      'disabled': 'Вимкнений',
      'invited': 'Запрошений',
      'deleted': 'Видалений',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Облікові записи';

  @override
  String get adminAddAccount => 'Додати обліковий запис';

  @override
  String get adminAddExternalLibrary => 'Додати зовнішню бібліотеку';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts спроби',
      many: '$attempts спроб',
      few: '$attempts спроби',
      one: '$attempts спроба',
      zero: 'ще не запускалося',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Журнал аудиту';

  @override
  String get adminBackUpNow => 'Створити копію зараз';

  @override
  String get adminBackupQueued =>
      'Резервну копію поставлено в чергу; за нею буде навчальне відновлення';

  @override
  String get adminBackups => 'Резервні копії бази даних';

  @override
  String get adminCancelJob => 'Скасувати завдання';

  @override
  String get adminCapabilities => 'Можливості';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Керовані бібліотеки',
      'uploads': 'Завантаження з пристроїв, вебу та CLI',
      'folder_browser': 'Перегляд папок',
      'device_folders': 'Папки пристрою в підключених застосунках',
      'sharing': 'Спільний доступ і публічні посилання',
      'edits': 'Редагування',
      'deletes': 'Видалення',
      'xmp_writes': 'Запис файлів XMP',
      'face_recognition': 'Розпізнавання облич',
      'ml_search': 'Розумний пошук',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'ОК',
      'warn': 'Попередження',
      'fail': 'Не пройдено',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Скопійовано';

  @override
  String get adminCopyBundle => 'Скопіювати діагностику для звіту про помилку';

  @override
  String get adminCopyLink => 'Копіювати посилання';

  @override
  String get adminDelete => 'Видалити';

  @override
  String get adminDeviceBackups => 'Резервні копії пристроїв';

  @override
  String get adminDevices => 'Ваші пристрої';

  @override
  String get adminDisable => 'Вимкнути';

  @override
  String adminDrillFailed(String detail) {
    return 'Останнє навчальне відновлення не вдалося: $detail';
  }

  @override
  String get adminEdit => 'Змінити';

  @override
  String get adminEmail => 'Електронна пошта';

  @override
  String get adminEnable => 'Увімкнути';

  @override
  String get adminErrorSignIn => 'Увійдіть як адміністратор';

  @override
  String get adminFacesDefault =>
      'Розпізнавання облич увімкнено за замовчуванням для нових облікових записів';

  @override
  String get adminFiles => 'Файли за типами';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Пошкоджено',
      'missing': 'Відсутній',
      'size': 'Неправильний розмір',
      'hash': 'Замінено',
      'orphan': 'Зайвий файл',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return 'Вільно: $size';
  }

  @override
  String get adminFreeDisk =>
      'Поріг вільного місця на диску для призупинення завантаження, у відсотках, від 0 до 50';

  @override
  String get adminFreeDiskGb =>
      'або нижче цього вільного місця в ГБ, якщо воно менше, від 0 до 100000';

  @override
  String get adminHandle => 'Ім’я користувача';

  @override
  String get adminIntegrity => 'Цілісність';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString елемента',
      many: '$countString елементів',
      few: '$countString елементи',
      one: '$countString елемент',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'У черзі',
      'running': 'Виконується',
      'done': 'Виконано',
      'dead': 'Помилка',
      'cancelled': 'Скасовано',
      'other': 'Усі',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Тип завдання, наприклад render';

  @override
  String get adminJobs => 'Завдання';

  @override
  String adminLastSeen(String time) {
    return 'Остання активність: $time';
  }

  @override
  String get adminLibraries => 'Бібліотеки';

  @override
  String get adminLibraryOwner => 'Власник';

  @override
  String get adminLibraryRoot => 'Папка на сервері, наприклад /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Доступна',
      'offline': 'Недоступна',
      'scanning': 'Сканування',
      'error': 'Помилка',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Журнал сервера';

  @override
  String get adminName => 'Ім’я';

  @override
  String get adminNothing => 'Тут поки нічого немає';

  @override
  String get adminOutOfRange => 'Поза допустимим діапазоном';

  @override
  String get adminOverview => 'Огляд';

  @override
  String get adminPair => 'Пов’язати пристрій';

  @override
  String get adminPairBody =>
      'Відскануйте цей код або надішліть посилання, а потім вставте його в Photolib на новому пристрої в розділі «Додати сервер»: воно передає всі адреси цього сервера та його сертифікат, щоб нікому не довелося їх вводити.';

  @override
  String get adminPasswordSetup => 'Посилання для встановлення пароля';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Надішліть це посилання $name будь-яким способом або дайте відсканувати код. Воно встановлює пароль один раз, до $date.';
  }

  @override
  String get adminPause => 'Призупинити тип завдань';

  @override
  String adminPauseMinutes(int max) {
    return 'Хвилини, від 1 до $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return 'Завдання типу $type призупинено до $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Залишилося скопіювати $countString елемента',
      many: 'Залишилося скопіювати $countString елементів',
      few: 'Залишилося скопіювати $countString елементи',
      one: 'Залишилося скопіювати $countString елемент',
      zero: 'Нічого копіювати',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Політики';

  @override
  String get adminPolicyReset => 'Використати значення рівня вище';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Увімкнено за замовчуванням',
      'server': 'Задано для сервера',
      'user': 'Задано для цього облікового запису',
      'library': 'Задано для цієї бібліотеки',
      'config': 'Задано в конфігурації',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Застосувати шаблон';

  @override
  String get adminPresetBody =>
      'Шаблон задає кожну можливість для сервера й скидає те, що задали облікові записи та бібліотеки. Усе можна змінити.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Перегляд архіву',
      'family_backup': 'Сімейне резервне копіювання',
      'personal': 'Особистий',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Зовнішні бібліотеки лише для читання — єдине джерело істини: без завантажень, керованих бібліотек, папок пристрою, редагування, видалення й запису XMP',
      'family_backup': 'Усе ввімкнено, крім запису XMP',
      'personal': 'Усе ввімкнено, крім спільного доступу та публічних посилань',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'QR-код посилання';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString завдання в черзі',
      many: '$countString завдань у черзі',
      few: '$countString завдання в черзі',
      one: '$countString завдання в черзі',
      zero: 'Немає чого обробляти',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'Квота сховища в ГБ; порожньо — без обмеження';

  @override
  String get adminRemote => 'Віддалений доступ';

  @override
  String get adminRemoteBody =>
      'Під’єднуйтеся до сервера звідусіль, не відкриваючи порт на роутері. Виберіть спосіб; кожен дає йому адресу HTTPS для застосунків. Потім перевірте її ззовні.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared сам під’єднується до Cloudflare, який віддає ваш домен через HTTPS. Безкоштовний тариф обмежує запит 100 МБ, а резервне копіювання до цього не доходить: воно надсилає по 8 МіБ.';

  @override
  String get adminRemoteNoAddress =>
      'Додайте в цей застосунок адресу сервера з https:// на початку, щоб перевірити її ззовні.';

  @override
  String get adminRemoteReachable => 'Доступний ззовні.';

  @override
  String get adminRemoteTailscale =>
      'Установіть Tailscale на комп’ютер сервера і на кожен пристрій, в одну tailnet або ваш Headscale, потім виконайте це на комп’ютері сервера і вкажіть у public_url адресу, яку він виведе.';

  @override
  String get adminRemoteTest => 'Перевірити ззовні';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host відкриє $url зі своїх серверів по всьому світу і так дізнається цю адресу. Продовжити?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Недоступний ззовні: перевірте вибраний спосіб і повторіть перевірку.';

  @override
  String get adminRemoteWireguard =>
      'Потрібен один відкритий порт UDP на боці сервера або на вузлі-посереднику. Це конфігурація для пристрою; ключі створіть командою wg genkey.';

  @override
  String get adminRepair =>
      'Відновіть його з резервної копії або з пристрою, де він ще є';

  @override
  String get adminRepairOrphan =>
      'Жодне фото на нього не посилається: перевірте його, потім видаліть або залиште';

  @override
  String get adminReprocess => 'Обробити повторно';

  @override
  String get adminReprocessFaces => 'Повторно виявити обличчя';

  @override
  String get adminReprocessFolder =>
      'Папка, наприклад 2024/05; порожньо — уся бібліотека';

  @override
  String get adminReprocessMetadata => 'Повторно прочитати метадані';

  @override
  String get adminReprocessRenditions =>
      'Заново створити мініатюри й попередні перегляди';

  @override
  String get adminRestore => 'Відновити';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Відновлення $name не вдалося: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Жодне навчальне відновлення ще не пройшло';

  @override
  String adminRestoreVerified(String when) {
    return 'Останнє перевірене відновлення: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd зупиниться і під час наступного запуску замінить усю базу даних копією $name. Зміни після цієї копії буде втрачено, а кожен пристрій синхронізується заново.';
  }

  @override
  String get adminRestoring => 'photolibd зупиняється, щоб відновити копію';

  @override
  String get adminResume => 'Відновити';

  @override
  String get adminRetry => 'Повторити';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Адміністратор',
      'user': 'Користувач',
      'viewer': 'Читач',
      'other': 'Невідомо',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Збережено';

  @override
  String get adminScan => 'Сканувати зараз';

  @override
  String get adminScrubDays =>
      'Днів, за які перевірка проходить кожен оригінал, від 1 до 3650';

  @override
  String get adminScrubNever => 'Триває перша повна перевірка';

  @override
  String adminScrubbed(String time) {
    return 'Остання повна перевірка $time';
  }

  @override
  String get adminSecondAdmin =>
      'Зробіть адміністратором другу людину, щоб хтось інший міг обслуговувати й відновлювати сервер, якщо ви не зможете.';

  @override
  String adminSilent(String time) {
    return 'Мовчить з $time';
  }

  @override
  String get adminSilentHours =>
      'Годин без звіту, після яких резервне копіювання пристрою вважається мовчазним, від 1 до 8760';

  @override
  String get adminStores => 'Сховище';

  @override
  String get adminThisDevice => 'Цей пристрій';

  @override
  String get adminTitle => 'Адміністрування сервера';

  @override
  String get adminTrashDays => 'Днів у кошику, від 1 до 3650';

  @override
  String get adminTwoFactor =>
      'Для всіх облікових записів обов’язкова двофакторна автентифікація';

  @override
  String get adminUsage => 'Використання за обліковими записами';

  @override
  String get albumCover => 'Зробити обкладинкою';

  @override
  String get albumEmpty => 'Цей альбом порожній';

  @override
  String get albumHideMemories => 'Сховати зі спогадів';

  @override
  String get albumHideTimeline => 'Сховати зі стрічки';

  @override
  String get albumNew => 'Новий альбом';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Будь-яка дата';

  @override
  String get backupCap => 'Найбільший елемент';

  @override
  String get backupCharging => 'Лише під час заряджання';

  @override
  String backupCompleted(String time) {
    return 'Останнє повне резервне копіювання: $time';
  }

  @override
  String backupContact(String time) {
    return 'Останній зв’язок із сервером: $time';
  }

  @override
  String get backupEnabled => 'Резервувати цей пристрій';

  @override
  String get backupFolderNo => 'Не цю';

  @override
  String get backupFolderYes => 'Резервувати';

  @override
  String backupHours(int count) {
    return '$count год';
  }

  @override
  String get backupMetered =>
      'У лімітних мережах, як-от мобільні дані чи точка доступу';

  @override
  String get backupNever => 'Повного резервного копіювання ще не було';

  @override
  String backupNewFolder(String name) {
    return 'Нова папка $name: резервувати?';
  }

  @override
  String get backupNoLimit => 'Без обмежень';

  @override
  String get backupNothing => 'Нічого не чекає';

  @override
  String get backupNow => 'Резервувати зараз';

  @override
  String backupOverdue(int hours, String items) {
    return 'Немає повного резервного копіювання $hours год. Чекають: $items';
  }

  @override
  String get backupOverdueTitle => 'Резервне копіювання не завершено';

  @override
  String backupPending(String items) {
    return 'Чекають: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Повтор: $time';
  }

  @override
  String get backupRoaming => 'Резервувати в роумінгу';

  @override
  String get backupSignIn => 'Увійдіть на сервер, щоб резервувати цей пристрій';

  @override
  String get backupSignedOut =>
      'Резервне копіювання зупинено: сервер завершив сеанс цього пристрою. Увійдіть знову в налаштуваннях.';

  @override
  String get backupSince => 'Знято з';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Резервне копіювання чекає, доки сервер стане доступним',
      'charging': 'Резервне копіювання чекає заряджання пристрою',
      'battery_low': 'Резервне копіювання чекає: батарея розряджена',
      'roaming': 'Резервне копіювання чекає, поки ви в роумінгу',
      'quota': 'Резервне копіювання зупинено: сховище на сервері заповнене',
      'second_factor': 'Резервне копіювання зупинено: сервер вимагає другий фактор для цього облікового запису',
      'other': 'Резервне копіювання зупинено: сервер відповів $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Резервне копіювання';

  @override
  String get backupWaiting => 'Не зарезервовано';

  @override
  String get backupWarnAfter => 'Попереджати, якщо не завершено за';

  @override
  String get backupWhat => 'Що резервувати';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'У папці, яку ви не вибрали',
      'folder_new': 'У новій папці: вирішіть, чи резервувати її',
      'type_excluded': 'Тип елементів, який ви не вибрали',
      'before_date': 'Знято до вибраної дати',
      'selected': 'Чекає своєї черги',
      'server_restored':
          'Сервер втратив його під час відновлення: надсилається знову',
      'working': 'Резервується',
      'waiting_for_icloud': 'Чекає завантаження з iCloud',
      'metered': 'Чекає безлімітної мережі',
      'metered_cap': 'Завеликий для лімітної мережі',
      'unreadable': 'Цей пристрій не може його прочитати',
      'changed': 'Змінився під час надсилання',
      'quota': 'Сховище на сервері заповнене',
      'other': 'Сервер відмовив: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Сервер більше не працює з цією версією Photolib.';

  @override
  String get checkAppTooOldNext => 'Оновіть Photolib.';

  @override
  String get checkChanged =>
      'Сертифікат сервера — не той, якому ви довірилися.';

  @override
  String get checkChangedNext =>
      'Якщо адміністратор його замінив, довіртеся новому. Якщо ні, вас можуть підслуховувати: не продовжуйте.';

  @override
  String get checkClock =>
      'Годинник цього пристрою і сервера розходяться більш ніж на п’ять хвилин.';

  @override
  String get checkClockNext =>
      'Увімкніть на пристрої автоматичне встановлення дати й часу.';

  @override
  String get checkDnsFailed => 'Ім’я сервера не веде до жодної адреси.';

  @override
  String get checkDnsFailedNext =>
      'Перевірте адресу або під’єднайтеся до мережі сервера.';

  @override
  String checkExpired(String date) {
    return 'Термін дії сертифіката сервера минув $date.';
  }

  @override
  String get checkFailed => 'Не пройдено';

  @override
  String get checkMetered => 'Ви в лімітній мережі, наприклад мобільній.';

  @override
  String get checkMeteredNext =>
      'Під’єднайтеся до Wi-Fi перед великим резервним копіюванням.';

  @override
  String get checkNotPhotolib =>
      'Відповідає не Photolib, а, наприклад, сторінка помилки проксі або сторінка входу у Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Увійдіть у Wi-Fi у браузері або попросіть адміністратора перевірити проксі.';

  @override
  String get checkOtherServer =>
      'За цією адресою відповідає інший сервер Photolib.';

  @override
  String get checkPassed => 'Пройдено';

  @override
  String get checkRefused => 'За цією адресою ніщо не відповідає.';

  @override
  String get checkRefusedNext =>
      'Переконайтеся, що сервер працює і ви в його мережі чи VPN.';

  @override
  String get checkRun => 'Перевірити з’єднання';

  @override
  String get checkRunning => 'Перевірка';

  @override
  String get checkSelfSigned =>
      'Сервер використовує власний сертифікат, якого цей пристрій ще не знає.';

  @override
  String get checkSkipped => 'Не перевірялося';

  @override
  String get checkStepAuth => 'Ваш вхід';

  @override
  String get checkStepClock => 'Годинник вашого пристрою';

  @override
  String get checkStepDns => 'Пошук адреси сервера';

  @override
  String get checkStepNetwork => 'Ваша мережа';

  @override
  String get checkStepServer => 'Photolib на сервері';

  @override
  String get checkStepTcp => 'Зв’язок із сервером';

  @override
  String get checkStepTls => 'Захищене з’єднання та сертифікат';

  @override
  String get checkStepUpload => 'Великі завантаження через проксі';

  @override
  String get checkTimedOut => 'Сервер надто довго не відповідає.';

  @override
  String get checkTimedOutNext => 'Перевірте з’єднання і спробуйте знову.';

  @override
  String get checkTitle => 'Перевірка з’єднання';

  @override
  String get checkTlsFailed => 'Не вдалося встановити захищене з’єднання.';

  @override
  String get checkTrustNext =>
      'Довіряйте йому, лише якщо його відбиток збігається з відбитком вашого сервера.';

  @override
  String get checkUntrusted =>
      'Сертифікат сервера видано центром, якому цей пристрій не довіряє.';

  @override
  String get checkUploadCap =>
      'Проксі на шляху відхиляє великі завантаження, тож резервне копіювання йде повільніше, малими частинами.';

  @override
  String get checkUploadCapNext =>
      'Попросіть адміністратора пропускати через проксі запити по 64 МБ.';

  @override
  String get collectionAlbums => 'Альбоми';

  @override
  String collectionHide(String name) {
    return 'Приховати «$name»';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Перемістити «$name» вниз';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Перемістити «$name» вгору';
  }

  @override
  String get collectionPeople => 'Люди';

  @override
  String collectionPin(String name) {
    return 'Закріпити «$name»';
  }

  @override
  String get collectionPlaces => 'Місця';

  @override
  String collectionShow(String name) {
    return 'Показати «$name»';
  }

  @override
  String get collectionTags => 'Теги';

  @override
  String collectionUnpin(String name) {
    return 'Відкріпити «$name»';
  }

  @override
  String get collectionsCustomise => 'Налаштувати';

  @override
  String get collectionsDone => 'Готово';

  @override
  String get commandPalette => 'Палітра команд';

  @override
  String get commandPaletteHint => 'Введіть команду';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString на цьому пристрої та в резервній копії',
      many: '$countString на цьому пристрої та в резервній копії',
      few: '$countString на цьому пристрої та в резервній копії',
      one: '$countString на цьому пристрої та в резервній копії',
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
      other: '$countString лише на цьому пристрої, без резервної копії',
      many: '$countString лише на цьому пристрої, без резервної копії',
      few: '$countString лише на цьому пристрої, без резервної копії',
      one: '$countString лише на цьому пристрої, без резервної копії',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Якщо ввімкнено Фото iCloud, видалене з цього пристрою зникне також з iCloud і з інших ваших пристроїв Apple.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString лише у вашій бібліотеці',
      many: '$countString лише у вашій бібліотеці',
      few: '$countString лише у вашій бібліотеці',
      one: '$countString лише у вашій бібліотеці',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Прибрати з цього пристрою';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString елемента із резервною копією; бібліотека їх збереже',
      many: '$countString елементів із резервною копією; бібліотека їх збереже',
      few: '$countString елементи із резервною копією; бібліотека їх збереже',
      one: '$countString елемент із резервною копією; бібліотека його збереже',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Копії на цьому пристрої потраплять до його кошика: місце звільниться, коли його буде очищено.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Видалити $countString елемента?',
      many: 'Видалити $countString елементів?',
      few: 'Видалити $countString елементи?',
      one: 'Видалити $countString елемент?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'З цього пристрою та з вашої бібліотеки',
      'device': 'Лише з цього пристрою',
      'other': 'З вашої бібліотеки',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Немає на пристрої';

  @override
  String get deviceFolderCard => 'SD-карта';

  @override
  String get deviceFolderExclude => 'Виключити';

  @override
  String get deviceFolderExcludeThis => 'Виключити цю папку';

  @override
  String get deviceFolderExcludedNotice =>
      'Папку цього елемента виключено з бібліотеки';

  @override
  String get deviceFolderForget => 'Прибрати зі списку';

  @override
  String get deviceFolderInternal => 'Внутрішня пам\'ять';

  @override
  String get deviceFolderKeep => 'Залишити';

  @override
  String deviceFolderNew(String name, String items) {
    return 'Нова папка: $name, $items';
  }

  @override
  String get deviceFolders => 'Папки пристрою';

  @override
  String get deviceFoldersAll => 'Показувати всі папки, крім виключених';

  @override
  String get deviceFoldersChosen => 'Показувати лише вибрані папки';

  @override
  String get deviceFoldersExcludedNow => 'Виключено з бібліотеки';

  @override
  String get deviceFoldersSearch => 'Пошук папок';

  @override
  String get diagnosticsAdvanced => 'Показувати діагностику';

  @override
  String get diagnosticsAllLoggers => 'Усі джерела';

  @override
  String get diagnosticsCopied => 'Журнал скопійовано';

  @override
  String get diagnosticsCopy => 'Копіювати показаний журнал';

  @override
  String get diagnosticsEmpty => 'У журналі поки немає записів';

  @override
  String get diagnosticsExport => 'Експортувати пакет діагностики';

  @override
  String get diagnosticsExported => 'Пакет діагностики збережено';

  @override
  String get diagnosticsLevel => 'Рівень';

  @override
  String get diagnosticsLogger => 'Джерело';

  @override
  String get diagnosticsTitle => 'Діагностика';

  @override
  String get download => 'Завантажити';

  @override
  String get downloadCurrent => 'Поточна версія з правками';

  @override
  String get downloadFailed => 'Не вдалося завантажити';

  @override
  String get downloadOriginal => 'Оригінал';

  @override
  String downloadSaved(String name) {
    return 'Збережено: $name';
  }

  @override
  String get downloadVersion => 'Яку версію?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завантажуються $countString елемента',
      many: 'Завантажуються $countString елементів',
      few: 'Завантажуються $countString елементи',
      one: 'Завантажується $countString елемент',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Автопокращення';

  @override
  String get editorCrop => 'Обрізати';

  @override
  String get editorCropOriginal => 'Оригінал';

  @override
  String get editorCropSquare => 'Квадрат';

  @override
  String get editorEdit => 'Редагувати';

  @override
  String get editorFlip => 'Віддзеркалити';

  @override
  String get editorRotate => 'Повернути';

  @override
  String get editorSaveCopy => 'Зберегти копію';

  @override
  String get editorSaveFailed => 'Не вдалося зберегти копію';

  @override
  String get editorSaveVersion => 'Зберегти';

  @override
  String get editorSaved => 'Збережено як копію';

  @override
  String get editorVersionFailed => 'Не вдалося зберегти версію';

  @override
  String get editorVersionSaved => 'Збережено як нову версію';

  @override
  String get editorVersionsUnsupported =>
      'Цей сервер поки не вміє зберігати версії відредагованих фото';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скасовано $countString зміни: сервер їх відхилив.',
      many: 'Скасовано $countString змін: сервер їх відхилив.',
      few: 'Скасовано $countString зміни: сервер їх відхилив.',
      one: 'Скасовано $countString зміну: сервер її відхилив.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Закрити';

  @override
  String get editsRejectedForbidden =>
      'Ви можете переглядати ці об\'єкти, але не змінювати їх.';

  @override
  String get editsRejectedInvalid => 'Сервер не зміг прийняти зміни.';

  @override
  String get editsRejectedNotFound =>
      'Об\'єкти видалено або вони більше не доступні вам.';

  @override
  String get errorNotFound => 'Такої сторінки не існує';

  @override
  String get errorRetry => 'Спробувати ще раз';

  @override
  String get errorTitle => 'Щось пішло не так';

  @override
  String faceNumber(int number) {
    return 'Обличчя $number';
  }

  @override
  String get facesAgree => 'Погоджуюсь';

  @override
  String get facesAura =>
      'Описувати обличчя за допомогою AuraFace (більше завантаження)';

  @override
  String get facesNotNow => 'Не зараз';

  @override
  String get facesNoticeKeep =>
      'Знайдене залишається разом із вашими фото, на ваших пристроях і вашому сервері. Описи ніколи не показуються й не передаються, а все видаляється, коли ви вимикаєте функцію або видаляєте фото.';

  @override
  String get facesNoticeOptional =>
      'Це необов’язково. Усе інше в Photolib працює без цього, а вимкнути функцію можна будь-коли в налаштуваннях.';

  @override
  String get facesNoticeTitle => 'Знаходити обличчя на ваших фото?';

  @override
  String get facesNoticeWhat =>
      'Photolib шукає обличчя на ваших фото й відео та зберігає для кожного, де воно розташоване, і набір чисел, що його описує, щоб знову знаходити ту саму людину. Такий опис може вважатися біометричними даними.';

  @override
  String get facesNoticeWhere =>
      'Це відбувається на цьому пристрої та, якщо ви ввійшли в обліковий запис, на вашому власному сервері. Ніколи в сервісі, яким керуємо ми чи хтось інший.';

  @override
  String get facesServerFailed =>
      'Не вдалося повідомити ваш сервер. Спробуйте ще раз.';

  @override
  String get facesServerOff => 'Ваш сервер не знаходить облич для вас';

  @override
  String get facesServerOn => 'Ваш сервер знаходить обличчя для вас';

  @override
  String get facesServerUnavailable =>
      'Ваш сервер не пропонує розпізнавання облич';

  @override
  String facesStatusDownloading(int percent) {
    return 'Завантаження моделей облич: $percent %';
  }

  @override
  String get facesStatusMissing =>
      'На вашому сервері не встановлено моделей облич';

  @override
  String get facesStatusNoDecoder =>
      'Пошук облич недоступний: не знайдено бібліотеку зображень (libvips). Перевстановіть Photolib або встановіть libvips і перезапустіть застосунок.';

  @override
  String get facesStatusRunning => 'Пошук облич на цьому пристрої';

  @override
  String get facesStatusUnavailable =>
      'На цьому пристрої не можна знаходити обличчя';

  @override
  String get facesStatusWaiting => 'Моделі облич завантажаться через Wi-Fi';

  @override
  String get facesSwitch => 'Знаходити обличчя на моїх фото';

  @override
  String get facesSwitchOff =>
      'Вимкнено. Нічого про обличчя не обчислюється, доки ви не погодитеся.';

  @override
  String get facesSwitchOn =>
      'Увімкнено. Photolib знаходить обличчя на ваших фото.';

  @override
  String get facesTitle => 'Обличчя та люди';

  @override
  String get facesWithdraw => 'Видалити й припинити';

  @override
  String get facesWithdrawBody =>
      'Буде видалено всі обличчя, описи та людей, яких Photolib знайшов для вас, на цьому пристрої та на вашому сервері. Ваші фото не зміняться.';

  @override
  String get facesWithdrawTitle => 'Припинити знаходити обличчя?';

  @override
  String fileSize(double size, String unit) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    String _temp0 = intl.Intl.selectLogic(unit, {
      'kB': 'кБ',
      'MB': 'МБ',
      'GB': 'ГБ',
      'TB': 'ТБ',
      'other': 'Б',
    });
    return '$sizeString $_temp0';
  }

  @override
  String filesFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Файлів не змінено: $countString';
  }

  @override
  String get folderAllow => 'Дозволити доступ до цієї папки';

  @override
  String get folderDelete => 'Видалити папку';

  @override
  String folderDeleteBody(String name) {
    return 'Перемістити фото й відео з папки $name у кошик?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString елемента',
      many: '$countString елементів',
      few: '$countString елементи',
      one: '$countString елемент',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Нова папка';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недоступна, $countString елемента',
      many: 'Недоступна, $countString елементів',
      few: 'Недоступна, $countString елементи',
      one: 'Недоступна, $countString елемент',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Ця папка вже є в бібліотеці, вкладена в одну з її папок або містить таку папку';

  @override
  String get folderRemove => 'Прибрати папку';

  @override
  String folderRemoveBody(String folder) {
    return 'Фото й відео з папки $folder буде прибрано з бібліотеки. Самі файли залишаться на диску без змін.';
  }

  @override
  String get folderRemoveConfirm => 'Прибрати';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сканування, поки що знайдено $countString елемента',
      many: 'Сканування, поки що знайдено $countString елементів',
      few: 'Сканування, поки що знайдено $countString елементи',
      one: 'Сканування, поки що знайдено $countString елемент',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Дозволити доступ';

  @override
  String get foldersHideExcluded => 'Сховати виключені папки';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib більше не може прочитати $countString теки.',
      many: 'Photolib більше не може прочитати $countString тек.',
      few: 'Photolib більше не може прочитати $countString теки.',
      one: 'Photolib більше не може прочитати $countString теку.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Показати виключені папки ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Цей браузер не може використовувати папку як вашу бібліотеку. Відкрийте Photolib у Chrome або Edge на комп’ютері чи скористайтеся застосунком для комп’ютера.';

  @override
  String get galleryButtons => 'Кнопки';

  @override
  String galleryCameraNote(String camera) {
    return 'Your camera app ($camera) decides where its preview opens. Aperture, Open Camera and Fossify Camera open Photolib. The cameras of Pixel, Samsung, Xiaomi and Motorola open their own gallery.';
  }

  @override
  String get galleryChips => 'Чипи';

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
  String get galleryGrid => 'Сітка';

  @override
  String get galleryMenus => 'Меню й панелі';

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
  String get galleryShowSheet => 'Показати панель';

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
  String get galleryTitle => 'Компоненти';

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
    return 'Приховані ($count)';
  }

  @override
  String get indexingAllowMetered => 'Завантажувати через мобільну мережу';

  @override
  String get indexingAllowSaver => 'Також у режимі енергозбереження';

  @override
  String get indexingBattery => 'Заряд, потрібний без зарядного пристрою';

  @override
  String get indexingChargingOnly => 'Лише під час заряджання';

  @override
  String indexingDownloading(int percent) {
    return 'Завантаження моделі пошуку: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не вдалося прочитати $count фото',
      many: 'Не вдалося прочитати $count фото',
      few: 'Не вдалося прочитати $count фото',
      one: 'Не вдалося прочитати $count фото',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Цей пристрій індексує лише нові фото';

  @override
  String get indexingMissing => 'Ваш сервер не встановив модель пошуку';

  @override
  String get indexingModels => 'Пошук на цьому пристрої';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Завантажує модель пошуку ($megabytesString МБ) з $host';
  }

  @override
  String get indexingNoDecoder =>
      'Пошук і розпізнавання тексту недоступні: не знайдено бібліотеку зображень (libvips). Перевстановіть Photolib або встановіть libvips і перезапустіть застосунок.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Пауза, поки заряд батареї нижче $percent%';
  }

  @override
  String get indexingPausedCharger => 'Пауза до початку заряджання';

  @override
  String get indexingPausedHeat => 'Пауза, поки пристрій гарячий';

  @override
  String get indexingPausedSaver => 'Пауза, поки ввімкнено економію заряду';

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

    return 'Проіндексовано фото: $doneString з $totalString';
  }

  @override
  String get indexingText => 'Розпізнавати текст на фото';

  @override
  String indexingTextDownloading(int percent) {
    return 'Завантаження моделей тексту: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Завантажує моделі тексту ($megabytesString МБ) з $host; знаходить слова на ваших фото';
  }

  @override
  String get indexingTextMissing =>
      'На вашому сервері не встановлено моделей тексту';

  @override
  String get indexingTextPlatform =>
      'Використовує розпізнавання тексту самого телефона; нічого завантажувати не потрібно. Читає нові фото';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Фото з розпізнаним текстом: $doneString з $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Розпізнавання тексту тут недоступне';

  @override
  String get indexingTextWaiting => 'Моделі тексту завантажуються через Wi-Fi';

  @override
  String get indexingUnavailable => 'Пошук на цьому пристрої тут недоступний';

  @override
  String get indexingWaiting => 'Модель пошуку завантажиться через Wi-Fi';

  @override
  String get infoAddName => 'Додати ім’я';

  @override
  String get infoAddTag => 'Додати тег';

  @override
  String get infoAlbums => 'Альбоми';

  @override
  String get infoAllMetadata => 'Усі метадані';

  @override
  String get infoAuto => 'Авто';

  @override
  String get infoBackedUp => 'Резервну копію створено';

  @override
  String get infoCamera => 'Камера';

  @override
  String get infoChangeAdjust => 'Кольори скориговано';

  @override
  String get infoChangeCrop => 'Обрізано';

  @override
  String get infoChangeFlip => 'Віддзеркалено';

  @override
  String get infoChangeInpaint => 'Область заповнено';

  @override
  String get infoChangeLocal => 'Область скориговано';

  @override
  String get infoChangeLut => 'Застосовано колірний стиль';

  @override
  String get infoChangeOther => 'Відредаговано';

  @override
  String get infoChangeTurn => 'Повернуто';

  @override
  String get infoCompare => 'Порівняти з оригіналом';

  @override
  String infoConfidence(String percent) {
    return 'Достовірність: $percent';
  }

  @override
  String get infoCopyPath => 'Копіювати шлях';

  @override
  String get infoCurrent => 'Поточна';

  @override
  String get infoDescription => 'Додати опис';

  @override
  String get infoEditDate => 'Змінити дату';

  @override
  String infoEditNumber(int number) {
    return 'Редагування $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Змінена копія $name';
  }

  @override
  String get infoFaces => 'Обличчя';

  @override
  String get infoFile => 'Файл';

  @override
  String get infoFromFileName => 'з назви файлу';

  @override
  String get infoHistory => 'Історія змін';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count елемента',
      many: '$count елементів',
      few: '$count елементи',
      one: '$count елемент',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Місце';

  @override
  String get infoMap => 'Мапа місця зйомки';

  @override
  String get infoMapAgree =>
      'Фрагменти мапи завантажуються з інтернету й показують, яку місцевість ви переглядаєте';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels Мп';
  }

  @override
  String infoNewTag(String path) {
    return 'Новий тег: $path';
  }

  @override
  String get infoNoAlbum => 'Не в альбомах';

  @override
  String get infoOnDevice => 'На цьому пристрої';

  @override
  String get infoOriginal => 'Оригінал';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString пікс.';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Прибрати з «$album»';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Прибрати «$tag»';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Прибрано з «$album»';
  }

  @override
  String get infoRevert => 'Повернути';

  @override
  String get infoSaveCopy => 'Зберегти як копію';

  @override
  String get infoShared => 'спільний';

  @override
  String get infoShowFaces => 'Показати обличчя на фото';

  @override
  String get infoShowMap => 'Показати мапу';

  @override
  String get infoTags => 'Теги';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count версії',
      many: '$count версій',
      few: '$count версії',
      one: '$count версія',
    );
    return '$_temp0 · остання $time';
  }

  @override
  String get infoWhy => 'Чому ця дата?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Прочитано з файлу, з поля $tag',
      'name': 'Прочитано з назви файлу',
      'folder': 'Прочитано з назви папки',
      'host': 'Вказано сервісом, з якого надійшов файл',
      'unknown': 'У файлі немає нічого, що вказувало б дату, тому використано дату його останньої зміни',
      'other': 'Файл ще не прочитано, тому використано дату, яку повідомляє пристрій',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Список',
      'other': 'Сітка',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Ім\'я',
      'taken': 'Дата зйомки',
      'modified': 'Дата зміни',
      'size': 'Розмір',
      'random': 'Випадково',
      'extension': 'Тип',
      'custom': 'Порядок альбому',
      'other': 'Дата зйомки',
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
  String get languageDevice => 'Мова пристрою';

  @override
  String get languageName => 'Українська';

  @override
  String get libraryAddFolder => 'Додати папку';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Немає резервної копії',
      'backed_up': 'Є резервна копія',
      'cloud_only': 'Лише в хмарі',
      'other': 'Усі',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Резервні копії є для всього',
      'backed_up': 'Резервних копій ще немає',
      'cloud_only': 'Немає нічого лише на сервері',
      'other': 'Тут нічого немає',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Значки резервного копіювання';

  @override
  String get libraryEmpty => 'Тут з’являться ваші фото';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Групувати за тижнями',
      'month': 'Групувати за місяцями',
      'other': 'Групувати за днями',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Знову приховати приховані й архівні елементи';

  @override
  String get libraryNoKeyring =>
      'Photolib зберігає ключ до вашої бібліотеки в системній в’язці ключів, яка не запущена або заблокована. Запустіть або розблокуйте в’язку ключів, наприклад GNOME Keyring або KWallet, і спробуйте ще раз.';

  @override
  String get libraryRevealExcluded => 'Показати виключені папки на 5 хвилин';

  @override
  String get libraryShowVeiled =>
      'Показати приховані й архівні елементи на 5 хвилин';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Нещодавно додані',
      'other': 'Дата зйомки',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib не вдалося відкрити бібліотеку, що зберігається на цьому пристрої';

  @override
  String get libraryViewOptions => 'Параметри перегляду';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Підготовка мініатюр: $doneString з $totalString';
  }

  @override
  String get libraryZoomIn => 'Збільшити мініатюри';

  @override
  String get libraryZoomOut => 'Зменшити мініатюри';

  @override
  String get mapAddTrack => 'Додати трек GPX';

  @override
  String get mapArea => 'Область карти';

  @override
  String get mapAttribution => '© учасники OpenStreetMap';

  @override
  String get mapClearLasso => 'Зняти виділення';

  @override
  String get mapEmpty => 'Ще немає фото з місцем зйомки';

  @override
  String get mapHeat => 'Теплова карта';

  @override
  String get mapLasso => 'Виділити, обвівши фотографії';

  @override
  String get mapLoading => 'Фотографії розміщуються на карті';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Фото: $countString';
  }

  @override
  String get mapSearchHere => 'Шукати в цій області';

  @override
  String get mapSplit => 'Показати фото під картою';

  @override
  String get mapTilesAgree =>
      'Тло карти завантажується із сервера OpenStreetMap (tile.openstreetmap.org), який бачить, яку область ви дивитеся';

  @override
  String get mapTilesShow => 'Показати тло';

  @override
  String get mapTime => 'Період';

  @override
  String get mapTitle => 'Карта';

  @override
  String get mapTrackBad => 'У цьому файлі немає треків GPX';

  @override
  String get mapTrips => 'Поїздки';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Вибране',
      'hidden': 'Приховано',
      'archived': 'В архіві',
      'offline': 'Зберігається на цьому пристрої',
      'offline': 'Зберігається на цьому пристрої',
      'offline': 'Зберігається на цьому пристрої',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Дозволити доступ';

  @override
  String get mediaAccessNone =>
      'Застосунку Photolib потрібен доступ до ваших фото й відео, щоб їх показувати.';

  @override
  String get mediaAccessPartial =>
      'Застосунок Photolib бачить лише вибрані вами фото й відео. Галереї потрібен доступ до всіх.';

  @override
  String get mediaAccessSelect => 'Вибрати ще фото';

  @override
  String get nameLabel => 'Назва';

  @override
  String get nextAddRoot =>
      'Додайте теку до external_roots у конфігурації сервера і перезапустіть сервер.';

  @override
  String get nextAskAdmin => 'Зверніться до адміністратора вашого сервера.';

  @override
  String get nextAskOwner =>
      'Попросіть власника бібліотеки дозволити вам додавати фото.';

  @override
  String get nextCheckConnection =>
      'Перевірте з’єднання, щоб дізнатися причину.';

  @override
  String get nextCheckEntry => 'Перевірте введені дані і спробуйте знову.';

  @override
  String get nextConfirm =>
      'Перевірте, скільки елементів це зачепить, і підтвердьте.';

  @override
  String get nextDeleteWebhook =>
      'Видаліть вебхук, який більше не потрібен, і спробуйте ще раз.';

  @override
  String get nextEditConfig =>
      'Змініть це в конфігурації сервера і перезапустіть сервер.';

  @override
  String get nextFreeSpace =>
      'Звільніть місце або попросіть в адміністратора більше.';

  @override
  String get nextNewLink => 'Попросіть в адміністратора нове.';

  @override
  String get nextNewestToken => 'Скопіюйте найновіший із журналу photolibd.';

  @override
  String get nextOtherAdmin =>
      'Спершу зробіть адміністратором інший обліковий запис.';

  @override
  String get nextOtherFolder => 'Виберіть окрему теку.';

  @override
  String get nextRefresh => 'Оновіть і спробуйте знову.';

  @override
  String get nextReport =>
      'Спробуйте знову. Якщо це повториться, скопіюйте подробиці нижче для адміністратора.';

  @override
  String get nextSetUpPrivate =>
      'Завершіть налаштування приватних бібліотек у розділі «Налаштування» і спробуйте знову.';

  @override
  String get nextSignIn => 'Увійдіть знову.';

  @override
  String get nextSignInAccount =>
      'Увійдіть зі своїм обліковим записом і спробуйте знову.';

  @override
  String get nextSignInInstead => 'Натомість увійдіть.';

  @override
  String get nextTryAgain => 'Спробуйте знову.';

  @override
  String get nextUpdateAndAgree =>
      'Оновіть застосунок і знову погодьтеся з повідомленням.';

  @override
  String get nextUseAnother => 'Виберіть інше.';

  @override
  String get nextUseHttps =>
      'Використайте адресу https:// сервера або під’єднайтеся з мережі сервера.';

  @override
  String get nextWait => 'Зачекайте хвилину і спробуйте знову.';

  @override
  String get offlineKeep => 'Зберігати офлайн';

  @override
  String offlineKeepHere(String size) {
    return 'Зберігати на цьому пристрої ($size)';
  }

  @override
  String get offlineKeptHere => 'Зберігається на цьому пристрої';

  @override
  String get offlineStopKeeping => 'Не зберігати офлайн';

  @override
  String get otherFiles => 'Інші файли';

  @override
  String get passphraseCreate =>
      'На цьому компʼютері не працює вʼязка ключів (Secret Service), яка зберігала б ключі Photolib. Задайте парольну фразу щонайменше з 10 символів, щоб їх захистити: Photolib питатиме її під час кожного запуску.';

  @override
  String get passphraseLabel => 'Парольна фраза';

  @override
  String get passphraseMismatch => 'Парольні фрази не збігаються.';

  @override
  String get passphraseRepeat => 'Повторіть парольну фразу';

  @override
  String get passphraseTooShort => 'Використайте щонайменше 10 символів.';

  @override
  String get passphraseUnlock =>
      'Введіть парольну фразу, яка захищає ключі Photolib на цьому компʼютері.';

  @override
  String get passphraseWrong => 'Неправильна парольна фраза. Спробуйте ще раз.';

  @override
  String photoPosition(int index, int count) {
    return 'Фото $index з $count';
  }

  @override
  String get privacyCheckKit => 'Перевірити набір відновлення';

  @override
  String get privacyDrillDue =>
      'Час для навчального відновлення: перевірте, чи набір відновлення досі відкриває ваші приватні бібліотеки.';

  @override
  String get privacyHonest =>
      'Приватні бібліотеки шифруються на ваших пристроях, і ніхто інший не може їх відкрити: ні сервер, ні його адміністратор, ні розробники Photolib. Якщо ви втратите і пароль, і набір відновлення, ваші фото буде втрачено назавжди, і ніхто не зможе повернути їх вам.';

  @override
  String get privacyKitBody =>
      'Запишіть ці 24 слова на папері по порядку й зберігайте їх у надійному місці. Вони відкривають ваші приватні бібліотеки, якщо ви забудете пароль, — будь-кому, у кого вони є.';

  @override
  String get privacyKitDone => 'Ваш набір відновлення працює.';

  @override
  String get privacyKitOther => 'Це не ваш поточний набір відновлення.';

  @override
  String get privacyKitTitle => 'Ваш набір відновлення';

  @override
  String get privacyKitUnverified => 'Набір відновлення ще не підтверджено';

  @override
  String privacyKitVerified(String date) {
    return 'Набір відновлення підтверджено $date';
  }

  @override
  String get privacyKitWritten => 'Слова записано';

  @override
  String get privacyNotReady =>
      'Приватні завантаження залишаються вимкненими, доки у вас не буде двох способів розблокування й підтвердженого набору відновлення.';

  @override
  String get privacyPasswordHelp =>
      'Введіть пароль свого облікового запису: він стане одним зі способів розблокувати приватні бібліотеки.';

  @override
  String get privacyPhrase => 'Фраза відновлення';

  @override
  String get privacyPhraseHelp => '24 слова вашого набору відновлення';

  @override
  String get privacyPhraseInvalid =>
      'Це не фраза відновлення. Перевірте кожне слово.';

  @override
  String get privacyReady => 'Приватні завантаження ввімкнено.';

  @override
  String get privacyRecoveryKit => 'Набір відновлення';

  @override
  String get privacySetUp => 'Налаштувати';

  @override
  String get privacyShowWords => 'Показати слова ще раз';

  @override
  String get privacyTitle => 'Приватні бібліотеки';

  @override
  String privacyUnknownWord(int number) {
    return 'Слово $number не є словом набору відновлення.';
  }

  @override
  String get privacyVerify => 'Підтвердити';

  @override
  String get privacyVerifyBody =>
      'Введіть ці слова з набору відновлення, щоб показати, що ви його зберегли.';

  @override
  String get privacyWays => 'Способи розблокування';

  @override
  String privacyWord(int number) {
    return 'Слово $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Ці слова не збігаються з вашим набором відновлення. Перевірте свої записи.';

  @override
  String get privacyWrongPassword => 'Це не пароль вашого облікового запису.';

  @override
  String get problemAdminOnly => 'Це може зробити лише адміністратор.';

  @override
  String get problemBusy => 'Сервер зайнятий або перезапускається.';

  @override
  String get problemChanged => 'Це встигло змінитися.';

  @override
  String get problemConfirm =>
      'Це приховає або видалить більше елементів, ніж сервер робить без підтвердження';

  @override
  String get problemContribute =>
      'Ви не можете додавати фото до цієї бібліотеки.';

  @override
  String get problemCopy => 'Копіювати подробиці';

  @override
  String get problemDetails => 'Подробиці';

  @override
  String get problemDiskLow =>
      'Диск сервера майже заповнений, тому завантаження призупинено.';

  @override
  String get problemEmailTaken =>
      'Ця ел. пошта вже в іншого облікового запису.';

  @override
  String get problemExists => 'Це вже існує.';

  @override
  String get problemFaceNotice =>
      'Ваш сервер вимагає новішої версії повідомлення про обличчя, ніж показує цей застосунок.';

  @override
  String get problemGone => 'Цього вже немає на сервері.';

  @override
  String get problemHandleTaken =>
      'Це ім’я користувача вже в іншого облікового запису.';

  @override
  String get problemInterrupted => 'Завантаження перервалося.';

  @override
  String get problemInvalid => 'Неприпустиме значення';

  @override
  String get problemLastAdmin => 'Серверу потрібен хоча б один адміністратор.';

  @override
  String get problemLinkInvalid =>
      'Термін дії посилання минув, або його вже використано.';

  @override
  String get problemLoginFailed =>
      'Неправильна ел. пошта, ім’я користувача або пароль.';

  @override
  String get problemMaintenanceKey =>
      'Резервне копіювання, перевірку цілісності й остаточне видалення можна призупинити, лише увійшовши в систему, а не за допомогою ключа API';

  @override
  String get problemNotAllowed => 'Вашому обліковому запису це не дозволено.';

  @override
  String get problemNotExternal =>
      'Сканувати можна лише бібліотеки з власних тек сервера.';

  @override
  String get problemOidcClaim =>
      'Ваш сервіс входу не повідомив, хто ви, у вигляді, який приймає цей сервер.';

  @override
  String get problemOidcDown => 'Ваш сервіс входу не відповідає серверу.';

  @override
  String get problemOidcFailed => 'Ваш сервіс входу відхилив вхід.';

  @override
  String get problemOidcNotAllowed =>
      'Вашому обліковому запису не можна входити в такий спосіб.';

  @override
  String get problemOidcTaken =>
      'Цей вхід уже прив’язано до іншого облікового запису Photolib.';

  @override
  String get problemOidcUnknown =>
      'Цей сервер більше не пропонує такий спосіб входу.';

  @override
  String get problemPasskeysOff =>
      'Ключі доступу працюють, лише коли сервер має публічну адресу.';

  @override
  String get problemPinned =>
      'Це задано у файлі конфігурації, і змінити це тут не можна.';

  @override
  String get problemPolicyOff => 'Це вимкнено на цьому сервері.';

  @override
  String get problemQuota => 'Ваше сховище на сервері заповнене.';

  @override
  String get problemRestoreKey =>
      'Відновити резервну копію можна, лише увійшовши в систему, а не за допомогою ключа API.';

  @override
  String get problemRootDiffers => 'У цій папці немає файлів цієї бібліотеки';

  @override
  String get problemRootNotAllowed =>
      'Ця папка не входить до external_roots конфігурації сервера';

  @override
  String get problemRootOverlaps =>
      'Ця папка містить іншу бібліотеку або дані самого сервера чи розташована всередині них';

  @override
  String get problemScanning => 'Ця бібліотека вже сканується';

  @override
  String get problemSecondFactor =>
      'Для цього облікового запису потрібен другий фактор, наприклад код з автентифікатора або ключ доступу, а ця версія Photolib поки не вміє його надати.';

  @override
  String get problemSetupDone => 'Цей сервер уже має адміністратора.';

  @override
  String get problemSetupExpired => 'Це тривало надто довго.';

  @override
  String get problemSetupToken => 'Цей токен налаштування неправильний.';

  @override
  String get problemSignedOut => 'Ви вийшли з системи на сервері.';

  @override
  String get problemStepUp => 'Для цієї зміни спершу потрібен пароль або код.';

  @override
  String get problemStorage => 'Сервер не може зв’язатися зі своїм сховищем.';

  @override
  String get problemTooMany => 'Забагато спроб за короткий час.';

  @override
  String get problemUnexpected => 'Сталося щось непередбачене.';

  @override
  String get problemUnreachable => 'Сервер не відповідає.';

  @override
  String get problemUploadDamaged => 'Файл змінився або пошкодився дорогою.';

  @override
  String get problemUploadExpired =>
      'На сервері більше немає цього завантаження: незавершені завантаження видаляються через добу.';

  @override
  String get problemWebhookLimit =>
      'Ваш обліковий запис уже має стільки вебхуків, скільки дозволено.';

  @override
  String get problemWebhooksOff => 'Вебхуки на цьому сервері вимкнено.';

  @override
  String get recoveryCode => 'Код відновлення';

  @override
  String get recoveryCodeAbout =>
      'Відкриває сховище Photolib на цьому пристрої, якщо сховище ключів втратить його ключ';

  @override
  String get recoveryCodeEnter => 'Ввести код відновлення';

  @override
  String get recoveryCreate => 'Створити код відновлення';

  @override
  String get recoveryLater => 'Пізніше';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString зміни є лише на цьому пристрої. Код відновлення поверне їх, якщо сховище ключів втратить ключ Photolib.',
      many:
          '$countString змін є лише на цьому пристрої. Код відновлення поверне їх, якщо сховище ключів втратить ключ Photolib.',
      few:
          '$countString зміни є лише на цьому пристрої. Код відновлення поверне їх, якщо сховище ключів втратить ключ Photolib.',
      one:
          '$countString зміна є лише на цьому пристрої. Код відновлення поверне її, якщо сховище ключів втратить ключ Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Запишіть ці 24 слова й зберігайте їх у надійному місці: вони відкривають сховище Photolib на цьому пристрої без ключа зі сховища ключів. Вони замінюють будь-який попередній код.';

  @override
  String get recoveryUnlock => 'Розблокувати';

  @override
  String get recoveryWrong => 'Це не код відновлення цього сховища';

  @override
  String get renameFind => 'Знайти';

  @override
  String get renamePattern => 'Нове ім\'я';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Задовге: ім\'я займає не більше 255 байтів',
      'invalid': 'Неприпустиме ім\'я файлу',
      'duplicate': 'Дано й іншому файлу',
      'exists': 'Це ім\'я вже має інший файл у папці',
      'other': 'Не можна перейменувати',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Замінити на';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Файлів перейменовано: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Показати у Finder',
      'windows': 'Показати в Провіднику',
      'other': 'Показати в папці',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Камера';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString елемента',
      many: '$countString елементів',
      few: '$countString елементи',
      one: '$countString елемент',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Дати';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Пошук у бібліотеці';

  @override
  String get searchFavourites => 'Вибране';

  @override
  String get searchFolder => 'Папка';

  @override
  String get searchHint => 'Назва файлу або папки';

  @override
  String get searchMotionPhotos => 'Фото з рухом';

  @override
  String get searchNothing => 'Нічого не знайдено';

  @override
  String get searchPanoramas => 'Панорами';

  @override
  String get searchPhotos => 'Фото';

  @override
  String get searchScreenshots => 'Знімки екрана';

  @override
  String get searchVideo => 'Відео';

  @override
  String get searchVideos => 'Відео';

  @override
  String get securityAddPasskey => 'Додати ключ доступу';

  @override
  String get securityCode => 'Код';

  @override
  String get securityCodesHelp =>
      'Збережіть ці коди в надійному місці. Кожен спрацьовує один раз замість другого фактора, і показуються вони лише зараз.';

  @override
  String securityCodesLeft(int count) {
    return 'Не використано: $count';
  }

  @override
  String get securityNewCodes => 'Нові коди';

  @override
  String get securityPasskeyNotAdded => 'Ключ доступу не додано.';

  @override
  String get securityRecoveryCodes => 'Коди відновлення';

  @override
  String get securityRemovePasskey => 'Видалити ключ доступу';

  @override
  String get securitySetUp => 'Налаштувати';

  @override
  String get securityStepUpBody =>
      'Щоб змінити другі фактори, введіть пароль, код із застосунку-автентифікатора або код відновлення.';

  @override
  String get securityStepUpTitle => 'Підтвердьте, що це ви';

  @override
  String get securityTitle => 'Другі фактори';

  @override
  String get securityTotp => 'Застосунок-автентифікатор';

  @override
  String get securityTotpHelp =>
      'Додайте цей ключ у застосунок-автентифікатор, потім введіть код, який він покаже.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Увімкнено',
      'other': 'Вимкнено',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Вимкнути';

  @override
  String get securityWrongCode => 'Неправильний код.';

  @override
  String get securityWrongProof => 'Неправильний пароль або код.';

  @override
  String get selectAll => 'Вибрати все';

  @override
  String get selectionClear => 'Скасувати вибір';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вибрано $countString елемента',
      many: 'Вибрано $countString елементів',
      few: 'Вибрано $countString елементи',
      one: 'Вибрано $countString елемент',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Показати вибрані';

  @override
  String get serverAccount => 'Ел. пошта або ім’я користувача';

  @override
  String get serverAdd => 'Додати сервер';

  @override
  String get serverAddressInvalid =>
      'Введіть адреси на кшталт photos.example.org';

  @override
  String get serverAddresses => 'Адреси';

  @override
  String get serverAddressesHelp =>
      'По одній у рядку: сервер у вашій мережі, в інтернеті або через VPN. Застосунок використовує найшвидшу з тих, що відповідають. Або вставте отримане посилання для встановлення пароля.';

  @override
  String get serverCa => 'Сертифікат приватного ЦС (PEM)';

  @override
  String get serverCaChoose => 'Вибрати файл сертифіката';

  @override
  String serverCertificateBody(String host) {
    return '$host надає сертифікат, якому цей пристрій не довіряє. Довіряйте йому, лише якщо цей відбиток SHA-256 збігається з відбитком вашого сервера:';
  }

  @override
  String get serverCertificateTitle => 'Довіряти цьому сертифікату?';

  @override
  String get serverConfirm => 'Підтвердити';

  @override
  String get serverConnect => 'Під’єднатися';

  @override
  String get serverCreateAdmin => 'Створити адміністратора';

  @override
  String get serverEnded => 'Сервер завершив цей сеанс. Увійдіть знову.';

  @override
  String get serverHandleHelp =>
      'Малі літери, цифри, крапки, дефіси й підкреслення; воно ніколи не змінюється.';

  @override
  String get serverHeaders => 'Власні заголовки';

  @override
  String get serverHeadersHelp =>
      'По одному в рядку, у вигляді Name: value; надсилаються лише через HTTPS';

  @override
  String get serverHeadersInvalid =>
      'Запишіть кожен заголовок у вигляді Name: value';

  @override
  String get serverIdentity => 'Сертифікат клієнта (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Вибрати сертифікат клієнта';

  @override
  String get serverIdentityInvalid =>
      'Це не сертифікат PKCS#12, або його пароль неправильний.';

  @override
  String get serverIdentityPassword => 'Пароль сертифіката клієнта';

  @override
  String get serverLoading => 'Читання сервера, збереженого на цьому пристрої';

  @override
  String get serverNearby => 'Сервери в цій мережі';

  @override
  String get serverNeedsHttps =>
      'Цьому серверу потрібна адреса HTTPS: поза локальною мережею Photolib не входить через звичайний HTTP.';

  @override
  String get serverNoSignIn =>
      'Цей сервер не пропонує способів входу, які підтримує ця версія Photolib.';

  @override
  String get serverOffline => 'Сервер не відповідає. Ви залишаєтеся в системі.';

  @override
  String get serverPasskeyFailed =>
      'Ключ доступу не використано. Спробуйте ще раз або введіть код.';

  @override
  String get serverPasskeyRequired =>
      'Цей сервер вимагає ключ доступу, який ця версія Photolib поки не підтримує.';

  @override
  String get serverPassword => 'Пароль';

  @override
  String get serverPasswordAgain => 'Повторіть пароль';

  @override
  String get serverPasswordSetupInvalid =>
      'Цей токен для встановлення пароля неправильний, уже використаний або прострочений. Попросіть новий.';

  @override
  String get serverPasswordSetupToken => 'Токен для встановлення пароля';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Від адміністратора або з виводу photolibd admin password-setup на сервері.';

  @override
  String get serverPasswordsDiffer => 'Паролі не збігаються.';

  @override
  String get serverPrivateLibrariesBody =>
      'Новий пароль їх не відкриває. Відкрийте їх знову за допомогою набору відновлення, ключа доступу або пристрою, на якому ви ще ввійшли.';

  @override
  String get serverPrivateLibrariesGo => 'Встановити пароль';

  @override
  String get serverPrivateLibrariesTitle =>
      'Ваші приватні бібліотеки залишаються заблокованими';

  @override
  String get serverProxy => 'HTTP-проксі у вигляді host:port';

  @override
  String get serverProxyInvalid => 'Введіть проксі у вигляді host:port';

  @override
  String get serverRecoveryCode => 'Код відновлення';

  @override
  String get serverRemove => 'Видалити цей сервер';

  @override
  String get serverRequired => 'Обов’язкове поле';

  @override
  String get serverSecondFactor =>
      'Другий фактор цього облікового запису — ключ доступу, який ця версія Photolib поки не підтримує.';

  @override
  String get serverSecondFactorCode =>
      'Для цього облікового запису також потрібен код із застосунку-автентифікатора або код відновлення.';

  @override
  String get serverSecondFactorTitle => 'Підтвердьте, що це ви';

  @override
  String get serverSecondFactorWrong =>
      'Не вдалося. Після п\'яти спроб увійдіть знову.';

  @override
  String get serverSetPassword => 'Встановити пароль';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Для $handle на $server';
  }

  @override
  String get serverSetPasswordOpen => 'Встановити пароль';

  @override
  String get serverSetPasswordTitle => 'Встановіть пароль';

  @override
  String get serverSetUp => 'Налаштувати новий сервер';

  @override
  String get serverSetupLinkElsewhere =>
      'Щоб скористатися цим посиланням, спершу вийдіть із цього сервера або видаліть його, якщо посилання для іншого.';

  @override
  String get serverSetupTitle => 'Налаштування сервера';

  @override
  String get serverSetupToken => 'Токен налаштування';

  @override
  String get serverSetupTokenHelp =>
      'photolibd виводить його в журнал, доки на сервері немає адміністратора; кожен запуск виводить новий.';

  @override
  String get serverSignIn => 'Увійти';

  @override
  String get serverSignOut => 'Вийти';

  @override
  String serverSignedInAs(String account) {
    return 'Ви ввійшли як $account';
  }

  @override
  String get serverSignedOut => 'Ви вийшли';

  @override
  String get serverSwitch => 'Змінити обліковий запис';

  @override
  String get serverTotpCode => 'Код із застосунку автентифікації';

  @override
  String get serverTrust => 'Довіряти';

  @override
  String get serverUnreadable =>
      'Не вдається прочитати сервер, збережений на цьому пристрої';

  @override
  String get serverUsePasskey => 'Використати ключ доступу';

  @override
  String get serverUseRecoveryCode => 'Використати код відновлення';

  @override
  String get settingsBackground => 'Тло прозорих зображень';

  @override
  String get settingsDefaultTab => 'Папки й альбоми відкриваються на вкладці';

  @override
  String get settingsFolders => 'Папки';

  @override
  String get settingsIndexing => 'Індексація на цьому пристрої';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsLibrary => 'Бібліотека';

  @override
  String get settingsServer => 'Сервер';

  @override
  String get settingsStart => 'Початковий екран';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Торкніться лівого чи правого краю для попереднього чи наступного елемента',
      'oneFingerZoom':
          'Двічі торкніться й перетягніть, щоб масштабувати одним пальцем',
      'swipes': 'Проведіть угору чи вниз лівою стороною відео для яскравості, правою — для гучності',
      'maxBrightness': 'Повна яскравість під час перегляду',
      'autoRotate': 'Повертати за орієнтацією кожного фото чи відео',
      'mixAudio':
          'Відтворювати відео поверх іншого звуку, не призупиняючи його',
      'autoplay': 'Відтворювати відео під час відкриття',
      'loop': 'Повторювати відео',
      'autoNext': 'Переходити до наступного елемента, коли відео закінчиться',
      'resume': 'Продовжувати відео з місця зупинки',
      'other': 'Відтворювати анімовані зображення в сітці',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'Кнопки на панелі перегляду';

  @override
  String get settingsViewing => 'Перегляд';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString обʼєкта, якими поділилися з Photolib, чекають на дозвіл додати їх до вашої медіатеки «Фото». Незбережені обʼєкти видаляються через 7 днів.',
      many:
          '$countString обʼєктів, якими поділилися з Photolib, чекають на дозвіл додати їх до вашої медіатеки «Фото». Незбережені обʼєкти видаляються через 7 днів.',
      few:
          '$countString обʼєкти, якими поділилися з Photolib, чекають на дозвіл додати їх до вашої медіатеки «Фото». Незбережені обʼєкти видаляються через 7 днів.',
      one:
          '$countString обʼєкт, яким поділилися з Photolib, чекає на дозвіл додати його до вашої медіатеки «Фото». Незбережені обʼєкти видаляються через 7 днів.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Завеликий обсяг, щоб поділитися за раз: виберіть менше елементів';

  @override
  String shareTooMany(int count) {
    return 'Забагато, щоб поділитися за раз: виберіть не більше $count';
  }

  @override
  String get shortcutsTitle => 'Комбінації клавіш';

  @override
  String get slideshow => 'Слайд-шоу';

  @override
  String get slideshowLoop => 'Повтор';

  @override
  String get slideshowOptions => 'Параметри слайд-шоу';

  @override
  String get slideshowSeconds => 'Секунд на елемент';

  @override
  String get slideshowShuffle => 'Випадковий порядок';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'За спаданням',
      'other': 'За зростанням',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Цей пристрій';

  @override
  String sourceHide(String name) {
    return 'Приховати $name';
  }

  @override
  String get sourceHideOthers => 'Приховати все інше тут';

  @override
  String get sourceLost => 'Немає доступу';

  @override
  String get sourcePartly => 'Показано частково';

  @override
  String sourceShow(String name) {
    return 'Показати $name';
  }

  @override
  String get sourceShowEverything => 'Показувати все тут';

  @override
  String get sourceShowOnly => 'Показувати лише це';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Хронологія',
      'folders': 'Папки й альбоми',
      'favourites': 'Вибране',
      'other': 'Хронологія',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Зберігати людину офлайн';

  @override
  String get storageBudget => 'Ліміт сховища';

  @override
  String get storageClear => 'Видалити офлайн-копії';

  @override
  String get storageClearAction => 'Видалити';

  @override
  String storageClearBody(String size) {
    return 'Буде видалено $size, що зберігаються на цьому пристрої, а альбоми, пошуки й фото більше не зберігатимуться офлайн. Ваша бібліотека на сервері не зазнає змін.';
  }

  @override
  String get storageKeepLibrary => 'Зберігати всю бібліотеку';

  @override
  String get storageKeepOriginals => 'Зберігати й оригінали';

  @override
  String get storageNoPeople => 'Поки немає людей з іменами.';

  @override
  String get storageNoPins =>
      'Нічого не закріплено. Закріпіть альбом, пошук або фото, щоб зберігати їх офлайн.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Альбом',
      'search': 'Пошук',
      'person': 'Людина',
      'library': 'Уся бібліотека',
      'asset': 'Фото',
      'other': 'Закріплено',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Не вміщується в ліміт: потрібно ще $size';
  }

  @override
  String get storagePinNothing =>
      'Нічого завантажувати: фото вже на цьому пристрої';

  @override
  String get storagePinPaused =>
      'Очікування: цей режим нічого не зберігає офлайн';

  @override
  String get storagePinPlanning => 'Визначаємо, що зберігати…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Завантаження: $haveString з $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Доступно офлайн ($size)';
  }

  @override
  String get storagePinWaiting => 'Завантажиться, коли з\'явиться мережа';

  @override
  String get storagePins => 'Зберігається офлайн';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Лише каталог',
      'spaceSaver': 'Економія місця',
      'travel': 'Вибрані альбоми офлайн',
      'everything': 'Усе',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Нічого не зберігає; фото завантажуються з вашого сервера під час відкриття.',
      'spaceSaver':
          'Зберігає превʼю всієї бібліотеки, спершу нові, у межах ліміту.',
      'travel': 'Зберігає лише закріплене: альбоми, пошуки й фото.',
      'everything':
          'Зберігає оригінали всієї бібліотеки, спершу нові, у межах ліміту.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Що зберігає цей пристрій';

  @override
  String get storageSubtitle => 'Офлайн-копії та ліміт сховища';

  @override
  String get storageTitle => 'Сховище';

  @override
  String storageUsed(String used, String budget) {
    return 'Використано $used з $budget';
  }

  @override
  String get storageWebNote =>
      'Браузер зберігає лише превʼю й стирає їх під час виходу з облікового запису.';

  @override
  String get storeNoKeyring =>
      'Photolib зберігає ключ свого локального сховища в системній в\'язці ключів, яка не відповіла. Установіть і розблокуйте gnome-keyring, KWallet або KeePassXC з увімкненою службою Secret Service і спробуйте ще раз.';

  @override
  String get storeNoKeystore =>
      'Photolib не вдалося зв\'язатися зі сховищем ключів цього пристрою, де зберігається ключ його локального сховища.';

  @override
  String get storeRebuilt =>
      'У сховищі ключів цього пристрою більше не було ключа локального сховища Photolib, тому сховище створено заново. Його налаштування й те, що було лише на цьому пристрої, втрачено; медіатеки синхронізуються знову, а мініатюри повернуться.';

  @override
  String get storeRecoveryNeeded =>
      'У сховищі ключів цього пристрою більше немає ключа локального сховища Photolib. Введіть код відновлення або скиньте сховище, втративши те, що є лише на цьому пристрої.';

  @override
  String get storeReset => 'Скинути сховище';

  @override
  String get storeResetBody =>
      'Те, що є лише на цьому пристрої, буде втрачено; медіатеки синхронізуються знову, а мініатюри повернуться.';

  @override
  String get storeUnavailable =>
      'Сховище на цьому пристрої недоступне: налаштування й колекції не зберігаються';

  @override
  String get tabCollections => 'Колекції';

  @override
  String get tabLibrary => 'Бібліотека';

  @override
  String get tabSearch => 'Пошук';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeSystem => 'Як у системі';

  @override
  String get timelineBenchmark => 'Тест продуктивності стрічки';

  @override
  String get timelineBenchmarkCopy => 'Скопіювати результати';

  @override
  String get timelineCannotPlay => 'Не відтворюється в цьому браузері';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position з $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position з $count, без попереднього перегляду';
  }

  @override
  String get timelineExcluded => 'У виключеній папці';

  @override
  String get timelineScrubber => 'Прокручування за датами';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Дата невідома';

  @override
  String timelineWeek(String date) {
    return 'Тиждень з $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Додати «$action» на панель';
  }

  @override
  String toolbarDown(String action) {
    return 'Перемістити «$action» нижче';
  }

  @override
  String get toolbarInBar => 'На панелі';

  @override
  String get toolbarInMenu => 'У меню ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Прибрати «$action» з панелі';
  }

  @override
  String get toolbarReset => 'Скинути до типових';

  @override
  String toolbarUp(String action) {
    return 'Перемістити «$action» вище';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Перемістити сюди',
      'other': 'Копіювати сюди',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Файл або папка з таким ім\'ям уже є',
      'changed': 'Копія не збіглася з оригіналом і її видалено',
      'cancelled': 'Скасовано',
      'invalid': 'Неприпустима назва папки',
      'other': 'Помилка',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Нещодавні';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Видалити $countString елемента назавжди? Це не можна скасувати.',
      many: 'Видалити $countString елементів назавжди? Це не можна скасувати.',
      few: 'Видалити $countString елементи назавжди? Це не можна скасувати.',
      one: 'Видалити $countString елемент назавжди? Це не можна скасувати.',
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
      other: 'Залишилося $daysString дня',
      many: 'Залишилося $daysString днів',
      few: 'Залишилося $daysString дні',
      one: 'Залишився $daysString день',
      zero: 'Буде видалено сьогодні',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Кошик порожній';

  @override
  String get trashEmptyAll => 'Очистити кошик';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString елемента переміщено в кошик',
      many: '$countString елементів переміщено в кошик',
      few: '$countString елементи переміщено в кошик',
      one: '$countString елемент переміщено в кошик',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib назавжди видаляє те, що зберігає в кошику, через $days днів; кожен елемент показує, скільки часу йому залишилося.';
  }

  @override
  String get trashTitle => 'Кошик';

  @override
  String get undo => 'Скасувати';

  @override
  String get uploadAction => 'Завантажити фото й відео';

  @override
  String get uploadClear => 'Очистити';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Завантажено $doneString із $totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Помилок: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString елемента архівовано',
      many: '$countString елементів архівовано',
      few: '$countString елементи архівовано',
      one: '$countString елемент архівовано',
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
      other: '$countString елемента приховано',
      many: '$countString елементів приховано',
      few: '$countString елементи приховано',
      one: '$countString елемент приховано',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Чорне',
      'white': 'Біле',
      'other': 'Шахове',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Це відео не можна відтворити на цьому пристрої';

  @override
  String get viewerCaptions => 'Субтитри';

  @override
  String get viewerCompass => 'Блокування за компасом';

  @override
  String get viewerCopy => 'Копіювати';

  @override
  String get viewerCopyText => 'Копіювати текст';

  @override
  String get viewerCustomize => 'Налаштувати панель інструментів…';

  @override
  String get viewerDial =>
      'Напрямок. Натисніть, щоб дивитися вперед. Перетягніть, щоб роззирнутися, прокрутіть або зведіть пальці для масштабу, двічі натисніть для скидання';

  @override
  String get viewerFilmstrip => 'Стрічка мініатюр';

  @override
  String get viewerFirst => 'Перше';

  @override
  String get viewerFisheye => 'Риб\'яче око';

  @override
  String get viewerGyroscope => 'Рухайте пристрій, щоб роззирнутися';

  @override
  String get viewerHdr => 'Показати в HDR';

  @override
  String get viewerInfo => 'Відомості';

  @override
  String get viewerInfoLoading => 'Завантаження відомостей про цей елемент';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString з $countString';
  }

  @override
  String get viewerLast => 'Останнє';

  @override
  String get viewerLenses => 'Вибрати об’єктив';

  @override
  String get viewerMap => 'Карта';

  @override
  String get viewerMotion => 'Відтворити рух';

  @override
  String get viewerMotionDenied =>
      'Цей браузер не дозволив доступ до датчиків руху';

  @override
  String get viewerMotionMissing =>
      'На цьому пристрої немає гіроскопа, щоб роззирнутися';

  @override
  String get viewerMute => 'Вимкнути звук';

  @override
  String get viewerNext => 'Наступне';

  @override
  String get viewerNextFrame => 'Наступний кадр';

  @override
  String get viewerPause => 'Пауза';

  @override
  String get viewerPlanet => 'Маленька планета';

  @override
  String get viewerPlay => 'Відтворити';

  @override
  String get viewerPrevious => 'Попереднє';

  @override
  String get viewerPreviousFrame => 'Попередній кадр';

  @override
  String get viewerRotate => 'Повернути';

  @override
  String get viewerSdr => 'Показати в SDR';

  @override
  String get viewerSeek => 'Позиція';

  @override
  String get viewerSetAs => 'Установити як';

  @override
  String get viewerShare => 'Поділитися';

  @override
  String get viewerSpeed => 'Швидкість відтворення';

  @override
  String get viewerSphere =>
      'Огляд 360°. Перетягуйте, щоб роззирнутися, зводьте пальці для масштабу';

  @override
  String get viewerText => 'Текст на цьому фото';

  @override
  String get viewerTextCopied => 'Текст скопійовано';

  @override
  String get viewerTextNone => 'На цьому фото текст не знайдено';

  @override
  String get viewerTextUnread => 'Текст на цьому фото ще не розпізнано';

  @override
  String get viewerUnmute => 'Увімкнути звук';

  @override
  String get viewerZoomIn => 'Збільшити';

  @override
  String get viewerZoomOut => 'Зменшити';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD-карта',
      'other': 'Внутрішня',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Збільшити';

  @override
  String get zoomOut => 'Зменшити';
}
