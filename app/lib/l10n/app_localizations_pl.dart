// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get actionAddToAlbum => 'Dodaj do albumu';

  @override
  String get actionArchive => 'Archiwizuj';

  @override
  String get actionCopyTo => 'Kopiuj do…';

  @override
  String get actionDeleteForever => 'Usuń na zawsze';

  @override
  String get actionFavourite => 'Dodaj do ulubionych';

  @override
  String get actionHide => 'Ukryj';

  @override
  String get actionMoveTo => 'Przenieś do…';

  @override
  String get actionRename => 'Zmień nazwę';

  @override
  String get actionRestore => 'Przywróć';

  @override
  String get actionShare => 'Udostępnij';

  @override
  String get actionTrash => 'Przenieś do kosza';

  @override
  String get actionUnarchive => 'Przywróć z archiwum';

  @override
  String get actionUndo => 'Cofnij';

  @override
  String get actionUnfavourite => 'Usuń z ulubionych';

  @override
  String get actionUnhide => 'Odkryj';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Aktywne',
      'disabled': 'Wyłączone',
      'invited': 'Zaproszone',
      'deleted': 'Usunięte',
      'other': 'Nieznany stan',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Konta';

  @override
  String get adminAddAccount => 'Dodaj konto';

  @override
  String get adminAddExternalLibrary => 'Dodaj bibliotekę zewnętrzną';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts próby',
      many: '$attempts prób',
      few: '$attempts próby',
      one: '$attempts próba',
      zero: 'jeszcze nie uruchomiono',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Dziennik audytu';

  @override
  String get adminBackUpNow => 'Utwórz kopię teraz';

  @override
  String get adminBackupQueued =>
      'Kopia jest w kolejce; po niej nastąpi próba przywracania';

  @override
  String get adminBackups => 'Kopie zapasowe bazy danych';

  @override
  String get adminCancelJob => 'Anuluj zadanie';

  @override
  String get adminCapabilities => 'Funkcje';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Biblioteki zarządzane',
      'uploads': 'Przesyłanie z urządzeń, przeglądarki i CLI',
      'folder_browser': 'Przeglądarka folderów',
      'device_folders': 'Foldery urządzenia w połączonych aplikacjach',
      'sharing': 'Udostępnianie i linki publiczne',
      'edits': 'Edycja',
      'deletes': 'Usuwanie',
      'xmp_writes': 'Zapisywanie plików XMP',
      'face_recognition': 'Rozpoznawanie twarzy',
      'ml_search': 'Inteligentne wyszukiwanie',
      'other': 'Nieznane',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Ostrzeżenie',
      'fail': 'Niepowodzenie',
      'other': 'Nieznany wynik',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Skopiowano';

  @override
  String get adminCopyBundle =>
      'Skopiuj dane diagnostyczne do zgłoszenia błędu';

  @override
  String get adminCopyLink => 'Kopiuj link';

  @override
  String get adminDelete => 'Usuń';

  @override
  String get adminDeviceBackups => 'Kopie zapasowe urządzeń';

  @override
  String get adminDevices => 'Twoje urządzenia';

  @override
  String get adminDisable => 'Wyłącz';

  @override
  String adminDrillFailed(String detail) {
    return 'Ostatnia próba przywracania nie powiodła się: $detail';
  }

  @override
  String get adminEdit => 'Edytuj';

  @override
  String get adminEmail => 'Adres e-mail';

  @override
  String get adminEnable => 'Włącz';

  @override
  String get adminErrorSignIn => 'Zaloguj się jako administrator';

  @override
  String get adminFacesDefault =>
      'Rozpoznawanie twarzy domyślnie włączone dla nowych kont';

  @override
  String get adminFiles => 'Pliki według rodzaju';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Uszkodzony',
      'missing': 'Brak',
      'size': 'Zły rozmiar',
      'hash': 'Podmieniony',
      'orphan': 'Zbędny plik',
      'other': 'Nieznany',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return 'Wolne: $size';
  }

  @override
  String get adminFreeDisk =>
      'Próg wolnego miejsca na dysku, poniżej którego przesyłanie jest wstrzymywane, w procentach, od 0 do 50';

  @override
  String get adminFreeDiskGb =>
      'lub poniżej tego wolnego miejsca w GB, jeśli jest mniejsze, od 0 do 100000';

  @override
  String get adminHandle => 'Nazwa użytkownika';

  @override
  String get adminIntegrity => 'Integralność';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementu',
      many: '$countString elementów',
      few: '$countString elementy',
      one: '$countString element',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'W kolejce',
      'running': 'W toku',
      'done': 'Ukończone',
      'dead': 'Niepowodzenie',
      'cancelled': 'Anulowane',
      'other': 'Wszystkie',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Typ zadania, np. render';

  @override
  String get adminJobs => 'Zadania';

  @override
  String adminLastSeen(String time) {
    return 'Ostatnio widziane $time';
  }

  @override
  String get adminLibraries => 'Biblioteki';

  @override
  String get adminLibraryOwner => 'Właściciel';

  @override
  String get adminLibraryRoot => 'Folder na serwerze, np. /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Dostępna',
      'offline': 'Niedostępna',
      'scanning': 'Skanowanie',
      'error': 'Błąd',
      'other': 'Nieznany stan',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Dziennik serwera';

  @override
  String get adminName => 'Nazwa wyświetlana';

  @override
  String get adminNothing => 'Nic tu jeszcze nie ma';

  @override
  String get adminOutOfRange => 'Poza zakresem';

  @override
  String get adminOverview => 'Przegląd';

  @override
  String get adminPair => 'Sparuj urządzenie';

  @override
  String get adminPairBody =>
      'Zeskanuj ten kod lub wyślij link, a potem wklej go w Photolib na nowym urządzeniu w Dodaj serwer: przenosi wszystkie adresy tego serwera i jego certyfikat, więc nikt nie musi ich wpisywać.';

  @override
  String get adminPasswordSetup => 'Link do ustawienia hasła';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Wyślij ten link do $name dowolnym sposobem albo pozwól zeskanować kod. Pozwala ustawić hasło jeden raz, do $date.';
  }

  @override
  String get adminPause => 'Wstrzymaj typ zadań';

  @override
  String adminPauseMinutes(int max) {
    return 'Minuty, od 1 do $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return 'Zadania typu $type są wstrzymane do $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementu do skopiowania',
      many: '$countString elementów do skopiowania',
      few: '$countString elementy do skopiowania',
      one: '1 element do skopiowania',
      zero: 'Nic do skopiowania',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Zasady';

  @override
  String get adminPolicyReset => 'Użyj wartości z wyższego poziomu';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Domyślnie włączone',
      'server': 'Ustawione dla serwera',
      'user': 'Ustawione dla tego konta',
      'library': 'Ustawione dla tej biblioteki',
      'config': 'Ustawione w konfiguracji',
      'other': 'Nieznane',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Zastosuj ustawienie wstępne';

  @override
  String get adminPresetBody =>
      'Ustawienie wstępne określa każdą funkcję serwera i usuwa to, co ustawiły konta i biblioteki. Wszystko można potem zmienić.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Przeglądanie archiwum',
      'family_backup': 'Kopia rodzinna',
      'personal': 'Osobiste',
      'other': 'Nieznane',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Zewnętrzne biblioteki tylko do odczytu są jedynym źródłem prawdy: bez przesyłania, bibliotek zarządzanych, folderów urządzenia, edycji, usuwania i zapisu XMP',
      'family_backup': 'Wszystko włączone oprócz zapisu XMP',
      'personal': 'Wszystko włączone oprócz udostępniania i linków publicznych',
      'other': 'Nieznane',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Kod QR linku';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString zadania w kolejce',
      many: '$countString zadań w kolejce',
      few: '$countString zadania w kolejce',
      one: '$countString zadanie w kolejce',
      zero: 'Nic do zrobienia',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'Limit miejsca w GB; pozostaw puste, aby nie ustawiać limitu';

  @override
  String get adminRemote => 'Dostęp zdalny';

  @override
  String get adminRemoteBody =>
      'Łącz się z serwerem z dowolnego miejsca bez otwierania portu na routerze. Wybierz sposób; każdy daje mu adres HTTPS do dodania w aplikacjach. Potem przetestuj go z zewnątrz.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared łączy się na zewnątrz z Cloudflare, który udostępnia twoją domenę przez HTTPS. Darmowy plan ogranicza żądanie do 100 MB, czego kopie zapasowe nigdy nie osiągają: wysyłają po 8 MiB.';

  @override
  String get adminRemoteNoAddress =>
      'Dodaj w tej aplikacji adres https:// serwera, aby przetestować go z zewnątrz.';

  @override
  String get adminRemoteReachable => 'Dostępny z zewnątrz.';

  @override
  String get adminRemoteTailscale =>
      'Zainstaluj Tailscale na komputerze serwera i na każdym urządzeniu, w tej samej sieci tailnet lub w swoim Headscale, potem uruchom to na komputerze serwera i ustaw public_url na wyświetlony adres.';

  @override
  String get adminRemoteTest => 'Testuj z zewnątrz';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host otworzy $url ze swoich serwerów na świecie i w ten sposób pozna ten adres. Kontynuować?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Niedostępny z zewnątrz: sprawdź wybrany sposób i przetestuj ponownie.';

  @override
  String get adminRemoteWireguard =>
      'Wymaga jednego otwartego portu UDP po stronie serwera lub na węźle pośrednim. To konfiguracja dla urządzenia; klucze utworzysz przez wg genkey.';

  @override
  String get adminRepair =>
      'Przywróć go z kopii zapasowej lub z urządzenia, które wciąż go ma';

  @override
  String get adminRepairOrphan =>
      'Żadne zdjęcie go nie wskazuje: sprawdź go, a potem usuń lub zachowaj';

  @override
  String get adminReprocess => 'Przetwórz ponownie';

  @override
  String get adminReprocessFaces => 'Ponownie wykryj twarze';

  @override
  String get adminReprocessFolder =>
      'Folder, np. 2024/05; pozostaw puste, aby objąć całą bibliotekę';

  @override
  String get adminReprocessMetadata => 'Ponownie odczytaj metadane';

  @override
  String get adminReprocessRenditions =>
      'Ponownie wygeneruj miniatury i podglądy';

  @override
  String get adminRestore => 'Przywróć';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Przywracanie $name nie powiodło się: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Żadna próba przywracania jeszcze się nie powiodła';

  @override
  String adminRestoreVerified(String when) {
    return 'Ostatnie zweryfikowane przywracanie: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd zatrzyma się, a po ponownym uruchomieniu zastąpi całą bazę danych kopią $name. Zmiany od tej kopii przepadną, a każde urządzenie zsynchronizuje się od nowa.';
  }

  @override
  String get adminRestoring => 'photolibd zatrzymuje się, aby przywrócić kopię';

  @override
  String get adminResume => 'Wznów';

  @override
  String get adminRetry => 'Ponów';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrator',
      'user': 'Użytkownik',
      'viewer': 'Przeglądający',
      'other': 'Nieznana rola',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Zapisano';

  @override
  String get adminScan => 'Skanuj teraz';

  @override
  String get adminScrubDays =>
      'Dni, w których kontrola sprawdza każdy oryginał, od 1 do 3650';

  @override
  String get adminScrubNever => 'Trwa pierwsza pełna kontrola';

  @override
  String adminScrubbed(String time) {
    return 'Ostatnia pełna kontrola $time';
  }

  @override
  String get adminSecondAdmin =>
      'Nadaj uprawnienia administratora drugiej osobie, aby ktoś inny mógł prowadzić i przywrócić serwer, gdy ty nie możesz.';

  @override
  String adminSilent(String time) {
    return 'Milczy od $time';
  }

  @override
  String get adminSilentHours =>
      'Godziny bez raportu, po których kopia urządzenia uznawana jest za milczącą, od 1 do 8760';

  @override
  String get adminStores => 'Pamięć masowa';

  @override
  String get adminThisDevice => 'To urządzenie';

  @override
  String get adminTitle => 'Administracja serwerem';

  @override
  String get adminTrashDays => 'Dni w koszu, od 1 do 3650';

  @override
  String get adminTwoFactor =>
      'Wszystkie konta muszą skonfigurować drugi składnik uwierzytelniania';

  @override
  String get adminUsage => 'Użycie według kont';

  @override
  String get albumCover => 'Ustaw jako okładkę';

  @override
  String get albumEmpty => 'Ten album jest pusty';

  @override
  String get albumHideMemories => 'Ukryj we wspomnieniach';

  @override
  String get albumHideTimeline => 'Ukryj na osi czasu';

  @override
  String get albumNew => 'Nowy album';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Dowolna data';

  @override
  String get backupCap => 'Największy element';

  @override
  String get backupCharging => 'Tylko podczas ładowania';

  @override
  String backupCompleted(String time) {
    return 'Ostatnia pełna kopia: $time';
  }

  @override
  String backupContact(String time) {
    return 'Ostatni kontakt z serwerem: $time';
  }

  @override
  String get backupEnabled => 'Twórz kopię tego urządzenia';

  @override
  String get backupFolderNo => 'Nie ten';

  @override
  String get backupFolderYes => 'Twórz kopię';

  @override
  String backupHours(int count) {
    return '$count godz.';
  }

  @override
  String get backupMetered =>
      'W sieciach z limitem, np. dane komórkowe lub hotspot';

  @override
  String get backupNever => 'Brak pełnej kopii';

  @override
  String backupNewFolder(String name) {
    return 'Nowy folder $name: tworzyć kopię?';
  }

  @override
  String get backupNoLimit => 'Bez limitu';

  @override
  String get backupNothing => 'Nic nie czeka';

  @override
  String get backupNow => 'Utwórz kopię teraz';

  @override
  String backupOverdue(int hours, String items) {
    return 'Brak pełnej kopii od $hours godz. Czeka: $items';
  }

  @override
  String get backupOverdueTitle => 'Kopia nie została ukończona';

  @override
  String backupPending(String items) {
    return 'Czeka: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Ponowna próba: $time';
  }

  @override
  String get backupRoaming => 'Twórz kopię w roamingu';

  @override
  String get backupSignIn =>
      'Zaloguj się na serwerze, aby tworzyć kopię tego urządzenia';

  @override
  String get backupSignedOut =>
      'Kopia zatrzymana: serwer wylogował to urządzenie. Zaloguj się ponownie w Ustawieniach.';

  @override
  String get backupSince => 'Wykonane od';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Kopia czeka, aż serwer będzie osiągalny',
      'charging': 'Kopia czeka na ładowanie urządzenia',
      'battery_low': 'Kopia czeka: niski poziom baterii',
      'roaming': 'Kopia czeka podczas roamingu',
      'quota': 'Kopia zatrzymana: miejsce na serwerze się skończyło',
      'second_factor':
          'Kopia zatrzymana: serwer wymaga drugiego składnika dla tego konta',
      'other': 'Kopia zatrzymana: serwer odpowiedział $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Kopia zapasowa';

  @override
  String get backupWaiting => 'Bez kopii';

  @override
  String get backupWarnAfter => 'Ostrzegaj, gdy niepełna przez';

  @override
  String get backupWhat => 'Co kopiować';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'W folderze, którego nie wybrano',
      'folder_new': 'W nowym folderze: zdecyduj, czy tworzyć kopię',
      'type_excluded': 'Rodzaj elementu, którego nie wybrano',
      'before_date': 'Wykonane przed wybraną datą',
      'selected': 'Czeka na swoją kolej',
      'server_restored':
          'Serwer utracił go podczas przywracania: wysyłanie ponownie',
      'working': 'Trwa tworzenie kopii',
      'waiting_for_icloud': 'Czeka na pobranie z iCloud',
      'metered': 'Czeka na sieć bez limitu',
      'metered_cap': 'Za duży dla sieci z limitem',
      'unreadable': 'To urządzenie nie może go odczytać',
      'changed': 'Zmienił się podczas wysyłania',
      'quota': 'Miejsce na serwerze się skończyło',
      'other': 'Serwer go odrzucił: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld => 'Serwer nie działa już z tą wersją Photolib.';

  @override
  String get checkAppTooOldNext => 'Zaktualizuj Photolib.';

  @override
  String get checkChanged =>
      'Certyfikat serwera nie jest tym, któremu zaufałeś.';

  @override
  String get checkChangedNext =>
      'Jeśli administrator go wymienił, zaufaj nowemu. Jeśli nie, ktoś może podsłuchiwać: nie kontynuuj.';

  @override
  String get checkClock =>
      'Zegar tego urządzenia i zegar serwera różnią się o ponad pięć minut.';

  @override
  String get checkClockNext =>
      'Pozwól urządzeniu ustawiać datę i godzinę automatycznie.';

  @override
  String get checkDnsFailed => 'Nazwa serwera nie prowadzi do żadnego adresu.';

  @override
  String get checkDnsFailedNext =>
      'Sprawdź adres albo połącz się z siecią serwera.';

  @override
  String checkExpired(String date) {
    return 'Certyfikat serwera wygasł $date.';
  }

  @override
  String get checkFailed => 'Niepowodzenie';

  @override
  String get checkMetered =>
      'Korzystasz z sieci taryfowej, np. danych komórkowych.';

  @override
  String get checkMeteredNext =>
      'Przed dużymi kopiami zapasowymi połącz się z Wi-Fi.';

  @override
  String get checkNotPhotolib =>
      'Odpowiada coś innego niż Photolib, na przykład strona błędu proxy lub strona logowania do Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Zaloguj się do Wi-Fi w przeglądarce albo poproś administratora o sprawdzenie proxy.';

  @override
  String get checkOtherServer =>
      'Pod tym adresem odpowiada inny serwer Photolib.';

  @override
  String get checkPassed => 'Zaliczono';

  @override
  String get checkRefused => 'Pod tym adresem nic nie odpowiada.';

  @override
  String get checkRefusedNext =>
      'Sprawdź, czy serwer działa i czy jesteś w jego sieci lub VPN.';

  @override
  String get checkRun => 'Sprawdź połączenie';

  @override
  String get checkRunning => 'Sprawdzanie';

  @override
  String get checkSelfSigned =>
      'Serwer używa własnego certyfikatu, którego to urządzenie jeszcze nie zna.';

  @override
  String get checkSkipped => 'Nie sprawdzono';

  @override
  String get checkStepAuth => 'Twoje logowanie';

  @override
  String get checkStepClock => 'Zegar urządzenia';

  @override
  String get checkStepDns => 'Znajdowanie adresu serwera';

  @override
  String get checkStepNetwork => 'Twoja sieć';

  @override
  String get checkStepServer => 'Photolib na serwerze';

  @override
  String get checkStepTcp => 'Łączenie z serwerem';

  @override
  String get checkStepTls => 'Bezpieczne połączenie i certyfikat';

  @override
  String get checkStepUpload => 'Duże przesyłania przez proxy';

  @override
  String get checkTimedOut => 'Serwer zbyt długo nie odpowiada.';

  @override
  String get checkTimedOutNext => 'Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get checkTitle => 'Sprawdzanie połączenia';

  @override
  String get checkTlsFailed => 'Bezpieczne połączenie nie powiodło się.';

  @override
  String get checkTrustNext =>
      'Zaufaj mu tylko wtedy, gdy jego odcisk zgadza się z odciskiem twojego serwera.';

  @override
  String get checkUntrusted =>
      'Certyfikat serwera pochodzi od urzędu, któremu to urządzenie nie ufa.';

  @override
  String get checkUploadCap =>
      'Proxy po drodze odrzuca duże przesyłania, więc kopie zapasowe idą wolniej, małymi częściami.';

  @override
  String get checkUploadCapNext =>
      'Poproś administratora, aby przepuszczał przez proxy żądania o rozmiarze 64 MB.';

  @override
  String get collectionAlbums => 'Albumy';

  @override
  String collectionHide(String name) {
    return 'Ukryj „$name”';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Przenieś „$name” w dół';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Przenieś „$name” w górę';
  }

  @override
  String get collectionPeople => 'Osoby';

  @override
  String collectionPin(String name) {
    return 'Przypnij „$name”';
  }

  @override
  String get collectionPlaces => 'Miejsca';

  @override
  String collectionShow(String name) {
    return 'Pokaż „$name”';
  }

  @override
  String get collectionTags => 'Tagi';

  @override
  String collectionUnpin(String name) {
    return 'Odepnij „$name”';
  }

  @override
  String get collectionsCustomise => 'Dostosuj';

  @override
  String get collectionsDone => 'Gotowe';

  @override
  String get commandPalette => 'Paleta poleceń';

  @override
  String get commandPaletteHint => 'Wpisz polecenie';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString na tym urządzeniu i w kopii zapasowej',
      many: '$countString na tym urządzeniu i w kopii zapasowej',
      few: '$countString na tym urządzeniu i w kopii zapasowej',
      one: '$countString na tym urządzeniu i w kopii zapasowej',
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
      other: '$countString tylko na tym urządzeniu, bez kopii zapasowej',
      many: '$countString tylko na tym urządzeniu, bez kopii zapasowej',
      few: '$countString tylko na tym urządzeniu, bez kopii zapasowej',
      one: '$countString tylko na tym urządzeniu, bez kopii zapasowej',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Gdy Zdjęcia iCloud są włączone, elementy usunięte z tego urządzenia znikną też z iCloud i z Twoich innych urządzeń Apple.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tylko w Twojej bibliotece',
      many: '$countString tylko w Twojej bibliotece',
      few: '$countString tylko w Twojej bibliotece',
      one: '$countString tylko w Twojej bibliotece',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Usuń z tego urządzenia';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementu z kopią zapasową; biblioteka je zachowa',
      many: '$countString elementów z kopią zapasową; biblioteka je zachowa',
      few: '$countString elementy z kopią zapasową; biblioteka je zachowa',
      one: '$countString element z kopią zapasową; biblioteka go zachowa',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Kopie na tym urządzeniu trafią do jego kosza: miejsce zwolni się po jego opróżnieniu.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usunąć $countString elementu?',
      many: 'Usunąć $countString elementów?',
      few: 'Usunąć $countString elementy?',
      one: 'Usunąć $countString element?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Z tego urządzenia i z Twojej biblioteki',
      'device': 'Tylko z tego urządzenia',
      'other': 'Z Twojej biblioteki',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Niedostępny';

  @override
  String get deviceFolderCard => 'Karta SD';

  @override
  String get deviceFolderExclude => 'Wyklucz';

  @override
  String get deviceFolderExcludeThis => 'Wyklucz ten folder';

  @override
  String get deviceFolderExcludedNotice =>
      'Folder tego elementu jest wykluczony z biblioteki';

  @override
  String get deviceFolderForget => 'Usuń z listy';

  @override
  String get deviceFolderInternal => 'Pamięć wewnętrzna';

  @override
  String get deviceFolderKeep => 'Zachowaj';

  @override
  String deviceFolderNew(String name, String items) {
    return 'Nowy folder: $name, $items';
  }

  @override
  String get deviceFolders => 'Foldery na urządzeniu';

  @override
  String get deviceFoldersAll =>
      'Pokazuj wszystkie foldery oprócz wykluczonych';

  @override
  String get deviceFoldersChosen => 'Pokazuj tylko wybrane foldery';

  @override
  String get deviceFoldersExcludedNow => 'Wykluczono z biblioteki';

  @override
  String get deviceFoldersSearch => 'Szukaj folderów';

  @override
  String get diagnosticsAdvanced => 'Pokaż diagnostykę';

  @override
  String get diagnosticsAllLoggers => 'Wszystkie źródła';

  @override
  String get diagnosticsCopied => 'Dziennik skopiowany';

  @override
  String get diagnosticsCopy => 'Kopiuj wyświetlany dziennik';

  @override
  String get diagnosticsEmpty => 'Brak wpisów w dzienniku';

  @override
  String get diagnosticsExport => 'Eksportuj pakiet diagnostyczny';

  @override
  String get diagnosticsExported => 'Zapisano pakiet diagnostyczny';

  @override
  String get diagnosticsLevel => 'Poziom';

  @override
  String get diagnosticsLogger => 'Źródło';

  @override
  String get diagnosticsTitle => 'Diagnostyka';

  @override
  String get download => 'Pobierz';

  @override
  String get downloadCurrent => 'Bieżąca wersja, z edycjami';

  @override
  String get downloadFailed => 'Nie udało się pobrać';

  @override
  String get downloadOriginal => 'Oryginał';

  @override
  String downloadSaved(String name) {
    return 'Zapisano $name';
  }

  @override
  String get downloadVersion => 'Która wersja?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pobieranie $countString elementu',
      many: 'Pobieranie $countString elementów',
      few: 'Pobieranie $countString elementów',
      one: 'Pobieranie $countString elementu',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Automatyczne ulepszanie';

  @override
  String get editorCrop => 'Przytnij';

  @override
  String get editorCropOriginal => 'Oryginał';

  @override
  String get editorCropSquare => 'Kwadrat';

  @override
  String get editorEdit => 'Edytuj';

  @override
  String get editorFlip => 'Odbij';

  @override
  String get editorRotate => 'Obróć';

  @override
  String get editorSaveCopy => 'Zapisz kopię';

  @override
  String get editorSaveFailed => 'Nie udało się zapisać kopii';

  @override
  String get editorSaveVersion => 'Zapisz';

  @override
  String get editorSaved => 'Zapisano jako kopię';

  @override
  String get editorVersionFailed => 'Nie udało się zapisać wersji';

  @override
  String get editorVersionSaved => 'Zapisano jako nową wersję';

  @override
  String get editorVersionsUnsupported =>
      'Ten serwer nie potrafi jeszcze przechowywać wersji edytowanych zdjęć';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cofnięto $countString zmiany: serwer je odrzucił.',
      many: 'Cofnięto $countString zmian: serwer je odrzucił.',
      few: 'Cofnięto $countString zmiany: serwer je odrzucił.',
      one: 'Cofnięto $countString zmianę: serwer ją odrzucił.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Zamknij';

  @override
  String get editsRejectedForbidden =>
      'Możesz przeglądać te elementy, ale nie możesz ich zmieniać.';

  @override
  String get editsRejectedInvalid => 'Serwer nie mógł przyjąć zmian.';

  @override
  String get editsRejectedNotFound =>
      'Elementy zostały usunięte lub nie są już Ci udostępniane.';

  @override
  String get errorNotFound => 'Ta strona nie istnieje';

  @override
  String get errorRetry => 'Spróbuj ponownie';

  @override
  String get errorTitle => 'Coś poszło nie tak';

  @override
  String faceNumber(int number) {
    return 'Twarz $number';
  }

  @override
  String get facesAgree => 'Zgadzam się';

  @override
  String get facesAura =>
      'Opisuj twarze za pomocą AuraFace (większe pobieranie)';

  @override
  String get facesNotNow => 'Nie teraz';

  @override
  String get facesNoticeKeep =>
      'To, co zostanie znalezione, zostaje przy Twoich zdjęciach, na Twoich urządzeniach i serwerze. Opisy nigdy nie są pokazywane ani udostępniane, a wszystko jest usuwane, gdy przestaniesz lub usuniesz zdjęcie.';

  @override
  String get facesNoticeOptional =>
      'To jest opcjonalne. Wszystko inne w Photolib działa bez tego, a w każdej chwili możesz przestać w Ustawieniach.';

  @override
  String get facesNoticeTitle => 'Znaleźć twarze na Twoich zdjęciach?';

  @override
  String get facesNoticeWhat =>
      'Photolib szuka twarzy na Twoich zdjęciach i filmach i zapisuje dla każdej, gdzie się znajduje, oraz listę liczb, która ją opisuje, aby można było ponownie rozpoznać tę samą osobę. Taki opis może być uznany za dane biometryczne.';

  @override
  String get facesNoticeWhere =>
      'Dzieje się to na tym urządzeniu i, jeśli jesteś zalogowany, na Twoim własnym serwerze. Nigdy w usłudze prowadzonej przez nas lub kogokolwiek innego.';

  @override
  String get facesServerFailed =>
      'Nie udało się powiadomić serwera. Spróbuj ponownie.';

  @override
  String get facesServerOff => 'Twój serwer nie szuka dla Ciebie twarzy';

  @override
  String get facesServerOn => 'Twój serwer szuka dla Ciebie twarzy';

  @override
  String get facesServerUnavailable =>
      'Twój serwer nie oferuje rozpoznawania twarzy';

  @override
  String facesStatusDownloading(int percent) {
    return 'Pobieranie modeli twarzy: $percent%';
  }

  @override
  String get facesStatusMissing => 'Twój serwer nie zainstalował modeli twarzy';

  @override
  String get facesStatusNoDecoder =>
      'Wyszukiwanie twarzy jest niedostępne: nie znaleziono biblioteki obrazów (libvips). Zainstaluj Photolib ponownie albo zainstaluj libvips i uruchom aplikację ponownie.';

  @override
  String get facesStatusRunning => 'Szukanie twarzy na tym urządzeniu';

  @override
  String get facesStatusUnavailable =>
      'Na tym urządzeniu nie można szukać twarzy';

  @override
  String get facesStatusWaiting => 'Modele twarzy pobiorą się przez Wi-Fi';

  @override
  String get facesSwitch => 'Znajdź twarze na moich zdjęciach';

  @override
  String get facesSwitchOff =>
      'Wyłączone. Nic o twarzach nie jest obliczane, dopóki się nie zgodzisz.';

  @override
  String get facesSwitchOn =>
      'Włączone. Photolib znajduje twarze na Twoich zdjęciach.';

  @override
  String get facesTitle => 'Twarze i osoby';

  @override
  String get facesWithdraw => 'Usuń i przestań';

  @override
  String get facesWithdrawBody =>
      'To usuwa wszystkie twarze, opisy i osoby, które Photolib znalazł dla Ciebie, na tym urządzeniu i na Twoim serwerze. Twoje zdjęcia się nie zmieniają.';

  @override
  String get facesWithdrawTitle => 'Przestać szukać twarzy?';

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

    return 'Niezmienione pliki: $countString';
  }

  @override
  String get folderAllow => 'Zezwól na dostęp do tego folderu';

  @override
  String get folderDelete => 'Usuń folder';

  @override
  String folderDeleteBody(String name) {
    return 'Przenieść zdjęcia i filmy z folderu $name do kosza?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementu',
      many: '$countString elementów',
      few: '$countString elementy',
      one: '$countString element',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Nowy folder';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Niedostępny, $countString elementu',
      many: 'Niedostępny, $countString elementów',
      few: 'Niedostępny, $countString elementy',
      one: 'Niedostępny, $countString element',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Ten folder już jest w bibliotece, znajduje się w jednym z jej folderów lub zawiera taki folder';

  @override
  String get folderRemove => 'Usuń folder';

  @override
  String folderRemoveBody(String folder) {
    return 'Zdjęcia i filmy z folderu $folder zostaną usunięte z biblioteki. Pliki pozostaną na dysku bez zmian.';
  }

  @override
  String get folderRemoveConfirm => 'Usuń';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skanowanie, dotąd znaleziono $countString elementu',
      many: 'Skanowanie, dotąd znaleziono $countString elementów',
      few: 'Skanowanie, dotąd znaleziono $countString elementy',
      one: 'Skanowanie, dotąd znaleziono $countString element',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Zezwól na dostęp';

  @override
  String get foldersHideExcluded => 'Ukryj wykluczone foldery';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib nie może już odczytać $countString folderu.',
      many: 'Photolib nie może już odczytać $countString folderów.',
      few: 'Photolib nie może już odczytać $countString folderów.',
      one: 'Photolib nie może już odczytać $countString folderu.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Pokaż wykluczone foldery ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Ta przeglądarka nie może używać folderu jako Twojej biblioteki. Otwórz Photolib w Chrome lub Edge na komputerze albo użyj aplikacji na komputer.';

  @override
  String get galleryButtons => 'Przyciski';

  @override
  String galleryCameraNote(String camera) {
    return 'Your camera app ($camera) decides where its preview opens. Aperture, Open Camera and Fossify Camera open Photolib. The cameras of Pixel, Samsung, Xiaomi and Motorola open their own gallery.';
  }

  @override
  String get galleryChips => 'Chipy';

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
  String get galleryGrid => 'Siatka';

  @override
  String get galleryMenus => 'Menu i arkusze';

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
  String get galleryShowSheet => 'Pokaż arkusz';

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
  String get galleryTitle => 'Komponenty';

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
    return 'Ukryte ($count)';
  }

  @override
  String get indexingAllowMetered => 'Pobieraj przez dane komórkowe';

  @override
  String get indexingAllowSaver => 'Również w trybie oszczędzania energii';

  @override
  String get indexingBattery => 'Wymagany poziom baterii bez ładowarki';

  @override
  String get indexingChargingOnly => 'Tylko podczas ładowania';

  @override
  String indexingDownloading(int percent) {
    return 'Pobieranie modelu wyszukiwania: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie udało się odczytać $count zdjęcia',
      many: 'Nie udało się odczytać $count zdjęć',
      few: 'Nie udało się odczytać $count zdjęć',
      one: 'Nie udało się odczytać $count zdjęcia',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'To urządzenie indeksuje tylko nowe zdjęcia';

  @override
  String get indexingMissing =>
      'Twój serwer nie zainstalował modelu wyszukiwania';

  @override
  String get indexingModels => 'Wyszukiwanie na tym urządzeniu';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Pobiera model wyszukiwania ($megabytesString MB) z $host';
  }

  @override
  String get indexingNoDecoder =>
      'Wyszukiwanie i odczyt tekstu są niedostępne: nie znaleziono biblioteki obrazów (libvips). Zainstaluj Photolib ponownie albo zainstaluj libvips i uruchom aplikację ponownie.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Wstrzymane, dopóki bateria ma poniżej $percent%';
  }

  @override
  String get indexingPausedCharger =>
      'Wstrzymane do czasu ładowania urządzenia';

  @override
  String get indexingPausedHeat => 'Wstrzymane, dopóki urządzenie jest gorące';

  @override
  String get indexingPausedSaver =>
      'Wstrzymane, dopóki oszczędzanie baterii jest włączone';

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

    return 'Zindeksowane zdjęcia: $doneString z $totalString';
  }

  @override
  String get indexingText => 'Odczytuj tekst na zdjęciach';

  @override
  String indexingTextDownloading(int percent) {
    return 'Pobieranie modeli tekstu: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Pobiera modele tekstu ($megabytesString MB) z $host; znajduje słowa na zdjęciach';
  }

  @override
  String get indexingTextMissing =>
      'Twój serwer nie zainstalował modeli tekstu';

  @override
  String get indexingTextPlatform =>
      'Używa wbudowanego rozpoznawania tekstu telefonu; nic do pobrania. Odczytuje nowe zdjęcia';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Zdjęcia odczytane pod kątem tekstu: $doneString z $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Odczyt tekstu nie jest tu dostępny';

  @override
  String get indexingTextWaiting => 'Modele tekstu pobierają się przez Wi-Fi';

  @override
  String get indexingUnavailable =>
      'Wyszukiwanie na tym urządzeniu jest tu niedostępne';

  @override
  String get indexingWaiting => 'Model wyszukiwania pobierze się przez Wi-Fi';

  @override
  String get infoAddName => 'Dodaj imię';

  @override
  String get infoAddTag => 'Dodaj tag';

  @override
  String get infoAlbums => 'Albumy';

  @override
  String get infoAllMetadata => 'Wyświetl wszystkie metadane';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Kopia zapasowa';

  @override
  String get infoCamera => 'Aparat';

  @override
  String get infoChangeAdjust => 'Dostosowano kolory';

  @override
  String get infoChangeCrop => 'Przycięto';

  @override
  String get infoChangeFlip => 'Odbito lustrzanie';

  @override
  String get infoChangeInpaint => 'Wypełniono obszar';

  @override
  String get infoChangeLocal => 'Dostosowano obszar';

  @override
  String get infoChangeLut => 'Zastosowano styl kolorów';

  @override
  String get infoChangeOther => 'Edytowano';

  @override
  String get infoChangeTurn => 'Obrócono';

  @override
  String get infoCompare => 'Porównaj z oryginałem';

  @override
  String infoConfidence(String percent) {
    return 'Pewność: $percent';
  }

  @override
  String get infoCopyPath => 'Kopiuj ścieżkę';

  @override
  String get infoCurrent => 'Bieżąca';

  @override
  String get infoDescription => 'Dodaj opis';

  @override
  String get infoEditDate => 'Edytuj datę';

  @override
  String infoEditNumber(int number) {
    return 'Edycja $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Edytowana kopia $name';
  }

  @override
  String get infoFaces => 'Twarze';

  @override
  String get infoFile => 'Plik';

  @override
  String get infoFromFileName => 'z nazwy pliku';

  @override
  String get infoHistory => 'Historia edycji';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementu',
      many: '$count elementów',
      few: '$count elementy',
      one: '$count element',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Miejsce';

  @override
  String get infoMap => 'Mapa miejsca wykonania';

  @override
  String get infoMapAgree =>
      'Kafelki mapy pochodzą z internetu i zdradzają, jaki obszar oglądasz';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Nowy tag: $path';
  }

  @override
  String get infoNoAlbum => 'Nie ma w żadnym albumie';

  @override
  String get infoOnDevice => 'Na tym urządzeniu';

  @override
  String get infoOriginal => 'Oryginał';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString pikseli';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Usuń z $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Usuń $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Usunięto z $album';
  }

  @override
  String get infoRevert => 'Przywróć';

  @override
  String get infoSaveCopy => 'Zapisz jako kopię';

  @override
  String get infoShared => 'udostępniony';

  @override
  String get infoShowFaces => 'Pokaż twarze na zdjęciu';

  @override
  String get infoShowMap => 'Pokaż mapę';

  @override
  String get infoTags => 'Tagi';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wersji',
      many: '$count wersji',
      few: '$count wersje',
      one: '$count wersja',
    );
    return '$_temp0 · ostatnia $time';
  }

  @override
  String get infoWhy => 'Dlaczego ta data?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Odczytana z pliku, jako $tag',
      'name': 'Odczytana z nazwy pliku',
      'folder': 'Odczytana z nazwy folderu',
      'host': 'Podana przez usługę, z której pochodzi plik',
      'unknown': 'Nic w pliku nie wskazuje daty, więc użyto daty jego ostatniej zmiany',
      'other': 'Plik nie został jeszcze odczytany, więc użyto daty podanej przez urządzenie',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Lista',
      'other': 'Siatka',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Nazwa',
      'taken': 'Data wykonania',
      'modified': 'Data modyfikacji',
      'size': 'Rozmiar',
      'random': 'Losowo',
      'extension': 'Typ',
      'custom': 'Kolejność albumu',
      'other': 'Data wykonania',
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
  String get languageDevice => 'Język urządzenia';

  @override
  String get languageName => 'Polski';

  @override
  String get libraryAddFolder => 'Dodaj folder';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Bez kopii zapasowej',
      'backed_up': 'Z kopią zapasową',
      'cloud_only': 'Tylko w chmurze',
      'other': 'Wszystkie',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Wszystko ma kopię zapasową',
      'backed_up': 'Nic nie ma jeszcze kopii zapasowej',
      'cloud_only': 'Nic nie jest tylko na serwerze',
      'other': 'Nic tu nie ma',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Plakietki kopii zapasowej';

  @override
  String get libraryEmpty => 'Tutaj pojawią się Twoje zdjęcia';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Grupuj według tygodni',
      'month': 'Grupuj według miesięcy',
      'other': 'Grupuj według dni',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Ponownie ukryj ukryte i zarchiwizowane elementy';

  @override
  String get libraryNoKeyring =>
      'Photolib przechowuje klucz do Twojej biblioteki w systemowym pęku kluczy, który nie działa lub jest zablokowany. Uruchom lub odblokuj pęk kluczy, na przykład GNOME Keyring lub KWallet, i spróbuj ponownie.';

  @override
  String get libraryRevealExcluded => 'Pokaż wykluczone foldery przez 5 minut';

  @override
  String get libraryShowVeiled =>
      'Pokaż ukryte i zarchiwizowane elementy przez 5 minut';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Ostatnio dodane',
      'other': 'Data wykonania',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib nie może otworzyć biblioteki zapisanej na tym urządzeniu';

  @override
  String get libraryViewOptions => 'Opcje widoku';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Przygotowywanie miniatur: $doneString z $totalString';
  }

  @override
  String get libraryZoomIn => 'Większe miniatury';

  @override
  String get libraryZoomOut => 'Mniejsze miniatury';

  @override
  String get mapAddTrack => 'Dodaj ślad GPX';

  @override
  String get mapArea => 'Obszar mapy';

  @override
  String get mapAttribution => '© współtwórcy OpenStreetMap';

  @override
  String get mapClearLasso => 'Wyczyść zaznaczenie';

  @override
  String get mapEmpty => 'Brak jeszcze zdjęć z lokalizacją';

  @override
  String get mapHeat => 'Mapa cieplna';

  @override
  String get mapLasso => 'Zaznacz, rysując pętlę wokół zdjęć';

  @override
  String get mapLoading => 'Umieszczanie zdjęć na mapie';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Zdjęcia: $countString';
  }

  @override
  String get mapSearchHere => 'Szukaj w tym obszarze';

  @override
  String get mapSplit => 'Pokaż zdjęcia pod mapą';

  @override
  String get mapTilesAgree =>
      'Tło mapy pochodzi z serwera OpenStreetMap (tile.openstreetmap.org), który widzi, jaki obszar oglądasz';

  @override
  String get mapTilesShow => 'Pokaż tło';

  @override
  String get mapTime => 'Zakres czasu';

  @override
  String get mapTitle => 'Mapa';

  @override
  String get mapTrackBad => 'Ten plik nie zawiera śladów GPX';

  @override
  String get mapTrips => 'Podróże';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Ulubione',
      'hidden': 'Ukryte',
      'archived': 'Zarchiwizowane',
      'offline': 'Zachowane na tym urządzeniu',
      'offline': 'Zachowane na tym urządzeniu',
      'offline': 'Zachowane na tym urządzeniu',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Zezwól na dostęp';

  @override
  String get mediaAccessNone =>
      'Photolib potrzebuje dostępu do Twoich zdjęć i filmów, aby je wyświetlać.';

  @override
  String get mediaAccessPartial =>
      'Photolib widzi tylko wybrane przez Ciebie zdjęcia i filmy. Galeria potrzebuje dostępu do wszystkich.';

  @override
  String get mediaAccessSelect => 'Wybierz więcej zdjęć';

  @override
  String get nameLabel => 'Nazwa';

  @override
  String get nextAddRoot =>
      'Dodaj folder do external_roots w konfiguracji serwera, a potem uruchom serwer ponownie.';

  @override
  String get nextAskAdmin => 'Zapytaj administratora swojego serwera.';

  @override
  String get nextAskOwner =>
      'Poproś właściciela biblioteki, aby pozwolił ci dodawać zdjęcia.';

  @override
  String get nextCheckConnection =>
      'Sprawdź połączenie, aby zobaczyć dlaczego.';

  @override
  String get nextCheckEntry => 'Sprawdź, co wpisałeś, i spróbuj ponownie.';

  @override
  String get nextConfirm => 'Sprawdź, ilu elementów to dotyczy, i potwierdź.';

  @override
  String get nextDeleteWebhook =>
      'Usuń webhook, którego już nie używasz, i spróbuj ponownie.';

  @override
  String get nextEditConfig =>
      'Zmień to w konfiguracji serwera, a potem uruchom serwer ponownie.';

  @override
  String get nextFreeSpace =>
      'Zwolnij miejsce albo poproś administratora o więcej.';

  @override
  String get nextNewLink => 'Poproś administratora o nowy.';

  @override
  String get nextNewestToken => 'Skopiuj najnowszy z dziennika photolibd.';

  @override
  String get nextOtherAdmin =>
      'Najpierw nadaj innemu kontu uprawnienia administratora.';

  @override
  String get nextOtherFolder => 'Wybierz osobny folder.';

  @override
  String get nextRefresh => 'Odśwież i spróbuj ponownie.';

  @override
  String get nextReport =>
      'Spróbuj ponownie. Jeśli to się powtórzy, skopiuj poniższe szczegóły dla administratora.';

  @override
  String get nextSetUpPrivate =>
      'Dokończ konfigurowanie prywatnych bibliotek w Ustawieniach, a potem spróbuj ponownie.';

  @override
  String get nextSignIn => 'Zaloguj się ponownie.';

  @override
  String get nextSignInAccount =>
      'Zaloguj się na swoje konto i spróbuj ponownie.';

  @override
  String get nextSignInInstead => 'Zamiast tego zaloguj się.';

  @override
  String get nextTryAgain => 'Spróbuj ponownie.';

  @override
  String get nextUpdateAndAgree =>
      'Zaktualizuj aplikację i zgódź się na informację ponownie.';

  @override
  String get nextUseAnother => 'Wybierz inną.';

  @override
  String get nextUseHttps =>
      'Użyj adresu https:// serwera albo połącz się z sieci serwera.';

  @override
  String get nextWait => 'Poczekaj minutę i spróbuj ponownie.';

  @override
  String get offlineKeep => 'Zachowaj offline';

  @override
  String offlineKeepHere(String size) {
    return 'Zachowaj na tym urządzeniu ($size)';
  }

  @override
  String get offlineKeptHere => 'Zachowane na tym urządzeniu';

  @override
  String get offlineStopKeeping => 'Przestań zachowywać offline';

  @override
  String get otherFiles => 'Inne pliki';

  @override
  String get passphraseCreate =>
      'Na tym komputerze nie działa pęk kluczy (Secret Service), który przechowywałby klucze Photolib. Wybierz frazę hasła o długości co najmniej 10 znaków, aby je chronić: Photolib zapyta o nią przy każdym uruchomieniu.';

  @override
  String get passphraseLabel => 'Fraza hasła';

  @override
  String get passphraseMismatch => 'Frazy hasła się różnią.';

  @override
  String get passphraseRepeat => 'Powtórz frazę hasła';

  @override
  String get passphraseTooShort => 'Użyj co najmniej 10 znaków.';

  @override
  String get passphraseUnlock =>
      'Wpisz frazę hasła, która chroni klucze Photolib na tym komputerze.';

  @override
  String get passphraseWrong => 'Nieprawidłowa fraza hasła. Spróbuj ponownie.';

  @override
  String photoPosition(int index, int count) {
    return 'Zdjęcie $index z $count';
  }

  @override
  String get privacyCheckKit => 'Sprawdź zestaw odzyskiwania';

  @override
  String get privacyDrillDue =>
      'Czas na próbę odzyskiwania: sprawdź, czy zestaw odzyskiwania nadal odblokowuje twoje prywatne biblioteki.';

  @override
  String get privacyHonest =>
      'Prywatne biblioteki są szyfrowane na twoich urządzeniach i nikt inny nie może ich otworzyć: ani serwer, ani jego administrator, ani twórcy Photolib. Jeśli stracisz zarówno hasło, jak i zestaw odzyskiwania, twoje zdjęcia przepadną na zawsze i nikt nie odzyska ich za ciebie.';

  @override
  String get privacyKitBody =>
      'Zapisz te 24 słowa na papierze, w kolejności, i przechowuj je w bezpiecznym miejscu. Odblokowują twoje prywatne biblioteki, jeśli zapomnisz hasła – każdemu, kto je ma.';

  @override
  String get privacyKitDone => 'Twój zestaw odzyskiwania działa.';

  @override
  String get privacyKitOther =>
      'To nie jest twój aktualny zestaw odzyskiwania.';

  @override
  String get privacyKitTitle => 'Twój zestaw odzyskiwania';

  @override
  String get privacyKitUnverified =>
      'Zestaw odzyskiwania jeszcze niepotwierdzony';

  @override
  String privacyKitVerified(String date) {
    return 'Zestaw odzyskiwania potwierdzony $date';
  }

  @override
  String get privacyKitWritten => 'Mam je zapisane';

  @override
  String get privacyNotReady =>
      'Prywatne przesyłanie pozostaje wyłączone, dopóki nie będziesz mieć dwóch sposobów odblokowania i potwierdzonego zestawu odzyskiwania.';

  @override
  String get privacyPasswordHelp =>
      'Wpisz hasło swojego konta: stanie się jednym ze sposobów odblokowania prywatnych bibliotek.';

  @override
  String get privacyPhrase => 'Fraza odzyskiwania';

  @override
  String get privacyPhraseHelp => '24 słowa twojego zestawu odzyskiwania';

  @override
  String get privacyPhraseInvalid =>
      'To nie jest fraza odzyskiwania. Sprawdź każde słowo.';

  @override
  String get privacyReady => 'Prywatne przesyłanie jest włączone.';

  @override
  String get privacyRecoveryKit => 'Zestaw odzyskiwania';

  @override
  String get privacySetUp => 'Skonfiguruj';

  @override
  String get privacyShowWords => 'Pokaż słowa ponownie';

  @override
  String get privacyTitle => 'Prywatne biblioteki';

  @override
  String privacyUnknownWord(int number) {
    return 'Słowo $number nie należy do słów zestawu odzyskiwania.';
  }

  @override
  String get privacyVerify => 'Potwierdź';

  @override
  String get privacyVerifyBody =>
      'Wpisz te słowa z zestawu odzyskiwania, aby pokazać, że go masz.';

  @override
  String get privacyWays => 'Sposoby odblokowania';

  @override
  String privacyWord(int number) {
    return 'Słowo $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Te słowa nie pasują do twojego zestawu odzyskiwania. Sprawdź swoje zapiski.';

  @override
  String get privacyWrongPassword => 'To nie jest hasło twojego konta.';

  @override
  String get problemAdminOnly => 'Tylko administrator może to zrobić.';

  @override
  String get problemBusy => 'Serwer jest zajęty lub uruchamia się ponownie.';

  @override
  String get problemChanged => 'To się w międzyczasie zmieniło.';

  @override
  String get problemConfirm =>
      'To ukryłoby lub usunęło więcej elementów, niż serwer robi bez potwierdzenia';

  @override
  String get problemContribute => 'Nie możesz dodawać zdjęć do tej biblioteki.';

  @override
  String get problemCopy => 'Kopiuj szczegóły';

  @override
  String get problemDetails => 'Szczegóły';

  @override
  String get problemDiskLow =>
      'Dysk serwera jest prawie pełny, więc przesyłanie jest wstrzymane.';

  @override
  String get problemEmailTaken => 'Inne konto ma ten e-mail.';

  @override
  String get problemExists => 'To już istnieje.';

  @override
  String get problemFaceNotice =>
      'Twój serwer wymaga nowszej wersji informacji o twarzach, niż pokazuje ta aplikacja.';

  @override
  String get problemGone => 'Tego już nie ma na serwerze.';

  @override
  String get problemHandleTaken => 'Inne konto ma tę nazwę użytkownika.';

  @override
  String get problemInterrupted => 'Przesyłanie zostało przerwane.';

  @override
  String get problemInvalid => 'Nieprawidłowa wartość';

  @override
  String get problemLastAdmin =>
      'Serwer potrzebuje co najmniej jednego administratora.';

  @override
  String get problemLinkInvalid => 'Ten link wygasł lub został już użyty.';

  @override
  String get problemLoginFailed =>
      'Nieprawidłowy e-mail, nazwa użytkownika lub hasło.';

  @override
  String get problemMaintenanceKey =>
      'Kopie zapasowe, kontrole integralności i trwałe usuwanie można wstrzymać tylko po zalogowaniu, a nie za pomocą klucza API';

  @override
  String get problemNotAllowed => 'Twoje konto nie może tego zrobić.';

  @override
  String get problemNotExternal =>
      'Skanować można tylko biblioteki z własnych folderów serwera.';

  @override
  String get problemOidcClaim =>
      'Twój dostawca logowania nie podał, kim jesteś, w sposób akceptowany przez ten serwer.';

  @override
  String get problemOidcDown =>
      'Twój dostawca logowania nie odpowiada serwerowi.';

  @override
  String get problemOidcFailed => 'Twój dostawca logowania odmówił logowania.';

  @override
  String get problemOidcNotAllowed =>
      'Twoje konto nie może logować się w ten sposób.';

  @override
  String get problemOidcTaken =>
      'To logowanie jest już połączone z innym kontem Photolib.';

  @override
  String get problemOidcUnknown =>
      'Ten serwer nie oferuje już tego sposobu logowania.';

  @override
  String get problemPasskeysOff =>
      'Klucze dostępu działają dopiero, gdy serwer ma swój adres publiczny.';

  @override
  String get problemPinned =>
      'To ustawienie pochodzi z pliku konfiguracyjnego i nie można go tu zmienić.';

  @override
  String get problemPolicyOff => 'To jest wyłączone na tym serwerze.';

  @override
  String get problemQuota => 'Twoje miejsce na serwerze jest pełne.';

  @override
  String get problemRestoreKey =>
      'Kopię zapasową można przywrócić tylko po zalogowaniu, a nie za pomocą klucza API.';

  @override
  String get problemRootDiffers =>
      'Ten folder nie zawiera plików tej biblioteki';

  @override
  String get problemRootNotAllowed =>
      'Ten folder nie leży w external_roots z konfiguracji serwera';

  @override
  String get problemRootOverlaps =>
      'Ten folder zawiera inną bibliotekę lub dane samego serwera albo się w nich znajduje';

  @override
  String get problemScanning => 'Ta biblioteka jest już skanowana';

  @override
  String get problemSecondFactor =>
      'To konto wymaga drugiego składnika, takiego jak kod uwierzytelniający lub klucz dostępu, którego ta wersja Photolib nie umie jeszcze podać.';

  @override
  String get problemSetupDone => 'Ten serwer ma już administratora.';

  @override
  String get problemSetupExpired => 'To trwało za długo.';

  @override
  String get problemSetupToken => 'Ten token konfiguracji jest nieprawidłowy.';

  @override
  String get problemSignedOut => 'Jesteś wylogowany z serwera.';

  @override
  String get problemStepUp => 'Ta zmiana wymaga najpierw hasła lub kodu.';

  @override
  String get problemStorage => 'Serwer nie ma dostępu do swojej pamięci.';

  @override
  String get problemTooMany => 'Za dużo prób w krótkim czasie.';

  @override
  String get problemUnexpected => 'Coś nieoczekiwanego poszło nie tak.';

  @override
  String get problemUnreachable => 'Serwer nie odpowiada.';

  @override
  String get problemUploadDamaged =>
      'Plik zmienił się lub uszkodził po drodze.';

  @override
  String get problemUploadExpired =>
      'Serwer nie ma już tego przesyłania: niedokończone przesyłania wygasają po dniu.';

  @override
  String get problemWebhookLimit =>
      'Twoje konto ma już tyle webhooków, ile może mieć.';

  @override
  String get problemWebhooksOff => 'Webhooki są wyłączone na tym serwerze.';

  @override
  String get recoveryCode => 'Kod odzyskiwania';

  @override
  String get recoveryCodeAbout =>
      'Otwiera magazyn Photolib na tym urządzeniu, jeśli magazyn kluczy utraci jego klucz';

  @override
  String get recoveryCodeEnter => 'Wpisz kod odzyskiwania';

  @override
  String get recoveryCreate => 'Utwórz kod odzyskiwania';

  @override
  String get recoveryLater => 'Później';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString zmiany istnieje tylko na tym urządzeniu. Kod odzyskiwania je przywróci, jeśli magazyn kluczy utraci klucz Photolib.',
      many:
          '$countString zmian istnieje tylko na tym urządzeniu. Kod odzyskiwania je przywróci, jeśli magazyn kluczy utraci klucz Photolib.',
      few:
          '$countString zmiany istnieją tylko na tym urządzeniu. Kod odzyskiwania je przywróci, jeśli magazyn kluczy utraci klucz Photolib.',
      one:
          '$countString zmiana istnieje tylko na tym urządzeniu. Kod odzyskiwania ją przywróci, jeśli magazyn kluczy utraci klucz Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Zapisz te 24 słowa i przechowuj je w bezpiecznym miejscu: otwierają magazyn Photolib na tym urządzeniu bez jego klucza z magazynu kluczy. Zastępują każdy wcześniejszy kod.';

  @override
  String get recoveryUnlock => 'Odblokuj';

  @override
  String get recoveryWrong => 'To nie jest kod odzyskiwania tego magazynu';

  @override
  String get renameFind => 'Znajdź';

  @override
  String get renamePattern => 'Nowa nazwa';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Za długa: nazwa ma najwyżej 255 bajtów',
      'invalid': 'Nieprawidłowa nazwa pliku',
      'duplicate': 'Nadana też innemu plikowi',
      'exists': 'Inny plik w tym folderze ma tę nazwę',
      'other': 'Nie można zmienić nazwy',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Zamień na';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Pliki o zmienionej nazwie: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Pokaż w Finderze',
      'windows': 'Pokaż w Eksploratorze',
      'other': 'Pokaż w folderze',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Aparat';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementu',
      many: '$countString elementów',
      few: '$countString elementy',
      one: '$countString element',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Daty';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Przeszukaj bibliotekę';

  @override
  String get searchFavourites => 'Ulubione';

  @override
  String get searchFolder => 'Folder';

  @override
  String get searchHint => 'Nazwa pliku lub folderu';

  @override
  String get searchMotionPhotos => 'Zdjęcia ruchome';

  @override
  String get searchNothing => 'Brak wyników';

  @override
  String get searchPanoramas => 'Panoramy';

  @override
  String get searchPhotos => 'Zdjęcia';

  @override
  String get searchScreenshots => 'Zrzuty ekranu';

  @override
  String get searchVideo => 'Film';

  @override
  String get searchVideos => 'Filmy';

  @override
  String get securityAddPasskey => 'Dodaj klucz dostępu';

  @override
  String get securityCode => 'Kod';

  @override
  String get securityCodesHelp =>
      'Przechowuj te kody w bezpiecznym miejscu. Każdy działa raz zamiast drugiego składnika i są pokazywane tylko teraz.';

  @override
  String securityCodesLeft(int count) {
    return 'Niewykorzystane: $count';
  }

  @override
  String get securityNewCodes => 'Nowe kody';

  @override
  String get securityPasskeyNotAdded => 'Nie dodano klucza dostępu.';

  @override
  String get securityRecoveryCodes => 'Kody odzyskiwania';

  @override
  String get securityRemovePasskey => 'Usuń klucz dostępu';

  @override
  String get securitySetUp => 'Skonfiguruj';

  @override
  String get securityStepUpBody =>
      'Wpisz hasło, kod z aplikacji uwierzytelniającej lub kod odzyskiwania, aby zmienić drugie składniki.';

  @override
  String get securityStepUpTitle => 'Potwierdź, że to Ty';

  @override
  String get securityTitle => 'Drugie składniki';

  @override
  String get securityTotp => 'Aplikacja uwierzytelniająca';

  @override
  String get securityTotpHelp =>
      'Dodaj ten klucz do aplikacji uwierzytelniającej, a potem wpisz wyświetlony w niej kod.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Włączona',
      'other': 'Wyłączona',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Wyłącz';

  @override
  String get securityWrongCode => 'Ten kod jest nieprawidłowy.';

  @override
  String get securityWrongProof => 'Nieprawidłowe hasło lub kod.';

  @override
  String get selectAll => 'Zaznacz wszystko';

  @override
  String get selectionClear => 'Wyczyść zaznaczenie';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zaznaczono $countString elementu',
      many: 'Zaznaczono $countString elementów',
      few: 'Zaznaczono $countString elementy',
      one: 'Zaznaczono $countString element',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Pokaż zaznaczone';

  @override
  String get serverAccount => 'E-mail lub nazwa użytkownika';

  @override
  String get serverAdd => 'Dodaj serwer';

  @override
  String get serverAddressInvalid =>
      'Wpisz adresy takie jak photos.example.org';

  @override
  String get serverAddresses => 'Adresy';

  @override
  String get serverAddressesHelp =>
      'Jeden w wierszu: serwer w Twojej sieci, w internecie lub przez VPN. Aplikacja używa najszybszego, który odpowiada. Albo wklej otrzymany link do ustawienia hasła.';

  @override
  String get serverCa => 'Certyfikat prywatnego CA (PEM)';

  @override
  String get serverCaChoose => 'Wybierz plik certyfikatu';

  @override
  String serverCertificateBody(String host) {
    return '$host przedstawia certyfikat, któremu to urządzenie nie ufa. Zaufaj mu tylko wtedy, gdy ten odcisk SHA-256 należy do Twojego serwera:';
  }

  @override
  String get serverCertificateTitle => 'Zaufać temu certyfikatowi?';

  @override
  String get serverConfirm => 'Potwierdź';

  @override
  String get serverConnect => 'Połącz';

  @override
  String get serverCreateAdmin => 'Utwórz administratora';

  @override
  String get serverEnded => 'Serwer zakończył tę sesję. Zaloguj się ponownie.';

  @override
  String get serverHandleHelp =>
      'Małe litery, cyfry, kropki, myślniki i podkreślenia; nigdy się nie zmienia.';

  @override
  String get serverHeaders => 'Własne nagłówki';

  @override
  String get serverHeadersHelp =>
      'Jeden w wierszu jako Name: value; wysyłane tylko przez HTTPS';

  @override
  String get serverHeadersInvalid => 'Zapisz każdy nagłówek jako Name: value';

  @override
  String get serverIdentity => 'Certyfikat klienta (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Wybierz certyfikat klienta';

  @override
  String get serverIdentityInvalid =>
      'To nie jest certyfikat (PKCS#12) albo jego hasło jest błędne.';

  @override
  String get serverIdentityPassword => 'Hasło certyfikatu klienta';

  @override
  String get serverLoading =>
      'Odczytywanie serwera zapisanego na tym urządzeniu';

  @override
  String get serverNearby => 'Serwery w tej sieci';

  @override
  String get serverNeedsHttps =>
      'Ten serwer wymaga adresu HTTPS: poza siecią lokalną Photolib nie loguje się przez zwykłe HTTP.';

  @override
  String get serverNoSignIn =>
      'Ten serwer nie oferuje logowania obsługiwanego przez tę wersję Photolib.';

  @override
  String get serverOffline => 'Serwer nie odpowiada. Pozostajesz zalogowany.';

  @override
  String get serverPasskeyFailed =>
      'Nie użyto klucza dostępu. Spróbuj ponownie lub użyj kodu.';

  @override
  String get serverPasskeyRequired =>
      'Ten serwer wymaga klucza dostępu, którego ta wersja Photolib nie umie jeszcze używać.';

  @override
  String get serverPassword => 'Hasło';

  @override
  String get serverPasswordAgain => 'Powtórz hasło';

  @override
  String get serverPasswordSetupInvalid =>
      'Ten token ustawienia hasła jest błędny, został już użyty lub wygasł. Poproś o nowy.';

  @override
  String get serverPasswordSetupToken => 'Token ustawienia hasła';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Od administratora albo wypisany przez photolibd admin password-setup na serwerze.';

  @override
  String get serverPasswordsDiffer => 'Hasła się różnią.';

  @override
  String get serverPrivateLibrariesBody =>
      'Nowe hasło ich nie otwiera. Otwórz je ponownie zestawem odzyskiwania, kluczem dostępu albo urządzeniem, na którym nadal jesteś zalogowany.';

  @override
  String get serverPrivateLibrariesGo => 'Ustaw hasło';

  @override
  String get serverPrivateLibrariesTitle =>
      'Twoje prywatne biblioteki pozostają zablokowane';

  @override
  String get serverProxy => 'Serwer proxy HTTP jako host:port';

  @override
  String get serverProxyInvalid => 'Wpisz serwer proxy jako host:port';

  @override
  String get serverRecoveryCode => 'Kod odzyskiwania';

  @override
  String get serverRemove => 'Usuń ten serwer';

  @override
  String get serverRequired => 'Wymagane';

  @override
  String get serverSecondFactor =>
      'Drugim składnikiem tego konta jest klucz dostępu, którego ta wersja Photolib nie umie jeszcze używać.';

  @override
  String get serverSecondFactorCode =>
      'To konto wymaga też kodu z aplikacji uwierzytelniającej lub kodu odzyskiwania.';

  @override
  String get serverSecondFactorTitle => 'Potwierdź, że to Ty';

  @override
  String get serverSecondFactorWrong =>
      'To nie zadziałało. Po pięciu próbach zaloguj się ponownie.';

  @override
  String get serverSetPassword => 'Ustaw hasło';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Dla $handle na $server';
  }

  @override
  String get serverSetPasswordOpen => 'Ustaw hasło';

  @override
  String get serverSetPasswordTitle => 'Ustaw hasło';

  @override
  String get serverSetUp => 'Skonfiguruj nowy serwer';

  @override
  String get serverSetupLinkElsewhere =>
      'Aby użyć tego linku, najpierw wyloguj się z tego serwera albo usuń go, jeśli link dotyczy innego.';

  @override
  String get serverSetupTitle => 'Konfiguracja serwera';

  @override
  String get serverSetupToken => 'Token konfiguracji';

  @override
  String get serverSetupTokenHelp =>
      'photolibd zapisuje go w dzienniku, dopóki serwer nie ma administratora; każde uruchomienie zapisuje nowy.';

  @override
  String get serverSignIn => 'Zaloguj się';

  @override
  String get serverSignOut => 'Wyloguj się';

  @override
  String serverSignedInAs(String account) {
    return 'Zalogowano jako $account';
  }

  @override
  String get serverSignedOut => 'Wylogowano';

  @override
  String get serverSwitch => 'Przełącz konto';

  @override
  String get serverTotpCode => 'Kod z aplikacji uwierzytelniającej';

  @override
  String get serverTrust => 'Zaufaj';

  @override
  String get serverUnreadable =>
      'Nie można odczytać serwera zapisanego na tym urządzeniu';

  @override
  String get serverUsePasskey => 'Użyj klucza dostępu';

  @override
  String get serverUseRecoveryCode => 'Użyj zamiast tego kodu odzyskiwania';

  @override
  String get settingsBackground => 'Za przezroczystymi obrazami';

  @override
  String get settingsDefaultTab => 'Foldery i albumy otwierają się na karcie';

  @override
  String get settingsFolders => 'Foldery';

  @override
  String get settingsIndexing => 'Indeksowanie na tym urządzeniu';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsLibrary => 'Biblioteka';

  @override
  String get settingsServer => 'Serwer';

  @override
  String get settingsStart => 'Ekran startowy';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Dotknij lewej lub prawej krawędzi, aby przejść do poprzedniego lub następnego elementu',
      'oneFingerZoom':
          'Dotknij dwukrotnie i przeciągnij, aby powiększać jednym palcem',
      'swipes': 'Przesuń w górę lub w dół po lewej stronie filmu, aby zmienić jasność, po prawej — głośność',
      'maxBrightness': 'Pełna jasność podczas przeglądania',
      'autoRotate': 'Obracaj zgodnie z orientacją każdego zdjęcia lub filmu',
      'mixAudio':
          'Odtwarzaj filmy razem z innym dźwiękiem zamiast go wstrzymywać',
      'autoplay': 'Odtwarzaj filmy po otwarciu',
      'loop': 'Zapętlaj filmy',
      'autoNext': 'Po zakończeniu filmu przejdź do następnego elementu',
      'resume': 'Wznawiaj filmy tam, gdzie zostały przerwane',
      'other': 'Odtwarzaj animowane obrazy w siatce',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'Przyciski na pasku przeglądarki';

  @override
  String get settingsViewing => 'Przeglądanie';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString udostępnionego elementu czeka, aż Photolib będzie mógł dodać je do Twojej biblioteki zdjęć. Niezapisane elementy są usuwane po 7 dniach.',
      many:
          '$countString udostępnionych elementów czeka, aż Photolib będzie mógł dodać je do Twojej biblioteki zdjęć. Niezapisane elementy są usuwane po 7 dniach.',
      few:
          '$countString udostępnione elementy czekają, aż Photolib będzie mógł dodać je do Twojej biblioteki zdjęć. Niezapisane elementy są usuwane po 7 dniach.',
      one:
          '$countString udostępniony element czeka, aż Photolib będzie mógł dodać go do Twojej biblioteki zdjęć. Niezapisane elementy są usuwane po 7 dniach.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Za duże, by udostępnić naraz: zaznacz mniej elementów';

  @override
  String shareTooMany(int count) {
    return 'Za dużo, by udostępnić naraz: zaznacz najwyżej $count';
  }

  @override
  String get shortcutsTitle => 'Skróty klawiszowe';

  @override
  String get slideshow => 'Pokaz slajdów';

  @override
  String get slideshowLoop => 'Powtarzaj';

  @override
  String get slideshowOptions => 'Opcje pokazu slajdów';

  @override
  String get slideshowSeconds => 'Sekundy na element';

  @override
  String get slideshowShuffle => 'Losowa kolejność';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Malejąco',
      'other': 'Rosnąco',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'To urządzenie';

  @override
  String sourceHide(String name) {
    return 'Ukryj $name';
  }

  @override
  String get sourceHideOthers => 'Ukryj wszystko inne tutaj';

  @override
  String get sourceLost => 'Brak dostępu';

  @override
  String get sourcePartly => 'Częściowo pokazany';

  @override
  String sourceShow(String name) {
    return 'Pokaż $name';
  }

  @override
  String get sourceShowEverything => 'Pokaż wszystko tutaj';

  @override
  String get sourceShowOnly => 'Pokaż tylko to';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Oś czasu',
      'folders': 'Foldery i albumy',
      'favourites': 'Ulubione',
      'other': 'Oś czasu',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Zachowaj osobę offline';

  @override
  String get storageBudget => 'Limit miejsca';

  @override
  String get storageClear => 'Usuń kopie offline';

  @override
  String get storageClearAction => 'Usuń';

  @override
  String storageClearBody(String size) {
    return 'Usunięte zostanie $size zachowane na tym urządzeniu, a albumy, wyszukiwania i zdjęcia przestaną być zachowywane offline. Twoja biblioteka na serwerze pozostaje nietknięta.';
  }

  @override
  String get storageKeepLibrary => 'Zachowaj całą bibliotekę';

  @override
  String get storageKeepOriginals => 'Zachowaj też oryginały';

  @override
  String get storageNoPeople => 'Żadna osoba nie ma jeszcze nazwy.';

  @override
  String get storageNoPins =>
      'Nic nie jest przypięte. Przypnij album, wyszukiwanie lub zdjęcie, aby zachować je offline.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Wyszukiwanie',
      'person': 'Osoba',
      'library': 'Cała biblioteka',
      'asset': 'Zdjęcie',
      'other': 'Przypięte',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Nie mieści się w limicie: brakuje $size';
  }

  @override
  String get storagePinNothing =>
      'Nic do pobrania: zdjęcia są już na tym urządzeniu';

  @override
  String get storagePinPaused =>
      'Oczekiwanie: to ustawienie nie zachowuje nic offline';

  @override
  String get storagePinPlanning => 'Sprawdzanie, co zachować…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Pobieranie: $haveString z $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Dostępne offline ($size)';
  }

  @override
  String get storagePinWaiting => 'Zostanie pobrane po połączeniu z siecią';

  @override
  String get storagePins => 'Zachowane offline';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Tylko katalog',
      'spaceSaver': 'Oszczędzanie miejsca',
      'travel': 'Wybrane albumy offline',
      'everything': 'Wszystko',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Nie zachowuje nic; zdjęcia ładują się z Twojego serwera po otwarciu.',
      'spaceSaver': 'Zachowuje podglądy całej biblioteki, od najnowszych, w granicach limitu.',
      'travel':
          'Zachowuje tylko to, co przypniesz: albumy, wyszukiwania i zdjęcia.',
      'everything': 'Zachowuje oryginały całej biblioteki, od najnowszych, w granicach limitu.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Co zachowuje to urządzenie';

  @override
  String get storageSubtitle => 'Kopie offline i limit miejsca';

  @override
  String get storageTitle => 'Pamięć';

  @override
  String storageUsed(String used, String budget) {
    return 'Użyto $used z $budget';
  }

  @override
  String get storageWebNote =>
      'Przeglądarka zachowuje tylko podglądy i usuwa je po wylogowaniu.';

  @override
  String get storeNoKeyring =>
      'Photolib przechowuje klucz swojego lokalnego magazynu w systemowym pęku kluczy, który nie odpowiedział. Zainstaluj i odblokuj gnome-keyring, KWallet lub KeePassXC z włączoną usługą Secret Service, a potem spróbuj ponownie.';

  @override
  String get storeNoKeystore =>
      'Photolib nie mógł połączyć się z magazynem kluczy tego urządzenia, w którym jest klucz jego lokalnego magazynu.';

  @override
  String get storeRebuilt =>
      'Magazyn kluczy tego urządzenia nie miał już klucza lokalnego magazynu Photolib, więc magazyn został odbudowany. Jego ustawienia i to, co istniało tylko na tym urządzeniu, zostały utracone; biblioteki synchronizują się ponownie, a miniatury wrócą.';

  @override
  String get storeRecoveryNeeded =>
      'Magazyn kluczy tego urządzenia nie ma już klucza lokalnego magazynu Photolib. Wpisz kod odzyskiwania albo zresetuj magazyn i utrać to, co istnieje tylko na tym urządzeniu.';

  @override
  String get storeReset => 'Zresetuj magazyn';

  @override
  String get storeResetBody =>
      'To, co istnieje tylko na tym urządzeniu, zostanie utracone; biblioteki synchronizują się ponownie, a miniatury wrócą.';

  @override
  String get storeUnavailable =>
      'Magazyn na tym urządzeniu jest niedostępny: ustawienia i kolekcje nie są zachowywane';

  @override
  String get tabCollections => 'Kolekcje';

  @override
  String get tabLibrary => 'Biblioteka';

  @override
  String get tabSearch => 'Szukaj';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get timelineBenchmark => 'Test wydajności osi czasu';

  @override
  String get timelineBenchmarkCopy => 'Skopiuj wyniki';

  @override
  String get timelineCannotPlay => 'Nie można odtworzyć w tej przeglądarce';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position z $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position z $count, brak podglądu';
  }

  @override
  String get timelineExcluded => 'W wykluczonym folderze';

  @override
  String get timelineScrubber => 'Przewijanie według dat';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Nieznana data';

  @override
  String timelineWeek(String date) {
    return 'Tydzień od $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Dodaj $action do paska';
  }

  @override
  String toolbarDown(String action) {
    return 'Przesuń $action w dół';
  }

  @override
  String get toolbarInBar => 'Na pasku';

  @override
  String get toolbarInMenu => 'W menu ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Usuń $action z paska';
  }

  @override
  String get toolbarReset => 'Przywróć domyślne';

  @override
  String toolbarUp(String action) {
    return 'Przesuń $action w górę';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Przenieś tutaj',
      'other': 'Kopiuj tutaj',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Plik lub folder o tej nazwie już tam jest',
      'changed': 'Kopia nie zgadzała się z oryginałem i została usunięta',
      'cancelled': 'Anulowano',
      'invalid': 'Nieprawidłowa nazwa folderu',
      'other': 'Niepowodzenie',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Ostatnie';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usunąć $countString elementu na zawsze? Tego nie można cofnąć.',
      many: 'Usunąć $countString elementów na zawsze? Tego nie można cofnąć.',
      few: 'Usunąć $countString elementy na zawsze? Tego nie można cofnąć.',
      one: 'Usunąć $countString element na zawsze? Tego nie można cofnąć.',
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
      other: 'Zostało $daysString dnia',
      many: 'Zostało $daysString dni',
      few: 'Zostały $daysString dni',
      one: 'Został $daysString dzień',
      zero: 'Zostanie usunięty dzisiaj',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Kosz jest pusty';

  @override
  String get trashEmptyAll => 'Opróżnij kosz';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przeniesiono $countString elementu do kosza',
      many: 'Przeniesiono $countString elementów do kosza',
      few: 'Przeniesiono $countString elementy do kosza',
      one: 'Przeniesiono $countString element do kosza',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib usuwa na zawsze to, co trzyma w koszu, po $days dniach; każdy element pokazuje, ile czasu mu zostało.';
  }

  @override
  String get trashTitle => 'Kosz';

  @override
  String get undo => 'Cofnij';

  @override
  String get uploadAction => 'Prześlij zdjęcia i filmy';

  @override
  String get uploadClear => 'Wyczyść';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Przesłano $doneString z $totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Niepowodzenia: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zarchiwizowano $countString elementu',
      many: 'Zarchiwizowano $countString elementów',
      few: 'Zarchiwizowano $countString elementy',
      one: 'Zarchiwizowano $countString element',
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
      other: 'Ukryto $countString elementu',
      many: 'Ukryto $countString elementów',
      few: 'Ukryto $countString elementy',
      one: 'Ukryto $countString element',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Czarne',
      'white': 'Białe',
      'other': 'Szachownica',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Tego filmu nie można odtworzyć na tym urządzeniu';

  @override
  String get viewerCaptions => 'Napisy';

  @override
  String get viewerCompass => 'Blokada kompasu';

  @override
  String get viewerCopy => 'Kopiuj';

  @override
  String get viewerCopyText => 'Kopiuj tekst';

  @override
  String get viewerCustomize => 'Dostosuj pasek narzędzi…';

  @override
  String get viewerDial =>
      'Kierunek. Kliknij, aby patrzeć na wprost. Przeciągnij, aby się rozejrzeć, przewiń lub zsuń palce, aby powiększyć, kliknij dwukrotnie, aby zresetować';

  @override
  String get viewerFilmstrip => 'Pasek miniatur';

  @override
  String get viewerFirst => 'Pierwsze';

  @override
  String get viewerFisheye => 'Rybie oko';

  @override
  String get viewerGyroscope => 'Poruszaj, aby się rozejrzeć';

  @override
  String get viewerHdr => 'Pokaż w HDR';

  @override
  String get viewerInfo => 'Informacje';

  @override
  String get viewerInfoLoading => 'Wczytywanie informacji o tym elemencie';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString z $countString';
  }

  @override
  String get viewerLast => 'Ostatnie';

  @override
  String get viewerLenses => 'Wybierz obiektyw';

  @override
  String get viewerMap => 'Mapa';

  @override
  String get viewerMotion => 'Odtwórz ruch';

  @override
  String get viewerMotionDenied =>
      'Ta przeglądarka nie zezwoliła na dostęp do czujników ruchu';

  @override
  String get viewerMotionMissing =>
      'To urządzenie nie ma żyroskopu, aby się rozejrzeć';

  @override
  String get viewerMute => 'Wycisz';

  @override
  String get viewerNext => 'Następne';

  @override
  String get viewerNextFrame => 'Następna klatka';

  @override
  String get viewerPause => 'Wstrzymaj';

  @override
  String get viewerPlanet => 'Mała planeta';

  @override
  String get viewerPlay => 'Odtwórz';

  @override
  String get viewerPrevious => 'Poprzednie';

  @override
  String get viewerPreviousFrame => 'Poprzednia klatka';

  @override
  String get viewerRotate => 'Obróć';

  @override
  String get viewerSdr => 'Pokaż w SDR';

  @override
  String get viewerSeek => 'Pozycja';

  @override
  String get viewerSetAs => 'Ustaw jako';

  @override
  String get viewerShare => 'Udostępnij';

  @override
  String get viewerSpeed => 'Szybkość odtwarzania';

  @override
  String get viewerSphere =>
      'Widok 360°. Przeciągnij, aby się rozejrzeć, uszczypnij, aby powiększyć';

  @override
  String get viewerText => 'Tekst na tym zdjęciu';

  @override
  String get viewerTextCopied => 'Skopiowano tekst';

  @override
  String get viewerTextNone => 'Nie znaleziono tekstu na tym zdjęciu';

  @override
  String get viewerTextUnread =>
      'Tekst z tego zdjęcia nie został jeszcze odczytany';

  @override
  String get viewerUnmute => 'Wyłącz wyciszenie';

  @override
  String get viewerZoomIn => 'Powiększ';

  @override
  String get viewerZoomOut => 'Pomniejsz';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'Karta SD',
      'other': 'Pamięć wewnętrzna',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Powiększ';

  @override
  String get zoomOut => 'Pomniejsz';
}
