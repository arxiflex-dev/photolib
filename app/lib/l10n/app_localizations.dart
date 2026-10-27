import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('ar', 'XB'),
    Locale('de'),
    Locale('en'),
    Locale('en', 'XA'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @actionAddToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Add to album'**
  String get actionAddToAlbum;

  /// Archives photos: out of the timeline, still in folders and search
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get actionArchive;

  /// Copies the selected files into another folder
  ///
  /// In en, this message translates to:
  /// **'Copy to…'**
  String get actionCopyTo;

  /// Deletes photos in the trash for good; every client uses this wording
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get actionDeleteForever;

  /// No description provided for @actionFavourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get actionFavourite;

  /// Hides photos from every view of Photolib
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get actionHide;

  /// Moves the selected files into another folder, or an album into another album folder
  ///
  /// In en, this message translates to:
  /// **'Move to…'**
  String get actionMoveTo;

  /// Renames the selected files
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// Brings photos back from the trash where they were
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// Moves photos to the trash; every client uses this wording
  ///
  /// In en, this message translates to:
  /// **'Move to trash'**
  String get actionTrash;

  /// Brings archived photos back into the timeline
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get actionUnarchive;

  /// Takes back what was just done
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// Takes photos out of the favourites
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get actionUnfavourite;

  /// Shows hidden photos again
  ///
  /// In en, this message translates to:
  /// **'Unhide'**
  String get actionUnhide;

  /// Whether an account may sign in
  ///
  /// In en, this message translates to:
  /// **'{status, select, active{Active} disabled{Disabled} invited{Invited} deleted{Deleted} other{Unknown}}'**
  String adminAccountStatus(String status);

  /// A tab of the admin console: the server's user accounts
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get adminAccounts;

  /// Opens the dialog that creates an account
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get adminAddAccount;

  /// Opens the dialog that gives an account a read-only library of a folder on the server
  ///
  /// In en, this message translates to:
  /// **'Add an external library'**
  String get adminAddExternalLibrary;

  /// A job's state and how often it ran
  ///
  /// In en, this message translates to:
  /// **'{status}, {attempts, plural, =0{not run yet} =1{1 attempt} other{{attempts} attempts}}'**
  String adminAttempts(String status, int attempts);

  /// A tab of the admin console: who changed what
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get adminAudit;

  /// Queues a database backup now
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get adminBackUpNow;

  /// Said once a backup is queued
  ///
  /// In en, this message translates to:
  /// **'The backup is queued; a restore drill follows it'**
  String get adminBackupQueued;

  /// A heading of the admin overview
  ///
  /// In en, this message translates to:
  /// **'Database backups'**
  String get adminBackups;

  /// Stops a queued or running job
  ///
  /// In en, this message translates to:
  /// **'Cancel job'**
  String get adminCancelJob;

  /// A heading of the admin console's policies: the capability switches of the server, an account or a library
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get adminCapabilities;

  /// A capability the server's policy switches
  ///
  /// In en, this message translates to:
  /// **'{name, select, managed_libraries{Managed libraries} uploads{Uploads from devices, the web and the CLI} folder_browser{Folder browser} device_folders{Device folders in connected apps} sharing{Sharing and public links} edits{Edits} deletes{Deletes} xmp_writes{XMP sidecar writes} face_recognition{Face recognition} ml_search{Smart search} other{Unknown}}'**
  String adminCapability(String name);

  /// The outcome of a check of the server
  ///
  /// In en, this message translates to:
  /// **'{status, select, ok{OK} warn{Warning} fail{Failed} other{Unknown}}'**
  String adminCheck(String status);

  /// The diagnostics bundle is on the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get adminCopied;

  /// Copies the server's diagnostics bundle
  ///
  /// In en, this message translates to:
  /// **'Copy diagnostics for a bug report'**
  String get adminCopyBundle;

  /// Copies a password setup link
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get adminCopyLink;

  /// Deletes an account after a delay
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminDelete;

  /// A heading of the admin overview: the backup each device last reported
  ///
  /// In en, this message translates to:
  /// **'Device backups'**
  String get adminDeviceBackups;

  /// A section of the admin console: the devices signed in to the administrator's account
  ///
  /// In en, this message translates to:
  /// **'Your devices'**
  String get adminDevices;

  /// Stops an account from signing in
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get adminDisable;

  /// The last automatic restore test of a backup failed; detail is the server's English reason
  ///
  /// In en, this message translates to:
  /// **'The last restore drill failed: {detail}'**
  String adminDrillFailed(String detail);

  /// Opens the dialog that changes an account
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminEdit;

  /// An account's email address
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminEmail;

  /// Lets a disabled or deleted account sign in again
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get adminEnable;

  /// The server refused the console
  ///
  /// In en, this message translates to:
  /// **'Sign in as an administrator'**
  String get adminErrorSignIn;

  /// A policy of the server
  ///
  /// In en, this message translates to:
  /// **'Face recognition starts on for new accounts'**
  String get adminFacesDefault;

  /// A heading of the admin overview: originals, thumbnails and previews
  ///
  /// In en, this message translates to:
  /// **'Files by kind'**
  String get adminFiles;

  /// What the integrity scrub found wrong with a stored file
  ///
  /// In en, this message translates to:
  /// **'{kind, select, content{Damaged} missing{Missing} size{Wrong size} hash{Replaced} orphan{Stray file} other{Unknown}}'**
  String adminFinding(String kind);

  /// Free space on a store
  ///
  /// In en, this message translates to:
  /// **'{size} free'**
  String adminFree(String size);

  /// A policy of the server
  ///
  /// In en, this message translates to:
  /// **'Pause uploads below this free disk, in percent, 0 to 50'**
  String get adminFreeDisk;

  /// A policy of the server, after adminFreeDisk: the floor in GB applies when it is less than the percentage
  ///
  /// In en, this message translates to:
  /// **'or below this free disk in GB, if less, 0 to 100000'**
  String get adminFreeDiskGb;

  /// An account's unique sign-in name
  ///
  /// In en, this message translates to:
  /// **'Sign-in name'**
  String get adminHandle;

  /// A heading of the admin overview: files the scrub found damaged, missing, replaced or stray
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get adminIntegrity;

  /// An account's or a library's number of photos and videos, or a number of files
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String adminItems(int count);

  /// A background job's state, and the filter of the job list
  ///
  /// In en, this message translates to:
  /// **'{status, select, queued{Queued} running{Running} done{Done} dead{Failed} cancelled{Cancelled} other{All}}'**
  String adminJobStatus(String status);

  /// The job list's filter and the pause dialog's field
  ///
  /// In en, this message translates to:
  /// **'Job type, such as render'**
  String get adminJobType;

  /// A tab of the admin console: the server's background jobs
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get adminJobs;

  /// When a device last made a request
  ///
  /// In en, this message translates to:
  /// **'Last seen {time}'**
  String adminLastSeen(String time);

  /// A heading of the admin overview
  ///
  /// In en, this message translates to:
  /// **'Libraries'**
  String get adminLibraries;

  /// The account an external library is given to
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get adminLibraryOwner;

  /// The field of the external library dialog that names its folder
  ///
  /// In en, this message translates to:
  /// **'Folder on the server, such as /srv/photos'**
  String get adminLibraryRoot;

  /// A library's state
  ///
  /// In en, this message translates to:
  /// **'{state, select, online{Online} offline{Offline} scanning{Scanning} error{Error} other{Unknown}}'**
  String adminLibraryState(String state);

  /// A tab of the admin console: the newest lines of the server's log
  ///
  /// In en, this message translates to:
  /// **'Server log'**
  String get adminLog;

  /// An account's display name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminName;

  /// An empty list of the admin console
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get adminNothing;

  /// A field's value is not allowed
  ///
  /// In en, this message translates to:
  /// **'Out of range'**
  String get adminOutOfRange;

  /// A tab of the admin console: usage, libraries and backups
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get adminOverview;

  /// A section of the admin console: the link and QR code that bring this server's addresses and certificate to a new device
  ///
  /// In en, this message translates to:
  /// **'Pair a device'**
  String get adminPair;

  /// Explains the pairing link; Add a server is the name of the app's page
  ///
  /// In en, this message translates to:
  /// **'Scan this code or send the link, then paste it into Add a server in Photolib on the new device: it brings every address of this server and its certificate, so nobody types them.'**
  String get adminPairBody;

  /// Makes a one-time link with which an account's owner sets a new password
  ///
  /// In en, this message translates to:
  /// **'Password setup link'**
  String get adminPasswordSetup;

  /// Says how to hand a password setup link over and until when it works
  ///
  /// In en, this message translates to:
  /// **'Send this link to {name} by any channel, or let them scan the code. It sets a password once, until {date}.'**
  String adminPasswordSetupBody(String name, String date);

  /// Opens the dialog that pauses a kind of background job
  ///
  /// In en, this message translates to:
  /// **'Pause a job type'**
  String get adminPause;

  /// How long the pause lasts; it ends by itself
  ///
  /// In en, this message translates to:
  /// **'Minutes, 1 to {max}'**
  String adminPauseMinutes(int max);

  /// A banner line: a kind of background job does not run until the time
  ///
  /// In en, this message translates to:
  /// **'{type} is paused until {time}'**
  String adminPausedUntil(String type, String time);

  /// How many items a device still had to back up when it last reported
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing left to back up} =1{1 item left to back up} other{{count} items left to back up}}'**
  String adminPending(int count);

  /// A tab of the admin console: the server's settings for new accounts
  ///
  /// In en, this message translates to:
  /// **'Policies'**
  String get adminPolicies;

  /// Clears what an account or a library sets, so that the server's or the account's value applies
  ///
  /// In en, this message translates to:
  /// **'Use the wider level\'s value'**
  String get adminPolicyReset;

  /// Where a capability's value comes from
  ///
  /// In en, this message translates to:
  /// **'{source, select, default{On by default} server{Set for the server} user{Set for this account} library{Set for this library} config{Set in config} other{Unknown}}'**
  String adminPolicySource(String source);

  /// Opens the dialog that applies a preset to the server's policy
  ///
  /// In en, this message translates to:
  /// **'Apply a preset'**
  String get adminPreset;

  /// What applying a preset does
  ///
  /// In en, this message translates to:
  /// **'A preset sets every capability for the server and clears what accounts and libraries set. Each stays editable.'**
  String get adminPresetBody;

  /// A preset of the server's policy
  ///
  /// In en, this message translates to:
  /// **'{preset, select, archive_viewer{Archive viewer} family_backup{Family backup} personal{Personal} other{Unknown}}'**
  String adminPresetName(String preset);

  /// What a preset of the server's policy switches off
  ///
  /// In en, this message translates to:
  /// **'{preset, select, archive_viewer{The external read-only libraries are the only source of truth: no uploads, managed libraries, device folders, edits, deletes or XMP writes} family_backup{Everything on but XMP writes} personal{Everything on but sharing and public links} other{Unknown}}'**
  String adminPresetSummary(String preset);

  /// What a screen reader says of the QR code of a password setup link
  ///
  /// In en, this message translates to:
  /// **'QR code of the link'**
  String get adminQrCode;

  /// What reprocessing queued
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to do} =1{1 job queued} other{{count} jobs queued}}'**
  String adminQueued(int count);

  /// An account's storage limit
  ///
  /// In en, this message translates to:
  /// **'Storage quota in GB; empty for none'**
  String get adminQuota;

  /// A section of the admin console: ways to reach the server from anywhere without opening a port on the router
  ///
  /// In en, this message translates to:
  /// **'Remote access'**
  String get adminRemote;

  /// The admin console's remote access
  ///
  /// In en, this message translates to:
  /// **'Reach the server from anywhere without opening a port on your router. Pick one way; each gives it an HTTPS address to add to the apps. Then test it from outside.'**
  String get adminRemoteBody;

  /// The admin console's remote access; keep cloudflared as it is
  ///
  /// In en, this message translates to:
  /// **'cloudflared connects out to Cloudflare, which serves your domain over HTTPS. The free plan caps a request at 100 MB, which backups never reach: they send 8 MiB at a time.'**
  String get adminRemoteCloudflare;

  /// The admin console's remote access; keep https:// as it is
  ///
  /// In en, this message translates to:
  /// **'Add this server\'s https:// address to this app to test it from outside.'**
  String get adminRemoteNoAddress;

  /// The test from outside passed
  ///
  /// In en, this message translates to:
  /// **'Reachable from outside.'**
  String get adminRemoteReachable;

  /// The admin console's remote access; keep public_url as it is
  ///
  /// In en, this message translates to:
  /// **'Install Tailscale on the server\'s machine and every device, in the same tailnet or your Headscale, then run this on the server\'s machine and set public_url to the address it prints.'**
  String get adminRemoteTailscale;

  /// Asks an outside service to open the server's public address
  ///
  /// In en, this message translates to:
  /// **'Test from outside'**
  String get adminRemoteTest;

  /// Asked before the test from outside contacts the host
  ///
  /// In en, this message translates to:
  /// **'{host} will open {url} from its servers around the world, and so learn this address. Go on?'**
  String adminRemoteTestAsk(String host, String url);

  /// The test from outside failed
  ///
  /// In en, this message translates to:
  /// **'Not reachable from outside: check the way you chose, then test again.'**
  String get adminRemoteUnreachable;

  /// The admin console's remote access; keep wg genkey as it is
  ///
  /// In en, this message translates to:
  /// **'Needs one UDP port open on the server\'s side or on a hub. This is the configuration for a device; make keys with wg genkey.'**
  String get adminRemoteWireguard;

  /// How an administrator repairs a damaged, missing or replaced file
  ///
  /// In en, this message translates to:
  /// **'Put it back from a backup or from a device that still has it'**
  String get adminRepair;

  /// What an administrator does with a stored file no photo refers to
  ///
  /// In en, this message translates to:
  /// **'No photo names it: check it, then delete or keep it'**
  String get adminRepairOrphan;

  /// Opens the dialog that redoes the processing of a library or a folder
  ///
  /// In en, this message translates to:
  /// **'Reprocess'**
  String get adminReprocess;

  /// A choice of the reprocess dialog
  ///
  /// In en, this message translates to:
  /// **'Detect faces again'**
  String get adminReprocessFaces;

  /// The field of the reprocess dialog that limits it to a folder
  ///
  /// In en, this message translates to:
  /// **'Folder, such as 2024/05; empty for the whole library'**
  String get adminReprocessFolder;

  /// A choice of the reprocess dialog
  ///
  /// In en, this message translates to:
  /// **'Read metadata again'**
  String get adminReprocessMetadata;

  /// A choice of the reprocess dialog
  ///
  /// In en, this message translates to:
  /// **'Regenerate thumbnails and previews'**
  String get adminReprocessRenditions;

  /// Replaces the server's database with a backup: a button and the title of its confirmation
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get adminRestore;

  /// The last restore of a backup failed; detail is the server's English reason
  ///
  /// In en, this message translates to:
  /// **'The restore of {name} failed: {detail}'**
  String adminRestoreFailed(String name, String detail);

  /// No automatic restore test of a backup has passed yet
  ///
  /// In en, this message translates to:
  /// **'No restore drill has passed yet'**
  String get adminRestoreUnverified;

  /// When an automatic restore test of a backup last passed
  ///
  /// In en, this message translates to:
  /// **'Last verified restore: {when}'**
  String adminRestoreVerified(String when);

  /// The confirmation of a restore; name is the backup's file name
  ///
  /// In en, this message translates to:
  /// **'photolibd stops, then replaces the whole database with {name} when it starts again. What changed since that backup is lost, and every device syncs from scratch.'**
  String adminRestoreWarning(String name);

  /// Said once the server stops to restore a backup
  ///
  /// In en, this message translates to:
  /// **'photolibd is stopping to restore the backup'**
  String get adminRestoring;

  /// Ends the pause of a kind of background job now
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get adminResume;

  /// Runs a failed or cancelled job again
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adminRetry;

  /// An account's role
  ///
  /// In en, this message translates to:
  /// **'{role, select, admin{Administrator} user{User} viewer{Viewer} other{Unknown}}'**
  String adminRole(String role);

  /// The policies were saved
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get adminSaved;

  /// Looks for new files in an external library
  ///
  /// In en, this message translates to:
  /// **'Scan now'**
  String get adminScan;

  /// A policy of the server: how fast the integrity scrub goes
  ///
  /// In en, this message translates to:
  /// **'Days for the scrub to check every original, 1 to 3650'**
  String get adminScrubDays;

  /// A store whose integrity scrub has not yet checked every file
  ///
  /// In en, this message translates to:
  /// **'First full check under way'**
  String get adminScrubNever;

  /// When the integrity scrub last checked every file of a store
  ///
  /// In en, this message translates to:
  /// **'Last full check {time}'**
  String adminScrubbed(String time);

  /// Shown in the accounts list while the server has one active administrator: asks for a second one, who can take over
  ///
  /// In en, this message translates to:
  /// **'Make a second person an administrator, so that someone else can run and restore the server if you cannot.'**
  String get adminSecondAdmin;

  /// A device that has not reported its backup since this time, for longer than the policy allows
  ///
  /// In en, this message translates to:
  /// **'Silent since {time}'**
  String adminSilent(String time);

  /// A policy of the server: when a device's backup counts as silent
  ///
  /// In en, this message translates to:
  /// **'Hours without a report until a device\'s backup is silent, 1 to 8760'**
  String get adminSilentHours;

  /// A tab of the admin console: where the server keeps files
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get adminStores;

  /// Marks the device in use in the list of devices
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get adminThisDevice;

  /// The admin console's title and its entry in the settings
  ///
  /// In en, this message translates to:
  /// **'Server administration'**
  String get adminTitle;

  /// How long trashed items stay
  ///
  /// In en, this message translates to:
  /// **'Days in the trash, 1 to 3650'**
  String get adminTrashDays;

  /// A policy of the server
  ///
  /// In en, this message translates to:
  /// **'Every account must set up a second factor'**
  String get adminTwoFactor;

  /// A heading of the admin overview
  ///
  /// In en, this message translates to:
  /// **'Usage by account'**
  String get adminUsage;

  /// Makes the selected photo the album's cover
  ///
  /// In en, this message translates to:
  /// **'Use as cover'**
  String get albumCover;

  /// An album without photos or videos
  ///
  /// In en, this message translates to:
  /// **'This album is empty'**
  String get albumEmpty;

  /// Hides an album's photos from memories, in the album's menu; checked while it is hidden
  ///
  /// In en, this message translates to:
  /// **'Hide from memories'**
  String get albumHideMemories;

  /// Hides an album's photos from the timeline, in the album's menu; checked while it is hidden
  ///
  /// In en, this message translates to:
  /// **'Hide from timeline'**
  String get albumHideTimeline;

  /// Makes an album
  ///
  /// In en, this message translates to:
  /// **'New album'**
  String get albumNew;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Photolib'**
  String get appTitle;

  /// Backup settings: items are backed up whatever their capture date
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get backupAnyDate;

  /// Backup settings: the largest photo or video a metered network may carry
  ///
  /// In en, this message translates to:
  /// **'Largest item'**
  String get backupCap;

  /// Backup settings: a switch; backup waits until the device charges
  ///
  /// In en, this message translates to:
  /// **'Only while charging'**
  String get backupCharging;

  /// When a backup last left nothing waiting; time is a date and time
  ///
  /// In en, this message translates to:
  /// **'Last complete backup {time}'**
  String backupCompleted(String time);

  /// When the device last reached the server, shown while backup waits for it; time is a date and time
  ///
  /// In en, this message translates to:
  /// **'Last contact with the server {time}'**
  String backupContact(String time);

  /// Backup settings: the switch that turns backup on
  ///
  /// In en, this message translates to:
  /// **'Back up this device'**
  String get backupEnabled;

  /// The answer to a new folder: do not back it up
  ///
  /// In en, this message translates to:
  /// **'Not this one'**
  String get backupFolderNo;

  /// The answer to a new folder: back it up
  ///
  /// In en, this message translates to:
  /// **'Back it up'**
  String get backupFolderYes;

  /// A number of hours, abbreviated
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String backupHours(int count);

  /// Backup settings: a heading over what a metered network may carry
  ///
  /// In en, this message translates to:
  /// **'On metered networks, such as mobile data or a hotspot'**
  String get backupMetered;

  /// No backup has left nothing waiting yet
  ///
  /// In en, this message translates to:
  /// **'No complete backup yet'**
  String get backupNever;

  /// Asked once for each new folder; name is the folder
  ///
  /// In en, this message translates to:
  /// **'New folder {name}: back it up?'**
  String backupNewFolder(String name);

  /// Backup settings: a metered network may carry items of any size
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get backupNoLimit;

  /// Every item chosen is backed up
  ///
  /// In en, this message translates to:
  /// **'Nothing waits'**
  String get backupNothing;

  /// Starts a backup at once
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// A notification: backup has not completed for that long; items is a count of items
  ///
  /// In en, this message translates to:
  /// **'No complete backup for {hours} h. Waiting: {items}'**
  String backupOverdue(int hours, String items);

  /// The title of the notification that backup is overdue
  ///
  /// In en, this message translates to:
  /// **'Backup has not completed'**
  String get backupOverdueTitle;

  /// How many items wait to be backed up; items is a count of items
  ///
  /// In en, this message translates to:
  /// **'Waiting: {items}'**
  String backupPending(String items);

  /// When a failed backup is tried again; time is a date and time
  ///
  /// In en, this message translates to:
  /// **'Trying again {time}'**
  String backupRetry(String time);

  /// Backup settings: a switch; backup runs on a roaming mobile network
  ///
  /// In en, this message translates to:
  /// **'Back up while roaming'**
  String get backupRoaming;

  /// Backup needs a server; shown while the app is signed in to none
  ///
  /// In en, this message translates to:
  /// **'Sign in to a server to back up this device'**
  String get backupSignIn;

  /// A notice on the home screen that stays until the person signs in again
  ///
  /// In en, this message translates to:
  /// **'Backup stopped: the server signed this device out. Sign in again in Settings.'**
  String get backupSignedOut;

  /// Backup settings: items taken before this date are not backed up
  ///
  /// In en, this message translates to:
  /// **'Taken since'**
  String get backupSince;

  /// Why the last backup run stopped or sent nothing; code is the server's reason code
  ///
  /// In en, this message translates to:
  /// **'{reason, select, offline{Backup waits until the server is in reach} charging{Backup waits until the device charges} battery_low{Backup waits: the battery is low} roaming{Backup waits while roaming} quota{Backup stopped: your storage on the server is full} second_factor{Backup stopped: the server asks this account for a second factor} other{Backup stopped: the server answered {code}}}'**
  String backupStopped(String reason, String code);

  /// The settings page of backup, and its entry in Settings
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupTitle;

  /// Backup settings: a heading over the items that are not backed up, by why
  ///
  /// In en, this message translates to:
  /// **'Not backed up'**
  String get backupWaiting;

  /// Backup settings: after how many hours without a complete backup the device warns
  ///
  /// In en, this message translates to:
  /// **'Warn when not complete for'**
  String get backupWarnAfter;

  /// Backup settings: a heading over the folders, media types and date chosen
  ///
  /// In en, this message translates to:
  /// **'What to back up'**
  String get backupWhat;

  /// Why items are not backed up; code is the server's reason code
  ///
  /// In en, this message translates to:
  /// **'{reason, select, folder_excluded{In a folder you did not choose} folder_new{In a new folder: choose whether to back it up} type_excluded{A kind of item you did not choose} before_date{Taken before the date you chose} selected{Waiting for its turn} server_restored{The server lost it in a restore: sending it again} working{Being backed up} waiting_for_icloud{Waiting for iCloud to download it} metered{Waiting for a network that is not metered} metered_cap{Too large for a metered network} unreadable{This device cannot read it} changed{It changed while it was sent} quota{Your storage on the server is full} other{The server refused it: {code}}}'**
  String backupWhy(String reason, String code);

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The server no longer works with this version of Photolib.'**
  String get checkAppTooOld;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Update Photolib.'**
  String get checkAppTooOldNext;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The server\'s certificate is not the one you trusted.'**
  String get checkChanged;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'If your administrator replaced it, trust the new one. If not, someone may be listening in: do not go on.'**
  String get checkChangedNext;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'This device\'s clock and the server\'s differ by more than five minutes.'**
  String get checkClock;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Let your device set its date and time automatically.'**
  String get checkClockNext;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The server\'s name does not lead to an address.'**
  String get checkDnsFailed;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Check the address, or connect to the network the server is on.'**
  String get checkDnsFailedNext;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The server\'s certificate expired on {date}.'**
  String checkExpired(String date);

  /// The connection check: what a screen reader says of a step that failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get checkFailed;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'You are on a metered network, such as mobile data.'**
  String get checkMetered;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Connect to Wi-Fi before large backups.'**
  String get checkMeteredNext;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'Something other than Photolib answers, such as a proxy\'s error page or a Wi-Fi sign-in page.'**
  String get checkNotPhotolib;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Sign in to the Wi-Fi in your browser, or ask your administrator to check the proxy.'**
  String get checkNotPhotolibNext;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'A different Photolib server answers at this address.'**
  String get checkOtherServer;

  /// The connection check: what a screen reader says of a step that passed
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get checkPassed;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'Nothing answers at this address.'**
  String get checkRefused;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Check that the server is running and that you are on its network or VPN.'**
  String get checkRefusedNext;

  /// Opens the connection check
  ///
  /// In en, this message translates to:
  /// **'Check the connection'**
  String get checkRun;

  /// The connection check: what a screen reader says of a step under way
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get checkRunning;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The server uses a certificate of its own, which this device does not know yet.'**
  String get checkSelfSigned;

  /// The connection check: a step that did not run, as an earlier one failed or it does not apply
  ///
  /// In en, this message translates to:
  /// **'Not checked'**
  String get checkSkipped;

  /// The connection check: whether the server takes this device's session
  ///
  /// In en, this message translates to:
  /// **'Your sign-in'**
  String get checkStepAuth;

  /// The connection check: the device's clock against the server's
  ///
  /// In en, this message translates to:
  /// **'Your device\'s clock'**
  String get checkStepClock;

  /// The connection check: the step that resolves the server's name
  ///
  /// In en, this message translates to:
  /// **'Finding the server\'s address'**
  String get checkStepDns;

  /// The connection check: whether the network is metered
  ///
  /// In en, this message translates to:
  /// **'Your network'**
  String get checkStepNetwork;

  /// The connection check: whether Photolib answers, and which server
  ///
  /// In en, this message translates to:
  /// **'Photolib on the server'**
  String get checkStepServer;

  /// The connection check: the step that connects to it
  ///
  /// In en, this message translates to:
  /// **'Reaching the server'**
  String get checkStepTcp;

  /// The connection check: the TLS step
  ///
  /// In en, this message translates to:
  /// **'Secure connection and certificate'**
  String get checkStepTls;

  /// The connection check: whether a proxy refuses large requests
  ///
  /// In en, this message translates to:
  /// **'Large uploads through proxies'**
  String get checkStepUpload;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The server takes too long to answer.'**
  String get checkTimedOut;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Check your connection, then try again.'**
  String get checkTimedOutNext;

  /// Title of the page that checks the connection to the server step by step
  ///
  /// In en, this message translates to:
  /// **'Connection check'**
  String get checkTitle;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The secure connection failed.'**
  String get checkTlsFailed;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Trust it only if its fingerprint matches your server\'s.'**
  String get checkTrustNext;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'The server\'s certificate comes from an authority this device does not trust.'**
  String get checkUntrusted;

  /// The connection check: the cause of a failed step
  ///
  /// In en, this message translates to:
  /// **'A proxy on the way refuses large uploads, so backups go slower, in small pieces.'**
  String get checkUploadCap;

  /// The connection check: the next step
  ///
  /// In en, this message translates to:
  /// **'Ask your administrator to let requests of 64 MB through the proxy.'**
  String get checkUploadCapNext;

  /// No description provided for @collectionAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get collectionAlbums;

  /// No description provided for @collectionHide.
  ///
  /// In en, this message translates to:
  /// **'Hide {name}'**
  String collectionHide(String name);

  /// No description provided for @collectionMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move {name} down'**
  String collectionMoveDown(String name);

  /// No description provided for @collectionMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move {name} up'**
  String collectionMoveUp(String name);

  /// No description provided for @collectionPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get collectionPeople;

  /// No description provided for @collectionPin.
  ///
  /// In en, this message translates to:
  /// **'Pin {name}'**
  String collectionPin(String name);

  /// No description provided for @collectionPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get collectionPlaces;

  /// No description provided for @collectionShow.
  ///
  /// In en, this message translates to:
  /// **'Show {name}'**
  String collectionShow(String name);

  /// No description provided for @collectionTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get collectionTags;

  /// No description provided for @collectionUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin {name}'**
  String collectionUnpin(String name);

  /// No description provided for @collectionsCustomise.
  ///
  /// In en, this message translates to:
  /// **'Customise'**
  String get collectionsCustomise;

  /// No description provided for @collectionsDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get collectionsDone;

  /// A searchable list of every command, opened with Ctrl+K
  ///
  /// In en, this message translates to:
  /// **'Command palette'**
  String get commandPalette;

  /// No description provided for @commandPaletteHint.
  ///
  /// In en, this message translates to:
  /// **'Type a command'**
  String get commandPaletteHint;

  /// The first choice of Settings' date format list: dates are laid out the way the app's language does
  ///
  /// In en, this message translates to:
  /// **'Language default'**
  String get dateFormatDefault;

  /// A choice of Settings' date format list: dates as day, month, year, in the app's language
  ///
  /// In en, this message translates to:
  /// **'Day-month-year'**
  String get dateFormatDmy;

  /// A choice of Settings' date format list: dates as month, day, year, in the app's language
  ///
  /// In en, this message translates to:
  /// **'Month-day-year'**
  String get dateFormatMdy;

  /// A choice of Settings' date format list: dates as year, month, day, in the app's language
  ///
  /// In en, this message translates to:
  /// **'Year-month-day'**
  String get dateFormatYmd;

  /// A line of the delete dialog: how many selected items are on this device and backed up on the server, followed by their size
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 on this device and backed up} other{{count} on this device and backed up}}'**
  String deleteBoth(int count);

  /// A line of the delete dialog: how many selected items are only on this device, never backed up, followed by their size
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 only on this device, not backed up} other{{count} only on this device, not backed up}}'**
  String deleteDevice(int count);

  /// A note of the delete dialog on Apple devices: with iCloud Photos, deleting in Apple Photos deletes everywhere
  ///
  /// In en, this message translates to:
  /// **'With iCloud Photos on, items deleted from this device also leave iCloud and your other Apple devices.'**
  String get deleteICloud;

  /// A line of the delete dialog: how many selected items are only in the library on the server, followed by their size
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 only in your library} other{{count} only in your library}}'**
  String deleteLibrary(int count);

  /// The delete dialog's choice that removes only the device copies of backed-up items; the library keeps them
  ///
  /// In en, this message translates to:
  /// **'Remove from this device'**
  String get deleteRemove;

  /// Under Remove from this device: what it removes
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{The backed-up item; your library keeps it} other{The {count} backed-up items; your library keeps them}}'**
  String deleteRemoveWhat(int count);

  /// A note of the delete dialog: deleted device copies go to the system trash, so their space returns only when it is emptied
  ///
  /// In en, this message translates to:
  /// **'Copies on this device go to its trash: the space returns once it is emptied.'**
  String get deleteSpaceReturns;

  /// The title of the dialog that asks what to delete
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 item?} other{Delete {count} items?}}'**
  String deleteTitle(int count);

  /// Under Move to trash: where it takes the items from, each copy into its own trash
  ///
  /// In en, this message translates to:
  /// **'{where, select, both{From this device and your library} device{From this device only} other{From your library}}'**
  String deleteTrashWhere(String where);

  /// A device folder whose items are gone, or on a card that is out; its setting stays
  ///
  /// In en, this message translates to:
  /// **'Not present'**
  String get deviceFolderAbsent;

  /// The volume of a device folder: a memory card or USB drive
  ///
  /// In en, this message translates to:
  /// **'SD card'**
  String get deviceFolderCard;

  /// Keeps a device folder out of the library
  ///
  /// In en, this message translates to:
  /// **'Exclude'**
  String get deviceFolderExclude;

  /// Keeps the folder of this photo or video out of the library
  ///
  /// In en, this message translates to:
  /// **'Exclude this folder'**
  String get deviceFolderExcludeThis;

  /// Shown once when another app opens an item of an excluded folder
  ///
  /// In en, this message translates to:
  /// **'This item\'s folder is excluded from your library'**
  String get deviceFolderExcludedNotice;

  /// Forgets a device folder that is not present, and its setting
  ///
  /// In en, this message translates to:
  /// **'Remove from the list'**
  String get deviceFolderForget;

  /// The volume of a device folder: the phone's own storage
  ///
  /// In en, this message translates to:
  /// **'Internal storage'**
  String get deviceFolderInternal;

  /// Keeps a new device folder in the library
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get deviceFolderKeep;

  /// A device folder that appeared after the library was first indexed; items is how many photos and videos it holds, such as '312 items'
  ///
  /// In en, this message translates to:
  /// **'{name}, {items}, is new'**
  String deviceFolderNew(String name, String items);

  /// Settings: the folders of the phone and its cards, each shown in the library or excluded
  ///
  /// In en, this message translates to:
  /// **'Device folders'**
  String get deviceFolders;

  /// How the library picks device folders: every folder, new ones too, but those excluded
  ///
  /// In en, this message translates to:
  /// **'Show all folders except the excluded'**
  String get deviceFoldersAll;

  /// How the library picks device folders: only those chosen; new ones are not shown
  ///
  /// In en, this message translates to:
  /// **'Show only the chosen folders'**
  String get deviceFoldersChosen;

  /// Said once folders were excluded from the library
  ///
  /// In en, this message translates to:
  /// **'Excluded from the library'**
  String get deviceFoldersExcludedNow;

  /// The hint of the device folders' search box
  ///
  /// In en, this message translates to:
  /// **'Search folders'**
  String get deviceFoldersSearch;

  /// Settings switch that shows Diagnostics in a release build
  ///
  /// In en, this message translates to:
  /// **'Show diagnostics'**
  String get diagnosticsAdvanced;

  /// The log filter that shows every logger
  ///
  /// In en, this message translates to:
  /// **'All loggers'**
  String get diagnosticsAllLoggers;

  /// No description provided for @diagnosticsCopied.
  ///
  /// In en, this message translates to:
  /// **'Log copied'**
  String get diagnosticsCopied;

  /// Copies the log records the filters show
  ///
  /// In en, this message translates to:
  /// **'Copy the log shown'**
  String get diagnosticsCopy;

  /// No description provided for @diagnosticsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No log entries yet'**
  String get diagnosticsEmpty;

  /// Saves or shares the diagnostic bundle for a bug report: logs, versions, settings, library counts
  ///
  /// In en, this message translates to:
  /// **'Export diagnostic bundle'**
  String get diagnosticsExport;

  /// No description provided for @diagnosticsExported.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic bundle saved'**
  String get diagnosticsExported;

  /// No description provided for @diagnosticsLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get diagnosticsLevel;

  /// No description provided for @diagnosticsLogger.
  ///
  /// In en, this message translates to:
  /// **'Logger'**
  String get diagnosticsLogger;

  /// No description provided for @diagnosticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnosticsTitle;

  /// Saves the photo or video shown, or those selected, as files where the user chooses
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// A choice of what to download: the photo as edited
  ///
  /// In en, this message translates to:
  /// **'Current version, with its edits'**
  String get downloadCurrent;

  /// A download stopped with an error
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download'**
  String get downloadFailed;

  /// A choice of what to download: the photo as it was before any edit
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get downloadOriginal;

  /// A download finished; name is the file saved
  ///
  /// In en, this message translates to:
  /// **'Saved {name}'**
  String downloadSaved(String name);

  /// Asks whether to download the edited photo or its original
  ///
  /// In en, this message translates to:
  /// **'Which version?'**
  String get downloadVersion;

  /// A download under way, with a progress bar and a cancel button
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Downloading 1 item} other{Downloading {count} items}}'**
  String downloading(int count);

  /// Improves the photo being edited in one tap: its exposure, colour balance and contrast
  ///
  /// In en, this message translates to:
  /// **'Auto-enhance'**
  String get editorAutoEnhance;

  /// Chooses the shape of the crop of the photo being edited; also names the crop frame dragged over it
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get editorCrop;

  /// A crop shape: the whole photo, uncropped
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get editorCropOriginal;

  /// A crop shape: a square, as large as the photo allows
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get editorCropSquare;

  /// Opens the photo shown full screen in the editor; the editor's title
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editorEdit;

  /// Mirrors the photo being edited left to right
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get editorFlip;

  /// Turns the photo being edited a quarter turn counter-clockwise
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get editorRotate;

  /// Saves the edited photo as a new file beside the original, which stays as it was
  ///
  /// In en, this message translates to:
  /// **'Save copy'**
  String get editorSaveCopy;

  /// Says that the edited photo could not be saved; the original is unchanged
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the copy'**
  String get editorSaveFailed;

  /// Saves the edit of a photo of the library as a new version of it; the original stays as it was
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editorSaveVersion;

  /// Says that the edit was saved as a new photo beside the original
  ///
  /// In en, this message translates to:
  /// **'Saved as a copy'**
  String get editorSaved;

  /// Says that the edit could not be saved as a new version of the photo
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the version'**
  String get editorVersionFailed;

  /// Says that the edit was saved as a new version of the photo, which every device shows once the server has made it
  ///
  /// In en, this message translates to:
  /// **'Saved as a new version'**
  String get editorVersionSaved;

  /// Says that the server in use is too old to keep an edit as a version of a photo
  ///
  /// In en, this message translates to:
  /// **'This server cannot keep versions of edited photos yet'**
  String get editorVersionsUnsupported;

  /// A banner over the library when the server refused some of the user's edits (favourites, titles, album changes) for good, so the app undid them on this device
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change was undone: the server refused it.} other{{count} changes were undone: the server refused them.}}'**
  String editsRejected(int count);

  /// The button that hides the banner about refused edits once the user has read it
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get editsRejectedDismiss;

  /// Under the refused-edits banner: why, when the user may only view what they changed, such as a shared album
  ///
  /// In en, this message translates to:
  /// **'You may view the items but not change them.'**
  String get editsRejectedForbidden;

  /// Under the refused-edits banner: why, when the server did not accept the changes for another reason
  ///
  /// In en, this message translates to:
  /// **'The server could not accept the changes.'**
  String get editsRejectedInvalid;

  /// Under the refused-edits banner: why, when what the user changed was deleted or is no longer shared with them
  ///
  /// In en, this message translates to:
  /// **'The items were deleted or are no longer shared with you.'**
  String get editsRejectedNotFound;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This page does not exist'**
  String get errorNotFound;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errorRetry;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// The accessible label of the box around a face found in the photo, numbered
  ///
  /// In en, this message translates to:
  /// **'Face {number}'**
  String faceNumber(int number);

  /// The button that agrees to the face notice
  ///
  /// In en, this message translates to:
  /// **'I agree'**
  String get facesAgree;

  /// Settings switch on desktops: describe faces with the optional AuraFace model instead of SFace
  ///
  /// In en, this message translates to:
  /// **'Describe faces with AuraFace (larger download)'**
  String get facesAura;

  /// The button that leaves the face notice or the withdrawal without a change
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get facesNotNow;

  /// Consent notice, paragraph 3: what is kept, who sees it and when it is deleted
  ///
  /// In en, this message translates to:
  /// **'What is found stays with your photos, on your devices and your server. The descriptions are never shown or shared, and everything is deleted when you stop or delete the photo.'**
  String get facesNoticeKeep;

  /// Consent notice, paragraph 4: it is optional and can be stopped at any time
  ///
  /// In en, this message translates to:
  /// **'This is optional. Everything else in Photolib works without it, and you can stop at any time in Settings.'**
  String get facesNoticeOptional;

  /// The title of the consent notice for finding faces
  ///
  /// In en, this message translates to:
  /// **'Find faces in your photos?'**
  String get facesNoticeTitle;

  /// Consent notice, paragraph 1: what is found and kept, which can count as biometric data
  ///
  /// In en, this message translates to:
  /// **'Photolib looks for faces in your photos and videos and keeps, for each one, where it is and a list of numbers that describes it, so that the same person can be found again. Such a description can count as biometric data.'**
  String get facesNoticeWhat;

  /// Consent notice, paragraph 2: where faces are processed, never by a third party
  ///
  /// In en, this message translates to:
  /// **'This happens on this device and, if you are signed in, on your own server. Never on a service run by us or anyone else.'**
  String get facesNoticeWhere;

  /// A message: the server could not be told the answer to the face notice
  ///
  /// In en, this message translates to:
  /// **'Your server could not be told. Try again.'**
  String get facesServerFailed;

  /// The user's server finds no faces for the account
  ///
  /// In en, this message translates to:
  /// **'Your server finds no faces for you'**
  String get facesServerOff;

  /// The user's server finds faces for the account
  ///
  /// In en, this message translates to:
  /// **'Your server finds faces for you'**
  String get facesServerOn;

  /// The user's server does not offer face recognition to the account (policy)
  ///
  /// In en, this message translates to:
  /// **'Your server does not offer face recognition'**
  String get facesServerUnavailable;

  /// Faces on this device: the face models download, this far
  ///
  /// In en, this message translates to:
  /// **'Downloading the face models: {percent}%'**
  String facesStatusDownloading(int percent);

  /// Faces on this device wait: the user's server has not installed the face models
  ///
  /// In en, this message translates to:
  /// **'Your server has not installed the face models'**
  String get facesStatusMissing;

  /// Faces on this device cannot be found: the desktop app found no libvips to decode photos with
  ///
  /// In en, this message translates to:
  /// **'Face finding is unavailable: the image library (libvips) was not found. Reinstall Photolib, or install libvips and restart it.'**
  String get facesStatusNoDecoder;

  /// Faces on this device are being found, as far as its gates let it
  ///
  /// In en, this message translates to:
  /// **'Finding faces on this device'**
  String get facesStatusRunning;

  /// Faces on this device cannot be found: no model file for this platform, or a failed download
  ///
  /// In en, this message translates to:
  /// **'Faces cannot be found on this device'**
  String get facesStatusUnavailable;

  /// Faces on this device: the face models wait for an unmetered network
  ///
  /// In en, this message translates to:
  /// **'The face models download on Wi-Fi'**
  String get facesStatusWaiting;

  /// Settings switch: find the faces in the photos, after the user agrees to the notice
  ///
  /// In en, this message translates to:
  /// **'Find faces in my photos'**
  String get facesSwitch;

  /// Under the faces switch while it is off: nothing about faces is computed
  ///
  /// In en, this message translates to:
  /// **'Off. Nothing about faces is computed until you agree.'**
  String get facesSwitchOff;

  /// Under the faces switch while it is on
  ///
  /// In en, this message translates to:
  /// **'On. Photolib finds the faces in your photos.'**
  String get facesSwitchOn;

  /// A heading of Settings: finding the faces in photos, which the user must agree to
  ///
  /// In en, this message translates to:
  /// **'Faces and people'**
  String get facesTitle;

  /// The button that deletes the faces found and stops finding them
  ///
  /// In en, this message translates to:
  /// **'Delete and stop'**
  String get facesWithdraw;

  /// What stopping to find faces deletes
  ///
  /// In en, this message translates to:
  /// **'This deletes every face, description and person Photolib found for you, on this device and on your server. Your photos are not changed.'**
  String get facesWithdrawBody;

  /// The title of the confirmation of stopping to find faces
  ///
  /// In en, this message translates to:
  /// **'Stop finding faces?'**
  String get facesWithdrawTitle;

  /// A file size; the units are powers of 1000 bytes
  ///
  /// In en, this message translates to:
  /// **'{size} {unit, select, kB{kB} MB{MB} GB{GB} TB{TB} other{B}}'**
  String fileSize(double size, String unit);

  /// After a rename, a move or a deletion: how many files kept their name and place because something went wrong
  ///
  /// In en, this message translates to:
  /// **'Files not changed: {count}'**
  String filesFailed(int count);

  /// Asks the browser or the system again for access to a folder it no longer lets the app read
  ///
  /// In en, this message translates to:
  /// **'Allow access to this folder'**
  String get folderAllow;

  /// Moves the photos and videos of a folder to the trash, after asking
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get folderDelete;

  /// Asks before a folder's photos and videos go to the trash; their number shows below
  ///
  /// In en, this message translates to:
  /// **'Move the photos and videos in {name} to the trash?'**
  String folderDeleteBody(String name);

  /// How many photos and videos of a folder are in the library
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String folderItems(int count);

  /// Makes a folder: of albums, or on a disk
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get folderNew;

  /// A folder that cannot be read now, such as one on an unplugged drive; its items stay in the library
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Offline, 1 item} other{Offline, {count} items}}'**
  String folderOffline(int count);

  /// No description provided for @folderOverlaps.
  ///
  /// In en, this message translates to:
  /// **'This folder is already in the library, or inside or around one that is'**
  String get folderOverlaps;

  /// No description provided for @folderRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove folder'**
  String get folderRemove;

  /// No description provided for @folderRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'The photos and videos of {folder} leave the library. The files stay on disk, untouched.'**
  String folderRemoveBody(String folder);

  /// Confirms removing a folder from the library
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get folderRemoveConfirm;

  /// A folder being scanned, and how many photos and videos the scan has found
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Scanning, 1 item so far} other{Scanning, {count} items so far}}'**
  String folderScanning(int count);

  /// The banner's button that asks the user to pick a folder the app can no longer read again, which gives the access back
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get foldersAllow;

  /// Hides again the folders hidden by default
  ///
  /// In en, this message translates to:
  /// **'Hide excluded folders'**
  String get foldersHideExcluded;

  /// A banner over the library when the system no longer lets the app read folders the user added, so their photos cannot show
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Photolib can no longer read 1 folder.} other{Photolib can no longer read {count} folders.}}'**
  String foldersLost(int count);

  /// Shows the folders hidden by default: music, album art, app caches and app-private folders
  ///
  /// In en, this message translates to:
  /// **'Show excluded folders ({count})'**
  String foldersShowExcluded(int count);

  /// Shown in the empty library by browsers without File System Access, which cannot add folders
  ///
  /// In en, this message translates to:
  /// **'This browser cannot keep a folder as your library. Open Photolib in Chrome or Edge on a computer, or use the desktop app.'**
  String get foldersUnsupported;

  /// A section of the component gallery
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get galleryButtons;

  /// A section of the component gallery
  ///
  /// In en, this message translates to:
  /// **'Chips'**
  String get galleryChips;

  /// A section of the component gallery
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get galleryGrid;

  /// A section of the component gallery
  ///
  /// In en, this message translates to:
  /// **'Menus and sheets'**
  String get galleryMenus;

  /// A button of the component gallery that opens a bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Show a sheet'**
  String get galleryShowSheet;

  /// The component gallery, a tool for developers that shows every control of the app
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get galleryTitle;

  /// No description provided for @hiddenCollections.
  ///
  /// In en, this message translates to:
  /// **'Hidden ({count})'**
  String hiddenCollections(int count);

  /// Settings switch: the model for on-device indexing downloads over mobile (metered) data too, not only Wi-Fi
  ///
  /// In en, this message translates to:
  /// **'Download over mobile data'**
  String get indexingAllowMetered;

  /// Settings switch: indexing on this device runs in power saving mode (battery saver, Low Power Mode) too
  ///
  /// In en, this message translates to:
  /// **'Also in power saving mode'**
  String get indexingAllowSaver;

  /// Settings: the battery level, chosen beside it, below which indexing on this device waits for a charger
  ///
  /// In en, this message translates to:
  /// **'Battery needed without a charger'**
  String get indexingBattery;

  /// Settings switch: indexing on this device runs only while it charges
  ///
  /// In en, this message translates to:
  /// **'Only while charging'**
  String get indexingChargingOnly;

  /// Indexing on this device: the search model downloads, this far
  ///
  /// In en, this message translates to:
  /// **'Downloading the search model: {percent}%'**
  String indexingDownloading(int percent);

  /// Indexing on this device: photos it could not read; a tap lists them
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo could not be read} other{{count} photos could not be read}}'**
  String indexingFailed(int count);

  /// Indexing on this device: a device with little memory indexes only new photos and uses results from other devices
  ///
  /// In en, this message translates to:
  /// **'This device indexes only its new photos'**
  String get indexingLite;

  /// Indexing on this device waits: the user's server has not installed the search model the app downloads from it
  ///
  /// In en, this message translates to:
  /// **'Your server has not installed the search model'**
  String get indexingMissing;

  /// Settings switch: download the search model and index photos on this device, with the user's consent
  ///
  /// In en, this message translates to:
  /// **'Search on this device'**
  String get indexingModels;

  /// Under the switch to search on this device: the model's size and the host it downloads from
  ///
  /// In en, this message translates to:
  /// **'Downloads the search model ({megabytes} MB) from {host}'**
  String indexingModelsFrom(int megabytes, String host);

  /// On-device search and text reading cannot run: the desktop app found no libvips to decode photos with
  ///
  /// In en, this message translates to:
  /// **'Search and text reading are unavailable: the image library (libvips) was not found. Reinstall Photolib, or install libvips and restart it.'**
  String get indexingNoDecoder;

  /// Indexing on this device waits: the battery is below the threshold and no charger is plugged in
  ///
  /// In en, this message translates to:
  /// **'Paused while the battery is below {percent}%'**
  String indexingPausedBattery(int percent);

  /// Indexing on this device waits: it runs only while charging, and the device is not
  ///
  /// In en, this message translates to:
  /// **'Paused until the device charges'**
  String get indexingPausedCharger;

  /// Indexing on this device waits: the device is too warm
  ///
  /// In en, this message translates to:
  /// **'Paused while the device is hot'**
  String get indexingPausedHeat;

  /// Indexing on this device waits: battery saver (power saving, Low Power Mode) is on
  ///
  /// In en, this message translates to:
  /// **'Paused while battery saver is on'**
  String get indexingPausedSaver;

  /// A battery level in the threshold's menu
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String indexingPercent(int percent);

  /// How far indexing on this device is: photos indexed, of all the library shows
  ///
  /// In en, this message translates to:
  /// **'Photos indexed: {done} of {total}'**
  String indexingProgress(int done, int total);

  /// Settings switch: download the text models and read the words in photos on this device, with the user's consent
  ///
  /// In en, this message translates to:
  /// **'Read text in photos'**
  String get indexingText;

  /// Reading text on this device: the text models download, this far
  ///
  /// In en, this message translates to:
  /// **'Downloading the text models: {percent}%'**
  String indexingTextDownloading(int percent);

  /// Under the switch to read text on this device: the models' size and the host they download from
  ///
  /// In en, this message translates to:
  /// **'Downloads the text models ({megabytes} MB) from {host}; finds the words in your photos'**
  String indexingTextFrom(int megabytes, String host);

  /// Reading text on this device waits: the user's server has not installed the text models the app downloads from it
  ///
  /// In en, this message translates to:
  /// **'Your server has not installed the text models'**
  String get indexingTextMissing;

  /// Under the switch to read text on a phone: its own text recognition (ML Kit, Vision) reads, so there is no download
  ///
  /// In en, this message translates to:
  /// **'Uses your phone\'s own text recognition; nothing to download. Reads new photos'**
  String get indexingTextPlatform;

  /// How far reading text on this device is: photos read, of all the library shows
  ///
  /// In en, this message translates to:
  /// **'Photos read for text: {done} of {total}'**
  String indexingTextProgress(int done, int total);

  /// Reading text on this device cannot run: no model file for it, or its download failed
  ///
  /// In en, this message translates to:
  /// **'Reading text is not available here'**
  String get indexingTextUnavailable;

  /// Reading text on this device waits: the text models download only on Wi-Fi (an unmetered network)
  ///
  /// In en, this message translates to:
  /// **'The text models download on Wi-Fi'**
  String get indexingTextWaiting;

  /// Indexing on this device cannot run: no model file for it, or its download failed
  ///
  /// In en, this message translates to:
  /// **'Search on this device is not available here'**
  String get indexingUnavailable;

  /// Indexing on this device waits: the search model downloads only on Wi-Fi (an unmetered network)
  ///
  /// In en, this message translates to:
  /// **'The search model downloads on Wi-Fi'**
  String get indexingWaiting;

  /// Under the round picture of a face nobody has named yet
  ///
  /// In en, this message translates to:
  /// **'Add name'**
  String get infoAddName;

  /// Opens a field that adds a tag, typed as a path such as Travel/Greece/Hydra, to a photo
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get infoAddTag;

  /// Heading of the albums a photo is in, in its info
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get infoAlbums;

  /// Opens every field the app knows of a photo
  ///
  /// In en, this message translates to:
  /// **'View all metadata'**
  String get infoAllMetadata;

  /// Marks a smart or tag album, which fills itself, in a photo's list of albums
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get infoAuto;

  /// Says, beside 'On this device', that the photo is also backed up to the server
  ///
  /// In en, this message translates to:
  /// **'Backed up'**
  String get infoBackedUp;

  /// The heading of the camera that took a photo or video, in its info
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get infoCamera;

  /// In the edit history: what a version changed, the exposure, white balance, contrast or colours
  ///
  /// In en, this message translates to:
  /// **'Adjusted colours'**
  String get infoChangeAdjust;

  /// In the edit history: what a version changed, the photo was cropped
  ///
  /// In en, this message translates to:
  /// **'Cropped'**
  String get infoChangeCrop;

  /// In the edit history: what a version changed, the photo was mirrored
  ///
  /// In en, this message translates to:
  /// **'Mirrored'**
  String get infoChangeFlip;

  /// In the edit history: what a version changed, an area of the photo was filled in
  ///
  /// In en, this message translates to:
  /// **'Filled an area'**
  String get infoChangeInpaint;

  /// In the edit history: what a version changed, the colours of only a part of the photo
  ///
  /// In en, this message translates to:
  /// **'Adjusted an area'**
  String get infoChangeLocal;

  /// In the edit history: what a version changed, a colour look (filter) was applied
  ///
  /// In en, this message translates to:
  /// **'Applied a colour look'**
  String get infoChangeLut;

  /// In the edit history: what a version changed, when nothing more specific is known
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get infoChangeOther;

  /// In the edit history: what a version changed, the photo was rotated
  ///
  /// In en, this message translates to:
  /// **'Rotated'**
  String get infoChangeTurn;

  /// Shows the original of an edited photo in its place while on
  ///
  /// In en, this message translates to:
  /// **'Compare with original'**
  String get infoCompare;

  /// How sure Photolib is of the capture date, as a percentage
  ///
  /// In en, this message translates to:
  /// **'Confidence: {percent}'**
  String infoConfidence(String percent);

  /// Copies the full path of a photo's file
  ///
  /// In en, this message translates to:
  /// **'Copy path'**
  String get infoCopyPath;

  /// Marks the version of a photo that shows now, in its edit history
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get infoCurrent;

  /// Placeholder of the field at the top of a photo's info where the user writes a description of it
  ///
  /// In en, this message translates to:
  /// **'Add a description'**
  String get infoDescription;

  /// Changes when a photo was taken
  ///
  /// In en, this message translates to:
  /// **'Edit the date'**
  String get infoEditDate;

  /// The name of a version of an edited photo that its author gave no name, in the edit history
  ///
  /// In en, this message translates to:
  /// **'Edit {number}'**
  String infoEditNumber(int number);

  /// Says that the photo shown is an edited copy of another; a tap shows that one
  ///
  /// In en, this message translates to:
  /// **'Edited copy of {name}'**
  String infoEditedCopyOf(String name);

  /// A heading of the info panel: the faces found in the photo
  ///
  /// In en, this message translates to:
  /// **'Faces'**
  String get infoFaces;

  /// The heading of a photo or video's file name, folder, size and type, in its info
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get infoFile;

  /// Says, under a photo's date, that the date was read in the file's name rather than in the photo
  ///
  /// In en, this message translates to:
  /// **'from file name'**
  String get infoFromFileName;

  /// Opens the list of a photo's edited versions
  ///
  /// In en, this message translates to:
  /// **'Edit history'**
  String get infoHistory;

  /// How many photos and videos an album holds
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} item} other{{count} items}}'**
  String infoItems(int count);

  /// The heading of where a photo or video was taken, in its info
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get infoLocation;

  /// What a screen reader says of the small map in the info of a photo or video
  ///
  /// In en, this message translates to:
  /// **'Map of where it was taken'**
  String get infoMap;

  /// Shown in a photo's info before its map loads for the first time: the map's tiles are fetched from the internet, which reveals the area looked at
  ///
  /// In en, this message translates to:
  /// **'Map tiles come from the internet and show which area you look at'**
  String get infoMapAgree;

  /// A photo's size in megapixels, as 34 MP
  ///
  /// In en, this message translates to:
  /// **'{megapixels} MP'**
  String infoMegapixels(String megapixels);

  /// Offers to make a tag that does not exist yet, with the levels its path names
  ///
  /// In en, this message translates to:
  /// **'New tag: {path}'**
  String infoNewTag(String path);

  /// Under Albums in a photo's info when it is in none
  ///
  /// In en, this message translates to:
  /// **'Not in any album'**
  String get infoNoAlbum;

  /// Where a photo or video is kept: only on this phone or computer, not on a server
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get infoOnDevice;

  /// The name of the first version of a photo, the one that was taken, in the edit history
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get infoOriginal;

  /// The width and height of a photo or video
  ///
  /// In en, this message translates to:
  /// **'{width} × {height} pixels'**
  String infoPixels(int width, int height);

  /// Takes the photo out of one album, named, and no other
  ///
  /// In en, this message translates to:
  /// **'Remove from {album}'**
  String infoRemoveFrom(String album);

  /// Takes one tag, named, off the photo
  ///
  /// In en, this message translates to:
  /// **'Remove {tag}'**
  String infoRemoveTag(String tag);

  /// Says for 5 seconds, with Undo, that the photo left an album
  ///
  /// In en, this message translates to:
  /// **'Removed from {album}'**
  String infoRemovedFrom(String album);

  /// Makes an older version of a photo the one that shows again
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get infoRevert;

  /// Saves one version of a photo as a photo of its own
  ///
  /// In en, this message translates to:
  /// **'Save as copy'**
  String get infoSaveCopy;

  /// Says an album in a photo's list of albums is shared with others
  ///
  /// In en, this message translates to:
  /// **'shared'**
  String get infoShared;

  /// Keeps the outlines of every face visible on the photo
  ///
  /// In en, this message translates to:
  /// **'Show faces on the photo'**
  String get infoShowFaces;

  /// Agrees once to load maps from the internet and shows the photo's map
  ///
  /// In en, this message translates to:
  /// **'Show map'**
  String get infoShowMap;

  /// Heading of a photo's tags, in its info
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get infoTags;

  /// Under Edit history: how many versions a photo has and when the last was made
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} version} other{{count} versions}} · last {time}'**
  String infoVersions(int count, String time);

  /// Opens the explanation of where the capture date of a photo or video comes from
  ///
  /// In en, this message translates to:
  /// **'Why this date?'**
  String get infoWhy;

  /// Where the capture date of a photo or video comes from; the tag names the field of the file's metadata, such as exif:DateTimeOriginal
  ///
  /// In en, this message translates to:
  /// **'{source, select, metadata{Read in the file, as {tag}} name{Read in the file name} folder{Read in the name of a folder} host{Given by the service the file came from} unknown{Nothing in the file dates it, so the date it last changed stands in} other{The file is not read yet, so the date the device gives stands in}}'**
  String infoWhyBecause(String source, String tag);

  /// How a folder or an album shows its items: a list of names, sizes and dates, or a grid of thumbnails
  ///
  /// In en, this message translates to:
  /// **'{list, select, true{List} other{Grid}}'**
  String itemLayout(String list);

  /// What a folder or an album sorts its items by; type is the file name extension, album order the order the user gave
  ///
  /// In en, this message translates to:
  /// **'{sort, select, name{Name} taken{Date taken} modified{Date modified} size{Size} random{Random} extension{Type} custom{Album order} other{Date taken}}'**
  String itemSort(String sort);

  /// The Alt key (Option on Apple keyboards), as keyboards label it
  ///
  /// In en, this message translates to:
  /// **'Alt'**
  String get keyAlt;

  /// The Control key, as keyboards label it
  ///
  /// In en, this message translates to:
  /// **'Ctrl'**
  String get keyControl;

  /// The Command key of Apple keyboards
  ///
  /// In en, this message translates to:
  /// **'Cmd'**
  String get keyMeta;

  /// The Shift key, as keyboards label it
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get keyShift;

  /// The first choice of Settings' language list: the app shows the language the device or the system's per-app setting chose
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageDevice;

  /// This translation's language, named in itself and its own script (Deutsch, 日本語), as Settings' language list shows it to anyone: never its name in English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// Opens the system's folder picker to add a folder of photos and videos to the library
  ///
  /// In en, this message translates to:
  /// **'Add folder'**
  String get libraryAddFolder;

  /// Where a photo is, as its badge says and the library's filter shows: only on this device, also on the server, or only on the server; other is the filter that shows all. Every client uses this wording
  ///
  /// In en, this message translates to:
  /// **'{state, select, not_backed_up{Not backed up} backed_up{Backed up} cloud_only{Cloud only} other{All}}'**
  String libraryBackup(String state);

  /// Says the library's filter by backup state finds nothing
  ///
  /// In en, this message translates to:
  /// **'{state, select, not_backed_up{Everything is backed up} backed_up{Nothing is backed up yet} cloud_only{Nothing is only on the server} other{Nothing here}}'**
  String libraryBackupEmpty(String state);

  /// Shows or hides the badges on photos that are not backed up or only on the server
  ///
  /// In en, this message translates to:
  /// **'Backup badges'**
  String get libraryBadges;

  /// No description provided for @libraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your photos will appear here'**
  String get libraryEmpty;

  /// How the library groups its photos under headings
  ///
  /// In en, this message translates to:
  /// **'{grouping, select, week{Group by week} month{Group by month} other{Group by day}}'**
  String libraryGroup(String grouping);

  /// Ends showing hidden and archived items in the library
  ///
  /// In en, this message translates to:
  /// **'Hide hidden and archived items again'**
  String get libraryHideVeiled;

  /// Shown in place of the library when the system keyring that keeps the key to its encrypted store does not answer, as on Linux without a Secret Service
  ///
  /// In en, this message translates to:
  /// **'Photolib keeps the key to your library in the system keyring, which is not running or is locked. Start or unlock a keyring, such as GNOME Keyring or KWallet, then try again.'**
  String get libraryNoKeyring;

  /// A view option: shows the items of excluded device folders, marked, for five minutes
  ///
  /// In en, this message translates to:
  /// **'Show excluded folders for 5 minutes'**
  String get libraryRevealExcluded;

  /// Shows hidden and archived items in the library for a while
  ///
  /// In en, this message translates to:
  /// **'Show hidden and archived items for 5 minutes'**
  String get libraryShowVeiled;

  /// How the library is sorted: by when each item was added to the library, or by capture date
  ///
  /// In en, this message translates to:
  /// **'{added, select, true{Recently added} other{Date taken}}'**
  String librarySort(String added);

  /// The library cannot be shown: its encrypted store on the device failed to open
  ///
  /// In en, this message translates to:
  /// **'Photolib could not open the library kept on this device'**
  String get libraryStoreFailed;

  /// The menu that sorts and groups the library
  ///
  /// In en, this message translates to:
  /// **'View options'**
  String get libraryViewOptions;

  /// Above the library while the app prepares the thumbnails of a folder it has just scanned, so that they show at once when scrolled to
  ///
  /// In en, this message translates to:
  /// **'Preparing thumbnails: {done} of {total}'**
  String libraryWarming(int done, int total);

  /// Shows fewer, larger thumbnails in the library, like a pinch out
  ///
  /// In en, this message translates to:
  /// **'Larger thumbnails'**
  String get libraryZoomIn;

  /// Shows more, smaller thumbnails in the library, like a pinch in
  ///
  /// In en, this message translates to:
  /// **'Smaller thumbnails'**
  String get libraryZoomOut;

  /// A button that draws a GPX track, a recorded route, over the map
  ///
  /// In en, this message translates to:
  /// **'Add a GPX track'**
  String get mapAddTrack;

  /// A filter chip that limits a search to the area of the map the user chose
  ///
  /// In en, this message translates to:
  /// **'Map area'**
  String get mapArea;

  /// The credit the map background's licence requires, shown on the map
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapAttribution;

  /// Removes the outline drawn around photos on the map
  ///
  /// In en, this message translates to:
  /// **'Clear the selection'**
  String get mapClearLasso;

  /// Shown on the map when none of the photos and videos has a location
  ///
  /// In en, this message translates to:
  /// **'No photos with a place yet'**
  String get mapEmpty;

  /// A switch that shows where the most photos were taken as a coloured haze over the map
  ///
  /// In en, this message translates to:
  /// **'Heatmap'**
  String get mapHeat;

  /// A button after which the user draws a loop on the map to select the photos inside it
  ///
  /// In en, this message translates to:
  /// **'Select by drawing around photos'**
  String get mapLasso;

  /// What a screen reader says while the map is loading the places of all photos
  ///
  /// In en, this message translates to:
  /// **'Placing photos on the map'**
  String get mapLoading;

  /// A marker on the map: how many photos are at this place
  ///
  /// In en, this message translates to:
  /// **'Photos: {count}'**
  String mapPhotos(int count);

  /// A button that searches the library in the area of the map that shows
  ///
  /// In en, this message translates to:
  /// **'Search this area'**
  String get mapSearchHere;

  /// A switch that shows the photos of the area under the map, in a grid
  ///
  /// In en, this message translates to:
  /// **'Show photos under the map'**
  String get mapSplit;

  /// Shown on the map before its background loads for the first time: it is fetched from the internet, which reveals the area looked at
  ///
  /// In en, this message translates to:
  /// **'The map background comes from OpenStreetMap\'s server (tile.openstreetmap.org), which sees which area you look at'**
  String get mapTilesAgree;

  /// Agrees once to load the map's background from the internet
  ///
  /// In en, this message translates to:
  /// **'Show the background'**
  String get mapTilesShow;

  /// The name of the slider that limits the map to photos taken between two dates
  ///
  /// In en, this message translates to:
  /// **'Time range'**
  String get mapTime;

  /// The title of the page that shows photos on a map, and of its entry in Collections
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// Said when the file the user chose holds no recorded route
  ///
  /// In en, this message translates to:
  /// **'That file has no GPX tracks'**
  String get mapTrackBad;

  /// A switch that draws a line through the places of the photos of each trip, in time order, on the map
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get mapTrips;

  /// What a badge on a photo says to a screen reader
  ///
  /// In en, this message translates to:
  /// **'{mark, select, favourite{Favourite} hidden{Hidden} archived{Archived} offline{Kept on this device} offline{Kept on this device} offline{Kept on this device} other{}}'**
  String mark(String mark);

  /// No description provided for @mediaAccessAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get mediaAccessAllow;

  /// No description provided for @mediaAccessNone.
  ///
  /// In en, this message translates to:
  /// **'Photolib needs access to your photos and videos to show them.'**
  String get mediaAccessNone;

  /// No description provided for @mediaAccessPartial.
  ///
  /// In en, this message translates to:
  /// **'Photolib sees only the photos and videos you selected. A gallery needs access to all of them.'**
  String get mediaAccessPartial;

  /// Opens the system's picker that changes which photos and videos Photolib may see
  ///
  /// In en, this message translates to:
  /// **'Select more photos'**
  String get mediaAccessSelect;

  /// The name of a new album or folder
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// The next step after a failure, in plain words; keep external_roots as it is
  ///
  /// In en, this message translates to:
  /// **'Add the folder to external_roots in the server\'s configuration, then restart the server.'**
  String get nextAddRoot;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Ask your server\'s administrator.'**
  String get nextAskAdmin;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Ask the library\'s owner to let you add to it.'**
  String get nextAskOwner;

  /// The next step after a failure, in plain words: the connection check names the step that fails
  ///
  /// In en, this message translates to:
  /// **'Check the connection to see why.'**
  String get nextCheckConnection;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Check what you entered and try again.'**
  String get nextCheckEntry;

  /// The next step after a failure, in plain words: confirm a dry run's count
  ///
  /// In en, this message translates to:
  /// **'Check how many items it affects, then confirm.'**
  String get nextConfirm;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Delete a webhook you no longer use, then try again.'**
  String get nextDeleteWebhook;

  /// The next step after a failure, in plain words: the administrator changes the server's configuration file
  ///
  /// In en, this message translates to:
  /// **'Change it in the server\'s configuration, then restart the server.'**
  String get nextEditConfig;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Free some space, or ask your administrator for more.'**
  String get nextFreeSpace;

  /// The next step after a failure, in plain words: a new link
  ///
  /// In en, this message translates to:
  /// **'Ask your administrator for a new one.'**
  String get nextNewLink;

  /// The next step after a failure, in plain words; keep photolibd as it is
  ///
  /// In en, this message translates to:
  /// **'Copy the newest one from photolibd\'s log.'**
  String get nextNewestToken;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Make another account an administrator first.'**
  String get nextOtherAdmin;

  /// The next step after a failure, in plain words: one no other library holds
  ///
  /// In en, this message translates to:
  /// **'Choose a folder of its own.'**
  String get nextOtherFolder;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Refresh and try again.'**
  String get nextRefresh;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Try again. If it happens again, copy the details below for your administrator.'**
  String get nextReport;

  /// The next step after a failure, in plain words: private libraries need two ways to unlock and a verified recovery kit first
  ///
  /// In en, this message translates to:
  /// **'Finish setting up private libraries in Settings, then try again.'**
  String get nextSetUpPrivate;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Sign in again.'**
  String get nextSignIn;

  /// The next step after a failure, in plain words: not with an API key
  ///
  /// In en, this message translates to:
  /// **'Sign in with your account and try again.'**
  String get nextSignInAccount;

  /// The next step after a failure, in plain words: rather than setting the server up
  ///
  /// In en, this message translates to:
  /// **'Sign in instead.'**
  String get nextSignInInstead;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Try again.'**
  String get nextTryAgain;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Update the app, then agree to the notice again.'**
  String get nextUpdateAndAgree;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Choose another one.'**
  String get nextUseAnother;

  /// The next step after a failure, in plain words; keep https:// as it is
  ///
  /// In en, this message translates to:
  /// **'Use the server\'s https:// address, or connect from the server\'s own network.'**
  String get nextUseHttps;

  /// The next step after a failure, in plain words
  ///
  /// In en, this message translates to:
  /// **'Wait a minute, then try again.'**
  String get nextWait;

  /// A button that keeps an album or a search available with no network
  ///
  /// In en, this message translates to:
  /// **'Keep offline'**
  String get offlineKeep;

  /// Keeps one photo or video whole on this device; the size is what it adds
  ///
  /// In en, this message translates to:
  /// **'Keep on this device ({size})'**
  String offlineKeepHere(String size);

  /// The state of a photo or video kept on this device
  ///
  /// In en, this message translates to:
  /// **'Kept on this device'**
  String get offlineKeptHere;

  /// A button that lets go of what was kept offline; the space returns
  ///
  /// In en, this message translates to:
  /// **'Stop keeping offline'**
  String get offlineStopKeeping;

  /// Files that are no photo or video, such as PDFs and audio, which the server keeps and lists apart for download
  ///
  /// In en, this message translates to:
  /// **'Other files'**
  String get otherFiles;

  /// Shown once on a Linux computer without a keyring service: the user chooses a passphrase that encrypts the app's keys, asked at every start
  ///
  /// In en, this message translates to:
  /// **'This computer runs no keyring (Secret Service) to keep Photolib\'s keys. Choose a passphrase of at least 10 characters to protect them: Photolib asks for it each time it starts.'**
  String get passphraseCreate;

  /// No description provided for @passphraseLabel.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get passphraseLabel;

  /// No description provided for @passphraseMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passphrases differ.'**
  String get passphraseMismatch;

  /// No description provided for @passphraseRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat the passphrase'**
  String get passphraseRepeat;

  /// No description provided for @passphraseTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 10 characters.'**
  String get passphraseTooShort;

  /// Asked at every start on a Linux computer without a keyring service, for the passphrase chosen there
  ///
  /// In en, this message translates to:
  /// **'Enter the passphrase that protects Photolib\'s keys on this computer.'**
  String get passphraseUnlock;

  /// No description provided for @passphraseWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong passphrase. Try again.'**
  String get passphraseWrong;

  /// What a screen reader says for a photo in a grid
  ///
  /// In en, this message translates to:
  /// **'Photo {index} of {count}'**
  String photoPosition(int index, int count);

  /// Opens the recovery drill, which checks that the recovery kit still unlocks the private libraries
  ///
  /// In en, this message translates to:
  /// **'Check recovery kit'**
  String get privacyCheckKit;

  /// Under the recovery kit's state when its six-monthly drill is due
  ///
  /// In en, this message translates to:
  /// **'Time for a recovery drill: check that your recovery kit still unlocks your private libraries.'**
  String get privacyDrillDue;

  /// The plain truth about private libraries, above their setup and their state
  ///
  /// In en, this message translates to:
  /// **'Private libraries are encrypted on your devices, and nobody else can open them: not the server, not its administrator, not Photolib\'s developers. If you lose both your password and your recovery kit, your photos are lost for good, and nobody can get them back for you.'**
  String get privacyHonest;

  /// Above the 24 words of a new recovery kit
  ///
  /// In en, this message translates to:
  /// **'Write these 24 words on paper, in order, and keep them somewhere safe. They unlock your private libraries if you forget your password, for anyone who has them.'**
  String get privacyKitBody;

  /// The recovery drill opened the private libraries' keys
  ///
  /// In en, this message translates to:
  /// **'Your recovery kit works.'**
  String get privacyKitDone;

  /// A recovery phrase that belongs to a replaced or another account's kit
  ///
  /// In en, this message translates to:
  /// **'This is not your current recovery kit.'**
  String get privacyKitOther;

  /// Heading of the 24 words of a new recovery kit
  ///
  /// In en, this message translates to:
  /// **'Your recovery kit'**
  String get privacyKitTitle;

  /// The person has not yet shown they saved their recovery kit
  ///
  /// In en, this message translates to:
  /// **'Recovery kit not verified yet'**
  String get privacyKitUnverified;

  /// When the person last showed they hold their recovery kit
  ///
  /// In en, this message translates to:
  /// **'Recovery kit verified on {date}'**
  String privacyKitVerified(String date);

  /// Confirms the recovery kit's words are written down, then asks for some of them
  ///
  /// In en, this message translates to:
  /// **'I wrote them down'**
  String get privacyKitWritten;

  /// Why the server refuses uploads to private libraries yet
  ///
  /// In en, this message translates to:
  /// **'Private uploads stay off until you have two ways to unlock and have verified your recovery kit.'**
  String get privacyNotReady;

  /// Above the password field of the private libraries' setup
  ///
  /// In en, this message translates to:
  /// **'Enter your account password: it becomes one way to unlock your private libraries.'**
  String get privacyPasswordHelp;

  /// The field of the recovery drill
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase'**
  String get privacyPhrase;

  /// Under the recovery phrase field
  ///
  /// In en, this message translates to:
  /// **'The 24 words of your recovery kit'**
  String get privacyPhraseHelp;

  /// A typed recovery phrase has the wrong number of words or a wrong word
  ///
  /// In en, this message translates to:
  /// **'This is not a recovery phrase. Check every word.'**
  String get privacyPhraseInvalid;

  /// The account has two ways to unlock and a verified recovery kit
  ///
  /// In en, this message translates to:
  /// **'Private uploads are on.'**
  String get privacyReady;

  /// A way to unlock private libraries: the 24 words written down
  ///
  /// In en, this message translates to:
  /// **'Recovery kit'**
  String get privacyRecoveryKit;

  /// Makes the private libraries' keys and recovery kit
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get privacySetUp;

  /// Goes back from the check to the recovery kit's words
  ///
  /// In en, this message translates to:
  /// **'Show the words again'**
  String get privacyShowWords;

  /// Settings entry and page of end-to-end encrypted libraries
  ///
  /// In en, this message translates to:
  /// **'Private libraries'**
  String get privacyTitle;

  /// A typed recovery phrase holds a word not in the recovery word list
  ///
  /// In en, this message translates to:
  /// **'Word {number} is not a recovery kit word.'**
  String privacyUnknownWord(int number);

  /// Checks the typed words against the recovery kit
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get privacyVerify;

  /// Above the fields asking for some words of the new recovery kit
  ///
  /// In en, this message translates to:
  /// **'Type these words from your recovery kit to show that you saved it.'**
  String get privacyVerifyBody;

  /// Heading of the list of ways the private libraries open: password, recovery kit
  ///
  /// In en, this message translates to:
  /// **'Ways to unlock'**
  String get privacyWays;

  /// The position of a word of the recovery kit
  ///
  /// In en, this message translates to:
  /// **'Word {number}'**
  String privacyWord(int number);

  /// Words typed for the recovery kit's check are wrong
  ///
  /// In en, this message translates to:
  /// **'These words do not match your recovery kit. Check what you wrote down.'**
  String get privacyWordsDiffer;

  /// The password entered for the private libraries' setup is wrong
  ///
  /// In en, this message translates to:
  /// **'This is not your account\'s password.'**
  String get privacyWrongPassword;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Only an administrator can do this.'**
  String get problemAdminOnly;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'The server is busy or restarting.'**
  String get problemBusy;

  /// The cause of a failure, in plain words; its next step follows: someone or something changed it first
  ///
  /// In en, this message translates to:
  /// **'This changed in the meantime.'**
  String get problemChanged;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This would hide or delete more items than the server does without a confirmation.'**
  String get problemConfirm;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'You may not add photos to this library.'**
  String get problemContribute;

  /// Copies a failure's cause, next step and technical detail
  ///
  /// In en, this message translates to:
  /// **'Copy details'**
  String get problemCopy;

  /// Shows the technical detail of a failure
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get problemDetails;

  /// The cause of a failure, in plain words; its next step follows: uploads wait while the server's disk is almost full
  ///
  /// In en, this message translates to:
  /// **'The server\'s disk is almost full, so uploads are paused.'**
  String get problemDiskLow;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Another account has this email.'**
  String get problemEmailTaken;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'It exists already.'**
  String get problemExists;

  /// The cause of a failure, in plain words; its next step follows: the server asks for a newer version of the face recognition notice than this app shows
  ///
  /// In en, this message translates to:
  /// **'Your server asks for a newer version of the faces notice than this app shows.'**
  String get problemFaceNotice;

  /// The cause of a failure, in plain words; its next step follows: what was asked for was deleted meanwhile
  ///
  /// In en, this message translates to:
  /// **'It is no longer on the server.'**
  String get problemGone;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Another account has this sign-in name.'**
  String get problemHandleTaken;

  /// The cause of a failure, in plain words; its next step follows: an upload
  ///
  /// In en, this message translates to:
  /// **'The upload was interrupted.'**
  String get problemInterrupted;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'A value is not valid.'**
  String get problemInvalid;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'The server needs at least one administrator.'**
  String get problemLastAdmin;

  /// The cause of a failure, in plain words; its next step follows: a password setup link
  ///
  /// In en, this message translates to:
  /// **'This link has expired or was used.'**
  String get problemLinkInvalid;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Wrong email, sign-in name or password.'**
  String get problemLoginFailed;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Backups, scrubs and purges can be paused only when signed in, not with an API key.'**
  String get problemMaintenanceKey;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Your account may not do this.'**
  String get problemNotAllowed;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Only libraries of the server\'s own folders can be scanned.'**
  String get problemNotExternal;

  /// The cause of a failure, in plain words; its next step follows: single sign-on
  ///
  /// In en, this message translates to:
  /// **'Your sign-in provider did not say who you are in a way this server accepts.'**
  String get problemOidcClaim;

  /// The cause of a failure, in plain words; its next step follows: single sign-on
  ///
  /// In en, this message translates to:
  /// **'Your sign-in provider does not answer the server.'**
  String get problemOidcDown;

  /// The cause of a failure, in plain words; its next step follows: single sign-on
  ///
  /// In en, this message translates to:
  /// **'Your sign-in provider refused the sign-in.'**
  String get problemOidcFailed;

  /// The cause of a failure, in plain words; its next step follows: single sign-on
  ///
  /// In en, this message translates to:
  /// **'Your account may not sign in this way.'**
  String get problemOidcNotAllowed;

  /// The cause of a failure, in plain words; its next step follows: single sign-on
  ///
  /// In en, this message translates to:
  /// **'This sign-in is linked to another Photolib account already.'**
  String get problemOidcTaken;

  /// The cause of a failure, in plain words; its next step follows: single sign-on
  ///
  /// In en, this message translates to:
  /// **'This server no longer offers this way to sign in.'**
  String get problemOidcUnknown;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Passkeys work only once the server has its public address.'**
  String get problemPasskeysOff;

  /// The cause of a failure, in plain words; its next step follows: the server refused to change a setting its configuration file pins
  ///
  /// In en, this message translates to:
  /// **'This is set in the configuration file and cannot be changed here.'**
  String get problemPinned;

  /// The cause of a failure, in plain words; its next step follows: the server's policy switches off what was asked, such as uploads
  ///
  /// In en, this message translates to:
  /// **'This is switched off on this server.'**
  String get problemPolicyOff;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Your storage on the server is full.'**
  String get problemQuota;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'A backup can be restored only when signed in, not with an API key.'**
  String get problemRestoreKey;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This folder does not hold this library\'s files.'**
  String get problemRootDiffers;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This folder is not under the external_roots of the server\'s configuration.'**
  String get problemRootNotAllowed;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This folder holds or lies in another library or the server\'s own data.'**
  String get problemRootOverlaps;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This library is being scanned already.'**
  String get problemScanning;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This account needs a second factor, such as an authenticator code or a passkey, which this version of Photolib cannot provide yet.'**
  String get problemSecondFactor;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This server already has an administrator.'**
  String get problemSetupDone;

  /// The cause of a failure, in plain words; its next step follows: a setup step expired
  ///
  /// In en, this message translates to:
  /// **'This took too long.'**
  String get problemSetupExpired;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This setup token is wrong.'**
  String get problemSetupToken;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'You are signed out of the server.'**
  String get problemSignedOut;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'This change needs your password or a code first.'**
  String get problemStepUp;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'The server cannot reach its storage.'**
  String get problemStorage;

  /// The cause of a failure, in plain words; its next step follows
  ///
  /// In en, this message translates to:
  /// **'Too many attempts in a short time.'**
  String get problemTooMany;

  /// The cause of a failure, in plain words; its next step follows: a failure nobody foresaw
  ///
  /// In en, this message translates to:
  /// **'Something unexpected went wrong.'**
  String get problemUnexpected;

  /// The cause of a failure, in plain words; its next step follows: no answer from the server, or one from something in between
  ///
  /// In en, this message translates to:
  /// **'The server does not answer.'**
  String get problemUnreachable;

  /// The cause of a failure, in plain words; its next step follows: an upload
  ///
  /// In en, this message translates to:
  /// **'The file changed or was damaged on the way.'**
  String get problemUploadDamaged;

  /// The cause of a failure, in plain words; its next step follows: an upload
  ///
  /// In en, this message translates to:
  /// **'The server no longer has this upload: unfinished uploads expire after a day.'**
  String get problemUploadExpired;

  /// The cause of a failure, in plain words; its next step follows: webhooks call the user's own services at each event, up to a number per account
  ///
  /// In en, this message translates to:
  /// **'Your account has as many webhooks as it may.'**
  String get problemWebhookLimit;

  /// The cause of a failure, in plain words; its next step follows: the administrator has not turned webhooks on
  ///
  /// In en, this message translates to:
  /// **'Webhooks are turned off on this server.'**
  String get problemWebhooksOff;

  /// The local recovery code: 24 words that open the app's encrypted store on this device when the device's keystore lost its key
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get recoveryCode;

  /// Settings: what the recovery code is for
  ///
  /// In en, this message translates to:
  /// **'Opens Photolib\'s store on this device if the keystore loses its key'**
  String get recoveryCodeAbout;

  /// A button and dialog title: type the recovery code to open the store
  ///
  /// In en, this message translates to:
  /// **'Enter recovery code'**
  String get recoveryCodeEnter;

  /// A button: make a recovery code now
  ///
  /// In en, this message translates to:
  /// **'Create recovery code'**
  String get recoveryCreate;

  /// A button: put the offer of a recovery code off; the app asks again later
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get recoveryLater;

  /// A banner over the library: how many changes exist only on this device, which a recovery code protects
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change exists only on this device. A recovery code gets it back if the keystore loses Photolib\'s key.} other{{count} changes exist only on this device. A recovery code gets them back if the keystore loses Photolib\'s key.}}'**
  String recoveryOffer(int count);

  /// Shown with the 24 words of a new recovery code
  ///
  /// In en, this message translates to:
  /// **'Write these 24 words down and keep them safe: they open Photolib\'s store on this device without its keystore key. They replace any earlier code.'**
  String get recoveryShow;

  /// A button: open the store with the recovery code typed
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get recoveryUnlock;

  /// The recovery code typed does not open the store
  ///
  /// In en, this message translates to:
  /// **'That is not this store\'s recovery code'**
  String get recoveryWrong;

  /// Text to replace in every file name
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get renameFind;

  /// The pattern every new file name follows
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get renamePattern;

  /// Why a file cannot take its new name; nothing is renamed until every name can be given
  ///
  /// In en, this message translates to:
  /// **'{problem, select, tooLong{Too long: a name has at most 255 bytes} invalid{Not a valid file name} duplicate{Given to another file too} exists{Another file in this folder has this name} other{Cannot be renamed}}'**
  String renameProblem(String problem);

  /// What replaces the text found in every file name
  ///
  /// In en, this message translates to:
  /// **'Replace with'**
  String get renameReplace;

  /// After a rename
  ///
  /// In en, this message translates to:
  /// **'Files renamed: {count}'**
  String renamed(int count);

  /// Shows the file of the item in the computer's file manager, named as the system names it
  ///
  /// In en, this message translates to:
  /// **'{platform, select, macOS{Show in Finder} windows{Show in Explorer} other{Show in folder}}'**
  String reveal(String platform);

  /// A filter chip that limits a search to the photos and videos of one camera model
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get searchCamera;

  /// How many photos and videos a search found
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String searchCount(int count);

  /// A filter chip that limits a search to a range of capture dates
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get searchDates;

  /// The capture dates a search is limited to, both included
  ///
  /// In en, this message translates to:
  /// **'{first} – {last}'**
  String searchDays(String first, String last);

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search your library'**
  String get searchEmpty;

  /// A filter chip: only favourites
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get searchFavourites;

  /// A filter chip that limits a search to a folder and its subfolders
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get searchFolder;

  /// The hint of the search field, which finds photos and videos by the words in their file names and folder names
  ///
  /// In en, this message translates to:
  /// **'File name or folder'**
  String get searchHint;

  /// A filter chip: only photos with a short video, such as Live Photos
  ///
  /// In en, this message translates to:
  /// **'Motion photos'**
  String get searchMotionPhotos;

  /// A search found no photo or video
  ///
  /// In en, this message translates to:
  /// **'Nothing matches'**
  String get searchNothing;

  /// A filter chip: only panoramas and 360° photos
  ///
  /// In en, this message translates to:
  /// **'Panoramas'**
  String get searchPanoramas;

  /// A filter chip: only photos
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get searchPhotos;

  /// A filter chip: only screenshots
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get searchScreenshots;

  /// What a screen reader says of a video among the results of a search, before its file name
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get searchVideo;

  /// A filter chip: only videos
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get searchVideos;

  /// Adds a passkey to the account through the server's page in the browser; also the button on that page
  ///
  /// In en, this message translates to:
  /// **'Add a passkey'**
  String get securityAddPasskey;

  /// Field for a six-digit code from an authenticator app, or a recovery code
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get securityCode;

  /// Shown above an account's new recovery codes
  ///
  /// In en, this message translates to:
  /// **'Keep these codes somewhere safe. Each works once in place of your second factor, and they are shown only now.'**
  String get securityCodesHelp;

  /// How many of the account's recovery codes are unused
  ///
  /// In en, this message translates to:
  /// **'Unused: {count}'**
  String securityCodesLeft(int count);

  /// Replaces the account's recovery codes with new ones
  ///
  /// In en, this message translates to:
  /// **'New codes'**
  String get securityNewCodes;

  /// The browser created no passkey, e.g. the person cancelled
  ///
  /// In en, this message translates to:
  /// **'No passkey was added.'**
  String get securityPasskeyNotAdded;

  /// One-time codes that stand in for a second factor at sign-in
  ///
  /// In en, this message translates to:
  /// **'Recovery codes'**
  String get securityRecoveryCodes;

  /// Removes a passkey from the account
  ///
  /// In en, this message translates to:
  /// **'Remove passkey'**
  String get securityRemovePasskey;

  /// Sets up an authenticator app, in place of any earlier one
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get securitySetUp;

  /// Why the app asks for a password or code before a second factor changes
  ///
  /// In en, this message translates to:
  /// **'Enter your password, or a code from your authenticator app or a recovery code, to change your second factors.'**
  String get securityStepUpBody;

  /// Title of the prompt for a password or code before a second factor changes
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you'**
  String get securityStepUpTitle;

  /// The account's passkeys, authenticator app and recovery codes
  ///
  /// In en, this message translates to:
  /// **'Second factors'**
  String get securityTitle;

  /// Six-digit codes from an app such as Google Authenticator (TOTP)
  ///
  /// In en, this message translates to:
  /// **'Authenticator app'**
  String get securityTotp;

  /// Shown with the key to type into an authenticator app
  ///
  /// In en, this message translates to:
  /// **'Add this key to your authenticator app, then enter the code it shows.'**
  String get securityTotpHelp;

  /// Whether the authenticator app is set up
  ///
  /// In en, this message translates to:
  /// **'{state, select, on{On} other{Off}}'**
  String securityTotpState(String state);

  /// Turns the authenticator app off for the account
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get securityTurnOff;

  /// The authenticator app's code did not match the new key
  ///
  /// In en, this message translates to:
  /// **'That code is wrong.'**
  String get securityWrongCode;

  /// The password or code given to confirm it's you was wrong
  ///
  /// In en, this message translates to:
  /// **'Wrong password or code.'**
  String get securityWrongProof;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @selectionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get selectionClear;

  /// How many photos and videos are selected
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String selectionCount(int count);

  /// Opens a review of the selected photos and videos, where tapping one deselects it
  ///
  /// In en, this message translates to:
  /// **'Show selected'**
  String get selectionReview;

  /// The sign-in field for the account
  ///
  /// In en, this message translates to:
  /// **'Email or sign-in name'**
  String get serverAccount;

  /// Opens the page that connects the app to a Photolib server
  ///
  /// In en, this message translates to:
  /// **'Add a server'**
  String get serverAdd;

  /// An address cannot be one; keep the example URL as it is
  ///
  /// In en, this message translates to:
  /// **'Enter addresses such as photos.example.org'**
  String get serverAddressInvalid;

  /// The field of the server's addresses (URLs)
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get serverAddresses;

  /// Explains the addresses field
  ///
  /// In en, this message translates to:
  /// **'One per line: the server on your network, on the internet or through a VPN. The app uses the fastest that answers. Or paste the password setup link you were sent.'**
  String get serverAddressesHelp;

  /// The field for the certificate of a private certificate authority that signed the server's certificate
  ///
  /// In en, this message translates to:
  /// **'Private CA certificate (PEM)'**
  String get serverCa;

  /// Opens a file picker for the private CA certificate
  ///
  /// In en, this message translates to:
  /// **'Choose a certificate file'**
  String get serverCaChoose;

  /// Asks the user to compare the certificate's fingerprint, shown below, with the server's
  ///
  /// In en, this message translates to:
  /// **'{host} presents a certificate this device does not trust. Trust it only if this SHA-256 fingerprint is your server\'s:'**
  String serverCertificateBody(String host);

  /// Title of the dialog that shows the fingerprint of a self-signed server certificate
  ///
  /// In en, this message translates to:
  /// **'Trust this certificate?'**
  String get serverCertificateTitle;

  /// Sends the second factor code
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get serverConfirm;

  /// Contacts the server at the addresses entered
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get serverConnect;

  /// Creates the server's first administrator and signs them in
  ///
  /// In en, this message translates to:
  /// **'Create administrator'**
  String get serverCreateAdmin;

  /// The server revoked the device's session
  ///
  /// In en, this message translates to:
  /// **'The server ended this session. Sign in again.'**
  String get serverEnded;

  /// The rules of a sign-in name
  ///
  /// In en, this message translates to:
  /// **'Lowercase letters, digits, dots, dashes and underscores; it never changes.'**
  String get serverHandleHelp;

  /// The field of HTTP headers sent with every request, such as a Cloudflare Access token
  ///
  /// In en, this message translates to:
  /// **'Custom headers'**
  String get serverHeaders;

  /// Explains the headers field; keep Name: value as it is
  ///
  /// In en, this message translates to:
  /// **'One per line, as Name: value, sent over HTTPS only'**
  String get serverHeadersHelp;

  /// A line of the headers field is no header; keep Name: value as it is
  ///
  /// In en, this message translates to:
  /// **'Write each header as Name: value'**
  String get serverHeadersInvalid;

  /// The field for a client certificate bundle (PKCS#12, .p12 or .pfx) that a server behind mutual TLS asks for
  ///
  /// In en, this message translates to:
  /// **'Client certificate (PKCS#12)'**
  String get serverIdentity;

  /// Opens a file picker for the client certificate bundle
  ///
  /// In en, this message translates to:
  /// **'Choose a client certificate'**
  String get serverIdentityChoose;

  /// The chosen client certificate file does not open with the password given
  ///
  /// In en, this message translates to:
  /// **'This is not a certificate (PKCS#12), or its password is wrong.'**
  String get serverIdentityInvalid;

  /// The password that opens the client certificate bundle
  ///
  /// In en, this message translates to:
  /// **'Client certificate password'**
  String get serverIdentityPassword;

  /// Settings' server entry while the app still reads which server this device keeps from its encrypted store, for example until the user enters the store's passphrase
  ///
  /// In en, this message translates to:
  /// **'Reading the server kept on this device'**
  String get serverLoading;

  /// Heading above the Photolib servers found on the local network, which the user taps to add
  ///
  /// In en, this message translates to:
  /// **'Servers on this network'**
  String get serverNearby;

  /// The server is reached over plain HTTP beyond the local networks, where the app sends no session; HTTPS stays as it is
  ///
  /// In en, this message translates to:
  /// **'This server needs an HTTPS address: beyond your local network, Photolib does not sign in over plain HTTP.'**
  String get serverNeedsHttps;

  /// The server offers neither password nor passkey sign-in
  ///
  /// In en, this message translates to:
  /// **'This server offers no sign-in this version of Photolib supports.'**
  String get serverNoSignIn;

  /// The server cannot be reached; the app works offline and keeps the session
  ///
  /// In en, this message translates to:
  /// **'The server does not answer. You stay signed in.'**
  String get serverOffline;

  /// The passkey ceremony in the browser ended without a passkey, e.g. cancelled
  ///
  /// In en, this message translates to:
  /// **'No passkey was used. Try again, or use a code.'**
  String get serverPasskeyFailed;

  /// The server offers no password sign-in, only passkeys
  ///
  /// In en, this message translates to:
  /// **'This server requires a passkey, which this version of Photolib cannot use yet.'**
  String get serverPasskeyRequired;

  /// The password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get serverPassword;

  /// The field that repeats the new password
  ///
  /// In en, this message translates to:
  /// **'Password again'**
  String get serverPasswordAgain;

  /// The server refused the password setup token
  ///
  /// In en, this message translates to:
  /// **'This password setup token is wrong, used or expired. Ask for a new one.'**
  String get serverPasswordSetupInvalid;

  /// The one-time token with which an account sets its password
  ///
  /// In en, this message translates to:
  /// **'Password setup token'**
  String get serverPasswordSetupToken;

  /// Where a password setup token comes from; keep 'photolibd admin password-setup' as it is
  ///
  /// In en, this message translates to:
  /// **'From your administrator, or printed by photolibd admin password-setup on the server.'**
  String get serverPasswordSetupTokenHelp;

  /// The two password fields do not match
  ///
  /// In en, this message translates to:
  /// **'The passwords differ.'**
  String get serverPasswordsDiffer;

  /// Says what reopens private libraries after a password reset
  ///
  /// In en, this message translates to:
  /// **'A new password does not open them. Reopen them with your recovery kit, a passkey or a device that is still signed in.'**
  String get serverPrivateLibrariesBody;

  /// Sets the new password although private libraries stay locked
  ///
  /// In en, this message translates to:
  /// **'Set the password'**
  String get serverPrivateLibrariesGo;

  /// Asked before a reset password leaves private libraries locked
  ///
  /// In en, this message translates to:
  /// **'Your private libraries stay locked'**
  String get serverPrivateLibrariesTitle;

  /// The field of an HTTP proxy the app connects through; keep host:port as it is
  ///
  /// In en, this message translates to:
  /// **'HTTP proxy, as host:port'**
  String get serverProxy;

  /// The proxy field holds no host:port; keep host:port as it is
  ///
  /// In en, this message translates to:
  /// **'Enter the proxy as host:port'**
  String get serverProxyInvalid;

  /// The field for one of the account's one-time recovery codes
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get serverRecoveryCode;

  /// Signs out and forgets the server on this device
  ///
  /// In en, this message translates to:
  /// **'Remove this server'**
  String get serverRemove;

  /// A field that must not be empty
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get serverRequired;

  /// The server asked for a passkey after the password, which the app cannot use yet
  ///
  /// In en, this message translates to:
  /// **'This account\'s second factor is a passkey, which this version of Photolib cannot use yet.'**
  String get serverSecondFactor;

  /// Asks for the second factor of a password sign-in
  ///
  /// In en, this message translates to:
  /// **'This account also needs a code from your authenticator app, or a recovery code.'**
  String get serverSecondFactorCode;

  /// Title of the page that asks for a second factor after the password
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you'**
  String get serverSecondFactorTitle;

  /// The server refused the second factor; five wrong answers end the sign-in
  ///
  /// In en, this message translates to:
  /// **'That did not work. After five tries, sign in again.'**
  String get serverSecondFactorWrong;

  /// Sets the password with a password setup link
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get serverSetPassword;

  /// Whose password the link sets, and on which server
  ///
  /// In en, this message translates to:
  /// **'For {handle} on {server}'**
  String serverSetPasswordFor(String handle, String server);

  /// Opens the page that sets an account's password with a password setup token
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get serverSetPasswordOpen;

  /// The page that sets a password with a password setup link or token
  ///
  /// In en, this message translates to:
  /// **'Set your password'**
  String get serverSetPasswordTitle;

  /// Opens the page that creates a new server's first administrator
  ///
  /// In en, this message translates to:
  /// **'Set up a new server'**
  String get serverSetUp;

  /// A password setup link opened while the app has a server it cannot be used with: signed in, or another one
  ///
  /// In en, this message translates to:
  /// **'To use this setup link, sign out of this server first, or remove it if the link is for another one.'**
  String get serverSetupLinkElsewhere;

  /// Title of the page that creates a new server's first administrator
  ///
  /// In en, this message translates to:
  /// **'Set up the server'**
  String get serverSetupTitle;

  /// The one-time token the server prints in its log
  ///
  /// In en, this message translates to:
  /// **'Setup token'**
  String get serverSetupToken;

  /// Where to find the setup token; keep photolibd as it is
  ///
  /// In en, this message translates to:
  /// **'photolibd prints it in its log while the server has no administrator; each start prints a new one.'**
  String get serverSetupTokenHelp;

  /// Signs in to the server
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get serverSignIn;

  /// Ends a device's session on the server
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get serverSignOut;

  /// The email or user name the device is signed in with
  ///
  /// In en, this message translates to:
  /// **'Signed in as {account}'**
  String serverSignedInAs(String account);

  /// The device has no session on the server
  ///
  /// In en, this message translates to:
  /// **'Signed out'**
  String get serverSignedOut;

  /// Tooltip of the app bar's menu that switches to another of the accounts kept on this device
  ///
  /// In en, this message translates to:
  /// **'Switch account'**
  String get serverSwitch;

  /// The field for the six-digit code of an authenticator app (TOTP)
  ///
  /// In en, this message translates to:
  /// **'Code from your authenticator app'**
  String get serverTotpCode;

  /// Pins the shown certificate for this server
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get serverTrust;

  /// Settings' server entry when the app could not read which server this device keeps from its encrypted store; its button tries again
  ///
  /// In en, this message translates to:
  /// **'The server kept on this device cannot be read'**
  String get serverUnreadable;

  /// Signs in with a passkey through the server's page in the browser; also the button on that page
  ///
  /// In en, this message translates to:
  /// **'Use a passkey'**
  String get serverUsePasskey;

  /// Switches the field from an authenticator code to a recovery code
  ///
  /// In en, this message translates to:
  /// **'Use a recovery code instead'**
  String get serverUseRecoveryCode;

  /// A label in Settings over the choice of what shows behind the transparent parts of an image shown full screen
  ///
  /// In en, this message translates to:
  /// **'Behind transparent images'**
  String get settingsBackground;

  /// A tile of Settings that opens the list of ways to order a date, whatever the language
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get settingsDateFormat;

  /// The tab the folders and albums page shows first
  ///
  /// In en, this message translates to:
  /// **'Folders and albums open on'**
  String get settingsDefaultTab;

  /// The folders on this computer whose photos and videos are in the library
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get settingsFolders;

  /// A heading of Settings: indexing of the photos on this device, for search and faces
  ///
  /// In en, this message translates to:
  /// **'Indexing on this device'**
  String get settingsIndexing;

  /// A tile of Settings that opens the list of the languages the app can show
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// A section of Settings: what the library shows
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get settingsLibrary;

  /// A heading of Settings: the Photolib server this device signs in to
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get settingsServer;

  /// What the app shows when it starts
  ///
  /// In en, this message translates to:
  /// **'Start screen'**
  String get settingsStart;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// A switch in Settings that turns one behaviour of the full-screen viewer, its videos or the grid of photos on or off
  ///
  /// In en, this message translates to:
  /// **'{toggle, select, edgeTaps{Tap the left or right edge for the previous or next item} oneFingerZoom{Double-tap and drag to zoom with one finger} swipes{Swipe up or down on a video\'s left side for brightness, right side for volume} maxBrightness{Full brightness while viewing} autoRotate{Turn to each photo\'s or video\'s orientation} mixAudio{Play videos over other audio instead of pausing it} autoplay{Play videos as they open} loop{Loop videos} autoNext{Go to the next item when a video ends} resume{Resume videos where they were left} other{Play animated images in the grid}}'**
  String settingsToggle(String toggle);

  /// Opens a list in Settings where the user chooses which buttons the bar over a photo shown full screen holds, and in what order
  ///
  /// In en, this message translates to:
  /// **'Buttons in the viewer\'s bar'**
  String get settingsViewerBar;

  /// A heading in Settings over how the full-screen viewer, its videos and the grid behave
  ///
  /// In en, this message translates to:
  /// **'Viewing'**
  String get settingsViewing;

  /// A banner over the library on iPhone and iPad: photos and videos other apps shared with Photolib cannot be saved into the system's Photos library until the user allows it; its button asks for that access
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 shared photo or video waits until Photolib may add to your Photos library. Unsaved items are deleted after 7 days.} other{{count} shared photos and videos wait until Photolib may add to your Photos library. Unsaved items are deleted after 7 days.}}'**
  String shareInboxWaiting(int count);

  /// Said when a phone is asked to share more than it may copy into its temporary space at once
  ///
  /// In en, this message translates to:
  /// **'Too large to share at once: select fewer items'**
  String get shareTooLarge;

  /// Said when a phone is asked to share more items than one share can carry
  ///
  /// In en, this message translates to:
  /// **'Too many to share at once: select {count} or fewer'**
  String shareTooMany(int count);

  /// No description provided for @shortcutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get shortcutsTitle;

  /// Shows the items one after another, full screen, each for a few seconds
  ///
  /// In en, this message translates to:
  /// **'Slideshow'**
  String get slideshow;

  /// A switch: the slideshow starts over after the last item
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get slideshowLoop;

  /// Opens the slideshow's interval, shuffle and repeat settings
  ///
  /// In en, this message translates to:
  /// **'Slideshow options'**
  String get slideshowOptions;

  /// A number field: how many seconds the slideshow shows each item
  ///
  /// In en, this message translates to:
  /// **'Seconds per item'**
  String get slideshowSeconds;

  /// A switch: the slideshow shows the items in a random order, each once
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get slideshowShuffle;

  /// The order of a sort
  ///
  /// In en, this message translates to:
  /// **'{descending, select, true{Descending} other{Ascending}}'**
  String sortOrder(String descending);

  /// The top of the source tree: every volume and folder of this device; its eye shows all folders but the hidden, or only those shown
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get sourceDevice;

  /// The eye of a node of the source tree, which keeps its folder and those below it out of the library
  ///
  /// In en, this message translates to:
  /// **'Hide {name}'**
  String sourceHide(String name);

  /// Source tree menu: shows this folder and hides the rest of the folder it is in
  ///
  /// In en, this message translates to:
  /// **'Hide everything else here'**
  String get sourceHideOthers;

  /// A folder the app may no longer read, until the user allows it again
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get sourceLost;

  /// A hidden folder of the source tree with a folder shown below it
  ///
  /// In en, this message translates to:
  /// **'Partly shown'**
  String get sourcePartly;

  /// The eye of a node of the source tree, which shows its folder and those below it in the library
  ///
  /// In en, this message translates to:
  /// **'Show {name}'**
  String sourceShow(String name);

  /// Source tree menu: shows this folder and everything below it
  ///
  /// In en, this message translates to:
  /// **'Show everything here'**
  String get sourceShowEverything;

  /// Source tree menu: the library shows this folder and nothing else of the device
  ///
  /// In en, this message translates to:
  /// **'Show only this'**
  String get sourceShowOnly;

  /// What the app can show when it starts
  ///
  /// In en, this message translates to:
  /// **'{screen, select, timeline{Timeline} folders{Folders and albums} favourites{Favourites} other{Timeline}}'**
  String startScreen(String screen);

  /// A button that picks a person whose photos are kept offline
  ///
  /// In en, this message translates to:
  /// **'Keep a person offline'**
  String get storageAddPerson;

  /// The most storage this device may use for photos kept offline
  ///
  /// In en, this message translates to:
  /// **'Storage budget'**
  String get storageBudget;

  /// A button that removes every photo kept offline
  ///
  /// In en, this message translates to:
  /// **'Remove offline copies'**
  String get storageClear;

  /// The button that confirms removing the offline copies
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get storageClearAction;

  /// What removing the offline copies does; the size is exactly what is freed
  ///
  /// In en, this message translates to:
  /// **'This removes {size} kept on this device and stops keeping albums, searches and photos offline. Your library on the server is not touched.'**
  String storageClearBody(String size);

  /// A switch that keeps the whole library available offline, within the budget
  ///
  /// In en, this message translates to:
  /// **'Keep the whole library'**
  String get storageKeepLibrary;

  /// A switch on a pin: keep the original files, not only previews
  ///
  /// In en, this message translates to:
  /// **'Keep originals too'**
  String get storageKeepOriginals;

  /// Shown in the list of people to keep offline when none is named yet
  ///
  /// In en, this message translates to:
  /// **'No people are named yet.'**
  String get storageNoPeople;

  /// Shown while nothing is pinned for offline use
  ///
  /// In en, this message translates to:
  /// **'Nothing is pinned. Pin an album, a search or a photo to keep it offline.'**
  String get storageNoPins;

  /// What a pin keeps offline
  ///
  /// In en, this message translates to:
  /// **'{kind, select, album{Album} search{Search} person{Person} library{Whole library} asset{Photo} other{Pinned}}'**
  String storagePinKind(String kind);

  /// A pin that does not fit the storage budget; the size is what is missing
  ///
  /// In en, this message translates to:
  /// **'Does not fit the budget: {size} more needed'**
  String storagePinLeft(String size);

  /// A pin with nothing to download because the device holds the photos already
  ///
  /// In en, this message translates to:
  /// **'Nothing to download: its photos are on this device already'**
  String get storagePinNothing;

  /// A pin that waits because the storage preset keeps nothing offline
  ///
  /// In en, this message translates to:
  /// **'Waiting: this preset keeps nothing offline'**
  String get storagePinPaused;

  /// A pin whose files the app is still working out
  ///
  /// In en, this message translates to:
  /// **'Looking up what to keep…'**
  String get storagePinPlanning;

  /// How far a pin's files are downloaded
  ///
  /// In en, this message translates to:
  /// **'Downloading: {have} of {files}'**
  String storagePinProgress(int have, int files);

  /// A pin whose files are all on the device; the size is what they take
  ///
  /// In en, this message translates to:
  /// **'Available offline ({size})'**
  String storagePinReady(String size);

  /// A pin waiting for the network: it downloads when the device is online
  ///
  /// In en, this message translates to:
  /// **'Will download when online'**
  String get storagePinWaiting;

  /// The heading of the albums, searches and photos kept offline
  ///
  /// In en, this message translates to:
  /// **'Kept offline'**
  String get storagePins;

  /// The name of a storage preset: what this device keeps
  ///
  /// In en, this message translates to:
  /// **'{preset, select, catalogueOnly{Catalogue only} spaceSaver{Space saver} travel{Selected albums offline} everything{Everything} other{}}'**
  String storagePreset(String preset);

  /// What a storage preset keeps, in one sentence
  ///
  /// In en, this message translates to:
  /// **'{preset, select, catalogueOnly{Keeps nothing; photos load from your server when you open them.} spaceSaver{Keeps previews of your whole library, newest first, within the budget.} travel{Keeps only what you pin: albums, searches and photos.} everything{Keeps the originals of your whole library, newest first, within the budget.} other{}}'**
  String storagePresetHelp(String preset);

  /// The heading of the storage presets
  ///
  /// In en, this message translates to:
  /// **'What this device keeps'**
  String get storagePresets;

  /// The subtitle of Settings' storage entry
  ///
  /// In en, this message translates to:
  /// **'Offline copies and storage budget'**
  String get storageSubtitle;

  /// The title of the storage settings page
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storageTitle;

  /// How much of the storage budget photos kept offline use
  ///
  /// In en, this message translates to:
  /// **'{used} of {budget} used'**
  String storageUsed(String used, String budget);

  /// Says what a browser keeps offline
  ///
  /// In en, this message translates to:
  /// **'A browser keeps previews only, and erases them when you sign out.'**
  String get storageWebNote;

  /// A banner on Linux: the system keyring (Secret Service) did not answer, so the store cannot open; names the keyrings to install
  ///
  /// In en, this message translates to:
  /// **'Photolib keeps the key of its local store in the system keyring, which did not answer. Install and unlock gnome-keyring, KWallet or KeePassXC with its Secret Service on, then try again.'**
  String get storeNoKeyring;

  /// A banner: the device's keystore did not answer, so the store cannot open
  ///
  /// In en, this message translates to:
  /// **'Photolib could not reach this device\'s keystore, which holds the key of its local store.'**
  String get storeNoKeystore;

  /// A banner after the keystore lost the store's key and the device had no recovery code: the store was made anew
  ///
  /// In en, this message translates to:
  /// **'This device\'s keystore no longer had the key of Photolib\'s local store, so the store was rebuilt. Its settings and what existed only on this device are lost; libraries sync again and thumbnails come back.'**
  String get storeRebuilt;

  /// A banner: the keystore lost the store's key; the recovery code opens it, or a reset makes it anew
  ///
  /// In en, this message translates to:
  /// **'This device\'s keystore no longer has the key of Photolib\'s local store. Enter its recovery code, or reset the store and lose what exists only on this device.'**
  String get storeRecoveryNeeded;

  /// A button and dialog title: erase the store and make it anew
  ///
  /// In en, this message translates to:
  /// **'Reset store'**
  String get storeReset;

  /// Asks to confirm a reset of the store
  ///
  /// In en, this message translates to:
  /// **'What exists only on this device is lost; libraries sync again and thumbnails come back.'**
  String get storeResetBody;

  /// Said on every tab when the app cannot open its encrypted store on this device, for example without a keystore
  ///
  /// In en, this message translates to:
  /// **'The store on this device is unavailable: settings and collections are not kept'**
  String get storeUnavailable;

  /// No description provided for @tabCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get tabCollections;

  /// No description provided for @tabLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get tabLibrary;

  /// No description provided for @tabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tabSearch;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Runs the timeline's performance check in a test build
  ///
  /// In en, this message translates to:
  /// **'Timeline benchmark'**
  String get timelineBenchmark;

  /// Copies the performance check's results as JSON
  ///
  /// In en, this message translates to:
  /// **'Copy the results'**
  String get timelineBenchmarkCopy;

  /// Shown on, and said of, a video in the web app's timeline that the browser cannot play, such as HEVC in some browsers or ProRes
  ///
  /// In en, this message translates to:
  /// **'Can\'t play in this browser'**
  String get timelineCannotPlay;

  /// What a screen reader says of a photo or video in the timeline: its segment's heading and its place there
  ///
  /// In en, this message translates to:
  /// **'{date}, {position} of {count}'**
  String timelineCell(String date, int position, int count);

  /// What a screen reader says of a photo or video in the timeline whose thumbnail could not be made: its segment's heading, its place there, and that it shows a mark instead
  ///
  /// In en, this message translates to:
  /// **'{date}, {position} of {count}, no preview'**
  String timelineCellNoPreview(String date, int position, int count);

  /// What a screen reader says of an item the library shows only for now
  ///
  /// In en, this message translates to:
  /// **'In an excluded folder'**
  String get timelineExcluded;

  /// The handle on the timeline's edge that jumps through the years
  ///
  /// In en, this message translates to:
  /// **'Scroll by date'**
  String get timelineScrubber;

  /// What a screen reader says of the cell of a photo sphere or 360° video in the timeline, which has a 360° badge
  ///
  /// In en, this message translates to:
  /// **'360°'**
  String get timelineSphere;

  /// The heading of the photos with no capture date, last in the timeline
  ///
  /// In en, this message translates to:
  /// **'Date unknown'**
  String get timelineUndated;

  /// The heading of a week of photos in the timeline
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String timelineWeek(String date);

  /// Pins one action of the ⋮ menu to the end of the viewer's bar; action is its name
  ///
  /// In en, this message translates to:
  /// **'Add {action} to the bar'**
  String toolbarAdd(String action);

  /// Moves one button of the viewer's bar one place later; action is the button's name
  ///
  /// In en, this message translates to:
  /// **'Move {action} down'**
  String toolbarDown(String action);

  /// Heading of the list of buttons pinned to the bar over a photo shown full screen
  ///
  /// In en, this message translates to:
  /// **'In the bar'**
  String get toolbarInBar;

  /// Heading of the list of actions that are in the bar's ⋮ menu rather than pinned to it
  ///
  /// In en, this message translates to:
  /// **'In the ⋮ menu'**
  String get toolbarInMenu;

  /// Takes one button out of the viewer's bar into its ⋮ menu; action is the button's name
  ///
  /// In en, this message translates to:
  /// **'Remove {action} from the bar'**
  String toolbarRemove(String action);

  /// Puts the default buttons back in the viewer's bar, in their default order
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get toolbarReset;

  /// Moves one button of the viewer's bar one place earlier; action is the button's name
  ///
  /// In en, this message translates to:
  /// **'Move {action} up'**
  String toolbarUp(String action);

  /// Moves or copies the files into the folder shown
  ///
  /// In en, this message translates to:
  /// **'{move, select, true{Move here} other{Copy here}}'**
  String transferHere(String move);

  /// Why a file was not moved or copied, or a folder not made
  ///
  /// In en, this message translates to:
  /// **'{reason, select, exists{A file or folder of this name is already there} changed{The copy did not match the original and was removed} cancelled{Cancelled} invalid{Not a valid folder name} other{Failed}}'**
  String transferProblem(String reason);

  /// The folders that files were moved or copied to lately
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get transferRecent;

  /// Asks once before photos in the trash are deleted for good
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 item forever? This cannot be undone.} other{Delete {count} items forever? This cannot be undone.}}'**
  String trashConfirm(int count);

  /// How long a photo stays in the trash
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Deleted forever today} =1{1 day left} other{{days} days left}}'**
  String trashDaysLeft(int days);

  /// The trash holds nothing
  ///
  /// In en, this message translates to:
  /// **'The trash is empty'**
  String get trashEmpty;

  /// Deletes everything in the trash for good
  ///
  /// In en, this message translates to:
  /// **'Empty trash'**
  String get trashEmptyAll;

  /// Says that photos went to the trash, with a way to undo it
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item moved to the trash} other{{count} items moved to the trash}}'**
  String trashMoved(int count);

  /// The trash's retention, at the top of the trash
  ///
  /// In en, this message translates to:
  /// **'Photolib deletes what it keeps in the trash for good after {days} days; each item shows the time it has left.'**
  String trashRetention(int days);

  /// The screen of what was moved to the trash
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trashTitle;

  /// Undoes what was just done
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Uploads photos and videos from this device to the server: the button over the library
  ///
  /// In en, this message translates to:
  /// **'Upload photos and videos'**
  String get uploadAction;

  /// Forgets the uploads that ended, from the library banner
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get uploadClear;

  /// The library banner while files upload
  ///
  /// In en, this message translates to:
  /// **'Uploaded {done} of {total}'**
  String uploadProgress(int done, int total);

  /// The library banner when uploads failed
  ///
  /// In en, this message translates to:
  /// **'Failed: {count}'**
  String uploadsFailed(int count);

  /// Says that photos were archived, with a way to undo it
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item archived} other{{count} items archived}}'**
  String veilArchived(int count);

  /// Says that photos were hidden, with a way to undo it
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item hidden} other{{count} items hidden}}'**
  String veilHidden(int count);

  /// One choice of what shows behind the transparent parts of an image shown full screen: black, white, or a checkerboard of grey squares
  ///
  /// In en, this message translates to:
  /// **'{background, select, black{Black} white{White} other{Checkerboard}}'**
  String viewerBackground(String background);

  /// Shown over a video full screen that the phone or computer has no decoder for
  ///
  /// In en, this message translates to:
  /// **'This video cannot play on this device'**
  String get viewerCannotPlay;

  /// Shows or hides the captions of the video shown full screen, which come from a subtitle file beside it
  ///
  /// In en, this message translates to:
  /// **'Captions'**
  String get viewerCaptions;

  /// While the 360° view turns with the phone or tablet, keeps it true to the compass, so that it never drifts; again, turns it off
  ///
  /// In en, this message translates to:
  /// **'Compass lock'**
  String get viewerCompass;

  /// Copies the photo shown full screen to the clipboard, to paste it in another app
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get viewerCopy;

  /// Shows the text found in the photo shown full screen, to copy it; a button of the bar over the photo and a dialog's button that puts the text on the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy text'**
  String get viewerCopyText;

  /// The last entry of the menu of the bar over a photo shown full screen: opens the page where the user picks and orders the bar's buttons
  ///
  /// In en, this message translates to:
  /// **'Customize toolbar…'**
  String get viewerCustomize;

  /// Tooltip of the small compass at the bottom right of a 360° photo or video: what it shows, what a click does, and how to look around
  ///
  /// In en, this message translates to:
  /// **'Heading. Click to face front. Drag to look around, scroll or pinch to zoom, double-click to reset'**
  String get viewerDial;

  /// Shows or hides the strip of thumbnails under the photo shown full screen
  ///
  /// In en, this message translates to:
  /// **'Filmstrip'**
  String get viewerFilmstrip;

  /// Shows the first photo or video of the library full screen
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get viewerFirst;

  /// Shows the 360° photo or video full screen through a fisheye lens, half the sphere at once, or back as before
  ///
  /// In en, this message translates to:
  /// **'Fisheye'**
  String get viewerFisheye;

  /// Turns the 360° photo or video full screen as the phone or tablet turns, or stops doing so
  ///
  /// In en, this message translates to:
  /// **'Move to look around'**
  String get viewerGyroscope;

  /// Shows the HDR photo or video full screen, and those shown next, in high dynamic range, with brighter highlights where the screen has them
  ///
  /// In en, this message translates to:
  /// **'Show in HDR'**
  String get viewerHdr;

  /// Shows or hides the date, camera, place and file of the photo or video shown full screen
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get viewerInfo;

  /// What a screen reader says of the info panel while the item's details load
  ///
  /// In en, this message translates to:
  /// **'Loading this item\'s info'**
  String get viewerInfoLoading;

  /// What a screen reader says of a thumbnail in the filmstrip under a photo shown full screen: its place among all
  ///
  /// In en, this message translates to:
  /// **'{position} of {count}'**
  String viewerItem(int position, int count);

  /// Shows the last photo or video of the library full screen
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get viewerLast;

  /// What a long press on the small compass of a 360° photo or video does: offers the little planet and fisheye views
  ///
  /// In en, this message translates to:
  /// **'Choose a lens'**
  String get viewerLenses;

  /// Shows where the photo or video shown full screen was taken, in the device's maps app
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get viewerMap;

  /// Plays the short video of the motion photo or Live Photo shown full screen; a screen reader also says it of pressing and holding the photo
  ///
  /// In en, this message translates to:
  /// **'Play motion'**
  String get viewerMotion;

  /// Shown when the user turns on 'Move to look around' in a phone's browser and the browser, as Safari may, refuses the motion sensors
  ///
  /// In en, this message translates to:
  /// **'This browser did not allow access to the motion sensors'**
  String get viewerMotionDenied;

  /// Shown when the user turns on 'Move to look around' on a phone or tablet without a gyroscope, which turns it back off
  ///
  /// In en, this message translates to:
  /// **'This device has no gyroscope to look around with'**
  String get viewerMotionMissing;

  /// Turns off the sound of the video shown full screen
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get viewerMute;

  /// Shows the next photo or video full screen
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get viewerNext;

  /// Pauses the video shown full screen and shows its next frame
  ///
  /// In en, this message translates to:
  /// **'Next frame'**
  String get viewerNextFrame;

  /// Pauses the video shown full screen
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get viewerPause;

  /// Shows the 360° photo or video full screen as a little planet, the whole sphere seen from above as a round world, or back as before
  ///
  /// In en, this message translates to:
  /// **'Little planet'**
  String get viewerPlanet;

  /// Plays the video shown full screen, or pauses it
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get viewerPlay;

  /// Shows the previous photo or video full screen
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get viewerPrevious;

  /// Pauses the video shown full screen and shows its previous frame
  ///
  /// In en, this message translates to:
  /// **'Previous frame'**
  String get viewerPreviousFrame;

  /// Turns the photo shown full screen a quarter clockwise, until the viewer closes; the file is not changed
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get viewerRotate;

  /// Shows the HDR photo or video full screen, and those shown next, in standard dynamic range, without the brighter highlights
  ///
  /// In en, this message translates to:
  /// **'Show in SDR'**
  String get viewerSdr;

  /// The slider that moves through the video shown full screen
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get viewerSeek;

  /// Offers the photo shown full screen to the apps that use one as a wallpaper or a contact photo
  ///
  /// In en, this message translates to:
  /// **'Set as'**
  String get viewerSetAs;

  /// Sends the photo or video shown full screen to another app
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get viewerShare;

  /// Chooses how fast the video shown full screen plays, from a quarter to twice its speed
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get viewerSpeed;

  /// What a screen reader says of a 360° photo or video shown full screen, which a drag turns
  ///
  /// In en, this message translates to:
  /// **'360° view. Drag to look around, pinch to zoom'**
  String get viewerSphere;

  /// The title of the dialog that shows the text found in the photo shown full screen
  ///
  /// In en, this message translates to:
  /// **'Text in this photo'**
  String get viewerText;

  /// Said once the text found in a photo is on the clipboard
  ///
  /// In en, this message translates to:
  /// **'Text copied'**
  String get viewerTextCopied;

  /// Said when the photo shown full screen holds no text
  ///
  /// In en, this message translates to:
  /// **'No text found in this photo'**
  String get viewerTextNone;

  /// Said when the server has not yet read the text of the photo shown full screen
  ///
  /// In en, this message translates to:
  /// **'This photo\'s text has not been read yet'**
  String get viewerTextUnread;

  /// Turns the sound of the video shown full screen back on
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get viewerUnmute;

  /// Enlarges the photo shown full screen
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get viewerZoomIn;

  /// Shrinks the photo shown full screen back
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get viewerZoomOut;

  /// Where a folder of the phone is: on its SD card or in its own storage
  ///
  /// In en, this message translates to:
  /// **'{kind, select, sd{SD card} other{Internal}}'**
  String volumeBadge(String kind);

  /// Shows fewer, larger photos in the grid
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// Shows more, smaller photos in the grid
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'he',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ru',
    'sv',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'ar':
      {
        switch (locale.countryCode) {
          case 'XB':
            return AppLocalizationsArXb();
        }
        break;
      }
    case 'en':
      {
        switch (locale.countryCode) {
          case 'XA':
            return AppLocalizationsEnXa();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
