// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get actionAddToAlbum => 'Thêm vào album';

  @override
  String get actionArchive => 'Lưu trữ';

  @override
  String get actionCopyTo => 'Sao chép đến…';

  @override
  String get actionDeleteForever => 'Xóa vĩnh viễn';

  @override
  String get actionFavourite => 'Yêu thích';

  @override
  String get actionHide => 'Ẩn';

  @override
  String get actionMoveTo => 'Di chuyển đến…';

  @override
  String get actionRename => 'Đổi tên';

  @override
  String get actionRestore => 'Khôi phục';

  @override
  String get actionShare => 'Chia sẻ';

  @override
  String get actionTrash => 'Chuyển vào thùng rác';

  @override
  String get actionUnarchive => 'Bỏ lưu trữ';

  @override
  String get actionUndo => 'Hoàn tác';

  @override
  String get actionUnfavourite => 'Bỏ yêu thích';

  @override
  String get actionUnhide => 'Bỏ ẩn';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': 'Đang hoạt động',
      'disabled': 'Đã vô hiệu hóa',
      'invited': 'Đã mời',
      'deleted': 'Đã xóa',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'Tài khoản';

  @override
  String get adminAddAccount => 'Thêm tài khoản';

  @override
  String get adminAddExternalLibrary => 'Thêm thư viện bên ngoài';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts lần thử',
      zero: 'chưa chạy lần nào',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => 'Nhật ký kiểm tra';

  @override
  String get adminBackUpNow => 'Sao lưu ngay';

  @override
  String get adminBackupQueued =>
      'Bản sao lưu đã vào hàng đợi; tiếp theo là một lần diễn tập khôi phục';

  @override
  String get adminBackups => 'Bản sao lưu cơ sở dữ liệu';

  @override
  String get adminCancelJob => 'Hủy tác vụ';

  @override
  String get adminCapabilities => 'Tính năng';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': 'Thư viện được quản lý',
      'uploads': 'Tải lên từ thiết bị, web và CLI',
      'folder_browser': 'Trình duyệt thư mục',
      'device_folders': 'Thư mục thiết bị trong ứng dụng đã kết nối',
      'sharing': 'Chia sẻ và liên kết công khai',
      'edits': 'Chỉnh sửa',
      'deletes': 'Xóa',
      'xmp_writes': 'Ghi tệp XMP',
      'face_recognition': 'Nhận dạng khuôn mặt',
      'ml_search': 'Tìm kiếm thông minh',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': 'OK',
      'warn': 'Cảnh báo',
      'fail': 'Không đạt',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => 'Đã sao chép';

  @override
  String get adminCopyBundle => 'Sao chép thông tin chẩn đoán để báo cáo lỗi';

  @override
  String get adminCopyLink => 'Sao chép liên kết';

  @override
  String get adminDelete => 'Xóa';

  @override
  String get adminDeviceBackups => 'Bản sao lưu thiết bị';

  @override
  String get adminDevices => 'Thiết bị của bạn';

  @override
  String get adminDisable => 'Vô hiệu hóa';

  @override
  String adminDrillFailed(String detail) {
    return 'Lần diễn tập khôi phục gần nhất đã thất bại: $detail';
  }

  @override
  String get adminEdit => 'Chỉnh sửa';

  @override
  String get adminEmail => 'Email';

  @override
  String get adminEnable => 'Kích hoạt';

  @override
  String get adminErrorSignIn => 'Đăng nhập với tư cách quản trị viên';

  @override
  String get adminFacesDefault =>
      'Tính năng nhận dạng khuôn mặt được bật sẵn cho tài khoản mới';

  @override
  String get adminFiles => 'Tệp theo loại';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': 'Bị hỏng',
      'missing': 'Bị thiếu',
      'size': 'Sai kích thước',
      'hash': 'Bị thay thế',
      'orphan': 'Tệp lạc',
      'other': 'Không rõ',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return 'Còn trống $size';
  }

  @override
  String get adminFreeDisk =>
      'Tạm dừng tải lên khi dung lượng trống của ổ đĩa dưới mức phần trăm này, từ 0 đến 50';

  @override
  String get adminFreeDiskGb =>
      'hoặc dưới dung lượng trống này tính bằng GB, nếu nhỏ hơn, từ 0 đến 100000';

  @override
  String get adminHandle => 'Tên đăng nhập';

  @override
  String get adminIntegrity => 'Tính toàn vẹn';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString mục',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': 'Đang chờ',
      'running': 'Đang chạy',
      'done': 'Đã xong',
      'dead': 'Thất bại',
      'cancelled': 'Đã hủy',
      'other': 'Tất cả',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'Loại tác vụ, chẳng hạn như render';

  @override
  String get adminJobs => 'Tác vụ';

  @override
  String adminLastSeen(String time) {
    return 'Hoạt động lần cuối $time';
  }

  @override
  String get adminLibraries => 'Thư viện';

  @override
  String get adminLibraryOwner => 'Chủ sở hữu';

  @override
  String get adminLibraryRoot =>
      'Thư mục trên máy chủ, chẳng hạn như /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'Trực tuyến',
      'offline': 'Ngoại tuyến',
      'scanning': 'Đang quét',
      'error': 'Lỗi',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'Nhật ký máy chủ';

  @override
  String get adminName => 'Tên';

  @override
  String get adminNothing => 'Chưa có gì ở đây';

  @override
  String get adminOutOfRange => 'Ngoài phạm vi cho phép';

  @override
  String get adminOverview => 'Tổng quan';

  @override
  String get adminPair => 'Ghép nối thiết bị';

  @override
  String get adminPairBody =>
      'Quét mã này hoặc gửi liên kết, rồi dán vào Thêm máy chủ trong Photolib trên thiết bị mới: liên kết mang theo mọi địa chỉ của máy chủ này và chứng chỉ của nó, nên không ai phải gõ.';

  @override
  String get adminPasswordSetup => 'Liên kết đặt mật khẩu';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'Gửi liên kết này cho $name qua bất kỳ cách nào, hoặc cho họ quét mã. Liên kết đặt mật khẩu một lần, đến $date.';
  }

  @override
  String get adminPause => 'Tạm dừng một loại tác vụ';

  @override
  String adminPauseMinutes(int max) {
    return 'Số phút, từ 1 đến $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type đang tạm dừng đến $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $countString mục cần sao lưu',
      zero: 'Không còn gì để sao lưu',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'Chính sách';

  @override
  String get adminPolicyReset => 'Dùng giá trị của cấp cao hơn';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'Bật theo mặc định',
      'server': 'Đặt cho máy chủ',
      'user': 'Đặt cho tài khoản này',
      'library': 'Đặt cho thư viện này',
      'config': 'Đặt trong cấu hình',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'Áp dụng cấu hình sẵn';

  @override
  String get adminPresetBody =>
      'Cấu hình sẵn đặt mọi tính năng cho máy chủ và xóa những gì tài khoản và thư viện đã đặt. Mọi thứ vẫn có thể chỉnh sửa.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Xem kho lưu trữ',
      'family_backup': 'Sao lưu gia đình',
      'personal': 'Cá nhân',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'Các thư viện bên ngoài chỉ đọc là nguồn dữ liệu chuẩn duy nhất: không tải lên, thư viện được quản lý, thư mục thiết bị, chỉnh sửa, xóa hay ghi XMP',
      'family_backup': 'Bật tất cả trừ ghi XMP',
      'personal': 'Bật tất cả trừ chia sẻ và liên kết công khai',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'Mã QR của liên kết';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã đưa $countString tác vụ vào hàng đợi',
      zero: 'Không có gì để làm',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota =>
      'Hạn mức bộ nhớ tính bằng GB; để trống nếu không giới hạn';

  @override
  String get adminRemote => 'Truy cập từ xa';

  @override
  String get adminRemoteBody =>
      'Truy cập máy chủ từ mọi nơi mà không cần mở cổng trên bộ định tuyến. Chọn một cách; mỗi cách cho nó một địa chỉ HTTPS để thêm vào ứng dụng. Sau đó kiểm tra từ bên ngoài.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared tự kết nối ra Cloudflare, nơi phục vụ tên miền của bạn qua HTTPS. Gói miễn phí giới hạn mỗi yêu cầu 100 MB, mức mà sao lưu không bao giờ chạm tới: mỗi lần chỉ gửi 8 MiB.';

  @override
  String get adminRemoteNoAddress =>
      'Hãy thêm địa chỉ https:// của máy chủ vào ứng dụng này để kiểm tra từ bên ngoài.';

  @override
  String get adminRemoteReachable => 'Truy cập được từ bên ngoài.';

  @override
  String get adminRemoteTailscale =>
      'Cài Tailscale trên máy của máy chủ và trên mọi thiết bị, trong cùng tailnet hoặc Headscale của bạn, rồi chạy lệnh này trên máy của máy chủ và đặt public_url thành địa chỉ nó in ra.';

  @override
  String get adminRemoteTest => 'Kiểm tra từ bên ngoài';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host sẽ mở $url từ các máy chủ của nó trên khắp thế giới, và vì thế biết địa chỉ này. Tiếp tục?';
  }

  @override
  String get adminRemoteUnreachable =>
      'Không truy cập được từ bên ngoài: kiểm tra cách bạn đã chọn rồi thử lại.';

  @override
  String get adminRemoteWireguard =>
      'Cần một cổng UDP mở ở phía máy chủ hoặc ở một nút trung gian. Đây là cấu hình cho một thiết bị; tạo khóa bằng wg genkey.';

  @override
  String get adminRepair =>
      'Khôi phục từ bản sao lưu hoặc từ thiết bị vẫn còn tệp này';

  @override
  String get adminRepairOrphan =>
      'Không ảnh nào trỏ tới tệp này: hãy kiểm tra, rồi xóa hoặc giữ lại';

  @override
  String get adminReprocess => 'Xử lý lại';

  @override
  String get adminReprocessFaces => 'Phát hiện lại khuôn mặt';

  @override
  String get adminReprocessFolder =>
      'Thư mục, chẳng hạn như 2024/05; để trống để xử lý toàn bộ thư viện';

  @override
  String get adminReprocessMetadata => 'Đọc lại siêu dữ liệu';

  @override
  String get adminReprocessRenditions =>
      'Tạo lại hình thu nhỏ và bản xem trước';

  @override
  String get adminRestore => 'Khôi phục';

  @override
  String adminRestoreFailed(String name, String detail) {
    return 'Khôi phục $name thất bại: $detail';
  }

  @override
  String get adminRestoreUnverified =>
      'Chưa có lần diễn tập khôi phục nào thành công';

  @override
  String adminRestoreVerified(String when) {
    return 'Lần khôi phục đã xác minh gần nhất: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd dừng lại, rồi thay toàn bộ cơ sở dữ liệu bằng $name khi khởi động lại. Những gì thay đổi kể từ bản sao lưu đó sẽ mất, và mọi thiết bị đồng bộ lại từ đầu.';
  }

  @override
  String get adminRestoring => 'photolibd đang dừng để khôi phục bản sao lưu';

  @override
  String get adminResume => 'Tiếp tục';

  @override
  String get adminRetry => 'Thử lại';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Quản trị viên',
      'user': 'Người dùng',
      'viewer': 'Người xem',
      'other': 'Không xác định',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => 'Đã lưu';

  @override
  String get adminScan => 'Quét ngay';

  @override
  String get adminScrubDays =>
      'Số ngày để kiểm tra hết mọi bản gốc, từ 1 đến 3650';

  @override
  String get adminScrubNever => 'Đang chạy lần kiểm tra đầy đủ đầu tiên';

  @override
  String adminScrubbed(String time) {
    return 'Lần kiểm tra đầy đủ gần nhất $time';
  }

  @override
  String get adminSecondAdmin =>
      'Hãy đặt thêm một người làm quản trị viên, để người khác có thể vận hành và khôi phục máy chủ khi bạn không thể.';

  @override
  String adminSilent(String time) {
    return 'Im lặng từ $time';
  }

  @override
  String get adminSilentHours =>
      'Số giờ không có báo cáo trước khi bản sao lưu của thiết bị bị coi là im lặng, từ 1 đến 8760';

  @override
  String get adminStores => 'Bộ nhớ';

  @override
  String get adminThisDevice => 'Thiết bị này';

  @override
  String get adminTitle => 'Quản trị máy chủ';

  @override
  String get adminTrashDays => 'Số ngày trong thùng rác, từ 1 đến 3650';

  @override
  String get adminTwoFactor =>
      'Mọi tài khoản phải thiết lập yếu tố xác thực thứ hai';

  @override
  String get adminUsage => 'Mức sử dụng theo tài khoản';

  @override
  String get albumCover => 'Dùng làm ảnh bìa';

  @override
  String get albumEmpty => 'Album này trống';

  @override
  String get albumHideMemories => 'Ẩn khỏi kỷ niệm';

  @override
  String get albumHideTimeline => 'Ẩn khỏi dòng thời gian';

  @override
  String get albumNew => 'Album mới';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'Mọi ngày';

  @override
  String get backupCap => 'Mục lớn nhất';

  @override
  String get backupCharging => 'Chỉ khi đang sạc';

  @override
  String backupCompleted(String time) {
    return 'Lần sao lưu đầy đủ gần nhất: $time';
  }

  @override
  String backupContact(String time) {
    return 'Lần liên lạc gần nhất với máy chủ: $time';
  }

  @override
  String get backupEnabled => 'Sao lưu thiết bị này';

  @override
  String get backupFolderNo => 'Không phải thư mục này';

  @override
  String get backupFolderYes => 'Sao lưu';

  @override
  String backupHours(int count) {
    return '$count giờ';
  }

  @override
  String get backupMetered =>
      'Trên mạng đo lượng dữ liệu, như dữ liệu di động hoặc điểm phát sóng';

  @override
  String get backupNever => 'Chưa có lần sao lưu đầy đủ nào';

  @override
  String backupNewFolder(String name) {
    return 'Thư mục mới $name: sao lưu?';
  }

  @override
  String get backupNoLimit => 'Không giới hạn';

  @override
  String get backupNothing => 'Không có mục nào đang chờ';

  @override
  String get backupNow => 'Sao lưu ngay';

  @override
  String backupOverdue(int hours, String items) {
    return 'Không có lần sao lưu đầy đủ nào trong $hours giờ. Đang chờ: $items';
  }

  @override
  String get backupOverdueTitle => 'Sao lưu chưa hoàn tất';

  @override
  String backupPending(String items) {
    return 'Đang chờ: $items';
  }

  @override
  String backupRetry(String time) {
    return 'Thử lại: $time';
  }

  @override
  String get backupRoaming => 'Sao lưu khi chuyển vùng';

  @override
  String get backupSignIn => 'Đăng nhập vào máy chủ để sao lưu thiết bị này';

  @override
  String get backupSignedOut =>
      'Sao lưu đã dừng: máy chủ đã đăng xuất thiết bị này. Hãy đăng nhập lại trong Cài đặt.';

  @override
  String get backupSince => 'Chụp từ ngày';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'Sao lưu đang chờ máy chủ có thể kết nối',
      'charging': 'Sao lưu đang chờ thiết bị được sạc',
      'battery_low': 'Sao lưu đang chờ: pin yếu',
      'roaming': 'Sao lưu chờ trong khi chuyển vùng',
      'quota': 'Sao lưu đã dừng: dung lượng của bạn trên máy chủ đã đầy',
      'second_factor':
          'Sao lưu đã dừng: máy chủ yêu cầu yếu tố thứ hai cho tài khoản này',
      'other': 'Sao lưu đã dừng: máy chủ trả lời $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'Sao lưu';

  @override
  String get backupWaiting => 'Chưa sao lưu';

  @override
  String get backupWarnAfter => 'Cảnh báo khi chưa hoàn tất sau';

  @override
  String get backupWhat => 'Nội dung sao lưu';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': 'Trong thư mục bạn không chọn',
      'folder_new': 'Trong thư mục mới: hãy chọn có sao lưu hay không',
      'type_excluded': 'Loại mục bạn không chọn',
      'before_date': 'Chụp trước ngày bạn chọn',
      'selected': 'Đang chờ đến lượt',
      'server_restored': 'Máy chủ đã mất mục này khi khôi phục: đang gửi lại',
      'working': 'Đang sao lưu',
      'waiting_for_icloud': 'Đang chờ iCloud tải xuống',
      'metered': 'Đang chờ mạng không đo lượng dữ liệu',
      'metered_cap': 'Quá lớn cho mạng đo lượng dữ liệu',
      'unreadable': 'Thiết bị này không đọc được',
      'changed': 'Đã thay đổi trong khi gửi',
      'quota': 'Dung lượng của bạn trên máy chủ đã đầy',
      'other': 'Máy chủ đã từ chối: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld =>
      'Máy chủ không còn hoạt động với phiên bản Photolib này.';

  @override
  String get checkAppTooOldNext => 'Hãy cập nhật Photolib.';

  @override
  String get checkChanged =>
      'Chứng chỉ của máy chủ không phải chứng chỉ bạn đã tin cậy.';

  @override
  String get checkChangedNext =>
      'Nếu quản trị viên đã thay nó, hãy tin cậy chứng chỉ mới. Nếu không, có thể ai đó đang nghe lén: đừng tiếp tục.';

  @override
  String get checkClock =>
      'Đồng hồ của thiết bị này và của máy chủ lệch nhau hơn năm phút.';

  @override
  String get checkClockNext => 'Hãy để thiết bị tự đặt ngày giờ.';

  @override
  String get checkDnsFailed => 'Tên máy chủ không dẫn tới địa chỉ nào.';

  @override
  String get checkDnsFailedNext =>
      'Kiểm tra địa chỉ, hoặc kết nối vào mạng của máy chủ.';

  @override
  String checkExpired(String date) {
    return 'Chứng chỉ của máy chủ đã hết hạn vào $date.';
  }

  @override
  String get checkFailed => 'Không đạt';

  @override
  String get checkMetered =>
      'Bạn đang dùng mạng tính phí theo dung lượng, như dữ liệu di động.';

  @override
  String get checkMeteredNext => 'Hãy kết nối Wi-Fi trước khi sao lưu lớn.';

  @override
  String get checkNotPhotolib =>
      'Thứ đang trả lời không phải Photolib, chẳng hạn trang lỗi của proxy hoặc trang đăng nhập Wi-Fi.';

  @override
  String get checkNotPhotolibNext =>
      'Đăng nhập Wi-Fi trong trình duyệt, hoặc nhờ quản trị viên kiểm tra proxy.';

  @override
  String get checkOtherServer =>
      'Một máy chủ Photolib khác đang trả lời ở địa chỉ này.';

  @override
  String get checkPassed => 'Đạt';

  @override
  String get checkRefused => 'Không có gì trả lời ở địa chỉ này.';

  @override
  String get checkRefusedNext =>
      'Kiểm tra máy chủ đang chạy và bạn đang ở trong mạng hoặc VPN của nó.';

  @override
  String get checkRun => 'Kiểm tra kết nối';

  @override
  String get checkRunning => 'Đang kiểm tra';

  @override
  String get checkSelfSigned =>
      'Máy chủ dùng chứng chỉ riêng mà thiết bị này chưa biết.';

  @override
  String get checkSkipped => 'Chưa kiểm tra';

  @override
  String get checkStepAuth => 'Lần đăng nhập của bạn';

  @override
  String get checkStepClock => 'Đồng hồ thiết bị';

  @override
  String get checkStepDns => 'Tìm địa chỉ máy chủ';

  @override
  String get checkStepNetwork => 'Mạng của bạn';

  @override
  String get checkStepServer => 'Photolib trên máy chủ';

  @override
  String get checkStepTcp => 'Kết nối tới máy chủ';

  @override
  String get checkStepTls => 'Kết nối bảo mật và chứng chỉ';

  @override
  String get checkStepUpload => 'Tải lên lớn qua proxy';

  @override
  String get checkTimedOut => 'Máy chủ trả lời quá lâu.';

  @override
  String get checkTimedOutNext => 'Kiểm tra kết nối rồi thử lại.';

  @override
  String get checkTitle => 'Kiểm tra kết nối';

  @override
  String get checkTlsFailed => 'Kết nối bảo mật không thành công.';

  @override
  String get checkTrustNext =>
      'Chỉ tin cậy nếu dấu vân tay của nó khớp với máy chủ của bạn.';

  @override
  String get checkUntrusted =>
      'Chứng chỉ của máy chủ đến từ một tổ chức mà thiết bị này không tin cậy.';

  @override
  String get checkUploadCap =>
      'Một proxy trên đường đi từ chối tải lên lớn, nên sao lưu chậm hơn, từng phần nhỏ.';

  @override
  String get checkUploadCapNext =>
      'Nhờ quản trị viên cho phép yêu cầu 64 MB đi qua proxy.';

  @override
  String get collectionAlbums => 'Album';

  @override
  String collectionHide(String name) {
    return 'Ẩn $name';
  }

  @override
  String collectionMoveDown(String name) {
    return 'Di chuyển $name xuống';
  }

  @override
  String collectionMoveUp(String name) {
    return 'Di chuyển $name lên';
  }

  @override
  String get collectionPeople => 'Mọi người';

  @override
  String collectionPin(String name) {
    return 'Ghim $name';
  }

  @override
  String get collectionPlaces => 'Địa điểm';

  @override
  String collectionShow(String name) {
    return 'Hiện $name';
  }

  @override
  String get collectionTags => 'Thẻ';

  @override
  String collectionUnpin(String name) {
    return 'Bỏ ghim $name';
  }

  @override
  String get collectionsCustomise => 'Tùy chỉnh';

  @override
  String get collectionsDone => 'Xong';

  @override
  String get commandPalette => 'Bảng lệnh';

  @override
  String get commandPaletteHint => 'Nhập lệnh';

  @override
  String get dateFormatDefault => 'Mặc định theo ngôn ngữ';

  @override
  String get dateFormatDmy => 'Ngày-tháng-năm';

  @override
  String get dateFormatMdy => 'Tháng-ngày-năm';

  @override
  String get dateFormatYmd => 'Năm-tháng-ngày';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString trên thiết bị này và đã sao lưu',
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
      other: '$countString chỉ trên thiết bị này, chưa sao lưu',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'Khi Ảnh iCloud bật, các mục bị xóa khỏi thiết bị này cũng biến mất khỏi iCloud và các thiết bị Apple khác của bạn.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString chỉ trong thư viện của bạn',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'Gỡ khỏi thiết bị này';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString mục đã sao lưu; thư viện của bạn vẫn giữ chúng',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'Các bản sao trên thiết bị này vào thùng rác của thiết bị: dung lượng được trả lại khi thùng rác được dọn.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xóa $countString mục?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'Khỏi thiết bị này và thư viện của bạn',
      'device': 'Chỉ khỏi thiết bị này',
      'other': 'Khỏi thư viện của bạn',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => 'Không có';

  @override
  String get deviceFolderCard => 'Thẻ SD';

  @override
  String get deviceFolderExclude => 'Loại trừ';

  @override
  String get deviceFolderExcludeThis => 'Loại trừ thư mục này';

  @override
  String get deviceFolderExcludedNotice =>
      'Thư mục của mục này đã bị loại khỏi thư viện';

  @override
  String get deviceFolderForget => 'Xóa khỏi danh sách';

  @override
  String get deviceFolderInternal => 'Bộ nhớ trong';

  @override
  String get deviceFolderKeep => 'Giữ lại';

  @override
  String deviceFolderNew(String name, String items) {
    return 'Thư mục mới: $name, $items';
  }

  @override
  String get deviceFolders => 'Thư mục trên thiết bị';

  @override
  String get deviceFoldersAll => 'Hiển thị mọi thư mục trừ thư mục bị loại trừ';

  @override
  String get deviceFoldersChosen => 'Chỉ hiển thị thư mục đã chọn';

  @override
  String get deviceFoldersExcludedNow => 'Đã loại khỏi thư viện';

  @override
  String get deviceFoldersSearch => 'Tìm thư mục';

  @override
  String get diagnosticsAdvanced => 'Hiện chẩn đoán';

  @override
  String get diagnosticsAllLoggers => 'Tất cả nguồn';

  @override
  String get diagnosticsCopied => 'Đã sao chép nhật ký';

  @override
  String get diagnosticsCopy => 'Sao chép nhật ký đang hiển thị';

  @override
  String get diagnosticsEmpty => 'Chưa có mục nhật ký nào';

  @override
  String get diagnosticsExport => 'Xuất gói chẩn đoán';

  @override
  String get diagnosticsExported => 'Đã lưu gói chẩn đoán';

  @override
  String get diagnosticsLevel => 'Mức';

  @override
  String get diagnosticsLogger => 'Nguồn';

  @override
  String get diagnosticsTitle => 'Chẩn đoán';

  @override
  String get download => 'Tải xuống';

  @override
  String get downloadCurrent => 'Phiên bản hiện tại, kèm các chỉnh sửa';

  @override
  String get downloadFailed => 'Không thể tải xuống';

  @override
  String get downloadOriginal => 'Bản gốc';

  @override
  String downloadSaved(String name) {
    return 'Đã lưu $name';
  }

  @override
  String get downloadVersion => 'Phiên bản nào?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đang tải xuống $countString mục',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => 'Tự động nâng cao';

  @override
  String get editorCrop => 'Cắt';

  @override
  String get editorCropOriginal => 'Gốc';

  @override
  String get editorCropSquare => 'Vuông';

  @override
  String get editorEdit => 'Chỉnh sửa';

  @override
  String get editorFlip => 'Lật';

  @override
  String get editorRotate => 'Xoay';

  @override
  String get editorSaveCopy => 'Lưu bản sao';

  @override
  String get editorSaveFailed => 'Không thể lưu bản sao';

  @override
  String get editorSaveVersion => 'Lưu';

  @override
  String get editorSaved => 'Đã lưu dưới dạng bản sao';

  @override
  String get editorVersionFailed => 'Không thể lưu phiên bản';

  @override
  String get editorVersionSaved => 'Đã lưu thành phiên bản mới';

  @override
  String get editorVersionsUnsupported =>
      'Máy chủ này chưa thể lưu các phiên bản của ảnh đã chỉnh sửa';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã hoàn tác $countString thay đổi: máy chủ đã từ chối.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => 'Đóng';

  @override
  String get editsRejectedForbidden =>
      'Bạn có thể xem các mục này nhưng không thể thay đổi chúng.';

  @override
  String get editsRejectedInvalid =>
      'Máy chủ không thể chấp nhận các thay đổi.';

  @override
  String get editsRejectedNotFound =>
      'Các mục đã bị xóa hoặc không còn được chia sẻ với bạn.';

  @override
  String get errorNotFound => 'Trang này không tồn tại';

  @override
  String get errorRetry => 'Thử lại';

  @override
  String get errorTitle => 'Đã xảy ra lỗi';

  @override
  String faceNumber(int number) {
    return 'Khuôn mặt $number';
  }

  @override
  String get facesAgree => 'Tôi đồng ý';

  @override
  String get facesAura => 'Mô tả khuôn mặt bằng AuraFace (tải về lớn hơn)';

  @override
  String get facesNotNow => 'Để sau';

  @override
  String get facesNoticeKeep =>
      'Những gì tìm được nằm cùng ảnh của bạn, trên thiết bị và máy chủ của bạn. Các mô tả không bao giờ được hiển thị hay chia sẻ, và tất cả bị xóa khi bạn dừng hoặc xóa ảnh.';

  @override
  String get facesNoticeOptional =>
      'Đây là tùy chọn. Mọi thứ khác trong Photolib vẫn hoạt động mà không cần nó, và bạn có thể dừng bất cứ lúc nào trong Cài đặt.';

  @override
  String get facesNoticeTitle => 'Tìm khuôn mặt trong ảnh của bạn?';

  @override
  String get facesNoticeWhat =>
      'Photolib tìm khuôn mặt trong ảnh và video của bạn và lưu cho mỗi khuôn mặt vị trí của nó cùng một dãy số mô tả nó, để có thể tìm lại cùng một người. Mô tả như vậy có thể được coi là dữ liệu sinh trắc học.';

  @override
  String get facesNoticeWhere =>
      'Việc này diễn ra trên thiết bị này và, nếu bạn đã đăng nhập, trên máy chủ của riêng bạn. Không bao giờ trên dịch vụ do chúng tôi hay ai khác vận hành.';

  @override
  String get facesServerFailed =>
      'Không thể báo cho máy chủ của bạn. Hãy thử lại.';

  @override
  String get facesServerOff => 'Máy chủ của bạn không tìm khuôn mặt cho bạn';

  @override
  String get facesServerOn => 'Máy chủ của bạn tìm khuôn mặt cho bạn';

  @override
  String get facesServerUnavailable =>
      'Máy chủ của bạn không cung cấp nhận diện khuôn mặt';

  @override
  String facesStatusDownloading(int percent) {
    return 'Đang tải mô hình khuôn mặt: $percent%';
  }

  @override
  String get facesStatusMissing => 'Máy chủ của bạn chưa cài mô hình khuôn mặt';

  @override
  String get facesStatusNoDecoder =>
      'Không thể tìm khuôn mặt: không tìm thấy thư viện ảnh (libvips). Hãy cài lại Photolib, hoặc cài libvips rồi khởi động lại.';

  @override
  String get facesStatusRunning => 'Đang tìm khuôn mặt trên thiết bị này';

  @override
  String get facesStatusUnavailable =>
      'Không thể tìm khuôn mặt trên thiết bị này';

  @override
  String get facesStatusWaiting => 'Mô hình khuôn mặt được tải qua Wi-Fi';

  @override
  String get facesSwitch => 'Tìm khuôn mặt trong ảnh của tôi';

  @override
  String get facesSwitchOff =>
      'Tắt. Không có gì về khuôn mặt được tính toán cho đến khi bạn đồng ý.';

  @override
  String get facesSwitchOn => 'Bật. Photolib tìm khuôn mặt trong ảnh của bạn.';

  @override
  String get facesTitle => 'Khuôn mặt và người';

  @override
  String get facesWithdraw => 'Xóa và dừng';

  @override
  String get facesWithdrawBody =>
      'Việc này xóa mọi khuôn mặt, mô tả và người mà Photolib đã tìm cho bạn, trên thiết bị này và trên máy chủ của bạn. Ảnh của bạn không thay đổi.';

  @override
  String get facesWithdrawTitle => 'Dừng tìm khuôn mặt?';

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

    return 'Tệp không thay đổi: $countString';
  }

  @override
  String get folderAllow => 'Cho phép truy cập vào thư mục này';

  @override
  String get folderDelete => 'Xóa thư mục';

  @override
  String folderDeleteBody(String name) {
    return 'Chuyển ảnh và video trong $name vào thùng rác?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString mục',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => 'Thư mục mới';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ngoại tuyến, $countString mục',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps =>
      'Thư mục này đã có trong thư viện, hoặc nằm trong hay chứa một thư mục đã có';

  @override
  String get folderRemove => 'Gỡ thư mục';

  @override
  String folderRemoveBody(String folder) {
    return 'Ảnh và video trong $folder sẽ bị gỡ khỏi thư viện. Các tệp vẫn còn nguyên trên ổ đĩa.';
  }

  @override
  String get folderRemoveConfirm => 'Gỡ';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đang quét, đã tìm thấy $countString mục',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'Cho phép truy cập';

  @override
  String get foldersHideExcluded => 'Ẩn các thư mục bị loại trừ';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib không còn đọc được $countString thư mục.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Hiện các thư mục bị loại trừ ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'Trình duyệt này không thể dùng một thư mục làm thư viện của bạn. Hãy mở Photolib trong Chrome hoặc Edge trên máy tính, hoặc dùng ứng dụng dành cho máy tính.';

  @override
  String get galleryButtons => 'Nút';

  @override
  String get galleryChips => 'Chip';

  @override
  String get galleryGrid => 'Lưới';

  @override
  String get galleryMenus => 'Menu và bảng';

  @override
  String get galleryShowSheet => 'Hiện bảng';

  @override
  String get galleryTitle => 'Thành phần';

  @override
  String hiddenCollections(int count) {
    return 'Đã ẩn ($count)';
  }

  @override
  String get indexingAllowMetered => 'Tải xuống bằng dữ liệu di động';

  @override
  String get indexingAllowSaver => 'Cả khi ở chế độ tiết kiệm pin';

  @override
  String get indexingBattery => 'Mức pin cần khi không sạc';

  @override
  String get indexingChargingOnly => 'Chỉ khi đang sạc';

  @override
  String indexingDownloading(int percent) {
    return 'Đang tải mô hình tìm kiếm: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Không đọc được $count ảnh',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'Thiết bị này chỉ lập chỉ mục ảnh mới';

  @override
  String get indexingMissing => 'Máy chủ của bạn chưa cài mô hình tìm kiếm';

  @override
  String get indexingModels => 'Tìm kiếm trên thiết bị này';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Tải mô hình tìm kiếm ($megabytesString MB) từ $host';
  }

  @override
  String get indexingNoDecoder =>
      'Không thể tìm kiếm và đọc chữ: không tìm thấy thư viện ảnh (libvips). Hãy cài lại Photolib, hoặc cài libvips rồi khởi động lại.';

  @override
  String indexingPausedBattery(int percent) {
    return 'Tạm dừng khi pin dưới $percent%';
  }

  @override
  String get indexingPausedCharger => 'Tạm dừng cho đến khi thiết bị được sạc';

  @override
  String get indexingPausedHeat => 'Tạm dừng khi thiết bị nóng';

  @override
  String get indexingPausedSaver => 'Tạm dừng khi bật tiết kiệm pin';

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

    return 'Ảnh đã lập chỉ mục: $doneString/$totalString';
  }

  @override
  String get indexingText => 'Đọc văn bản trong ảnh';

  @override
  String indexingTextDownloading(int percent) {
    return 'Đang tải các mô hình văn bản: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'Tải các mô hình văn bản ($megabytesString MB) từ $host; tìm các từ trong ảnh của bạn';
  }

  @override
  String get indexingTextMissing =>
      'Máy chủ của bạn chưa cài các mô hình văn bản';

  @override
  String get indexingTextPlatform =>
      'Dùng tính năng nhận dạng văn bản của điện thoại; không có gì để tải. Đọc ảnh mới';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Ảnh đã đọc văn bản: $doneString / $totalString';
  }

  @override
  String get indexingTextUnavailable => 'Không thể đọc văn bản ở đây';

  @override
  String get indexingTextWaiting => 'Các mô hình văn bản được tải qua Wi-Fi';

  @override
  String get indexingUnavailable =>
      'Không thể tìm kiếm trên thiết bị này tại đây';

  @override
  String get indexingWaiting => 'Mô hình tìm kiếm sẽ tải qua Wi-Fi';

  @override
  String get infoAddName => 'Thêm tên';

  @override
  String get infoAddTag => 'Thêm thẻ';

  @override
  String get infoAlbums => 'Album';

  @override
  String get infoAllMetadata => 'Xem tất cả siêu dữ liệu';

  @override
  String get infoAuto => 'Tự động';

  @override
  String get infoBackedUp => 'Đã sao lưu';

  @override
  String get infoCamera => 'Máy ảnh';

  @override
  String get infoChangeAdjust => 'Đã chỉnh màu';

  @override
  String get infoChangeCrop => 'Đã cắt';

  @override
  String get infoChangeFlip => 'Đã lật gương';

  @override
  String get infoChangeInpaint => 'Đã lấp một vùng';

  @override
  String get infoChangeLocal => 'Đã chỉnh một vùng';

  @override
  String get infoChangeLut => 'Đã áp dụng kiểu màu';

  @override
  String get infoChangeOther => 'Đã chỉnh sửa';

  @override
  String get infoChangeTurn => 'Đã xoay';

  @override
  String get infoCompare => 'So sánh với bản gốc';

  @override
  String infoConfidence(String percent) {
    return 'Độ tin cậy: $percent';
  }

  @override
  String get infoCopyPath => 'Sao chép đường dẫn';

  @override
  String get infoCurrent => 'Hiện tại';

  @override
  String get infoDescription => 'Thêm mô tả';

  @override
  String get infoEditDate => 'Sửa ngày';

  @override
  String infoEditNumber(int number) {
    return 'Chỉnh sửa $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return 'Bản sao đã chỉnh sửa của $name';
  }

  @override
  String get infoFaces => 'Khuôn mặt';

  @override
  String get infoFile => 'Tệp';

  @override
  String get infoFromFileName => 'từ tên tệp';

  @override
  String get infoHistory => 'Lịch sử chỉnh sửa';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => 'Vị trí';

  @override
  String get infoMap => 'Bản đồ nơi chụp';

  @override
  String get infoMapAgree =>
      'Ô bản đồ được tải từ internet và cho biết khu vực bạn đang xem';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return 'Thẻ mới: $path';
  }

  @override
  String get infoNoAlbum => 'Không có trong album nào';

  @override
  String get infoOnDevice => 'Trên thiết bị này';

  @override
  String get infoOriginal => 'Gốc';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString điểm ảnh';
  }

  @override
  String infoRemoveFrom(String album) {
    return 'Xóa khỏi $album';
  }

  @override
  String infoRemoveTag(String tag) {
    return 'Xóa $tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return 'Đã xóa khỏi $album';
  }

  @override
  String get infoRevert => 'Hoàn nguyên';

  @override
  String get infoSaveCopy => 'Lưu thành bản sao';

  @override
  String get infoShared => 'được chia sẻ';

  @override
  String get infoShowFaces => 'Hiện khuôn mặt trên ảnh';

  @override
  String get infoShowMap => 'Hiện bản đồ';

  @override
  String get infoTags => 'Thẻ';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phiên bản',
    );
    return '$_temp0 · gần nhất $time';
  }

  @override
  String get infoWhy => 'Tại sao là ngày này?';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'Đọc từ tệp, ở $tag',
      'name': 'Đọc từ tên tệp',
      'folder': 'Đọc từ tên một thư mục',
      'host': 'Do dịch vụ cung cấp tệp đưa ra',
      'unknown': 'Không có gì trong tệp cho biết ngày, nên dùng ngày tệp được sửa lần cuối',
      'other': 'Tệp chưa được đọc, nên dùng ngày do thiết bị đưa ra',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'Danh sách',
      'other': 'Lưới',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': 'Tên',
      'taken': 'Ngày chụp',
      'modified': 'Ngày sửa đổi',
      'size': 'Kích thước',
      'random': 'Ngẫu nhiên',
      'extension': 'Loại',
      'custom': 'Thứ tự album',
      'other': 'Ngày chụp',
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
  String get languageDevice => 'Ngôn ngữ của thiết bị';

  @override
  String get languageName => 'Tiếng Việt';

  @override
  String get libraryAddFolder => 'Thêm thư mục';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Chưa sao lưu',
      'backed_up': 'Đã sao lưu',
      'cloud_only': 'Chỉ trên đám mây',
      'other': 'Tất cả',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'Mọi thứ đã được sao lưu',
      'backed_up': 'Chưa có gì được sao lưu',
      'cloud_only': 'Không có gì chỉ nằm trên máy chủ',
      'other': 'Không có gì ở đây',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'Huy hiệu sao lưu';

  @override
  String get libraryEmpty => 'Ảnh của bạn sẽ xuất hiện ở đây';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': 'Nhóm theo tuần',
      'month': 'Nhóm theo tháng',
      'other': 'Nhóm theo ngày',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => 'Ẩn lại các mục đã ẩn và đã lưu trữ';

  @override
  String get libraryNoKeyring =>
      'Photolib lưu khóa của thư viện của bạn trong chùm khóa hệ thống, nhưng chùm khóa đang không chạy hoặc bị khóa. Hãy khởi động hoặc mở khóa một chùm khóa, chẳng hạn GNOME Keyring hoặc KWallet, rồi thử lại.';

  @override
  String get libraryRevealExcluded =>
      'Hiển thị thư mục bị loại trừ trong 5 phút';

  @override
  String get libraryShowVeiled =>
      'Hiện các mục đã ẩn và đã lưu trữ trong 5 phút';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': 'Mới thêm gần đây',
      'other': 'Ngày chụp',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed =>
      'Photolib không thể mở thư viện được lưu trên thiết bị này';

  @override
  String get libraryViewOptions => 'Tùy chọn hiển thị';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Đang chuẩn bị hình thu nhỏ: $doneString/$totalString';
  }

  @override
  String get libraryZoomIn => 'Hình thu nhỏ lớn hơn';

  @override
  String get libraryZoomOut => 'Hình thu nhỏ nhỏ hơn';

  @override
  String get mapAddTrack => 'Thêm đường đi GPX';

  @override
  String get mapArea => 'Khu vực bản đồ';

  @override
  String get mapAttribution => '© những người đóng góp OpenStreetMap';

  @override
  String get mapClearLasso => 'Bỏ chọn';

  @override
  String get mapEmpty => 'Chưa có ảnh nào có vị trí';

  @override
  String get mapHeat => 'Bản đồ nhiệt';

  @override
  String get mapLasso => 'Chọn bằng cách vẽ vòng quanh ảnh';

  @override
  String get mapLoading => 'Đang đặt ảnh lên bản đồ';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Ảnh: $countString';
  }

  @override
  String get mapSearchHere => 'Tìm trong khu vực này';

  @override
  String get mapSplit => 'Hiện ảnh bên dưới bản đồ';

  @override
  String get mapTilesAgree =>
      'Nền bản đồ lấy từ máy chủ OpenStreetMap (tile.openstreetmap.org), nơi thấy bạn đang xem khu vực nào';

  @override
  String get mapTilesShow => 'Hiện nền bản đồ';

  @override
  String get mapTime => 'Khoảng thời gian';

  @override
  String get mapTitle => 'Bản đồ';

  @override
  String get mapTrackBad => 'Tệp đó không có đường đi GPX';

  @override
  String get mapTrips => 'Chuyến đi';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'Yêu thích',
      'hidden': 'Đã ẩn',
      'archived': 'Đã lưu trữ',
      'offline': 'Đã giữ trên thiết bị này',
      'offline': 'Đã giữ trên thiết bị này',
      'offline': 'Đã giữ trên thiết bị này',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'Cho phép truy cập';

  @override
  String get mediaAccessNone =>
      'Photolib cần quyền truy cập vào ảnh và video của bạn để hiển thị chúng.';

  @override
  String get mediaAccessPartial =>
      'Photolib chỉ thấy những ảnh và video bạn đã chọn. Một ứng dụng thư viện ảnh cần quyền truy cập vào tất cả.';

  @override
  String get mediaAccessSelect => 'Chọn thêm ảnh';

  @override
  String get nameLabel => 'Tên';

  @override
  String get nextAddRoot =>
      'Thêm thư mục vào external_roots trong cấu hình máy chủ, rồi khởi động lại máy chủ.';

  @override
  String get nextAskAdmin => 'Hãy hỏi quản trị viên máy chủ của bạn.';

  @override
  String get nextAskOwner => 'Hãy nhờ chủ thư viện cho phép bạn thêm ảnh.';

  @override
  String get nextCheckConnection => 'Kiểm tra kết nối để xem lý do.';

  @override
  String get nextCheckEntry => 'Kiểm tra những gì bạn đã nhập rồi thử lại.';

  @override
  String get nextConfirm => 'Kiểm tra số mục bị ảnh hưởng rồi xác nhận.';

  @override
  String get nextDeleteWebhook =>
      'Hãy xóa một webhook bạn không còn dùng, rồi thử lại.';

  @override
  String get nextEditConfig =>
      'Thay đổi trong cấu hình máy chủ, rồi khởi động lại máy chủ.';

  @override
  String get nextFreeSpace =>
      'Giải phóng dung lượng, hoặc xin quản trị viên thêm.';

  @override
  String get nextNewLink => 'Hãy xin quản trị viên một liên kết mới.';

  @override
  String get nextNewestToken =>
      'Sao chép mã mới nhất từ nhật ký của photolibd.';

  @override
  String get nextOtherAdmin =>
      'Trước tiên hãy đặt một tài khoản khác làm quản trị viên.';

  @override
  String get nextOtherFolder => 'Chọn một thư mục riêng.';

  @override
  String get nextRefresh => 'Làm mới rồi thử lại.';

  @override
  String get nextReport =>
      'Thử lại. Nếu vẫn xảy ra, hãy sao chép chi tiết bên dưới cho quản trị viên.';

  @override
  String get nextSetUpPrivate =>
      'Hoàn tất thiết lập thư viện riêng tư trong Cài đặt, rồi thử lại.';

  @override
  String get nextSignIn => 'Đăng nhập lại.';

  @override
  String get nextSignInAccount =>
      'Đăng nhập bằng tài khoản của bạn rồi thử lại.';

  @override
  String get nextSignInInstead => 'Hãy đăng nhập thay vào đó.';

  @override
  String get nextTryAgain => 'Thử lại.';

  @override
  String get nextUpdateAndAgree =>
      'Hãy cập nhật ứng dụng, rồi đồng ý lại với thông báo.';

  @override
  String get nextUseAnother => 'Chọn tên khác.';

  @override
  String get nextUseHttps =>
      'Dùng địa chỉ https:// của máy chủ, hoặc kết nối từ chính mạng của máy chủ.';

  @override
  String get nextWait => 'Chờ một phút rồi thử lại.';

  @override
  String get offlineKeep => 'Giữ ngoại tuyến';

  @override
  String offlineKeepHere(String size) {
    return 'Giữ trên thiết bị này ($size)';
  }

  @override
  String get offlineKeptHere => 'Đã giữ trên thiết bị này';

  @override
  String get offlineStopKeeping => 'Ngừng giữ ngoại tuyến';

  @override
  String get otherFiles => 'Tệp khác';

  @override
  String get passphraseCreate =>
      'Máy tính này không chạy chuỗi khóa (Secret Service) nào để giữ khóa của Photolib. Hãy chọn một cụm mật khẩu dài ít nhất 10 ký tự để bảo vệ chúng: Photolib sẽ hỏi cụm này mỗi lần khởi động.';

  @override
  String get passphraseLabel => 'Cụm mật khẩu';

  @override
  String get passphraseMismatch => 'Cụm mật khẩu không khớp.';

  @override
  String get passphraseRepeat => 'Nhập lại cụm mật khẩu';

  @override
  String get passphraseTooShort => 'Hãy dùng ít nhất 10 ký tự.';

  @override
  String get passphraseUnlock =>
      'Nhập cụm mật khẩu bảo vệ khóa của Photolib trên máy tính này.';

  @override
  String get passphraseWrong => 'Sai cụm mật khẩu. Hãy thử lại.';

  @override
  String photoPosition(int index, int count) {
    return 'Ảnh $index trong số $count';
  }

  @override
  String get privacyCheckKit => 'Kiểm tra bộ khôi phục';

  @override
  String get privacyDrillDue =>
      'Đã đến lúc diễn tập khôi phục: hãy kiểm tra xem bộ khôi phục của bạn có còn mở khóa được thư viện riêng tư không.';

  @override
  String get privacyHonest =>
      'Thư viện riêng tư được mã hóa trên thiết bị của bạn và không ai khác mở được: không phải máy chủ, không phải quản trị viên của máy chủ, cũng không phải nhà phát triển Photolib. Nếu bạn mất cả mật khẩu lẫn bộ khôi phục, ảnh của bạn sẽ mất vĩnh viễn và không ai có thể lấy lại giúp bạn.';

  @override
  String get privacyKitBody =>
      'Hãy viết 24 từ này ra giấy theo đúng thứ tự và cất ở nơi an toàn. Chúng mở khóa thư viện riêng tư của bạn nếu bạn quên mật khẩu, cho bất kỳ ai có chúng.';

  @override
  String get privacyKitDone => 'Bộ khôi phục của bạn hoạt động.';

  @override
  String get privacyKitOther => 'Đây không phải bộ khôi phục hiện tại của bạn.';

  @override
  String get privacyKitTitle => 'Bộ khôi phục của bạn';

  @override
  String get privacyKitUnverified => 'Bộ khôi phục chưa được xác minh';

  @override
  String privacyKitVerified(String date) {
    return 'Bộ khôi phục đã được xác minh vào $date';
  }

  @override
  String get privacyKitWritten => 'Tôi đã ghi lại';

  @override
  String get privacyNotReady =>
      'Tải lên riêng tư vẫn tắt cho đến khi bạn có hai cách mở khóa và đã xác minh bộ khôi phục.';

  @override
  String get privacyPasswordHelp =>
      'Nhập mật khẩu tài khoản của bạn: nó sẽ trở thành một cách mở khóa thư viện riêng tư.';

  @override
  String get privacyPhrase => 'Cụm từ khôi phục';

  @override
  String get privacyPhraseHelp => '24 từ trong bộ khôi phục của bạn';

  @override
  String get privacyPhraseInvalid =>
      'Đây không phải cụm từ khôi phục. Hãy kiểm tra từng từ.';

  @override
  String get privacyReady => 'Tải lên riêng tư đang bật.';

  @override
  String get privacyRecoveryKit => 'Bộ khôi phục';

  @override
  String get privacySetUp => 'Thiết lập';

  @override
  String get privacyShowWords => 'Hiện lại các từ';

  @override
  String get privacyTitle => 'Thư viện riêng tư';

  @override
  String privacyUnknownWord(int number) {
    return 'Từ thứ $number không phải là từ của bộ khôi phục.';
  }

  @override
  String get privacyVerify => 'Xác minh';

  @override
  String get privacyVerifyBody =>
      'Nhập các từ này từ bộ khôi phục để cho thấy bạn đã lưu nó.';

  @override
  String get privacyWays => 'Cách mở khóa';

  @override
  String privacyWord(int number) {
    return 'Từ $number';
  }

  @override
  String get privacyWordsDiffer =>
      'Các từ này không khớp với bộ khôi phục của bạn. Hãy kiểm tra những gì bạn đã ghi.';

  @override
  String get privacyWrongPassword =>
      'Đây không phải mật khẩu tài khoản của bạn.';

  @override
  String get problemAdminOnly => 'Chỉ quản trị viên mới làm được việc này.';

  @override
  String get problemBusy => 'Máy chủ đang bận hoặc đang khởi động lại.';

  @override
  String get problemChanged => 'Điều này đã thay đổi trong lúc đó.';

  @override
  String get problemConfirm =>
      'Thao tác này sẽ ẩn hoặc xóa nhiều mục hơn mức máy chủ làm khi không có xác nhận';

  @override
  String get problemContribute => 'Bạn không được thêm ảnh vào thư viện này.';

  @override
  String get problemCopy => 'Sao chép chi tiết';

  @override
  String get problemDetails => 'Chi tiết';

  @override
  String get problemDiskLow =>
      'Ổ đĩa của máy chủ gần đầy nên việc tải lên đang tạm dừng.';

  @override
  String get problemEmailTaken => 'Một tài khoản khác đã dùng email này.';

  @override
  String get problemExists => 'Nó đã tồn tại.';

  @override
  String get problemFaceNotice =>
      'Máy chủ của bạn yêu cầu phiên bản thông báo về khuôn mặt mới hơn phiên bản ứng dụng này hiển thị.';

  @override
  String get problemGone => 'Nó không còn trên máy chủ.';

  @override
  String get problemHandleTaken =>
      'Một tài khoản khác đã dùng tên đăng nhập này.';

  @override
  String get problemInterrupted => 'Việc tải lên đã bị gián đoạn.';

  @override
  String get problemInvalid => 'Có một giá trị không hợp lệ';

  @override
  String get problemLastAdmin => 'Máy chủ cần ít nhất một quản trị viên.';

  @override
  String get problemLinkInvalid => 'Liên kết này đã hết hạn hoặc đã được dùng.';

  @override
  String get problemLoginFailed =>
      'Email, tên đăng nhập hoặc mật khẩu không đúng.';

  @override
  String get problemMaintenanceKey =>
      'Chỉ có thể tạm dừng việc sao lưu, kiểm tra tính toàn vẹn và xóa vĩnh viễn khi đã đăng nhập, không thể dùng khóa API';

  @override
  String get problemNotAllowed =>
      'Tài khoản của bạn không được phép làm việc này.';

  @override
  String get problemNotExternal =>
      'Chỉ có thể quét thư viện từ các thư mục riêng của máy chủ.';

  @override
  String get problemOidcClaim =>
      'Nhà cung cấp đăng nhập của bạn không cho biết bạn là ai theo cách máy chủ này chấp nhận.';

  @override
  String get problemOidcDown =>
      'Nhà cung cấp đăng nhập của bạn không trả lời máy chủ.';

  @override
  String get problemOidcFailed =>
      'Nhà cung cấp đăng nhập của bạn đã từ chối đăng nhập.';

  @override
  String get problemOidcNotAllowed =>
      'Tài khoản của bạn không được đăng nhập theo cách này.';

  @override
  String get problemOidcTaken =>
      'Lần đăng nhập này đã được liên kết với một tài khoản Photolib khác.';

  @override
  String get problemOidcUnknown =>
      'Máy chủ này không còn cung cấp cách đăng nhập này.';

  @override
  String get problemPasskeysOff =>
      'Khóa truy cập chỉ hoạt động khi máy chủ có địa chỉ công khai.';

  @override
  String get problemPinned =>
      'Mục này được đặt trong tệp cấu hình và không thể thay đổi ở đây.';

  @override
  String get problemPolicyOff => 'Tính năng này đang bị tắt trên máy chủ này.';

  @override
  String get problemQuota => 'Bộ nhớ của bạn trên máy chủ đã đầy.';

  @override
  String get problemRestoreKey =>
      'Chỉ có thể khôi phục bản sao lưu khi đã đăng nhập, không thể dùng khóa API.';

  @override
  String get problemRootDiffers =>
      'Thư mục này không chứa các tệp của thư viện này';

  @override
  String get problemRootNotAllowed =>
      'Thư mục này không nằm trong external_roots của cấu hình máy chủ';

  @override
  String get problemRootOverlaps =>
      'Thư mục này chứa hoặc nằm trong một thư viện khác hay dữ liệu riêng của máy chủ';

  @override
  String get problemScanning => 'Thư viện này đang được quét';

  @override
  String get problemSecondFactor =>
      'Tài khoản này cần yếu tố thứ hai, như mã xác thực hoặc khóa truy cập, mà phiên bản Photolib này chưa cung cấp được.';

  @override
  String get problemSetupDone => 'Máy chủ này đã có quản trị viên.';

  @override
  String get problemSetupExpired => 'Việc này mất quá nhiều thời gian.';

  @override
  String get problemSetupToken => 'Mã thiết lập này không đúng.';

  @override
  String get problemSignedOut => 'Bạn đã đăng xuất khỏi máy chủ.';

  @override
  String get problemStepUp =>
      'Thay đổi này cần mật khẩu hoặc mã của bạn trước.';

  @override
  String get problemStorage => 'Máy chủ không truy cập được bộ lưu trữ của nó.';

  @override
  String get problemTooMany => 'Quá nhiều lần thử trong thời gian ngắn.';

  @override
  String get problemUnexpected => 'Đã xảy ra sự cố không lường trước.';

  @override
  String get problemUnreachable => 'Máy chủ không trả lời.';

  @override
  String get problemUploadDamaged =>
      'Tệp đã thay đổi hoặc bị hỏng trên đường truyền.';

  @override
  String get problemUploadExpired =>
      'Máy chủ không còn giữ lần tải lên này: các lần tải lên chưa xong sẽ hết hạn sau một ngày.';

  @override
  String get problemWebhookLimit =>
      'Tài khoản của bạn đã có số webhook tối đa được phép.';

  @override
  String get problemWebhooksOff => 'Webhook đang bị tắt trên máy chủ này.';

  @override
  String get recoveryCode => 'Mã khôi phục';

  @override
  String get recoveryCodeAbout =>
      'Mở kho của Photolib trên thiết bị này nếu kho khóa làm mất khóa của nó';

  @override
  String get recoveryCodeEnter => 'Nhập mã khôi phục';

  @override
  String get recoveryCreate => 'Tạo mã khôi phục';

  @override
  String get recoveryLater => 'Để sau';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString thay đổi chỉ có trên thiết bị này. Mã khôi phục sẽ lấy lại chúng nếu kho khóa làm mất khóa của Photolib.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'Hãy ghi lại 24 từ này và cất giữ an toàn: chúng mở kho của Photolib trên thiết bị này mà không cần khóa trong kho khóa. Chúng thay thế mọi mã trước đó.';

  @override
  String get recoveryUnlock => 'Mở khóa';

  @override
  String get recoveryWrong => 'Đó không phải là mã khôi phục của kho này';

  @override
  String get renameFind => 'Tìm';

  @override
  String get renamePattern => 'Tên mới';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': 'Quá dài: tên dài tối đa 255 byte',
      'invalid': 'Không phải tên tệp hợp lệ',
      'duplicate': 'Cũng được đặt cho tệp khác',
      'exists': 'Một tệp khác trong thư mục này đã có tên này',
      'other': 'Không thể đổi tên',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => 'Thay bằng';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Tệp đã đổi tên: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Hiển thị trong Finder',
      'windows': 'Hiển thị trong Explorer',
      'other': 'Hiển thị trong thư mục',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'Máy ảnh';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString mục',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => 'Ngày';

  @override
  String searchDays(String first, String last) {
    return '$first – $last';
  }

  @override
  String get searchEmpty => 'Tìm kiếm trong thư viện của bạn';

  @override
  String get searchFavourites => 'Mục yêu thích';

  @override
  String get searchFolder => 'Thư mục';

  @override
  String get searchHint => 'Tên tệp hoặc thư mục';

  @override
  String get searchMotionPhotos => 'Ảnh chuyển động';

  @override
  String get searchNothing => 'Không có kết quả phù hợp';

  @override
  String get searchPanoramas => 'Ảnh toàn cảnh';

  @override
  String get searchPhotos => 'Ảnh';

  @override
  String get searchScreenshots => 'Ảnh chụp màn hình';

  @override
  String get searchVideo => 'Video';

  @override
  String get searchVideos => 'Video';

  @override
  String get securityAddPasskey => 'Thêm khóa truy cập';

  @override
  String get securityCode => 'Mã';

  @override
  String get securityCodesHelp =>
      'Hãy cất các mã này ở nơi an toàn. Mỗi mã dùng được một lần thay cho yếu tố thứ hai của bạn, và chúng chỉ hiện ra lúc này.';

  @override
  String securityCodesLeft(int count) {
    return 'Chưa dùng: $count';
  }

  @override
  String get securityNewCodes => 'Mã mới';

  @override
  String get securityPasskeyNotAdded => 'Chưa thêm khóa truy cập nào.';

  @override
  String get securityRecoveryCodes => 'Mã khôi phục';

  @override
  String get securityRemovePasskey => 'Xóa khóa truy cập';

  @override
  String get securitySetUp => 'Thiết lập';

  @override
  String get securityStepUpBody =>
      'Nhập mật khẩu, mã từ ứng dụng xác thực hoặc mã khôi phục để thay đổi các yếu tố thứ hai của bạn.';

  @override
  String get securityStepUpTitle => 'Xác nhận đó là bạn';

  @override
  String get securityTitle => 'Yếu tố thứ hai';

  @override
  String get securityTotp => 'Ứng dụng xác thực';

  @override
  String get securityTotpHelp =>
      'Thêm khóa này vào ứng dụng xác thực, rồi nhập mã mà ứng dụng hiển thị.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': 'Bật', 'other': 'Tắt'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'Tắt';

  @override
  String get securityWrongCode => 'Mã không đúng.';

  @override
  String get securityWrongProof => 'Mật khẩu hoặc mã không đúng.';

  @override
  String get selectAll => 'Chọn tất cả';

  @override
  String get selectionClear => 'Bỏ chọn';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chọn $countString',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => 'Hiện mục đã chọn';

  @override
  String get serverAccount => 'Email hoặc tên đăng nhập';

  @override
  String get serverAdd => 'Thêm máy chủ';

  @override
  String get serverAddressInvalid => 'Nhập địa chỉ như photos.example.org';

  @override
  String get serverAddresses => 'Địa chỉ';

  @override
  String get serverAddressesHelp =>
      'Mỗi dòng một địa chỉ: máy chủ trong mạng của bạn, trên internet hoặc qua VPN. Ứng dụng dùng địa chỉ trả lời nhanh nhất. Hoặc dán liên kết đặt mật khẩu bạn đã nhận.';

  @override
  String get serverCa => 'Chứng chỉ CA riêng (PEM)';

  @override
  String get serverCaChoose => 'Chọn tệp chứng chỉ';

  @override
  String serverCertificateBody(String host) {
    return '$host đưa ra một chứng chỉ mà thiết bị này không tin cậy. Chỉ tin cậy nếu dấu vân tay SHA-256 này là của máy chủ của bạn:';
  }

  @override
  String get serverCertificateTitle => 'Tin cậy chứng chỉ này?';

  @override
  String get serverConfirm => 'Xác nhận';

  @override
  String get serverConnect => 'Kết nối';

  @override
  String get serverCreateAdmin => 'Tạo quản trị viên';

  @override
  String get serverEnded => 'Máy chủ đã kết thúc phiên này. Hãy đăng nhập lại.';

  @override
  String get serverHandleHelp =>
      'Chữ thường, chữ số, dấu chấm, dấu gạch ngang và gạch dưới; không bao giờ thay đổi.';

  @override
  String get serverHeaders => 'Tiêu đề tùy chỉnh';

  @override
  String get serverHeadersHelp =>
      'Mỗi dòng một tiêu đề, dạng Name: value; chỉ gửi qua HTTPS';

  @override
  String get serverHeadersInvalid => 'Viết mỗi tiêu đề theo dạng Name: value';

  @override
  String get serverIdentity => 'Chứng chỉ máy khách (PKCS#12)';

  @override
  String get serverIdentityChoose => 'Chọn chứng chỉ máy khách';

  @override
  String get serverIdentityInvalid =>
      'Đây không phải chứng chỉ PKCS#12, hoặc mật khẩu của nó sai.';

  @override
  String get serverIdentityPassword => 'Mật khẩu chứng chỉ máy khách';

  @override
  String get serverLoading => 'Đang đọc máy chủ được lưu trên thiết bị này';

  @override
  String get serverNearby => 'Máy chủ trên mạng này';

  @override
  String get serverNeedsHttps =>
      'Máy chủ này cần địa chỉ HTTPS: ngoài mạng cục bộ của bạn, Photolib không đăng nhập qua HTTP thường.';

  @override
  String get serverNoSignIn =>
      'Máy chủ này không có cách đăng nhập nào mà phiên bản Photolib này hỗ trợ.';

  @override
  String get serverOffline => 'Máy chủ không trả lời. Bạn vẫn được đăng nhập.';

  @override
  String get serverPasskeyFailed =>
      'Chưa dùng khóa truy cập nào. Hãy thử lại hoặc dùng mã.';

  @override
  String get serverPasskeyRequired =>
      'Máy chủ này yêu cầu khóa truy cập, mà phiên bản Photolib này chưa dùng được.';

  @override
  String get serverPassword => 'Mật khẩu';

  @override
  String get serverPasswordAgain => 'Nhập lại mật khẩu';

  @override
  String get serverPasswordSetupInvalid =>
      'Mã thiết lập mật khẩu này sai, đã được dùng hoặc đã hết hạn. Hãy xin mã mới.';

  @override
  String get serverPasswordSetupToken => 'Mã thiết lập mật khẩu';

  @override
  String get serverPasswordSetupTokenHelp =>
      'Từ quản trị viên của bạn, hoặc do photolibd admin password-setup in ra trên máy chủ.';

  @override
  String get serverPasswordsDiffer => 'Mật khẩu không khớp.';

  @override
  String get serverPrivateLibrariesBody =>
      'Mật khẩu mới không mở được chúng. Hãy mở lại bằng bộ khôi phục, khóa truy cập hoặc thiết bị vẫn đang đăng nhập.';

  @override
  String get serverPrivateLibrariesGo => 'Đặt mật khẩu';

  @override
  String get serverPrivateLibrariesTitle =>
      'Thư viện riêng tư của bạn vẫn bị khóa';

  @override
  String get serverProxy => 'Proxy HTTP, dạng host:port';

  @override
  String get serverProxyInvalid => 'Nhập proxy theo dạng host:port';

  @override
  String get serverRecoveryCode => 'Mã khôi phục';

  @override
  String get serverRemove => 'Gỡ máy chủ này';

  @override
  String get serverRequired => 'Bắt buộc';

  @override
  String get serverSecondFactor =>
      'Yếu tố thứ hai của tài khoản này là khóa truy cập, mà phiên bản Photolib này chưa dùng được.';

  @override
  String get serverSecondFactorCode =>
      'Tài khoản này còn cần mã từ ứng dụng xác thực hoặc mã khôi phục.';

  @override
  String get serverSecondFactorTitle => 'Xác nhận đó là bạn';

  @override
  String get serverSecondFactorWrong =>
      'Không thành công. Sau năm lần thử, hãy đăng nhập lại.';

  @override
  String get serverSetPassword => 'Đặt mật khẩu';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return 'Cho $handle trên $server';
  }

  @override
  String get serverSetPasswordOpen => 'Đặt mật khẩu';

  @override
  String get serverSetPasswordTitle => 'Đặt mật khẩu của bạn';

  @override
  String get serverSetUp => 'Thiết lập máy chủ mới';

  @override
  String get serverSetupLinkElsewhere =>
      'Để dùng liên kết này, hãy đăng xuất khỏi máy chủ này trước, hoặc gỡ nó nếu liên kết dành cho máy chủ khác.';

  @override
  String get serverSetupTitle => 'Thiết lập máy chủ';

  @override
  String get serverSetupToken => 'Mã thiết lập';

  @override
  String get serverSetupTokenHelp =>
      'photolibd ghi mã này vào nhật ký khi máy chủ chưa có quản trị viên; mỗi lần khởi động sẽ ghi một mã mới.';

  @override
  String get serverSignIn => 'Đăng nhập';

  @override
  String get serverSignOut => 'Đăng xuất';

  @override
  String serverSignedInAs(String account) {
    return 'Đã đăng nhập với tư cách $account';
  }

  @override
  String get serverSignedOut => 'Đã đăng xuất';

  @override
  String get serverSwitch => 'Chuyển tài khoản';

  @override
  String get serverTotpCode => 'Mã từ ứng dụng xác thực';

  @override
  String get serverTrust => 'Tin cậy';

  @override
  String get serverUnreadable =>
      'Không thể đọc máy chủ được lưu trên thiết bị này';

  @override
  String get serverUsePasskey => 'Dùng khóa truy cập';

  @override
  String get serverUseRecoveryCode => 'Dùng mã khôi phục thay thế';

  @override
  String get settingsBackground => 'Phía sau ảnh trong suốt';

  @override
  String get settingsDateFormat => 'Định dạng ngày';

  @override
  String get settingsDefaultTab => 'Thư mục và album mở ở thẻ';

  @override
  String get settingsFolders => 'Thư mục';

  @override
  String get settingsIndexing => 'Lập chỉ mục trên thiết bị này';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsLibrary => 'Thư viện';

  @override
  String get settingsServer => 'Máy chủ';

  @override
  String get settingsStart => 'Màn hình khởi động';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': 'Chạm cạnh trái hoặc phải để đến mục trước hoặc sau',
      'oneFingerZoom': 'Chạm hai lần rồi kéo để thu phóng bằng một ngón tay',
      'swipes': 'Vuốt lên hoặc xuống ở bên trái video để chỉnh độ sáng, bên phải để chỉnh âm lượng',
      'maxBrightness': 'Độ sáng tối đa khi xem',
      'autoRotate': 'Xoay theo hướng của từng ảnh hoặc video',
      'mixAudio': 'Phát video cùng âm thanh khác thay vì tạm dừng nó',
      'autoplay': 'Phát video khi mở',
      'loop': 'Lặp lại video',
      'autoNext': 'Chuyển sang mục tiếp theo khi video kết thúc',
      'resume': 'Tiếp tục video từ chỗ đã dừng',
      'other': 'Phát ảnh động trong lưới',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'Các nút trên thanh trình xem';

  @override
  String get settingsViewing => 'Xem';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString ảnh và video được chia sẻ đang chờ đến khi Photolib được phép thêm vào thư viện ảnh của bạn. Các mục chưa lưu sẽ bị xóa sau 7 ngày.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge =>
      'Quá lớn để chia sẻ cùng lúc: hãy chọn ít mục hơn';

  @override
  String shareTooMany(int count) {
    return 'Quá nhiều để chia sẻ cùng lúc: hãy chọn tối đa $count';
  }

  @override
  String get shortcutsTitle => 'Phím tắt';

  @override
  String get slideshow => 'Trình chiếu';

  @override
  String get slideshowLoop => 'Lặp lại';

  @override
  String get slideshowOptions => 'Tùy chọn trình chiếu';

  @override
  String get slideshowSeconds => 'Số giây mỗi mục';

  @override
  String get slideshowShuffle => 'Trộn';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': 'Giảm dần',
      'other': 'Tăng dần',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'Thiết bị này';

  @override
  String sourceHide(String name) {
    return 'Ẩn $name';
  }

  @override
  String get sourceHideOthers => 'Ẩn mọi thứ khác ở đây';

  @override
  String get sourceLost => 'Không có quyền truy cập';

  @override
  String get sourcePartly => 'Hiện một phần';

  @override
  String sourceShow(String name) {
    return 'Hiện $name';
  }

  @override
  String get sourceShowEverything => 'Hiện mọi thứ ở đây';

  @override
  String get sourceShowOnly => 'Chỉ hiện mục này';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'Dòng thời gian',
      'folders': 'Thư mục và album',
      'favourites': 'Mục yêu thích',
      'other': 'Dòng thời gian',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => 'Giữ một người ngoại tuyến';

  @override
  String get storageBudget => 'Giới hạn dung lượng';

  @override
  String get storageClear => 'Xóa bản sao ngoại tuyến';

  @override
  String get storageClearAction => 'Xóa';

  @override
  String storageClearBody(String size) {
    return 'Thao tác này xóa $size đang giữ trên thiết bị này và ngừng giữ album, tìm kiếm và ảnh ngoại tuyến. Thư viện của bạn trên máy chủ không bị ảnh hưởng.';
  }

  @override
  String get storageKeepLibrary => 'Giữ toàn bộ thư viện';

  @override
  String get storageKeepOriginals => 'Giữ cả bản gốc';

  @override
  String get storageNoPeople => 'Chưa có người nào được đặt tên.';

  @override
  String get storageNoPins =>
      'Chưa ghim gì. Hãy ghim một album, tìm kiếm hoặc ảnh để giữ ngoại tuyến.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album',
      'search': 'Tìm kiếm',
      'person': 'Người',
      'library': 'Toàn bộ thư viện',
      'asset': 'Ảnh',
      'other': 'Đã ghim',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return 'Vượt giới hạn: cần thêm $size';
  }

  @override
  String get storagePinNothing =>
      'Không có gì để tải: ảnh đã có trên thiết bị này';

  @override
  String get storagePinPaused =>
      'Đang chờ: chế độ này không giữ gì ngoại tuyến';

  @override
  String get storagePinPlanning => 'Đang xem cần giữ gì…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'Đang tải: $haveString trên $filesString';
  }

  @override
  String storagePinReady(String size) {
    return 'Có sẵn ngoại tuyến ($size)';
  }

  @override
  String get storagePinWaiting => 'Sẽ tải khi có mạng';

  @override
  String get storagePins => 'Giữ ngoại tuyến';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Chỉ danh mục',
      'spaceSaver': 'Tiết kiệm dung lượng',
      'travel': 'Album đã chọn ngoại tuyến',
      'everything': 'Tất cả',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'Không giữ gì; ảnh được tải từ máy chủ của bạn khi mở.',
      'spaceSaver':
          'Giữ bản xem trước của cả thư viện, mới nhất trước, trong giới hạn.',
      'travel': 'Chỉ giữ những gì bạn ghim: album, tìm kiếm và ảnh.',
      'everything':
          'Giữ bản gốc của cả thư viện, mới nhất trước, trong giới hạn.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'Thiết bị này giữ gì';

  @override
  String get storageSubtitle => 'Bản sao ngoại tuyến và giới hạn dung lượng';

  @override
  String get storageTitle => 'Dung lượng';

  @override
  String storageUsed(String used, String budget) {
    return 'Đã dùng $used trên $budget';
  }

  @override
  String get storageWebNote =>
      'Trình duyệt chỉ giữ bản xem trước và xóa khi bạn đăng xuất.';

  @override
  String get storeNoKeyring =>
      'Photolib giữ khóa của kho cục bộ trong chùm khóa của hệ thống, nhưng chùm khóa không phản hồi. Hãy cài đặt và mở khóa gnome-keyring, KWallet hoặc KeePassXC với Secret Service được bật, rồi thử lại.';

  @override
  String get storeNoKeystore =>
      'Photolib không thể kết nối với kho khóa của thiết bị này, nơi giữ khóa của kho cục bộ.';

  @override
  String get storeRebuilt =>
      'Kho khóa của thiết bị này không còn khóa của kho cục bộ Photolib, nên kho đã được tạo lại. Cài đặt của kho và những gì chỉ có trên thiết bị này đã mất; thư viện đồng bộ lại và hình thu nhỏ sẽ trở lại.';

  @override
  String get storeRecoveryNeeded =>
      'Kho khóa của thiết bị này không còn khóa của kho cục bộ Photolib. Hãy nhập mã khôi phục, hoặc đặt lại kho và mất những gì chỉ có trên thiết bị này.';

  @override
  String get storeReset => 'Đặt lại kho';

  @override
  String get storeResetBody =>
      'Những gì chỉ có trên thiết bị này sẽ mất; thư viện đồng bộ lại và hình thu nhỏ sẽ trở lại.';

  @override
  String get storeUnavailable =>
      'Kho lưu trữ trên thiết bị này không khả dụng: cài đặt và bộ sưu tập không được giữ lại';

  @override
  String get tabCollections => 'Bộ sưu tập';

  @override
  String get tabLibrary => 'Thư viện';

  @override
  String get tabSearch => 'Tìm kiếm';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get timelineBenchmark => 'Đo hiệu năng dòng thời gian';

  @override
  String get timelineBenchmarkCopy => 'Sao chép kết quả';

  @override
  String get timelineCannotPlay => 'Không thể phát trong trình duyệt này';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $position trong số $count';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $position trong số $count, không có bản xem trước';
  }

  @override
  String get timelineExcluded => 'Trong thư mục bị loại trừ';

  @override
  String get timelineScrubber => 'Cuộn theo ngày';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => 'Không rõ ngày';

  @override
  String timelineWeek(String date) {
    return 'Tuần từ $date';
  }

  @override
  String toolbarAdd(String action) {
    return 'Thêm $action vào thanh';
  }

  @override
  String toolbarDown(String action) {
    return 'Di chuyển $action xuống';
  }

  @override
  String get toolbarInBar => 'Trên thanh';

  @override
  String get toolbarInMenu => 'Trong menu ⋮';

  @override
  String toolbarRemove(String action) {
    return 'Xóa $action khỏi thanh';
  }

  @override
  String get toolbarReset => 'Đặt lại về mặc định';

  @override
  String toolbarUp(String action) {
    return 'Di chuyển $action lên';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'Di chuyển đến đây',
      'other': 'Sao chép đến đây',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': 'Đã có tệp hoặc thư mục cùng tên',
      'changed': 'Bản sao không khớp với bản gốc nên đã bị xóa',
      'cancelled': 'Đã hủy',
      'invalid': 'Không phải tên thư mục hợp lệ',
      'other': 'Không thành công',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => 'Gần đây';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xóa vĩnh viễn $countString mục? Không thể hoàn tác.',
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
      other: 'Còn $daysString ngày',
      zero: 'Sẽ bị xóa vĩnh viễn hôm nay',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'Thùng rác trống';

  @override
  String get trashEmptyAll => 'Dọn sạch thùng rác';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chuyển $countString mục vào thùng rác',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib xóa vĩnh viễn những gì nó giữ trong thùng rác sau $days ngày; mỗi mục cho biết thời gian còn lại.';
  }

  @override
  String get trashTitle => 'Thùng rác';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get uploadAction => 'Tải ảnh và video lên';

  @override
  String get uploadClear => 'Xóa';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Đã tải lên $doneString/$totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Thất bại: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã lưu trữ $countString mục',
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
      other: 'Đã ẩn $countString mục',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': 'Đen',
      'white': 'Trắng',
      'other': 'Ô bàn cờ',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => 'Không thể phát video này trên thiết bị này';

  @override
  String get viewerCaptions => 'Phụ đề';

  @override
  String get viewerCompass => 'Khóa la bàn';

  @override
  String get viewerCopy => 'Sao chép';

  @override
  String get viewerCopyText => 'Sao chép văn bản';

  @override
  String get viewerCustomize => 'Tùy chỉnh thanh công cụ…';

  @override
  String get viewerDial =>
      'Hướng. Nhấp để nhìn về phía trước. Kéo để nhìn xung quanh, cuộn hoặc chụm để thu phóng, nhấp đúp để đặt lại';

  @override
  String get viewerFilmstrip => 'Dải ảnh';

  @override
  String get viewerFirst => 'Đầu tiên';

  @override
  String get viewerFisheye => 'Mắt cá';

  @override
  String get viewerGyroscope => 'Di chuyển thiết bị để nhìn xung quanh';

  @override
  String get viewerHdr => 'Hiển thị ở chế độ HDR';

  @override
  String get viewerInfo => 'Thông tin';

  @override
  String get viewerInfoLoading => 'Đang tải thông tin của mục này';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$positionString trong số $countString';
  }

  @override
  String get viewerLast => 'Cuối cùng';

  @override
  String get viewerLenses => 'Chọn ống kính';

  @override
  String get viewerMap => 'Bản đồ';

  @override
  String get viewerMotion => 'Phát chuyển động';

  @override
  String get viewerMotionDenied =>
      'Trình duyệt này không cho phép truy cập cảm biến chuyển động';

  @override
  String get viewerMotionMissing =>
      'Thiết bị này không có con quay hồi chuyển để nhìn xung quanh';

  @override
  String get viewerMute => 'Tắt tiếng';

  @override
  String get viewerNext => 'Tiếp theo';

  @override
  String get viewerNextFrame => 'Khung hình tiếp theo';

  @override
  String get viewerPause => 'Tạm dừng';

  @override
  String get viewerPlanet => 'Hành tinh nhỏ';

  @override
  String get viewerPlay => 'Phát';

  @override
  String get viewerPrevious => 'Trước';

  @override
  String get viewerPreviousFrame => 'Khung hình trước';

  @override
  String get viewerRotate => 'Xoay';

  @override
  String get viewerSdr => 'Hiển thị ở chế độ SDR';

  @override
  String get viewerSeek => 'Vị trí';

  @override
  String get viewerSetAs => 'Đặt làm';

  @override
  String get viewerShare => 'Chia sẻ';

  @override
  String get viewerSpeed => 'Tốc độ phát';

  @override
  String get viewerSphere =>
      'Chế độ xem 360°. Kéo để nhìn xung quanh, chụm để thu phóng';

  @override
  String get viewerText => 'Văn bản trong ảnh này';

  @override
  String get viewerTextCopied => 'Đã sao chép văn bản';

  @override
  String get viewerTextNone => 'Không tìm thấy văn bản trong ảnh này';

  @override
  String get viewerTextUnread => 'Văn bản của ảnh này chưa được đọc';

  @override
  String get viewerUnmute => 'Bật tiếng';

  @override
  String get viewerZoomIn => 'Phóng to';

  @override
  String get viewerZoomOut => 'Thu nhỏ';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'Thẻ SD',
      'other': 'Bộ nhớ trong',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => 'Phóng to';

  @override
  String get zoomOut => 'Thu nhỏ';
}
