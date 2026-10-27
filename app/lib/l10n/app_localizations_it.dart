// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get actionAddToAlbum => 'Aggiungi all\'album';

  @override
  String get actionArchive => 'Archivia';

  @override
  String get actionCopyTo => 'Copia in…';

  @override
  String get actionDeleteForever => 'Elimina definitivamente';

  @override
  String get actionFavourite => 'Aggiungi ai preferiti';

  @override
  String get actionHide => 'Nascondi';

  @override
  String get actionMoveTo => 'Sposta in…';

  @override
  String get actionRename => 'Rinomina';

  @override
  String get actionRestore => 'Ripristina';

  @override
  String get actionShare => 'Condividi';

  @override
  String get actionTrash => 'Sposta nel cestino';

  @override
  String get actionUnarchive => 'Togli dall\'archivio';

  @override
  String get actionUndo => 'Annulla';

  @override
  String get actionUnfavourite => 'Rimuovi dai preferiti';

  @override
  String get actionUnhide => 'Mostra';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Attivo',
      'disabled': 'Disattivato',
      'invited': 'Invitato',
      'deleted': 'Eliminato',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Account';

  @override
  String get adminAddAccount => 'Aggiungi account';

  @override
  String get adminAddExternalLibrary => 'Aggiungi una libreria esterna';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts tentativi',
      many: '$attempts di tentativi',
      one: '1 tentativo',
      zero: 'non ancora eseguita',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Registro di controllo';

  @override
  String get adminBackUpNow => 'Esegui backup ora';

  @override
  String get adminBackupQueued =>
      'Il backup è in coda; seguirà una prova di ripristino';

  @override
  String get adminBackups => 'Backup del database';

  @override
  String get adminCancelJob => 'Annulla attività';

  @override
  String get adminCapabilities => 'Funzionalità';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Librerie gestite',
      'uploads': 'Caricamenti da dispositivi, web e CLI',
      'folder_browser': 'Esplora cartelle',
      'device_folders': 'Cartelle del dispositivo nelle app connesse',
      'sharing': 'Condivisione e link pubblici',
      'edits': 'Modifiche',
      'deletes': 'Eliminazioni',
      'xmp_writes': 'Scrittura dei file XMP',
      'face_recognition': 'Riconoscimento facciale',
      'ml_search': 'Ricerca intelligente',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Avviso',
      'fail': 'Non riuscito',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Copiato';

  @override
  String get adminCopyBundle =>
      'Copia la diagnostica per una segnalazione di bug';

  @override
  String get adminCopyLink => 'Copia link';

  @override
  String get adminDelete => 'Elimina';

  @override
  String get adminDeviceBackups => 'Backup dei dispositivi';

  @override
  String get adminDevices => 'I tuoi dispositivi';

  @override
  String get adminDisable => 'Disattiva';

  @override
  String adminDrillFailed(String detail) {
    return 'L’ultima prova di ripristino non è riuscita: $detail';
  }

  @override
  String get adminEdit => 'Modifica';

  @override
  String get adminEmail => 'Email';

  @override
  String get adminEnable => 'Attiva';

  @override
  String get adminErrorSignIn => 'Accedi come amministratore';

  @override
  String get adminFacesDefault =>
      'Il riconoscimento facciale è attivo per impostazione predefinita nei nuovi account';

  @override
  String get adminFiles => 'File per tipo';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Danneggiato',
      'missing': 'Mancante',
      'size': 'Dimensione errata',
      'hash': 'Sostituito',
      'orphan': 'File estraneo',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size liberi';
  }

  @override
  String get adminFreeDisk =>
      'Metti in pausa i caricamenti sotto questa percentuale di spazio libero su disco, da 0 a 50';

  @override
  String get adminFreeDiskGb =>
      'o sotto questo spazio libero in GB, se è minore, da 0 a 100000';

  @override
  String get adminHandle => 'Nome utente';

  @override
  String get adminIntegrity => 'Integrità';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementi',
      many: '$countString di elementi',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'In coda',
      'running': 'In esecuzione',
      'done': 'Completata',
      'dead': 'Non riuscita',
      'cancelled': 'Annullata',
      'other': 'Tutte',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Tipo di attività, ad esempio render';

  @override
  String get adminJobs => 'Attività';

  @override
  String adminLastSeen(String time) {
    return 'Ultimo accesso $time';
  }

  @override
  String get adminLibraries => 'Librerie';

  @override
  String get adminLibraryOwner => 'Proprietario';

  @override
  String get adminLibraryRoot => 'Cartella sul server, ad esempio /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Online',
      'offline': 'Offline',
      'scanning': 'Scansione in corso',
      'error': 'Errore',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Registro del server';

  @override
  String get adminName => 'Nome';

  @override
  String get adminNothing => 'Ancora niente qui';

  @override
  String get adminOutOfRange => 'Fuori intervallo';

  @override
  String get adminOverview => 'Panoramica';

  @override
  String get adminPair => 'Associa un dispositivo';

  @override
  String get adminPairBody =>
      'Scansiona questo codice o invia il link, poi incollalo in Aggiungi un server di Photolib sul nuovo dispositivo: porta tutti gli indirizzi di questo server e il suo certificato, così nessuno deve digitarli.';

  @override
  String get adminPasswordSetup => 'Link per impostare la password';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Invia questo link a $name con qualsiasi mezzo, oppure fagli scansionare il codice. Imposta una password una sola volta, fino al $date.';
  }

  @override
  String get adminPause => 'Metti in pausa un tipo di attività';

  @override
  String adminPauseMinutes(int max) {
    return 'Minuti, da 1 a $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type è in pausa fino al $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementi da salvare',
      many: '$countString di elementi da salvare',
      one: '1 elemento da salvare',
      zero: 'Niente da salvare',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Criteri';

  @override
  String get adminPolicyReset => 'Usa il valore del livello superiore';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Attivo per impostazione predefinita',
      'server': 'Impostato per il server',
      'user': 'Impostato per questo account',
      'library': 'Impostato per questa libreria',
      'config': 'Impostato nella configurazione',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Applica un profilo';

  @override
  String get adminPresetBody =>
      'Un profilo imposta ogni funzionalità per il server e cancella ciò che hanno impostato account e librerie. Tutto resta modificabile.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Consultazione archivio',
      'family_backup': 'Backup di famiglia',
      'personal': 'Personale',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Le librerie esterne di sola lettura sono l’unica fonte di verità: niente caricamenti, librerie gestite, cartelle del dispositivo, modifiche, eliminazioni o scritture XMP',
      'family_backup': 'Tutto attivo tranne la scrittura XMP',
      'personal': 'Tutto attivo tranne la condivisione e i link pubblici',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Codice QR del link';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString attività in coda',
      many: '$countString di attività in coda',
      one: '1 attività in coda',
      zero: 'Niente da fare',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'Quota di archiviazione in GB; lascia vuoto per nessun limite';

  @override
  String get adminRemote => 'Accesso remoto';

  @override
  String get adminRemoteBody =>
      'Raggiungi il server ovunque senza aprire porte sul router. Scegli un modo; ognuno gli dà un indirizzo HTTPS da aggiungere alle app. Poi provalo dall’esterno.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared si collega verso Cloudflare, che serve il tuo dominio in HTTPS. Il piano gratuito limita una richiesta a 100 MB, che i backup non raggiungono mai: inviano 8 MiB alla volta.';

  @override
  String get adminRemoteNoAddress =>
      'Aggiungi a questa app l’indirizzo https:// del server per provarlo dall’esterno.';

  @override
  String get adminRemoteReachable => 'Raggiungibile dall’esterno.';

  @override
  String get adminRemoteTailscale =>
      'Installa Tailscale sul computer del server e su ogni dispositivo, nella stessa tailnet o nel tuo Headscale, poi esegui questo sul computer del server e imposta public_url sull’indirizzo che mostra.';

  @override
  String get adminRemoteTest => 'Prova dall’esterno';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host aprirà $url dai suoi server nel mondo, e così conoscerà questo indirizzo. Continuare?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Non raggiungibile dall’esterno: controlla il modo scelto, poi riprova.';

  @override
  String get adminRemoteWireguard =>
      'Serve una porta UDP aperta dal lato del server o su un nodo centrale. Questa è la configurazione di un dispositivo; crea le chiavi con wg genkey.';

  @override
  String get adminRepair =>
      'Ripristinalo da un backup o da un dispositivo che lo ha ancora';

  @override
  String get adminRepairOrphan =>
      'Nessuna foto lo indica: controllalo, poi eliminalo o tienilo';

  @override
  String get adminReprocess => 'Rielabora';

  @override
  String get adminReprocessFaces => 'Rileva di nuovo i volti';

  @override
  String get adminReprocessFolder =>
      'Cartella, ad esempio 2024/05; lascia vuoto per l\'intera libreria';

  @override
  String get adminReprocessMetadata => 'Rileggi i metadati';

  @override
  String get adminReprocessRenditions => 'Rigenera miniature e anteprime';

  @override
  String get adminRestore => 'Ripristina';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Il ripristino di $name non è riuscito: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Nessuna prova di ripristino è ancora riuscita';

  @override
  String adminRestoreVerified(String when) {
    return 'Ultimo ripristino verificato: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd si arresta e, al riavvio, sostituisce l’intero database con $name. Ciò che è cambiato da quel backup va perso e ogni dispositivo si risincronizza da zero.';
  }

  @override
  String get adminRestoring =>
      'photolibd si sta arrestando per ripristinare il backup';

  @override
  String get adminResume => 'Riprendi';

  @override
  String get adminRetry => 'Riprova';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Amministratore',
      'user': 'Utente',
      'viewer': 'Visualizzatore',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Salvato';

  @override
  String get adminScan => 'Scansiona ora';

  @override
  String get adminScrubDays =>
      'Giorni in cui la verifica controlla ogni originale, da 1 a 3650';

  @override
  String get adminScrubNever => 'Prima verifica completa in corso';

  @override
  String adminScrubbed(String time) {
    return 'Ultima verifica completa $time';
  }

  @override
  String get adminSecondAdmin =>
      'Rendi amministratore una seconda persona, così che qualcun altro possa gestire e ripristinare il server se tu non puoi.';

  @override
  String adminSilent(String time) {
    return 'Silenzioso da $time';
  }

  @override
  String get adminSilentHours =>
      'Ore senza rapporto prima che il backup di un dispositivo sia silenzioso, da 1 a 8760';

  @override
  String get adminStores => 'Archiviazione';

  @override
  String get adminThisDevice => 'Questo dispositivo';

  @override
  String get adminTitle => 'Amministrazione del server';

  @override
  String get adminTrashDays => 'Giorni nel cestino, da 1 a 3650';

  @override
  String get adminTwoFactor =>
      'Tutti gli account devono configurare un secondo fattore di autenticazione';

  @override
  String get adminUsage => 'Utilizzo per account';

  @override
  String get albumCover => 'Usa come copertina';

  @override
  String get albumEmpty => 'Questo album è vuoto';

  @override
  String get albumHideMemories => 'Nascondi dai ricordi';

  @override
  String get albumHideTimeline => 'Nascondi dalla cronologia';

  @override
  String get albumNew => 'Nuovo album';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Qualsiasi data';

  @override
  String get backupCap => 'Elemento più grande';

  @override
  String get backupCharging => 'Solo durante la ricarica';

  @override
  String backupCompleted(String time) {
    return 'Ultimo backup completo: $time';
  }

  @override
  String backupContact(String time) {
    return 'Ultimo contatto con il server: $time';
  }

  @override
  String get backupEnabled => 'Esegui il backup di questo dispositivo';

  @override
  String get backupFolderNo => 'Questa no';

  @override
  String get backupFolderYes => 'Esegui il backup';

  @override
  String backupHours(int count) {
    return '$count h';
  }

  @override
  String get backupMetered =>
      'Su reti a consumo, come i dati mobili o un hotspot';

  @override
  String get backupNever => 'Nessun backup completo per ora';

  @override
  String backupNewFolder(String name) {
    return 'Nuova cartella $name: eseguire il backup?';
  }

  @override
  String get backupNoLimit => 'Nessun limite';

  @override
  String get backupNothing => 'Niente in attesa';

  @override
  String get backupNow => 'Esegui ora il backup';

  @override
  String backupOverdue(int hours, String items) {
    return 'Nessun backup completo da $hours h. In attesa: $items';
  }

  @override
  String get backupOverdueTitle => 'Il backup non è stato completato';

  @override
  String backupPending(String items) {
    return 'In attesa: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Nuovo tentativo: $time';
  }

  @override
  String get backupRoaming => 'Esegui il backup in roaming';

  @override
  String get backupSignIn =>
      'Accedi a un server per eseguire il backup di questo dispositivo';

  @override
  String get backupSignedOut =>
      'Backup interrotto: il server ha disconnesso questo dispositivo. Accedi di nuovo in Impostazioni.';

  @override
  String get backupSince => 'Scattate dal';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Il backup attende che il server sia raggiungibile',
      'charging': 'Il backup attende che il dispositivo sia in carica',
      'battery_low': 'Il backup attende: la batteria è scarica',
      'roaming': 'Il backup attende durante il roaming',
      'quota': 'Backup interrotto: lo spazio sul server è esaurito',
      'second_factor': 'Backup interrotto: il server chiede un secondo fattore per questo account',
      'other': 'Backup interrotto: il server ha risposto $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupWaiting => 'Senza backup';

  @override
  String get backupWarnAfter => 'Avvisa se non completo da';

  @override
  String get backupWhat => 'Cosa salvare';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'In una cartella che non hai scelto',
      'folder_new': 'In una nuova cartella: scegli se eseguirne il backup',
      'type_excluded': 'Un tipo di elemento che non hai scelto',
      'before_date': 'Scattato prima della data scelta',
      'selected': 'In attesa del suo turno',
      'server_restored':
          'Il server l’ha perso in un ripristino: viene inviato di nuovo',
      'working': 'Backup in corso',
      'waiting_for_icloud': 'In attesa che iCloud lo scarichi',
      'metered': 'In attesa di una rete non a consumo',
      'metered_cap': 'Troppo grande per una rete a consumo',
      'unreadable': 'Questo dispositivo non riesce a leggerlo',
      'changed': 'È cambiato durante l’invio',
      'quota': 'Lo spazio sul server è esaurito',
      'other': 'Il server l’ha rifiutato: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Il server non funziona più con questa versione di Photolib.';

  @override
  String get checkAppTooOldNext => 'Aggiorna Photolib.';

  @override
  String get checkChanged =>
      'Il certificato del server non è quello di cui ti sei fidato.';

  @override
  String get checkChangedNext =>
      'Se l’amministratore l’ha sostituito, fidati di quello nuovo. Altrimenti qualcuno potrebbe ascoltare: non proseguire.';

  @override
  String get checkClock =>
      'L’orologio di questo dispositivo e quello del server differiscono di oltre cinque minuti.';

  @override
  String get checkClockNext =>
      'Lascia che il dispositivo imposti data e ora automaticamente.';

  @override
  String get checkDnsFailed =>
      'Il nome del server non porta a nessun indirizzo.';

  @override
  String get checkDnsFailedNext =>
      'Controlla l’indirizzo o collegati alla rete del server.';

  @override
  String checkExpired(String date) {
    return 'Il certificato del server è scaduto il $date.';
  }

  @override
  String get checkFailed => 'Non riuscito';

  @override
  String get checkMetered => 'Sei su una rete a consumo, come i dati mobili.';

  @override
  String get checkMeteredNext => 'Collegati al Wi-Fi prima di backup grandi.';

  @override
  String get checkNotPhotolib =>
      'Risponde qualcosa che non è Photolib, come la pagina di errore di un proxy o una pagina di accesso Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Accedi al Wi-Fi dal browser o chiedi all’amministratore di controllare il proxy.';

  @override
  String get checkOtherServer =>
      'A questo indirizzo risponde un altro server Photolib.';

  @override
  String get checkPassed => 'Superato';

  @override
  String get checkRefused => 'Nessuno risponde a questo indirizzo.';

  @override
  String get checkRefusedNext =>
      'Controlla che il server sia acceso e di essere sulla sua rete o VPN.';

  @override
  String get checkRun => 'Verifica la connessione';

  @override
  String get checkRunning => 'Verifica in corso';

  @override
  String get checkSelfSigned =>
      'Il server usa un certificato proprio, che questo dispositivo non conosce ancora.';

  @override
  String get checkSkipped => 'Non verificato';

  @override
  String get checkStepAuth => 'Il tuo accesso';

  @override
  String get checkStepClock => 'L’orologio del tuo dispositivo';

  @override
  String get checkStepDns => 'Trovare l’indirizzo del server';

  @override
  String get checkStepNetwork => 'La tua rete';

  @override
  String get checkStepServer => 'Photolib sul server';

  @override
  String get checkStepTcp => 'Raggiungere il server';

  @override
  String get checkStepTls => 'Connessione sicura e certificato';

  @override
  String get checkStepUpload => 'Caricamenti grandi attraverso i proxy';

  @override
  String get checkTimedOut => 'Il server impiega troppo tempo a rispondere.';

  @override
  String get checkTimedOutNext => 'Controlla la connessione, poi riprova.';

  @override
  String get checkTitle => 'Verifica della connessione';

  @override
  String get checkTlsFailed => 'La connessione sicura non è riuscita.';

  @override
  String get checkTrustNext =>
      'Fidati solo se la sua impronta corrisponde a quella del tuo server.';

  @override
  String get checkUntrusted =>
      'Il certificato del server proviene da un’autorità di cui questo dispositivo non si fida.';

  @override
  String get checkUploadCap =>
      'Un proxy lungo il percorso rifiuta i caricamenti grandi, quindi i backup vanno più lenti, a piccoli pezzi.';

  @override
  String get checkUploadCapNext =>
      'Chiedi all’amministratore di lasciar passare dal proxy richieste da 64 MB.';

  @override
  String get collectionAlbums => 'Album';

  @override
  String collectionHide(String name) {
    return 'Nascondi $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Sposta $name in basso';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Sposta $name in alto';
  }

  @override
  String get collectionPeople => 'Persone';

  @override
  String collectionPin(String name) {
    return 'Fissa $name';
  }

  @override
  String get collectionPlaces => 'Luoghi';

  @override
  String collectionShow(String name) {
    return 'Mostra $name';
  }

  @override
  String get collectionTags => 'Tag';

  @override
  String collectionUnpin(String name) {
    return 'Non fissare più $name';
  }

  @override
  String get collectionsCustomise => 'Personalizza';

  @override
  String get collectionsDone => 'Fine';

  @override
  String get commandPalette => 'Riquadro comandi';

  @override
  String get commandPaletteHint => 'Digita un comando';

  @override
  String get dateFormatDefault => 'Predefinito della lingua';

  @override
  String get dateFormatDmy => 'Giorno-mese-anno';

  @override
  String get dateFormatMdy => 'Mese-giorno-anno';

  @override
  String get dateFormatYmd => 'Anno-mese-giorno';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString su questo dispositivo e con backup',
      many: '$countString di elementi su questo dispositivo e con backup',
      one: '$countString su questo dispositivo e con backup',
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
      other: '$countString solo su questo dispositivo, senza backup',
      many: '$countString di elementi solo su questo dispositivo, senza backup',
      one: '$countString solo su questo dispositivo, senza backup',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Con Foto di iCloud attivo, gli elementi eliminati da questo dispositivo spariscono anche da iCloud e dagli altri tuoi dispositivi Apple.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString solo nella tua libreria',
      many: '$countString di elementi solo nella tua libreria',
      one: '$countString solo nella tua libreria',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Rimuovi da questo dispositivo';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'I $countString elementi con backup; la tua libreria li conserva',
      many:
          'I $countString di elementi con backup; la tua libreria li conserva',
      one: 'L\'elemento con backup; la tua libreria lo conserva',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Le copie su questo dispositivo vanno nel suo cestino: lo spazio torna libero quando viene svuotato.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminare $countString elementi?',
      many: 'Eliminare $countString di elementi?',
      one: 'Eliminare $countString elemento?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Da questo dispositivo e dalla tua libreria',
      'device': 'Solo da questo dispositivo',
      'other': 'Dalla tua libreria',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Non presente';

  @override
  String get deviceFolderCard => 'Scheda SD';

  @override
  String get deviceFolderExclude => 'Escludi';

  @override
  String get deviceFolderExcludeThis => 'Escludi questa cartella';

  @override
  String get deviceFolderExcludedNotice =>
      'La cartella di questo elemento è esclusa dalla tua libreria';

  @override
  String get deviceFolderForget => 'Rimuovi dall\'elenco';

  @override
  String get deviceFolderInternal => 'Memoria interna';

  @override
  String get deviceFolderKeep => 'Mantieni';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, è nuova';
  }

  @override
  String get deviceFolders => 'Cartelle del dispositivo';

  @override
  String get deviceFoldersAll =>
      'Mostra tutte le cartelle tranne quelle escluse';

  @override
  String get deviceFoldersChosen => 'Mostra solo le cartelle scelte';

  @override
  String get deviceFoldersExcludedNow => 'Esclusa dalla libreria';

  @override
  String get deviceFoldersSearch => 'Cerca cartelle';

  @override
  String get diagnosticsAdvanced => 'Mostra diagnostica';

  @override
  String get diagnosticsAllLoggers => 'Tutti i logger';

  @override
  String get diagnosticsCopied => 'Registro copiato';

  @override
  String get diagnosticsCopy => 'Copia il registro mostrato';

  @override
  String get diagnosticsEmpty => 'Ancora nessuna voce nel registro';

  @override
  String get diagnosticsExport => 'Esporta pacchetto diagnostico';

  @override
  String get diagnosticsExported => 'Pacchetto diagnostico salvato';

  @override
  String get diagnosticsLevel => 'Livello';

  @override
  String get diagnosticsLogger => 'Logger';

  @override
  String get diagnosticsTitle => 'Diagnostica';

  @override
  String get download => 'Scarica';

  @override
  String get downloadCurrent => 'Versione attuale, con le modifiche';

  @override
  String get downloadFailed => 'Impossibile scaricare';

  @override
  String get downloadOriginal => 'Originale';

  @override
  String downloadSaved(String name) {
    return '$name salvato';
  }

  @override
  String get downloadVersion => 'Quale versione?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Download di $countString elementi',
      many: 'Download di $countString di elementi',
      one: 'Download di $countString elemento',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Miglioramento automatico';

  @override
  String get editorCrop => 'Ritaglia';

  @override
  String get editorCropOriginal => 'Originale';

  @override
  String get editorCropSquare => 'Quadrato';

  @override
  String get editorEdit => 'Modifica';

  @override
  String get editorFlip => 'Rifletti';

  @override
  String get editorRotate => 'Ruota';

  @override
  String get editorSaveCopy => 'Salva copia';

  @override
  String get editorSaveFailed => 'Impossibile salvare la copia';

  @override
  String get editorSaveVersion => 'Salva';

  @override
  String get editorSaved => 'Salvata come copia';

  @override
  String get editorVersionFailed => 'Impossibile salvare la versione';

  @override
  String get editorVersionSaved => 'Salvata come nuova versione';

  @override
  String get editorVersionsUnsupported =>
      'Questo server non può ancora conservare versioni delle foto modificate';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString modifiche sono state annullate: il server le ha rifiutate.',
      many:
          '$countString di modifiche sono state annullate: il server le ha rifiutate.',
      one: '1 modifica è stata annullata: il server l\'ha rifiutata.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Chiudi';

  @override
  String get editsRejectedForbidden =>
      'Puoi vedere gli elementi, ma non modificarli.';

  @override
  String get editsRejectedInvalid =>
      'Il server non ha potuto accettare le modifiche.';

  @override
  String get editsRejectedNotFound =>
      'Gli elementi sono stati eliminati o non sono più condivisi con te.';

  @override
  String get errorNotFound => 'Questa pagina non esiste';

  @override
  String get errorRetry => 'Riprova';

  @override
  String get errorTitle => 'Si è verificato un problema';

  @override
  String faceNumber(int number) {
    return 'Volto $number';
  }

  @override
  String get facesAgree => 'Acconsento';

  @override
  String get facesAura => 'Descrivi i volti con AuraFace (download più grande)';

  @override
  String get facesNotNow => 'Non ora';

  @override
  String get facesNoticeKeep =>
      'Ciò che viene trovato resta con le tue foto, sui tuoi dispositivi e sul tuo server. Le descrizioni non vengono mai mostrate né condivise e tutto viene eliminato quando smetti o elimini la foto.';

  @override
  String get facesNoticeOptional =>
      'È facoltativo. Tutto il resto di Photolib funziona senza e puoi smettere in qualsiasi momento nelle Impostazioni.';

  @override
  String get facesNoticeTitle => 'Trovare i volti nelle tue foto?';

  @override
  String get facesNoticeWhat =>
      'Photolib cerca i volti nelle tue foto e nei tuoi video e conserva, per ciascuno, dove si trova e un elenco di numeri che lo descrive, per poter ritrovare la stessa persona. Una descrizione di questo tipo può essere considerata un dato biometrico.';

  @override
  String get facesNoticeWhere =>
      'Avviene su questo dispositivo e, se hai effettuato l’accesso, sul tuo server. Mai su un servizio nostro o di altri.';

  @override
  String get facesServerFailed =>
      'Non è stato possibile avvisare il tuo server. Riprova.';

  @override
  String get facesServerOff => 'Il tuo server non trova volti per te';

  @override
  String get facesServerOn => 'Il tuo server trova i volti per te';

  @override
  String get facesServerUnavailable =>
      'Il tuo server non offre il riconoscimento facciale';

  @override
  String facesStatusDownloading(int percent) {
    return 'Download dei modelli dei volti: $percent%';
  }

  @override
  String get facesStatusMissing =>
      'Il tuo server non ha installato i modelli dei volti';

  @override
  String get facesStatusNoDecoder =>
      'La ricerca dei volti non è disponibile: la libreria di immagini (libvips) non è stata trovata. Reinstalla Photolib, oppure installa libvips e riavviala.';

  @override
  String get facesStatusRunning => 'Ricerca dei volti su questo dispositivo';

  @override
  String get facesStatusUnavailable =>
      'Su questo dispositivo non si possono trovare i volti';

  @override
  String get facesStatusWaiting =>
      'I modelli dei volti si scaricano con il Wi-Fi';

  @override
  String get facesSwitch => 'Trova i volti nelle mie foto';

  @override
  String get facesSwitchOff =>
      'Disattivato. Non viene calcolato nulla sui volti finché non acconsenti.';

  @override
  String get facesSwitchOn => 'Attivo. Photolib trova i volti nelle tue foto.';

  @override
  String get facesTitle => 'Volti e persone';

  @override
  String get facesWithdraw => 'Elimina e smetti';

  @override
  String get facesWithdrawBody =>
      'Vengono eliminati tutti i volti, le descrizioni e le persone che Photolib ha trovato per te, su questo dispositivo e sul tuo server. Le tue foto non cambiano.';

  @override
  String get facesWithdrawTitle => 'Smettere di trovare i volti?';

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

    return 'File non modificati: $countString';
  }

  @override
  String get folderAllow => 'Consenti l\'accesso a questa cartella';

  @override
  String get folderDelete => 'Elimina cartella';

  @override
  String folderDeleteBody(String name) {
    return 'Spostare le foto e i video di $name nel cestino?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementi',
      many: '$countString di elementi',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Nuova cartella';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline, $countString elementi',
      many: 'Offline, $countString di elementi',
      one: 'Offline, 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Questa cartella è già nella libreria, oppure contiene una cartella della libreria o si trova all\'interno di una di queste';

  @override
  String get folderRemove => 'Rimuovi cartella';

  @override
  String folderRemoveBody(String folder) {
    return 'Le foto e i video di $folder verranno rimossi dalla libreria. I file resteranno intatti sul disco.';
  }

  @override
  String get folderRemoveConfirm => 'Rimuovi';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scansione in corso, $countString elementi finora',
      many: 'Scansione in corso, $countString di elementi finora',
      one: 'Scansione in corso, 1 elemento finora',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Consenti l\'accesso';

  @override
  String get foldersHideExcluded => 'Nascondi le cartelle escluse';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib non può più leggere $countString cartelle.',
      many: 'Photolib non può più leggere $countString di cartelle.',
      one: 'Photolib non può più leggere 1 cartella.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Mostra le cartelle escluse ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Questo browser non può usare una cartella come libreria. Apri Photolib in Chrome o Edge su un computer oppure usa l\'app desktop.';

  @override
  String get galleryButtons => 'Pulsanti';

  @override
  String get galleryChips => 'Chip';

  @override
  String get galleryGrid => 'Griglia';

  @override
  String get galleryMenus => 'Menu e pannelli';

  @override
  String get galleryShowSheet => 'Mostra un pannello';

  @override
  String get galleryTitle => 'Componenti';

  @override
  String hiddenCollections(int count) {
    return 'Nascoste ($count)';
  }

  @override
  String get indexingAllowMetered => 'Scarica con i dati mobili';

  @override
  String get indexingAllowSaver => 'Anche in modalità risparmio energetico';

  @override
  String get indexingBattery => 'Batteria necessaria senza caricatore';

  @override
  String get indexingChargingOnly => 'Solo durante la ricarica';

  @override
  String indexingDownloading(int percent) {
    return 'Download del modello di ricerca: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Impossibile leggere $count foto',
      many: 'Impossibile leggere $count di foto',
      one: 'Impossibile leggere 1 foto',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Questo dispositivo indicizza solo le foto nuove';

  @override
  String get indexingMissing =>
      'Il tuo server non ha installato il modello di ricerca';

  @override
  String get indexingModels => 'Cerca su questo dispositivo';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Scarica il modello di ricerca ($megabytesString MB) da $host';
  }

  @override
  String get indexingNoDecoder =>
      'Ricerca e lettura del testo non sono disponibili: la libreria di immagini (libvips) non è stata trovata. Reinstalla Photolib, oppure installa libvips e riavviala.';

  @override
  String indexingPausedBattery(int percent) {
    return 'In pausa finché la batteria è sotto il $percent%';
  }

  @override
  String get indexingPausedCharger =>
      'In pausa finché il dispositivo non è in carica';

  @override
  String get indexingPausedHeat => 'In pausa finché il dispositivo è caldo';

  @override
  String get indexingPausedSaver =>
      'In pausa finché il risparmio energetico è attivo';

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

    return 'Foto indicizzate: $doneString di $totalString';
  }

  @override
  String get indexingText => 'Leggi il testo nelle foto';

  @override
  String indexingTextDownloading(int percent) {
    return 'Download dei modelli di testo: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Scarica i modelli di testo ($megabytesString MB) da $host; trova le parole nelle tue foto';
  }

  @override
  String get indexingTextMissing =>
      'Il tuo server non ha installato i modelli di testo';

  @override
  String get indexingTextPlatform =>
      'Usa il riconoscimento del testo del telefono; niente da scaricare. Legge le foto nuove';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Foto lette per il testo: $doneString di $totalString';
  }

  @override
  String get indexingTextUnavailable =>
      'La lettura del testo non è disponibile qui';

  @override
  String get indexingTextWaiting =>
      'I modelli di testo si scaricano con il Wi-Fi';

  @override
  String get indexingUnavailable =>
      'La ricerca su questo dispositivo non è disponibile qui';

  @override
  String get indexingWaiting => 'Il modello di ricerca si scarica con il Wi-Fi';

  @override
  String get infoAddName => 'Aggiungi nome';

  @override
  String get infoAddTag => 'Aggiungi tag';

  @override
  String get infoAlbums => 'Album';

  @override
  String get infoAllMetadata => 'Visualizza tutti i metadati';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Backup eseguito';

  @override
  String get infoCamera => 'Fotocamera';

  @override
  String get infoChangeAdjust => 'Colori regolati';

  @override
  String get infoChangeCrop => 'Ritagliata';

  @override
  String get infoChangeFlip => 'Specchiata';

  @override
  String get infoChangeInpaint => 'Area riempita';

  @override
  String get infoChangeLocal => 'Area regolata';

  @override
  String get infoChangeLut => 'Applicato uno stile di colore';

  @override
  String get infoChangeOther => 'Modificata';

  @override
  String get infoChangeTurn => 'Ruotata';

  @override
  String get infoCompare => 'Confronta con l\'originale';

  @override
  String infoConfidence(String percent) {
    return 'Affidabilità: $percent';
  }

  @override
  String get infoCopyPath => 'Copia percorso';

  @override
  String get infoCurrent => 'Attuale';

  @override
  String get infoDescription => 'Aggiungi una descrizione';

  @override
  String get infoEditDate => 'Modifica la data';

  @override
  String infoEditNumber(int number) {
    return 'Modifica $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Copia modificata di $name';
  }

  @override
  String get infoFaces => 'Volti';

  @override
  String get infoFile => 'File';

  @override
  String get infoFromFileName => 'dal nome del file';

  @override
  String get infoHistory => 'Cronologia modifiche';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi',
      many: '$count di elementi',
      one: '$count elemento',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Luogo';

  @override
  String get infoMap => 'Mappa del luogo dello scatto';

  @override
  String get infoMapAgree =>
      'I riquadri della mappa arrivano da internet e rivelano quale zona guardi';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Nuovo tag: $path';
  }

  @override
  String get infoNoAlbum => 'Non è in nessun album';

  @override
  String get infoOnDevice => 'Su questo dispositivo';

  @override
  String get infoOriginal => 'Originale';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString pixel';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Rimuovi da $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Rimuovi $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Rimosso da $album';
  }

  @override
  String get infoRevert => 'Ripristina';

  @override
  String get infoSaveCopy => 'Salva come copia';

  @override
  String get infoShared => 'condiviso';

  @override
  String get infoShowFaces => 'Mostra i volti sulla foto';

  @override
  String get infoShowMap => 'Mostra mappa';

  @override
  String get infoTags => 'Tag';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versioni',
      many: '$count di versioni',
      one: '$count versione',
    );
    return '$_temp0 · ultima $time';
  }

  @override
  String get infoWhy => 'Perché questa data?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Letta nel file, come $tag',
      'name': 'Letta nel nome del file',
      'folder': 'Letta nel nome di una cartella',
      'host': 'Fornita dal servizio da cui proviene il file',
      'unknown': 'Nulla nel file lo data, quindi vale la data della sua ultima modifica',
      'other': 'Il file non è ancora stato letto, quindi vale la data fornita dal dispositivo',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Elenco',
      'other': 'Griglia',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Nome',
      'taken': 'Data di scatto',
      'modified': 'Data di modifica',
      'size': 'Dimensione',
      'random': 'Casuale',
      'extension': 'Tipo',
      'custom': 'Ordine dell\'album',
      'other': 'Data di scatto',
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
  String get keyShift => 'Maiusc';

  @override
  String get languageDevice => 'Lingua del dispositivo';

  @override
  String get languageName => 'Italiano';

  @override
  String get libraryAddFolder => 'Aggiungi cartella';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Senza backup',
      'backed_up': 'Con backup',
      'cloud_only': 'Solo nel cloud',
      'other': 'Tutti',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Tutto ha un backup',
      'backed_up': 'Ancora nessun backup',
      'cloud_only': 'Niente è solo sul server',
      'other': 'Niente qui',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Badge di backup';

  @override
  String get libraryEmpty => 'Le tue foto verranno visualizzate qui';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Raggruppa per settimana',
      'month': 'Raggruppa per mese',
      'other': 'Raggruppa per giorno',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Nascondi di nuovo gli elementi nascosti e archiviati';

  @override
  String get libraryNoKeyring =>
      'Photolib conserva la chiave della tua libreria nel portachiavi di sistema, che non è in esecuzione o è bloccato. Avvia o sblocca un portachiavi, come GNOME Keyring o KWallet, poi riprova.';

  @override
  String get libraryRevealExcluded => 'Mostra le cartelle escluse per 5 minuti';

  @override
  String get libraryShowVeiled =>
      'Mostra gli elementi nascosti e archiviati per 5 minuti';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Aggiunti di recente',
      'other': 'Data di scatto',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib non è riuscito ad aprire la libreria salvata su questo dispositivo';

  @override
  String get libraryViewOptions => 'Opzioni di visualizzazione';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Preparazione delle miniature: $doneString di $totalString';
  }

  @override
  String get libraryZoomIn => 'Miniature più grandi';

  @override
  String get libraryZoomOut => 'Miniature più piccole';

  @override
  String get mapAddTrack => 'Aggiungi una traccia GPX';

  @override
  String get mapArea => 'Area della mappa';

  @override
  String get mapAttribution => '© contributori di OpenStreetMap';

  @override
  String get mapClearLasso => 'Annulla la selezione';

  @override
  String get mapEmpty => 'Ancora nessuna foto con un luogo';

  @override
  String get mapHeat => 'Mappa di calore';

  @override
  String get mapLasso => 'Seleziona disegnando intorno alle foto';

  @override
  String get mapLoading => 'Sto posizionando le foto sulla mappa';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Foto: $countString';
  }

  @override
  String get mapSearchHere => 'Cerca in quest\'area';

  @override
  String get mapSplit => 'Mostra le foto sotto la mappa';

  @override
  String get mapTilesAgree =>
      'Lo sfondo della mappa arriva dal server di OpenStreetMap (tile.openstreetmap.org), che vede quale area guardi';

  @override
  String get mapTilesShow => 'Mostra lo sfondo';

  @override
  String get mapTime => 'Intervallo di tempo';

  @override
  String get mapTitle => 'Mappa';

  @override
  String get mapTrackBad => 'Questo file non contiene tracce GPX';

  @override
  String get mapTrips => 'Viaggi';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Preferito',
      'hidden': 'Nascosto',
      'archived': 'Archiviato',
      'offline': 'Tenuto su questo dispositivo',
      'offline': 'Tenuto su questo dispositivo',
      'offline': 'Tenuto su questo dispositivo',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Consenti l\'accesso';

  @override
  String get mediaAccessNone =>
      'Photolib ha bisogno di accedere alle tue foto e ai tuoi video per mostrarli.';

  @override
  String get mediaAccessPartial =>
      'Photolib vede solo le foto e i video che hai selezionato. Una galleria deve poter accedere a tutti.';

  @override
  String get mediaAccessSelect => 'Seleziona altre foto';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nextAddRoot =>
      'Aggiungi la cartella a external_roots nella configurazione del server, poi riavvia il server.';

  @override
  String get nextAskAdmin => 'Chiedi all’amministratore del tuo server.';

  @override
  String get nextAskOwner =>
      'Chiedi a chi possiede la libreria di permetterti di aggiungere foto.';

  @override
  String get nextCheckConnection =>
      'Controlla la connessione per capire perché.';

  @override
  String get nextCheckEntry => 'Controlla ciò che hai inserito e riprova.';

  @override
  String get nextConfirm => 'Controlla quanti elementi riguarda, poi conferma.';

  @override
  String get nextDeleteWebhook =>
      'Elimina un webhook che non usi più, poi riprova.';

  @override
  String get nextEditConfig =>
      'Modificalo nella configurazione del server, poi riavvia il server.';

  @override
  String get nextFreeSpace =>
      'Libera spazio o chiedine altro al tuo amministratore.';

  @override
  String get nextNewLink => 'Chiedine uno nuovo al tuo amministratore.';

  @override
  String get nextNewestToken => 'Copia il più recente dal log di photolibd.';

  @override
  String get nextOtherAdmin => 'Prima rendi amministratore un altro account.';

  @override
  String get nextOtherFolder => 'Scegli una cartella tutta sua.';

  @override
  String get nextRefresh => 'Aggiorna e riprova.';

  @override
  String get nextReport =>
      'Riprova. Se succede ancora, copia i dettagli qui sotto per il tuo amministratore.';

  @override
  String get nextSetUpPrivate =>
      'Completa la configurazione delle librerie private in Impostazioni, poi riprova.';

  @override
  String get nextSignIn => 'Accedi di nuovo.';

  @override
  String get nextSignInAccount => 'Accedi con il tuo account e riprova.';

  @override
  String get nextSignInInstead => 'Accedi invece.';

  @override
  String get nextTryAgain => 'Riprova.';

  @override
  String get nextUpdateAndAgree =>
      'Aggiorna l’app, poi acconsenti di nuovo all’avviso.';

  @override
  String get nextUseAnother => 'Scegline un altro.';

  @override
  String get nextUseHttps =>
      'Usa l’indirizzo https:// del server o collegati dalla rete del server.';

  @override
  String get nextWait => 'Aspetta un minuto, poi riprova.';

  @override
  String get offlineKeep => 'Tieni offline';

  @override
  String offlineKeepHere(String size) {
    return 'Tieni su questo dispositivo ($size)';
  }

  @override
  String get offlineKeptHere => 'Tenuto su questo dispositivo';

  @override
  String get offlineStopKeeping => 'Non tenere più offline';

  @override
  String get otherFiles => 'Altri file';

  @override
  String get passphraseCreate =>
      'Su questo computer non è attivo alcun portachiavi (Secret Service) per conservare le chiavi di Photolib. Scegli una passphrase di almeno 10 caratteri per proteggerle: Photolib la chiede a ogni avvio.';

  @override
  String get passphraseLabel => 'Passphrase';

  @override
  String get passphraseMismatch => 'Le passphrase non coincidono.';

  @override
  String get passphraseRepeat => 'Ripeti la passphrase';

  @override
  String get passphraseTooShort => 'Usa almeno 10 caratteri.';

  @override
  String get passphraseUnlock =>
      'Inserisci la passphrase che protegge le chiavi di Photolib su questo computer.';

  @override
  String get passphraseWrong => 'Passphrase errata. Riprova.';

  @override
  String photoPosition(int index, int count) {
    return 'Foto $index di $count';
  }

  @override
  String get privacyCheckKit => 'Controlla il kit di recupero';

  @override
  String get privacyDrillDue =>
      'È ora di una prova di recupero: controlla che il tuo kit di recupero sblocchi ancora le tue librerie private.';

  @override
  String get privacyHonest =>
      'Le librerie private sono cifrate sui tuoi dispositivi e nessun altro può aprirle: né il server, né il suo amministratore, né gli sviluppatori di Photolib. Se perdi sia la password sia il kit di recupero, le tue foto sono perse per sempre e nessuno potrà recuperarle per te.';

  @override
  String get privacyKitBody =>
      'Scrivi queste 24 parole su carta, in ordine, e conservale in un posto sicuro. Sbloccano le tue librerie private se dimentichi la password, per chiunque le abbia.';

  @override
  String get privacyKitDone => 'Il tuo kit di recupero funziona.';

  @override
  String get privacyKitOther => 'Questo non è il tuo kit di recupero attuale.';

  @override
  String get privacyKitTitle => 'Il tuo kit di recupero';

  @override
  String get privacyKitUnverified => 'Kit di recupero non ancora verificato';

  @override
  String privacyKitVerified(String date) {
    return 'Kit di recupero verificato il $date';
  }

  @override
  String get privacyKitWritten => 'Le ho scritte';

  @override
  String get privacyNotReady =>
      'I caricamenti privati restano disattivati finché non hai due modi per sbloccare e un kit di recupero verificato.';

  @override
  String get privacyPasswordHelp =>
      'Inserisci la password del tuo account: diventa un modo per sbloccare le tue librerie private.';

  @override
  String get privacyPhrase => 'Frase di recupero';

  @override
  String get privacyPhraseHelp => 'Le 24 parole del tuo kit di recupero';

  @override
  String get privacyPhraseInvalid =>
      'Questa non è una frase di recupero. Controlla ogni parola.';

  @override
  String get privacyReady => 'I caricamenti privati sono attivi.';

  @override
  String get privacyRecoveryKit => 'Kit di recupero';

  @override
  String get privacySetUp => 'Configura';

  @override
  String get privacyShowWords => 'Mostra di nuovo le parole';

  @override
  String get privacyTitle => 'Librerie private';

  @override
  String privacyUnknownWord(int number) {
    return 'La parola $number non è una parola di un kit di recupero.';
  }

  @override
  String get privacyVerify => 'Verifica';

  @override
  String get privacyVerifyBody =>
      'Digita queste parole del tuo kit di recupero per dimostrare di averlo conservato.';

  @override
  String get privacyWays => 'Modi per sbloccare';

  @override
  String privacyWord(int number) {
    return 'Parola $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Queste parole non corrispondono al tuo kit di recupero. Controlla ciò che hai scritto.';

  @override
  String get privacyWrongPassword =>
      'Questa non è la password del tuo account.';

  @override
  String get problemAdminOnly => 'Solo un amministratore può farlo.';

  @override
  String get problemBusy => 'Il server è occupato o si sta riavviando.';

  @override
  String get problemChanged => 'Nel frattempo è cambiato.';

  @override
  String get problemConfirm =>
      'Questo nasconderebbe o eliminerebbe più elementi di quanti il server ne tocchi senza una conferma';

  @override
  String get problemContribute => 'Non puoi aggiungere foto a questa libreria.';

  @override
  String get problemCopy => 'Copia i dettagli';

  @override
  String get problemDetails => 'Dettagli';

  @override
  String get problemDiskLow =>
      'Il disco del server è quasi pieno, quindi i caricamenti sono in pausa.';

  @override
  String get problemEmailTaken => 'Un altro account ha questa email.';

  @override
  String get problemExists => 'Esiste già.';

  @override
  String get problemFaceNotice =>
      'Il tuo server chiede una versione più recente dell’avviso sui volti di quella mostrata da questa app.';

  @override
  String get problemGone => 'Non è più sul server.';

  @override
  String get problemHandleTaken => 'Un altro account ha questo nome utente.';

  @override
  String get problemInterrupted => 'Il caricamento si è interrotto.';

  @override
  String get problemInvalid => 'Un valore non è valido';

  @override
  String get problemLastAdmin =>
      'Il server ha bisogno di almeno un amministratore.';

  @override
  String get problemLinkInvalid => 'Questo link è scaduto o è già stato usato.';

  @override
  String get problemLoginFailed => 'Email, nome utente o password errati.';

  @override
  String get problemMaintenanceKey =>
      'Backup, controlli di integrità ed eliminazioni definitive possono essere messi in pausa solo dopo aver eseguito l\'accesso, non con una chiave API';

  @override
  String get problemNotAllowed => 'Il tuo account non può farlo.';

  @override
  String get problemNotExternal =>
      'Si possono analizzare solo le librerie delle cartelle del server.';

  @override
  String get problemOidcClaim =>
      'Il tuo provider di accesso non ha indicato chi sei in un modo che questo server accetta.';

  @override
  String get problemOidcDown =>
      'Il tuo provider di accesso non risponde al server.';

  @override
  String get problemOidcFailed =>
      'Il tuo provider di accesso ha rifiutato l’accesso.';

  @override
  String get problemOidcNotAllowed =>
      'Il tuo account non può accedere in questo modo.';

  @override
  String get problemOidcTaken =>
      'Questo accesso è già collegato a un altro account Photolib.';

  @override
  String get problemOidcUnknown =>
      'Questo server non offre più questo modo di accedere.';

  @override
  String get problemPasskeysOff =>
      'Le passkey funzionano solo quando il server ha il suo indirizzo pubblico.';

  @override
  String get problemPinned =>
      'È impostato nel file di configurazione e non si può modificare qui.';

  @override
  String get problemPolicyOff =>
      'Questa funzione è disattivata su questo server.';

  @override
  String get problemQuota => 'Il tuo spazio sul server è pieno.';

  @override
  String get problemRestoreKey =>
      'Un backup può essere ripristinato solo dopo aver eseguito l\'accesso, non con una chiave API.';

  @override
  String get problemRootDiffers =>
      'Questa cartella non contiene i file di questa libreria';

  @override
  String get problemRootNotAllowed =>
      'Questa cartella non si trova sotto le external_roots della configurazione del server';

  @override
  String get problemRootOverlaps =>
      'Questa cartella contiene un\'altra libreria o i dati del server stesso, oppure si trova al loro interno';

  @override
  String get problemScanning => 'Questa libreria è già in fase di scansione';

  @override
  String get problemSecondFactor =>
      'Questo account richiede un secondo fattore, come un codice di autenticazione o una passkey, che questa versione di Photolib non può ancora fornire.';

  @override
  String get problemSetupDone => 'Questo server ha già un amministratore.';

  @override
  String get problemSetupExpired => 'Ci è voluto troppo tempo.';

  @override
  String get problemSetupToken => 'Questo token di configurazione è errato.';

  @override
  String get problemSignedOut => 'Sei disconnesso dal server.';

  @override
  String get problemStepUp =>
      'Questa modifica richiede prima la password o un codice.';

  @override
  String get problemStorage => 'Il server non raggiunge il suo archivio.';

  @override
  String get problemTooMany => 'Troppi tentativi in poco tempo.';

  @override
  String get problemUnexpected => 'Si è verificato un problema inatteso.';

  @override
  String get problemUnreachable => 'Il server non risponde.';

  @override
  String get problemUploadDamaged =>
      'Il file è cambiato o si è danneggiato durante il trasferimento.';

  @override
  String get problemUploadExpired =>
      'Il server non ha più questo caricamento: i caricamenti incompleti scadono dopo un giorno.';

  @override
  String get problemWebhookLimit =>
      'Il tuo account ha già tutti i webhook che può avere.';

  @override
  String get problemWebhooksOff =>
      'I webhook sono disattivati su questo server.';

  @override
  String get recoveryCode => 'Codice di recupero';

  @override
  String get recoveryCodeAbout =>
      'Apre l\'archivio di Photolib su questo dispositivo se il portachiavi perde la sua chiave';

  @override
  String get recoveryCodeEnter => 'Inserisci il codice di recupero';

  @override
  String get recoveryCreate => 'Crea codice di recupero';

  @override
  String get recoveryLater => 'Più tardi';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString modifiche esistono solo su questo dispositivo. Un codice di recupero le riporta indietro se il portachiavi perde la chiave di Photolib.',
      many:
          '$countString modifiche esistono solo su questo dispositivo. Un codice di recupero le riporta indietro se il portachiavi perde la chiave di Photolib.',
      one: '1 modifica esiste solo su questo dispositivo. Un codice di recupero la riporta indietro se il portachiavi perde la chiave di Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Scrivi queste 24 parole e conservale al sicuro: aprono l\'archivio di Photolib su questo dispositivo senza la sua chiave del portachiavi. Sostituiscono qualsiasi codice precedente.';

  @override
  String get recoveryUnlock => 'Sblocca';

  @override
  String get recoveryWrong =>
      'Questo non è il codice di recupero di questo archivio';

  @override
  String get renameFind => 'Trova';

  @override
  String get renamePattern => 'Nuovo nome';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Troppo lungo: un nome ha al massimo 255 byte',
      'invalid': 'Nome file non valido',
      'duplicate': 'Dato anche a un altro file',
      'exists': 'Un altro file di questa cartella ha questo nome',
      'other': 'Impossibile rinominare',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Sostituisci con';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'File rinominati: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Mostra nel Finder',
      'windows': 'Mostra in Esplora file',
      'other': 'Mostra nella cartella',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Fotocamera';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementi',
      many: '$countString di elementi',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Date';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Cerca nella libreria';

  @override
  String get searchFavourites => 'Preferiti';

  @override
  String get searchFolder => 'Cartella';

  @override
  String get searchHint => 'Nome di file o cartella';

  @override
  String get searchMotionPhotos => 'Foto in movimento';

  @override
  String get searchNothing => 'Nessun risultato';

  @override
  String get searchPanoramas => 'Panoramiche';

  @override
  String get searchPhotos => 'Foto';

  @override
  String get searchScreenshots => 'Screenshot';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Video';

  @override
  String get securityAddPasskey => 'Aggiungi passkey';

  @override
  String get securityCode => 'Codice';

  @override
  String get securityCodesHelp =>
      'Conserva questi codici in un posto sicuro. Ognuno funziona una volta al posto del tuo secondo fattore e vengono mostrati solo ora.';

  @override
  String securityCodesLeft(int count) {
    return 'Non usati: $count';
  }

  @override
  String get securityNewCodes => 'Nuovi codici';

  @override
  String get securityPasskeyNotAdded => 'Non è stata aggiunta nessuna passkey.';

  @override
  String get securityRecoveryCodes => 'Codici di recupero';

  @override
  String get securityRemovePasskey => 'Rimuovi passkey';

  @override
  String get securitySetUp => 'Configura';

  @override
  String get securityStepUpBody =>
      'Inserisci la password, un codice dell\'app di autenticazione o un codice di recupero per modificare i tuoi secondi fattori.';

  @override
  String get securityStepUpTitle => 'Conferma la tua identità';

  @override
  String get securityTitle => 'Secondi fattori';

  @override
  String get securityTotp => 'App di autenticazione';

  @override
  String get securityTotpHelp =>
      'Aggiungi questa chiave all\'app di autenticazione, poi inserisci il codice che mostra.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Attiva',
      'other': 'Disattivata',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Disattiva';

  @override
  String get securityWrongCode => 'Questo codice è errato.';

  @override
  String get securityWrongProof => 'Password o codice errati.';

  @override
  String get selectAll => 'Seleziona tutto';

  @override
  String get selectionClear => 'Annulla selezione';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString selezionati',
      many: '$countString di elementi selezionati',
      one: '1 selezionato',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Mostra selezionati';

  @override
  String get serverAccount => 'Email o nome utente';

  @override
  String get serverAdd => 'Aggiungi un server';

  @override
  String get serverAddressInvalid =>
      'Inserisci indirizzi come photos.example.org';

  @override
  String get serverAddresses => 'Indirizzi';

  @override
  String get serverAddressesHelp =>
      'Uno per riga: il server sulla tua rete, su internet o tramite una VPN. L\'app usa il più veloce che risponde. Oppure incolla il link per impostare la password che hai ricevuto.';

  @override
  String get serverCa => 'Certificato della CA privata (PEM)';

  @override
  String get serverCaChoose => 'Scegli un file di certificato';

  @override
  String serverCertificateBody(String host) {
    return '$host presenta un certificato che questo dispositivo non considera attendibile. Consideralo attendibile solo se questa impronta SHA-256 è quella del tuo server:';
  }

  @override
  String get serverCertificateTitle =>
      'Considerare attendibile questo certificato?';

  @override
  String get serverConfirm => 'Conferma';

  @override
  String get serverConnect => 'Connetti';

  @override
  String get serverCreateAdmin => 'Crea amministratore';

  @override
  String get serverEnded =>
      'Il server ha chiuso questa sessione. Accedi di nuovo.';

  @override
  String get serverHandleHelp =>
      'Lettere minuscole, cifre, punti, trattini e trattini bassi; non cambia mai.';

  @override
  String get serverHeaders => 'Intestazioni personalizzate';

  @override
  String get serverHeadersHelp =>
      'Una per riga, come Name: value; inviate solo via HTTPS';

  @override
  String get serverHeadersInvalid =>
      'Scrivi ogni intestazione come Name: value';

  @override
  String get serverIdentity => 'Certificato client (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Scegli un certificato client';

  @override
  String get serverIdentityInvalid =>
      'Non è un certificato PKCS#12, oppure la sua password è errata.';

  @override
  String get serverIdentityPassword => 'Password del certificato client';

  @override
  String get serverLoading =>
      'Lettura del server salvato su questo dispositivo';

  @override
  String get serverNearby => 'Server su questa rete';

  @override
  String get serverNeedsHttps =>
      'Questo server richiede un indirizzo HTTPS: fuori dalla tua rete locale, Photolib non accede tramite HTTP semplice.';

  @override
  String get serverNoSignIn =>
      'Questo server non offre alcun accesso supportato da questa versione di Photolib.';

  @override
  String get serverOffline => 'Il server non risponde. Resti connesso.';

  @override
  String get serverPasskeyFailed =>
      'Non è stata usata nessuna passkey. Riprova o usa un codice.';

  @override
  String get serverPasskeyRequired =>
      'Questo server richiede una passkey, che questa versione di Photolib non può ancora usare.';

  @override
  String get serverPassword => 'Password';

  @override
  String get serverPasswordAgain => 'Ripeti la password';

  @override
  String get serverPasswordSetupInvalid =>
      'Questo token per impostare la password è errato, già usato o scaduto. Chiedine uno nuovo.';

  @override
  String get serverPasswordSetupToken => 'Token per impostare la password';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Dal tuo amministratore, oppure stampato da photolibd admin password-setup sul server.';

  @override
  String get serverPasswordsDiffer => 'Le password non coincidono.';

  @override
  String get serverPrivateLibrariesBody =>
      'Una nuova password non le apre. Riaprile con il kit di recupero, una passkey o un dispositivo ancora connesso.';

  @override
  String get serverPrivateLibrariesGo => 'Imposta la password';

  @override
  String get serverPrivateLibrariesTitle =>
      'Le tue librerie private restano bloccate';

  @override
  String get serverProxy => 'Proxy HTTP, come host:port';

  @override
  String get serverProxyInvalid => 'Inserisci il proxy come host:port';

  @override
  String get serverRecoveryCode => 'Codice di recupero';

  @override
  String get serverRemove => 'Rimuovi questo server';

  @override
  String get serverRequired => 'Obbligatorio';

  @override
  String get serverSecondFactor =>
      'Il secondo fattore di questo account è una passkey, che questa versione di Photolib non può ancora usare.';

  @override
  String get serverSecondFactorCode =>
      'Questo account richiede anche un codice dell\'app di autenticazione o un codice di recupero.';

  @override
  String get serverSecondFactorTitle => 'Conferma che sei tu';

  @override
  String get serverSecondFactorWrong =>
      'Non ha funzionato. Dopo cinque tentativi, accedi di nuovo.';

  @override
  String get serverSetPassword => 'Imposta password';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Per $handle su $server';
  }

  @override
  String get serverSetPasswordOpen => 'Imposta una password';

  @override
  String get serverSetPasswordTitle => 'Imposta la tua password';

  @override
  String get serverSetUp => 'Configura un nuovo server';

  @override
  String get serverSetupLinkElsewhere =>
      'Per usare questo link, esci prima da questo server, oppure rimuovilo se il link è per un altro.';

  @override
  String get serverSetupTitle => 'Configura il server';

  @override
  String get serverSetupToken => 'Token di configurazione';

  @override
  String get serverSetupTokenHelp =>
      'photolibd lo scrive nel suo log finché il server non ha un amministratore; ogni avvio ne scrive uno nuovo.';

  @override
  String get serverSignIn => 'Accedi';

  @override
  String get serverSignOut => 'Esci';

  @override
  String serverSignedInAs(String account) {
    return 'Accesso effettuato come $account';
  }

  @override
  String get serverSignedOut => 'Disconnesso';

  @override
  String get serverSwitch => 'Cambia account';

  @override
  String get serverTotpCode => 'Codice dell\'app di autenticazione';

  @override
  String get serverTrust => 'Considera attendibile';

  @override
  String get serverUnreadable =>
      'Impossibile leggere il server salvato su questo dispositivo';

  @override
  String get serverUsePasskey => 'Usa una passkey';

  @override
  String get serverUseRecoveryCode => 'Usa invece un codice di recupero';

  @override
  String get settingsBackground => 'Dietro le immagini trasparenti';

  @override
  String get settingsDateFormat => 'Formato data';

  @override
  String get settingsDefaultTab => 'Cartelle e album si aprono su';

  @override
  String get settingsFolders => 'Cartelle';

  @override
  String get settingsIndexing => 'Indicizzazione su questo dispositivo';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLibrary => 'Libreria';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsStart => 'Schermata iniziale';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Tocca il bordo sinistro o destro per l\'elemento precedente o successivo',
      'oneFingerZoom': 'Tocca due volte e trascina per lo zoom con un dito',
      'swipes': 'Scorri in alto o in basso sul lato sinistro di un video per la luminosità, sul destro per il volume',
      'maxBrightness': 'Luminosità massima durante la visione',
      'autoRotate': 'Ruota secondo l\'orientamento di ogni foto o video',
      'mixAudio':
          'Riproduci i video sopra altro audio invece di metterlo in pausa',
      'autoplay': 'Riproduci i video quando si aprono',
      'loop': 'Ripeti i video',
      'autoNext': 'Passa all\'elemento successivo alla fine di un video',
      'resume': 'Riprendi i video da dove erano stati lasciati',
      'other': 'Riproduci le immagini animate nella griglia',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Per quanto tempo Photolib conserva gli elementi nel cestino';

  @override
  String get settingsViewerBar => 'Pulsanti nella barra del visualizzatore';

  @override
  String get settingsViewing => 'Visualizzazione';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString foto e video condivisi attendono che Photolib possa aggiungerli alla tua libreria foto. Gli elementi non salvati vengono eliminati dopo 7 giorni.',
      many:
          '$countString di foto e video condivisi attendono che Photolib possa aggiungerli alla tua libreria foto. Gli elementi non salvati vengono eliminati dopo 7 giorni.',
      one: '1 foto o video condiviso attende che Photolib possa aggiungerlo alla tua libreria foto. Gli elementi non salvati vengono eliminati dopo 7 giorni.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Troppo grande da condividere in una volta: seleziona meno elementi';

  @override
  String shareTooMany(int count) {
    return 'Troppi elementi da condividere in una volta: selezionane al massimo $count';
  }

  @override
  String get shortcutsTitle => 'Scorciatoie da tastiera';

  @override
  String get slideshow => 'Presentazione';

  @override
  String get slideshowLoop => 'Ripeti';

  @override
  String get slideshowOptions => 'Opzioni della presentazione';

  @override
  String get slideshowSeconds => 'Secondi per elemento';

  @override
  String get slideshowShuffle => 'Ordine casuale';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Decrescente',
      'other': 'Crescente',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Questo dispositivo';

  @override
  String sourceHide(String name) {
    return 'Nascondi $name';
  }

  @override
  String get sourceHideOthers => 'Nascondi tutto il resto qui';

  @override
  String get sourceLost => 'Nessun accesso';

  @override
  String get sourcePartly => 'Mostrato in parte';

  @override
  String sourceShow(String name) {
    return 'Mostra $name';
  }

  @override
  String get sourceShowEverything => 'Mostra tutto qui';

  @override
  String get sourceShowOnly => 'Mostra solo questo';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Cronologia',
      'folders': 'Cartelle e album',
      'favourites': 'Preferiti',
      'other': 'Cronologia',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Tieni una persona offline';

  @override
  String get storageBudget => 'Limite di spazio';

  @override
  String get storageClear => 'Rimuovi copie offline';

  @override
  String get storageClearAction => 'Rimuovi';

  @override
  String storageClearBody(String size) {
    return 'Vengono rimossi $size tenuti su questo dispositivo e si smette di tenere offline album, ricerche e foto. La tua libreria sul server non viene toccata.';
  }

  @override
  String get storageKeepLibrary => 'Tieni tutta la libreria';

  @override
  String get storageKeepOriginals => 'Tieni anche gli originali';

  @override
  String get storageNoPeople => 'Nessuna persona ha ancora un nome.';

  @override
  String get storageNoPins =>
      'Niente è fissato. Fissa un album, una ricerca o una foto per tenerli offline.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Ricerca',
      'person': 'Persona',
      'library': 'Tutta la libreria',
      'asset': 'Foto',
      'other': 'Fissato',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Non rientra nel limite: servono altri $size';
  }

  @override
  String get storagePinNothing =>
      'Niente da scaricare: le sue foto sono già su questo dispositivo';

  @override
  String get storagePinPaused =>
      'In attesa: questa impostazione non tiene nulla offline';

  @override
  String get storagePinPlanning => 'Cerco cosa tenere…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Download: $haveString di $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Disponibile offline ($size)';
  }

  @override
  String get storagePinWaiting => 'Verrà scaricato quando sarai online';

  @override
  String get storagePins => 'Tenuto offline';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Solo catalogo',
      'spaceSaver': 'Risparmio di spazio',
      'travel': 'Album scelti offline',
      'everything': 'Tutto',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Non tiene nulla; le foto si caricano dal tuo server quando le apri.',
      'spaceSaver': 'Tiene le anteprime di tutta la libreria, le più recenti prima, entro il limite.',
      'travel': 'Tiene solo ciò che fissi: album, ricerche e foto.',
      'everything': 'Tiene gli originali di tutta la libreria, i più recenti prima, entro il limite.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Cosa tiene questo dispositivo';

  @override
  String get storageSubtitle => 'Copie offline e limite di spazio';

  @override
  String get storageTitle => 'Spazio';

  @override
  String storageUsed(String used, String budget) {
    return '$used di $budget usati';
  }

  @override
  String get storageWebNote =>
      'Un browser tiene solo anteprime e le cancella all\'uscita.';

  @override
  String get storeNoKeyring =>
      'Photolib conserva la chiave del suo archivio locale nel portachiavi di sistema, che non ha risposto. Installa e sblocca gnome-keyring, KWallet o KeePassXC con il suo Secret Service attivo, poi riprova.';

  @override
  String get storeNoKeystore =>
      'Photolib non è riuscito a raggiungere il portachiavi di questo dispositivo, che contiene la chiave del suo archivio locale.';

  @override
  String get storeRebuilt =>
      'Il portachiavi di questo dispositivo non aveva più la chiave dell\'archivio locale di Photolib, quindi l\'archivio è stato ricostruito. Le sue impostazioni e ciò che esisteva solo su questo dispositivo sono andati persi; le librerie si sincronizzano di nuovo e le miniature tornano.';

  @override
  String get storeRecoveryNeeded =>
      'Il portachiavi di questo dispositivo non ha più la chiave dell\'archivio locale di Photolib. Inserisci il suo codice di recupero oppure reimposta l\'archivio e perdi ciò che esiste solo su questo dispositivo.';

  @override
  String get storeReset => 'Reimposta archivio';

  @override
  String get storeResetBody =>
      'Ciò che esiste solo su questo dispositivo va perso; le librerie si sincronizzano di nuovo e le miniature tornano.';

  @override
  String get storeUnavailable =>
      'L\'archivio di questo dispositivo non è disponibile: impostazioni e raccolte non vengono conservate';

  @override
  String get tabCollections => 'Raccolte';

  @override
  String get tabLibrary => 'Libreria';

  @override
  String get tabSearch => 'Cerca';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get timelineBenchmark => 'Benchmark della cronologia';

  @override
  String get timelineBenchmarkCopy => 'Copia i risultati';

  @override
  String get timelineCannotPlay => 'Impossibile riprodurlo in questo browser';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position di $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position di $count, nessuna anteprima';
  }

  @override
  String get timelineExcluded => 'In una cartella esclusa';

  @override
  String get timelineScrubber => 'Scorri per data';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Data sconosciuta';

  @override
  String timelineWeek(String date) {
    return 'Settimana del $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Aggiungi $action alla barra';
  }

  @override
  String toolbarDown(String action) {
    return 'Sposta $action in basso';
  }

  @override
  String get toolbarInBar => 'Nella barra';

  @override
  String get toolbarInMenu => 'Nel menu ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Rimuovi $action dalla barra';
  }

  @override
  String get toolbarReset => 'Ripristina predefiniti';

  @override
  String toolbarUp(String action) {
    return 'Sposta $action in alto';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Sposta qui',
      'other': 'Copia qui',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'C\'è già un file o una cartella con questo nome',
      'changed': 'La copia non corrispondeva all\'originale ed è stata rimossa',
      'cancelled': 'Annullato',
      'invalid': 'Nome di cartella non valido',
      'other': 'Non riuscito',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Recenti';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Eliminare definitivamente $countString elementi? Non si può annullare.',
      many:
          'Eliminare definitivamente $countString di elementi? Non si può annullare.',
      one:
          'Eliminare definitivamente $countString elemento? Non si può annullare.',
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
      other: 'Mancano $daysString giorni',
      many: 'Mancano $daysString di giorni',
      one: 'Manca $daysString giorno',
      zero: 'Viene eliminato oggi',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Il cestino è vuoto';

  @override
  String get trashEmptyAll => 'Svuota il cestino';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString giorni';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementi spostati nel cestino',
      many: '$countString di elementi spostati nel cestino',
      one: '$countString elemento spostato nel cestino',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Rimuovi dall\'elenco';

  @override
  String trashRetention(int days) {
    return 'Photolib elimina definitivamente ciò che tiene nel cestino dopo $days giorni; ogni elemento mostra il tempo che gli resta.';
  }

  @override
  String get trashTitle => 'Cestino';

  @override
  String get undo => 'Annulla';

  @override
  String get uploadAction => 'Carica foto e video';

  @override
  String get uploadClear => 'Cancella';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString di $totalString caricati';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Non riusciti: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementi archiviati',
      many: '$countString di elementi archiviati',
      one: '$countString elemento archiviato',
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
      other: '$countString elementi nascosti',
      many: '$countString di elementi nascosti',
      one: '$countString elemento nascosto',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Nero',
      'white': 'Bianco',
      'other': 'Scacchiera',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Questo video non può essere riprodotto su questo dispositivo';

  @override
  String get viewerCaptions => 'Sottotitoli';

  @override
  String get viewerCompass => 'Blocco bussola';

  @override
  String get viewerCopy => 'Copia';

  @override
  String get viewerCopyText => 'Copia testo';

  @override
  String get viewerCustomize => 'Personalizza la barra degli strumenti…';

  @override
  String get viewerDial =>
      'Direzione. Fai clic per guardare avanti. Trascina per guardarti intorno, scorri o pizzica per lo zoom, fai doppio clic per ripristinare';

  @override
  String get viewerFilmstrip => 'Pellicola';

  @override
  String get viewerFirst => 'Primo';

  @override
  String get viewerFisheye => 'Fisheye';

  @override
  String get viewerGyroscope => 'Muovi per guardarti intorno';

  @override
  String get viewerHdr => 'Mostra in HDR';

  @override
  String get viewerInfo => 'Info';

  @override
  String get viewerInfoLoading => 'Caricamento delle info di questo elemento';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString di $countString';
  }

  @override
  String get viewerLast => 'Ultimo';

  @override
  String get viewerLenses => 'Scegli un obiettivo';

  @override
  String get viewerMap => 'Mappa';

  @override
  String get viewerMotion => 'Riproduci movimento';

  @override
  String get viewerMotionDenied =>
      'Questo browser non ha consentito l\'accesso ai sensori di movimento';

  @override
  String get viewerMotionMissing =>
      'Questo dispositivo non ha un giroscopio per guardarti intorno';

  @override
  String get viewerMute => 'Disattiva audio';

  @override
  String get viewerNext => 'Successivo';

  @override
  String get viewerNextFrame => 'Fotogramma successivo';

  @override
  String get viewerPause => 'Pausa';

  @override
  String get viewerPlanet => 'Piccolo pianeta';

  @override
  String get viewerPlay => 'Riproduci';

  @override
  String get viewerPrevious => 'Precedente';

  @override
  String get viewerPreviousFrame => 'Fotogramma precedente';

  @override
  String get viewerRotate => 'Ruota';

  @override
  String get viewerSdr => 'Mostra in SDR';

  @override
  String get viewerSeek => 'Posizione';

  @override
  String get viewerSetAs => 'Imposta come';

  @override
  String get viewerShare => 'Condividi';

  @override
  String get viewerSpeed => 'Velocità di riproduzione';

  @override
  String get viewerSphere =>
      'Vista a 360°. Trascina per guardarti intorno, pizzica per lo zoom';

  @override
  String get viewerText => 'Testo in questa foto';

  @override
  String get viewerTextCopied => 'Testo copiato';

  @override
  String get viewerTextNone => 'Nessun testo trovato in questa foto';

  @override
  String get viewerTextUnread =>
      'Il testo di questa foto non è ancora stato letto';

  @override
  String get viewerUnmute => 'Attiva audio';

  @override
  String get viewerZoomIn => 'Ingrandisci';

  @override
  String get viewerZoomOut => 'Riduci';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'Scheda SD',
      'other': 'Interna',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Ingrandisci';

  @override
  String get zoomOut => 'Riduci';
}
