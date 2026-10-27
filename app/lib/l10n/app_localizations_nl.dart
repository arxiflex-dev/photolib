// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get actionAddToAlbum => 'Toevoegen aan album';

  @override
  String get actionArchive => 'Archiveren';

  @override
  String get actionCopyTo => 'Kopiëren naar…';

  @override
  String get actionDeleteForever => 'Definitief verwijderen';

  @override
  String get actionFavourite => 'Markeren als favoriet';

  @override
  String get actionHide => 'Verbergen';

  @override
  String get actionMoveTo => 'Verplaatsen naar…';

  @override
  String get actionRename => 'Naam wijzigen';

  @override
  String get actionRestore => 'Terugzetten';

  @override
  String get actionShare => 'Delen';

  @override
  String get actionTrash => 'Verplaatsen naar prullenbak';

  @override
  String get actionUnarchive => 'Uit archief halen';

  @override
  String get actionUndo => 'Ongedaan maken';

  @override
  String get actionUnfavourite => 'Verwijderen uit favorieten';

  @override
  String get actionUnhide => 'Zichtbaar maken';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Actief',
      'disabled': 'Uitgeschakeld',
      'invited': 'Uitgenodigd',
      'deleted': 'Verwijderd',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Accounts';

  @override
  String get adminAddAccount => 'Account toevoegen';

  @override
  String get adminAddExternalLibrary => 'Externe bibliotheek toevoegen';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts pogingen',
      one: '1 poging',
      zero: 'nog niet uitgevoerd',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Auditlogboek';

  @override
  String get adminBackUpNow => 'Nu back-up maken';

  @override
  String get adminBackupQueued =>
      'De back-up staat in de wachtrij; een hersteloefening volgt';

  @override
  String get adminBackups => 'Databaseback-ups';

  @override
  String get adminCancelJob => 'Taak annuleren';

  @override
  String get adminCapabilities => 'Functies';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Beheerde bibliotheken',
      'uploads': 'Uploads van apparaten, het web en de CLI',
      'folder_browser': 'Mappenweergave',
      'device_folders': 'Apparaatmappen in verbonden apps',
      'sharing': 'Delen en openbare links',
      'edits': 'Bewerkingen',
      'deletes': 'Verwijderingen',
      'xmp_writes': 'XMP-sidecars schrijven',
      'face_recognition': 'Gezichtsherkenning',
      'ml_search': 'Slim zoeken',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Waarschuwing',
      'fail': 'Mislukt',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Gekopieerd';

  @override
  String get adminCopyBundle => 'Diagnosegegevens kopiëren voor een bugrapport';

  @override
  String get adminCopyLink => 'Link kopiëren';

  @override
  String get adminDelete => 'Verwijderen';

  @override
  String get adminDeviceBackups => 'Back-ups van apparaten';

  @override
  String get adminDevices => 'Je apparaten';

  @override
  String get adminDisable => 'Uitschakelen';

  @override
  String adminDrillFailed(String detail) {
    return 'De laatste hersteloefening is mislukt: $detail';
  }

  @override
  String get adminEdit => 'Bewerken';

  @override
  String get adminEmail => 'E-mail';

  @override
  String get adminEnable => 'Inschakelen';

  @override
  String get adminErrorSignIn => 'Log in als beheerder';

  @override
  String get adminFacesDefault =>
      'Gezichtsherkenning staat standaard aan voor nieuwe accounts';

  @override
  String get adminFiles => 'Bestanden per soort';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Beschadigd',
      'missing': 'Ontbreekt',
      'size': 'Verkeerde grootte',
      'hash': 'Vervangen',
      'orphan': 'Los bestand',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size vrij';
  }

  @override
  String get adminFreeDisk =>
      'Uploads pauzeren als de vrije schijfruimte onder deze waarde komt, in procenten, 0 tot en met 50';

  @override
  String get adminFreeDiskGb =>
      'of onder deze vrije ruimte in GB, als die kleiner is, 0 tot en met 100000';

  @override
  String get adminHandle => 'Inlognaam';

  @override
  String get adminIntegrity => 'Integriteit';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'In wachtrij',
      'running': 'Bezig',
      'done': 'Klaar',
      'dead': 'Mislukt',
      'cancelled': 'Geannuleerd',
      'other': 'Alle',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Taaktype, zoals render';

  @override
  String get adminJobs => 'Taken';

  @override
  String adminLastSeen(String time) {
    return 'Laatst gezien $time';
  }

  @override
  String get adminLibraries => 'Bibliotheken';

  @override
  String get adminLibraryOwner => 'Eigenaar';

  @override
  String get adminLibraryRoot => 'Map op de server, zoals /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Online',
      'offline': 'Offline',
      'scanning': 'Scannen',
      'error': 'Fout',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Serverlogboek';

  @override
  String get adminName => 'Naam';

  @override
  String get adminNothing => 'Nog niets hier';

  @override
  String get adminOutOfRange => 'Buiten het toegestane bereik';

  @override
  String get adminOverview => 'Overzicht';

  @override
  String get adminPair => 'Een apparaat koppelen';

  @override
  String get adminPairBody =>
      'Scan deze code of stuur de link en plak die op het nieuwe apparaat in Photolib bij Server toevoegen: hij brengt alle adressen van deze server en zijn certificaat mee, zodat niemand ze hoeft te typen.';

  @override
  String get adminPasswordSetup => 'Link om een wachtwoord in te stellen';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Stuur deze link op welke manier ook naar $name, of laat de code scannen. Hij stelt één keer een wachtwoord in, tot $date.';
  }

  @override
  String get adminPause => 'Een taaktype pauzeren';

  @override
  String adminPauseMinutes(int max) {
    return 'Minuten, 1 tot en met $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type is gepauzeerd tot $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nog $countString items te back-uppen',
      one: 'Nog 1 item te back-uppen',
      zero: 'Niets meer te back-uppen',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Beleid';

  @override
  String get adminPolicyReset => 'Waarde van het bredere niveau gebruiken';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Standaard aan',
      'server': 'Ingesteld voor de server',
      'user': 'Ingesteld voor dit account',
      'library': 'Ingesteld voor deze bibliotheek',
      'config': 'Ingesteld in de configuratie',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Voorinstelling toepassen';

  @override
  String get adminPresetBody =>
      'Een voorinstelling stelt elke functie voor de server in en wist wat accounts en bibliotheken hebben ingesteld. Alles blijft aanpasbaar.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Archiefweergave',
      'family_backup': 'Gezinsback-up',
      'personal': 'Persoonlijk',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'De externe alleen-lezen bibliotheken zijn de enige bron van waarheid: geen uploads, beheerde bibliotheken, apparaatmappen, bewerkingen, verwijderingen of XMP-schrijfacties',
      'family_backup': 'Alles aan behalve XMP-schrijfacties',
      'personal': 'Alles aan behalve delen en openbare links',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'QR-code van de link';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString taken in wachtrij',
      one: '1 taak in wachtrij',
      zero: 'Niets te doen',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'Opslagquotum in GB; leeg voor onbeperkt';

  @override
  String get adminRemote => 'Toegang op afstand';

  @override
  String get adminRemoteBody =>
      'Bereik de server overal zonder een poort op je router te openen. Kies een manier; elk geeft hem een HTTPS-adres voor de apps. Test het daarna van buitenaf.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared maakt zelf verbinding met Cloudflare, dat je domein via HTTPS aanbiedt. Het gratis abonnement beperkt een verzoek tot 100 MB, wat back-ups nooit halen: ze sturen 8 MiB per keer.';

  @override
  String get adminRemoteNoAddress =>
      'Voeg het adres van de server met https:// aan deze app toe om het van buitenaf te testen.';

  @override
  String get adminRemoteReachable => 'Van buitenaf bereikbaar.';

  @override
  String get adminRemoteTailscale =>
      'Installeer Tailscale op de computer van de server en op elk apparaat, in hetzelfde tailnet of je Headscale, voer dit dan uit op de computer van de server en zet public_url op het adres dat het toont.';

  @override
  String get adminRemoteTest => 'Van buitenaf testen';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host opent $url vanaf zijn servers wereldwijd en leert zo dit adres. Doorgaan?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Van buitenaf niet bereikbaar: controleer de gekozen manier en test opnieuw.';

  @override
  String get adminRemoteWireguard =>
      'Vereist één open UDP-poort aan de kant van de server of op een centraal knooppunt. Dit is de configuratie voor een apparaat; maak sleutels met wg genkey.';

  @override
  String get adminRepair =>
      'Zet het terug uit een back-up of van een apparaat dat het nog heeft';

  @override
  String get adminRepairOrphan =>
      'Geen foto verwijst ernaar: controleer het en verwijder of bewaar het dan';

  @override
  String get adminReprocess => 'Opnieuw verwerken';

  @override
  String get adminReprocessFaces => 'Gezichten opnieuw detecteren';

  @override
  String get adminReprocessFolder =>
      'Map, zoals 2024/05; leeg voor de hele bibliotheek';

  @override
  String get adminReprocessMetadata => 'Metagegevens opnieuw lezen';

  @override
  String get adminReprocessRenditions =>
      'Miniaturen en voorvertoningen opnieuw genereren';

  @override
  String get adminRestore => 'Herstellen';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Het herstel van $name is mislukt: $detail';
  }

  @override
  String get adminRestoreUnverified => 'Nog geen hersteloefening geslaagd';

  @override
  String adminRestoreVerified(String when) {
    return 'Laatst gecontroleerd herstel: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd stopt en vervangt bij de volgende start de hele database door $name. Wat sindsdien is veranderd, gaat verloren, en elk apparaat synchroniseert opnieuw vanaf het begin.';
  }

  @override
  String get adminRestoring => 'photolibd stopt om de back-up te herstellen';

  @override
  String get adminResume => 'Hervatten';

  @override
  String get adminRetry => 'Opnieuw proberen';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Beheerder',
      'user': 'Gebruiker',
      'viewer': 'Kijker',
      'other': 'Onbekend',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Opgeslagen';

  @override
  String get adminScan => 'Nu scannen';

  @override
  String get adminScrubDays =>
      'Dagen waarin de controle elk origineel nakijkt, 1 tot 3650';

  @override
  String get adminScrubNever => 'Eerste volledige controle bezig';

  @override
  String adminScrubbed(String time) {
    return 'Laatste volledige controle $time';
  }

  @override
  String get adminSecondAdmin =>
      'Maak een tweede persoon beheerder, zodat iemand anders de server kan beheren en herstellen als jij dat niet kunt.';

  @override
  String adminSilent(String time) {
    return 'Stil sinds $time';
  }

  @override
  String get adminSilentHours =>
      'Uren zonder melding voordat de back-up van een apparaat stil is, 1 tot 8760';

  @override
  String get adminStores => 'Opslag';

  @override
  String get adminThisDevice => 'Dit apparaat';

  @override
  String get adminTitle => 'Serverbeheer';

  @override
  String get adminTrashDays => 'Dagen in prullenbak, 1 tot en met 3650';

  @override
  String get adminTwoFactor =>
      'Alle accounts moeten een tweede factor instellen';

  @override
  String get adminUsage => 'Gebruik per account';

  @override
  String get albumCover => 'Als omslag gebruiken';

  @override
  String get albumEmpty => 'Dit album is leeg';

  @override
  String get albumHideMemories => 'Verbergen in herinneringen';

  @override
  String get albumHideTimeline => 'Verbergen op de tijdlijn';

  @override
  String get albumNew => 'Nieuw album';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Elke datum';

  @override
  String get backupCap => 'Grootste item';

  @override
  String get backupCharging => 'Alleen tijdens opladen';

  @override
  String backupCompleted(String time) {
    return 'Laatste volledige back-up: $time';
  }

  @override
  String backupContact(String time) {
    return 'Laatste contact met de server: $time';
  }

  @override
  String get backupEnabled => 'Een back-up maken van dit apparaat';

  @override
  String get backupFolderNo => 'Deze niet';

  @override
  String get backupFolderYes => 'Back-up maken';

  @override
  String backupHours(int count) {
    return '$count u';
  }

  @override
  String get backupMetered =>
      'Op netwerken met datalimiet, zoals mobiele data of een hotspot';

  @override
  String get backupNever => 'Nog geen volledige back-up';

  @override
  String backupNewFolder(String name) {
    return 'Nieuwe map $name: back-up maken?';
  }

  @override
  String get backupNoLimit => 'Geen limiet';

  @override
  String get backupNothing => 'Er wacht niets';

  @override
  String get backupNow => 'Nu back-up maken';

  @override
  String backupOverdue(int hours, String items) {
    return 'Al $hours u geen volledige back-up. Wachtend: $items';
  }

  @override
  String get backupOverdueTitle => 'De back-up is niet voltooid';

  @override
  String backupPending(String items) {
    return 'Wachtend: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Nieuwe poging: $time';
  }

  @override
  String get backupRoaming => 'Back-up maken tijdens roaming';

  @override
  String get backupSignIn =>
      'Meld je aan bij een server om een back-up van dit apparaat te maken';

  @override
  String get backupSignedOut =>
      'Back-up gestopt: de server heeft dit apparaat afgemeld. Meld je opnieuw aan in Instellingen.';

  @override
  String get backupSince => 'Gemaakt sinds';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'De back-up wacht tot de server bereikbaar is',
      'charging': 'De back-up wacht tot het apparaat oplaadt',
      'battery_low': 'De back-up wacht: de batterij is bijna leeg',
      'roaming': 'De back-up wacht tijdens roaming',
      'quota': 'Back-up gestopt: je opslag op de server is vol',
      'second_factor': 'Back-up gestopt: de server vraagt een tweede factor voor dit account',
      'other': 'Back-up gestopt: de server antwoordde $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Back-up';

  @override
  String get backupWaiting => 'Geen back-up';

  @override
  String get backupWarnAfter => 'Waarschuwen als onvolledig na';

  @override
  String get backupWhat => 'Waarvan een back-up maken';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'In een map die je niet hebt gekozen',
      'folder_new': 'In een nieuwe map: kies of er een back-up van komt',
      'type_excluded': 'Een soort item dat je niet hebt gekozen',
      'before_date': 'Gemaakt vóór de gekozen datum',
      'selected': 'Wacht op zijn beurt',
      'server_restored':
          'De server verloor het bij een herstel: wordt opnieuw verzonden',
      'working': 'Back-up bezig',
      'waiting_for_icloud': 'Wacht tot iCloud het downloadt',
      'metered': 'Wacht op een netwerk zonder datalimiet',
      'metered_cap': 'Te groot voor een netwerk met datalimiet',
      'unreadable': 'Dit apparaat kan het niet lezen',
      'changed': 'Het veranderde tijdens het verzenden',
      'quota': 'Je opslag op de server is vol',
      'other': 'De server weigerde het: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'De server werkt niet meer met deze versie van Photolib.';

  @override
  String get checkAppTooOldNext => 'Werk Photolib bij.';

  @override
  String get checkChanged =>
      'Het certificaat van de server is niet het certificaat dat je hebt vertrouwd.';

  @override
  String get checkChangedNext =>
      'Heeft je beheerder het vervangen, vertrouw dan het nieuwe. Zo niet, dan luistert misschien iemand mee: ga niet verder.';

  @override
  String get checkClock =>
      'De klok van dit apparaat en die van de server verschillen meer dan vijf minuten.';

  @override
  String get checkClockNext =>
      'Laat je apparaat datum en tijd automatisch instellen.';

  @override
  String get checkDnsFailed =>
      'De naam van de server leidt niet naar een adres.';

  @override
  String get checkDnsFailedNext =>
      'Controleer het adres of maak verbinding met het netwerk van de server.';

  @override
  String checkExpired(String date) {
    return 'Het certificaat van de server is op $date verlopen.';
  }

  @override
  String get checkFailed => 'Mislukt';

  @override
  String get checkMetered =>
      'Je zit op een netwerk met datalimiet, zoals mobiele data.';

  @override
  String get checkMeteredNext =>
      'Maak verbinding met wifi voor grote back-ups.';

  @override
  String get checkNotPhotolib =>
      'Er antwoordt iets anders dan Photolib, zoals de foutpagina van een proxy of een wifi-inlogpagina.';

  @override
  String get checkNotPhotolibNext =>
      'Log in je browser in op de wifi of vraag je beheerder de proxy te controleren.';

  @override
  String get checkOtherServer =>
      'Op dit adres antwoordt een andere Photolib-server.';

  @override
  String get checkPassed => 'Geslaagd';

  @override
  String get checkRefused => 'Op dit adres antwoordt niets.';

  @override
  String get checkRefusedNext =>
      'Controleer of de server draait en of je op zijn netwerk of vpn zit.';

  @override
  String get checkRun => 'Verbinding controleren';

  @override
  String get checkRunning => 'Bezig met controleren';

  @override
  String get checkSelfSigned =>
      'De server gebruikt een eigen certificaat dat dit apparaat nog niet kent.';

  @override
  String get checkSkipped => 'Niet gecontroleerd';

  @override
  String get checkStepAuth => 'Je aanmelding';

  @override
  String get checkStepClock => 'De klok van je apparaat';

  @override
  String get checkStepDns => 'Het adres van de server vinden';

  @override
  String get checkStepNetwork => 'Je netwerk';

  @override
  String get checkStepServer => 'Photolib op de server';

  @override
  String get checkStepTcp => 'De server bereiken';

  @override
  String get checkStepTls => 'Beveiligde verbinding en certificaat';

  @override
  String get checkStepUpload => 'Grote uploads via proxy\'s';

  @override
  String get checkTimedOut =>
      'De server doet er te lang over om te antwoorden.';

  @override
  String get checkTimedOutNext =>
      'Controleer je verbinding en probeer het opnieuw.';

  @override
  String get checkTitle => 'Verbindingscontrole';

  @override
  String get checkTlsFailed => 'De beveiligde verbinding is mislukt.';

  @override
  String get checkTrustNext =>
      'Vertrouw het alleen als de vingerafdruk overeenkomt met die van je server.';

  @override
  String get checkUntrusted =>
      'Het certificaat van de server komt van een instantie die dit apparaat niet vertrouwt.';

  @override
  String get checkUploadCap =>
      'Een proxy onderweg weigert grote uploads, dus back-ups gaan langzamer, in kleine stukken.';

  @override
  String get checkUploadCapNext =>
      'Vraag je beheerder om verzoeken van 64 MB door de proxy toe te laten.';

  @override
  String get collectionAlbums => 'Albums';

  @override
  String collectionHide(String name) {
    return '$name verbergen';
  }

  @override
  String collectionMoveDown(String name) {
    return '$name omlaag verplaatsen';
  }

  @override
  String collectionMoveUp(String name) {
    return '$name omhoog verplaatsen';
  }

  @override
  String get collectionPeople => 'Personen';

  @override
  String collectionPin(String name) {
    return '$name vastzetten';
  }

  @override
  String get collectionPlaces => 'Plaatsen';

  @override
  String collectionShow(String name) {
    return '$name tonen';
  }

  @override
  String get collectionTags => 'Tags';

  @override
  String collectionUnpin(String name) {
    return '$name losmaken';
  }

  @override
  String get collectionsCustomise => 'Aanpassen';

  @override
  String get collectionsDone => 'Klaar';

  @override
  String get commandPalette => 'Opdrachtpalet';

  @override
  String get commandPaletteHint => 'Typ een opdracht';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString op dit apparaat en geback-upt',
      one: '$countString op dit apparaat en geback-upt',
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
      other: '$countString alleen op dit apparaat, geen back-up',
      one: '$countString alleen op dit apparaat, geen back-up',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Met iCloud-foto\'s aan verdwijnen items die je van dit apparaat verwijdert ook uit iCloud en van je andere Apple-apparaten.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString alleen in je bibliotheek',
      one: '$countString alleen in je bibliotheek',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Verwijderen van dit apparaat';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'De $countString geback-upte items; je bibliotheek bewaart ze',
      one: 'Het geback-upte item; je bibliotheek bewaart het',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Kopieën op dit apparaat gaan naar de prullenbak ervan: de ruimte komt vrij zodra die is geleegd.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items verwijderen?',
      one: '$countString item verwijderen?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Van dit apparaat en uit je bibliotheek',
      'device': 'Alleen van dit apparaat',
      'other': 'Uit je bibliotheek',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Niet aanwezig';

  @override
  String get deviceFolderCard => 'SD-kaart';

  @override
  String get deviceFolderExclude => 'Uitsluiten';

  @override
  String get deviceFolderExcludeThis => 'Deze map uitsluiten';

  @override
  String get deviceFolderExcludedNotice =>
      'De map van dit item is uitgesloten van je bibliotheek';

  @override
  String get deviceFolderForget => 'Uit de lijst verwijderen';

  @override
  String get deviceFolderInternal => 'Interne opslag';

  @override
  String get deviceFolderKeep => 'Behouden';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, is nieuw';
  }

  @override
  String get deviceFolders => 'Mappen op het apparaat';

  @override
  String get deviceFoldersAll => 'Alle mappen tonen behalve de uitgesloten';

  @override
  String get deviceFoldersChosen => 'Alleen de gekozen mappen tonen';

  @override
  String get deviceFoldersExcludedNow => 'Uitgesloten van de bibliotheek';

  @override
  String get deviceFoldersSearch => 'Mappen zoeken';

  @override
  String get diagnosticsAdvanced => 'Diagnose tonen';

  @override
  String get diagnosticsAllLoggers => 'Alle bronnen';

  @override
  String get diagnosticsCopied => 'Logboek gekopieerd';

  @override
  String get diagnosticsCopy => 'Getoond logboek kopiëren';

  @override
  String get diagnosticsEmpty => 'Nog geen logboekitems';

  @override
  String get diagnosticsExport => 'Diagnosepakket exporteren';

  @override
  String get diagnosticsExported => 'Diagnosepakket opgeslagen';

  @override
  String get diagnosticsLevel => 'Niveau';

  @override
  String get diagnosticsLogger => 'Bron';

  @override
  String get diagnosticsTitle => 'Diagnose';

  @override
  String get download => 'Downloaden';

  @override
  String get downloadCurrent => 'Huidige versie, met bewerkingen';

  @override
  String get downloadFailed => 'Downloaden mislukt';

  @override
  String get downloadOriginal => 'Origineel';

  @override
  String downloadSaved(String name) {
    return '$name opgeslagen';
  }

  @override
  String get downloadVersion => 'Welke versie?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items worden gedownload',
      one: '$countString item wordt gedownload',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Automatisch verbeteren';

  @override
  String get editorCrop => 'Bijsnijden';

  @override
  String get editorCropOriginal => 'Origineel';

  @override
  String get editorCropSquare => 'Vierkant';

  @override
  String get editorEdit => 'Bewerken';

  @override
  String get editorFlip => 'Spiegelen';

  @override
  String get editorRotate => 'Draaien';

  @override
  String get editorSaveCopy => 'Kopie opslaan';

  @override
  String get editorSaveFailed => 'Kan de kopie niet opslaan';

  @override
  String get editorSaveVersion => 'Opslaan';

  @override
  String get editorSaved => 'Opgeslagen als kopie';

  @override
  String get editorVersionFailed => 'De versie kon niet worden opgeslagen';

  @override
  String get editorVersionSaved => 'Opgeslagen als nieuwe versie';

  @override
  String get editorVersionsUnsupported =>
      'Deze server kan nog geen versies van bewerkte foto’s bewaren';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString wijzigingen zijn ongedaan gemaakt: de server heeft ze geweigerd.',
      one: '1 wijziging is ongedaan gemaakt: de server heeft die geweigerd.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Sluiten';

  @override
  String get editsRejectedForbidden =>
      'Je mag de items bekijken, maar niet wijzigen.';

  @override
  String get editsRejectedInvalid =>
      'De server kon de wijzigingen niet accepteren.';

  @override
  String get editsRejectedNotFound =>
      'De items zijn verwijderd of worden niet meer met je gedeeld.';

  @override
  String get errorNotFound => 'Deze pagina bestaat niet';

  @override
  String get errorRetry => 'Opnieuw proberen';

  @override
  String get errorTitle => 'Er is iets misgegaan';

  @override
  String faceNumber(int number) {
    return 'Gezicht $number';
  }

  @override
  String get facesAgree => 'Ik ga akkoord';

  @override
  String get facesAura =>
      'Gezichten beschrijven met AuraFace (grotere download)';

  @override
  String get facesNotNow => 'Niet nu';

  @override
  String get facesNoticeKeep =>
      'Wat wordt gevonden blijft bij je foto’s, op je apparaten en je server. De beschrijvingen worden nooit getoond of gedeeld, en alles wordt gewist als je stopt of de foto verwijdert.';

  @override
  String get facesNoticeOptional =>
      'Dit is optioneel. Al het andere in Photolib werkt ook zonder, en je kunt op elk moment stoppen in Instellingen.';

  @override
  String get facesNoticeTitle => 'Gezichten in je foto’s vinden?';

  @override
  String get facesNoticeWhat =>
      'Photolib zoekt gezichten in je foto’s en video’s en bewaart voor elk waar het zit en een lijst getallen die het beschrijft, zodat dezelfde persoon opnieuw kan worden gevonden. Zo’n beschrijving kan als biometrisch gegeven gelden.';

  @override
  String get facesNoticeWhere =>
      'Dit gebeurt op dit apparaat en, als je bent ingelogd, op je eigen server. Nooit bij een dienst van ons of van iemand anders.';

  @override
  String get facesServerFailed =>
      'Je server kon niet worden gewaarschuwd. Probeer het opnieuw.';

  @override
  String get facesServerOff => 'Je server vindt geen gezichten voor je';

  @override
  String get facesServerOn => 'Je server vindt gezichten voor je';

  @override
  String get facesServerUnavailable =>
      'Je server biedt geen gezichtsherkenning aan';

  @override
  String facesStatusDownloading(int percent) {
    return 'Gezichtsmodellen downloaden: $percent%';
  }

  @override
  String get facesStatusMissing =>
      'Je server heeft de gezichtsmodellen niet geïnstalleerd';

  @override
  String get facesStatusNoDecoder =>
      'Gezichten zoeken is niet beschikbaar: de afbeeldingsbibliotheek (libvips) is niet gevonden. Installeer Photolib opnieuw, of installeer libvips en start de app opnieuw.';

  @override
  String get facesStatusRunning => 'Gezichten vinden op dit apparaat';

  @override
  String get facesStatusUnavailable =>
      'Op dit apparaat kunnen geen gezichten worden gevonden';

  @override
  String get facesStatusWaiting =>
      'De gezichtsmodellen worden via wifi gedownload';

  @override
  String get facesSwitch => 'Gezichten in mijn foto’s vinden';

  @override
  String get facesSwitchOff =>
      'Uit. Er wordt niets over gezichten berekend tot je akkoord gaat.';

  @override
  String get facesSwitchOn => 'Aan. Photolib vindt de gezichten in je foto’s.';

  @override
  String get facesTitle => 'Gezichten en personen';

  @override
  String get facesWithdraw => 'Wissen en stoppen';

  @override
  String get facesWithdrawBody =>
      'Dit wist alle gezichten, beschrijvingen en personen die Photolib voor je vond, op dit apparaat en op je server. Je foto’s veranderen niet.';

  @override
  String get facesWithdrawTitle => 'Stoppen met gezichten vinden?';

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

    return 'Niet gewijzigde bestanden: $countString';
  }

  @override
  String get folderAllow => 'Toegang tot deze map toestaan';

  @override
  String get folderDelete => 'Map verwijderen';

  @override
  String folderDeleteBody(String name) {
    return 'De foto\'s en video\'s in $name naar de prullenbak verplaatsen?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Nieuwe map';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline, $countString items',
      one: 'Offline, 1 item',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Deze map, of een map erin of eromheen, staat al in de bibliotheek';

  @override
  String get folderRemove => 'Map verwijderen';

  @override
  String folderRemoveBody(String folder) {
    return 'De foto\'s en video\'s uit $folder verdwijnen uit de bibliotheek. De bestanden blijven onaangeroerd op de schijf staan.';
  }

  @override
  String get folderRemoveConfirm => 'Verwijderen';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scannen, tot nu toe $countString items',
      one: 'Scannen, tot nu toe 1 item',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Toegang toestaan';

  @override
  String get foldersHideExcluded => 'Uitgesloten mappen verbergen';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib kan $countString mappen niet meer lezen.',
      one: 'Photolib kan 1 map niet meer lezen.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Uitgesloten mappen tonen ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Deze browser kan geen map als je bibliotheek gebruiken. Open Photolib in Chrome of Edge op een computer, of gebruik de desktop-app.';

  @override
  String get galleryButtons => 'Knoppen';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryGrid => 'Raster';

  @override
  String get galleryMenus => 'Menu\'s en panelen';

  @override
  String get galleryShowSheet => 'Een paneel tonen';

  @override
  String get galleryTitle => 'Componenten';

  @override
  String hiddenCollections(int count) {
    return 'Verborgen ($count)';
  }

  @override
  String get indexingAllowMetered => 'Downloaden via mobiele data';

  @override
  String get indexingAllowSaver => 'Ook in de energiebesparingsmodus';

  @override
  String get indexingBattery => 'Benodigde batterij zonder lader';

  @override
  String get indexingChargingOnly => 'Alleen tijdens opladen';

  @override
  String indexingDownloading(int percent) {
    return 'Zoekmodel downloaden: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foto\'s konden niet worden gelezen',
      one: '1 foto kon niet worden gelezen',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite =>
      'Dit apparaat indexeert alleen zijn nieuwe foto\'s';

  @override
  String get indexingMissing =>
      'Je server heeft het zoekmodel niet geïnstalleerd';

  @override
  String get indexingModels => 'Zoeken op dit apparaat';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Downloadt het zoekmodel ($megabytesString MB) van $host';
  }

  @override
  String get indexingNoDecoder =>
      'Zoeken en tekst lezen zijn niet beschikbaar: de afbeeldingsbibliotheek (libvips) is niet gevonden. Installeer Photolib opnieuw, of installeer libvips en start de app opnieuw.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Gepauzeerd zolang de batterij onder $percent% is';
  }

  @override
  String get indexingPausedCharger => 'Gepauzeerd tot het apparaat oplaadt';

  @override
  String get indexingPausedHeat => 'Gepauzeerd zolang het apparaat heet is';

  @override
  String get indexingPausedSaver =>
      'Gepauzeerd zolang batterijbesparing aan staat';

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

    return 'Foto\'s geïndexeerd: $doneString van $totalString';
  }

  @override
  String get indexingText => 'Tekst in foto’s lezen';

  @override
  String indexingTextDownloading(int percent) {
    return 'Tekstmodellen downloaden: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Downloadt de tekstmodellen ($megabytesString MB) van $host; vindt de woorden in je foto’s';
  }

  @override
  String get indexingTextMissing =>
      'Je server heeft de tekstmodellen niet geïnstalleerd';

  @override
  String get indexingTextPlatform =>
      'Gebruikt de eigen tekstherkenning van je telefoon; niets te downloaden. Leest nieuwe foto’s';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Foto’s gelezen op tekst: $doneString van $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Tekst lezen is hier niet beschikbaar';

  @override
  String get indexingTextWaiting =>
      'De tekstmodellen worden via wifi gedownload';

  @override
  String get indexingUnavailable =>
      'Zoeken op dit apparaat is hier niet beschikbaar';

  @override
  String get indexingWaiting => 'Het zoekmodel downloadt via wifi';

  @override
  String get infoAddName => 'Naam toevoegen';

  @override
  String get infoAddTag => 'Tag toevoegen';

  @override
  String get infoAlbums => 'Albums';

  @override
  String get infoAllMetadata => 'Alle metadata bekijken';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Geback-upt';

  @override
  String get infoCamera => 'Camera';

  @override
  String get infoChangeAdjust => 'Kleuren aangepast';

  @override
  String get infoChangeCrop => 'Bijgesneden';

  @override
  String get infoChangeFlip => 'Gespiegeld';

  @override
  String get infoChangeInpaint => 'Gebied opgevuld';

  @override
  String get infoChangeLocal => 'Gebied aangepast';

  @override
  String get infoChangeLut => 'Kleurlook toegepast';

  @override
  String get infoChangeOther => 'Bewerkt';

  @override
  String get infoChangeTurn => 'Gedraaid';

  @override
  String get infoCompare => 'Vergelijken met origineel';

  @override
  String infoConfidence(String percent) {
    return 'Betrouwbaarheid: $percent';
  }

  @override
  String get infoCopyPath => 'Pad kopiëren';

  @override
  String get infoCurrent => 'Huidig';

  @override
  String get infoDescription => 'Beschrijving toevoegen';

  @override
  String get infoEditDate => 'Datum bewerken';

  @override
  String infoEditNumber(int number) {
    return 'Bewerking $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Bewerkte kopie van $name';
  }

  @override
  String get infoFaces => 'Gezichten';

  @override
  String get infoFile => 'Bestand';

  @override
  String get infoFromFileName => 'uit de bestandsnaam';

  @override
  String get infoHistory => 'Bewerkingsgeschiedenis';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Locatie';

  @override
  String get infoMap => 'Kaart van waar het is gemaakt';

  @override
  String get infoMapAgree =>
      'Kaarttegels komen van internet en laten zien naar welk gebied u kijkt';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Nieuwe tag: $path';
  }

  @override
  String get infoNoAlbum => 'In geen enkel album';

  @override
  String get infoOnDevice => 'Op dit apparaat';

  @override
  String get infoOriginal => 'Origineel';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString pixels';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Verwijderen uit $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return '$tag verwijderen';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Verwijderd uit $album';
  }

  @override
  String get infoRevert => 'Terugzetten';

  @override
  String get infoSaveCopy => 'Opslaan als kopie';

  @override
  String get infoShared => 'gedeeld';

  @override
  String get infoShowFaces => 'Gezichten op de foto tonen';

  @override
  String get infoShowMap => 'Kaart tonen';

  @override
  String get infoTags => 'Tags';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versies',
      one: '$count versie',
    );
    return '$_temp0 · laatste $time';
  }

  @override
  String get infoWhy => 'Waarom deze datum?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Gelezen uit het bestand, als $tag',
      'name': 'Gelezen uit de bestandsnaam',
      'folder': 'Gelezen uit de naam van een map',
      'host': 'Opgegeven door de dienst waar het bestand vandaan komt',
      'unknown': 'Niets in het bestand dateert het, dus geldt de datum waarop het voor het laatst is gewijzigd',
      'other': 'Het bestand is nog niet gelezen, dus geldt de datum die het apparaat opgeeft',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Lijst',
      'other': 'Raster',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Naam',
      'taken': 'Opnamedatum',
      'modified': 'Wijzigingsdatum',
      'size': 'Grootte',
      'random': 'Willekeurig',
      'extension': 'Type',
      'custom': 'Albumvolgorde',
      'other': 'Opnamedatum',
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
  String get languageDevice => 'Taal van het apparaat';

  @override
  String get languageName => 'Nederlands';

  @override
  String get libraryAddFolder => 'Map toevoegen';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Geen back-up',
      'backed_up': 'Back-up gemaakt',
      'cloud_only': 'Alleen in de cloud',
      'other': 'Alles',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Van alles is een back-up',
      'backed_up': 'Nog niets is geback-upt',
      'cloud_only': 'Niets staat alleen op de server',
      'other': 'Hier staat niets',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Back-upbadges';

  @override
  String get libraryEmpty => 'Je foto\'s worden hier weergegeven';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Groeperen per week',
      'month': 'Groeperen per maand',
      'other': 'Groeperen per dag',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Verborgen en gearchiveerde items weer verbergen';

  @override
  String get libraryNoKeyring =>
      'Photolib bewaart de sleutel van je bibliotheek in de sleutelbos van het systeem, die niet draait of vergrendeld is. Start of ontgrendel een sleutelbos, zoals GNOME Keyring of KWallet, en probeer het opnieuw.';

  @override
  String get libraryRevealExcluded => 'Uitgesloten mappen 5 minuten tonen';

  @override
  String get libraryShowVeiled =>
      'Verborgen en gearchiveerde items 5 minuten tonen';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Recent toegevoegd',
      'other': 'Opnamedatum',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib kon de bibliotheek op dit apparaat niet openen';

  @override
  String get libraryViewOptions => 'Weergaveopties';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Miniaturen voorbereiden: $doneString van $totalString';
  }

  @override
  String get libraryZoomIn => 'Grotere miniaturen';

  @override
  String get libraryZoomOut => 'Kleinere miniaturen';

  @override
  String get mapAddTrack => 'GPX-track toevoegen';

  @override
  String get mapArea => 'Kaartgebied';

  @override
  String get mapAttribution => '© OpenStreetMap-bijdragers';

  @override
  String get mapClearLasso => 'Selectie wissen';

  @override
  String get mapEmpty => 'Nog geen foto\'s met een plaats';

  @override
  String get mapHeat => 'Heatmap';

  @override
  String get mapLasso => 'Selecteren door rond foto\'s te tekenen';

  @override
  String get mapLoading => 'Foto\'s op de kaart plaatsen';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Foto\'s: $countString';
  }

  @override
  String get mapSearchHere => 'In dit gebied zoeken';

  @override
  String get mapSplit => 'Foto\'s onder de kaart tonen';

  @override
  String get mapTilesAgree =>
      'De kaartachtergrond komt van de server van OpenStreetMap (tile.openstreetmap.org), die ziet welk gebied je bekijkt';

  @override
  String get mapTilesShow => 'Achtergrond tonen';

  @override
  String get mapTime => 'Tijdsbereik';

  @override
  String get mapTitle => 'Kaart';

  @override
  String get mapTrackBad => 'Dit bestand bevat geen GPX-tracks';

  @override
  String get mapTrips => 'Reizen';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favoriet',
      'hidden': 'Verborgen',
      'archived': 'Gearchiveerd',
      'offline': 'Op dit apparaat bewaard',
      'offline': 'Op dit apparaat bewaard',
      'offline': 'Op dit apparaat bewaard',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Toegang toestaan';

  @override
  String get mediaAccessNone =>
      'Photolib heeft toegang tot je foto\'s en video\'s nodig om ze te tonen.';

  @override
  String get mediaAccessPartial =>
      'Photolib ziet alleen de foto\'s en video\'s die je hebt geselecteerd. Een galerij heeft toegang tot alles nodig.';

  @override
  String get mediaAccessSelect => 'Meer foto\'s selecteren';

  @override
  String get nameLabel => 'Naam';

  @override
  String get nextAddRoot =>
      'Voeg de map toe aan external_roots in de configuratie van de server en start de server opnieuw.';

  @override
  String get nextAskAdmin => 'Vraag het de beheerder van je server.';

  @override
  String get nextAskOwner =>
      'Vraag de eigenaar van de bibliotheek om je foto\'s te laten toevoegen.';

  @override
  String get nextCheckConnection =>
      'Controleer de verbinding om te zien waarom.';

  @override
  String get nextCheckEntry =>
      'Controleer wat je hebt ingevuld en probeer het opnieuw.';

  @override
  String get nextConfirm =>
      'Controleer hoeveel items het raakt en bevestig daarna.';

  @override
  String get nextDeleteWebhook =>
      'Verwijder een webhook die je niet meer gebruikt en probeer het opnieuw.';

  @override
  String get nextEditConfig =>
      'Wijzig het in de configuratie van de server en start de server opnieuw.';

  @override
  String get nextFreeSpace => 'Maak ruimte vrij of vraag je beheerder om meer.';

  @override
  String get nextNewLink => 'Vraag je beheerder om een nieuwe.';

  @override
  String get nextNewestToken =>
      'Kopieer de nieuwste uit het logboek van photolibd.';

  @override
  String get nextOtherAdmin => 'Maak eerst een ander account beheerder.';

  @override
  String get nextOtherFolder => 'Kies een eigen map.';

  @override
  String get nextRefresh => 'Vernieuw en probeer het opnieuw.';

  @override
  String get nextReport =>
      'Probeer het opnieuw. Gebeurt het weer, kopieer dan de details hieronder voor je beheerder.';

  @override
  String get nextSetUpPrivate =>
      'Rond het instellen van privébibliotheken af in Instellingen en probeer het opnieuw.';

  @override
  String get nextSignIn => 'Log opnieuw in.';

  @override
  String get nextSignInAccount =>
      'Log in met je account en probeer het opnieuw.';

  @override
  String get nextSignInInstead => 'Log in plaats daarvan in.';

  @override
  String get nextTryAgain => 'Probeer het opnieuw.';

  @override
  String get nextUpdateAndAgree =>
      'Werk de app bij en ga opnieuw akkoord met de melding.';

  @override
  String get nextUseAnother => 'Kies een andere.';

  @override
  String get nextUseHttps =>
      'Gebruik het adres van de server met https:// of maak verbinding vanuit het netwerk van de server.';

  @override
  String get nextWait => 'Wacht een minuut en probeer het dan opnieuw.';

  @override
  String get offlineKeep => 'Offline bewaren';

  @override
  String offlineKeepHere(String size) {
    return 'Op dit apparaat bewaren ($size)';
  }

  @override
  String get offlineKeptHere => 'Op dit apparaat bewaard';

  @override
  String get offlineStopKeeping => 'Niet meer offline bewaren';

  @override
  String get otherFiles => 'Andere bestanden';

  @override
  String get passphraseCreate =>
      'Op deze computer draait geen sleutelbos (Secret Service) die de sleutels van Photolib bewaart. Kies een wachtwoordzin van minstens 10 tekens om ze te beschermen: Photolib vraagt erom bij elke start.';

  @override
  String get passphraseLabel => 'Wachtwoordzin';

  @override
  String get passphraseMismatch => 'De wachtwoordzinnen zijn niet gelijk.';

  @override
  String get passphraseRepeat => 'Wachtwoordzin herhalen';

  @override
  String get passphraseTooShort => 'Gebruik minstens 10 tekens.';

  @override
  String get passphraseUnlock =>
      'Voer de wachtwoordzin in die de sleutels van Photolib op deze computer beschermt.';

  @override
  String get passphraseWrong => 'Onjuiste wachtwoordzin. Probeer het opnieuw.';

  @override
  String photoPosition(int index, int count) {
    return 'Foto $index van $count';
  }

  @override
  String get privacyCheckKit => 'Herstelkit controleren';

  @override
  String get privacyDrillDue =>
      'Tijd voor een hersteloefening: controleer of je herstelkit je privébibliotheken nog ontgrendelt.';

  @override
  String get privacyHonest =>
      'Privébibliotheken worden versleuteld op je apparaten, en niemand anders kan ze openen: niet de server, niet de beheerder ervan en niet de ontwikkelaars van Photolib. Als je zowel je wachtwoord als je herstelkit kwijtraakt, zijn je foto\'s voorgoed verloren en kan niemand ze voor je terughalen.';

  @override
  String get privacyKitBody =>
      'Schrijf deze 24 woorden op papier, in volgorde, en bewaar ze op een veilige plek. Ze ontgrendelen je privébibliotheken als je je wachtwoord vergeet, voor iedereen die ze heeft.';

  @override
  String get privacyKitDone => 'Je herstelkit werkt.';

  @override
  String get privacyKitOther => 'Dit is niet je huidige herstelkit.';

  @override
  String get privacyKitTitle => 'Je herstelkit';

  @override
  String get privacyKitUnverified => 'Herstelkit nog niet bevestigd';

  @override
  String privacyKitVerified(String date) {
    return 'Herstelkit bevestigd op $date';
  }

  @override
  String get privacyKitWritten => 'Ik heb ze opgeschreven';

  @override
  String get privacyNotReady =>
      'Privé-uploads blijven uit tot je twee manieren hebt om te ontgrendelen en je herstelkit hebt bevestigd.';

  @override
  String get privacyPasswordHelp =>
      'Voer het wachtwoord van je account in: het wordt een manier om je privébibliotheken te ontgrendelen.';

  @override
  String get privacyPhrase => 'Herstelzin';

  @override
  String get privacyPhraseHelp => 'De 24 woorden van je herstelkit';

  @override
  String get privacyPhraseInvalid =>
      'Dit is geen herstelzin. Controleer elk woord.';

  @override
  String get privacyReady => 'Privé-uploads staan aan.';

  @override
  String get privacyRecoveryKit => 'Herstelkit';

  @override
  String get privacySetUp => 'Instellen';

  @override
  String get privacyShowWords => 'Woorden opnieuw tonen';

  @override
  String get privacyTitle => 'Privébibliotheken';

  @override
  String privacyUnknownWord(int number) {
    return 'Woord $number is geen woord van een herstelkit.';
  }

  @override
  String get privacyVerify => 'Bevestigen';

  @override
  String get privacyVerifyBody =>
      'Typ deze woorden uit je herstelkit om te laten zien dat je hem hebt bewaard.';

  @override
  String get privacyWays => 'Manieren om te ontgrendelen';

  @override
  String privacyWord(int number) {
    return 'Woord $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Deze woorden komen niet overeen met je herstelkit. Controleer wat je hebt opgeschreven.';

  @override
  String get privacyWrongPassword =>
      'Dit is niet het wachtwoord van je account.';

  @override
  String get problemAdminOnly => 'Alleen een beheerder kan dit.';

  @override
  String get problemBusy => 'De server is bezig of start opnieuw op.';

  @override
  String get problemChanged => 'Dit is intussen veranderd.';

  @override
  String get problemConfirm =>
      'Dit zou meer items verbergen of verwijderen dan de server zonder bevestiging doet';

  @override
  String get problemContribute =>
      'Je mag geen foto\'s aan deze bibliotheek toevoegen.';

  @override
  String get problemCopy => 'Details kopiëren';

  @override
  String get problemDetails => 'Details';

  @override
  String get problemDiskLow =>
      'De schijf van de server is bijna vol, dus uploads zijn gepauzeerd.';

  @override
  String get problemEmailTaken => 'Een ander account heeft dit e-mailadres.';

  @override
  String get problemExists => 'Het bestaat al.';

  @override
  String get problemFaceNotice =>
      'Je server vraagt een nieuwere versie van de gezichtenmelding dan deze app toont.';

  @override
  String get problemGone => 'Het staat niet meer op de server.';

  @override
  String get problemHandleTaken => 'Een ander account heeft deze inlognaam.';

  @override
  String get problemInterrupted => 'De upload is onderbroken.';

  @override
  String get problemInvalid => 'Een waarde is ongeldig';

  @override
  String get problemLastAdmin =>
      'De server heeft minstens één beheerder nodig.';

  @override
  String get problemLinkInvalid => 'Deze link is verlopen of al gebruikt.';

  @override
  String get problemLoginFailed => 'E-mail, inlognaam of wachtwoord onjuist.';

  @override
  String get problemMaintenanceKey =>
      'Back-ups, integriteitscontroles en definitieve verwijderingen kunnen alleen worden gepauzeerd als je bent ingelogd, niet met een API-sleutel';

  @override
  String get problemNotAllowed => 'Je account mag dit niet.';

  @override
  String get problemNotExternal =>
      'Alleen bibliotheken van de eigen mappen van de server kunnen worden gescand.';

  @override
  String get problemOidcClaim =>
      'Je inlogdienst gaf niet aan wie je bent op een manier die deze server accepteert.';

  @override
  String get problemOidcDown => 'Je inlogdienst antwoordt de server niet.';

  @override
  String get problemOidcFailed =>
      'Je inlogdienst heeft het inloggen geweigerd.';

  @override
  String get problemOidcNotAllowed =>
      'Je account mag niet op deze manier inloggen.';

  @override
  String get problemOidcTaken =>
      'Deze login is al gekoppeld aan een ander Photolib-account.';

  @override
  String get problemOidcUnknown =>
      'Deze server biedt deze manier van inloggen niet meer aan.';

  @override
  String get problemPasskeysOff =>
      'Toegangssleutels werken pas als de server zijn openbare adres heeft.';

  @override
  String get problemPinned =>
      'Dit is ingesteld in het configuratiebestand en kan hier niet worden gewijzigd.';

  @override
  String get problemPolicyOff => 'Dit staat uit op deze server.';

  @override
  String get problemQuota => 'Je opslag op de server is vol.';

  @override
  String get problemRestoreKey =>
      'Een back-up kan alleen worden hersteld als je bent ingelogd, niet met een API-sleutel.';

  @override
  String get problemRootDiffers =>
      'Deze map bevat de bestanden van deze bibliotheek niet';

  @override
  String get problemRootNotAllowed =>
      'Deze map staat niet onder de external_roots van de serverconfiguratie';

  @override
  String get problemRootOverlaps =>
      'Deze map bevat een andere bibliotheek of de eigen gegevens van de server, of ligt daarin';

  @override
  String get problemScanning => 'Deze bibliotheek wordt al gescand';

  @override
  String get problemSecondFactor =>
      'Dit account heeft een tweede factor nodig, zoals een verificatiecode of een toegangssleutel, die deze versie van Photolib nog niet kan geven.';

  @override
  String get problemSetupDone => 'Deze server heeft al een beheerder.';

  @override
  String get problemSetupExpired => 'Dit duurde te lang.';

  @override
  String get problemSetupToken => 'Dit instellingstoken klopt niet.';

  @override
  String get problemSignedOut => 'Je bent uitgelogd bij de server.';

  @override
  String get problemStepUp =>
      'Voor deze wijziging is eerst je wachtwoord of een code nodig.';

  @override
  String get problemStorage => 'De server kan zijn opslag niet bereiken.';

  @override
  String get problemTooMany => 'Te veel pogingen in korte tijd.';

  @override
  String get problemUnexpected => 'Er ging iets onverwachts mis.';

  @override
  String get problemUnreachable => 'De server antwoordt niet.';

  @override
  String get problemUploadDamaged =>
      'Het bestand is onderweg veranderd of beschadigd.';

  @override
  String get problemUploadExpired =>
      'De server heeft deze upload niet meer: onvoltooide uploads verlopen na een dag.';

  @override
  String get problemWebhookLimit =>
      'Je account heeft al zoveel webhooks als het mag hebben.';

  @override
  String get problemWebhooksOff => 'Webhooks staan uit op deze server.';

  @override
  String get recoveryCode => 'Herstelcode';

  @override
  String get recoveryCodeAbout =>
      'Opent de opslag van Photolib op dit apparaat als de sleutelopslag zijn sleutel kwijtraakt';

  @override
  String get recoveryCodeEnter => 'Herstelcode invoeren';

  @override
  String get recoveryCreate => 'Herstelcode maken';

  @override
  String get recoveryLater => 'Later';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString wijzigingen bestaan alleen op dit apparaat. Een herstelcode haalt ze terug als de sleutelopslag de sleutel van Photolib kwijtraakt.',
      one: '1 wijziging bestaat alleen op dit apparaat. Een herstelcode haalt haar terug als de sleutelopslag de sleutel van Photolib kwijtraakt.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Schrijf deze 24 woorden op en bewaar ze veilig: ze openen de opslag van Photolib op dit apparaat zonder de sleutel uit de sleutelopslag. Ze vervangen elke eerdere code.';

  @override
  String get recoveryUnlock => 'Ontgrendelen';

  @override
  String get recoveryWrong => 'Dat is niet de herstelcode van deze opslag';

  @override
  String get renameFind => 'Zoeken';

  @override
  String get renamePattern => 'Nieuwe naam';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Te lang: een naam heeft hoogstens 255 bytes',
      'invalid': 'Geen geldige bestandsnaam',
      'duplicate': 'Ook aan een ander bestand gegeven',
      'exists': 'Een ander bestand in deze map heeft deze naam',
      'other': 'Naam kan niet worden gewijzigd',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Vervangen door';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Hernoemde bestanden: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Toon in Finder',
      'windows': 'Weergeven in Verkenner',
      'other': 'Weergeven in map',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Camera';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Datums';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Zoek in je bibliotheek';

  @override
  String get searchFavourites => 'Favorieten';

  @override
  String get searchFolder => 'Map';

  @override
  String get searchHint => 'Bestands- of mapnaam';

  @override
  String get searchMotionPhotos => 'Bewegende foto\'s';

  @override
  String get searchNothing => 'Geen resultaten';

  @override
  String get searchPanoramas => 'Panorama\'s';

  @override
  String get searchPhotos => 'Foto\'s';

  @override
  String get searchScreenshots => 'Screenshots';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Video\'s';

  @override
  String get securityAddPasskey => 'Toegangssleutel toevoegen';

  @override
  String get securityCode => 'Code';

  @override
  String get securityCodesHelp =>
      'Bewaar deze codes op een veilige plek. Elke code werkt één keer in plaats van je tweede factor, en ze worden alleen nu getoond.';

  @override
  String securityCodesLeft(int count) {
    return 'Ongebruikt: $count';
  }

  @override
  String get securityNewCodes => 'Nieuwe codes';

  @override
  String get securityPasskeyNotAdded =>
      'Er is geen toegangssleutel toegevoegd.';

  @override
  String get securityRecoveryCodes => 'Herstelcodes';

  @override
  String get securityRemovePasskey => 'Toegangssleutel verwijderen';

  @override
  String get securitySetUp => 'Instellen';

  @override
  String get securityStepUpBody =>
      'Voer je wachtwoord, een code uit je authenticator-app of een herstelcode in om je tweede factoren te wijzigen.';

  @override
  String get securityStepUpTitle => 'Bevestig dat jij het bent';

  @override
  String get securityTitle => 'Tweede factoren';

  @override
  String get securityTotp => 'Authenticator-app';

  @override
  String get securityTotpHelp =>
      'Voeg deze sleutel toe aan je authenticator-app en voer daarna de code in die de app toont.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': 'Aan', 'other': 'Uit'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Uitzetten';

  @override
  String get securityWrongCode => 'Die code klopt niet.';

  @override
  String get securityWrongProof => 'Wachtwoord of code klopt niet.';

  @override
  String get selectAll => 'Alles selecteren';

  @override
  String get selectionClear => 'Selectie wissen';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString geselecteerd',
      one: '1 geselecteerd',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Selectie tonen';

  @override
  String get serverAccount => 'E-mail of inlognaam';

  @override
  String get serverAdd => 'Server toevoegen';

  @override
  String get serverAddressInvalid =>
      'Voer adressen in zoals photos.example.org';

  @override
  String get serverAddresses => 'Adressen';

  @override
  String get serverAddressesHelp =>
      'Eén per regel: de server op je netwerk, op internet of via een VPN. De app gebruikt de snelste die antwoordt. Of plak de link om een wachtwoord in te stellen die je hebt gekregen.';

  @override
  String get serverCa => 'Certificaat van de privé-CA (PEM)';

  @override
  String get serverCaChoose => 'Certificaatbestand kiezen';

  @override
  String serverCertificateBody(String host) {
    return '$host toont een certificaat dat dit apparaat niet vertrouwt. Vertrouw het alleen als deze SHA-256-vingerafdruk die van je server is:';
  }

  @override
  String get serverCertificateTitle => 'Dit certificaat vertrouwen?';

  @override
  String get serverConfirm => 'Bevestigen';

  @override
  String get serverConnect => 'Verbinden';

  @override
  String get serverCreateAdmin => 'Beheerder aanmaken';

  @override
  String get serverEnded =>
      'De server heeft deze sessie beëindigd. Log opnieuw in.';

  @override
  String get serverHandleHelp =>
      'Kleine letters, cijfers, punten, streepjes en underscores; verandert nooit.';

  @override
  String get serverHeaders => 'Eigen headers';

  @override
  String get serverHeadersHelp =>
      'Eén per regel, als Name: value; alleen via HTTPS verstuurd';

  @override
  String get serverHeadersInvalid => 'Schrijf elke header als Name: value';

  @override
  String get serverIdentity => 'Clientcertificaat (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Kies een clientcertificaat';

  @override
  String get serverIdentityInvalid =>
      'Dit is geen PKCS#12-certificaat, of het wachtwoord is onjuist.';

  @override
  String get serverIdentityPassword => 'Wachtwoord van het clientcertificaat';

  @override
  String get serverLoading =>
      'De server die op dit apparaat is bewaard, wordt gelezen';

  @override
  String get serverNearby => 'Servers op dit netwerk';

  @override
  String get serverNeedsHttps =>
      'Deze server heeft een HTTPS-adres nodig: buiten je lokale netwerk meldt Photolib zich niet aan via gewone HTTP.';

  @override
  String get serverNoSignIn =>
      'Deze server biedt geen inlogmethode die deze versie van Photolib ondersteunt.';

  @override
  String get serverOffline => 'De server antwoordt niet. Je blijft ingelogd.';

  @override
  String get serverPasskeyFailed =>
      'Er is geen passkey gebruikt. Probeer het opnieuw of gebruik een code.';

  @override
  String get serverPasskeyRequired =>
      'Deze server vereist een toegangssleutel, die deze versie van Photolib nog niet kan gebruiken.';

  @override
  String get serverPassword => 'Wachtwoord';

  @override
  String get serverPasswordAgain => 'Wachtwoord herhalen';

  @override
  String get serverPasswordSetupInvalid =>
      'Dit token om het wachtwoord in te stellen is onjuist, al gebruikt of verlopen. Vraag om een nieuw token.';

  @override
  String get serverPasswordSetupToken =>
      'Token om het wachtwoord in te stellen';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Van je beheerder, of afgedrukt door photolibd admin password-setup op de server.';

  @override
  String get serverPasswordsDiffer => 'De wachtwoorden zijn niet gelijk.';

  @override
  String get serverPrivateLibrariesBody =>
      'Een nieuw wachtwoord opent ze niet. Open ze opnieuw met je herstelkit, een passkey of een apparaat dat nog is ingelogd.';

  @override
  String get serverPrivateLibrariesGo => 'Wachtwoord instellen';

  @override
  String get serverPrivateLibrariesTitle =>
      'Je privébibliotheken blijven vergrendeld';

  @override
  String get serverProxy => 'HTTP-proxy, als host:port';

  @override
  String get serverProxyInvalid => 'Voer de proxy in als host:port';

  @override
  String get serverRecoveryCode => 'Herstelcode';

  @override
  String get serverRemove => 'Deze server verwijderen';

  @override
  String get serverRequired => 'Verplicht';

  @override
  String get serverSecondFactor =>
      'De tweede factor van dit account is een toegangssleutel, die deze versie van Photolib nog niet kan gebruiken.';

  @override
  String get serverSecondFactorCode =>
      'Dit account heeft ook een code uit je authenticator-app of een herstelcode nodig.';

  @override
  String get serverSecondFactorTitle => 'Bevestig dat jij het bent';

  @override
  String get serverSecondFactorWrong =>
      'Dat werkte niet. Meld je na vijf pogingen opnieuw aan.';

  @override
  String get serverSetPassword => 'Wachtwoord instellen';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Voor $handle op $server';
  }

  @override
  String get serverSetPasswordOpen => 'Een wachtwoord instellen';

  @override
  String get serverSetPasswordTitle => 'Stel je wachtwoord in';

  @override
  String get serverSetUp => 'Nieuwe server instellen';

  @override
  String get serverSetupLinkElsewhere =>
      'Log eerst uit bij deze server om deze link te gebruiken, of verwijder de server als de link voor een andere is.';

  @override
  String get serverSetupTitle => 'Server instellen';

  @override
  String get serverSetupToken => 'Instellingstoken';

  @override
  String get serverSetupTokenHelp =>
      'photolibd schrijft het in zijn log zolang de server geen beheerder heeft; elke start schrijft een nieuwe.';

  @override
  String get serverSignIn => 'Inloggen';

  @override
  String get serverSignOut => 'Uitloggen';

  @override
  String serverSignedInAs(String account) {
    return 'Ingelogd als $account';
  }

  @override
  String get serverSignedOut => 'Uitgelogd';

  @override
  String get serverSwitch => 'Account wisselen';

  @override
  String get serverTotpCode => 'Code uit je authenticator-app';

  @override
  String get serverTrust => 'Vertrouwen';

  @override
  String get serverUnreadable =>
      'De server die op dit apparaat is bewaard, kan niet worden gelezen';

  @override
  String get serverUsePasskey => 'Een passkey gebruiken';

  @override
  String get serverUseRecoveryCode =>
      'Gebruik in plaats daarvan een herstelcode';

  @override
  String get settingsBackground => 'Achter transparante afbeeldingen';

  @override
  String get settingsDefaultTab => 'Mappen en albums openen op';

  @override
  String get settingsFolders => 'Mappen';

  @override
  String get settingsIndexing => 'Indexeren op dit apparaat';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsLibrary => 'Bibliotheek';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsStart => 'Startscherm';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps':
          'Tik op de linker- of rechterrand voor het vorige of volgende item',
      'oneFingerZoom': 'Dubbeltik en sleep om met één vinger te zoomen',
      'swipes': 'Veeg links op een video omhoog of omlaag voor de helderheid, rechts voor het volume',
      'maxBrightness': 'Volledige helderheid tijdens het bekijken',
      'autoRotate': 'Draaien naar de stand van elke foto of video',
      'mixAudio':
          'Video\'s over ander geluid afspelen in plaats van het te pauzeren',
      'autoplay': 'Video\'s afspelen zodra ze openen',
      'loop': 'Video\'s herhalen',
      'autoNext': 'Naar het volgende item gaan als een video eindigt',
      'resume': 'Video\'s hervatten waar ze gelaten zijn',
      'other': 'Geanimeerde afbeeldingen in het raster afspelen',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'Knoppen in de balk van de viewer';

  @override
  String get settingsViewing => 'Weergave';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString gedeelde foto\'s en video\'s wachten tot Photolib ze aan je fotobibliotheek mag toevoegen. Niet-bewaarde onderdelen worden na 7 dagen verwijderd.',
      one: '1 gedeelde foto of video wacht tot Photolib hem aan je fotobibliotheek mag toevoegen. Niet-bewaarde onderdelen worden na 7 dagen verwijderd.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Te groot om in één keer te delen: selecteer minder items';

  @override
  String shareTooMany(int count) {
    return 'Te veel om in één keer te delen: selecteer er maximaal $count';
  }

  @override
  String get shortcutsTitle => 'Sneltoetsen';

  @override
  String get slideshow => 'Diavoorstelling';

  @override
  String get slideshowLoop => 'Herhalen';

  @override
  String get slideshowOptions => 'Opties voor diavoorstelling';

  @override
  String get slideshowSeconds => 'Seconden per item';

  @override
  String get slideshowShuffle => 'Willekeurige volgorde';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Aflopend',
      'other': 'Oplopend',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Dit apparaat';

  @override
  String sourceHide(String name) {
    return '$name verbergen';
  }

  @override
  String get sourceHideOthers => 'Al het andere hier verbergen';

  @override
  String get sourceLost => 'Geen toegang';

  @override
  String get sourcePartly => 'Deels getoond';

  @override
  String sourceShow(String name) {
    return '$name tonen';
  }

  @override
  String get sourceShowEverything => 'Alles hier tonen';

  @override
  String get sourceShowOnly => 'Alleen dit tonen';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Tijdlijn',
      'folders': 'Mappen en albums',
      'favourites': 'Favorieten',
      'other': 'Tijdlijn',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Een persoon offline bewaren';

  @override
  String get storageBudget => 'Opslagbudget';

  @override
  String get storageClear => 'Offline kopieën verwijderen';

  @override
  String get storageClearAction => 'Verwijderen';

  @override
  String storageClearBody(String size) {
    return 'Dit verwijdert $size die op dit apparaat staan en stopt met het offline bewaren van albums, zoekopdrachten en foto\'s. Je bibliotheek op de server blijft ongemoeid.';
  }

  @override
  String get storageKeepLibrary => 'Hele bibliotheek bewaren';

  @override
  String get storageKeepOriginals => 'Ook originelen bewaren';

  @override
  String get storageNoPeople => 'Er zijn nog geen personen met een naam.';

  @override
  String get storageNoPins =>
      'Er is niets vastgezet. Zet een album, zoekopdracht of foto vast om het offline te bewaren.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Zoekopdracht',
      'person': 'Persoon',
      'library': 'Hele bibliotheek',
      'asset': 'Foto',
      'other': 'Vastgezet',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Past niet in het budget: nog $size nodig';
  }

  @override
  String get storagePinNothing =>
      'Niets te downloaden: de foto\'s staan al op dit apparaat';

  @override
  String get storagePinPaused =>
      'Wacht: deze voorinstelling bewaart niets offline';

  @override
  String get storagePinPlanning => 'Uitzoeken wat te bewaren…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Downloaden: $haveString van $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Offline beschikbaar ($size)';
  }

  @override
  String get storagePinWaiting => 'Wordt gedownload zodra je online bent';

  @override
  String get storagePins => 'Offline bewaard';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Alleen catalogus',
      'spaceSaver': 'Ruimte besparen',
      'travel': 'Gekozen albums offline',
      'everything': 'Alles',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Bewaart niets; foto\'s laden van je server wanneer je ze opent.',
      'spaceSaver': 'Bewaart voorbeelden van je hele bibliotheek, nieuwste eerst, binnen het budget.',
      'travel':
          'Bewaart alleen wat je vastzet: albums, zoekopdrachten en foto\'s.',
      'everything': 'Bewaart de originelen van je hele bibliotheek, nieuwste eerst, binnen het budget.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Wat dit apparaat bewaart';

  @override
  String get storageSubtitle => 'Offline kopieën en opslagbudget';

  @override
  String get storageTitle => 'Opslag';

  @override
  String storageUsed(String used, String budget) {
    return '$used van $budget gebruikt';
  }

  @override
  String get storageWebNote =>
      'Een browser bewaart alleen voorbeelden en wist ze bij uitloggen.';

  @override
  String get storeNoKeyring =>
      'Photolib bewaart de sleutel van zijn lokale opslag in de sleutelbos van het systeem, die niet antwoordde. Installeer en ontgrendel gnome-keyring, KWallet of KeePassXC met Secret Service aan en probeer het opnieuw.';

  @override
  String get storeNoKeystore =>
      'Photolib kon de sleutelopslag van dit apparaat niet bereiken, die de sleutel van zijn lokale opslag bewaart.';

  @override
  String get storeRebuilt =>
      'De sleutelopslag van dit apparaat had de sleutel van de lokale opslag van Photolib niet meer, dus is de opslag opnieuw opgebouwd. De instellingen en wat alleen op dit apparaat bestond zijn verloren; bibliotheken synchroniseren opnieuw en miniaturen komen terug.';

  @override
  String get storeRecoveryNeeded =>
      'De sleutelopslag van dit apparaat heeft de sleutel van de lokale opslag van Photolib niet meer. Voer de herstelcode in, of zet de opslag terug en verlies wat alleen op dit apparaat bestaat.';

  @override
  String get storeReset => 'Opslag terugzetten';

  @override
  String get storeResetBody =>
      'Wat alleen op dit apparaat bestaat, gaat verloren; bibliotheken synchroniseren opnieuw en miniaturen komen terug.';

  @override
  String get storeUnavailable =>
      'De opslag op dit apparaat is niet beschikbaar: instellingen en collecties worden niet bewaard';

  @override
  String get tabCollections => 'Collecties';

  @override
  String get tabLibrary => 'Bibliotheek';

  @override
  String get tabSearch => 'Zoeken';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get timelineBenchmark => 'Tijdlijnbenchmark';

  @override
  String get timelineBenchmarkCopy => 'Resultaten kopiëren';

  @override
  String get timelineCannotPlay => 'Kan niet worden afgespeeld in deze browser';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position van $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position van $count, geen voorbeeld';
  }

  @override
  String get timelineExcluded => 'In een uitgesloten map';

  @override
  String get timelineNoHeicLinux =>
      'Photolib kan HEIC-foto\'s op deze computer niet tonen. Verbind een Photolib-server om de kopie te zien, of open ze op een Mac.';

  @override
  String get timelineNoHeicWindows =>
      'Photolib kan HEIC-foto\'s op deze pc niet tonen. Verbind een Photolib-server om de kopie te zien, of open ze op een Mac.';

  @override
  String get timelineScrubber => 'Scrollen op datum';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Datum onbekend';

  @override
  String timelineWeek(String date) {
    return 'Week van $date';
  }

  @override
  String toolbarAdd(String action) {
    return '$action aan de balk toevoegen';
  }

  @override
  String toolbarDown(String action) {
    return '$action omlaag verplaatsen';
  }

  @override
  String get toolbarInBar => 'In de balk';

  @override
  String get toolbarInMenu => 'In het menu ⋮';

  @override
  String toolbarRemove(String action) {
    return '$action uit de balk verwijderen';
  }

  @override
  String get toolbarReset => 'Standaard herstellen';

  @override
  String toolbarUp(String action) {
    return '$action omhoog verplaatsen';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Hierheen verplaatsen',
      'other': 'Hierheen kopiëren',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Er staat al een bestand of map met deze naam',
      'changed':
          'De kopie kwam niet overeen met het origineel en is verwijderd',
      'cancelled': 'Geannuleerd',
      'invalid': 'Geen geldige mapnaam',
      'other': 'Mislukt',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Recent';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString items definitief verwijderen? Dit kan niet ongedaan worden gemaakt.',
      one: '1 item definitief verwijderen? Dit kan niet ongedaan worden gemaakt.',
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
      other: 'Nog $daysString dagen',
      one: 'Nog 1 dag',
      zero: 'Wordt vandaag definitief verwijderd',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'De prullenbak is leeg';

  @override
  String get trashEmptyAll => 'Prullenbak legen';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items naar de prullenbak verplaatst',
      one: '1 item naar de prullenbak verplaatst',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib verwijdert wat het in de prullenbak bewaart na $days dagen definitief; elk item toont hoeveel tijd het nog heeft.';
  }

  @override
  String get trashTitle => 'Prullenbak';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get uploadAction => 'Foto\'s en video\'s uploaden';

  @override
  String get uploadClear => 'Wissen';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString van $totalString geüpload';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Mislukt: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items gearchiveerd',
      one: '1 item gearchiveerd',
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
      other: '$countString items verborgen',
      one: '1 item verborgen',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Zwart',
      'white': 'Wit',
      'other': 'Schaakbord',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Deze video kan niet worden afgespeeld op dit apparaat';

  @override
  String get viewerCaptions => 'Ondertiteling';

  @override
  String get viewerCompass => 'Kompasvergrendeling';

  @override
  String get viewerCopy => 'Kopiëren';

  @override
  String get viewerCopyText => 'Tekst kopiëren';

  @override
  String get viewerCustomize => 'Werkbalk aanpassen…';

  @override
  String get viewerDial =>
      'Richting. Klik om naar voren te kijken. Sleep om rond te kijken, scrol of knijp om te zoomen, dubbelklik om te herstellen';

  @override
  String get viewerFilmstrip => 'Filmstrip';

  @override
  String get viewerFirst => 'Eerste';

  @override
  String get viewerFisheye => 'Visoog';

  @override
  String get viewerGyroscope => 'Beweeg om rond te kijken';

  @override
  String get viewerHdr => 'Weergeven in HDR';

  @override
  String get viewerInfo => 'Info';

  @override
  String get viewerInfoLoading => 'Info over dit item wordt geladen';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString van $countString';
  }

  @override
  String get viewerLast => 'Laatste';

  @override
  String get viewerLenses => 'Een lens kiezen';

  @override
  String get viewerMap => 'Kaart';

  @override
  String get viewerMotion => 'Beweging afspelen';

  @override
  String get viewerMotionDenied =>
      'Deze browser heeft geen toegang tot de bewegingssensoren gegeven';

  @override
  String get viewerMotionMissing =>
      'Dit apparaat heeft geen gyroscoop om rond te kijken';

  @override
  String get viewerMute => 'Dempen';

  @override
  String get viewerNext => 'Volgende';

  @override
  String get viewerNextFrame => 'Volgend beeld';

  @override
  String get viewerPause => 'Pauzeren';

  @override
  String get viewerPlanet => 'Kleine planeet';

  @override
  String get viewerPlay => 'Afspelen';

  @override
  String get viewerPrevious => 'Vorige';

  @override
  String get viewerPreviousFrame => 'Vorig beeld';

  @override
  String get viewerRotate => 'Draaien';

  @override
  String get viewerSdr => 'Weergeven in SDR';

  @override
  String get viewerSeek => 'Positie';

  @override
  String get viewerSetAs => 'Instellen als';

  @override
  String get viewerShare => 'Delen';

  @override
  String get viewerSpeed => 'Afspeelsnelheid';

  @override
  String get viewerSphere =>
      '360°-weergave. Sleep om rond te kijken, knijp om te zoomen';

  @override
  String get viewerText => 'Tekst in deze foto';

  @override
  String get viewerTextCopied => 'Tekst gekopieerd';

  @override
  String get viewerTextNone => 'Geen tekst gevonden in deze foto';

  @override
  String get viewerTextUnread => 'De tekst van deze foto is nog niet gelezen';

  @override
  String get viewerUnmute => 'Dempen opheffen';

  @override
  String get viewerZoomIn => 'Inzoomen';

  @override
  String get viewerZoomOut => 'Uitzoomen';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD-kaart',
      'other': 'Intern',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Inzoomen';

  @override
  String get zoomOut => 'Uitzoomen';
}
