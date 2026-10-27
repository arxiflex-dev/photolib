// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionAddToAlbum => 'Add to album';

  @override
  String get actionArchive => 'Archive';

  @override
  String get actionCopyTo => 'Copy to…';

  @override
  String get actionDeleteForever => 'Delete forever';

  @override
  String get actionFavourite => 'Favourite';

  @override
  String get actionHide => 'Hide';

  @override
  String get actionMoveTo => 'Move to…';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionRestore => 'Restore';

  @override
  String get actionShare => 'Share';

  @override
  String get actionTrash => 'Move to trash';

  @override
  String get actionUnarchive => 'Unarchive';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionUnfavourite => 'Remove from favourites';

  @override
  String get actionUnhide => 'Unhide';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Active',
      'disabled': 'Disabled',
      'invited': 'Invited',
      'deleted': 'Deleted',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Accounts';

  @override
  String get adminAddAccount => 'Add account';

  @override
  String get adminAddExternalLibrary => 'Add an external library';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts attempts',
      one: '1 attempt',
      zero: 'not run yet',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Audit log';

  @override
  String get adminBackUpNow => 'Back up now';

  @override
  String get adminBackupQueued =>
      'The backup is queued; a restore drill follows it';

  @override
  String get adminBackups => 'Database backups';

  @override
  String get adminCancelJob => 'Cancel job';

  @override
  String get adminCapabilities => 'Capabilities';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Managed libraries',
      'uploads': 'Uploads from devices, the web and the CLI',
      'folder_browser': 'Folder browser',
      'device_folders': 'Device folders in connected apps',
      'sharing': 'Sharing and public links',
      'edits': 'Edits',
      'deletes': 'Deletes',
      'xmp_writes': 'XMP sidecar writes',
      'face_recognition': 'Face recognition',
      'ml_search': 'Smart search',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Warning',
      'fail': 'Failed',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Copied';

  @override
  String get adminCopyBundle => 'Copy diagnostics for a bug report';

  @override
  String get adminCopyLink => 'Copy link';

  @override
  String get adminDelete => 'Delete';

  @override
  String get adminDeviceBackups => 'Device backups';

  @override
  String get adminDevices => 'Your devices';

  @override
  String get adminDisable => 'Disable';

  @override
  String adminDrillFailed(String detail) {
    return 'The last restore drill failed: $detail';
  }

  @override
  String get adminEdit => 'Edit';

  @override
  String get adminEmail => 'Email';

  @override
  String get adminEnable => 'Enable';

  @override
  String get adminErrorSignIn => 'Sign in as an administrator';

  @override
  String get adminFacesDefault => 'Face recognition starts on for new accounts';

  @override
  String get adminFiles => 'Files by kind';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Damaged',
      'missing': 'Missing',
      'size': 'Wrong size',
      'hash': 'Replaced',
      'orphan': 'Stray file',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size free';
  }

  @override
  String get adminFreeDisk =>
      'Pause uploads below this free disk, in percent, 0 to 50';

  @override
  String get adminFreeDiskGb =>
      'or below this free disk in GB, if less, 0 to 100000';

  @override
  String get adminHandle => 'Sign-in name';

  @override
  String get adminIntegrity => 'Integrity';

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
      'queued': 'Queued',
      'running': 'Running',
      'done': 'Done',
      'dead': 'Failed',
      'cancelled': 'Cancelled',
      'other': 'All',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Job type, such as render';

  @override
  String get adminJobs => 'Jobs';

  @override
  String adminLastSeen(String time) {
    return 'Last seen $time';
  }

  @override
  String get adminLibraries => 'Libraries';

  @override
  String get adminLibraryOwner => 'Owner';

  @override
  String get adminLibraryRoot => 'Folder on the server, such as /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Online',
      'offline': 'Offline',
      'scanning': 'Scanning',
      'error': 'Error',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Server log';

  @override
  String get adminName => 'Name';

  @override
  String get adminNothing => 'Nothing here yet';

  @override
  String get adminOutOfRange => 'Out of range';

  @override
  String get adminOverview => 'Overview';

  @override
  String get adminPair => 'Pair a device';

  @override
  String get adminPairBody =>
      'Scan this code or send the link, then paste it into Add a server in Photolib on the new device: it brings every address of this server and its certificate, so nobody types them.';

  @override
  String get adminPasswordSetup => 'Password setup link';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Send this link to $name by any channel, or let them scan the code. It sets a password once, until $date.';
  }

  @override
  String get adminPause => 'Pause a job type';

  @override
  String adminPauseMinutes(int max) {
    return 'Minutes, 1 to $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type is paused until $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items left to back up',
      one: '1 item left to back up',
      zero: 'Nothing left to back up',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Policies';

  @override
  String get adminPolicyReset => 'Use the wider level\'s value';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'On by default',
      'server': 'Set for the server',
      'user': 'Set for this account',
      'library': 'Set for this library',
      'config': 'Set in config',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Apply a preset';

  @override
  String get adminPresetBody =>
      'A preset sets every capability for the server and clears what accounts and libraries set. Each stays editable.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Archive viewer',
      'family_backup': 'Family backup',
      'personal': 'Personal',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'The external read-only libraries are the only source of truth: no uploads, managed libraries, device folders, edits, deletes or XMP writes',
      'family_backup': 'Everything on but XMP writes',
      'personal': 'Everything on but sharing and public links',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'QR code of the link';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString jobs queued',
      one: '1 job queued',
      zero: 'Nothing to do',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'Storage quota in GB; empty for none';

  @override
  String get adminRemote => 'Remote access';

  @override
  String get adminRemoteBody =>
      'Reach the server from anywhere without opening a port on your router. Pick one way; each gives it an HTTPS address to add to the apps. Then test it from outside.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared connects out to Cloudflare, which serves your domain over HTTPS. The free plan caps a request at 100 MB, which backups never reach: they send 8 MiB at a time.';

  @override
  String get adminRemoteNoAddress =>
      'Add this server\'s https:// address to this app to test it from outside.';

  @override
  String get adminRemoteReachable => 'Reachable from outside.';

  @override
  String get adminRemoteTailscale =>
      'Install Tailscale on the server\'s machine and every device, in the same tailnet or your Headscale, then run this on the server\'s machine and set public_url to the address it prints.';

  @override
  String get adminRemoteTest => 'Test from outside';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host will open $url from its servers around the world, and so learn this address. Go on?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Not reachable from outside: check the way you chose, then test again.';

  @override
  String get adminRemoteWireguard =>
      'Needs one UDP port open on the server\'s side or on a hub. This is the configuration for a device; make keys with wg genkey.';

  @override
  String get adminRepair =>
      'Put it back from a backup or from a device that still has it';

  @override
  String get adminRepairOrphan =>
      'No photo names it: check it, then delete or keep it';

  @override
  String get adminReprocess => 'Reprocess';

  @override
  String get adminReprocessFaces => 'Detect faces again';

  @override
  String get adminReprocessFolder =>
      'Folder, such as 2024/05; empty for the whole library';

  @override
  String get adminReprocessMetadata => 'Read metadata again';

  @override
  String get adminReprocessRenditions => 'Regenerate thumbnails and previews';

  @override
  String get adminRestore => 'Restore';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'The restore of $name failed: $detail';
  }

  @override
  String get adminRestoreUnverified => 'No restore drill has passed yet';

  @override
  String adminRestoreVerified(String when) {
    return 'Last verified restore: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd stops, then replaces the whole database with $name when it starts again. What changed since that backup is lost, and every device syncs from scratch.';
  }

  @override
  String get adminRestoring => 'photolibd is stopping to restore the backup';

  @override
  String get adminResume => 'Resume';

  @override
  String get adminRetry => 'Retry';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrator',
      'user': 'User',
      'viewer': 'Viewer',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Saved';

  @override
  String get adminScan => 'Scan now';

  @override
  String get adminScrubDays =>
      'Days for the scrub to check every original, 1 to 3650';

  @override
  String get adminScrubNever => 'First full check under way';

  @override
  String adminScrubbed(String time) {
    return 'Last full check $time';
  }

  @override
  String get adminSecondAdmin =>
      'Make a second person an administrator, so that someone else can run and restore the server if you cannot.';

  @override
  String adminSilent(String time) {
    return 'Silent since $time';
  }

  @override
  String get adminSilentHours =>
      'Hours without a report until a device\'s backup is silent, 1 to 8760';

  @override
  String get adminStores => 'Storage';

  @override
  String get adminThisDevice => 'This device';

  @override
  String get adminTitle => 'Server administration';

  @override
  String get adminTrashDays => 'Days in the trash, 1 to 3650';

  @override
  String get adminTwoFactor => 'Every account must set up a second factor';

  @override
  String get adminUsage => 'Usage by account';

  @override
  String get albumCover => 'Use as cover';

  @override
  String get albumEmpty => 'This album is empty';

  @override
  String get albumHideMemories => 'Hide from memories';

  @override
  String get albumHideTimeline => 'Hide from timeline';

  @override
  String get albumNew => 'New album';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Any date';

  @override
  String get backupCap => 'Largest item';

  @override
  String get backupCharging => 'Only while charging';

  @override
  String backupCompleted(String time) {
    return 'Last complete backup $time';
  }

  @override
  String backupContact(String time) {
    return 'Last contact with the server $time';
  }

  @override
  String get backupEnabled => 'Back up this device';

  @override
  String get backupFolderNo => 'Not this one';

  @override
  String get backupFolderYes => 'Back it up';

  @override
  String backupHours(int count) {
    return '$count h';
  }

  @override
  String get backupMetered =>
      'On metered networks, such as mobile data or a hotspot';

  @override
  String get backupNever => 'No complete backup yet';

  @override
  String backupNewFolder(String name) {
    return 'New folder $name: back it up?';
  }

  @override
  String get backupNoLimit => 'No limit';

  @override
  String get backupNothing => 'Nothing waits';

  @override
  String get backupNow => 'Back up now';

  @override
  String backupOverdue(int hours, String items) {
    return 'No complete backup for $hours h. Waiting: $items';
  }

  @override
  String get backupOverdueTitle => 'Backup has not completed';

  @override
  String backupPending(String items) {
    return 'Waiting: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Trying again $time';
  }

  @override
  String get backupRoaming => 'Back up while roaming';

  @override
  String get backupSignIn => 'Sign in to a server to back up this device';

  @override
  String get backupSignedOut =>
      'Backup stopped: the server signed this device out. Sign in again in Settings.';

  @override
  String get backupSince => 'Taken since';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Backup waits until the server is in reach',
      'charging': 'Backup waits until the device charges',
      'battery_low': 'Backup waits: the battery is low',
      'roaming': 'Backup waits while roaming',
      'quota': 'Backup stopped: your storage on the server is full',
      'second_factor':
          'Backup stopped: the server asks this account for a second factor',
      'other': 'Backup stopped: the server answered $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupWaiting => 'Not backed up';

  @override
  String get backupWarnAfter => 'Warn when not complete for';

  @override
  String get backupWhat => 'What to back up';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'In a folder you did not choose',
      'folder_new': 'In a new folder: choose whether to back it up',
      'type_excluded': 'A kind of item you did not choose',
      'before_date': 'Taken before the date you chose',
      'selected': 'Waiting for its turn',
      'server_restored': 'The server lost it in a restore: sending it again',
      'working': 'Being backed up',
      'waiting_for_icloud': 'Waiting for iCloud to download it',
      'metered': 'Waiting for a network that is not metered',
      'metered_cap': 'Too large for a metered network',
      'unreadable': 'This device cannot read it',
      'changed': 'It changed while it was sent',
      'quota': 'Your storage on the server is full',
      'other': 'The server refused it: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'The server no longer works with this version of Photolib.';

  @override
  String get checkAppTooOldNext => 'Update Photolib.';

  @override
  String get checkChanged =>
      'The server\'s certificate is not the one you trusted.';

  @override
  String get checkChangedNext =>
      'If your administrator replaced it, trust the new one. If not, someone may be listening in: do not go on.';

  @override
  String get checkClock =>
      'This device\'s clock and the server\'s differ by more than five minutes.';

  @override
  String get checkClockNext =>
      'Let your device set its date and time automatically.';

  @override
  String get checkDnsFailed =>
      'The server\'s name does not lead to an address.';

  @override
  String get checkDnsFailedNext =>
      'Check the address, or connect to the network the server is on.';

  @override
  String checkExpired(String date) {
    return 'The server\'s certificate expired on $date.';
  }

  @override
  String get checkFailed => 'Failed';

  @override
  String get checkMetered =>
      'You are on a metered network, such as mobile data.';

  @override
  String get checkMeteredNext => 'Connect to Wi-Fi before large backups.';

  @override
  String get checkNotPhotolib =>
      'Something other than Photolib answers, such as a proxy\'s error page or a Wi-Fi sign-in page.';

  @override
  String get checkNotPhotolibNext =>
      'Sign in to the Wi-Fi in your browser, or ask your administrator to check the proxy.';

  @override
  String get checkOtherServer =>
      'A different Photolib server answers at this address.';

  @override
  String get checkPassed => 'Passed';

  @override
  String get checkRefused => 'Nothing answers at this address.';

  @override
  String get checkRefusedNext =>
      'Check that the server is running and that you are on its network or VPN.';

  @override
  String get checkRun => 'Check the connection';

  @override
  String get checkRunning => 'Checking';

  @override
  String get checkSelfSigned =>
      'The server uses a certificate of its own, which this device does not know yet.';

  @override
  String get checkSkipped => 'Not checked';

  @override
  String get checkStepAuth => 'Your sign-in';

  @override
  String get checkStepClock => 'Your device\'s clock';

  @override
  String get checkStepDns => 'Finding the server\'s address';

  @override
  String get checkStepNetwork => 'Your network';

  @override
  String get checkStepServer => 'Photolib on the server';

  @override
  String get checkStepTcp => 'Reaching the server';

  @override
  String get checkStepTls => 'Secure connection and certificate';

  @override
  String get checkStepUpload => 'Large uploads through proxies';

  @override
  String get checkTimedOut => 'The server takes too long to answer.';

  @override
  String get checkTimedOutNext => 'Check your connection, then try again.';

  @override
  String get checkTitle => 'Connection check';

  @override
  String get checkTlsFailed => 'The secure connection failed.';

  @override
  String get checkTrustNext =>
      'Trust it only if its fingerprint matches your server\'s.';

  @override
  String get checkUntrusted =>
      'The server\'s certificate comes from an authority this device does not trust.';

  @override
  String get checkUploadCap =>
      'A proxy on the way refuses large uploads, so backups go slower, in small pieces.';

  @override
  String get checkUploadCapNext =>
      'Ask your administrator to let requests of 64 MB through the proxy.';

  @override
  String get collectionAlbums => 'Albums';

  @override
  String collectionHide(String name) {
    return 'Hide $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Move $name down';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Move $name up';
  }

  @override
  String get collectionPeople => 'People';

  @override
  String collectionPin(String name) {
    return 'Pin $name';
  }

  @override
  String get collectionPlaces => 'Places';

  @override
  String collectionShow(String name) {
    return 'Show $name';
  }

  @override
  String get collectionTags => 'Tags';

  @override
  String collectionUnpin(String name) {
    return 'Unpin $name';
  }

  @override
  String get collectionsCustomise => 'Customise';

  @override
  String get collectionsDone => 'Done';

  @override
  String get commandPalette => 'Command palette';

  @override
  String get commandPaletteHint => 'Type a command';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString on this device and backed up',
      one: '1 on this device and backed up',
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
      other: '$countString only on this device, not backed up',
      one: '1 only on this device, not backed up',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'With iCloud Photos on, items deleted from this device also leave iCloud and your other Apple devices.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString only in your library',
      one: '1 only in your library',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Remove from this device';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'The $countString backed-up items; your library keeps them',
      one: 'The backed-up item; your library keeps it',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Copies on this device go to its trash: the space returns once it is emptied.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $countString items?',
      one: 'Delete 1 item?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'From this device and your library',
      'device': 'From this device only',
      'other': 'From your library',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Not present';

  @override
  String get deviceFolderCard => 'SD card';

  @override
  String get deviceFolderExclude => 'Exclude';

  @override
  String get deviceFolderExcludeThis => 'Exclude this folder';

  @override
  String get deviceFolderExcludedNotice =>
      'This item\'s folder is excluded from your library';

  @override
  String get deviceFolderForget => 'Remove from the list';

  @override
  String get deviceFolderInternal => 'Internal storage';

  @override
  String get deviceFolderKeep => 'Keep';

  @override
  String deviceFolderNew(String name, String items) {
    return '$name, $items, is new';
  }

  @override
  String get deviceFolders => 'Device folders';

  @override
  String get deviceFoldersAll => 'Show all folders except the excluded';

  @override
  String get deviceFoldersChosen => 'Show only the chosen folders';

  @override
  String get deviceFoldersExcludedNow => 'Excluded from the library';

  @override
  String get deviceFoldersSearch => 'Search folders';

  @override
  String get diagnosticsAdvanced => 'Show diagnostics';

  @override
  String get diagnosticsAllLoggers => 'All loggers';

  @override
  String get diagnosticsCopied => 'Log copied';

  @override
  String get diagnosticsCopy => 'Copy the log shown';

  @override
  String get diagnosticsEmpty => 'No log entries yet';

  @override
  String get diagnosticsExport => 'Export diagnostic bundle';

  @override
  String get diagnosticsExported => 'Diagnostic bundle saved';

  @override
  String get diagnosticsLevel => 'Level';

  @override
  String get diagnosticsLogger => 'Logger';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get download => 'Download';

  @override
  String get downloadCurrent => 'Current version, with its edits';

  @override
  String get downloadFailed => 'Couldn\'t download';

  @override
  String get downloadOriginal => 'Original';

  @override
  String downloadSaved(String name) {
    return 'Saved $name';
  }

  @override
  String get downloadVersion => 'Which version?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Downloading $countString items',
      one: 'Downloading 1 item',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Auto-enhance';

  @override
  String get editorCrop => 'Crop';

  @override
  String get editorCropOriginal => 'Original';

  @override
  String get editorCropSquare => 'Square';

  @override
  String get editorEdit => 'Edit';

  @override
  String get editorFlip => 'Flip';

  @override
  String get editorRotate => 'Rotate';

  @override
  String get editorSaveCopy => 'Save copy';

  @override
  String get editorSaveFailed => 'Couldn\'t save the copy';

  @override
  String get editorSaveVersion => 'Save';

  @override
  String get editorSaved => 'Saved as a copy';

  @override
  String get editorVersionFailed => 'Couldn\'t save the version';

  @override
  String get editorVersionSaved => 'Saved as a new version';

  @override
  String get editorVersionsUnsupported =>
      'This server cannot keep versions of edited photos yet';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString changes were undone: the server refused them.',
      one: '1 change was undone: the server refused it.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Dismiss';

  @override
  String get editsRejectedForbidden =>
      'You may view the items but not change them.';

  @override
  String get editsRejectedInvalid => 'The server could not accept the changes.';

  @override
  String get editsRejectedNotFound =>
      'The items were deleted or are no longer shared with you.';

  @override
  String get errorNotFound => 'This page does not exist';

  @override
  String get errorRetry => 'Try again';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String faceNumber(int number) {
    return 'Face $number';
  }

  @override
  String get facesAgree => 'I agree';

  @override
  String get facesAura => 'Describe faces with AuraFace (larger download)';

  @override
  String get facesNotNow => 'Not now';

  @override
  String get facesNoticeKeep =>
      'What is found stays with your photos, on your devices and your server. The descriptions are never shown or shared, and everything is deleted when you stop or delete the photo.';

  @override
  String get facesNoticeOptional =>
      'This is optional. Everything else in Photolib works without it, and you can stop at any time in Settings.';

  @override
  String get facesNoticeTitle => 'Find faces in your photos?';

  @override
  String get facesNoticeWhat =>
      'Photolib looks for faces in your photos and videos and keeps, for each one, where it is and a list of numbers that describes it, so that the same person can be found again. Such a description can count as biometric data.';

  @override
  String get facesNoticeWhere =>
      'This happens on this device and, if you are signed in, on your own server. Never on a service run by us or anyone else.';

  @override
  String get facesServerFailed => 'Your server could not be told. Try again.';

  @override
  String get facesServerOff => 'Your server finds no faces for you';

  @override
  String get facesServerOn => 'Your server finds faces for you';

  @override
  String get facesServerUnavailable =>
      'Your server does not offer face recognition';

  @override
  String facesStatusDownloading(int percent) {
    return 'Downloading the face models: $percent%';
  }

  @override
  String get facesStatusMissing =>
      'Your server has not installed the face models';

  @override
  String get facesStatusNoDecoder =>
      'Face finding is unavailable: the image library (libvips) was not found. Reinstall Photolib, or install libvips and restart it.';

  @override
  String get facesStatusRunning => 'Finding faces on this device';

  @override
  String get facesStatusUnavailable => 'Faces cannot be found on this device';

  @override
  String get facesStatusWaiting => 'The face models download on Wi-Fi';

  @override
  String get facesSwitch => 'Find faces in my photos';

  @override
  String get facesSwitchOff =>
      'Off. Nothing about faces is computed until you agree.';

  @override
  String get facesSwitchOn => 'On. Photolib finds the faces in your photos.';

  @override
  String get facesTitle => 'Faces and people';

  @override
  String get facesWithdraw => 'Delete and stop';

  @override
  String get facesWithdrawBody =>
      'This deletes every face, description and person Photolib found for you, on this device and on your server. Your photos are not changed.';

  @override
  String get facesWithdrawTitle => 'Stop finding faces?';

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

    return 'Files not changed: $countString';
  }

  @override
  String get folderAllow => 'Allow access to this folder';

  @override
  String get folderDelete => 'Delete folder';

  @override
  String folderDeleteBody(String name) {
    return 'Move the photos and videos in $name to the trash?';
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
  String get folderNew => 'New folder';

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
      'This folder is already in the library, or inside or around one that is';

  @override
  String get folderRemove => 'Remove folder';

  @override
  String folderRemoveBody(String folder) {
    return 'The photos and videos of $folder leave the library. The files stay on disk, untouched.';
  }

  @override
  String get folderRemoveConfirm => 'Remove';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scanning, $countString items so far',
      one: 'Scanning, 1 item so far',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Allow access';

  @override
  String get foldersHideExcluded => 'Hide excluded folders';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib can no longer read $countString folders.',
      one: 'Photolib can no longer read 1 folder.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Show excluded folders ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'This browser cannot keep a folder as your library. Open Photolib in Chrome or Edge on a computer, or use the desktop app.';

  @override
  String get galleryButtons => 'Buttons';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryGrid => 'Grid';

  @override
  String get galleryMenus => 'Menus and sheets';

  @override
  String get galleryShowSheet => 'Show a sheet';

  @override
  String get galleryTitle => 'Components';

  @override
  String hiddenCollections(int count) {
    return 'Hidden ($count)';
  }

  @override
  String get indexingAllowMetered => 'Download over mobile data';

  @override
  String get indexingAllowSaver => 'Also in power saving mode';

  @override
  String get indexingBattery => 'Battery needed without a charger';

  @override
  String get indexingChargingOnly => 'Only while charging';

  @override
  String indexingDownloading(int percent) {
    return 'Downloading the search model: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos could not be read',
      one: '1 photo could not be read',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'This device indexes only its new photos';

  @override
  String get indexingMissing =>
      'Your server has not installed the search model';

  @override
  String get indexingModels => 'Search on this device';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Downloads the search model ($megabytesString MB) from $host';
  }

  @override
  String get indexingNoDecoder =>
      'Search and text reading are unavailable: the image library (libvips) was not found. Reinstall Photolib, or install libvips and restart it.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Paused while the battery is below $percent%';
  }

  @override
  String get indexingPausedCharger => 'Paused until the device charges';

  @override
  String get indexingPausedHeat => 'Paused while the device is hot';

  @override
  String get indexingPausedSaver => 'Paused while battery saver is on';

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

    return 'Photos indexed: $doneString of $totalString';
  }

  @override
  String get indexingText => 'Read text in photos';

  @override
  String indexingTextDownloading(int percent) {
    return 'Downloading the text models: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Downloads the text models ($megabytesString MB) from $host; finds the words in your photos';
  }

  @override
  String get indexingTextMissing =>
      'Your server has not installed the text models';

  @override
  String get indexingTextPlatform =>
      'Uses your phone\'s own text recognition; nothing to download. Reads new photos';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Photos read for text: $doneString of $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Reading text is not available here';

  @override
  String get indexingTextWaiting => 'The text models download on Wi-Fi';

  @override
  String get indexingUnavailable =>
      'Search on this device is not available here';

  @override
  String get indexingWaiting => 'The search model downloads on Wi-Fi';

  @override
  String get infoAddName => 'Add name';

  @override
  String get infoAddTag => 'Add tag';

  @override
  String get infoAlbums => 'Albums';

  @override
  String get infoAllMetadata => 'View all metadata';

  @override
  String get infoAuto => 'Auto';

  @override
  String get infoBackedUp => 'Backed up';

  @override
  String get infoCamera => 'Camera';

  @override
  String get infoChangeAdjust => 'Adjusted colours';

  @override
  String get infoChangeCrop => 'Cropped';

  @override
  String get infoChangeFlip => 'Mirrored';

  @override
  String get infoChangeInpaint => 'Filled an area';

  @override
  String get infoChangeLocal => 'Adjusted an area';

  @override
  String get infoChangeLut => 'Applied a colour look';

  @override
  String get infoChangeOther => 'Edited';

  @override
  String get infoChangeTurn => 'Rotated';

  @override
  String get infoCompare => 'Compare with original';

  @override
  String infoConfidence(String percent) {
    return 'Confidence: $percent';
  }

  @override
  String get infoCopyPath => 'Copy path';

  @override
  String get infoCurrent => 'Current';

  @override
  String get infoDescription => 'Add a description';

  @override
  String get infoEditDate => 'Edit the date';

  @override
  String infoEditNumber(int number) {
    return 'Edit $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Edited copy of $name';
  }

  @override
  String get infoFaces => 'Faces';

  @override
  String get infoFile => 'File';

  @override
  String get infoFromFileName => 'from file name';

  @override
  String get infoHistory => 'Edit history';

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
  String get infoLocation => 'Location';

  @override
  String get infoMap => 'Map of where it was taken';

  @override
  String get infoMapAgree =>
      'Map tiles come from the internet and show which area you look at';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'New tag: $path';
  }

  @override
  String get infoNoAlbum => 'Not in any album';

  @override
  String get infoOnDevice => 'On this device';

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

    return '$widthString × $heightString pixels';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Remove from $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Remove $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Removed from $album';
  }

  @override
  String get infoRevert => 'Revert';

  @override
  String get infoSaveCopy => 'Save as copy';

  @override
  String get infoShared => 'shared';

  @override
  String get infoShowFaces => 'Show faces on the photo';

  @override
  String get infoShowMap => 'Show map';

  @override
  String get infoTags => 'Tags';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versions',
      one: '$count version',
    );
    return '$_temp0 · last $time';
  }

  @override
  String get infoWhy => 'Why this date?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Read in the file, as $tag',
      'name': 'Read in the file name',
      'folder': 'Read in the name of a folder',
      'host': 'Given by the service the file came from',
      'unknown':
          'Nothing in the file dates it, so the date it last changed stands in',
      'other':
          'The file is not read yet, so the date the device gives stands in',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'List',
      'other': 'Grid',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Name',
      'taken': 'Date taken',
      'modified': 'Date modified',
      'size': 'Size',
      'random': 'Random',
      'extension': 'Type',
      'custom': 'Album order',
      'other': 'Date taken',
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
  String get languageDevice => 'Device language';

  @override
  String get languageName => 'English';

  @override
  String get libraryAddFolder => 'Add folder';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Not backed up',
      'backed_up': 'Backed up',
      'cloud_only': 'Cloud only',
      'other': 'All',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Everything is backed up',
      'backed_up': 'Nothing is backed up yet',
      'cloud_only': 'Nothing is only on the server',
      'other': 'Nothing here',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Backup badges';

  @override
  String get libraryEmpty => 'Your photos will appear here';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Group by week',
      'month': 'Group by month',
      'other': 'Group by day',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'Hide hidden and archived items again';

  @override
  String get libraryNoKeyring =>
      'Photolib keeps the key to your library in the system keyring, which is not running or is locked. Start or unlock a keyring, such as GNOME Keyring or KWallet, then try again.';

  @override
  String get libraryRevealExcluded => 'Show excluded folders for 5 minutes';

  @override
  String get libraryShowVeiled =>
      'Show hidden and archived items for 5 minutes';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Recently added',
      'other': 'Date taken',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib could not open the library kept on this device';

  @override
  String get libraryViewOptions => 'View options';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Preparing thumbnails: $doneString of $totalString';
  }

  @override
  String get libraryZoomIn => 'Larger thumbnails';

  @override
  String get libraryZoomOut => 'Smaller thumbnails';

  @override
  String get mapAddTrack => 'Add a GPX track';

  @override
  String get mapArea => 'Map area';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get mapClearLasso => 'Clear the selection';

  @override
  String get mapEmpty => 'No photos with a place yet';

  @override
  String get mapHeat => 'Heatmap';

  @override
  String get mapLasso => 'Select by drawing around photos';

  @override
  String get mapLoading => 'Placing photos on the map';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Photos: $countString';
  }

  @override
  String get mapSearchHere => 'Search this area';

  @override
  String get mapSplit => 'Show photos under the map';

  @override
  String get mapTilesAgree =>
      'The map background comes from OpenStreetMap\'s server (tile.openstreetmap.org), which sees which area you look at';

  @override
  String get mapTilesShow => 'Show the background';

  @override
  String get mapTime => 'Time range';

  @override
  String get mapTitle => 'Map';

  @override
  String get mapTrackBad => 'That file has no GPX tracks';

  @override
  String get mapTrips => 'Trips';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favourite',
      'hidden': 'Hidden',
      'archived': 'Archived',
      'offline': 'Kept on this device',
      'offline': 'Kept on this device',
      'offline': 'Kept on this device',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Allow access';

  @override
  String get mediaAccessNone =>
      'Photolib needs access to your photos and videos to show them.';

  @override
  String get mediaAccessPartial =>
      'Photolib sees only the photos and videos you selected. A gallery needs access to all of them.';

  @override
  String get mediaAccessSelect => 'Select more photos';

  @override
  String get nameLabel => 'Name';

  @override
  String get nextAddRoot =>
      'Add the folder to external_roots in the server\'s configuration, then restart the server.';

  @override
  String get nextAskAdmin => 'Ask your server\'s administrator.';

  @override
  String get nextAskOwner => 'Ask the library\'s owner to let you add to it.';

  @override
  String get nextCheckConnection => 'Check the connection to see why.';

  @override
  String get nextCheckEntry => 'Check what you entered and try again.';

  @override
  String get nextConfirm => 'Check how many items it affects, then confirm.';

  @override
  String get nextDeleteWebhook =>
      'Delete a webhook you no longer use, then try again.';

  @override
  String get nextEditConfig =>
      'Change it in the server\'s configuration, then restart the server.';

  @override
  String get nextFreeSpace =>
      'Free some space, or ask your administrator for more.';

  @override
  String get nextNewLink => 'Ask your administrator for a new one.';

  @override
  String get nextNewestToken => 'Copy the newest one from photolibd\'s log.';

  @override
  String get nextOtherAdmin => 'Make another account an administrator first.';

  @override
  String get nextOtherFolder => 'Choose a folder of its own.';

  @override
  String get nextRefresh => 'Refresh and try again.';

  @override
  String get nextReport =>
      'Try again. If it happens again, copy the details below for your administrator.';

  @override
  String get nextSetUpPrivate =>
      'Finish setting up private libraries in Settings, then try again.';

  @override
  String get nextSignIn => 'Sign in again.';

  @override
  String get nextSignInAccount => 'Sign in with your account and try again.';

  @override
  String get nextSignInInstead => 'Sign in instead.';

  @override
  String get nextTryAgain => 'Try again.';

  @override
  String get nextUpdateAndAgree =>
      'Update the app, then agree to the notice again.';

  @override
  String get nextUseAnother => 'Choose another one.';

  @override
  String get nextUseHttps =>
      'Use the server\'s https:// address, or connect from the server\'s own network.';

  @override
  String get nextWait => 'Wait a minute, then try again.';

  @override
  String get offlineKeep => 'Keep offline';

  @override
  String offlineKeepHere(String size) {
    return 'Keep on this device ($size)';
  }

  @override
  String get offlineKeptHere => 'Kept on this device';

  @override
  String get offlineStopKeeping => 'Stop keeping offline';

  @override
  String get otherFiles => 'Other files';

  @override
  String get passphraseCreate =>
      'This computer runs no keyring (Secret Service) to keep Photolib\'s keys. Choose a passphrase of at least 10 characters to protect them: Photolib asks for it each time it starts.';

  @override
  String get passphraseLabel => 'Passphrase';

  @override
  String get passphraseMismatch => 'The passphrases differ.';

  @override
  String get passphraseRepeat => 'Repeat the passphrase';

  @override
  String get passphraseTooShort => 'Use at least 10 characters.';

  @override
  String get passphraseUnlock =>
      'Enter the passphrase that protects Photolib\'s keys on this computer.';

  @override
  String get passphraseWrong => 'Wrong passphrase. Try again.';

  @override
  String photoPosition(int index, int count) {
    return 'Photo $index of $count';
  }

  @override
  String get privacyCheckKit => 'Check recovery kit';

  @override
  String get privacyDrillDue =>
      'Time for a recovery drill: check that your recovery kit still unlocks your private libraries.';

  @override
  String get privacyHonest =>
      'Private libraries are encrypted on your devices, and nobody else can open them: not the server, not its administrator, not Photolib\'s developers. If you lose both your password and your recovery kit, your photos are lost for good, and nobody can get them back for you.';

  @override
  String get privacyKitBody =>
      'Write these 24 words on paper, in order, and keep them somewhere safe. They unlock your private libraries if you forget your password, for anyone who has them.';

  @override
  String get privacyKitDone => 'Your recovery kit works.';

  @override
  String get privacyKitOther => 'This is not your current recovery kit.';

  @override
  String get privacyKitTitle => 'Your recovery kit';

  @override
  String get privacyKitUnverified => 'Recovery kit not verified yet';

  @override
  String privacyKitVerified(String date) {
    return 'Recovery kit verified on $date';
  }

  @override
  String get privacyKitWritten => 'I wrote them down';

  @override
  String get privacyNotReady =>
      'Private uploads stay off until you have two ways to unlock and have verified your recovery kit.';

  @override
  String get privacyPasswordHelp =>
      'Enter your account password: it becomes one way to unlock your private libraries.';

  @override
  String get privacyPhrase => 'Recovery phrase';

  @override
  String get privacyPhraseHelp => 'The 24 words of your recovery kit';

  @override
  String get privacyPhraseInvalid =>
      'This is not a recovery phrase. Check every word.';

  @override
  String get privacyReady => 'Private uploads are on.';

  @override
  String get privacyRecoveryKit => 'Recovery kit';

  @override
  String get privacySetUp => 'Set up';

  @override
  String get privacyShowWords => 'Show the words again';

  @override
  String get privacyTitle => 'Private libraries';

  @override
  String privacyUnknownWord(int number) {
    return 'Word $number is not a recovery kit word.';
  }

  @override
  String get privacyVerify => 'Verify';

  @override
  String get privacyVerifyBody =>
      'Type these words from your recovery kit to show that you saved it.';

  @override
  String get privacyWays => 'Ways to unlock';

  @override
  String privacyWord(int number) {
    return 'Word $number';
  }

  @override
  String get privacyWordsDiffer =>
      'These words do not match your recovery kit. Check what you wrote down.';

  @override
  String get privacyWrongPassword => 'This is not your account\'s password.';

  @override
  String get problemAdminOnly => 'Only an administrator can do this.';

  @override
  String get problemBusy => 'The server is busy or restarting.';

  @override
  String get problemChanged => 'This changed in the meantime.';

  @override
  String get problemConfirm =>
      'This would hide or delete more items than the server does without a confirmation.';

  @override
  String get problemContribute => 'You may not add photos to this library.';

  @override
  String get problemCopy => 'Copy details';

  @override
  String get problemDetails => 'Details';

  @override
  String get problemDiskLow =>
      'The server\'s disk is almost full, so uploads are paused.';

  @override
  String get problemEmailTaken => 'Another account has this email.';

  @override
  String get problemExists => 'It exists already.';

  @override
  String get problemFaceNotice =>
      'Your server asks for a newer version of the faces notice than this app shows.';

  @override
  String get problemGone => 'It is no longer on the server.';

  @override
  String get problemHandleTaken => 'Another account has this sign-in name.';

  @override
  String get problemInterrupted => 'The upload was interrupted.';

  @override
  String get problemInvalid => 'A value is not valid.';

  @override
  String get problemLastAdmin => 'The server needs at least one administrator.';

  @override
  String get problemLinkInvalid => 'This link has expired or was used.';

  @override
  String get problemLoginFailed => 'Wrong email, sign-in name or password.';

  @override
  String get problemMaintenanceKey =>
      'Backups, scrubs and purges can be paused only when signed in, not with an API key.';

  @override
  String get problemNotAllowed => 'Your account may not do this.';

  @override
  String get problemNotExternal =>
      'Only libraries of the server\'s own folders can be scanned.';

  @override
  String get problemOidcClaim =>
      'Your sign-in provider did not say who you are in a way this server accepts.';

  @override
  String get problemOidcDown =>
      'Your sign-in provider does not answer the server.';

  @override
  String get problemOidcFailed => 'Your sign-in provider refused the sign-in.';

  @override
  String get problemOidcNotAllowed => 'Your account may not sign in this way.';

  @override
  String get problemOidcTaken =>
      'This sign-in is linked to another Photolib account already.';

  @override
  String get problemOidcUnknown =>
      'This server no longer offers this way to sign in.';

  @override
  String get problemPasskeysOff =>
      'Passkeys work only once the server has its public address.';

  @override
  String get problemPinned =>
      'This is set in the configuration file and cannot be changed here.';

  @override
  String get problemPolicyOff => 'This is switched off on this server.';

  @override
  String get problemQuota => 'Your storage on the server is full.';

  @override
  String get problemRestoreKey =>
      'A backup can be restored only when signed in, not with an API key.';

  @override
  String get problemRootDiffers =>
      'This folder does not hold this library\'s files.';

  @override
  String get problemRootNotAllowed =>
      'This folder is not under the external_roots of the server\'s configuration.';

  @override
  String get problemRootOverlaps =>
      'This folder holds or lies in another library or the server\'s own data.';

  @override
  String get problemScanning => 'This library is being scanned already.';

  @override
  String get problemSecondFactor =>
      'This account needs a second factor, such as an authenticator code or a passkey, which this version of Photolib cannot provide yet.';

  @override
  String get problemSetupDone => 'This server already has an administrator.';

  @override
  String get problemSetupExpired => 'This took too long.';

  @override
  String get problemSetupToken => 'This setup token is wrong.';

  @override
  String get problemSignedOut => 'You are signed out of the server.';

  @override
  String get problemStepUp =>
      'This change needs your password or a code first.';

  @override
  String get problemStorage => 'The server cannot reach its storage.';

  @override
  String get problemTooMany => 'Too many attempts in a short time.';

  @override
  String get problemUnexpected => 'Something unexpected went wrong.';

  @override
  String get problemUnreachable => 'The server does not answer.';

  @override
  String get problemUploadDamaged =>
      'The file changed or was damaged on the way.';

  @override
  String get problemUploadExpired =>
      'The server no longer has this upload: unfinished uploads expire after a day.';

  @override
  String get problemWebhookLimit =>
      'Your account has as many webhooks as it may.';

  @override
  String get problemWebhooksOff => 'Webhooks are turned off on this server.';

  @override
  String get recoveryCode => 'Recovery code';

  @override
  String get recoveryCodeAbout =>
      'Opens Photolib\'s store on this device if the keystore loses its key';

  @override
  String get recoveryCodeEnter => 'Enter recovery code';

  @override
  String get recoveryCreate => 'Create recovery code';

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
          '$countString changes exist only on this device. A recovery code gets them back if the keystore loses Photolib\'s key.',
      one: '1 change exists only on this device. A recovery code gets it back if the keystore loses Photolib\'s key.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Write these 24 words down and keep them safe: they open Photolib\'s store on this device without its keystore key. They replace any earlier code.';

  @override
  String get recoveryUnlock => 'Unlock';

  @override
  String get recoveryWrong => 'That is not this store\'s recovery code';

  @override
  String get renameFind => 'Find';

  @override
  String get renamePattern => 'New name';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Too long: a name has at most 255 bytes',
      'invalid': 'Not a valid file name',
      'duplicate': 'Given to another file too',
      'exists': 'Another file in this folder has this name',
      'other': 'Cannot be renamed',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Replace with';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Files renamed: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Show in Finder',
      'windows': 'Show in Explorer',
      'other': 'Show in folder',
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
  String get searchDates => 'Dates';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Search your library';

  @override
  String get searchFavourites => 'Favourites';

  @override
  String get searchFolder => 'Folder';

  @override
  String get searchHint => 'File name or folder';

  @override
  String get searchMotionPhotos => 'Motion photos';

  @override
  String get searchNothing => 'Nothing matches';

  @override
  String get searchPanoramas => 'Panoramas';

  @override
  String get searchPhotos => 'Photos';

  @override
  String get searchScreenshots => 'Screenshots';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Videos';

  @override
  String get securityAddPasskey => 'Add a passkey';

  @override
  String get securityCode => 'Code';

  @override
  String get securityCodesHelp =>
      'Keep these codes somewhere safe. Each works once in place of your second factor, and they are shown only now.';

  @override
  String securityCodesLeft(int count) {
    return 'Unused: $count';
  }

  @override
  String get securityNewCodes => 'New codes';

  @override
  String get securityPasskeyNotAdded => 'No passkey was added.';

  @override
  String get securityRecoveryCodes => 'Recovery codes';

  @override
  String get securityRemovePasskey => 'Remove passkey';

  @override
  String get securitySetUp => 'Set up';

  @override
  String get securityStepUpBody =>
      'Enter your password, or a code from your authenticator app or a recovery code, to change your second factors.';

  @override
  String get securityStepUpTitle => 'Confirm it\'s you';

  @override
  String get securityTitle => 'Second factors';

  @override
  String get securityTotp => 'Authenticator app';

  @override
  String get securityTotpHelp =>
      'Add this key to your authenticator app, then enter the code it shows.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': 'On', 'other': 'Off'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Turn off';

  @override
  String get securityWrongCode => 'That code is wrong.';

  @override
  String get securityWrongProof => 'Wrong password or code.';

  @override
  String get selectAll => 'Select all';

  @override
  String get selectionClear => 'Clear selection';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Show selected';

  @override
  String get serverAccount => 'Email or sign-in name';

  @override
  String get serverAdd => 'Add a server';

  @override
  String get serverAddressInvalid =>
      'Enter addresses such as photos.example.org';

  @override
  String get serverAddresses => 'Addresses';

  @override
  String get serverAddressesHelp =>
      'One per line: the server on your network, on the internet or through a VPN. The app uses the fastest that answers. Or paste the password setup link you were sent.';

  @override
  String get serverCa => 'Private CA certificate (PEM)';

  @override
  String get serverCaChoose => 'Choose a certificate file';

  @override
  String serverCertificateBody(String host) {
    return '$host presents a certificate this device does not trust. Trust it only if this SHA-256 fingerprint is your server\'s:';
  }

  @override
  String get serverCertificateTitle => 'Trust this certificate?';

  @override
  String get serverConfirm => 'Confirm';

  @override
  String get serverConnect => 'Connect';

  @override
  String get serverCreateAdmin => 'Create administrator';

  @override
  String get serverEnded => 'The server ended this session. Sign in again.';

  @override
  String get serverHandleHelp =>
      'Lowercase letters, digits, dots, dashes and underscores; it never changes.';

  @override
  String get serverHeaders => 'Custom headers';

  @override
  String get serverHeadersHelp =>
      'One per line, as Name: value, sent over HTTPS only';

  @override
  String get serverHeadersInvalid => 'Write each header as Name: value';

  @override
  String get serverIdentity => 'Client certificate (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Choose a client certificate';

  @override
  String get serverIdentityInvalid =>
      'This is not a certificate (PKCS#12), or its password is wrong.';

  @override
  String get serverIdentityPassword => 'Client certificate password';

  @override
  String get serverLoading => 'Reading the server kept on this device';

  @override
  String get serverNearby => 'Servers on this network';

  @override
  String get serverNeedsHttps =>
      'This server needs an HTTPS address: beyond your local network, Photolib does not sign in over plain HTTP.';

  @override
  String get serverNoSignIn =>
      'This server offers no sign-in this version of Photolib supports.';

  @override
  String get serverOffline => 'The server does not answer. You stay signed in.';

  @override
  String get serverPasskeyFailed =>
      'No passkey was used. Try again, or use a code.';

  @override
  String get serverPasskeyRequired =>
      'This server requires a passkey, which this version of Photolib cannot use yet.';

  @override
  String get serverPassword => 'Password';

  @override
  String get serverPasswordAgain => 'Password again';

  @override
  String get serverPasswordSetupInvalid =>
      'This password setup token is wrong, used or expired. Ask for a new one.';

  @override
  String get serverPasswordSetupToken => 'Password setup token';

  @override
  String get serverPasswordSetupTokenHelp =>
      'From your administrator, or printed by photolibd admin password-setup on the server.';

  @override
  String get serverPasswordsDiffer => 'The passwords differ.';

  @override
  String get serverPrivateLibrariesBody =>
      'A new password does not open them. Reopen them with your recovery kit, a passkey or a device that is still signed in.';

  @override
  String get serverPrivateLibrariesGo => 'Set the password';

  @override
  String get serverPrivateLibrariesTitle =>
      'Your private libraries stay locked';

  @override
  String get serverProxy => 'HTTP proxy, as host:port';

  @override
  String get serverProxyInvalid => 'Enter the proxy as host:port';

  @override
  String get serverRecoveryCode => 'Recovery code';

  @override
  String get serverRemove => 'Remove this server';

  @override
  String get serverRequired => 'Required';

  @override
  String get serverSecondFactor =>
      'This account\'s second factor is a passkey, which this version of Photolib cannot use yet.';

  @override
  String get serverSecondFactorCode =>
      'This account also needs a code from your authenticator app, or a recovery code.';

  @override
  String get serverSecondFactorTitle => 'Confirm it\'s you';

  @override
  String get serverSecondFactorWrong =>
      'That did not work. After five tries, sign in again.';

  @override
  String get serverSetPassword => 'Set password';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'For $handle on $server';
  }

  @override
  String get serverSetPasswordOpen => 'Set a password';

  @override
  String get serverSetPasswordTitle => 'Set your password';

  @override
  String get serverSetUp => 'Set up a new server';

  @override
  String get serverSetupLinkElsewhere =>
      'To use this setup link, sign out of this server first, or remove it if the link is for another one.';

  @override
  String get serverSetupTitle => 'Set up the server';

  @override
  String get serverSetupToken => 'Setup token';

  @override
  String get serverSetupTokenHelp =>
      'photolibd prints it in its log while the server has no administrator; each start prints a new one.';

  @override
  String get serverSignIn => 'Sign in';

  @override
  String get serverSignOut => 'Sign out';

  @override
  String serverSignedInAs(String account) {
    return 'Signed in as $account';
  }

  @override
  String get serverSignedOut => 'Signed out';

  @override
  String get serverSwitch => 'Switch account';

  @override
  String get serverTotpCode => 'Code from your authenticator app';

  @override
  String get serverTrust => 'Trust';

  @override
  String get serverUnreadable =>
      'The server kept on this device cannot be read';

  @override
  String get serverUsePasskey => 'Use a passkey';

  @override
  String get serverUseRecoveryCode => 'Use a recovery code instead';

  @override
  String get settingsBackground => 'Behind transparent images';

  @override
  String get settingsDefaultTab => 'Folders and albums open on';

  @override
  String get settingsFolders => 'Folders';

  @override
  String get settingsIndexing => 'Indexing on this device';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLibrary => 'Library';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsStart => 'Start screen';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsTitle => 'Settings';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Tap the left or right edge for the previous or next item',
      'oneFingerZoom': 'Double-tap and drag to zoom with one finger',
      'swipes': 'Swipe up or down on a video\'s left side for brightness, right side for volume',
      'maxBrightness': 'Full brightness while viewing',
      'autoRotate': 'Turn to each photo\'s or video\'s orientation',
      'mixAudio': 'Play videos over other audio instead of pausing it',
      'autoplay': 'Play videos as they open',
      'loop': 'Loop videos',
      'autoNext': 'Go to the next item when a video ends',
      'resume': 'Resume videos where they were left',
      'other': 'Play animated images in the grid',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'Buttons in the viewer\'s bar';

  @override
  String get settingsViewing => 'Viewing';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString shared photos and videos wait until Photolib may add to your Photos library. Unsaved items are deleted after 7 days.',
      one: '1 shared photo or video waits until Photolib may add to your Photos library. Unsaved items are deleted after 7 days.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge => 'Too large to share at once: select fewer items';

  @override
  String shareTooMany(int count) {
    return 'Too many to share at once: select $count or fewer';
  }

  @override
  String get shortcutsTitle => 'Keyboard shortcuts';

  @override
  String get slideshow => 'Slideshow';

  @override
  String get slideshowLoop => 'Repeat';

  @override
  String get slideshowOptions => 'Slideshow options';

  @override
  String get slideshowSeconds => 'Seconds per item';

  @override
  String get slideshowShuffle => 'Shuffle';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Descending',
      'other': 'Ascending',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'This device';

  @override
  String sourceHide(String name) {
    return 'Hide $name';
  }

  @override
  String get sourceHideOthers => 'Hide everything else here';

  @override
  String get sourceLost => 'No access';

  @override
  String get sourcePartly => 'Partly shown';

  @override
  String sourceShow(String name) {
    return 'Show $name';
  }

  @override
  String get sourceShowEverything => 'Show everything here';

  @override
  String get sourceShowOnly => 'Show only this';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Timeline',
      'folders': 'Folders and albums',
      'favourites': 'Favourites',
      'other': 'Timeline',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Keep a person offline';

  @override
  String get storageBudget => 'Storage budget';

  @override
  String get storageClear => 'Remove offline copies';

  @override
  String get storageClearAction => 'Remove';

  @override
  String storageClearBody(String size) {
    return 'This removes $size kept on this device and stops keeping albums, searches and photos offline. Your library on the server is not touched.';
  }

  @override
  String get storageKeepLibrary => 'Keep the whole library';

  @override
  String get storageKeepOriginals => 'Keep originals too';

  @override
  String get storageNoPeople => 'No people are named yet.';

  @override
  String get storageNoPins =>
      'Nothing is pinned. Pin an album, a search or a photo to keep it offline.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Search',
      'person': 'Person',
      'library': 'Whole library',
      'asset': 'Photo',
      'other': 'Pinned',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Does not fit the budget: $size more needed';
  }

  @override
  String get storagePinNothing =>
      'Nothing to download: its photos are on this device already';

  @override
  String get storagePinPaused => 'Waiting: this preset keeps nothing offline';

  @override
  String get storagePinPlanning => 'Looking up what to keep…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Downloading: $haveString of $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Available offline ($size)';
  }

  @override
  String get storagePinWaiting => 'Will download when online';

  @override
  String get storagePins => 'Kept offline';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Catalogue only',
      'spaceSaver': 'Space saver',
      'travel': 'Selected albums offline',
      'everything': 'Everything',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Keeps nothing; photos load from your server when you open them.',
      'spaceSaver': 'Keeps previews of your whole library, newest first, within the budget.',
      'travel': 'Keeps only what you pin: albums, searches and photos.',
      'everything': 'Keeps the originals of your whole library, newest first, within the budget.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'What this device keeps';

  @override
  String get storageSubtitle => 'Offline copies and storage budget';

  @override
  String get storageTitle => 'Storage';

  @override
  String storageUsed(String used, String budget) {
    return '$used of $budget used';
  }

  @override
  String get storageWebNote =>
      'A browser keeps previews only, and erases them when you sign out.';

  @override
  String get storeNoKeyring =>
      'Photolib keeps the key of its local store in the system keyring, which did not answer. Install and unlock gnome-keyring, KWallet or KeePassXC with its Secret Service on, then try again.';

  @override
  String get storeNoKeystore =>
      'Photolib could not reach this device\'s keystore, which holds the key of its local store.';

  @override
  String get storeRebuilt =>
      'This device\'s keystore no longer had the key of Photolib\'s local store, so the store was rebuilt. Its settings and what existed only on this device are lost; libraries sync again and thumbnails come back.';

  @override
  String get storeRecoveryNeeded =>
      'This device\'s keystore no longer has the key of Photolib\'s local store. Enter its recovery code, or reset the store and lose what exists only on this device.';

  @override
  String get storeReset => 'Reset store';

  @override
  String get storeResetBody =>
      'What exists only on this device is lost; libraries sync again and thumbnails come back.';

  @override
  String get storeUnavailable =>
      'The store on this device is unavailable: settings and collections are not kept';

  @override
  String get tabCollections => 'Collections';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabSearch => 'Search';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get timelineBenchmark => 'Timeline benchmark';

  @override
  String get timelineBenchmarkCopy => 'Copy the results';

  @override
  String get timelineCannotPlay => 'Can\'t play in this browser';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position of $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position of $count, no preview';
  }

  @override
  String get timelineExcluded => 'In an excluded folder';

  @override
  String get timelineNoHeicLinux =>
      'Photolib can\'t show HEIC photos on this computer. Connect a Photolib server to see its copy, or open them on a Mac.';

  @override
  String get timelineNoHeicWindows =>
      'Photolib can\'t show HEIC photos on this PC. Connect a Photolib server to see its copy, or open them on a Mac.';

  @override
  String get timelineScrubber => 'Scroll by date';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Date unknown';

  @override
  String timelineWeek(String date) {
    return 'Week of $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Add $action to the bar';
  }

  @override
  String toolbarDown(String action) {
    return 'Move $action down';
  }

  @override
  String get toolbarInBar => 'In the bar';

  @override
  String get toolbarInMenu => 'In the ⋮ menu';

  @override
  String toolbarRemove(String action) {
    return 'Remove $action from the bar';
  }

  @override
  String get toolbarReset => 'Reset to default';

  @override
  String toolbarUp(String action) {
    return 'Move $action up';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Move here',
      'other': 'Copy here',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'A file or folder of this name is already there',
      'changed': 'The copy did not match the original and was removed',
      'cancelled': 'Cancelled',
      'invalid': 'Not a valid folder name',
      'other': 'Failed',
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
      other: 'Delete $countString items forever? This cannot be undone.',
      one: 'Delete 1 item forever? This cannot be undone.',
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
      other: '$daysString days left',
      one: '1 day left',
      zero: 'Deleted forever today',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'The trash is empty';

  @override
  String get trashEmptyAll => 'Empty trash';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items moved to the trash',
      one: '1 item moved to the trash',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib deletes what it keeps in the trash for good after $days days; each item shows the time it has left.';
  }

  @override
  String get trashTitle => 'Trash';

  @override
  String get undo => 'Undo';

  @override
  String get uploadAction => 'Upload photos and videos';

  @override
  String get uploadClear => 'Clear';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Uploaded $doneString of $totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Failed: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items archived',
      one: '1 item archived',
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
      other: '$countString items hidden',
      one: '1 item hidden',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Black',
      'white': 'White',
      'other': 'Checkerboard',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => 'This video cannot play on this device';

  @override
  String get viewerCaptions => 'Captions';

  @override
  String get viewerCompass => 'Compass lock';

  @override
  String get viewerCopy => 'Copy';

  @override
  String get viewerCopyText => 'Copy text';

  @override
  String get viewerCustomize => 'Customize toolbar…';

  @override
  String get viewerDial =>
      'Heading. Click to face front. Drag to look around, scroll or pinch to zoom, double-click to reset';

  @override
  String get viewerFilmstrip => 'Filmstrip';

  @override
  String get viewerFirst => 'First';

  @override
  String get viewerFisheye => 'Fisheye';

  @override
  String get viewerGyroscope => 'Move to look around';

  @override
  String get viewerHdr => 'Show in HDR';

  @override
  String get viewerInfo => 'Info';

  @override
  String get viewerInfoLoading => 'Loading this item\'s info';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString of $countString';
  }

  @override
  String get viewerLast => 'Last';

  @override
  String get viewerLenses => 'Choose a lens';

  @override
  String get viewerMap => 'Map';

  @override
  String get viewerMotion => 'Play motion';

  @override
  String get viewerMotionDenied =>
      'This browser did not allow access to the motion sensors';

  @override
  String get viewerMotionMissing =>
      'This device has no gyroscope to look around with';

  @override
  String get viewerMute => 'Mute';

  @override
  String get viewerNext => 'Next';

  @override
  String get viewerNextFrame => 'Next frame';

  @override
  String get viewerPause => 'Pause';

  @override
  String get viewerPlanet => 'Little planet';

  @override
  String get viewerPlay => 'Play';

  @override
  String get viewerPrevious => 'Previous';

  @override
  String get viewerPreviousFrame => 'Previous frame';

  @override
  String get viewerRotate => 'Rotate';

  @override
  String get viewerSdr => 'Show in SDR';

  @override
  String get viewerSeek => 'Position';

  @override
  String get viewerSetAs => 'Set as';

  @override
  String get viewerShare => 'Share';

  @override
  String get viewerSpeed => 'Playback speed';

  @override
  String get viewerSphere => '360° view. Drag to look around, pinch to zoom';

  @override
  String get viewerText => 'Text in this photo';

  @override
  String get viewerTextCopied => 'Text copied';

  @override
  String get viewerTextNone => 'No text found in this photo';

  @override
  String get viewerTextUnread => 'This photo\'s text has not been read yet';

  @override
  String get viewerUnmute => 'Unmute';

  @override
  String get viewerZoomIn => 'Zoom in';

  @override
  String get viewerZoomOut => 'Zoom out';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD card',
      'other': 'Internal',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';
}

/// The translations for English (`en_XA`).
class AppLocalizationsEnXa extends AppLocalizationsEn {
  AppLocalizationsEnXa() : super('en_XA');

  @override
  String get actionAddToAlbum => '[Åðð ţö åļƀûɱ one two]';

  @override
  String get actionArchive => '[Åŕçĥîṽé one]';

  @override
  String get actionCopyTo => '[Çöþý ţö… one]';

  @override
  String get actionDeleteForever => '[Ðéļéţé ƒöŕéṽéŕ one two]';

  @override
  String get actionFavourite => '[Ƒåṽöûŕîţé one]';

  @override
  String get actionHide => '[Ĥîðé one]';

  @override
  String get actionMoveTo => '[Ṁöṽé ţö… one]';

  @override
  String get actionRename => '[Ŕéñåɱé one]';

  @override
  String get actionRestore => '[Ŕéšţöŕé one]';

  @override
  String get actionShare => '[Šĥåŕé one]';

  @override
  String get actionTrash => '[Ṁöṽé ţö ţŕåšĥ one two]';

  @override
  String get actionUnarchive => '[Ûñåŕçĥîṽé one]';

  @override
  String get actionUndo => '[Ûñðö one]';

  @override
  String get actionUnfavourite => '[Ŕéɱöṽé ƒŕöɱ ƒåṽöûŕîţéš one two three]';

  @override
  String get actionUnhide => '[Ûñĥîðé one]';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Åçţîṽé',
      'disabled': 'Ðîšåƀļéð',
      'invited': 'Îñṽîţéð',
      'deleted': 'Ðéļéţéð',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one]';
  }

  @override
  String get adminAccounts => '[Åççöûñţš one]';

  @override
  String get adminAddAccount => '[Åðð åççöûñţ one two]';

  @override
  String get adminAddExternalLibrary =>
      '[Åðð åñ éẋţéŕñåļ ļîƀŕåŕý one two three]';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts åţţéɱþţš',
      one: '1 åţţéɱþţ',
      zero: 'ñöţ ŕûñ ýéţ',
    );
    return '[$status, $_temp0 one two three]';
  }

  @override
  String get adminAudit => '[Åûðîţ ļöĝ one]';

  @override
  String get adminBackUpNow => '[Ɓåçķ ûþ ñöŵ one two]';

  @override
  String get adminBackupQueued =>
      '[Ţĥé ƀåçķûþ îš ǫûéûéð; å ŕéšţöŕé ðŕîļļ ƒöļļöŵš îţ one two three four five]';

  @override
  String get adminBackups => '[Ðåţåƀåšé ƀåçķûþš one two]';

  @override
  String get adminCancelJob => '[Çåñçéļ ĵöƀ one]';

  @override
  String get adminCapabilities => '[Çåþåƀîļîţîéš one two]';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Ṁåñåĝéð ļîƀŕåŕîéš',
      'uploads': 'Ûþļöåðš ƒŕöɱ ðéṽîçéš, ţĥé ŵéƀ åñð ţĥé ÇĻÎ',
      'folder_browser': 'Ƒöļðéŕ ƀŕöŵšéŕ',
      'device_folders': 'Ðéṽîçé ƒöļðéŕš îñ çöññéçţéð åþþš',
      'sharing': 'Šĥåŕîñĝ åñð þûƀļîç ļîñķš',
      'edits': 'Éðîţš',
      'deletes': 'Ðéļéţéš',
      'xmp_writes': 'ẊṀÞ šîðéçåŕ ŵŕîţéš',
      'face_recognition': 'Ƒåçé ŕéçöĝñîţîöñ',
      'ml_search': 'Šɱåŕţ šéåŕçĥ',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one two three four]';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'ÖĶ',
      'warn': 'Ŵåŕñîñĝ',
      'fail': 'Ƒåîļéð',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one]';
  }

  @override
  String get adminCopied => '[Çöþîéð one]';

  @override
  String get adminCopyBundle =>
      '[Çöþý ðîåĝñöšţîçš ƒöŕ å ƀûĝ ŕéþöŕţ one two three]';

  @override
  String get adminCopyLink => '[Çöþý ļîñķ one]';

  @override
  String get adminDelete => '[Ðéļéţé one]';

  @override
  String get adminDeviceBackups => '[Ðéṽîçé ƀåçķûþš one two]';

  @override
  String get adminDevices => '[Ýöûŕ ðéṽîçéš one two]';

  @override
  String get adminDisable => '[Ðîšåƀļé one]';

  @override
  String adminDrillFailed(String detail) {
    return '[Ţĥé ļåšţ ŕéšţöŕé ðŕîļļ ƒåîļéð: $detail one two three four]';
  }

  @override
  String get adminEdit => '[Éðîţ one]';

  @override
  String get adminEmail => '[Éɱåîļ one]';

  @override
  String get adminEnable => '[Éñåƀļé one]';

  @override
  String get adminErrorSignIn => '[Šîĝñ îñ åš åñ åðɱîñîšţŕåţöŕ one two three]';

  @override
  String get adminFacesDefault =>
      '[Ƒåçé ŕéçöĝñîţîöñ šţåŕţš öñ ƒöŕ ñéŵ åççöûñţš one two three four]';

  @override
  String get adminFiles => '[Ƒîļéš ƀý ķîñð one two]';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Ðåɱåĝéð',
      'missing': 'Ṁîššîñĝ',
      'size': 'Ŵŕöñĝ šîžé',
      'hash': 'Ŕéþļåçéð',
      'orphan': 'Šţŕåý ƒîļé',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one]';
  }

  @override
  String adminFree(String size) {
    return '[$size ƒŕéé one]';
  }

  @override
  String get adminFreeDisk =>
      '[Þåûšé ûþļöåðš ƀéļöŵ ţĥîš ƒŕéé ðîšķ, îñ þéŕçéñţ, 0 ţö 50 one two three four five]';

  @override
  String get adminFreeDiskGb =>
      '[öŕ ƀéļöŵ ţĥîš ƒŕéé ðîšķ îñ ĜƁ, îƒ ļéšš, 0 ţö 100000 one two three four five]';

  @override
  String get adminHandle => '[Šîĝñ-îñ ñåɱé one two]';

  @override
  String get adminIntegrity => '[Îñţéĝŕîţý one]';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString îţéɱš',
      one: '1 îţéɱ',
    );
    return '[$_temp0 one two]';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'Ǫûéûéð',
      'running': 'Ŕûññîñĝ',
      'done': 'Ðöñé',
      'dead': 'Ƒåîļéð',
      'cancelled': 'Çåñçéļļéð',
      'other': 'Åļļ',
    });
    return '[$_temp0 one]';
  }

  @override
  String get adminJobType => '[Ĵöƀ ţýþé, šûçĥ åš ŕéñðéŕ one two three]';

  @override
  String get adminJobs => '[Ĵöƀš one]';

  @override
  String adminLastSeen(String time) {
    return '[Ļåšţ šééñ $time one two]';
  }

  @override
  String get adminLibraries => '[Ļîƀŕåŕîéš one]';

  @override
  String get adminLibraryOwner => '[Öŵñéŕ one]';

  @override
  String get adminLibraryRoot =>
      '[Ƒöļðéŕ öñ ţĥé šéŕṽéŕ, šûçĥ åš /šŕṽ/þĥöţöš one two three four]';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Öñļîñé',
      'offline': 'Öƒƒļîñé',
      'scanning': 'Šçåññîñĝ',
      'error': 'Éŕŕöŕ',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one]';
  }

  @override
  String get adminLog => '[Šéŕṽéŕ ļöĝ one]';

  @override
  String get adminName => '[Ñåɱé one]';

  @override
  String get adminNothing => '[Ñöţĥîñĝ ĥéŕé ýéţ one two]';

  @override
  String get adminOutOfRange => '[Öûţ öƒ ŕåñĝé one two]';

  @override
  String get adminOverview => '[Öṽéŕṽîéŵ one]';

  @override
  String get adminPair => '[Þåîŕ å ðéṽîçé one two]';

  @override
  String get adminPairBody =>
      '[Šçåñ ţĥîš çöðé öŕ šéñð ţĥé ļîñķ, ţĥéñ þåšţé îţ îñţö Åðð å šéŕṽéŕ îñ Þĥöţöļîƀ öñ ţĥé ñéŵ ðéṽîçé: îţ ƀŕîñĝš éṽéŕý åððŕéšš öƒ ţĥîš šéŕṽéŕ åñð îţš çéŕţîƒîçåţé, šö ñöƀöðý ţýþéš ţĥéɱ. one two three four five six seven one two three four five six seven one]';

  @override
  String get adminPasswordSetup => '[Þåššŵöŕð šéţûþ ļîñķ one two]';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return '[Šéñð ţĥîš ļîñķ ţö $name ƀý åñý çĥåññéļ, öŕ ļéţ ţĥéɱ šçåñ ţĥé çöðé. Îţ šéţš å þåššŵöŕð öñçé, ûñţîļ $date. one two three four five six seven one two]';
  }

  @override
  String get adminPause => '[Þåûšé å ĵöƀ ţýþé one two]';

  @override
  String adminPauseMinutes(int max) {
    return '[Ṁîñûţéš, 1 ţö $max one two]';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '[$type îš þåûšéð ûñţîļ $time one two three]';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString îţéɱš ļéƒţ ţö ƀåçķ ûþ',
      one: '1 îţéɱ ļéƒţ ţö ƀåçķ ûþ',
      zero: 'Ñöţĥîñĝ ļéƒţ ţö ƀåçķ ûþ',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String get adminPolicies => '[Þöļîçîéš one]';

  @override
  String get adminPolicyReset => '[Ûšé ţĥé ŵîðéŕ ļéṽéļ\'š ṽåļûé one two three]';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Öñ ƀý ðéƒåûļţ',
      'server': 'Šéţ ƒöŕ ţĥé šéŕṽéŕ',
      'user': 'Šéţ ƒöŕ ţĥîš åççöûñţ',
      'library': 'Šéţ ƒöŕ ţĥîš ļîƀŕåŕý',
      'config': 'Šéţ îñ çöñƒîĝ',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get adminPreset => '[Åþþļý å þŕéšéţ one two]';

  @override
  String get adminPresetBody =>
      '[Å þŕéšéţ šéţš éṽéŕý çåþåƀîļîţý ƒöŕ ţĥé šéŕṽéŕ åñð çļéåŕš ŵĥåţ åççöûñţš åñð ļîƀŕåŕîéš šéţ. Éåçĥ šţåýš éðîţåƀļé. one two three four five six seven one two three]';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Åŕçĥîṽé ṽîéŵéŕ',
      'family_backup': 'Ƒåɱîļý ƀåçķûþ',
      'personal': 'Þéŕšöñåļ',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one two]';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Ţĥé éẋţéŕñåļ ŕéåð-öñļý ļîƀŕåŕîéš åŕé ţĥé öñļý šöûŕçé öƒ ţŕûţĥ: ñö ûþļöåðš, ɱåñåĝéð ļîƀŕåŕîéš, ðéṽîçé ƒöļðéŕš, éðîţš, ðéļéţéš öŕ ẊṀÞ ŵŕîţéš',
      'family_backup': 'Éṽéŕýţĥîñĝ öñ ƀûţ ẊṀÞ ŵŕîţéš',
      'personal': 'Éṽéŕýţĥîñĝ öñ ƀûţ šĥåŕîñĝ åñð þûƀļîç ļîñķš',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one two three four five six seven one two three four five]';
  }

  @override
  String get adminQrCode => '[ǪŔ çöðé öƒ ţĥé ļîñķ one two]';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ĵöƀš ǫûéûéð',
      one: '1 ĵöƀ ǫûéûéð',
      zero: 'Ñöţĥîñĝ ţö ðö',
    );
    return '[$_temp0 one two]';
  }

  @override
  String get adminQuota =>
      '[Šţöŕåĝé ǫûöţå îñ ĜƁ; éɱþţý ƒöŕ ñöñé one two three]';

  @override
  String get adminRemote => '[Ŕéɱöţé åççéšš one two]';

  @override
  String get adminRemoteBody =>
      '[Ŕéåçĥ ţĥé šéŕṽéŕ ƒŕöɱ åñýŵĥéŕé ŵîţĥöûţ öþéñîñĝ å þöŕţ öñ ýöûŕ ŕöûţéŕ. Þîçķ öñé ŵåý; éåçĥ ĝîṽéš îţ åñ ĤŢŢÞŠ åððŕéšš ţö åðð ţö ţĥé åþþš. Ţĥéñ ţéšţ îţ ƒŕöɱ öûţšîðé. one two three four five six seven one two three four five six seven]';

  @override
  String get adminRemoteCloudflare =>
      '[çļöûðƒļåŕéð çöññéçţš öûţ ţö Çļöûðƒļåŕé, ŵĥîçĥ šéŕṽéš ýöûŕ ðöɱåîñ öṽéŕ ĤŢŢÞŠ. Ţĥé ƒŕéé þļåñ çåþš å ŕéǫûéšţ åţ 100 ṀƁ, ŵĥîçĥ ƀåçķûþš ñéṽéŕ ŕéåçĥ: ţĥéý šéñð 8 ṀîƁ åţ å ţîɱé. one two three four five six seven one two three four five six seven]';

  @override
  String get adminRemoteNoAddress =>
      '[Åðð ţĥîš šéŕṽéŕ\'š ĥţţþš:// åððŕéšš ţö ţĥîš åþþ ţö ţéšţ îţ ƒŕöɱ öûţšîðé. one two three four five six seven]';

  @override
  String get adminRemoteReachable => '[Ŕéåçĥåƀļé ƒŕöɱ öûţšîðé. one two three]';

  @override
  String get adminRemoteTailscale =>
      '[Îñšţåļļ Ţåîļšçåļé öñ ţĥé šéŕṽéŕ\'š ɱåçĥîñé åñð éṽéŕý ðéṽîçé, îñ ţĥé šåɱé ţåîļñéţ öŕ ýöûŕ Ĥéåðšçåļé, ţĥéñ ŕûñ ţĥîš öñ ţĥé šéŕṽéŕ\'š ɱåçĥîñé åñð šéţ þûƀļîç_ûŕļ ţö ţĥé åððŕéšš îţ þŕîñţš. one two three four five six seven one two three four five six seven one two]';

  @override
  String get adminRemoteTest => '[Ţéšţ ƒŕöɱ öûţšîðé one two]';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '[$host ŵîļļ öþéñ $url ƒŕöɱ îţš šéŕṽéŕš åŕöûñð ţĥé ŵöŕļð, åñð šö ļéåŕñ ţĥîš åððŕéšš. Ĝö öñ? one two three four five six seven one]';
  }

  @override
  String get adminRemoteUnreachable =>
      '[Ñöţ ŕéåçĥåƀļé ƒŕöɱ öûţšîðé: çĥéçķ ţĥé ŵåý ýöû çĥöšé, ţĥéñ ţéšţ åĝåîñ. one two three four five six]';

  @override
  String get adminRemoteWireguard =>
      '[Ñééðš öñé ÛÐÞ þöŕţ öþéñ öñ ţĥé šéŕṽéŕ\'š šîðé öŕ öñ å ĥûƀ. Ţĥîš îš ţĥé çöñƒîĝûŕåţîöñ ƒöŕ å ðéṽîçé; ɱåķé ķéýš ŵîţĥ ŵĝ ĝéñķéý. one two three four five six seven one two three four]';

  @override
  String get adminRepair =>
      '[Þûţ îţ ƀåçķ ƒŕöɱ å ƀåçķûþ öŕ ƒŕöɱ å ðéṽîçé ţĥåţ šţîļļ ĥåš îţ one two three four five]';

  @override
  String get adminRepairOrphan =>
      '[Ñö þĥöţö ñåɱéš îţ: çĥéçķ îţ, ţĥéñ ðéļéţé öŕ ķééþ îţ one two three four five]';

  @override
  String get adminReprocess => '[Ŕéþŕöçéšš one]';

  @override
  String get adminReprocessFaces => '[Ðéţéçţ ƒåçéš åĝåîñ one two]';

  @override
  String get adminReprocessFolder =>
      '[Ƒöļðéŕ, šûçĥ åš 2024/05; éɱþţý ƒöŕ ţĥé ŵĥöļé ļîƀŕåŕý one two three four five]';

  @override
  String get adminReprocessMetadata => '[Ŕéåð ɱéţåðåţå åĝåîñ one two]';

  @override
  String get adminReprocessRenditions =>
      '[Ŕéĝéñéŕåţé ţĥûɱƀñåîļš åñð þŕéṽîéŵš one two three]';

  @override
  String get adminRestore => '[Ŕéšţöŕé one]';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '[Ţĥé ŕéšţöŕé öƒ $name ƒåîļéð: $detail one two three]';
  }

  @override
  String get adminRestoreUnverified =>
      '[Ñö ŕéšţöŕé ðŕîļļ ĥåš þåššéð ýéţ one two three]';

  @override
  String adminRestoreVerified(String when) {
    return '[Ļåšţ ṽéŕîƒîéð ŕéšţöŕé: $when one two three]';
  }

  @override
  String adminRestoreWarning(String name) {
    return '[þĥöţöļîƀð šţöþš, ţĥéñ ŕéþļåçéš ţĥé ŵĥöļé ðåţåƀåšé ŵîţĥ $name ŵĥéñ îţ šţåŕţš åĝåîñ. Ŵĥåţ çĥåñĝéð šîñçé ţĥåţ ƀåçķûþ îš ļöšţ, åñð éṽéŕý ðéṽîçé šýñçš ƒŕöɱ šçŕåţçĥ. one two three four five six seven one two three four five six seven]';
  }

  @override
  String get adminRestoring =>
      '[þĥöţöļîƀð îš šţöþþîñĝ ţö ŕéšţöŕé ţĥé ƀåçķûþ one two three four]';

  @override
  String get adminResume => '[Ŕéšûɱé one]';

  @override
  String get adminRetry => '[Ŕéţŕý one]';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Åðɱîñîšţŕåţöŕ',
      'user': 'Ûšéŕ',
      'viewer': 'Ṽîéŵéŕ',
      'other': 'Ûñķñöŵñ',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get adminSaved => '[Šåṽéð one]';

  @override
  String get adminScan => '[Šçåñ ñöŵ one]';

  @override
  String get adminScrubDays =>
      '[Ðåýš ƒöŕ ţĥé šçŕûƀ ţö çĥéçķ éṽéŕý öŕîĝîñåļ, 1 ţö 3650 one two three four five]';

  @override
  String get adminScrubNever => '[Ƒîŕšţ ƒûļļ çĥéçķ ûñðéŕ ŵåý one two three]';

  @override
  String adminScrubbed(String time) {
    return '[Ļåšţ ƒûļļ çĥéçķ $time one two]';
  }

  @override
  String get adminSecondAdmin =>
      '[Ṁåķé å šéçöñð þéŕšöñ åñ åðɱîñîšţŕåţöŕ, šö ţĥåţ šöɱéöñé éļšé çåñ ŕûñ åñð ŕéšţöŕé ţĥé šéŕṽéŕ îƒ ýöû çåññöţ. one two three four five six seven one two]';

  @override
  String adminSilent(String time) {
    return '[Šîļéñţ šîñçé $time one two]';
  }

  @override
  String get adminSilentHours =>
      '[Ĥöûŕš ŵîţĥöûţ å ŕéþöŕţ ûñţîļ å ðéṽîçé\'š ƀåçķûþ îš šîļéñţ, 1 ţö 8760 one two three four five six]';

  @override
  String get adminStores => '[Šţöŕåĝé one]';

  @override
  String get adminThisDevice => '[Ţĥîš ðéṽîçé one two]';

  @override
  String get adminTitle => '[Šéŕṽéŕ åðɱîñîšţŕåţîöñ one two three]';

  @override
  String get adminTrashDays => '[Ðåýš îñ ţĥé ţŕåšĥ, 1 ţö 3650 one two three]';

  @override
  String get adminTwoFactor =>
      '[Éṽéŕý åççöûñţ ɱûšţ šéţ ûþ å šéçöñð ƒåçţöŕ one two three four]';

  @override
  String get adminUsage => '[Ûšåĝé ƀý åççöûñţ one two]';

  @override
  String get albumCover => '[Ûšé åš çöṽéŕ one two]';

  @override
  String get albumEmpty => '[Ţĥîš åļƀûɱ îš éɱþţý one two]';

  @override
  String get albumHideMemories => '[Ĥîðé ƒŕöɱ ɱéɱöŕîéš one two]';

  @override
  String get albumHideTimeline => '[Ĥîðé ƒŕöɱ ţîɱéļîñé one two]';

  @override
  String get albumNew => '[Ñéŵ åļƀûɱ one]';

  @override
  String get appTitle => '[Þĥöţöļîƀ one]';

  @override
  String get backupAnyDate => '[Åñý ðåţé one]';

  @override
  String get backupCap => '[Ļåŕĝéšţ îţéɱ one two]';

  @override
  String get backupCharging => '[Öñļý ŵĥîļé çĥåŕĝîñĝ one two]';

  @override
  String backupCompleted(String time) {
    return '[Ļåšţ çöɱþļéţé ƀåçķûþ $time one two three]';
  }

  @override
  String backupContact(String time) {
    return '[Ļåšţ çöñţåçţ ŵîţĥ ţĥé šéŕṽéŕ $time one two three]';
  }

  @override
  String get backupEnabled => '[Ɓåçķ ûþ ţĥîš ðéṽîçé one two]';

  @override
  String get backupFolderNo => '[Ñöţ ţĥîš öñé one two]';

  @override
  String get backupFolderYes => '[Ɓåçķ îţ ûþ one]';

  @override
  String backupHours(int count) {
    return '[$count ĥ one]';
  }

  @override
  String get backupMetered =>
      '[Öñ ɱéţéŕéð ñéţŵöŕķš, šûçĥ åš ɱöƀîļé ðåţå öŕ å ĥöţšþöţ one two three four five]';

  @override
  String get backupNever => '[Ñö çöɱþļéţé ƀåçķûþ ýéţ one two three]';

  @override
  String backupNewFolder(String name) {
    return '[Ñéŵ ƒöļðéŕ $name: ƀåçķ îţ ûþ? one two three]';
  }

  @override
  String get backupNoLimit => '[Ñö ļîɱîţ one]';

  @override
  String get backupNothing => '[Ñöţĥîñĝ ŵåîţš one two]';

  @override
  String get backupNow => '[Ɓåçķ ûþ ñöŵ one two]';

  @override
  String backupOverdue(int hours, String items) {
    return '[Ñö çöɱþļéţé ƀåçķûþ ƒöŕ $hours ĥ. Ŵåîţîñĝ: $items one two three four]';
  }

  @override
  String get backupOverdueTitle => '[Ɓåçķûþ ĥåš ñöţ çöɱþļéţéð one two three]';

  @override
  String backupPending(String items) {
    return '[Ŵåîţîñĝ: $items one two]';
  }

  @override
  String backupRetry(String time) {
    return '[Ţŕýîñĝ åĝåîñ $time one two]';
  }

  @override
  String get backupRoaming => '[Ɓåçķ ûþ ŵĥîļé ŕöåɱîñĝ one two three]';

  @override
  String get backupSignIn =>
      '[Šîĝñ îñ ţö å šéŕṽéŕ ţö ƀåçķ ûþ ţĥîš ðéṽîçé one two three four]';

  @override
  String get backupSignedOut =>
      '[Ɓåçķûþ šţöþþéð: ţĥé šéŕṽéŕ šîĝñéð ţĥîš ðéṽîçé öûţ. Šîĝñ îñ åĝåîñ îñ Šéţţîñĝš. one two three four five six seven]';

  @override
  String get backupSince => '[Ţåķéñ šîñçé one two]';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Ɓåçķûþ ŵåîţš ûñţîļ ţĥé šéŕṽéŕ îš îñ ŕéåçĥ',
      'charging': 'Ɓåçķûþ ŵåîţš ûñţîļ ţĥé ðéṽîçé çĥåŕĝéš',
      'battery_low': 'Ɓåçķûþ ŵåîţš: ţĥé ƀåţţéŕý îš ļöŵ',
      'roaming': 'Ɓåçķûþ ŵåîţš ŵĥîļé ŕöåɱîñĝ',
      'quota': 'Ɓåçķûþ šţöþþéð: ýöûŕ šţöŕåĝé öñ ţĥé šéŕṽéŕ îš ƒûļļ',
      'second_factor':
          'Ɓåçķûþ šţöþþéð: ţĥé šéŕṽéŕ åšķš ţĥîš åççöûñţ ƒöŕ å šéçöñð ƒåçţöŕ',
      'other': 'Ɓåçķûþ šţöþþéð: ţĥé šéŕṽéŕ åñšŵéŕéð $code',
    });
    return '[$_temp0 one two three four five six]';
  }

  @override
  String get backupTitle => '[Ɓåçķûþ one]';

  @override
  String get backupWaiting => '[Ñöţ ƀåçķéð ûþ one two]';

  @override
  String get backupWarnAfter => '[Ŵåŕñ ŵĥéñ ñöţ çöɱþļéţé ƒöŕ one two three]';

  @override
  String get backupWhat => '[Ŵĥåţ ţö ƀåçķ ûþ one two]';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'Îñ å ƒöļðéŕ ýöû ðîð ñöţ çĥööšé',
      'folder_new': 'Îñ å ñéŵ ƒöļðéŕ: çĥööšé ŵĥéţĥéŕ ţö ƀåçķ îţ ûþ',
      'type_excluded': 'Å ķîñð öƒ îţéɱ ýöû ðîð ñöţ çĥööšé',
      'before_date': 'Ţåķéñ ƀéƒöŕé ţĥé ðåţé ýöû çĥöšé',
      'selected': 'Ŵåîţîñĝ ƒöŕ îţš ţûŕñ',
      'server_restored': 'Ţĥé šéŕṽéŕ ļöšţ îţ îñ å ŕéšţöŕé: šéñðîñĝ îţ åĝåîñ',
      'working': 'Ɓéîñĝ ƀåçķéð ûþ',
      'waiting_for_icloud': 'Ŵåîţîñĝ ƒöŕ îÇļöûð ţö ðöŵñļöåð îţ',
      'metered': 'Ŵåîţîñĝ ƒöŕ å ñéţŵöŕķ ţĥåţ îš ñöţ ɱéţéŕéð',
      'metered_cap': 'Ţöö ļåŕĝé ƒöŕ å ɱéţéŕéð ñéţŵöŕķ',
      'unreadable': 'Ţĥîš ðéṽîçé çåññöţ ŕéåð îţ',
      'changed': 'Îţ çĥåñĝéð ŵĥîļé îţ ŵåš šéñţ',
      'quota': 'Ýöûŕ šţöŕåĝé öñ ţĥé šéŕṽéŕ îš ƒûļļ',
      'other': 'Ţĥé šéŕṽéŕ ŕéƒûšéð îţ: $code',
    });
    return '[$_temp0 one two three four five]';
  }

  @override
  String get checkAppTooOld =>
      '[Ţĥé šéŕṽéŕ ñö ļöñĝéŕ ŵöŕķš ŵîţĥ ţĥîš ṽéŕšîöñ öƒ Þĥöţöļîƀ. one two three four five]';

  @override
  String get checkAppTooOldNext => '[Ûþðåţé Þĥöţöļîƀ. one two]';

  @override
  String get checkChanged =>
      '[Ţĥé šéŕṽéŕ\'š çéŕţîƒîçåţé îš ñöţ ţĥé öñé ýöû ţŕûšţéð. one two three four five]';

  @override
  String get checkChangedNext =>
      '[Îƒ ýöûŕ åðɱîñîšţŕåţöŕ ŕéþļåçéð îţ, ţŕûšţ ţĥé ñéŵ öñé. Îƒ ñöţ, šöɱéöñé ɱåý ƀé ļîšţéñîñĝ îñ: ðö ñöţ ĝö öñ. one two three four five six seven one two]';

  @override
  String get checkClock =>
      '[Ţĥîš ðéṽîçé\'š çļöçķ åñð ţĥé šéŕṽéŕ\'š ðîƒƒéŕ ƀý ɱöŕé ţĥåñ ƒîṽé ɱîñûţéš. one two three four five six]';

  @override
  String get checkClockNext =>
      '[Ļéţ ýöûŕ ðéṽîçé šéţ îţš ðåţé åñð ţîɱé åûţöɱåţîçåļļý. one two three four five]';

  @override
  String get checkDnsFailed =>
      '[Ţĥé šéŕṽéŕ\'š ñåɱé ðöéš ñöţ ļéåð ţö åñ åððŕéšš. one two three four]';

  @override
  String get checkDnsFailedNext =>
      '[Çĥéçķ ţĥé åððŕéšš, öŕ çöññéçţ ţö ţĥé ñéţŵöŕķ ţĥé šéŕṽéŕ îš öñ. one two three four five six]';

  @override
  String checkExpired(String date) {
    return '[Ţĥé šéŕṽéŕ\'š çéŕţîƒîçåţé éẋþîŕéð öñ $date. one two three four]';
  }

  @override
  String get checkFailed => '[Ƒåîļéð one]';

  @override
  String get checkMetered =>
      '[Ýöû åŕé öñ å ɱéţéŕéð ñéţŵöŕķ, šûçĥ åš ɱöƀîļé ðåţå. one two three four five]';

  @override
  String get checkMeteredNext =>
      '[Çöññéçţ ţö Ŵî-Ƒî ƀéƒöŕé ļåŕĝé ƀåçķûþš. one two three four]';

  @override
  String get checkNotPhotolib =>
      '[Šöɱéţĥîñĝ öţĥéŕ ţĥåñ Þĥöţöļîƀ åñšŵéŕš, šûçĥ åš å þŕöẋý\'š éŕŕöŕ þåĝé öŕ å Ŵî-Ƒî šîĝñ-îñ þåĝé. one two three four five six seven one]';

  @override
  String get checkNotPhotolibNext =>
      '[Šîĝñ îñ ţö ţĥé Ŵî-Ƒî îñ ýöûŕ ƀŕöŵšéŕ, öŕ åšķ ýöûŕ åðɱîñîšţŕåţöŕ ţö çĥéçķ ţĥé þŕöẋý. one two three four five six seven]';

  @override
  String get checkOtherServer =>
      '[Å ðîƒƒéŕéñţ Þĥöţöļîƀ šéŕṽéŕ åñšŵéŕš åţ ţĥîš åððŕéšš. one two three four five]';

  @override
  String get checkPassed => '[Þåššéð one]';

  @override
  String get checkRefused => '[Ñöţĥîñĝ åñšŵéŕš åţ ţĥîš åððŕéšš. one two three]';

  @override
  String get checkRefusedNext =>
      '[Çĥéçķ ţĥåţ ţĥé šéŕṽéŕ îš ŕûññîñĝ åñð ţĥåţ ýöû åŕé öñ îţš ñéţŵöŕķ öŕ ṼÞÑ. one two three four five six seven]';

  @override
  String get checkRun => '[Çĥéçķ ţĥé çöññéçţîöñ one two]';

  @override
  String get checkRunning => '[Çĥéçķîñĝ one]';

  @override
  String get checkSelfSigned =>
      '[Ţĥé šéŕṽéŕ ûšéš å çéŕţîƒîçåţé öƒ îţš öŵñ, ŵĥîçĥ ţĥîš ðéṽîçé ðöéš ñöţ ķñöŵ ýéţ. one two three four five six seven]';

  @override
  String get checkSkipped => '[Ñöţ çĥéçķéð one two]';

  @override
  String get checkStepAuth => '[Ýöûŕ šîĝñ-îñ one two]';

  @override
  String get checkStepClock => '[Ýöûŕ ðéṽîçé\'š çļöçķ one two]';

  @override
  String get checkStepDns => '[Ƒîñðîñĝ ţĥé šéŕṽéŕ\'š åððŕéšš one two three]';

  @override
  String get checkStepNetwork => '[Ýöûŕ ñéţŵöŕķ one two]';

  @override
  String get checkStepServer => '[Þĥöţöļîƀ öñ ţĥé šéŕṽéŕ one two three]';

  @override
  String get checkStepTcp => '[Ŕéåçĥîñĝ ţĥé šéŕṽéŕ one two]';

  @override
  String get checkStepTls =>
      '[Šéçûŕé çöññéçţîöñ åñð çéŕţîƒîçåţé one two three]';

  @override
  String get checkStepUpload => '[Ļåŕĝé ûþļöåðš ţĥŕöûĝĥ þŕöẋîéš one two three]';

  @override
  String get checkTimedOut =>
      '[Ţĥé šéŕṽéŕ ţåķéš ţöö ļöñĝ ţö åñšŵéŕ. one two three four]';

  @override
  String get checkTimedOutNext =>
      '[Çĥéçķ ýöûŕ çöññéçţîöñ, ţĥéñ ţŕý åĝåîñ. one two three four]';

  @override
  String get checkTitle => '[Çöññéçţîöñ çĥéçķ one two]';

  @override
  String get checkTlsFailed => '[Ţĥé šéçûŕé çöññéçţîöñ ƒåîļéð. one two three]';

  @override
  String get checkTrustNext =>
      '[Ţŕûšţ îţ öñļý îƒ îţš ƒîñĝéŕþŕîñţ ɱåţçĥéš ýöûŕ šéŕṽéŕ\'š. one two three four five]';

  @override
  String get checkUntrusted =>
      '[Ţĥé šéŕṽéŕ\'š çéŕţîƒîçåţé çöɱéš ƒŕöɱ åñ åûţĥöŕîţý ţĥîš ðéṽîçé ðöéš ñöţ ţŕûšţ. one two three four five six seven]';

  @override
  String get checkUploadCap =>
      '[Å þŕöẋý öñ ţĥé ŵåý ŕéƒûšéš ļåŕĝé ûþļöåðš, šö ƀåçķûþš ĝö šļöŵéŕ, îñ šɱåļļ þîéçéš. one two three four five six seven]';

  @override
  String get checkUploadCapNext =>
      '[Åšķ ýöûŕ åðɱîñîšţŕåţöŕ ţö ļéţ ŕéǫûéšţš öƒ 64 ṀƁ ţĥŕöûĝĥ ţĥé þŕöẋý. one two three four five six]';

  @override
  String get collectionAlbums => '[Åļƀûɱš one]';

  @override
  String collectionHide(String name) {
    return '[Ĥîðé $name one]';
  }

  @override
  String collectionMoveDown(String name) {
    return '[Ṁöṽé $name ðöŵñ one two]';
  }

  @override
  String collectionMoveUp(String name) {
    return '[Ṁöṽé $name ûþ one two]';
  }

  @override
  String get collectionPeople => '[Þéöþļé one]';

  @override
  String collectionPin(String name) {
    return '[Þîñ $name one]';
  }

  @override
  String get collectionPlaces => '[Þļåçéš one]';

  @override
  String collectionShow(String name) {
    return '[Šĥöŵ $name one]';
  }

  @override
  String get collectionTags => '[Ţåĝš one]';

  @override
  String collectionUnpin(String name) {
    return '[Ûñþîñ $name one]';
  }

  @override
  String get collectionsCustomise => '[Çûšţöɱîšé one]';

  @override
  String get collectionsDone => '[Ðöñé one]';

  @override
  String get commandPalette => '[Çöɱɱåñð þåļéţţé one two]';

  @override
  String get commandPaletteHint => '[Ţýþé å çöɱɱåñð one two]';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öñ ţĥîš ðéṽîçé åñð ƀåçķéð ûþ',
      one: '1 öñ ţĥîš ðéṽîçé åñð ƀåçķéð ûþ',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String deleteDevice(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öñļý öñ ţĥîš ðéṽîçé, ñöţ ƀåçķéð ûþ',
      one: '1 öñļý öñ ţĥîš ðéṽîçé, ñöţ ƀåçķéð ûþ',
    );
    return '[$_temp0 one two three four]';
  }

  @override
  String get deleteICloud =>
      '[Ŵîţĥ îÇļöûð Þĥöţöš öñ, îţéɱš ðéļéţéð ƒŕöɱ ţĥîš ðéṽîçé åļšö ļéåṽé îÇļöûð åñð ýöûŕ öţĥéŕ Åþþļé ðéṽîçéš. one two three four five six seven one two]';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öñļý îñ ýöûŕ ļîƀŕåŕý',
      one: '1 öñļý îñ ýöûŕ ļîƀŕåŕý',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String get deleteRemove => '[Ŕéɱöṽé ƒŕöɱ ţĥîš ðéṽîçé one two three]';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ţĥé $countString ƀåçķéð-ûþ îţéɱš; ýöûŕ ļîƀŕåŕý ķééþš ţĥéɱ',
      one: 'Ţĥé ƀåçķéð-ûþ îţéɱ; ýöûŕ ļîƀŕåŕý ķééþš îţ',
    );
    return '[$_temp0 one two three four five]';
  }

  @override
  String get deleteSpaceReturns =>
      '[Çöþîéš öñ ţĥîš ðéṽîçé ĝö ţö îţš ţŕåšĥ: ţĥé šþåçé ŕéţûŕñš öñçé îţ îš éɱþţîéð. one two three four five six seven]';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ðéļéţé $countString îţéɱš?',
      one: 'Ðéļéţé 1 îţéɱ?',
    );
    return '[$_temp0 one two]';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Ƒŕöɱ ţĥîš ðéṽîçé åñð ýöûŕ ļîƀŕåŕý',
      'device': 'Ƒŕöɱ ţĥîš ðéṽîçé öñļý',
      'other': 'Ƒŕöɱ ýöûŕ ļîƀŕåŕý',
    });
    return '[$_temp0 one two three]';
  }

  @override
  String get deviceFolderAbsent => '[Ñöţ þŕéšéñţ one two]';

  @override
  String get deviceFolderCard => '[ŠÐ çåŕð one]';

  @override
  String get deviceFolderExclude => '[Éẋçļûðé one]';

  @override
  String get deviceFolderExcludeThis => '[Éẋçļûðé ţĥîš ƒöļðéŕ one two]';

  @override
  String get deviceFolderExcludedNotice =>
      '[Ţĥîš îţéɱ\'š ƒöļðéŕ îš éẋçļûðéð ƒŕöɱ ýöûŕ ļîƀŕåŕý one two three four five]';

  @override
  String get deviceFolderForget => '[Ŕéɱöṽé ƒŕöɱ ţĥé ļîšţ one two]';

  @override
  String get deviceFolderInternal => '[Îñţéŕñåļ šţöŕåĝé one two]';

  @override
  String get deviceFolderKeep => '[Ķééþ one]';

  @override
  String deviceFolderNew(String name, String items) {
    return '[$name, $items, îš ñéŵ one two]';
  }

  @override
  String get deviceFolders => '[Ðéṽîçé ƒöļðéŕš one two]';

  @override
  String get deviceFoldersAll =>
      '[Šĥöŵ åļļ ƒöļðéŕš éẋçéþţ ţĥé éẋçļûðéð one two three four]';

  @override
  String get deviceFoldersChosen =>
      '[Šĥöŵ öñļý ţĥé çĥöšéñ ƒöļðéŕš one two three]';

  @override
  String get deviceFoldersExcludedNow =>
      '[Éẋçļûðéð ƒŕöɱ ţĥé ļîƀŕåŕý one two three]';

  @override
  String get deviceFoldersSearch => '[Šéåŕçĥ ƒöļðéŕš one two]';

  @override
  String get diagnosticsAdvanced => '[Šĥöŵ ðîåĝñöšţîçš one two]';

  @override
  String get diagnosticsAllLoggers => '[Åļļ ļöĝĝéŕš one two]';

  @override
  String get diagnosticsCopied => '[Ļöĝ çöþîéð one]';

  @override
  String get diagnosticsCopy => '[Çöþý ţĥé ļöĝ šĥöŵñ one two]';

  @override
  String get diagnosticsEmpty => '[Ñö ļöĝ éñţŕîéš ýéţ one two]';

  @override
  String get diagnosticsExport => '[Éẋþöŕţ ðîåĝñöšţîç ƀûñðļé one two three]';

  @override
  String get diagnosticsExported => '[Ðîåĝñöšţîç ƀûñðļé šåṽéð one two three]';

  @override
  String get diagnosticsLevel => '[Ļéṽéļ one]';

  @override
  String get diagnosticsLogger => '[Ļöĝĝéŕ one]';

  @override
  String get diagnosticsTitle => '[Ðîåĝñöšţîçš one two]';

  @override
  String get download => '[Ðöŵñļöåð one]';

  @override
  String get downloadCurrent =>
      '[Çûŕŕéñţ ṽéŕšîöñ, ŵîţĥ îţš éðîţš one two three]';

  @override
  String get downloadFailed => '[Çöûļðñ\'ţ ðöŵñļöåð one two]';

  @override
  String get downloadOriginal => '[Öŕîĝîñåļ one]';

  @override
  String downloadSaved(String name) {
    return '[Šåṽéð $name one]';
  }

  @override
  String get downloadVersion => '[Ŵĥîçĥ ṽéŕšîöñ? one two]';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ðöŵñļöåðîñĝ $countString îţéɱš',
      one: 'Ðöŵñļöåðîñĝ 1 îţéɱ',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String get editorAutoEnhance => '[Åûţö-éñĥåñçé one two]';

  @override
  String get editorCrop => '[Çŕöþ one]';

  @override
  String get editorCropOriginal => '[Öŕîĝîñåļ one]';

  @override
  String get editorCropSquare => '[Šǫûåŕé one]';

  @override
  String get editorEdit => '[Éðîţ one]';

  @override
  String get editorFlip => '[Ƒļîþ one]';

  @override
  String get editorRotate => '[Ŕöţåţé one]';

  @override
  String get editorSaveCopy => '[Šåṽé çöþý one]';

  @override
  String get editorSaveFailed => '[Çöûļðñ\'ţ šåṽé ţĥé çöþý one two three]';

  @override
  String get editorSaveVersion => '[Šåṽé one]';

  @override
  String get editorSaved => '[Šåṽéð åš å çöþý one two]';

  @override
  String get editorVersionFailed =>
      '[Çöûļðñ\'ţ šåṽé ţĥé ṽéŕšîöñ one two three]';

  @override
  String get editorVersionSaved => '[Šåṽéð åš å ñéŵ ṽéŕšîöñ one two three]';

  @override
  String get editorVersionsUnsupported =>
      '[Ţĥîš šéŕṽéŕ çåññöţ ķééþ ṽéŕšîöñš öƒ éðîţéð þĥöţöš ýéţ one two three four five]';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString çĥåñĝéš ŵéŕé ûñðöñé: ţĥé šéŕṽéŕ ŕéƒûšéð ţĥéɱ.',
      one: '1 çĥåñĝé ŵåš ûñðöñé: ţĥé šéŕṽéŕ ŕéƒûšéð îţ.',
    );
    return '[$_temp0 one two three four five]';
  }

  @override
  String get editsRejectedDismiss => '[Ðîšɱîšš one]';

  @override
  String get editsRejectedForbidden =>
      '[Ýöû ɱåý ṽîéŵ ţĥé îţéɱš ƀûţ ñöţ çĥåñĝé ţĥéɱ. one two three four]';

  @override
  String get editsRejectedInvalid =>
      '[Ţĥé šéŕṽéŕ çöûļð ñöţ åççéþţ ţĥé çĥåñĝéš. one two three four]';

  @override
  String get editsRejectedNotFound =>
      '[Ţĥé îţéɱš ŵéŕé ðéļéţéð öŕ åŕé ñö ļöñĝéŕ šĥåŕéð ŵîţĥ ýöû. one two three four five]';

  @override
  String get errorNotFound => '[Ţĥîš þåĝé ðöéš ñöţ éẋîšţ one two three]';

  @override
  String get errorRetry => '[Ţŕý åĝåîñ one]';

  @override
  String get errorTitle => '[Šöɱéţĥîñĝ ŵéñţ ŵŕöñĝ one two]';

  @override
  String faceNumber(int number) {
    return '[Ƒåçé $number one two]';
  }

  @override
  String get facesAgree => '[Î åĝŕéé one]';

  @override
  String get facesAura =>
      '[Ðéšçŕîƀé ƒåçéš ŵîţĥ ÅûŕåƑåçé (ļåŕĝéŕ ðöŵñļöåð) one two three four]';

  @override
  String get facesNotNow => '[Ñöţ ñöŵ one]';

  @override
  String get facesNoticeKeep =>
      '[Ŵĥåţ îš ƒöûñð šţåýš ŵîţĥ ýöûŕ þĥöţöš, öñ ýöûŕ ðéṽîçéš åñð ýöûŕ šéŕṽéŕ. Ţĥé ðéšçŕîþţîöñš åŕé ñéṽéŕ šĥöŵñ öŕ šĥåŕéð, åñð éṽéŕýţĥîñĝ îš ðéļéţéð ŵĥéñ ýöû šţöþ öŕ ðéļéţé ţĥé þĥöţö. one two three four five six seven one two three four five six seven one]';

  @override
  String get facesNoticeOptional =>
      '[Ţĥîš îš öþţîöñåļ. Éṽéŕýţĥîñĝ éļšé îñ Þĥöţöļîƀ ŵöŕķš ŵîţĥöûţ îţ, åñð ýöû çåñ šţöþ åţ åñý ţîɱé îñ Šéţţîñĝš. one two three four five six seven one two]';

  @override
  String get facesNoticeTitle => '[Ƒîñð ƒåçéš îñ ýöûŕ þĥöţöš? one two three]';

  @override
  String get facesNoticeWhat =>
      '[Þĥöţöļîƀ ļööķš ƒöŕ ƒåçéš îñ ýöûŕ þĥöţöš åñð ṽîðéöš åñð ķééþš, ƒöŕ éåçĥ öñé, ŵĥéŕé îţ îš åñð å ļîšţ öƒ ñûɱƀéŕš ţĥåţ ðéšçŕîƀéš îţ, šö ţĥåţ ţĥé šåɱé þéŕšöñ çåñ ƀé ƒöûñð åĝåîñ. Šûçĥ å ðéšçŕîþţîöñ çåñ çöûñţ åš ƀîöɱéţŕîç ðåţå. one two three four five six seven one two three four five six seven one two three four five]';

  @override
  String get facesNoticeWhere =>
      '[Ţĥîš ĥåþþéñš öñ ţĥîš ðéṽîçé åñð, îƒ ýöû åŕé šîĝñéð îñ, öñ ýöûŕ öŵñ šéŕṽéŕ. Ñéṽéŕ öñ å šéŕṽîçé ŕûñ ƀý ûš öŕ åñýöñé éļšé. one two three four five six seven one two three]';

  @override
  String get facesServerFailed =>
      '[Ýöûŕ šéŕṽéŕ çöûļð ñöţ ƀé ţöļð. Ţŕý åĝåîñ. one two three four]';

  @override
  String get facesServerOff =>
      '[Ýöûŕ šéŕṽéŕ ƒîñðš ñö ƒåçéš ƒöŕ ýöû one two three]';

  @override
  String get facesServerOn => '[Ýöûŕ šéŕṽéŕ ƒîñðš ƒåçéš ƒöŕ ýöû one two three]';

  @override
  String get facesServerUnavailable =>
      '[Ýöûŕ šéŕṽéŕ ðöéš ñöţ öƒƒéŕ ƒåçé ŕéçöĝñîţîöñ one two three four]';

  @override
  String facesStatusDownloading(int percent) {
    return '[Ðöŵñļöåðîñĝ ţĥé ƒåçé ɱöðéļš: $percent% one two three four]';
  }

  @override
  String get facesStatusMissing =>
      '[Ýöûŕ šéŕṽéŕ ĥåš ñöţ îñšţåļļéð ţĥé ƒåçé ɱöðéļš one two three four]';

  @override
  String get facesStatusNoDecoder =>
      '[Ƒåçé ƒîñðîñĝ îš ûñåṽåîļåƀļé: ţĥé îɱåĝé ļîƀŕåŕý (ļîƀṽîþš) ŵåš ñöţ ƒöûñð. Ŕéîñšţåļļ Þĥöţöļîƀ, öŕ îñšţåļļ ļîƀṽîþš åñð ŕéšţåŕţ îţ. one two three four five six seven one two three four]';

  @override
  String get facesStatusRunning =>
      '[Ƒîñðîñĝ ƒåçéš öñ ţĥîš ðéṽîçé one two three]';

  @override
  String get facesStatusUnavailable =>
      '[Ƒåçéš çåññöţ ƀé ƒöûñð öñ ţĥîš ðéṽîçé one two three four]';

  @override
  String get facesStatusWaiting =>
      '[Ţĥé ƒåçé ɱöðéļš ðöŵñļöåð öñ Ŵî-Ƒî one two three]';

  @override
  String get facesSwitch => '[Ƒîñð ƒåçéš îñ ɱý þĥöţöš one two three]';

  @override
  String get facesSwitchOff =>
      '[Öƒƒ. Ñöţĥîñĝ åƀöûţ ƒåçéš îš çöɱþûţéð ûñţîļ ýöû åĝŕéé. one two three four five]';

  @override
  String get facesSwitchOn =>
      '[Öñ. Þĥöţöļîƀ ƒîñðš ţĥé ƒåçéš îñ ýöûŕ þĥöţöš. one two three four]';

  @override
  String get facesTitle => '[Ƒåçéš åñð þéöþļé one two]';

  @override
  String get facesWithdraw => '[Ðéļéţé åñð šţöþ one two]';

  @override
  String get facesWithdrawBody =>
      '[Ţĥîš ðéļéţéš éṽéŕý ƒåçé, ðéšçŕîþţîöñ åñð þéŕšöñ Þĥöţöļîƀ ƒöûñð ƒöŕ ýöû, öñ ţĥîš ðéṽîçé åñð öñ ýöûŕ šéŕṽéŕ. Ýöûŕ þĥöţöš åŕé ñöţ çĥåñĝéð. one two three four five six seven one two three four five]';

  @override
  String get facesWithdrawTitle => '[Šţöþ ƒîñðîñĝ ƒåçéš? one two]';

  @override
  String fileSize(double size, String unit) {
    final intl.NumberFormat sizeNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String sizeString = sizeNumberFormat.format(size);

    String _temp0 = intl.Intl.selectLogic(unit, {
      'kB': 'ķƁ',
      'MB': 'ṀƁ',
      'GB': 'ĜƁ',
      'TB': 'ŢƁ',
      'other': 'Ɓ',
    });
    return '[$sizeString $_temp0 one]';
  }

  @override
  String filesFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '[Ƒîļéš ñöţ çĥåñĝéð: $countString one two three]';
  }

  @override
  String get folderAllow => '[Åļļöŵ åççéšš ţö ţĥîš ƒöļðéŕ one two three]';

  @override
  String get folderDelete => '[Ðéļéţé ƒöļðéŕ one two]';

  @override
  String folderDeleteBody(String name) {
    return '[Ṁöṽé ţĥé þĥöţöš åñð ṽîðéöš îñ $name ţö ţĥé ţŕåšĥ? one two three four five]';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString îţéɱš',
      one: '1 îţéɱ',
    );
    return '[$_temp0 one two]';
  }

  @override
  String get folderNew => '[Ñéŵ ƒöļðéŕ one]';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Öƒƒļîñé, $countString îţéɱš',
      one: 'Öƒƒļîñé, 1 îţéɱ',
    );
    return '[$_temp0 one two]';
  }

  @override
  String get folderOverlaps =>
      '[Ţĥîš ƒöļðéŕ îš åļŕéåðý îñ ţĥé ļîƀŕåŕý, öŕ îñšîðé öŕ åŕöûñð öñé ţĥåţ îš one two three four five six]';

  @override
  String get folderRemove => '[Ŕéɱöṽé ƒöļðéŕ one two]';

  @override
  String folderRemoveBody(String folder) {
    return '[Ţĥé þĥöţöš åñð ṽîðéöš öƒ $folder ļéåṽé ţĥé ļîƀŕåŕý. Ţĥé ƒîļéš šţåý öñ ðîšķ, ûñţöûçĥéð. one two three four five six seven]';
  }

  @override
  String get folderRemoveConfirm => '[Ŕéɱöṽé one]';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Šçåññîñĝ, $countString îţéɱš šö ƒåŕ',
      one: 'Šçåññîñĝ, 1 îţéɱ šö ƒåŕ',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String get foldersAllow => '[Åļļöŵ åççéšš one two]';

  @override
  String get foldersHideExcluded => '[Ĥîðé éẋçļûðéð ƒöļðéŕš one two three]';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Þĥöţöļîƀ çåñ ñö ļöñĝéŕ ŕéåð $countString ƒöļðéŕš.',
      one: 'Þĥöţöļîƀ çåñ ñö ļöñĝéŕ ŕéåð 1 ƒöļðéŕ.',
    );
    return '[$_temp0 one two three four]';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '[Šĥöŵ éẋçļûðéð ƒöļðéŕš ($countString) one two three]';
  }

  @override
  String get foldersUnsupported =>
      '[Ţĥîš ƀŕöŵšéŕ çåññöţ ķééþ å ƒöļðéŕ åš ýöûŕ ļîƀŕåŕý. Öþéñ Þĥöţöļîƀ îñ Çĥŕöɱé öŕ Éðĝé öñ å çöɱþûţéŕ, öŕ ûšé ţĥé ðéšķţöþ åþþ. one two three four five six seven one two three four]';

  @override
  String get galleryButtons => '[Ɓûţţöñš one]';

  @override
  String get galleryChips => '[Çĥîþš one]';

  @override
  String get galleryGrid => '[Ĝŕîð one]';

  @override
  String get galleryMenus => '[Ṁéñûš åñð šĥééţš one two]';

  @override
  String get galleryShowSheet => '[Šĥöŵ å šĥééţ one two]';

  @override
  String get galleryTitle => '[Çöɱþöñéñţš one]';

  @override
  String hiddenCollections(int count) {
    return '[Ĥîððéñ ($count) one two]';
  }

  @override
  String get indexingAllowMetered =>
      '[Ðöŵñļöåð öṽéŕ ɱöƀîļé ðåţå one two three]';

  @override
  String get indexingAllowSaver => '[Åļšö îñ þöŵéŕ šåṽîñĝ ɱöðé one two three]';

  @override
  String get indexingBattery =>
      '[Ɓåţţéŕý ñééðéð ŵîţĥöûţ å çĥåŕĝéŕ one two three]';

  @override
  String get indexingChargingOnly => '[Öñļý ŵĥîļé çĥåŕĝîñĝ one two]';

  @override
  String indexingDownloading(int percent) {
    return '[Ðöŵñļöåðîñĝ ţĥé šéåŕçĥ ɱöðéļ: $percent% one two three four]';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count þĥöţöš çöûļð ñöţ ƀé ŕéåð',
      one: '1 þĥöţö çöûļð ñöţ ƀé ŕéåð',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String get indexingLite =>
      '[Ţĥîš ðéṽîçé îñðéẋéš öñļý îţš ñéŵ þĥöţöš one two three four]';

  @override
  String get indexingMissing =>
      '[Ýöûŕ šéŕṽéŕ ĥåš ñöţ îñšţåļļéð ţĥé šéåŕçĥ ɱöðéļ one two three four]';

  @override
  String get indexingModels => '[Šéåŕçĥ öñ ţĥîš ðéṽîçé one two three]';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '[Ðöŵñļöåðš ţĥé šéåŕçĥ ɱöðéļ ($megabytesString ṀƁ) ƒŕöɱ $host one two three four five]';
  }

  @override
  String get indexingNoDecoder =>
      '[Šéåŕçĥ åñð ţéẋţ ŕéåðîñĝ åŕé ûñåṽåîļåƀļé: ţĥé îɱåĝé ļîƀŕåŕý (ļîƀṽîþš) ŵåš ñöţ ƒöûñð. Ŕéîñšţåļļ Þĥöţöļîƀ, öŕ îñšţåļļ ļîƀṽîþš åñð ŕéšţåŕţ îţ. one two three four five six seven one two three four five]';

  @override
  String indexingPausedBattery(int percent) {
    return '[Þåûšéð ŵĥîļé ţĥé ƀåţţéŕý îš ƀéļöŵ $percent% one two three four]';
  }

  @override
  String get indexingPausedCharger =>
      '[Þåûšéð ûñţîļ ţĥé ðéṽîçé çĥåŕĝéš one two three]';

  @override
  String get indexingPausedHeat =>
      '[Þåûšéð ŵĥîļé ţĥé ðéṽîçé îš ĥöţ one two three]';

  @override
  String get indexingPausedSaver =>
      '[Þåûšéð ŵĥîļé ƀåţţéŕý šåṽéŕ îš öñ one two three]';

  @override
  String indexingPercent(int percent) {
    return '[$percent% one]';
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

    return '[Þĥöţöš îñðéẋéð: $doneString öƒ $totalString one two three]';
  }

  @override
  String get indexingText => '[Ŕéåð ţéẋţ îñ þĥöţöš one two]';

  @override
  String indexingTextDownloading(int percent) {
    return '[Ðöŵñļöåðîñĝ ţĥé ţéẋţ ɱöðéļš: $percent% one two three four]';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '[Ðöŵñļöåðš ţĥé ţéẋţ ɱöðéļš ($megabytesString ṀƁ) ƒŕöɱ $host; ƒîñðš ţĥé ŵöŕðš îñ ýöûŕ þĥöţöš one two three four five six seven]';
  }

  @override
  String get indexingTextMissing =>
      '[Ýöûŕ šéŕṽéŕ ĥåš ñöţ îñšţåļļéð ţĥé ţéẋţ ɱöðéļš one two three four]';

  @override
  String get indexingTextPlatform =>
      '[Ûšéš ýöûŕ þĥöñé\'š öŵñ ţéẋţ ŕéçöĝñîţîöñ; ñöţĥîñĝ ţö ðöŵñļöåð. Ŕéåðš ñéŵ þĥöţöš one two three four five six seven]';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '[Þĥöţöš ŕéåð ƒöŕ ţéẋţ: $doneString öƒ $totalString one two three]';
  }

  @override
  String get indexingTextUnavailable =>
      '[Ŕéåðîñĝ ţéẋţ îš ñöţ åṽåîļåƀļé ĥéŕé one two three]';

  @override
  String get indexingTextWaiting =>
      '[Ţĥé ţéẋţ ɱöðéļš ðöŵñļöåð öñ Ŵî-Ƒî one two three]';

  @override
  String get indexingUnavailable =>
      '[Šéåŕçĥ öñ ţĥîš ðéṽîçé îš ñöţ åṽåîļåƀļé ĥéŕé one two three four]';

  @override
  String get indexingWaiting =>
      '[Ţĥé šéåŕçĥ ɱöðéļ ðöŵñļöåðš öñ Ŵî-Ƒî one two three]';

  @override
  String get infoAddName => '[Åðð ñåɱé one]';

  @override
  String get infoAddTag => '[Åðð ţåĝ one]';

  @override
  String get infoAlbums => '[Åļƀûɱš one]';

  @override
  String get infoAllMetadata => '[Ṽîéŵ åļļ ɱéţåðåţå one two]';

  @override
  String get infoAuto => '[Åûţö one]';

  @override
  String get infoBackedUp => '[Ɓåçķéð ûþ one]';

  @override
  String get infoCamera => '[Çåɱéŕå one]';

  @override
  String get infoChangeAdjust => '[Åðĵûšţéð çöļöûŕš one two]';

  @override
  String get infoChangeCrop => '[Çŕöþþéð one]';

  @override
  String get infoChangeFlip => '[Ṁîŕŕöŕéð one]';

  @override
  String get infoChangeInpaint => '[Ƒîļļéð åñ åŕéå one two]';

  @override
  String get infoChangeLocal => '[Åðĵûšţéð åñ åŕéå one two]';

  @override
  String get infoChangeLut => '[Åþþļîéð å çöļöûŕ ļööķ one two three]';

  @override
  String get infoChangeOther => '[Éðîţéð one]';

  @override
  String get infoChangeTurn => '[Ŕöţåţéð one]';

  @override
  String get infoCompare => '[Çöɱþåŕé ŵîţĥ öŕîĝîñåļ one two three]';

  @override
  String infoConfidence(String percent) {
    return '[Çöñƒîðéñçé: $percent one two]';
  }

  @override
  String get infoCopyPath => '[Çöþý þåţĥ one]';

  @override
  String get infoCurrent => '[Çûŕŕéñţ one]';

  @override
  String get infoDescription => '[Åðð å ðéšçŕîþţîöñ one two]';

  @override
  String get infoEditDate => '[Éðîţ ţĥé ðåţé one two]';

  @override
  String infoEditNumber(int number) {
    return '[Éðîţ $number one two]';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '[Éðîţéð çöþý öƒ $name one two]';
  }

  @override
  String get infoFaces => '[Ƒåçéš one]';

  @override
  String get infoFile => '[Ƒîļé one]';

  @override
  String get infoFromFileName => '[ƒŕöɱ ƒîļé ñåɱé one two]';

  @override
  String get infoHistory => '[Éðîţ ĥîšţöŕý one two]';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count îţéɱš',
      one: '$count îţéɱ',
    );
    return '[$_temp0 one two]';
  }

  @override
  String get infoLocation => '[Ļöçåţîöñ one]';

  @override
  String get infoMap => '[Ṁåþ öƒ ŵĥéŕé îţ ŵåš ţåķéñ one two three]';

  @override
  String get infoMapAgree =>
      '[Ṁåþ ţîļéš çöɱé ƒŕöɱ ţĥé îñţéŕñéţ åñð šĥöŵ ŵĥîçĥ åŕéå ýöû ļööķ åţ one two three four five six]';

  @override
  String infoMegapixels(String megapixels) {
    return '[$megapixels ṀÞ one two]';
  }

  @override
  String infoNewTag(String path) {
    return '[Ñéŵ ţåĝ: $path one two]';
  }

  @override
  String get infoNoAlbum => '[Ñöţ îñ åñý åļƀûɱ one two]';

  @override
  String get infoOnDevice => '[Öñ ţĥîš ðéṽîçé one two]';

  @override
  String get infoOriginal => '[Öŕîĝîñåļ one]';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '[$widthString × $heightString þîẋéļš one two three]';
  }

  @override
  String infoRemoveFrom(String album) {
    return '[Ŕéɱöṽé ƒŕöɱ $album one two]';
  }

  @override
  String infoRemoveTag(String tag) {
    return '[Ŕéɱöṽé $tag one]';
  }

  @override
  String infoRemovedFrom(String album) {
    return '[Ŕéɱöṽéð ƒŕöɱ $album one two]';
  }

  @override
  String get infoRevert => '[Ŕéṽéŕţ one]';

  @override
  String get infoSaveCopy => '[Šåṽé åš çöþý one two]';

  @override
  String get infoShared => '[šĥåŕéð one]';

  @override
  String get infoShowFaces => '[Šĥöŵ ƒåçéš öñ ţĥé þĥöţö one two three]';

  @override
  String get infoShowMap => '[Šĥöŵ ɱåþ one]';

  @override
  String get infoTags => '[Ţåĝš one]';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ṽéŕšîöñš',
      one: '$count ṽéŕšîöñ',
    );
    return '[$_temp0 · ļåšţ $time one two three]';
  }

  @override
  String get infoWhy => '[Ŵĥý ţĥîš ðåţé? one two]';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Ŕéåð îñ ţĥé ƒîļé, åš $tag',
      'name': 'Ŕéåð îñ ţĥé ƒîļé ñåɱé',
      'folder': 'Ŕéåð îñ ţĥé ñåɱé öƒ å ƒöļðéŕ',
      'host': 'Ĝîṽéñ ƀý ţĥé šéŕṽîçé ţĥé ƒîļé çåɱé ƒŕöɱ',
      'unknown':
          'Ñöţĥîñĝ îñ ţĥé ƒîļé ðåţéš îţ, šö ţĥé ðåţé îţ ļåšţ çĥåñĝéð šţåñðš îñ',
      'other':
          'Ţĥé ƒîļé îš ñöţ ŕéåð ýéţ, šö ţĥé ðåţé ţĥé ðéṽîçé ĝîṽéš šţåñðš îñ',
    });
    return '[$_temp0 one two three four five six]';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Ļîšţ',
      'other': 'Ĝŕîð',
    });
    return '[$_temp0 one]';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Ñåɱé',
      'taken': 'Ðåţé ţåķéñ',
      'modified': 'Ðåţé ɱöðîƒîéð',
      'size': 'Šîžé',
      'random': 'Ŕåñðöɱ',
      'extension': 'Ţýþé',
      'custom': 'Åļƀûɱ öŕðéŕ',
      'other': 'Ðåţé ţåķéñ',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get keyAlt => '[Åļţ one]';

  @override
  String get keyControl => '[Çţŕļ one]';

  @override
  String get keyMeta => '[Çɱð one]';

  @override
  String get keyShift => '[Šĥîƒţ one]';

  @override
  String get languageDevice => '[Ðéṽîçé ļåñĝûåĝé one two]';

  @override
  String get languageName => '[Éñĝļîšĥ one]';

  @override
  String get libraryAddFolder => '[Åðð ƒöļðéŕ one]';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Ñöţ ƀåçķéð ûþ',
      'backed_up': 'Ɓåçķéð ûþ',
      'cloud_only': 'Çļöûð öñļý',
      'other': 'Åļļ',
    });
    return '[$_temp0 one two]';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Éṽéŕýţĥîñĝ îš ƀåçķéð ûþ',
      'backed_up': 'Ñöţĥîñĝ îš ƀåçķéð ûþ ýéţ',
      'cloud_only': 'Ñöţĥîñĝ îš öñļý öñ ţĥé šéŕṽéŕ',
      'other': 'Ñöţĥîñĝ ĥéŕé',
    });
    return '[$_temp0 one two three]';
  }

  @override
  String get libraryBadges => '[Ɓåçķûþ ƀåðĝéš one two]';

  @override
  String get libraryEmpty => '[Ýöûŕ þĥöţöš ŵîļļ åþþéåŕ ĥéŕé one two three]';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Ĝŕöûþ ƀý ŵééķ',
      'month': 'Ĝŕöûþ ƀý ɱöñţĥ',
      'other': 'Ĝŕöûþ ƀý ðåý',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get libraryHideVeiled =>
      '[Ĥîðé ĥîððéñ åñð åŕçĥîṽéð îţéɱš åĝåîñ one two three four]';

  @override
  String get libraryNoKeyring =>
      '[Þĥöţöļîƀ ķééþš ţĥé ķéý ţö ýöûŕ ļîƀŕåŕý îñ ţĥé šýšţéɱ ķéýŕîñĝ, ŵĥîçĥ îš ñöţ ŕûññîñĝ öŕ îš ļöçķéð. Šţåŕţ öŕ ûñļöçķ å ķéýŕîñĝ, šûçĥ åš ĜÑÖṀÉ Ķéýŕîñĝ öŕ ĶŴåļļéţ, ţĥéñ ţŕý åĝåîñ. one two three four five six seven one two three four five six seven one]';

  @override
  String get libraryRevealExcluded =>
      '[Šĥöŵ éẋçļûðéð ƒöļðéŕš ƒöŕ 5 ɱîñûţéš one two three]';

  @override
  String get libraryShowVeiled =>
      '[Šĥöŵ ĥîððéñ åñð åŕçĥîṽéð îţéɱš ƒöŕ 5 ɱîñûţéš one two three four]';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Ŕéçéñţļý åððéð',
      'other': 'Ðåţé ţåķéñ',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get libraryStoreFailed =>
      '[Þĥöţöļîƀ çöûļð ñöţ öþéñ ţĥé ļîƀŕåŕý ķéþţ öñ ţĥîš ðéṽîçé one two three four five]';

  @override
  String get libraryViewOptions => '[Ṽîéŵ öþţîöñš one two]';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '[Þŕéþåŕîñĝ ţĥûɱƀñåîļš: $doneString öƒ $totalString one two three]';
  }

  @override
  String get libraryZoomIn => '[Ļåŕĝéŕ ţĥûɱƀñåîļš one two]';

  @override
  String get libraryZoomOut => '[Šɱåļļéŕ ţĥûɱƀñåîļš one two]';

  @override
  String get mapAddTrack => '[Åðð å ĜÞẊ ţŕåçķ one two]';

  @override
  String get mapArea => '[Ṁåþ åŕéå one]';

  @override
  String get mapAttribution => '[© ÖþéñŠţŕééţṀåþ çöñţŕîƀûţöŕš one two three]';

  @override
  String get mapClearLasso => '[Çļéåŕ ţĥé šéļéçţîöñ one two]';

  @override
  String get mapEmpty => '[Ñö þĥöţöš ŵîţĥ å þļåçé ýéţ one two three]';

  @override
  String get mapHeat => '[Ĥéåţɱåþ one]';

  @override
  String get mapLasso => '[Šéļéçţ ƀý ðŕåŵîñĝ åŕöûñð þĥöţöš one two three]';

  @override
  String get mapLoading => '[Þļåçîñĝ þĥöţöš öñ ţĥé ɱåþ one two three]';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '[Þĥöţöš: $countString one two]';
  }

  @override
  String get mapSearchHere => '[Šéåŕçĥ ţĥîš åŕéå one two]';

  @override
  String get mapSplit => '[Šĥöŵ þĥöţöš ûñðéŕ ţĥé ɱåþ one two three]';

  @override
  String get mapTilesAgree =>
      '[Ţĥé ɱåþ ƀåçķĝŕöûñð çöɱéš ƒŕöɱ ÖþéñŠţŕééţṀåþ\'š šéŕṽéŕ (ţîļé.öþéñšţŕééţɱåþ.öŕĝ), ŵĥîçĥ šééš ŵĥîçĥ åŕéå ýöû ļööķ åţ one two three four five six seven one two three]';

  @override
  String get mapTilesShow => '[Šĥöŵ ţĥé ƀåçķĝŕöûñð one two]';

  @override
  String get mapTime => '[Ţîɱé ŕåñĝé one]';

  @override
  String get mapTitle => '[Ṁåþ one]';

  @override
  String get mapTrackBad => '[Ţĥåţ ƒîļé ĥåš ñö ĜÞẊ ţŕåçķš one two three]';

  @override
  String get mapTrips => '[Ţŕîþš one]';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Ƒåṽöûŕîţé',
      'hidden': 'Ĥîððéñ',
      'archived': 'Åŕçĥîṽéð',
      'offline': 'Ķéþţ öñ ţĥîš ðéṽîçé',
      'offline': 'Ķéþţ öñ ţĥîš ðéṽîçé',
      'offline': 'Ķéþţ öñ ţĥîš ðéṽîçé',
      'other': '',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get mediaAccessAllow => '[Åļļöŵ åççéšš one two]';

  @override
  String get mediaAccessNone =>
      '[Þĥöţöļîƀ ñééðš åççéšš ţö ýöûŕ þĥöţöš åñð ṽîðéöš ţö šĥöŵ ţĥéɱ. one two three four five six]';

  @override
  String get mediaAccessPartial =>
      '[Þĥöţöļîƀ šééš öñļý ţĥé þĥöţöš åñð ṽîðéöš ýöû šéļéçţéð. Å ĝåļļéŕý ñééðš åççéšš ţö åļļ öƒ ţĥéɱ. one two three four five six seven one]';

  @override
  String get mediaAccessSelect => '[Šéļéçţ ɱöŕé þĥöţöš one two]';

  @override
  String get nameLabel => '[Ñåɱé one]';

  @override
  String get nextAddRoot =>
      '[Åðð ţĥé ƒöļðéŕ ţö éẋţéŕñåļ_ŕööţš îñ ţĥé šéŕṽéŕ\'š çöñƒîĝûŕåţîöñ, ţĥéñ ŕéšţåŕţ ţĥé šéŕṽéŕ. one two three four five six seven one]';

  @override
  String get nextAskAdmin =>
      '[Åšķ ýöûŕ šéŕṽéŕ\'š åðɱîñîšţŕåţöŕ. one two three]';

  @override
  String get nextAskOwner =>
      '[Åšķ ţĥé ļîƀŕåŕý\'š öŵñéŕ ţö ļéţ ýöû åðð ţö îţ. one two three four]';

  @override
  String get nextCheckConnection =>
      '[Çĥéçķ ţĥé çöññéçţîöñ ţö šéé ŵĥý. one two three]';

  @override
  String get nextCheckEntry =>
      '[Çĥéçķ ŵĥåţ ýöû éñţéŕéð åñð ţŕý åĝåîñ. one two three four]';

  @override
  String get nextConfirm =>
      '[Çĥéçķ ĥöŵ ɱåñý îţéɱš îţ åƒƒéçţš, ţĥéñ çöñƒîŕɱ. one two three four]';

  @override
  String get nextDeleteWebhook =>
      '[Ðéļéţé å ŵéƀĥööķ ýöû ñö ļöñĝéŕ ûšé, ţĥéñ ţŕý åĝåîñ. one two three four five]';

  @override
  String get nextEditConfig =>
      '[Çĥåñĝé îţ îñ ţĥé šéŕṽéŕ\'š çöñƒîĝûŕåţîöñ, ţĥéñ ŕéšţåŕţ ţĥé šéŕṽéŕ. one two three four five six]';

  @override
  String get nextFreeSpace =>
      '[Ƒŕéé šöɱé šþåçé, öŕ åšķ ýöûŕ åðɱîñîšţŕåţöŕ ƒöŕ ɱöŕé. one two three four five]';

  @override
  String get nextNewLink =>
      '[Åšķ ýöûŕ åðɱîñîšţŕåţöŕ ƒöŕ å ñéŵ öñé. one two three four]';

  @override
  String get nextNewestToken =>
      '[Çöþý ţĥé ñéŵéšţ öñé ƒŕöɱ þĥöţöļîƀð\'š ļöĝ. one two three four]';

  @override
  String get nextOtherAdmin =>
      '[Ṁåķé åñöţĥéŕ åççöûñţ åñ åðɱîñîšţŕåţöŕ ƒîŕšţ. one two three four]';

  @override
  String get nextOtherFolder => '[Çĥööšé å ƒöļðéŕ öƒ îţš öŵñ. one two three]';

  @override
  String get nextRefresh => '[Ŕéƒŕéšĥ åñð ţŕý åĝåîñ. one two three]';

  @override
  String get nextReport =>
      '[Ţŕý åĝåîñ. Îƒ îţ ĥåþþéñš åĝåîñ, çöþý ţĥé ðéţåîļš ƀéļöŵ ƒöŕ ýöûŕ åðɱîñîšţŕåţöŕ. one two three four five six seven]';

  @override
  String get nextSetUpPrivate =>
      '[Ƒîñîšĥ šéţţîñĝ ûþ þŕîṽåţé ļîƀŕåŕîéš îñ Šéţţîñĝš, ţĥéñ ţŕý åĝåîñ. one two three four five six]';

  @override
  String get nextSignIn => '[Šîĝñ îñ åĝåîñ. one two]';

  @override
  String get nextSignInAccount =>
      '[Šîĝñ îñ ŵîţĥ ýöûŕ åççöûñţ åñð ţŕý åĝåîñ. one two three four]';

  @override
  String get nextSignInInstead => '[Šîĝñ îñ îñšţéåð. one two]';

  @override
  String get nextTryAgain => '[Ţŕý åĝåîñ. one]';

  @override
  String get nextUpdateAndAgree =>
      '[Ûþðåţé ţĥé åþþ, ţĥéñ åĝŕéé ţö ţĥé ñöţîçé åĝåîñ. one two three four]';

  @override
  String get nextUseAnother => '[Çĥööšé åñöţĥéŕ öñé. one two]';

  @override
  String get nextUseHttps =>
      '[Ûšé ţĥé šéŕṽéŕ\'š ĥţţþš:// åððŕéšš, öŕ çöññéçţ ƒŕöɱ ţĥé šéŕṽéŕ\'š öŵñ ñéţŵöŕķ. one two three four five six seven]';

  @override
  String get nextWait => '[Ŵåîţ å ɱîñûţé, ţĥéñ ţŕý åĝåîñ. one two three]';

  @override
  String get offlineKeep => '[Ķééþ öƒƒļîñé one two]';

  @override
  String offlineKeepHere(String size) {
    return '[Ķééþ öñ ţĥîš ðéṽîçé ($size) one two three]';
  }

  @override
  String get offlineKeptHere => '[Ķéþţ öñ ţĥîš ðéṽîçé one two]';

  @override
  String get offlineStopKeeping => '[Šţöþ ķééþîñĝ öƒƒļîñé one two]';

  @override
  String get otherFiles => '[Öţĥéŕ ƒîļéš one two]';

  @override
  String get passphraseCreate =>
      '[Ţĥîš çöɱþûţéŕ ŕûñš ñö ķéýŕîñĝ (Šéçŕéţ Šéŕṽîçé) ţö ķééþ Þĥöţöļîƀ\'š ķéýš. Çĥööšé å þåššþĥŕåšé öƒ åţ ļéåšţ 10 çĥåŕåçţéŕš ţö þŕöţéçţ ţĥéɱ: Þĥöţöļîƀ åšķš ƒöŕ îţ éåçĥ ţîɱé îţ šţåŕţš. one two three four five six seven one two three four five six seven one]';

  @override
  String get passphraseLabel => '[Þåššþĥŕåšé one]';

  @override
  String get passphraseMismatch => '[Ţĥé þåššþĥŕåšéš ðîƒƒéŕ. one two three]';

  @override
  String get passphraseRepeat => '[Ŕéþéåţ ţĥé þåššþĥŕåšé one two three]';

  @override
  String get passphraseTooShort =>
      '[Ûšé åţ ļéåšţ 10 çĥåŕåçţéŕš. one two three]';

  @override
  String get passphraseUnlock =>
      '[Éñţéŕ ţĥé þåššþĥŕåšé ţĥåţ þŕöţéçţš Þĥöţöļîƀ\'š ķéýš öñ ţĥîš çöɱþûţéŕ. one two three four five six]';

  @override
  String get passphraseWrong => '[Ŵŕöñĝ þåššþĥŕåšé. Ţŕý åĝåîñ. one two three]';

  @override
  String photoPosition(int index, int count) {
    return '[Þĥöţö $index öƒ $count one two]';
  }

  @override
  String get privacyCheckKit => '[Çĥéçķ ŕéçöṽéŕý ķîţ one two]';

  @override
  String get privacyDrillDue =>
      '[Ţîɱé ƒöŕ å ŕéçöṽéŕý ðŕîļļ: çĥéçķ ţĥåţ ýöûŕ ŕéçöṽéŕý ķîţ šţîļļ ûñļöçķš ýöûŕ þŕîṽåţé ļîƀŕåŕîéš. one two three four five six seven one]';

  @override
  String get privacyHonest =>
      '[Þŕîṽåţé ļîƀŕåŕîéš åŕé éñçŕýþţéð öñ ýöûŕ ðéṽîçéš, åñð ñöƀöðý éļšé çåñ öþéñ ţĥéɱ: ñöţ ţĥé šéŕṽéŕ, ñöţ îţš åðɱîñîšţŕåţöŕ, ñöţ Þĥöţöļîƀ\'š ðéṽéļöþéŕš. Îƒ ýöû ļöšé ƀöţĥ ýöûŕ þåššŵöŕð åñð ýöûŕ ŕéçöṽéŕý ķîţ, ýöûŕ þĥöţöš åŕé ļöšţ ƒöŕ ĝööð, åñð ñöƀöðý çåñ ĝéţ ţĥéɱ ƀåçķ ƒöŕ ýöû. one two three four five six seven one two three four five six seven one two three four five six seven one two]';

  @override
  String get privacyKitBody =>
      '[Ŵŕîţé ţĥéšé 24 ŵöŕðš öñ þåþéŕ, îñ öŕðéŕ, åñð ķééþ ţĥéɱ šöɱéŵĥéŕé šåƒé. Ţĥéý ûñļöçķ ýöûŕ þŕîṽåţé ļîƀŕåŕîéš îƒ ýöû ƒöŕĝéţ ýöûŕ þåššŵöŕð, ƒöŕ åñýöñé ŵĥö ĥåš ţĥéɱ. one two three four five six seven one two three four five six seven]';

  @override
  String get privacyKitDone => '[Ýöûŕ ŕéçöṽéŕý ķîţ ŵöŕķš. one two three]';

  @override
  String get privacyKitOther =>
      '[Ţĥîš îš ñöţ ýöûŕ çûŕŕéñţ ŕéçöṽéŕý ķîţ. one two three four]';

  @override
  String get privacyKitTitle => '[Ýöûŕ ŕéçöṽéŕý ķîţ one two]';

  @override
  String get privacyKitUnverified =>
      '[Ŕéçöṽéŕý ķîţ ñöţ ṽéŕîƒîéð ýéţ one two three]';

  @override
  String privacyKitVerified(String date) {
    return '[Ŕéçöṽéŕý ķîţ ṽéŕîƒîéð öñ $date one two three]';
  }

  @override
  String get privacyKitWritten => '[Î ŵŕöţé ţĥéɱ ðöŵñ one two]';

  @override
  String get privacyNotReady =>
      '[Þŕîṽåţé ûþļöåðš šţåý öƒƒ ûñţîļ ýöû ĥåṽé ţŵö ŵåýš ţö ûñļöçķ åñð ĥåṽé ṽéŕîƒîéð ýöûŕ ŕéçöṽéŕý ķîţ. one two three four five six seven one]';

  @override
  String get privacyPasswordHelp =>
      '[Éñţéŕ ýöûŕ åççöûñţ þåššŵöŕð: îţ ƀéçöɱéš öñé ŵåý ţö ûñļöçķ ýöûŕ þŕîṽåţé ļîƀŕåŕîéš. one two three four five six seven]';

  @override
  String get privacyPhrase => '[Ŕéçöṽéŕý þĥŕåšé one two]';

  @override
  String get privacyPhraseHelp =>
      '[Ţĥé 24 ŵöŕðš öƒ ýöûŕ ŕéçöṽéŕý ķîţ one two three]';

  @override
  String get privacyPhraseInvalid =>
      '[Ţĥîš îš ñöţ å ŕéçöṽéŕý þĥŕåšé. Çĥéçķ éṽéŕý ŵöŕð. one two three four five]';

  @override
  String get privacyReady => '[Þŕîṽåţé ûþļöåðš åŕé öñ. one two three]';

  @override
  String get privacyRecoveryKit => '[Ŕéçöṽéŕý ķîţ one two]';

  @override
  String get privacySetUp => '[Šéţ ûþ one]';

  @override
  String get privacyShowWords => '[Šĥöŵ ţĥé ŵöŕðš åĝåîñ one two]';

  @override
  String get privacyTitle => '[Þŕîṽåţé ļîƀŕåŕîéš one two]';

  @override
  String privacyUnknownWord(int number) {
    return '[Ŵöŕð $number îš ñöţ å ŕéçöṽéŕý ķîţ ŵöŕð. one two three four]';
  }

  @override
  String get privacyVerify => '[Ṽéŕîƒý one]';

  @override
  String get privacyVerifyBody =>
      '[Ţýþé ţĥéšé ŵöŕðš ƒŕöɱ ýöûŕ ŕéçöṽéŕý ķîţ ţö šĥöŵ ţĥåţ ýöû šåṽéð îţ. one two three four five six]';

  @override
  String get privacyWays => '[Ŵåýš ţö ûñļöçķ one two]';

  @override
  String privacyWord(int number) {
    return '[Ŵöŕð $number one two]';
  }

  @override
  String get privacyWordsDiffer =>
      '[Ţĥéšé ŵöŕðš ðö ñöţ ɱåţçĥ ýöûŕ ŕéçöṽéŕý ķîţ. Çĥéçķ ŵĥåţ ýöû ŵŕöţé ðöŵñ. one two three four five six]';

  @override
  String get privacyWrongPassword =>
      '[Ţĥîš îš ñöţ ýöûŕ åççöûñţ\'š þåššŵöŕð. one two three four]';

  @override
  String get problemAdminOnly =>
      '[Öñļý åñ åðɱîñîšţŕåţöŕ çåñ ðö ţĥîš. one two three]';

  @override
  String get problemBusy => '[Ţĥé šéŕṽéŕ îš ƀûšý öŕ ŕéšţåŕţîñĝ. one two three]';

  @override
  String get problemChanged => '[Ţĥîš çĥåñĝéð îñ ţĥé ɱéåñţîɱé. one two three]';

  @override
  String get problemConfirm =>
      '[Ţĥîš ŵöûļð ĥîðé öŕ ðéļéţé ɱöŕé îţéɱš ţĥåñ ţĥé šéŕṽéŕ ðöéš ŵîţĥöûţ å çöñƒîŕɱåţîöñ. one two three four five six seven]';

  @override
  String get problemContribute =>
      '[Ýöû ɱåý ñöţ åðð þĥöţöš ţö ţĥîš ļîƀŕåŕý. one two three four]';

  @override
  String get problemCopy => '[Çöþý ðéţåîļš one two]';

  @override
  String get problemDetails => '[Ðéţåîļš one]';

  @override
  String get problemDiskLow =>
      '[Ţĥé šéŕṽéŕ\'š ðîšķ îš åļɱöšţ ƒûļļ, šö ûþļöåðš åŕé þåûšéð. one two three four five]';

  @override
  String get problemEmailTaken =>
      '[Åñöţĥéŕ åççöûñţ ĥåš ţĥîš éɱåîļ. one two three]';

  @override
  String get problemExists => '[Îţ éẋîšţš åļŕéåðý. one two]';

  @override
  String get problemFaceNotice =>
      '[Ýöûŕ šéŕṽéŕ åšķš ƒöŕ å ñéŵéŕ ṽéŕšîöñ öƒ ţĥé ƒåçéš ñöţîçé ţĥåñ ţĥîš åþþ šĥöŵš. one two three four five six seven]';

  @override
  String get problemGone => '[Îţ îš ñö ļöñĝéŕ öñ ţĥé šéŕṽéŕ. one two three]';

  @override
  String get problemHandleTaken =>
      '[Åñöţĥéŕ åççöûñţ ĥåš ţĥîš šîĝñ-îñ ñåɱé. one two three four]';

  @override
  String get problemInterrupted =>
      '[Ţĥé ûþļöåð ŵåš îñţéŕŕûþţéð. one two three]';

  @override
  String get problemInvalid => '[Å ṽåļûé îš ñöţ ṽåļîð. one two three]';

  @override
  String get problemLastAdmin =>
      '[Ţĥé šéŕṽéŕ ñééðš åţ ļéåšţ öñé åðɱîñîšţŕåţöŕ. one two three four]';

  @override
  String get problemLinkInvalid =>
      '[Ţĥîš ļîñķ ĥåš éẋþîŕéð öŕ ŵåš ûšéð. one two three]';

  @override
  String get problemLoginFailed =>
      '[Ŵŕöñĝ éɱåîļ, šîĝñ-îñ ñåɱé öŕ þåššŵöŕð. one two three four]';

  @override
  String get problemMaintenanceKey =>
      '[Ɓåçķûþš, šçŕûƀš åñð þûŕĝéš çåñ ƀé þåûšéð öñļý ŵĥéñ šîĝñéð îñ, ñöţ ŵîţĥ åñ ÅÞÎ ķéý. one two three four five six seven]';

  @override
  String get problemNotAllowed =>
      '[Ýöûŕ åççöûñţ ɱåý ñöţ ðö ţĥîš. one two three]';

  @override
  String get problemNotExternal =>
      '[Öñļý ļîƀŕåŕîéš öƒ ţĥé šéŕṽéŕ\'š öŵñ ƒöļðéŕš çåñ ƀé šçåññéð. one two three four five]';

  @override
  String get problemOidcClaim =>
      '[Ýöûŕ šîĝñ-îñ þŕöṽîðéŕ ðîð ñöţ šåý ŵĥö ýöû åŕé îñ å ŵåý ţĥîš šéŕṽéŕ åççéþţš. one two three four five six seven]';

  @override
  String get problemOidcDown =>
      '[Ýöûŕ šîĝñ-îñ þŕöṽîðéŕ ðöéš ñöţ åñšŵéŕ ţĥé šéŕṽéŕ. one two three four five]';

  @override
  String get problemOidcFailed =>
      '[Ýöûŕ šîĝñ-îñ þŕöṽîðéŕ ŕéƒûšéð ţĥé šîĝñ-îñ. one two three four]';

  @override
  String get problemOidcNotAllowed =>
      '[Ýöûŕ åççöûñţ ɱåý ñöţ šîĝñ îñ ţĥîš ŵåý. one two three four]';

  @override
  String get problemOidcTaken =>
      '[Ţĥîš šîĝñ-îñ îš ļîñķéð ţö åñöţĥéŕ Þĥöţöļîƀ åççöûñţ åļŕéåðý. one two three four five]';

  @override
  String get problemOidcUnknown =>
      '[Ţĥîš šéŕṽéŕ ñö ļöñĝéŕ öƒƒéŕš ţĥîš ŵåý ţö šîĝñ îñ. one two three four five]';

  @override
  String get problemPasskeysOff =>
      '[Þåššķéýš ŵöŕķ öñļý öñçé ţĥé šéŕṽéŕ ĥåš îţš þûƀļîç åððŕéšš. one two three four five]';

  @override
  String get problemPinned =>
      '[Ţĥîš îš šéţ îñ ţĥé çöñƒîĝûŕåţîöñ ƒîļé åñð çåññöţ ƀé çĥåñĝéð ĥéŕé. one two three four five six]';

  @override
  String get problemPolicyOff =>
      '[Ţĥîš îš šŵîţçĥéð öƒƒ öñ ţĥîš šéŕṽéŕ. one two three four]';

  @override
  String get problemQuota =>
      '[Ýöûŕ šţöŕåĝé öñ ţĥé šéŕṽéŕ îš ƒûļļ. one two three]';

  @override
  String get problemRestoreKey =>
      '[Å ƀåçķûþ çåñ ƀé ŕéšţöŕéð öñļý ŵĥéñ šîĝñéð îñ, ñöţ ŵîţĥ åñ ÅÞÎ ķéý. one two three four five six]';

  @override
  String get problemRootDiffers =>
      '[Ţĥîš ƒöļðéŕ ðöéš ñöţ ĥöļð ţĥîš ļîƀŕåŕý\'š ƒîļéš. one two three four]';

  @override
  String get problemRootNotAllowed =>
      '[Ţĥîš ƒöļðéŕ îš ñöţ ûñðéŕ ţĥé éẋţéŕñåļ_ŕööţš öƒ ţĥé šéŕṽéŕ\'š çöñƒîĝûŕåţîöñ. one two three four five six seven]';

  @override
  String get problemRootOverlaps =>
      '[Ţĥîš ƒöļðéŕ ĥöļðš öŕ ļîéš îñ åñöţĥéŕ ļîƀŕåŕý öŕ ţĥé šéŕṽéŕ\'š öŵñ ðåţå. one two three four five six]';

  @override
  String get problemScanning =>
      '[Ţĥîš ļîƀŕåŕý îš ƀéîñĝ šçåññéð åļŕéåðý. one two three four]';

  @override
  String get problemSecondFactor =>
      '[Ţĥîš åççöûñţ ñééðš å šéçöñð ƒåçţöŕ, šûçĥ åš åñ åûţĥéñţîçåţöŕ çöðé öŕ å þåššķéý, ŵĥîçĥ ţĥîš ṽéŕšîöñ öƒ Þĥöţöļîƀ çåññöţ þŕöṽîðé ýéţ. one two three four five six seven one two three four]';

  @override
  String get problemSetupDone =>
      '[Ţĥîš šéŕṽéŕ åļŕéåðý ĥåš åñ åðɱîñîšţŕåţöŕ. one two three four]';

  @override
  String get problemSetupExpired => '[Ţĥîš ţööķ ţöö ļöñĝ. one two]';

  @override
  String get problemSetupToken => '[Ţĥîš šéţûþ ţöķéñ îš ŵŕöñĝ. one two three]';

  @override
  String get problemSignedOut =>
      '[Ýöû åŕé šîĝñéð öûţ öƒ ţĥé šéŕṽéŕ. one two three]';

  @override
  String get problemStepUp =>
      '[Ţĥîš çĥåñĝé ñééðš ýöûŕ þåššŵöŕð öŕ å çöðé ƒîŕšţ. one two three four five]';

  @override
  String get problemStorage =>
      '[Ţĥé šéŕṽéŕ çåññöţ ŕéåçĥ îţš šţöŕåĝé. one two three four]';

  @override
  String get problemTooMany =>
      '[Ţöö ɱåñý åţţéɱþţš îñ å šĥöŕţ ţîɱé. one two three]';

  @override
  String get problemUnexpected =>
      '[Šöɱéţĥîñĝ ûñéẋþéçţéð ŵéñţ ŵŕöñĝ. one two three]';

  @override
  String get problemUnreachable =>
      '[Ţĥé šéŕṽéŕ ðöéš ñöţ åñšŵéŕ. one two three]';

  @override
  String get problemUploadDamaged =>
      '[Ţĥé ƒîļé çĥåñĝéð öŕ ŵåš ðåɱåĝéð öñ ţĥé ŵåý. one two three four]';

  @override
  String get problemUploadExpired =>
      '[Ţĥé šéŕṽéŕ ñö ļöñĝéŕ ĥåš ţĥîš ûþļöåð: ûñƒîñîšĥéð ûþļöåðš éẋþîŕé åƒţéŕ å ðåý. one two three four five six seven]';

  @override
  String get problemWebhookLimit =>
      '[Ýöûŕ åççöûñţ ĥåš åš ɱåñý ŵéƀĥööķš åš îţ ɱåý. one two three four]';

  @override
  String get problemWebhooksOff =>
      '[Ŵéƀĥööķš åŕé ţûŕñéð öƒƒ öñ ţĥîš šéŕṽéŕ. one two three four]';

  @override
  String get recoveryCode => '[Ŕéçöṽéŕý çöðé one two]';

  @override
  String get recoveryCodeAbout =>
      '[Öþéñš Þĥöţöļîƀ\'š šţöŕé öñ ţĥîš ðéṽîçé îƒ ţĥé ķéýšţöŕé ļöšéš îţš ķéý one two three four five six]';

  @override
  String get recoveryCodeEnter => '[Éñţéŕ ŕéçöṽéŕý çöðé one two]';

  @override
  String get recoveryCreate => '[Çŕéåţé ŕéçöṽéŕý çöðé one two]';

  @override
  String get recoveryLater => '[Ļåţéŕ one]';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString çĥåñĝéš éẋîšţ öñļý öñ ţĥîš ðéṽîçé. Å ŕéçöṽéŕý çöðé ĝéţš ţĥéɱ ƀåçķ îƒ ţĥé ķéýšţöŕé ļöšéš Þĥöţöļîƀ\'š ķéý.',
      one: '1 çĥåñĝé éẋîšţš öñļý öñ ţĥîš ðéṽîçé. Å ŕéçöṽéŕý çöðé ĝéţš îţ ƀåçķ îƒ ţĥé ķéýšţöŕé ļöšéš Þĥöţöļîƀ\'š ķéý.',
    );
    return '[$_temp0 one two three four five six seven one two three]';
  }

  @override
  String get recoveryShow =>
      '[Ŵŕîţé ţĥéšé 24 ŵöŕðš ðöŵñ åñð ķééþ ţĥéɱ šåƒé: ţĥéý öþéñ Þĥöţöļîƀ\'š šţöŕé öñ ţĥîš ðéṽîçé ŵîţĥöûţ îţš ķéýšţöŕé ķéý. Ţĥéý ŕéþļåçé åñý éåŕļîéŕ çöðé. one two three four five six seven one two three four five]';

  @override
  String get recoveryUnlock => '[Ûñļöçķ one]';

  @override
  String get recoveryWrong =>
      '[Ţĥåţ îš ñöţ ţĥîš šţöŕé\'š ŕéçöṽéŕý çöðé one two three four]';

  @override
  String get renameFind => '[Ƒîñð one]';

  @override
  String get renamePattern => '[Ñéŵ ñåɱé one]';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Ţöö ļöñĝ: å ñåɱé ĥåš åţ ɱöšţ 255 ƀýţéš',
      'invalid': 'Ñöţ å ṽåļîð ƒîļé ñåɱé',
      'duplicate': 'Ĝîṽéñ ţö åñöţĥéŕ ƒîļé ţöö',
      'exists': 'Åñöţĥéŕ ƒîļé îñ ţĥîš ƒöļðéŕ ĥåš ţĥîš ñåɱé',
      'other': 'Çåññöţ ƀé ŕéñåɱéð',
    });
    return '[$_temp0 one two three four]';
  }

  @override
  String get renameReplace => '[Ŕéþļåçé ŵîţĥ one two]';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '[Ƒîļéš ŕéñåɱéð: $countString one two]';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Šĥöŵ îñ Ƒîñðéŕ',
      'windows': 'Šĥöŵ îñ Éẋþļöŕéŕ',
      'other': 'Šĥöŵ îñ ƒöļðéŕ',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get searchCamera => '[Çåɱéŕå one]';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString îţéɱš',
      one: '1 îţéɱ',
    );
    return '[$_temp0 one two]';
  }

  @override
  String get searchDates => '[Ðåţéš one]';

  @override
  String searchDays(String first, String last) {
    return '[$first – $last one two]';
  }

  @override
  String get searchEmpty => '[Šéåŕçĥ ýöûŕ ļîƀŕåŕý one two]';

  @override
  String get searchFavourites => '[Ƒåṽöûŕîţéš one]';

  @override
  String get searchFolder => '[Ƒöļðéŕ one]';

  @override
  String get searchHint => '[Ƒîļé ñåɱé öŕ ƒöļðéŕ one two]';

  @override
  String get searchMotionPhotos => '[Ṁöţîöñ þĥöţöš one two]';

  @override
  String get searchNothing => '[Ñöţĥîñĝ ɱåţçĥéš one two]';

  @override
  String get searchPanoramas => '[Þåñöŕåɱåš one]';

  @override
  String get searchPhotos => '[Þĥöţöš one]';

  @override
  String get searchScreenshots => '[Šçŕééñšĥöţš one two]';

  @override
  String get searchVideo => '[Ṽîðéö one]';

  @override
  String get searchVideos => '[Ṽîðéöš one]';

  @override
  String get securityAddPasskey => '[Åðð å þåššķéý one two]';

  @override
  String get securityCode => '[Çöðé one]';

  @override
  String get securityCodesHelp =>
      '[Ķééþ ţĥéšé çöðéš šöɱéŵĥéŕé šåƒé. Éåçĥ ŵöŕķš öñçé îñ þļåçé öƒ ýöûŕ šéçöñð ƒåçţöŕ, åñð ţĥéý åŕé šĥöŵñ öñļý ñöŵ. one two three four five six seven one two three]';

  @override
  String securityCodesLeft(int count) {
    return '[Ûñûšéð: $count one two]';
  }

  @override
  String get securityNewCodes => '[Ñéŵ çöðéš one]';

  @override
  String get securityPasskeyNotAdded => '[Ñö þåššķéý ŵåš åððéð. one two three]';

  @override
  String get securityRecoveryCodes => '[Ŕéçöṽéŕý çöðéš one two]';

  @override
  String get securityRemovePasskey => '[Ŕéɱöṽé þåššķéý one two]';

  @override
  String get securitySetUp => '[Šéţ ûþ one]';

  @override
  String get securityStepUpBody =>
      '[Éñţéŕ ýöûŕ þåššŵöŕð, öŕ å çöðé ƒŕöɱ ýöûŕ åûţĥéñţîçåţöŕ åþþ öŕ å ŕéçöṽéŕý çöðé, ţö çĥåñĝé ýöûŕ šéçöñð ƒåçţöŕš. one two three four five six seven one two three]';

  @override
  String get securityStepUpTitle => '[Çöñƒîŕɱ îţ\'š ýöû one two]';

  @override
  String get securityTitle => '[Šéçöñð ƒåçţöŕš one two]';

  @override
  String get securityTotp => '[Åûţĥéñţîçåţöŕ åþþ one two]';

  @override
  String get securityTotpHelp =>
      '[Åðð ţĥîš ķéý ţö ýöûŕ åûţĥéñţîçåţöŕ åþþ, ţĥéñ éñţéŕ ţĥé çöðé îţ šĥöŵš. one two three four five six]';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': 'Öñ', 'other': 'Öƒƒ'});
    return '[$_temp0 one]';
  }

  @override
  String get securityTurnOff => '[Ţûŕñ öƒƒ one]';

  @override
  String get securityWrongCode => '[Ţĥåţ çöðé îš ŵŕöñĝ. one two]';

  @override
  String get securityWrongProof => '[Ŵŕöñĝ þåššŵöŕð öŕ çöðé. one two three]';

  @override
  String get selectAll => '[Šéļéçţ åļļ one]';

  @override
  String get selectionClear => '[Çļéåŕ šéļéçţîöñ one two]';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString šéļéçţéð',
      one: '1 šéļéçţéð',
    );
    return '[$_temp0 one two]';
  }

  @override
  String get selectionReview => '[Šĥöŵ šéļéçţéð one two]';

  @override
  String get serverAccount => '[Éɱåîļ öŕ šîĝñ-îñ ñåɱé one two three]';

  @override
  String get serverAdd => '[Åðð å šéŕṽéŕ one two]';

  @override
  String get serverAddressInvalid =>
      '[Éñţéŕ åððŕéššéš šûçĥ åš þĥöţöš.éẋåɱþļé.öŕĝ one two three four]';

  @override
  String get serverAddresses => '[Åððŕéššéš one]';

  @override
  String get serverAddressesHelp =>
      '[Öñé þéŕ ļîñé: ţĥé šéŕṽéŕ öñ ýöûŕ ñéţŵöŕķ, öñ ţĥé îñţéŕñéţ öŕ ţĥŕöûĝĥ å ṼÞÑ. Ţĥé åþþ ûšéš ţĥé ƒåšţéšţ ţĥåţ åñšŵéŕš. Öŕ þåšţé ţĥé þåššŵöŕð šéţûþ ļîñķ ýöû ŵéŕé šéñţ. one two three four five six seven one two three four five six seven]';

  @override
  String get serverCa => '[Þŕîṽåţé ÇÅ çéŕţîƒîçåţé (ÞÉṀ) one two three]';

  @override
  String get serverCaChoose => '[Çĥööšé å çéŕţîƒîçåţé ƒîļé one two three]';

  @override
  String serverCertificateBody(String host) {
    return '[$host þŕéšéñţš å çéŕţîƒîçåţé ţĥîš ðéṽîçé ðöéš ñöţ ţŕûšţ. Ţŕûšţ îţ öñļý îƒ ţĥîš ŠĤÅ-256 ƒîñĝéŕþŕîñţ îš ýöûŕ šéŕṽéŕ\'š: one two three four five six seven one two three]';
  }

  @override
  String get serverCertificateTitle =>
      '[Ţŕûšţ ţĥîš çéŕţîƒîçåţé? one two three]';

  @override
  String get serverConfirm => '[Çöñƒîŕɱ one]';

  @override
  String get serverConnect => '[Çöññéçţ one]';

  @override
  String get serverCreateAdmin => '[Çŕéåţé åðɱîñîšţŕåţöŕ one two]';

  @override
  String get serverEnded =>
      '[Ţĥé šéŕṽéŕ éñðéð ţĥîš šéššîöñ. Šîĝñ îñ åĝåîñ. one two three four]';

  @override
  String get serverHandleHelp =>
      '[Ļöŵéŕçåšé ļéţţéŕš, ðîĝîţš, ðöţš, ðåšĥéš åñð ûñðéŕšçöŕéš; îţ ñéṽéŕ çĥåñĝéš. one two three four five six seven]';

  @override
  String get serverHeaders => '[Çûšţöɱ ĥéåðéŕš one two]';

  @override
  String get serverHeadersHelp =>
      '[Öñé þéŕ ļîñé, åš Ñåɱé: ṽåļûé, šéñţ öṽéŕ ĤŢŢÞŠ öñļý one two three four five]';

  @override
  String get serverHeadersInvalid =>
      '[Ŵŕîţé éåçĥ ĥéåðéŕ åš Ñåɱé: ṽåļûé one two three]';

  @override
  String get serverIdentity => '[Çļîéñţ çéŕţîƒîçåţé (ÞĶÇŠ#12) one two three]';

  @override
  String get serverIdentityChoose =>
      '[Çĥööšé å çļîéñţ çéŕţîƒîçåţé one two three]';

  @override
  String get serverIdentityInvalid =>
      '[Ţĥîš îš ñöţ å çéŕţîƒîçåţé (ÞĶÇŠ#12), öŕ îţš þåššŵöŕð îš ŵŕöñĝ. one two three four five six]';

  @override
  String get serverIdentityPassword =>
      '[Çļîéñţ çéŕţîƒîçåţé þåššŵöŕð one two three]';

  @override
  String get serverLoading =>
      '[Ŕéåðîñĝ ţĥé šéŕṽéŕ ķéþţ öñ ţĥîš ðéṽîçé one two three four]';

  @override
  String get serverNearby => '[Šéŕṽéŕš öñ ţĥîš ñéţŵöŕķ one two three]';

  @override
  String get serverNeedsHttps =>
      '[Ţĥîš šéŕṽéŕ ñééðš åñ ĤŢŢÞŠ åððŕéšš: ƀéýöñð ýöûŕ ļöçåļ ñéţŵöŕķ, Þĥöţöļîƀ ðöéš ñöţ šîĝñ îñ öṽéŕ þļåîñ ĤŢŢÞ. one two three four five six seven one two]';

  @override
  String get serverNoSignIn =>
      '[Ţĥîš šéŕṽéŕ öƒƒéŕš ñö šîĝñ-îñ ţĥîš ṽéŕšîöñ öƒ Þĥöţöļîƀ šûþþöŕţš. one two three four five six]';

  @override
  String get serverOffline =>
      '[Ţĥé šéŕṽéŕ ðöéš ñöţ åñšŵéŕ. Ýöû šţåý šîĝñéð îñ. one two three four]';

  @override
  String get serverPasskeyFailed =>
      '[Ñö þåššķéý ŵåš ûšéð. Ţŕý åĝåîñ, öŕ ûšé å çöðé. one two three four]';

  @override
  String get serverPasskeyRequired =>
      '[Ţĥîš šéŕṽéŕ ŕéǫûîŕéš å þåššķéý, ŵĥîçĥ ţĥîš ṽéŕšîöñ öƒ Þĥöţöļîƀ çåññöţ ûšé ýéţ. one two three four five six seven]';

  @override
  String get serverPassword => '[Þåššŵöŕð one]';

  @override
  String get serverPasswordAgain => '[Þåššŵöŕð åĝåîñ one two]';

  @override
  String get serverPasswordSetupInvalid =>
      '[Ţĥîš þåššŵöŕð šéţûþ ţöķéñ îš ŵŕöñĝ, ûšéð öŕ éẋþîŕéð. Åšķ ƒöŕ å ñéŵ öñé. one two three four five six seven]';

  @override
  String get serverPasswordSetupToken => '[Þåššŵöŕð šéţûþ ţöķéñ one two]';

  @override
  String get serverPasswordSetupTokenHelp =>
      '[Ƒŕöɱ ýöûŕ åðɱîñîšţŕåţöŕ, öŕ þŕîñţéð ƀý þĥöţöļîƀð åðɱîñ þåššŵöŕð-šéţûþ öñ ţĥé šéŕṽéŕ. one two three four five six seven]';

  @override
  String get serverPasswordsDiffer => '[Ţĥé þåššŵöŕðš ðîƒƒéŕ. one two three]';

  @override
  String get serverPrivateLibrariesBody =>
      '[Å ñéŵ þåššŵöŕð ðöéš ñöţ öþéñ ţĥéɱ. Ŕéöþéñ ţĥéɱ ŵîţĥ ýöûŕ ŕéçöṽéŕý ķîţ, å þåššķéý öŕ å ðéṽîçé ţĥåţ îš šţîļļ šîĝñéð îñ. one two three four five six seven one two three]';

  @override
  String get serverPrivateLibrariesGo => '[Šéţ ţĥé þåššŵöŕð one two]';

  @override
  String get serverPrivateLibrariesTitle =>
      '[Ýöûŕ þŕîṽåţé ļîƀŕåŕîéš šţåý ļöçķéð one two three]';

  @override
  String get serverProxy => '[ĤŢŢÞ þŕöẋý, åš ĥöšţ:þöŕţ one two three]';

  @override
  String get serverProxyInvalid =>
      '[Éñţéŕ ţĥé þŕöẋý åš ĥöšţ:þöŕţ one two three]';

  @override
  String get serverRecoveryCode => '[Ŕéçöṽéŕý çöðé one two]';

  @override
  String get serverRemove => '[Ŕéɱöṽé ţĥîš šéŕṽéŕ one two]';

  @override
  String get serverRequired => '[Ŕéǫûîŕéð one]';

  @override
  String get serverSecondFactor =>
      '[Ţĥîš åççöûñţ\'š šéçöñð ƒåçţöŕ îš å þåššķéý, ŵĥîçĥ ţĥîš ṽéŕšîöñ öƒ Þĥöţöļîƀ çåññöţ ûšé ýéţ. one two three four five six seven one]';

  @override
  String get serverSecondFactorCode =>
      '[Ţĥîš åççöûñţ åļšö ñééðš å çöðé ƒŕöɱ ýöûŕ åûţĥéñţîçåţöŕ åþþ, öŕ å ŕéçöṽéŕý çöðé. one two three four five six seven]';

  @override
  String get serverSecondFactorTitle => '[Çöñƒîŕɱ îţ\'š ýöû one two]';

  @override
  String get serverSecondFactorWrong =>
      '[Ţĥåţ ðîð ñöţ ŵöŕķ. Åƒţéŕ ƒîṽé ţŕîéš, šîĝñ îñ åĝåîñ. one two three four five]';

  @override
  String get serverSetPassword => '[Šéţ þåššŵöŕð one two]';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '[Ƒöŕ $handle öñ $server one two]';
  }

  @override
  String get serverSetPasswordOpen => '[Šéţ å þåššŵöŕð one two]';

  @override
  String get serverSetPasswordTitle => '[Šéţ ýöûŕ þåššŵöŕð one two]';

  @override
  String get serverSetUp => '[Šéţ ûþ å ñéŵ šéŕṽéŕ one two]';

  @override
  String get serverSetupLinkElsewhere =>
      '[Ţö ûšé ţĥîš šéţûþ ļîñķ, šîĝñ öûţ öƒ ţĥîš šéŕṽéŕ ƒîŕšţ, öŕ ŕéɱöṽé îţ îƒ ţĥé ļîñķ îš ƒöŕ åñöţĥéŕ öñé. one two three four five six seven one two]';

  @override
  String get serverSetupTitle => '[Šéţ ûþ ţĥé šéŕṽéŕ one two]';

  @override
  String get serverSetupToken => '[Šéţûþ ţöķéñ one two]';

  @override
  String get serverSetupTokenHelp =>
      '[þĥöţöļîƀð þŕîñţš îţ îñ îţš ļöĝ ŵĥîļé ţĥé šéŕṽéŕ ĥåš ñö åðɱîñîšţŕåţöŕ; éåçĥ šţåŕţ þŕîñţš å ñéŵ öñé. one two three four five six seven one two]';

  @override
  String get serverSignIn => '[Šîĝñ îñ one]';

  @override
  String get serverSignOut => '[Šîĝñ öûţ one]';

  @override
  String serverSignedInAs(String account) {
    return '[Šîĝñéð îñ åš $account one two]';
  }

  @override
  String get serverSignedOut => '[Šîĝñéð öûţ one]';

  @override
  String get serverSwitch => '[Šŵîţçĥ åççöûñţ one two]';

  @override
  String get serverTotpCode =>
      '[Çöðé ƒŕöɱ ýöûŕ åûţĥéñţîçåţöŕ åþþ one two three]';

  @override
  String get serverTrust => '[Ţŕûšţ one]';

  @override
  String get serverUnreadable =>
      '[Ţĥé šéŕṽéŕ ķéþţ öñ ţĥîš ðéṽîçé çåññöţ ƀé ŕéåð one two three four]';

  @override
  String get serverUsePasskey => '[Ûšé å þåššķéý one two]';

  @override
  String get serverUseRecoveryCode =>
      '[Ûšé å ŕéçöṽéŕý çöðé îñšţéåð one two three]';

  @override
  String get settingsBackground => '[Ɓéĥîñð ţŕåñšþåŕéñţ îɱåĝéš one two three]';

  @override
  String get settingsDefaultTab => '[Ƒöļðéŕš åñð åļƀûɱš öþéñ öñ one two three]';

  @override
  String get settingsFolders => '[Ƒöļðéŕš one]';

  @override
  String get settingsIndexing => '[Îñðéẋîñĝ öñ ţĥîš ðéṽîçé one two three]';

  @override
  String get settingsLanguage => '[Ļåñĝûåĝé one]';

  @override
  String get settingsLibrary => '[Ļîƀŕåŕý one]';

  @override
  String get settingsServer => '[Šéŕṽéŕ one]';

  @override
  String get settingsStart => '[Šţåŕţ šçŕééñ one two]';

  @override
  String get settingsTheme => '[Ţĥéɱé one]';

  @override
  String get settingsTitle => '[Šéţţîñĝš one]';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Ţåþ ţĥé ļéƒţ öŕ ŕîĝĥţ éðĝé ƒöŕ ţĥé þŕéṽîöûš öŕ ñéẋţ îţéɱ',
      'oneFingerZoom': 'Ðöûƀļé-ţåþ åñð ðŕåĝ ţö žööɱ ŵîţĥ öñé ƒîñĝéŕ',
      'swipes': 'Šŵîþé ûþ öŕ ðöŵñ öñ å ṽîðéö\'š ļéƒţ šîðé ƒöŕ ƀŕîĝĥţñéšš, ŕîĝĥţ šîðé ƒöŕ ṽöļûɱé',
      'maxBrightness': 'Ƒûļļ ƀŕîĝĥţñéšš ŵĥîļé ṽîéŵîñĝ',
      'autoRotate': 'Ţûŕñ ţö éåçĥ þĥöţö\'š öŕ ṽîðéö\'š öŕîéñţåţîöñ',
      'mixAudio': 'Þļåý ṽîðéöš öṽéŕ öţĥéŕ åûðîö îñšţéåð öƒ þåûšîñĝ îţ',
      'autoplay': 'Þļåý ṽîðéöš åš ţĥéý öþéñ',
      'loop': 'Ļööþ ṽîðéöš',
      'autoNext': 'Ĝö ţö ţĥé ñéẋţ îţéɱ ŵĥéñ å ṽîðéö éñðš',
      'resume': 'Ŕéšûɱé ṽîðéöš ŵĥéŕé ţĥéý ŵéŕé ļéƒţ',
      'other': 'Þļåý åñîɱåţéð îɱåĝéš îñ ţĥé ĝŕîð',
    });
    return '[$_temp0 one two three four five six seven]';
  }

  @override
  String get settingsViewerBar =>
      '[Ɓûţţöñš îñ ţĥé ṽîéŵéŕ\'š ƀåŕ one two three]';

  @override
  String get settingsViewing => '[Ṽîéŵîñĝ one]';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString šĥåŕéð þĥöţöš åñð ṽîðéöš ŵåîţ ûñţîļ Þĥöţöļîƀ ɱåý åðð ţö ýöûŕ Þĥöţöš ļîƀŕåŕý. Ûñšåṽéð îţéɱš åŕé ðéļéţéð åƒţéŕ 7 ðåýš.',
      one: '1 šĥåŕéð þĥöţö öŕ ṽîðéö ŵåîţš ûñţîļ Þĥöţöļîƀ ɱåý åðð ţö ýöûŕ Þĥöţöš ļîƀŕåŕý. Ûñšåṽéð îţéɱš åŕé ðéļéţéð åƒţéŕ 7 ðåýš.',
    );
    return '[$_temp0 one two three four five six seven one two three four]';
  }

  @override
  String get shareTooLarge =>
      '[Ţöö ļåŕĝé ţö šĥåŕé åţ öñçé: šéļéçţ ƒéŵéŕ îţéɱš one two three four]';

  @override
  String shareTooMany(int count) {
    return '[Ţöö ɱåñý ţö šĥåŕé åţ öñçé: šéļéçţ $count öŕ ƒéŵéŕ one two three four five]';
  }

  @override
  String get shortcutsTitle => '[Ķéýƀöåŕð šĥöŕţçûţš one two]';

  @override
  String get slideshow => '[Šļîðéšĥöŵ one]';

  @override
  String get slideshowLoop => '[Ŕéþéåţ one]';

  @override
  String get slideshowOptions => '[Šļîðéšĥöŵ öþţîöñš one two]';

  @override
  String get slideshowSeconds => '[Šéçöñðš þéŕ îţéɱ one two]';

  @override
  String get slideshowShuffle => '[Šĥûƒƒļé one]';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Ðéšçéñðîñĝ',
      'other': 'Åšçéñðîñĝ',
    });
    return '[$_temp0 one]';
  }

  @override
  String get sourceDevice => '[Ţĥîš ðéṽîçé one two]';

  @override
  String sourceHide(String name) {
    return '[Ĥîðé $name one]';
  }

  @override
  String get sourceHideOthers => '[Ĥîðé éṽéŕýţĥîñĝ éļšé ĥéŕé one two three]';

  @override
  String get sourceLost => '[Ñö åççéšš one]';

  @override
  String get sourcePartly => '[Þåŕţļý šĥöŵñ one two]';

  @override
  String sourceShow(String name) {
    return '[Šĥöŵ $name one]';
  }

  @override
  String get sourceShowEverything => '[Šĥöŵ éṽéŕýţĥîñĝ ĥéŕé one two]';

  @override
  String get sourceShowOnly => '[Šĥöŵ öñļý ţĥîš one two]';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Ţîɱéļîñé',
      'folders': 'Ƒöļðéŕš åñð åļƀûɱš',
      'favourites': 'Ƒåṽöûŕîţéš',
      'other': 'Ţîɱéļîñé',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get storageAddPerson => '[Ķééþ å þéŕšöñ öƒƒļîñé one two three]';

  @override
  String get storageBudget => '[Šţöŕåĝé ƀûðĝéţ one two]';

  @override
  String get storageClear => '[Ŕéɱöṽé öƒƒļîñé çöþîéš one two three]';

  @override
  String get storageClearAction => '[Ŕéɱöṽé one]';

  @override
  String storageClearBody(String size) {
    return '[Ţĥîš ŕéɱöṽéš $size ķéþţ öñ ţĥîš ðéṽîçé åñð šţöþš ķééþîñĝ åļƀûɱš, šéåŕçĥéš åñð þĥöţöš öƒƒļîñé. Ýöûŕ ļîƀŕåŕý öñ ţĥé šéŕṽéŕ îš ñöţ ţöûçĥéð. one two three four five six seven one two three four five]';
  }

  @override
  String get storageKeepLibrary => '[Ķééþ ţĥé ŵĥöļé ļîƀŕåŕý one two three]';

  @override
  String get storageKeepOriginals => '[Ķééþ öŕîĝîñåļš ţöö one two]';

  @override
  String get storageNoPeople => '[Ñö þéöþļé åŕé ñåɱéð ýéţ. one two three]';

  @override
  String get storageNoPins =>
      '[Ñöţĥîñĝ îš þîññéð. Þîñ åñ åļƀûɱ, å šéåŕçĥ öŕ å þĥöţö ţö ķééþ îţ öƒƒļîñé. one two three four five six seven]';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Åļƀûɱ',
      'search': 'Šéåŕçĥ',
      'person': 'Þéŕšöñ',
      'library': 'Ŵĥöļé ļîƀŕåŕý',
      'asset': 'Þĥöţö',
      'other': 'Þîññéð',
    });
    return '[$_temp0 one two]';
  }

  @override
  String storagePinLeft(String size) {
    return '[Ðöéš ñöţ ƒîţ ţĥé ƀûðĝéţ: $size ɱöŕé ñééðéð one two three four]';
  }

  @override
  String get storagePinNothing =>
      '[Ñöţĥîñĝ ţö ðöŵñļöåð: îţš þĥöţöš åŕé öñ ţĥîš ðéṽîçé åļŕéåðý one two three four five]';

  @override
  String get storagePinPaused =>
      '[Ŵåîţîñĝ: ţĥîš þŕéšéţ ķééþš ñöţĥîñĝ öƒƒļîñé one two three four]';

  @override
  String get storagePinPlanning => '[Ļööķîñĝ ûþ ŵĥåţ ţö ķééþ… one two three]';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return '[Ðöŵñļöåðîñĝ: $haveString öƒ $filesString one two three]';
  }

  @override
  String storagePinReady(String size) {
    return '[Åṽåîļåƀļé öƒƒļîñé ($size) one two three]';
  }

  @override
  String get storagePinWaiting => '[Ŵîļļ ðöŵñļöåð ŵĥéñ öñļîñé one two three]';

  @override
  String get storagePins => '[Ķéþţ öƒƒļîñé one two]';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Çåţåļöĝûé öñļý',
      'spaceSaver': 'Šþåçé šåṽéŕ',
      'travel': 'Šéļéçţéð åļƀûɱš öƒƒļîñé',
      'everything': 'Éṽéŕýţĥîñĝ',
      'other': '',
    });
    return '[$_temp0 one two three]';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Ķééþš ñöţĥîñĝ; þĥöţöš ļöåð ƒŕöɱ ýöûŕ šéŕṽéŕ ŵĥéñ ýöû öþéñ ţĥéɱ.',
      'spaceSaver': 'Ķééþš þŕéṽîéŵš öƒ ýöûŕ ŵĥöļé ļîƀŕåŕý, ñéŵéšţ ƒîŕšţ, ŵîţĥîñ ţĥé ƀûðĝéţ.',
      'travel': 'Ķééþš öñļý ŵĥåţ ýöû þîñ: åļƀûɱš, šéåŕçĥéš åñð þĥöţöš.',
      'everything': 'Ķééþš ţĥé öŕîĝîñåļš öƒ ýöûŕ ŵĥöļé ļîƀŕåŕý, ñéŵéšţ ƒîŕšţ, ŵîţĥîñ ţĥé ƀûðĝéţ.',
      'other': '',
    });
    return '[$_temp0 one two three four five six seven]';
  }

  @override
  String get storagePresets => '[Ŵĥåţ ţĥîš ðéṽîçé ķééþš one two three]';

  @override
  String get storageSubtitle =>
      '[Öƒƒļîñé çöþîéš åñð šţöŕåĝé ƀûðĝéţ one two three]';

  @override
  String get storageTitle => '[Šţöŕåĝé one]';

  @override
  String storageUsed(String used, String budget) {
    return '[$used öƒ $budget ûšéð one two]';
  }

  @override
  String get storageWebNote =>
      '[Å ƀŕöŵšéŕ ķééþš þŕéṽîéŵš öñļý, åñð éŕåšéš ţĥéɱ ŵĥéñ ýöû šîĝñ öûţ. one two three four five six]';

  @override
  String get storeNoKeyring =>
      '[Þĥöţöļîƀ ķééþš ţĥé ķéý öƒ îţš ļöçåļ šţöŕé îñ ţĥé šýšţéɱ ķéýŕîñĝ, ŵĥîçĥ ðîð ñöţ åñšŵéŕ. Îñšţåļļ åñð ûñļöçķ ĝñöɱé-ķéýŕîñĝ, ĶŴåļļéţ öŕ ĶééÞåššẊÇ ŵîţĥ îţš Šéçŕéţ Šéŕṽîçé öñ, ţĥéñ ţŕý åĝåîñ. one two three four five six seven one two three four five six seven one two]';

  @override
  String get storeNoKeystore =>
      '[Þĥöţöļîƀ çöûļð ñöţ ŕéåçĥ ţĥîš ðéṽîçé\'š ķéýšţöŕé, ŵĥîçĥ ĥöļðš ţĥé ķéý öƒ îţš ļöçåļ šţöŕé. one two three four five six seven one]';

  @override
  String get storeRebuilt =>
      '[Ţĥîš ðéṽîçé\'š ķéýšţöŕé ñö ļöñĝéŕ ĥåð ţĥé ķéý öƒ Þĥöţöļîƀ\'š ļöçåļ šţöŕé, šö ţĥé šţöŕé ŵåš ŕéƀûîļţ. Îţš šéţţîñĝš åñð ŵĥåţ éẋîšţéð öñļý öñ ţĥîš ðéṽîçé åŕé ļöšţ; ļîƀŕåŕîéš šýñç åĝåîñ åñð ţĥûɱƀñåîļš çöɱé ƀåçķ. one two three four five six seven one two three four five six seven one two three]';

  @override
  String get storeRecoveryNeeded =>
      '[Ţĥîš ðéṽîçé\'š ķéýšţöŕé ñö ļöñĝéŕ ĥåš ţĥé ķéý öƒ Þĥöţöļîƀ\'š ļöçåļ šţöŕé. Éñţéŕ îţš ŕéçöṽéŕý çöðé, öŕ ŕéšéţ ţĥé šţöŕé åñð ļöšé ŵĥåţ éẋîšţš öñļý öñ ţĥîš ðéṽîçé. one two three four five six seven one two three four five six seven]';

  @override
  String get storeReset => '[Ŕéšéţ šţöŕé one two]';

  @override
  String get storeResetBody =>
      '[Ŵĥåţ éẋîšţš öñļý öñ ţĥîš ðéṽîçé îš ļöšţ; ļîƀŕåŕîéš šýñç åĝåîñ åñð ţĥûɱƀñåîļš çöɱé ƀåçķ. one two three four five six seven one]';

  @override
  String get storeUnavailable =>
      '[Ţĥé šţöŕé öñ ţĥîš ðéṽîçé îš ûñåṽåîļåƀļé: šéţţîñĝš åñð çöļļéçţîöñš åŕé ñöţ ķéþţ one two three four five six seven]';

  @override
  String get tabCollections => '[Çöļļéçţîöñš one two]';

  @override
  String get tabLibrary => '[Ļîƀŕåŕý one]';

  @override
  String get tabSearch => '[Šéåŕçĥ one]';

  @override
  String get themeDark => '[Ðåŕķ one]';

  @override
  String get themeLight => '[Ļîĝĥţ one]';

  @override
  String get themeSystem => '[Šýšţéɱ one]';

  @override
  String get timelineBenchmark => '[Ţîɱéļîñé ƀéñçĥɱåŕķ one two]';

  @override
  String get timelineBenchmarkCopy => '[Çöþý ţĥé ŕéšûļţš one two]';

  @override
  String get timelineCannotPlay =>
      '[Çåñ\'ţ þļåý îñ ţĥîš ƀŕöŵšéŕ one two three]';

  @override
  String timelineCell(String date, int position, int count) {
    return '[$date, $position öƒ $count one two three]';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '[$date, $position öƒ $count, ñö þŕéṽîéŵ one two three]';
  }

  @override
  String get timelineExcluded => '[Îñ åñ éẋçļûðéð ƒöļðéŕ one two three]';

  @override
  String get timelineNoHeicLinux =>
      '[Þĥöţöļîƀ çåñ\'ţ šĥöŵ ĤÉÎÇ þĥöţöš öñ ţĥîš çöɱþûţéŕ. Çöññéçţ å Þĥöţöļîƀ šéŕṽéŕ ţö šéé îţš çöþý, öŕ öþéñ ţĥéɱ öñ å Ṁåç. one two three four five six seven one two three]';

  @override
  String get timelineNoHeicWindows =>
      '[Þĥöţöļîƀ çåñ\'ţ šĥöŵ ĤÉÎÇ þĥöţöš öñ ţĥîš ÞÇ. Çöññéçţ å Þĥöţöļîƀ šéŕṽéŕ ţö šéé îţš çöþý, öŕ öþéñ ţĥéɱ öñ å Ṁåç. one two three four five six seven one two three]';

  @override
  String get timelineScrubber => '[Šçŕöļļ ƀý ðåţé one two]';

  @override
  String get timelineSphere => '[360° one]';

  @override
  String get timelineUndated => '[Ðåţé ûñķñöŵñ one two]';

  @override
  String timelineWeek(String date) {
    return '[Ŵééķ öƒ $date one two]';
  }

  @override
  String toolbarAdd(String action) {
    return '[Åðð $action ţö ţĥé ƀåŕ one two three]';
  }

  @override
  String toolbarDown(String action) {
    return '[Ṁöṽé $action ðöŵñ one two]';
  }

  @override
  String get toolbarInBar => '[Îñ ţĥé ƀåŕ one]';

  @override
  String get toolbarInMenu => '[Îñ ţĥé ⋮ ɱéñû one two]';

  @override
  String toolbarRemove(String action) {
    return '[Ŕéɱöṽé $action ƒŕöɱ ţĥé ƀåŕ one two three]';
  }

  @override
  String get toolbarReset => '[Ŕéšéţ ţö ðéƒåûļţ one two]';

  @override
  String toolbarUp(String action) {
    return '[Ṁöṽé $action ûþ one two]';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Ṁöṽé ĥéŕé',
      'other': 'Çöþý ĥéŕé',
    });
    return '[$_temp0 one]';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Å ƒîļé öŕ ƒöļðéŕ öƒ ţĥîš ñåɱé îš åļŕéåðý ţĥéŕé',
      'changed': 'Ţĥé çöþý ðîð ñöţ ɱåţçĥ ţĥé öŕîĝîñåļ åñð ŵåš ŕéɱöṽéð',
      'cancelled': 'Çåñçéļļéð',
      'invalid': 'Ñöţ å ṽåļîð ƒöļðéŕ ñåɱé',
      'other': 'Ƒåîļéð',
    });
    return '[$_temp0 one two three four five]';
  }

  @override
  String get transferRecent => '[Ŕéçéñţ one]';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ðéļéţé $countString îţéɱš ƒöŕéṽéŕ? Ţĥîš çåññöţ ƀé ûñðöñé.',
      one: 'Ðéļéţé 1 îţéɱ ƒöŕéṽéŕ? Ţĥîš çåññöţ ƀé ûñðöñé.',
    );
    return '[$_temp0 one two three four five]';
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
      other: '$daysString ðåýš ļéƒţ',
      one: '1 ðåý ļéƒţ',
      zero: 'Ðéļéţéð ƒöŕéṽéŕ ţöðåý',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String get trashEmpty => '[Ţĥé ţŕåšĥ îš éɱþţý one two]';

  @override
  String get trashEmptyAll => '[Éɱþţý ţŕåšĥ one two]';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString îţéɱš ɱöṽéð ţö ţĥé ţŕåšĥ',
      one: '1 îţéɱ ɱöṽéð ţö ţĥé ţŕåšĥ',
    );
    return '[$_temp0 one two three]';
  }

  @override
  String trashRetention(int days) {
    return '[Þĥöţöļîƀ ðéļéţéš ŵĥåţ îţ ķééþš îñ ţĥé ţŕåšĥ ƒöŕ ĝööð åƒţéŕ $days ðåýš; éåçĥ îţéɱ šĥöŵš ţĥé ţîɱé îţ ĥåš ļéƒţ. one two three four five six seven one two three]';
  }

  @override
  String get trashTitle => '[Ţŕåšĥ one]';

  @override
  String get undo => '[Ûñðö one]';

  @override
  String get uploadAction => '[Ûþļöåð þĥöţöš åñð ṽîðéöš one two three]';

  @override
  String get uploadClear => '[Çļéåŕ one]';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '[Ûþļöåðéð $doneString öƒ $totalString one two three]';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '[Ƒåîļéð: $countString one two]';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString îţéɱš åŕçĥîṽéð',
      one: '1 îţéɱ åŕçĥîṽéð',
    );
    return '[$_temp0 one two]';
  }

  @override
  String veilHidden(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString îţéɱš ĥîððéñ',
      one: '1 îţéɱ ĥîððéñ',
    );
    return '[$_temp0 one two]';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Ɓļåçķ',
      'white': 'Ŵĥîţé',
      'other': 'Çĥéçķéŕƀöåŕð',
    });
    return '[$_temp0 one two]';
  }

  @override
  String get viewerCannotPlay =>
      '[Ţĥîš ṽîðéö çåññöţ þļåý öñ ţĥîš ðéṽîçé one two three four]';

  @override
  String get viewerCaptions => '[Çåþţîöñš one]';

  @override
  String get viewerCompass => '[Çöɱþåšš ļöçķ one two]';

  @override
  String get viewerCopy => '[Çöþý one]';

  @override
  String get viewerCopyText => '[Çöþý ţéẋţ one]';

  @override
  String get viewerCustomize => '[Çûšţöɱîžé ţööļƀåŕ… one two]';

  @override
  String get viewerDial =>
      '[Ĥéåðîñĝ. Çļîçķ ţö ƒåçé ƒŕöñţ. Ðŕåĝ ţö ļööķ åŕöûñð, šçŕöļļ öŕ þîñçĥ ţö žööɱ, ðöûƀļé-çļîçķ ţö ŕéšéţ one two three four five six seven one two]';

  @override
  String get viewerFilmstrip => '[Ƒîļɱšţŕîþ one]';

  @override
  String get viewerFirst => '[Ƒîŕšţ one]';

  @override
  String get viewerFisheye => '[Ƒîšĥéýé one]';

  @override
  String get viewerGyroscope => '[Ṁöṽé ţö ļööķ åŕöûñð one two]';

  @override
  String get viewerHdr => '[Šĥöŵ îñ ĤÐŔ one two]';

  @override
  String get viewerInfo => '[Îñƒö one]';

  @override
  String get viewerInfoLoading => '[Ļöåðîñĝ ţĥîš îţéɱ\'š îñƒö one two three]';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '[$positionString öƒ $countString one two]';
  }

  @override
  String get viewerLast => '[Ļåšţ one]';

  @override
  String get viewerLenses => '[Çĥööšé å ļéñš one two]';

  @override
  String get viewerMap => '[Ṁåþ one]';

  @override
  String get viewerMotion => '[Þļåý ɱöţîöñ one two]';

  @override
  String get viewerMotionDenied =>
      '[Ţĥîš ƀŕöŵšéŕ ðîð ñöţ åļļöŵ åççéšš ţö ţĥé ɱöţîöñ šéñšöŕš one two three four five]';

  @override
  String get viewerMotionMissing =>
      '[Ţĥîš ðéṽîçé ĥåš ñö ĝýŕöšçöþé ţö ļööķ åŕöûñð ŵîţĥ one two three four five]';

  @override
  String get viewerMute => '[Ṁûţé one]';

  @override
  String get viewerNext => '[Ñéẋţ one]';

  @override
  String get viewerNextFrame => '[Ñéẋţ ƒŕåɱé one]';

  @override
  String get viewerPause => '[Þåûšé one]';

  @override
  String get viewerPlanet => '[Ļîţţļé þļåñéţ one two]';

  @override
  String get viewerPlay => '[Þļåý one]';

  @override
  String get viewerPrevious => '[Þŕéṽîöûš one]';

  @override
  String get viewerPreviousFrame => '[Þŕéṽîöûš ƒŕåɱé one two]';

  @override
  String get viewerRotate => '[Ŕöţåţé one]';

  @override
  String get viewerSdr => '[Šĥöŵ îñ ŠÐŔ one two]';

  @override
  String get viewerSeek => '[Þöšîţîöñ one]';

  @override
  String get viewerSetAs => '[Šéţ åš one]';

  @override
  String get viewerShare => '[Šĥåŕé one]';

  @override
  String get viewerSpeed => '[Þļåýƀåçķ šþééð one two]';

  @override
  String get viewerSphere =>
      '[360° ṽîéŵ. Ðŕåĝ ţö ļööķ åŕöûñð, þîñçĥ ţö žööɱ one two three four]';

  @override
  String get viewerText => '[Ţéẋţ îñ ţĥîš þĥöţö one two]';

  @override
  String get viewerTextCopied => '[Ţéẋţ çöþîéð one two]';

  @override
  String get viewerTextNone => '[Ñö ţéẋţ ƒöûñð îñ ţĥîš þĥöţö one two three]';

  @override
  String get viewerTextUnread =>
      '[Ţĥîš þĥöţö\'š ţéẋţ ĥåš ñöţ ƀééñ ŕéåð ýéţ one two three four]';

  @override
  String get viewerUnmute => '[Ûñɱûţé one]';

  @override
  String get viewerZoomIn => '[Žööɱ îñ one]';

  @override
  String get viewerZoomOut => '[Žööɱ öûţ one]';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'ŠÐ çåŕð',
      'other': 'Îñţéŕñåļ',
    });
    return '[$_temp0 one]';
  }

  @override
  String get zoomIn => '[Žööɱ îñ one]';

  @override
  String get zoomOut => '[Žööɱ öûţ one]';
}
