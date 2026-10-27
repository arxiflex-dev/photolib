// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get actionAddToAlbum => 'Добавить в альбом';

  @override
  String get actionArchive => 'Архивировать';

  @override
  String get actionCopyTo => 'Копировать в…';

  @override
  String get actionDeleteForever => 'Удалить навсегда';

  @override
  String get actionFavourite => 'Добавить в избранное';

  @override
  String get actionHide => 'Скрыть';

  @override
  String get actionMoveTo => 'Переместить в…';

  @override
  String get actionRename => 'Переименовать';

  @override
  String get actionRestore => 'Восстановить';

  @override
  String get actionShare => 'Поделиться';

  @override
  String get actionTrash => 'Переместить в корзину';

  @override
  String get actionUnarchive => 'Вернуть из архива';

  @override
  String get actionUndo => 'Отменить';

  @override
  String get actionUnfavourite => 'Убрать из избранного';

  @override
  String get actionUnhide => 'Показать';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Активна',
      'disabled': 'Отключена',
      'invited': 'Приглашена',
      'deleted': 'Удалена',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Учётные записи';

  @override
  String get adminAddAccount => 'Добавить учётную запись';

  @override
  String get adminAddExternalLibrary => 'Добавить внешнюю библиотеку';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts попытки',
      many: '$attempts попыток',
      few: '$attempts попытки',
      one: '$attempts попытка',
      zero: 'ещё не запускалась',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Журнал аудита';

  @override
  String get adminBackUpNow => 'Создать копию сейчас';

  @override
  String get adminBackupQueued =>
      'Резервная копия в очереди; за ней последует учебное восстановление';

  @override
  String get adminBackups => 'Резервные копии базы данных';

  @override
  String get adminCancelJob => 'Отменить задачу';

  @override
  String get adminCapabilities => 'Возможности';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Управляемые библиотеки',
      'uploads': 'Загрузки с устройств, из веба и CLI',
      'folder_browser': 'Просмотр папок',
      'device_folders': 'Папки устройства в подключённых приложениях',
      'sharing': 'Общий доступ и публичные ссылки',
      'edits': 'Редактирование',
      'deletes': 'Удаление',
      'xmp_writes': 'Запись файлов XMP',
      'face_recognition': 'Распознавание лиц',
      'ml_search': 'Умный поиск',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'ОК',
      'warn': 'Предупреждение',
      'fail': 'Не пройдена',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Скопировано';

  @override
  String get adminCopyBundle => 'Скопировать диагностику для отчёта об ошибке';

  @override
  String get adminCopyLink => 'Копировать ссылку';

  @override
  String get adminDelete => 'Удалить';

  @override
  String get adminDeviceBackups => 'Резервные копии устройств';

  @override
  String get adminDevices => 'Ваши устройства';

  @override
  String get adminDisable => 'Отключить';

  @override
  String adminDrillFailed(String detail) {
    return 'Последнее учебное восстановление не удалось: $detail';
  }

  @override
  String get adminEdit => 'Изменить';

  @override
  String get adminEmail => 'Электронная почта';

  @override
  String get adminEnable => 'Включить';

  @override
  String get adminErrorSignIn => 'Войдите как администратор';

  @override
  String get adminFacesDefault =>
      'Распознавание лиц включено по умолчанию для новых учётных записей';

  @override
  String get adminFiles => 'Файлы по типам';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Повреждён',
      'missing': 'Отсутствует',
      'size': 'Неверный размер',
      'hash': 'Заменён',
      'orphan': 'Лишний файл',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return 'Свободно: $size';
  }

  @override
  String get adminFreeDisk =>
      'Порог свободного места на диске для приостановки загрузки, в процентах, от 0 до 50';

  @override
  String get adminFreeDiskGb =>
      'или ниже этого свободного места в ГБ, если оно меньше, от 0 до 100000';

  @override
  String get adminHandle => 'Имя пользователя';

  @override
  String get adminIntegrity => 'Целостность';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString объекта',
      many: '$countString объектов',
      few: '$countString объекта',
      one: '$countString объект',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'В очереди',
      'running': 'Выполняется',
      'done': 'Выполнена',
      'dead': 'Ошибка',
      'cancelled': 'Отменена',
      'other': 'Все',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Тип задачи, например render';

  @override
  String get adminJobs => 'Задачи';

  @override
  String adminLastSeen(String time) {
    return 'Последняя активность: $time';
  }

  @override
  String get adminLibraries => 'Библиотеки';

  @override
  String get adminLibraryOwner => 'Владелец';

  @override
  String get adminLibraryRoot => 'Папка на сервере, например /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Доступна',
      'offline': 'Недоступна',
      'scanning': 'Сканирование',
      'error': 'Ошибка',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Журнал сервера';

  @override
  String get adminName => 'Имя';

  @override
  String get adminNothing => 'Здесь пока ничего нет';

  @override
  String get adminOutOfRange => 'Вне допустимого диапазона';

  @override
  String get adminOverview => 'Обзор';

  @override
  String get adminPair => 'Связать устройство';

  @override
  String get adminPairBody =>
      'Отсканируйте этот код или отправьте ссылку, затем вставьте её в Photolib на новом устройстве в разделе «Добавить сервер»: она передаёт все адреса этого сервера и его сертификат, чтобы никому не пришлось их вводить.';

  @override
  String get adminPasswordSetup => 'Ссылка для задания пароля';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Отправьте эту ссылку $name любым способом или дайте отсканировать код. Она задаёт пароль один раз, до $date.';
  }

  @override
  String get adminPause => 'Приостановить тип задач';

  @override
  String adminPauseMinutes(int max) {
    return 'Минуты, от 1 до $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return 'Задачи типа $type приостановлены до $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось скопировать $countString объекта',
      many: 'Осталось скопировать $countString объектов',
      few: 'Осталось скопировать $countString объекта',
      one: 'Осталось скопировать $countString объект',
      zero: 'Нечего копировать',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Политики';

  @override
  String get adminPolicyReset => 'Использовать значение уровня выше';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Включено по умолчанию',
      'server': 'Задано для сервера',
      'user': 'Задано для этой учётной записи',
      'library': 'Задано для этой библиотеки',
      'config': 'Задано в конфигурации',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Применить шаблон';

  @override
  String get adminPresetBody =>
      'Шаблон задаёт каждую возможность для сервера и сбрасывает то, что задали учётные записи и библиотеки. Всё остаётся изменяемым.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Просмотр архива',
      'family_backup': 'Семейное резервное копирование',
      'personal': 'Личный',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Внешние библиотеки только для чтения — единственный источник истины: без загрузок, управляемых библиотек, папок устройства, редактирования, удаления и записи XMP',
      'family_backup': 'Всё включено, кроме записи XMP',
      'personal': 'Всё включено, кроме общего доступа и публичных ссылок',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'QR-код ссылки';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString задачи в очереди',
      many: '$countString задач в очереди',
      few: '$countString задачи в очереди',
      one: '$countString задача в очереди',
      zero: 'Нечего обрабатывать',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'Квота хранилища в ГБ; пусто — без ограничения';

  @override
  String get adminRemote => 'Удалённый доступ';

  @override
  String get adminRemoteBody =>
      'Подключайтесь к серверу откуда угодно, не открывая порт на роутере. Выберите способ; каждый даёт ему адрес HTTPS для приложений. Затем проверьте его снаружи.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared сам подключается к Cloudflare, который отдаёт ваш домен по HTTPS. Бесплатный тариф ограничивает запрос 100 МБ, а резервное копирование до этого не доходит: оно отправляет по 8 МиБ.';

  @override
  String get adminRemoteNoAddress =>
      'Добавьте в это приложение адрес сервера с https:// в начале, чтобы проверить его снаружи.';

  @override
  String get adminRemoteReachable => 'Доступен снаружи.';

  @override
  String get adminRemoteTailscale =>
      'Установите Tailscale на компьютер сервера и на каждое устройство, в одну tailnet или ваш Headscale, затем выполните это на компьютере сервера и укажите в public_url адрес, который он выведет.';

  @override
  String get adminRemoteTest => 'Проверить снаружи';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host откроет $url со своих серверов по всему миру и так узнает этот адрес. Продолжить?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Недоступен снаружи: проверьте выбранный способ и повторите проверку.';

  @override
  String get adminRemoteWireguard =>
      'Нужен один открытый порт UDP на стороне сервера или на узле-посреднике. Это конфигурация для устройства; ключи создайте командой wg genkey.';

  @override
  String get adminRepair =>
      'Восстановите его из резервной копии или с устройства, где он ещё есть';

  @override
  String get adminRepairOrphan =>
      'Ни одно фото на него не ссылается: проверьте его, затем удалите или оставьте';

  @override
  String get adminReprocess => 'Обработать заново';

  @override
  String get adminReprocessFaces => 'Повторно обнаружить лица';

  @override
  String get adminReprocessFolder =>
      'Папка, например 2024/05; пусто — вся библиотека';

  @override
  String get adminReprocessMetadata => 'Повторно прочитать метаданные';

  @override
  String get adminReprocessRenditions => 'Заново создать миниатюры и превью';

  @override
  String get adminRestore => 'Восстановить';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Восстановление $name не удалось: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Ни одно учебное восстановление ещё не прошло';

  @override
  String adminRestoreVerified(String when) {
    return 'Последнее проверенное восстановление: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd остановится и при следующем запуске заменит всю базу данных копией $name. Изменения после этой копии будут потеряны, а каждое устройство синхронизируется заново.';
  }

  @override
  String get adminRestoring =>
      'photolibd останавливается, чтобы восстановить копию';

  @override
  String get adminResume => 'Возобновить';

  @override
  String get adminRetry => 'Повторить';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Администратор',
      'user': 'Пользователь',
      'viewer': 'Читатель',
      'other': 'Неизвестно',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Сохранено';

  @override
  String get adminScan => 'Сканировать сейчас';

  @override
  String get adminScrubDays =>
      'Дней, за которые проверка проходит каждый оригинал, от 1 до 3650';

  @override
  String get adminScrubNever => 'Идёт первая полная проверка';

  @override
  String adminScrubbed(String time) {
    return 'Последняя полная проверка $time';
  }

  @override
  String get adminSecondAdmin =>
      'Сделайте администратором второго человека, чтобы кто-то другой мог обслуживать и восстанавливать сервер, если вы не сможете.';

  @override
  String adminSilent(String time) {
    return 'Молчит с $time';
  }

  @override
  String get adminSilentHours =>
      'Часов без отчёта, после которых резервное копирование устройства считается молчащим, от 1 до 8760';

  @override
  String get adminStores => 'Хранилище';

  @override
  String get adminThisDevice => 'Это устройство';

  @override
  String get adminTitle => 'Администрирование сервера';

  @override
  String get adminTrashDays => 'Дней в корзине, от 1 до 3650';

  @override
  String get adminTwoFactor =>
      'Для всех учётных записей обязательна двухфакторная аутентификация';

  @override
  String get adminUsage => 'Использование по учётным записям';

  @override
  String get albumCover => 'Сделать обложкой';

  @override
  String get albumEmpty => 'В этом альбоме пусто';

  @override
  String get albumHideMemories => 'Скрыть из воспоминаний';

  @override
  String get albumHideTimeline => 'Скрыть из ленты';

  @override
  String get albumNew => 'Новый альбом';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Любая дата';

  @override
  String get backupCap => 'Самый большой объект';

  @override
  String get backupCharging => 'Только во время зарядки';

  @override
  String backupCompleted(String time) {
    return 'Последнее полное резервирование: $time';
  }

  @override
  String backupContact(String time) {
    return 'Последняя связь с сервером: $time';
  }

  @override
  String get backupEnabled => 'Резервировать это устройство';

  @override
  String get backupFolderNo => 'Не эту';

  @override
  String get backupFolderYes => 'Резервировать';

  @override
  String backupHours(int count) {
    return '$count ч';
  }

  @override
  String get backupMetered =>
      'В лимитных сетях, например мобильной или точке доступа';

  @override
  String get backupNever => 'Полного резервирования ещё не было';

  @override
  String backupNewFolder(String name) {
    return 'Новая папка $name: резервировать?';
  }

  @override
  String get backupNoLimit => 'Без ограничений';

  @override
  String get backupNothing => 'Ничего не ждёт';

  @override
  String get backupNow => 'Резервировать сейчас';

  @override
  String backupOverdue(int hours, String items) {
    return 'Нет полного резервирования $hours ч. Ожидают: $items';
  }

  @override
  String get backupOverdueTitle => 'Резервирование не завершено';

  @override
  String backupPending(String items) {
    return 'Ожидают: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Повтор: $time';
  }

  @override
  String get backupRoaming => 'Резервировать в роуминге';

  @override
  String get backupSignIn =>
      'Войдите на сервер, чтобы резервировать это устройство';

  @override
  String get backupSignedOut =>
      'Резервирование остановлено: сервер завершил сеанс этого устройства. Войдите снова в настройках.';

  @override
  String get backupSince => 'Снято с';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Резервирование ждёт, пока сервер станет доступен',
      'charging': 'Резервирование ждёт зарядки устройства',
      'battery_low': 'Резервирование ждёт: батарея разряжена',
      'roaming': 'Резервирование ждёт, пока вы в роуминге',
      'quota': 'Резервирование остановлено: хранилище на сервере заполнено',
      'second_factor': 'Резервирование остановлено: сервер требует второй фактор для этой учётной записи',
      'other': 'Резервирование остановлено: сервер ответил $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Резервирование';

  @override
  String get backupWaiting => 'Не зарезервировано';

  @override
  String get backupWarnAfter => 'Предупреждать, если не завершено за';

  @override
  String get backupWhat => 'Что резервировать';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'В папке, которую вы не выбрали',
      'folder_new': 'В новой папке: решите, резервировать ли её',
      'type_excluded': 'Тип объектов, который вы не выбрали',
      'before_date': 'Снято до выбранной даты',
      'selected': 'Ждёт своей очереди',
      'server_restored':
          'Сервер потерял его при восстановлении: отправляется снова',
      'working': 'Резервируется',
      'waiting_for_icloud': 'Ждёт загрузки из iCloud',
      'metered': 'Ждёт нелимитной сети',
      'metered_cap': 'Слишком большой для лимитной сети',
      'unreadable': 'Это устройство не может его прочитать',
      'changed': 'Изменился во время отправки',
      'quota': 'Хранилище на сервере заполнено',
      'other': 'Сервер отказал: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Сервер больше не работает с этой версией Photolib.';

  @override
  String get checkAppTooOldNext => 'Обновите Photolib.';

  @override
  String get checkChanged =>
      'Сертификат сервера — не тот, которому вы доверились.';

  @override
  String get checkChangedNext =>
      'Если администратор его заменил, доверьтесь новому. Если нет, вас могут подслушивать: не продолжайте.';

  @override
  String get checkClock =>
      'Часы этого устройства и сервера расходятся больше чем на пять минут.';

  @override
  String get checkClockNext =>
      'Включите на устройстве автоматическую установку даты и времени.';

  @override
  String get checkDnsFailed => 'Имя сервера не ведёт ни к какому адресу.';

  @override
  String get checkDnsFailedNext =>
      'Проверьте адрес или подключитесь к сети сервера.';

  @override
  String checkExpired(String date) {
    return 'Срок действия сертификата сервера истёк $date.';
  }

  @override
  String get checkFailed => 'Не пройдено';

  @override
  String get checkMetered => 'Вы в лимитной сети, например в мобильной.';

  @override
  String get checkMeteredNext =>
      'Подключитесь к Wi-Fi перед большим резервным копированием.';

  @override
  String get checkNotPhotolib =>
      'Отвечает не Photolib, а, например, страница ошибки прокси или страница входа в Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Войдите в Wi-Fi в браузере или попросите администратора проверить прокси.';

  @override
  String get checkOtherServer =>
      'По этому адресу отвечает другой сервер Photolib.';

  @override
  String get checkPassed => 'Пройдено';

  @override
  String get checkRefused => 'По этому адресу ничего не отвечает.';

  @override
  String get checkRefusedNext =>
      'Убедитесь, что сервер работает и вы в его сети или VPN.';

  @override
  String get checkRun => 'Проверить подключение';

  @override
  String get checkRunning => 'Проверка';

  @override
  String get checkSelfSigned =>
      'Сервер использует собственный сертификат, который это устройство ещё не знает.';

  @override
  String get checkSkipped => 'Не проверялось';

  @override
  String get checkStepAuth => 'Ваш вход';

  @override
  String get checkStepClock => 'Часы вашего устройства';

  @override
  String get checkStepDns => 'Поиск адреса сервера';

  @override
  String get checkStepNetwork => 'Ваша сеть';

  @override
  String get checkStepServer => 'Photolib на сервере';

  @override
  String get checkStepTcp => 'Связь с сервером';

  @override
  String get checkStepTls => 'Защищённое соединение и сертификат';

  @override
  String get checkStepUpload => 'Большие загрузки через прокси';

  @override
  String get checkTimedOut => 'Сервер слишком долго не отвечает.';

  @override
  String get checkTimedOutNext => 'Проверьте подключение и попробуйте снова.';

  @override
  String get checkTitle => 'Проверка подключения';

  @override
  String get checkTlsFailed => 'Не удалось установить защищённое соединение.';

  @override
  String get checkTrustNext =>
      'Доверяйте ему, только если его отпечаток совпадает с отпечатком вашего сервера.';

  @override
  String get checkUntrusted =>
      'Сертификат сервера выдан центром, которому это устройство не доверяет.';

  @override
  String get checkUploadCap =>
      'Прокси на пути отклоняет большие загрузки, поэтому резервное копирование идёт медленнее, маленькими частями.';

  @override
  String get checkUploadCapNext =>
      'Попросите администратора пропускать через прокси запросы по 64 МБ.';

  @override
  String get collectionAlbums => 'Альбомы';

  @override
  String collectionHide(String name) {
    return 'Скрыть «$name»';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Переместить «$name» вниз';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Переместить «$name» вверх';
  }

  @override
  String get collectionPeople => 'Люди';

  @override
  String collectionPin(String name) {
    return 'Закрепить «$name»';
  }

  @override
  String get collectionPlaces => 'Места';

  @override
  String collectionShow(String name) {
    return 'Показать «$name»';
  }

  @override
  String get collectionTags => 'Теги';

  @override
  String collectionUnpin(String name) {
    return 'Открепить «$name»';
  }

  @override
  String get collectionsCustomise => 'Настроить';

  @override
  String get collectionsDone => 'Готово';

  @override
  String get commandPalette => 'Палитра команд';

  @override
  String get commandPaletteHint => 'Введите команду';

  @override
  String get dateFormatDefault => 'По умолчанию для языка';

  @override
  String get dateFormatDmy => 'День-месяц-год';

  @override
  String get dateFormatMdy => 'Месяц-день-год';

  @override
  String get dateFormatYmd => 'Год-месяц-день';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString на этом устройстве и в резервной копии',
      many: '$countString на этом устройстве и в резервной копии',
      few: '$countString на этом устройстве и в резервной копии',
      one: '$countString на этом устройстве и в резервной копии',
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
      other: '$countString только на этом устройстве, без резервной копии',
      many: '$countString только на этом устройстве, без резервной копии',
      few: '$countString только на этом устройстве, без резервной копии',
      one: '$countString только на этом устройстве, без резервной копии',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Если включены Фото iCloud, удалённое с этого устройства исчезнет и из iCloud, и с других ваших устройств Apple.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString только в вашей библиотеке',
      many: '$countString только в вашей библиотеке',
      few: '$countString только в вашей библиотеке',
      one: '$countString только в вашей библиотеке',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Убрать с этого устройства';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString объекта с резервной копией; библиотека их сохранит',
      many: '$countString объектов с резервной копией; библиотека их сохранит',
      few: '$countString объекта с резервной копией; библиотека их сохранит',
      one: '$countString объект с резервной копией; библиотека его сохранит',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Копии на этом устройстве попадут в его корзину: место освободится, когда она будет очищена.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить $countString объекта?',
      many: 'Удалить $countString объектов?',
      few: 'Удалить $countString объекта?',
      one: 'Удалить $countString объект?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'С этого устройства и из вашей библиотеки',
      'device': 'Только с этого устройства',
      'other': 'Из вашей библиотеки',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Нет на устройстве';

  @override
  String get deviceFolderCard => 'SD-карта';

  @override
  String get deviceFolderExclude => 'Исключить';

  @override
  String get deviceFolderExcludeThis => 'Исключить эту папку';

  @override
  String get deviceFolderExcludedNotice =>
      'Папка этого объекта исключена из библиотеки';

  @override
  String get deviceFolderForget => 'Убрать из списка';

  @override
  String get deviceFolderInternal => 'Внутренняя память';

  @override
  String get deviceFolderKeep => 'Оставить';

  @override
  String deviceFolderNew(String name, String items) {
    return 'Новая папка: $name, $items';
  }

  @override
  String get deviceFolders => 'Папки устройства';

  @override
  String get deviceFoldersAll => 'Показывать все папки, кроме исключённых';

  @override
  String get deviceFoldersChosen => 'Показывать только выбранные папки';

  @override
  String get deviceFoldersExcludedNow => 'Исключено из библиотеки';

  @override
  String get deviceFoldersSearch => 'Поиск папок';

  @override
  String get diagnosticsAdvanced => 'Показывать диагностику';

  @override
  String get diagnosticsAllLoggers => 'Все источники';

  @override
  String get diagnosticsCopied => 'Журнал скопирован';

  @override
  String get diagnosticsCopy => 'Копировать показанный журнал';

  @override
  String get diagnosticsEmpty => 'В журнале пока нет записей';

  @override
  String get diagnosticsExport => 'Экспортировать пакет диагностики';

  @override
  String get diagnosticsExported => 'Пакет диагностики сохранён';

  @override
  String get diagnosticsLevel => 'Уровень';

  @override
  String get diagnosticsLogger => 'Источник';

  @override
  String get diagnosticsTitle => 'Диагностика';

  @override
  String get download => 'Скачать';

  @override
  String get downloadCurrent => 'Текущая версия с правками';

  @override
  String get downloadFailed => 'Не удалось скачать';

  @override
  String get downloadOriginal => 'Оригинал';

  @override
  String downloadSaved(String name) {
    return 'Сохранено: $name';
  }

  @override
  String get downloadVersion => 'Какую версию?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скачиваются $countString объекта',
      many: 'Скачиваются $countString объектов',
      few: 'Скачиваются $countString объекта',
      one: 'Скачивается $countString объект',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Автоулучшение';

  @override
  String get editorCrop => 'Обрезать';

  @override
  String get editorCropOriginal => 'Оригинал';

  @override
  String get editorCropSquare => 'Квадрат';

  @override
  String get editorEdit => 'Изменить';

  @override
  String get editorFlip => 'Отразить';

  @override
  String get editorRotate => 'Повернуть';

  @override
  String get editorSaveCopy => 'Сохранить копию';

  @override
  String get editorSaveFailed => 'Не удалось сохранить копию';

  @override
  String get editorSaveVersion => 'Сохранить';

  @override
  String get editorSaved => 'Сохранено как копия';

  @override
  String get editorVersionFailed => 'Не удалось сохранить версию';

  @override
  String get editorVersionSaved => 'Сохранено как новая версия';

  @override
  String get editorVersionsUnsupported =>
      'Этот сервер пока не умеет хранить версии отредактированных фото';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отменено $countString изменения: сервер их отклонил.',
      many: 'Отменено $countString изменений: сервер их отклонил.',
      few: 'Отменено $countString изменения: сервер их отклонил.',
      one: 'Отменено $countString изменение: сервер его отклонил.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Закрыть';

  @override
  String get editsRejectedForbidden =>
      'Вы можете просматривать эти объекты, но не изменять их.';

  @override
  String get editsRejectedInvalid => 'Сервер не смог принять изменения.';

  @override
  String get editsRejectedNotFound =>
      'Объекты удалены или больше не доступны вам.';

  @override
  String get errorNotFound => 'Такой страницы нет';

  @override
  String get errorRetry => 'Повторить попытку';

  @override
  String get errorTitle => 'Что-то пошло не так';

  @override
  String faceNumber(int number) {
    return 'Лицо $number';
  }

  @override
  String get facesAgree => 'Согласен';

  @override
  String get facesAura =>
      'Описывать лица с помощью AuraFace (больший объём загрузки)';

  @override
  String get facesNotNow => 'Не сейчас';

  @override
  String get facesNoticeKeep =>
      'Найденное остаётся вместе с вашими фото, на ваших устройствах и вашем сервере. Описания никогда не показываются и не передаются, а всё удаляется, когда вы отключаете функцию или удаляете фото.';

  @override
  String get facesNoticeOptional =>
      'Это необязательно. Всё остальное в Photolib работает без этого, а отключить функцию можно в любой момент в настройках.';

  @override
  String get facesNoticeTitle => 'Находить лица на ваших фото?';

  @override
  String get facesNoticeWhat =>
      'Photolib ищет лица на ваших фото и видео и сохраняет для каждого, где оно находится, и набор чисел, который его описывает, чтобы снова находить того же человека. Такое описание может считаться биометрическими данными.';

  @override
  String get facesNoticeWhere =>
      'Это происходит на этом устройстве и, если вы вошли в аккаунт, на вашем собственном сервере. Никогда не в сервисе, который ведём мы или кто-либо другой.';

  @override
  String get facesServerFailed =>
      'Не удалось сообщить вашему серверу. Повторите попытку.';

  @override
  String get facesServerOff => 'Ваш сервер не находит лица для вас';

  @override
  String get facesServerOn => 'Ваш сервер находит лица для вас';

  @override
  String get facesServerUnavailable =>
      'Ваш сервер не предлагает распознавание лиц';

  @override
  String facesStatusDownloading(int percent) {
    return 'Загрузка моделей лиц: $percent %';
  }

  @override
  String get facesStatusMissing => 'На вашем сервере не установлены модели лиц';

  @override
  String get facesStatusNoDecoder =>
      'Поиск лиц недоступен: не найдена библиотека изображений (libvips). Переустановите Photolib или установите libvips и перезапустите приложение.';

  @override
  String get facesStatusRunning => 'Поиск лиц на этом устройстве';

  @override
  String get facesStatusUnavailable =>
      'На этом устройстве нельзя находить лица';

  @override
  String get facesStatusWaiting => 'Модели лиц загрузятся по Wi-Fi';

  @override
  String get facesSwitch => 'Находить лица на моих фото';

  @override
  String get facesSwitchOff =>
      'Выключено. Ничего о лицах не вычисляется, пока вы не согласитесь.';

  @override
  String get facesSwitchOn => 'Включено. Photolib находит лица на ваших фото.';

  @override
  String get facesTitle => 'Лица и люди';

  @override
  String get facesWithdraw => 'Удалить и остановить';

  @override
  String get facesWithdrawBody =>
      'Будут удалены все лица, описания и люди, найденные Photolib для вас, на этом устройстве и на вашем сервере. Ваши фото не изменятся.';

  @override
  String get facesWithdrawTitle => 'Перестать находить лица?';

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

    return 'Файлов не изменено: $countString';
  }

  @override
  String get folderAllow => 'Разрешить доступ к этой папке';

  @override
  String get folderDelete => 'Удалить папку';

  @override
  String folderDeleteBody(String name) {
    return 'Переместить фото и видео из папки $name в корзину?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString объекта',
      many: '$countString объектов',
      few: '$countString объекта',
      one: '$countString объект',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Новая папка';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Недоступна, $countString объекта',
      many: 'Недоступна, $countString объектов',
      few: 'Недоступна, $countString объекта',
      one: 'Недоступна, $countString объект',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Эта папка уже есть в библиотеке, вложена в одну из её папок или содержит такую папку';

  @override
  String get folderRemove => 'Убрать папку';

  @override
  String folderRemoveBody(String folder) {
    return 'Фото и видео из папки $folder будут убраны из библиотеки. Сами файлы останутся на диске без изменений.';
  }

  @override
  String get folderRemoveConfirm => 'Убрать';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сканирование, пока найдено $countString объекта',
      many: 'Сканирование, пока найдено $countString объектов',
      few: 'Сканирование, пока найдено $countString объекта',
      one: 'Сканирование, пока найден $countString объект',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Разрешить доступ';

  @override
  String get foldersHideExcluded => 'Скрыть исключённые папки';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib больше не может прочитать $countString папки.',
      many: 'Photolib больше не может прочитать $countString папок.',
      few: 'Photolib больше не может прочитать $countString папки.',
      one: 'Photolib больше не может прочитать $countString папку.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Показать исключённые папки ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Этот браузер не может использовать папку в качестве вашей библиотеки. Откройте Photolib в Chrome или Edge на компьютере либо используйте приложение для компьютера.';

  @override
  String get galleryButtons => 'Кнопки';

  @override
  String get galleryChips => 'Чипы';

  @override
  String get galleryGrid => 'Сетка';

  @override
  String get galleryMenus => 'Меню и панели';

  @override
  String get galleryShowSheet => 'Показать панель';

  @override
  String get galleryTitle => 'Компоненты';

  @override
  String hiddenCollections(int count) {
    return 'Скрытые ($count)';
  }

  @override
  String get indexingAllowMetered => 'Загружать через мобильную сеть';

  @override
  String get indexingAllowSaver => 'Также в режиме энергосбережения';

  @override
  String get indexingBattery => 'Заряд, нужный без зарядки';

  @override
  String get indexingChargingOnly => 'Только во время зарядки';

  @override
  String indexingDownloading(int percent) {
    return 'Загрузка модели поиска: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось прочитать $count фото',
      many: 'Не удалось прочитать $count фото',
      few: 'Не удалось прочитать $count фото',
      one: 'Не удалось прочитать $count фото',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Это устройство индексирует только новые фото';

  @override
  String get indexingMissing => 'Ваш сервер не установил модель поиска';

  @override
  String get indexingModels => 'Поиск на этом устройстве';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Загружает модель поиска ($megabytesString МБ) с $host';
  }

  @override
  String get indexingNoDecoder =>
      'Поиск и распознавание текста недоступны: не найдена библиотека изображений (libvips). Переустановите Photolib или установите libvips и перезапустите приложение.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Пауза, пока заряд батареи ниже $percent%';
  }

  @override
  String get indexingPausedCharger => 'Пауза до начала зарядки';

  @override
  String get indexingPausedHeat => 'Пауза, пока устройство горячее';

  @override
  String get indexingPausedSaver => 'Пауза, пока включена экономия заряда';

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

    return 'Проиндексировано фото: $doneString из $totalString';
  }

  @override
  String get indexingText => 'Распознавать текст на фото';

  @override
  String indexingTextDownloading(int percent) {
    return 'Загрузка моделей текста: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Загружает модели текста ($megabytesString МБ) с $host; находит слова на ваших фото';
  }

  @override
  String get indexingTextMissing =>
      'На вашем сервере не установлены модели текста';

  @override
  String get indexingTextPlatform =>
      'Использует распознавание текста самого телефона; ничего загружать не нужно. Читает новые фото';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Фото с распознанным текстом: $doneString из $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Распознавание текста здесь недоступно';

  @override
  String get indexingTextWaiting => 'Модели текста загружаются по Wi-Fi';

  @override
  String get indexingUnavailable => 'Поиск на этом устройстве здесь недоступен';

  @override
  String get indexingWaiting => 'Модель поиска загрузится по Wi-Fi';

  @override
  String get infoAddName => 'Добавить имя';

  @override
  String get infoAddTag => 'Добавить тег';

  @override
  String get infoAlbums => 'Альбомы';

  @override
  String get infoAllMetadata => 'Все метаданные';

  @override
  String get infoAuto => 'Авто';

  @override
  String get infoBackedUp => 'Резервная копия есть';

  @override
  String get infoCamera => 'Камера';

  @override
  String get infoChangeAdjust => 'Цвета скорректированы';

  @override
  String get infoChangeCrop => 'Обрезано';

  @override
  String get infoChangeFlip => 'Отражено';

  @override
  String get infoChangeInpaint => 'Область заполнена';

  @override
  String get infoChangeLocal => 'Область скорректирована';

  @override
  String get infoChangeLut => 'Применён цветовой стиль';

  @override
  String get infoChangeOther => 'Отредактировано';

  @override
  String get infoChangeTurn => 'Повёрнуто';

  @override
  String get infoCompare => 'Сравнить с оригиналом';

  @override
  String infoConfidence(String percent) {
    return 'Достоверность: $percent';
  }

  @override
  String get infoCopyPath => 'Копировать путь';

  @override
  String get infoCurrent => 'Текущая';

  @override
  String get infoDescription => 'Добавить описание';

  @override
  String get infoEditDate => 'Изменить дату';

  @override
  String infoEditNumber(int number) {
    return 'Правка $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Изменённая копия $name';
  }

  @override
  String get infoFaces => 'Лица';

  @override
  String get infoFile => 'Файл';

  @override
  String get infoFromFileName => 'из имени файла';

  @override
  String get infoHistory => 'История изменений';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count объекта',
      many: '$count объектов',
      few: '$count объекта',
      one: '$count объект',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Место';

  @override
  String get infoMap => 'Карта места съёмки';

  @override
  String get infoMapAgree =>
      'Фрагменты карты загружаются из интернета и показывают, какую местность вы смотрите';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels Мп';
  }

  @override
  String infoNewTag(String path) {
    return 'Новый тег: $path';
  }

  @override
  String get infoNoAlbum => 'Не в альбомах';

  @override
  String get infoOnDevice => 'На этом устройстве';

  @override
  String get infoOriginal => 'Оригинал';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString пикс.';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Убрать из «$album»';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Убрать «$tag»';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Убрано из «$album»';
  }

  @override
  String get infoRevert => 'Вернуть';

  @override
  String get infoSaveCopy => 'Сохранить как копию';

  @override
  String get infoShared => 'общий';

  @override
  String get infoShowFaces => 'Показать лица на фото';

  @override
  String get infoShowMap => 'Показать карту';

  @override
  String get infoTags => 'Теги';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count версии',
      many: '$count версий',
      few: '$count версии',
      one: '$count версия',
    );
    return '$_temp0 · последняя $time';
  }

  @override
  String get infoWhy => 'Почему эта дата?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Прочитана из файла, из поля $tag',
      'name': 'Прочитана из имени файла',
      'folder': 'Прочитана из имени папки',
      'host': 'Указана сервисом, из которого пришёл файл',
      'unknown': 'В файле нет ничего, что указывало бы дату, поэтому используется дата его последнего изменения',
      'other': 'Файл ещё не прочитан, поэтому используется дата, которую сообщает устройство',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Список',
      'other': 'Сетка',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Имя',
      'taken': 'Дата съёмки',
      'modified': 'Дата изменения',
      'size': 'Размер',
      'random': 'Случайно',
      'extension': 'Тип',
      'custom': 'Порядок альбома',
      'other': 'Дата съёмки',
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
  String get languageDevice => 'Язык устройства';

  @override
  String get languageName => 'Русский';

  @override
  String get libraryAddFolder => 'Добавить папку';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Нет резервной копии',
      'backed_up': 'Есть резервная копия',
      'cloud_only': 'Только в облаке',
      'other': 'Все',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Резервные копии есть у всего',
      'backed_up': 'Резервных копий пока нет',
      'cloud_only': 'Нет ничего только на сервере',
      'other': 'Здесь ничего нет',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Значки резервного копирования';

  @override
  String get libraryEmpty => 'Здесь появятся ваши фото';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Группировать по неделям',
      'month': 'Группировать по месяцам',
      'other': 'Группировать по дням',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'Снова скрыть скрытые и архивные объекты';

  @override
  String get libraryNoKeyring =>
      'Photolib хранит ключ к вашей библиотеке в системной связке ключей, которая не запущена или заблокирована. Запустите или разблокируйте связку ключей, например GNOME Keyring или KWallet, и повторите попытку.';

  @override
  String get libraryRevealExcluded => 'Показать исключённые папки на 5 минут';

  @override
  String get libraryShowVeiled =>
      'Показать скрытые и архивные объекты на 5 минут';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Недавно добавленные',
      'other': 'Дата съёмки',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib не удалось открыть библиотеку, хранящуюся на этом устройстве';

  @override
  String get libraryViewOptions => 'Параметры просмотра';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Подготовка миниатюр: $doneString из $totalString';
  }

  @override
  String get libraryZoomIn => 'Увеличить миниатюры';

  @override
  String get libraryZoomOut => 'Уменьшить миниатюры';

  @override
  String get mapAddTrack => 'Добавить трек GPX';

  @override
  String get mapArea => 'Область карты';

  @override
  String get mapAttribution => '© участники OpenStreetMap';

  @override
  String get mapClearLasso => 'Снять выделение';

  @override
  String get mapEmpty => 'Пока нет фото с местом съёмки';

  @override
  String get mapHeat => 'Тепловая карта';

  @override
  String get mapLasso => 'Выделить, обведя фотографии';

  @override
  String get mapLoading => 'Фотографии размещаются на карте';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Фото: $countString';
  }

  @override
  String get mapSearchHere => 'Искать в этой области';

  @override
  String get mapSplit => 'Показать фото под картой';

  @override
  String get mapTilesAgree =>
      'Фон карты загружается с сервера OpenStreetMap (tile.openstreetmap.org), который видит, какую область вы смотрите';

  @override
  String get mapTilesShow => 'Показать фон';

  @override
  String get mapTime => 'Период';

  @override
  String get mapTitle => 'Карта';

  @override
  String get mapTrackBad => 'В этом файле нет треков GPX';

  @override
  String get mapTrips => 'Поездки';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Избранное',
      'hidden': 'Скрыто',
      'archived': 'В архиве',
      'offline': 'Хранится на этом устройстве',
      'offline': 'Хранится на этом устройстве',
      'offline': 'Хранится на этом устройстве',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Разрешить доступ';

  @override
  String get mediaAccessNone =>
      'Приложению Photolib нужен доступ к вашим фото и видео, чтобы их показывать.';

  @override
  String get mediaAccessPartial =>
      'Приложение Photolib видит только выбранные вами фото и видео. Галерее нужен доступ ко всем.';

  @override
  String get mediaAccessSelect => 'Выбрать ещё фото';

  @override
  String get nameLabel => 'Название';

  @override
  String get nextAddRoot =>
      'Добавьте папку в external_roots в конфигурации сервера и перезапустите сервер.';

  @override
  String get nextAskAdmin => 'Обратитесь к администратору вашего сервера.';

  @override
  String get nextAskOwner =>
      'Попросите владельца библиотеки разрешить вам добавлять фото.';

  @override
  String get nextCheckConnection =>
      'Проверьте подключение, чтобы узнать причину.';

  @override
  String get nextCheckEntry => 'Проверьте введённые данные и попробуйте снова.';

  @override
  String get nextConfirm =>
      'Проверьте, сколько объектов это затронет, и подтвердите.';

  @override
  String get nextDeleteWebhook =>
      'Удалите веб-хук, который больше не нужен, и попробуйте снова.';

  @override
  String get nextEditConfig =>
      'Измените это в конфигурации сервера и перезапустите сервер.';

  @override
  String get nextFreeSpace =>
      'Освободите место или попросите у администратора больше.';

  @override
  String get nextNewLink => 'Попросите у администратора новую.';

  @override
  String get nextNewestToken => 'Скопируйте самый новый из журнала photolibd.';

  @override
  String get nextOtherAdmin =>
      'Сначала сделайте администратором другую учётную запись.';

  @override
  String get nextOtherFolder => 'Выберите отдельную папку.';

  @override
  String get nextRefresh => 'Обновите и попробуйте снова.';

  @override
  String get nextReport =>
      'Попробуйте снова. Если это повторится, скопируйте подробности ниже для администратора.';

  @override
  String get nextSetUpPrivate =>
      'Завершите настройку личных библиотек в разделе «Настройки» и попробуйте снова.';

  @override
  String get nextSignIn => 'Войдите снова.';

  @override
  String get nextSignInAccount =>
      'Войдите со своей учётной записью и попробуйте снова.';

  @override
  String get nextSignInInstead => 'Вместо этого войдите.';

  @override
  String get nextTryAgain => 'Попробуйте снова.';

  @override
  String get nextUpdateAndAgree =>
      'Обновите приложение и снова согласитесь с уведомлением.';

  @override
  String get nextUseAnother => 'Выберите другое.';

  @override
  String get nextUseHttps =>
      'Используйте адрес https:// сервера или подключитесь из сети сервера.';

  @override
  String get nextWait => 'Подождите минуту и попробуйте снова.';

  @override
  String get offlineKeep => 'Хранить офлайн';

  @override
  String offlineKeepHere(String size) {
    return 'Хранить на этом устройстве ($size)';
  }

  @override
  String get offlineKeptHere => 'Хранится на этом устройстве';

  @override
  String get offlineStopKeeping => 'Не хранить офлайн';

  @override
  String get otherFiles => 'Другие файлы';

  @override
  String get passphraseCreate =>
      'На этом компьютере не работает связка ключей (Secret Service), которая хранила бы ключи Photolib. Задайте парольную фразу не короче 10 символов для их защиты: Photolib будет спрашивать её при каждом запуске.';

  @override
  String get passphraseLabel => 'Парольная фраза';

  @override
  String get passphraseMismatch => 'Парольные фразы не совпадают.';

  @override
  String get passphraseRepeat => 'Повторите парольную фразу';

  @override
  String get passphraseTooShort => 'Используйте не менее 10 символов.';

  @override
  String get passphraseUnlock =>
      'Введите парольную фразу, которая защищает ключи Photolib на этом компьютере.';

  @override
  String get passphraseWrong => 'Неверная парольная фраза. Попробуйте ещё раз.';

  @override
  String photoPosition(int index, int count) {
    return 'Фото $index из $count';
  }

  @override
  String get privacyCheckKit => 'Проверить набор восстановления';

  @override
  String get privacyDrillDue =>
      'Пора провести учебное восстановление: проверьте, что набор восстановления всё ещё открывает ваши личные библиотеки.';

  @override
  String get privacyHonest =>
      'Личные библиотеки шифруются на ваших устройствах, и никто другой не может их открыть: ни сервер, ни его администратор, ни разработчики Photolib. Если вы потеряете и пароль, и набор восстановления, ваши фото будут потеряны навсегда, и никто не сможет вернуть их вам.';

  @override
  String get privacyKitBody =>
      'Запишите эти 24 слова на бумаге по порядку и храните их в надёжном месте. Они открывают ваши личные библиотеки, если вы забудете пароль, — любому, у кого они есть.';

  @override
  String get privacyKitDone => 'Ваш набор восстановления работает.';

  @override
  String get privacyKitOther => 'Это не ваш текущий набор восстановления.';

  @override
  String get privacyKitTitle => 'Ваш набор восстановления';

  @override
  String get privacyKitUnverified => 'Набор восстановления ещё не подтверждён';

  @override
  String privacyKitVerified(String date) {
    return 'Набор восстановления подтверждён $date';
  }

  @override
  String get privacyKitWritten => 'Слова записаны';

  @override
  String get privacyNotReady =>
      'Личные загрузки остаются выключенными, пока у вас нет двух способов разблокировки и подтверждённого набора восстановления.';

  @override
  String get privacyPasswordHelp =>
      'Введите пароль своей учётной записи: он станет одним из способов разблокировать личные библиотеки.';

  @override
  String get privacyPhrase => 'Фраза восстановления';

  @override
  String get privacyPhraseHelp => '24 слова вашего набора восстановления';

  @override
  String get privacyPhraseInvalid =>
      'Это не фраза восстановления. Проверьте каждое слово.';

  @override
  String get privacyReady => 'Личные загрузки включены.';

  @override
  String get privacyRecoveryKit => 'Набор восстановления';

  @override
  String get privacySetUp => 'Настроить';

  @override
  String get privacyShowWords => 'Показать слова ещё раз';

  @override
  String get privacyTitle => 'Личные библиотеки';

  @override
  String privacyUnknownWord(int number) {
    return 'Слово $number не является словом набора восстановления.';
  }

  @override
  String get privacyVerify => 'Подтвердить';

  @override
  String get privacyVerifyBody =>
      'Введите эти слова из набора восстановления, чтобы показать, что вы его сохранили.';

  @override
  String get privacyWays => 'Способы разблокировки';

  @override
  String privacyWord(int number) {
    return 'Слово $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Эти слова не совпадают с вашим набором восстановления. Проверьте свои записи.';

  @override
  String get privacyWrongPassword => 'Это не пароль вашей учётной записи.';

  @override
  String get problemAdminOnly => 'Это может сделать только администратор.';

  @override
  String get problemBusy => 'Сервер занят или перезапускается.';

  @override
  String get problemChanged => 'Это успело измениться.';

  @override
  String get problemConfirm =>
      'Это скроет или удалит больше объектов, чем сервер делает без подтверждения';

  @override
  String get problemContribute =>
      'Вы не можете добавлять фото в эту библиотеку.';

  @override
  String get problemCopy => 'Скопировать подробности';

  @override
  String get problemDetails => 'Подробности';

  @override
  String get problemDiskLow =>
      'Диск сервера почти заполнен, поэтому загрузки приостановлены.';

  @override
  String get problemEmailTaken =>
      'Этот адрес эл. почты уже у другой учётной записи.';

  @override
  String get problemExists => 'Это уже существует.';

  @override
  String get problemFaceNotice =>
      'Ваш сервер требует более новую версию уведомления о лицах, чем показывает это приложение.';

  @override
  String get problemGone => 'Этого больше нет на сервере.';

  @override
  String get problemHandleTaken =>
      'Это имя пользователя уже у другой учётной записи.';

  @override
  String get problemInterrupted => 'Загрузка прервалась.';

  @override
  String get problemInvalid => 'Недопустимое значение';

  @override
  String get problemLastAdmin => 'Серверу нужен хотя бы один администратор.';

  @override
  String get problemLinkInvalid =>
      'Срок действия ссылки истёк, или она уже использована.';

  @override
  String get problemLoginFailed =>
      'Неверная эл. почта, имя пользователя или пароль.';

  @override
  String get problemMaintenanceKey =>
      'Резервное копирование, проверку целостности и окончательное удаление можно приостановить, только войдя в систему, а не с помощью ключа API';

  @override
  String get problemNotAllowed => 'Вашей учётной записи это не разрешено.';

  @override
  String get problemNotExternal =>
      'Сканировать можно только библиотеки из собственных папок сервера.';

  @override
  String get problemOidcClaim =>
      'Ваш сервис входа не сообщил, кто вы, в виде, который принимает этот сервер.';

  @override
  String get problemOidcDown => 'Ваш сервис входа не отвечает серверу.';

  @override
  String get problemOidcFailed => 'Ваш сервис входа отклонил вход.';

  @override
  String get problemOidcNotAllowed =>
      'Вашей учётной записи нельзя входить этим способом.';

  @override
  String get problemOidcTaken =>
      'Этот вход уже привязан к другой учётной записи Photolib.';

  @override
  String get problemOidcUnknown =>
      'Этот сервер больше не предлагает такой способ входа.';

  @override
  String get problemPasskeysOff =>
      'Ключи доступа работают, только когда у сервера есть публичный адрес.';

  @override
  String get problemPinned =>
      'Это задано в файле конфигурации, и изменить это здесь нельзя.';

  @override
  String get problemPolicyOff => 'Это выключено на этом сервере.';

  @override
  String get problemQuota => 'Ваше хранилище на сервере заполнено.';

  @override
  String get problemRestoreKey =>
      'Восстановить резервную копию можно, только войдя в систему, а не с помощью ключа API.';

  @override
  String get problemRootDiffers => 'В этой папке нет файлов этой библиотеки';

  @override
  String get problemRootNotAllowed =>
      'Эта папка не входит в external_roots конфигурации сервера';

  @override
  String get problemRootOverlaps =>
      'Эта папка содержит другую библиотеку или данные самого сервера либо находится внутри них';

  @override
  String get problemScanning => 'Эта библиотека уже сканируется';

  @override
  String get problemSecondFactor =>
      'Для этого аккаунта нужен второй фактор, например код из приложения-аутентификатора или ключ доступа, а эта версия Photolib пока не умеет его передавать.';

  @override
  String get problemSetupDone => 'У этого сервера уже есть администратор.';

  @override
  String get problemSetupExpired => 'Это заняло слишком много времени.';

  @override
  String get problemSetupToken => 'Этот токен настройки неверен.';

  @override
  String get problemSignedOut => 'Вы вышли из системы на сервере.';

  @override
  String get problemStepUp =>
      'Для этого изменения сначала нужен пароль или код.';

  @override
  String get problemStorage => 'Сервер не может связаться со своим хранилищем.';

  @override
  String get problemTooMany => 'Слишком много попыток за короткое время.';

  @override
  String get problemUnexpected => 'Произошло что-то непредвиденное.';

  @override
  String get problemUnreachable => 'Сервер не отвечает.';

  @override
  String get problemUploadDamaged => 'Файл изменился или повредился по пути.';

  @override
  String get problemUploadExpired =>
      'На сервере больше нет этой загрузки: незавершённые загрузки удаляются через сутки.';

  @override
  String get problemWebhookLimit =>
      'У вашей учётной записи уже столько веб-хуков, сколько разрешено.';

  @override
  String get problemWebhooksOff => 'Веб-хуки на этом сервере выключены.';

  @override
  String get recoveryCode => 'Код восстановления';

  @override
  String get recoveryCodeAbout =>
      'Открывает хранилище Photolib на этом устройстве, если хранилище ключей потеряет его ключ';

  @override
  String get recoveryCodeEnter => 'Ввести код восстановления';

  @override
  String get recoveryCreate => 'Создать код восстановления';

  @override
  String get recoveryLater => 'Позже';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString изменения есть только на этом устройстве. Код восстановления вернёт их, если хранилище ключей потеряет ключ Photolib.',
      many:
          '$countString изменений есть только на этом устройстве. Код восстановления вернёт их, если хранилище ключей потеряет ключ Photolib.',
      few:
          '$countString изменения есть только на этом устройстве. Код восстановления вернёт их, если хранилище ключей потеряет ключ Photolib.',
      one:
          '$countString изменение есть только на этом устройстве. Код восстановления вернёт его, если хранилище ключей потеряет ключ Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Запишите эти 24 слова и храните их в надёжном месте: они открывают хранилище Photolib на этом устройстве без ключа из хранилища ключей. Они заменяют любой прежний код.';

  @override
  String get recoveryUnlock => 'Разблокировать';

  @override
  String get recoveryWrong => 'Это не код восстановления этого хранилища';

  @override
  String get renameFind => 'Найти';

  @override
  String get renamePattern => 'Новое имя';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Слишком длинное: имя занимает не более 255 байт',
      'invalid': 'Недопустимое имя файла',
      'duplicate': 'Дано и другому файлу',
      'exists': 'Это имя уже у другого файла в папке',
      'other': 'Нельзя переименовать',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Заменить на';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Файлов переименовано: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Показать в Finder',
      'windows': 'Показать в Проводнике',
      'other': 'Показать в папке',
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
      other: '$countString объекта',
      many: '$countString объектов',
      few: '$countString объекта',
      one: '$countString объект',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Даты';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Поиск по библиотеке';

  @override
  String get searchFavourites => 'Избранное';

  @override
  String get searchFolder => 'Папка';

  @override
  String get searchHint => 'Имя файла или папки';

  @override
  String get searchMotionPhotos => 'Фото с движением';

  @override
  String get searchNothing => 'Ничего не найдено';

  @override
  String get searchPanoramas => 'Панорамы';

  @override
  String get searchPhotos => 'Фото';

  @override
  String get searchScreenshots => 'Скриншоты';

  @override
  String get searchVideo => 'Видео';

  @override
  String get searchVideos => 'Видео';

  @override
  String get securityAddPasskey => 'Добавить ключ доступа';

  @override
  String get securityCode => 'Код';

  @override
  String get securityCodesHelp =>
      'Сохраните эти коды в надёжном месте. Каждый срабатывает один раз вместо второго фактора, и показываются они только сейчас.';

  @override
  String securityCodesLeft(int count) {
    return 'Не использовано: $count';
  }

  @override
  String get securityNewCodes => 'Новые коды';

  @override
  String get securityPasskeyNotAdded => 'Ключ доступа не добавлен.';

  @override
  String get securityRecoveryCodes => 'Коды восстановления';

  @override
  String get securityRemovePasskey => 'Удалить ключ доступа';

  @override
  String get securitySetUp => 'Настроить';

  @override
  String get securityStepUpBody =>
      'Чтобы изменить вторые факторы, введите пароль, код из приложения-аутентификатора или код восстановления.';

  @override
  String get securityStepUpTitle => 'Подтвердите, что это вы';

  @override
  String get securityTitle => 'Вторые факторы';

  @override
  String get securityTotp => 'Приложение-аутентификатор';

  @override
  String get securityTotpHelp =>
      'Добавьте этот ключ в приложение-аутентификатор, затем введите код, который оно покажет.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Включено',
      'other': 'Выключено',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Выключить';

  @override
  String get securityWrongCode => 'Неверный код.';

  @override
  String get securityWrongProof => 'Неверный пароль или код.';

  @override
  String get selectAll => 'Выбрать всё';

  @override
  String get selectionClear => 'Отменить выбор';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $countString объекта',
      many: 'Выбрано $countString объектов',
      few: 'Выбрано $countString объекта',
      one: 'Выбран $countString объект',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Показать выбранные';

  @override
  String get serverAccount => 'Эл. почта или имя пользователя';

  @override
  String get serverAdd => 'Добавить сервер';

  @override
  String get serverAddressInvalid => 'Введите адреса вида photos.example.org';

  @override
  String get serverAddresses => 'Адреса';

  @override
  String get serverAddressesHelp =>
      'По одному в строке: сервер в вашей сети, в интернете или через VPN. Приложение использует самый быстрый из отвечающих. Или вставьте полученную ссылку для задания пароля.';

  @override
  String get serverCa => 'Сертификат частного ЦС (PEM)';

  @override
  String get serverCaChoose => 'Выбрать файл сертификата';

  @override
  String serverCertificateBody(String host) {
    return '$host предъявляет сертификат, которому это устройство не доверяет. Доверяйте ему, только если этот отпечаток SHA-256 совпадает с отпечатком вашего сервера:';
  }

  @override
  String get serverCertificateTitle => 'Доверять этому сертификату?';

  @override
  String get serverConfirm => 'Подтвердить';

  @override
  String get serverConnect => 'Подключиться';

  @override
  String get serverCreateAdmin => 'Создать администратора';

  @override
  String get serverEnded => 'Сервер завершил этот сеанс. Войдите снова.';

  @override
  String get serverHandleHelp =>
      'Строчные буквы, цифры, точки, дефисы и подчёркивания; оно никогда не меняется.';

  @override
  String get serverHeaders => 'Свои заголовки';

  @override
  String get serverHeadersHelp =>
      'По одному в строке, в виде Name: value; отправляются только по HTTPS';

  @override
  String get serverHeadersInvalid =>
      'Запишите каждый заголовок в виде Name: value';

  @override
  String get serverIdentity => 'Сертификат клиента (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Выбрать сертификат клиента';

  @override
  String get serverIdentityInvalid =>
      'Это не сертификат PKCS#12, или его пароль неверен.';

  @override
  String get serverIdentityPassword => 'Пароль сертификата клиента';

  @override
  String get serverLoading => 'Чтение сервера, сохранённого на этом устройстве';

  @override
  String get serverNearby => 'Серверы в этой сети';

  @override
  String get serverNeedsHttps =>
      'Этому серверу нужен адрес HTTPS: за пределами локальной сети Photolib не входит по обычному HTTP.';

  @override
  String get serverNoSignIn =>
      'Этот сервер не предлагает способов входа, которые поддерживает эта версия Photolib.';

  @override
  String get serverOffline => 'Сервер не отвечает. Вы остаётесь в системе.';

  @override
  String get serverPasskeyFailed =>
      'Ключ доступа не использован. Попробуйте ещё раз или введите код.';

  @override
  String get serverPasskeyRequired =>
      'Этот сервер требует ключ доступа, который эта версия Photolib пока не поддерживает.';

  @override
  String get serverPassword => 'Пароль';

  @override
  String get serverPasswordAgain => 'Повторите пароль';

  @override
  String get serverPasswordSetupInvalid =>
      'Этот токен для задания пароля неверен, уже использован или истёк. Попросите новый.';

  @override
  String get serverPasswordSetupToken => 'Токен для задания пароля';

  @override
  String get serverPasswordSetupTokenHelp =>
      'От администратора или из вывода photolibd admin password-setup на сервере.';

  @override
  String get serverPasswordsDiffer => 'Пароли не совпадают.';

  @override
  String get serverPrivateLibrariesBody =>
      'Новый пароль их не открывает. Откройте их снова с помощью набора восстановления, ключа доступа или устройства, на котором вы ещё вошли.';

  @override
  String get serverPrivateLibrariesGo => 'Задать пароль';

  @override
  String get serverPrivateLibrariesTitle =>
      'Ваши личные библиотеки остаются закрытыми';

  @override
  String get serverProxy => 'HTTP-прокси в виде host:port';

  @override
  String get serverProxyInvalid => 'Введите прокси в виде host:port';

  @override
  String get serverRecoveryCode => 'Код восстановления';

  @override
  String get serverRemove => 'Удалить этот сервер';

  @override
  String get serverRequired => 'Обязательное поле';

  @override
  String get serverSecondFactor =>
      'Второй фактор этого аккаунта — ключ доступа, который эта версия Photolib пока не поддерживает.';

  @override
  String get serverSecondFactorCode =>
      'Для этого аккаунта также нужен код из приложения-аутентификатора или код восстановления.';

  @override
  String get serverSecondFactorTitle => 'Подтвердите, что это вы';

  @override
  String get serverSecondFactorWrong =>
      'Не получилось. После пяти попыток войдите заново.';

  @override
  String get serverSetPassword => 'Задать пароль';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Для $handle на $server';
  }

  @override
  String get serverSetPasswordOpen => 'Задать пароль';

  @override
  String get serverSetPasswordTitle => 'Задайте пароль';

  @override
  String get serverSetUp => 'Настроить новый сервер';

  @override
  String get serverSetupLinkElsewhere =>
      'Чтобы воспользоваться этой ссылкой, сначала выйдите из этого сервера или удалите его, если ссылка для другого.';

  @override
  String get serverSetupTitle => 'Настройка сервера';

  @override
  String get serverSetupToken => 'Токен настройки';

  @override
  String get serverSetupTokenHelp =>
      'photolibd выводит его в журнал, пока на сервере нет администратора; при каждом запуске выводится новый.';

  @override
  String get serverSignIn => 'Войти';

  @override
  String get serverSignOut => 'Выйти';

  @override
  String serverSignedInAs(String account) {
    return 'Вы вошли как $account';
  }

  @override
  String get serverSignedOut => 'Вы вышли';

  @override
  String get serverSwitch => 'Сменить аккаунт';

  @override
  String get serverTotpCode => 'Код из приложения-аутентификатора';

  @override
  String get serverTrust => 'Доверять';

  @override
  String get serverUnreadable =>
      'Не удаётся прочитать сервер, сохранённый на этом устройстве';

  @override
  String get serverUsePasskey => 'Использовать ключ доступа';

  @override
  String get serverUseRecoveryCode => 'Использовать код восстановления';

  @override
  String get settingsBackground => 'Фон прозрачных изображений';

  @override
  String get settingsDateFormat => 'Формат даты';

  @override
  String get settingsDefaultTab => 'Папки и альбомы открываются на вкладке';

  @override
  String get settingsFolders => 'Папки';

  @override
  String get settingsIndexing => 'Индексация на этом устройстве';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLibrary => 'Библиотека';

  @override
  String get settingsServer => 'Сервер';

  @override
  String get settingsStart => 'Начальный экран';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps':
          'Касание левого или правого края — предыдущий или следующий элемент',
      'oneFingerZoom':
          'Двойное касание и перетаскивание — масштаб одним пальцем',
      'swipes': 'Проведите вверх или вниз по левой стороне видео для яркости, по правой — для громкости',
      'maxBrightness': 'Максимальная яркость при просмотре',
      'autoRotate': 'Поворачивать по ориентации каждого фото или видео',
      'mixAudio':
          'Воспроизводить видео поверх другого звука, не приостанавливая его',
      'autoplay': 'Воспроизводить видео при открытии',
      'loop': 'Повторять видео',
      'autoNext': 'Переходить к следующему элементу по окончании видео',
      'resume': 'Продолжать видео с места остановки',
      'other': 'Воспроизводить анимированные изображения в сетке',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Как долго Photolib хранит элементы в корзине';

  @override
  String get settingsViewerBar => 'Кнопки на панели просмотра';

  @override
  String get settingsViewing => 'Просмотр';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString объекта, которыми поделились с Photolib, ждут разрешения на добавление в вашу медиатеку «Фото». Несохранённые объекты удаляются через 7 дней.',
      many:
          '$countString объектов, которыми поделились с Photolib, ждут разрешения на добавление в вашу медиатеку «Фото». Несохранённые объекты удаляются через 7 дней.',
      few:
          '$countString объекта, которыми поделились с Photolib, ждут разрешения на добавление в вашу медиатеку «Фото». Несохранённые объекты удаляются через 7 дней.',
      one:
          '$countString объект, которым поделились с Photolib, ждёт разрешения на добавление в вашу медиатеку «Фото». Несохранённые объекты удаляются через 7 дней.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Слишком большой объём, чтобы поделиться за раз: выберите меньше элементов';

  @override
  String shareTooMany(int count) {
    return 'Слишком много, чтобы поделиться за раз: выберите не более $count';
  }

  @override
  String get shortcutsTitle => 'Быстрые клавиши';

  @override
  String get slideshow => 'Слайд-шоу';

  @override
  String get slideshowLoop => 'Повтор';

  @override
  String get slideshowOptions => 'Параметры слайд-шоу';

  @override
  String get slideshowSeconds => 'Секунд на элемент';

  @override
  String get slideshowShuffle => 'Случайный порядок';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'По убыванию',
      'other': 'По возрастанию',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Это устройство';

  @override
  String sourceHide(String name) {
    return 'Скрыть $name';
  }

  @override
  String get sourceHideOthers => 'Скрыть всё остальное здесь';

  @override
  String get sourceLost => 'Нет доступа';

  @override
  String get sourcePartly => 'Показан частично';

  @override
  String sourceShow(String name) {
    return 'Показать $name';
  }

  @override
  String get sourceShowEverything => 'Показывать всё здесь';

  @override
  String get sourceShowOnly => 'Показывать только это';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Хронология',
      'folders': 'Папки и альбомы',
      'favourites': 'Избранное',
      'other': 'Хронология',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Хранить человека офлайн';

  @override
  String get storageBudget => 'Лимит хранилища';

  @override
  String get storageClear => 'Удалить офлайн-копии';

  @override
  String get storageClearAction => 'Удалить';

  @override
  String storageClearBody(String size) {
    return 'Будет удалено $size, хранящиеся на этом устройстве, и альбомы, поиски и фото больше не будут храниться офлайн. Ваша библиотека на сервере не затрагивается.';
  }

  @override
  String get storageKeepLibrary => 'Хранить всю библиотеку';

  @override
  String get storageKeepOriginals => 'Хранить и оригиналы';

  @override
  String get storageNoPeople => 'Пока нет людей с именами.';

  @override
  String get storageNoPins =>
      'Ничего не закреплено. Закрепите альбом, поиск или фото, чтобы хранить их офлайн.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Альбом',
      'search': 'Поиск',
      'person': 'Человек',
      'library': 'Вся библиотека',
      'asset': 'Фото',
      'other': 'Закреплено',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Не помещается в лимит: нужно ещё $size';
  }

  @override
  String get storagePinNothing =>
      'Нечего загружать: фото уже на этом устройстве';

  @override
  String get storagePinPaused => 'Ожидание: этот режим ничего не хранит офлайн';

  @override
  String get storagePinPlanning => 'Определяем, что хранить…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Загрузка: $haveString из $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Доступно офлайн ($size)';
  }

  @override
  String get storagePinWaiting => 'Загрузится, когда появится сеть';

  @override
  String get storagePins => 'Хранится офлайн';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Только каталог',
      'spaceSaver': 'Экономия места',
      'travel': 'Выбранные альбомы офлайн',
      'everything': 'Всё',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Ничего не хранит; фото загружаются с вашего сервера при открытии.',
      'spaceSaver':
          'Хранит превью всей библиотеки, сначала новые, в пределах лимита.',
      'travel': 'Хранит только закреплённое: альбомы, поиски и фото.',
      'everything':
          'Хранит оригиналы всей библиотеки, сначала новые, в пределах лимита.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Что хранит это устройство';

  @override
  String get storageSubtitle => 'Офлайн-копии и лимит хранилища';

  @override
  String get storageTitle => 'Хранилище';

  @override
  String storageUsed(String used, String budget) {
    return 'Занято $used из $budget';
  }

  @override
  String get storageWebNote =>
      'Браузер хранит только превью и стирает их при выходе из аккаунта.';

  @override
  String get storeNoKeyring =>
      'Photolib хранит ключ своего локального хранилища в системной связке ключей, которая не ответила. Установите и разблокируйте gnome-keyring, KWallet или KeePassXC с включённой службой Secret Service и повторите попытку.';

  @override
  String get storeNoKeystore =>
      'Photolib не удалось связаться с хранилищем ключей этого устройства, где лежит ключ его локального хранилища.';

  @override
  String get storeRebuilt =>
      'В хранилище ключей этого устройства больше не было ключа локального хранилища Photolib, поэтому хранилище создано заново. Его настройки и то, что было только на этом устройстве, потеряны; медиатеки синхронизируются снова, а миниатюры вернутся.';

  @override
  String get storeRecoveryNeeded =>
      'В хранилище ключей этого устройства больше нет ключа локального хранилища Photolib. Введите код восстановления или сбросьте хранилище, потеряв то, что есть только на этом устройстве.';

  @override
  String get storeReset => 'Сбросить хранилище';

  @override
  String get storeResetBody =>
      'То, что есть только на этом устройстве, будет потеряно; медиатеки синхронизируются снова, а миниатюры вернутся.';

  @override
  String get storeUnavailable =>
      'Хранилище на этом устройстве недоступно: настройки и коллекции не сохраняются';

  @override
  String get tabCollections => 'Коллекции';

  @override
  String get tabLibrary => 'Библиотека';

  @override
  String get tabSearch => 'Поиск';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get timelineBenchmark => 'Тест производительности ленты';

  @override
  String get timelineBenchmarkCopy => 'Скопировать результаты';

  @override
  String get timelineCannotPlay => 'Не воспроизводится в этом браузере';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position из $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position из $count, без предпросмотра';
  }

  @override
  String get timelineExcluded => 'В исключённой папке';

  @override
  String get timelineScrubber => 'Прокрутка по датам';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Дата неизвестна';

  @override
  String timelineWeek(String date) {
    return 'Неделя с $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Добавить «$action» на панель';
  }

  @override
  String toolbarDown(String action) {
    return 'Переместить «$action» ниже';
  }

  @override
  String get toolbarInBar => 'На панели';

  @override
  String get toolbarInMenu => 'В меню ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Убрать «$action» с панели';
  }

  @override
  String get toolbarReset => 'Сбросить по умолчанию';

  @override
  String toolbarUp(String action) {
    return 'Переместить «$action» выше';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Переместить сюда',
      'other': 'Копировать сюда',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Файл или папка с таким именем уже есть',
      'changed': 'Копия не совпала с оригиналом и удалена',
      'cancelled': 'Отменено',
      'invalid': 'Недопустимое имя папки',
      'other': 'Ошибка',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Недавние';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить $countString объекта навсегда? Это нельзя отменить.',
      many: 'Удалить $countString объектов навсегда? Это нельзя отменить.',
      few: 'Удалить $countString объекта навсегда? Это нельзя отменить.',
      one: 'Удалить $countString объект навсегда? Это нельзя отменить.',
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
      other: 'Осталось $daysString дня',
      many: 'Осталось $daysString дней',
      few: 'Осталось $daysString дня',
      one: 'Остался $daysString день',
      zero: 'Будет удалено сегодня',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Корзина пуста';

  @override
  String get trashEmptyAll => 'Очистить корзину';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString дней';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString объекта перемещены в корзину',
      many: '$countString объектов перемещены в корзину',
      few: '$countString объекта перемещены в корзину',
      one: '$countString объект перемещён в корзину',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Убрать из списка';

  @override
  String trashRetention(int days) {
    return 'Photolib навсегда удаляет то, что хранит в корзине, через $days дней; у каждого объекта видно, сколько времени у него осталось.';
  }

  @override
  String get trashTitle => 'Корзина';

  @override
  String get undo => 'Отменить';

  @override
  String get uploadAction => 'Загрузить фото и видео';

  @override
  String get uploadClear => 'Очистить';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Загружено $doneString из $totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Ошибок: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString объекта перемещены в архив',
      many: '$countString объектов перемещены в архив',
      few: '$countString объекта перемещены в архив',
      one: '$countString объект перемещён в архив',
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
      other: '$countString объекта скрыты',
      many: '$countString объектов скрыты',
      few: '$countString объекта скрыты',
      one: '$countString объект скрыт',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Чёрный',
      'white': 'Белый',
      'other': 'Шахматный',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Это видео нельзя воспроизвести на этом устройстве';

  @override
  String get viewerCaptions => 'Субтитры';

  @override
  String get viewerCompass => 'Блокировка по компасу';

  @override
  String get viewerCopy => 'Копировать';

  @override
  String get viewerCopyText => 'Копировать текст';

  @override
  String get viewerCustomize => 'Настроить панель инструментов…';

  @override
  String get viewerDial =>
      'Направление. Нажмите, чтобы смотреть вперёд. Перетащите, чтобы осмотреться, прокрутите или сведите пальцы для масштаба, дважды нажмите для сброса';

  @override
  String get viewerFilmstrip => 'Лента миниатюр';

  @override
  String get viewerFirst => 'Первое';

  @override
  String get viewerFisheye => 'Рыбий глаз';

  @override
  String get viewerGyroscope => 'Двигайте устройство, чтобы осмотреться';

  @override
  String get viewerHdr => 'Показать в HDR';

  @override
  String get viewerInfo => 'Сведения';

  @override
  String get viewerInfoLoading => 'Загрузка сведений об этом элементе';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString из $countString';
  }

  @override
  String get viewerLast => 'Последнее';

  @override
  String get viewerLenses => 'Выбрать объектив';

  @override
  String get viewerMap => 'Карта';

  @override
  String get viewerMotion => 'Воспроизвести движение';

  @override
  String get viewerMotionDenied =>
      'Этот браузер не разрешил доступ к датчикам движения';

  @override
  String get viewerMotionMissing =>
      'На этом устройстве нет гироскопа, чтобы осматриваться';

  @override
  String get viewerMute => 'Выключить звук';

  @override
  String get viewerNext => 'Следующее';

  @override
  String get viewerNextFrame => 'Следующий кадр';

  @override
  String get viewerPause => 'Пауза';

  @override
  String get viewerPlanet => 'Маленькая планета';

  @override
  String get viewerPlay => 'Воспроизвести';

  @override
  String get viewerPrevious => 'Предыдущее';

  @override
  String get viewerPreviousFrame => 'Предыдущий кадр';

  @override
  String get viewerRotate => 'Повернуть';

  @override
  String get viewerSdr => 'Показать в SDR';

  @override
  String get viewerSeek => 'Позиция';

  @override
  String get viewerSetAs => 'Установить как';

  @override
  String get viewerShare => 'Поделиться';

  @override
  String get viewerSpeed => 'Скорость воспроизведения';

  @override
  String get viewerSphere =>
      'Обзор 360°. Перетаскивайте, чтобы осмотреться, сводите пальцы для масштаба';

  @override
  String get viewerText => 'Текст на этом фото';

  @override
  String get viewerTextCopied => 'Текст скопирован';

  @override
  String get viewerTextNone => 'На этом фото текст не найден';

  @override
  String get viewerTextUnread => 'Текст на этом фото ещё не распознан';

  @override
  String get viewerUnmute => 'Включить звук';

  @override
  String get viewerZoomIn => 'Увеличить';

  @override
  String get viewerZoomOut => 'Уменьшить';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD-карта',
      'other': 'Внутренняя',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Увеличить';

  @override
  String get zoomOut => 'Уменьшить';
}
