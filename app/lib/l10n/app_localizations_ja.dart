// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get actionAddToAlbum => 'アルバムに追加';

  @override
  String get actionArchive => 'アーカイブ';

  @override
  String get actionCopyTo => 'コピー先…';

  @override
  String get actionDeleteForever => '完全に削除';

  @override
  String get actionFavourite => 'お気に入り';

  @override
  String get actionHide => '非表示にする';

  @override
  String get actionMoveTo => '移動先…';

  @override
  String get actionRename => '名前を変更';

  @override
  String get actionRestore => '復元';

  @override
  String get actionShare => '共有';

  @override
  String get actionTrash => 'ゴミ箱に移動';

  @override
  String get actionUnarchive => 'アーカイブから戻す';

  @override
  String get actionUndo => '元に戻す';

  @override
  String get actionUnfavourite => 'お気に入りから外す';

  @override
  String get actionUnhide => '再表示';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': '有効',
      'disabled': '無効',
      'invited': '招待中',
      'deleted': '削除済み',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => 'アカウント';

  @override
  String get adminAddAccount => 'アカウントを追加';

  @override
  String get adminAddExternalLibrary => '外部ライブラリを追加';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts 回試行',
      zero: '未実行',
    );
    return '$status、$_temp0';
  }

  @override
  String get adminAudit => '監査ログ';

  @override
  String get adminBackUpNow => '今すぐバックアップ';

  @override
  String get adminBackupQueued => 'バックアップを待機列に追加しました。続いて復元テストを行います';

  @override
  String get adminBackups => 'データベースのバックアップ';

  @override
  String get adminCancelJob => 'ジョブをキャンセル';

  @override
  String get adminCapabilities => '機能';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': '管理ライブラリ',
      'uploads': 'デバイス、ウェブ、CLI からのアップロード',
      'folder_browser': 'フォルダブラウザ',
      'device_folders': '接続中のアプリでのデバイスフォルダ',
      'sharing': '共有と公開リンク',
      'edits': '編集',
      'deletes': '削除',
      'xmp_writes': 'XMP サイドカーの書き込み',
      'face_recognition': '顔認識',
      'ml_search': 'スマート検索',
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
  String get adminCopied => 'コピーしました';

  @override
  String get adminCopyBundle => 'バグ報告用に診断情報をコピー';

  @override
  String get adminCopyLink => 'リンクをコピー';

  @override
  String get adminDelete => '削除';

  @override
  String get adminDeviceBackups => 'デバイスのバックアップ';

  @override
  String get adminDevices => 'あなたのデバイス';

  @override
  String get adminDisable => '無効にする';

  @override
  String adminDrillFailed(String detail) {
    return '前回の復元テストに失敗しました: $detail';
  }

  @override
  String get adminEdit => '編集';

  @override
  String get adminEmail => 'メールアドレス';

  @override
  String get adminEnable => '有効にする';

  @override
  String get adminErrorSignIn => '管理者としてログインしてください';

  @override
  String get adminFacesDefault => '新しいアカウントで顔認識を最初からオンにする';

  @override
  String get adminFiles => '種類別のファイル';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': '破損',
      'missing': '欠落',
      'size': 'サイズ不一致',
      'hash': '置き換え',
      'orphan': '孤立ファイル',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '空き容量 $size';
  }

  @override
  String get adminFreeDisk => '空きディスク容量がこの割合（%、0～50）を下回るとアップロードを一時停止';

  @override
  String get adminFreeDiskGb => 'またはこの値（GB、0～100000）のほうが小さければ、空き容量がそれを下回ると一時停止';

  @override
  String get adminHandle => 'ログイン名';

  @override
  String get adminIntegrity => '整合性';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個のアイテム',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': '待機中',
      'running': '実行中',
      'done': '完了',
      'dead': '失敗',
      'cancelled': 'キャンセル済み',
      'other': 'すべて',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => 'ジョブの種類（例: render）';

  @override
  String get adminJobs => 'ジョブ';

  @override
  String adminLastSeen(String time) {
    return '最終アクセス：$time';
  }

  @override
  String get adminLibraries => 'ライブラリ';

  @override
  String get adminLibraryOwner => '所有者';

  @override
  String get adminLibraryRoot => 'サーバー上のフォルダ（例: /srv/photos）';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': 'オンライン',
      'offline': 'オフライン',
      'scanning': 'スキャン中',
      'error': 'エラー',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => 'サーバーログ';

  @override
  String get adminName => '名前';

  @override
  String get adminNothing => 'まだ何もありません';

  @override
  String get adminOutOfRange => '範囲外です';

  @override
  String get adminOverview => '概要';

  @override
  String get adminPair => 'デバイスをペアリング';

  @override
  String get adminPairBody =>
      'このコードをスキャンするかリンクを送り、新しいデバイスの Photolib の「サーバーを追加」に貼り付けてください。このサーバーのすべてのアドレスと証明書が伝わるので、誰も入力する必要はありません。';

  @override
  String get adminPasswordSetup => 'パスワード設定リンク';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return 'このリンクを任意の方法で $name さんに送るか、コードをスキャンしてもらってください。$date まで、1 回だけパスワードを設定できます。';
  }

  @override
  String get adminPause => 'ジョブの種類を一時停止';

  @override
  String adminPauseMinutes(int max) {
    return '時間（分、1～$max）';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type は $time まで一時停止中です';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'バックアップ待ち $countString 件',
      zero: 'バックアップ待ちはありません',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => 'ポリシー';

  @override
  String get adminPolicyReset => '上位レベルの値を使う';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': 'デフォルトでオン',
      'server': 'サーバーで設定',
      'user': 'このアカウントで設定',
      'library': 'このライブラリで設定',
      'config': '設定ファイルで指定',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => 'プリセットを適用';

  @override
  String get adminPresetBody =>
      'プリセットはサーバーのすべての機能を設定し、アカウントやライブラリの設定を消去します。どれも後から変更できます。';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': 'アーカイブ閲覧',
      'family_backup': '家族のバックアップ',
      'personal': '個人用',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '読み取り専用の外部ライブラリだけを正とします。アップロード、管理ライブラリ、デバイスフォルダ、編集、削除、XMP の書き込みはありません',
      'family_backup': 'XMP の書き込み以外はすべてオン',
      'personal': '共有と公開リンク以外はすべてオン',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => 'リンクの QR コード';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 件のジョブをキューに追加しました',
      zero: '処理するものはありません',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => 'ストレージの割り当て（GB、空欄で無制限）';

  @override
  String get adminRemote => 'リモートアクセス';

  @override
  String get adminRemoteBody =>
      'ルーターのポートを開けずに、どこからでもサーバーにアクセスできます。方法を 1 つ選んでください。どれもアプリに追加する HTTPS アドレスをサーバーに与えます。その後、外部からテストしてください。';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared が Cloudflare へ外向きに接続し、Cloudflare があなたのドメインを HTTPS で配信します。無料プランは 1 リクエストを 100 MB に制限しますが、バックアップは 8 MiB ずつ送るので上限に達しません。';

  @override
  String get adminRemoteNoAddress =>
      '外部からテストするには、このアプリにサーバーの https:// アドレスを追加してください。';

  @override
  String get adminRemoteReachable => '外部からアクセスできます。';

  @override
  String get adminRemoteTailscale =>
      'サーバーのマシンと各デバイスに、同じ tailnet またはご自身の Headscale で Tailscale をインストールし、サーバーのマシンでこれを実行して、表示されたアドレスを public_url に設定してください。';

  @override
  String get adminRemoteTest => '外部からテスト';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host が世界中のサーバーから $url を開くため、このアドレスを知ることになります。続けますか？';
  }

  @override
  String get adminRemoteUnreachable =>
      '外部からアクセスできません。選んだ方法を確認して、もう一度テストしてください。';

  @override
  String get adminRemoteWireguard =>
      'サーバー側か中継ノードに、開いた UDP ポートが 1 つ必要です。これはデバイス用の設定です。鍵は wg genkey で作成してください。';

  @override
  String get adminRepair => 'バックアップか、まだ保持しているデバイスから元に戻してください';

  @override
  String get adminRepairOrphan => 'どの写真からも参照されていません：確認してから削除するか残してください';

  @override
  String get adminReprocess => '再処理';

  @override
  String get adminReprocessFaces => '顔を再検出';

  @override
  String get adminReprocessFolder => 'フォルダ（例: 2024/05、空欄でライブラリ全体）';

  @override
  String get adminReprocessMetadata => 'メタデータを再読み込み';

  @override
  String get adminReprocessRenditions => 'サムネイルとプレビューを再生成';

  @override
  String get adminRestore => '復元';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '$name の復元に失敗しました: $detail';
  }

  @override
  String get adminRestoreUnverified => '合格した復元テストはまだありません';

  @override
  String adminRestoreVerified(String when) {
    return '最後に検証された復元: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd は停止し、次回起動時にデータベース全体を $name で置き換えます。そのバックアップ以降の変更は失われ、すべてのデバイスが最初から同期し直します。';
  }

  @override
  String get adminRestoring => 'バックアップを復元するため photolibd を停止しています';

  @override
  String get adminResume => '再開';

  @override
  String get adminRetry => '再試行';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': '管理者',
      'user': 'ユーザー',
      'viewer': '閲覧者',
      'other': '不明',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => '保存しました';

  @override
  String get adminScan => '今すぐスキャン';

  @override
  String get adminScrubDays => '検査ですべてのオリジナルを確認する日数（1〜3650）';

  @override
  String get adminScrubNever => '初回の完全検査を実行中';

  @override
  String adminScrubbed(String time) {
    return '前回の完全検査：$time';
  }

  @override
  String get adminSecondAdmin =>
      '2人目の管理者を設定してください。あなたが対応できないときも、ほかの人がサーバーを運用・復元できます。';

  @override
  String adminSilent(String time) {
    return '$time から応答なし';
  }

  @override
  String get adminSilentHours => 'デバイスのバックアップを応答なしとみなすまでの報告のない時間（1〜8760）';

  @override
  String get adminStores => 'ストレージ';

  @override
  String get adminThisDevice => 'このデバイス';

  @override
  String get adminTitle => 'サーバー管理';

  @override
  String get adminTrashDays => 'ゴミ箱での保持日数（1～3650）';

  @override
  String get adminTwoFactor => 'すべてのアカウントで 2 段階認証の設定を必須にする';

  @override
  String get adminUsage => 'アカウント別の使用量';

  @override
  String get albumCover => 'カバーに設定';

  @override
  String get albumEmpty => 'このアルバムは空です';

  @override
  String get albumHideMemories => 'メモリーから隠す';

  @override
  String get albumHideTimeline => 'タイムラインから隠す';

  @override
  String get albumNew => '新しいアルバム';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => 'すべての日付';

  @override
  String get backupCap => '最大のアイテム';

  @override
  String get backupCharging => '充電中のみ';

  @override
  String backupCompleted(String time) {
    return '最後の完全バックアップ: $time';
  }

  @override
  String backupContact(String time) {
    return 'サーバーとの最終接続: $time';
  }

  @override
  String get backupEnabled => 'このデバイスをバックアップ';

  @override
  String get backupFolderNo => 'このフォルダは除外';

  @override
  String get backupFolderYes => 'バックアップする';

  @override
  String backupHours(int count) {
    return '$count 時間';
  }

  @override
  String get backupMetered => '従量制ネットワーク（モバイルデータやテザリングなど）';

  @override
  String get backupNever => '完全なバックアップはまだありません';

  @override
  String backupNewFolder(String name) {
    return '新しいフォルダ $name: バックアップしますか？';
  }

  @override
  String get backupNoLimit => '制限なし';

  @override
  String get backupNothing => '待機中のアイテムはありません';

  @override
  String get backupNow => '今すぐバックアップ';

  @override
  String backupOverdue(int hours, String items) {
    return '$hours 時間、完全なバックアップがありません。待機中: $items';
  }

  @override
  String get backupOverdueTitle => 'バックアップが完了していません';

  @override
  String backupPending(String items) {
    return '待機中: $items';
  }

  @override
  String backupRetry(String time) {
    return '再試行: $time';
  }

  @override
  String get backupRoaming => 'ローミング中もバックアップ';

  @override
  String get backupSignIn => 'このデバイスをバックアップするにはサーバーにサインインしてください';

  @override
  String get backupSignedOut =>
      'バックアップが停止しました: サーバーがこのデバイスをサインアウトしました。設定で再度サインインしてください。';

  @override
  String get backupSince => '撮影日の範囲（この日以降）';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': 'サーバーに接続できるまでバックアップは待機します',
      'charging': 'デバイスが充電されるまでバックアップは待機します',
      'battery_low': 'バックアップは待機中: バッテリー残量が少なくなっています',
      'roaming': 'ローミング中はバックアップを待機します',
      'quota': 'バックアップが停止しました: サーバーのストレージがいっぱいです',
      'second_factor': 'バックアップが停止しました: サーバーがこのアカウントに 2 段階目の認証を求めています',
      'other': 'バックアップが停止しました: サーバーの応答 $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => 'バックアップ';

  @override
  String get backupWaiting => '未バックアップ';

  @override
  String get backupWarnAfter => '未完了の場合に警告するまでの時間';

  @override
  String get backupWhat => 'バックアップする内容';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': '選択していないフォルダ内',
      'folder_new': '新しいフォルダ内: バックアップするか選んでください',
      'type_excluded': '選択していない種類のアイテム',
      'before_date': '選択した日付より前に撮影',
      'selected': '順番待ち',
      'server_restored': 'サーバーが復元で失ったため再送信中',
      'working': 'バックアップ中',
      'waiting_for_icloud': 'iCloud からのダウンロード待ち',
      'metered': '従量制ではないネットワーク待ち',
      'metered_cap': '従量制ネットワークには大きすぎます',
      'unreadable': 'このデバイスでは読み取れません',
      'changed': '送信中に変更されました',
      'quota': 'サーバーのストレージがいっぱいです',
      'other': 'サーバーが拒否しました: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld => 'このサーバーは、このバージョンの Photolib に対応しなくなりました。';

  @override
  String get checkAppTooOldNext => 'Photolib を更新してください。';

  @override
  String get checkChanged => 'サーバーの証明書は、信頼したものとは異なります。';

  @override
  String get checkChangedNext =>
      '管理者が交換した場合は、新しい証明書を信頼してください。そうでない場合は盗聴のおそれがあるため、続行しないでください。';

  @override
  String get checkClock => 'このデバイスの時計とサーバーの時計が 5 分以上ずれています。';

  @override
  String get checkClockNext => '日付と時刻を自動で設定するようにしてください。';

  @override
  String get checkDnsFailed => 'サーバー名からアドレスが見つかりません。';

  @override
  String get checkDnsFailedNext => 'アドレスを確認するか、サーバーと同じネットワークに接続してください。';

  @override
  String checkExpired(String date) {
    return 'サーバーの証明書は $date に期限切れになりました。';
  }

  @override
  String get checkFailed => '失敗';

  @override
  String get checkMetered => 'モバイルデータなどの従量制ネットワークに接続しています。';

  @override
  String get checkMeteredNext => '大きなバックアップの前に Wi-Fi に接続してください。';

  @override
  String get checkNotPhotolib =>
      'Photolib 以外のもの（プロキシのエラーページや Wi-Fi のログインページなど）が応答しています。';

  @override
  String get checkNotPhotolibNext =>
      'ブラウザで Wi-Fi にログインするか、管理者にプロキシの確認を依頼してください。';

  @override
  String get checkOtherServer => 'このアドレスでは別の Photolib サーバーが応答しています。';

  @override
  String get checkPassed => '合格';

  @override
  String get checkRefused => 'このアドレスでは何も応答しません。';

  @override
  String get checkRefusedNext =>
      'サーバーが動作していて、そのネットワークまたは VPN に接続しているか確認してください。';

  @override
  String get checkRun => '接続をチェック';

  @override
  String get checkRunning => 'チェック中';

  @override
  String get checkSelfSigned => 'サーバーは独自の証明書を使っていますが、このデバイスはまだそれを知りません。';

  @override
  String get checkSkipped => '未チェック';

  @override
  String get checkStepAuth => 'ログイン状態';

  @override
  String get checkStepClock => 'デバイスの時計';

  @override
  String get checkStepDns => 'サーバーのアドレスを探す';

  @override
  String get checkStepNetwork => 'ネットワーク';

  @override
  String get checkStepServer => 'サーバー上の Photolib';

  @override
  String get checkStepTcp => 'サーバーに接続する';

  @override
  String get checkStepTls => '安全な接続と証明書';

  @override
  String get checkStepUpload => 'プロキシ経由の大きなアップロード';

  @override
  String get checkTimedOut => 'サーバーの応答に時間がかかりすぎています。';

  @override
  String get checkTimedOutNext => '接続を確認して、もう一度お試しください。';

  @override
  String get checkTitle => '接続チェック';

  @override
  String get checkTlsFailed => '安全な接続に失敗しました。';

  @override
  String get checkTrustNext => 'フィンガープリントがサーバーのものと一致する場合にだけ信頼してください。';

  @override
  String get checkUntrusted => 'サーバーの証明書は、このデバイスが信頼していない認証局が発行したものです。';

  @override
  String get checkUploadCap =>
      '経路上のプロキシが大きなアップロードを拒否するため、バックアップは小さく分けてゆっくり進みます。';

  @override
  String get checkUploadCapNext => '64 MB のリクエストをプロキシで通すよう管理者に依頼してください。';

  @override
  String get collectionAlbums => 'アルバム';

  @override
  String collectionHide(String name) {
    return '$nameを非表示';
  }

  @override
  String collectionMoveDown(String name) {
    return '$nameを下に移動';
  }

  @override
  String collectionMoveUp(String name) {
    return '$nameを上に移動';
  }

  @override
  String get collectionPeople => '人物';

  @override
  String collectionPin(String name) {
    return '$nameを固定';
  }

  @override
  String get collectionPlaces => '場所';

  @override
  String collectionShow(String name) {
    return '$nameを表示';
  }

  @override
  String get collectionTags => 'タグ';

  @override
  String collectionUnpin(String name) {
    return '$nameの固定を解除';
  }

  @override
  String get collectionsCustomise => 'カスタマイズ';

  @override
  String get collectionsDone => '完了';

  @override
  String get commandPalette => 'コマンドパレット';

  @override
  String get commandPaletteHint => 'コマンドを入力';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'このデバイスにありバックアップ済み: $countString 個',
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
      other: 'このデバイスのみ、未バックアップ: $countString 個',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'iCloud 写真がオンの場合、このデバイスから削除した項目は iCloud とほかの Apple デバイスからも削除されます。';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ライブラリのみ: $countString 個',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => 'このデバイスから取り除く';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'バックアップ済みの $countString 個の項目。ライブラリには残ります',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      'このデバイス上のコピーはデバイスのゴミ箱に移動します。ゴミ箱を空にすると容量が戻ります。';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個の項目を削除しますか？',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': 'このデバイスとライブラリから',
      'device': 'このデバイスのみから',
      'other': 'ライブラリから',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => '見つかりません';

  @override
  String get deviceFolderCard => 'SD カード';

  @override
  String get deviceFolderExclude => '除外';

  @override
  String get deviceFolderExcludeThis => 'このフォルダを除外';

  @override
  String get deviceFolderExcludedNotice => 'このアイテムのフォルダはライブラリから除外されています';

  @override
  String get deviceFolderForget => 'リストから削除';

  @override
  String get deviceFolderInternal => '内部ストレージ';

  @override
  String get deviceFolderKeep => '残す';

  @override
  String deviceFolderNew(String name, String items) {
    return '新しいフォルダ: $name、$items';
  }

  @override
  String get deviceFolders => 'デバイスのフォルダ';

  @override
  String get deviceFoldersAll => '除外したフォルダ以外をすべて表示';

  @override
  String get deviceFoldersChosen => '選んだフォルダのみ表示';

  @override
  String get deviceFoldersExcludedNow => 'ライブラリから除外しました';

  @override
  String get deviceFoldersSearch => 'フォルダを検索';

  @override
  String get diagnosticsAdvanced => '診断を表示';

  @override
  String get diagnosticsAllLoggers => 'すべてのロガー';

  @override
  String get diagnosticsCopied => 'ログをコピーしました';

  @override
  String get diagnosticsCopy => '表示中のログをコピー';

  @override
  String get diagnosticsEmpty => 'ログはまだありません';

  @override
  String get diagnosticsExport => '診断バンドルを書き出す';

  @override
  String get diagnosticsExported => '診断バンドルを保存しました';

  @override
  String get diagnosticsLevel => 'レベル';

  @override
  String get diagnosticsLogger => 'ロガー';

  @override
  String get diagnosticsTitle => '診断';

  @override
  String get download => 'ダウンロード';

  @override
  String get downloadCurrent => '現在のバージョン(編集を含む)';

  @override
  String get downloadFailed => 'ダウンロードできませんでした';

  @override
  String get downloadOriginal => 'オリジナル';

  @override
  String downloadSaved(String name) {
    return '$name を保存しました';
  }

  @override
  String get downloadVersion => 'どのバージョンにしますか?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個をダウンロード中',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => '自動補正';

  @override
  String get editorCrop => '切り抜き';

  @override
  String get editorCropOriginal => 'オリジナル';

  @override
  String get editorCropSquare => '正方形';

  @override
  String get editorEdit => '編集';

  @override
  String get editorFlip => '反転';

  @override
  String get editorRotate => '回転';

  @override
  String get editorSaveCopy => 'コピーを保存';

  @override
  String get editorSaveFailed => 'コピーを保存できませんでした';

  @override
  String get editorSaveVersion => '保存';

  @override
  String get editorSaved => 'コピーとして保存しました';

  @override
  String get editorVersionFailed => 'バージョンを保存できませんでした';

  @override
  String get editorVersionSaved => '新しいバージョンとして保存しました';

  @override
  String get editorVersionsUnsupported => 'このサーバーはまだ編集した写真のバージョンを保存できません';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 件の変更を元に戻しました: サーバーが拒否しました。',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => '閉じる';

  @override
  String get editsRejectedForbidden => 'これらの項目は表示できますが、変更はできません。';

  @override
  String get editsRejectedInvalid => 'サーバーが変更を受け付けられませんでした。';

  @override
  String get editsRejectedNotFound => '項目が削除されたか、共有されなくなりました。';

  @override
  String get errorNotFound => 'このページは存在しません';

  @override
  String get errorRetry => '再試行';

  @override
  String get errorTitle => '問題が発生しました';

  @override
  String faceNumber(int number) {
    return '顔 $number';
  }

  @override
  String get facesAgree => '同意する';

  @override
  String get facesAura => 'AuraFace で顔を表す（ダウンロードが大きくなります）';

  @override
  String get facesNotNow => '今はしない';

  @override
  String get facesNoticeKeep =>
      '見つかった情報は写真とともに、あなたのデバイスとサーバーに残ります。顔を表す情報が表示されたり共有されたりすることはなく、停止したり写真を削除したりするとすべて削除されます。';

  @override
  String get facesNoticeOptional =>
      'これは任意です。Photolib のほかの機能はこれがなくても使え、設定からいつでも停止できます。';

  @override
  String get facesNoticeTitle => '写真から顔を見つけますか？';

  @override
  String get facesNoticeWhat =>
      'Photolib は写真や動画から顔を探し、顔ごとにその位置と、顔を表す数値のリストを保存します。これにより同じ人物を再び見つけられます。このような情報は生体データに当たる場合があります。';

  @override
  String get facesNoticeWhere =>
      'この処理は、このデバイスと、サインインしている場合はあなた自身のサーバーで行われます。当社や他者が運営するサービスで行われることはありません。';

  @override
  String get facesServerFailed => 'サーバーに伝えられませんでした。もう一度お試しください。';

  @override
  String get facesServerOff => 'サーバーはあなたの顔を見つけません';

  @override
  String get facesServerOn => 'サーバーがあなたの顔を見つけます';

  @override
  String get facesServerUnavailable => 'サーバーは顔認識を提供していません';

  @override
  String facesStatusDownloading(int percent) {
    return '顔モデルをダウンロード中：$percent%';
  }

  @override
  String get facesStatusMissing => 'サーバーに顔モデルがインストールされていません';

  @override
  String get facesStatusNoDecoder =>
      '顔の検出は利用できません。画像ライブラリ (libvips) が見つかりませんでした。Photolib を再インストールするか、libvips をインストールして再起動してください。';

  @override
  String get facesStatusRunning => 'このデバイスで顔を検出中';

  @override
  String get facesStatusUnavailable => 'このデバイスでは顔を見つけられません';

  @override
  String get facesStatusWaiting => '顔モデルは Wi-Fi でダウンロードされます';

  @override
  String get facesSwitch => '写真から顔を見つける';

  @override
  String get facesSwitchOff => 'オフ。同意するまで、顔に関する計算は一切行われません。';

  @override
  String get facesSwitchOn => 'オン。Photolib が写真の顔を見つけます。';

  @override
  String get facesTitle => '顔と人物';

  @override
  String get facesWithdraw => '削除して停止';

  @override
  String get facesWithdrawBody =>
      'Photolib があなたのために見つけた顔、顔を表す情報、人物をすべて、このデバイスとサーバーから削除します。写真は変更されません。';

  @override
  String get facesWithdrawTitle => '顔の検出を停止しますか？';

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

    return '変更されなかったファイル: $countString';
  }

  @override
  String get folderAllow => 'このフォルダへのアクセスを許可';

  @override
  String get folderDelete => 'フォルダを削除';

  @override
  String folderDeleteBody(String name) {
    return '$name の写真と動画をゴミ箱に移動しますか?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個のアイテム',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => '新しいフォルダ';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'オフライン、$countString 個のアイテム',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps => 'このフォルダ、またはその親フォルダかサブフォルダが、すでにライブラリにあります';

  @override
  String get folderRemove => 'フォルダを除外';

  @override
  String folderRemoveBody(String folder) {
    return '$folder の写真と動画はライブラリから除外されます。ファイルはディスク上にそのまま残ります。';
  }

  @override
  String get folderRemoveConfirm => '除外';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'スキャン中、$countString 個のアイテムを検出済み',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => 'アクセスを許可';

  @override
  String get foldersHideExcluded => '除外したフォルダを隠す';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib は $countString 個のフォルダを読み取れなくなりました。',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '除外したフォルダを表示 ($countString)';
  }

  @override
  String get foldersUnsupported =>
      'このブラウザではフォルダをライブラリとして保持できません。パソコンの Chrome または Edge で Photolib を開くか、デスクトップアプリをご利用ください。';

  @override
  String get galleryButtons => 'ボタン';

  @override
  String galleryCameraNote(String camera) {
    return 'Your camera app ($camera) decides where its preview opens. Aperture, Open Camera and Fossify Camera open Photolib. The cameras of Pixel, Samsung, Xiaomi and Motorola open their own gallery.';
  }

  @override
  String get galleryChips => 'チップ';

  @override
  String get galleryEditNone => 'No app on this phone edits pictures.';

  @override
  String get galleryEditNotSaved => 'The edited picture could not be saved.';

  @override
  String get galleryEditWith => 'Edit with…';

  @override
  String get galleryEditorAsk => 'Ask every time';

  @override
  String get galleryEditorSetting => 'Editing app';

  @override
  String get galleryGrid => 'グリッド';

  @override
  String get galleryMenus => 'メニューとシート';

  @override
  String get galleryOnboardIntro =>
      'Every step is optional. Photolib never asks to run without battery limits, and never asks for access to all files.';

  @override
  String get galleryOnboardTitle => 'Make Photolib your gallery';

  @override
  String get galleryOpenWith => 'Open with…';

  @override
  String get galleryPickTitle => 'Choose photos';

  @override
  String get galleryShortcutAdd => 'Add to home screen';

  @override
  String get galleryShortcutFailed => 'Your launcher cannot add shortcuts.';

  @override
  String get galleryShowSheet => 'シートを表示';

  @override
  String get galleryStepCamera => 'Camera';

  @override
  String get galleryStepDefault => 'Open photos with Photolib';

  @override
  String get galleryStepDefaultWhy =>
      'Without this, a photo you tap in another app opens in another gallery.';

  @override
  String get galleryStepDone => 'Done';

  @override
  String get galleryStepManage => 'Fewer confirmation dialogs';

  @override
  String get galleryStepManageWhy =>
      'Without this, Android asks you each time you trash or delete photos.';

  @override
  String get galleryStepMedia => 'Photos and videos';

  @override
  String get galleryStepMediaWhy =>
      'Without access to all your photos and videos, Photolib cannot show your library.';

  @override
  String get galleryStepNotifications => 'Notifications';

  @override
  String get galleryStepNotificationsWhy =>
      'Without them you will not see that a backup has stalled.';

  @override
  String get galleryStepOpen => 'Open settings';

  @override
  String get galleryTitle => 'コンポーネント';

  @override
  String get galleryUninstallWarning =>
      'Your library on this phone is encrypted with a key that uninstalling Photolib deletes. Keep your recovery code safe before you uninstall, or what only this phone holds is lost.';

  @override
  String get galleryWallpaper => 'Set as wallpaper';

  @override
  String get galleryWallpaperBoth => 'Home and lock screens';

  @override
  String get galleryWallpaperDone => 'Wallpaper set';

  @override
  String get galleryWallpaperFailed => 'The wallpaper could not be set.';

  @override
  String get galleryWallpaperHome => 'Home screen';

  @override
  String get galleryWallpaperLock => 'Lock screen';

  @override
  String hiddenCollections(int count) {
    return '非表示（$count）';
  }

  @override
  String get indexingAllowMetered => 'モバイルデータでダウンロード';

  @override
  String get indexingAllowSaver => '省電力モードでも実行';

  @override
  String get indexingBattery => '充電器なしで必要なバッテリー残量';

  @override
  String get indexingChargingOnly => '充電中のみ';

  @override
  String indexingDownloading(int percent) {
    return '検索モデルをダウンロード中: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 枚の写真を読み取れませんでした',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => 'このデバイスは新しい写真だけをインデックスします';

  @override
  String get indexingMissing => 'サーバーに検索モデルがインストールされていません';

  @override
  String get indexingModels => 'このデバイスで検索';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '検索モデル（$megabytesString MB）を $host からダウンロードします';
  }

  @override
  String get indexingNoDecoder =>
      '検索とテキスト認識は利用できません。画像ライブラリ (libvips) が見つかりませんでした。Photolib を再インストールするか、libvips をインストールして再起動してください。';

  @override
  String indexingPausedBattery(int percent) {
    return 'バッテリー残量が$percent%未満の間は一時停止中';
  }

  @override
  String get indexingPausedCharger => 'デバイスが充電されるまで一時停止中';

  @override
  String get indexingPausedHeat => 'デバイスが高温の間は一時停止中';

  @override
  String get indexingPausedSaver => 'バッテリーセーバーがオンの間は一時停止中';

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

    return 'インデックス済みの写真: $doneString / $totalString';
  }

  @override
  String get indexingText => '写真の文字を読み取る';

  @override
  String indexingTextDownloading(int percent) {
    return 'テキストモデルをダウンロード中: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return 'テキストモデル（$megabytesString MB）を $host からダウンロードし、写真の中の言葉を探せるようにします';
  }

  @override
  String get indexingTextMissing => 'サーバーにテキストモデルがインストールされていません';

  @override
  String get indexingTextPlatform =>
      'スマートフォン標準の文字認識を使います。ダウンロードは不要です。新しい写真を読み取ります';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '文字を読み取った写真: $doneString / $totalString';
  }

  @override
  String get indexingTextUnavailable => 'ここでは文字の読み取りを利用できません';

  @override
  String get indexingTextWaiting => 'テキストモデルは Wi-Fi でダウンロードされます';

  @override
  String get indexingUnavailable => 'このデバイスでの検索はここでは利用できません';

  @override
  String get indexingWaiting => '検索モデルは Wi-Fi でダウンロードされます';

  @override
  String get infoAddName => '名前を追加';

  @override
  String get infoAddTag => 'タグを追加';

  @override
  String get infoAlbums => 'アルバム';

  @override
  String get infoAllMetadata => 'すべてのメタデータを表示';

  @override
  String get infoAuto => '自動';

  @override
  String get infoBackedUp => 'バックアップ済み';

  @override
  String get infoCamera => 'カメラ';

  @override
  String get infoChangeAdjust => '色を調整しました';

  @override
  String get infoChangeCrop => 'トリミングしました';

  @override
  String get infoChangeFlip => '反転しました';

  @override
  String get infoChangeInpaint => '領域を塗りつぶしました';

  @override
  String get infoChangeLocal => '領域を調整しました';

  @override
  String get infoChangeLut => '色調フィルターを適用しました';

  @override
  String get infoChangeOther => '編集しました';

  @override
  String get infoChangeTurn => '回転しました';

  @override
  String get infoCompare => 'オリジナルと比較';

  @override
  String infoConfidence(String percent) {
    return '信頼度: $percent';
  }

  @override
  String get infoCopyPath => 'パスをコピー';

  @override
  String get infoCurrent => '現在';

  @override
  String get infoDescription => '説明を追加';

  @override
  String get infoEditDate => '日付を編集';

  @override
  String infoEditNumber(int number) {
    return '編集 $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '$name の編集済みコピー';
  }

  @override
  String get infoFaces => '顔';

  @override
  String get infoFile => 'ファイル';

  @override
  String get infoFromFileName => 'ファイル名から';

  @override
  String get infoHistory => '編集履歴';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => '場所';

  @override
  String get infoMap => '撮影場所の地図';

  @override
  String get infoMapAgree => '地図タイルはインターネットから読み込まれ、見ている地域が分かります';

  @override
  String infoMegapixels(String megapixels) {
    return '$megapixels MP';
  }

  @override
  String infoNewTag(String path) {
    return '新しいタグ: $path';
  }

  @override
  String get infoNoAlbum => 'どのアルバムにもありません';

  @override
  String get infoOnDevice => 'このデバイス上';

  @override
  String get infoOriginal => 'オリジナル';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString ピクセル';
  }

  @override
  String infoRemoveFrom(String album) {
    return '$album から削除';
  }

  @override
  String infoRemoveTag(String tag) {
    return '$tag を削除';
  }

  @override
  String infoRemovedFrom(String album) {
    return '$album から削除しました';
  }

  @override
  String get infoRevert => '元に戻す';

  @override
  String get infoSaveCopy => 'コピーとして保存';

  @override
  String get infoShared => '共有中';

  @override
  String get infoShowFaces => '写真に顔を表示';

  @override
  String get infoShowMap => '地図を表示';

  @override
  String get infoTags => 'タグ';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のバージョン',
    );
    return '$_temp0 · 最終 $time';
  }

  @override
  String get infoWhy => 'この日付の理由';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': 'ファイル内の $tag から読み取りました',
      'name': 'ファイル名から読み取りました',
      'folder': 'フォルダ名から読み取りました',
      'host': 'ファイルの提供元サービスによる日付です',
      'unknown': 'ファイルに日付の手がかりがないため、最終更新日を使っています',
      'other': 'ファイルをまだ読み取っていないため、デバイスが示す日付を使っています',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {
      'true': 'リスト',
      'other': 'グリッド',
    });
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': '名前',
      'taken': '撮影日',
      'modified': '更新日',
      'size': 'サイズ',
      'random': 'ランダム',
      'extension': '種類',
      'custom': 'アルバムの順序',
      'other': '撮影日',
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
  String get languageDevice => 'デバイスの言語';

  @override
  String get languageName => '日本語';

  @override
  String get libraryAddFolder => 'フォルダを追加';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '未バックアップ',
      'backed_up': 'バックアップ済み',
      'cloud_only': 'クラウドのみ',
      'other': 'すべて',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': 'すべてバックアップ済みです',
      'backed_up': 'バックアップ済みの項目はまだありません',
      'cloud_only': 'サーバーにしかない項目はありません',
      'other': 'ここには何もありません',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => 'バックアップバッジ';

  @override
  String get libraryEmpty => 'ここに写真が表示されます';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': '週ごとにグループ化',
      'month': '月ごとにグループ化',
      'other': '日ごとにグループ化',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => '非表示とアーカイブの項目を再び隠す';

  @override
  String get libraryNoKeyring =>
      'Photolib はライブラリの鍵をシステムのキーリングに保管していますが、キーリングが起動していないかロックされています。GNOME Keyring や KWallet などのキーリングを起動またはロック解除してから、もう一度お試しください。';

  @override
  String get libraryRevealExcluded => '除外したフォルダを 5 分間表示';

  @override
  String get libraryShowVeiled => '非表示とアーカイブの項目を 5 分間表示';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': '最近追加した項目',
      'other': '撮影日',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed => 'Photolib はこのデバイスに保存されたライブラリを開けませんでした';

  @override
  String get libraryViewOptions => '表示オプション';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'サムネイルを準備中: $totalString 件中 $doneString 件';
  }

  @override
  String get libraryZoomIn => 'サムネイルを大きく';

  @override
  String get libraryZoomOut => 'サムネイルを小さく';

  @override
  String get mapAddTrack => 'GPX トラックを追加';

  @override
  String get mapArea => '地図の範囲';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get mapClearLasso => '選択を解除';

  @override
  String get mapEmpty => '場所のある写真はまだありません';

  @override
  String get mapHeat => 'ヒートマップ';

  @override
  String get mapLasso => '写真の周りを囲んで選択';

  @override
  String get mapLoading => '写真を地図に配置しています';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '写真: $countString';
  }

  @override
  String get mapSearchHere => 'この範囲を検索';

  @override
  String get mapSplit => '地図の下に写真を表示';

  @override
  String get mapTilesAgree =>
      '地図の背景は OpenStreetMap のサーバー (tile.openstreetmap.org) から取得され、見ている範囲が伝わります';

  @override
  String get mapTilesShow => '背景を表示';

  @override
  String get mapTime => '期間';

  @override
  String get mapTitle => '地図';

  @override
  String get mapTrackBad => 'このファイルには GPX トラックがありません';

  @override
  String get mapTrips => '旅行';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': 'お気に入り',
      'hidden': '非表示',
      'archived': 'アーカイブ済み',
      'offline': 'この端末に保持済み',
      'offline': 'この端末に保持済み',
      'offline': 'この端末に保持済み',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => 'アクセスを許可';

  @override
  String get mediaAccessNone => 'Photolib で写真と動画を表示するには、写真と動画へのアクセス権が必要です。';

  @override
  String get mediaAccessPartial =>
      'Photolib がアクセスできるのは、選択した写真と動画のみです。ギャラリーとして使うには、すべての写真と動画へのアクセス権が必要です。';

  @override
  String get mediaAccessSelect => '写真をさらに選択';

  @override
  String get nameLabel => '名前';

  @override
  String get nextAddRoot =>
      'サーバーの設定で external_roots にフォルダを追加してから、サーバーを再起動してください。';

  @override
  String get nextAskAdmin => 'サーバーの管理者にお問い合わせください。';

  @override
  String get nextAskOwner => 'ライブラリの所有者に、写真を追加できるようにしてもらってください。';

  @override
  String get nextCheckConnection => '原因を調べるには接続を確認してください。';

  @override
  String get nextCheckEntry => '入力内容を確認して、もう一度お試しください。';

  @override
  String get nextConfirm => '影響を受けるアイテムの数を確認してから、確定してください。';

  @override
  String get nextDeleteWebhook => '使わなくなった Webhook を削除してから、もう一度お試しください。';

  @override
  String get nextEditConfig => 'サーバーの設定で変更してから、サーバーを再起動してください。';

  @override
  String get nextFreeSpace => '空き容量を増やすか、管理者に追加を依頼してください。';

  @override
  String get nextNewLink => '管理者に新しいリンクを依頼してください。';

  @override
  String get nextNewestToken => 'photolibd のログから最新のものをコピーしてください。';

  @override
  String get nextOtherAdmin => '先に別のアカウントを管理者にしてください。';

  @override
  String get nextOtherFolder => '専用のフォルダを選んでください。';

  @override
  String get nextRefresh => '更新してからもう一度お試しください。';

  @override
  String get nextReport => 'もう一度お試しください。再び起きる場合は、下の詳細をコピーして管理者に伝えてください。';

  @override
  String get nextSetUpPrivate => '設定で非公開ライブラリの設定を完了してから、もう一度お試しください。';

  @override
  String get nextSignIn => 'もう一度ログインしてください。';

  @override
  String get nextSignInAccount => 'ご自分のアカウントでログインして、もう一度お試しください。';

  @override
  String get nextSignInInstead => '代わりにログインしてください。';

  @override
  String get nextTryAgain => 'もう一度お試しください。';

  @override
  String get nextUpdateAndAgree => 'アプリを更新してから、もう一度通知に同意してください。';

  @override
  String get nextUseAnother => '別のものを選んでください。';

  @override
  String get nextUseHttps => 'サーバーの https:// アドレスを使うか、サーバーと同じネットワークから接続してください。';

  @override
  String get nextWait => '1 分ほど待ってからもう一度お試しください。';

  @override
  String get offlineKeep => 'オフラインで保持';

  @override
  String offlineKeepHere(String size) {
    return 'この端末に保持（$size）';
  }

  @override
  String get offlineKeptHere => 'この端末に保持済み';

  @override
  String get offlineStopKeeping => 'オフライン保持をやめる';

  @override
  String get otherFiles => 'その他のファイル';

  @override
  String get passphraseCreate =>
      'このコンピュータには Photolib の鍵を保管するキーリング（Secret Service）が動作していません。鍵を保護するため、10 文字以上のパスフレーズを決めてください。Photolib は起動するたびにこれを尋ねます。';

  @override
  String get passphraseLabel => 'パスフレーズ';

  @override
  String get passphraseMismatch => 'パスフレーズが一致しません。';

  @override
  String get passphraseRepeat => 'パスフレーズ（確認）';

  @override
  String get passphraseTooShort => '10 文字以上にしてください。';

  @override
  String get passphraseUnlock => 'このコンピュータで Photolib の鍵を保護しているパスフレーズを入力してください。';

  @override
  String get passphraseWrong => 'パスフレーズが違います。もう一度お試しください。';

  @override
  String photoPosition(int index, int count) {
    return '$count 枚中 $index 枚目の写真';
  }

  @override
  String get privacyCheckKit => 'リカバリーキットを確認';

  @override
  String get privacyDrillDue =>
      'リカバリー訓練の時期です。リカバリーキットで今も非公開ライブラリのロックを解除できるか確認してください。';

  @override
  String get privacyHonest =>
      '非公開ライブラリはお使いのデバイス上で暗号化され、ほかの誰も開けません。サーバーも、その管理者も、Photolib の開発者も開けません。パスワードとリカバリーキットの両方を失うと、写真は永久に失われ、誰も取り戻すことはできません。';

  @override
  String get privacyKitBody =>
      'この 24 個の単語を順番どおりに紙に書き、安全な場所に保管してください。パスワードを忘れたとき、これで非公開ライブラリのロックを解除できます。これを持っている人なら誰でも解除できます。';

  @override
  String get privacyKitDone => 'リカバリーキットは有効です。';

  @override
  String get privacyKitOther => 'これは現在のリカバリーキットではありません。';

  @override
  String get privacyKitTitle => 'あなたのリカバリーキット';

  @override
  String get privacyKitUnverified => 'リカバリーキットはまだ確認されていません';

  @override
  String privacyKitVerified(String date) {
    return 'リカバリーキットを $date に確認済み';
  }

  @override
  String get privacyKitWritten => '書き留めました';

  @override
  String get privacyNotReady =>
      'ロックを解除する方法が 2 つあり、リカバリーキットを確認するまで、非公開アップロードはオフのままです。';

  @override
  String get privacyPasswordHelp =>
      'アカウントのパスワードを入力してください。非公開ライブラリのロックを解除する方法の 1 つになります。';

  @override
  String get privacyPhrase => 'リカバリーフレーズ';

  @override
  String get privacyPhraseHelp => 'リカバリーキットの 24 個の単語';

  @override
  String get privacyPhraseInvalid => 'リカバリーフレーズではありません。すべての単語を確認してください。';

  @override
  String get privacyReady => '非公開アップロードはオンです。';

  @override
  String get privacyRecoveryKit => 'リカバリーキット';

  @override
  String get privacySetUp => '設定する';

  @override
  String get privacyShowWords => '単語をもう一度表示';

  @override
  String get privacyTitle => '非公開ライブラリ';

  @override
  String privacyUnknownWord(int number) {
    return '$number 番目の単語はリカバリーキットの単語ではありません。';
  }

  @override
  String get privacyVerify => '確認';

  @override
  String get privacyVerifyBody => '保存したことを示すため、リカバリーキットからこれらの単語を入力してください。';

  @override
  String get privacyWays => 'ロック解除の方法';

  @override
  String privacyWord(int number) {
    return '単語 $number';
  }

  @override
  String get privacyWordsDiffer => 'これらの単語はリカバリーキットと一致しません。書き留めた内容を確認してください。';

  @override
  String get privacyWrongPassword => 'アカウントのパスワードではありません。';

  @override
  String get problemAdminOnly => 'この操作は管理者だけが行えます。';

  @override
  String get problemBusy => 'サーバーが混み合っているか、再起動中です。';

  @override
  String get problemChanged => 'その間に変更されました。';

  @override
  String get problemConfirm => '確認なしでサーバーが処理できる数を超えるアイテムが非表示または削除されます';

  @override
  String get problemContribute => 'このライブラリに写真を追加することは許可されていません。';

  @override
  String get problemCopy => '詳細をコピー';

  @override
  String get problemDetails => '詳細';

  @override
  String get problemDiskLow => 'サーバーのディスクがほぼいっぱいのため、アップロードを一時停止しています。';

  @override
  String get problemEmailTaken => 'このメールアドレスは別のアカウントが使っています。';

  @override
  String get problemExists => 'すでに存在します。';

  @override
  String get problemFaceNotice => 'サーバーは、このアプリが表示しているより新しい版の顔に関する通知を求めています。';

  @override
  String get problemGone => 'サーバー上にもうありません。';

  @override
  String get problemHandleTaken => 'このログイン名は別のアカウントが使っています。';

  @override
  String get problemInterrupted => 'アップロードが中断されました。';

  @override
  String get problemInvalid => '無効な値があります';

  @override
  String get problemLastAdmin => 'サーバーには少なくとも 1 人の管理者が必要です。';

  @override
  String get problemLinkInvalid => 'このリンクは期限切れか、すでに使用されています。';

  @override
  String get problemLoginFailed => 'メールアドレス、ログイン名、またはパスワードが正しくありません。';

  @override
  String get problemMaintenanceKey =>
      'バックアップ、整合性チェック、完全削除を一時停止できるのは、API キーではなくログインしている場合のみです';

  @override
  String get problemNotAllowed => 'このアカウントではこの操作は許可されていません。';

  @override
  String get problemNotExternal => 'スキャンできるのはサーバー自身のフォルダのライブラリだけです。';

  @override
  String get problemOidcClaim => 'ログインプロバイダーが、このサーバーの受け付ける形であなたが誰かを伝えませんでした。';

  @override
  String get problemOidcDown => 'ログインプロバイダーがサーバーに応答しません。';

  @override
  String get problemOidcFailed => 'ログインプロバイダーがログインを拒否しました。';

  @override
  String get problemOidcNotAllowed => 'このアカウントはこの方法でログインできません。';

  @override
  String get problemOidcTaken => 'このログインはすでに別の Photolib アカウントに関連付けられています。';

  @override
  String get problemOidcUnknown => 'このサーバーはこのログイン方法を提供しなくなりました。';

  @override
  String get problemPasskeysOff => 'パスキーは、サーバーに公開アドレスが設定されてから使えます。';

  @override
  String get problemPinned => 'これは設定ファイルで指定されているため、ここでは変更できません。';

  @override
  String get problemPolicyOff => 'このサーバーではこの機能がオフになっています。';

  @override
  String get problemQuota => 'サーバー上のストレージがいっぱいです。';

  @override
  String get problemRestoreKey => 'バックアップを復元できるのは、API キーではなくログインしている場合のみです。';

  @override
  String get problemRootDiffers => 'このフォルダにはこのライブラリのファイルがありません';

  @override
  String get problemRootNotAllowed => 'このフォルダはサーバー設定の external_roots の下にありません';

  @override
  String get problemRootOverlaps => 'このフォルダは別のライブラリかサーバー自身のデータを含んでいるか、その中にあります';

  @override
  String get problemScanning => 'このライブラリはすでにスキャン中です';

  @override
  String get problemSecondFactor =>
      'このアカウントには認証コードやパスキーなどの 2 つ目の要素が必要ですが、このバージョンの Photolib はまだ提供できません。';

  @override
  String get problemSetupDone => 'このサーバーにはすでに管理者がいます。';

  @override
  String get problemSetupExpired => '時間がかかりすぎました。';

  @override
  String get problemSetupToken => 'このセットアップトークンは正しくありません。';

  @override
  String get problemSignedOut => 'サーバーからログアウトしています。';

  @override
  String get problemStepUp => 'この変更には、先にパスワードまたはコードが必要です。';

  @override
  String get problemStorage => 'サーバーがストレージにアクセスできません。';

  @override
  String get problemTooMany => '短時間に試行が多すぎます。';

  @override
  String get problemUnexpected => '予期しない問題が発生しました。';

  @override
  String get problemUnreachable => 'サーバーが応答しません。';

  @override
  String get problemUploadDamaged => 'ファイルが途中で変更されたか、破損しました。';

  @override
  String get problemUploadExpired =>
      'このアップロードはもうサーバーにありません。未完了のアップロードは 1 日で期限切れになります。';

  @override
  String get problemWebhookLimit => 'このアカウントには、作成できる上限まで Webhook があります。';

  @override
  String get problemWebhooksOff => 'このサーバーでは Webhook がオフになっています。';

  @override
  String get recoveryCode => '復旧コード';

  @override
  String get recoveryCodeAbout => 'キーストアがキーを失ったときに、このデバイスの Photolib のストアを開きます';

  @override
  String get recoveryCodeEnter => '復旧コードを入力';

  @override
  String get recoveryCreate => '復旧コードを作成';

  @override
  String get recoveryLater => '後で';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countString 件の変更はこのデバイスにしかありません。キーストアが Photolib のキーを失っても、復旧コードがあれば取り戻せます。',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      'この 24 個の単語を書き留めて、安全な場所に保管してください。キーストアのキーがなくても、このデバイスの Photolib のストアを開けます。以前のコードは置き換えられます。';

  @override
  String get recoveryUnlock => 'ロックを解除';

  @override
  String get recoveryWrong => 'このストアの復旧コードではありません';

  @override
  String get renameFind => '検索';

  @override
  String get renamePattern => '新しい名前';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': '長すぎます: 名前は 255 バイトまでです',
      'invalid': '無効なファイル名です',
      'duplicate': '別のファイルにも同じ名前が付きます',
      'exists': 'このフォルダの別のファイルがこの名前です',
      'other': '名前を変更できません',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => '置換後';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '名前を変更したファイル: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Finder で表示',
      'windows': 'エクスプローラーで表示',
      'other': 'フォルダーで表示',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => 'カメラ';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個のアイテム',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => '日付';

  @override
  String searchDays(String first, String last) {
    return '$first～$last';
  }

  @override
  String get searchEmpty => 'ライブラリを検索';

  @override
  String get searchFavourites => 'お気に入り';

  @override
  String get searchFolder => 'フォルダ';

  @override
  String get searchHint => 'ファイル名またはフォルダ名';

  @override
  String get searchMotionPhotos => 'モーションフォト';

  @override
  String get searchNothing => '一致するものはありません';

  @override
  String get searchPanoramas => 'パノラマ';

  @override
  String get searchPhotos => '写真';

  @override
  String get searchScreenshots => 'スクリーンショット';

  @override
  String get searchVideo => '動画';

  @override
  String get searchVideos => '動画';

  @override
  String get securityAddPasskey => 'パスキーを追加';

  @override
  String get securityCode => 'コード';

  @override
  String get securityCodesHelp =>
      'これらのコードは安全な場所に保管してください。各コードは 2 つ目の要素の代わりに 1 回だけ使え、表示されるのは今だけです。';

  @override
  String securityCodesLeft(int count) {
    return '未使用: $count';
  }

  @override
  String get securityNewCodes => '新しいコード';

  @override
  String get securityPasskeyNotAdded => 'パスキーは追加されませんでした。';

  @override
  String get securityRecoveryCodes => '復旧コード';

  @override
  String get securityRemovePasskey => 'パスキーを削除';

  @override
  String get securitySetUp => '設定';

  @override
  String get securityStepUpBody =>
      '2 つ目の要素を変更するには、パスワード、認証アプリのコード、または復旧コードを入力してください。';

  @override
  String get securityStepUpTitle => '本人確認';

  @override
  String get securityTitle => '2 つ目の要素';

  @override
  String get securityTotp => '認証アプリ';

  @override
  String get securityTotpHelp => 'このキーを認証アプリに追加し、表示されたコードを入力してください。';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': 'オン', 'other': 'オフ'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => 'オフにする';

  @override
  String get securityWrongCode => 'コードが正しくありません。';

  @override
  String get securityWrongProof => 'パスワードまたはコードが正しくありません。';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get selectionClear => '選択を解除';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個を選択中',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => '選択した項目を表示';

  @override
  String get serverAccount => 'メールアドレスまたはログイン名';

  @override
  String get serverAdd => 'サーバーを追加';

  @override
  String get serverAddressInvalid => 'photos.example.org のようなアドレスを入力してください';

  @override
  String get serverAddresses => 'アドレス';

  @override
  String get serverAddressesHelp =>
      '1 行に 1 つ：ネットワーク内、インターネット上、または VPN 経由のサーバー。応答したもののうち最も速いアドレスを使います。 または、送られてきたパスワード設定リンクを貼り付けてください。';

  @override
  String get serverCa => 'プライベート CA の証明書（PEM）';

  @override
  String get serverCaChoose => '証明書ファイルを選択';

  @override
  String serverCertificateBody(String host) {
    return '$host は、このデバイスが信頼していない証明書を提示しています。この SHA-256 フィンガープリントがあなたのサーバーのものである場合にのみ信頼してください：';
  }

  @override
  String get serverCertificateTitle => 'この証明書を信頼しますか？';

  @override
  String get serverConfirm => '確認';

  @override
  String get serverConnect => '接続';

  @override
  String get serverCreateAdmin => '管理者を作成';

  @override
  String get serverEnded => 'サーバーがこのセッションを終了しました。もう一度ログインしてください。';

  @override
  String get serverHandleHelp => '英小文字、数字、ピリオド、ハイフン、アンダースコア。変更はできません。';

  @override
  String get serverHeaders => 'カスタムヘッダー';

  @override
  String get serverHeadersHelp => '1 行に 1 つ、Name: value 形式で。HTTPS でのみ送信されます';

  @override
  String get serverHeadersInvalid => '各ヘッダーは Name: value 形式で書いてください';

  @override
  String get serverIdentity => 'クライアント証明書（PKCS#12）';

  @override
  String get serverIdentityChoose => 'クライアント証明書を選択';

  @override
  String get serverIdentityInvalid => '証明書（PKCS#12）ではないか、パスワードが間違っています。';

  @override
  String get serverIdentityPassword => 'クライアント証明書のパスワード';

  @override
  String get serverLoading => 'このデバイスに保存されたサーバーを読み込んでいます';

  @override
  String get serverNearby => 'このネットワーク上のサーバー';

  @override
  String get serverNeedsHttps =>
      'このサーバーには HTTPS のアドレスが必要です。ローカルネットワークの外では、Photolib は暗号化されていない HTTP でサインインしません。';

  @override
  String get serverNoSignIn =>
      'このサーバーには、このバージョンの Photolib が対応しているログイン方法がありません。';

  @override
  String get serverOffline => 'サーバーが応答しません。ログインしたままです。';

  @override
  String get serverPasskeyFailed => 'パスキーは使われませんでした。もう一度試すか、コードを使ってください。';

  @override
  String get serverPasskeyRequired =>
      'このサーバーではパスキーが必要ですが、このバージョンの Photolib はまだ使用できません。';

  @override
  String get serverPassword => 'パスワード';

  @override
  String get serverPasswordAgain => 'パスワード（確認）';

  @override
  String get serverPasswordSetupInvalid =>
      'このパスワード設定トークンは間違っているか、使用済みか、期限切れです。新しいものを依頼してください。';

  @override
  String get serverPasswordSetupToken => 'パスワード設定トークン';

  @override
  String get serverPasswordSetupTokenHelp =>
      '管理者から受け取るか、サーバーで photolibd admin password-setup が表示します。';

  @override
  String get serverPasswordsDiffer => 'パスワードが一致しません。';

  @override
  String get serverPrivateLibrariesBody =>
      '新しいパスワードでは開けません。リカバリーキット、パスキー、またはまだサインインしているデバイスで開き直してください。';

  @override
  String get serverPrivateLibrariesGo => 'パスワードを設定';

  @override
  String get serverPrivateLibrariesTitle => '非公開ライブラリはロックされたままです';

  @override
  String get serverProxy => 'HTTP プロキシ（host:port 形式）';

  @override
  String get serverProxyInvalid => 'プロキシは host:port 形式で入力してください';

  @override
  String get serverRecoveryCode => 'リカバリーコード';

  @override
  String get serverRemove => 'このサーバーを削除';

  @override
  String get serverRequired => '必須';

  @override
  String get serverSecondFactor =>
      'このアカウントの 2 つ目の要素はパスキーですが、このバージョンの Photolib はまだ使用できません。';

  @override
  String get serverSecondFactorCode => 'このアカウントには、認証アプリのコードまたは復旧コードも必要です。';

  @override
  String get serverSecondFactorTitle => '本人確認';

  @override
  String get serverSecondFactorWrong => 'うまくいきませんでした。5 回失敗したら、もう一度サインインしてください。';

  @override
  String get serverSetPassword => 'パスワードを設定';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '$server の $handle';
  }

  @override
  String get serverSetPasswordOpen => 'パスワードを設定';

  @override
  String get serverSetPasswordTitle => 'パスワードを設定してください';

  @override
  String get serverSetUp => '新しいサーバーをセットアップ';

  @override
  String get serverSetupLinkElsewhere =>
      'この設定リンクを使うには、まずこのサーバーからログアウトしてください。リンクが別のサーバーのものなら、このサーバーを削除してください。';

  @override
  String get serverSetupTitle => 'サーバーのセットアップ';

  @override
  String get serverSetupToken => 'セットアップトークン';

  @override
  String get serverSetupTokenHelp =>
      'サーバーに管理者がいない間、photolibd がログに出力します。起動するたびに新しいトークンが出力されます。';

  @override
  String get serverSignIn => 'ログイン';

  @override
  String get serverSignOut => 'ログアウト';

  @override
  String serverSignedInAs(String account) {
    return '$account としてログイン中';
  }

  @override
  String get serverSignedOut => 'ログアウト済み';

  @override
  String get serverSwitch => 'アカウントを切り替え';

  @override
  String get serverTotpCode => '認証アプリのコード';

  @override
  String get serverTrust => '信頼する';

  @override
  String get serverUnreadable => 'このデバイスに保存されたサーバーを読み込めません';

  @override
  String get serverUsePasskey => 'パスキーを使う';

  @override
  String get serverUseRecoveryCode => '代わりにリカバリーコードを使う';

  @override
  String get settingsBackground => '透明な画像の背景';

  @override
  String get settingsDefaultTab => 'フォルダとアルバムで最初に開くタブ';

  @override
  String get settingsFolders => 'フォルダ';

  @override
  String get settingsIndexing => 'このデバイスでのインデックス作成';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLibrary => 'ライブラリ';

  @override
  String get settingsServer => 'サーバー';

  @override
  String get settingsStart => '起動時の画面';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsTitle => '設定';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': '左端か右端をタップして前または次の項目へ',
      'oneFingerZoom': 'ダブルタップしてドラッグし、1本の指でズーム',
      'swipes': '動画の左側を上下にスワイプして明るさ、右側で音量を調整',
      'maxBrightness': '表示中は最大の明るさ',
      'autoRotate': '写真や動画ごとの向きに回転',
      'mixAudio': '他の音声を一時停止せずに重ねて動画を再生',
      'autoplay': '動画を開いたら再生',
      'loop': '動画をループ再生',
      'autoNext': '動画が終わったら次の項目へ',
      'resume': '動画を前回の位置から再開',
      'other': 'グリッドでアニメーション画像を再生',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => 'ビューアーのバーのボタン';

  @override
  String get settingsViewing => '表示';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '共有された写真と動画 $countString 件が、Photolib に写真ライブラリへの追加が許可されるのを待っています。保存されなかった項目は 7 日後に削除されます。',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge => '一度に共有するにはサイズが大きすぎます。選択する項目を減らしてください';

  @override
  String shareTooMany(int count) {
    return '一度に共有するには多すぎます。$count 件以下を選択してください';
  }

  @override
  String get shortcutsTitle => 'キーボードショートカット';

  @override
  String get slideshow => 'スライドショー';

  @override
  String get slideshowLoop => 'リピート';

  @override
  String get slideshowOptions => 'スライドショーのオプション';

  @override
  String get slideshowSeconds => '1 項目あたりの秒数';

  @override
  String get slideshowShuffle => 'シャッフル';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': '降順',
      'other': '昇順',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => 'このデバイス';

  @override
  String sourceHide(String name) {
    return '$name を非表示';
  }

  @override
  String get sourceHideOthers => 'ここのほかをすべて非表示';

  @override
  String get sourceLost => 'アクセスできません';

  @override
  String get sourcePartly => '一部を表示';

  @override
  String sourceShow(String name) {
    return '$name を表示';
  }

  @override
  String get sourceShowEverything => 'ここをすべて表示';

  @override
  String get sourceShowOnly => 'これだけを表示';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': 'タイムライン',
      'folders': 'フォルダとアルバム',
      'favourites': 'お気に入り',
      'other': 'タイムライン',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => '人物をオフラインで保持';

  @override
  String get storageBudget => 'ストレージ上限';

  @override
  String get storageClear => 'オフラインコピーを削除';

  @override
  String get storageClearAction => '削除';

  @override
  String storageClearBody(String size) {
    return 'この端末に保持している$sizeを削除し、アルバム、検索、写真のオフライン保持をやめます。サーバー上のライブラリには影響しません。';
  }

  @override
  String get storageKeepLibrary => 'ライブラリ全体を保持';

  @override
  String get storageKeepOriginals => 'オリジナルも保持';

  @override
  String get storageNoPeople => '名前のついた人物はまだいません。';

  @override
  String get storageNoPins => '固定したものはありません。アルバム、検索、写真を固定するとオフラインで使えます。';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'アルバム',
      'search': '検索',
      'person': '人物',
      'library': 'ライブラリ全体',
      'asset': '写真',
      'other': '固定済み',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return '上限に収まりません：あと$size必要です';
  }

  @override
  String get storagePinNothing => 'ダウンロードするものはありません：写真はすでにこの端末にあります';

  @override
  String get storagePinPaused => '待機中：このプリセットは何もオフライン保持しません';

  @override
  String get storagePinPlanning => '保持するものを確認中…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return 'ダウンロード中：$filesString件中$haveString件';
  }

  @override
  String storagePinReady(String size) {
    return 'オフラインで利用可能（$size）';
  }

  @override
  String get storagePinWaiting => 'オンラインになったらダウンロードします';

  @override
  String get storagePins => 'オフライン保持';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': 'カタログのみ',
      'spaceSaver': '容量節約',
      'travel': '選んだアルバムをオフライン',
      'everything': 'すべて',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '何も保持しません。写真は開くときにサーバーから読み込みます。',
      'spaceSaver': 'ライブラリ全体のプレビューを新しい順に、上限内で保持します。',
      'travel': '固定したものだけを保持します：アルバム、検索、写真。',
      'everything': 'ライブラリ全体のオリジナルを新しい順に、上限内で保持します。',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => 'この端末が保持するもの';

  @override
  String get storageSubtitle => 'オフラインコピーとストレージ上限';

  @override
  String get storageTitle => 'ストレージ';

  @override
  String storageUsed(String used, String budget) {
    return '$budget中$usedを使用';
  }

  @override
  String get storageWebNote => 'ブラウザーはプレビューのみ保持し、サインアウト時に消去します。';

  @override
  String get storeNoKeyring =>
      'Photolib はローカルストアのキーをシステムのキーリングに保管していますが、応答がありませんでした。Secret Service を有効にして gnome-keyring、KWallet、KeePassXC のいずれかをインストールしてロックを解除し、もう一度お試しください。';

  @override
  String get storeNoKeystore =>
      'Photolib は、ローカルストアのキーを保管しているこのデバイスのキーストアにアクセスできませんでした。';

  @override
  String get storeRebuilt =>
      'このデバイスのキーストアに Photolib のローカルストアのキーがなくなっていたため、ストアを再構築しました。設定と、このデバイスにしかなかったものは失われました。ライブラリは再び同期され、サムネイルは戻ります。';

  @override
  String get storeRecoveryNeeded =>
      'このデバイスのキーストアに Photolib のローカルストアのキーがなくなりました。復旧コードを入力するか、ストアをリセットしてください。リセットすると、このデバイスにしかないものは失われます。';

  @override
  String get storeReset => 'ストアをリセット';

  @override
  String get storeResetBody => 'このデバイスにしかないものは失われます。ライブラリは再び同期され、サムネイルは戻ります。';

  @override
  String get storeUnavailable => 'このデバイスのストアを利用できません。設定とコレクションは保存されません';

  @override
  String get tabCollections => 'コレクション';

  @override
  String get tabLibrary => 'ライブラリ';

  @override
  String get tabSearch => '検索';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeSystem => 'システム設定に従う';

  @override
  String get timelineBenchmark => 'タイムラインのベンチマーク';

  @override
  String get timelineBenchmarkCopy => '結果をコピー';

  @override
  String get timelineCannotPlay => 'このブラウザでは再生できません';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date、$count 件中 $position 件目';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date、$count 件中 $position 件目、プレビューなし';
  }

  @override
  String get timelineExcluded => '除外したフォルダ内';

  @override
  String get timelineScrubber => '日付でスクロール';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => '日付不明';

  @override
  String timelineWeek(String date) {
    return '$date の週';
  }

  @override
  String toolbarAdd(String action) {
    return '$action をバーに追加';
  }

  @override
  String toolbarDown(String action) {
    return '$action を下へ移動';
  }

  @override
  String get toolbarInBar => 'バーに表示';

  @override
  String get toolbarInMenu => '⋮ メニューに表示';

  @override
  String toolbarRemove(String action) {
    return '$action をバーから削除';
  }

  @override
  String get toolbarReset => 'デフォルトに戻す';

  @override
  String toolbarUp(String action) {
    return '$action を上へ移動';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': 'ここに移動',
      'other': 'ここにコピー',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': '同じ名前のファイルまたはフォルダがすでにあります',
      'changed': 'コピーが元のファイルと一致しなかったため削除しました',
      'cancelled': 'キャンセルしました',
      'invalid': '無効なフォルダ名です',
      'other': '失敗しました',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => '最近使用';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個の項目を完全に削除しますか？元に戻すことはできません。',
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
      other: '残り $daysString 日',
      zero: '今日完全に削除されます',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => 'ゴミ箱は空です';

  @override
  String get trashEmptyAll => 'ゴミ箱を空にする';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個の項目をゴミ箱に移動しました',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib はゴミ箱の中身を $days 日後に完全に削除します。各項目に残り時間が表示されます。';
  }

  @override
  String get trashTitle => 'ゴミ箱';

  @override
  String get undo => '元に戻す';

  @override
  String get uploadAction => '写真と動画をアップロード';

  @override
  String get uploadClear => 'クリア';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$totalString 件中 $doneString 件をアップロード済み';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '失敗: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 個の項目をアーカイブしました',
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
      other: '$countString 個の項目を非表示にしました',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': '黒',
      'white': '白',
      'other': '市松模様',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => 'この動画はこのデバイスでは再生できません';

  @override
  String get viewerCaptions => '字幕';

  @override
  String get viewerCompass => 'コンパスロック';

  @override
  String get viewerCopy => 'コピー';

  @override
  String get viewerCopyText => 'テキストをコピー';

  @override
  String get viewerCustomize => 'ツールバーをカスタマイズ…';

  @override
  String get viewerDial =>
      '方角。クリックで正面を向きます。ドラッグで見回し、スクロールかピンチでズーム、ダブルクリックでリセット';

  @override
  String get viewerFilmstrip => 'フィルムストリップ';

  @override
  String get viewerFirst => '最初';

  @override
  String get viewerFisheye => '魚眼';

  @override
  String get viewerGyroscope => '端末を動かして見回す';

  @override
  String get viewerHdr => 'HDRで表示';

  @override
  String get viewerInfo => '情報';

  @override
  String get viewerInfoLoading => 'この項目の情報を読み込んでいます';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString 件中 $positionString 件目';
  }

  @override
  String get viewerLast => '最後';

  @override
  String get viewerLenses => 'レンズを選択';

  @override
  String get viewerMap => '地図';

  @override
  String get viewerMotion => 'モーションを再生';

  @override
  String get viewerMotionDenied => 'このブラウザーはモーションセンサーへのアクセスを許可しませんでした';

  @override
  String get viewerMotionMissing => 'この端末にはジャイロスコープがないため、動かして見回せません';

  @override
  String get viewerMute => 'ミュート';

  @override
  String get viewerNext => '次へ';

  @override
  String get viewerNextFrame => '次のフレーム';

  @override
  String get viewerPause => '一時停止';

  @override
  String get viewerPlanet => 'リトルプラネット';

  @override
  String get viewerPlay => '再生';

  @override
  String get viewerPrevious => '前へ';

  @override
  String get viewerPreviousFrame => '前のフレーム';

  @override
  String get viewerRotate => '回転';

  @override
  String get viewerSdr => 'SDRで表示';

  @override
  String get viewerSeek => '再生位置';

  @override
  String get viewerSetAs => '登録';

  @override
  String get viewerShare => '共有';

  @override
  String get viewerSpeed => '再生速度';

  @override
  String get viewerSphere => '360° ビュー。ドラッグで見回し、ピンチでズーム';

  @override
  String get viewerText => 'この写真のテキスト';

  @override
  String get viewerTextCopied => 'テキストをコピーしました';

  @override
  String get viewerTextNone => 'この写真にテキストは見つかりませんでした';

  @override
  String get viewerTextUnread => 'この写真のテキストはまだ読み取られていません';

  @override
  String get viewerUnmute => 'ミュート解除';

  @override
  String get viewerZoomIn => '拡大';

  @override
  String get viewerZoomOut => '縮小';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'sd': 'SD カード',
      'other': '内部',
    });
    return '$_temp0';
  }

  @override
  String get zoomIn => '拡大';

  @override
  String get zoomOut => '縮小';
}
