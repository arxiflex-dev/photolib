// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get actionAddToAlbum => 'एल्बम में जोड़ें';

  @override
  String get actionArchive => 'संग्रहित करें';

  @override
  String get actionCopyTo => 'यहाँ कॉपी करें…';

  @override
  String get actionDeleteForever => 'हमेशा के लिए हटाएं';

  @override
  String get actionFavourite => 'पसंदीदा में जोड़ें';

  @override
  String get actionHide => 'छिपाएं';

  @override
  String get actionMoveTo => 'यहाँ ले जाएं…';

  @override
  String get actionRename => 'नाम बदलें';

  @override
  String get actionRestore => 'वापस लाएं';

  @override
  String get actionShare => 'शेयर करें';

  @override
  String get actionTrash => 'ट्रैश में ले जाएं';

  @override
  String get actionUnarchive => 'संग्रह से निकालें';

  @override
  String get actionUndo => 'पहले जैसा करें';

  @override
  String get actionUnfavourite => 'पसंदीदा से हटाएं';

  @override
  String get actionUnhide => 'दिखाएं';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'सक्रिय',
      'disabled': 'बंद किया गया',
      'invited': 'आमंत्रित',
      'deleted': 'मिटाया गया',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'खाते';

  @override
  String get adminAddAccount => 'खाता जोड़ें';

  @override
  String get adminAddExternalLibrary => 'बाहरी लाइब्रेरी जोड़ें';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts प्रयास',
      one: '1 प्रयास',
      zero: 'अभी तक नहीं चलाया गया',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'ऑडिट लॉग';

  @override
  String get adminBackUpNow => 'अभी बैकअप लें';

  @override
  String get adminBackupQueued =>
      'बैकअप कतार में है; उसके बाद पुनर्स्थापना अभ्यास होगा';

  @override
  String get adminBackups => 'डेटाबेस बैकअप';

  @override
  String get adminCancelJob => 'जॉब रद्द करें';

  @override
  String get adminCapabilities => 'सुविधाएं';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'प्रबंधित लाइब्रेरी',
      'uploads': 'डिवाइस, वेब और CLI से अपलोड',
      'folder_browser': 'फ़ोल्डर ब्राउज़र',
      'device_folders': 'कनेक्ट किए गए ऐप में डिवाइस फ़ोल्डर',
      'sharing': 'शेयर करना और सार्वजनिक लिंक',
      'edits': 'बदलाव',
      'deletes': 'मिटाना',
      'xmp_writes': 'XMP फ़ाइलें लिखना',
      'face_recognition': 'चेहरे की पहचान',
      'ml_search': 'स्मार्ट खोज',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'ठीक है',
      'warn': 'चेतावनी',
      'fail': 'विफल',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'कॉपी किया गया';

  @override
  String get adminCopyBundle =>
      'गड़बड़ी की रिपोर्ट के लिए डायग्नोस्टिक्स कॉपी करें';

  @override
  String get adminCopyLink => 'लिंक कॉपी करें';

  @override
  String get adminDelete => 'मिटाएं';

  @override
  String get adminDeviceBackups => 'डिवाइस बैकअप';

  @override
  String get adminDevices => 'आपके डिवाइस';

  @override
  String get adminDisable => 'बंद करें';

  @override
  String adminDrillFailed(String detail) {
    return 'पिछला पुनर्स्थापना अभ्यास विफल रहा: $detail';
  }

  @override
  String get adminEdit => 'बदलाव करें';

  @override
  String get adminEmail => 'ईमेल';

  @override
  String get adminEnable => 'चालू करें';

  @override
  String get adminErrorSignIn => 'एडमिन के तौर पर साइन इन करें';

  @override
  String get adminFacesDefault =>
      'नए खातों के लिए चेहरे की पहचान की सुविधा डिफ़ॉल्ट रूप से चालू रहती है';

  @override
  String get adminFiles => 'टाइप के हिसाब से फ़ाइलें';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'क्षतिग्रस्त',
      'missing': 'गायब',
      'size': 'गलत आकार',
      'hash': 'बदला गया',
      'orphan': 'अनाथ फ़ाइल',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size खाली';
  }

  @override
  String get adminFreeDisk =>
      'डिस्क में खाली जगह इस प्रतिशत से कम होने पर अपलोड रोकें, 0 से 50 तक';

  @override
  String get adminFreeDiskGb =>
      'या GB में इस खाली जगह से कम होने पर, यदि यह कम हो, 0 से 100000 तक';

  @override
  String get adminHandle => 'साइन-इन नाम';

  @override
  String get adminIntegrity => 'अखंडता';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम',
      one: '$countString आइटम',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'कतार में',
      'running': 'चालू',
      'done': 'पूर्ण',
      'dead': 'विफल',
      'cancelled': 'रद्द',
      'other': 'सभी',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'जॉब का टाइप, जैसे render';

  @override
  String get adminJobs => 'जॉब';

  @override
  String adminLastSeen(String time) {
    return 'आखिरी बार $time को देखा गया';
  }

  @override
  String get adminLibraries => 'लाइब्रेरी';

  @override
  String get adminLibraryOwner => 'मालिक';

  @override
  String get adminLibraryRoot => 'सर्वर पर फ़ोल्डर, जैसे /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'ऑनलाइन',
      'offline': 'ऑफ़लाइन',
      'scanning': 'स्कैन जारी है',
      'error': 'गड़बड़ी',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'सर्वर लॉग';

  @override
  String get adminName => 'नाम';

  @override
  String get adminNothing => 'यहां अभी कुछ नहीं है';

  @override
  String get adminOutOfRange => 'सीमा से बाहर';

  @override
  String get adminOverview => 'खास जानकारी';

  @override
  String get adminPair => 'डिवाइस जोड़ें';

  @override
  String get adminPairBody =>
      'यह कोड स्कैन करें या लिंक भेजें, फिर नए डिवाइस पर Photolib में सर्वर जोड़ें में चिपकाएँ: यह इस सर्वर के सारे पते और उसका प्रमाणपत्र साथ लाता है, ताकि किसी को उन्हें टाइप न करना पड़े।';

  @override
  String get adminPasswordSetup => 'पासवर्ड सेट करने का लिंक';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'यह लिंक $name को किसी भी तरीके से भेजें, या उन्हें कोड स्कैन करने दें। यह $date तक एक बार पासवर्ड सेट करता है।';
  }

  @override
  String get adminPause => 'किसी टाइप के जॉब रोकें';

  @override
  String adminPauseMinutes(int max) {
    return 'मिनट, 1 से $max तक';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type को $time तक रोका गया है';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बैकअप के लिए $countString आइटम बचे',
      one: 'बैकअप के लिए 1 आइटम बचा',
      zero: 'बैकअप के लिए कुछ नहीं बचा',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'नीतियां';

  @override
  String get adminPolicyReset => 'ऊपर के स्तर का मान इस्तेमाल करें';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'डिफ़ॉल्ट रूप से चालू',
      'server': 'सर्वर के लिए सेट',
      'user': 'इस खाते के लिए सेट',
      'library': 'इस लाइब्रेरी के लिए सेट',
      'config': 'कॉन्फ़िगरेशन में सेट',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'प्रीसेट लागू करें';

  @override
  String get adminPresetBody =>
      'प्रीसेट सर्वर के लिए हर सुविधा सेट करता है और खातों व लाइब्रेरी की सेटिंग हटा देता है. हर सुविधा बाद में बदली जा सकती है.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'संग्रह देखना',
      'family_backup': 'परिवार का बैकअप',
      'personal': 'निजी',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'सिर्फ़ पढ़ने वाली बाहरी लाइब्रेरी ही सही जानकारी का एकमात्र स्रोत हैं: कोई अपलोड, प्रबंधित लाइब्रेरी, डिवाइस फ़ोल्डर, बदलाव, मिटाना या XMP लिखना नहीं',
      'family_backup': 'XMP लिखने को छोड़कर सब चालू',
      'personal': 'शेयर करने और सार्वजनिक लिंक को छोड़कर सब चालू',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'लिंक का QR कोड';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString जॉब कतार में हैं',
      one: '1 जॉब कतार में है',
      zero: 'करने के लिए कुछ नहीं है',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'GB में स्टोरेज कोटा; कोई सीमा न रखने के लिए खाली छोड़ें';

  @override
  String get adminRemote => 'रिमोट एक्सेस';

  @override
  String get adminRemoteBody =>
      'राउटर पर कोई पोर्ट खोले बिना कहीं से भी सर्वर तक पहुँचें। एक तरीका चुनें; हर तरीका उसे ऐप्स में जोड़ने के लिए एक HTTPS पता देता है। फिर बाहर से जाँचें।';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared बाहर की ओर Cloudflare से जुड़ता है, जो आपका डोमेन HTTPS पर देता है। मुफ़्त प्लान एक अनुरोध को 100 MB तक सीमित करता है, जहाँ बैकअप कभी नहीं पहुँचते: वे एक बार में 8 MiB भेजते हैं।';

  @override
  String get adminRemoteNoAddress =>
      'बाहर से जाँचने के लिए इस ऐप में सर्वर का https:// पता जोड़ें।';

  @override
  String get adminRemoteReachable => 'बाहर से पहुँचा जा सकता है।';

  @override
  String get adminRemoteTailscale =>
      'सर्वर की मशीन और हर डिवाइस पर Tailscale इंस्टॉल करें, एक ही tailnet या अपने Headscale में, फिर सर्वर की मशीन पर यह चलाएँ और public_url को उसके दिखाए पते पर सेट करें।';

  @override
  String get adminRemoteTest => 'बाहर से जाँचें';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host दुनिया भर के अपने सर्वरों से $url खोलेगा, और इस तरह यह पता जान लेगा। जारी रखें?';
  }

  @override
  String get adminRemoteUnreachable =>
      'बाहर से नहीं पहुँचा जा सकता: चुना हुआ तरीका जाँचें, फिर से जाँचें।';

  @override
  String get adminRemoteWireguard =>
      'सर्वर की तरफ़ या किसी केंद्रीय नोड पर एक खुला UDP पोर्ट चाहिए। यह एक डिवाइस का कॉन्फ़िगरेशन है; कुंजियाँ wg genkey से बनाएँ।';

  @override
  String get adminRepair =>
      'इसे किसी बैकअप से या ऐसे डिवाइस से वापस रखें जिसमें यह अभी भी है';

  @override
  String get adminRepairOrphan =>
      'कोई फ़ोटो इसका नाम नहीं लेती: इसे जाँचें, फिर हटाएँ या रखें';

  @override
  String get adminReprocess => 'फिर से प्रोसेस करें';

  @override
  String get adminReprocessFaces => 'चेहरों की फिर से पहचान करें';

  @override
  String get adminReprocessFolder =>
      'फ़ोल्डर, जैसे 2024/05; पूरी लाइब्रेरी के लिए खाली छोड़ें';

  @override
  String get adminReprocessMetadata => 'मेटाडेटा फिर से पढ़ें';

  @override
  String get adminReprocessRenditions => 'थंबनेल और प्रीव्यू फिर से बनाएं';

  @override
  String get adminRestore => 'पुनर्स्थापित करें';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '$name की पुनर्स्थापना विफल रही: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'अभी तक कोई पुनर्स्थापना अभ्यास सफल नहीं हुआ';

  @override
  String adminRestoreVerified(String when) {
    return 'अंतिम सत्यापित पुनर्स्थापना: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd रुक जाता है, फिर दोबारा शुरू होने पर पूरे डेटाबेस को $name से बदल देता है। उस बैकअप के बाद हुए बदलाव खो जाते हैं, और हर डिवाइस शुरू से सिंक करता है।';
  }

  @override
  String get adminRestoring =>
      'बैकअप पुनर्स्थापित करने के लिए photolibd रुक रहा है';

  @override
  String get adminResume => 'फिर से शुरू करें';

  @override
  String get adminRetry => 'फिर से कोशिश करें';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'एडमिन',
      'user': 'उपयोगकर्ता',
      'viewer': 'दर्शक',
      'other': 'अज्ञात',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'सेव किया गया';

  @override
  String get adminScan => 'अभी स्कैन करें';

  @override
  String get adminScrubDays =>
      'जाँच द्वारा हर मूल फ़ाइल जाँचने के दिन, 1 से 3650';

  @override
  String get adminScrubNever => 'पहली पूरी जाँच चल रही है';

  @override
  String adminScrubbed(String time) {
    return 'पिछली पूरी जाँच $time';
  }

  @override
  String get adminSecondAdmin =>
      'किसी दूसरे व्यक्ति को भी एडमिनिस्ट्रेटर बनाएँ, ताकि अगर आप न कर पाएँ तो कोई और सर्वर चला सके और उसे पुनर्स्थापित कर सके।';

  @override
  String adminSilent(String time) {
    return '$time से चुप';
  }

  @override
  String get adminSilentHours =>
      'रिपोर्ट के बिना घंटे, जिसके बाद डिवाइस का बैकअप चुप माना जाता है, 1 से 8760';

  @override
  String get adminStores => 'स्टोरेज';

  @override
  String get adminThisDevice => 'यह डिवाइस';

  @override
  String get adminTitle => 'सर्वर का एडमिनिस्ट्रेशन';

  @override
  String get adminTrashDays => 'ट्रैश में रहने के दिन, 1 से 3650 तक';

  @override
  String get adminTwoFactor =>
      'सभी खातों को पुष्टि का दूसरा तरीका सेट अप करना होगा';

  @override
  String get adminUsage => 'खाते के हिसाब से इस्तेमाल';

  @override
  String get albumCover => 'कवर के रूप में इस्तेमाल करें';

  @override
  String get albumEmpty => 'यह एल्बम खाली है';

  @override
  String get albumHideMemories => 'यादों से छिपाएँ';

  @override
  String get albumHideTimeline => 'टाइमलाइन से छिपाएँ';

  @override
  String get albumNew => 'नया एल्बम';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'कोई भी तारीख';

  @override
  String get backupCap => 'सबसे बड़ा आइटम';

  @override
  String get backupCharging => 'केवल चार्ज होते समय';

  @override
  String backupCompleted(String time) {
    return 'पिछला पूरा बैकअप: $time';
  }

  @override
  String backupContact(String time) {
    return 'सर्वर से पिछला संपर्क: $time';
  }

  @override
  String get backupEnabled => 'इस डिवाइस का बैकअप लें';

  @override
  String get backupFolderNo => 'यह नहीं';

  @override
  String get backupFolderYes => 'बैकअप लें';

  @override
  String backupHours(int count) {
    return '$count घं॰';
  }

  @override
  String get backupMetered => 'सीमित नेटवर्क पर, जैसे मोबाइल डेटा या हॉटस्पॉट';

  @override
  String get backupNever => 'अभी तक कोई पूरा बैकअप नहीं';

  @override
  String backupNewFolder(String name) {
    return 'नया फ़ोल्डर $name: बैकअप लें?';
  }

  @override
  String get backupNoLimit => 'कोई सीमा नहीं';

  @override
  String get backupNothing => 'कुछ भी प्रतीक्षा में नहीं';

  @override
  String get backupNow => 'अभी बैकअप लें';

  @override
  String backupOverdue(int hours, String items) {
    return '$hours घं॰ से कोई पूरा बैकअप नहीं। प्रतीक्षा में: $items';
  }

  @override
  String get backupOverdueTitle => 'बैकअप पूरा नहीं हुआ';

  @override
  String backupPending(String items) {
    return 'प्रतीक्षा में: $items';
  }

  @override
  String backupRetry(String time) {
    return 'फिर से प्रयास: $time';
  }

  @override
  String get backupRoaming => 'रोमिंग में बैकअप लें';

  @override
  String get backupSignIn =>
      'इस डिवाइस का बैकअप लेने के लिए किसी सर्वर में साइन इन करें';

  @override
  String get backupSignedOut =>
      'बैकअप रुक गया: सर्वर ने इस डिवाइस को साइन आउट कर दिया। सेटिंग में फिर से साइन इन करें।';

  @override
  String get backupSince => 'इस तारीख से लिए गए';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'बैकअप सर्वर के उपलब्ध होने की प्रतीक्षा में है',
      'charging': 'बैकअप डिवाइस के चार्ज होने की प्रतीक्षा में है',
      'battery_low': 'बैकअप प्रतीक्षा में है: बैटरी कम है',
      'roaming': 'रोमिंग के दौरान बैकअप प्रतीक्षा में है',
      'quota': 'बैकअप रुक गया: सर्वर पर आपका स्टोरेज भर गया है',
      'second_factor':
          'बैकअप रुक गया: सर्वर इस खाते के लिए दूसरा फ़ैक्टर माँगता है',
      'other': 'बैकअप रुक गया: सर्वर ने $code उत्तर दिया',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'बैकअप';

  @override
  String get backupWaiting => 'बैकअप नहीं हुआ';

  @override
  String get backupWarnAfter => 'इतने समय तक पूरा न हो तो चेतावनी दें';

  @override
  String get backupWhat => 'किसका बैकअप लें';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'ऐसे फ़ोल्डर में जिसे आपने नहीं चुना',
      'folder_new': 'नए फ़ोल्डर में: चुनें कि उसका बैकअप लेना है या नहीं',
      'type_excluded': 'ऐसा आइटम प्रकार जिसे आपने नहीं चुना',
      'before_date': 'आपकी चुनी तारीख से पहले लिया गया',
      'selected': 'अपनी बारी की प्रतीक्षा में',
      'server_restored': 'रीस्टोर में सर्वर से खो गया: फिर से भेजा जा रहा है',
      'working': 'बैकअप हो रहा है',
      'waiting_for_icloud': 'iCloud से डाउनलोड होने की प्रतीक्षा में',
      'metered': 'असीमित नेटवर्क की प्रतीक्षा में',
      'metered_cap': 'सीमित नेटवर्क के लिए बहुत बड़ा',
      'unreadable': 'यह डिवाइस इसे पढ़ नहीं सकता',
      'changed': 'भेजते समय यह बदल गया',
      'quota': 'सर्वर पर आपका स्टोरेज भर गया है',
      'other': 'सर्वर ने इसे अस्वीकार किया: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'सर्वर अब Photolib के इस वर्शन के साथ काम नहीं करता।';

  @override
  String get checkAppTooOldNext => 'Photolib अपडेट करें।';

  @override
  String get checkChanged =>
      'सर्वर का प्रमाणपत्र वह नहीं है जिस पर आपने भरोसा किया था।';

  @override
  String get checkChangedNext =>
      'अगर एडमिनिस्ट्रेटर ने इसे बदला है, तो नए पर भरोसा करें। अगर नहीं, तो शायद कोई सुन रहा है: आगे न बढ़ें।';

  @override
  String get checkClock =>
      'इस डिवाइस की घड़ी और सर्वर की घड़ी में पाँच मिनट से ज़्यादा का फ़र्क है।';

  @override
  String get checkClockNext =>
      'अपने डिवाइस को तारीख और समय अपने-आप सेट करने दें।';

  @override
  String get checkDnsFailed => 'सर्वर का नाम किसी पते तक नहीं ले जाता।';

  @override
  String get checkDnsFailedNext =>
      'पता जाँचें, या सर्वर के नेटवर्क से कनेक्ट करें।';

  @override
  String checkExpired(String date) {
    return 'सर्वर के प्रमाणपत्र की अवधि $date को खत्म हो गई।';
  }

  @override
  String get checkFailed => 'विफल';

  @override
  String get checkMetered => 'आप मीटर्ड नेटवर्क पर हैं, जैसे मोबाइल डेटा।';

  @override
  String get checkMeteredNext => 'बड़े बैकअप से पहले वाई-फ़ाई से कनेक्ट करें।';

  @override
  String get checkNotPhotolib =>
      'Photolib के बजाय कुछ और जवाब दे रहा है, जैसे प्रॉक्सी का त्रुटि पेज या वाई-फ़ाई साइन-इन पेज।';

  @override
  String get checkNotPhotolibNext =>
      'अपने ब्राउज़र में वाई-फ़ाई में साइन इन करें, या एडमिनिस्ट्रेटर से प्रॉक्सी जाँचने को कहें।';

  @override
  String get checkOtherServer =>
      'इस पते पर कोई दूसरा Photolib सर्वर जवाब दे रहा है।';

  @override
  String get checkPassed => 'पास';

  @override
  String get checkRefused => 'इस पते पर कुछ भी जवाब नहीं देता।';

  @override
  String get checkRefusedNext =>
      'जाँचें कि सर्वर चल रहा है और आप उसके नेटवर्क या VPN पर हैं।';

  @override
  String get checkRun => 'कनेक्शन जाँचें';

  @override
  String get checkRunning => 'जाँच हो रही है';

  @override
  String get checkSelfSigned =>
      'सर्वर अपना खुद का प्रमाणपत्र इस्तेमाल करता है, जिसे यह डिवाइस अभी नहीं जानता।';

  @override
  String get checkSkipped => 'जाँचा नहीं गया';

  @override
  String get checkStepAuth => 'आपका साइन-इन';

  @override
  String get checkStepClock => 'आपके डिवाइस की घड़ी';

  @override
  String get checkStepDns => 'सर्वर का पता ढूँढना';

  @override
  String get checkStepNetwork => 'आपका नेटवर्क';

  @override
  String get checkStepServer => 'सर्वर पर Photolib';

  @override
  String get checkStepTcp => 'सर्वर तक पहुँचना';

  @override
  String get checkStepTls => 'सुरक्षित कनेक्शन और प्रमाणपत्र';

  @override
  String get checkStepUpload => 'प्रॉक्सी से बड़े अपलोड';

  @override
  String get checkTimedOut => 'सर्वर जवाब देने में बहुत समय ले रहा है।';

  @override
  String get checkTimedOutNext => 'अपना कनेक्शन जाँचें, फिर से कोशिश करें।';

  @override
  String get checkTitle => 'कनेक्शन जाँच';

  @override
  String get checkTlsFailed => 'सुरक्षित कनेक्शन विफल रहा।';

  @override
  String get checkTrustNext =>
      'इस पर भरोसा तभी करें जब इसका फ़िंगरप्रिंट आपके सर्वर से मेल खाए।';

  @override
  String get checkUntrusted =>
      'सर्वर का प्रमाणपत्र ऐसी संस्था से है जिस पर यह डिवाइस भरोसा नहीं करता।';

  @override
  String get checkUploadCap =>
      'रास्ते में एक प्रॉक्सी बड़े अपलोड मना करता है, इसलिए बैकअप छोटे हिस्सों में धीरे चलते हैं।';

  @override
  String get checkUploadCapNext =>
      'एडमिनिस्ट्रेटर से कहें कि प्रॉक्सी से 64 MB के अनुरोध जाने दें।';

  @override
  String get collectionAlbums => 'एल्बम';

  @override
  String collectionHide(String name) {
    return '$name छिपाएं';
  }

  @override
  String collectionMoveDown(String name) {
    return '$name को नीचे ले जाएं';
  }

  @override
  String collectionMoveUp(String name) {
    return '$name को ऊपर ले जाएं';
  }

  @override
  String get collectionPeople => 'लोग';

  @override
  String collectionPin(String name) {
    return '$name को पिन करें';
  }

  @override
  String get collectionPlaces => 'जगहें';

  @override
  String collectionShow(String name) {
    return '$name दिखाएं';
  }

  @override
  String get collectionTags => 'टैग';

  @override
  String collectionUnpin(String name) {
    return '$name को अनपिन करें';
  }

  @override
  String get collectionsCustomise => 'पसंद के मुताबिक बनाएं';

  @override
  String get collectionsDone => 'हो गया';

  @override
  String get commandPalette => 'कमांड पैलेट';

  @override
  String get commandPaletteHint => 'कोई कमांड टाइप करें';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString इस डिवाइस पर और बैकअप में',
      one: '$countString इस डिवाइस पर और बैकअप में',
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
      other: '$countString सिर्फ़ इस डिवाइस पर, बैकअप नहीं हुआ',
      one: '$countString सिर्फ़ इस डिवाइस पर, बैकअप नहीं हुआ',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'iCloud फ़ोटो चालू होने पर, इस डिवाइस से मिटाए गए आइटम iCloud और आपके दूसरे Apple डिवाइस से भी हट जाते हैं।';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString सिर्फ़ आपकी लाइब्रेरी में',
      one: '$countString सिर्फ़ आपकी लाइब्रेरी में',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'इस डिवाइस से हटाएं';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बैकअप किए गए $countString आइटम; आपकी लाइब्रेरी इन्हें रखती है',
      one: 'बैकअप किया गया $countString आइटम; आपकी लाइब्रेरी इसे रखती है',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'इस डिवाइस की कॉपी उसके ट्रैश में जाती हैं: ट्रैश खाली होने पर जगह वापस मिलती है।';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम मिटाएं?',
      one: '$countString आइटम मिटाएं?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'इस डिवाइस और आपकी लाइब्रेरी से',
      'device': 'सिर्फ़ इस डिवाइस से',
      'other': 'आपकी लाइब्रेरी से',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'मौजूद नहीं';

  @override
  String get deviceFolderCard => 'SD कार्ड';

  @override
  String get deviceFolderExclude => 'बाहर रखें';

  @override
  String get deviceFolderExcludeThis => 'इस फ़ोल्डर को बाहर रखें';

  @override
  String get deviceFolderExcludedNotice =>
      'इस आइटम का फ़ोल्डर आपकी लाइब्रेरी से बाहर रखा गया है';

  @override
  String get deviceFolderForget => 'सूची से हटाएं';

  @override
  String get deviceFolderInternal => 'इंटरनल स्टोरेज';

  @override
  String get deviceFolderKeep => 'रखें';

  @override
  String deviceFolderNew(String name, String items) {
    return 'नया फ़ोल्डर: $name, $items';
  }

  @override
  String get deviceFolders => 'डिवाइस के फ़ोल्डर';

  @override
  String get deviceFoldersAll =>
      'बाहर रखे गए फ़ोल्डर के अलावा सभी फ़ोल्डर दिखाएं';

  @override
  String get deviceFoldersChosen => 'सिर्फ़ चुने गए फ़ोल्डर दिखाएं';

  @override
  String get deviceFoldersExcludedNow => 'लाइब्रेरी से बाहर रखा गया';

  @override
  String get deviceFoldersSearch => 'फ़ोल्डर खोजें';

  @override
  String get diagnosticsAdvanced => 'निदान दिखाएं';

  @override
  String get diagnosticsAllLoggers => 'सभी स्रोत';

  @override
  String get diagnosticsCopied => 'लॉग कॉपी किया गया';

  @override
  String get diagnosticsCopy => 'दिखाया गया लॉग कॉपी करें';

  @override
  String get diagnosticsEmpty => 'अभी तक कोई लॉग एंट्री नहीं है';

  @override
  String get diagnosticsExport => 'निदान बंडल निर्यात करें';

  @override
  String get diagnosticsExported => 'निदान बंडल सहेजा गया';

  @override
  String get diagnosticsLevel => 'स्तर';

  @override
  String get diagnosticsLogger => 'स्रोत';

  @override
  String get diagnosticsTitle => 'डायग्नोस्टिक्स';

  @override
  String get download => 'डाउनलोड करें';

  @override
  String get downloadCurrent => 'वर्तमान संस्करण, संपादनों के साथ';

  @override
  String get downloadFailed => 'डाउनलोड नहीं हो सका';

  @override
  String get downloadOriginal => 'मूल';

  @override
  String downloadSaved(String name) {
    return '$name सहेजा गया';
  }

  @override
  String get downloadVersion => 'कौन-सा संस्करण?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम डाउनलोड हो रहे हैं',
      one: '$countString आइटम डाउनलोड हो रहा है',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'स्वतः सुधार';

  @override
  String get editorCrop => 'क्रॉप करें';

  @override
  String get editorCropOriginal => 'मूल';

  @override
  String get editorCropSquare => 'वर्गाकार';

  @override
  String get editorEdit => 'संपादित करें';

  @override
  String get editorFlip => 'पलटें';

  @override
  String get editorRotate => 'घुमाएं';

  @override
  String get editorSaveCopy => 'कॉपी सहेजें';

  @override
  String get editorSaveFailed => 'कॉपी सहेजी नहीं जा सकी';

  @override
  String get editorSaveVersion => 'सहेजें';

  @override
  String get editorSaved => 'कॉपी के रूप में सहेजा गया';

  @override
  String get editorVersionFailed => 'संस्करण सहेजा नहीं जा सका';

  @override
  String get editorVersionSaved => 'नए संस्करण के रूप में सहेजा गया';

  @override
  String get editorVersionsUnsupported =>
      'यह सर्वर अभी संपादित फ़ोटो के संस्करण नहीं रख सकता';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString बदलाव पूर्ववत किए गए: सर्वर ने उन्हें अस्वीकार कर दिया।',
      one:
          '$countString बदलाव पूर्ववत किया गया: सर्वर ने उसे अस्वीकार कर दिया।',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'खारिज करें';

  @override
  String get editsRejectedForbidden =>
      'आप आइटम देख सकते हैं, लेकिन उन्हें बदल नहीं सकते।';

  @override
  String get editsRejectedInvalid => 'सर्वर बदलावों को स्वीकार नहीं कर सका।';

  @override
  String get editsRejectedNotFound =>
      'आइटम हटा दिए गए हैं या अब आपके साथ शेयर नहीं किए गए हैं।';

  @override
  String get errorNotFound => 'यह पेज मौजूद नहीं है';

  @override
  String get errorRetry => 'फिर से कोशिश करें';

  @override
  String get errorTitle => 'कोई गड़बड़ी हुई';

  @override
  String faceNumber(int number) {
    return 'चेहरा $number';
  }

  @override
  String get facesAgree => 'मैं सहमत हूँ';

  @override
  String get facesAura => 'चेहरों को AuraFace से बताएँ (बड़ा डाउनलोड)';

  @override
  String get facesNotNow => 'अभी नहीं';

  @override
  String get facesNoticeKeep =>
      'जो मिलता है वह आपकी फ़ोटो के साथ, आपके डिवाइस और आपके सर्वर पर रहता है। विवरण कभी दिखाए या साझा नहीं किए जाते, और बंद करने या फ़ोटो हटाने पर सब कुछ मिटा दिया जाता है।';

  @override
  String get facesNoticeOptional =>
      'यह वैकल्पिक है। Photolib में बाकी सब इसके बिना भी चलता है, और आप सेटिंग में कभी भी रोक सकते हैं।';

  @override
  String get facesNoticeTitle => 'आपकी फ़ोटो में चेहरे खोजें?';

  @override
  String get facesNoticeWhat =>
      'Photolib आपकी फ़ोटो और वीडियो में चेहरे ढूँढता है और हर चेहरे के लिए उसकी जगह और उसे बताने वाली संख्याओं की एक सूची रखता है, ताकि वही व्यक्ति दोबारा मिल सके। ऐसा विवरण बायोमेट्रिक डेटा माना जा सकता है।';

  @override
  String get facesNoticeWhere =>
      'यह इसी डिवाइस पर और, यदि आप साइन इन हैं, तो आपके अपने सर्वर पर होता है। हमारी या किसी और की सेवा पर कभी नहीं।';

  @override
  String get facesServerFailed =>
      'आपके सर्वर को बताया नहीं जा सका। फिर कोशिश करें।';

  @override
  String get facesServerOff => 'आपका सर्वर आपके लिए चेहरे नहीं खोजता';

  @override
  String get facesServerOn => 'आपका सर्वर आपके लिए चेहरे खोजता है';

  @override
  String get facesServerUnavailable => 'आपका सर्वर चेहरे की पहचान नहीं देता';

  @override
  String facesStatusDownloading(int percent) {
    return 'चेहरों के मॉडल डाउनलोड हो रहे हैं: $percent%';
  }

  @override
  String get facesStatusMissing =>
      'आपके सर्वर ने चेहरों के मॉडल इंस्टॉल नहीं किए हैं';

  @override
  String get facesStatusNoDecoder =>
      'चेहरे खोजना उपलब्ध नहीं है: इमेज लाइब्रेरी (libvips) नहीं मिली। Photolib को दोबारा इंस्टॉल करें, या libvips इंस्टॉल करके इसे फिर से चालू करें।';

  @override
  String get facesStatusRunning => 'इस डिवाइस पर चेहरे खोजे जा रहे हैं';

  @override
  String get facesStatusUnavailable => 'इस डिवाइस पर चेहरे नहीं खोजे जा सकते';

  @override
  String get facesStatusWaiting => 'चेहरों के मॉडल Wi-Fi पर डाउनलोड होंगे';

  @override
  String get facesSwitch => 'मेरी फ़ोटो में चेहरे खोजें';

  @override
  String get facesSwitchOff =>
      'बंद। आपके सहमत होने तक चेहरों के बारे में कुछ भी नहीं निकाला जाता।';

  @override
  String get facesSwitchOn => 'चालू। Photolib आपकी फ़ोटो में चेहरे खोजता है।';

  @override
  String get facesTitle => 'चेहरे और लोग';

  @override
  String get facesWithdraw => 'मिटाएँ और रोकें';

  @override
  String get facesWithdrawBody =>
      'इससे Photolib ने आपके लिए जो भी चेहरे, विवरण और लोग खोजे हैं, वे इस डिवाइस और आपके सर्वर से मिट जाएँगे। आपकी फ़ोटो नहीं बदलतीं।';

  @override
  String get facesWithdrawTitle => 'चेहरे खोजना रोकें?';

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

    return 'बिना बदली फ़ाइलें: $countString';
  }

  @override
  String get folderAllow => 'इस फ़ोल्डर का ऐक्सेस दें';

  @override
  String get folderDelete => 'फ़ोल्डर हटाएं';

  @override
  String folderDeleteBody(String name) {
    return '$name की फ़ोटो और वीडियो ट्रैश में ले जाएं?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम',
      one: '$countString आइटम',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'नया फ़ोल्डर';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ऑफ़लाइन, $countString आइटम',
      one: 'ऑफ़लाइन, $countString आइटम',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'यह फ़ोल्डर पहले से लाइब्रेरी में है, या लाइब्रेरी में मौजूद किसी फ़ोल्डर के अंदर है या उसे अपने अंदर रखता है';

  @override
  String get folderRemove => 'फ़ोल्डर हटाएं';

  @override
  String folderRemoveBody(String folder) {
    return '$folder की फ़ोटो और वीडियो लाइब्रेरी से हट जाएंगे. फ़ाइलें डिस्क पर बिना किसी बदलाव के बनी रहेंगी.';
  }

  @override
  String get folderRemoveConfirm => 'हटाएं';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'स्कैन जारी है, अब तक $countString आइटम',
      one: 'स्कैन जारी है, अब तक $countString आइटम',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'पहुँच की अनुमति दें';

  @override
  String get foldersHideExcluded => 'बाहर रखे फ़ोल्डर छिपाएं';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib अब $countString फ़ोल्डर नहीं पढ़ सकता।',
      one: 'Photolib अब $countString फ़ोल्डर नहीं पढ़ सकता।',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'बाहर रखे फ़ोल्डर दिखाएं ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'यह ब्राउज़र किसी फ़ोल्डर को आपकी लाइब्रेरी के तौर पर नहीं रख सकता. कंप्यूटर पर Chrome या Edge में Photolib खोलें या डेस्कटॉप ऐप इस्तेमाल करें.';

  @override
  String get galleryButtons => 'बटन';

  @override
  String get galleryChips => 'चिप';

  @override
  String get galleryGrid => 'ग्रिड';

  @override
  String get galleryMenus => 'मेन्यू और शीट';

  @override
  String get galleryShowSheet => 'शीट दिखाएं';

  @override
  String get galleryTitle => 'कॉम्पोनेंट';

  @override
  String hiddenCollections(int count) {
    return 'छिपाए गए ($count)';
  }

  @override
  String get indexingAllowMetered => 'मोबाइल डेटा से डाउनलोड करें';

  @override
  String get indexingAllowSaver => 'पावर सेविंग मोड में भी';

  @override
  String get indexingBattery => 'चार्जर के बिना ज़रूरी बैटरी';

  @override
  String get indexingChargingOnly => 'सिर्फ़ चार्ज होते समय';

  @override
  String indexingDownloading(int percent) {
    return 'सर्च मॉडल डाउनलोड हो रहा है: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ोटो पढ़ी नहीं जा सकीं',
      one: '$count फ़ोटो पढ़ी नहीं जा सकी',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'यह डिवाइस केवल अपनी नई फ़ोटो इंडेक्स करता है';

  @override
  String get indexingMissing => 'आपके सर्वर ने सर्च मॉडल इंस्टॉल नहीं किया है';

  @override
  String get indexingModels => 'इस डिवाइस पर खोजें';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'सर्च मॉडल ($megabytesString MB) $host से डाउनलोड करता है';
  }

  @override
  String get indexingNoDecoder =>
      'खोज और टेक्स्ट पढ़ना उपलब्ध नहीं है: इमेज लाइब्रेरी (libvips) नहीं मिली। Photolib को दोबारा इंस्टॉल करें, या libvips इंस्टॉल करके इसे फिर से चालू करें।';

  @override
  String indexingPausedBattery(int percent) {
    return 'बैटरी $percent% से कम रहने तक रुका हुआ';
  }

  @override
  String get indexingPausedCharger => 'डिवाइस चार्ज होने तक रुका हुआ';

  @override
  String get indexingPausedHeat => 'डिवाइस गर्म रहने तक रुका हुआ';

  @override
  String get indexingPausedSaver => 'बैटरी सेवर चालू रहने तक रुका हुआ';

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

    return 'इंडेक्स की गई फ़ोटो: $totalString में से $doneString';
  }

  @override
  String get indexingText => 'फ़ोटो में टेक्स्ट पढ़ें';

  @override
  String indexingTextDownloading(int percent) {
    return 'टेक्स्ट मॉडल डाउनलोड हो रहे हैं: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'टेक्स्ट मॉडल ($megabytesString MB) $host से डाउनलोड करता है; आपकी फ़ोटो में शब्द खोजता है';
  }

  @override
  String get indexingTextMissing =>
      'आपके सर्वर ने टेक्स्ट मॉडल इंस्टॉल नहीं किए हैं';

  @override
  String get indexingTextPlatform =>
      'आपके फ़ोन की अपनी टेक्स्ट पहचान का उपयोग करता है; कुछ डाउनलोड नहीं करना है। नई फ़ोटो पढ़ता है';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'टेक्स्ट के लिए पढ़ी गई फ़ोटो: $totalString में से $doneString';
  }

  @override
  String get indexingTextUnavailable => 'टेक्स्ट पढ़ना यहाँ उपलब्ध नहीं है';

  @override
  String get indexingTextWaiting => 'टेक्स्ट मॉडल Wi-Fi पर डाउनलोड होते हैं';

  @override
  String get indexingUnavailable => 'इस डिवाइस पर खोज यहाँ उपलब्ध नहीं है';

  @override
  String get indexingWaiting => 'सर्च मॉडल Wi-Fi पर डाउनलोड होगा';

  @override
  String get infoAddName => 'नाम जोड़ें';

  @override
  String get infoAddTag => 'टैग जोड़ें';

  @override
  String get infoAlbums => 'एल्बम';

  @override
  String get infoAllMetadata => 'सभी मेटाडेटा देखें';

  @override
  String get infoAuto => 'स्वतः';

  @override
  String get infoBackedUp => 'बैकअप लिया गया';

  @override
  String get infoCamera => 'कैमरा';

  @override
  String get infoChangeAdjust => 'रंग समायोजित किए';

  @override
  String get infoChangeCrop => 'काटा गया';

  @override
  String get infoChangeFlip => 'प्रतिबिंबित किया';

  @override
  String get infoChangeInpaint => 'एक क्षेत्र भरा';

  @override
  String get infoChangeLocal => 'एक क्षेत्र समायोजित किया';

  @override
  String get infoChangeLut => 'रंग शैली लागू की';

  @override
  String get infoChangeOther => 'संपादित';

  @override
  String get infoChangeTurn => 'घुमाया गया';

  @override
  String get infoCompare => 'मूल से तुलना करें';

  @override
  String infoConfidence(String percent) {
    return 'विश्वसनीयता: $percent';
  }

  @override
  String get infoCopyPath => 'पथ कॉपी करें';

  @override
  String get infoCurrent => 'वर्तमान';

  @override
  String get infoDescription => 'विवरण जोड़ें';

  @override
  String get infoEditDate => 'तारीख बदलें';

  @override
  String infoEditNumber(int number) {
    return 'संपादन $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '$name की संपादित कॉपी';
  }

  @override
  String get infoFaces => 'चेहरे';

  @override
  String get infoFile => 'फ़ाइल';

  @override
  String get infoFromFileName => 'फ़ाइल नाम से';

  @override
  String get infoHistory => 'संपादन इतिहास';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '$count आइटम',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'स्थान';

  @override
  String get infoMap => 'जहाँ इसे लिया गया, उसका मानचित्र';

  @override
  String get infoMapAgree =>
      'मैप टाइल इंटरनेट से आती हैं और बताती हैं कि आप कौन सा क्षेत्र देख रहे हैं';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'नया टैग: $path';
  }

  @override
  String get infoNoAlbum => 'किसी एल्बम में नहीं';

  @override
  String get infoOnDevice => 'इस डिवाइस पर';

  @override
  String get infoOriginal => 'मूल';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString पिक्सेल';
  }

  @override
  String infoRemoveFrom(String album) {
    return '$album से हटाएं';
  }

  @override
  String infoRemoveTag(String tag) {
    return '$tag हटाएं';
  }

  @override
  String infoRemovedFrom(String album) {
    return '$album से हटाया गया';
  }

  @override
  String get infoRevert => 'वापस लाएं';

  @override
  String get infoSaveCopy => 'कॉपी के रूप में सहेजें';

  @override
  String get infoShared => 'साझा';

  @override
  String get infoShowFaces => 'फ़ोटो पर चेहरे दिखाएं';

  @override
  String get infoShowMap => 'मैप दिखाएं';

  @override
  String get infoTags => 'टैग';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count संस्करण',
      one: '$count संस्करण',
    );
    return '$_temp0 · अंतिम $time';
  }

  @override
  String get infoWhy => 'यह तारीख क्यों?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'फ़ाइल में $tag के रूप में पढ़ी गई',
      'name': 'फ़ाइल के नाम से पढ़ी गई',
      'folder': 'किसी फ़ोल्डर के नाम से पढ़ी गई',
      'host': 'उस सेवा द्वारा दी गई जिससे फ़ाइल आई',
      'unknown': 'फ़ाइल में कुछ भी इसकी तारीख नहीं बताता, इसलिए इसके आख़िरी बदलाव की तारीख इस्तेमाल होती है',
      'other': 'फ़ाइल अभी पढ़ी नहीं गई है, इसलिए डिवाइस की दी गई तारीख इस्तेमाल होती है',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'सूची',
      'other': 'ग्रिड',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'नाम',
      'taken': 'फ़ोटो लेने की तारीख',
      'modified': 'बदलाव की तारीख',
      'size': 'आकार',
      'random': 'बेतरतीब',
      'extension': 'प्रकार',
      'custom': 'एल्बम का क्रम',
      'other': 'फ़ोटो लेने की तारीख',
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
  String get languageDevice => 'डिवाइस की भाषा';

  @override
  String get languageName => 'हिन्दी';

  @override
  String get libraryAddFolder => 'फ़ोल्डर जोड़ें';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'बैकअप नहीं हुआ',
      'backed_up': 'बैकअप हो गया',
      'cloud_only': 'सिर्फ़ क्लाउड में',
      'other': 'सभी',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'हर चीज़ का बैकअप हो गया है',
      'backed_up': 'अभी तक किसी का बैकअप नहीं हुआ',
      'cloud_only': 'सिर्फ़ सर्वर पर कुछ नहीं है',
      'other': 'यहां कुछ नहीं है',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'बैकअप बैज';

  @override
  String get libraryEmpty => 'आपकी फ़ोटो यहां दिखेंगी';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'हफ़्ते के हिसाब से ग्रुप करें',
      'month': 'महीने के हिसाब से ग्रुप करें',
      'other': 'दिन के हिसाब से ग्रुप करें',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'छिपे और संग्रहित आइटम फिर से छिपाएं';

  @override
  String get libraryNoKeyring =>
      'Photolib आपकी लाइब्रेरी की कुंजी सिस्टम कीरिंग में रखता है, जो चल नहीं रही है या लॉक है। GNOME Keyring या KWallet जैसी कोई कीरिंग शुरू या अनलॉक करें, फिर से कोशिश करें।';

  @override
  String get libraryRevealExcluded => 'बाहर रखे गए फ़ोल्डर 5 मिनट तक दिखाएं';

  @override
  String get libraryShowVeiled => 'छिपे और संग्रहित आइटम 5 मिनट के लिए दिखाएं';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'हाल ही में जोड़े गए',
      'other': 'फ़ोटो लेने की तारीख',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib इस डिवाइस पर रखी लाइब्रेरी नहीं खोल सका';

  @override
  String get libraryViewOptions => 'व्यू के विकल्प';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'थंबनेल तैयार हो रहे हैं: $totalString में से $doneString';
  }

  @override
  String get libraryZoomIn => 'बड़े थंबनेल';

  @override
  String get libraryZoomOut => 'छोटे थंबनेल';

  @override
  String get mapAddTrack => 'GPX ट्रैक जोड़ें';

  @override
  String get mapArea => 'मानचित्र का क्षेत्र';

  @override
  String get mapAttribution => '© OpenStreetMap योगदानकर्ता';

  @override
  String get mapClearLasso => 'चयन हटाएँ';

  @override
  String get mapEmpty => 'अभी तक किसी फ़ोटो में स्थान नहीं है';

  @override
  String get mapHeat => 'हीटमैप';

  @override
  String get mapLasso => 'फ़ोटो के चारों ओर घेरा बनाकर चुनें';

  @override
  String get mapLoading => 'फ़ोटो मानचित्र पर रखी जा रही हैं';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'फ़ोटो: $countString';
  }

  @override
  String get mapSearchHere => 'इस क्षेत्र में खोजें';

  @override
  String get mapSplit => 'मानचित्र के नीचे फ़ोटो दिखाएँ';

  @override
  String get mapTilesAgree =>
      'मानचित्र की पृष्ठभूमि OpenStreetMap के सर्वर (tile.openstreetmap.org) से आती है, जो देखता है कि आप कौन-सा क्षेत्र देख रहे हैं';

  @override
  String get mapTilesShow => 'पृष्ठभूमि दिखाएँ';

  @override
  String get mapTime => 'समय सीमा';

  @override
  String get mapTitle => 'मानचित्र';

  @override
  String get mapTrackBad => 'इस फ़ाइल में कोई GPX ट्रैक नहीं है';

  @override
  String get mapTrips => 'यात्राएँ';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'पसंदीदा',
      'hidden': 'छिपा हुआ',
      'archived': 'संग्रहित',
      'offline': 'इस डिवाइस पर रखा है',
      'offline': 'इस डिवाइस पर रखा है',
      'offline': 'इस डिवाइस पर रखा है',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'ऐक्सेस दें';

  @override
  String get mediaAccessNone =>
      'आपकी फ़ोटो और वीडियो दिखाने के लिए, Photolib को उनका ऐक्सेस चाहिए.';

  @override
  String get mediaAccessPartial =>
      'Photolib को सिर्फ़ वे फ़ोटो और वीडियो दिखते हैं जिन्हें आपने चुना है. गैलरी के लिए सभी का ऐक्सेस ज़रूरी है.';

  @override
  String get mediaAccessSelect => 'और फ़ोटो चुनें';

  @override
  String get nameLabel => 'नाम';

  @override
  String get nextAddRoot =>
      'सर्वर के कॉन्फ़िगरेशन में फ़ोल्डर को external_roots में जोड़ें, फिर सर्वर को फिर से शुरू करें।';

  @override
  String get nextAskAdmin => 'अपने सर्वर के एडमिनिस्ट्रेटर से पूछें।';

  @override
  String get nextAskOwner =>
      'लाइब्रेरी के मालिक से कहें कि वह आपको फ़ोटो जोड़ने दे।';

  @override
  String get nextCheckConnection => 'वजह जानने के लिए कनेक्शन जाँचें।';

  @override
  String get nextCheckEntry =>
      'आपने जो डाला है उसे जाँचें और फिर से कोशिश करें।';

  @override
  String get nextConfirm =>
      'देखें कि कितने आइटम प्रभावित होते हैं, फिर पुष्टि करें।';

  @override
  String get nextDeleteWebhook =>
      'कोई वेबहुक हटाएँ जिसका अब आप उपयोग नहीं करते, फिर दोबारा कोशिश करें।';

  @override
  String get nextEditConfig =>
      'इसे सर्वर के कॉन्फ़िगरेशन में बदलें, फिर सर्वर को फिर से शुरू करें।';

  @override
  String get nextFreeSpace =>
      'कुछ जगह खाली करें, या अपने एडमिनिस्ट्रेटर से और माँगें।';

  @override
  String get nextNewLink => 'अपने एडमिनिस्ट्रेटर से नया माँगें।';

  @override
  String get nextNewestToken => 'photolibd के लॉग से सबसे नया कॉपी करें।';

  @override
  String get nextOtherAdmin => 'पहले किसी दूसरे खाते को एडमिनिस्ट्रेटर बनाएँ।';

  @override
  String get nextOtherFolder => 'इसका अपना अलग फ़ोल्डर चुनें।';

  @override
  String get nextRefresh => 'रीफ़्रेश करके फिर से कोशिश करें।';

  @override
  String get nextReport =>
      'फिर से कोशिश करें। फिर से ऐसा हो, तो नीचे दिया विवरण अपने एडमिनिस्ट्रेटर के लिए कॉपी करें।';

  @override
  String get nextSetUpPrivate =>
      'सेटिंग में निजी लाइब्रेरी का सेटअप पूरा करें, फिर से कोशिश करें।';

  @override
  String get nextSignIn => 'फिर से साइन इन करें।';

  @override
  String get nextSignInAccount =>
      'अपने खाते से साइन इन करके फिर से कोशिश करें।';

  @override
  String get nextSignInInstead => 'इसकी जगह साइन इन करें।';

  @override
  String get nextTryAgain => 'फिर से कोशिश करें।';

  @override
  String get nextUpdateAndAgree =>
      'ऐप अपडेट करें, फिर सूचना से दोबारा सहमत हों।';

  @override
  String get nextUseAnother => 'कोई दूसरा चुनें।';

  @override
  String get nextUseHttps =>
      'सर्वर का https:// पता इस्तेमाल करें, या सर्वर के अपने नेटवर्क से कनेक्ट करें।';

  @override
  String get nextWait => 'एक मिनट रुककर फिर से कोशिश करें।';

  @override
  String get offlineKeep => 'ऑफ़लाइन रखें';

  @override
  String offlineKeepHere(String size) {
    return 'इस डिवाइस पर रखें ($size)';
  }

  @override
  String get offlineKeptHere => 'इस डिवाइस पर रखा है';

  @override
  String get offlineStopKeeping => 'ऑफ़लाइन रखना बंद करें';

  @override
  String get otherFiles => 'अन्य फ़ाइलें';

  @override
  String get passphraseCreate =>
      'इस कंप्यूटर पर Photolib की कुंजियां रखने के लिए कोई कीरिंग (Secret Service) नहीं चल रही है. उन्हें सुरक्षित रखने के लिए कम से कम 10 वर्णों का पासफ़्रेज़ चुनें: Photolib हर बार शुरू होने पर इसे पूछेगा.';

  @override
  String get passphraseLabel => 'पासफ़्रेज़';

  @override
  String get passphraseMismatch => 'पासफ़्रेज़ मेल नहीं खाते.';

  @override
  String get passphraseRepeat => 'पासफ़्रेज़ फिर से डालें';

  @override
  String get passphraseTooShort => 'कम से कम 10 वर्ण इस्तेमाल करें.';

  @override
  String get passphraseUnlock =>
      'वह पासफ़्रेज़ डालें जो इस कंप्यूटर पर Photolib की कुंजियों को सुरक्षित रखता है.';

  @override
  String get passphraseWrong => 'गलत पासफ़्रेज़. फिर से कोशिश करें.';

  @override
  String photoPosition(int index, int count) {
    return '$count में से फ़ोटो $index';
  }

  @override
  String get privacyCheckKit => 'रिकवरी किट जाँचें';

  @override
  String get privacyDrillDue =>
      'रिकवरी अभ्यास का समय: जाँचें कि आपकी रिकवरी किट अब भी आपकी निजी लाइब्रेरी खोलती है।';

  @override
  String get privacyHonest =>
      'निजी लाइब्रेरी आपके डिवाइस पर एन्क्रिप्ट होती हैं, और कोई और उन्हें नहीं खोल सकता: न सर्वर, न उसका एडमिनिस्ट्रेटर, न Photolib के डेवलपर। अगर आप अपना पासवर्ड और अपनी रिकवरी किट दोनों खो देते हैं, तो आपकी फ़ोटो हमेशा के लिए खो जाती हैं, और कोई उन्हें आपके लिए वापस नहीं ला सकता।';

  @override
  String get privacyKitBody =>
      'इन 24 शब्दों को क्रम से कागज़ पर लिखें और किसी सुरक्षित जगह रखें। अगर आप अपना पासवर्ड भूल जाएँ, तो ये आपकी निजी लाइब्रेरी खोलते हैं, जिसके भी पास ये हों उसके लिए।';

  @override
  String get privacyKitDone => 'आपकी रिकवरी किट काम करती है।';

  @override
  String get privacyKitOther => 'यह आपकी मौजूदा रिकवरी किट नहीं है।';

  @override
  String get privacyKitTitle => 'आपकी रिकवरी किट';

  @override
  String get privacyKitUnverified => 'रिकवरी किट अभी सत्यापित नहीं हुई';

  @override
  String privacyKitVerified(String date) {
    return 'रिकवरी किट $date को सत्यापित हुई';
  }

  @override
  String get privacyKitWritten => 'मैंने इन्हें लिख लिया';

  @override
  String get privacyNotReady =>
      'जब तक आपके पास अनलॉक करने के दो तरीके न हों और आपने अपनी रिकवरी किट सत्यापित न की हो, निजी अपलोड बंद रहते हैं।';

  @override
  String get privacyPasswordHelp =>
      'अपने खाते का पासवर्ड डालें: यह आपकी निजी लाइब्रेरी अनलॉक करने का एक तरीका बन जाता है।';

  @override
  String get privacyPhrase => 'रिकवरी वाक्यांश';

  @override
  String get privacyPhraseHelp => 'आपकी रिकवरी किट के 24 शब्द';

  @override
  String get privacyPhraseInvalid =>
      'यह रिकवरी वाक्यांश नहीं है। हर शब्द जाँचें।';

  @override
  String get privacyReady => 'निजी अपलोड चालू हैं।';

  @override
  String get privacyRecoveryKit => 'रिकवरी किट';

  @override
  String get privacySetUp => 'सेट अप करें';

  @override
  String get privacyShowWords => 'शब्द फिर से दिखाएँ';

  @override
  String get privacyTitle => 'निजी लाइब्रेरी';

  @override
  String privacyUnknownWord(int number) {
    return 'शब्द $number रिकवरी किट का शब्द नहीं है।';
  }

  @override
  String get privacyVerify => 'सत्यापित करें';

  @override
  String get privacyVerifyBody =>
      'यह दिखाने के लिए कि आपने इसे सहेजा है, अपनी रिकवरी किट से ये शब्द टाइप करें।';

  @override
  String get privacyWays => 'अनलॉक करने के तरीके';

  @override
  String privacyWord(int number) {
    return 'शब्द $number';
  }

  @override
  String get privacyWordsDiffer =>
      'ये शब्द आपकी रिकवरी किट से मेल नहीं खाते। जो आपने लिखा था उसे जाँचें।';

  @override
  String get privacyWrongPassword => 'यह आपके खाते का पासवर्ड नहीं है।';

  @override
  String get problemAdminOnly => 'यह सिर्फ़ एडमिनिस्ट्रेटर कर सकता है।';

  @override
  String get problemBusy => 'सर्वर व्यस्त है या फिर से शुरू हो रहा है।';

  @override
  String get problemChanged => 'इस बीच यह बदल गया है।';

  @override
  String get problemConfirm =>
      'इससे उससे ज़्यादा आइटम छिप जाएँगे या हट जाएँगे, जितने सर्वर बिना पुष्टि के करता है';

  @override
  String get problemContribute => 'आप इस लाइब्रेरी में फ़ोटो नहीं जोड़ सकते।';

  @override
  String get problemCopy => 'विवरण कॉपी करें';

  @override
  String get problemDetails => 'विवरण';

  @override
  String get problemDiskLow =>
      'सर्वर की डिस्क लगभग भर गई है, इसलिए अपलोड रुके हुए हैं।';

  @override
  String get problemEmailTaken => 'यह ईमेल किसी दूसरे खाते का है।';

  @override
  String get problemExists => 'यह पहले से मौजूद है।';

  @override
  String get problemFaceNotice =>
      'आपका सर्वर चेहरों की सूचना का इस ऐप से नया संस्करण माँगता है।';

  @override
  String get problemGone => 'यह अब सर्वर पर नहीं है।';

  @override
  String get problemHandleTaken => 'यह साइन-इन नाम किसी दूसरे खाते का है।';

  @override
  String get problemInterrupted => 'अपलोड बीच में रुक गया।';

  @override
  String get problemInvalid => 'एक वैल्यू अमान्य है';

  @override
  String get problemLastAdmin => 'सर्वर को कम से कम एक एडमिनिस्ट्रेटर चाहिए।';

  @override
  String get problemLinkInvalid =>
      'इस लिंक की अवधि खत्म हो गई है या इसका इस्तेमाल हो चुका है।';

  @override
  String get problemLoginFailed => 'ईमेल, साइन-इन नाम या पासवर्ड गलत है।';

  @override
  String get problemMaintenanceKey =>
      'बैकअप, डेटा की जांच और हमेशा के लिए मिटाने के काम सिर्फ़ साइन इन करके रोके जा सकते हैं, API कुंजी से नहीं';

  @override
  String get problemNotAllowed => 'आपके खाते को यह करने की अनुमति नहीं है।';

  @override
  String get problemNotExternal =>
      'सिर्फ़ सर्वर के अपने फ़ोल्डरों की लाइब्रेरी ही स्कैन की जा सकती हैं।';

  @override
  String get problemOidcClaim =>
      'आपके साइन-इन प्रदाता ने यह नहीं बताया कि आप कौन हैं, उस तरह से जिसे यह सर्वर मानता है।';

  @override
  String get problemOidcDown =>
      'आपका साइन-इन प्रदाता सर्वर को जवाब नहीं दे रहा है।';

  @override
  String get problemOidcFailed =>
      'आपके साइन-इन प्रदाता ने साइन-इन मना कर दिया।';

  @override
  String get problemOidcNotAllowed =>
      'आपका खाता इस तरीके से साइन इन नहीं कर सकता।';

  @override
  String get problemOidcTaken =>
      'यह साइन-इन पहले से किसी दूसरे Photolib खाते से जुड़ा है।';

  @override
  String get problemOidcUnknown => 'यह सर्वर अब साइन इन का यह तरीका नहीं देता।';

  @override
  String get problemPasskeysOff =>
      'पासकी तभी काम करती हैं जब सर्वर के पास उसका सार्वजनिक पता हो।';

  @override
  String get problemPinned =>
      'यह कॉन्फ़िगरेशन फ़ाइल में सेट है और इसे यहां नहीं बदला जा सकता।';

  @override
  String get problemPolicyOff => 'यह इस सर्वर पर बंद है।';

  @override
  String get problemQuota => 'सर्वर पर आपका स्टोरेज भर गया है।';

  @override
  String get problemRestoreKey =>
      'बैकअप सिर्फ़ साइन इन करके पुनर्स्थापित किया जा सकता है, API कुंजी से नहीं।';

  @override
  String get problemRootDiffers =>
      'इस फ़ोल्डर में इस लाइब्रेरी की फ़ाइलें नहीं हैं';

  @override
  String get problemRootNotAllowed =>
      'यह फ़ोल्डर सर्वर के कॉन्फ़िगरेशन के external_roots के अंदर नहीं है';

  @override
  String get problemRootOverlaps =>
      'इस फ़ोल्डर में कोई दूसरी लाइब्रेरी या सर्वर का अपना डेटा है, या यह उनके अंदर है';

  @override
  String get problemScanning => 'इस लाइब्रेरी को पहले से स्कैन किया जा रहा है';

  @override
  String get problemSecondFactor =>
      'इस खाते के लिए दूसरा फ़ैक्टर ज़रूरी है, जैसे ऑथेंटिकेटर कोड या पासकी, जिसे Photolib का यह वर्शन अभी नहीं दे सकता।';

  @override
  String get problemSetupDone => 'इस सर्वर का पहले से एक एडमिनिस्ट्रेटर है।';

  @override
  String get problemSetupExpired => 'इसमें बहुत ज़्यादा समय लगा।';

  @override
  String get problemSetupToken => 'यह सेटअप टोकन गलत है।';

  @override
  String get problemSignedOut => 'आप सर्वर से साइन आउट हैं।';

  @override
  String get problemStepUp =>
      'इस बदलाव के लिए पहले आपका पासवर्ड या कोई कोड चाहिए।';

  @override
  String get problemStorage => 'सर्वर अपने स्टोरेज तक नहीं पहुँच पा रहा है।';

  @override
  String get problemTooMany => 'कम समय में बहुत ज़्यादा प्रयास।';

  @override
  String get problemUnexpected => 'कुछ अनपेक्षित गड़बड़ हो गई।';

  @override
  String get problemUnreachable => 'सर्वर जवाब नहीं दे रहा है।';

  @override
  String get problemUploadDamaged => 'फ़ाइल रास्ते में बदल गई या खराब हो गई।';

  @override
  String get problemUploadExpired =>
      'सर्वर के पास अब यह अपलोड नहीं है: अधूरे अपलोड एक दिन बाद खत्म हो जाते हैं।';

  @override
  String get problemWebhookLimit =>
      'आपके खाते में पहले से ही अधिकतम अनुमत वेबहुक हैं।';

  @override
  String get problemWebhooksOff => 'इस सर्वर पर वेबहुक बंद हैं।';

  @override
  String get recoveryCode => 'रिकवरी कोड';

  @override
  String get recoveryCodeAbout =>
      'अगर कीस्टोर अपनी कुंजी खो दे, तो इस डिवाइस पर Photolib का स्टोर खोलता है';

  @override
  String get recoveryCodeEnter => 'रिकवरी कोड डालें';

  @override
  String get recoveryCreate => 'रिकवरी कोड बनाएँ';

  @override
  String get recoveryLater => 'बाद में';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString बदलाव सिर्फ़ इस डिवाइस पर हैं। अगर कीस्टोर Photolib की कुंजी खो दे, तो रिकवरी कोड उन्हें वापस लाता है।',
      one:
          '$countString बदलाव सिर्फ़ इस डिवाइस पर है। अगर कीस्टोर Photolib की कुंजी खो दे, तो रिकवरी कोड उसे वापस लाता है।',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'ये 24 शब्द लिख लें और सुरक्षित रखें: ये कीस्टोर की कुंजी के बिना इस डिवाइस पर Photolib का स्टोर खोलते हैं। ये किसी भी पिछले कोड की जगह लेते हैं।';

  @override
  String get recoveryUnlock => 'अनलॉक करें';

  @override
  String get recoveryWrong => 'यह इस स्टोर का रिकवरी कोड नहीं है';

  @override
  String get renameFind => 'खोजें';

  @override
  String get renamePattern => 'नया नाम';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'बहुत लंबा: नाम में अधिकतम 255 बाइट होते हैं',
      'invalid': 'मान्य फ़ाइल नाम नहीं',
      'duplicate': 'किसी दूसरी फ़ाइल को भी दिया गया',
      'exists': 'इस फ़ोल्डर की एक और फ़ाइल का यही नाम है',
      'other': 'नाम नहीं बदला जा सकता',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'इससे बदलें';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'नाम बदली गई फ़ाइलें: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Finder में दिखाएँ',
      'windows': 'एक्सप्लोरर में दिखाएँ',
      'other': 'फ़ोल्डर में दिखाएँ',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'कैमरा';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम',
      one: '$countString आइटम',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'तारीखें';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'अपनी लाइब्रेरी में खोजें';

  @override
  String get searchFavourites => 'पसंदीदा';

  @override
  String get searchFolder => 'फ़ोल्डर';

  @override
  String get searchHint => 'फ़ाइल या फ़ोल्डर का नाम';

  @override
  String get searchMotionPhotos => 'मोशन फ़ोटो';

  @override
  String get searchNothing => 'कोई मिलता-जुलता नतीजा नहीं मिला';

  @override
  String get searchPanoramas => 'पैनोरमा';

  @override
  String get searchPhotos => 'फ़ोटो';

  @override
  String get searchScreenshots => 'स्क्रीनशॉट';

  @override
  String get searchVideo => 'वीडियो';

  @override
  String get searchVideos => 'वीडियो';

  @override
  String get securityAddPasskey => 'पासकी जोड़ें';

  @override
  String get securityCode => 'कोड';

  @override
  String get securityCodesHelp =>
      'इन कोड को किसी सुरक्षित जगह रखें। हर कोड आपके दूसरे फ़ैक्टर की जगह एक बार काम करता है, और ये सिर्फ़ अभी दिखाए जाते हैं।';

  @override
  String securityCodesLeft(int count) {
    return 'इस्तेमाल नहीं हुए: $count';
  }

  @override
  String get securityNewCodes => 'नए कोड';

  @override
  String get securityPasskeyNotAdded => 'कोई पासकी नहीं जोड़ी गई।';

  @override
  String get securityRecoveryCodes => 'रिकवरी कोड';

  @override
  String get securityRemovePasskey => 'पासकी हटाएं';

  @override
  String get securitySetUp => 'सेट अप करें';

  @override
  String get securityStepUpBody =>
      'अपने दूसरे फ़ैक्टर बदलने के लिए अपना पासवर्ड, ऑथेंटिकेटर ऐप का कोड या कोई रिकवरी कोड डालें।';

  @override
  String get securityStepUpTitle => 'पुष्टि करें कि यह आप हैं';

  @override
  String get securityTitle => 'दूसरे फ़ैक्टर';

  @override
  String get securityTotp => 'ऑथेंटिकेटर ऐप';

  @override
  String get securityTotpHelp =>
      'यह कुंजी अपने ऑथेंटिकेटर ऐप में जोड़ें, फिर वह जो कोड दिखाए उसे डालें।';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'चालू',
      'other': 'बंद',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'बंद करें';

  @override
  String get securityWrongCode => 'यह कोड गलत है।';

  @override
  String get securityWrongProof => 'पासवर्ड या कोड गलत है।';

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String get selectionClear => 'चुनाव हटाएं';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम चुने गए',
      one: '$countString आइटम चुना गया',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'चुने गए आइटम दिखाएं';

  @override
  String get serverAccount => 'ईमेल या साइन-इन नाम';

  @override
  String get serverAdd => 'सर्वर जोड़ें';

  @override
  String get serverAddressInvalid => 'photos.example.org जैसे पते डालें';

  @override
  String get serverAddresses => 'पते';

  @override
  String get serverAddressesHelp =>
      'हर लाइन में एक: आपके नेटवर्क पर, इंटरनेट पर या VPN से सर्वर। ऐप जवाब देने वालों में सबसे तेज़ पता इस्तेमाल करता है। या आपको भेजा गया पासवर्ड सेट करने का लिंक चिपकाएँ।';

  @override
  String get serverCa => 'निजी CA का सर्टिफ़िकेट (PEM)';

  @override
  String get serverCaChoose => 'सर्टिफ़िकेट फ़ाइल चुनें';

  @override
  String serverCertificateBody(String host) {
    return '$host ऐसा सर्टिफ़िकेट दिखा रहा है जिस पर यह डिवाइस भरोसा नहीं करता। इस पर तभी भरोसा करें जब यह SHA-256 फ़िंगरप्रिंट आपके सर्वर का हो:';
  }

  @override
  String get serverCertificateTitle => 'इस सर्टिफ़िकेट पर भरोसा करें?';

  @override
  String get serverConfirm => 'पुष्टि करें';

  @override
  String get serverConnect => 'कनेक्ट करें';

  @override
  String get serverCreateAdmin => 'एडमिन बनाएँ';

  @override
  String get serverEnded =>
      'सर्वर ने यह सेशन खत्म कर दिया। फिर से साइन इन करें।';

  @override
  String get serverHandleHelp =>
      'छोटे अक्षर, अंक, बिंदु, डैश और अंडरस्कोर; यह कभी नहीं बदलता।';

  @override
  String get serverHeaders => 'कस्टम हेडर';

  @override
  String get serverHeadersHelp =>
      'हर लाइन में एक, Name: value के रूप में; सिर्फ़ HTTPS पर भेजे जाते हैं';

  @override
  String get serverHeadersInvalid => 'हर हेडर को Name: value के रूप में लिखें';

  @override
  String get serverIdentity => 'क्लाइंट प्रमाणपत्र (PKCS#12)';

  @override
  String get serverIdentityChoose => 'क्लाइंट प्रमाणपत्र चुनें';

  @override
  String get serverIdentityInvalid =>
      'यह प्रमाणपत्र (PKCS#12) नहीं है, या इसका पासवर्ड गलत है।';

  @override
  String get serverIdentityPassword => 'क्लाइंट प्रमाणपत्र का पासवर्ड';

  @override
  String get serverLoading => 'इस डिवाइस पर रखा सर्वर पढ़ा जा रहा है';

  @override
  String get serverNearby => 'इस नेटवर्क पर सर्वर';

  @override
  String get serverNeedsHttps =>
      'इस सर्वर को HTTPS पता चाहिए: आपके स्थानीय नेटवर्क के बाहर Photolib सादे HTTP पर साइन इन नहीं करता।';

  @override
  String get serverNoSignIn =>
      'यह सर्वर साइन इन का कोई ऐसा तरीका नहीं देता जो Photolib के इस वर्शन में काम करे।';

  @override
  String get serverOffline => 'सर्वर जवाब नहीं दे रहा है। आप साइन इन रहेंगे।';

  @override
  String get serverPasskeyFailed =>
      'कोई पासकी इस्तेमाल नहीं हुई। फिर से कोशिश करें, या कोड इस्तेमाल करें।';

  @override
  String get serverPasskeyRequired =>
      'इस सर्वर के लिए पासकी ज़रूरी है, जिसे Photolib का यह वर्शन अभी इस्तेमाल नहीं कर सकता।';

  @override
  String get serverPassword => 'पासवर्ड';

  @override
  String get serverPasswordAgain => 'पासवर्ड फिर से डालें';

  @override
  String get serverPasswordSetupInvalid =>
      'यह पासवर्ड सेटअप टोकन गलत है, पहले ही इस्तेमाल हो चुका है या समाप्त हो गया है। नया टोकन माँगें।';

  @override
  String get serverPasswordSetupToken => 'पासवर्ड सेटअप टोकन';

  @override
  String get serverPasswordSetupTokenHelp =>
      'आपके व्यवस्थापक से, या सर्वर पर photolibd admin password-setup द्वारा छापा गया।';

  @override
  String get serverPasswordsDiffer => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get serverPrivateLibrariesBody =>
      'नया पासवर्ड उन्हें नहीं खोलता। उन्हें अपनी रिकवरी किट, पासकी या ऐसे डिवाइस से फिर खोलें जिसमें अब भी साइन इन है।';

  @override
  String get serverPrivateLibrariesGo => 'पासवर्ड सेट करें';

  @override
  String get serverPrivateLibrariesTitle => 'आपकी निजी लाइब्रेरी लॉक रहती हैं';

  @override
  String get serverProxy => 'HTTP प्रॉक्सी, host:port के रूप में';

  @override
  String get serverProxyInvalid => 'प्रॉक्सी को host:port के रूप में डालें';

  @override
  String get serverRecoveryCode => 'रिकवरी कोड';

  @override
  String get serverRemove => 'यह सर्वर हटाएँ';

  @override
  String get serverRequired => 'ज़रूरी';

  @override
  String get serverSecondFactor =>
      'इस खाते का दूसरा फ़ैक्टर पासकी है, जिसे Photolib का यह वर्शन अभी इस्तेमाल नहीं कर सकता।';

  @override
  String get serverSecondFactorCode =>
      'इस खाते के लिए आपके ऑथेंटिकेटर ऐप का कोड या कोई रिकवरी कोड भी ज़रूरी है।';

  @override
  String get serverSecondFactorTitle => 'पुष्टि करें कि यह आप हैं';

  @override
  String get serverSecondFactorWrong =>
      'यह काम नहीं किया। पाँच कोशिशों के बाद फिर से साइन इन करें।';

  @override
  String get serverSetPassword => 'पासवर्ड सेट करें';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '$server पर $handle के लिए';
  }

  @override
  String get serverSetPasswordOpen => 'पासवर्ड सेट करें';

  @override
  String get serverSetPasswordTitle => 'अपना पासवर्ड सेट करें';

  @override
  String get serverSetUp => 'नया सर्वर सेट अप करें';

  @override
  String get serverSetupLinkElsewhere =>
      'इस लिंक का इस्तेमाल करने के लिए पहले इस सर्वर से साइन आउट करें, या अगर लिंक किसी दूसरे सर्वर का है तो इसे हटाएँ।';

  @override
  String get serverSetupTitle => 'सर्वर सेट अप करें';

  @override
  String get serverSetupToken => 'सेटअप टोकन';

  @override
  String get serverSetupTokenHelp =>
      'जब तक सर्वर पर कोई एडमिन नहीं है, photolibd इसे अपने लॉग में लिखता है; हर बार शुरू होने पर नया लिखता है।';

  @override
  String get serverSignIn => 'साइन इन करें';

  @override
  String get serverSignOut => 'साइन आउट करें';

  @override
  String serverSignedInAs(String account) {
    return '$account के तौर पर साइन इन है';
  }

  @override
  String get serverSignedOut => 'साइन आउट है';

  @override
  String get serverSwitch => 'खाता बदलें';

  @override
  String get serverTotpCode => 'ऑथेंटिकेटर ऐप से कोड';

  @override
  String get serverTrust => 'भरोसा करें';

  @override
  String get serverUnreadable => 'इस डिवाइस पर रखा सर्वर पढ़ा नहीं जा सकता';

  @override
  String get serverUsePasskey => 'पासकी इस्तेमाल करें';

  @override
  String get serverUseRecoveryCode => 'इसके बजाय रिकवरी कोड इस्तेमाल करें';

  @override
  String get settingsBackground => 'पारदर्शी इमेज के पीछे';

  @override
  String get settingsDefaultTab => 'फ़ोल्डर और एल्बम इस टैब पर खुलते हैं';

  @override
  String get settingsFolders => 'फ़ोल्डर';

  @override
  String get settingsIndexing => 'इस डिवाइस पर इंडेक्सिंग';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLibrary => 'लाइब्रेरी';

  @override
  String get settingsServer => 'सर्वर';

  @override
  String get settingsStart => 'शुरुआती स्क्रीन';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get settingsTitle => 'सेटिंग';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'पिछले या अगले आइटम के लिए बाएँ या दाएँ किनारे पर टैप करें',
      'oneFingerZoom': 'एक उंगली से ज़ूम करने के लिए दो बार टैप करके खींचें',
      'swipes': 'चमक के लिए वीडियो के बाईं ओर और वॉल्यूम के लिए दाईं ओर ऊपर या नीचे स्वाइप करें',
      'maxBrightness': 'देखते समय पूरी चमक',
      'autoRotate': 'हर फ़ोटो या वीडियो के ओरिएंटेशन के अनुसार घुमाएँ',
      'mixAudio': 'दूसरी ऑडियो को रोके बिना उसके साथ वीडियो चलाएँ',
      'autoplay': 'वीडियो खुलते ही चलाएं',
      'loop': 'वीडियो लूप करें',
      'autoNext': 'वीडियो खत्म होने पर अगले आइटम पर जाएँ',
      'resume': 'वीडियो वहीं से फिर चलाएँ जहाँ छोड़े थे',
      'other': 'ग्रिड में एनिमेटेड इमेज चलाएँ',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep => 'Photolib ट्रैश में आइटम कितने समय रखता है';

  @override
  String get settingsViewerBar => 'व्यूअर के बार में बटन';

  @override
  String get settingsViewing => 'देखना';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'शेयर किए गए $countString फ़ोटो और वीडियो तब तक इंतज़ार कर रहे हैं, जब तक Photolib को उन्हें आपकी फ़ोटो लाइब्रेरी में जोड़ने की अनुमति नहीं मिलती. सेव न किए गए आइटम 7 दिन बाद मिटा दिए जाते हैं.',
      one:
          'शेयर की गई $countString फ़ोटो या वीडियो तब तक इंतज़ार कर रही है, जब तक Photolib को उसे आपकी फ़ोटो लाइब्रेरी में जोड़ने की अनुमति नहीं मिलती. सेव न किए गए आइटम 7 दिन बाद मिटा दिए जाते हैं.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'एक बार में साझा करने के लिए बहुत बड़ा: कम आइटम चुनें';

  @override
  String shareTooMany(int count) {
    return 'एक बार में साझा करने के लिए बहुत अधिक: अधिकतम $count चुनें';
  }

  @override
  String get shortcutsTitle => 'कीबोर्ड शॉर्टकट';

  @override
  String get slideshow => 'स्लाइड शो';

  @override
  String get slideshowLoop => 'दोहराएँ';

  @override
  String get slideshowOptions => 'स्लाइड शो के विकल्प';

  @override
  String get slideshowSeconds => 'प्रति आइटम सेकंड';

  @override
  String get slideshowShuffle => 'क्रम बदलें';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'अवरोही',
      'other': 'आरोही',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'यह डिवाइस';

  @override
  String sourceHide(String name) {
    return '$name छिपाएं';
  }

  @override
  String get sourceHideOthers => 'यहां बाकी सब छिपाएं';

  @override
  String get sourceLost => 'पहुंच नहीं';

  @override
  String get sourcePartly => 'आंशिक रूप से दिखाया गया';

  @override
  String sourceShow(String name) {
    return '$name दिखाएं';
  }

  @override
  String get sourceShowEverything => 'यहां का सब कुछ दिखाएं';

  @override
  String get sourceShowOnly => 'सिर्फ़ इसे दिखाएं';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'टाइमलाइन',
      'folders': 'फ़ोल्डर और एल्बम',
      'favourites': 'पसंदीदा',
      'other': 'टाइमलाइन',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'किसी व्यक्ति को ऑफ़लाइन रखें';

  @override
  String get storageBudget => 'स्टोरेज सीमा';

  @override
  String get storageClear => 'ऑफ़लाइन कॉपी हटाएँ';

  @override
  String get storageClearAction => 'हटाएँ';

  @override
  String storageClearBody(String size) {
    return 'इससे इस डिवाइस पर रखे $size हट जाएँगे और ऐल्बम, खोज और फ़ोटो ऑफ़लाइन रखना बंद हो जाएगा। सर्वर पर आपकी लाइब्रेरी को छुआ नहीं जाएगा।';
  }

  @override
  String get storageKeepLibrary => 'पूरी लाइब्रेरी रखें';

  @override
  String get storageKeepOriginals => 'मूल फ़ाइलें भी रखें';

  @override
  String get storageNoPeople => 'अभी किसी व्यक्ति का नाम नहीं रखा गया।';

  @override
  String get storageNoPins =>
      'कुछ भी पिन नहीं है। ऑफ़लाइन रखने के लिए कोई ऐल्बम, खोज या फ़ोटो पिन करें।';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'ऐल्बम',
      'search': 'खोज',
      'person': 'व्यक्ति',
      'library': 'पूरी लाइब्रेरी',
      'asset': 'फ़ोटो',
      'other': 'पिन किया',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'सीमा में नहीं आता: $size और चाहिए';
  }

  @override
  String get storagePinNothing =>
      'डाउनलोड करने को कुछ नहीं: इसकी फ़ोटो पहले से इस डिवाइस पर हैं';

  @override
  String get storagePinPaused =>
      'प्रतीक्षा: यह प्रीसेट कुछ भी ऑफ़लाइन नहीं रखता';

  @override
  String get storagePinPlanning => 'देख रहे हैं कि क्या रखना है…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'डाउनलोड हो रहा है: $filesString में से $haveString';
  }

  @override
  String storagePinReady(String size) {
    return 'ऑफ़लाइन उपलब्ध ($size)';
  }

  @override
  String get storagePinWaiting => 'ऑनलाइन होने पर डाउनलोड होगा';

  @override
  String get storagePins => 'ऑफ़लाइन रखा गया';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'केवल कैटलॉग',
      'spaceSaver': 'जगह बचाएँ',
      'travel': 'चुने हुए ऐल्बम ऑफ़लाइन',
      'everything': 'सब कुछ',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'कुछ नहीं रखता; खोलने पर फ़ोटो आपके सर्वर से लोड होती हैं।',
      'spaceSaver':
          'पूरी लाइब्रेरी के प्रीव्यू रखता है, नए पहले, सीमा के भीतर।',
      'travel': 'केवल वही रखता है जो आप पिन करें: ऐल्बम, खोज और फ़ोटो।',
      'everything':
          'पूरी लाइब्रेरी की मूल फ़ाइलें रखता है, नई पहले, सीमा के भीतर।',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'यह डिवाइस क्या रखता है';

  @override
  String get storageSubtitle => 'ऑफ़लाइन कॉपी और स्टोरेज सीमा';

  @override
  String get storageTitle => 'स्टोरेज';

  @override
  String storageUsed(String used, String budget) {
    return '$budget में से $used उपयोग में';
  }

  @override
  String get storageWebNote =>
      'ब्राउज़र केवल प्रीव्यू रखता है और साइन आउट पर मिटा देता है।';

  @override
  String get storeNoKeyring =>
      'Photolib अपने लोकल स्टोर की कुंजी सिस्टम कीरिंग में रखता है, जिसने जवाब नहीं दिया। Secret Service चालू रखकर gnome-keyring, KWallet या KeePassXC इंस्टॉल और अनलॉक करें, फिर दोबारा कोशिश करें।';

  @override
  String get storeNoKeystore =>
      'Photolib इस डिवाइस के कीस्टोर तक नहीं पहुँच सका, जिसमें उसके लोकल स्टोर की कुंजी है।';

  @override
  String get storeRebuilt =>
      'इस डिवाइस के कीस्टोर में अब Photolib के लोकल स्टोर की कुंजी नहीं थी, इसलिए स्टोर फिर से बनाया गया। उसकी सेटिंग और जो सिर्फ़ इस डिवाइस पर था, वह खो गया; लाइब्रेरी फिर से सिंक होती हैं और थंबनेल वापस आते हैं।';

  @override
  String get storeRecoveryNeeded =>
      'इस डिवाइस के कीस्टोर में अब Photolib के लोकल स्टोर की कुंजी नहीं है। उसका रिकवरी कोड डालें, या स्टोर रीसेट करें और जो सिर्फ़ इस डिवाइस पर है उसे खो दें।';

  @override
  String get storeReset => 'स्टोर रीसेट करें';

  @override
  String get storeResetBody =>
      'जो सिर्फ़ इस डिवाइस पर है, वह खो जाएगा; लाइब्रेरी फिर से सिंक होती हैं और थंबनेल वापस आते हैं।';

  @override
  String get storeUnavailable =>
      'इस डिवाइस का स्टोर उपलब्ध नहीं है: सेटिंग और कलेक्शन सहेजे नहीं जाते';

  @override
  String get tabCollections => 'कलेक्शन';

  @override
  String get tabLibrary => 'लाइब्रेरी';

  @override
  String get tabSearch => 'खोजें';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get timelineBenchmark => 'टाइमलाइन बेंचमार्क';

  @override
  String get timelineBenchmarkCopy => 'परिणाम कॉपी करें';

  @override
  String get timelineCannotPlay => 'इस ब्राउज़र में नहीं चल सकता';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $count में से $position';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $count में से $position, कोई पूर्वावलोकन नहीं';
  }

  @override
  String get timelineExcluded => 'बाहर रखे गए फ़ोल्डर में';

  @override
  String get timelineScrubber => 'तारीख के हिसाब से स्क्रोल करें';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'अज्ञात तारीख';

  @override
  String timelineWeek(String date) {
    return '$date से शुरू होने वाला हफ़्ता';
  }

  @override
  String toolbarAdd(String action) {
    return '$action को बार में जोड़ें';
  }

  @override
  String toolbarDown(String action) {
    return '$action को नीचे ले जाएं';
  }

  @override
  String get toolbarInBar => 'बार में';

  @override
  String get toolbarInMenu => '⋮ मेनू में';

  @override
  String toolbarRemove(String action) {
    return '$action को बार से हटाएं';
  }

  @override
  String get toolbarReset => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String toolbarUp(String action) {
    return '$action को ऊपर ले जाएं';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'यहाँ ले जाएं',
      'other': 'यहाँ कॉपी करें',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'इस नाम की फ़ाइल या फ़ोल्डर पहले से है',
      'changed': 'कॉपी मूल से मेल नहीं खाई और हटा दी गई',
      'cancelled': 'रद्द किया गया',
      'invalid': 'मान्य फ़ोल्डर नाम नहीं',
      'other': 'विफल',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'हाल के';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString आइटम हमेशा के लिए हटाएं? इसे पूर्ववत नहीं किया जा सकता।',
      one:
          '$countString आइटम हमेशा के लिए हटाएं? इसे पूर्ववत नहीं किया जा सकता।',
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
      other: '$daysString दिन बाकी',
      one: '$daysString दिन बाकी',
      zero: 'आज हमेशा के लिए हट जाएगा',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'ट्रैश खाली है';

  @override
  String get trashEmptyAll => 'ट्रैश खाली करें';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString दिन';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम ट्रैश में ले जाए गए',
      one: '$countString आइटम ट्रैश में ले जाया गया',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'सूची से हटाएँ';

  @override
  String trashRetention(int days) {
    return 'Photolib ट्रैश में रखी चीज़ों को $days दिनों के बाद हमेशा के लिए हटा देता है; हर आइटम बताता है कि उसका कितना समय बचा है।';
  }

  @override
  String get trashTitle => 'ट्रैश';

  @override
  String get undo => 'पहले जैसा करें';

  @override
  String get uploadAction => 'फ़ोटो और वीडियो अपलोड करें';

  @override
  String get uploadClear => 'साफ़ करें';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$totalString में से $doneString अपलोड हुए';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'विफल: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString आइटम संग्रहित किए गए',
      one: '$countString आइटम संग्रहित किया गया',
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
      other: '$countString आइटम छिपाए गए',
      one: '$countString आइटम छिपाया गया',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'काला',
      'white': 'सफ़ेद',
      'other': 'चेकरबोर्ड',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => 'यह वीडियो इस डिवाइस पर नहीं चल सकता';

  @override
  String get viewerCaptions => 'कैप्शन';

  @override
  String get viewerCompass => 'कम्पास लॉक';

  @override
  String get viewerCopy => 'कॉपी करें';

  @override
  String get viewerCopyText => 'टेक्स्ट कॉपी करें';

  @override
  String get viewerCustomize => 'टूलबार अनुकूलित करें…';

  @override
  String get viewerDial =>
      'दिशा। सामने देखने के लिए क्लिक करें। चारों ओर देखने के लिए खींचें, ज़ूम के लिए स्क्रॉल या पिंच करें, रीसेट के लिए डबल-क्लिक करें';

  @override
  String get viewerFilmstrip => 'फ़िल्मस्ट्रिप';

  @override
  String get viewerFirst => 'पहला';

  @override
  String get viewerFisheye => 'फ़िशआई';

  @override
  String get viewerGyroscope => 'चारों ओर देखने के लिए डिवाइस घुमाएं';

  @override
  String get viewerHdr => 'HDR में दिखाएं';

  @override
  String get viewerInfo => 'जानकारी';

  @override
  String get viewerInfoLoading => 'इस आइटम की जानकारी लोड हो रही है';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString में से $positionString';
  }

  @override
  String get viewerLast => 'आख़िरी';

  @override
  String get viewerLenses => 'लेंस चुनें';

  @override
  String get viewerMap => 'मानचित्र';

  @override
  String get viewerMotion => 'मोशन चलाएँ';

  @override
  String get viewerMotionDenied =>
      'इस ब्राउज़र ने मोशन सेंसर तक पहुँच की अनुमति नहीं दी';

  @override
  String get viewerMotionMissing =>
      'इस डिवाइस में चारों ओर देखने के लिए जाइरोस्कोप नहीं है';

  @override
  String get viewerMute => 'म्यूट करें';

  @override
  String get viewerNext => 'अगला';

  @override
  String get viewerNextFrame => 'अगला फ़्रेम';

  @override
  String get viewerPause => 'रोकें';

  @override
  String get viewerPlanet => 'छोटा ग्रह';

  @override
  String get viewerPlay => 'चलाएँ';

  @override
  String get viewerPrevious => 'पिछला';

  @override
  String get viewerPreviousFrame => 'पिछला फ़्रेम';

  @override
  String get viewerRotate => 'घुमाएँ';

  @override
  String get viewerSdr => 'SDR में दिखाएं';

  @override
  String get viewerSeek => 'स्थिति';

  @override
  String get viewerSetAs => 'इस रूप में सेट करें';

  @override
  String get viewerShare => 'शेयर करें';

  @override
  String get viewerSpeed => 'प्लेबैक गति';

  @override
  String get viewerSphere =>
      '360° दृश्य। चारों ओर देखने के लिए खींचें, ज़ूम करने के लिए पिंच करें';

  @override
  String get viewerText => 'इस फ़ोटो में टेक्स्ट';

  @override
  String get viewerTextCopied => 'टेक्स्ट कॉपी किया गया';

  @override
  String get viewerTextNone => 'इस फ़ोटो में कोई टेक्स्ट नहीं मिला';

  @override
  String get viewerTextUnread => 'इस फ़ोटो का टेक्स्ट अभी पढ़ा नहीं गया है';

  @override
  String get viewerUnmute => 'अनम्यूट करें';

  @override
  String get viewerZoomIn => 'ज़ूम इन करें';

  @override
  String get viewerZoomOut => 'ज़ूम आउट करें';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD कार्ड',
      'other': 'आंतरिक',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'ज़ूम इन करें';

  @override
  String get zoomOut => 'ज़ूम आउट करें';
}
