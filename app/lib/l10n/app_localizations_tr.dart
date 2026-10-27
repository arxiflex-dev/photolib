// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get actionAddToAlbum => 'Albüme ekle';

  @override
  String get actionArchive => 'Arşivle';

  @override
  String get actionCopyTo => 'Şuraya kopyala…';

  @override
  String get actionDeleteForever => 'Kalıcı olarak sil';

  @override
  String get actionFavourite => 'Favorilere ekle';

  @override
  String get actionHide => 'Gizle';

  @override
  String get actionMoveTo => 'Şuraya taşı…';

  @override
  String get actionRename => 'Yeniden adlandır';

  @override
  String get actionRestore => 'Geri yükle';

  @override
  String get actionShare => 'Paylaş';

  @override
  String get actionTrash => 'Çöp kutusuna taşı';

  @override
  String get actionUnarchive => 'Arşivden çıkar';

  @override
  String get actionUndo => 'Geri al';

  @override
  String get actionUnfavourite => 'Favorilerden çıkar';

  @override
  String get actionUnhide => 'Göster';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Etkin',
      'disabled': 'Devre dışı',
      'invited': 'Davet edildi',
      'deleted': 'Silindi',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Hesaplar';

  @override
  String get adminAddAccount => 'Hesap ekle';

  @override
  String get adminAddExternalLibrary => 'Harici kitaplık ekle';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts deneme',
      one: '1 deneme',
      zero: 'henüz çalıştırılmadı',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Denetim günlüğü';

  @override
  String get adminBackUpNow => 'Şimdi yedekle';

  @override
  String get adminBackupQueued =>
      'Yedek sıraya alındı; ardından bir geri yükleme tatbikatı gelecek';

  @override
  String get adminBackups => 'Veritabanı yedekleri';

  @override
  String get adminCancelJob => 'İşi iptal et';

  @override
  String get adminCapabilities => 'Özellikler';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Yönetilen kitaplıklar',
      'uploads': 'Cihazlardan, webden ve CLI\'dan yüklemeler',
      'folder_browser': 'Klasör tarayıcı',
      'device_folders': 'Bağlı uygulamalarda cihaz klasörleri',
      'sharing': 'Paylaşım ve herkese açık bağlantılar',
      'edits': 'Düzenlemeler',
      'deletes': 'Silmeler',
      'xmp_writes': 'XMP dosyası yazma',
      'face_recognition': 'Yüz tanıma',
      'ml_search': 'Akıllı arama',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'Tamam',
      'warn': 'Uyarı',
      'fail': 'Başarısız',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Kopyalandı';

  @override
  String get adminCopyBundle => 'Hata raporu için tanılama bilgilerini kopyala';

  @override
  String get adminCopyLink => 'Bağlantıyı kopyala';

  @override
  String get adminDelete => 'Sil';

  @override
  String get adminDeviceBackups => 'Cihaz yedekleri';

  @override
  String get adminDevices => 'Cihazlarınız';

  @override
  String get adminDisable => 'Devre dışı bırak';

  @override
  String adminDrillFailed(String detail) {
    return 'Son geri yükleme tatbikatı başarısız oldu: $detail';
  }

  @override
  String get adminEdit => 'Düzenle';

  @override
  String get adminEmail => 'E-posta';

  @override
  String get adminEnable => 'Etkinleştir';

  @override
  String get adminErrorSignIn => 'Yönetici olarak oturum açın';

  @override
  String get adminFacesDefault =>
      'Yüz tanıma, yeni hesaplarda varsayılan olarak açık';

  @override
  String get adminFiles => 'Türe göre dosyalar';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Bozuk',
      'missing': 'Eksik',
      'size': 'Yanlış boyut',
      'hash': 'Değiştirilmiş',
      'orphan': 'Sahipsiz dosya',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size boş';
  }

  @override
  String get adminFreeDisk =>
      'Boş disk alanı bu değerin altına düşünce yüklemeleri duraklat, yüzde olarak, 0 ile 50 arası';

  @override
  String get adminFreeDiskGb =>
      'veya daha küçükse GB olarak bu boş alanın altına düşünce, 0 ile 100000 arası';

  @override
  String get adminHandle => 'Oturum açma adı';

  @override
  String get adminIntegrity => 'Bütünlük';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe',
      one: '1 öğe',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'Sırada',
      'running': 'Çalışıyor',
      'done': 'Tamamlandı',
      'dead': 'Başarısız',
      'cancelled': 'İptal edildi',
      'other': 'Tümü',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'İş türü, örneğin render';

  @override
  String get adminJobs => 'İşler';

  @override
  String adminLastSeen(String time) {
    return 'Son görülme: $time';
  }

  @override
  String get adminLibraries => 'Kitaplıklar';

  @override
  String get adminLibraryOwner => 'Sahip';

  @override
  String get adminLibraryRoot => 'Sunucudaki klasör, örneğin /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Çevrimiçi',
      'offline': 'Çevrimdışı',
      'scanning': 'Taranıyor',
      'error': 'Hata',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Sunucu günlüğü';

  @override
  String get adminName => 'Ad';

  @override
  String get adminNothing => 'Henüz burada bir şey yok';

  @override
  String get adminOutOfRange => 'İzin verilen aralığın dışında';

  @override
  String get adminOverview => 'Genel bakış';

  @override
  String get adminPair => 'Cihaz eşleştir';

  @override
  String get adminPairBody =>
      'Bu kodu tarayın veya bağlantıyı gönderin, sonra yeni cihazda Photolib\'in Sunucu ekle sayfasına yapıştırın: bu sunucunun tüm adreslerini ve sertifikasını getirir, böylece kimsenin yazması gerekmez.';

  @override
  String get adminPasswordSetup => 'Parola belirleme bağlantısı';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Bu bağlantıyı $name kişisine herhangi bir yolla gönderin veya kodu taratın. $date tarihine kadar bir kez parola belirler.';
  }

  @override
  String get adminPause => 'Bir iş türünü duraklat';

  @override
  String adminPauseMinutes(int max) {
    return 'Dakika, 1 ile $max arası';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type şu zamana kadar duraklatıldı: $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yedeklenecek $countString öğe kaldı',
      one: 'Yedeklenecek 1 öğe kaldı',
      zero: 'Yedeklenecek bir şey kalmadı',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'İlkeler';

  @override
  String get adminPolicyReset => 'Üst düzeyin değerini kullan';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Varsayılan olarak açık',
      'server': 'Sunucu için ayarlandı',
      'user': 'Bu hesap için ayarlandı',
      'library': 'Bu kitaplık için ayarlandı',
      'config': 'Yapılandırmada ayarlandı',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Hazır ayar uygula';

  @override
  String get adminPresetBody =>
      'Hazır ayar, sunucu için her özelliği ayarlar ve hesapların ile kitaplıkların ayarladıklarını temizler. Her biri düzenlenebilir kalır.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Arşiv görüntüleyici',
      'family_backup': 'Aile yedeği',
      'personal': 'Kişisel',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Salt okunur harici kitaplıklar tek doğruluk kaynağıdır: yükleme, yönetilen kitaplık, cihaz klasörü, düzenleme, silme veya XMP yazma yok',
      'family_backup': 'XMP yazma dışında her şey açık',
      'personal': 'Paylaşım ve herkese açık bağlantılar dışında her şey açık',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Bağlantının QR kodu';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString iş sıraya alındı',
      one: '1 iş sıraya alındı',
      zero: 'Yapılacak bir şey yok',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'GB cinsinden depolama kotası; sınırsız için boş bırakın';

  @override
  String get adminRemote => 'Uzaktan erişim';

  @override
  String get adminRemoteBody =>
      'Yönlendiricinizde port açmadan sunucuya her yerden ulaşın. Bir yol seçin; her biri ona uygulamalara eklenecek bir HTTPS adresi verir. Sonra dışarıdan test edin.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared dışarıya, alan adınızı HTTPS üzerinden sunan Cloudflare\'e bağlanır. Ücretsiz plan bir isteği 100 MB ile sınırlar; yedeklemeler buna asla ulaşmaz: her seferinde 8 MiB gönderirler.';

  @override
  String get adminRemoteNoAddress =>
      'Dışarıdan test etmek için sunucunun https:// adresini bu uygulamaya ekleyin.';

  @override
  String get adminRemoteReachable => 'Dışarıdan erişilebilir.';

  @override
  String get adminRemoteTailscale =>
      'Tailscale\'i sunucunun bilgisayarına ve her cihaza, aynı tailnet\'e veya Headscale\'inize kurun; sonra bunu sunucunun bilgisayarında çalıştırın ve public_url\'i yazdırdığı adrese ayarlayın.';

  @override
  String get adminRemoteTest => 'Dışarıdan test et';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host, $url adresini dünyadaki sunucularından açacak ve böylece bu adresi öğrenecek. Devam edilsin mi?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Dışarıdan erişilemiyor: seçtiğiniz yolu kontrol edip tekrar test edin.';

  @override
  String get adminRemoteWireguard =>
      'Sunucu tarafında veya bir merkez düğümde açık bir UDP portu gerekir. Bu bir cihazın yapılandırmasıdır; anahtarları wg genkey ile oluşturun.';

  @override
  String get adminRepair =>
      'Bir yedekten veya hâlâ ona sahip bir cihazdan geri koyun';

  @override
  String get adminRepairOrphan =>
      'Hiçbir fotoğraf onu göstermiyor: kontrol edin, sonra silin ya da saklayın';

  @override
  String get adminReprocess => 'Yeniden işle';

  @override
  String get adminReprocessFaces => 'Yüzleri yeniden algıla';

  @override
  String get adminReprocessFolder =>
      'Klasör, örneğin 2024/05; kitaplığın tamamı için boş bırakın';

  @override
  String get adminReprocessMetadata => 'Meta verileri yeniden oku';

  @override
  String get adminReprocessRenditions =>
      'Küçük resimleri ve önizlemeleri yeniden oluştur';

  @override
  String get adminRestore => 'Geri yükle';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '$name geri yüklenemedi: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Henüz başarılı bir geri yükleme tatbikatı yok';

  @override
  String adminRestoreVerified(String when) {
    return 'Son doğrulanan geri yükleme: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd durur ve yeniden başladığında tüm veritabanını $name ile değiştirir. O yedekten bu yana yapılan değişiklikler kaybolur ve her cihaz baştan eşitlenir.';
  }

  @override
  String get adminRestoring => 'photolibd yedeği geri yüklemek için duruyor';

  @override
  String get adminResume => 'Devam ettir';

  @override
  String get adminRetry => 'Yeniden dene';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Yönetici',
      'user': 'Kullanıcı',
      'viewer': 'Görüntüleyici',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Kaydedildi';

  @override
  String get adminScan => 'Şimdi tara';

  @override
  String get adminScrubDays =>
      'Denetimin her orijinali kontrol ettiği gün sayısı, 1 ile 3650 arası';

  @override
  String get adminScrubNever => 'İlk tam denetim sürüyor';

  @override
  String adminScrubbed(String time) {
    return 'Son tam denetim $time';
  }

  @override
  String get adminSecondAdmin =>
      'İkinci bir kişiyi yönetici yapın; böylece siz yapamadığınızda başka biri sunucuyu yönetip geri yükleyebilir.';

  @override
  String adminSilent(String time) {
    return '$time tarihinden beri sessiz';
  }

  @override
  String get adminSilentHours =>
      'Bir cihazın yedeğinin sessiz sayılması için raporsuz geçen saat, 1 ile 8760 arası';

  @override
  String get adminStores => 'Depolama';

  @override
  String get adminThisDevice => 'Bu cihaz';

  @override
  String get adminTitle => 'Sunucu yönetimi';

  @override
  String get adminTrashDays =>
      'Çöp kutusunda kalma süresi (gün), 1 ile 3650 arası';

  @override
  String get adminTwoFactor =>
      'Tüm hesaplar ikinci bir kimlik doğrulama faktörü ayarlamalıdır';

  @override
  String get adminUsage => 'Hesaba göre kullanım';

  @override
  String get albumCover => 'Kapak olarak kullan';

  @override
  String get albumEmpty => 'Bu albüm boş';

  @override
  String get albumHideMemories => 'Anılardan gizle';

  @override
  String get albumHideTimeline => 'Zaman çizelgesinden gizle';

  @override
  String get albumNew => 'Yeni albüm';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Herhangi bir tarih';

  @override
  String get backupCap => 'En büyük öğe';

  @override
  String get backupCharging => 'Yalnızca şarj olurken';

  @override
  String backupCompleted(String time) {
    return 'Son tam yedekleme: $time';
  }

  @override
  String backupContact(String time) {
    return 'Sunucuyla son bağlantı: $time';
  }

  @override
  String get backupEnabled => 'Bu cihazı yedekle';

  @override
  String get backupFolderNo => 'Bunu değil';

  @override
  String get backupFolderYes => 'Yedekle';

  @override
  String backupHours(int count) {
    return '$count sa';
  }

  @override
  String get backupMetered =>
      'Ölçülü ağlarda, örneğin mobil veri veya erişim noktası';

  @override
  String get backupNever => 'Henüz tam yedekleme yok';

  @override
  String backupNewFolder(String name) {
    return 'Yeni klasör $name: yedeklensin mi?';
  }

  @override
  String get backupNoLimit => 'Sınır yok';

  @override
  String get backupNothing => 'Bekleyen öğe yok';

  @override
  String get backupNow => 'Şimdi yedekle';

  @override
  String backupOverdue(int hours, String items) {
    return '$hours saattir tam yedekleme yok. Bekleyen: $items';
  }

  @override
  String get backupOverdueTitle => 'Yedekleme tamamlanmadı';

  @override
  String backupPending(String items) {
    return 'Bekleyen: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Yeniden denenecek: $time';
  }

  @override
  String get backupRoaming => 'Dolaşımdayken yedekle';

  @override
  String get backupSignIn =>
      'Bu cihazı yedeklemek için bir sunucuda oturum açın';

  @override
  String get backupSignedOut =>
      'Yedekleme durdu: sunucu bu cihazın oturumunu kapattı. Ayarlar’da yeniden oturum açın.';

  @override
  String get backupSince => 'Şu tarihten beri çekilen';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Yedekleme sunucuya erişilene kadar bekliyor',
      'charging': 'Yedekleme cihaz şarj olana kadar bekliyor',
      'battery_low': 'Yedekleme bekliyor: pil zayıf',
      'roaming': 'Yedekleme dolaşım sırasında bekliyor',
      'quota': 'Yedekleme durdu: sunucudaki depolama alanınız dolu',
      'second_factor':
          'Yedekleme durdu: sunucu bu hesap için ikinci bir doğrulama istiyor',
      'other': 'Yedekleme durdu: sunucu $code yanıtını verdi',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Yedekleme';

  @override
  String get backupWaiting => 'Yedeklenmeyenler';

  @override
  String get backupWarnAfter => 'Şu süre tamamlanmazsa uyar';

  @override
  String get backupWhat => 'Neler yedeklensin';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'Seçmediğiniz bir klasörde',
      'folder_new': 'Yeni bir klasörde: yedeklenip yedeklenmeyeceğini seçin',
      'type_excluded': 'Seçmediğiniz bir öğe türü',
      'before_date': 'Seçtiğiniz tarihten önce çekilmiş',
      'selected': 'Sırasını bekliyor',
      'server_restored':
          'Sunucu bir geri yüklemede kaybetti: yeniden gönderiliyor',
      'working': 'Yedekleniyor',
      'waiting_for_icloud': 'iCloud’un indirmesini bekliyor',
      'metered': 'Ölçülü olmayan bir ağ bekliyor',
      'metered_cap': 'Ölçülü ağ için fazla büyük',
      'unreadable': 'Bu cihaz okuyamıyor',
      'changed': 'Gönderilirken değişti',
      'quota': 'Sunucudaki depolama alanınız dolu',
      'other': 'Sunucu reddetti: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Sunucu artık Photolib\'in bu sürümüyle çalışmıyor.';

  @override
  String get checkAppTooOldNext => 'Photolib\'i güncelleyin.';

  @override
  String get checkChanged =>
      'Sunucunun sertifikası güvendiğiniz sertifika değil.';

  @override
  String get checkChangedNext =>
      'Yöneticiniz değiştirdiyse yenisine güvenin. Değiştirmediyse biri dinliyor olabilir: devam etmeyin.';

  @override
  String get checkClock =>
      'Bu cihazın saati ile sunucunun saati arasında beş dakikadan fazla fark var.';

  @override
  String get checkClockNext =>
      'Cihazınızın tarih ve saati otomatik ayarlamasına izin verin.';

  @override
  String get checkDnsFailed => 'Sunucunun adı bir adrese çıkmıyor.';

  @override
  String get checkDnsFailedNext =>
      'Adresi kontrol edin veya sunucunun ağına bağlanın.';

  @override
  String checkExpired(String date) {
    return 'Sunucunun sertifikasının süresi $date tarihinde doldu.';
  }

  @override
  String get checkFailed => 'Başarısız';

  @override
  String get checkMetered => 'Mobil veri gibi ölçülü bir ağdasınız.';

  @override
  String get checkMeteredNext =>
      'Büyük yedeklemelerden önce Wi-Fi\'ye bağlanın.';

  @override
  String get checkNotPhotolib =>
      'Photolib dışında bir şey yanıt veriyor; örneğin bir proxy\'nin hata sayfası veya bir Wi-Fi oturum açma sayfası.';

  @override
  String get checkNotPhotolibNext =>
      'Tarayıcınızda Wi-Fi\'ye giriş yapın veya yöneticinizden proxy\'yi kontrol etmesini isteyin.';

  @override
  String get checkOtherServer =>
      'Bu adreste başka bir Photolib sunucusu yanıt veriyor.';

  @override
  String get checkPassed => 'Geçti';

  @override
  String get checkRefused => 'Bu adreste hiçbir şey yanıt vermiyor.';

  @override
  String get checkRefusedNext =>
      'Sunucunun çalıştığını ve onun ağında ya da VPN\'inde olduğunuzu kontrol edin.';

  @override
  String get checkRun => 'Bağlantıyı denetle';

  @override
  String get checkRunning => 'Denetleniyor';

  @override
  String get checkSelfSigned =>
      'Sunucu, bu cihazın henüz tanımadığı kendi sertifikasını kullanıyor.';

  @override
  String get checkSkipped => 'Denetlenmedi';

  @override
  String get checkStepAuth => 'Oturumunuz';

  @override
  String get checkStepClock => 'Cihazınızın saati';

  @override
  String get checkStepDns => 'Sunucunun adresini bulma';

  @override
  String get checkStepNetwork => 'Ağınız';

  @override
  String get checkStepServer => 'Sunucuda Photolib';

  @override
  String get checkStepTcp => 'Sunucuya ulaşma';

  @override
  String get checkStepTls => 'Güvenli bağlantı ve sertifika';

  @override
  String get checkStepUpload => 'Proxy\'ler üzerinden büyük yüklemeler';

  @override
  String get checkTimedOut => 'Sunucunun yanıt vermesi çok uzun sürüyor.';

  @override
  String get checkTimedOutNext => 'Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get checkTitle => 'Bağlantı denetimi';

  @override
  String get checkTlsFailed => 'Güvenli bağlantı kurulamadı.';

  @override
  String get checkTrustNext =>
      'Yalnızca parmak izi sunucunuzunkiyle eşleşiyorsa güvenin.';

  @override
  String get checkUntrusted =>
      'Sunucunun sertifikası, bu cihazın güvenmediği bir kuruluştan geliyor.';

  @override
  String get checkUploadCap =>
      'Yol üzerindeki bir proxy büyük yüklemeleri reddediyor; bu yüzden yedeklemeler küçük parçalarla daha yavaş ilerliyor.';

  @override
  String get checkUploadCapNext =>
      'Yöneticinizden proxy\'nin 64 MB\'lık isteklere izin vermesini isteyin.';

  @override
  String get collectionAlbums => 'Albümler';

  @override
  String collectionHide(String name) {
    return '$name bölümünü gizle';
  }

  @override
  String collectionMoveDown(String name) {
    return '$name bölümünü aşağı taşı';
  }

  @override
  String collectionMoveUp(String name) {
    return '$name bölümünü yukarı taşı';
  }

  @override
  String get collectionPeople => 'Kişiler';

  @override
  String collectionPin(String name) {
    return '$name bölümünü sabitle';
  }

  @override
  String get collectionPlaces => 'Yerler';

  @override
  String collectionShow(String name) {
    return '$name bölümünü göster';
  }

  @override
  String get collectionTags => 'Etiketler';

  @override
  String collectionUnpin(String name) {
    return '$name bölümünün sabitlemesini kaldır';
  }

  @override
  String get collectionsCustomise => 'Özelleştir';

  @override
  String get collectionsDone => 'Bitti';

  @override
  String get commandPalette => 'Komut paleti';

  @override
  String get commandPaletteHint => 'Bir komut yazın';

  @override
  String get dateFormatDefault => 'Dil varsayılanı';

  @override
  String get dateFormatDmy => 'Gün-ay-yıl';

  @override
  String get dateFormatMdy => 'Ay-gün-yıl';

  @override
  String get dateFormatYmd => 'Yıl-ay-gün';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe bu cihazda ve yedeklendi',
      one: '$countString öğe bu cihazda ve yedeklendi',
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
      other: '$countString öğe yalnızca bu cihazda, yedeklenmedi',
      one: '$countString öğe yalnızca bu cihazda, yedeklenmedi',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'iCloud Fotoğrafları açıkken bu cihazdan silinen öğeler iCloud\'dan ve diğer Apple cihazlarınızdan da kaldırılır.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe yalnızca kitaplığınızda',
      one: '$countString öğe yalnızca kitaplığınızda',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Bu cihazdan kaldır';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yedeklenen $countString öğe; kitaplığınız bunları saklar',
      one: 'Yedeklenen $countString öğe; kitaplığınız onu saklar',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Bu cihazdaki kopyalar cihazın çöp kutusuna gider: alan, çöp kutusu boşaltılınca geri kazanılır.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe silinsin mi?',
      one: '$countString öğe silinsin mi?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Bu cihazdan ve kitaplığınızdan',
      'device': 'Yalnızca bu cihazdan',
      'other': 'Kitaplığınızdan',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Mevcut değil';

  @override
  String get deviceFolderCard => 'SD kart';

  @override
  String get deviceFolderExclude => 'Hariç tut';

  @override
  String get deviceFolderExcludeThis => 'Bu klasörü hariç tut';

  @override
  String get deviceFolderExcludedNotice =>
      'Bu öğenin klasörü kitaplığınızdan hariç tutuldu';

  @override
  String get deviceFolderForget => 'Listeden kaldır';

  @override
  String get deviceFolderInternal => 'Dahili depolama';

  @override
  String get deviceFolderKeep => 'Tut';

  @override
  String deviceFolderNew(String name, String items) {
    return 'Yeni klasör: $name, $items';
  }

  @override
  String get deviceFolders => 'Cihaz klasörleri';

  @override
  String get deviceFoldersAll =>
      'Hariç tutulanlar dışındaki tüm klasörleri göster';

  @override
  String get deviceFoldersChosen => 'Yalnızca seçilen klasörleri göster';

  @override
  String get deviceFoldersExcludedNow => 'Kitaplıktan hariç tutuldu';

  @override
  String get deviceFoldersSearch => 'Klasör ara';

  @override
  String get diagnosticsAdvanced => 'Tanılamayı göster';

  @override
  String get diagnosticsAllLoggers => 'Tüm kaynaklar';

  @override
  String get diagnosticsCopied => 'Günlük kopyalandı';

  @override
  String get diagnosticsCopy => 'Gösterilen günlüğü kopyala';

  @override
  String get diagnosticsEmpty => 'Henüz günlük kaydı yok';

  @override
  String get diagnosticsExport => 'Tanılama paketini dışa aktar';

  @override
  String get diagnosticsExported => 'Tanılama paketi kaydedildi';

  @override
  String get diagnosticsLevel => 'Düzey';

  @override
  String get diagnosticsLogger => 'Kaynak';

  @override
  String get diagnosticsTitle => 'Tanılama';

  @override
  String get download => 'İndir';

  @override
  String get downloadCurrent => 'Düzenlemeleriyle geçerli sürüm';

  @override
  String get downloadFailed => 'İndirilemedi';

  @override
  String get downloadOriginal => 'Orijinal';

  @override
  String downloadSaved(String name) {
    return '$name kaydedildi';
  }

  @override
  String get downloadVersion => 'Hangi sürüm?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe indiriliyor',
      one: '$countString öğe indiriliyor',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Otomatik iyileştir';

  @override
  String get editorCrop => 'Kırp';

  @override
  String get editorCropOriginal => 'Orijinal';

  @override
  String get editorCropSquare => 'Kare';

  @override
  String get editorEdit => 'Düzenle';

  @override
  String get editorFlip => 'Çevir';

  @override
  String get editorRotate => 'Döndür';

  @override
  String get editorSaveCopy => 'Kopyayı kaydet';

  @override
  String get editorSaveFailed => 'Kopya kaydedilemedi';

  @override
  String get editorSaveVersion => 'Kaydet';

  @override
  String get editorSaved => 'Kopya olarak kaydedildi';

  @override
  String get editorVersionFailed => 'Sürüm kaydedilemedi';

  @override
  String get editorVersionSaved => 'Yeni sürüm olarak kaydedildi';

  @override
  String get editorVersionsUnsupported =>
      'Bu sunucu düzenlenmiş fotoğrafların sürümlerini henüz saklayamıyor';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString değişiklik geri alındı: sunucu reddetti.',
      one: '1 değişiklik geri alındı: sunucu reddetti.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Kapat';

  @override
  String get editsRejectedForbidden =>
      'Öğeleri görüntüleyebilirsiniz ancak değiştiremezsiniz.';

  @override
  String get editsRejectedInvalid => 'Sunucu değişiklikleri kabul edemedi.';

  @override
  String get editsRejectedNotFound =>
      'Öğeler silindi veya artık sizinle paylaşılmıyor.';

  @override
  String get errorNotFound => 'Bu sayfa mevcut değil';

  @override
  String get errorRetry => 'Tekrar dene';

  @override
  String get errorTitle => 'Bir sorun oluştu';

  @override
  String faceNumber(int number) {
    return '$number. yüz';
  }

  @override
  String get facesAgree => 'Kabul ediyorum';

  @override
  String get facesAura => 'Yüzleri AuraFace ile tanımla (daha büyük indirme)';

  @override
  String get facesNotNow => 'Şimdi değil';

  @override
  String get facesNoticeKeep =>
      'Bulunanlar fotoğraflarınızla birlikte, cihazlarınızda ve sunucunuzda kalır. Tanımlar asla gösterilmez ya da paylaşılmaz; durdurduğunuzda veya fotoğrafı sildiğinizde hepsi silinir.';

  @override
  String get facesNoticeOptional =>
      'Bu isteğe bağlıdır. Photolib’in geri kalanı bunsuz da çalışır ve istediğiniz zaman Ayarlar’dan durdurabilirsiniz.';

  @override
  String get facesNoticeTitle => 'Fotoğraflarınızdaki yüzler bulunsun mu?';

  @override
  String get facesNoticeWhat =>
      'Photolib fotoğraflarınızda ve videolarınızda yüzleri arar ve her biri için nerede olduğunu ve onu tanımlayan bir sayı listesini saklar; böylece aynı kişi yeniden bulunabilir. Böyle bir tanım biyometrik veri sayılabilir.';

  @override
  String get facesNoticeWhere =>
      'Bu, bu cihazda ve oturum açtıysanız kendi sunucunuzda olur. Bizim ya da bir başkasının işlettiği bir hizmette asla.';

  @override
  String get facesServerFailed => 'Sunucunuza bildirilemedi. Yeniden deneyin.';

  @override
  String get facesServerOff => 'Sunucunuz sizin için yüz bulmaz';

  @override
  String get facesServerOn => 'Sunucunuz sizin için yüzleri bulur';

  @override
  String get facesServerUnavailable => 'Sunucunuz yüz tanıma sunmuyor';

  @override
  String facesStatusDownloading(int percent) {
    return 'Yüz modelleri indiriliyor: %$percent';
  }

  @override
  String get facesStatusMissing => 'Sunucunuz yüz modellerini yüklememiş';

  @override
  String get facesStatusNoDecoder =>
      'Yüz bulma kullanılamıyor: görüntü kitaplığı (libvips) bulunamadı. Photolib\'i yeniden yükleyin ya da libvips\'i yükleyip yeniden başlatın.';

  @override
  String get facesStatusRunning => 'Bu cihazda yüzler bulunuyor';

  @override
  String get facesStatusUnavailable => 'Bu cihazda yüzler bulunamıyor';

  @override
  String get facesStatusWaiting => 'Yüz modelleri Wi-Fi’da indirilir';

  @override
  String get facesSwitch => 'Fotoğraflarımdaki yüzleri bul';

  @override
  String get facesSwitchOff =>
      'Kapalı. Siz kabul edene kadar yüzlerle ilgili hiçbir şey hesaplanmaz.';

  @override
  String get facesSwitchOn =>
      'Açık. Photolib fotoğraflarınızdaki yüzleri bulur.';

  @override
  String get facesTitle => 'Yüzler ve kişiler';

  @override
  String get facesWithdraw => 'Sil ve durdur';

  @override
  String get facesWithdrawBody =>
      'Bu, Photolib’in sizin için bulduğu tüm yüzleri, tanımları ve kişileri bu cihazdan ve sunucunuzdan siler. Fotoğraflarınız değişmez.';

  @override
  String get facesWithdrawTitle => 'Yüz bulma durdurulsun mu?';

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

    return 'Değiştirilmeyen dosyalar: $countString';
  }

  @override
  String get folderAllow => 'Bu klasöre erişime izin ver';

  @override
  String get folderDelete => 'Klasörü sil';

  @override
  String folderDeleteBody(String name) {
    return '$name içindeki fotoğraflar ve videolar çöp kutusuna taşınsın mı?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe',
      one: '1 öğe',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Yeni klasör';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Çevrimdışı, $countString öğe',
      one: 'Çevrimdışı, 1 öğe',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Bu klasör ya da onu içeren veya onun içindeki bir klasör zaten kitaplıkta';

  @override
  String get folderRemove => 'Klasörü kaldır';

  @override
  String folderRemoveBody(String folder) {
    return '$folder klasöründeki fotoğraflar ve videolar kitaplıktan çıkarılır. Dosyalar diskte olduğu gibi kalır.';
  }

  @override
  String get folderRemoveConfirm => 'Kaldır';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Taranıyor, şu ana kadar $countString öğe',
      one: 'Taranıyor, şu ana kadar 1 öğe',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Erişime izin ver';

  @override
  String get foldersHideExcluded => 'Hariç tutulan klasörleri gizle';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib artık $countString klasörü okuyamıyor.',
      one: 'Photolib artık 1 klasörü okuyamıyor.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Hariç tutulan klasörleri göster ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Bu tarayıcı bir klasörü kitaplığınız olarak kullanamaz. Photolib\'i bir bilgisayarda Chrome veya Edge ile açın ya da masaüstü uygulamasını kullanın.';

  @override
  String get galleryButtons => 'Düğmeler';

  @override
  String get galleryChips => 'Çipler';

  @override
  String get galleryGrid => 'Izgara';

  @override
  String get galleryMenus => 'Menüler ve alt sayfalar';

  @override
  String get galleryShowSheet => 'Alt sayfa göster';

  @override
  String get galleryTitle => 'Bileşenler';

  @override
  String hiddenCollections(int count) {
    return 'Gizli ($count)';
  }

  @override
  String get indexingAllowMetered => 'Mobil veriyle indir';

  @override
  String get indexingAllowSaver => 'Güç tasarrufu modunda da';

  @override
  String get indexingBattery => 'Şarj cihazı olmadan gereken pil';

  @override
  String get indexingChargingOnly => 'Yalnızca şarj olurken';

  @override
  String indexingDownloading(int percent) {
    return 'Arama modeli indiriliyor: %$percent';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotoğraf okunamadı',
      one: '1 fotoğraf okunamadı',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Bu cihaz yalnızca yeni fotoğraflarını dizinler';

  @override
  String get indexingMissing => 'Sunucunuz arama modelini yüklememiş';

  @override
  String get indexingModels => 'Bu cihazda ara';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Arama modelini ($megabytesString MB) $host adresinden indirir';
  }

  @override
  String get indexingNoDecoder =>
      'Arama ve metin okuma kullanılamıyor: görüntü kitaplığı (libvips) bulunamadı. Photolib\'i yeniden yükleyin ya da libvips\'i yükleyip yeniden başlatın.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Pil %$percent\'nin altındayken duraklatıldı';
  }

  @override
  String get indexingPausedCharger => 'Cihaz şarj olana kadar duraklatıldı';

  @override
  String get indexingPausedHeat => 'Cihaz sıcakken duraklatıldı';

  @override
  String get indexingPausedSaver => 'Pil tasarrufu açıkken duraklatıldı';

  @override
  String indexingPercent(int percent) {
    return '%$percent';
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

    return 'Dizinlenen fotoğraflar: $doneString / $totalString';
  }

  @override
  String get indexingText => 'Fotoğraflardaki metni oku';

  @override
  String indexingTextDownloading(int percent) {
    return 'Metin modelleri indiriliyor: %$percent';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Metin modellerini ($megabytesString MB) $host adresinden indirir; fotoğraflarınızdaki kelimeleri bulur';
  }

  @override
  String get indexingTextMissing => 'Sunucunuz metin modellerini yüklememiş';

  @override
  String get indexingTextPlatform =>
      'Telefonunuzun kendi metin tanımasını kullanır; indirilecek bir şey yok. Yeni fotoğrafları okur';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Metni okunan fotoğraflar: $doneString / $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Metin okuma burada kullanılamıyor';

  @override
  String get indexingTextWaiting => 'Metin modelleri Wi-Fi ile indirilir';

  @override
  String get indexingUnavailable => 'Bu cihazda arama burada kullanılamıyor';

  @override
  String get indexingWaiting => 'Arama modeli Wi-Fi\'de indirilir';

  @override
  String get infoAddName => 'Ad ekle';

  @override
  String get infoAddTag => 'Etiket ekle';

  @override
  String get infoAlbums => 'Albümler';

  @override
  String get infoAllMetadata => 'Tüm meta verileri görüntüle';

  @override
  String get infoAuto => 'Otomatik';

  @override
  String get infoBackedUp => 'Yedeklendi';

  @override
  String get infoCamera => 'Kamera';

  @override
  String get infoChangeAdjust => 'Renkler ayarlandı';

  @override
  String get infoChangeCrop => 'Kırpıldı';

  @override
  String get infoChangeFlip => 'Yansıtıldı';

  @override
  String get infoChangeInpaint => 'Bir alan dolduruldu';

  @override
  String get infoChangeLocal => 'Bir alan ayarlandı';

  @override
  String get infoChangeLut => 'Renk stili uygulandı';

  @override
  String get infoChangeOther => 'Düzenlendi';

  @override
  String get infoChangeTurn => 'Döndürüldü';

  @override
  String get infoCompare => 'Orijinalle karşılaştır';

  @override
  String infoConfidence(String percent) {
    return 'Güven: $percent';
  }

  @override
  String get infoCopyPath => 'Yolu kopyala';

  @override
  String get infoCurrent => 'Geçerli';

  @override
  String get infoDescription => 'Açıklama ekle';

  @override
  String get infoEditDate => 'Tarihi düzenle';

  @override
  String infoEditNumber(int number) {
    return 'Düzenleme $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '$name dosyasının düzenlenmiş kopyası';
  }

  @override
  String get infoFaces => 'Yüzler';

  @override
  String get infoFile => 'Dosya';

  @override
  String get infoFromFileName => 'dosya adından';

  @override
  String get infoHistory => 'Düzenleme geçmişi';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
      one: '$count öğe',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Konum';

  @override
  String get infoMap => 'Çekildiği yerin haritası';

  @override
  String get infoMapAgree =>
      'Harita kutucukları internetten gelir ve baktığınız bölgeyi gösterir';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Yeni etiket: $path';
  }

  @override
  String get infoNoAlbum => 'Hiçbir albümde değil';

  @override
  String get infoOnDevice => 'Bu cihazda';

  @override
  String get infoOriginal => 'Orijinal';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString piksel';
  }

  @override
  String infoRemoveFrom(String album) {
    return '$album albümünden kaldır';
  }

  @override
  String infoRemoveTag(String tag) {
    return '$tag etiketini kaldır';
  }

  @override
  String infoRemovedFrom(String album) {
    return '$album albümünden kaldırıldı';
  }

  @override
  String get infoRevert => 'Geri al';

  @override
  String get infoSaveCopy => 'Kopya olarak kaydet';

  @override
  String get infoShared => 'paylaşılan';

  @override
  String get infoShowFaces => 'Fotoğraftaki yüzleri göster';

  @override
  String get infoShowMap => 'Haritayı göster';

  @override
  String get infoTags => 'Etiketler';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sürüm',
      one: '$count sürüm',
    );
    return '$_temp0 · son $time';
  }

  @override
  String get infoWhy => 'Neden bu tarih?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Dosyadan $tag olarak okundu',
      'name': 'Dosya adından okundu',
      'folder': 'Bir klasörün adından okundu',
      'host': 'Dosyanın geldiği hizmet tarafından verildi',
      'unknown': 'Dosyada tarihini gösteren bir şey yok, bu yüzden son değiştirildiği tarih kullanılıyor',
      'other':
          'Dosya henüz okunmadı, bu yüzden cihazın verdiği tarih kullanılıyor',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Liste',
      'other': 'Izgara',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Ad',
      'taken': 'Çekim tarihi',
      'modified': 'Değiştirilme tarihi',
      'size': 'Boyut',
      'random': 'Rastgele',
      'extension': 'Tür',
      'custom': 'Albüm sırası',
      'other': 'Çekim tarihi',
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
  String get languageDevice => 'Cihaz dili';

  @override
  String get languageName => 'Türkçe';

  @override
  String get libraryAddFolder => 'Klasör ekle';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Yedeklenmedi',
      'backed_up': 'Yedeklendi',
      'cloud_only': 'Yalnızca bulutta',
      'other': 'Tümü',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Her şey yedeklendi',
      'backed_up': 'Henüz hiçbir şey yedeklenmedi',
      'cloud_only': 'Yalnızca sunucuda olan bir şey yok',
      'other': 'Burada bir şey yok',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Yedekleme rozetleri';

  @override
  String get libraryEmpty => 'Fotoğraflarınız burada görünecek';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Haftaya göre grupla',
      'month': 'Aya göre grupla',
      'other': 'Güne göre grupla',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'Gizli ve arşivlenmiş öğeleri yeniden gizle';

  @override
  String get libraryNoKeyring =>
      'Photolib, kitaplığınızın anahtarını sistem anahtarlığında saklar; anahtarlık çalışmıyor veya kilitli. GNOME Keyring veya KWallet gibi bir anahtarlığı başlatın ya da kilidini açın, ardından tekrar deneyin.';

  @override
  String get libraryRevealExcluded =>
      'Hariç tutulan klasörleri 5 dakika göster';

  @override
  String get libraryShowVeiled =>
      'Gizli ve arşivlenmiş öğeleri 5 dakika göster';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Son eklenenler',
      'other': 'Çekim tarihi',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib bu cihazda saklanan kitaplığı açamadı';

  @override
  String get libraryViewOptions => 'Görünüm seçenekleri';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Küçük resimler hazırlanıyor: $totalString öğeden $doneString';
  }

  @override
  String get libraryZoomIn => 'Küçük resimleri büyüt';

  @override
  String get libraryZoomOut => 'Küçük resimleri küçült';

  @override
  String get mapAddTrack => 'GPX izi ekle';

  @override
  String get mapArea => 'Harita alanı';

  @override
  String get mapAttribution => '© OpenStreetMap katkıda bulunanlar';

  @override
  String get mapClearLasso => 'Seçimi temizle';

  @override
  String get mapEmpty => 'Henüz konumlu fotoğraf yok';

  @override
  String get mapHeat => 'Isı haritası';

  @override
  String get mapLasso => 'Fotoğrafların çevresine çizerek seç';

  @override
  String get mapLoading => 'Fotoğraflar haritaya yerleştiriliyor';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Fotoğraflar: $countString';
  }

  @override
  String get mapSearchHere => 'Bu alanda ara';

  @override
  String get mapSplit => 'Fotoğrafları haritanın altında göster';

  @override
  String get mapTilesAgree =>
      'Harita arka planı, baktığınız alanı gören OpenStreetMap sunucusundan (tile.openstreetmap.org) gelir';

  @override
  String get mapTilesShow => 'Arka planı göster';

  @override
  String get mapTime => 'Zaman aralığı';

  @override
  String get mapTitle => 'Harita';

  @override
  String get mapTrackBad => 'Bu dosyada GPX izi yok';

  @override
  String get mapTrips => 'Geziler';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favori',
      'hidden': 'Gizli',
      'archived': 'Arşivlendi',
      'offline': 'Bu cihazda tutuluyor',
      'offline': 'Bu cihazda tutuluyor',
      'offline': 'Bu cihazda tutuluyor',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Erişime izin ver';

  @override
  String get mediaAccessNone =>
      'Photolib\'in fotoğraflarınızı ve videolarınızı gösterebilmesi için bunlara erişmesi gerekiyor.';

  @override
  String get mediaAccessPartial =>
      'Photolib yalnızca seçtiğiniz fotoğrafları ve videoları görebiliyor. Bir galerinin hepsine erişmesi gerekir.';

  @override
  String get mediaAccessSelect => 'Daha fazla fotoğraf seç';

  @override
  String get nameLabel => 'Ad';

  @override
  String get nextAddRoot =>
      'Klasörü sunucu yapılandırmasındaki external_roots listesine ekleyin, ardından sunucuyu yeniden başlatın.';

  @override
  String get nextAskAdmin => 'Sunucunuzun yöneticisine sorun.';

  @override
  String get nextAskOwner =>
      'Kitaplığın sahibinden fotoğraf eklemenize izin vermesini isteyin.';

  @override
  String get nextCheckConnection =>
      'Nedenini görmek için bağlantıyı kontrol edin.';

  @override
  String get nextCheckEntry => 'Girdiklerinizi kontrol edip tekrar deneyin.';

  @override
  String get nextConfirm => 'Kaç öğenin etkilendiğini kontrol edip onaylayın.';

  @override
  String get nextDeleteWebhook =>
      'Artık kullanmadığınız bir webhook\'u silin, ardından tekrar deneyin.';

  @override
  String get nextEditConfig =>
      'Bunu sunucu yapılandırmasında değiştirin, ardından sunucuyu yeniden başlatın.';

  @override
  String get nextFreeSpace =>
      'Yer açın veya yöneticinizden daha fazlasını isteyin.';

  @override
  String get nextNewLink => 'Yöneticinizden yenisini isteyin.';

  @override
  String get nextNewestToken =>
      'photolibd günlüğündeki en yenisini kopyalayın.';

  @override
  String get nextOtherAdmin => 'Önce başka bir hesabı yönetici yapın.';

  @override
  String get nextOtherFolder => 'Kendine ait bir klasör seçin.';

  @override
  String get nextRefresh => 'Yenileyip tekrar deneyin.';

  @override
  String get nextReport =>
      'Tekrar deneyin. Yine olursa aşağıdaki ayrıntıları yöneticiniz için kopyalayın.';

  @override
  String get nextSetUpPrivate =>
      'Ayarlar\'da özel kitaplıkların kurulumunu tamamlayın, ardından tekrar deneyin.';

  @override
  String get nextSignIn => 'Yeniden oturum açın.';

  @override
  String get nextSignInAccount => 'Hesabınızla oturum açıp tekrar deneyin.';

  @override
  String get nextSignInInstead => 'Bunun yerine oturum açın.';

  @override
  String get nextTryAgain => 'Tekrar deneyin.';

  @override
  String get nextUpdateAndAgree =>
      'Uygulamayı güncelleyin, ardından bildirimi yeniden kabul edin.';

  @override
  String get nextUseAnother => 'Başka birini seçin.';

  @override
  String get nextUseHttps =>
      'Sunucunun https:// adresini kullanın veya sunucunun kendi ağından bağlanın.';

  @override
  String get nextWait => 'Bir dakika bekleyip tekrar deneyin.';

  @override
  String get offlineKeep => 'Çevrimdışı tut';

  @override
  String offlineKeepHere(String size) {
    return 'Bu cihazda tut ($size)';
  }

  @override
  String get offlineKeptHere => 'Bu cihazda tutuluyor';

  @override
  String get offlineStopKeeping => 'Çevrimdışı tutmayı bırak';

  @override
  String get otherFiles => 'Diğer dosyalar';

  @override
  String get passphraseCreate =>
      'Bu bilgisayarda Photolib\'in anahtarlarını saklayacak bir anahtarlık (Secret Service) çalışmıyor. Onları korumak için en az 10 karakterlik bir parola ifadesi seçin: Photolib her açılışta bunu sorar.';

  @override
  String get passphraseLabel => 'Parola ifadesi';

  @override
  String get passphraseMismatch => 'Parola ifadeleri eşleşmiyor.';

  @override
  String get passphraseRepeat => 'Parola ifadesini tekrarla';

  @override
  String get passphraseTooShort => 'En az 10 karakter kullanın.';

  @override
  String get passphraseUnlock =>
      'Bu bilgisayarda Photolib\'in anahtarlarını koruyan parola ifadesini girin.';

  @override
  String get passphraseWrong => 'Yanlış parola ifadesi. Yeniden deneyin.';

  @override
  String photoPosition(int index, int count) {
    return 'Fotoğraf $index, toplam $count';
  }

  @override
  String get privacyCheckKit => 'Kurtarma kitini denetle';

  @override
  String get privacyDrillDue =>
      'Kurtarma tatbikatı zamanı: kurtarma kitinizin özel kitaplıklarınızın kilidini hâlâ açtığını denetleyin.';

  @override
  String get privacyHonest =>
      'Özel kitaplıklar cihazlarınızda şifrelenir ve onları başka kimse açamaz: ne sunucu, ne yöneticisi, ne de Photolib geliştiricileri. Hem parolanızı hem de kurtarma kitinizi kaybederseniz fotoğraflarınız sonsuza dek kaybolur ve kimse onları sizin için geri getiremez.';

  @override
  String get privacyKitBody =>
      'Bu 24 sözcüğü sırasıyla kâğıda yazın ve güvenli bir yerde saklayın. Parolanızı unutursanız özel kitaplıklarınızın kilidini açarlar; onlara sahip olan herkes için.';

  @override
  String get privacyKitDone => 'Kurtarma kitiniz çalışıyor.';

  @override
  String get privacyKitOther => 'Bu, geçerli kurtarma kitiniz değil.';

  @override
  String get privacyKitTitle => 'Kurtarma kitiniz';

  @override
  String get privacyKitUnverified => 'Kurtarma kiti henüz doğrulanmadı';

  @override
  String privacyKitVerified(String date) {
    return 'Kurtarma kiti $date tarihinde doğrulandı';
  }

  @override
  String get privacyKitWritten => 'Yazdım';

  @override
  String get privacyNotReady =>
      'Kilidi açmanın iki yolu olana ve kurtarma kitinizi doğrulayana kadar özel yüklemeler kapalı kalır.';

  @override
  String get privacyPasswordHelp =>
      'Hesabınızın parolasını girin: özel kitaplıklarınızın kilidini açmanın bir yolu olur.';

  @override
  String get privacyPhrase => 'Kurtarma ifadesi';

  @override
  String get privacyPhraseHelp => 'Kurtarma kitinizdeki 24 sözcük';

  @override
  String get privacyPhraseInvalid =>
      'Bu bir kurtarma ifadesi değil. Her sözcüğü denetleyin.';

  @override
  String get privacyReady => 'Özel yüklemeler açık.';

  @override
  String get privacyRecoveryKit => 'Kurtarma kiti';

  @override
  String get privacySetUp => 'Kur';

  @override
  String get privacyShowWords => 'Sözcükleri yeniden göster';

  @override
  String get privacyTitle => 'Özel kitaplıklar';

  @override
  String privacyUnknownWord(int number) {
    return '$number. sözcük bir kurtarma kiti sözcüğü değil.';
  }

  @override
  String get privacyVerify => 'Doğrula';

  @override
  String get privacyVerifyBody =>
      'Kaydettiğinizi göstermek için kurtarma kitinizdeki bu sözcükleri yazın.';

  @override
  String get privacyWays => 'Kilit açma yolları';

  @override
  String privacyWord(int number) {
    return '$number. sözcük';
  }

  @override
  String get privacyWordsDiffer =>
      'Bu sözcükler kurtarma kitinizle eşleşmiyor. Yazdıklarınızı denetleyin.';

  @override
  String get privacyWrongPassword => 'Bu, hesabınızın parolası değil.';

  @override
  String get problemAdminOnly => 'Bunu yalnızca bir yönetici yapabilir.';

  @override
  String get problemBusy => 'Sunucu meşgul veya yeniden başlıyor.';

  @override
  String get problemChanged => 'Bu, bu arada değişti.';

  @override
  String get problemConfirm =>
      'Bu, sunucunun onay olmadan yaptığından daha fazla öğeyi gizler veya siler';

  @override
  String get problemContribute => 'Bu kitaplığa fotoğraf ekleyemezsiniz.';

  @override
  String get problemCopy => 'Ayrıntıları kopyala';

  @override
  String get problemDetails => 'Ayrıntılar';

  @override
  String get problemDiskLow =>
      'Sunucunun diski neredeyse dolu, bu yüzden yüklemeler duraklatıldı.';

  @override
  String get problemEmailTaken => 'Bu e-posta başka bir hesapta.';

  @override
  String get problemExists => 'Zaten var.';

  @override
  String get problemFaceNotice =>
      'Sunucunuz, bu uygulamanın gösterdiğinden daha yeni bir yüz bildirimi sürümü istiyor.';

  @override
  String get problemGone => 'Artık sunucuda değil.';

  @override
  String get problemHandleTaken => 'Bu oturum açma adı başka bir hesapta.';

  @override
  String get problemInterrupted => 'Yükleme kesintiye uğradı.';

  @override
  String get problemInvalid => 'Bir değer geçersiz';

  @override
  String get problemLastAdmin => 'Sunucunun en az bir yöneticiye ihtiyacı var.';

  @override
  String get problemLinkInvalid =>
      'Bu bağlantının süresi doldu veya kullanıldı.';

  @override
  String get problemLoginFailed =>
      'E-posta, oturum açma adı veya şifre yanlış.';

  @override
  String get problemMaintenanceKey =>
      'Yedeklemeler, bütünlük taramaları ve kalıcı silmeler API anahtarıyla değil, yalnızca oturum açılarak duraklatılabilir';

  @override
  String get problemNotAllowed => 'Hesabınızın bunu yapma izni yok.';

  @override
  String get problemNotExternal =>
      'Yalnızca sunucunun kendi klasörlerinden kitaplıklar taranabilir.';

  @override
  String get problemOidcClaim =>
      'Oturum açma sağlayıcınız kim olduğunuzu bu sunucunun kabul ettiği şekilde bildirmedi.';

  @override
  String get problemOidcDown =>
      'Oturum açma sağlayıcınız sunucuya yanıt vermiyor.';

  @override
  String get problemOidcFailed =>
      'Oturum açma sağlayıcınız oturum açmayı reddetti.';

  @override
  String get problemOidcNotAllowed => 'Hesabınız bu şekilde oturum açamaz.';

  @override
  String get problemOidcTaken =>
      'Bu oturum açma zaten başka bir Photolib hesabına bağlı.';

  @override
  String get problemOidcUnknown =>
      'Bu sunucu artık bu oturum açma yolunu sunmuyor.';

  @override
  String get problemPasskeysOff =>
      'Geçiş anahtarları yalnızca sunucunun genel adresi olduğunda çalışır.';

  @override
  String get problemPinned =>
      'Bu, yapılandırma dosyasında ayarlı ve burada değiştirilemez.';

  @override
  String get problemPolicyOff => 'Bu, bu sunucuda kapalı.';

  @override
  String get problemQuota => 'Sunucudaki depolama alanınız dolu.';

  @override
  String get problemRestoreKey =>
      'Bir yedek API anahtarıyla değil, yalnızca oturum açılarak geri yüklenebilir.';

  @override
  String get problemRootDiffers =>
      'Bu klasör bu kitaplığın dosyalarını içermiyor';

  @override
  String get problemRootNotAllowed =>
      'Bu klasör, sunucu yapılandırmasındaki external_roots altında değil';

  @override
  String get problemRootOverlaps =>
      'Bu klasör başka bir kitaplığı veya sunucunun kendi verilerini içeriyor ya da bunların içinde';

  @override
  String get problemScanning => 'Bu kitaplık zaten taranıyor';

  @override
  String get problemSecondFactor =>
      'Bu hesap, doğrulama kodu veya geçiş anahtarı gibi ikinci bir faktör gerektiriyor; Photolib\'in bu sürümü bunu henüz sağlayamıyor.';

  @override
  String get problemSetupDone => 'Bu sunucunun zaten bir yöneticisi var.';

  @override
  String get problemSetupExpired => 'Bu çok uzun sürdü.';

  @override
  String get problemSetupToken => 'Bu kurulum belirteci yanlış.';

  @override
  String get problemSignedOut => 'Sunucudan çıkış yaptınız.';

  @override
  String get problemStepUp =>
      'Bu değişiklik için önce şifreniz veya bir kod gerekiyor.';

  @override
  String get problemStorage => 'Sunucu kendi depolamasına ulaşamıyor.';

  @override
  String get problemTooMany => 'Kısa sürede çok fazla deneme.';

  @override
  String get problemUnexpected => 'Beklenmedik bir sorun oluştu.';

  @override
  String get problemUnreachable => 'Sunucu yanıt vermiyor.';

  @override
  String get problemUploadDamaged => 'Dosya yolda değişti veya bozuldu.';

  @override
  String get problemUploadExpired =>
      'Sunucuda artık bu yükleme yok: tamamlanmamış yüklemelerin süresi bir gün sonra dolar.';

  @override
  String get problemWebhookLimit =>
      'Hesabınızda zaten izin verilen en fazla sayıda webhook var.';

  @override
  String get problemWebhooksOff => 'Bu sunucuda webhook\'lar kapalı.';

  @override
  String get recoveryCode => 'Kurtarma kodu';

  @override
  String get recoveryCodeAbout =>
      'Anahtar deposu anahtarını kaybederse Photolib\'in bu cihazdaki deposunu açar';

  @override
  String get recoveryCodeEnter => 'Kurtarma kodunu gir';

  @override
  String get recoveryCreate => 'Kurtarma kodu oluştur';

  @override
  String get recoveryLater => 'Daha sonra';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString değişiklik yalnızca bu cihazda var. Anahtar deposu Photolib\'in anahtarını kaybederse kurtarma kodu onları geri getirir.',
      one:
          '$countString değişiklik yalnızca bu cihazda var. Anahtar deposu Photolib\'in anahtarını kaybederse kurtarma kodu onu geri getirir.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Bu 24 kelimeyi yazın ve güvenli bir yerde saklayın: Photolib\'in bu cihazdaki deposunu anahtar deposundaki anahtarı olmadan açarlar. Önceki tüm kodların yerini alırlar.';

  @override
  String get recoveryUnlock => 'Kilidi aç';

  @override
  String get recoveryWrong => 'Bu, bu deponun kurtarma kodu değil';

  @override
  String get renameFind => 'Bul';

  @override
  String get renamePattern => 'Yeni ad';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Çok uzun: bir ad en fazla 255 bayttır',
      'invalid': 'Geçerli bir dosya adı değil',
      'duplicate': 'Başka bir dosyaya da veriliyor',
      'exists': 'Bu klasördeki başka bir dosya bu ada sahip',
      'other': 'Yeniden adlandırılamıyor',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Şununla değiştir';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Yeniden adlandırılan dosyalar: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Finder\'da göster',
      'windows': 'Gezgin\'de göster',
      'other': 'Klasörde göster',
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
      other: '$countString öğe',
      one: '1 öğe',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Tarihler';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Kitaplığınızda arama yapın';

  @override
  String get searchFavourites => 'Favoriler';

  @override
  String get searchFolder => 'Klasör';

  @override
  String get searchHint => 'Dosya veya klasör adı';

  @override
  String get searchMotionPhotos => 'Hareketli fotoğraflar';

  @override
  String get searchNothing => 'Eşleşen sonuç yok';

  @override
  String get searchPanoramas => 'Panoramalar';

  @override
  String get searchPhotos => 'Fotoğraflar';

  @override
  String get searchScreenshots => 'Ekran görüntüleri';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Videolar';

  @override
  String get securityAddPasskey => 'Geçiş anahtarı ekle';

  @override
  String get securityCode => 'Kod';

  @override
  String get securityCodesHelp =>
      'Bu kodları güvenli bir yerde saklayın. Her biri ikinci faktörünüzün yerine bir kez çalışır ve yalnızca şimdi gösterilir.';

  @override
  String securityCodesLeft(int count) {
    return 'Kullanılmamış: $count';
  }

  @override
  String get securityNewCodes => 'Yeni kodlar';

  @override
  String get securityPasskeyNotAdded => 'Geçiş anahtarı eklenmedi.';

  @override
  String get securityRecoveryCodes => 'Kurtarma kodları';

  @override
  String get securityRemovePasskey => 'Geçiş anahtarını kaldır';

  @override
  String get securitySetUp => 'Ayarla';

  @override
  String get securityStepUpBody =>
      'İkinci faktörlerinizi değiştirmek için şifrenizi, doğrulama uygulamanızdaki bir kodu veya bir kurtarma kodunu girin.';

  @override
  String get securityStepUpTitle => 'Siz olduğunuzu doğrulayın';

  @override
  String get securityTitle => 'İkinci faktörler';

  @override
  String get securityTotp => 'Doğrulama uygulaması';

  @override
  String get securityTotpHelp =>
      'Bu anahtarı doğrulama uygulamanıza ekleyin, ardından gösterdiği kodu girin.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Açık',
      'other': 'Kapalı',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Kapat';

  @override
  String get securityWrongCode => 'Bu kod yanlış.';

  @override
  String get securityWrongProof => 'Şifre veya kod yanlış.';

  @override
  String get selectAll => 'Tümünü seç';

  @override
  String get selectionClear => 'Seçimi temizle';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe seçildi',
      one: '1 öğe seçildi',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Seçilenleri göster';

  @override
  String get serverAccount => 'E-posta veya oturum açma adı';

  @override
  String get serverAdd => 'Sunucu ekle';

  @override
  String get serverAddressInvalid => 'photos.example.org gibi adresler girin';

  @override
  String get serverAddresses => 'Adresler';

  @override
  String get serverAddressesHelp =>
      'Her satıra bir tane: ağınızdaki, internetteki veya VPN üzerinden erişilen sunucu. Uygulama yanıt verenlerin en hızlısını kullanır. Ya da size gönderilen parola belirleme bağlantısını yapıştırın.';

  @override
  String get serverCa => 'Özel CA sertifikası (PEM)';

  @override
  String get serverCaChoose => 'Sertifika dosyası seç';

  @override
  String serverCertificateBody(String host) {
    return '$host, bu cihazın güvenmediği bir sertifika sunuyor. Yalnızca bu SHA-256 parmak izi sunucunuza aitse güvenin:';
  }

  @override
  String get serverCertificateTitle => 'Bu sertifikaya güvenilsin mi?';

  @override
  String get serverConfirm => 'Onayla';

  @override
  String get serverConnect => 'Bağlan';

  @override
  String get serverCreateAdmin => 'Yönetici oluştur';

  @override
  String get serverEnded =>
      'Sunucu bu oturumu sonlandırdı. Yeniden oturum açın.';

  @override
  String get serverHandleHelp =>
      'Küçük harfler, rakamlar, nokta, tire ve alt çizgi; asla değişmez.';

  @override
  String get serverHeaders => 'Özel başlıklar';

  @override
  String get serverHeadersHelp =>
      'Her satıra bir tane, Name: value biçiminde; yalnızca HTTPS üzerinden gönderilir';

  @override
  String get serverHeadersInvalid => 'Her başlığı Name: value biçiminde yazın';

  @override
  String get serverIdentity => 'İstemci sertifikası (PKCS#12)';

  @override
  String get serverIdentityChoose => 'İstemci sertifikası seç';

  @override
  String get serverIdentityInvalid =>
      'Bu bir sertifika (PKCS#12) değil ya da parolası yanlış.';

  @override
  String get serverIdentityPassword => 'İstemci sertifikası parolası';

  @override
  String get serverLoading => 'Bu cihazda saklanan sunucu okunuyor';

  @override
  String get serverNearby => 'Bu ağdaki sunucular';

  @override
  String get serverNeedsHttps =>
      'Bu sunucunun bir HTTPS adresine ihtiyacı var: yerel ağınızın dışında Photolib düz HTTP üzerinden oturum açmaz.';

  @override
  String get serverNoSignIn =>
      'Bu sunucu, Photolib\'in bu sürümünün desteklediği bir oturum açma yöntemi sunmuyor.';

  @override
  String get serverOffline => 'Sunucu yanıt vermiyor. Oturumunuz açık kalıyor.';

  @override
  String get serverPasskeyFailed =>
      'Geçiş anahtarı kullanılmadı. Yeniden deneyin ya da bir kod kullanın.';

  @override
  String get serverPasskeyRequired =>
      'Bu sunucu bir geçiş anahtarı gerektiriyor; Photolib\'in bu sürümü bunu henüz kullanamıyor.';

  @override
  String get serverPassword => 'Şifre';

  @override
  String get serverPasswordAgain => 'Şifreyi tekrarla';

  @override
  String get serverPasswordSetupInvalid =>
      'Bu parola belirleme belirteci yanlış, kullanılmış ya da süresi dolmuş. Yenisini isteyin.';

  @override
  String get serverPasswordSetupToken => 'Parola belirleme belirteci';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Yöneticinizden ya da sunucuda photolibd admin password-setup komutunun çıktısından.';

  @override
  String get serverPasswordsDiffer => 'Şifreler eşleşmiyor.';

  @override
  String get serverPrivateLibrariesBody =>
      'Yeni parola bunları açmaz. Kurtarma kitinizle, bir geçiş anahtarıyla veya hâlâ oturumu açık bir cihazla yeniden açın.';

  @override
  String get serverPrivateLibrariesGo => 'Parolayı belirle';

  @override
  String get serverPrivateLibrariesTitle =>
      'Özel kitaplıklarınız kilitli kalır';

  @override
  String get serverProxy => 'HTTP proxy, host:port biçiminde';

  @override
  String get serverProxyInvalid => 'Proxy\'yi host:port biçiminde girin';

  @override
  String get serverRecoveryCode => 'Kurtarma kodu';

  @override
  String get serverRemove => 'Bu sunucuyu kaldır';

  @override
  String get serverRequired => 'Zorunlu';

  @override
  String get serverSecondFactor =>
      'Bu hesabın ikinci faktörü bir geçiş anahtarı; Photolib\'in bu sürümü bunu henüz kullanamıyor.';

  @override
  String get serverSecondFactorCode =>
      'Bu hesap ayrıca doğrulama uygulamanızdan bir kod veya bir kurtarma kodu gerektiriyor.';

  @override
  String get serverSecondFactorTitle => 'Siz olduğunuzu doğrulayın';

  @override
  String get serverSecondFactorWrong =>
      'Olmadı. Beş denemeden sonra yeniden oturum açın.';

  @override
  String get serverSetPassword => 'Parola belirle';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '$server üzerinde $handle için';
  }

  @override
  String get serverSetPasswordOpen => 'Parola belirle';

  @override
  String get serverSetPasswordTitle => 'Parolanızı belirleyin';

  @override
  String get serverSetUp => 'Yeni sunucu kur';

  @override
  String get serverSetupLinkElsewhere =>
      'Bu bağlantıyı kullanmak için önce bu sunucudaki oturumu kapatın ya da bağlantı başka bir sunucu içinse sunucuyu kaldırın.';

  @override
  String get serverSetupTitle => 'Sunucuyu kur';

  @override
  String get serverSetupToken => 'Kurulum belirteci';

  @override
  String get serverSetupTokenHelp =>
      'Sunucuda yönetici yokken photolibd bunu günlüğüne yazar; her başlatmada yenisini yazar.';

  @override
  String get serverSignIn => 'Oturum aç';

  @override
  String get serverSignOut => 'Oturumu kapat';

  @override
  String serverSignedInAs(String account) {
    return '$account olarak oturum açıldı';
  }

  @override
  String get serverSignedOut => 'Oturum kapalı';

  @override
  String get serverSwitch => 'Hesap değiştir';

  @override
  String get serverTotpCode => 'Kimlik doğrulama uygulamasındaki kod';

  @override
  String get serverTrust => 'Güven';

  @override
  String get serverUnreadable => 'Bu cihazda saklanan sunucu okunamıyor';

  @override
  String get serverUsePasskey => 'Geçiş anahtarı kullan';

  @override
  String get serverUseRecoveryCode => 'Bunun yerine kurtarma kodu kullan';

  @override
  String get settingsBackground => 'Saydam görsellerin arkasında';

  @override
  String get settingsDateFormat => 'Tarih biçimi';

  @override
  String get settingsDefaultTab => 'Klasörler ve albümler şurada açılır';

  @override
  String get settingsFolders => 'Klasörler';

  @override
  String get settingsIndexing => 'Bu cihazda dizinleme';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLibrary => 'Kitaplık';

  @override
  String get settingsServer => 'Sunucu';

  @override
  String get settingsStart => 'Başlangıç ekranı';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Önceki veya sonraki öğe için sol ya da sağ kenara dokunun',
      'oneFingerZoom':
          'Tek parmakla yakınlaştırmak için iki kez dokunup sürükleyin',
      'swipes': 'Parlaklık için videonun sol tarafında, ses için sağ tarafında yukarı veya aşağı kaydırın',
      'maxBrightness': 'Görüntülerken tam parlaklık',
      'autoRotate': 'Her fotoğrafın veya videonun yönüne döndür',
      'mixAudio':
          'Videoları diğer sesi duraklatmak yerine onun üzerinden oynat',
      'autoplay': 'Videoları açıldıklarında oynat',
      'loop': 'Videoları döngüye al',
      'autoNext': 'Video bitince sonraki öğeye geç',
      'resume': 'Videoları bırakıldıkları yerden sürdür',
      'other': 'Hareketli görselleri ızgarada oynat',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep =>
      'Photolib çöp kutusundaki öğeleri ne kadar saklasın';

  @override
  String get settingsViewerBar => 'Görüntüleyici çubuğundaki düğmeler';

  @override
  String get settingsViewing => 'Görüntüleme';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Paylaşılan $countString fotoğraf ve video, Photolib\'in fotoğraf arşivinize ekleme izni almasını bekliyor. Kaydedilmeyen öğeler 7 gün sonra silinir.',
      one: 'Paylaşılan 1 fotoğraf veya video, Photolib\'in fotoğraf arşivinize ekleme izni almasını bekliyor. Kaydedilmeyen öğeler 7 gün sonra silinir.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Tek seferde paylaşmak için çok büyük: Daha az öğe seçin';

  @override
  String shareTooMany(int count) {
    return 'Tek seferde paylaşmak için çok fazla: En fazla $count tane seçin';
  }

  @override
  String get shortcutsTitle => 'Klavye kısayolları';

  @override
  String get slideshow => 'Slayt gösterisi';

  @override
  String get slideshowLoop => 'Tekrarla';

  @override
  String get slideshowOptions => 'Slayt gösterisi seçenekleri';

  @override
  String get slideshowSeconds => 'Öğe başına saniye';

  @override
  String get slideshowShuffle => 'Karıştır';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Azalan',
      'other': 'Artan',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Bu cihaz';

  @override
  String sourceHide(String name) {
    return '$name öğesini gizle';
  }

  @override
  String get sourceHideOthers => 'Buradaki diğer her şeyi gizle';

  @override
  String get sourceLost => 'Erişim yok';

  @override
  String get sourcePartly => 'Kısmen gösteriliyor';

  @override
  String sourceShow(String name) {
    return '$name öğesini göster';
  }

  @override
  String get sourceShowEverything => 'Buradaki her şeyi göster';

  @override
  String get sourceShowOnly => 'Yalnızca bunu göster';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Zaman çizelgesi',
      'folders': 'Klasörler ve albümler',
      'favourites': 'Favoriler',
      'other': 'Zaman çizelgesi',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Bir kişiyi çevrimdışı tut';

  @override
  String get storageBudget => 'Depolama sınırı';

  @override
  String get storageClear => 'Çevrimdışı kopyaları kaldır';

  @override
  String get storageClearAction => 'Kaldır';

  @override
  String storageClearBody(String size) {
    return 'Bu cihazda tutulan $size kaldırılır ve albümler, aramalar ile fotoğraflar artık çevrimdışı tutulmaz. Sunucudaki kitaplığınıza dokunulmaz.';
  }

  @override
  String get storageKeepLibrary => 'Tüm kitaplığı tut';

  @override
  String get storageKeepOriginals => 'Orijinalleri de tut';

  @override
  String get storageNoPeople => 'Henüz adı olan kimse yok.';

  @override
  String get storageNoPins =>
      'Hiçbir şey sabitlenmedi. Çevrimdışı tutmak için bir albümü, aramayı veya fotoğrafı sabitleyin.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Albüm',
      'search': 'Arama',
      'person': 'Kişi',
      'library': 'Tüm kitaplık',
      'asset': 'Fotoğraf',
      'other': 'Sabitlendi',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Sınıra sığmıyor: $size daha gerekli';
  }

  @override
  String get storagePinNothing =>
      'İndirilecek bir şey yok: fotoğrafları zaten bu cihazda';

  @override
  String get storagePinPaused =>
      'Bekliyor: bu ön ayar çevrimdışı hiçbir şey tutmaz';

  @override
  String get storagePinPlanning => 'Neyin tutulacağı belirleniyor…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'İndiriliyor: $haveString / $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Çevrimdışı kullanılabilir ($size)';
  }

  @override
  String get storagePinWaiting => 'Çevrimiçi olunca indirilecek';

  @override
  String get storagePins => 'Çevrimdışı tutulanlar';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Yalnızca katalog',
      'spaceSaver': 'Alan tasarrufu',
      'travel': 'Seçili albümler çevrimdışı',
      'everything': 'Her şey',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Hiçbir şey tutmaz; fotoğraflar açıldığında sunucunuzdan yüklenir.',
      'spaceSaver': 'Tüm kitaplığınızın önizlemelerini, yeniden eskiye, sınır içinde tutar.',
      'travel': 'Yalnızca sabitlediklerinizi tutar: albümler, aramalar ve fotoğraflar.',
      'everything': 'Tüm kitaplığınızın orijinallerini, yeniden eskiye, sınır içinde tutar.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Bu cihazın tuttukları';

  @override
  String get storageSubtitle => 'Çevrimdışı kopyalar ve depolama sınırı';

  @override
  String get storageTitle => 'Depolama';

  @override
  String storageUsed(String used, String budget) {
    return '$used / $budget kullanıldı';
  }

  @override
  String get storageWebNote =>
      'Bir tarayıcı yalnızca önizlemeleri tutar ve oturum kapatılınca siler.';

  @override
  String get storeNoKeyring =>
      'Photolib yerel deposunun anahtarını sistem anahtarlığında tutar ve anahtarlık yanıt vermedi. Secret Service açıkken gnome-keyring, KWallet veya KeePassXC\'yi kurup kilidini açın, sonra yeniden deneyin.';

  @override
  String get storeNoKeystore =>
      'Photolib, yerel deposunun anahtarını tutan bu cihazın anahtar deposuna ulaşamadı.';

  @override
  String get storeRebuilt =>
      'Bu cihazın anahtar deposunda artık Photolib\'in yerel deposunun anahtarı yoktu, bu yüzden depo yeniden oluşturuldu. Ayarları ve yalnızca bu cihazda bulunanlar kayboldu; kitaplıklar yeniden eşitlenir ve küçük resimler geri gelir.';

  @override
  String get storeRecoveryNeeded =>
      'Bu cihazın anahtar deposunda artık Photolib\'in yerel deposunun anahtarı yok. Kurtarma kodunu girin ya da depoyu sıfırlayıp yalnızca bu cihazda bulunanları kaybedin.';

  @override
  String get storeReset => 'Depoyu sıfırla';

  @override
  String get storeResetBody =>
      'Yalnızca bu cihazda bulunanlar kaybolur; kitaplıklar yeniden eşitlenir ve küçük resimler geri gelir.';

  @override
  String get storeUnavailable =>
      'Bu cihazdaki depo kullanılamıyor: ayarlar ve koleksiyonlar saklanmıyor';

  @override
  String get tabCollections => 'Koleksiyonlar';

  @override
  String get tabLibrary => 'Kitaplık';

  @override
  String get tabSearch => 'Ara';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get timelineBenchmark => 'Zaman tüneli performans testi';

  @override
  String get timelineBenchmarkCopy => 'Sonuçları kopyala';

  @override
  String get timelineCannotPlay => 'Bu tarayıcıda oynatılamıyor';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position, toplam $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position, toplam $count, önizleme yok';
  }

  @override
  String get timelineExcluded => 'Hariç tutulan bir klasörde';

  @override
  String get timelineScrubber => 'Tarihe göre kaydır';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Tarih bilinmiyor';

  @override
  String timelineWeek(String date) {
    return '$date haftası';
  }

  @override
  String toolbarAdd(String action) {
    return '$action öğesini çubuğa ekle';
  }

  @override
  String toolbarDown(String action) {
    return '$action öğesini aşağı taşı';
  }

  @override
  String get toolbarInBar => 'Çubukta';

  @override
  String get toolbarInMenu => '⋮ menüsünde';

  @override
  String toolbarRemove(String action) {
    return '$action öğesini çubuktan kaldır';
  }

  @override
  String get toolbarReset => 'Varsayılana sıfırla';

  @override
  String toolbarUp(String action) {
    return '$action öğesini yukarı taşı';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Buraya taşı',
      'other': 'Buraya kopyala',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Bu adda bir dosya veya klasör zaten var',
      'changed': 'Kopya orijinalle eşleşmedi ve kaldırıldı',
      'cancelled': 'İptal edildi',
      'invalid': 'Geçerli bir klasör adı değil',
      'other': 'Başarısız',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Son kullanılanlar';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString öğe kalıcı olarak silinsin mi? Bu işlem geri alınamaz.',
      one: '1 öğe kalıcı olarak silinsin mi? Bu işlem geri alınamaz.',
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
      other: '$daysString gün kaldı',
      one: '1 gün kaldı',
      zero: 'Bugün kalıcı olarak silinecek',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Çöp kutusu boş';

  @override
  String get trashEmptyAll => 'Çöp kutusunu boşalt';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString gün';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe çöp kutusuna taşındı',
      one: '1 öğe çöp kutusuna taşındı',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => 'Listeden kaldır';

  @override
  String trashRetention(int days) {
    return 'Photolib, çöp kutusunda tuttuklarını $days gün sonra kalıcı olarak siler; her öğe kalan süresini gösterir.';
  }

  @override
  String get trashTitle => 'Çöp kutusu';

  @override
  String get undo => 'Geri al';

  @override
  String get uploadAction => 'Fotoğraf ve videoları yükle';

  @override
  String get uploadClear => 'Temizle';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$totalString dosyadan $doneString yüklendi';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Başarısız: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString öğe arşivlendi',
      one: '1 öğe arşivlendi',
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
      other: '$countString öğe gizlendi',
      one: '1 öğe gizlendi',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Siyah',
      'white': 'Beyaz',
      'other': 'Dama',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => 'Bu video bu cihazda oynatılamıyor';

  @override
  String get viewerCaptions => 'Altyazılar';

  @override
  String get viewerCompass => 'Pusula kilidi';

  @override
  String get viewerCopy => 'Kopyala';

  @override
  String get viewerCopyText => 'Metni kopyala';

  @override
  String get viewerCustomize => 'Araç çubuğunu özelleştir…';

  @override
  String get viewerDial =>
      'Yön. Öne bakmak için tıklayın. Etrafa bakmak için sürükleyin, yakınlaştırmak için kaydırın veya kıstırın, sıfırlamak için çift tıklayın';

  @override
  String get viewerFilmstrip => 'Film şeridi';

  @override
  String get viewerFirst => 'İlk';

  @override
  String get viewerFisheye => 'Balıkgözü';

  @override
  String get viewerGyroscope => 'Etrafa bakmak için hareket ettirin';

  @override
  String get viewerHdr => 'HDR olarak göster';

  @override
  String get viewerInfo => 'Bilgi';

  @override
  String get viewerInfoLoading => 'Bu ögenin bilgileri yükleniyor';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString, toplam $countString';
  }

  @override
  String get viewerLast => 'Son';

  @override
  String get viewerLenses => 'Bir lens seçin';

  @override
  String get viewerMap => 'Harita';

  @override
  String get viewerMotion => 'Hareketi oynat';

  @override
  String get viewerMotionDenied =>
      'Bu tarayıcı hareket sensörlerine erişime izin vermedi';

  @override
  String get viewerMotionMissing =>
      'Bu cihazda etrafa bakmak için jiroskop yok';

  @override
  String get viewerMute => 'Sesi kapat';

  @override
  String get viewerNext => 'Sonraki';

  @override
  String get viewerNextFrame => 'Sonraki kare';

  @override
  String get viewerPause => 'Duraklat';

  @override
  String get viewerPlanet => 'Küçük gezegen';

  @override
  String get viewerPlay => 'Oynat';

  @override
  String get viewerPrevious => 'Önceki';

  @override
  String get viewerPreviousFrame => 'Önceki kare';

  @override
  String get viewerRotate => 'Döndür';

  @override
  String get viewerSdr => 'SDR olarak göster';

  @override
  String get viewerSeek => 'Konum';

  @override
  String get viewerSetAs => 'Farklı ayarla';

  @override
  String get viewerShare => 'Paylaş';

  @override
  String get viewerSpeed => 'Oynatma hızı';

  @override
  String get viewerSphere =>
      '360° görünüm. Etrafa bakmak için sürükleyin, yakınlaştırmak için kıstırın';

  @override
  String get viewerText => 'Bu fotoğraftaki metin';

  @override
  String get viewerTextCopied => 'Metin kopyalandı';

  @override
  String get viewerTextNone => 'Bu fotoğrafta metin bulunamadı';

  @override
  String get viewerTextUnread => 'Bu fotoğrafın metni henüz okunmadı';

  @override
  String get viewerUnmute => 'Sesi aç';

  @override
  String get viewerZoomIn => 'Yakınlaştır';

  @override
  String get viewerZoomOut => 'Uzaklaştır';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD kart',
      'other': 'Dahili',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Yakınlaştır';

  @override
  String get zoomOut => 'Uzaklaştır';
}
