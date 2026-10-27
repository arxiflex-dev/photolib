// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get actionAddToAlbum => 'Tambahkan ke album';

  @override
  String get actionArchive => 'Arsipkan';

  @override
  String get actionCopyTo => 'Salin ke…';

  @override
  String get actionDeleteForever => 'Hapus selamanya';

  @override
  String get actionFavourite => 'Favoritkan';

  @override
  String get actionHide => 'Sembunyikan';

  @override
  String get actionMoveTo => 'Pindahkan ke…';

  @override
  String get actionRename => 'Ganti nama';

  @override
  String get actionRestore => 'Pulihkan';

  @override
  String get actionShare => 'Bagikan';

  @override
  String get actionTrash => 'Pindahkan ke sampah';

  @override
  String get actionUnarchive => 'Keluarkan dari arsip';

  @override
  String get actionUndo => 'Urungkan';

  @override
  String get actionUnfavourite => 'Hapus dari favorit';

  @override
  String get actionUnhide => 'Tampilkan';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Aktif',
      'disabled': 'Dinonaktifkan',
      'invited': 'Diundang',
      'deleted': 'Dihapus',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Akun';

  @override
  String get adminAddAccount => 'Tambahkan akun';

  @override
  String get adminAddExternalLibrary => 'Tambahkan pustaka eksternal';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts percobaan',
      zero: 'belum dijalankan',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Log audit';

  @override
  String get adminBackUpNow => 'Cadangkan sekarang';

  @override
  String get adminBackupQueued =>
      'Cadangan sudah diantrekan; uji pemulihan menyusul';

  @override
  String get adminBackups => 'Cadangan database';

  @override
  String get adminCancelJob => 'Batalkan tugas';

  @override
  String get adminCapabilities => 'Kemampuan';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Pustaka terkelola',
      'uploads': 'Unggahan dari perangkat, web, dan CLI',
      'folder_browser': 'Penjelajah folder',
      'device_folders': 'Folder perangkat di aplikasi yang terhubung',
      'sharing': 'Berbagi dan tautan publik',
      'edits': 'Pengeditan',
      'deletes': 'Penghapusan',
      'xmp_writes': 'Penulisan file XMP',
      'face_recognition': 'Pengenalan wajah',
      'ml_search': 'Pencarian cerdas',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Peringatan',
      'fail': 'Gagal',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Disalin';

  @override
  String get adminCopyBundle => 'Salin diagnostik untuk laporan bug';

  @override
  String get adminCopyLink => 'Salin tautan';

  @override
  String get adminDelete => 'Hapus';

  @override
  String get adminDeviceBackups => 'Cadangan perangkat';

  @override
  String get adminDevices => 'Perangkat Anda';

  @override
  String get adminDisable => 'Nonaktifkan';

  @override
  String adminDrillFailed(String detail) {
    return 'Uji pemulihan terakhir gagal: $detail';
  }

  @override
  String get adminEdit => 'Edit';

  @override
  String get adminEmail => 'Email';

  @override
  String get adminEnable => 'Aktifkan';

  @override
  String get adminErrorSignIn => 'Login sebagai administrator';

  @override
  String get adminFacesDefault =>
      'Pengenalan wajah aktif secara default untuk akun baru';

  @override
  String get adminFiles => 'File menurut jenis';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Rusak',
      'missing': 'Hilang',
      'size': 'Ukuran salah',
      'hash': 'Diganti',
      'orphan': 'Berkas lepas',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size tersedia';
  }

  @override
  String get adminFreeDisk =>
      'Jeda upload jika ruang disk kosong kurang dari persentase ini, 0 hingga 50';

  @override
  String get adminFreeDiskGb =>
      'atau di bawah ruang kosong ini dalam GB, jika lebih kecil, 0 hingga 100000';

  @override
  String get adminHandle => 'Nama login';

  @override
  String get adminIntegrity => 'Integritas';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString item',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'Dalam antrean',
      'running': 'Berjalan',
      'done': 'Selesai',
      'dead': 'Gagal',
      'cancelled': 'Dibatalkan',
      'other': 'Semua',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Jenis tugas, misalnya render';

  @override
  String get adminJobs => 'Tugas';

  @override
  String adminLastSeen(String time) {
    return 'Terakhir terlihat $time';
  }

  @override
  String get adminLibraries => 'Pustaka';

  @override
  String get adminLibraryOwner => 'Pemilik';

  @override
  String get adminLibraryRoot => 'Folder di server, misalnya /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Online',
      'offline': 'Offline',
      'scanning': 'Memindai',
      'error': 'Error',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Log server';

  @override
  String get adminName => 'Nama';

  @override
  String get adminNothing => 'Belum ada apa pun di sini';

  @override
  String get adminOutOfRange => 'Di luar rentang';

  @override
  String get adminOverview => 'Ringkasan';

  @override
  String get adminPair => 'Pasangkan perangkat';

  @override
  String get adminPairBody =>
      'Pindai kode ini atau kirim tautannya, lalu tempel di Tambahkan server pada Photolib di perangkat baru: tautan ini membawa semua alamat server ini dan sertifikatnya, jadi tidak ada yang perlu mengetiknya.';

  @override
  String get adminPasswordSetup => 'Tautan pengaturan kata sandi';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Kirim tautan ini ke $name lewat cara apa pun, atau biarkan mereka memindai kodenya. Tautan ini mengatur kata sandi sekali, hingga $date.';
  }

  @override
  String get adminPause => 'Jeda jenis tugas';

  @override
  String adminPauseMinutes(int max) {
    return 'Menit, 1 hingga $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type dijeda hingga $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString item tersisa untuk dicadangkan',
      zero: 'Tidak ada yang tersisa untuk dicadangkan',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Kebijakan';

  @override
  String get adminPolicyReset => 'Gunakan nilai dari tingkat di atasnya';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Aktif secara default',
      'server': 'Diatur untuk server',
      'user': 'Diatur untuk akun ini',
      'library': 'Diatur untuk pustaka ini',
      'config': 'Diatur di konfigurasi',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Terapkan prasetel';

  @override
  String get adminPresetBody =>
      'Prasetel mengatur setiap kemampuan untuk server dan menghapus apa yang diatur akun dan pustaka. Semuanya tetap bisa diubah.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Penampil arsip',
      'family_backup': 'Cadangan keluarga',
      'personal': 'Pribadi',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Pustaka eksternal hanya-baca menjadi satu-satunya sumber kebenaran: tanpa unggahan, pustaka terkelola, folder perangkat, pengeditan, penghapusan, atau penulisan XMP',
      'family_backup': 'Semua aktif kecuali penulisan XMP',
      'personal': 'Semua aktif kecuali berbagi dan tautan publik',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Kode QR tautan';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tugas dalam antrean',
      zero: 'Tidak ada yang perlu dilakukan',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'Kuota penyimpanan dalam GB; kosongkan jika tanpa batas';

  @override
  String get adminRemote => 'Akses jarak jauh';

  @override
  String get adminRemoteBody =>
      'Jangkau server dari mana saja tanpa membuka port di router. Pilih satu cara; masing-masing memberinya alamat HTTPS untuk ditambahkan ke aplikasi. Lalu uji dari luar.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared tersambung keluar ke Cloudflare, yang menyajikan domain Anda lewat HTTPS. Paket gratis membatasi satu permintaan 100 MB, yang tidak pernah dicapai pencadangan: ia mengirim 8 MiB setiap kali.';

  @override
  String get adminRemoteNoAddress =>
      'Tambahkan alamat https:// server ke aplikasi ini untuk mengujinya dari luar.';

  @override
  String get adminRemoteReachable => 'Dapat dijangkau dari luar.';

  @override
  String get adminRemoteTailscale =>
      'Pasang Tailscale di komputer server dan di setiap perangkat, dalam tailnet yang sama atau Headscale Anda, lalu jalankan ini di komputer server dan setel public_url ke alamat yang ditampilkannya.';

  @override
  String get adminRemoteTest => 'Uji dari luar';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host akan membuka $url dari server-servernya di seluruh dunia, sehingga mengetahui alamat ini. Lanjutkan?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Tidak dapat dijangkau dari luar: periksa cara yang Anda pilih, lalu uji lagi.';

  @override
  String get adminRemoteWireguard =>
      'Memerlukan satu port UDP terbuka di sisi server atau di sebuah simpul pusat. Ini konfigurasi untuk perangkat; buat kunci dengan wg genkey.';

  @override
  String get adminRepair =>
      'Kembalikan dari cadangan atau dari perangkat yang masih memilikinya';

  @override
  String get adminRepairOrphan =>
      'Tidak ada foto yang merujuknya: periksa, lalu hapus atau simpan';

  @override
  String get adminReprocess => 'Proses ulang';

  @override
  String get adminReprocessFaces => 'Deteksi ulang wajah';

  @override
  String get adminReprocessFolder =>
      'Folder, misalnya 2024/05; kosongkan untuk seluruh pustaka';

  @override
  String get adminReprocessMetadata => 'Baca ulang metadata';

  @override
  String get adminReprocessRenditions => 'Buat ulang thumbnail dan pratinjau';

  @override
  String get adminRestore => 'Pulihkan';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Pemulihan $name gagal: $detail';
  }

  @override
  String get adminRestoreUnverified => 'Belum ada uji pemulihan yang lolos';

  @override
  String adminRestoreVerified(String when) {
    return 'Pemulihan terakhir yang terverifikasi: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd berhenti, lalu mengganti seluruh basis data dengan $name saat dijalankan lagi. Perubahan sejak cadangan itu hilang, dan setiap perangkat menyinkronkan dari awal.';
  }

  @override
  String get adminRestoring => 'photolibd berhenti untuk memulihkan cadangan';

  @override
  String get adminResume => 'Lanjutkan';

  @override
  String get adminRetry => 'Coba lagi';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrator',
      'user': 'Pengguna',
      'viewer': 'Pelihat',
      'other': 'Tidak diketahui',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Disimpan';

  @override
  String get adminScan => 'Pindai sekarang';

  @override
  String get adminScrubDays =>
      'Hari bagi pemeriksaan untuk memeriksa setiap file asli, 1 sampai 3650';

  @override
  String get adminScrubNever => 'Pemeriksaan penuh pertama sedang berjalan';

  @override
  String adminScrubbed(String time) {
    return 'Pemeriksaan penuh terakhir $time';
  }

  @override
  String get adminSecondAdmin =>
      'Jadikan orang kedua administrator, agar orang lain dapat menjalankan dan memulihkan server jika Anda tidak bisa.';

  @override
  String adminSilent(String time) {
    return 'Diam sejak $time';
  }

  @override
  String get adminSilentHours =>
      'Jam tanpa laporan hingga cadangan perangkat dianggap diam, 1 sampai 8760';

  @override
  String get adminStores => 'Penyimpanan';

  @override
  String get adminThisDevice => 'Perangkat ini';

  @override
  String get adminTitle => 'Administrasi server';

  @override
  String get adminTrashDays => 'Jumlah hari di sampah, 1 hingga 3650';

  @override
  String get adminTwoFactor => 'Semua akun harus menyiapkan faktor kedua';

  @override
  String get adminUsage => 'Penggunaan per akun';

  @override
  String get albumCover => 'Jadikan sampul';

  @override
  String get albumEmpty => 'Album ini kosong';

  @override
  String get albumHideMemories => 'Sembunyikan dari kenangan';

  @override
  String get albumHideTimeline => 'Sembunyikan dari lini masa';

  @override
  String get albumNew => 'Album baru';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Tanggal berapa pun';

  @override
  String get backupCap => 'Item terbesar';

  @override
  String get backupCharging => 'Hanya saat mengisi daya';

  @override
  String backupCompleted(String time) {
    return 'Pencadangan lengkap terakhir: $time';
  }

  @override
  String backupContact(String time) {
    return 'Kontak terakhir dengan server: $time';
  }

  @override
  String get backupEnabled => 'Cadangkan perangkat ini';

  @override
  String get backupFolderNo => 'Jangan yang ini';

  @override
  String get backupFolderYes => 'Cadangkan';

  @override
  String backupHours(int count) {
    return '$count jam';
  }

  @override
  String get backupMetered =>
      'Di jaringan berkuota, seperti data seluler atau hotspot';

  @override
  String get backupNever => 'Belum ada pencadangan lengkap';

  @override
  String backupNewFolder(String name) {
    return 'Folder baru $name: cadangkan?';
  }

  @override
  String get backupNoLimit => 'Tanpa batas';

  @override
  String get backupNothing => 'Tidak ada yang menunggu';

  @override
  String get backupNow => 'Cadangkan sekarang';

  @override
  String backupOverdue(int hours, String items) {
    return 'Tidak ada pencadangan lengkap selama $hours jam. Menunggu: $items';
  }

  @override
  String get backupOverdueTitle => 'Pencadangan belum selesai';

  @override
  String backupPending(String items) {
    return 'Menunggu: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Dicoba lagi: $time';
  }

  @override
  String get backupRoaming => 'Cadangkan saat roaming';

  @override
  String get backupSignIn => 'Masuk ke server untuk mencadangkan perangkat ini';

  @override
  String get backupSignedOut =>
      'Pencadangan berhenti: server mengeluarkan perangkat ini. Masuk lagi di Setelan.';

  @override
  String get backupSince => 'Diambil sejak';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Pencadangan menunggu server dapat dijangkau',
      'charging': 'Pencadangan menunggu perangkat diisi daya',
      'battery_low': 'Pencadangan menunggu: baterai lemah',
      'roaming': 'Pencadangan menunggu selama roaming',
      'quota': 'Pencadangan berhenti: penyimpanan Anda di server penuh',
      'second_factor':
          'Pencadangan berhenti: server meminta faktor kedua untuk akun ini',
      'other': 'Pencadangan berhenti: server menjawab $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Pencadangan';

  @override
  String get backupWaiting => 'Belum dicadangkan';

  @override
  String get backupWarnAfter => 'Peringatkan jika belum selesai selama';

  @override
  String get backupWhat => 'Yang dicadangkan';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'Di folder yang tidak Anda pilih',
      'folder_new': 'Di folder baru: pilih apakah akan dicadangkan',
      'type_excluded': 'Jenis item yang tidak Anda pilih',
      'before_date': 'Diambil sebelum tanggal yang Anda pilih',
      'selected': 'Menunggu giliran',
      'server_restored': 'Server kehilangannya saat pemulihan: dikirim lagi',
      'working': 'Sedang dicadangkan',
      'waiting_for_icloud': 'Menunggu iCloud mengunduhnya',
      'metered': 'Menunggu jaringan tanpa kuota',
      'metered_cap': 'Terlalu besar untuk jaringan berkuota',
      'unreadable': 'Perangkat ini tidak dapat membacanya',
      'changed': 'Berubah saat dikirim',
      'quota': 'Penyimpanan Anda di server penuh',
      'other': 'Server menolaknya: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Server tidak lagi bekerja dengan versi Photolib ini.';

  @override
  String get checkAppTooOldNext => 'Perbarui Photolib.';

  @override
  String get checkChanged => 'Sertifikat server bukan yang Anda percayai.';

  @override
  String get checkChangedNext =>
      'Jika administrator Anda menggantinya, percayai yang baru. Jika tidak, mungkin ada yang menyadap: jangan lanjutkan.';

  @override
  String get checkClock =>
      'Jam perangkat ini dan jam server berselisih lebih dari lima menit.';

  @override
  String get checkClockNext =>
      'Biarkan perangkat Anda mengatur tanggal dan waktu secara otomatis.';

  @override
  String get checkDnsFailed => 'Nama server tidak mengarah ke alamat mana pun.';

  @override
  String get checkDnsFailedNext =>
      'Periksa alamatnya, atau sambungkan ke jaringan server.';

  @override
  String checkExpired(String date) {
    return 'Sertifikat server kedaluwarsa pada $date.';
  }

  @override
  String get checkFailed => 'Gagal';

  @override
  String get checkMetered =>
      'Anda berada di jaringan terukur, seperti data seluler.';

  @override
  String get checkMeteredNext =>
      'Sambungkan ke Wi-Fi sebelum pencadangan besar.';

  @override
  String get checkNotPhotolib =>
      'Yang menjawab bukan Photolib, misalnya halaman galat proxy atau halaman login Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Login ke Wi-Fi di browser Anda, atau minta administrator memeriksa proxy.';

  @override
  String get checkOtherServer => 'Server Photolib lain menjawab di alamat ini.';

  @override
  String get checkPassed => 'Lolos';

  @override
  String get checkRefused => 'Tidak ada yang menjawab di alamat ini.';

  @override
  String get checkRefusedNext =>
      'Pastikan server berjalan dan Anda berada di jaringan atau VPN-nya.';

  @override
  String get checkRun => 'Periksa koneksi';

  @override
  String get checkRunning => 'Memeriksa';

  @override
  String get checkSelfSigned =>
      'Server memakai sertifikatnya sendiri, yang belum dikenal perangkat ini.';

  @override
  String get checkSkipped => 'Tidak diperiksa';

  @override
  String get checkStepAuth => 'Login Anda';

  @override
  String get checkStepClock => 'Jam perangkat Anda';

  @override
  String get checkStepDns => 'Mencari alamat server';

  @override
  String get checkStepNetwork => 'Jaringan Anda';

  @override
  String get checkStepServer => 'Photolib di server';

  @override
  String get checkStepTcp => 'Menjangkau server';

  @override
  String get checkStepTls => 'Koneksi aman dan sertifikat';

  @override
  String get checkStepUpload => 'Unggahan besar melalui proxy';

  @override
  String get checkTimedOut => 'Server terlalu lama menjawab.';

  @override
  String get checkTimedOutNext => 'Periksa koneksi Anda, lalu coba lagi.';

  @override
  String get checkTitle => 'Pemeriksaan koneksi';

  @override
  String get checkTlsFailed => 'Koneksi aman gagal.';

  @override
  String get checkTrustNext =>
      'Percayai hanya jika sidik jarinya cocok dengan milik server Anda.';

  @override
  String get checkUntrusted =>
      'Sertifikat server berasal dari otoritas yang tidak dipercaya perangkat ini.';

  @override
  String get checkUploadCap =>
      'Proxy di tengah jalan menolak unggahan besar, jadi pencadangan berjalan lebih lambat dalam potongan kecil.';

  @override
  String get checkUploadCapNext =>
      'Minta administrator agar proxy meloloskan permintaan sebesar 64 MB.';

  @override
  String get collectionAlbums => 'Album';

  @override
  String collectionHide(String name) {
    return 'Sembunyikan $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Pindahkan $name ke bawah';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Pindahkan $name ke atas';
  }

  @override
  String get collectionPeople => 'Orang';

  @override
  String collectionPin(String name) {
    return 'Sematkan $name';
  }

  @override
  String get collectionPlaces => 'Tempat';

  @override
  String collectionShow(String name) {
    return 'Tampilkan $name';
  }

  @override
  String get collectionTags => 'Tag';

  @override
  String collectionUnpin(String name) {
    return 'Lepas sematan $name';
  }

  @override
  String get collectionsCustomise => 'Sesuaikan';

  @override
  String get collectionsDone => 'Selesai';

  @override
  String get commandPalette => 'Palet perintah';

  @override
  String get commandPaletteHint => 'Ketik perintah';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString di perangkat ini dan sudah dicadangkan',
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
      other: '$countString hanya di perangkat ini, belum dicadangkan',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Jika Foto iCloud aktif, item yang dihapus dari perangkat ini juga hilang dari iCloud dan perangkat Apple Anda yang lain.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString hanya di pustaka Anda',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Singkirkan dari perangkat ini';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString item yang sudah dicadangkan; pustaka Anda tetap menyimpannya',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Salinan di perangkat ini masuk ke sampahnya: ruang kembali setelah sampah dikosongkan.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hapus $countString item?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Dari perangkat ini dan pustaka Anda',
      'device': 'Hanya dari perangkat ini',
      'other': 'Dari pustaka Anda',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Tidak ada';

  @override
  String get deviceFolderCard => 'Kartu SD';

  @override
  String get deviceFolderExclude => 'Kecualikan';

  @override
  String get deviceFolderExcludeThis => 'Kecualikan folder ini';

  @override
  String get deviceFolderExcludedNotice =>
      'Folder item ini dikecualikan dari pustaka Anda';

  @override
  String get deviceFolderForget => 'Hapus dari daftar';

  @override
  String get deviceFolderInternal => 'Penyimpanan internal';

  @override
  String get deviceFolderKeep => 'Simpan';

  @override
  String deviceFolderNew(String name, String items) {
    return 'Folder baru: $name, $items';
  }

  @override
  String get deviceFolders => 'Folder perangkat';

  @override
  String get deviceFoldersAll =>
      'Tampilkan semua folder kecuali yang dikecualikan';

  @override
  String get deviceFoldersChosen => 'Tampilkan hanya folder yang dipilih';

  @override
  String get deviceFoldersExcludedNow => 'Dikecualikan dari pustaka';

  @override
  String get deviceFoldersSearch => 'Cari folder';

  @override
  String get diagnosticsAdvanced => 'Tampilkan diagnostik';

  @override
  String get diagnosticsAllLoggers => 'Semua sumber';

  @override
  String get diagnosticsCopied => 'Log disalin';

  @override
  String get diagnosticsCopy => 'Salin log yang ditampilkan';

  @override
  String get diagnosticsEmpty => 'Belum ada entri log';

  @override
  String get diagnosticsExport => 'Ekspor paket diagnostik';

  @override
  String get diagnosticsExported => 'Paket diagnostik disimpan';

  @override
  String get diagnosticsLevel => 'Tingkat';

  @override
  String get diagnosticsLogger => 'Sumber';

  @override
  String get diagnosticsTitle => 'Diagnostik';

  @override
  String get download => 'Unduh';

  @override
  String get downloadCurrent => 'Versi saat ini, dengan editannya';

  @override
  String get downloadFailed => 'Tidak dapat mengunduh';

  @override
  String get downloadOriginal => 'Asli';

  @override
  String downloadSaved(String name) {
    return '$name disimpan';
  }

  @override
  String get downloadVersion => 'Versi mana?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mengunduh $countString item',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Tingkatkan otomatis';

  @override
  String get editorCrop => 'Pangkas';

  @override
  String get editorCropOriginal => 'Asli';

  @override
  String get editorCropSquare => 'Persegi';

  @override
  String get editorEdit => 'Edit';

  @override
  String get editorFlip => 'Balik';

  @override
  String get editorRotate => 'Putar';

  @override
  String get editorSaveCopy => 'Simpan salinan';

  @override
  String get editorSaveFailed => 'Tidak dapat menyimpan salinan';

  @override
  String get editorSaveVersion => 'Simpan';

  @override
  String get editorSaved => 'Disimpan sebagai salinan';

  @override
  String get editorVersionFailed => 'Versi tidak dapat disimpan';

  @override
  String get editorVersionSaved => 'Disimpan sebagai versi baru';

  @override
  String get editorVersionsUnsupported =>
      'Server ini belum dapat menyimpan versi foto yang diedit';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString perubahan dibatalkan: server menolaknya.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Tutup';

  @override
  String get editsRejectedForbidden =>
      'Anda dapat melihat item tersebut, tetapi tidak dapat mengubahnya.';

  @override
  String get editsRejectedInvalid =>
      'Server tidak dapat menerima perubahan tersebut.';

  @override
  String get editsRejectedNotFound =>
      'Item tersebut telah dihapus atau tidak lagi dibagikan dengan Anda.';

  @override
  String get errorNotFound => 'Halaman ini tidak ada';

  @override
  String get errorRetry => 'Coba lagi';

  @override
  String get errorTitle => 'Terjadi kesalahan';

  @override
  String faceNumber(int number) {
    return 'Wajah $number';
  }

  @override
  String get facesAgree => 'Saya setuju';

  @override
  String get facesAura =>
      'Gambarkan wajah dengan AuraFace (unduhan lebih besar)';

  @override
  String get facesNotNow => 'Nanti saja';

  @override
  String get facesNoticeKeep =>
      'Yang ditemukan tetap bersama foto Anda, di perangkat dan server Anda. Gambaran itu tidak pernah ditampilkan atau dibagikan, dan semuanya dihapus saat Anda berhenti atau menghapus foto.';

  @override
  String get facesNoticeOptional =>
      'Ini opsional. Semua hal lain di Photolib berfungsi tanpanya, dan Anda dapat berhenti kapan saja di Pengaturan.';

  @override
  String get facesNoticeTitle => 'Temukan wajah di foto Anda?';

  @override
  String get facesNoticeWhat =>
      'Photolib mencari wajah di foto dan video Anda, dan menyimpan untuk setiap wajah letaknya serta daftar angka yang menggambarkannya, agar orang yang sama dapat ditemukan lagi. Gambaran semacam itu dapat dianggap sebagai data biometrik.';

  @override
  String get facesNoticeWhere =>
      'Ini terjadi di perangkat ini dan, jika Anda masuk, di server Anda sendiri. Tidak pernah di layanan yang dijalankan oleh kami atau pihak lain.';

  @override
  String get facesServerFailed =>
      'Server Anda tidak dapat diberi tahu. Coba lagi.';

  @override
  String get facesServerOff => 'Server Anda tidak menemukan wajah untuk Anda';

  @override
  String get facesServerOn => 'Server Anda menemukan wajah untuk Anda';

  @override
  String get facesServerUnavailable =>
      'Server Anda tidak menyediakan pengenalan wajah';

  @override
  String facesStatusDownloading(int percent) {
    return 'Mengunduh model wajah: $percent%';
  }

  @override
  String get facesStatusMissing => 'Server Anda belum memasang model wajah';

  @override
  String get facesStatusNoDecoder =>
      'Pencarian wajah tidak tersedia: pustaka gambar (libvips) tidak ditemukan. Pasang ulang Photolib, atau pasang libvips lalu mulai ulang.';

  @override
  String get facesStatusRunning => 'Menemukan wajah di perangkat ini';

  @override
  String get facesStatusUnavailable =>
      'Wajah tidak dapat ditemukan di perangkat ini';

  @override
  String get facesStatusWaiting => 'Model wajah diunduh lewat Wi-Fi';

  @override
  String get facesSwitch => 'Temukan wajah di foto saya';

  @override
  String get facesSwitchOff =>
      'Nonaktif. Tidak ada yang dihitung tentang wajah sampai Anda setuju.';

  @override
  String get facesSwitchOn => 'Aktif. Photolib menemukan wajah di foto Anda.';

  @override
  String get facesTitle => 'Wajah dan orang';

  @override
  String get facesWithdraw => 'Hapus dan berhenti';

  @override
  String get facesWithdrawBody =>
      'Ini menghapus setiap wajah, gambaran, dan orang yang ditemukan Photolib untuk Anda, di perangkat ini dan di server Anda. Foto Anda tidak berubah.';

  @override
  String get facesWithdrawTitle => 'Berhenti menemukan wajah?';

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

    return 'File tidak diubah: $countString';
  }

  @override
  String get folderAllow => 'Izinkan akses ke folder ini';

  @override
  String get folderDelete => 'Hapus folder';

  @override
  String folderDeleteBody(String name) {
    return 'Pindahkan foto dan video di $name ke sampah?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString item',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Folder baru';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Offline, $countString item',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Folder ini sudah ada di pustaka, atau berada di dalam atau mencakup folder yang sudah ada';

  @override
  String get folderRemove => 'Hapus folder';

  @override
  String folderRemoveBody(String folder) {
    return 'Foto dan video dari $folder akan dikeluarkan dari pustaka. File tetap ada di disk, tidak diubah.';
  }

  @override
  String get folderRemoveConfirm => 'Hapus';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Memindai, sejauh ini $countString item',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Izinkan akses';

  @override
  String get foldersHideExcluded => 'Sembunyikan folder yang dikecualikan';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib tidak dapat lagi membaca $countString folder.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Tampilkan folder yang dikecualikan ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Browser ini tidak dapat menyimpan folder sebagai pustaka Anda. Buka Photolib di Chrome atau Edge pada komputer, atau gunakan aplikasi desktop.';

  @override
  String get galleryButtons => 'Tombol';

  @override
  String get galleryChips => 'Chip';

  @override
  String get galleryGrid => 'Petak';

  @override
  String get galleryMenus => 'Menu dan sheet';

  @override
  String get galleryShowSheet => 'Tampilkan sheet';

  @override
  String get galleryTitle => 'Komponen';

  @override
  String hiddenCollections(int count) {
    return 'Disembunyikan ($count)';
  }

  @override
  String get indexingAllowMetered => 'Unduh lewat data seluler';

  @override
  String get indexingAllowSaver => 'Juga dalam mode hemat daya';

  @override
  String get indexingBattery => 'Baterai yang dibutuhkan tanpa pengisi daya';

  @override
  String get indexingChargingOnly => 'Hanya saat mengisi daya';

  @override
  String indexingDownloading(int percent) {
    return 'Mengunduh model pencarian: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foto tidak dapat dibaca',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Perangkat ini hanya mengindeks foto barunya';

  @override
  String get indexingMissing => 'Server Anda belum memasang model pencarian';

  @override
  String get indexingModels => 'Cari di perangkat ini';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Mengunduh model pencarian ($megabytesString MB) dari $host';
  }

  @override
  String get indexingNoDecoder =>
      'Pencarian dan pembacaan teks tidak tersedia: pustaka gambar (libvips) tidak ditemukan. Pasang ulang Photolib, atau pasang libvips lalu mulai ulang.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Dijeda selama baterai di bawah $percent%';
  }

  @override
  String get indexingPausedCharger => 'Dijeda hingga perangkat diisi daya';

  @override
  String get indexingPausedHeat => 'Dijeda selama perangkat panas';

  @override
  String get indexingPausedSaver => 'Dijeda selama penghemat baterai aktif';

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

    return 'Foto terindeks: $doneString dari $totalString';
  }

  @override
  String get indexingText => 'Baca teks di foto';

  @override
  String indexingTextDownloading(int percent) {
    return 'Mengunduh model teks: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Mengunduh model teks ($megabytesString MB) dari $host; menemukan kata di foto Anda';
  }

  @override
  String get indexingTextMissing => 'Server Anda belum memasang model teks';

  @override
  String get indexingTextPlatform =>
      'Memakai pengenalan teks bawaan ponsel Anda; tidak ada yang diunduh. Membaca foto baru';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Foto yang dibaca teksnya: $doneString dari $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Membaca teks tidak tersedia di sini';

  @override
  String get indexingTextWaiting => 'Model teks diunduh lewat Wi-Fi';

  @override
  String get indexingUnavailable =>
      'Pencarian di perangkat ini tidak tersedia di sini';

  @override
  String get indexingWaiting => 'Model pencarian diunduh lewat Wi-Fi';

  @override
  String get infoAddName => 'Tambah nama';

  @override
  String get infoAddTag => 'Tambah tag';

  @override
  String get infoAlbums => 'Album';

  @override
  String get infoAllMetadata => 'Lihat semua metadata';

  @override
  String get infoAuto => 'Otomatis';

  @override
  String get infoBackedUp => 'Dicadangkan';

  @override
  String get infoCamera => 'Kamera';

  @override
  String get infoChangeAdjust => 'Warna disesuaikan';

  @override
  String get infoChangeCrop => 'Dipangkas';

  @override
  String get infoChangeFlip => 'Dicerminkan';

  @override
  String get infoChangeInpaint => 'Area diisi';

  @override
  String get infoChangeLocal => 'Area disesuaikan';

  @override
  String get infoChangeLut => 'Gaya warna diterapkan';

  @override
  String get infoChangeOther => 'Diedit';

  @override
  String get infoChangeTurn => 'Diputar';

  @override
  String get infoCompare => 'Bandingkan dengan asli';

  @override
  String infoConfidence(String percent) {
    return 'Keyakinan: $percent';
  }

  @override
  String get infoCopyPath => 'Salin jalur';

  @override
  String get infoCurrent => 'Saat ini';

  @override
  String get infoDescription => 'Tambahkan deskripsi';

  @override
  String get infoEditDate => 'Ubah tanggal';

  @override
  String infoEditNumber(int number) {
    return 'Suntingan $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Salinan hasil edit dari $name';
  }

  @override
  String get infoFaces => 'Wajah';

  @override
  String get infoFile => 'File';

  @override
  String get infoFromFileName => 'dari nama file';

  @override
  String get infoHistory => 'Riwayat edit';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Lokasi';

  @override
  String get infoMap => 'Peta tempat pengambilannya';

  @override
  String get infoMapAgree =>
      'Ubin peta berasal dari internet dan menunjukkan area yang Anda lihat';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Tag baru: $path';
  }

  @override
  String get infoNoAlbum => 'Tidak ada di album mana pun';

  @override
  String get infoOnDevice => 'Di perangkat ini';

  @override
  String get infoOriginal => 'Asli';

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
    return 'Hapus dari $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Hapus $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Dihapus dari $album';
  }

  @override
  String get infoRevert => 'Kembalikan';

  @override
  String get infoSaveCopy => 'Simpan sebagai salinan';

  @override
  String get infoShared => 'dibagikan';

  @override
  String get infoShowFaces => 'Tampilkan wajah di foto';

  @override
  String get infoShowMap => 'Tampilkan peta';

  @override
  String get infoTags => 'Tag';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count versi',
    );
    return '$_temp0 · terakhir $time';
  }

  @override
  String get infoWhy => 'Mengapa tanggal ini?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Dibaca dari file, sebagai $tag',
      'name': 'Dibaca dari nama file',
      'folder': 'Dibaca dari nama folder',
      'host': 'Diberikan oleh layanan asal file',
      'unknown': 'Tidak ada apa pun di file yang menunjukkan tanggalnya, jadi tanggal terakhir diubah yang digunakan',
      'other': 'File belum dibaca, jadi tanggal dari perangkat yang digunakan',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Daftar',
      'other': 'Petak',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Nama',
      'taken': 'Tanggal diambil',
      'modified': 'Tanggal diubah',
      'size': 'Ukuran',
      'random': 'Acak',
      'extension': 'Jenis',
      'custom': 'Urutan album',
      'other': 'Tanggal diambil',
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
  String get languageDevice => 'Bahasa perangkat';

  @override
  String get languageName => 'Bahasa Indonesia';

  @override
  String get libraryAddFolder => 'Tambahkan folder';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Belum dicadangkan',
      'backed_up': 'Sudah dicadangkan',
      'cloud_only': 'Hanya di cloud',
      'other': 'Semua',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Semuanya sudah dicadangkan',
      'backed_up': 'Belum ada yang dicadangkan',
      'cloud_only': 'Tidak ada yang hanya di server',
      'other': 'Tidak ada apa pun di sini',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Lencana cadangan';

  @override
  String get libraryEmpty => 'Foto Anda akan muncul di sini';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Kelompokkan per minggu',
      'month': 'Kelompokkan per bulan',
      'other': 'Kelompokkan per hari',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled =>
      'Sembunyikan lagi item tersembunyi dan terarsip';

  @override
  String get libraryNoKeyring =>
      'Photolib menyimpan kunci pustaka Anda di keyring sistem, yang tidak berjalan atau terkunci. Jalankan atau buka kunci keyring, seperti GNOME Keyring atau KWallet, lalu coba lagi.';

  @override
  String get libraryRevealExcluded =>
      'Tampilkan folder yang dikecualikan selama 5 menit';

  @override
  String get libraryShowVeiled =>
      'Tampilkan item tersembunyi dan terarsip selama 5 menit';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Baru ditambahkan',
      'other': 'Tanggal diambil',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib tidak dapat membuka pustaka yang disimpan di perangkat ini';

  @override
  String get libraryViewOptions => 'Opsi tampilan';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Menyiapkan thumbnail: $doneString dari $totalString';
  }

  @override
  String get libraryZoomIn => 'Thumbnail lebih besar';

  @override
  String get libraryZoomOut => 'Thumbnail lebih kecil';

  @override
  String get mapAddTrack => 'Tambahkan jejak GPX';

  @override
  String get mapArea => 'Area peta';

  @override
  String get mapAttribution => '© kontributor OpenStreetMap';

  @override
  String get mapClearLasso => 'Hapus pilihan';

  @override
  String get mapEmpty => 'Belum ada foto dengan lokasi';

  @override
  String get mapHeat => 'Peta panas';

  @override
  String get mapLasso => 'Pilih dengan menggambar di sekeliling foto';

  @override
  String get mapLoading => 'Menempatkan foto di peta';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Foto: $countString';
  }

  @override
  String get mapSearchHere => 'Cari di area ini';

  @override
  String get mapSplit => 'Tampilkan foto di bawah peta';

  @override
  String get mapTilesAgree =>
      'Latar peta berasal dari server OpenStreetMap (tile.openstreetmap.org), yang melihat area mana yang Anda lihat';

  @override
  String get mapTilesShow => 'Tampilkan latar';

  @override
  String get mapTime => 'Rentang waktu';

  @override
  String get mapTitle => 'Peta';

  @override
  String get mapTrackBad => 'Berkas itu tidak memiliki jejak GPX';

  @override
  String get mapTrips => 'Perjalanan';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Favorit',
      'hidden': 'Tersembunyi',
      'archived': 'Terarsip',
      'offline': 'Disimpan di perangkat ini',
      'offline': 'Disimpan di perangkat ini',
      'offline': 'Disimpan di perangkat ini',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Izinkan akses';

  @override
  String get mediaAccessNone =>
      'Photolib memerlukan akses ke foto dan video Anda untuk menampilkannya.';

  @override
  String get mediaAccessPartial =>
      'Photolib hanya melihat foto dan video yang Anda pilih. Galeri memerlukan akses ke semuanya.';

  @override
  String get mediaAccessSelect => 'Pilih foto lainnya';

  @override
  String get nameLabel => 'Nama';

  @override
  String get nextAddRoot =>
      'Tambahkan folder ke external_roots di konfigurasi server, lalu mulai ulang server.';

  @override
  String get nextAskAdmin => 'Tanyakan kepada administrator server Anda.';

  @override
  String get nextAskOwner =>
      'Minta pemilik perpustakaan agar mengizinkan Anda menambahkan foto.';

  @override
  String get nextCheckConnection =>
      'Periksa koneksi untuk melihat penyebabnya.';

  @override
  String get nextCheckEntry => 'Periksa yang Anda masukkan, lalu coba lagi.';

  @override
  String get nextConfirm =>
      'Periksa berapa banyak item yang terdampak, lalu konfirmasi.';

  @override
  String get nextDeleteWebhook =>
      'Hapus webhook yang tidak lagi Anda gunakan, lalu coba lagi.';

  @override
  String get nextEditConfig =>
      'Ubah di konfigurasi server, lalu mulai ulang server.';

  @override
  String get nextFreeSpace =>
      'Kosongkan ruang, atau minta tambahan kepada administrator Anda.';

  @override
  String get nextNewLink => 'Minta yang baru kepada administrator Anda.';

  @override
  String get nextNewestToken => 'Salin yang terbaru dari log photolibd.';

  @override
  String get nextOtherAdmin =>
      'Jadikan akun lain administrator terlebih dahulu.';

  @override
  String get nextOtherFolder => 'Pilih folder tersendiri.';

  @override
  String get nextRefresh => 'Muat ulang lalu coba lagi.';

  @override
  String get nextReport =>
      'Coba lagi. Jika terjadi lagi, salin detail di bawah untuk administrator Anda.';

  @override
  String get nextSetUpPrivate =>
      'Selesaikan penyiapan pustaka pribadi di Setelan, lalu coba lagi.';

  @override
  String get nextSignIn => 'Login lagi.';

  @override
  String get nextSignInAccount => 'Login dengan akun Anda, lalu coba lagi.';

  @override
  String get nextSignInInstead => 'Login saja.';

  @override
  String get nextTryAgain => 'Coba lagi.';

  @override
  String get nextUpdateAndAgree =>
      'Perbarui aplikasi, lalu setujui pemberitahuan itu lagi.';

  @override
  String get nextUseAnother => 'Pilih yang lain.';

  @override
  String get nextUseHttps =>
      'Gunakan alamat https:// server, atau sambungkan dari jaringan server itu sendiri.';

  @override
  String get nextWait => 'Tunggu sebentar, lalu coba lagi.';

  @override
  String get offlineKeep => 'Simpan offline';

  @override
  String offlineKeepHere(String size) {
    return 'Simpan di perangkat ini ($size)';
  }

  @override
  String get offlineKeptHere => 'Disimpan di perangkat ini';

  @override
  String get offlineStopKeeping => 'Berhenti menyimpan offline';

  @override
  String get otherFiles => 'File lainnya';

  @override
  String get passphraseCreate =>
      'Komputer ini tidak menjalankan keyring (Secret Service) untuk menyimpan kunci Photolib. Pilih frasa sandi minimal 10 karakter untuk melindunginya: Photolib menanyakannya setiap kali dimulai.';

  @override
  String get passphraseLabel => 'Frasa sandi';

  @override
  String get passphraseMismatch => 'Frasa sandi tidak sama.';

  @override
  String get passphraseRepeat => 'Ulangi frasa sandi';

  @override
  String get passphraseTooShort => 'Gunakan minimal 10 karakter.';

  @override
  String get passphraseUnlock =>
      'Masukkan frasa sandi yang melindungi kunci Photolib di komputer ini.';

  @override
  String get passphraseWrong => 'Frasa sandi salah. Coba lagi.';

  @override
  String photoPosition(int index, int count) {
    return 'Foto $index dari $count';
  }

  @override
  String get privacyCheckKit => 'Periksa kit pemulihan';

  @override
  String get privacyDrillDue =>
      'Saatnya latihan pemulihan: periksa apakah kit pemulihan Anda masih membuka kunci pustaka pribadi Anda.';

  @override
  String get privacyHonest =>
      'Pustaka pribadi dienkripsi di perangkat Anda, dan tidak ada orang lain yang dapat membukanya: bukan server, bukan administratornya, bukan pengembang Photolib. Jika Anda kehilangan kata sandi dan kit pemulihan sekaligus, foto Anda hilang selamanya, dan tidak ada yang dapat mengembalikannya untuk Anda.';

  @override
  String get privacyKitBody =>
      'Tulis 24 kata ini di kertas, sesuai urutan, dan simpan di tempat yang aman. Kata-kata ini membuka kunci pustaka pribadi Anda jika Anda lupa kata sandi, bagi siapa pun yang memilikinya.';

  @override
  String get privacyKitDone => 'Kit pemulihan Anda berfungsi.';

  @override
  String get privacyKitOther => 'Ini bukan kit pemulihan Anda saat ini.';

  @override
  String get privacyKitTitle => 'Kit pemulihan Anda';

  @override
  String get privacyKitUnverified => 'Kit pemulihan belum diverifikasi';

  @override
  String privacyKitVerified(String date) {
    return 'Kit pemulihan diverifikasi pada $date';
  }

  @override
  String get privacyKitWritten => 'Saya sudah menuliskannya';

  @override
  String get privacyNotReady =>
      'Unggahan pribadi tetap nonaktif sampai Anda memiliki dua cara membuka kunci dan telah memverifikasi kit pemulihan.';

  @override
  String get privacyPasswordHelp =>
      'Masukkan kata sandi akun Anda: kata sandi ini menjadi salah satu cara membuka kunci pustaka pribadi Anda.';

  @override
  String get privacyPhrase => 'Frasa pemulihan';

  @override
  String get privacyPhraseHelp => '24 kata dari kit pemulihan Anda';

  @override
  String get privacyPhraseInvalid =>
      'Ini bukan frasa pemulihan. Periksa setiap kata.';

  @override
  String get privacyReady => 'Unggahan pribadi aktif.';

  @override
  String get privacyRecoveryKit => 'Kit pemulihan';

  @override
  String get privacySetUp => 'Siapkan';

  @override
  String get privacyShowWords => 'Tampilkan kata lagi';

  @override
  String get privacyTitle => 'Pustaka pribadi';

  @override
  String privacyUnknownWord(int number) {
    return 'Kata $number bukan kata kit pemulihan.';
  }

  @override
  String get privacyVerify => 'Verifikasi';

  @override
  String get privacyVerifyBody =>
      'Ketik kata-kata ini dari kit pemulihan Anda untuk menunjukkan bahwa Anda telah menyimpannya.';

  @override
  String get privacyWays => 'Cara membuka kunci';

  @override
  String privacyWord(int number) {
    return 'Kata $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Kata-kata ini tidak cocok dengan kit pemulihan Anda. Periksa apa yang Anda tulis.';

  @override
  String get privacyWrongPassword => 'Ini bukan kata sandi akun Anda.';

  @override
  String get problemAdminOnly =>
      'Hanya administrator yang dapat melakukan ini.';

  @override
  String get problemBusy => 'Server sedang sibuk atau dimulai ulang.';

  @override
  String get problemChanged => 'Ini sudah berubah sementara itu.';

  @override
  String get problemConfirm =>
      'Ini akan menyembunyikan atau menghapus lebih banyak item daripada yang dilakukan server tanpa konfirmasi';

  @override
  String get problemContribute =>
      'Anda tidak boleh menambahkan foto ke perpustakaan ini.';

  @override
  String get problemCopy => 'Salin detail';

  @override
  String get problemDetails => 'Detail';

  @override
  String get problemDiskLow =>
      'Disk server hampir penuh, jadi unggahan dijeda.';

  @override
  String get problemEmailTaken => 'Akun lain memakai email ini.';

  @override
  String get problemExists => 'Sudah ada.';

  @override
  String get problemFaceNotice =>
      'Server Anda meminta versi pemberitahuan wajah yang lebih baru daripada yang ditampilkan aplikasi ini.';

  @override
  String get problemGone => 'Sudah tidak ada di server.';

  @override
  String get problemHandleTaken => 'Akun lain memakai nama login ini.';

  @override
  String get problemInterrupted => 'Unggahan terputus.';

  @override
  String get problemInvalid => 'Ada nilai yang tidak valid';

  @override
  String get problemLastAdmin =>
      'Server memerlukan setidaknya satu administrator.';

  @override
  String get problemLinkInvalid =>
      'Tautan ini sudah kedaluwarsa atau sudah dipakai.';

  @override
  String get problemLoginFailed => 'Email, nama login, atau sandi salah.';

  @override
  String get problemMaintenanceKey =>
      'Pencadangan, pemeriksaan integritas, dan penghapusan permanen hanya dapat dijeda saat login, bukan dengan kunci API';

  @override
  String get problemNotAllowed => 'Akun Anda tidak boleh melakukan ini.';

  @override
  String get problemNotExternal =>
      'Hanya perpustakaan dari folder milik server sendiri yang dapat dipindai.';

  @override
  String get problemOidcClaim =>
      'Penyedia login Anda tidak menyebutkan siapa Anda dengan cara yang diterima server ini.';

  @override
  String get problemOidcDown => 'Penyedia login Anda tidak menjawab server.';

  @override
  String get problemOidcFailed => 'Penyedia login Anda menolak login.';

  @override
  String get problemOidcNotAllowed =>
      'Akun Anda tidak boleh login dengan cara ini.';

  @override
  String get problemOidcTaken =>
      'Login ini sudah ditautkan ke akun Photolib lain.';

  @override
  String get problemOidcUnknown =>
      'Server ini tidak lagi menawarkan cara login ini.';

  @override
  String get problemPasskeysOff =>
      'Kunci sandi baru berfungsi setelah server memiliki alamat publiknya.';

  @override
  String get problemPinned =>
      'Ini diatur di file konfigurasi dan tidak dapat diubah di sini.';

  @override
  String get problemPolicyOff => 'Ini dinonaktifkan di server ini.';

  @override
  String get problemQuota => 'Penyimpanan Anda di server penuh.';

  @override
  String get problemRestoreKey =>
      'Cadangan hanya dapat dipulihkan saat login, bukan dengan kunci API.';

  @override
  String get problemRootDiffers => 'Folder ini tidak berisi file pustaka ini';

  @override
  String get problemRootNotAllowed =>
      'Folder ini tidak berada di bawah external_roots dalam konfigurasi server';

  @override
  String get problemRootOverlaps =>
      'Folder ini berisi atau berada di dalam pustaka lain atau data milik server sendiri';

  @override
  String get problemScanning => 'Pustaka ini sedang dipindai';

  @override
  String get problemSecondFactor =>
      'Akun ini memerlukan faktor kedua, seperti kode autentikator atau kunci sandi, yang belum dapat diberikan versi Photolib ini.';

  @override
  String get problemSetupDone => 'Server ini sudah punya administrator.';

  @override
  String get problemSetupExpired => 'Ini terlalu lama.';

  @override
  String get problemSetupToken => 'Token penyiapan ini salah.';

  @override
  String get problemSignedOut => 'Anda sudah logout dari server.';

  @override
  String get problemStepUp =>
      'Perubahan ini memerlukan sandi Anda atau kode terlebih dahulu.';

  @override
  String get problemStorage => 'Server tidak dapat menjangkau penyimpanannya.';

  @override
  String get problemTooMany => 'Terlalu banyak percobaan dalam waktu singkat.';

  @override
  String get problemUnexpected => 'Terjadi masalah yang tidak terduga.';

  @override
  String get problemUnreachable => 'Server tidak menjawab.';

  @override
  String get problemUploadDamaged => 'File berubah atau rusak di perjalanan.';

  @override
  String get problemUploadExpired =>
      'Server tidak lagi menyimpan unggahan ini: unggahan yang belum selesai kedaluwarsa setelah sehari.';

  @override
  String get problemWebhookLimit =>
      'Akun Anda sudah memiliki webhook sebanyak yang diizinkan.';

  @override
  String get problemWebhooksOff => 'Webhook dinonaktifkan di server ini.';

  @override
  String get recoveryCode => 'Kode pemulihan';

  @override
  String get recoveryCodeAbout =>
      'Membuka penyimpanan Photolib di perangkat ini jika penyimpanan kunci kehilangan kuncinya';

  @override
  String get recoveryCodeEnter => 'Masukkan kode pemulihan';

  @override
  String get recoveryCreate => 'Buat kode pemulihan';

  @override
  String get recoveryLater => 'Nanti';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString perubahan hanya ada di perangkat ini. Kode pemulihan mengembalikannya jika penyimpanan kunci kehilangan kunci Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Tulis 24 kata ini dan simpan di tempat aman: kata-kata ini membuka penyimpanan Photolib di perangkat ini tanpa kuncinya di penyimpanan kunci. Kata-kata ini menggantikan kode sebelumnya.';

  @override
  String get recoveryUnlock => 'Buka kunci';

  @override
  String get recoveryWrong => 'Itu bukan kode pemulihan penyimpanan ini';

  @override
  String get renameFind => 'Cari';

  @override
  String get renamePattern => 'Nama baru';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Terlalu panjang: nama paling banyak 255 byte',
      'invalid': 'Bukan nama file yang valid',
      'duplicate': 'Diberikan juga ke file lain',
      'exists': 'File lain di folder ini memakai nama ini',
      'other': 'Tidak dapat diganti namanya',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Ganti dengan';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'File diganti namanya: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Tampilkan di Finder',
      'windows': 'Tampilkan di Explorer',
      'other': 'Tampilkan di folder',
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
      other: '$countString item',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Tanggal';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Telusuri pustaka Anda';

  @override
  String get searchFavourites => 'Favorit';

  @override
  String get searchFolder => 'Folder';

  @override
  String get searchHint => 'Nama file atau folder';

  @override
  String get searchMotionPhotos => 'Foto bergerak';

  @override
  String get searchNothing => 'Tidak ada yang cocok';

  @override
  String get searchPanoramas => 'Panorama';

  @override
  String get searchPhotos => 'Foto';

  @override
  String get searchScreenshots => 'Screenshot';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Video';

  @override
  String get securityAddPasskey => 'Tambahkan kunci sandi';

  @override
  String get securityCode => 'Kode';

  @override
  String get securityCodesHelp =>
      'Simpan kode ini di tempat yang aman. Setiap kode berlaku sekali sebagai pengganti faktor kedua Anda, dan hanya ditampilkan sekarang.';

  @override
  String securityCodesLeft(int count) {
    return 'Belum dipakai: $count';
  }

  @override
  String get securityNewCodes => 'Kode baru';

  @override
  String get securityPasskeyNotAdded =>
      'Tidak ada kunci sandi yang ditambahkan.';

  @override
  String get securityRecoveryCodes => 'Kode pemulihan';

  @override
  String get securityRemovePasskey => 'Hapus kunci sandi';

  @override
  String get securitySetUp => 'Siapkan';

  @override
  String get securityStepUpBody =>
      'Masukkan sandi Anda, kode dari aplikasi autentikator, atau kode pemulihan untuk mengubah faktor kedua Anda.';

  @override
  String get securityStepUpTitle => 'Konfirmasi bahwa ini Anda';

  @override
  String get securityTitle => 'Faktor kedua';

  @override
  String get securityTotp => 'Aplikasi autentikator';

  @override
  String get securityTotpHelp =>
      'Tambahkan kunci ini ke aplikasi autentikator Anda, lalu masukkan kode yang ditampilkannya.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'on': 'Aktif',
      'other': 'Nonaktif',
    });
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Nonaktifkan';

  @override
  String get securityWrongCode => 'Kode itu salah.';

  @override
  String get securityWrongProof => 'Sandi atau kode salah.';

  @override
  String get selectAll => 'Pilih semua';

  @override
  String get selectionClear => 'Hapus pilihan';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString dipilih',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Tampilkan yang dipilih';

  @override
  String get serverAccount => 'Email atau nama login';

  @override
  String get serverAdd => 'Tambahkan server';

  @override
  String get serverAddressInvalid =>
      'Masukkan alamat seperti photos.example.org';

  @override
  String get serverAddresses => 'Alamat';

  @override
  String get serverAddressesHelp =>
      'Satu per baris: server di jaringan Anda, di internet, atau melalui VPN. Aplikasi memakai yang tercepat menjawab. Atau tempel tautan pengaturan kata sandi yang dikirim kepada Anda.';

  @override
  String get serverCa => 'Sertifikat CA pribadi (PEM)';

  @override
  String get serverCaChoose => 'Pilih file sertifikat';

  @override
  String serverCertificateBody(String host) {
    return '$host menunjukkan sertifikat yang tidak dipercaya perangkat ini. Percayai hanya jika sidik jari SHA-256 ini milik server Anda:';
  }

  @override
  String get serverCertificateTitle => 'Percayai sertifikat ini?';

  @override
  String get serverConfirm => 'Konfirmasi';

  @override
  String get serverConnect => 'Hubungkan';

  @override
  String get serverCreateAdmin => 'Buat administrator';

  @override
  String get serverEnded => 'Server mengakhiri sesi ini. Login lagi.';

  @override
  String get serverHandleHelp =>
      'Huruf kecil, angka, titik, tanda hubung, dan garis bawah; tidak pernah berubah.';

  @override
  String get serverHeaders => 'Header kustom';

  @override
  String get serverHeadersHelp =>
      'Satu per baris, sebagai Name: value; hanya dikirim lewat HTTPS';

  @override
  String get serverHeadersInvalid => 'Tulis setiap header sebagai Name: value';

  @override
  String get serverIdentity => 'Sertifikat klien (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Pilih sertifikat klien';

  @override
  String get serverIdentityInvalid =>
      'Ini bukan sertifikat PKCS#12, atau kata sandinya salah.';

  @override
  String get serverIdentityPassword => 'Kata sandi sertifikat klien';

  @override
  String get serverLoading => 'Membaca server yang disimpan di perangkat ini';

  @override
  String get serverNearby => 'Server di jaringan ini';

  @override
  String get serverNeedsHttps =>
      'Server ini memerlukan alamat HTTPS: di luar jaringan lokal Anda, Photolib tidak masuk melalui HTTP biasa.';

  @override
  String get serverNoSignIn =>
      'Server ini tidak menawarkan cara login yang didukung versi Photolib ini.';

  @override
  String get serverOffline => 'Server tidak menjawab. Anda tetap login.';

  @override
  String get serverPasskeyFailed =>
      'Tidak ada kunci sandi yang digunakan. Coba lagi, atau gunakan kode.';

  @override
  String get serverPasskeyRequired =>
      'Server ini memerlukan kunci sandi, yang belum dapat dipakai versi Photolib ini.';

  @override
  String get serverPassword => 'Sandi';

  @override
  String get serverPasswordAgain => 'Ulangi sandi';

  @override
  String get serverPasswordSetupInvalid =>
      'Token pengaturan kata sandi ini salah, sudah dipakai, atau kedaluwarsa. Minta yang baru.';

  @override
  String get serverPasswordSetupToken => 'Token pengaturan kata sandi';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Dari administrator Anda, atau dicetak oleh photolibd admin password-setup di server.';

  @override
  String get serverPasswordsDiffer => 'Sandi tidak sama.';

  @override
  String get serverPrivateLibrariesBody =>
      'Kata sandi baru tidak membukanya. Buka lagi dengan kit pemulihan, kunci sandi, atau perangkat yang masih masuk.';

  @override
  String get serverPrivateLibrariesGo => 'Atur kata sandi';

  @override
  String get serverPrivateLibrariesTitle =>
      'Pustaka pribadi Anda tetap terkunci';

  @override
  String get serverProxy => 'Proxy HTTP, sebagai host:port';

  @override
  String get serverProxyInvalid => 'Masukkan proxy sebagai host:port';

  @override
  String get serverRecoveryCode => 'Kode pemulihan';

  @override
  String get serverRemove => 'Hapus server ini';

  @override
  String get serverRequired => 'Wajib diisi';

  @override
  String get serverSecondFactor =>
      'Faktor kedua akun ini adalah kunci sandi, yang belum dapat dipakai versi Photolib ini.';

  @override
  String get serverSecondFactorCode =>
      'Akun ini juga memerlukan kode dari aplikasi autentikator Anda, atau kode pemulihan.';

  @override
  String get serverSecondFactorTitle => 'Konfirmasi bahwa ini Anda';

  @override
  String get serverSecondFactorWrong =>
      'Itu tidak berhasil. Setelah lima kali mencoba, masuk lagi.';

  @override
  String get serverSetPassword => 'Atur kata sandi';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Untuk $handle di $server';
  }

  @override
  String get serverSetPasswordOpen => 'Atur kata sandi';

  @override
  String get serverSetPasswordTitle => 'Atur kata sandi Anda';

  @override
  String get serverSetUp => 'Siapkan server baru';

  @override
  String get serverSetupLinkElsewhere =>
      'Untuk memakai tautan ini, logout dulu dari server ini, atau hapus server ini jika tautannya untuk server lain.';

  @override
  String get serverSetupTitle => 'Siapkan server';

  @override
  String get serverSetupToken => 'Token penyiapan';

  @override
  String get serverSetupTokenHelp =>
      'photolibd menuliskannya di log selama server belum punya administrator; setiap kali dimulai, ia menuliskan yang baru.';

  @override
  String get serverSignIn => 'Login';

  @override
  String get serverSignOut => 'Logout';

  @override
  String serverSignedInAs(String account) {
    return 'Login sebagai $account';
  }

  @override
  String get serverSignedOut => 'Sudah logout';

  @override
  String get serverSwitch => 'Ganti akun';

  @override
  String get serverTotpCode => 'Kode dari aplikasi autentikator';

  @override
  String get serverTrust => 'Percayai';

  @override
  String get serverUnreadable =>
      'Server yang disimpan di perangkat ini tidak dapat dibaca';

  @override
  String get serverUsePasskey => 'Gunakan kunci sandi';

  @override
  String get serverUseRecoveryCode => 'Gunakan kode pemulihan';

  @override
  String get settingsBackground => 'Di belakang gambar transparan';

  @override
  String get settingsDefaultTab => 'Folder dan album terbuka di';

  @override
  String get settingsFolders => 'Folder';

  @override
  String get settingsIndexing => 'Pengindeksan di perangkat ini';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLibrary => 'Pustaka';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsStart => 'Layar awal';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsTitle => 'Setelan';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps':
          'Ketuk tepi kiri atau kanan untuk item sebelumnya atau berikutnya',
      'oneFingerZoom': 'Ketuk dua kali dan seret untuk zoom dengan satu jari',
      'swipes': 'Geser ke atas atau bawah di sisi kiri video untuk kecerahan, di sisi kanan untuk volume',
      'maxBrightness': 'Kecerahan penuh saat melihat',
      'autoRotate': 'Putar sesuai orientasi setiap foto atau video',
      'mixAudio': 'Putar video bersama audio lain alih-alih menjedanya',
      'autoplay': 'Putar video saat dibuka',
      'loop': 'Ulangi video',
      'autoNext': 'Lanjut ke item berikutnya saat video selesai',
      'resume': 'Lanjutkan video dari posisi terakhir',
      'other': 'Putar gambar animasi di kisi',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'Tombol di bilah penampil';

  @override
  String get settingsViewing => 'Tampilan';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString foto dan video yang dibagikan menunggu hingga Photolib diizinkan menambahkannya ke perpustakaan foto Anda. Item yang tidak disimpan dihapus setelah 7 hari.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Terlalu besar untuk dibagikan sekaligus: pilih lebih sedikit item';

  @override
  String shareTooMany(int count) {
    return 'Terlalu banyak untuk dibagikan sekaligus: pilih maksimal $count';
  }

  @override
  String get shortcutsTitle => 'Pintasan keyboard';

  @override
  String get slideshow => 'Tayangan slide';

  @override
  String get slideshowLoop => 'Ulangi';

  @override
  String get slideshowOptions => 'Opsi tayangan slide';

  @override
  String get slideshowSeconds => 'Detik per item';

  @override
  String get slideshowShuffle => 'Acak';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Turun',
      'other': 'Naik',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Perangkat ini';

  @override
  String sourceHide(String name) {
    return 'Sembunyikan $name';
  }

  @override
  String get sourceHideOthers => 'Sembunyikan yang lain di sini';

  @override
  String get sourceLost => 'Tidak ada akses';

  @override
  String get sourcePartly => 'Ditampilkan sebagian';

  @override
  String sourceShow(String name) {
    return 'Tampilkan $name';
  }

  @override
  String get sourceShowEverything => 'Tampilkan semua di sini';

  @override
  String get sourceShowOnly => 'Tampilkan hanya ini';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Linimasa',
      'folders': 'Folder dan album',
      'favourites': 'Favorit',
      'other': 'Linimasa',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Simpan seseorang offline';

  @override
  String get storageBudget => 'Batas penyimpanan';

  @override
  String get storageClear => 'Hapus salinan offline';

  @override
  String get storageClearAction => 'Hapus';

  @override
  String storageClearBody(String size) {
    return 'Ini menghapus $size yang disimpan di perangkat ini dan berhenti menyimpan album, pencarian, dan foto secara offline. Pustaka Anda di server tidak disentuh.';
  }

  @override
  String get storageKeepLibrary => 'Simpan seluruh pustaka';

  @override
  String get storageKeepOriginals => 'Simpan juga file asli';

  @override
  String get storageNoPeople => 'Belum ada orang yang diberi nama.';

  @override
  String get storageNoPins =>
      'Tidak ada yang disematkan. Sematkan album, pencarian, atau foto untuk menyimpannya offline.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Pencarian',
      'person': 'Orang',
      'library': 'Seluruh pustaka',
      'asset': 'Foto',
      'other': 'Disematkan',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Melebihi batas: butuh $size lagi';
  }

  @override
  String get storagePinNothing =>
      'Tidak ada yang diunduh: fotonya sudah ada di perangkat ini';

  @override
  String get storagePinPaused =>
      'Menunggu: preset ini tidak menyimpan apa pun offline';

  @override
  String get storagePinPlanning => 'Mencari apa yang disimpan…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Mengunduh: $haveString dari $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Tersedia offline ($size)';
  }

  @override
  String get storagePinWaiting => 'Akan diunduh saat online';

  @override
  String get storagePins => 'Disimpan offline';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Katalog saja',
      'spaceSaver': 'Hemat ruang',
      'travel': 'Album terpilih offline',
      'everything': 'Semuanya',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly':
          'Tidak menyimpan apa pun; foto dimuat dari server Anda saat dibuka.',
      'spaceSaver':
          'Menyimpan pratinjau seluruh pustaka, terbaru dulu, sesuai batas.',
      'travel':
          'Hanya menyimpan yang Anda sematkan: album, pencarian, dan foto.',
      'everything':
          'Menyimpan file asli seluruh pustaka, terbaru dulu, sesuai batas.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Yang disimpan perangkat ini';

  @override
  String get storageSubtitle => 'Salinan offline dan batas penyimpanan';

  @override
  String get storageTitle => 'Penyimpanan';

  @override
  String storageUsed(String used, String budget) {
    return '$used dari $budget terpakai';
  }

  @override
  String get storageWebNote =>
      'Peramban hanya menyimpan pratinjau dan menghapusnya saat Anda keluar.';

  @override
  String get storeNoKeyring =>
      'Photolib menyimpan kunci penyimpanan lokalnya di keyring sistem, yang tidak menjawab. Pasang dan buka kunci gnome-keyring, KWallet, atau KeePassXC dengan Secret Service aktif, lalu coba lagi.';

  @override
  String get storeNoKeystore =>
      'Photolib tidak dapat menjangkau penyimpanan kunci perangkat ini, yang menyimpan kunci penyimpanan lokalnya.';

  @override
  String get storeRebuilt =>
      'Penyimpanan kunci perangkat ini tidak lagi memiliki kunci penyimpanan lokal Photolib, jadi penyimpanan dibangun ulang. Setelannya dan apa yang hanya ada di perangkat ini hilang; pustaka disinkronkan lagi dan gambar mini kembali.';

  @override
  String get storeRecoveryNeeded =>
      'Penyimpanan kunci perangkat ini tidak lagi memiliki kunci penyimpanan lokal Photolib. Masukkan kode pemulihannya, atau setel ulang penyimpanan dan kehilangan apa yang hanya ada di perangkat ini.';

  @override
  String get storeReset => 'Setel ulang penyimpanan';

  @override
  String get storeResetBody =>
      'Apa yang hanya ada di perangkat ini akan hilang; pustaka disinkronkan lagi dan gambar mini kembali.';

  @override
  String get storeUnavailable =>
      'Penyimpanan di perangkat ini tidak tersedia: setelan dan koleksi tidak disimpan';

  @override
  String get tabCollections => 'Koleksi';

  @override
  String get tabLibrary => 'Pustaka';

  @override
  String get tabSearch => 'Telusuri';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeSystem => 'Default sistem';

  @override
  String get timelineBenchmark => 'Tolok ukur linimasa';

  @override
  String get timelineBenchmarkCopy => 'Salin hasil';

  @override
  String get timelineCannotPlay => 'Tidak dapat diputar di browser ini';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position dari $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position dari $count, tanpa pratinjau';
  }

  @override
  String get timelineExcluded => 'Di folder yang dikecualikan';

  @override
  String get timelineNoHeicLinux =>
      'Photolib tidak dapat menampilkan foto HEIC di komputer ini. Hubungkan server Photolib untuk melihat salinannya, atau buka di Mac.';

  @override
  String get timelineNoHeicWindows =>
      'Photolib tidak dapat menampilkan foto HEIC di PC ini. Hubungkan server Photolib untuk melihat salinannya, atau buka di Mac.';

  @override
  String get timelineScrubber => 'Gulir menurut tanggal';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Tanggal tidak diketahui';

  @override
  String timelineWeek(String date) {
    return 'Minggu mulai $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Tambahkan $action ke bilah';
  }

  @override
  String toolbarDown(String action) {
    return 'Pindahkan $action ke bawah';
  }

  @override
  String get toolbarInBar => 'Di bilah';

  @override
  String get toolbarInMenu => 'Di menu ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Hapus $action dari bilah';
  }

  @override
  String get toolbarReset => 'Setel ulang ke default';

  @override
  String toolbarUp(String action) {
    return 'Pindahkan $action ke atas';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Pindahkan ke sini',
      'other': 'Salin ke sini',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Sudah ada file atau folder dengan nama ini',
      'changed': 'Salinan tidak cocok dengan aslinya dan dihapus',
      'cancelled': 'Dibatalkan',
      'invalid': 'Bukan nama folder yang valid',
      'other': 'Gagal',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Terbaru';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Hapus $countString item selamanya? Tindakan ini tidak dapat diurungkan.',
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
      other: '$daysString hari lagi',
      zero: 'Dihapus selamanya hari ini',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Sampah kosong';

  @override
  String get trashEmptyAll => 'Kosongkan sampah';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString item dipindahkan ke sampah',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib menghapus selamanya isi sampahnya setelah $days hari; setiap item menunjukkan sisa waktunya.';
  }

  @override
  String get trashTitle => 'Sampah';

  @override
  String get undo => 'Urungkan';

  @override
  String get uploadAction => 'Unggah foto dan video';

  @override
  String get uploadClear => 'Hapus';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString dari $totalString terunggah';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Gagal: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString item diarsipkan',
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
      other: '$countString item disembunyikan',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Hitam',
      'white': 'Putih',
      'other': 'Papan catur',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay =>
      'Video ini tidak dapat diputar di perangkat ini';

  @override
  String get viewerCaptions => 'Teks';

  @override
  String get viewerCompass => 'Kunci kompas';

  @override
  String get viewerCopy => 'Salin';

  @override
  String get viewerCopyText => 'Salin teks';

  @override
  String get viewerCustomize => 'Sesuaikan bilah alat…';

  @override
  String get viewerDial =>
      'Arah. Klik untuk menghadap depan. Seret untuk melihat sekeliling, gulir atau cubit untuk zoom, klik dua kali untuk mengatur ulang';

  @override
  String get viewerFilmstrip => 'Strip film';

  @override
  String get viewerFirst => 'Pertama';

  @override
  String get viewerFisheye => 'Mata ikan';

  @override
  String get viewerGyroscope => 'Gerakkan untuk melihat sekeliling';

  @override
  String get viewerHdr => 'Tampilkan dalam HDR';

  @override
  String get viewerInfo => 'Info';

  @override
  String get viewerInfoLoading => 'Memuat info item ini';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString dari $countString';
  }

  @override
  String get viewerLast => 'Terakhir';

  @override
  String get viewerLenses => 'Pilih lensa';

  @override
  String get viewerMap => 'Peta';

  @override
  String get viewerMotion => 'Putar gerakan';

  @override
  String get viewerMotionDenied =>
      'Browser ini tidak mengizinkan akses ke sensor gerak';

  @override
  String get viewerMotionMissing =>
      'Perangkat ini tidak memiliki giroskop untuk melihat sekeliling';

  @override
  String get viewerMute => 'Bisukan';

  @override
  String get viewerNext => 'Berikutnya';

  @override
  String get viewerNextFrame => 'Bingkai berikutnya';

  @override
  String get viewerPause => 'Jeda';

  @override
  String get viewerPlanet => 'Planet kecil';

  @override
  String get viewerPlay => 'Putar';

  @override
  String get viewerPrevious => 'Sebelumnya';

  @override
  String get viewerPreviousFrame => 'Bingkai sebelumnya';

  @override
  String get viewerRotate => 'Putar';

  @override
  String get viewerSdr => 'Tampilkan dalam SDR';

  @override
  String get viewerSeek => 'Posisi';

  @override
  String get viewerSetAs => 'Setel sebagai';

  @override
  String get viewerShare => 'Bagikan';

  @override
  String get viewerSpeed => 'Kecepatan pemutaran';

  @override
  String get viewerSphere =>
      'Tampilan 360°. Seret untuk melihat sekeliling, cubit untuk zoom';

  @override
  String get viewerText => 'Teks di foto ini';

  @override
  String get viewerTextCopied => 'Teks disalin';

  @override
  String get viewerTextNone => 'Tidak ada teks di foto ini';

  @override
  String get viewerTextUnread => 'Teks foto ini belum dibaca';

  @override
  String get viewerUnmute => 'Bunyikan';

  @override
  String get viewerZoomIn => 'Perbesar';

  @override
  String get viewerZoomOut => 'Perkecil';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'Kartu SD',
      'other': 'Internal',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Perbesar';

  @override
  String get zoomOut => 'Perkecil';
}
