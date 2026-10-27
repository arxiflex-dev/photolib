// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get actionAddToAlbum => '添加到相册';

  @override
  String get actionArchive => '归档';

  @override
  String get actionCopyTo => '复制到…';

  @override
  String get actionDeleteForever => '永久删除';

  @override
  String get actionFavourite => '收藏';

  @override
  String get actionHide => '隐藏';

  @override
  String get actionMoveTo => '移动到…';

  @override
  String get actionRename => '重命名';

  @override
  String get actionRestore => '恢复';

  @override
  String get actionShare => '分享';

  @override
  String get actionTrash => '移至回收站';

  @override
  String get actionUnarchive => '取消归档';

  @override
  String get actionUndo => '撤消';

  @override
  String get actionUnfavourite => '取消收藏';

  @override
  String get actionUnhide => '取消隐藏';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': '已启用',
      'disabled': '已停用',
      'invited': '已邀请',
      'deleted': '已删除',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => '账号';

  @override
  String get adminAddAccount => '添加账号';

  @override
  String get adminAddExternalLibrary => '添加外部图库';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '已尝试 $attempts 次',
      zero: '尚未运行',
    );
    return '$status，$_temp0';
  }

  @override
  String get adminAudit => '审计日志';

  @override
  String get adminBackUpNow => '立即备份';

  @override
  String get adminBackupQueued => '备份已加入队列，随后将进行恢复演练';

  @override
  String get adminBackups => '数据库备份';

  @override
  String get adminCancelJob => '取消任务';

  @override
  String get adminCapabilities => '功能';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': '托管图库',
      'uploads': '来自设备、网页和 CLI 的上传',
      'folder_browser': '文件夹浏览',
      'device_folders': '已连接应用中的设备文件夹',
      'sharing': '共享和公开链接',
      'edits': '编辑',
      'deletes': '删除',
      'xmp_writes': '写入 XMP 附属文件',
      'face_recognition': '人脸识别',
      'ml_search': '智能搜索',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': '正常',
      'warn': '警告',
      'fail': '失败',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => '已复制';

  @override
  String get adminCopyBundle => '复制诊断信息以提交错误报告';

  @override
  String get adminCopyLink => '复制链接';

  @override
  String get adminDelete => '删除';

  @override
  String get adminDeviceBackups => '设备备份';

  @override
  String get adminDevices => '你的设备';

  @override
  String get adminDisable => '停用';

  @override
  String adminDrillFailed(String detail) {
    return '上次恢复演练失败：$detail';
  }

  @override
  String get adminEdit => '编辑';

  @override
  String get adminEmail => '电子邮箱';

  @override
  String get adminEnable => '启用';

  @override
  String get adminErrorSignIn => '请以管理员身份登录';

  @override
  String get adminFacesDefault => '新账号默认开启人脸识别';

  @override
  String get adminFiles => '各类型文件';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': '已损坏',
      'missing': '缺失',
      'size': '大小不符',
      'hash': '已被替换',
      'orphan': '孤立文件',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '可用 $size';
  }

  @override
  String get adminFreeDisk => '可用磁盘空间低于此百分比（0 到 50）时暂停上传';

  @override
  String get adminFreeDiskGb => '或低于此可用空间（GB，0 到 100000），以较小者为准';

  @override
  String get adminHandle => '登录名';

  @override
  String get adminIntegrity => '完整性';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 个项目',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': '排队中',
      'running': '运行中',
      'done': '已完成',
      'dead': '失败',
      'cancelled': '已取消',
      'other': '全部',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => '任务类型，例如 render';

  @override
  String get adminJobs => '任务';

  @override
  String adminLastSeen(String time) {
    return '上次活动：$time';
  }

  @override
  String get adminLibraries => '图库';

  @override
  String get adminLibraryOwner => '所有者';

  @override
  String get adminLibraryRoot => '服务器上的文件夹，例如 /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': '在线',
      'offline': '离线',
      'scanning': '正在扫描',
      'error': '错误',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => '服务器日志';

  @override
  String get adminName => '姓名';

  @override
  String get adminNothing => '暂无内容';

  @override
  String get adminOutOfRange => '超出范围';

  @override
  String get adminOverview => '概览';

  @override
  String get adminPair => '配对设备';

  @override
  String get adminPairBody =>
      '扫描此代码或发送链接，然后在新设备上的 Photolib 中粘贴到“添加服务器”：它会带上此服务器的所有地址和证书，无需任何人输入。';

  @override
  String get adminPasswordSetup => '设置密码链接';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return '通过任意方式将此链接发送给 $name，或让对方扫描二维码。它可在 $date 前设置一次密码。';
  }

  @override
  String get adminPause => '暂停某类任务';

  @override
  String adminPauseMinutes(int max) {
    return '分钟数，1 到 $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type 已暂停至 $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还有 $countString 个项目待备份',
      zero: '没有待备份的项目',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => '策略';

  @override
  String get adminPolicyReset => '使用上一级的值';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': '默认开启',
      'server': '为服务器设定',
      'user': '为此账号设定',
      'library': '为此图库设定',
      'config': '在配置中设定',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => '应用预设';

  @override
  String get adminPresetBody => '预设会为服务器设定每项功能，并清除账号和图库的设定。之后仍可逐项更改。';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '档案浏览',
      'family_backup': '家庭备份',
      'personal': '个人',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '仅以外部只读图库为准：不上传、不使用托管图库和设备文件夹，不编辑、不删除，也不写入 XMP',
      'family_backup': '除写入 XMP 外全部开启',
      'personal': '除共享和公开链接外全部开启',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => '链接的二维码';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已将 $countString 个任务加入队列',
      zero: '无需处理',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => '存储配额（GB），留空表示不限';

  @override
  String get adminRemote => '远程访问';

  @override
  String get adminRemoteBody =>
      '无需在路由器上开放端口，即可随时随地访问服务器。选择一种方式；每种方式都会为服务器提供一个 HTTPS 地址，供添加到应用中。然后从外部进行测试。';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared 主动连接到 Cloudflare，由 Cloudflare 通过 HTTPS 提供你的域名。免费套餐将单个请求限制为 100 MB，备份不会触及该上限：每次只发送 8 MiB。';

  @override
  String get adminRemoteNoAddress => '要从外部测试，请将服务器的 https:// 地址添加到此应用。';

  @override
  String get adminRemoteReachable => '可以从外部访问。';

  @override
  String get adminRemoteTailscale =>
      '在服务器所在的机器和每台设备上安装 Tailscale，加入同一个 tailnet 或你的 Headscale，然后在服务器机器上运行此命令，并将 public_url 设为它输出的地址。';

  @override
  String get adminRemoteTest => '从外部测试';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host 将从其遍布全球的服务器打开 $url，因此会知道这个地址。要继续吗？';
  }

  @override
  String get adminRemoteUnreachable => '无法从外部访问：请检查你选择的方式，然后重新测试。';

  @override
  String get adminRemoteWireguard =>
      '需要在服务器一侧或中转节点上开放一个 UDP 端口。这是设备端的配置；用 wg genkey 生成密钥。';

  @override
  String get adminRepair => '请从备份或仍保留该文件的设备恢复';

  @override
  String get adminRepairOrphan => '没有照片引用它：请检查后删除或保留';

  @override
  String get adminReprocess => '重新处理';

  @override
  String get adminReprocessFaces => '重新检测人脸';

  @override
  String get adminReprocessFolder => '文件夹，例如 2024/05；留空则处理整个图库';

  @override
  String get adminReprocessMetadata => '重新读取元数据';

  @override
  String get adminReprocessRenditions => '重新生成缩略图和预览';

  @override
  String get adminRestore => '恢复';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '恢复 $name 失败：$detail';
  }

  @override
  String get adminRestoreUnverified => '尚无通过的恢复演练';

  @override
  String adminRestoreVerified(String when) {
    return '上次验证的恢复：$when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd 将停止，并在再次启动时用 $name 替换整个数据库。该备份之后的更改将丢失，所有设备都会从头同步。';
  }

  @override
  String get adminRestoring => 'photolibd 正在停止以恢复备份';

  @override
  String get adminResume => '恢复';

  @override
  String get adminRetry => '重试';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': '管理员',
      'user': '用户',
      'viewer': '查看者',
      'other': '未知',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => '已保存';

  @override
  String get adminScan => '立即扫描';

  @override
  String get adminScrubDays => '检查完所有原始文件所用的天数，1 到 3650';

  @override
  String get adminScrubNever => '首次完整检查进行中';

  @override
  String adminScrubbed(String time) {
    return '上次完整检查 $time';
  }

  @override
  String get adminSecondAdmin => '请再设一位管理员，这样在你无法处理时，其他人也能运行并恢复服务器。';

  @override
  String adminSilent(String time) {
    return '自 $time 起无响应';
  }

  @override
  String get adminSilentHours => '设备备份在多少小时无报告后视为无响应，1 到 8760';

  @override
  String get adminStores => '存储';

  @override
  String get adminThisDevice => '此设备';

  @override
  String get adminTitle => '服务器管理';

  @override
  String get adminTrashDays => '回收站保留天数，1 到 3650';

  @override
  String get adminTwoFactor => '所有账号都必须设置两步验证';

  @override
  String get adminUsage => '各账号用量';

  @override
  String get albumCover => '设为封面';

  @override
  String get albumEmpty => '此相册为空';

  @override
  String get albumHideMemories => '从回忆中隐藏';

  @override
  String get albumHideTimeline => '从时间线中隐藏';

  @override
  String get albumNew => '新建相册';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => '任意日期';

  @override
  String get backupCap => '最大项目';

  @override
  String get backupCharging => '仅在充电时';

  @override
  String backupCompleted(String time) {
    return '上次完整备份：$time';
  }

  @override
  String backupContact(String time) {
    return '上次连接服务器：$time';
  }

  @override
  String get backupEnabled => '备份此设备';

  @override
  String get backupFolderNo => '不备份此文件夹';

  @override
  String get backupFolderYes => '备份';

  @override
  String backupHours(int count) {
    return '$count 小时';
  }

  @override
  String get backupMetered => '按流量计费的网络（如移动数据或热点）';

  @override
  String get backupNever => '尚无完整备份';

  @override
  String backupNewFolder(String name) {
    return '新文件夹 $name：要备份吗？';
  }

  @override
  String get backupNoLimit => '无限制';

  @override
  String get backupNothing => '没有等待的项目';

  @override
  String get backupNow => '立即备份';

  @override
  String backupOverdue(int hours, String items) {
    return '已有 $hours 小时没有完整备份。等待中：$items';
  }

  @override
  String get backupOverdueTitle => '备份尚未完成';

  @override
  String backupPending(String items) {
    return '等待中：$items';
  }

  @override
  String backupRetry(String time) {
    return '重试时间：$time';
  }

  @override
  String get backupRoaming => '漫游时备份';

  @override
  String get backupSignIn => '登录服务器以备份此设备';

  @override
  String get backupSignedOut => '备份已停止：服务器已将此设备退出登录。请在设置中重新登录。';

  @override
  String get backupSince => '拍摄于此日期之后';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': '备份正在等待服务器可访问',
      'charging': '备份正在等待设备充电',
      'battery_low': '备份正在等待：电量不足',
      'roaming': '漫游时备份将等待',
      'quota': '备份已停止：你在服务器上的存储空间已满',
      'second_factor': '备份已停止：服务器要求此账户使用第二重验证',
      'other': '备份已停止：服务器返回 $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => '备份';

  @override
  String get backupWaiting => '未备份';

  @override
  String get backupWarnAfter => '未完成多久后提醒';

  @override
  String get backupWhat => '备份内容';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': '位于你未选择的文件夹中',
      'folder_new': '位于新文件夹中：请选择是否备份',
      'type_excluded': '你未选择的项目类型',
      'before_date': '拍摄于你选择的日期之前',
      'selected': '正在排队',
      'server_restored': '服务器在恢复中丢失了它：正在重新发送',
      'working': '正在备份',
      'waiting_for_icloud': '正在等待从 iCloud 下载',
      'metered': '正在等待不按流量计费的网络',
      'metered_cap': '对按流量计费的网络来说太大',
      'unreadable': '此设备无法读取它',
      'changed': '发送时它发生了变化',
      'quota': '你在服务器上的存储空间已满',
      'other': '服务器拒绝了它：$code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld => '服务器已不再支持此版本的 Photolib。';

  @override
  String get checkAppTooOldNext => '请更新 Photolib。';

  @override
  String get checkChanged => '服务器证书不是你之前信任的那个。';

  @override
  String get checkChangedNext => '如果管理员更换了证书，请信任新证书。否则可能有人在窃听：请不要继续。';

  @override
  String get checkClock => '此设备的时钟与服务器的时钟相差超过五分钟。';

  @override
  String get checkClockNext => '让设备自动设置日期和时间。';

  @override
  String get checkDnsFailed => '服务器名称无法解析为地址。';

  @override
  String get checkDnsFailedNext => '检查地址，或连接到服务器所在的网络。';

  @override
  String checkExpired(String date) {
    return '服务器证书已于 $date 过期。';
  }

  @override
  String get checkFailed => '失败';

  @override
  String get checkMetered => '你正在使用按流量计费的网络，例如移动数据。';

  @override
  String get checkMeteredNext => '大量备份前请连接 Wi-Fi。';

  @override
  String get checkNotPhotolib => '响应的不是 Photolib，例如代理的错误页面或 Wi-Fi 登录页面。';

  @override
  String get checkNotPhotolibNext => '在浏览器中登录 Wi-Fi，或请管理员检查代理。';

  @override
  String get checkOtherServer => '此地址上响应的是另一个 Photolib 服务器。';

  @override
  String get checkPassed => '通过';

  @override
  String get checkRefused => '此地址没有任何响应。';

  @override
  String get checkRefusedNext => '检查服务器是否在运行，以及你是否在它的网络或 VPN 中。';

  @override
  String get checkRun => '检查连接';

  @override
  String get checkRunning => '正在检查';

  @override
  String get checkSelfSigned => '服务器使用自己的证书，此设备还不认识它。';

  @override
  String get checkSkipped => '未检查';

  @override
  String get checkStepAuth => '你的登录';

  @override
  String get checkStepClock => '设备时钟';

  @override
  String get checkStepDns => '查找服务器地址';

  @override
  String get checkStepNetwork => '你的网络';

  @override
  String get checkStepServer => '服务器上的 Photolib';

  @override
  String get checkStepTcp => '连接服务器';

  @override
  String get checkStepTls => '安全连接和证书';

  @override
  String get checkStepUpload => '通过代理的大文件上传';

  @override
  String get checkTimedOut => '服务器响应时间过长。';

  @override
  String get checkTimedOutNext => '检查你的连接，然后重试。';

  @override
  String get checkTitle => '连接检查';

  @override
  String get checkTlsFailed => '安全连接失败。';

  @override
  String get checkTrustNext => '只有当它的指纹与你的服务器一致时才信任它。';

  @override
  String get checkUntrusted => '服务器证书来自此设备不信任的颁发机构。';

  @override
  String get checkUploadCap => '途中的代理拒绝大文件上传，因此备份会以小块的形式更慢地进行。';

  @override
  String get checkUploadCapNext => '请管理员让 64 MB 的请求通过代理。';

  @override
  String get collectionAlbums => '相册';

  @override
  String collectionHide(String name) {
    return '隐藏$name';
  }

  @override
  String collectionMoveDown(String name) {
    return '下移$name';
  }

  @override
  String collectionMoveUp(String name) {
    return '上移$name';
  }

  @override
  String get collectionPeople => '人物';

  @override
  String collectionPin(String name) {
    return '固定$name';
  }

  @override
  String get collectionPlaces => '地点';

  @override
  String collectionShow(String name) {
    return '显示$name';
  }

  @override
  String get collectionTags => '标签';

  @override
  String collectionUnpin(String name) {
    return '取消固定$name';
  }

  @override
  String get collectionsCustomise => '自定义';

  @override
  String get collectionsDone => '完成';

  @override
  String get commandPalette => '命令面板';

  @override
  String get commandPaletteHint => '输入命令';

  @override
  String get dateFormatDefault => '跟随语言';

  @override
  String get dateFormatDmy => '日-月-年';

  @override
  String get dateFormatMdy => '月-日-年';

  @override
  String get dateFormatYmd => '年-月-日';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 项在此设备上且已备份',
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
      other: '$countString 项仅在此设备上，未备份',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      '开启 iCloud 照片后，从此设备删除的项目也会从 iCloud 和您的其他 Apple 设备中移除。';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 项仅在您的图库中',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => '从此设备移除';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 个已备份的项目；您的图库会保留它们',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns => '此设备上的副本将移至其回收站：清空回收站后才会释放空间。';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '删除 $countString 项？',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': '从此设备和您的图库',
      'device': '仅从此设备',
      'other': '从您的图库',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => '不存在';

  @override
  String get deviceFolderCard => 'SD 卡';

  @override
  String get deviceFolderExclude => '排除';

  @override
  String get deviceFolderExcludeThis => '排除此文件夹';

  @override
  String get deviceFolderExcludedNotice => '此项目所在的文件夹已从图库中排除';

  @override
  String get deviceFolderForget => '从列表中移除';

  @override
  String get deviceFolderInternal => '内部存储空间';

  @override
  String get deviceFolderKeep => '保留';

  @override
  String deviceFolderNew(String name, String items) {
    return '新文件夹：$name，$items';
  }

  @override
  String get deviceFolders => '设备文件夹';

  @override
  String get deviceFoldersAll => '显示除已排除以外的所有文件夹';

  @override
  String get deviceFoldersChosen => '仅显示所选文件夹';

  @override
  String get deviceFoldersExcludedNow => '已从图库中排除';

  @override
  String get deviceFoldersSearch => '搜索文件夹';

  @override
  String get diagnosticsAdvanced => '显示诊断';

  @override
  String get diagnosticsAllLoggers => '所有来源';

  @override
  String get diagnosticsCopied => '已复制日志';

  @override
  String get diagnosticsCopy => '复制显示的日志';

  @override
  String get diagnosticsEmpty => '暂无日志';

  @override
  String get diagnosticsExport => '导出诊断包';

  @override
  String get diagnosticsExported => '已保存诊断包';

  @override
  String get diagnosticsLevel => '级别';

  @override
  String get diagnosticsLogger => '来源';

  @override
  String get diagnosticsTitle => '诊断';

  @override
  String get download => '下载';

  @override
  String get downloadCurrent => '当前版本(含编辑)';

  @override
  String get downloadFailed => '无法下载';

  @override
  String get downloadOriginal => '原始版本';

  @override
  String downloadSaved(String name) {
    return '已保存 $name';
  }

  @override
  String get downloadVersion => '哪个版本?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在下载 $countString 项',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => '自动增强';

  @override
  String get editorCrop => '裁剪';

  @override
  String get editorCropOriginal => '原始比例';

  @override
  String get editorCropSquare => '正方形';

  @override
  String get editorEdit => '编辑';

  @override
  String get editorFlip => '翻转';

  @override
  String get editorRotate => '旋转';

  @override
  String get editorSaveCopy => '保存副本';

  @override
  String get editorSaveFailed => '无法保存副本';

  @override
  String get editorSaveVersion => '保存';

  @override
  String get editorSaved => '已另存为副本';

  @override
  String get editorVersionFailed => '无法保存该版本';

  @override
  String get editorVersionSaved => '已保存为新版本';

  @override
  String get editorVersionsUnsupported => '此服务器暂时无法保存已编辑照片的版本';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已撤销 $countString 项更改：服务器拒绝了这些更改。',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => '关闭';

  @override
  String get editsRejectedForbidden => '您可以查看这些项目，但不能更改它们。';

  @override
  String get editsRejectedInvalid => '服务器无法接受这些更改。';

  @override
  String get editsRejectedNotFound => '这些项目已被删除，或不再与您共享。';

  @override
  String get errorNotFound => '此页面不存在';

  @override
  String get errorRetry => '重试';

  @override
  String get errorTitle => '出了点问题';

  @override
  String faceNumber(int number) {
    return '人脸 $number';
  }

  @override
  String get facesAgree => '我同意';

  @override
  String get facesAura => '用 AuraFace 描述人脸（下载更大）';

  @override
  String get facesNotNow => '暂不';

  @override
  String get facesNoticeKeep =>
      '找到的内容与你的照片一起保存在你的设备和服务器上。这些描述绝不会被显示或分享，停止或删除照片时全部删除。';

  @override
  String get facesNoticeOptional => '这是可选的。Photolib 的其他功能无需它也能使用，你可以随时在设置中停止。';

  @override
  String get facesNoticeTitle => '在你的照片中查找人脸？';

  @override
  String get facesNoticeWhat =>
      'Photolib 会在你的照片和视频中查找人脸，并为每张人脸保存其位置和一串描述它的数字，以便再次找到同一个人。这样的描述可能被视为生物识别数据。';

  @override
  String get facesNoticeWhere =>
      '这在此设备上进行；如果你已登录，也会在你自己的服务器上进行。绝不会在由我们或其他任何人运营的服务上进行。';

  @override
  String get facesServerFailed => '无法通知你的服务器。请重试。';

  @override
  String get facesServerOff => '你的服务器不会为你查找人脸';

  @override
  String get facesServerOn => '你的服务器会为你查找人脸';

  @override
  String get facesServerUnavailable => '你的服务器不提供人脸识别';

  @override
  String facesStatusDownloading(int percent) {
    return '正在下载人脸模型：$percent%';
  }

  @override
  String get facesStatusMissing => '你的服务器尚未安装人脸模型';

  @override
  String get facesStatusNoDecoder =>
      '无法查找人脸：未找到图像库 (libvips)。请重新安装 Photolib，或安装 libvips 后重新启动。';

  @override
  String get facesStatusRunning => '正在此设备上查找人脸';

  @override
  String get facesStatusUnavailable => '此设备无法查找人脸';

  @override
  String get facesStatusWaiting => '人脸模型将通过 Wi-Fi 下载';

  @override
  String get facesSwitch => '在我的照片中查找人脸';

  @override
  String get facesSwitchOff => '已关闭。在你同意之前，不会计算任何与人脸有关的内容。';

  @override
  String get facesSwitchOn => '已开启。Photolib 会查找你照片中的人脸。';

  @override
  String get facesTitle => '人脸与人物';

  @override
  String get facesWithdraw => '删除并停止';

  @override
  String get facesWithdrawBody =>
      '这会删除 Photolib 为你找到的所有人脸、描述和人物，包括此设备和你的服务器上的。你的照片不会改变。';

  @override
  String get facesWithdrawTitle => '停止查找人脸？';

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

    return '未更改的文件：$countString';
  }

  @override
  String get folderAllow => '允许访问此文件夹';

  @override
  String get folderDelete => '删除文件夹';

  @override
  String folderDeleteBody(String name) {
    return '要将 $name 中的照片和视频移至回收站吗？';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 个项目',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => '新建文件夹';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '离线，$countString 个项目',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps => '此文件夹或其上级、下级文件夹已在图库中';

  @override
  String get folderRemove => '移除文件夹';

  @override
  String folderRemoveBody(String folder) {
    return '$folder 中的照片和视频将从图库中移除。文件会原样保留在磁盘上。';
  }

  @override
  String get folderRemoveConfirm => '移除';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在扫描，已找到 $countString 个项目',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => '允许访问';

  @override
  String get foldersHideExcluded => '隐藏已排除的文件夹';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib 无法再读取 $countString 个文件夹。',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '显示已排除的文件夹（$countString）';
  }

  @override
  String get foldersUnsupported =>
      '此浏览器无法将文件夹保留为您的图库。请在电脑上使用 Chrome 或 Edge 打开 Photolib，或使用桌面应用。';

  @override
  String get galleryButtons => '按钮';

  @override
  String get galleryChips => '纸片';

  @override
  String get galleryGrid => '网格';

  @override
  String get galleryMenus => '菜单和面板';

  @override
  String get galleryShowSheet => '显示面板';

  @override
  String get galleryTitle => '组件';

  @override
  String hiddenCollections(int count) {
    return '已隐藏（$count）';
  }

  @override
  String get indexingAllowMetered => '使用移动数据下载';

  @override
  String get indexingAllowSaver => '省电模式下也运行';

  @override
  String get indexingBattery => '未充电时所需电量';

  @override
  String get indexingChargingOnly => '仅在充电时';

  @override
  String indexingDownloading(int percent) {
    return '正在下载搜索模型：$percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 张照片无法读取',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => '此设备只为新照片建立索引';

  @override
  String get indexingMissing => '你的服务器尚未安装搜索模型';

  @override
  String get indexingModels => '在此设备上搜索';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '从 $host 下载搜索模型（$megabytesString MB）';
  }

  @override
  String get indexingNoDecoder =>
      '无法搜索和识别文字：未找到图像库 (libvips)。请重新安装 Photolib，或安装 libvips 后重新启动。';

  @override
  String indexingPausedBattery(int percent) {
    return '电池电量低于 $percent% 时暂停';
  }

  @override
  String get indexingPausedCharger => '暂停，直到设备开始充电';

  @override
  String get indexingPausedHeat => '设备过热时暂停';

  @override
  String get indexingPausedSaver => '省电模式开启时暂停';

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

    return '已索引的照片：$doneString / $totalString';
  }

  @override
  String get indexingText => '读取照片中的文字';

  @override
  String indexingTextDownloading(int percent) {
    return '正在下载文字模型：$percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '从 $host 下载文字模型（$megabytesString MB），可按照片中的文字查找';
  }

  @override
  String get indexingTextMissing => '您的服务器尚未安装文字模型';

  @override
  String get indexingTextPlatform => '使用手机自带的文字识别，无需下载。读取新照片';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '已读取文字的照片：$doneString / $totalString';
  }

  @override
  String get indexingTextUnavailable => '此处无法读取文字';

  @override
  String get indexingTextWaiting => '文字模型仅通过 Wi-Fi 下载';

  @override
  String get indexingUnavailable => '此设备上的搜索在这里不可用';

  @override
  String get indexingWaiting => '搜索模型将通过 Wi-Fi 下载';

  @override
  String get infoAddName => '添加姓名';

  @override
  String get infoAddTag => '添加标签';

  @override
  String get infoAlbums => '相册';

  @override
  String get infoAllMetadata => '查看所有元数据';

  @override
  String get infoAuto => '自动';

  @override
  String get infoBackedUp => '已备份';

  @override
  String get infoCamera => '相机';

  @override
  String get infoChangeAdjust => '已调整颜色';

  @override
  String get infoChangeCrop => '已裁剪';

  @override
  String get infoChangeFlip => '已镜像';

  @override
  String get infoChangeInpaint => '已填充区域';

  @override
  String get infoChangeLocal => '已调整区域';

  @override
  String get infoChangeLut => '已应用色彩风格';

  @override
  String get infoChangeOther => '已编辑';

  @override
  String get infoChangeTurn => '已旋转';

  @override
  String get infoCompare => '与原图比较';

  @override
  String infoConfidence(String percent) {
    return '可信度：$percent';
  }

  @override
  String get infoCopyPath => '复制路径';

  @override
  String get infoCurrent => '当前';

  @override
  String get infoDescription => '添加说明';

  @override
  String get infoEditDate => '编辑日期';

  @override
  String infoEditNumber(int number) {
    return '编辑 $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '$name 的编辑副本';
  }

  @override
  String get infoFaces => '人脸';

  @override
  String get infoFile => '文件';

  @override
  String get infoFromFileName => '来自文件名';

  @override
  String get infoHistory => '编辑历史记录';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => '位置';

  @override
  String get infoMap => '拍摄地点地图';

  @override
  String get infoMapAgree => '地图图块来自互联网，会透露你查看的区域';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return '新标签：$path';
  }

  @override
  String get infoNoAlbum => '不在任何相册中';

  @override
  String get infoOnDevice => '在此设备上';

  @override
  String get infoOriginal => '原图';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString 像素';
  }

  @override
  String infoRemoveFrom(String album) {
    return '从$album中移除';
  }

  @override
  String infoRemoveTag(String tag) {
    return '移除$tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return '已从$album中移除';
  }

  @override
  String get infoRevert => '还原';

  @override
  String get infoSaveCopy => '另存为副本';

  @override
  String get infoShared => '已共享';

  @override
  String get infoShowFaces => '在照片上显示人脸';

  @override
  String get infoShowMap => '显示地图';

  @override
  String get infoTags => '标签';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个版本',
    );
    return '$_temp0 · 最近 $time';
  }

  @override
  String get infoWhy => '为什么是这个日期？';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': '从文件的 $tag 读取',
      'name': '从文件名读取',
      'folder': '从文件夹名称读取',
      'host': '由文件来源服务提供',
      'unknown': '文件中没有任何日期信息，因此使用其最后修改日期',
      'other': '文件尚未读取，因此使用设备提供的日期',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {'true': '列表', 'other': '网格'});
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': '名称',
      'taken': '拍摄日期',
      'modified': '修改日期',
      'size': '大小',
      'random': '随机',
      'extension': '类型',
      'custom': '相册顺序',
      'other': '拍摄日期',
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
  String get languageDevice => '设备语言';

  @override
  String get languageName => '简体中文';

  @override
  String get libraryAddFolder => '添加文件夹';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '未备份',
      'backed_up': '已备份',
      'cloud_only': '仅在云端',
      'other': '全部',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '全部已备份',
      'backed_up': '尚无已备份的项目',
      'cloud_only': '没有仅在服务器上的项目',
      'other': '此处没有内容',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => '备份标记';

  @override
  String get libraryEmpty => '您的照片将显示在这里';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': '按周分组',
      'month': '按月分组',
      'other': '按天分组',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => '再次隐藏已隐藏和已归档的项目';

  @override
  String get libraryNoKeyring =>
      'Photolib 将图库的密钥保存在系统密钥环中，但密钥环未运行或已锁定。请启动或解锁 GNOME Keyring 或 KWallet 等密钥环，然后重试。';

  @override
  String get libraryRevealExcluded => '显示已排除的文件夹 5 分钟';

  @override
  String get libraryShowVeiled => '显示已隐藏和已归档的项目 5 分钟';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': '最近添加',
      'other': '拍摄日期',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed => 'Photolib 无法打开此设备上保存的图库';

  @override
  String get libraryViewOptions => '视图选项';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '正在准备缩略图：$doneString/$totalString';
  }

  @override
  String get libraryZoomIn => '较大的缩略图';

  @override
  String get libraryZoomOut => '较小的缩略图';

  @override
  String get mapAddTrack => '添加 GPX 轨迹';

  @override
  String get mapArea => '地图区域';

  @override
  String get mapAttribution => '© OpenStreetMap 贡献者';

  @override
  String get mapClearLasso => '清除选择';

  @override
  String get mapEmpty => '还没有带位置的照片';

  @override
  String get mapHeat => '热力图';

  @override
  String get mapLasso => '围绕照片画圈选择';

  @override
  String get mapLoading => '正在把照片放到地图上';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '照片：$countString';
  }

  @override
  String get mapSearchHere => '搜索此区域';

  @override
  String get mapSplit => '在地图下方显示照片';

  @override
  String get mapTilesAgree =>
      '地图背景来自 OpenStreetMap 的服务器 (tile.openstreetmap.org)，该服务器会知道你查看的区域';

  @override
  String get mapTilesShow => '显示背景';

  @override
  String get mapTime => '时间范围';

  @override
  String get mapTitle => '地图';

  @override
  String get mapTrackBad => '该文件中没有 GPX 轨迹';

  @override
  String get mapTrips => '旅程';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': '已收藏',
      'hidden': '已隐藏',
      'archived': '已归档',
      'offline': '已保留在此设备',
      'offline': '已保留在此设备',
      'offline': '已保留在此设备',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => '允许访问';

  @override
  String get mediaAccessNone => 'Photolib 需要访问您的照片和视频才能显示它们。';

  @override
  String get mediaAccessPartial =>
      'Photolib 只能看到您选择的照片和视频。要用作图库，需要允许访问所有照片和视频。';

  @override
  String get mediaAccessSelect => '选择更多照片';

  @override
  String get nameLabel => '名称';

  @override
  String get nextAddRoot => '在服务器配置的 external_roots 中添加该文件夹，然后重启服务器。';

  @override
  String get nextAskAdmin => '请询问你的服务器管理员。';

  @override
  String get nextAskOwner => '请图库的所有者允许你添加照片。';

  @override
  String get nextCheckConnection => '检查连接以了解原因。';

  @override
  String get nextCheckEntry => '检查你输入的内容后重试。';

  @override
  String get nextConfirm => '检查受影响的项目数量，然后确认。';

  @override
  String get nextDeleteWebhook => '删除一个不再使用的 Webhook，然后再试一次。';

  @override
  String get nextEditConfig => '在服务器配置中更改它，然后重启服务器。';

  @override
  String get nextFreeSpace => '释放一些空间，或请管理员增加空间。';

  @override
  String get nextNewLink => '请管理员给你一个新的。';

  @override
  String get nextNewestToken => '从 photolibd 的日志中复制最新的令牌。';

  @override
  String get nextOtherAdmin => '先将另一个账号设为管理员。';

  @override
  String get nextOtherFolder => '选择一个独立的文件夹。';

  @override
  String get nextRefresh => '刷新后重试。';

  @override
  String get nextReport => '再试一次。如果再次发生，请复制下面的详细信息给管理员。';

  @override
  String get nextSetUpPrivate => '在设置中完成私密图库的设置，然后重试。';

  @override
  String get nextSignIn => '重新登录。';

  @override
  String get nextSignInAccount => '用你的账号登录后重试。';

  @override
  String get nextSignInInstead => '请改为登录。';

  @override
  String get nextTryAgain => '再试一次。';

  @override
  String get nextUpdateAndAgree => '请更新应用，然后再次同意须知。';

  @override
  String get nextUseAnother => '选择另一个。';

  @override
  String get nextUseHttps => '使用服务器的 https:// 地址，或从服务器所在的网络连接。';

  @override
  String get nextWait => '等一分钟后再试。';

  @override
  String get offlineKeep => '离线保留';

  @override
  String offlineKeepHere(String size) {
    return '保留在此设备（$size）';
  }

  @override
  String get offlineKeptHere => '已保留在此设备';

  @override
  String get offlineStopKeeping => '停止离线保留';

  @override
  String get otherFiles => '其他文件';

  @override
  String get passphraseCreate =>
      '这台电脑没有运行可保存 Photolib 密钥的钥匙环（Secret Service）。请设置一个至少 10 个字符的密码短语来保护它们：Photolib 每次启动时都会询问。';

  @override
  String get passphraseLabel => '密码短语';

  @override
  String get passphraseMismatch => '两次输入的密码短语不一致。';

  @override
  String get passphraseRepeat => '再次输入密码短语';

  @override
  String get passphraseTooShort => '请至少使用 10 个字符。';

  @override
  String get passphraseUnlock => '请输入在这台电脑上保护 Photolib 密钥的密码短语。';

  @override
  String get passphraseWrong => '密码短语错误，请重试。';

  @override
  String photoPosition(int index, int count) {
    return '第 $index 张照片，共 $count 张';
  }

  @override
  String get privacyCheckKit => '检查恢复套件';

  @override
  String get privacyDrillDue => '该进行恢复演练了：请确认你的恢复套件仍能解锁你的私密图库。';

  @override
  String get privacyHonest =>
      '私密图库在你的设备上加密，其他任何人都无法打开：服务器不能，服务器管理员不能，Photolib 的开发者也不能。如果你同时丢失了密码和恢复套件，你的照片将永久丢失，任何人都无法为你找回。';

  @override
  String get privacyKitBody =>
      '请按顺序把这 24 个单词写在纸上，并存放在安全的地方。如果你忘记密码，它们可以解锁你的私密图库；任何拿到它们的人也可以。';

  @override
  String get privacyKitDone => '你的恢复套件有效。';

  @override
  String get privacyKitOther => '这不是你当前的恢复套件。';

  @override
  String get privacyKitTitle => '你的恢复套件';

  @override
  String get privacyKitUnverified => '恢复套件尚未验证';

  @override
  String privacyKitVerified(String date) {
    return '恢复套件已于 $date 验证';
  }

  @override
  String get privacyKitWritten => '我已写下';

  @override
  String get privacyNotReady => '在你拥有两种解锁方式并验证恢复套件之前，私密上传保持关闭。';

  @override
  String get privacyPasswordHelp => '输入你的账户密码：它将成为解锁私密图库的一种方式。';

  @override
  String get privacyPhrase => '恢复短语';

  @override
  String get privacyPhraseHelp => '你的恢复套件中的 24 个单词';

  @override
  String get privacyPhraseInvalid => '这不是恢复短语。请检查每个单词。';

  @override
  String get privacyReady => '私密上传已开启。';

  @override
  String get privacyRecoveryKit => '恢复套件';

  @override
  String get privacySetUp => '设置';

  @override
  String get privacyShowWords => '再次显示单词';

  @override
  String get privacyTitle => '私密图库';

  @override
  String privacyUnknownWord(int number) {
    return '第 $number 个单词不是恢复套件中的单词。';
  }

  @override
  String get privacyVerify => '验证';

  @override
  String get privacyVerifyBody => '输入恢复套件中的这些单词，以证明你已保存它。';

  @override
  String get privacyWays => '解锁方式';

  @override
  String privacyWord(int number) {
    return '单词 $number';
  }

  @override
  String get privacyWordsDiffer => '这些单词与你的恢复套件不符。请检查你写下的内容。';

  @override
  String get privacyWrongPassword => '这不是你的账户密码。';

  @override
  String get problemAdminOnly => '只有管理员可以执行此操作。';

  @override
  String get problemBusy => '服务器繁忙或正在重启。';

  @override
  String get problemChanged => '这在此期间已被更改。';

  @override
  String get problemConfirm => '这将隐藏或删除的项目多于服务器无需确认即可处理的数量';

  @override
  String get problemContribute => '你不能向此图库添加照片。';

  @override
  String get problemCopy => '复制详细信息';

  @override
  String get problemDetails => '详细信息';

  @override
  String get problemDiskLow => '服务器磁盘快满了，上传已暂停。';

  @override
  String get problemEmailTaken => '另一个账号已使用此电子邮件。';

  @override
  String get problemExists => '它已存在。';

  @override
  String get problemFaceNotice => '你的服务器要求比此应用所显示的更新版本的人脸须知。';

  @override
  String get problemGone => '它已不在服务器上。';

  @override
  String get problemHandleTaken => '另一个账号已使用此登录名。';

  @override
  String get problemInterrupted => '上传已中断。';

  @override
  String get problemInvalid => '有一个值无效';

  @override
  String get problemLastAdmin => '服务器至少需要一名管理员。';

  @override
  String get problemLinkInvalid => '此链接已过期或已被使用。';

  @override
  String get problemLoginFailed => '电子邮件、登录名或密码错误。';

  @override
  String get problemMaintenanceKey => '只有登录后才能暂停备份、完整性校验和彻底删除，使用 API 密钥则不行';

  @override
  String get problemNotAllowed => '你的账号不能执行此操作。';

  @override
  String get problemNotExternal => '只有服务器自身文件夹中的图库才能扫描。';

  @override
  String get problemOidcClaim => '你的登录服务没有以此服务器接受的方式说明你是谁。';

  @override
  String get problemOidcDown => '你的登录服务没有响应服务器。';

  @override
  String get problemOidcFailed => '你的登录服务拒绝了登录。';

  @override
  String get problemOidcNotAllowed => '你的账号不能用这种方式登录。';

  @override
  String get problemOidcTaken => '此登录已关联到另一个 Photolib 账号。';

  @override
  String get problemOidcUnknown => '此服务器不再提供这种登录方式。';

  @override
  String get problemPasskeysOff => '服务器有了公开地址后，通行密钥才能使用。';

  @override
  String get problemPinned => '此项在配置文件中设定，无法在此更改。';

  @override
  String get problemPolicyOff => '此服务器已关闭此功能。';

  @override
  String get problemQuota => '你在服务器上的存储空间已满。';

  @override
  String get problemRestoreKey => '只有登录后才能恢复备份，使用 API 密钥则不行。';

  @override
  String get problemRootDiffers => '此文件夹不包含此图库的文件';

  @override
  String get problemRootNotAllowed => '此文件夹不在服务器配置的 external_roots 之下';

  @override
  String get problemRootOverlaps => '此文件夹包含或位于另一个图库或服务器自身的数据中';

  @override
  String get problemScanning => '此图库已在扫描中';

  @override
  String get problemSecondFactor =>
      '此账户需要第二重验证，例如验证器代码或通行密钥，但此版本的 Photolib 尚无法提供。';

  @override
  String get problemSetupDone => '此服务器已有管理员。';

  @override
  String get problemSetupExpired => '用时太长。';

  @override
  String get problemSetupToken => '此设置令牌不正确。';

  @override
  String get problemSignedOut => '你已从服务器退出登录。';

  @override
  String get problemStepUp => '此更改需要先输入密码或代码。';

  @override
  String get problemStorage => '服务器无法访问其存储。';

  @override
  String get problemTooMany => '短时间内尝试次数过多。';

  @override
  String get problemUnexpected => '发生了意外问题。';

  @override
  String get problemUnreachable => '服务器没有响应。';

  @override
  String get problemUploadDamaged => '文件在传输途中被更改或损坏。';

  @override
  String get problemUploadExpired => '服务器上已没有此上传：未完成的上传一天后过期。';

  @override
  String get problemWebhookLimit => '你的账号已达到可拥有的 Webhook 数量上限。';

  @override
  String get problemWebhooksOff => '此服务器已关闭 Webhook。';

  @override
  String get recoveryCode => '恢复码';

  @override
  String get recoveryCodeAbout => '如果密钥库丢失了密钥，可用它打开此设备上的 Photolib 存储';

  @override
  String get recoveryCodeEnter => '输入恢复码';

  @override
  String get recoveryCreate => '创建恢复码';

  @override
  String get recoveryLater => '以后';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 项更改仅存在于此设备上。如果密钥库丢失了 Photolib 的密钥，恢复码可以找回它们。',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      '请写下这 24 个单词并妥善保管：没有密钥库中的密钥，它们也能打开此设备上的 Photolib 存储。它们会替换之前的任何恢复码。';

  @override
  String get recoveryUnlock => '解锁';

  @override
  String get recoveryWrong => '这不是此存储的恢复码';

  @override
  String get renameFind => '查找';

  @override
  String get renamePattern => '新名称';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': '太长：名称最多 255 字节',
      'invalid': '不是有效的文件名',
      'duplicate': '也分配给了另一个文件',
      'exists': '此文件夹中的另一个文件已使用此名称',
      'other': '无法重命名',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => '替换为';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '已重命名的文件：$countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': '在访达中显示',
      'windows': '在资源管理器中显示',
      'other': '在文件夹中显示',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => '相机';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 个项目',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => '日期';

  @override
  String searchDays(String first, String last) {
    return '$first至$last';
  }

  @override
  String get searchEmpty => '搜索图库';

  @override
  String get searchFavourites => '收藏';

  @override
  String get searchFolder => '文件夹';

  @override
  String get searchHint => '文件名或文件夹名';

  @override
  String get searchMotionPhotos => '动态照片';

  @override
  String get searchNothing => '没有匹配的结果';

  @override
  String get searchPanoramas => '全景照片';

  @override
  String get searchPhotos => '照片';

  @override
  String get searchScreenshots => '屏幕截图';

  @override
  String get searchVideo => '视频';

  @override
  String get searchVideos => '视频';

  @override
  String get securityAddPasskey => '添加通行密钥';

  @override
  String get securityCode => '代码';

  @override
  String get securityCodesHelp => '请将这些代码保存在安全的地方。每个代码可代替第二重验证使用一次，且只在此时显示。';

  @override
  String securityCodesLeft(int count) {
    return '未使用：$count';
  }

  @override
  String get securityNewCodes => '新代码';

  @override
  String get securityPasskeyNotAdded => '未添加通行密钥。';

  @override
  String get securityRecoveryCodes => '恢复代码';

  @override
  String get securityRemovePasskey => '移除通行密钥';

  @override
  String get securitySetUp => '设置';

  @override
  String get securityStepUpBody => '请输入密码、验证器应用中的代码或恢复代码，以更改第二重验证。';

  @override
  String get securityStepUpTitle => '确认是你本人';

  @override
  String get securityTitle => '第二重验证';

  @override
  String get securityTotp => '验证器应用';

  @override
  String get securityTotpHelp => '将此密钥添加到验证器应用，然后输入它显示的代码。';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': '已开启', 'other': '已关闭'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => '关闭';

  @override
  String get securityWrongCode => '代码不正确。';

  @override
  String get securityWrongProof => '密码或代码不正确。';

  @override
  String get selectAll => '全选';

  @override
  String get selectionClear => '取消选择';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选择 $countString 项',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => '显示所选项';

  @override
  String get serverAccount => '电子邮件或登录名';

  @override
  String get serverAdd => '添加服务器';

  @override
  String get serverAddressInvalid => '请输入地址，例如 photos.example.org';

  @override
  String get serverAddresses => '地址';

  @override
  String get serverAddressesHelp =>
      '每行一个：你网络中、互联网上或通过 VPN 访问的服务器。应用会使用响应最快的地址。 或粘贴你收到的设置密码链接。';

  @override
  String get serverCa => '私有 CA 证书（PEM）';

  @override
  String get serverCaChoose => '选择证书文件';

  @override
  String serverCertificateBody(String host) {
    return '$host 提供的证书不受此设备信任。只有当此 SHA-256 指纹属于你的服务器时才信任它：';
  }

  @override
  String get serverCertificateTitle => '信任此证书？';

  @override
  String get serverConfirm => '确认';

  @override
  String get serverConnect => '连接';

  @override
  String get serverCreateAdmin => '创建管理员';

  @override
  String get serverEnded => '服务器已结束此会话。请重新登录。';

  @override
  String get serverHandleHelp => '小写字母、数字、点、连字符和下划线；创建后无法更改。';

  @override
  String get serverHeaders => '自定义标头';

  @override
  String get serverHeadersHelp => '每行一个，格式为 Name: value；仅通过 HTTPS 发送';

  @override
  String get serverHeadersInvalid => '请按 Name: value 格式写每个标头';

  @override
  String get serverIdentity => '客户端证书（PKCS#12）';

  @override
  String get serverIdentityChoose => '选择客户端证书';

  @override
  String get serverIdentityInvalid => '这不是证书（PKCS#12），或者其密码错误。';

  @override
  String get serverIdentityPassword => '客户端证书密码';

  @override
  String get serverLoading => '正在读取此设备上保存的服务器';

  @override
  String get serverNearby => '此网络上的服务器';

  @override
  String get serverNeedsHttps =>
      '此服务器需要 HTTPS 地址：在本地网络之外，Photolib 不会通过普通 HTTP 登录。';

  @override
  String get serverNoSignIn => '此服务器不提供此版本 Photolib 支持的登录方式。';

  @override
  String get serverOffline => '服务器没有响应。你仍保持登录。';

  @override
  String get serverPasskeyFailed => '未使用通行密钥。请重试，或使用代码。';

  @override
  String get serverPasskeyRequired => '此服务器需要通行密钥，但此版本的 Photolib 尚不支持。';

  @override
  String get serverPassword => '密码';

  @override
  String get serverPasswordAgain => '再次输入密码';

  @override
  String get serverPasswordSetupInvalid => '此密码设置令牌错误、已使用或已过期。请索取新的令牌。';

  @override
  String get serverPasswordSetupToken => '密码设置令牌';

  @override
  String get serverPasswordSetupTokenHelp =>
      '由管理员提供，或由服务器上的 photolibd admin password-setup 打印。';

  @override
  String get serverPasswordsDiffer => '两次输入的密码不一致。';

  @override
  String get serverPrivateLibrariesBody =>
      '新密码无法打开它们。请使用恢复套件、通行密钥或仍处于登录状态的设备重新打开。';

  @override
  String get serverPrivateLibrariesGo => '设置密码';

  @override
  String get serverPrivateLibrariesTitle => '你的私密图库仍保持锁定';

  @override
  String get serverProxy => 'HTTP 代理，格式为 host:port';

  @override
  String get serverProxyInvalid => '请按 host:port 格式输入代理';

  @override
  String get serverRecoveryCode => '恢复代码';

  @override
  String get serverRemove => '移除此服务器';

  @override
  String get serverRequired => '必填';

  @override
  String get serverSecondFactor => '此账户的第二重验证是通行密钥，但此版本的 Photolib 尚不支持。';

  @override
  String get serverSecondFactorCode => '此账户还需要验证器应用中的代码或恢复代码。';

  @override
  String get serverSecondFactorTitle => '确认是你本人';

  @override
  String get serverSecondFactorWrong => '未成功。尝试五次后，请重新登录。';

  @override
  String get serverSetPassword => '设置密码';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '$server 上的 $handle';
  }

  @override
  String get serverSetPasswordOpen => '设置密码';

  @override
  String get serverSetPasswordTitle => '设置你的密码';

  @override
  String get serverSetUp => '设置新服务器';

  @override
  String get serverSetupLinkElsewhere =>
      '要使用此设置链接，请先退出此服务器；如果链接属于另一台服务器，请移除此服务器。';

  @override
  String get serverSetupTitle => '设置服务器';

  @override
  String get serverSetupToken => '设置令牌';

  @override
  String get serverSetupTokenHelp => '服务器没有管理员时，photolibd 会将其写入日志；每次启动都会写入新令牌。';

  @override
  String get serverSignIn => '登录';

  @override
  String get serverSignOut => '退出登录';

  @override
  String serverSignedInAs(String account) {
    return '已以 $account 身份登录';
  }

  @override
  String get serverSignedOut => '已退出登录';

  @override
  String get serverSwitch => '切换账号';

  @override
  String get serverTotpCode => '身份验证器应用中的代码';

  @override
  String get serverTrust => '信任';

  @override
  String get serverUnreadable => '无法读取此设备上保存的服务器';

  @override
  String get serverUsePasskey => '使用通行密钥';

  @override
  String get serverUseRecoveryCode => '改用恢复代码';

  @override
  String get settingsBackground => '透明图片的背景';

  @override
  String get settingsDateFormat => '日期格式';

  @override
  String get settingsDefaultTab => '文件夹和相册默认打开';

  @override
  String get settingsFolders => '文件夹';

  @override
  String get settingsIndexing => '在此设备上建立索引';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLibrary => '图库';

  @override
  String get settingsServer => '服务器';

  @override
  String get settingsStart => '启动画面';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsTitle => '设置';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': '点按左侧或右侧边缘以查看上一项或下一项',
      'oneFingerZoom': '点按两次并拖动以单指缩放',
      'swipes': '在视频左侧上下滑动调节亮度，右侧调节音量',
      'maxBrightness': '查看时使用最高亮度',
      'autoRotate': '按每张照片或每个视频的方向旋转',
      'mixAudio': '视频与其他音频同时播放，而不暂停它',
      'autoplay': '打开视频时自动播放',
      'loop': '循环播放视频',
      'autoNext': '视频结束后转到下一项',
      'resume': '从上次离开处继续播放视频',
      'other': '在网格中播放动态图片',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep => 'Photolib 在回收站中保留项目的时间';

  @override
  String get settingsViewerBar => '查看器栏中的按钮';

  @override
  String get settingsViewing => '查看';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 个共享的照片和视频正在等待 Photolib 获准添加到您的照片图库。未保存的项目将在 7 天后删除。',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge => '一次分享的内容过大：请少选一些项目';

  @override
  String shareTooMany(int count) {
    return '一次分享的项目过多：请最多选择 $count 项';
  }

  @override
  String get shortcutsTitle => '键盘快捷键';

  @override
  String get slideshow => '幻灯片放映';

  @override
  String get slideshowLoop => '重复';

  @override
  String get slideshowOptions => '幻灯片放映选项';

  @override
  String get slideshowSeconds => '每项秒数';

  @override
  String get slideshowShuffle => '随机顺序';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': '降序',
      'other': '升序',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => '此设备';

  @override
  String sourceHide(String name) {
    return '隐藏$name';
  }

  @override
  String get sourceHideOthers => '隐藏此处其他所有内容';

  @override
  String get sourceLost => '无访问权限';

  @override
  String get sourcePartly => '部分显示';

  @override
  String sourceShow(String name) {
    return '显示$name';
  }

  @override
  String get sourceShowEverything => '显示此处所有内容';

  @override
  String get sourceShowOnly => '仅显示此项';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': '时间线',
      'folders': '文件夹和相册',
      'favourites': '收藏',
      'other': '时间线',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => '离线保留某个人物';

  @override
  String get storageBudget => '存储上限';

  @override
  String get storageClear => '移除离线副本';

  @override
  String get storageClearAction => '移除';

  @override
  String storageClearBody(String size) {
    return '这将移除此设备上保留的 $size，并停止离线保留相册、搜索和照片。服务器上的资料库不受影响。';
  }

  @override
  String get storageKeepLibrary => '保留整个资料库';

  @override
  String get storageKeepOriginals => '同时保留原图';

  @override
  String get storageNoPeople => '还没有已命名的人物。';

  @override
  String get storageNoPins => '没有固定任何内容。固定相册、搜索或照片即可离线保留。';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '相册',
      'search': '搜索',
      'person': '人物',
      'library': '整个资料库',
      'asset': '照片',
      'other': '已固定',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return '超出上限：还需要 $size';
  }

  @override
  String get storagePinNothing => '无需下载：其中的照片已在此设备上';

  @override
  String get storagePinPaused => '等待中：此预设不离线保留任何内容';

  @override
  String get storagePinPlanning => '正在确定要保留的内容…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return '正在下载：$haveString / $filesString';
  }

  @override
  String storagePinReady(String size) {
    return '可离线使用（$size）';
  }

  @override
  String get storagePinWaiting => '联网后将下载';

  @override
  String get storagePins => '离线保留';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '仅目录',
      'spaceSaver': '节省空间',
      'travel': '所选相册离线',
      'everything': '全部',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '不保留任何内容；打开照片时从服务器加载。',
      'spaceSaver': '在上限内按从新到旧保留整个资料库的预览。',
      'travel': '只保留您固定的内容：相册、搜索和照片。',
      'everything': '在上限内按从新到旧保留整个资料库的原图。',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => '此设备保留的内容';

  @override
  String get storageSubtitle => '离线副本和存储上限';

  @override
  String get storageTitle => '存储';

  @override
  String storageUsed(String used, String budget) {
    return '已用 $used，上限 $budget';
  }

  @override
  String get storageWebNote => '浏览器只保留预览，退出登录时会清除。';

  @override
  String get storeNoKeyring =>
      'Photolib 将其本地存储的密钥保存在系统密钥环中，但密钥环没有响应。请安装并解锁 gnome-keyring、KWallet 或 KeePassXC，并开启其 Secret Service，然后重试。';

  @override
  String get storeNoKeystore => 'Photolib 无法访问此设备的密钥库，其中保存着其本地存储的密钥。';

  @override
  String get storeRebuilt =>
      '此设备的密钥库中已没有 Photolib 本地存储的密钥，因此已重建该存储。其设置以及仅存在于此设备上的内容已丢失；资料库会重新同步，缩略图会恢复。';

  @override
  String get storeRecoveryNeeded =>
      '此设备的密钥库中已没有 Photolib 本地存储的密钥。请输入其恢复码，或重置存储并丢失仅存在于此设备上的内容。';

  @override
  String get storeReset => '重置存储';

  @override
  String get storeResetBody => '仅存在于此设备上的内容将丢失；资料库会重新同步，缩略图会恢复。';

  @override
  String get storeUnavailable => '此设备上的存储不可用：设置和合集不会保留';

  @override
  String get tabCollections => '合集';

  @override
  String get tabLibrary => '图库';

  @override
  String get tabSearch => '搜索';

  @override
  String get themeDark => '深色';

  @override
  String get themeLight => '浅色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get timelineBenchmark => '时间线基准测试';

  @override
  String get timelineBenchmarkCopy => '复制结果';

  @override
  String get timelineCannotPlay => '无法在此浏览器中播放';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date，第 $position 项，共 $count 项';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date，第 $position 项，共 $count 项，无预览';
  }

  @override
  String get timelineExcluded => '位于已排除的文件夹中';

  @override
  String get timelineScrubber => '按日期滚动';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => '日期未知';

  @override
  String timelineWeek(String date) {
    return '$date 起的一周';
  }

  @override
  String toolbarAdd(String action) {
    return '将$action添加到栏中';
  }

  @override
  String toolbarDown(String action) {
    return '下移$action';
  }

  @override
  String get toolbarInBar => '在栏中';

  @override
  String get toolbarInMenu => '在 ⋮ 菜单中';

  @override
  String toolbarRemove(String action) {
    return '从栏中移除$action';
  }

  @override
  String get toolbarReset => '恢复默认';

  @override
  String toolbarUp(String action) {
    return '上移$action';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': '移动到此处',
      'other': '复制到此处',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': '已存在同名文件或文件夹',
      'changed': '副本与原文件不一致，已删除',
      'cancelled': '已取消',
      'invalid': '不是有效的文件夹名称',
      'other': '失败',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => '最近';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '要永久删除 $countString 项吗？此操作无法撤销。',
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
      other: '还剩 $daysString 天',
      zero: '今天将被永久删除',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => '回收站是空的';

  @override
  String get trashEmptyAll => '清空回收站';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString 天';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已将 $countString 项移至回收站',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => '从列表中移除';

  @override
  String trashRetention(int days) {
    return 'Photolib 会在 $days 天后永久删除回收站中的内容；每一项都会显示剩余时间。';
  }

  @override
  String get trashTitle => '回收站';

  @override
  String get undo => '撤销';

  @override
  String get uploadAction => '上传照片和视频';

  @override
  String get uploadClear => '清除';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '已上传 $doneString/$totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '失败：$countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已归档 $countString 项',
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
      other: '已隐藏 $countString 项',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': '黑色',
      'white': '白色',
      'other': '棋盘格',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => '无法在此设备上播放此视频';

  @override
  String get viewerCaptions => '字幕';

  @override
  String get viewerCompass => '指南针锁定';

  @override
  String get viewerCopy => '复制';

  @override
  String get viewerCopyText => '复制文字';

  @override
  String get viewerCustomize => '自定义工具栏…';

  @override
  String get viewerDial => '方向。点击可朝向正前方。拖动可环视，滚动或双指缩放可缩放，双击可重置';

  @override
  String get viewerFilmstrip => '胶片栏';

  @override
  String get viewerFirst => '第一项';

  @override
  String get viewerFisheye => '鱼眼';

  @override
  String get viewerGyroscope => '移动设备以环顾四周';

  @override
  String get viewerHdr => '以 HDR 显示';

  @override
  String get viewerInfo => '信息';

  @override
  String get viewerInfoLoading => '正在加载此项目的信息';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '第 $positionString 项，共 $countString 项';
  }

  @override
  String get viewerLast => '最后一项';

  @override
  String get viewerLenses => '选择镜头';

  @override
  String get viewerMap => '地图';

  @override
  String get viewerMotion => '播放动态效果';

  @override
  String get viewerMotionDenied => '此浏览器未允许访问运动传感器';

  @override
  String get viewerMotionMissing => '此设备没有陀螺仪，无法环顾四周';

  @override
  String get viewerMute => '静音';

  @override
  String get viewerNext => '下一项';

  @override
  String get viewerNextFrame => '下一帧';

  @override
  String get viewerPause => '暂停';

  @override
  String get viewerPlanet => '小行星';

  @override
  String get viewerPlay => '播放';

  @override
  String get viewerPrevious => '上一项';

  @override
  String get viewerPreviousFrame => '上一帧';

  @override
  String get viewerRotate => '旋转';

  @override
  String get viewerSdr => '以 SDR 显示';

  @override
  String get viewerSeek => '位置';

  @override
  String get viewerSetAs => '设置为';

  @override
  String get viewerShare => '分享';

  @override
  String get viewerSpeed => '播放速度';

  @override
  String get viewerSphere => '360° 视图。拖动以环顾四周，双指缩放';

  @override
  String get viewerText => '此照片中的文字';

  @override
  String get viewerTextCopied => '文字已复制';

  @override
  String get viewerTextNone => '此照片中未找到文字';

  @override
  String get viewerTextUnread => '此照片的文字尚未识别';

  @override
  String get viewerUnmute => '取消静音';

  @override
  String get viewerZoomIn => '放大';

  @override
  String get viewerZoomOut => '缩小';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD 卡',
      'other': '内部存储',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => '放大';

  @override
  String get zoomOut => '缩小';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get actionAddToAlbum => '新增至相簿';

  @override
  String get actionArchive => '封存';

  @override
  String get actionCopyTo => '複製到…';

  @override
  String get actionDeleteForever => '永久刪除';

  @override
  String get actionFavourite => '加入最愛';

  @override
  String get actionHide => '隱藏';

  @override
  String get actionMoveTo => '移動到…';

  @override
  String get actionRename => '重新命名';

  @override
  String get actionRestore => '復原';

  @override
  String get actionShare => '分享';

  @override
  String get actionTrash => '移至垃圾桶';

  @override
  String get actionUnarchive => '取消封存';

  @override
  String get actionUndo => '復原';

  @override
  String get actionUnfavourite => '從最愛中移除';

  @override
  String get actionUnhide => '取消隱藏';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': '已啟用',
      'disabled': '已停用',
      'invited': '已邀請',
      'deleted': '已刪除',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => '帳戶';

  @override
  String get adminAddAccount => '新增帳戶';

  @override
  String get adminAddExternalLibrary => '新增外部圖庫';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '已嘗試 $attempts 次',
      zero: '尚未執行',
    );
    return '$status，$_temp0';
  }

  @override
  String get adminAudit => '稽核記錄';

  @override
  String get adminBackUpNow => '立即備份';

  @override
  String get adminBackupQueued => '備份已加入佇列，接著會進行還原演練';

  @override
  String get adminBackups => '資料庫備份';

  @override
  String get adminCancelJob => '取消工作';

  @override
  String get adminCapabilities => '功能';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': '代管圖庫',
      'uploads': '來自裝置、網頁和 CLI 的上傳',
      'folder_browser': '資料夾瀏覽',
      'device_folders': '已連線應用程式中的裝置資料夾',
      'sharing': '分享和公開連結',
      'edits': '編輯',
      'deletes': '刪除',
      'xmp_writes': '寫入 XMP 附屬檔案',
      'face_recognition': '臉孔辨識',
      'ml_search': '智慧搜尋',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': '正常',
      'warn': '警告',
      'fail': '失敗',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => '已複製';

  @override
  String get adminCopyBundle => '複製診斷資訊以回報錯誤';

  @override
  String get adminCopyLink => '複製連結';

  @override
  String get adminDelete => '刪除';

  @override
  String get adminDeviceBackups => '裝置備份';

  @override
  String get adminDevices => '你的裝置';

  @override
  String get adminDisable => '停用';

  @override
  String adminDrillFailed(String detail) {
    return '上次還原演練失敗：$detail';
  }

  @override
  String get adminEdit => '編輯';

  @override
  String get adminEmail => '電子郵件';

  @override
  String get adminEnable => '啟用';

  @override
  String get adminErrorSignIn => '請以管理員身分登入';

  @override
  String get adminFacesDefault => '新帳戶預設開啟臉孔辨識';

  @override
  String get adminFiles => '各類型檔案';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': '已損壞',
      'missing': '遺失',
      'size': '大小不符',
      'hash': '已被取代',
      'orphan': '孤立檔案',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '可用空間 $size';
  }

  @override
  String get adminFreeDisk => '可用磁碟空間低於此百分比（0 至 50）時暫停上傳';

  @override
  String get adminFreeDiskGb => '或低於此可用空間（GB，0 至 100000），以較小者為準';

  @override
  String get adminHandle => '登入名稱';

  @override
  String get adminIntegrity => '完整性';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個項目',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': '排隊中',
      'running': '執行中',
      'done': '已完成',
      'dead': '失敗',
      'cancelled': '已取消',
      'other': '全部',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => '工作類型，例如 render';

  @override
  String get adminJobs => '工作';

  @override
  String adminLastSeen(String time) {
    return '上次活動：$time';
  }

  @override
  String get adminLibraries => '圖庫';

  @override
  String get adminLibraryOwner => '擁有者';

  @override
  String get adminLibraryRoot => '伺服器上的資料夾，例如 /srv/photos';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': '線上',
      'offline': '離線',
      'scanning': '掃描中',
      'error': '錯誤',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => '伺服器記錄';

  @override
  String get adminName => '姓名';

  @override
  String get adminNothing => '目前沒有任何內容';

  @override
  String get adminOutOfRange => '超出範圍';

  @override
  String get adminOverview => '總覽';

  @override
  String get adminPair => '配對裝置';

  @override
  String get adminPairBody =>
      '掃描這個代碼或傳送連結，然後在新裝置的 Photolib 中貼到「新增伺服器」：它會帶上這部伺服器的所有位址和憑證，不需要任何人輸入。';

  @override
  String get adminPasswordSetup => '設定密碼連結';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return '透過任何方式將此連結傳送給 $name，或讓對方掃描 QR 碼。它可在 $date 前設定一次密碼。';
  }

  @override
  String get adminPause => '暫停某類工作';

  @override
  String adminPauseMinutes(int max) {
    return '分鐘數，1 至 $max';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type 已暫停至 $time';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '還有 $countString 個項目待備份',
      zero: '沒有待備份的項目',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => '政策';

  @override
  String get adminPolicyReset => '使用上一層的值';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': '預設開啟',
      'server': '為伺服器設定',
      'user': '為此帳戶設定',
      'library': '為此圖庫設定',
      'config': '在設定檔中指定',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => '套用預設組合';

  @override
  String get adminPresetBody => '預設組合會為伺服器設定每項功能，並清除帳戶和圖庫的設定。之後仍可逐項變更。';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '封存瀏覽',
      'family_backup': '家庭備份',
      'personal': '個人',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '僅以外部唯讀圖庫為準：不上傳、不使用代管圖庫和裝置資料夾，不編輯、不刪除，也不寫入 XMP',
      'family_backup': '除寫入 XMP 外全部開啟',
      'personal': '除分享和公開連結外全部開啟',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => '連結的 QR 碼';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已將 $countString 個工作排入佇列',
      zero: '沒有需要處理的項目',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => '儲存空間配額（GB），留空表示無限制';

  @override
  String get adminRemote => '遠端存取';

  @override
  String get adminRemoteBody =>
      '不必在路由器上開放連接埠，就能隨時隨地連上伺服器。選擇一種方式；每種方式都會給伺服器一個 HTTPS 位址，供加入應用程式。然後從外部測試。';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared 主動連線到 Cloudflare，由 Cloudflare 透過 HTTPS 提供你的網域。免費方案將單一要求限制為 100 MB，備份不會達到此上限：每次只傳送 8 MiB。';

  @override
  String get adminRemoteNoAddress => '要從外部測試，請將伺服器的 https:// 位址加入此應用程式。';

  @override
  String get adminRemoteReachable => '可以從外部連上。';

  @override
  String get adminRemoteTailscale =>
      '在伺服器所在的電腦和每部裝置上安裝 Tailscale，加入同一個 tailnet 或你的 Headscale，然後在伺服器電腦上執行此指令，並將 public_url 設為它顯示的位址。';

  @override
  String get adminRemoteTest => '從外部測試';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host 將從其遍布全球的伺服器開啟 $url，因此會知道這個位址。要繼續嗎？';
  }

  @override
  String get adminRemoteUnreachable => '無法從外部連上：請檢查你選擇的方式，然後再測試一次。';

  @override
  String get adminRemoteWireguard =>
      '需要在伺服器端或中繼節點上開放一個 UDP 連接埠。這是裝置端的設定；用 wg genkey 產生金鑰。';

  @override
  String get adminRepair => '請從備份或仍保有該檔案的裝置還原';

  @override
  String get adminRepairOrphan => '沒有相片參照它：請檢查後刪除或保留';

  @override
  String get adminReprocess => '重新處理';

  @override
  String get adminReprocessFaces => '重新偵測臉孔';

  @override
  String get adminReprocessFolder => '資料夾，例如 2024/05；留空則處理整個圖庫';

  @override
  String get adminReprocessMetadata => '重新讀取中繼資料';

  @override
  String get adminReprocessRenditions => '重新產生縮圖和預覽';

  @override
  String get adminRestore => '還原';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '還原 $name 失敗：$detail';
  }

  @override
  String get adminRestoreUnverified => '尚無通過的還原演練';

  @override
  String adminRestoreVerified(String when) {
    return '上次驗證的還原：$when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd 會停止，並在再次啟動時以 $name 取代整個資料庫。該備份之後的變更將會遺失，所有裝置都會從頭同步。';
  }

  @override
  String get adminRestoring => 'photolibd 正在停止以還原備份';

  @override
  String get adminResume => '繼續';

  @override
  String get adminRetry => '重試';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': '管理員',
      'user': '使用者',
      'viewer': '檢視者',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => '已儲存';

  @override
  String get adminScan => '立即掃描';

  @override
  String get adminScrubDays => '檢查完所有原始檔所用的天數，1 到 3650';

  @override
  String get adminScrubNever => '首次完整檢查進行中';

  @override
  String adminScrubbed(String time) {
    return '上次完整檢查 $time';
  }

  @override
  String get adminSecondAdmin => '請再設一位管理員，這樣在你無法處理時，其他人也能運行並還原伺服器。';

  @override
  String adminSilent(String time) {
    return '自 $time 起無回應';
  }

  @override
  String get adminSilentHours => '裝置備份在多少小時無回報後視為無回應，1 到 8760';

  @override
  String get adminStores => '儲存空間';

  @override
  String get adminThisDevice => '這部裝置';

  @override
  String get adminTitle => '伺服器管理';

  @override
  String get adminTrashDays => '垃圾桶保留天數，1 至 3650';

  @override
  String get adminTwoFactor => '所有帳戶都必須設定兩步驟驗證';

  @override
  String get adminUsage => '各帳戶用量';

  @override
  String get albumCover => '設為封面';

  @override
  String get albumEmpty => '此相簿是空的';

  @override
  String get albumHideMemories => '從回憶中隱藏';

  @override
  String get albumHideTimeline => '從時間軸隱藏';

  @override
  String get albumNew => '新增相簿';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => '任意日期';

  @override
  String get backupCap => '最大項目';

  @override
  String get backupCharging => '僅在充電時';

  @override
  String backupCompleted(String time) {
    return '上次完整備份：$time';
  }

  @override
  String backupContact(String time) {
    return '上次連線伺服器：$time';
  }

  @override
  String get backupEnabled => '備份此裝置';

  @override
  String get backupFolderNo => '不備份此資料夾';

  @override
  String get backupFolderYes => '備份';

  @override
  String backupHours(int count) {
    return '$count 小時';
  }

  @override
  String get backupMetered => '計量付費網路（如行動數據或熱點）';

  @override
  String get backupNever => '尚無完整備份';

  @override
  String backupNewFolder(String name) {
    return '新資料夾 $name：要備份嗎？';
  }

  @override
  String get backupNoLimit => '無限制';

  @override
  String get backupNothing => '沒有等待的項目';

  @override
  String get backupNow => '立即備份';

  @override
  String backupOverdue(int hours, String items) {
    return '已有 $hours 小時沒有完整備份。等待中：$items';
  }

  @override
  String get backupOverdueTitle => '備份尚未完成';

  @override
  String backupPending(String items) {
    return '等待中：$items';
  }

  @override
  String backupRetry(String time) {
    return '重試時間：$time';
  }

  @override
  String get backupRoaming => '漫遊時備份';

  @override
  String get backupSignIn => '登入伺服器以備份此裝置';

  @override
  String get backupSignedOut => '備份已停止：伺服器已將此裝置登出。請在設定中重新登入。';

  @override
  String get backupSince => '拍攝於此日期之後';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': '備份正在等待伺服器可連線',
      'charging': '備份正在等待裝置充電',
      'battery_low': '備份正在等待：電量不足',
      'roaming': '漫遊時備份將等待',
      'quota': '備份已停止：你在伺服器上的儲存空間已滿',
      'second_factor': '備份已停止：伺服器要求此帳號使用第二重驗證',
      'other': '備份已停止：伺服器回應 $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => '備份';

  @override
  String get backupWaiting => '未備份';

  @override
  String get backupWarnAfter => '未完成多久後提醒';

  @override
  String get backupWhat => '備份內容';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': '位於你未選擇的資料夾中',
      'folder_new': '位於新資料夾中：請選擇是否備份',
      'type_excluded': '你未選擇的項目類型',
      'before_date': '拍攝於你選擇的日期之前',
      'selected': '正在排隊',
      'server_restored': '伺服器在還原中遺失了它：正在重新傳送',
      'working': '正在備份',
      'waiting_for_icloud': '正在等待從 iCloud 下載',
      'metered': '正在等待非計量付費的網路',
      'metered_cap': '對計量付費網路來說太大',
      'unreadable': '此裝置無法讀取它',
      'changed': '傳送時它發生了變化',
      'quota': '你在伺服器上的儲存空間已滿',
      'other': '伺服器拒絕了它：$code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld => '伺服器已不再支援這個版本的 Photolib。';

  @override
  String get checkAppTooOldNext => '請更新 Photolib。';

  @override
  String get checkChanged => '伺服器憑證不是你先前信任的那一個。';

  @override
  String get checkChangedNext => '如果管理員更換了憑證，請信任新的憑證。否則可能有人在竊聽：請不要繼續。';

  @override
  String get checkClock => '這部裝置的時鐘與伺服器的時鐘相差超過五分鐘。';

  @override
  String get checkClockNext => '讓裝置自動設定日期和時間。';

  @override
  String get checkDnsFailed => '伺服器名稱無法對應到任何位址。';

  @override
  String get checkDnsFailedNext => '檢查位址，或連上伺服器所在的網路。';

  @override
  String checkExpired(String date) {
    return '伺服器憑證已於 $date 過期。';
  }

  @override
  String get checkFailed => '失敗';

  @override
  String get checkMetered => '你正在使用計量付費的網路，例如行動數據。';

  @override
  String get checkMeteredNext => '大型備份前請連上 Wi-Fi。';

  @override
  String get checkNotPhotolib => '回應的不是 Photolib，例如代理伺服器的錯誤頁面或 Wi-Fi 登入頁面。';

  @override
  String get checkNotPhotolibNext => '在瀏覽器中登入 Wi-Fi，或請管理員檢查代理伺服器。';

  @override
  String get checkOtherServer => '這個位址上回應的是另一部 Photolib 伺服器。';

  @override
  String get checkPassed => '通過';

  @override
  String get checkRefused => '這個位址沒有任何回應。';

  @override
  String get checkRefusedNext => '檢查伺服器是否正在執行，以及你是否在它的網路或 VPN 中。';

  @override
  String get checkRun => '檢查連線';

  @override
  String get checkRunning => '檢查中';

  @override
  String get checkSelfSigned => '伺服器使用自己的憑證，這部裝置還不認得它。';

  @override
  String get checkSkipped => '未檢查';

  @override
  String get checkStepAuth => '你的登入';

  @override
  String get checkStepClock => '裝置時鐘';

  @override
  String get checkStepDns => '尋找伺服器位址';

  @override
  String get checkStepNetwork => '你的網路';

  @override
  String get checkStepServer => '伺服器上的 Photolib';

  @override
  String get checkStepTcp => '連上伺服器';

  @override
  String get checkStepTls => '安全連線與憑證';

  @override
  String get checkStepUpload => '透過代理伺服器的大型上傳';

  @override
  String get checkTimedOut => '伺服器回應時間過長。';

  @override
  String get checkTimedOutNext => '檢查你的連線，然後再試一次。';

  @override
  String get checkTitle => '連線檢查';

  @override
  String get checkTlsFailed => '安全連線失敗。';

  @override
  String get checkTrustNext => '只有在指紋與你的伺服器相符時才信任它。';

  @override
  String get checkUntrusted => '伺服器憑證來自這部裝置不信任的發行機構。';

  @override
  String get checkUploadCap => '途中的代理伺服器拒絕大型上傳，因此備份會以小區塊較慢地進行。';

  @override
  String get checkUploadCapNext => '請管理員讓 64 MB 的要求通過代理伺服器。';

  @override
  String get collectionAlbums => '相簿';

  @override
  String collectionHide(String name) {
    return '隱藏$name';
  }

  @override
  String collectionMoveDown(String name) {
    return '下移$name';
  }

  @override
  String collectionMoveUp(String name) {
    return '上移$name';
  }

  @override
  String get collectionPeople => '人物';

  @override
  String collectionPin(String name) {
    return '釘選$name';
  }

  @override
  String get collectionPlaces => '地點';

  @override
  String collectionShow(String name) {
    return '顯示$name';
  }

  @override
  String get collectionTags => '標籤';

  @override
  String collectionUnpin(String name) {
    return '取消釘選$name';
  }

  @override
  String get collectionsCustomise => '自訂';

  @override
  String get collectionsDone => '完成';

  @override
  String get commandPalette => '命令面板';

  @override
  String get commandPaletteHint => '輸入命令';

  @override
  String get dateFormatDefault => '跟隨語言';

  @override
  String get dateFormatDmy => '日-月-年';

  @override
  String get dateFormatMdy => '月-日-年';

  @override
  String get dateFormatYmd => '年-月-日';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個在此裝置上且已備份',
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
      other: '$countString 個僅在此裝置上，未備份',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      '開啟 iCloud 照片後，從此裝置刪除的項目也會從 iCloud 和你的其他 Apple 裝置中移除。';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個僅在你的圖庫中',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => '從此裝置移除';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個已備份的項目；你的圖庫會保留它們',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns => '此裝置上的副本會移至其垃圾桶：清空垃圾桶後才會釋放空間。';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '要刪除 $countString 個項目嗎？',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': '從此裝置和你的圖庫',
      'device': '僅從此裝置',
      'other': '從你的圖庫',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => '不存在';

  @override
  String get deviceFolderCard => 'SD 卡';

  @override
  String get deviceFolderExclude => '排除';

  @override
  String get deviceFolderExcludeThis => '排除這個資料夾';

  @override
  String get deviceFolderExcludedNotice => '這個項目所在的資料夾已從圖庫中排除';

  @override
  String get deviceFolderForget => '從清單中移除';

  @override
  String get deviceFolderInternal => '內部儲存空間';

  @override
  String get deviceFolderKeep => '保留';

  @override
  String deviceFolderNew(String name, String items) {
    return '新資料夾：$name，$items';
  }

  @override
  String get deviceFolders => '裝置資料夾';

  @override
  String get deviceFoldersAll => '顯示除已排除以外的所有資料夾';

  @override
  String get deviceFoldersChosen => '只顯示所選資料夾';

  @override
  String get deviceFoldersExcludedNow => '已從圖庫中排除';

  @override
  String get deviceFoldersSearch => '搜尋資料夾';

  @override
  String get diagnosticsAdvanced => '顯示診斷';

  @override
  String get diagnosticsAllLoggers => '所有來源';

  @override
  String get diagnosticsCopied => '已複製日誌';

  @override
  String get diagnosticsCopy => '複製顯示的日誌';

  @override
  String get diagnosticsEmpty => '尚無記錄項目';

  @override
  String get diagnosticsExport => '匯出診斷套件';

  @override
  String get diagnosticsExported => '已儲存診斷套件';

  @override
  String get diagnosticsLevel => '等級';

  @override
  String get diagnosticsLogger => '來源';

  @override
  String get diagnosticsTitle => '診斷';

  @override
  String get download => '下載';

  @override
  String get downloadCurrent => '目前版本(含編輯)';

  @override
  String get downloadFailed => '無法下載';

  @override
  String get downloadOriginal => '原始版本';

  @override
  String downloadSaved(String name) {
    return '已儲存 $name';
  }

  @override
  String get downloadVersion => '哪個版本?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在下載 $countString 項',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => '自動增強';

  @override
  String get editorCrop => '裁剪';

  @override
  String get editorCropOriginal => '原始比例';

  @override
  String get editorCropSquare => '正方形';

  @override
  String get editorEdit => '編輯';

  @override
  String get editorFlip => '翻轉';

  @override
  String get editorRotate => '旋轉';

  @override
  String get editorSaveCopy => '儲存副本';

  @override
  String get editorSaveFailed => '無法儲存副本';

  @override
  String get editorSaveVersion => '儲存';

  @override
  String get editorSaved => '已另存為副本';

  @override
  String get editorVersionFailed => '無法儲存該版本';

  @override
  String get editorVersionSaved => '已儲存為新版本';

  @override
  String get editorVersionsUnsupported => '此伺服器暫時無法儲存已編輯照片的版本';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已復原 $countString 項變更：伺服器拒絕了這些變更。',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => '關閉';

  @override
  String get editsRejectedForbidden => '你可以檢視這些項目，但無法變更。';

  @override
  String get editsRejectedInvalid => '伺服器無法接受這些變更。';

  @override
  String get editsRejectedNotFound => '這些項目已被刪除，或不再與你共用。';

  @override
  String get errorNotFound => '這個頁面不存在';

  @override
  String get errorRetry => '再試一次';

  @override
  String get errorTitle => '發生錯誤';

  @override
  String faceNumber(int number) {
    return '臉孔 $number';
  }

  @override
  String get facesAgree => '我同意';

  @override
  String get facesAura => '用 AuraFace 描述臉孔（下載較大）';

  @override
  String get facesNotNow => '暫不';

  @override
  String get facesNoticeKeep =>
      '找到的內容會與你的相片一起保存在你的裝置和伺服器上。這些描述絕不會被顯示或分享，停止或刪除相片時全部刪除。';

  @override
  String get facesNoticeOptional => '這是選用的。Photolib 的其他功能不需要它也能使用，你可以隨時在設定中停止。';

  @override
  String get facesNoticeTitle => '在你的相片中尋找臉孔？';

  @override
  String get facesNoticeWhat =>
      'Photolib 會在你的相片和影片中尋找臉孔，並為每張臉孔儲存其位置和一串描述它的數字，以便再次找到同一個人。這樣的描述可能被視為生物辨識資料。';

  @override
  String get facesNoticeWhere =>
      '這會在此裝置上進行；如果你已登入，也會在你自己的伺服器上進行。絕不會在由我們或其他任何人營運的服務上進行。';

  @override
  String get facesServerFailed => '無法通知你的伺服器。請再試一次。';

  @override
  String get facesServerOff => '你的伺服器不會為你尋找臉孔';

  @override
  String get facesServerOn => '你的伺服器會為你尋找臉孔';

  @override
  String get facesServerUnavailable => '你的伺服器不提供臉孔辨識';

  @override
  String facesStatusDownloading(int percent) {
    return '正在下載臉孔模型：$percent%';
  }

  @override
  String get facesStatusMissing => '你的伺服器尚未安裝臉孔模型';

  @override
  String get facesStatusNoDecoder =>
      '無法尋找臉孔：找不到影像程式庫 (libvips)。請重新安裝 Photolib，或安裝 libvips 後重新啟動。';

  @override
  String get facesStatusRunning => '正在此裝置上尋找臉孔';

  @override
  String get facesStatusUnavailable => '此裝置無法尋找臉孔';

  @override
  String get facesStatusWaiting => '臉孔模型將透過 Wi-Fi 下載';

  @override
  String get facesSwitch => '在我的相片中尋找臉孔';

  @override
  String get facesSwitchOff => '已關閉。在你同意之前，不會計算任何與臉孔有關的內容。';

  @override
  String get facesSwitchOn => '已開啟。Photolib 會尋找你相片中的臉孔。';

  @override
  String get facesTitle => '臉孔與人物';

  @override
  String get facesWithdraw => '刪除並停止';

  @override
  String get facesWithdrawBody =>
      '這會刪除 Photolib 為你找到的所有臉孔、描述和人物，包括此裝置和你的伺服器上的。你的相片不會改變。';

  @override
  String get facesWithdrawTitle => '停止尋找臉孔？';

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

    return '未變更的檔案：$countString';
  }

  @override
  String get folderAllow => '允許存取這個資料夾';

  @override
  String get folderDelete => '刪除資料夾';

  @override
  String folderDeleteBody(String name) {
    return '要將 $name 中的相片和影片移至垃圾桶嗎？';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個項目',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => '新增資料夾';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '離線，$countString 個項目',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps => '這個資料夾或其上層、下層資料夾已在圖庫中';

  @override
  String get folderRemove => '移除資料夾';

  @override
  String folderRemoveBody(String folder) {
    return '$folder 中的相片和影片將從圖庫中移除。檔案會原封不動地保留在磁碟上。';
  }

  @override
  String get folderRemoveConfirm => '移除';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '掃描中，已找到 $countString 個項目',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => '允許存取';

  @override
  String get foldersHideExcluded => '隱藏已排除的資料夾';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib 無法再讀取 $countString 個資料夾。',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '顯示已排除的資料夾（$countString）';
  }

  @override
  String get foldersUnsupported =>
      '這個瀏覽器無法將資料夾保留為你的圖庫。請在電腦上使用 Chrome 或 Edge 開啟 Photolib，或使用桌面應用程式。';

  @override
  String get galleryButtons => '按鈕';

  @override
  String get galleryChips => '方塊';

  @override
  String get galleryGrid => '網格';

  @override
  String get galleryMenus => '選單和面板';

  @override
  String get galleryShowSheet => '顯示面板';

  @override
  String get galleryTitle => '元件';

  @override
  String hiddenCollections(int count) {
    return '已隱藏（$count）';
  }

  @override
  String get indexingAllowMetered => '使用行動數據下載';

  @override
  String get indexingAllowSaver => '省電模式下也執行';

  @override
  String get indexingBattery => '未充電時所需電量';

  @override
  String get indexingChargingOnly => '僅在充電時';

  @override
  String indexingDownloading(int percent) {
    return '正在下載搜尋模型：$percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 張照片無法讀取',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => '此裝置只為新照片建立索引';

  @override
  String get indexingMissing => '你的伺服器尚未安裝搜尋模型';

  @override
  String get indexingModels => '在此裝置上搜尋';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '從 $host 下載搜尋模型（$megabytesString MB）';
  }

  @override
  String get indexingNoDecoder =>
      '無法搜尋與辨識文字：找不到影像程式庫 (libvips)。請重新安裝 Photolib，或安裝 libvips 後重新啟動。';

  @override
  String indexingPausedBattery(int percent) {
    return '電池電量低於 $percent% 時暫停';
  }

  @override
  String get indexingPausedCharger => '暫停，直到裝置開始充電';

  @override
  String get indexingPausedHeat => '裝置過熱時暫停';

  @override
  String get indexingPausedSaver => '省電模式開啟時暫停';

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

    return '已建立索引的照片：$doneString / $totalString';
  }

  @override
  String get indexingText => '讀取相片中的文字';

  @override
  String indexingTextDownloading(int percent) {
    return '正在下載文字模型：$percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '從 $host 下載文字模型（$megabytesString MB），可依相片中的文字尋找';
  }

  @override
  String get indexingTextMissing => '您的伺服器尚未安裝文字模型';

  @override
  String get indexingTextPlatform => '使用手機內建的文字辨識，無需下載。讀取新相片';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '已讀取文字的相片：$doneString / $totalString';
  }

  @override
  String get indexingTextUnavailable => '此處無法讀取文字';

  @override
  String get indexingTextWaiting => '文字模型僅透過 Wi-Fi 下載';

  @override
  String get indexingUnavailable => '此裝置上的搜尋在這裡無法使用';

  @override
  String get indexingWaiting => '搜尋模型將透過 Wi-Fi 下載';

  @override
  String get infoAddName => '新增名稱';

  @override
  String get infoAddTag => '新增標籤';

  @override
  String get infoAlbums => '相簿';

  @override
  String get infoAllMetadata => '檢視所有中繼資料';

  @override
  String get infoAuto => '自動';

  @override
  String get infoBackedUp => '已備份';

  @override
  String get infoCamera => '相機';

  @override
  String get infoChangeAdjust => '已調整色彩';

  @override
  String get infoChangeCrop => '已裁切';

  @override
  String get infoChangeFlip => '已鏡射';

  @override
  String get infoChangeInpaint => '已填補區域';

  @override
  String get infoChangeLocal => '已調整區域';

  @override
  String get infoChangeLut => '已套用色彩風格';

  @override
  String get infoChangeOther => '已編輯';

  @override
  String get infoChangeTurn => '已旋轉';

  @override
  String get infoCompare => '與原圖比較';

  @override
  String infoConfidence(String percent) {
    return '可信度：$percent';
  }

  @override
  String get infoCopyPath => '複製路徑';

  @override
  String get infoCurrent => '目前';

  @override
  String get infoDescription => '新增說明';

  @override
  String get infoEditDate => '編輯日期';

  @override
  String infoEditNumber(int number) {
    return '編輯 $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '$name 的編輯副本';
  }

  @override
  String get infoFaces => '臉孔';

  @override
  String get infoFile => '檔案';

  @override
  String get infoFromFileName => '來自檔案名稱';

  @override
  String get infoHistory => '編輯記錄';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => '位置';

  @override
  String get infoMap => '拍攝地點地圖';

  @override
  String get infoMapAgree => '地圖圖磚來自網際網路，會透露你查看的區域';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return '新標籤：$path';
  }

  @override
  String get infoNoAlbum => '不在任何相簿中';

  @override
  String get infoOnDevice => '在此裝置上';

  @override
  String get infoOriginal => '原圖';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString 像素';
  }

  @override
  String infoRemoveFrom(String album) {
    return '從$album中移除';
  }

  @override
  String infoRemoveTag(String tag) {
    return '移除$tag';
  }

  @override
  String infoRemovedFrom(String album) {
    return '已從$album中移除';
  }

  @override
  String get infoRevert => '還原';

  @override
  String get infoSaveCopy => '另存為副本';

  @override
  String get infoShared => '已共用';

  @override
  String get infoShowFaces => '在相片上顯示臉孔';

  @override
  String get infoShowMap => '顯示地圖';

  @override
  String get infoTags => '標籤';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個版本',
    );
    return '$_temp0 · 最近 $time';
  }

  @override
  String get infoWhy => '為什麼是這個日期？';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': '從檔案的 $tag 讀取',
      'name': '從檔案名稱讀取',
      'folder': '從資料夾名稱讀取',
      'host': '由檔案來源服務提供',
      'unknown': '檔案中沒有任何日期資訊，因此使用其最後修改日期',
      'other': '檔案尚未讀取，因此使用裝置提供的日期',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {'true': '清單', 'other': '網格'});
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': '名稱',
      'taken': '拍攝日期',
      'modified': '修改日期',
      'size': '大小',
      'random': '隨機',
      'extension': '類型',
      'custom': '相簿順序',
      'other': '拍攝日期',
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
  String get languageDevice => '裝置語言';

  @override
  String get languageName => '繁體中文';

  @override
  String get libraryAddFolder => '新增資料夾';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '未備份',
      'backed_up': '已備份',
      'cloud_only': '僅在雲端',
      'other': '全部',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '全部已備份',
      'backed_up': '尚無已備份的項目',
      'cloud_only': '沒有僅在伺服器上的項目',
      'other': '這裡沒有內容',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => '備份標記';

  @override
  String get libraryEmpty => '你的相片會顯示在這裡';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': '依週分組',
      'month': '依月分組',
      'other': '依日分組',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => '再次隱藏已隱藏和已封存的項目';

  @override
  String get libraryNoKeyring =>
      'Photolib 會將圖庫的金鑰保存在系統鑰匙圈中，但鑰匙圈未執行或已鎖定。請啟動或解鎖 GNOME Keyring 或 KWallet 等鑰匙圈，然後再試一次。';

  @override
  String get libraryRevealExcluded => '顯示已排除的資料夾 5 分鐘';

  @override
  String get libraryShowVeiled => '顯示已隱藏和已封存的項目 5 分鐘';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': '最近新增',
      'other': '拍攝日期',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed => 'Photolib 無法開啟此裝置上儲存的圖庫';

  @override
  String get libraryViewOptions => '檢視選項';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '正在準備縮圖：$doneString/$totalString';
  }

  @override
  String get libraryZoomIn => '較大的縮圖';

  @override
  String get libraryZoomOut => '較小的縮圖';

  @override
  String get mapAddTrack => '新增 GPX 軌跡';

  @override
  String get mapArea => '地圖區域';

  @override
  String get mapAttribution => '© OpenStreetMap 貢獻者';

  @override
  String get mapClearLasso => '清除選取';

  @override
  String get mapEmpty => '還沒有帶位置的相片';

  @override
  String get mapHeat => '熱度圖';

  @override
  String get mapLasso => '圍繞相片畫圈選取';

  @override
  String get mapLoading => '正在把相片放到地圖上';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '相片：$countString';
  }

  @override
  String get mapSearchHere => '搜尋此區域';

  @override
  String get mapSplit => '在地圖下方顯示相片';

  @override
  String get mapTilesAgree =>
      '地圖背景來自 OpenStreetMap 的伺服器 (tile.openstreetmap.org)，該伺服器會知道你查看的區域';

  @override
  String get mapTilesShow => '顯示背景';

  @override
  String get mapTime => '時間範圍';

  @override
  String get mapTitle => '地圖';

  @override
  String get mapTrackBad => '該檔案中沒有 GPX 軌跡';

  @override
  String get mapTrips => '旅程';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': '最愛',
      'hidden': '已隱藏',
      'archived': '已封存',
      'offline': '已保留在此裝置',
      'offline': '已保留在此裝置',
      'offline': '已保留在此裝置',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => '允許存取';

  @override
  String get mediaAccessNone => 'Photolib 需要存取你的相片和影片才能顯示。';

  @override
  String get mediaAccessPartial =>
      'Photolib 只能看到你選取的相片和影片。若要作為圖庫使用，必須允許存取所有相片和影片。';

  @override
  String get mediaAccessSelect => '選取更多相片';

  @override
  String get nameLabel => '名稱';

  @override
  String get nextAddRoot => '在伺服器設定的 external_roots 中加入該資料夾，然後重新啟動伺服器。';

  @override
  String get nextAskAdmin => '請詢問你的伺服器管理員。';

  @override
  String get nextAskOwner => '請圖庫的擁有者允許你加入照片。';

  @override
  String get nextCheckConnection => '檢查連線以了解原因。';

  @override
  String get nextCheckEntry => '檢查你輸入的內容後再試一次。';

  @override
  String get nextConfirm => '檢查受影響的項目數量，然後確認。';

  @override
  String get nextDeleteWebhook => '刪除一個不再使用的 Webhook，然後再試一次。';

  @override
  String get nextEditConfig => '在伺服器設定中變更，然後重新啟動伺服器。';

  @override
  String get nextFreeSpace => '釋放一些空間，或請管理員增加空間。';

  @override
  String get nextNewLink => '請管理員給你一個新的。';

  @override
  String get nextNewestToken => '從 photolibd 的記錄中複製最新的權杖。';

  @override
  String get nextOtherAdmin => '先將另一個帳號設為管理員。';

  @override
  String get nextOtherFolder => '選擇一個獨立的資料夾。';

  @override
  String get nextRefresh => '重新整理後再試一次。';

  @override
  String get nextReport => '再試一次。如果再次發生，請複製下方的詳細資訊給管理員。';

  @override
  String get nextSetUpPrivate => '在設定中完成私人圖庫的設定，然後再試一次。';

  @override
  String get nextSignIn => '重新登入。';

  @override
  String get nextSignInAccount => '用你的帳號登入後再試一次。';

  @override
  String get nextSignInInstead => '請改為登入。';

  @override
  String get nextTryAgain => '再試一次。';

  @override
  String get nextUpdateAndAgree => '請更新應用程式，然後再次同意須知。';

  @override
  String get nextUseAnother => '選擇另一個。';

  @override
  String get nextUseHttps => '使用伺服器的 https:// 位址，或從伺服器所在的網路連線。';

  @override
  String get nextWait => '等一分鐘後再試一次。';

  @override
  String get offlineKeep => '離線保留';

  @override
  String offlineKeepHere(String size) {
    return '保留在此裝置（$size）';
  }

  @override
  String get offlineKeptHere => '已保留在此裝置';

  @override
  String get offlineStopKeeping => '停止離線保留';

  @override
  String get otherFiles => '其他檔案';

  @override
  String get passphraseCreate =>
      '這台電腦沒有執行可保存 Photolib 金鑰的鑰匙圈（Secret Service）。請設定至少 10 個字元的密碼短語來保護它們：Photolib 每次啟動時都會詢問。';

  @override
  String get passphraseLabel => '密碼短語';

  @override
  String get passphraseMismatch => '兩次輸入的密碼短語不一致。';

  @override
  String get passphraseRepeat => '再次輸入密碼短語';

  @override
  String get passphraseTooShort => '請至少使用 10 個字元。';

  @override
  String get passphraseUnlock => '請輸入在這台電腦上保護 Photolib 金鑰的密碼短語。';

  @override
  String get passphraseWrong => '密碼短語錯誤，請再試一次。';

  @override
  String photoPosition(int index, int count) {
    return '第 $index 張相片，共 $count 張';
  }

  @override
  String get privacyCheckKit => '檢查復原套件';

  @override
  String get privacyDrillDue => '該進行復原演練了：請確認你的復原套件仍能解鎖你的私人圖庫。';

  @override
  String get privacyHonest =>
      '私人圖庫在你的裝置上加密，其他任何人都無法開啟：伺服器不能，伺服器管理員不能，Photolib 的開發者也不能。如果你同時遺失了密碼和復原套件，你的照片將永久遺失，任何人都無法為你找回。';

  @override
  String get privacyKitBody =>
      '請依序將這 24 個單字寫在紙上，並存放在安全的地方。如果你忘記密碼，它們可以解鎖你的私人圖庫；任何拿到它們的人也可以。';

  @override
  String get privacyKitDone => '你的復原套件有效。';

  @override
  String get privacyKitOther => '這不是你目前的復原套件。';

  @override
  String get privacyKitTitle => '你的復原套件';

  @override
  String get privacyKitUnverified => '復原套件尚未驗證';

  @override
  String privacyKitVerified(String date) {
    return '復原套件已於 $date 驗證';
  }

  @override
  String get privacyKitWritten => '我已寫下';

  @override
  String get privacyNotReady => '在你擁有兩種解鎖方式並驗證復原套件之前，私人上傳保持關閉。';

  @override
  String get privacyPasswordHelp => '輸入你的帳號密碼：它將成為解鎖私人圖庫的一種方式。';

  @override
  String get privacyPhrase => '復原詞組';

  @override
  String get privacyPhraseHelp => '你的復原套件中的 24 個單字';

  @override
  String get privacyPhraseInvalid => '這不是復原詞組。請檢查每個單字。';

  @override
  String get privacyReady => '私人上傳已開啟。';

  @override
  String get privacyRecoveryKit => '復原套件';

  @override
  String get privacySetUp => '設定';

  @override
  String get privacyShowWords => '再次顯示單字';

  @override
  String get privacyTitle => '私人圖庫';

  @override
  String privacyUnknownWord(int number) {
    return '第 $number 個單字不是復原套件中的單字。';
  }

  @override
  String get privacyVerify => '驗證';

  @override
  String get privacyVerifyBody => '輸入復原套件中的這些單字，以證明你已儲存它。';

  @override
  String get privacyWays => '解鎖方式';

  @override
  String privacyWord(int number) {
    return '單字 $number';
  }

  @override
  String get privacyWordsDiffer => '這些單字與你的復原套件不符。請檢查你寫下的內容。';

  @override
  String get privacyWrongPassword => '這不是你的帳號密碼。';

  @override
  String get problemAdminOnly => '只有管理員可以執行此操作。';

  @override
  String get problemBusy => '伺服器忙碌中或正在重新啟動。';

  @override
  String get problemChanged => '這在此期間已被變更。';

  @override
  String get problemConfirm => '這將隱藏或刪除的項目多於伺服器無需確認即可處理的數量';

  @override
  String get problemContribute => '你不能將照片加入這個圖庫。';

  @override
  String get problemCopy => '複製詳細資訊';

  @override
  String get problemDetails => '詳細資訊';

  @override
  String get problemDiskLow => '伺服器磁碟快滿了，上傳已暫停。';

  @override
  String get problemEmailTaken => '另一個帳號已使用這個電子郵件。';

  @override
  String get problemExists => '它已存在。';

  @override
  String get problemFaceNotice => '你的伺服器要求比此應用程式所顯示的更新版本的臉孔須知。';

  @override
  String get problemGone => '它已不在伺服器上。';

  @override
  String get problemHandleTaken => '另一個帳號已使用這個登入名稱。';

  @override
  String get problemInterrupted => '上傳已中斷。';

  @override
  String get problemInvalid => '有一個值無效';

  @override
  String get problemLastAdmin => '伺服器至少需要一位管理員。';

  @override
  String get problemLinkInvalid => '這個連結已過期或已被使用。';

  @override
  String get problemLoginFailed => '電子郵件、登入名稱或密碼錯誤。';

  @override
  String get problemMaintenanceKey => '只有在登入狀態下才能暫停備份、完整性檢查和永久刪除，無法使用 API 金鑰暫停';

  @override
  String get problemNotAllowed => '你的帳號不能執行此操作。';

  @override
  String get problemNotExternal => '只有伺服器本身資料夾中的圖庫才能掃描。';

  @override
  String get problemOidcClaim => '你的登入服務沒有以這部伺服器接受的方式說明你是誰。';

  @override
  String get problemOidcDown => '你的登入服務沒有回應伺服器。';

  @override
  String get problemOidcFailed => '你的登入服務拒絕了登入。';

  @override
  String get problemOidcNotAllowed => '你的帳號不能用這種方式登入。';

  @override
  String get problemOidcTaken => '這個登入已連結到另一個 Photolib 帳號。';

  @override
  String get problemOidcUnknown => '這部伺服器不再提供這種登入方式。';

  @override
  String get problemPasskeysOff => '伺服器有了公開位址後，通行金鑰才能使用。';

  @override
  String get problemPinned => '此項目在設定檔中指定，無法在這裡變更。';

  @override
  String get problemPolicyOff => '此伺服器已關閉此功能。';

  @override
  String get problemQuota => '你在伺服器上的儲存空間已滿。';

  @override
  String get problemRestoreKey => '只有在登入狀態下才能還原備份，無法使用 API 金鑰還原。';

  @override
  String get problemRootDiffers => '這個資料夾不包含這個圖庫的檔案';

  @override
  String get problemRootNotAllowed => '這個資料夾不在伺服器設定的 external_roots 之下';

  @override
  String get problemRootOverlaps => '這個資料夾包含或位於另一個圖庫或伺服器本身的資料中';

  @override
  String get problemScanning => '這個圖庫已在掃描中';

  @override
  String get problemSecondFactor =>
      '這個帳戶需要第二重驗證，例如驗證器代碼或通行金鑰，但此版本的 Photolib 還無法提供。';

  @override
  String get problemSetupDone => '這部伺服器已有管理員。';

  @override
  String get problemSetupExpired => '花費的時間太長。';

  @override
  String get problemSetupToken => '這個設定權杖不正確。';

  @override
  String get problemSignedOut => '你已從伺服器登出。';

  @override
  String get problemStepUp => '此變更需要先輸入密碼或代碼。';

  @override
  String get problemStorage => '伺服器無法存取其儲存空間。';

  @override
  String get problemTooMany => '短時間內嘗試次數過多。';

  @override
  String get problemUnexpected => '發生了意外問題。';

  @override
  String get problemUnreachable => '伺服器沒有回應。';

  @override
  String get problemUploadDamaged => '檔案在傳輸途中被變更或損壞。';

  @override
  String get problemUploadExpired => '伺服器上已沒有這次上傳：未完成的上傳一天後過期。';

  @override
  String get problemWebhookLimit => '你的帳號已達到可擁有的 Webhook 數量上限。';

  @override
  String get problemWebhooksOff => '此伺服器已關閉 Webhook。';

  @override
  String get recoveryCode => '復原碼';

  @override
  String get recoveryCodeAbout => '如果金鑰庫遺失了金鑰，可用它開啟此裝置上的 Photolib 儲存區';

  @override
  String get recoveryCodeEnter => '輸入復原碼';

  @override
  String get recoveryCreate => '建立復原碼';

  @override
  String get recoveryLater => '稍後';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 項變更只存在於此裝置上。如果金鑰庫遺失了 Photolib 的金鑰，復原碼可以找回它們。',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      '請寫下這 24 個單字並妥善保管：沒有金鑰庫中的金鑰，它們也能開啟此裝置上的 Photolib 儲存區。它們會取代先前的任何復原碼。';

  @override
  String get recoveryUnlock => '解鎖';

  @override
  String get recoveryWrong => '這不是此儲存區的復原碼';

  @override
  String get renameFind => '尋找';

  @override
  String get renamePattern => '新名稱';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': '太長：名稱最多 255 位元組',
      'invalid': '不是有效的檔案名稱',
      'duplicate': '也指派給了另一個檔案',
      'exists': '此資料夾中的另一個檔案已使用此名稱',
      'other': '無法重新命名',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => '取代為';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '已重新命名的檔案：$countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': '在 Finder 中顯示',
      'windows': '在檔案總管中顯示',
      'other': '在資料夾中顯示',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => '相機';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個項目',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => '日期';

  @override
  String searchDays(String first, String last) {
    return '$first至$last';
  }

  @override
  String get searchEmpty => '搜尋圖庫';

  @override
  String get searchFavourites => '最愛';

  @override
  String get searchFolder => '資料夾';

  @override
  String get searchHint => '檔案名稱或資料夾名稱';

  @override
  String get searchMotionPhotos => '動態相片';

  @override
  String get searchNothing => '沒有相符的結果';

  @override
  String get searchPanoramas => '全景相片';

  @override
  String get searchPhotos => '相片';

  @override
  String get searchScreenshots => '螢幕截圖';

  @override
  String get searchVideo => '影片';

  @override
  String get searchVideos => '影片';

  @override
  String get securityAddPasskey => '新增通行金鑰';

  @override
  String get securityCode => '代碼';

  @override
  String get securityCodesHelp => '請將這些代碼存放在安全的地方。每個代碼可代替第二重驗證使用一次，且只會在此時顯示。';

  @override
  String securityCodesLeft(int count) {
    return '未使用：$count';
  }

  @override
  String get securityNewCodes => '新代碼';

  @override
  String get securityPasskeyNotAdded => '未新增通行金鑰。';

  @override
  String get securityRecoveryCodes => '復原代碼';

  @override
  String get securityRemovePasskey => '移除通行金鑰';

  @override
  String get securitySetUp => '設定';

  @override
  String get securityStepUpBody => '請輸入密碼、驗證器 App 中的代碼或復原代碼，以變更第二重驗證。';

  @override
  String get securityStepUpTitle => '確認是你本人';

  @override
  String get securityTitle => '第二重驗證';

  @override
  String get securityTotp => '驗證器 App';

  @override
  String get securityTotpHelp => '將此金鑰新增到驗證器 App，然後輸入它顯示的代碼。';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': '已開啟', 'other': '已關閉'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => '關閉';

  @override
  String get securityWrongCode => '代碼不正確。';

  @override
  String get securityWrongProof => '密碼或代碼不正確。';

  @override
  String get selectAll => '全選';

  @override
  String get selectionClear => '取消選取';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已選取 $countString 項',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => '顯示已選取項目';

  @override
  String get serverAccount => '電子郵件或登入名稱';

  @override
  String get serverAdd => '新增伺服器';

  @override
  String get serverAddressInvalid => '請輸入位址，例如 photos.example.org';

  @override
  String get serverAddresses => '位址';

  @override
  String get serverAddressesHelp =>
      '每行一個：你網路中、網際網路上或透過 VPN 存取的伺服器。應用程式會使用回應最快的位址。 或貼上你收到的設定密碼連結。';

  @override
  String get serverCa => '私人 CA 憑證（PEM）';

  @override
  String get serverCaChoose => '選擇憑證檔案';

  @override
  String serverCertificateBody(String host) {
    return '$host 提供的憑證不受這部裝置信任。只有在這個 SHA-256 指紋屬於你的伺服器時才信任它：';
  }

  @override
  String get serverCertificateTitle => '要信任這個憑證嗎？';

  @override
  String get serverConfirm => '確認';

  @override
  String get serverConnect => '連線';

  @override
  String get serverCreateAdmin => '建立管理員';

  @override
  String get serverEnded => '伺服器已結束這個工作階段。請重新登入。';

  @override
  String get serverHandleHelp => '小寫字母、數字、句點、連字號和底線；建立後無法變更。';

  @override
  String get serverHeaders => '自訂標頭';

  @override
  String get serverHeadersHelp => '每行一個，格式為 Name: value；僅透過 HTTPS 傳送';

  @override
  String get serverHeadersInvalid => '請以 Name: value 格式撰寫每個標頭';

  @override
  String get serverIdentity => '用戶端憑證（PKCS#12）';

  @override
  String get serverIdentityChoose => '選擇用戶端憑證';

  @override
  String get serverIdentityInvalid => '這不是憑證（PKCS#12），或其密碼錯誤。';

  @override
  String get serverIdentityPassword => '用戶端憑證密碼';

  @override
  String get serverLoading => '正在讀取此裝置上儲存的伺服器';

  @override
  String get serverNearby => '這個網路上的伺服器';

  @override
  String get serverNeedsHttps =>
      '這部伺服器需要 HTTPS 位址：在區域網路之外，Photolib 不會透過一般 HTTP 登入。';

  @override
  String get serverNoSignIn => '這部伺服器未提供此版本 Photolib 支援的登入方式。';

  @override
  String get serverOffline => '伺服器沒有回應。你仍維持登入。';

  @override
  String get serverPasskeyFailed => '未使用密碼金鑰。請重試，或使用代碼。';

  @override
  String get serverPasskeyRequired => '這部伺服器需要通行金鑰，但此版本的 Photolib 還無法使用。';

  @override
  String get serverPassword => '密碼';

  @override
  String get serverPasswordAgain => '再次輸入密碼';

  @override
  String get serverPasswordSetupInvalid => '此密碼設定權杖錯誤、已使用或已過期。請索取新的權杖。';

  @override
  String get serverPasswordSetupToken => '密碼設定權杖';

  @override
  String get serverPasswordSetupTokenHelp =>
      '由管理員提供，或由伺服器上的 photolibd admin password-setup 印出。';

  @override
  String get serverPasswordsDiffer => '兩次輸入的密碼不一致。';

  @override
  String get serverPrivateLibrariesBody =>
      '新密碼無法開啟它們。請使用復原套件、密碼金鑰或仍在登入狀態的裝置重新開啟。';

  @override
  String get serverPrivateLibrariesGo => '設定密碼';

  @override
  String get serverPrivateLibrariesTitle => '你的私人圖庫仍保持鎖定';

  @override
  String get serverProxy => 'HTTP Proxy，格式為 host:port';

  @override
  String get serverProxyInvalid => '請以 host:port 格式輸入 Proxy';

  @override
  String get serverRecoveryCode => '復原代碼';

  @override
  String get serverRemove => '移除這部伺服器';

  @override
  String get serverRequired => '必填';

  @override
  String get serverSecondFactor => '這個帳戶的第二重驗證是通行金鑰，但此版本的 Photolib 還無法使用。';

  @override
  String get serverSecondFactorCode => '這個帳戶還需要驗證器 App 中的代碼或復原代碼。';

  @override
  String get serverSecondFactorTitle => '確認是你本人';

  @override
  String get serverSecondFactorWrong => '未成功。嘗試五次後，請重新登入。';

  @override
  String get serverSetPassword => '設定密碼';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '$server 上的 $handle';
  }

  @override
  String get serverSetPasswordOpen => '設定密碼';

  @override
  String get serverSetPasswordTitle => '設定你的密碼';

  @override
  String get serverSetUp => '設定新伺服器';

  @override
  String get serverSetupLinkElsewhere =>
      '若要使用此設定連結，請先登出這部伺服器；如果連結屬於另一部伺服器，請移除這部伺服器。';

  @override
  String get serverSetupTitle => '設定伺服器';

  @override
  String get serverSetupToken => '設定權杖';

  @override
  String get serverSetupTokenHelp =>
      '伺服器沒有管理員時，photolibd 會將它寫入記錄；每次啟動都會寫入新的權杖。';

  @override
  String get serverSignIn => '登入';

  @override
  String get serverSignOut => '登出';

  @override
  String serverSignedInAs(String account) {
    return '已以 $account 身分登入';
  }

  @override
  String get serverSignedOut => '已登出';

  @override
  String get serverSwitch => '切換帳號';

  @override
  String get serverTotpCode => '驗證器應用程式中的代碼';

  @override
  String get serverTrust => '信任';

  @override
  String get serverUnreadable => '無法讀取此裝置上儲存的伺服器';

  @override
  String get serverUsePasskey => '使用密碼金鑰';

  @override
  String get serverUseRecoveryCode => '改用復原代碼';

  @override
  String get settingsBackground => '透明圖片的背景';

  @override
  String get settingsDateFormat => '日期格式';

  @override
  String get settingsDefaultTab => '資料夾和相簿預設開啟';

  @override
  String get settingsFolders => '資料夾';

  @override
  String get settingsIndexing => '在此裝置上建立索引';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLibrary => '圖庫';

  @override
  String get settingsServer => '伺服器';

  @override
  String get settingsStart => '啟動畫面';

  @override
  String get settingsTheme => '主題';

  @override
  String get settingsTitle => '設定';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': '輕觸左側或右側邊緣以檢視上一項或下一項',
      'oneFingerZoom': '輕觸兩下並拖曳以單指縮放',
      'swipes': '在影片左側上下滑動調整亮度，右側調整音量',
      'maxBrightness': '檢視時使用最高亮度',
      'autoRotate': '依每張相片或每部影片的方向旋轉',
      'mixAudio': '影片與其他音訊同時播放，而不暫停它',
      'autoplay': '開啟影片時自動播放',
      'loop': '重複播放影片',
      'autoNext': '影片結束後前往下一項',
      'resume': '從上次離開處繼續播放影片',
      'other': '在格狀檢視中播放動態圖片',
    });
    return '$_temp0';
  }

  @override
  String get settingsTrashKeep => 'Photolib 在垃圾桶中保留項目的時間';

  @override
  String get settingsViewerBar => '檢視器列中的按鈕';

  @override
  String get settingsViewing => '檢視';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個共享的相片和影片正在等待 Photolib 獲准加入你的相片圖庫。未儲存的項目將在 7 天後刪除。',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge => '一次分享的內容過大：請少選一些項目';

  @override
  String shareTooMany(int count) {
    return '一次分享的項目過多：請最多選擇 $count 項';
  }

  @override
  String get shortcutsTitle => '鍵盤快速鍵';

  @override
  String get slideshow => '幻燈片播放';

  @override
  String get slideshowLoop => '重複';

  @override
  String get slideshowOptions => '幻燈片播放選項';

  @override
  String get slideshowSeconds => '每個項目秒數';

  @override
  String get slideshowShuffle => '隨機順序';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': '遞減',
      'other': '遞增',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => '此裝置';

  @override
  String sourceHide(String name) {
    return '隱藏$name';
  }

  @override
  String get sourceHideOthers => '隱藏此處其他所有內容';

  @override
  String get sourceLost => '無存取權限';

  @override
  String get sourcePartly => '部分顯示';

  @override
  String sourceShow(String name) {
    return '顯示$name';
  }

  @override
  String get sourceShowEverything => '顯示此處所有內容';

  @override
  String get sourceShowOnly => '僅顯示此項';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': '時間軸',
      'folders': '資料夾和相簿',
      'favourites': '最愛',
      'other': '時間軸',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => '離線保留某個人物';

  @override
  String get storageBudget => '儲存空間上限';

  @override
  String get storageClear => '移除離線副本';

  @override
  String get storageClearAction => '移除';

  @override
  String storageClearBody(String size) {
    return '這會移除此裝置上保留的 $size，並停止離線保留相簿、搜尋和照片。伺服器上的資料庫不受影響。';
  }

  @override
  String get storageKeepLibrary => '保留整個資料庫';

  @override
  String get storageKeepOriginals => '同時保留原圖';

  @override
  String get storageNoPeople => '還沒有已命名的人物。';

  @override
  String get storageNoPins => '沒有固定任何內容。固定相簿、搜尋或照片即可離線保留。';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '相簿',
      'search': '搜尋',
      'person': '人物',
      'library': '整個資料庫',
      'asset': '照片',
      'other': '已固定',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return '超出上限：還需要 $size';
  }

  @override
  String get storagePinNothing => '無需下載：其中的照片已在此裝置上';

  @override
  String get storagePinPaused => '等待中：此預設不離線保留任何內容';

  @override
  String get storagePinPlanning => '正在確定要保留的內容…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return '正在下載：$haveString / $filesString';
  }

  @override
  String storagePinReady(String size) {
    return '可離線使用（$size）';
  }

  @override
  String get storagePinWaiting => '連線後將下載';

  @override
  String get storagePins => '離線保留';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '僅目錄',
      'spaceSaver': '節省空間',
      'travel': '所選相簿離線',
      'everything': '全部',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '不保留任何內容；開啟照片時從伺服器載入。',
      'spaceSaver': '在上限內依新到舊保留整個資料庫的預覽。',
      'travel': '只保留您固定的內容：相簿、搜尋和照片。',
      'everything': '在上限內依新到舊保留整個資料庫的原圖。',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => '此裝置保留的內容';

  @override
  String get storageSubtitle => '離線副本和儲存空間上限';

  @override
  String get storageTitle => '儲存空間';

  @override
  String storageUsed(String used, String budget) {
    return '已用 $used，上限 $budget';
  }

  @override
  String get storageWebNote => '瀏覽器只保留預覽，登出時會清除。';

  @override
  String get storeNoKeyring =>
      'Photolib 將其本機儲存區的金鑰保存在系統鑰匙圈中，但鑰匙圈沒有回應。請安裝並解鎖 gnome-keyring、KWallet 或 KeePassXC，並開啟其 Secret Service，然後再試一次。';

  @override
  String get storeNoKeystore => 'Photolib 無法存取此裝置的金鑰庫，其中保存著其本機儲存區的金鑰。';

  @override
  String get storeRebuilt =>
      '此裝置的金鑰庫中已沒有 Photolib 本機儲存區的金鑰，因此已重建該儲存區。其設定以及只存在於此裝置上的內容已遺失；圖庫會重新同步，縮圖會恢復。';

  @override
  String get storeRecoveryNeeded =>
      '此裝置的金鑰庫中已沒有 Photolib 本機儲存區的金鑰。請輸入其復原碼，或重設儲存區並遺失只存在於此裝置上的內容。';

  @override
  String get storeReset => '重設儲存區';

  @override
  String get storeResetBody => '只存在於此裝置上的內容將會遺失；圖庫會重新同步，縮圖會恢復。';

  @override
  String get storeUnavailable => '此裝置上的儲存空間無法使用：設定和收藏集不會保留';

  @override
  String get tabCollections => '收藏集';

  @override
  String get tabLibrary => '圖庫';

  @override
  String get tabSearch => '搜尋';

  @override
  String get themeDark => '深色';

  @override
  String get themeLight => '淺色';

  @override
  String get themeSystem => '系統預設';

  @override
  String get timelineBenchmark => '時間軸基準測試';

  @override
  String get timelineBenchmarkCopy => '複製結果';

  @override
  String get timelineCannotPlay => '無法在此瀏覽器中播放';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date，第 $position 項，共 $count 項';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date，第 $position 項，共 $count 項，無預覽';
  }

  @override
  String get timelineExcluded => '位於已排除的資料夾中';

  @override
  String get timelineScrubber => '依日期捲動';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => '日期不明';

  @override
  String timelineWeek(String date) {
    return '$date 起的一週';
  }

  @override
  String toolbarAdd(String action) {
    return '將$action新增到列中';
  }

  @override
  String toolbarDown(String action) {
    return '下移$action';
  }

  @override
  String get toolbarInBar => '在列中';

  @override
  String get toolbarInMenu => '在 ⋮ 選單中';

  @override
  String toolbarRemove(String action) {
    return '從列中移除$action';
  }

  @override
  String get toolbarReset => '還原為預設值';

  @override
  String toolbarUp(String action) {
    return '上移$action';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': '移動到這裡',
      'other': '複製到這裡',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': '已有同名的檔案或資料夾',
      'changed': '副本與原始檔案不符，已移除',
      'cancelled': '已取消',
      'invalid': '不是有效的資料夾名稱',
      'other': '失敗',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => '最近';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '要永久刪除 $countString 個項目嗎？此動作無法復原。',
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
      other: '還剩 $daysString 天',
      zero: '今天將永久刪除',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => '垃圾桶是空的';

  @override
  String get trashEmptyAll => '清空垃圾桶';

  @override
  String trashKeepDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    return '$daysString 天';
  }

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已將 $countString 個項目移至垃圾桶',
    );
    return '$_temp0';
  }

  @override
  String get trashRemoveGone => '從清單中移除';

  @override
  String trashRetention(int days) {
    return 'Photolib 會在 $days 天後永久刪除垃圾桶中的內容；每個項目都會顯示剩餘時間。';
  }

  @override
  String get trashTitle => '垃圾桶';

  @override
  String get undo => '復原';

  @override
  String get uploadAction => '上傳相片和影片';

  @override
  String get uploadClear => '清除';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '已上傳 $doneString/$totalString';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '失敗：$countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已封存 $countString 個項目',
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
      other: '已隱藏 $countString 個項目',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': '黑色',
      'white': '白色',
      'other': '棋盤格',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => '無法在此裝置上播放此影片';

  @override
  String get viewerCaptions => '字幕';

  @override
  String get viewerCompass => '指南針鎖定';

  @override
  String get viewerCopy => '複製';

  @override
  String get viewerCopyText => '複製文字';

  @override
  String get viewerCustomize => '自訂工具列…';

  @override
  String get viewerDial => '方向。按一下可朝向正前方。拖曳可環顧四周，捲動或雙指縮放可縮放，按兩下可重設';

  @override
  String get viewerFilmstrip => '膠卷列';

  @override
  String get viewerFirst => '第一項';

  @override
  String get viewerFisheye => '魚眼';

  @override
  String get viewerGyroscope => '移動裝置以環顧四周';

  @override
  String get viewerHdr => '以 HDR 顯示';

  @override
  String get viewerInfo => '資訊';

  @override
  String get viewerInfoLoading => '正在載入此項目的資訊';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '第 $positionString 項，共 $countString 項';
  }

  @override
  String get viewerLast => '最後一項';

  @override
  String get viewerLenses => '選擇鏡頭';

  @override
  String get viewerMap => '地圖';

  @override
  String get viewerMotion => '播放動態效果';

  @override
  String get viewerMotionDenied => '此瀏覽器未允許存取動作感應器';

  @override
  String get viewerMotionMissing => '此裝置沒有陀螺儀，無法環顧四周';

  @override
  String get viewerMute => '靜音';

  @override
  String get viewerNext => '下一項';

  @override
  String get viewerNextFrame => '下一格';

  @override
  String get viewerPause => '暫停';

  @override
  String get viewerPlanet => '小行星';

  @override
  String get viewerPlay => '播放';

  @override
  String get viewerPrevious => '上一項';

  @override
  String get viewerPreviousFrame => '上一格';

  @override
  String get viewerRotate => '旋轉';

  @override
  String get viewerSdr => '以 SDR 顯示';

  @override
  String get viewerSeek => '位置';

  @override
  String get viewerSetAs => '設定為';

  @override
  String get viewerShare => '分享';

  @override
  String get viewerSpeed => '播放速度';

  @override
  String get viewerSphere => '360° 檢視。拖曳以環顧四周，雙指縮放';

  @override
  String get viewerText => '此相片中的文字';

  @override
  String get viewerTextCopied => '文字已複製';

  @override
  String get viewerTextNone => '此相片中找不到文字';

  @override
  String get viewerTextUnread => '此相片的文字尚未辨識';

  @override
  String get viewerUnmute => '取消靜音';

  @override
  String get viewerZoomIn => '放大';

  @override
  String get viewerZoomOut => '縮小';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD 卡',
      'other': '內部儲存空間',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => '放大';

  @override
  String get zoomOut => '縮小';
}
