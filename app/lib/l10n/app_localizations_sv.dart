// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get actionAddToAlbum => 'Lägg till i album';

  @override
  String get actionArchive => 'Arkivera';

  @override
  String get actionCopyTo => 'Kopiera till…';

  @override
  String get actionDeleteForever => 'Radera permanent';

  @override
  String get actionFavourite => 'Favoritmarkera';

  @override
  String get actionHide => 'Dölj';

  @override
  String get actionMoveTo => 'Flytta till…';

  @override
  String get actionRename => 'Byt namn';

  @override
  String get actionRestore => 'Återställ';

  @override
  String get actionShare => 'Dela';

  @override
  String get actionTrash => 'Flytta till papperskorgen';

  @override
  String get actionUnarchive => 'Ta ur arkivet';

  @override
  String get actionUndo => 'Ångra';

  @override
  String get actionUnfavourite => 'Ta bort från favoriter';

  @override
  String get actionUnhide => 'Visa igen';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Aktivt',
      'disabled': 'Inaktiverat',
      'invited': 'Inbjudet',
      'deleted': 'Raderat',
      'other': 'Okänt',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Konton';

  @override
  String get adminAddAccount => 'Lägg till konto';

  @override
  String get adminAddExternalLibrary => 'Lägg till ett externt bibliotek';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts försök',
      one: '1 försök',
      zero: 'har inte körts än',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Granskningslogg';

  @override
  String get adminBackUpNow => 'Säkerhetskopiera nu';

  @override
  String get adminBackupQueued =>
      'Säkerhetskopian står i kö; en återställningsövning följer';

  @override
  String get adminBackups => 'Säkerhetskopior av databasen';

  @override
  String get adminCancelJob => 'Avbryt jobb';

  @override
  String get adminCapabilities => 'Funktioner';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Hanterade bibliotek',
      'uploads': 'Uppladdningar från enheter, webben och CLI',
      'folder_browser': 'Mappbläddrare',
      'device_folders': 'Enhetsmappar i anslutna appar',
      'sharing': 'Delning och offentliga länkar',
      'edits': 'Redigeringar',
      'deletes': 'Borttagningar',
      'xmp_writes': 'Skrivning av XMP-filer',
      'face_recognition': 'Ansiktsigenkänning',
      'ml_search': 'Smart sökning',
      'other': 'Okänd',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Varning',
      'fail': 'Misslyckades',
      'other': 'Okänt',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Kopierat';

  @override
  String get adminCopyBundle => 'Kopiera diagnostik för en felrapport';

  @override
  String get adminCopyLink => 'Kopiera länk';

  @override
  String get adminDelete => 'Radera';

  @override
  String get adminDeviceBackups => 'Enheternas säkerhetskopior';

  @override
  String get adminDevices => 'Dina enheter';

  @override
  String get adminDisable => 'Inaktivera';

  @override
  String adminDrillFailed(String detail) {
    return 'Den senaste återställningsövningen misslyckades: $detail';
  }

  @override
  String get adminEdit => 'Redigera';

  @override
  String get adminEmail => 'E-post';

  @override
  String get adminEnable => 'Aktivera';

  @override
  String get adminErrorSignIn => 'Logga in som administratör';

  @override
  String get adminFacesDefault =>
      'Ansiktsigenkänning är på som standard för nya konton';

  @override
  String get adminFiles => 'Filer per typ';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Skadad',
      'missing': 'Saknas',
      'size': 'Fel storlek',
      'hash': 'Ersatt',
      'orphan': 'Lös fil',
      'other': 'Okänd',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size ledigt';
  }

  @override
  String get adminFreeDisk =>
      'Pausa uppladdningar när det lediga diskutrymmet understiger detta, i procent, 0 till 50';

  @override
  String get adminFreeDiskGb =>
      'eller under detta lediga utrymme i GB, om det är mindre, 0 till 100000';

  @override
  String get adminHandle => 'Inloggningsnamn';

  @override
  String get adminIntegrity => 'Integritet';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString objekt',
      one: '1 objekt',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'I kö',
      'running': 'Körs',
      'done': 'Klart',
      'dead': 'Misslyckat',
      'cancelled': 'Avbrutet',
      'other': 'Alla',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Jobbtyp, till exempel render';

  @override
  String get adminJobs => 'Jobb';

  @override
  String adminLastSeen(String time) {
    return 'Senast sedd $time';
  }

  @override
  String get adminLibraries => 'Bibliotek';

  @override
  String get adminLibraryOwner => 'Ägare';

  @override
  String get adminLibraryRoot => 'Mapp på servern, till exempel /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Online',
      'offline': 'Offline',
      'scanning': 'Skannar',
      'error': 'Fel',
      'other': 'Okänt',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Serverlogg';

  @override
  String get adminName => 'Namn';

  @override
  String get adminNothing => 'Inget här än';

  @override
  String get adminOutOfRange => 'Utanför tillåtet intervall';

  @override
  String get adminOverview => 'Översikt';

  @override
  String get adminPair => 'Para ihop en enhet';

  @override
  String get adminPairBody =>
      'Skanna koden eller skicka länken och klistra in den under Lägg till en server i Photolib på den nya enheten: den tar med alla serverns adresser och dess certifikat, så att ingen behöver skriva dem.';

  @override
  String get adminPasswordSetup => 'Länk för att ställa in lösenord';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Skicka länken till $name på valfritt sätt, eller låt hen skanna koden. Den ställer in ett lösenord en gång, till $date.';
  }

  @override
  String get adminPause => 'Pausa en jobbtyp';

  @override
  String adminPauseMinutes(int max) {
    return 'Minuter, 1 till $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type är pausad till $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString objekt kvar att säkerhetskopiera',
      one: '1 objekt kvar att säkerhetskopiera',
      zero: 'Inget kvar att säkerhetskopiera',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Policyer';

  @override
  String get adminPolicyReset => 'Använd värdet från nivån ovanför';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'På som standard',
      'server': 'Inställt för servern',
      'user': 'Inställt för det här kontot',
      'library': 'Inställt för det här biblioteket',
      'config': 'Inställt i konfigurationen',
      'other': 'Okänd',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Använd en förinställning';

  @override
  String get adminPresetBody =>
      'En förinställning ställer in varje funktion för servern och rensar det som konton och bibliotek har ställt in. Allt går att ändra efteråt.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Arkivvisning',
      'family_backup': 'Familjebackup',
      'personal': 'Personlig',
      'other': 'Okänd',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'De externa skrivskyddade biblioteken är den enda sanningskällan: inga uppladdningar, hanterade bibliotek, enhetsmappar, redigeringar, borttagningar eller XMP-skrivningar',
      'family_backup': 'Allt på utom XMP-skrivningar',
      'personal': 'Allt på utom delning och offentliga länkar',
      'other': 'Okänd',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Länkens QR-kod';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString jobb i kö',
      one: '1 jobb i kö',
      zero: 'Inget att göra',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'Lagringskvot i GB; tomt för obegränsat';

  @override
  String get adminRemote => 'Fjärråtkomst';

  @override
  String get adminRemoteBody =>
      'Nå servern varifrån som helst utan att öppna en port i routern. Välj ett sätt; vart och ett ger den en HTTPS-adress att lägga till i apparna. Testa den sedan utifrån.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared ansluter utåt till Cloudflare, som levererar din domän över HTTPS. Gratisplanen begränsar en förfrågan till 100 MB, vilket säkerhetskopior aldrig når: de skickar 8 MiB åt gången.';

  @override
  String get adminRemoteNoAddress =>
      'Lägg till serverns adress med https:// i den här appen för att testa den utifrån.';

  @override
  String get adminRemoteReachable => 'Nåbar utifrån.';

  @override
  String get adminRemoteTailscale =>
      'Installera Tailscale på serverns dator och på varje enhet, i samma tailnet eller din Headscale, kör sedan detta på serverns dator och sätt public_url till adressen som skrivs ut.';

  @override
  String get adminRemoteTest => 'Testa utifrån';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host öppnar $url från sina servrar runt om i världen och får därmed veta adressen. Fortsätta?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Inte nåbar utifrån: kontrollera sättet du valde och testa igen.';

  @override
  String get adminRemoteWireguard =>
      'Kräver en öppen UDP-port på serverns sida eller på en nod. Det här är konfigurationen för en enhet; skapa nycklar med wg genkey.';

  @override
  String get adminRepair =>
      'Lägg tillbaka den från en säkerhetskopia eller en enhet som fortfarande har den';

  @override
  String get adminRepairOrphan =>
      'Inget foto pekar på den: kontrollera den och ta sedan bort eller behåll den';

  @override
  String get adminReprocess => 'Bearbeta igen';

  @override
  String get adminReprocessFaces => 'Identifiera ansikten igen';

  @override
  String get adminReprocessFolder =>
      'Mapp, till exempel 2024/05; tomt för hela biblioteket';

  @override
  String get adminReprocessMetadata => 'Läs metadata igen';

  @override
  String get adminReprocessRenditions =>
      'Återskapa miniatyrer och förhandsvisningar';

  @override
  String get adminRestore => 'Återställ';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Återställningen av $name misslyckades: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Ingen återställningsövning har lyckats än';

  @override
  String adminRestoreVerified(String when) {
    return 'Senast verifierade återställning: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd stannar och ersätter vid nästa start hela databasen med $name. Det som ändrats sedan den säkerhetskopian går förlorat, och varje enhet synkar om från början.';
  }

  @override
  String get adminRestoring =>
      'photolibd stannar för att återställa säkerhetskopian';

  @override
  String get adminResume => 'Återuppta';

  @override
  String get adminRetry => 'Försök igen';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administratör',
      'user': 'Användare',
      'viewer': 'Läsare',
      'other': 'Okänd',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Sparat';

  @override
  String get adminScan => 'Skanna nu';

  @override
  String get adminScrubDays =>
      'Dagar för kontrollen att granska varje original, 1 till 3650';

  @override
  String get adminScrubNever => 'Första fullständiga kontrollen pågår';

  @override
  String adminScrubbed(String time) {
    return 'Senaste fullständiga kontroll $time';
  }

  @override
  String get adminSecondAdmin =>
      'Gör en andra person till administratör, så att någon annan kan sköta och återställa servern om du inte kan.';

  @override
  String adminSilent(String time) {
    return 'Tyst sedan $time';
  }

  @override
  String get adminSilentHours =>
      'Timmar utan rapport innan en enhets säkerhetskopiering räknas som tyst, 1 till 8760';

  @override
  String get adminStores => 'Lagring';

  @override
  String get adminThisDevice => 'Den här enheten';

  @override
  String get adminTitle => 'Serveradministration';

  @override
  String get adminTrashDays => 'Dagar i papperskorgen, 1 till 3650';

  @override
  String get adminTwoFactor => 'Alla konton måste ställa in en andra faktor';

  @override
  String get adminUsage => 'Användning per konto';

  @override
  String get albumCover => 'Använd som omslag';

  @override
  String get albumEmpty => 'Det här albumet är tomt';

  @override
  String get albumHideMemories => 'Dölj från minnen';

  @override
  String get albumHideTimeline => 'Dölj från tidslinjen';

  @override
  String get albumNew => 'Nytt album';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Valfritt datum';

  @override
  String get backupCap => 'Största objekt';

  @override
  String get backupCharging => 'Bara vid laddning';

  @override
  String backupCompleted(String time) {
    return 'Senaste fullständiga säkerhetskopia: $time';
  }

  @override
  String backupContact(String time) {
    return 'Senaste kontakt med servern: $time';
  }

  @override
  String get backupEnabled => 'Säkerhetskopiera den här enheten';

  @override
  String get backupFolderNo => 'Inte den här';

  @override
  String get backupFolderYes => 'Säkerhetskopiera';

  @override
  String backupHours(int count) {
    return '$count tim';
  }

  @override
  String get backupMetered =>
      'På nätverk med datapriser, som mobildata eller en surfzon';

  @override
  String get backupNever => 'Ingen fullständig säkerhetskopia än';

  @override
  String backupNewFolder(String name) {
    return 'Ny mapp $name: säkerhetskopiera den?';
  }

  @override
  String get backupNoLimit => 'Ingen gräns';

  @override
  String get backupNothing => 'Inget väntar';

  @override
  String get backupNow => 'Säkerhetskopiera nu';

  @override
  String backupOverdue(int hours, String items) {
    return 'Ingen fullständig säkerhetskopia på $hours tim. Väntar: $items';
  }

  @override
  String get backupOverdueTitle => 'Säkerhetskopieringen är inte klar';

  @override
  String backupPending(String items) {
    return 'Väntar: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Nytt försök: $time';
  }

  @override
  String get backupRoaming => 'Säkerhetskopiera vid roaming';

  @override
  String get backupSignIn =>
      'Logga in på en server för att säkerhetskopiera den här enheten';

  @override
  String get backupSignedOut =>
      'Säkerhetskopieringen stoppades: servern loggade ut den här enheten. Logga in igen i Inställningar.';

  @override
  String get backupSince => 'Tagna sedan';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Säkerhetskopieringen väntar tills servern går att nå',
      'charging': 'Säkerhetskopieringen väntar tills enheten laddas',
      'battery_low': 'Säkerhetskopieringen väntar: batteriet är svagt',
      'roaming': 'Säkerhetskopieringen väntar under roaming',
      'quota': 'Säkerhetskopieringen stoppades: ditt lagringsutrymme på servern är fullt',
      'second_factor': 'Säkerhetskopieringen stoppades: servern kräver en andra faktor för det här kontot',
      'other': 'Säkerhetskopieringen stoppades: servern svarade $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Säkerhetskopiering';

  @override
  String get backupWaiting => 'Inte säkerhetskopierat';

  @override
  String get backupWarnAfter => 'Varna när den inte är klar på';

  @override
  String get backupWhat => 'Vad som säkerhetskopieras';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'I en mapp du inte valt',
      'folder_new': 'I en ny mapp: välj om den ska säkerhetskopieras',
      'type_excluded': 'En sorts objekt du inte valt',
      'before_date': 'Taget före det datum du valt',
      'selected': 'Väntar på sin tur',
      'server_restored':
          'Servern förlorade det vid en återställning: skickas igen',
      'working': 'Säkerhetskopieras',
      'waiting_for_icloud': 'Väntar på att iCloud laddar ned det',
      'metered': 'Väntar på ett nätverk utan datapriser',
      'metered_cap': 'För stort för ett nätverk med datapriser',
      'unreadable': 'Den här enheten kan inte läsa det',
      'changed': 'Det ändrades medan det skickades',
      'quota': 'Ditt lagringsutrymme på servern är fullt',
      'other': 'Servern avvisade det: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Servern fungerar inte längre med den här versionen av Photolib.';

  @override
  String get checkAppTooOldNext => 'Uppdatera Photolib.';

  @override
  String get checkChanged => 'Serverns certifikat är inte det du litade på.';

  @override
  String get checkChangedNext =>
      'Om din administratör har bytt ut det, lita på det nya. Annars kanske någon tjuvlyssnar: fortsätt inte.';

  @override
  String get checkClock =>
      'Den här enhetens klocka och serverns skiljer sig åt med mer än fem minuter.';

  @override
  String get checkClockNext =>
      'Låt enheten ställa in datum och tid automatiskt.';

  @override
  String get checkDnsFailed => 'Serverns namn leder inte till någon adress.';

  @override
  String get checkDnsFailedNext =>
      'Kontrollera adressen eller anslut till serverns nätverk.';

  @override
  String checkExpired(String date) {
    return 'Serverns certifikat gick ut den $date.';
  }

  @override
  String get checkFailed => 'Misslyckades';

  @override
  String get checkMetered =>
      'Du är på ett nätverk med datapriser, till exempel mobildata.';

  @override
  String get checkMeteredNext => 'Anslut till wifi före stora säkerhetskopior.';

  @override
  String get checkNotPhotolib =>
      'Något annat än Photolib svarar, till exempel en proxys felsida eller en inloggningssida för wifi.';

  @override
  String get checkNotPhotolibNext =>
      'Logga in på wifi i webbläsaren eller be din administratör kontrollera proxyn.';

  @override
  String get checkOtherServer =>
      'En annan Photolib-server svarar på den här adressen.';

  @override
  String get checkPassed => 'Godkänd';

  @override
  String get checkRefused => 'Ingenting svarar på den här adressen.';

  @override
  String get checkRefusedNext =>
      'Kontrollera att servern är igång och att du är på dess nätverk eller VPN.';

  @override
  String get checkRun => 'Kontrollera anslutningen';

  @override
  String get checkRunning => 'Kontrollerar';

  @override
  String get checkSelfSigned =>
      'Servern använder ett eget certifikat som den här enheten inte känner till än.';

  @override
  String get checkSkipped => 'Inte kontrollerad';

  @override
  String get checkStepAuth => 'Din inloggning';

  @override
  String get checkStepClock => 'Enhetens klocka';

  @override
  String get checkStepDns => 'Hitta serverns adress';

  @override
  String get checkStepNetwork => 'Ditt nätverk';

  @override
  String get checkStepServer => 'Photolib på servern';

  @override
  String get checkStepTcp => 'Nå servern';

  @override
  String get checkStepTls => 'Säker anslutning och certifikat';

  @override
  String get checkStepUpload => 'Stora uppladdningar genom proxyer';

  @override
  String get checkTimedOut => 'Servern tar för lång tid att svara.';

  @override
  String get checkTimedOutNext =>
      'Kontrollera din anslutning och försök sedan igen.';

  @override
  String get checkTitle => 'Anslutningskontroll';

  @override
  String get checkTlsFailed => 'Den säkra anslutningen misslyckades.';

  @override
  String get checkTrustNext =>
      'Lita bara på det om dess fingeravtryck stämmer med din servers.';

  @override
  String get checkUntrusted =>
      'Serverns certifikat kommer från en utfärdare som den här enheten inte litar på.';

  @override
  String get checkUploadCap =>
      'En proxy på vägen nekar stora uppladdningar, så säkerhetskopior går långsammare, i små delar.';

  @override
  String get checkUploadCapNext =>
      'Be din administratör att släppa igenom förfrågningar på 64 MB genom proxyn.';

  @override
  String get collectionAlbums => 'Album';

  @override
  String collectionHide(String name) {
    return 'Dölj $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Flytta ned $name';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Flytta upp $name';
  }

  @override
  String get collectionPeople => 'Personer';

  @override
  String collectionPin(String name) {
    return 'Fäst $name';
  }

  @override
  String get collectionPlaces => 'Platser';

  @override
  String collectionShow(String name) {
    return 'Visa $name';
  }

  @override
  String get collectionTags => 'Taggar';

  @override
  String collectionUnpin(String name) {
    return 'Lossa $name';
  }

  @override
  String get collectionsCustomise => 'Anpassa';

  @override
  String get collectionsDone => 'Klar';

  @override
  String get commandPalette => 'Kommandopalett';

  @override
  String get commandPaletteHint => 'Skriv ett kommando';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString på den här enheten och säkerhetskopierade',
      one: '$countString på den här enheten och säkerhetskopierade',
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
      other: '$countString bara på den här enheten, inte säkerhetskopierade',
      one: '$countString bara på den här enheten, inte säkerhetskopierade',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Med iCloud-bilder på försvinner objekt som du raderar från den här enheten också från iCloud och dina andra Apple-enheter.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString bara i ditt bibliotek',
      one: '$countString bara i ditt bibliotek',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Ta bort från den här enheten';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'De $countString säkerhetskopierade objekten; ditt bibliotek behåller dem',
      one: 'Det säkerhetskopierade objektet; ditt bibliotek behåller det',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Kopior på den här enheten hamnar i dess papperskorg: utrymmet frigörs när den töms.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Radera $countString objekt?',
      one: 'Radera $countString objekt?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Från den här enheten och ditt bibliotek',
      'device': 'Bara från den här enheten',
      'other': 'Från ditt bibliotek',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Finns inte';

  @override
  String get deviceFolderCard => 'SD-kort';

  @override
  String get deviceFolderExclude => 'Uteslut';

  @override
  String get deviceFolderExcludeThis => 'Uteslut den här mappen';

  @override
  String get deviceFolderExcludedNotice =>
      'Mappen för det här objektet är utesluten från biblioteket';

  @override
  String get deviceFolderForget => 'Ta bort från listan';

  @override
  String get deviceFolderInternal => 'Internminne';

  @override
  String get deviceFolderKeep => 'Behåll';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, är ny';
  }

  @override
  String get deviceFolders => 'Mappar på enheten';

  @override
  String get deviceFoldersAll => 'Visa alla mappar utom de uteslutna';

  @override
  String get deviceFoldersChosen => 'Visa bara de valda mapparna';

  @override
  String get deviceFoldersExcludedNow => 'Utesluten från biblioteket';

  @override
  String get deviceFoldersSearch => 'Sök mappar';

  @override
  String get diagnosticsAdvanced => 'Visa diagnostik';

  @override
  String get diagnosticsAllLoggers => 'Alla källor';

  @override
  String get diagnosticsCopied => 'Loggen kopierades';

  @override
  String get diagnosticsCopy => 'Kopiera den visade loggen';

  @override
  String get diagnosticsEmpty => 'Inga loggposter än';

  @override
  String get diagnosticsExport => 'Exportera diagnostikpaket';

  @override
  String get diagnosticsExported => 'Diagnostikpaketet sparades';

  @override
  String get diagnosticsLevel => 'Nivå';

  @override
  String get diagnosticsLogger => 'Källa';

  @override
  String get diagnosticsTitle => 'Diagnostik';

  @override
  String get download => 'Ladda ned';

  @override
  String get downloadCurrent => 'Aktuell version, med redigeringar';

  @override
  String get downloadFailed => 'Det gick inte att ladda ned';

  @override
  String get downloadOriginal => 'Original';

  @override
  String downloadSaved(String name) {
    return '$name har sparats';
  }

  @override
  String get downloadVersion => 'Vilken version?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Laddar ned $countString objekt',
      one: 'Laddar ned $countString objekt',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Förbättra automatiskt';

  @override
  String get editorCrop => 'Beskär';

  @override
  String get editorCropOriginal => 'Original';

  @override
  String get editorCropSquare => 'Kvadrat';

  @override
  String get editorEdit => 'Redigera';

  @override
  String get editorFlip => 'Spegelvänd';

  @override
  String get editorRotate => 'Rotera';

  @override
  String get editorSaveCopy => 'Spara kopia';

  @override
  String get editorSaveFailed => 'Det gick inte att spara kopian';

  @override
  String get editorSaveVersion => 'Spara';

  @override
  String get editorSaved => 'Sparad som kopia';

  @override
  String get editorVersionFailed => 'Versionen kunde inte sparas';

  @override
  String get editorVersionSaved => 'Sparad som ny version';

  @override
  String get editorVersionsUnsupported =>
      'Den här servern kan ännu inte spara versioner av redigerade foton';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ändringar ångrades: servern avvisade dem.',
      one: '1 ändring ångrades: servern avvisade den.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Stäng';

  @override
  String get editsRejectedForbidden =>
      'Du får visa objekten men inte ändra dem.';

  @override
  String get editsRejectedInvalid => 'Servern kunde inte ta emot ändringarna.';

  @override
  String get editsRejectedNotFound =>
      'Objekten har raderats eller delas inte längre med dig.';

  @override
  String get errorNotFound => 'Den här sidan finns inte';

  @override
  String get errorRetry => 'Försök igen';

  @override
  String get errorTitle => 'Något gick fel';

  @override
  String faceNumber(int number) {
    return 'Ansikte $number';
  }

  @override
  String get facesAgree => 'Jag godkänner';

  @override
  String get facesAura => 'Beskriv ansikten med AuraFace (större nedladdning)';

  @override
  String get facesNotNow => 'Inte nu';

  @override
  String get facesNoticeKeep =>
      'Det som hittas stannar hos dina foton, på dina enheter och din server. Beskrivningarna visas eller delas aldrig, och allt raderas när du slutar eller tar bort fotot.';

  @override
  String get facesNoticeOptional =>
      'Det är valfritt. Allt annat i Photolib fungerar utan det, och du kan sluta när som helst i Inställningar.';

  @override
  String get facesNoticeTitle => 'Hitta ansikten i dina foton?';

  @override
  String get facesNoticeWhat =>
      'Photolib letar efter ansikten i dina foton och videor och sparar för varje ansikte var det finns och en lista med tal som beskriver det, så att samma person kan hittas igen. En sådan beskrivning kan räknas som biometriska uppgifter.';

  @override
  String get facesNoticeWhere =>
      'Det sker på den här enheten och, om du är inloggad, på din egen server. Aldrig i en tjänst som drivs av oss eller någon annan.';

  @override
  String get facesServerFailed =>
      'Din server kunde inte underrättas. Försök igen.';

  @override
  String get facesServerOff => 'Din server hittar inga ansikten åt dig';

  @override
  String get facesServerOn => 'Din server hittar ansikten åt dig';

  @override
  String get facesServerUnavailable =>
      'Din server erbjuder inte ansiktsigenkänning';

  @override
  String facesStatusDownloading(int percent) {
    return 'Laddar ned ansiktsmodellerna: $percent %';
  }

  @override
  String get facesStatusMissing =>
      'Din server har inte installerat ansiktsmodellerna';

  @override
  String get facesStatusNoDecoder =>
      'Ansiktssökning är inte tillgänglig: bildbiblioteket (libvips) hittades inte. Installera om Photolib, eller installera libvips och starta om appen.';

  @override
  String get facesStatusRunning => 'Hittar ansikten på den här enheten';

  @override
  String get facesStatusUnavailable =>
      'Ansikten kan inte hittas på den här enheten';

  @override
  String get facesStatusWaiting => 'Ansiktsmodellerna laddas ned över Wi-Fi';

  @override
  String get facesSwitch => 'Hitta ansikten i mina foton';

  @override
  String get facesSwitchOff =>
      'Av. Inget om ansikten beräknas förrän du godkänner.';

  @override
  String get facesSwitchOn => 'På. Photolib hittar ansikten i dina foton.';

  @override
  String get facesTitle => 'Ansikten och personer';

  @override
  String get facesWithdraw => 'Radera och sluta';

  @override
  String get facesWithdrawBody =>
      'Det här raderar alla ansikten, beskrivningar och personer som Photolib hittat åt dig, på den här enheten och på din server. Dina foton ändras inte.';

  @override
  String get facesWithdrawTitle => 'Sluta hitta ansikten?';

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

    return 'Filer som inte ändrades: $countString';
  }

  @override
  String get folderAllow => 'Tillåt åtkomst till den här mappen';

  @override
  String get folderDelete => 'Ta bort mapp';

  @override
  String folderDeleteBody(String name) {
    return 'Flytta foton och videor i $name till papperskorgen?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString objekt',
      one: '1 objekt',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Ny mapp';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline, $countString objekt',
      one: 'Offline, 1 objekt',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Den här mappen, en mapp i den eller en mapp som innehåller den finns redan i biblioteket';

  @override
  String get folderRemove => 'Ta bort mapp';

  @override
  String folderRemoveBody(String folder) {
    return 'Foton och videor i $folder tas bort från biblioteket. Filerna ligger kvar orörda på disken.';
  }

  @override
  String get folderRemoveConfirm => 'Ta bort';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Skannar, $countString objekt hittills',
      one: 'Skannar, 1 objekt hittills',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Tillåt åtkomst';

  @override
  String get foldersHideExcluded => 'Dölj undantagna mappar';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib kan inte längre läsa $countString mappar.',
      one: 'Photolib kan inte längre läsa 1 mapp.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Visa undantagna mappar ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Den här webbläsaren kan inte använda en mapp som ditt bibliotek. Öppna Photolib i Chrome eller Edge på en dator, eller använd skrivbordsappen.';

  @override
  String get galleryButtons => 'Knappar';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryGrid => 'Rutnät';

  @override
  String get galleryMenus => 'Menyer och paneler';

  @override
  String get galleryShowSheet => 'Visa en panel';

  @override
  String get galleryTitle => 'Komponenter';

  @override
  String hiddenCollections(int count) {
    return 'Dolda ($count)';
  }

  @override
  String get indexingAllowMetered => 'Ladda ned via mobildata';

  @override
  String get indexingAllowSaver => 'Även i energisparläge';

  @override
  String get indexingBattery => 'Batterinivå som krävs utan laddare';

  @override
  String get indexingChargingOnly => 'Bara under laddning';

  @override
  String indexingDownloading(int percent) {
    return 'Laddar ned sökmodellen: $percent %';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foton kunde inte läsas',
      one: '1 foto kunde inte läsas',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Den här enheten indexerar bara sina nya foton';

  @override
  String get indexingMissing => 'Din server har inte installerat sökmodellen';

  @override
  String get indexingModels => 'Sök på den här enheten';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Laddar ned sökmodellen ($megabytesString MB) från $host';
  }

  @override
  String get indexingNoDecoder =>
      'Sökning och textläsning är inte tillgängliga: bildbiblioteket (libvips) hittades inte. Installera om Photolib, eller installera libvips och starta om appen.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Pausad medan batteriet är under $percent %';
  }

  @override
  String get indexingPausedCharger => 'Pausad tills enheten laddas';

  @override
  String get indexingPausedHeat => 'Pausad medan enheten är varm';

  @override
  String get indexingPausedSaver => 'Pausad medan batterisparläget är på';

  @override
  String indexingPercent(int percent) {
    return '$percent %';
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

    return 'Indexerade bilder: $doneString av $totalString';
  }

  @override
  String get indexingText => 'Läs text i foton';

  @override
  String indexingTextDownloading(int percent) {
    return 'Hämtar textmodellerna: $percent %';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Hämtar textmodellerna ($megabytesString MB) från $host; hittar orden i dina foton';
  }

  @override
  String get indexingTextMissing =>
      'Din server har inte installerat textmodellerna';

  @override
  String get indexingTextPlatform =>
      'Använder telefonens egen textigenkänning; inget att hämta. Läser nya foton';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Foton lästa för text: $doneString av $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Textläsning är inte tillgänglig här';

  @override
  String get indexingTextWaiting => 'Textmodellerna hämtas över Wi-Fi';

  @override
  String get indexingUnavailable =>
      'Sökning på den här enheten är inte tillgänglig här';

  @override
  String get indexingWaiting => 'Sökmodellen laddas ned via wifi';

  @override
  String get infoAddName => 'Lägg till namn';

  @override
  String get infoAddTag => 'Lägg till tagg';

  @override
  String get infoAlbums => 'Album';

  @override
  String get infoAllMetadata => 'Visa all metadata';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Säkerhetskopierad';

  @override
  String get infoCamera => 'Kamera';

  @override
  String get infoChangeAdjust => 'Färger justerade';

  @override
  String get infoChangeCrop => 'Beskuren';

  @override
  String get infoChangeFlip => 'Speglad';

  @override
  String get infoChangeInpaint => 'Område fyllt';

  @override
  String get infoChangeLocal => 'Område justerat';

  @override
  String get infoChangeLut => 'Färgstil använd';

  @override
  String get infoChangeOther => 'Redigerad';

  @override
  String get infoChangeTurn => 'Roterad';

  @override
  String get infoCompare => 'Jämför med originalet';

  @override
  String infoConfidence(String percent) {
    return 'Säkerhet: $percent';
  }

  @override
  String get infoCopyPath => 'Kopiera sökväg';

  @override
  String get infoCurrent => 'Aktuell';

  @override
  String get infoDescription => 'Lägg till en beskrivning';

  @override
  String get infoEditDate => 'Redigera datumet';

  @override
  String infoEditNumber(int number) {
    return 'Redigering $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Redigerad kopia av $name';
  }

  @override
  String get infoFaces => 'Ansikten';

  @override
  String get infoFile => 'Fil';

  @override
  String get infoFromFileName => 'från filnamnet';

  @override
  String get infoHistory => 'Redigeringshistorik';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objekt',
      one: '$count objekt',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Plats';

  @override
  String get infoMap => 'Karta över var den togs';

  @override
  String get infoMapAgree =>
      'Kartbrickor hämtas från internet och visar vilket område du tittar på';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Ny tagg: $path';
  }

  @override
  String get infoNoAlbum => 'Inte i något album';

  @override
  String get infoOnDevice => 'På den här enheten';

  @override
  String get infoOriginal => 'Original';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString pixlar';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Ta bort från $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Ta bort $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Borttagen från $album';
  }

  @override
  String get infoRevert => 'Återställ';

  @override
  String get infoSaveCopy => 'Spara som kopia';

  @override
  String get infoShared => 'delat';

  @override
  String get infoShowFaces => 'Visa ansikten på fotot';

  @override
  String get infoShowMap => 'Visa karta';

  @override
  String get infoTags => 'Taggar';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versioner',
      one: '$count version',
    );
    return '$_temp0 · senast $time';
  }

  @override
  String get infoWhy => 'Varför det här datumet?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Läst i filen, som $tag',
      'name': 'Läst i filnamnet',
      'folder': 'Läst i namnet på en mapp',
      'host': 'Angivet av tjänsten som filen kom från',
      'unknown': 'Inget i filen daterar den, så datumet då den senast ändrades används',
      'other': 'Filen är inte läst än, så datumet som enheten anger används',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Lista',
      'other': 'Rutnät',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Namn',
      'taken': 'Fotograferingsdatum',
      'modified': 'Ändringsdatum',
      'size': 'Storlek',
      'random': 'Slumpvis',
      'extension': 'Typ',
      'custom': 'Albumets ordning',
      'other': 'Fotograferingsdatum',
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
  String get keyShift => 'Skift';

  @override
  String get languageDevice => 'Enhetens språk';

  @override
  String get languageName => 'Svenska';

  @override
  String get libraryAddFolder => 'Lägg till mapp';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Inte säkerhetskopierad',
      'backed_up': 'Säkerhetskopierad',
      'cloud_only': 'Bara i molnet',
      'other': 'Alla',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Allt är säkerhetskopierat',
      'backed_up': 'Inget är säkerhetskopierat än',
      'cloud_only': 'Inget finns bara på servern',
      'other': 'Inget här',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Märken för säkerhetskopiering';

  @override
  String get libraryEmpty => 'Dina foton visas här';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Gruppera per vecka',
      'month': 'Gruppera per månad',
      'other': 'Gruppera per dag',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'Dölj dolda och arkiverade objekt igen';

  @override
  String get libraryNoKeyring =>
      'Photolib förvarar nyckeln till ditt bibliotek i systemets nyckelring, som inte körs eller är låst. Starta eller lås upp en nyckelring, till exempel GNOME Keyring eller KWallet, och försök igen.';

  @override
  String get libraryRevealExcluded => 'Visa uteslutna mappar i 5 minuter';

  @override
  String get libraryShowVeiled =>
      'Visa dolda och arkiverade objekt i 5 minuter';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Nyligen tillagda',
      'other': 'Fotograferingsdatum',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib kunde inte öppna biblioteket som finns på den här enheten';

  @override
  String get libraryViewOptions => 'Visningsalternativ';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Förbereder miniatyrer: $doneString av $totalString';
  }

  @override
  String get libraryZoomIn => 'Större miniatyrer';

  @override
  String get libraryZoomOut => 'Mindre miniatyrer';

  @override
  String get mapAddTrack => 'Lägg till ett GPX-spår';

  @override
  String get mapArea => 'Kartområde';

  @override
  String get mapAttribution => '© OpenStreetMap-bidragsgivare';

  @override
  String get mapClearLasso => 'Rensa markeringen';

  @override
  String get mapEmpty => 'Inga foton med plats ännu';

  @override
  String get mapHeat => 'Värmekarta';

  @override
  String get mapLasso => 'Markera genom att rita runt foton';

  @override
  String get mapLoading => 'Placerar foton på kartan';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Foton: $countString';
  }

  @override
  String get mapSearchHere => 'Sök i det här området';

  @override
  String get mapSplit => 'Visa fotona under kartan';

  @override
  String get mapTilesAgree =>
      'Kartbakgrunden kommer från OpenStreetMaps server (tile.openstreetmap.org), som ser vilket område du tittar på';

  @override
  String get mapTilesShow => 'Visa bakgrunden';

  @override
  String get mapTime => 'Tidsintervall';

  @override
  String get mapTitle => 'Karta';

  @override
  String get mapTrackBad => 'Filen innehåller inga GPX-spår';

  @override
  String get mapTrips => 'Resor';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favorit',
      'hidden': 'Dold',
      'archived': 'Arkiverad',
      'offline': 'Behålls på den här enheten',
      'offline': 'Behålls på den här enheten',
      'offline': 'Behålls på den här enheten',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Tillåt åtkomst';

  @override
  String get mediaAccessNone =>
      'Photolib behöver åtkomst till dina foton och videor för att kunna visa dem.';

  @override
  String get mediaAccessPartial =>
      'Photolib ser bara de foton och videor som du har valt. Ett galleri behöver åtkomst till alla.';

  @override
  String get mediaAccessSelect => 'Välj fler foton';

  @override
  String get nameLabel => 'Namn';

  @override
  String get nextAddRoot =>
      'Lägg till mappen i external_roots i serverns konfiguration och starta sedan om servern.';

  @override
  String get nextAskAdmin => 'Fråga serverns administratör.';

  @override
  String get nextAskOwner =>
      'Be bibliotekets ägare att låta dig lägga till foton.';

  @override
  String get nextCheckConnection =>
      'Kontrollera anslutningen för att se varför.';

  @override
  String get nextCheckEntry => 'Kontrollera vad du skrev och försök igen.';

  @override
  String get nextConfirm =>
      'Kontrollera hur många objekt det gäller och bekräfta sedan.';

  @override
  String get nextDeleteWebhook =>
      'Ta bort en webhook som du inte längre använder och försök igen.';

  @override
  String get nextEditConfig =>
      'Ändra det i serverns konfiguration och starta sedan om servern.';

  @override
  String get nextFreeSpace =>
      'Frigör utrymme eller be din administratör om mer.';

  @override
  String get nextNewLink => 'Be din administratör om en ny.';

  @override
  String get nextNewestToken => 'Kopiera den senaste från photolibd:s logg.';

  @override
  String get nextOtherAdmin => 'Gör först ett annat konto till administratör.';

  @override
  String get nextOtherFolder => 'Välj en egen mapp.';

  @override
  String get nextRefresh => 'Uppdatera och försök igen.';

  @override
  String get nextReport =>
      'Försök igen. Om det händer igen, kopiera detaljerna nedan till din administratör.';

  @override
  String get nextSetUpPrivate =>
      'Slutför konfigurationen av privata bibliotek i Inställningar och försök sedan igen.';

  @override
  String get nextSignIn => 'Logga in igen.';

  @override
  String get nextSignInAccount => 'Logga in med ditt konto och försök igen.';

  @override
  String get nextSignInInstead => 'Logga in i stället.';

  @override
  String get nextTryAgain => 'Försök igen.';

  @override
  String get nextUpdateAndAgree =>
      'Uppdatera appen och godkänn meddelandet igen.';

  @override
  String get nextUseAnother => 'Välj en annan.';

  @override
  String get nextUseHttps =>
      'Använd serverns adress med https:// eller anslut från serverns eget nätverk.';

  @override
  String get nextWait => 'Vänta en minut och försök sedan igen.';

  @override
  String get offlineKeep => 'Behåll offline';

  @override
  String offlineKeepHere(String size) {
    return 'Behåll på den här enheten ($size)';
  }

  @override
  String get offlineKeptHere => 'Behålls på den här enheten';

  @override
  String get offlineStopKeeping => 'Sluta behålla offline';

  @override
  String get otherFiles => 'Övriga filer';

  @override
  String get passphraseCreate =>
      'Den här datorn kör ingen nyckelring (Secret Service) som kan förvara Photolibs nycklar. Välj en lösenfras på minst 10 tecken som skyddar dem: Photolib frågar efter den vid varje start.';

  @override
  String get passphraseLabel => 'Lösenfras';

  @override
  String get passphraseMismatch => 'Lösenfraserna stämmer inte överens.';

  @override
  String get passphraseRepeat => 'Upprepa lösenfrasen';

  @override
  String get passphraseTooShort => 'Använd minst 10 tecken.';

  @override
  String get passphraseUnlock =>
      'Ange lösenfrasen som skyddar Photolibs nycklar på den här datorn.';

  @override
  String get passphraseWrong => 'Fel lösenfras. Försök igen.';

  @override
  String photoPosition(int index, int count) {
    return 'Foto $index av $count';
  }

  @override
  String get privacyCheckKit => 'Kontrollera återställningskit';

  @override
  String get privacyDrillDue =>
      'Dags för en återställningsövning: kontrollera att ditt återställningskit fortfarande låser upp dina privata bibliotek.';

  @override
  String get privacyHonest =>
      'Privata bibliotek krypteras på dina enheter, och ingen annan kan öppna dem: inte servern, inte dess administratör och inte Photolibs utvecklare. Om du förlorar både ditt lösenord och ditt återställningskit är dina foton borta för alltid, och ingen kan hämta tillbaka dem åt dig.';

  @override
  String get privacyKitBody =>
      'Skriv ner de här 24 orden på papper, i ordning, och förvara dem på ett säkert ställe. De låser upp dina privata bibliotek om du glömmer ditt lösenord, för vem som helst som har dem.';

  @override
  String get privacyKitDone => 'Ditt återställningskit fungerar.';

  @override
  String get privacyKitOther =>
      'Det här är inte ditt nuvarande återställningskit.';

  @override
  String get privacyKitTitle => 'Ditt återställningskit';

  @override
  String get privacyKitUnverified => 'Återställningskitet är inte bekräftat än';

  @override
  String privacyKitVerified(String date) {
    return 'Återställningskitet bekräftades $date';
  }

  @override
  String get privacyKitWritten => 'Jag har skrivit ner dem';

  @override
  String get privacyNotReady =>
      'Privata uppladdningar är avstängda tills du har två sätt att låsa upp och har bekräftat ditt återställningskit.';

  @override
  String get privacyPasswordHelp =>
      'Ange ditt kontos lösenord: det blir ett sätt att låsa upp dina privata bibliotek.';

  @override
  String get privacyPhrase => 'Återställningsfras';

  @override
  String get privacyPhraseHelp => 'De 24 orden i ditt återställningskit';

  @override
  String get privacyPhraseInvalid =>
      'Det här är ingen återställningsfras. Kontrollera varje ord.';

  @override
  String get privacyReady => 'Privata uppladdningar är på.';

  @override
  String get privacyRecoveryKit => 'Återställningskit';

  @override
  String get privacySetUp => 'Konfigurera';

  @override
  String get privacyShowWords => 'Visa orden igen';

  @override
  String get privacyTitle => 'Privata bibliotek';

  @override
  String privacyUnknownWord(int number) {
    return 'Ord $number är inget ord i ett återställningskit.';
  }

  @override
  String get privacyVerify => 'Bekräfta';

  @override
  String get privacyVerifyBody =>
      'Skriv de här orden från ditt återställningskit för att visa att du har sparat det.';

  @override
  String get privacyWays => 'Sätt att låsa upp';

  @override
  String privacyWord(int number) {
    return 'Ord $number';
  }

  @override
  String get privacyWordsDiffer =>
      'De här orden stämmer inte med ditt återställningskit. Kontrollera det du skrev ner.';

  @override
  String get privacyWrongPassword => 'Det här är inte ditt kontos lösenord.';

  @override
  String get problemAdminOnly => 'Bara en administratör kan göra det här.';

  @override
  String get problemBusy => 'Servern är upptagen eller startar om.';

  @override
  String get problemChanged => 'Det här har ändrats under tiden.';

  @override
  String get problemConfirm =>
      'Det här skulle dölja eller ta bort fler objekt än servern gör utan bekräftelse';

  @override
  String get problemContribute =>
      'Du får inte lägga till foton i det här biblioteket.';

  @override
  String get problemCopy => 'Kopiera detaljer';

  @override
  String get problemDetails => 'Detaljer';

  @override
  String get problemDiskLow =>
      'Serverns disk är nästan full, så uppladdningar är pausade.';

  @override
  String get problemEmailTaken => 'Ett annat konto har den här e-postadressen.';

  @override
  String get problemExists => 'Den finns redan.';

  @override
  String get problemFaceNotice =>
      'Din server kräver en nyare version av ansiktsmeddelandet än den här appen visar.';

  @override
  String get problemGone => 'Den finns inte längre på servern.';

  @override
  String get problemHandleTaken =>
      'Ett annat konto har det här inloggningsnamnet.';

  @override
  String get problemInterrupted => 'Uppladdningen avbröts.';

  @override
  String get problemInvalid => 'Ett värde är ogiltigt';

  @override
  String get problemLastAdmin => 'Servern behöver minst en administratör.';

  @override
  String get problemLinkInvalid =>
      'Den här länken har gått ut eller redan använts.';

  @override
  String get problemLoginFailed =>
      'Fel e-post, inloggningsnamn eller lösenord.';

  @override
  String get problemMaintenanceKey =>
      'Säkerhetskopiering, integritetskontroller och rensningar kan bara pausas när du är inloggad, inte med en API-nyckel';

  @override
  String get problemNotAllowed => 'Ditt konto får inte göra det här.';

  @override
  String get problemNotExternal =>
      'Bara bibliotek från serverns egna mappar kan genomsökas.';

  @override
  String get problemOidcClaim =>
      'Din inloggningstjänst angav inte vem du är på ett sätt som den här servern godtar.';

  @override
  String get problemOidcDown => 'Din inloggningstjänst svarar inte servern.';

  @override
  String get problemOidcFailed => 'Din inloggningstjänst nekade inloggningen.';

  @override
  String get problemOidcNotAllowed =>
      'Ditt konto får inte logga in på det här sättet.';

  @override
  String get problemOidcTaken =>
      'Den här inloggningen är redan kopplad till ett annat Photolib-konto.';

  @override
  String get problemOidcUnknown =>
      'Den här servern erbjuder inte längre det här sättet att logga in.';

  @override
  String get problemPasskeysOff =>
      'Nycklar fungerar först när servern har sin offentliga adress.';

  @override
  String get problemPinned =>
      'Det här är inställt i konfigurationsfilen och kan inte ändras här.';

  @override
  String get problemPolicyOff => 'Det här är avstängt på den här servern.';

  @override
  String get problemQuota => 'Ditt lagringsutrymme på servern är fullt.';

  @override
  String get problemRestoreKey =>
      'En säkerhetskopia kan bara återställas när du är inloggad, inte med en API-nyckel.';

  @override
  String get problemRootDiffers =>
      'Den här mappen innehåller inte bibliotekets filer';

  @override
  String get problemRootNotAllowed =>
      'Den här mappen ligger inte under serverkonfigurationens external_roots';

  @override
  String get problemRootOverlaps =>
      'Den här mappen innehåller eller ligger i ett annat bibliotek eller serverns egna data';

  @override
  String get problemScanning => 'Det här biblioteket skannas redan';

  @override
  String get problemSecondFactor =>
      'Det här kontot kräver en andra faktor, till exempel en autentiseringskod eller en nyckel, som den här versionen av Photolib inte kan ge än.';

  @override
  String get problemSetupDone => 'Den här servern har redan en administratör.';

  @override
  String get problemSetupExpired => 'Det här tog för lång tid.';

  @override
  String get problemSetupToken => 'Den här konfigurationstoken är fel.';

  @override
  String get problemSignedOut => 'Du är utloggad från servern.';

  @override
  String get problemStepUp =>
      'Den här ändringen kräver först ditt lösenord eller en kod.';

  @override
  String get problemStorage => 'Servern når inte sin lagring.';

  @override
  String get problemTooMany => 'För många försök på kort tid.';

  @override
  String get problemUnexpected => 'Något oväntat gick fel.';

  @override
  String get problemUnreachable => 'Servern svarar inte.';

  @override
  String get problemUploadDamaged => 'Filen ändrades eller skadades på vägen.';

  @override
  String get problemUploadExpired =>
      'Servern har inte längre den här uppladdningen: ofullständiga uppladdningar går ut efter en dag.';

  @override
  String get problemWebhookLimit =>
      'Ditt konto har redan så många webhooks som det får ha.';

  @override
  String get problemWebhooksOff => 'Webhooks är avstängda på den här servern.';

  @override
  String get recoveryCode => 'Återställningskod';

  @override
  String get recoveryCodeAbout =>
      'Öppnar Photolibs lagring på den här enheten om nyckellagret förlorar sin nyckel';

  @override
  String get recoveryCodeEnter => 'Ange återställningskod';

  @override
  String get recoveryCreate => 'Skapa återställningskod';

  @override
  String get recoveryLater => 'Senare';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString ändringar finns bara på den här enheten. En återställningskod får tillbaka dem om nyckellagret förlorar Photolibs nyckel.',
      one: '1 ändring finns bara på den här enheten. En återställningskod får tillbaka den om nyckellagret förlorar Photolibs nyckel.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Skriv ner de här 24 orden och förvara dem säkert: de öppnar Photolibs lagring på den här enheten utan nyckeln i nyckellagret. De ersätter alla tidigare koder.';

  @override
  String get recoveryUnlock => 'Lås upp';

  @override
  String get recoveryWrong =>
      'Det är inte den här lagringens återställningskod';

  @override
  String get renameFind => 'Sök';

  @override
  String get renamePattern => 'Nytt namn';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'För långt: ett namn har högst 255 byte',
      'invalid': 'Inte ett giltigt filnamn',
      'duplicate': 'Ges även till en annan fil',
      'exists': 'En annan fil i den här mappen har det här namnet',
      'other': 'Kan inte byta namn',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Ersätt med';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Filer med nytt namn: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Visa i Finder',
      'windows': 'Visa i Utforskaren',
      'other': 'Visa i mapp',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Kamera';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString objekt',
      one: '1 objekt',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Datum';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Sök i ditt bibliotek';

  @override
  String get searchFavourites => 'Favoriter';

  @override
  String get searchFolder => 'Mapp';

  @override
  String get searchHint => 'Fil- eller mappnamn';

  @override
  String get searchMotionPhotos => 'Rörliga foton';

  @override
  String get searchNothing => 'Inga träffar';

  @override
  String get searchPanoramas => 'Panoramor';

  @override
  String get searchPhotos => 'Foton';

  @override
  String get searchScreenshots => 'Skärmbilder';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Videor';

  @override
  String get securityAddPasskey => 'Lägg till nyckel';

  @override
  String get securityCode => 'Kod';

  @override
  String get securityCodesHelp =>
      'Förvara koderna på ett säkert ställe. Varje kod fungerar en gång i stället för din andra faktor, och de visas bara nu.';

  @override
  String securityCodesLeft(int count) {
    return 'Oanvända: $count';
  }

  @override
  String get securityNewCodes => 'Nya koder';

  @override
  String get securityPasskeyNotAdded => 'Ingen nyckel lades till.';

  @override
  String get securityRecoveryCodes => 'Återställningskoder';

  @override
  String get securityRemovePasskey => 'Ta bort nyckel';

  @override
  String get securitySetUp => 'Ställ in';

  @override
  String get securityStepUpBody =>
      'Ange ditt lösenord, en kod från din autentiseringsapp eller en återställningskod för att ändra dina andra faktorer.';

  @override
  String get securityStepUpTitle => 'Bekräfta att det är du';

  @override
  String get securityTitle => 'Andra faktorer';

  @override
  String get securityTotp => 'Autentiseringsapp';

  @override
  String get securityTotpHelp =>
      'Lägg till den här nyckeln i din autentiseringsapp och ange sedan koden den visar.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': 'På', 'other': 'Av'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Stäng av';

  @override
  String get securityWrongCode => 'Koden är fel.';

  @override
  String get securityWrongProof => 'Fel lösenord eller kod.';

  @override
  String get selectAll => 'Markera alla';

  @override
  String get selectionClear => 'Rensa markering';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString markerade',
      one: '1 markerad',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Visa markerade';

  @override
  String get serverAccount => 'E-post eller inloggningsnamn';

  @override
  String get serverAdd => 'Lägg till en server';

  @override
  String get serverAddressInvalid => 'Ange adresser som photos.example.org';

  @override
  String get serverAddresses => 'Adresser';

  @override
  String get serverAddressesHelp =>
      'En per rad: servern i ditt nätverk, på internet eller via ett VPN. Appen använder den snabbaste som svarar. Eller klistra in länken för att ställa in lösenord som du fick.';

  @override
  String get serverCa => 'Certifikat för privat CA (PEM)';

  @override
  String get serverCaChoose => 'Välj en certifikatfil';

  @override
  String serverCertificateBody(String host) {
    return '$host visar ett certifikat som den här enheten inte litar på. Lita bara på det om det här SHA-256-fingeravtrycket är din servers:';
  }

  @override
  String get serverCertificateTitle => 'Lita på det här certifikatet?';

  @override
  String get serverConfirm => 'Bekräfta';

  @override
  String get serverConnect => 'Anslut';

  @override
  String get serverCreateAdmin => 'Skapa administratör';

  @override
  String get serverEnded =>
      'Servern avslutade den här sessionen. Logga in igen.';

  @override
  String get serverHandleHelp =>
      'Gemener, siffror, punkter, bindestreck och understreck; det ändras aldrig.';

  @override
  String get serverHeaders => 'Egna rubriker';

  @override
  String get serverHeadersHelp =>
      'En per rad, som Name: value; skickas bara över HTTPS';

  @override
  String get serverHeadersInvalid => 'Skriv varje rubrik som Name: value';

  @override
  String get serverIdentity => 'Klientcertifikat (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Välj ett klientcertifikat';

  @override
  String get serverIdentityInvalid =>
      'Det här är inte ett PKCS#12-certifikat, eller så är lösenordet fel.';

  @override
  String get serverIdentityPassword => 'Lösenord för klientcertifikatet';

  @override
  String get serverLoading => 'Läser servern som sparats på den här enheten';

  @override
  String get serverNearby => 'Servrar på det här nätverket';

  @override
  String get serverNeedsHttps =>
      'Den här servern behöver en HTTPS-adress: utanför ditt lokala nätverk loggar Photolib inte in via vanlig HTTP.';

  @override
  String get serverNoSignIn =>
      'Den här servern erbjuder ingen inloggning som den här versionen av Photolib stöder.';

  @override
  String get serverOffline => 'Servern svarar inte. Du förblir inloggad.';

  @override
  String get serverPasskeyFailed =>
      'Ingen nyckel användes. Försök igen eller använd en kod.';

  @override
  String get serverPasskeyRequired =>
      'Den här servern kräver en nyckel, som den här versionen av Photolib inte kan använda än.';

  @override
  String get serverPassword => 'Lösenord';

  @override
  String get serverPasswordAgain => 'Upprepa lösenordet';

  @override
  String get serverPasswordSetupInvalid =>
      'Den här token för att ange lösenord är fel, redan använd eller har gått ut. Be om en ny.';

  @override
  String get serverPasswordSetupToken => 'Token för att ange lösenord';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Från din administratör, eller utskriven av photolibd admin password-setup på servern.';

  @override
  String get serverPasswordsDiffer => 'Lösenorden stämmer inte överens.';

  @override
  String get serverPrivateLibrariesBody =>
      'Ett nytt lösenord öppnar dem inte. Öppna dem igen med ditt återställningskit, en nyckel eller en enhet som fortfarande är inloggad.';

  @override
  String get serverPrivateLibrariesGo => 'Ställ in lösenordet';

  @override
  String get serverPrivateLibrariesTitle =>
      'Dina privata bibliotek förblir låsta';

  @override
  String get serverProxy => 'HTTP-proxy, som host:port';

  @override
  String get serverProxyInvalid => 'Ange proxyn som host:port';

  @override
  String get serverRecoveryCode => 'Återställningskod';

  @override
  String get serverRemove => 'Ta bort den här servern';

  @override
  String get serverRequired => 'Obligatoriskt';

  @override
  String get serverSecondFactor =>
      'Det här kontots andra faktor är en nyckel, som den här versionen av Photolib inte kan använda än.';

  @override
  String get serverSecondFactorCode =>
      'Det här kontot kräver också en kod från din autentiseringsapp eller en återställningskod.';

  @override
  String get serverSecondFactorTitle => 'Bekräfta att det är du';

  @override
  String get serverSecondFactorWrong =>
      'Det fungerade inte. Logga in igen efter fem försök.';

  @override
  String get serverSetPassword => 'Ställ in lösenord';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'För $handle på $server';
  }

  @override
  String get serverSetPasswordOpen => 'Ange ett lösenord';

  @override
  String get serverSetPasswordTitle => 'Ställ in ditt lösenord';

  @override
  String get serverSetUp => 'Konfigurera en ny server';

  @override
  String get serverSetupLinkElsewhere =>
      'Logga först ut från den här servern för att använda länken, eller ta bort den om länken gäller en annan server.';

  @override
  String get serverSetupTitle => 'Konfigurera servern';

  @override
  String get serverSetupToken => 'Konfigurationstoken';

  @override
  String get serverSetupTokenHelp =>
      'photolibd skriver den i sin logg så länge servern saknar administratör; varje start skriver en ny.';

  @override
  String get serverSignIn => 'Logga in';

  @override
  String get serverSignOut => 'Logga ut';

  @override
  String serverSignedInAs(String account) {
    return 'Inloggad som $account';
  }

  @override
  String get serverSignedOut => 'Utloggad';

  @override
  String get serverSwitch => 'Byt konto';

  @override
  String get serverTotpCode => 'Kod från din autentiseringsapp';

  @override
  String get serverTrust => 'Lita på';

  @override
  String get serverUnreadable =>
      'Servern som sparats på den här enheten kan inte läsas';

  @override
  String get serverUsePasskey => 'Använd en nyckel';

  @override
  String get serverUseRecoveryCode => 'Använd en återställningskod i stället';

  @override
  String get settingsBackground => 'Bakom genomskinliga bilder';

  @override
  String get settingsDefaultTab => 'Mappar och album öppnas på';

  @override
  String get settingsFolders => 'Mappar';

  @override
  String get settingsIndexing => 'Indexering på den här enheten';

  @override
  String get settingsLanguage => 'Språk';

  @override
  String get settingsLibrary => 'Bibliotek';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsStart => 'Startskärm';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps':
          'Tryck på vänster eller höger kant för föregående eller nästa objekt',
      'oneFingerZoom': 'Dubbeltryck och dra för att zooma med ett finger',
      'swipes': 'Svep upp eller ner på en videos vänstra sida för ljusstyrka, högra för volym',
      'maxBrightness': 'Full ljusstyrka vid visning',
      'autoRotate': 'Vrid efter varje fotos eller videos orientering',
      'mixAudio':
          'Spela upp videor över annat ljud i stället för att pausa det',
      'autoplay': 'Spela upp videor när de öppnas',
      'loop': 'Upprepa videor',
      'autoNext': 'Gå till nästa objekt när en video tar slut',
      'resume': 'Återuppta videor där de lämnades',
      'other': 'Spela upp animerade bilder i rutnätet',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Hur länge Photolib behåller objekt i papperskorgen';

  @override
  String get settingsViewerBar => 'Knappar i visningsfältet';

  @override
  String get settingsViewing => 'Visning';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString delade foton och videor väntar tills Photolib får lägga till dem i ditt bildbibliotek. Objekt som inte sparats raderas efter 7 dagar.',
      one: '1 delat foto eller video väntar tills Photolib får lägga till det i ditt bildbibliotek. Objekt som inte sparats raderas efter 7 dagar.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'För stort för att dela på en gång: välj färre objekt';

  @override
  String shareTooMany(int count) {
    return 'För många för att dela på en gång: välj högst $count';
  }

  @override
  String get shortcutsTitle => 'Kortkommandon';

  @override
  String get slideshow => 'Bildspel';

  @override
  String get slideshowLoop => 'Upprepa';

  @override
  String get slideshowOptions => 'Alternativ för bildspel';

  @override
  String get slideshowSeconds => 'Sekunder per objekt';

  @override
  String get slideshowShuffle => 'Blanda';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Fallande',
      'other': 'Stigande',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Den här enheten';

  @override
  String sourceHide(String name) {
    return 'Dölj $name';
  }

  @override
  String get sourceHideOthers => 'Dölj allt annat här';

  @override
  String get sourceLost => 'Ingen åtkomst';

  @override
  String get sourcePartly => 'Visas delvis';

  @override
  String sourceShow(String name) {
    return 'Visa $name';
  }

  @override
  String get sourceShowEverything => 'Visa allt här';

  @override
  String get sourceShowOnly => 'Visa bara detta';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Tidslinje',
      'folders': 'Mappar och album',
      'favourites': 'Favoriter',
      'other': 'Tidslinje',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Behåll en person offline';

  @override
  String get storageBudget => 'Lagringsgräns';

  @override
  String get storageClear => 'Ta bort offlinekopior';

  @override
  String get storageClearAction => 'Ta bort';

  @override
  String storageClearBody(String size) {
    return 'Det här tar bort $size som ligger på den här enheten och slutar behålla album, sökningar och foton offline. Ditt bibliotek på servern berörs inte.';
  }

  @override
  String get storageKeepLibrary => 'Behåll hela biblioteket';

  @override
  String get storageKeepOriginals => 'Behåll även original';

  @override
  String get storageNoPeople => 'Inga personer har fått namn än.';

  @override
  String get storageNoPins =>
      'Inget är fäst. Fäst ett album, en sökning eller ett foto för att behålla det offline.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Sökning',
      'person': 'Person',
      'library': 'Hela biblioteket',
      'asset': 'Foto',
      'other': 'Fäst',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Ryms inte i gränsen: $size till behövs';
  }

  @override
  String get storagePinNothing =>
      'Inget att ladda ned: fotona finns redan på den här enheten';

  @override
  String get storagePinPaused =>
      'Väntar: den här förinställningen behåller inget offline';

  @override
  String get storagePinPlanning => 'Tar reda på vad som ska behållas …';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Laddar ned: $haveString av $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Tillgängligt offline ($size)';
  }

  @override
  String get storagePinWaiting => 'Laddas ned när du är online';

  @override
  String get storagePins => 'Behålls offline';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Endast katalog',
      'spaceSaver': 'Spara utrymme',
      'travel': 'Valda album offline',
      'everything': 'Allt',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Behåller inget; foton hämtas från din server när du öppnar dem.',
      'spaceSaver': 'Behåller förhandsvisningar av hela biblioteket, nyast först, inom gränsen.',
      'travel': 'Behåller bara det du fäster: album, sökningar och foton.',
      'everything':
          'Behåller originalen i hela biblioteket, nyast först, inom gränsen.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Vad den här enheten behåller';

  @override
  String get storageSubtitle => 'Offlinekopior och lagringsgräns';

  @override
  String get storageTitle => 'Lagring';

  @override
  String storageUsed(String used, String budget) {
    return '$used av $budget används';
  }

  @override
  String get storageWebNote =>
      'En webbläsare behåller bara förhandsvisningar och raderar dem när du loggar ut.';

  @override
  String get storeNoKeyring =>
      'Photolib förvarar nyckeln till sin lokala lagring i systemets nyckelring, som inte svarade. Installera och lås upp gnome-keyring, KWallet eller KeePassXC med Secret Service på och försök sedan igen.';

  @override
  String get storeNoKeystore =>
      'Photolib kunde inte nå den här enhetens nyckellager, som har nyckeln till dess lokala lagring.';

  @override
  String get storeRebuilt =>
      'Den här enhetens nyckellager hade inte längre nyckeln till Photolibs lokala lagring, så lagringen byggdes om. Dess inställningar och det som bara fanns på den här enheten har gått förlorat; bibliotek synkas igen och miniatyrer kommer tillbaka.';

  @override
  String get storeRecoveryNeeded =>
      'Den här enhetens nyckellager har inte längre nyckeln till Photolibs lokala lagring. Ange återställningskoden, eller återställ lagringen och förlora det som bara finns på den här enheten.';

  @override
  String get storeReset => 'Återställ lagring';

  @override
  String get storeResetBody =>
      'Det som bara finns på den här enheten går förlorat; bibliotek synkas igen och miniatyrer kommer tillbaka.';

  @override
  String get storeUnavailable =>
      'Lagringen på den här enheten är inte tillgänglig: inställningar och samlingar sparas inte';

  @override
  String get tabCollections => 'Samlingar';

  @override
  String get tabLibrary => 'Bibliotek';

  @override
  String get tabSearch => 'Sök';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeSystem => 'System';

  @override
  String get timelineBenchmark => 'Prestandatest för tidslinjen';

  @override
  String get timelineBenchmarkCopy => 'Kopiera resultaten';

  @override
  String get timelineCannotPlay => 'Kan inte spelas upp i den här webbläsaren';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position av $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position av $count, ingen förhandsvisning';
  }

  @override
  String get timelineExcluded => 'I en utesluten mapp';

  @override
  String get timelineScrubber => 'Bläddra efter datum';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Okänt datum';

  @override
  String timelineWeek(String date) {
    return 'Vecka från $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Lägg till $action i fältet';
  }

  @override
  String toolbarDown(String action) {
    return 'Flytta ned $action';
  }

  @override
  String get toolbarInBar => 'I fältet';

  @override
  String get toolbarInMenu => 'I menyn ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Ta bort $action från fältet';
  }

  @override
  String get toolbarReset => 'Återställ standard';

  @override
  String toolbarUp(String action) {
    return 'Flytta upp $action';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Flytta hit',
      'other': 'Kopiera hit',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Det finns redan en fil eller mapp med det här namnet',
      'changed': 'Kopian stämde inte med originalet och togs bort',
      'cancelled': 'Avbrutet',
      'invalid': 'Inte ett giltigt mappnamn',
      'other': 'Misslyckades',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Senaste';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Radera $countString objekt permanent? Det går inte att ångra.',
      one: 'Radera 1 objekt permanent? Det går inte att ångra.',
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
      other: '$daysString dagar kvar',
      one: '1 dag kvar',
      zero: 'Raderas permanent i dag',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Papperskorgen är tom';

  @override
  String get trashEmptyAll => 'Töm papperskorgen';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString dagar';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString objekt flyttade till papperskorgen',
      one: '1 objekt flyttat till papperskorgen',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Ta bort från listan';

  @override
  String trashRetention(int days) {
    return 'Photolib raderar det som ligger i papperskorgen permanent efter $days dagar; varje objekt visar hur lång tid det har kvar.';
  }

  @override
  String get trashTitle => 'Papperskorg';

  @override
  String get undo => 'Ångra';

  @override
  String get uploadAction => 'Ladda upp foton och videor';

  @override
  String get uploadClear => 'Rensa';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString av $totalString uppladdade';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Misslyckade: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString objekt arkiverade',
      one: '1 objekt arkiverat',
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
      other: '$countString objekt dolda',
      one: '1 objekt dolt',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Svart',
      'white': 'Vitt',
      'other': 'Schackruta',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Videon kan inte spelas upp på den här enheten';

  @override
  String get viewerCaptions => 'Undertexter';

  @override
  String get viewerCompass => 'Kompasslås';

  @override
  String get viewerCopy => 'Kopiera';

  @override
  String get viewerCopyText => 'Kopiera text';

  @override
  String get viewerCustomize => 'Anpassa verktygsfältet…';

  @override
  String get viewerDial =>
      'Riktning. Klicka för att titta framåt. Dra för att se dig omkring, scrolla eller nyp för att zooma, dubbelklicka för att återställa';

  @override
  String get viewerFilmstrip => 'Filmremsa';

  @override
  String get viewerFirst => 'Första';

  @override
  String get viewerFisheye => 'Fisheye';

  @override
  String get viewerGyroscope => 'Rör enheten för att se dig omkring';

  @override
  String get viewerHdr => 'Visa i HDR';

  @override
  String get viewerInfo => 'Info';

  @override
  String get viewerInfoLoading => 'Läser in info om det här objektet';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString av $countString';
  }

  @override
  String get viewerLast => 'Sista';

  @override
  String get viewerLenses => 'Välj ett objektiv';

  @override
  String get viewerMap => 'Karta';

  @override
  String get viewerMotion => 'Spela upp rörelse';

  @override
  String get viewerMotionDenied =>
      'Den här webbläsaren tillät inte åtkomst till rörelsesensorerna';

  @override
  String get viewerMotionMissing =>
      'Den här enheten har inget gyroskop för att se dig omkring';

  @override
  String get viewerMute => 'Ljud av';

  @override
  String get viewerNext => 'Nästa';

  @override
  String get viewerNextFrame => 'Nästa bildruta';

  @override
  String get viewerPause => 'Pausa';

  @override
  String get viewerPlanet => 'Liten planet';

  @override
  String get viewerPlay => 'Spela upp';

  @override
  String get viewerPrevious => 'Föregående';

  @override
  String get viewerPreviousFrame => 'Föregående bildruta';

  @override
  String get viewerRotate => 'Rotera';

  @override
  String get viewerSdr => 'Visa i SDR';

  @override
  String get viewerSeek => 'Position';

  @override
  String get viewerSetAs => 'Ange som';

  @override
  String get viewerShare => 'Dela';

  @override
  String get viewerSpeed => 'Uppspelningshastighet';

  @override
  String get viewerSphere =>
      '360°-vy. Dra för att se dig omkring, nyp för att zooma';

  @override
  String get viewerText => 'Text i det här fotot';

  @override
  String get viewerTextCopied => 'Texten kopierad';

  @override
  String get viewerTextNone => 'Ingen text hittades i det här fotot';

  @override
  String get viewerTextUnread => 'Texten i det här fotot har inte lästs ännu';

  @override
  String get viewerUnmute => 'Ljud på';

  @override
  String get viewerZoomIn => 'Zooma in';

  @override
  String get viewerZoomOut => 'Zooma ut';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD-kort',
      'other': 'Intern',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Zooma in';

  @override
  String get zoomOut => 'Zooma ut';
}
