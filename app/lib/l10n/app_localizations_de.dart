// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get actionAddToAlbum => 'Zu Album hinzufügen';

  @override
  String get actionArchive => 'Archivieren';

  @override
  String get actionCopyTo => 'Kopieren nach…';

  @override
  String get actionDeleteForever => 'Endgültig löschen';

  @override
  String get actionFavourite => 'Favorisieren';

  @override
  String get actionHide => 'Ausblenden';

  @override
  String get actionMoveTo => 'Verschieben nach…';

  @override
  String get actionRename => 'Umbenennen';

  @override
  String get actionRestore => 'Wiederherstellen';

  @override
  String get actionShare => 'Teilen';

  @override
  String get actionTrash => 'In den Papierkorb verschieben';

  @override
  String get actionUnarchive => 'Aus dem Archiv holen';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String get actionUnfavourite => 'Aus Favoriten entfernen';

  @override
  String get actionUnhide => 'Einblenden';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Aktiv',
      'disabled': 'Deaktiviert',
      'invited': 'Eingeladen',
      'deleted': 'Gelöscht',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Konten';

  @override
  String get adminAddAccount => 'Konto hinzufügen';

  @override
  String get adminAddExternalLibrary => 'Externe Bibliothek hinzufügen';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts Versuche',
      one: '1 Versuch',
      zero: 'noch nicht ausgeführt',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Audit-Protokoll';

  @override
  String get adminBackUpNow => 'Jetzt sichern';

  @override
  String get adminBackupQueued =>
      'Die Sicherung ist eingereiht; eine Wiederherstellungsprobe folgt';

  @override
  String get adminBackups => 'Datenbanksicherungen';

  @override
  String get adminCancelJob => 'Job abbrechen';

  @override
  String get adminCapabilities => 'Funktionen';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Verwaltete Bibliotheken',
      'uploads': 'Uploads von Geräten, aus dem Web und per CLI',
      'folder_browser': 'Ordneransicht',
      'device_folders': 'Geräteordner in verbundenen Apps',
      'sharing': 'Teilen und öffentliche Links',
      'edits': 'Bearbeiten',
      'deletes': 'Löschen',
      'xmp_writes': 'XMP-Sidecars schreiben',
      'face_recognition': 'Gesichtserkennung',
      'ml_search': 'Intelligente Suche',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Warnung',
      'fail': 'Fehlgeschlagen',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Kopiert';

  @override
  String get adminCopyBundle =>
      'Diagnosedaten für einen Fehlerbericht kopieren';

  @override
  String get adminCopyLink => 'Link kopieren';

  @override
  String get adminDelete => 'Löschen';

  @override
  String get adminDeviceBackups => 'Gerätesicherungen';

  @override
  String get adminDevices => 'Deine Geräte';

  @override
  String get adminDisable => 'Deaktivieren';

  @override
  String adminDrillFailed(String detail) {
    return 'Die letzte Wiederherstellungsprobe ist fehlgeschlagen: $detail';
  }

  @override
  String get adminEdit => 'Bearbeiten';

  @override
  String get adminEmail => 'E-Mail';

  @override
  String get adminEnable => 'Aktivieren';

  @override
  String get adminErrorSignIn => 'Melde dich als Administrator an';

  @override
  String get adminFacesDefault =>
      'Gesichtserkennung ist bei neuen Konten standardmäßig aktiviert';

  @override
  String get adminFiles => 'Dateien nach Art';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Beschädigt',
      'missing': 'Fehlt',
      'size': 'Falsche Größe',
      'hash': 'Ersetzt',
      'orphan': 'Fremde Datei',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size frei';
  }

  @override
  String get adminFreeDisk =>
      'Uploads pausieren, wenn der freie Speicherplatz unter diesen Wert fällt, in Prozent, 0 bis 50';

  @override
  String get adminFreeDiskGb =>
      'oder unter diesen Wert in GB, falls kleiner, 0 bis 100000';

  @override
  String get adminHandle => 'Anmeldename';

  @override
  String get adminIntegrity => 'Integrität';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Elemente',
      one: '1 Element',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'In Warteschlange',
      'running': 'Läuft',
      'done': 'Fertig',
      'dead': 'Fehlgeschlagen',
      'cancelled': 'Abgebrochen',
      'other': 'Alle',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Jobtyp, z. B. render';

  @override
  String get adminJobs => 'Jobs';

  @override
  String adminLastSeen(String time) {
    return 'Zuletzt gesehen $time';
  }

  @override
  String get adminLibraries => 'Bibliotheken';

  @override
  String get adminLibraryOwner => 'Eigentümer';

  @override
  String get adminLibraryRoot => 'Ordner auf dem Server, z. B. /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Online',
      'offline': 'Offline',
      'scanning': 'Wird gescannt',
      'error': 'Fehler',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Serverprotokoll';

  @override
  String get adminName => 'Name';

  @override
  String get adminNothing => 'Noch nichts vorhanden';

  @override
  String get adminOutOfRange => 'Außerhalb des zulässigen Bereichs';

  @override
  String get adminOverview => 'Übersicht';

  @override
  String get adminPair => 'Gerät koppeln';

  @override
  String get adminPairBody =>
      'Scanne diesen Code oder sende den Link und füge ihn dann auf dem neuen Gerät in Photolib unter Server hinzufügen ein: Er bringt alle Adressen dieses Servers und sein Zertifikat mit, sodass niemand sie abtippen muss.';

  @override
  String get adminPasswordSetup => 'Link zum Festlegen des Passworts';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Schick diesen Link auf beliebigem Weg an $name oder lass den Code scannen. Er legt einmal ein Passwort fest, bis $date.';
  }

  @override
  String get adminPause => 'Jobtyp pausieren';

  @override
  String adminPauseMinutes(int max) {
    return 'Minuten, 1 bis $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type ist bis $time pausiert';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $countString Elemente zu sichern',
      one: 'Noch 1 Element zu sichern',
      zero: 'Nichts mehr zu sichern',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Richtlinien';

  @override
  String get adminPolicyReset => 'Wert der übergeordneten Ebene verwenden';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Standardmäßig an',
      'server': 'Für den Server festgelegt',
      'user': 'Für dieses Konto festgelegt',
      'library': 'Für diese Bibliothek festgelegt',
      'config': 'In der Konfiguration festgelegt',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Vorlage anwenden';

  @override
  String get adminPresetBody =>
      'Eine Vorlage legt jede Funktion für den Server fest und entfernt, was Konten und Bibliotheken festgelegt haben. Alles bleibt änderbar.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Archivbetrachter',
      'family_backup': 'Familien-Backup',
      'personal': 'Persönlich',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Die externen schreibgeschützten Bibliotheken sind die einzige Quelle der Wahrheit: keine Uploads, verwalteten Bibliotheken, Geräteordner, Bearbeitungen, Löschungen oder XMP-Schreibvorgänge',
      'family_backup': 'Alles an außer XMP-Schreibvorgängen',
      'personal': 'Alles an außer Teilen und öffentlichen Links',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'QR-Code des Links';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Jobs in der Warteschlange',
      one: '1 Job in der Warteschlange',
      zero: 'Nichts zu tun',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'Speicherkontingent in GB; leer für unbegrenzt';

  @override
  String get adminRemote => 'Fernzugriff';

  @override
  String get adminRemoteBody =>
      'Erreiche den Server von überall, ohne einen Port am Router zu öffnen. Wähle einen Weg; jeder gibt ihm eine HTTPS-Adresse für die Apps. Teste sie dann von außen.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared verbindet sich nach außen mit Cloudflare, das deine Domain über HTTPS ausliefert. Der Gratistarif begrenzt eine Anfrage auf 100 MB, was Sicherungen nie erreichen: Sie senden je 8 MiB.';

  @override
  String get adminRemoteNoAddress =>
      'Füge in dieser App die Adresse des Servers mit https:// hinzu, um sie von außen zu testen.';

  @override
  String get adminRemoteReachable => 'Von außen erreichbar.';

  @override
  String get adminRemoteTailscale =>
      'Installiere Tailscale auf dem Rechner des Servers und auf jedem Gerät, im selben Tailnet oder deinem Headscale, führe dann dies auf dem Rechner des Servers aus und setze public_url auf die ausgegebene Adresse.';

  @override
  String get adminRemoteTest => 'Von außen testen';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host öffnet $url von seinen Servern weltweit und erfährt so diese Adresse. Fortfahren?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Von außen nicht erreichbar: Prüfe den gewählten Weg und teste erneut.';

  @override
  String get adminRemoteWireguard =>
      'Braucht einen offenen UDP-Port beim Server oder an einem Knoten. Dies ist die Konfiguration für ein Gerät; Schlüssel erzeugst du mit wg genkey.';

  @override
  String get adminRepair =>
      'Aus einer Sicherung oder von einem Gerät zurücklegen, das sie noch hat';

  @override
  String get adminRepairOrphan =>
      'Kein Foto verweist darauf: prüfen, dann löschen oder behalten';

  @override
  String get adminReprocess => 'Neu verarbeiten';

  @override
  String get adminReprocessFaces => 'Gesichter erneut erkennen';

  @override
  String get adminReprocessFolder =>
      'Ordner, z. B. 2024/05; leer für die gesamte Bibliothek';

  @override
  String get adminReprocessMetadata => 'Metadaten erneut lesen';

  @override
  String get adminReprocessRenditions =>
      'Miniaturansichten und Vorschauen neu erstellen';

  @override
  String get adminRestore => 'Wiederherstellen';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Die Wiederherstellung von $name ist fehlgeschlagen: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Noch keine Wiederherstellungsprobe bestanden';

  @override
  String adminRestoreVerified(String when) {
    return 'Zuletzt geprüfte Wiederherstellung: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd hält an und ersetzt beim nächsten Start die gesamte Datenbank durch $name. Was sich seit dieser Sicherung geändert hat, geht verloren, und jedes Gerät synchronisiert von vorn.';
  }

  @override
  String get adminRestoring =>
      'photolibd hält an, um die Sicherung wiederherzustellen';

  @override
  String get adminResume => 'Fortsetzen';

  @override
  String get adminRetry => 'Wiederholen';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrator',
      'user': 'Benutzer',
      'viewer': 'Betrachter',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Gespeichert';

  @override
  String get adminScan => 'Jetzt scannen';

  @override
  String get adminScrubDays =>
      'Tage, in denen die Prüfung jedes Original prüft, 1 bis 3650';

  @override
  String get adminScrubNever => 'Erste vollständige Prüfung läuft';

  @override
  String adminScrubbed(String time) {
    return 'Zuletzt vollständig geprüft $time';
  }

  @override
  String get adminSecondAdmin =>
      'Mache eine zweite Person zum Administrator, damit jemand anderes den Server betreiben und wiederherstellen kann, wenn du es nicht kannst.';

  @override
  String adminSilent(String time) {
    return 'Still seit $time';
  }

  @override
  String get adminSilentHours =>
      'Stunden ohne Meldung, bis die Sicherung eines Geräts als still gilt, 1 bis 8760';

  @override
  String get adminStores => 'Speicher';

  @override
  String get adminThisDevice => 'Dieses Gerät';

  @override
  String get adminTitle => 'Serververwaltung';

  @override
  String get adminTrashDays => 'Tage im Papierkorb, 1 bis 3650';

  @override
  String get adminTwoFactor =>
      'Alle Konten müssen einen zweiten Faktor einrichten';

  @override
  String get adminUsage => 'Nutzung nach Konto';

  @override
  String get albumCover => 'Als Titelbild verwenden';

  @override
  String get albumEmpty => 'Dieses Album ist leer';

  @override
  String get albumHideMemories => 'Aus Erinnerungen ausblenden';

  @override
  String get albumHideTimeline => 'Aus der Zeitleiste ausblenden';

  @override
  String get albumNew => 'Neues Album';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Beliebiges Datum';

  @override
  String get backupCap => 'Größtes Element';

  @override
  String get backupCharging => 'Nur beim Laden';

  @override
  String backupCompleted(String time) {
    return 'Letzte vollständige Sicherung: $time';
  }

  @override
  String backupContact(String time) {
    return 'Letzter Kontakt mit dem Server: $time';
  }

  @override
  String get backupEnabled => 'Dieses Gerät sichern';

  @override
  String get backupFolderNo => 'Diesen nicht';

  @override
  String get backupFolderYes => 'Sichern';

  @override
  String backupHours(int count) {
    return '$count Std.';
  }

  @override
  String get backupMetered =>
      'In getakteten Netzen wie mobilen Daten oder einem Hotspot';

  @override
  String get backupNever => 'Noch keine vollständige Sicherung';

  @override
  String backupNewFolder(String name) {
    return 'Neuer Ordner $name: sichern?';
  }

  @override
  String get backupNoLimit => 'Keine Grenze';

  @override
  String get backupNothing => 'Nichts wartet';

  @override
  String get backupNow => 'Jetzt sichern';

  @override
  String backupOverdue(int hours, String items) {
    return 'Seit $hours Std. keine vollständige Sicherung. Wartend: $items';
  }

  @override
  String get backupOverdueTitle => 'Die Sicherung ist nicht abgeschlossen';

  @override
  String backupPending(String items) {
    return 'Wartend: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Neuer Versuch: $time';
  }

  @override
  String get backupRoaming => 'Beim Roaming sichern';

  @override
  String get backupSignIn =>
      'Melden Sie sich bei einem Server an, um dieses Gerät zu sichern';

  @override
  String get backupSignedOut =>
      'Sicherung angehalten: Der Server hat dieses Gerät abgemeldet. Melden Sie sich in den Einstellungen erneut an.';

  @override
  String get backupSince => 'Aufgenommen seit';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Die Sicherung wartet, bis der Server erreichbar ist',
      'charging': 'Die Sicherung wartet, bis das Gerät lädt',
      'battery_low': 'Die Sicherung wartet: Der Akku ist schwach',
      'roaming': 'Die Sicherung wartet beim Roaming',
      'quota': 'Sicherung angehalten: Ihr Speicher auf dem Server ist voll',
      'second_factor': 'Sicherung angehalten: Der Server verlangt für dieses Konto einen zweiten Faktor',
      'other': 'Sicherung angehalten: Der Server antwortete $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Sicherung';

  @override
  String get backupWaiting => 'Nicht gesichert';

  @override
  String get backupWarnAfter => 'Warnen, wenn unvollständig seit';

  @override
  String get backupWhat => 'Was gesichert wird';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'In einem Ordner, den Sie nicht gewählt haben',
      'folder_new': 'In einem neuen Ordner: Wählen Sie, ob er gesichert wird',
      'type_excluded': 'Eine Art Element, die Sie nicht gewählt haben',
      'before_date': 'Vor dem gewählten Datum aufgenommen',
      'selected': 'Wartet, bis es an der Reihe ist',
      'server_restored': 'Der Server hat es bei einer Wiederherstellung verloren: wird erneut gesendet',
      'working': 'Wird gesichert',
      'waiting_for_icloud': 'Wartet, bis iCloud es herunterlädt',
      'metered': 'Wartet auf ein nicht getaktetes Netz',
      'metered_cap': 'Zu groß für ein getaktetes Netz',
      'unreadable': 'Dieses Gerät kann es nicht lesen',
      'changed': 'Es hat sich beim Senden geändert',
      'quota': 'Ihr Speicher auf dem Server ist voll',
      'other': 'Der Server hat es abgelehnt: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Der Server arbeitet nicht mehr mit dieser Version von Photolib.';

  @override
  String get checkAppTooOldNext => 'Aktualisiere Photolib.';

  @override
  String get checkChanged =>
      'Das Zertifikat des Servers ist nicht das, dem du vertraut hast.';

  @override
  String get checkChangedNext =>
      'Hat dein Administrator es ersetzt, vertraue dem neuen. Wenn nicht, hört vielleicht jemand mit: Mach nicht weiter.';

  @override
  String get checkClock =>
      'Die Uhr dieses Geräts und die des Servers weichen um mehr als fünf Minuten ab.';

  @override
  String get checkClockNext =>
      'Lass dein Gerät Datum und Uhrzeit automatisch einstellen.';

  @override
  String get checkDnsFailed => 'Der Name des Servers führt zu keiner Adresse.';

  @override
  String get checkDnsFailedNext =>
      'Prüfe die Adresse oder verbinde dich mit dem Netzwerk des Servers.';

  @override
  String checkExpired(String date) {
    return 'Das Zertifikat des Servers ist am $date abgelaufen.';
  }

  @override
  String get checkFailed => 'Fehlgeschlagen';

  @override
  String get checkMetered =>
      'Du bist in einem getakteten Netzwerk, etwa mobilen Daten.';

  @override
  String get checkMeteredNext =>
      'Verbinde dich vor großen Sicherungen mit dem WLAN.';

  @override
  String get checkNotPhotolib =>
      'Etwas anderes als Photolib antwortet, etwa die Fehlerseite eines Proxys oder eine WLAN-Anmeldeseite.';

  @override
  String get checkNotPhotolibNext =>
      'Melde dich im Browser beim WLAN an oder bitte deinen Administrator, den Proxy zu prüfen.';

  @override
  String get checkOtherServer =>
      'Unter dieser Adresse antwortet ein anderer Photolib-Server.';

  @override
  String get checkPassed => 'Bestanden';

  @override
  String get checkRefused => 'Unter dieser Adresse antwortet nichts.';

  @override
  String get checkRefusedNext =>
      'Prüfe, ob der Server läuft und du in seinem Netzwerk oder VPN bist.';

  @override
  String get checkRun => 'Verbindung prüfen';

  @override
  String get checkRunning => 'Wird geprüft';

  @override
  String get checkSelfSigned =>
      'Der Server nutzt ein eigenes Zertifikat, das dieses Gerät noch nicht kennt.';

  @override
  String get checkSkipped => 'Nicht geprüft';

  @override
  String get checkStepAuth => 'Deine Anmeldung';

  @override
  String get checkStepClock => 'Uhr deines Geräts';

  @override
  String get checkStepDns => 'Adresse des Servers finden';

  @override
  String get checkStepNetwork => 'Dein Netzwerk';

  @override
  String get checkStepServer => 'Photolib auf dem Server';

  @override
  String get checkStepTcp => 'Server erreichen';

  @override
  String get checkStepTls => 'Sichere Verbindung und Zertifikat';

  @override
  String get checkStepUpload => 'Große Uploads über Proxys';

  @override
  String get checkTimedOut => 'Der Server braucht zu lange für eine Antwort.';

  @override
  String get checkTimedOutNext =>
      'Prüfe deine Verbindung und versuche es dann erneut.';

  @override
  String get checkTitle => 'Verbindungsprüfung';

  @override
  String get checkTlsFailed => 'Die sichere Verbindung ist fehlgeschlagen.';

  @override
  String get checkTrustNext =>
      'Vertraue ihm nur, wenn sein Fingerabdruck zu deinem Server passt.';

  @override
  String get checkUntrusted =>
      'Das Zertifikat des Servers stammt von einer Stelle, der dieses Gerät nicht vertraut.';

  @override
  String get checkUploadCap =>
      'Ein Proxy unterwegs lehnt große Uploads ab, daher laufen Sicherungen langsamer in kleinen Stücken.';

  @override
  String get checkUploadCapNext =>
      'Bitte deinen Administrator, Anfragen von 64 MB durch den Proxy zu lassen.';

  @override
  String get collectionAlbums => 'Alben';

  @override
  String collectionHide(String name) {
    return '$name ausblenden';
  }

  @override
  String collectionMoveDown(String name) {
    return '$name nach unten verschieben';
  }

  @override
  String collectionMoveUp(String name) {
    return '$name nach oben verschieben';
  }

  @override
  String get collectionPeople => 'Personen';

  @override
  String collectionPin(String name) {
    return '$name anheften';
  }

  @override
  String get collectionPlaces => 'Orte';

  @override
  String collectionShow(String name) {
    return '$name einblenden';
  }

  @override
  String get collectionTags => 'Tags';

  @override
  String collectionUnpin(String name) {
    return '$name nicht mehr anheften';
  }

  @override
  String get collectionsCustomise => 'Anpassen';

  @override
  String get collectionsDone => 'Fertig';

  @override
  String get commandPalette => 'Befehlspalette';

  @override
  String get commandPaletteHint => 'Befehl eingeben';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString auf diesem Gerät und gesichert',
      one: '$countString auf diesem Gerät und gesichert',
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
      other: '$countString nur auf diesem Gerät, nicht gesichert',
      one: '$countString nur auf diesem Gerät, nicht gesichert',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Mit aktivierten iCloud-Fotos verschwinden auf diesem Gerät gelöschte Objekte auch aus iCloud und von deinen anderen Apple-Geräten.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString nur in deiner Bibliothek',
      one: '$countString nur in deiner Bibliothek',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Von diesem Gerät entfernen';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Die $countString gesicherten Elemente; deine Bibliothek behält sie',
      one: 'Das gesicherte Element; deine Bibliothek behält es',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Kopien auf diesem Gerät kommen in seinen Papierkorb: Der Speicherplatz wird frei, sobald er geleert ist.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Elemente löschen?',
      one: '$countString Element löschen?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Von diesem Gerät und aus deiner Bibliothek',
      'device': 'Nur von diesem Gerät',
      'other': 'Aus deiner Bibliothek',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Nicht vorhanden';

  @override
  String get deviceFolderCard => 'SD-Karte';

  @override
  String get deviceFolderExclude => 'Ausschließen';

  @override
  String get deviceFolderExcludeThis => 'Diesen Ordner ausschließen';

  @override
  String get deviceFolderExcludedNotice =>
      'Der Ordner dieses Elements ist aus deiner Bibliothek ausgeschlossen';

  @override
  String get deviceFolderForget => 'Aus der Liste entfernen';

  @override
  String get deviceFolderInternal => 'Interner Speicher';

  @override
  String get deviceFolderKeep => 'Behalten';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, ist neu';
  }

  @override
  String get deviceFolders => 'Ordner auf dem Gerät';

  @override
  String get deviceFoldersAll =>
      'Alle Ordner außer den ausgeschlossenen anzeigen';

  @override
  String get deviceFoldersChosen => 'Nur die ausgewählten Ordner anzeigen';

  @override
  String get deviceFoldersExcludedNow => 'Aus der Bibliothek ausgeschlossen';

  @override
  String get deviceFoldersSearch => 'Ordner suchen';

  @override
  String get diagnosticsAdvanced => 'Diagnose anzeigen';

  @override
  String get diagnosticsAllLoggers => 'Alle Protokollquellen';

  @override
  String get diagnosticsCopied => 'Protokoll kopiert';

  @override
  String get diagnosticsCopy => 'Angezeigtes Protokoll kopieren';

  @override
  String get diagnosticsEmpty => 'Noch keine Protokolleinträge';

  @override
  String get diagnosticsExport => 'Diagnosepaket exportieren';

  @override
  String get diagnosticsExported => 'Diagnosepaket gespeichert';

  @override
  String get diagnosticsLevel => 'Stufe';

  @override
  String get diagnosticsLogger => 'Protokollquelle';

  @override
  String get diagnosticsTitle => 'Diagnose';

  @override
  String get download => 'Herunterladen';

  @override
  String get downloadCurrent => 'Aktuelle Version mit Bearbeitungen';

  @override
  String get downloadFailed => 'Download fehlgeschlagen';

  @override
  String get downloadOriginal => 'Original';

  @override
  String downloadSaved(String name) {
    return '$name gespeichert';
  }

  @override
  String get downloadVersion => 'Welche Version?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Elemente werden heruntergeladen',
      one: '$countString Element wird heruntergeladen',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Automatisch verbessern';

  @override
  String get editorCrop => 'Zuschneiden';

  @override
  String get editorCropOriginal => 'Original';

  @override
  String get editorCropSquare => 'Quadrat';

  @override
  String get editorEdit => 'Bearbeiten';

  @override
  String get editorFlip => 'Spiegeln';

  @override
  String get editorRotate => 'Drehen';

  @override
  String get editorSaveCopy => 'Kopie speichern';

  @override
  String get editorSaveFailed => 'Kopie konnte nicht gespeichert werden';

  @override
  String get editorSaveVersion => 'Speichern';

  @override
  String get editorSaved => 'Als Kopie gespeichert';

  @override
  String get editorVersionFailed =>
      'Die Version konnte nicht gespeichert werden';

  @override
  String get editorVersionSaved => 'Als neue Version gespeichert';

  @override
  String get editorVersionsUnsupported =>
      'Dieser Server kann noch keine Versionen bearbeiteter Fotos speichern';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString Änderungen wurden rückgängig gemacht: Der Server hat sie abgelehnt.',
      one: '1 Änderung wurde rückgängig gemacht: Der Server hat sie abgelehnt.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Schließen';

  @override
  String get editsRejectedForbidden =>
      'Du darfst die Objekte ansehen, aber nicht ändern.';

  @override
  String get editsRejectedInvalid =>
      'Der Server konnte die Änderungen nicht annehmen.';

  @override
  String get editsRejectedNotFound =>
      'Die Objekte wurden gelöscht oder werden nicht mehr mit dir geteilt.';

  @override
  String get errorNotFound => 'Diese Seite existiert nicht';

  @override
  String get errorRetry => 'Erneut versuchen';

  @override
  String get errorTitle => 'Ein Fehler ist aufgetreten';

  @override
  String faceNumber(int number) {
    return 'Gesicht $number';
  }

  @override
  String get facesAgree => 'Ich stimme zu';

  @override
  String get facesAura =>
      'Gesichter mit AuraFace beschreiben (größerer Download)';

  @override
  String get facesNotNow => 'Nicht jetzt';

  @override
  String get facesNoticeKeep =>
      'Das Gefundene bleibt bei deinen Fotos, auf deinen Geräten und deinem Server. Die Beschreibungen werden nie angezeigt oder geteilt, und alles wird gelöscht, wenn du aufhörst oder das Foto löschst.';

  @override
  String get facesNoticeOptional =>
      'Das ist freiwillig. Alles andere in Photolib funktioniert auch ohne, und du kannst jederzeit in den Einstellungen aufhören.';

  @override
  String get facesNoticeTitle => 'Gesichter in deinen Fotos finden?';

  @override
  String get facesNoticeWhat =>
      'Photolib sucht Gesichter in deinen Fotos und Videos und merkt sich zu jedem, wo es ist und eine Zahlenliste, die es beschreibt, damit dieselbe Person wiedergefunden werden kann. Eine solche Beschreibung kann als biometrisches Datum gelten.';

  @override
  String get facesNoticeWhere =>
      'Das geschieht auf diesem Gerät und, wenn du angemeldet bist, auf deinem eigenen Server. Nie bei einem Dienst von uns oder anderen.';

  @override
  String get facesServerFailed =>
      'Dein Server konnte nicht benachrichtigt werden. Versuche es erneut.';

  @override
  String get facesServerOff => 'Dein Server findet keine Gesichter für dich';

  @override
  String get facesServerOn => 'Dein Server findet Gesichter für dich';

  @override
  String get facesServerUnavailable =>
      'Dein Server bietet keine Gesichtserkennung an';

  @override
  String facesStatusDownloading(int percent) {
    return 'Gesichtsmodelle werden geladen: $percent %';
  }

  @override
  String get facesStatusMissing =>
      'Dein Server hat die Gesichtsmodelle nicht installiert';

  @override
  String get facesStatusNoDecoder =>
      'Die Gesichtserkennung ist nicht verfügbar: Die Bildbibliothek (libvips) wurde nicht gefunden. Installiere Photolib neu oder installiere libvips und starte die App neu.';

  @override
  String get facesStatusRunning => 'Gesichter werden auf diesem Gerät gefunden';

  @override
  String get facesStatusUnavailable =>
      'Auf diesem Gerät können keine Gesichter gefunden werden';

  @override
  String get facesStatusWaiting =>
      'Die Gesichtsmodelle werden über WLAN geladen';

  @override
  String get facesSwitch => 'Gesichter in meinen Fotos finden';

  @override
  String get facesSwitchOff =>
      'Aus. Zu Gesichtern wird nichts berechnet, bis du zustimmst.';

  @override
  String get facesSwitchOn =>
      'An. Photolib findet die Gesichter in deinen Fotos.';

  @override
  String get facesTitle => 'Gesichter und Personen';

  @override
  String get facesWithdraw => 'Löschen und aufhören';

  @override
  String get facesWithdrawBody =>
      'Das löscht alle Gesichter, Beschreibungen und Personen, die Photolib für dich gefunden hat, auf diesem Gerät und auf deinem Server. Deine Fotos bleiben unverändert.';

  @override
  String get facesWithdrawTitle => 'Gesichter nicht mehr suchen?';

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

    return 'Nicht geänderte Dateien: $countString';
  }

  @override
  String get folderAllow => 'Zugriff auf diesen Ordner erlauben';

  @override
  String get folderDelete => 'Ordner löschen';

  @override
  String folderDeleteBody(String name) {
    return 'Die Fotos und Videos in $name in den Papierkorb verschieben?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Elemente',
      one: '1 Element',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Neuer Ordner';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline, $countString Elemente',
      one: 'Offline, 1 Element',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Dieser Ordner, ein Ordner darin oder ein übergeordneter Ordner ist bereits in der Bibliothek';

  @override
  String get folderRemove => 'Ordner entfernen';

  @override
  String folderRemoveBody(String folder) {
    return 'Die Fotos und Videos aus $folder werden aus der Bibliothek entfernt. Die Dateien bleiben unverändert auf dem Datenträger.';
  }

  @override
  String get folderRemoveConfirm => 'Entfernen';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wird gescannt, bisher $countString Elemente',
      one: 'Wird gescannt, bisher 1 Element',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Zugriff erlauben';

  @override
  String get foldersHideExcluded => 'Ausgeschlossene Ordner ausblenden';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib kann $countString Ordner nicht mehr lesen.',
      one: 'Photolib kann 1 Ordner nicht mehr lesen.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Ausgeschlossene Ordner anzeigen ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Dieser Browser kann keinen Ordner als deine Bibliothek verwenden. Öffne Photolib in Chrome oder Edge auf einem Computer oder nutze die Desktop-App.';

  @override
  String get galleryButtons => 'Schaltflächen';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryGrid => 'Raster';

  @override
  String get galleryMenus => 'Menüs und Sheets';

  @override
  String get galleryShowSheet => 'Sheet anzeigen';

  @override
  String get galleryTitle => 'Komponenten';

  @override
  String hiddenCollections(int count) {
    return 'Ausgeblendet ($count)';
  }

  @override
  String get indexingAllowMetered => 'Über mobile Daten herunterladen';

  @override
  String get indexingAllowSaver => 'Auch im Energiesparmodus';

  @override
  String get indexingBattery => 'Nötiger Akkustand ohne Ladegerät';

  @override
  String get indexingChargingOnly => 'Nur beim Laden';

  @override
  String indexingDownloading(int percent) {
    return 'Suchmodell wird geladen: $percent %';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos konnten nicht gelesen werden',
      one: '1 Foto konnte nicht gelesen werden',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Dieses Gerät indexiert nur seine neuen Fotos';

  @override
  String get indexingMissing =>
      'Dein Server hat das Suchmodell nicht installiert';

  @override
  String get indexingModels => 'Auf diesem Gerät suchen';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Lädt das Suchmodell ($megabytesString MB) von $host herunter';
  }

  @override
  String get indexingNoDecoder =>
      'Suche und Texterkennung sind nicht verfügbar: Die Bildbibliothek (libvips) wurde nicht gefunden. Installiere Photolib neu oder installiere libvips und starte die App neu.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Pausiert, solange der Akku unter $percent % ist';
  }

  @override
  String get indexingPausedCharger => 'Pausiert, bis das Gerät lädt';

  @override
  String get indexingPausedHeat => 'Pausiert, solange das Gerät heiß ist';

  @override
  String get indexingPausedSaver =>
      'Pausiert, solange der Energiesparmodus an ist';

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

    return 'Fotos indexiert: $doneString von $totalString';
  }

  @override
  String get indexingText => 'Text in Fotos lesen';

  @override
  String indexingTextDownloading(int percent) {
    return 'Textmodelle werden geladen: $percent %';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Lädt die Textmodelle ($megabytesString MB) von $host herunter; findet die Wörter in deinen Fotos';
  }

  @override
  String get indexingTextMissing =>
      'Dein Server hat die Textmodelle nicht installiert';

  @override
  String get indexingTextPlatform =>
      'Nutzt die Texterkennung deines Telefons; nichts herunterzuladen. Liest neue Fotos';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Fotos auf Text gelesen: $doneString von $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Text lesen ist hier nicht verfügbar';

  @override
  String get indexingTextWaiting => 'Die Textmodelle werden per WLAN geladen';

  @override
  String get indexingUnavailable =>
      'Die Suche auf diesem Gerät ist hier nicht verfügbar';

  @override
  String get indexingWaiting => 'Das Suchmodell wird über WLAN geladen';

  @override
  String get infoAddName => 'Namen hinzufügen';

  @override
  String get infoAddTag => 'Schlagwort hinzufügen';

  @override
  String get infoAlbums => 'Alben';

  @override
  String get infoAllMetadata => 'Alle Metadaten anzeigen';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Gesichert';

  @override
  String get infoCamera => 'Kamera';

  @override
  String get infoChangeAdjust => 'Farben angepasst';

  @override
  String get infoChangeCrop => 'Zugeschnitten';

  @override
  String get infoChangeFlip => 'Gespiegelt';

  @override
  String get infoChangeInpaint => 'Bereich aufgefüllt';

  @override
  String get infoChangeLocal => 'Bereich angepasst';

  @override
  String get infoChangeLut => 'Farblook angewendet';

  @override
  String get infoChangeOther => 'Bearbeitet';

  @override
  String get infoChangeTurn => 'Gedreht';

  @override
  String get infoCompare => 'Mit Original vergleichen';

  @override
  String infoConfidence(String percent) {
    return 'Sicherheit: $percent';
  }

  @override
  String get infoCopyPath => 'Pfad kopieren';

  @override
  String get infoCurrent => 'Aktuell';

  @override
  String get infoDescription => 'Beschreibung hinzufügen';

  @override
  String get infoEditDate => 'Datum ändern';

  @override
  String infoEditNumber(int number) {
    return 'Bearbeitung $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Bearbeitete Kopie von $name';
  }

  @override
  String get infoFaces => 'Gesichter';

  @override
  String get infoFile => 'Datei';

  @override
  String get infoFromFileName => 'aus dem Dateinamen';

  @override
  String get infoHistory => 'Bearbeitungsverlauf';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente',
      one: '$count Element',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Ort';

  @override
  String get infoMap => 'Karte des Aufnahmeorts';

  @override
  String get infoMapAgree =>
      'Kartenkacheln kommen aus dem Internet und verraten, welches Gebiet Sie ansehen';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Neues Schlagwort: $path';
  }

  @override
  String get infoNoAlbum => 'In keinem Album';

  @override
  String get infoOnDevice => 'Auf diesem Gerät';

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

    return '$widthString × $heightString Pixel';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Aus $album entfernen';
  }

  @override
  String infoRemoveTag(String tag) {
    return '$tag entfernen';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Aus $album entfernt';
  }

  @override
  String get infoRevert => 'Wiederherstellen';

  @override
  String get infoSaveCopy => 'Als Kopie speichern';

  @override
  String get infoShared => 'geteilt';

  @override
  String get infoShowFaces => 'Gesichter auf dem Foto zeigen';

  @override
  String get infoShowMap => 'Karte anzeigen';

  @override
  String get infoTags => 'Schlagwörter';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Versionen',
      one: '$count Version',
    );
    return '$_temp0 · zuletzt $time';
  }

  @override
  String get infoWhy => 'Warum dieses Datum?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Aus der Datei gelesen, als $tag',
      'name': 'Aus dem Dateinamen gelesen',
      'folder': 'Aus dem Namen eines Ordners gelesen',
      'host': 'Vom Dienst angegeben, aus dem die Datei stammt',
      'unknown': 'Nichts in der Datei datiert sie, daher gilt das Datum ihrer letzten Änderung',
      'other': 'Die Datei ist noch nicht gelesen, daher gilt das Datum, das das Gerät angibt',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Liste',
      'other': 'Raster',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Name',
      'taken': 'Aufnahmedatum',
      'modified': 'Änderungsdatum',
      'size': 'Größe',
      'random': 'Zufällig',
      'extension': 'Typ',
      'custom': 'Albumreihenfolge',
      'other': 'Aufnahmedatum',
    });
    return '$_temp0';
  }

  @override
  String get keyAlt => 'Alt';

  @override
  String get keyControl => 'Strg';

  @override
  String get keyMeta => 'Cmd';

  @override
  String get keyShift => 'Umschalt';

  @override
  String get languageDevice => 'Gerätesprache';

  @override
  String get languageName => 'Deutsch';

  @override
  String get libraryAddFolder => 'Ordner hinzufügen';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Nicht gesichert',
      'backed_up': 'Gesichert',
      'cloud_only': 'Nur in der Cloud',
      'other': 'Alle',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Alles ist gesichert',
      'backed_up': 'Noch nichts gesichert',
      'cloud_only': 'Nichts ist nur auf dem Server',
      'other': 'Hier ist nichts',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Sicherungssymbole';

  @override
  String get libraryEmpty => 'Hier erscheinen deine Fotos';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Nach Woche gruppieren',
      'month': 'Nach Monat gruppieren',
      'other': 'Nach Tag gruppieren',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Ausgeblendete und archivierte Elemente wieder ausblenden';

  @override
  String get libraryNoKeyring =>
      'Photolib bewahrt den Schlüssel zu deiner Bibliothek im Schlüsselbund des Systems auf, der nicht läuft oder gesperrt ist. Starte oder entsperre einen Schlüsselbund wie GNOME Keyring oder KWallet und versuche es dann erneut.';

  @override
  String get libraryRevealExcluded =>
      'Ausgeschlossene Ordner 5 Minuten lang anzeigen';

  @override
  String get libraryShowVeiled =>
      'Ausgeblendete und archivierte Elemente 5 Minuten lang zeigen';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Zuletzt hinzugefügt',
      'other': 'Aufnahmedatum',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib konnte die auf diesem Gerät gespeicherte Bibliothek nicht öffnen';

  @override
  String get libraryViewOptions => 'Ansichtsoptionen';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Vorschaubilder werden vorbereitet: $doneString von $totalString';
  }

  @override
  String get libraryZoomIn => 'Größere Miniaturansichten';

  @override
  String get libraryZoomOut => 'Kleinere Miniaturansichten';

  @override
  String get mapAddTrack => 'GPX-Track hinzufügen';

  @override
  String get mapArea => 'Kartenausschnitt';

  @override
  String get mapAttribution => '© OpenStreetMap-Mitwirkende';

  @override
  String get mapClearLasso => 'Auswahl aufheben';

  @override
  String get mapEmpty => 'Noch keine Fotos mit Ort';

  @override
  String get mapHeat => 'Heatmap';

  @override
  String get mapLasso => 'Durch Einkreisen von Fotos auswählen';

  @override
  String get mapLoading => 'Fotos werden auf der Karte platziert';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fotos: $countString';
  }

  @override
  String get mapSearchHere => 'In diesem Bereich suchen';

  @override
  String get mapSplit => 'Fotos unter der Karte zeigen';

  @override
  String get mapTilesAgree =>
      'Der Kartenhintergrund kommt vom Server von OpenStreetMap (tile.openstreetmap.org), der sieht, welchen Bereich du ansiehst';

  @override
  String get mapTilesShow => 'Hintergrund anzeigen';

  @override
  String get mapTime => 'Zeitraum';

  @override
  String get mapTitle => 'Karte';

  @override
  String get mapTrackBad => 'Diese Datei enthält keine GPX-Tracks';

  @override
  String get mapTrips => 'Reisen';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favorit',
      'hidden': 'Ausgeblendet',
      'archived': 'Archiviert',
      'offline': 'Auf diesem Gerät behalten',
      'offline': 'Auf diesem Gerät behalten',
      'offline': 'Auf diesem Gerät behalten',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Zugriff erlauben';

  @override
  String get mediaAccessNone =>
      'Photolib benötigt Zugriff auf deine Fotos und Videos, um sie anzuzeigen.';

  @override
  String get mediaAccessPartial =>
      'Photolib sieht nur die Fotos und Videos, die du ausgewählt hast. Eine Galerie benötigt Zugriff auf alle.';

  @override
  String get mediaAccessSelect => 'Mehr Fotos auswählen';

  @override
  String get nameLabel => 'Name';

  @override
  String get nextAddRoot =>
      'Füge den Ordner in der Serverkonfiguration zu external_roots hinzu und starte den Server neu.';

  @override
  String get nextAskAdmin => 'Frag den Administrator deines Servers.';

  @override
  String get nextAskOwner =>
      'Bitte die Person, der die Mediathek gehört, dich Fotos hinzufügen zu lassen.';

  @override
  String get nextCheckConnection => 'Prüfe die Verbindung, um zu sehen, warum.';

  @override
  String get nextCheckEntry => 'Prüfe deine Eingabe und versuche es erneut.';

  @override
  String get nextConfirm =>
      'Prüfe, wie viele Elemente betroffen sind, und bestätige dann.';

  @override
  String get nextDeleteWebhook =>
      'Lösche einen Webhook, den du nicht mehr brauchst, und versuche es dann erneut.';

  @override
  String get nextEditConfig =>
      'Ändere es in der Serverkonfiguration und starte den Server neu.';

  @override
  String get nextFreeSpace =>
      'Gib Speicher frei oder bitte deinen Administrator um mehr.';

  @override
  String get nextNewLink => 'Bitte deinen Administrator um einen neuen.';

  @override
  String get nextNewestToken =>
      'Kopiere das neueste aus dem Log von photolibd.';

  @override
  String get nextOtherAdmin =>
      'Mache zuerst ein anderes Konto zum Administrator.';

  @override
  String get nextOtherFolder => 'Wähle einen eigenen Ordner.';

  @override
  String get nextRefresh => 'Aktualisiere und versuche es erneut.';

  @override
  String get nextReport =>
      'Versuche es erneut. Passiert es wieder, kopiere die Details unten für deinen Administrator.';

  @override
  String get nextSetUpPrivate =>
      'Richte private Bibliotheken in den Einstellungen fertig ein und versuche es dann erneut.';

  @override
  String get nextSignIn => 'Melde dich erneut an.';

  @override
  String get nextSignInAccount =>
      'Melde dich mit deinem Konto an und versuche es erneut.';

  @override
  String get nextSignInInstead => 'Melde dich stattdessen an.';

  @override
  String get nextTryAgain => 'Versuche es erneut.';

  @override
  String get nextUpdateAndAgree =>
      'Aktualisiere die App und stimme dem Hinweis erneut zu.';

  @override
  String get nextUseAnother => 'Wähle einen anderen.';

  @override
  String get nextUseHttps =>
      'Nutze die Adresse des Servers mit https:// oder verbinde dich aus dem Netzwerk des Servers.';

  @override
  String get nextWait => 'Warte eine Minute und versuche es dann erneut.';

  @override
  String get offlineKeep => 'Offline behalten';

  @override
  String offlineKeepHere(String size) {
    return 'Auf diesem Gerät behalten ($size)';
  }

  @override
  String get offlineKeptHere => 'Auf diesem Gerät behalten';

  @override
  String get offlineStopKeeping => 'Nicht mehr offline behalten';

  @override
  String get otherFiles => 'Andere Dateien';

  @override
  String get passphraseCreate =>
      'Auf diesem Computer läuft kein Schlüsselbund (Secret Service), der die Schlüssel von Photolib aufbewahrt. Wähle eine Passphrase mit mindestens 10 Zeichen, um sie zu schützen: Photolib fragt bei jedem Start danach.';

  @override
  String get passphraseLabel => 'Passphrase';

  @override
  String get passphraseMismatch => 'Die Passphrasen stimmen nicht überein.';

  @override
  String get passphraseRepeat => 'Passphrase wiederholen';

  @override
  String get passphraseTooShort => 'Verwende mindestens 10 Zeichen.';

  @override
  String get passphraseUnlock =>
      'Gib die Passphrase ein, die die Schlüssel von Photolib auf diesem Computer schützt.';

  @override
  String get passphraseWrong => 'Falsche Passphrase. Versuche es erneut.';

  @override
  String photoPosition(int index, int count) {
    return 'Foto $index von $count';
  }

  @override
  String get privacyCheckKit => 'Wiederherstellungskit prüfen';

  @override
  String get privacyDrillDue =>
      'Zeit für eine Wiederherstellungsübung: Prüfe, ob dein Wiederherstellungskit deine privaten Bibliotheken noch entsperrt.';

  @override
  String get privacyHonest =>
      'Private Bibliotheken werden auf deinen Geräten verschlüsselt, und niemand sonst kann sie öffnen: weder der Server noch sein Administrator noch die Entwickler von Photolib. Verlierst du sowohl dein Passwort als auch dein Wiederherstellungskit, sind deine Fotos für immer verloren, und niemand kann sie für dich zurückholen.';

  @override
  String get privacyKitBody =>
      'Schreib diese 24 Wörter der Reihe nach auf Papier und bewahre sie an einem sicheren Ort auf. Sie entsperren deine privaten Bibliotheken, falls du dein Passwort vergisst – für jeden, der sie hat.';

  @override
  String get privacyKitDone => 'Dein Wiederherstellungskit funktioniert.';

  @override
  String get privacyKitOther =>
      'Das ist nicht dein aktuelles Wiederherstellungskit.';

  @override
  String get privacyKitTitle => 'Dein Wiederherstellungskit';

  @override
  String get privacyKitUnverified =>
      'Wiederherstellungskit noch nicht bestätigt';

  @override
  String privacyKitVerified(String date) {
    return 'Wiederherstellungskit bestätigt am $date';
  }

  @override
  String get privacyKitWritten => 'Ich habe sie aufgeschrieben';

  @override
  String get privacyNotReady =>
      'Private Uploads bleiben aus, bis du zwei Wege zum Entsperren hast und dein Wiederherstellungskit bestätigt hast.';

  @override
  String get privacyPasswordHelp =>
      'Gib das Passwort deines Kontos ein: Es wird zu einem Weg, deine privaten Bibliotheken zu entsperren.';

  @override
  String get privacyPhrase => 'Wiederherstellungsphrase';

  @override
  String get privacyPhraseHelp => 'Die 24 Wörter deines Wiederherstellungskits';

  @override
  String get privacyPhraseInvalid =>
      'Das ist keine Wiederherstellungsphrase. Prüfe jedes Wort.';

  @override
  String get privacyReady => 'Private Uploads sind an.';

  @override
  String get privacyRecoveryKit => 'Wiederherstellungskit';

  @override
  String get privacySetUp => 'Einrichten';

  @override
  String get privacyShowWords => 'Wörter noch einmal zeigen';

  @override
  String get privacyTitle => 'Private Bibliotheken';

  @override
  String privacyUnknownWord(int number) {
    return 'Wort $number ist kein Wort eines Wiederherstellungskits.';
  }

  @override
  String get privacyVerify => 'Bestätigen';

  @override
  String get privacyVerifyBody =>
      'Gib diese Wörter aus deinem Wiederherstellungskit ein, um zu zeigen, dass du es gesichert hast.';

  @override
  String get privacyWays => 'Wege zum Entsperren';

  @override
  String privacyWord(int number) {
    return 'Wort $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Diese Wörter passen nicht zu deinem Wiederherstellungskit. Prüfe, was du aufgeschrieben hast.';

  @override
  String get privacyWrongPassword =>
      'Das ist nicht das Passwort deines Kontos.';

  @override
  String get problemAdminOnly => 'Nur ein Administrator kann das.';

  @override
  String get problemBusy => 'Der Server ist ausgelastet oder startet neu.';

  @override
  String get problemChanged => 'Das hat sich inzwischen geändert.';

  @override
  String get problemConfirm =>
      'Das würde mehr Elemente ausblenden oder löschen, als der Server ohne Bestätigung tut';

  @override
  String get problemContribute =>
      'Du darfst dieser Mediathek keine Fotos hinzufügen.';

  @override
  String get problemCopy => 'Details kopieren';

  @override
  String get problemDetails => 'Details';

  @override
  String get problemDiskLow =>
      'Die Festplatte des Servers ist fast voll, deshalb pausieren Uploads.';

  @override
  String get problemEmailTaken => 'Ein anderes Konto hat diese E-Mail-Adresse.';

  @override
  String get problemExists => 'Es existiert bereits.';

  @override
  String get problemFaceNotice =>
      'Dein Server verlangt eine neuere Fassung des Gesichtshinweises, als diese App zeigt.';

  @override
  String get problemGone => 'Es ist nicht mehr auf dem Server.';

  @override
  String get problemHandleTaken => 'Ein anderes Konto hat diesen Anmeldenamen.';

  @override
  String get problemInterrupted => 'Der Upload wurde unterbrochen.';

  @override
  String get problemInvalid => 'Ein Wert ist ungültig';

  @override
  String get problemLastAdmin =>
      'Der Server braucht mindestens einen Administrator.';

  @override
  String get problemLinkInvalid =>
      'Dieser Link ist abgelaufen oder wurde schon benutzt.';

  @override
  String get problemLoginFailed =>
      'E-Mail, Anmeldename oder Passwort ist falsch.';

  @override
  String get problemMaintenanceKey =>
      'Sicherungen, Integritätsprüfungen und endgültige Löschungen lassen sich nur pausieren, wenn du angemeldet bist, nicht mit einem API-Schlüssel';

  @override
  String get problemNotAllowed => 'Dein Konto darf das nicht.';

  @override
  String get problemNotExternal =>
      'Nur Mediatheken aus den eigenen Ordnern des Servers lassen sich durchsuchen.';

  @override
  String get problemOidcClaim =>
      'Dein Anmeldedienst hat nicht so angegeben, wer du bist, wie dieser Server es akzeptiert.';

  @override
  String get problemOidcDown =>
      'Dein Anmeldedienst antwortet dem Server nicht.';

  @override
  String get problemOidcFailed =>
      'Dein Anmeldedienst hat die Anmeldung abgelehnt.';

  @override
  String get problemOidcNotAllowed =>
      'Dein Konto darf sich nicht auf diese Weise anmelden.';

  @override
  String get problemOidcTaken =>
      'Diese Anmeldung ist bereits mit einem anderen Photolib-Konto verknüpft.';

  @override
  String get problemOidcUnknown =>
      'Dieser Server bietet diese Art der Anmeldung nicht mehr an.';

  @override
  String get problemPasskeysOff =>
      'Passkeys funktionieren erst, wenn der Server seine öffentliche Adresse hat.';

  @override
  String get problemPinned =>
      'Das ist in der Konfigurationsdatei festgelegt und kann hier nicht geändert werden.';

  @override
  String get problemPolicyOff => 'Das ist auf diesem Server ausgeschaltet.';

  @override
  String get problemQuota => 'Dein Speicher auf dem Server ist voll.';

  @override
  String get problemRestoreKey =>
      'Eine Sicherung lässt sich nur wiederherstellen, wenn du angemeldet bist, nicht mit einem API-Schlüssel.';

  @override
  String get problemRootDiffers =>
      'Dieser Ordner enthält nicht die Dateien dieser Bibliothek';

  @override
  String get problemRootNotAllowed =>
      'Dieser Ordner liegt nicht unter den external_roots der Serverkonfiguration';

  @override
  String get problemRootOverlaps =>
      'Dieser Ordner enthält eine andere Bibliothek oder die eigenen Daten des Servers oder liegt darin';

  @override
  String get problemScanning => 'Diese Bibliothek wird bereits gescannt';

  @override
  String get problemSecondFactor =>
      'Dieses Konto braucht einen zweiten Faktor, etwa einen Authentifizierungscode oder einen Passkey, den diese Version von Photolib noch nicht liefern kann.';

  @override
  String get problemSetupDone =>
      'Dieser Server hat bereits einen Administrator.';

  @override
  String get problemSetupExpired => 'Das hat zu lange gedauert.';

  @override
  String get problemSetupToken => 'Dieses Einrichtungstoken ist falsch.';

  @override
  String get problemSignedOut => 'Du bist vom Server abgemeldet.';

  @override
  String get problemStepUp =>
      'Diese Änderung braucht zuerst dein Passwort oder einen Code.';

  @override
  String get problemStorage => 'Der Server erreicht seinen Speicher nicht.';

  @override
  String get problemTooMany => 'Zu viele Versuche in kurzer Zeit.';

  @override
  String get problemUnexpected => 'Etwas Unerwartetes ist schiefgegangen.';

  @override
  String get problemUnreachable => 'Der Server antwortet nicht.';

  @override
  String get problemUploadDamaged =>
      'Die Datei hat sich unterwegs geändert oder wurde beschädigt.';

  @override
  String get problemUploadExpired =>
      'Der Server hat diesen Upload nicht mehr: Unfertige Uploads verfallen nach einem Tag.';

  @override
  String get problemWebhookLimit =>
      'Dein Konto hat schon so viele Webhooks, wie es haben darf.';

  @override
  String get problemWebhooksOff =>
      'Webhooks sind auf diesem Server ausgeschaltet.';

  @override
  String get recoveryCode => 'Wiederherstellungscode';

  @override
  String get recoveryCodeAbout =>
      'Öffnet den Speicher von Photolib auf diesem Gerät, wenn der Schlüsselspeicher seinen Schlüssel verliert';

  @override
  String get recoveryCodeEnter => 'Wiederherstellungscode eingeben';

  @override
  String get recoveryCreate => 'Wiederherstellungscode erstellen';

  @override
  String get recoveryLater => 'Später';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString Änderungen gibt es nur auf diesem Gerät. Ein Wiederherstellungscode holt sie zurück, wenn der Schlüsselspeicher den Schlüssel von Photolib verliert.',
      one: '1 Änderung gibt es nur auf diesem Gerät. Ein Wiederherstellungscode holt sie zurück, wenn der Schlüsselspeicher den Schlüssel von Photolib verliert.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Schreib diese 24 Wörter auf und bewahre sie sicher auf: sie öffnen den Speicher von Photolib auf diesem Gerät ohne den Schlüssel im Schlüsselspeicher. Sie ersetzen jeden früheren Code.';

  @override
  String get recoveryUnlock => 'Entsperren';

  @override
  String get recoveryWrong =>
      'Das ist nicht der Wiederherstellungscode dieses Speichers';

  @override
  String get renameFind => 'Suchen';

  @override
  String get renamePattern => 'Neuer Name';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Zu lang: Ein Name hat höchstens 255 Bytes',
      'invalid': 'Kein gültiger Dateiname',
      'duplicate': 'Auch einer anderen Datei gegeben',
      'exists': 'Eine andere Datei in diesem Ordner hat diesen Namen',
      'other': 'Kann nicht umbenannt werden',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Ersetzen durch';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Umbenannte Dateien: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Im Finder zeigen',
      'windows': 'Im Explorer anzeigen',
      'other': 'Im Ordner anzeigen',
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
      other: '$countString Elemente',
      one: '1 Element',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Zeitraum';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'In deiner Bibliothek suchen';

  @override
  String get searchFavourites => 'Favoriten';

  @override
  String get searchFolder => 'Ordner';

  @override
  String get searchHint => 'Datei- oder Ordnername';

  @override
  String get searchMotionPhotos => 'Bewegte Fotos';

  @override
  String get searchNothing => 'Keine Treffer';

  @override
  String get searchPanoramas => 'Panoramen';

  @override
  String get searchPhotos => 'Fotos';

  @override
  String get searchScreenshots => 'Screenshots';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Videos';

  @override
  String get securityAddPasskey => 'Passkey hinzufügen';

  @override
  String get securityCode => 'Code';

  @override
  String get securityCodesHelp =>
      'Bewahre diese Codes sicher auf. Jeder funktioniert einmal anstelle deines zweiten Faktors, und sie werden nur jetzt angezeigt.';

  @override
  String securityCodesLeft(int count) {
    return 'Unbenutzt: $count';
  }

  @override
  String get securityNewCodes => 'Neue Codes';

  @override
  String get securityPasskeyNotAdded => 'Es wurde kein Passkey hinzugefügt.';

  @override
  String get securityRecoveryCodes => 'Wiederherstellungscodes';

  @override
  String get securityRemovePasskey => 'Passkey entfernen';

  @override
  String get securitySetUp => 'Einrichten';

  @override
  String get securityStepUpBody =>
      'Gib dein Passwort, einen Code aus deiner Authenticator-App oder einen Wiederherstellungscode ein, um deine zweiten Faktoren zu ändern.';

  @override
  String get securityStepUpTitle => 'Bestätige, dass du es bist';

  @override
  String get securityTitle => 'Zweite Faktoren';

  @override
  String get securityTotp => 'Authenticator-App';

  @override
  String get securityTotpHelp =>
      'Füge diesen Schlüssel deiner Authenticator-App hinzu und gib dann den angezeigten Code ein.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': 'An', 'other': 'Aus'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Ausschalten';

  @override
  String get securityWrongCode => 'Dieser Code ist falsch.';

  @override
  String get securityWrongProof => 'Passwort oder Code ist falsch.';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get selectionClear => 'Auswahl aufheben';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählt',
      one: '1 ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Auswahl anzeigen';

  @override
  String get serverAccount => 'E-Mail oder Anmeldename';

  @override
  String get serverAdd => 'Server hinzufügen';

  @override
  String get serverAddressInvalid => 'Gib Adressen wie photos.example.org ein';

  @override
  String get serverAddresses => 'Adressen';

  @override
  String get serverAddressesHelp =>
      'Eine pro Zeile: der Server in deinem Netzwerk, im Internet oder über ein VPN. Die App nutzt die schnellste, die antwortet. Oder füge den Link zum Festlegen des Passworts ein, den du bekommen hast.';

  @override
  String get serverCa => 'Zertifikat der privaten CA (PEM)';

  @override
  String get serverCaChoose => 'Zertifikatsdatei auswählen';

  @override
  String serverCertificateBody(String host) {
    return '$host zeigt ein Zertifikat, dem dieses Gerät nicht vertraut. Vertraue ihm nur, wenn dieser SHA-256-Fingerabdruck der deines Servers ist:';
  }

  @override
  String get serverCertificateTitle => 'Diesem Zertifikat vertrauen?';

  @override
  String get serverConfirm => 'Bestätigen';

  @override
  String get serverConnect => 'Verbinden';

  @override
  String get serverCreateAdmin => 'Administrator erstellen';

  @override
  String get serverEnded =>
      'Der Server hat diese Sitzung beendet. Melde dich erneut an.';

  @override
  String get serverHandleHelp =>
      'Kleinbuchstaben, Ziffern, Punkte, Bindestriche und Unterstriche; er ändert sich nie.';

  @override
  String get serverHeaders => 'Eigene Header';

  @override
  String get serverHeadersHelp =>
      'Einer pro Zeile als Name: value; nur über HTTPS gesendet';

  @override
  String get serverHeadersInvalid => 'Schreib jeden Header als Name: value';

  @override
  String get serverIdentity => 'Client-Zertifikat (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Client-Zertifikat auswählen';

  @override
  String get serverIdentityInvalid =>
      'Das ist kein PKCS#12-Zertifikat, oder sein Passwort ist falsch.';

  @override
  String get serverIdentityPassword => 'Passwort des Client-Zertifikats';

  @override
  String get serverLoading =>
      'Der auf diesem Gerät gespeicherte Server wird gelesen';

  @override
  String get serverNearby => 'Server in diesem Netzwerk';

  @override
  String get serverNeedsHttps =>
      'Dieser Server braucht eine HTTPS-Adresse: Außerhalb deines lokalen Netzwerks meldet sich Photolib nicht über einfaches HTTP an.';

  @override
  String get serverNoSignIn =>
      'Dieser Server bietet keine Anmeldung an, die diese Version von Photolib unterstützt.';

  @override
  String get serverOffline =>
      'Der Server antwortet nicht. Du bleibst angemeldet.';

  @override
  String get serverPasskeyFailed =>
      'Es wurde kein Passkey verwendet. Versuche es erneut oder verwende einen Code.';

  @override
  String get serverPasskeyRequired =>
      'Dieser Server verlangt einen Passkey, den diese Version von Photolib noch nicht nutzen kann.';

  @override
  String get serverPassword => 'Passwort';

  @override
  String get serverPasswordAgain => 'Passwort wiederholen';

  @override
  String get serverPasswordSetupInvalid =>
      'Dieses Token zum Festlegen des Passworts ist falsch, schon benutzt oder abgelaufen. Bitte um ein neues.';

  @override
  String get serverPasswordSetupToken => 'Token zum Festlegen des Passworts';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Von deiner Administratorin oder deinem Administrator, oder von photolibd admin password-setup auf dem Server ausgegeben.';

  @override
  String get serverPasswordsDiffer => 'Die Passwörter stimmen nicht überein.';

  @override
  String get serverPrivateLibrariesBody =>
      'Ein neues Passwort öffnet sie nicht. Öffne sie wieder mit deinem Wiederherstellungskit, einem Passkey oder einem Gerät, das noch angemeldet ist.';

  @override
  String get serverPrivateLibrariesGo => 'Passwort festlegen';

  @override
  String get serverPrivateLibrariesTitle =>
      'Deine privaten Bibliotheken bleiben gesperrt';

  @override
  String get serverProxy => 'HTTP-Proxy als host:port';

  @override
  String get serverProxyInvalid => 'Gib den Proxy als host:port ein';

  @override
  String get serverRecoveryCode => 'Wiederherstellungscode';

  @override
  String get serverRemove => 'Diesen Server entfernen';

  @override
  String get serverRequired => 'Pflichtfeld';

  @override
  String get serverSecondFactor =>
      'Der zweite Faktor dieses Kontos ist ein Passkey, den diese Version von Photolib noch nicht nutzen kann.';

  @override
  String get serverSecondFactorCode =>
      'Dieses Konto braucht außerdem einen Code aus deiner Authenticator-App oder einen Wiederherstellungscode.';

  @override
  String get serverSecondFactorTitle => 'Bestätige, dass du es bist';

  @override
  String get serverSecondFactorWrong =>
      'Das hat nicht geklappt. Nach fünf Versuchen melde dich erneut an.';

  @override
  String get serverSetPassword => 'Passwort festlegen';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Für $handle auf $server';
  }

  @override
  String get serverSetPasswordOpen => 'Passwort festlegen';

  @override
  String get serverSetPasswordTitle => 'Lege dein Passwort fest';

  @override
  String get serverSetUp => 'Neuen Server einrichten';

  @override
  String get serverSetupLinkElsewhere =>
      'Um diesen Link zu nutzen, melde dich zuerst von diesem Server ab oder entferne ihn, wenn der Link für einen anderen ist.';

  @override
  String get serverSetupTitle => 'Server einrichten';

  @override
  String get serverSetupToken => 'Einrichtungstoken';

  @override
  String get serverSetupTokenHelp =>
      'photolibd schreibt es in sein Protokoll, solange der Server keinen Administrator hat; jeder Start schreibt ein neues.';

  @override
  String get serverSignIn => 'Anmelden';

  @override
  String get serverSignOut => 'Abmelden';

  @override
  String serverSignedInAs(String account) {
    return 'Angemeldet als $account';
  }

  @override
  String get serverSignedOut => 'Abgemeldet';

  @override
  String get serverSwitch => 'Konto wechseln';

  @override
  String get serverTotpCode => 'Code aus deiner Authentifizierungs-App';

  @override
  String get serverTrust => 'Vertrauen';

  @override
  String get serverUnreadable =>
      'Der auf diesem Gerät gespeicherte Server kann nicht gelesen werden';

  @override
  String get serverUsePasskey => 'Passkey verwenden';

  @override
  String get serverUseRecoveryCode =>
      'Stattdessen einen Wiederherstellungscode verwenden';

  @override
  String get settingsBackground => 'Hinter transparenten Bildern';

  @override
  String get settingsDefaultTab => 'Ordner und Alben öffnen mit';

  @override
  String get settingsFolders => 'Ordner';

  @override
  String get settingsIndexing => 'Indexierung auf diesem Gerät';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLibrary => 'Bibliothek';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsStart => 'Startbildschirm';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps':
          'Linken oder rechten Rand tippen für das vorige oder nächste Element',
      'oneFingerZoom': 'Doppeltippen und ziehen, um mit einem Finger zu zoomen',
      'swipes': 'Auf einem Video links nach oben oder unten wischen für die Helligkeit, rechts für die Lautstärke',
      'maxBrightness': 'Volle Helligkeit beim Ansehen',
      'autoRotate': 'Nach der Ausrichtung jedes Fotos oder Videos drehen',
      'mixAudio':
          'Videos über andere Audiowiedergabe abspielen, statt sie anzuhalten',
      'autoplay': 'Videos beim Öffnen abspielen',
      'loop': 'Videos wiederholen',
      'autoNext': 'Am Ende eines Videos zum nächsten Element wechseln',
      'resume': 'Videos dort fortsetzen, wo sie verlassen wurden',
      'other': 'Animierte Bilder im Raster abspielen',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Wie lange Photolib Elemente im Papierkorb behält';

  @override
  String get settingsViewerBar => 'Schaltflächen in der Leiste der Ansicht';

  @override
  String get settingsViewing => 'Ansicht';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString geteilte Fotos und Videos warten, bis Photolib sie zu deiner Fotomediathek hinzufügen darf. Nicht gesicherte Objekte werden nach 7 Tagen gelöscht.',
      one: '1 geteiltes Foto oder Video wartet, bis Photolib es zu deiner Fotomediathek hinzufügen darf. Nicht gesicherte Objekte werden nach 7 Tagen gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Zu groß, um es auf einmal zu teilen: Wähle weniger Elemente aus';

  @override
  String shareTooMany(int count) {
    return 'Zu viele, um sie auf einmal zu teilen: Wähle höchstens $count aus';
  }

  @override
  String get shortcutsTitle => 'Tastenkombinationen';

  @override
  String get slideshow => 'Diashow';

  @override
  String get slideshowLoop => 'Wiederholen';

  @override
  String get slideshowOptions => 'Diashow-Optionen';

  @override
  String get slideshowSeconds => 'Sekunden pro Element';

  @override
  String get slideshowShuffle => 'Zufällige Reihenfolge';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Absteigend',
      'other': 'Aufsteigend',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Dieses Gerät';

  @override
  String sourceHide(String name) {
    return '$name ausblenden';
  }

  @override
  String get sourceHideOthers => 'Alles andere hier ausblenden';

  @override
  String get sourceLost => 'Kein Zugriff';

  @override
  String get sourcePartly => 'Teilweise angezeigt';

  @override
  String sourceShow(String name) {
    return '$name anzeigen';
  }

  @override
  String get sourceShowEverything => 'Alles hier anzeigen';

  @override
  String get sourceShowOnly => 'Nur diesen anzeigen';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Zeitleiste',
      'folders': 'Ordner und Alben',
      'favourites': 'Favoriten',
      'other': 'Zeitleiste',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Eine Person offline behalten';

  @override
  String get storageBudget => 'Speicherbudget';

  @override
  String get storageClear => 'Offline-Kopien entfernen';

  @override
  String get storageClearAction => 'Entfernen';

  @override
  String storageClearBody(String size) {
    return 'Das entfernt $size, die auf diesem Gerät liegen, und beendet das Offline-Behalten von Alben, Suchen und Fotos. Deine Bibliothek auf dem Server bleibt unberührt.';
  }

  @override
  String get storageKeepLibrary => 'Gesamte Bibliothek behalten';

  @override
  String get storageKeepOriginals => 'Auch Originale behalten';

  @override
  String get storageNoPeople => 'Noch keine Person benannt.';

  @override
  String get storageNoPins =>
      'Nichts ist angeheftet. Hefte ein Album, eine Suche oder ein Foto an, um es offline zu behalten.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Suche',
      'person': 'Person',
      'library': 'Gesamte Bibliothek',
      'asset': 'Foto',
      'other': 'Angeheftet',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Passt nicht ins Budget: $size mehr nötig';
  }

  @override
  String get storagePinNothing =>
      'Nichts herunterzuladen: Die Fotos sind schon auf diesem Gerät';

  @override
  String get storagePinPaused =>
      'Wartet: Diese Voreinstellung behält nichts offline';

  @override
  String get storagePinPlanning => 'Suche, was zu behalten ist …';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Lädt herunter: $haveString von $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Offline verfügbar ($size)';
  }

  @override
  String get storagePinWaiting => 'Wird geladen, sobald du online bist';

  @override
  String get storagePins => 'Offline behalten';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Nur Katalog',
      'spaceSaver': 'Platz sparen',
      'travel': 'Ausgewählte Alben offline',
      'everything': 'Alles',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Behält nichts; Fotos werden beim Öffnen von deinem Server geladen.',
      'spaceSaver': 'Behält Vorschauen deiner ganzen Bibliothek, neueste zuerst, im Rahmen des Budgets.',
      'travel': 'Behält nur, was du anheftest: Alben, Suchen und Fotos.',
      'everything': 'Behält die Originale deiner ganzen Bibliothek, neueste zuerst, im Rahmen des Budgets.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Was dieses Gerät behält';

  @override
  String get storageSubtitle => 'Offline-Kopien und Speicherbudget';

  @override
  String get storageTitle => 'Speicher';

  @override
  String storageUsed(String used, String budget) {
    return '$used von $budget belegt';
  }

  @override
  String get storageWebNote =>
      'Ein Browser behält nur Vorschauen und löscht sie beim Abmelden.';

  @override
  String get storeNoKeyring =>
      'Photolib bewahrt den Schlüssel seines lokalen Speichers im Schlüsselbund des Systems auf, der nicht geantwortet hat. Installiere und entsperre gnome-keyring, KWallet oder KeePassXC mit aktiviertem Secret Service und versuche es erneut.';

  @override
  String get storeNoKeystore =>
      'Photolib konnte den Schlüsselspeicher dieses Geräts nicht erreichen, der den Schlüssel seines lokalen Speichers enthält.';

  @override
  String get storeRebuilt =>
      'Der Schlüsselspeicher dieses Geräts hatte den Schlüssel des lokalen Speichers von Photolib nicht mehr, daher wurde der Speicher neu aufgebaut. Seine Einstellungen und was es nur auf diesem Gerät gab, sind verloren; Mediatheken werden erneut synchronisiert und Miniaturansichten kehren zurück.';

  @override
  String get storeRecoveryNeeded =>
      'Der Schlüsselspeicher dieses Geräts hat den Schlüssel des lokalen Speichers von Photolib nicht mehr. Gib den Wiederherstellungscode ein oder setze den Speicher zurück und verliere, was es nur auf diesem Gerät gibt.';

  @override
  String get storeReset => 'Speicher zurücksetzen';

  @override
  String get storeResetBody =>
      'Was es nur auf diesem Gerät gibt, geht verloren; Mediatheken werden erneut synchronisiert und Miniaturansichten kehren zurück.';

  @override
  String get storeUnavailable =>
      'Der Speicher auf diesem Gerät ist nicht verfügbar: Einstellungen und Sammlungen werden nicht gespeichert';

  @override
  String get tabCollections => 'Sammlungen';

  @override
  String get tabLibrary => 'Bibliothek';

  @override
  String get tabSearch => 'Suche';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeSystem => 'System';

  @override
  String get timelineBenchmark => 'Zeitleisten-Benchmark';

  @override
  String get timelineBenchmarkCopy => 'Ergebnisse kopieren';

  @override
  String get timelineCannotPlay =>
      'Kann in diesem Browser nicht abgespielt werden';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position von $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position von $count, keine Vorschau';
  }

  @override
  String get timelineExcluded => 'In einem ausgeschlossenen Ordner';

  @override
  String get timelineScrubber => 'Nach Datum scrollen';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Datum unbekannt';

  @override
  String timelineWeek(String date) {
    return 'Woche vom $date';
  }

  @override
  String toolbarAdd(String action) {
    return '$action zur Leiste hinzufügen';
  }

  @override
  String toolbarDown(String action) {
    return '$action nach unten verschieben';
  }

  @override
  String get toolbarInBar => 'In der Leiste';

  @override
  String get toolbarInMenu => 'Im Menü ⋮';

  @override
  String toolbarRemove(String action) {
    return '$action aus der Leiste entfernen';
  }

  @override
  String get toolbarReset => 'Auf Standard zurücksetzen';

  @override
  String toolbarUp(String action) {
    return '$action nach oben verschieben';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Hierher verschieben',
      'other': 'Hierher kopieren',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Dort gibt es schon eine Datei oder einen Ordner dieses Namens',
      'changed':
          'Die Kopie stimmte nicht mit dem Original überein und wurde entfernt',
      'cancelled': 'Abgebrochen',
      'invalid': 'Kein gültiger Ordnername',
      'other': 'Fehlgeschlagen',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Zuletzt verwendet';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString Elemente endgültig löschen? Das lässt sich nicht rückgängig machen.',
      one: '1 Element endgültig löschen? Das lässt sich nicht rückgängig machen.',
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
      other: 'Noch $daysString Tage',
      one: 'Noch 1 Tag',
      zero: 'Wird heute endgültig gelöscht',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Der Papierkorb ist leer';

  @override
  String get trashEmptyAll => 'Papierkorb leeren';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString Tage';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Elemente in den Papierkorb verschoben',
      one: '1 Element in den Papierkorb verschoben',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Aus der Liste entfernen';

  @override
  String trashRetention(int days) {
    return 'Photolib löscht, was es im Papierkorb aufbewahrt, nach $days Tagen endgültig; jedes Element zeigt die verbleibende Zeit.';
  }

  @override
  String get trashTitle => 'Papierkorb';

  @override
  String get undo => 'Rückgängig';

  @override
  String get uploadAction => 'Fotos und Videos hochladen';

  @override
  String get uploadClear => 'Leeren';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString von $totalString hochgeladen';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fehlgeschlagen: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Elemente archiviert',
      one: '1 Element archiviert',
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
      other: '$countString Elemente ausgeblendet',
      one: '1 Element ausgeblendet',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Schwarz',
      'white': 'Weiß',
      'other': 'Schachbrett',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Dieses Video kann auf diesem Gerät nicht abgespielt werden';

  @override
  String get viewerCaptions => 'Untertitel';

  @override
  String get viewerCompass => 'Kompass-Sperre';

  @override
  String get viewerCopy => 'Kopieren';

  @override
  String get viewerCopyText => 'Text kopieren';

  @override
  String get viewerCustomize => 'Symbolleiste anpassen…';

  @override
  String get viewerDial =>
      'Richtung. Klicken, um nach vorn zu blicken. Ziehen, um sich umzusehen, scrollen oder zusammenziehen zum Zoomen, doppelklicken zum Zurücksetzen';

  @override
  String get viewerFilmstrip => 'Filmstreifen';

  @override
  String get viewerFirst => 'Erstes';

  @override
  String get viewerFisheye => 'Fischauge';

  @override
  String get viewerGyroscope => 'Zum Umsehen bewegen';

  @override
  String get viewerHdr => 'In HDR anzeigen';

  @override
  String get viewerInfo => 'Info';

  @override
  String get viewerInfoLoading => 'Infos zu diesem Element werden geladen';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString von $countString';
  }

  @override
  String get viewerLast => 'Letztes';

  @override
  String get viewerLenses => 'Objektiv wählen';

  @override
  String get viewerMap => 'Karte';

  @override
  String get viewerMotion => 'Bewegung abspielen';

  @override
  String get viewerMotionDenied =>
      'Dieser Browser hat den Zugriff auf die Bewegungssensoren nicht erlaubt';

  @override
  String get viewerMotionMissing =>
      'Dieses Gerät hat kein Gyroskop zum Umsehen';

  @override
  String get viewerMute => 'Stummschalten';

  @override
  String get viewerNext => 'Nächstes';

  @override
  String get viewerNextFrame => 'Nächstes Bild';

  @override
  String get viewerPause => 'Pause';

  @override
  String get viewerPlanet => 'Kleiner Planet';

  @override
  String get viewerPlay => 'Abspielen';

  @override
  String get viewerPrevious => 'Vorheriges';

  @override
  String get viewerPreviousFrame => 'Vorheriges Bild';

  @override
  String get viewerRotate => 'Drehen';

  @override
  String get viewerSdr => 'In SDR anzeigen';

  @override
  String get viewerSeek => 'Position';

  @override
  String get viewerSetAs => 'Festlegen als';

  @override
  String get viewerShare => 'Teilen';

  @override
  String get viewerSpeed => 'Wiedergabegeschwindigkeit';

  @override
  String get viewerSphere =>
      '360°-Ansicht. Zum Umsehen ziehen, zum Zoomen auseinanderziehen';

  @override
  String get viewerText => 'Text in diesem Foto';

  @override
  String get viewerTextCopied => 'Text kopiert';

  @override
  String get viewerTextNone => 'Kein Text in diesem Foto gefunden';

  @override
  String get viewerTextUnread =>
      'Der Text dieses Fotos wurde noch nicht gelesen';

  @override
  String get viewerUnmute => 'Ton an';

  @override
  String get viewerZoomIn => 'Vergrößern';

  @override
  String get viewerZoomOut => 'Verkleinern';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD-Karte',
      'other': 'Intern',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Vergrößern';

  @override
  String get zoomOut => 'Verkleinern';
}
