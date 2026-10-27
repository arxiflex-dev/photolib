// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get actionAddToAlbum => '앨범에 추가';

  @override
  String get actionArchive => '보관';

  @override
  String get actionCopyTo => '복사할 위치…';

  @override
  String get actionDeleteForever => '영구 삭제';

  @override
  String get actionFavourite => '즐겨찾기';

  @override
  String get actionHide => '숨기기';

  @override
  String get actionMoveTo => '이동할 위치…';

  @override
  String get actionRename => '이름 바꾸기';

  @override
  String get actionRestore => '복원';

  @override
  String get actionShare => '공유';

  @override
  String get actionTrash => '휴지통으로 이동';

  @override
  String get actionUnarchive => '보관 해제';

  @override
  String get actionUndo => '실행취소';

  @override
  String get actionUnfavourite => '즐겨찾기에서 삭제';

  @override
  String get actionUnhide => '숨기기 해제';

  @override
  String adminAccountStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'active': '활성',
      'disabled': '사용 중지됨',
      'invited': '초대됨',
      'deleted': '삭제됨',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String get adminAccounts => '계정';

  @override
  String get adminAddAccount => '계정 추가';

  @override
  String get adminAddExternalLibrary => '외부 라이브러리 추가';

  @override
  String adminAttempts(String status, int attempts) {
    String _temp0 = intl.Intl.pluralLogic(
      attempts,
      locale: localeName,
      other: '$attempts회 시도',
      zero: '아직 실행되지 않음',
    );
    return '$status, $_temp0';
  }

  @override
  String get adminAudit => '감사 로그';

  @override
  String get adminBackUpNow => '지금 백업';

  @override
  String get adminBackupQueued => '백업이 대기열에 추가되었습니다. 이어서 복원 훈련이 실행됩니다';

  @override
  String get adminBackups => '데이터베이스 백업';

  @override
  String get adminCancelJob => '작업 취소';

  @override
  String get adminCapabilities => '기능';

  @override
  String adminCapability(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'managed_libraries': '관리 라이브러리',
      'uploads': '기기, 웹, CLI에서 업로드',
      'folder_browser': '폴더 탐색기',
      'device_folders': '연결된 앱의 기기 폴더',
      'sharing': '공유 및 공개 링크',
      'edits': '편집',
      'deletes': '삭제',
      'xmp_writes': 'XMP 사이드카 쓰기',
      'face_recognition': '얼굴 인식',
      'ml_search': '스마트 검색',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String adminCheck(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'ok': '정상',
      'warn': '경고',
      'fail': '실패',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String get adminCopied => '복사됨';

  @override
  String get adminCopyBundle => '버그 신고용 진단 정보 복사';

  @override
  String get adminCopyLink => '링크 복사';

  @override
  String get adminDelete => '삭제';

  @override
  String get adminDeviceBackups => '기기 백업';

  @override
  String get adminDevices => '내 기기';

  @override
  String get adminDisable => '사용 중지';

  @override
  String adminDrillFailed(String detail) {
    return '마지막 복원 훈련이 실패했습니다: $detail';
  }

  @override
  String get adminEdit => '수정';

  @override
  String get adminEmail => '이메일';

  @override
  String get adminEnable => '사용 설정';

  @override
  String get adminErrorSignIn => '관리자로 로그인하세요';

  @override
  String get adminFacesDefault => '새 계정에 얼굴 인식을 기본으로 사용 설정';

  @override
  String get adminFiles => '종류별 파일';

  @override
  String adminFinding(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'content': '손상됨',
      'missing': '없음',
      'size': '크기 불일치',
      'hash': '교체됨',
      'orphan': '고아 파일',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String adminFree(String size) {
    return '$size 사용 가능';
  }

  @override
  String get adminFreeDisk => '디스크 여유 공간이 이 비율(%, 0~50) 미만이면 업로드 일시중지';

  @override
  String get adminFreeDiskGb =>
      '또는 이 값(GB, 0~100000)이 더 작으면 여유 공간이 그 미만일 때 일시중지';

  @override
  String get adminHandle => '로그인 이름';

  @override
  String get adminIntegrity => '무결성';

  @override
  String adminItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $countString개',
    );
    return '$_temp0';
  }

  @override
  String adminJobStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'queued': '대기 중',
      'running': '실행 중',
      'done': '완료됨',
      'dead': '실패',
      'cancelled': '취소됨',
      'other': '전체',
    });
    return '$_temp0';
  }

  @override
  String get adminJobType => '작업 유형(예: render)';

  @override
  String get adminJobs => '작업';

  @override
  String adminLastSeen(String time) {
    return '마지막 접속: $time';
  }

  @override
  String get adminLibraries => '라이브러리';

  @override
  String get adminLibraryOwner => '소유자';

  @override
  String get adminLibraryRoot => '서버의 폴더(예: /srv/photos)';

  @override
  String adminLibraryState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'online': '온라인',
      'offline': '오프라인',
      'scanning': '스캔 중',
      'error': '오류',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String get adminLog => '서버 로그';

  @override
  String get adminName => '이름';

  @override
  String get adminNothing => '아직 항목이 없습니다';

  @override
  String get adminOutOfRange => '범위를 벗어났습니다';

  @override
  String get adminOverview => '개요';

  @override
  String get adminPair => '기기 페어링';

  @override
  String get adminPairBody =>
      '이 코드를 스캔하거나 링크를 보낸 뒤 새 기기의 Photolib에서 서버 추가에 붙여 넣으세요. 이 서버의 모든 주소와 인증서가 함께 전달되므로 아무도 입력할 필요가 없습니다.';

  @override
  String get adminPasswordSetup => '비밀번호 설정 링크';

  @override
  String adminPasswordSetupBody(String name, String date) {
    return '이 링크를 아무 방법으로나 $name님에게 보내거나 코드를 스캔하게 하세요. $date까지 한 번 비밀번호를 설정할 수 있습니다.';
  }

  @override
  String get adminPause => '작업 유형 일시중지';

  @override
  String adminPauseMinutes(int max) {
    return '분(1~$max)';
  }

  @override
  String adminPausedUntil(String type, String time) {
    return '$type 작업이 $time까지 일시중지됨';
  }

  @override
  String adminPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '백업할 항목 $countString개',
      zero: '백업할 항목 없음',
    );
    return '$_temp0';
  }

  @override
  String get adminPolicies => '정책';

  @override
  String get adminPolicyReset => '상위 수준의 값 사용';

  @override
  String adminPolicySource(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'default': '기본적으로 켜짐',
      'server': '서버에 설정됨',
      'user': '이 계정에 설정됨',
      'library': '이 라이브러리에 설정됨',
      'config': '구성에서 설정됨',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String get adminPreset => '프리셋 적용';

  @override
  String get adminPresetBody =>
      '프리셋은 서버의 모든 기능을 설정하고 계정과 라이브러리에서 설정한 값을 지웁니다. 모두 나중에 변경할 수 있습니다.';

  @override
  String adminPresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '아카이브 보기',
      'family_backup': '가족 백업',
      'personal': '개인용',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String adminPresetSummary(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'archive_viewer': '읽기 전용 외부 라이브러리만을 기준으로 삼습니다. 업로드, 관리 라이브러리, 기기 폴더, 편집, 삭제, XMP 쓰기가 없습니다',
      'family_backup': 'XMP 쓰기를 제외하고 모두 켜짐',
      'personal': '공유 및 공개 링크를 제외하고 모두 켜짐',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String get adminQrCode => '링크의 QR 코드';

  @override
  String adminQueued(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '작업 $countString개가 대기열에 추가됨',
      zero: '처리할 작업 없음',
    );
    return '$_temp0';
  }

  @override
  String get adminQuota => '저장용량 할당량(GB, 비워 두면 무제한)';

  @override
  String get adminRemote => '원격 접속';

  @override
  String get adminRemoteBody =>
      '라우터의 포트를 열지 않고 어디서든 서버에 접속하세요. 한 가지 방법을 고르세요. 어느 방법이든 앱에 추가할 HTTPS 주소를 서버에 제공합니다. 그런 다음 외부에서 테스트하세요.';

  @override
  String get adminRemoteCloudflare =>
      'cloudflared가 Cloudflare로 바깥쪽 연결을 맺고, Cloudflare가 도메인을 HTTPS로 제공합니다. 무료 요금제는 요청 하나를 100MB로 제한하지만 백업은 한 번에 8MiB씩 보내므로 한도에 닿지 않습니다.';

  @override
  String get adminRemoteNoAddress => '외부에서 테스트하려면 이 앱에 서버의 https:// 주소를 추가하세요.';

  @override
  String get adminRemoteReachable => '외부에서 접속할 수 있습니다.';

  @override
  String get adminRemoteTailscale =>
      '서버 컴퓨터와 모든 기기에 같은 tailnet 또는 사용자의 Headscale로 Tailscale을 설치한 뒤, 서버 컴퓨터에서 이 명령을 실행하고 표시된 주소로 public_url을 설정하세요.';

  @override
  String get adminRemoteTest => '외부에서 테스트';

  @override
  String adminRemoteTestAsk(String host, String url) {
    return '$host가 전 세계 서버에서 $url을(를) 열게 되며, 그에 따라 이 주소를 알게 됩니다. 계속할까요?';
  }

  @override
  String get adminRemoteUnreachable =>
      '외부에서 접속할 수 없습니다. 선택한 방법을 확인한 뒤 다시 테스트하세요.';

  @override
  String get adminRemoteWireguard =>
      '서버 쪽이나 중계 노드에 열린 UDP 포트가 하나 필요합니다. 기기용 설정입니다. 키는 wg genkey로 만드세요.';

  @override
  String get adminRepair => '백업이나 아직 이 파일이 있는 기기에서 복원하세요';

  @override
  String get adminRepairOrphan => '어떤 사진도 이 파일을 가리키지 않습니다: 확인한 뒤 삭제하거나 보관하세요';

  @override
  String get adminReprocess => '다시 처리';

  @override
  String get adminReprocessFaces => '얼굴 다시 감지';

  @override
  String get adminReprocessFolder => '폴더(예: 2024/05, 비워 두면 라이브러리 전체)';

  @override
  String get adminReprocessMetadata => '메타데이터 다시 읽기';

  @override
  String get adminReprocessRenditions => '썸네일 및 미리보기 다시 생성';

  @override
  String get adminRestore => '복원';

  @override
  String adminRestoreFailed(String name, String detail) {
    return '$name 복원에 실패했습니다: $detail';
  }

  @override
  String get adminRestoreUnverified => '아직 통과한 복원 훈련이 없습니다';

  @override
  String adminRestoreVerified(String when) {
    return '마지막으로 검증된 복원: $when';
  }

  @override
  String adminRestoreWarning(String name) {
    return 'photolibd가 멈춘 뒤 다시 시작할 때 전체 데이터베이스를 $name(으)로 바꿉니다. 그 백업 이후의 변경 사항은 사라지고 모든 기기가 처음부터 다시 동기화합니다.';
  }

  @override
  String get adminRestoring => '백업을 복원하기 위해 photolibd를 멈추는 중입니다';

  @override
  String get adminResume => '재개';

  @override
  String get adminRetry => '다시 시도';

  @override
  String adminRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': '관리자',
      'user': '사용자',
      'viewer': '뷰어',
      'other': '알 수 없음',
    });
    return '$_temp0';
  }

  @override
  String get adminSaved => '저장됨';

  @override
  String get adminScan => '지금 스캔';

  @override
  String get adminScrubDays => '검사가 모든 원본을 확인하는 일수, 1~3650';

  @override
  String get adminScrubNever => '첫 전체 검사 진행 중';

  @override
  String adminScrubbed(String time) {
    return '마지막 전체 검사 $time';
  }

  @override
  String get adminSecondAdmin =>
      '본인이 관리할 수 없을 때도 다른 사람이 서버를 운영하고 복원할 수 있도록 두 번째 사람을 관리자로 지정하세요.';

  @override
  String adminSilent(String time) {
    return '$time부터 응답 없음';
  }

  @override
  String get adminSilentHours => '기기 백업을 응답 없음으로 볼 때까지 보고가 없는 시간, 1~8760';

  @override
  String get adminStores => '저장소';

  @override
  String get adminThisDevice => '이 기기';

  @override
  String get adminTitle => '서버 관리';

  @override
  String get adminTrashDays => '휴지통 보관 일수(1~3650)';

  @override
  String get adminTwoFactor => '모든 계정은 2단계 인증을 반드시 설정해야 함';

  @override
  String get adminUsage => '계정별 사용량';

  @override
  String get albumCover => '커버로 사용';

  @override
  String get albumEmpty => '이 앨범은 비어 있습니다';

  @override
  String get albumHideMemories => '추억에서 숨기기';

  @override
  String get albumHideTimeline => '타임라인에서 숨기기';

  @override
  String get albumNew => '새 앨범';

  @override
  String get appTitle => 'Photolib';

  @override
  String get backupAnyDate => '모든 날짜';

  @override
  String get backupCap => '가장 큰 항목';

  @override
  String get backupCharging => '충전 중에만';

  @override
  String backupCompleted(String time) {
    return '마지막 전체 백업: $time';
  }

  @override
  String backupContact(String time) {
    return '서버와 마지막 연결: $time';
  }

  @override
  String get backupEnabled => '이 기기 백업';

  @override
  String get backupFolderNo => '이 폴더는 제외';

  @override
  String get backupFolderYes => '백업';

  @override
  String backupHours(int count) {
    return '$count시간';
  }

  @override
  String get backupMetered => '데이터 통신 네트워크(모바일 데이터, 핫스팟 등)';

  @override
  String get backupNever => '아직 전체 백업이 없습니다';

  @override
  String backupNewFolder(String name) {
    return '새 폴더 $name: 백업할까요?';
  }

  @override
  String get backupNoLimit => '제한 없음';

  @override
  String get backupNothing => '대기 중인 항목 없음';

  @override
  String get backupNow => '지금 백업';

  @override
  String backupOverdue(int hours, String items) {
    return '$hours시간 동안 전체 백업이 없습니다. 대기 중: $items';
  }

  @override
  String get backupOverdueTitle => '백업이 완료되지 않았습니다';

  @override
  String backupPending(String items) {
    return '대기 중: $items';
  }

  @override
  String backupRetry(String time) {
    return '다시 시도: $time';
  }

  @override
  String get backupRoaming => '로밍 중에도 백업';

  @override
  String get backupSignIn => '이 기기를 백업하려면 서버에 로그인하세요';

  @override
  String get backupSignedOut =>
      '백업이 중지되었습니다: 서버가 이 기기를 로그아웃했습니다. 설정에서 다시 로그인하세요.';

  @override
  String get backupSince => '이 날짜 이후 촬영';

  @override
  String backupStopped(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'offline': '서버에 연결될 때까지 백업이 대기합니다',
      'charging': '기기가 충전될 때까지 백업이 대기합니다',
      'battery_low': '백업 대기 중: 배터리가 부족합니다',
      'roaming': '로밍 중에는 백업이 대기합니다',
      'quota': '백업이 중지되었습니다: 서버의 저장 공간이 가득 찼습니다',
      'second_factor': '백업이 중지되었습니다: 서버가 이 계정에 2단계 인증을 요구합니다',
      'other': '백업이 중지되었습니다: 서버 응답 $code',
    });
    return '$_temp0';
  }

  @override
  String get backupTitle => '백업';

  @override
  String get backupWaiting => '백업되지 않음';

  @override
  String get backupWarnAfter => '완료되지 않으면 경고할 시간';

  @override
  String get backupWhat => '백업할 항목';

  @override
  String backupWhy(String reason, String code) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'folder_excluded': '선택하지 않은 폴더에 있음',
      'folder_new': '새 폴더에 있음: 백업할지 선택하세요',
      'type_excluded': '선택하지 않은 종류의 항목',
      'before_date': '선택한 날짜 이전에 촬영됨',
      'selected': '차례를 기다리는 중',
      'server_restored': '서버가 복원 중 잃어버려 다시 보내는 중',
      'working': '백업 중',
      'waiting_for_icloud': 'iCloud에서 다운로드 대기 중',
      'metered': '데이터 통신이 아닌 네트워크 대기 중',
      'metered_cap': '데이터 통신 네트워크에는 너무 큼',
      'unreadable': '이 기기에서 읽을 수 없음',
      'changed': '보내는 동안 변경됨',
      'quota': '서버의 저장 공간이 가득 참',
      'other': '서버가 거부함: $code',
    });
    return '$_temp0';
  }

  @override
  String get checkAppTooOld => '이 서버는 더 이상 이 버전의 Photolib와 작동하지 않습니다.';

  @override
  String get checkAppTooOldNext => 'Photolib를 업데이트하세요.';

  @override
  String get checkChanged => '서버 인증서가 신뢰했던 인증서와 다릅니다.';

  @override
  String get checkChangedNext =>
      '관리자가 교체했다면 새 인증서를 신뢰하세요. 그렇지 않다면 누군가 엿듣고 있을 수 있으니 계속하지 마세요.';

  @override
  String get checkClock => '이 기기의 시계와 서버의 시계가 5분 넘게 차이 납니다.';

  @override
  String get checkClockNext => '기기에서 날짜와 시간을 자동으로 설정하도록 하세요.';

  @override
  String get checkDnsFailed => '서버 이름으로 주소를 찾을 수 없습니다.';

  @override
  String get checkDnsFailedNext => '주소를 확인하거나 서버가 있는 네트워크에 연결하세요.';

  @override
  String checkExpired(String date) {
    return '서버 인증서가 $date에 만료되었습니다.';
  }

  @override
  String get checkFailed => '실패';

  @override
  String get checkMetered => '모바일 데이터 같은 데이터 요금제 네트워크에 연결되어 있습니다.';

  @override
  String get checkMeteredNext => '대용량 백업 전에 Wi-Fi에 연결하세요.';

  @override
  String get checkNotPhotolib =>
      'Photolib가 아닌 다른 것이 응답합니다. 예를 들어 프록시 오류 페이지나 Wi-Fi 로그인 페이지입니다.';

  @override
  String get checkNotPhotolibNext =>
      '브라우저에서 Wi-Fi에 로그인하거나 관리자에게 프록시 확인을 요청하세요.';

  @override
  String get checkOtherServer => '이 주소에서 다른 Photolib 서버가 응답합니다.';

  @override
  String get checkPassed => '통과';

  @override
  String get checkRefused => '이 주소에서 응답하는 것이 없습니다.';

  @override
  String get checkRefusedNext => '서버가 실행 중인지, 서버의 네트워크나 VPN에 연결되어 있는지 확인하세요.';

  @override
  String get checkRun => '연결 확인하기';

  @override
  String get checkRunning => '확인 중';

  @override
  String get checkSelfSigned => '서버가 자체 인증서를 사용하는데, 이 기기는 아직 그 인증서를 모릅니다.';

  @override
  String get checkSkipped => '확인 안 됨';

  @override
  String get checkStepAuth => '로그인 상태';

  @override
  String get checkStepClock => '기기 시계';

  @override
  String get checkStepDns => '서버 주소 찾기';

  @override
  String get checkStepNetwork => '네트워크';

  @override
  String get checkStepServer => '서버의 Photolib';

  @override
  String get checkStepTcp => '서버에 연결';

  @override
  String get checkStepTls => '보안 연결 및 인증서';

  @override
  String get checkStepUpload => '프록시를 통한 대용량 업로드';

  @override
  String get checkTimedOut => '서버가 응답하는 데 너무 오래 걸립니다.';

  @override
  String get checkTimedOutNext => '연결을 확인한 뒤 다시 시도하세요.';

  @override
  String get checkTitle => '연결 확인';

  @override
  String get checkTlsFailed => '보안 연결에 실패했습니다.';

  @override
  String get checkTrustNext => '지문이 서버의 지문과 일치할 때만 신뢰하세요.';

  @override
  String get checkUntrusted => '서버 인증서가 이 기기가 신뢰하지 않는 기관에서 발급되었습니다.';

  @override
  String get checkUploadCap => '경로상의 프록시가 대용량 업로드를 거부하여 백업이 작은 조각으로 느리게 진행됩니다.';

  @override
  String get checkUploadCapNext => '관리자에게 64MB 요청이 프록시를 통과하도록 허용해 달라고 요청하세요.';

  @override
  String get collectionAlbums => '앨범';

  @override
  String collectionHide(String name) {
    return '$name 숨기기';
  }

  @override
  String collectionMoveDown(String name) {
    return '$name 아래로 이동';
  }

  @override
  String collectionMoveUp(String name) {
    return '$name 위로 이동';
  }

  @override
  String get collectionPeople => '인물';

  @override
  String collectionPin(String name) {
    return '$name 고정';
  }

  @override
  String get collectionPlaces => '장소';

  @override
  String collectionShow(String name) {
    return '$name 표시';
  }

  @override
  String get collectionTags => '태그';

  @override
  String collectionUnpin(String name) {
    return '$name 고정 해제';
  }

  @override
  String get collectionsCustomise => '맞춤설정';

  @override
  String get collectionsDone => '완료';

  @override
  String get commandPalette => '명령 팔레트';

  @override
  String get commandPaletteHint => '명령 입력';

  @override
  String deleteBoth(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이 기기에 있고 백업됨: $countString개',
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
      other: '이 기기에만 있고 백업 안 됨: $countString개',
    );
    return '$_temp0';
  }

  @override
  String get deleteICloud =>
      'iCloud 사진이 켜져 있으면 이 기기에서 삭제한 항목이 iCloud와 다른 Apple 기기에서도 삭제됩니다.';

  @override
  String deleteLibrary(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '라이브러리에만 있음: $countString개',
    );
    return '$_temp0';
  }

  @override
  String get deleteRemove => '이 기기에서 제거';

  @override
  String deleteRemoveWhat(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '백업된 항목 $countString개, 라이브러리에는 그대로 남습니다',
    );
    return '$_temp0';
  }

  @override
  String get deleteSpaceReturns =>
      '이 기기의 사본은 기기의 휴지통으로 이동합니다. 휴지통을 비우면 공간이 확보됩니다.';

  @override
  String deleteTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $countString개를 삭제할까요?',
    );
    return '$_temp0';
  }

  @override
  String deleteTrashWhere(String where) {
    String _temp0 = intl.Intl.selectLogic(where, {
      'both': '이 기기와 라이브러리에서',
      'device': '이 기기에서만',
      'other': '라이브러리에서',
    });
    return '$_temp0';
  }

  @override
  String get deviceFolderAbsent => '없음';

  @override
  String get deviceFolderCard => 'SD 카드';

  @override
  String get deviceFolderExclude => '제외';

  @override
  String get deviceFolderExcludeThis => '이 폴더 제외';

  @override
  String get deviceFolderExcludedNotice => '이 항목의 폴더는 라이브러리에서 제외되어 있습니다';

  @override
  String get deviceFolderForget => '목록에서 삭제';

  @override
  String get deviceFolderInternal => '내부 저장소';

  @override
  String get deviceFolderKeep => '유지';

  @override
  String deviceFolderNew(String name, String items) {
    return '새 폴더: $name, $items';
  }

  @override
  String get deviceFolders => '기기 폴더';

  @override
  String get deviceFoldersAll => '제외한 폴더를 빼고 모든 폴더 표시';

  @override
  String get deviceFoldersChosen => '선택한 폴더만 표시';

  @override
  String get deviceFoldersExcludedNow => '라이브러리에서 제외됨';

  @override
  String get deviceFoldersSearch => '폴더 검색';

  @override
  String get diagnosticsAdvanced => '진단 표시';

  @override
  String get diagnosticsAllLoggers => '모든 로거';

  @override
  String get diagnosticsCopied => '로그를 복사했습니다';

  @override
  String get diagnosticsCopy => '표시된 로그 복사';

  @override
  String get diagnosticsEmpty => '아직 로그 항목이 없습니다';

  @override
  String get diagnosticsExport => '진단 번들 내보내기';

  @override
  String get diagnosticsExported => '진단 번들을 저장했습니다';

  @override
  String get diagnosticsLevel => '수준';

  @override
  String get diagnosticsLogger => '로거';

  @override
  String get diagnosticsTitle => '진단';

  @override
  String get download => '다운로드';

  @override
  String get downloadCurrent => '현재 버전(편집 포함)';

  @override
  String get downloadFailed => '다운로드할 수 없습니다';

  @override
  String get downloadOriginal => '원본';

  @override
  String downloadSaved(String name) {
    return '$name을(를) 저장했습니다';
  }

  @override
  String get downloadVersion => '어떤 버전을 받을까요?';

  @override
  String downloading(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString개 다운로드 중',
    );
    return '$_temp0';
  }

  @override
  String get editorAutoEnhance => '자동 보정';

  @override
  String get editorCrop => '자르기';

  @override
  String get editorCropOriginal => '원본';

  @override
  String get editorCropSquare => '정사각형';

  @override
  String get editorEdit => '편집';

  @override
  String get editorFlip => '뒤집기';

  @override
  String get editorRotate => '회전';

  @override
  String get editorSaveCopy => '사본 저장';

  @override
  String get editorSaveFailed => '사본을 저장하지 못했습니다';

  @override
  String get editorSaveVersion => '저장';

  @override
  String get editorSaved => '사본으로 저장됨';

  @override
  String get editorVersionFailed => '버전을 저장하지 못했습니다';

  @override
  String get editorVersionSaved => '새 버전으로 저장했습니다';

  @override
  String get editorVersionsUnsupported => '이 서버는 아직 편집한 사진의 버전을 보관할 수 없습니다';

  @override
  String editsRejected(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '변경 사항 $countString개가 취소되었습니다: 서버에서 거부했습니다.',
    );
    return '$_temp0';
  }

  @override
  String get editsRejectedDismiss => '닫기';

  @override
  String get editsRejectedForbidden => '항목을 볼 수는 있지만 변경할 수는 없습니다.';

  @override
  String get editsRejectedInvalid => '서버에서 변경 사항을 받아들일 수 없습니다.';

  @override
  String get editsRejectedNotFound => '항목이 삭제되었거나 더 이상 공유되지 않습니다.';

  @override
  String get errorNotFound => '존재하지 않는 페이지입니다';

  @override
  String get errorRetry => '다시 시도';

  @override
  String get errorTitle => '문제가 발생했습니다';

  @override
  String faceNumber(int number) {
    return '얼굴 $number';
  }

  @override
  String get facesAgree => '동의합니다';

  @override
  String get facesAura => 'AuraFace로 얼굴 설명 (더 큰 다운로드)';

  @override
  String get facesNotNow => '나중에';

  @override
  String get facesNoticeKeep =>
      '찾은 정보는 사진과 함께 기기와 서버에 남습니다. 얼굴을 나타내는 정보는 표시되거나 공유되지 않으며, 중지하거나 사진을 삭제하면 모두 삭제됩니다.';

  @override
  String get facesNoticeOptional =>
      '선택 사항입니다. Photolib의 다른 기능은 이것 없이도 작동하며, 설정에서 언제든 중지할 수 있습니다.';

  @override
  String get facesNoticeTitle => '사진에서 얼굴을 찾을까요?';

  @override
  String get facesNoticeWhat =>
      'Photolib은 사진과 동영상에서 얼굴을 찾고, 얼굴마다 위치와 그 얼굴을 나타내는 숫자 목록을 저장하여 같은 사람을 다시 찾을 수 있게 합니다. 이러한 정보는 생체 정보에 해당할 수 있습니다.';

  @override
  String get facesNoticeWhere =>
      '이 작업은 이 기기에서, 로그인한 경우 직접 운영하는 서버에서 이루어집니다. 저희나 다른 누군가가 운영하는 서비스에서는 절대 이루어지지 않습니다.';

  @override
  String get facesServerFailed => '서버에 알리지 못했습니다. 다시 시도하세요.';

  @override
  String get facesServerOff => '서버가 나를 위해 얼굴을 찾지 않습니다';

  @override
  String get facesServerOn => '서버가 나를 위해 얼굴을 찾습니다';

  @override
  String get facesServerUnavailable => '서버가 얼굴 인식을 제공하지 않습니다';

  @override
  String facesStatusDownloading(int percent) {
    return '얼굴 모델 다운로드 중: $percent%';
  }

  @override
  String get facesStatusMissing => '서버에 얼굴 모델이 설치되어 있지 않습니다';

  @override
  String get facesStatusNoDecoder =>
      '얼굴 찾기를 사용할 수 없습니다. 이미지 라이브러리(libvips)를 찾지 못했습니다. Photolib을 다시 설치하거나 libvips를 설치한 뒤 다시 시작하세요.';

  @override
  String get facesStatusRunning => '이 기기에서 얼굴을 찾는 중';

  @override
  String get facesStatusUnavailable => '이 기기에서는 얼굴을 찾을 수 없습니다';

  @override
  String get facesStatusWaiting => '얼굴 모델은 Wi-Fi에서 다운로드됩니다';

  @override
  String get facesSwitch => '내 사진에서 얼굴 찾기';

  @override
  String get facesSwitchOff => '꺼짐. 동의하기 전에는 얼굴에 관한 어떤 것도 계산하지 않습니다.';

  @override
  String get facesSwitchOn => '켜짐. Photolib이 사진 속 얼굴을 찾습니다.';

  @override
  String get facesTitle => '얼굴과 사람';

  @override
  String get facesWithdraw => '삭제하고 중지';

  @override
  String get facesWithdrawBody =>
      'Photolib이 찾은 모든 얼굴, 설명 정보, 사람을 이 기기와 서버에서 삭제합니다. 사진은 바뀌지 않습니다.';

  @override
  String get facesWithdrawTitle => '얼굴 찾기를 중지할까요?';

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

    return '변경되지 않은 파일: $countString';
  }

  @override
  String get folderAllow => '이 폴더에 대한 액세스 허용';

  @override
  String get folderDelete => '폴더 삭제';

  @override
  String folderDeleteBody(String name) {
    return '$name의 사진과 동영상을 휴지통으로 이동할까요?';
  }

  @override
  String folderItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $countString개',
    );
    return '$_temp0';
  }

  @override
  String get folderNew => '새 폴더';

  @override
  String folderOffline(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '오프라인, 항목 $countString개',
    );
    return '$_temp0';
  }

  @override
  String get folderOverlaps => '이 폴더 또는 이 폴더의 상위 폴더나 하위 폴더가 이미 라이브러리에 있습니다';

  @override
  String get folderRemove => '폴더 제거';

  @override
  String folderRemoveBody(String folder) {
    return '$folder의 사진과 동영상이 라이브러리에서 제거됩니다. 파일은 디스크에 그대로 남아 있습니다.';
  }

  @override
  String get folderRemoveConfirm => '제거';

  @override
  String folderScanning(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '스캔 중, 지금까지 항목 $countString개 발견',
    );
    return '$_temp0';
  }

  @override
  String get foldersAllow => '액세스 허용';

  @override
  String get foldersHideExcluded => '제외된 폴더 숨기기';

  @override
  String foldersLost(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photolib에서 폴더 $countString개를 더 이상 읽을 수 없습니다.',
    );
    return '$_temp0';
  }

  @override
  String foldersShowExcluded(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '제외된 폴더 표시($countString)';
  }

  @override
  String get foldersUnsupported =>
      '이 브라우저에서는 폴더를 라이브러리로 유지할 수 없습니다. 컴퓨터의 Chrome 또는 Edge에서 Photolib을 열거나 데스크톱 앱을 사용하세요.';

  @override
  String get galleryButtons => '버튼';

  @override
  String galleryCameraNote(String camera) {
    return 'Your camera app ($camera) decides where its preview opens. Aperture, Open Camera and Fossify Camera open Photolib. The cameras of Pixel, Samsung, Xiaomi and Motorola open their own gallery.';
  }

  @override
  String get galleryChips => '칩';

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
  String get galleryGrid => '그리드';

  @override
  String get galleryMenus => '메뉴 및 시트';

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
  String get galleryShowSheet => '시트 표시';

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
  String get galleryTitle => '구성요소';

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
    return '숨김($count)';
  }

  @override
  String get indexingAllowMetered => '모바일 데이터로 다운로드';

  @override
  String get indexingAllowSaver => '절전 모드에서도 실행';

  @override
  String get indexingBattery => '충전기 없이 필요한 배터리';

  @override
  String get indexingChargingOnly => '충전 중에만';

  @override
  String indexingDownloading(int percent) {
    return '검색 모델 다운로드 중: $percent%';
  }

  @override
  String indexingFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사진 $count장을 읽을 수 없음',
    );
    return '$_temp0';
  }

  @override
  String get indexingLite => '이 기기는 새 사진만 색인합니다';

  @override
  String get indexingMissing => '서버에 검색 모델이 설치되지 않았습니다';

  @override
  String get indexingModels => '이 기기에서 검색';

  @override
  String indexingModelsFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '$host에서 검색 모델(${megabytesString}MB)을 다운로드합니다';
  }

  @override
  String get indexingNoDecoder =>
      '검색과 텍스트 읽기를 사용할 수 없습니다. 이미지 라이브러리(libvips)를 찾지 못했습니다. Photolib을 다시 설치하거나 libvips를 설치한 뒤 다시 시작하세요.';

  @override
  String indexingPausedBattery(int percent) {
    return '배터리가 $percent% 미만인 동안 일시 중지됨';
  }

  @override
  String get indexingPausedCharger => '기기가 충전될 때까지 일시 중지됨';

  @override
  String get indexingPausedHeat => '기기가 뜨거운 동안 일시 중지됨';

  @override
  String get indexingPausedSaver => '절전 모드가 켜져 있는 동안 일시 중지됨';

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

    return '색인된 사진: $totalString장 중 $doneString장';
  }

  @override
  String get indexingText => '사진 속 텍스트 읽기';

  @override
  String indexingTextDownloading(int percent) {
    return '텍스트 모델 다운로드 중: $percent%';
  }

  @override
  String indexingTextFrom(int megabytes, String host) {
    final intl.NumberFormat megabytesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String megabytesString = megabytesNumberFormat.format(megabytes);

    return '텍스트 모델($megabytesString MB)을 $host에서 다운로드하여 사진 속 단어를 찾습니다';
  }

  @override
  String get indexingTextMissing => '서버에 텍스트 모델이 설치되어 있지 않습니다';

  @override
  String get indexingTextPlatform =>
      '휴대전화의 자체 텍스트 인식을 사용합니다. 다운로드할 것이 없습니다. 새 사진을 읽습니다';

  @override
  String indexingTextProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '텍스트를 읽은 사진: $doneString / $totalString';
  }

  @override
  String get indexingTextUnavailable => '여기서는 텍스트 읽기를 사용할 수 없습니다';

  @override
  String get indexingTextWaiting => '텍스트 모델은 Wi-Fi에서 다운로드됩니다';

  @override
  String get indexingUnavailable => '이 기기에서는 검색을 사용할 수 없습니다';

  @override
  String get indexingWaiting => '검색 모델은 Wi-Fi에서 다운로드됩니다';

  @override
  String get infoAddName => '이름 추가';

  @override
  String get infoAddTag => '태그 추가';

  @override
  String get infoAlbums => '앨범';

  @override
  String get infoAllMetadata => '모든 메타데이터 보기';

  @override
  String get infoAuto => '자동';

  @override
  String get infoBackedUp => '백업됨';

  @override
  String get infoCamera => '카메라';

  @override
  String get infoChangeAdjust => '색상을 조정함';

  @override
  String get infoChangeCrop => '잘라냄';

  @override
  String get infoChangeFlip => '좌우 반전함';

  @override
  String get infoChangeInpaint => '영역을 채움';

  @override
  String get infoChangeLocal => '영역을 조정함';

  @override
  String get infoChangeLut => '색상 스타일을 적용함';

  @override
  String get infoChangeOther => '편집함';

  @override
  String get infoChangeTurn => '회전함';

  @override
  String get infoCompare => '원본과 비교';

  @override
  String infoConfidence(String percent) {
    return '신뢰도: $percent';
  }

  @override
  String get infoCopyPath => '경로 복사';

  @override
  String get infoCurrent => '현재';

  @override
  String get infoDescription => '설명 추가';

  @override
  String get infoEditDate => '날짜 편집';

  @override
  String infoEditNumber(int number) {
    return '편집 $number';
  }

  @override
  String infoEditedCopyOf(String name) {
    return '$name의 편집된 사본';
  }

  @override
  String get infoFaces => '얼굴';

  @override
  String get infoFile => '파일';

  @override
  String get infoFromFileName => '파일 이름에서';

  @override
  String get infoHistory => '편집 기록';

  @override
  String infoItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 항목',
    );
    return '$_temp0';
  }

  @override
  String get infoLocation => '위치';

  @override
  String get infoMap => '촬영 위치 지도';

  @override
  String get infoMapAgree => '지도 타일은 인터넷에서 받아오며 보고 있는 지역이 드러납니다';

  @override
  String infoMegapixels(String megapixels) {
    return '${megapixels}MP';
  }

  @override
  String infoNewTag(String path) {
    return '새 태그: $path';
  }

  @override
  String get infoNoAlbum => '앨범에 없음';

  @override
  String get infoOnDevice => '이 기기에 있음';

  @override
  String get infoOriginal => '원본';

  @override
  String infoPixels(int width, int height) {
    final intl.NumberFormat widthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String widthString = widthNumberFormat.format(width);
    final intl.NumberFormat heightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String heightString = heightNumberFormat.format(height);

    return '$widthString × $heightString 픽셀';
  }

  @override
  String infoRemoveFrom(String album) {
    return '$album에서 제거';
  }

  @override
  String infoRemoveTag(String tag) {
    return '$tag 제거';
  }

  @override
  String infoRemovedFrom(String album) {
    return '$album에서 제거됨';
  }

  @override
  String get infoRevert => '되돌리기';

  @override
  String get infoSaveCopy => '사본으로 저장';

  @override
  String get infoShared => '공유됨';

  @override
  String get infoShowFaces => '사진에 얼굴 표시';

  @override
  String get infoShowMap => '지도 표시';

  @override
  String get infoTags => '태그';

  @override
  String infoVersions(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '버전 $count개',
    );
    return '$_temp0 · 마지막 $time';
  }

  @override
  String get infoWhy => '이 날짜인 이유';

  @override
  String infoWhyBecause(String source, String tag) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'metadata': '파일의 $tag에서 읽음',
      'name': '파일 이름에서 읽음',
      'folder': '폴더 이름에서 읽음',
      'host': '파일을 가져온 서비스가 제공함',
      'unknown': '파일에 날짜를 알 수 있는 정보가 없어 마지막으로 수정된 날짜를 사용함',
      'other': '파일을 아직 읽지 않아 기기가 제공한 날짜를 사용함',
    });
    return '$_temp0';
  }

  @override
  String itemLayout(String list) {
    String _temp0 = intl.Intl.selectLogic(list, {'true': '목록', 'other': '그리드'});
    return '$_temp0';
  }

  @override
  String itemSort(String sort) {
    String _temp0 = intl.Intl.selectLogic(sort, {
      'name': '이름',
      'taken': '촬영 날짜',
      'modified': '수정 날짜',
      'size': '크기',
      'random': '무작위',
      'extension': '유형',
      'custom': '앨범 순서',
      'other': '촬영 날짜',
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
  String get languageDevice => '기기 언어';

  @override
  String get languageName => '한국어';

  @override
  String get libraryAddFolder => '폴더 추가';

  @override
  String libraryBackup(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '백업 안 됨',
      'backed_up': '백업됨',
      'cloud_only': '클라우드에만 있음',
      'other': '전체',
    });
    return '$_temp0';
  }

  @override
  String libraryBackupEmpty(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'not_backed_up': '모두 백업되었습니다',
      'backed_up': '아직 백업된 항목이 없습니다',
      'cloud_only': '서버에만 있는 항목이 없습니다',
      'other': '항목이 없습니다',
    });
    return '$_temp0';
  }

  @override
  String get libraryBadges => '백업 배지';

  @override
  String get libraryEmpty => '여기에 사진이 표시됩니다';

  @override
  String libraryGroup(String grouping) {
    String _temp0 = intl.Intl.selectLogic(grouping, {
      'week': '주별로 그룹화',
      'month': '월별로 그룹화',
      'other': '일별로 그룹화',
    });
    return '$_temp0';
  }

  @override
  String get libraryHideVeiled => '숨긴 항목과 보관된 항목 다시 숨기기';

  @override
  String get libraryNoKeyring =>
      'Photolib은 라이브러리 키를 시스템 키링에 보관하는데, 키링이 실행 중이 아니거나 잠겨 있습니다. GNOME Keyring 또는 KWallet 같은 키링을 실행하거나 잠금 해제한 다음 다시 시도하세요.';

  @override
  String get libraryRevealExcluded => '제외한 폴더를 5분 동안 표시';

  @override
  String get libraryShowVeiled => '숨긴 항목과 보관된 항목을 5분 동안 표시';

  @override
  String librarySort(String added) {
    String _temp0 = intl.Intl.selectLogic(added, {
      'true': '최근 추가된 항목',
      'other': '촬영 날짜',
    });
    return '$_temp0';
  }

  @override
  String get libraryStoreFailed => 'Photolib이 이 기기에 저장된 라이브러리를 열 수 없습니다';

  @override
  String get libraryViewOptions => '보기 옵션';

  @override
  String libraryWarming(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '미리보기 이미지 준비 중: $totalString개 중 $doneString개';
  }

  @override
  String get libraryZoomIn => '썸네일 크게';

  @override
  String get libraryZoomOut => '썸네일 작게';

  @override
  String get mapAddTrack => 'GPX 트랙 추가';

  @override
  String get mapArea => '지도 영역';

  @override
  String get mapAttribution => '© OpenStreetMap 기여자';

  @override
  String get mapClearLasso => '선택 해제';

  @override
  String get mapEmpty => '위치가 있는 사진이 아직 없습니다';

  @override
  String get mapHeat => '히트맵';

  @override
  String get mapLasso => '사진 주위를 그려 선택';

  @override
  String get mapLoading => '사진을 지도에 배치하는 중';

  @override
  String mapPhotos(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '사진: $countString';
  }

  @override
  String get mapSearchHere => '이 영역에서 검색';

  @override
  String get mapSplit => '지도 아래에 사진 표시';

  @override
  String get mapTilesAgree =>
      '지도 배경은 OpenStreetMap 서버(tile.openstreetmap.org)에서 가져오며, 서버는 보고 있는 영역을 알게 됩니다';

  @override
  String get mapTilesShow => '배경 표시';

  @override
  String get mapTime => '기간';

  @override
  String get mapTitle => '지도';

  @override
  String get mapTrackBad => '이 파일에는 GPX 트랙이 없습니다';

  @override
  String get mapTrips => '여행';

  @override
  String mark(String mark) {
    String _temp0 = intl.Intl.selectLogic(mark, {
      'favourite': '즐겨찾기',
      'hidden': '숨김',
      'archived': '보관됨',
      'offline': '이 기기에 보관됨',
      'offline': '이 기기에 보관됨',
      'offline': '이 기기에 보관됨',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get mediaAccessAllow => '액세스 허용';

  @override
  String get mediaAccessNone =>
      'Photolib이 사진과 동영상을 표시하려면 사진 및 동영상에 액세스할 수 있어야 합니다.';

  @override
  String get mediaAccessPartial =>
      'Photolib은 선택한 사진과 동영상만 볼 수 있습니다. 갤러리로 사용하려면 모든 사진과 동영상에 액세스할 수 있어야 합니다.';

  @override
  String get mediaAccessSelect => '사진 더 선택';

  @override
  String get nameLabel => '이름';

  @override
  String get nextAddRoot => '서버 설정의 external_roots에 폴더를 추가한 뒤 서버를 다시 시작하세요.';

  @override
  String get nextAskAdmin => '서버 관리자에게 문의하세요.';

  @override
  String get nextAskOwner => '라이브러리 소유자에게 사진을 추가할 수 있게 해 달라고 요청하세요.';

  @override
  String get nextCheckConnection => '원인을 보려면 연결을 확인하세요.';

  @override
  String get nextCheckEntry => '입력한 내용을 확인하고 다시 시도하세요.';

  @override
  String get nextConfirm => '영향을 받는 항목 수를 확인한 뒤 확정하세요.';

  @override
  String get nextDeleteWebhook => '더 이상 사용하지 않는 웹훅을 삭제한 뒤 다시 시도하세요.';

  @override
  String get nextEditConfig => '서버 설정에서 변경한 뒤 서버를 다시 시작하세요.';

  @override
  String get nextFreeSpace => '공간을 확보하거나 관리자에게 더 요청하세요.';

  @override
  String get nextNewLink => '관리자에게 새 링크를 요청하세요.';

  @override
  String get nextNewestToken => 'photolibd 로그에서 가장 최근 토큰을 복사하세요.';

  @override
  String get nextOtherAdmin => '먼저 다른 계정을 관리자로 지정하세요.';

  @override
  String get nextOtherFolder => '전용 폴더를 선택하세요.';

  @override
  String get nextRefresh => '새로 고친 뒤 다시 시도하세요.';

  @override
  String get nextReport => '다시 시도하세요. 다시 발생하면 아래 자세한 내용을 복사해 관리자에게 전달하세요.';

  @override
  String get nextSetUpPrivate => '설정에서 비공개 라이브러리 설정을 마친 뒤 다시 시도하세요.';

  @override
  String get nextSignIn => '다시 로그인하세요.';

  @override
  String get nextSignInAccount => '본인 계정으로 로그인한 뒤 다시 시도하세요.';

  @override
  String get nextSignInInstead => '대신 로그인하세요.';

  @override
  String get nextTryAgain => '다시 시도하세요.';

  @override
  String get nextUpdateAndAgree => '앱을 업데이트한 다음 안내에 다시 동의하세요.';

  @override
  String get nextUseAnother => '다른 것을 선택하세요.';

  @override
  String get nextUseHttps => '서버의 https:// 주소를 사용하거나 서버와 같은 네트워크에서 연결하세요.';

  @override
  String get nextWait => '1분 정도 기다렸다가 다시 시도하세요.';

  @override
  String get offlineKeep => '오프라인으로 보관';

  @override
  String offlineKeepHere(String size) {
    return '이 기기에 보관($size)';
  }

  @override
  String get offlineKeptHere => '이 기기에 보관됨';

  @override
  String get offlineStopKeeping => '오프라인 보관 중지';

  @override
  String get otherFiles => '기타 파일';

  @override
  String get passphraseCreate =>
      '이 컴퓨터에는 Photolib의 키를 보관할 키링(Secret Service)이 실행되고 있지 않습니다. 키를 보호할 10자 이상의 암호 문구를 정하세요. Photolib이 시작할 때마다 이를 묻습니다.';

  @override
  String get passphraseLabel => '암호 문구';

  @override
  String get passphraseMismatch => '암호 문구가 일치하지 않습니다.';

  @override
  String get passphraseRepeat => '암호 문구 확인';

  @override
  String get passphraseTooShort => '10자 이상 사용하세요.';

  @override
  String get passphraseUnlock => '이 컴퓨터에서 Photolib의 키를 보호하는 암호 문구를 입력하세요.';

  @override
  String get passphraseWrong => '암호 문구가 틀렸습니다. 다시 시도하세요.';

  @override
  String photoPosition(int index, int count) {
    return '사진 $count장 중 $index번째';
  }

  @override
  String get privacyCheckKit => '복구 키트 확인';

  @override
  String get privacyDrillDue =>
      '복구 연습을 할 때입니다. 복구 키트로 아직 비공개 라이브러리의 잠금을 해제할 수 있는지 확인하세요.';

  @override
  String get privacyHonest =>
      '비공개 라이브러리는 내 기기에서 암호화되며 다른 누구도 열 수 없습니다. 서버도, 서버 관리자도, Photolib 개발자도 열 수 없습니다. 비밀번호와 복구 키트를 모두 잃어버리면 사진은 영원히 사라지며 누구도 되찾아 드릴 수 없습니다.';

  @override
  String get privacyKitBody =>
      '이 24개 단어를 순서대로 종이에 적어 안전한 곳에 보관하세요. 비밀번호를 잊었을 때 비공개 라이브러리의 잠금을 해제하며, 이 단어를 가진 사람은 누구나 해제할 수 있습니다.';

  @override
  String get privacyKitDone => '복구 키트가 작동합니다.';

  @override
  String get privacyKitOther => '현재 복구 키트가 아닙니다.';

  @override
  String get privacyKitTitle => '내 복구 키트';

  @override
  String get privacyKitUnverified => '복구 키트가 아직 확인되지 않음';

  @override
  String privacyKitVerified(String date) {
    return '$date에 복구 키트 확인됨';
  }

  @override
  String get privacyKitWritten => '적어 두었습니다';

  @override
  String get privacyNotReady =>
      '잠금 해제 방법이 두 가지가 되고 복구 키트를 확인할 때까지 비공개 업로드는 꺼져 있습니다.';

  @override
  String get privacyPasswordHelp =>
      '계정 비밀번호를 입력하세요. 비공개 라이브러리의 잠금을 해제하는 방법 중 하나가 됩니다.';

  @override
  String get privacyPhrase => '복구 문구';

  @override
  String get privacyPhraseHelp => '복구 키트의 24개 단어';

  @override
  String get privacyPhraseInvalid => '복구 문구가 아닙니다. 모든 단어를 확인하세요.';

  @override
  String get privacyReady => '비공개 업로드가 켜져 있습니다.';

  @override
  String get privacyRecoveryKit => '복구 키트';

  @override
  String get privacySetUp => '설정';

  @override
  String get privacyShowWords => '단어 다시 보기';

  @override
  String get privacyTitle => '비공개 라이브러리';

  @override
  String privacyUnknownWord(int number) {
    return '$number번째 단어는 복구 키트 단어가 아닙니다.';
  }

  @override
  String get privacyVerify => '확인';

  @override
  String get privacyVerifyBody => '저장했다는 것을 보여 주려면 복구 키트에서 이 단어들을 입력하세요.';

  @override
  String get privacyWays => '잠금 해제 방법';

  @override
  String privacyWord(int number) {
    return '단어 $number';
  }

  @override
  String get privacyWordsDiffer => '이 단어들이 복구 키트와 일치하지 않습니다. 적어 둔 내용을 확인하세요.';

  @override
  String get privacyWrongPassword => '계정 비밀번호가 아닙니다.';

  @override
  String get problemAdminOnly => '관리자만 할 수 있습니다.';

  @override
  String get problemBusy => '서버가 바쁘거나 다시 시작하는 중입니다.';

  @override
  String get problemChanged => '그사이에 변경되었습니다.';

  @override
  String get problemConfirm => '서버가 확인 없이 처리하는 것보다 많은 항목이 숨겨지거나 삭제됩니다';

  @override
  String get problemContribute => '이 라이브러리에 사진을 추가할 수 없습니다.';

  @override
  String get problemCopy => '자세한 내용 복사';

  @override
  String get problemDetails => '자세히';

  @override
  String get problemDiskLow => '서버 디스크가 거의 가득 차서 업로드가 일시 중지되었습니다.';

  @override
  String get problemEmailTaken => '다른 계정이 이 이메일을 사용합니다.';

  @override
  String get problemExists => '이미 있습니다.';

  @override
  String get problemFaceNotice => '서버가 이 앱이 보여 주는 것보다 새로운 버전의 얼굴 안내를 요구합니다.';

  @override
  String get problemGone => '더 이상 서버에 없습니다.';

  @override
  String get problemHandleTaken => '다른 계정이 이 로그인 이름을 사용합니다.';

  @override
  String get problemInterrupted => '업로드가 중단되었습니다.';

  @override
  String get problemInvalid => '유효하지 않은 값이 있습니다';

  @override
  String get problemLastAdmin => '서버에는 관리자가 한 명 이상 있어야 합니다.';

  @override
  String get problemLinkInvalid => '이 링크는 만료되었거나 이미 사용되었습니다.';

  @override
  String get problemLoginFailed => '이메일, 로그인 이름 또는 비밀번호가 올바르지 않습니다.';

  @override
  String get problemMaintenanceKey =>
      '백업, 무결성 검사, 영구 삭제는 API 키가 아니라 로그인한 상태에서만 일시중지할 수 있습니다';

  @override
  String get problemNotAllowed => '이 계정에는 이 작업이 허용되지 않습니다.';

  @override
  String get problemNotExternal => '서버 자체 폴더의 라이브러리만 스캔할 수 있습니다.';

  @override
  String get problemOidcClaim => '로그인 제공자가 이 서버가 받아들이는 방식으로 사용자를 알려 주지 않았습니다.';

  @override
  String get problemOidcDown => '로그인 제공자가 서버에 응답하지 않습니다.';

  @override
  String get problemOidcFailed => '로그인 제공자가 로그인을 거부했습니다.';

  @override
  String get problemOidcNotAllowed => '이 계정은 이 방법으로 로그인할 수 없습니다.';

  @override
  String get problemOidcTaken => '이 로그인은 이미 다른 Photolib 계정에 연결되어 있습니다.';

  @override
  String get problemOidcUnknown => '이 서버는 더 이상 이 로그인 방법을 제공하지 않습니다.';

  @override
  String get problemPasskeysOff => '패스키는 서버에 공개 주소가 설정된 뒤에만 작동합니다.';

  @override
  String get problemPinned => '구성 파일에서 설정된 항목이므로 여기에서 변경할 수 없습니다.';

  @override
  String get problemPolicyOff => '이 서버에서는 이 기능이 꺼져 있습니다.';

  @override
  String get problemQuota => '서버의 저장 공간이 가득 찼습니다.';

  @override
  String get problemRestoreKey => '백업은 API 키가 아니라 로그인한 상태에서만 복원할 수 있습니다.';

  @override
  String get problemRootDiffers => '이 폴더에는 이 라이브러리의 파일이 없습니다';

  @override
  String get problemRootNotAllowed => '이 폴더는 서버 설정의 external_roots 아래에 있지 않습니다';

  @override
  String get problemRootOverlaps =>
      '이 폴더는 다른 라이브러리나 서버 자체 데이터를 포함하거나 그 안에 있습니다';

  @override
  String get problemScanning => '이 라이브러리는 이미 스캔 중입니다';

  @override
  String get problemSecondFactor =>
      '이 계정에는 인증 코드나 패스키 같은 두 번째 인증 요소가 필요하지만 이 버전의 Photolib은 아직 제공할 수 없습니다.';

  @override
  String get problemSetupDone => '이 서버에는 이미 관리자가 있습니다.';

  @override
  String get problemSetupExpired => '시간이 너무 오래 걸렸습니다.';

  @override
  String get problemSetupToken => '이 설정 토큰이 올바르지 않습니다.';

  @override
  String get problemSignedOut => '서버에서 로그아웃되었습니다.';

  @override
  String get problemStepUp => '이 변경에는 먼저 비밀번호 또는 코드가 필요합니다.';

  @override
  String get problemStorage => '서버가 저장소에 접근할 수 없습니다.';

  @override
  String get problemTooMany => '짧은 시간에 시도가 너무 많습니다.';

  @override
  String get problemUnexpected => '예상치 못한 문제가 발생했습니다.';

  @override
  String get problemUnreachable => '서버가 응답하지 않습니다.';

  @override
  String get problemUploadDamaged => '파일이 전송 중에 변경되었거나 손상되었습니다.';

  @override
  String get problemUploadExpired =>
      '서버에 이 업로드가 더 이상 없습니다. 완료되지 않은 업로드는 하루 뒤 만료됩니다.';

  @override
  String get problemWebhookLimit => '계정에 허용된 최대 개수의 웹훅이 이미 있습니다.';

  @override
  String get problemWebhooksOff => '이 서버에서는 웹훅이 꺼져 있습니다.';

  @override
  String get recoveryCode => '복구 코드';

  @override
  String get recoveryCodeAbout => '키 저장소가 키를 잃으면 이 기기에서 Photolib 저장소를 엽니다';

  @override
  String get recoveryCodeEnter => '복구 코드 입력';

  @override
  String get recoveryCreate => '복구 코드 만들기';

  @override
  String get recoveryLater => '나중에';

  @override
  String recoveryOffer(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '변경 사항 $countString개가 이 기기에만 있습니다. 키 저장소가 Photolib의 키를 잃어도 복구 코드로 되찾을 수 있습니다.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryShow =>
      '이 24개 단어를 적어 안전한 곳에 보관하세요. 키 저장소의 키 없이도 이 기기에서 Photolib 저장소를 열 수 있습니다. 이전 코드는 모두 대체됩니다.';

  @override
  String get recoveryUnlock => '잠금 해제';

  @override
  String get recoveryWrong => '이 저장소의 복구 코드가 아닙니다';

  @override
  String get renameFind => '찾기';

  @override
  String get renamePattern => '새 이름';

  @override
  String renameProblem(String problem) {
    String _temp0 = intl.Intl.selectLogic(problem, {
      'tooLong': '너무 깁니다: 이름은 최대 255바이트입니다',
      'invalid': '올바른 파일 이름이 아닙니다',
      'duplicate': '다른 파일에도 붙는 이름입니다',
      'exists': '이 폴더의 다른 파일이 이 이름을 쓰고 있습니다',
      'other': '이름을 바꿀 수 없습니다',
    });
    return '$_temp0';
  }

  @override
  String get renameReplace => '바꿀 내용';

  @override
  String renamed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '이름을 바꾼 파일: $countString';
  }

  @override
  String reveal(String platform) {
    String _temp0 = intl.Intl.selectLogic(platform, {
      'macOS': 'Finder에서 보기',
      'windows': '탐색기에서 보기',
      'other': '폴더에서 보기',
    });
    return '$_temp0';
  }

  @override
  String get searchCamera => '카메라';

  @override
  String searchCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $countString개',
    );
    return '$_temp0';
  }

  @override
  String get searchDates => '날짜';

  @override
  String searchDays(String first, String last) {
    return '$first ~ $last';
  }

  @override
  String get searchEmpty => '라이브러리 검색';

  @override
  String get searchFavourites => '즐겨찾기';

  @override
  String get searchFolder => '폴더';

  @override
  String get searchHint => '파일 이름 또는 폴더 이름';

  @override
  String get searchMotionPhotos => '모션 포토';

  @override
  String get searchNothing => '일치하는 항목이 없습니다';

  @override
  String get searchPanoramas => '파노라마';

  @override
  String get searchPhotos => '사진';

  @override
  String get searchScreenshots => '스크린샷';

  @override
  String get searchVideo => '동영상';

  @override
  String get searchVideos => '동영상';

  @override
  String get securityAddPasskey => '패스키 추가';

  @override
  String get securityCode => '코드';

  @override
  String get securityCodesHelp =>
      '이 코드를 안전한 곳에 보관하세요. 각 코드는 두 번째 인증 요소 대신 한 번만 사용할 수 있으며 지금만 표시됩니다.';

  @override
  String securityCodesLeft(int count) {
    return '미사용: $count';
  }

  @override
  String get securityNewCodes => '새 코드';

  @override
  String get securityPasskeyNotAdded => '패스키가 추가되지 않았습니다.';

  @override
  String get securityRecoveryCodes => '복구 코드';

  @override
  String get securityRemovePasskey => '패스키 삭제';

  @override
  String get securitySetUp => '설정';

  @override
  String get securityStepUpBody =>
      '두 번째 인증 요소를 변경하려면 비밀번호, 인증 앱의 코드 또는 복구 코드를 입력하세요.';

  @override
  String get securityStepUpTitle => '본인 확인';

  @override
  String get securityTitle => '두 번째 인증 요소';

  @override
  String get securityTotp => '인증 앱';

  @override
  String get securityTotpHelp => '이 키를 인증 앱에 추가한 다음 앱에 표시되는 코드를 입력하세요.';

  @override
  String securityTotpState(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {'on': '켜짐', 'other': '꺼짐'});
    return '$_temp0';
  }

  @override
  String get securityTurnOff => '끄기';

  @override
  String get securityWrongCode => '코드가 올바르지 않습니다.';

  @override
  String get securityWrongProof => '비밀번호 또는 코드가 올바르지 않습니다.';

  @override
  String get selectAll => '모두 선택';

  @override
  String get selectionClear => '선택 해제';

  @override
  String selectionCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString개 선택됨',
    );
    return '$_temp0';
  }

  @override
  String get selectionReview => '선택한 항목 보기';

  @override
  String get serverAccount => '이메일 또는 로그인 이름';

  @override
  String get serverAdd => '서버 추가';

  @override
  String get serverAddressInvalid => 'photos.example.org 같은 주소를 입력하세요';

  @override
  String get serverAddresses => '주소';

  @override
  String get serverAddressesHelp =>
      '한 줄에 하나씩: 내 네트워크, 인터넷 또는 VPN을 통한 서버 주소입니다. 앱은 응답하는 주소 중 가장 빠른 주소를 사용합니다. 또는 받은 비밀번호 설정 링크를 붙여 넣으세요.';

  @override
  String get serverCa => '사설 CA 인증서(PEM)';

  @override
  String get serverCaChoose => '인증서 파일 선택';

  @override
  String serverCertificateBody(String host) {
    return '$host이(가) 이 기기가 신뢰하지 않는 인증서를 제시했습니다. 이 SHA-256 지문이 내 서버의 것일 때만 신뢰하세요.';
  }

  @override
  String get serverCertificateTitle => '이 인증서를 신뢰할까요?';

  @override
  String get serverConfirm => '확인';

  @override
  String get serverConnect => '연결';

  @override
  String get serverCreateAdmin => '관리자 만들기';

  @override
  String get serverEnded => '서버가 이 세션을 종료했습니다. 다시 로그인하세요.';

  @override
  String get serverHandleHelp =>
      '영문 소문자, 숫자, 마침표, 하이픈, 밑줄만 사용할 수 있으며 변경할 수 없습니다.';

  @override
  String get serverHeaders => '사용자 지정 헤더';

  @override
  String get serverHeadersHelp =>
      '한 줄에 하나씩 Name: value 형식으로 입력하세요. HTTPS로만 전송됩니다';

  @override
  String get serverHeadersInvalid => '각 헤더를 Name: value 형식으로 입력하세요';

  @override
  String get serverIdentity => '클라이언트 인증서(PKCS#12)';

  @override
  String get serverIdentityChoose => '클라이언트 인증서 선택';

  @override
  String get serverIdentityInvalid => '인증서(PKCS#12)가 아니거나 비밀번호가 틀렸습니다.';

  @override
  String get serverIdentityPassword => '클라이언트 인증서 비밀번호';

  @override
  String get serverLoading => '이 기기에 저장된 서버를 읽는 중';

  @override
  String get serverNearby => '이 네트워크의 서버';

  @override
  String get serverNeedsHttps =>
      '이 서버에는 HTTPS 주소가 필요합니다. 로컬 네트워크 밖에서는 Photolib이 일반 HTTP로 로그인하지 않습니다.';

  @override
  String get serverNoSignIn => '이 서버는 이 버전의 Photolib이 지원하는 로그인 방법을 제공하지 않습니다.';

  @override
  String get serverOffline => '서버가 응답하지 않습니다. 로그인은 유지됩니다.';

  @override
  String get serverPasskeyFailed => '패스키가 사용되지 않았습니다. 다시 시도하거나 코드를 사용하세요.';

  @override
  String get serverPasskeyRequired =>
      '이 서버는 패스키가 필요하지만 이 버전의 Photolib은 아직 패스키를 사용할 수 없습니다.';

  @override
  String get serverPassword => '비밀번호';

  @override
  String get serverPasswordAgain => '비밀번호 확인';

  @override
  String get serverPasswordSetupInvalid =>
      '이 비밀번호 설정 토큰은 틀렸거나 이미 사용되었거나 만료되었습니다. 새 토큰을 요청하세요.';

  @override
  String get serverPasswordSetupToken => '비밀번호 설정 토큰';

  @override
  String get serverPasswordSetupTokenHelp =>
      '관리자에게서 받거나, 서버에서 photolibd admin password-setup이 출력합니다.';

  @override
  String get serverPasswordsDiffer => '비밀번호가 일치하지 않습니다.';

  @override
  String get serverPrivateLibrariesBody =>
      '새 비밀번호로는 열리지 않습니다. 복구 키트, 패스키 또는 아직 로그인된 기기로 다시 여세요.';

  @override
  String get serverPrivateLibrariesGo => '비밀번호 설정';

  @override
  String get serverPrivateLibrariesTitle => '비공개 라이브러리는 잠긴 상태로 유지됩니다';

  @override
  String get serverProxy => 'HTTP 프록시(host:port 형식)';

  @override
  String get serverProxyInvalid => '프록시를 host:port 형식으로 입력하세요';

  @override
  String get serverRecoveryCode => '복구 코드';

  @override
  String get serverRemove => '이 서버 삭제';

  @override
  String get serverRequired => '필수';

  @override
  String get serverSecondFactor =>
      '이 계정의 두 번째 인증 요소는 패스키이지만 이 버전의 Photolib은 아직 패스키를 사용할 수 없습니다.';

  @override
  String get serverSecondFactorCode => '이 계정에는 인증 앱의 코드 또는 복구 코드도 필요합니다.';

  @override
  String get serverSecondFactorTitle => '본인 확인';

  @override
  String get serverSecondFactorWrong => '작동하지 않았습니다. 다섯 번 시도한 후에는 다시 로그인하세요.';

  @override
  String get serverSetPassword => '비밀번호 설정';

  @override
  String serverSetPasswordFor(String handle, String server) {
    return '$server의 $handle';
  }

  @override
  String get serverSetPasswordOpen => '비밀번호 설정';

  @override
  String get serverSetPasswordTitle => '비밀번호를 설정하세요';

  @override
  String get serverSetUp => '새 서버 설정';

  @override
  String get serverSetupLinkElsewhere =>
      '이 설정 링크를 사용하려면 먼저 이 서버에서 로그아웃하세요. 링크가 다른 서버의 것이라면 이 서버를 삭제하세요.';

  @override
  String get serverSetupTitle => '서버 설정';

  @override
  String get serverSetupToken => '설정 토큰';

  @override
  String get serverSetupTokenHelp =>
      '서버에 관리자가 없는 동안 photolibd가 로그에 출력합니다. 시작할 때마다 새 토큰이 출력됩니다.';

  @override
  String get serverSignIn => '로그인';

  @override
  String get serverSignOut => '로그아웃';

  @override
  String serverSignedInAs(String account) {
    return '$account(으)로 로그인됨';
  }

  @override
  String get serverSignedOut => '로그아웃됨';

  @override
  String get serverSwitch => '계정 전환';

  @override
  String get serverTotpCode => '인증 앱의 코드';

  @override
  String get serverTrust => '신뢰';

  @override
  String get serverUnreadable => '이 기기에 저장된 서버를 읽을 수 없습니다';

  @override
  String get serverUsePasskey => '패스키 사용';

  @override
  String get serverUseRecoveryCode => '대신 복구 코드 사용';

  @override
  String get settingsBackground => '투명한 이미지의 배경';

  @override
  String get settingsDefaultTab => '폴더와 앨범에서 먼저 여는 탭';

  @override
  String get settingsFolders => '폴더';

  @override
  String get settingsIndexing => '이 기기에서 색인 생성';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLibrary => '라이브러리';

  @override
  String get settingsServer => '서버';

  @override
  String get settingsStart => '시작 화면';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsTitle => '설정';

  @override
  String settingsToggle(String toggle) {
    String _temp0 = intl.Intl.selectLogic(toggle, {
      'edgeTaps': '왼쪽 또는 오른쪽 가장자리를 탭하여 이전 또는 다음 항목으로 이동',
      'oneFingerZoom': '두 번 탭하고 드래그하여 한 손가락으로 확대/축소',
      'swipes': '동영상 왼쪽을 위아래로 스와이프하면 밝기, 오른쪽은 볼륨',
      'maxBrightness': '보는 동안 최대 밝기',
      'autoRotate': '각 사진이나 동영상의 방향으로 회전',
      'mixAudio': '다른 오디오를 일시 중지하지 않고 함께 동영상 재생',
      'autoplay': '동영상을 열면 재생',
      'loop': '동영상 반복 재생',
      'autoNext': '동영상이 끝나면 다음 항목으로 이동',
      'resume': '동영상을 멈춘 곳부터 이어서 재생',
      'other': '그리드에서 움직이는 이미지 재생',
    });
    return '$_temp0';
  }

  @override
  String get settingsViewerBar => '뷰어 막대의 버튼';

  @override
  String get settingsViewing => '보기';

  @override
  String shareInboxWaiting(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '공유된 사진 및 동영상 $countString개가 Photolib이 사진 보관함에 추가할 수 있도록 허용되기를 기다리고 있습니다. 저장되지 않은 항목은 7일 후 삭제됩니다.',
    );
    return '$_temp0';
  }

  @override
  String get shareTooLarge => '한 번에 공유하기에는 용량이 너무 큽니다. 더 적은 항목을 선택하세요';

  @override
  String shareTooMany(int count) {
    return '한 번에 공유하기에는 너무 많습니다. $count개 이하로 선택하세요';
  }

  @override
  String get shortcutsTitle => '키보드 단축키';

  @override
  String get slideshow => '슬라이드쇼';

  @override
  String get slideshowLoop => '반복';

  @override
  String get slideshowOptions => '슬라이드쇼 옵션';

  @override
  String get slideshowSeconds => '항목당 초';

  @override
  String get slideshowShuffle => '무작위 순서';

  @override
  String sortOrder(String descending) {
    String _temp0 = intl.Intl.selectLogic(descending, {
      'true': '내림차순',
      'other': '오름차순',
    });
    return '$_temp0';
  }

  @override
  String get sourceDevice => '이 기기';

  @override
  String sourceHide(String name) {
    return '$name 숨기기';
  }

  @override
  String get sourceHideOthers => '여기서 나머지 모두 숨기기';

  @override
  String get sourceLost => '액세스 권한 없음';

  @override
  String get sourcePartly => '일부 표시됨';

  @override
  String sourceShow(String name) {
    return '$name 표시';
  }

  @override
  String get sourceShowEverything => '여기 있는 모두 표시';

  @override
  String get sourceShowOnly => '이것만 표시';

  @override
  String startScreen(String screen) {
    String _temp0 = intl.Intl.selectLogic(screen, {
      'timeline': '타임라인',
      'folders': '폴더 및 앨범',
      'favourites': '즐겨찾기',
      'other': '타임라인',
    });
    return '$_temp0';
  }

  @override
  String get storageAddPerson => '사람을 오프라인으로 보관';

  @override
  String get storageBudget => '저장 공간 한도';

  @override
  String get storageClear => '오프라인 사본 삭제';

  @override
  String get storageClearAction => '삭제';

  @override
  String storageClearBody(String size) {
    return '이 기기에 보관된 $size를 삭제하고 앨범, 검색, 사진의 오프라인 보관을 중지합니다. 서버의 라이브러리는 그대로입니다.';
  }

  @override
  String get storageKeepLibrary => '전체 라이브러리 보관';

  @override
  String get storageKeepOriginals => '원본도 보관';

  @override
  String get storageNoPeople => '이름이 지정된 사람이 아직 없습니다.';

  @override
  String get storageNoPins => '고정한 항목이 없습니다. 앨범, 검색 또는 사진을 고정하면 오프라인으로 보관됩니다.';

  @override
  String storagePinKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '앨범',
      'search': '검색',
      'person': '사람',
      'library': '전체 라이브러리',
      'asset': '사진',
      'other': '고정됨',
    });
    return '$_temp0';
  }

  @override
  String storagePinLeft(String size) {
    return '한도를 초과합니다: $size 더 필요';
  }

  @override
  String get storagePinNothing => '다운로드할 항목 없음: 사진이 이미 이 기기에 있습니다';

  @override
  String get storagePinPaused => '대기 중: 이 프리셋은 오프라인으로 아무것도 보관하지 않습니다';

  @override
  String get storagePinPlanning => '보관할 항목 확인 중…';

  @override
  String storagePinProgress(int have, int files) {
    final intl.NumberFormat haveNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String haveString = haveNumberFormat.format(have);
    final intl.NumberFormat filesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    return '다운로드 중: $filesString개 중 $haveString개';
  }

  @override
  String storagePinReady(String size) {
    return '오프라인 사용 가능($size)';
  }

  @override
  String get storagePinWaiting => '온라인이 되면 다운로드됩니다';

  @override
  String get storagePins => '오프라인 보관';

  @override
  String storagePreset(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '카탈로그만',
      'spaceSaver': '공간 절약',
      'travel': '선택한 앨범 오프라인',
      'everything': '전체',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String storagePresetHelp(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'catalogueOnly': '아무것도 보관하지 않습니다. 사진은 열 때 서버에서 불러옵니다.',
      'spaceSaver': '전체 라이브러리의 미리보기를 최신순으로 한도 안에서 보관합니다.',
      'travel': '고정한 항목만 보관합니다: 앨범, 검색, 사진.',
      'everything': '전체 라이브러리의 원본을 최신순으로 한도 안에서 보관합니다.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get storagePresets => '이 기기가 보관하는 항목';

  @override
  String get storageSubtitle => '오프라인 사본과 저장 공간 한도';

  @override
  String get storageTitle => '저장 공간';

  @override
  String storageUsed(String used, String budget) {
    return '$budget 중 $used 사용';
  }

  @override
  String get storageWebNote => '브라우저는 미리보기만 보관하며 로그아웃하면 지웁니다.';

  @override
  String get storeNoKeyring =>
      'Photolib은 로컬 저장소의 키를 시스템 키링에 보관하는데, 키링이 응답하지 않았습니다. Secret Service를 켠 상태로 gnome-keyring, KWallet 또는 KeePassXC를 설치하고 잠금을 해제한 뒤 다시 시도하세요.';

  @override
  String get storeNoKeystore =>
      'Photolib이 로컬 저장소의 키를 보관하는 이 기기의 키 저장소에 연결하지 못했습니다.';

  @override
  String get storeRebuilt =>
      '이 기기의 키 저장소에 Photolib 로컬 저장소의 키가 더 이상 없어서 저장소를 다시 만들었습니다. 설정과 이 기기에만 있던 항목은 사라졌습니다. 라이브러리는 다시 동기화되고 썸네일은 돌아옵니다.';

  @override
  String get storeRecoveryNeeded =>
      '이 기기의 키 저장소에 더 이상 Photolib 로컬 저장소의 키가 없습니다. 복구 코드를 입력하거나, 저장소를 재설정하고 이 기기에만 있는 항목을 잃으세요.';

  @override
  String get storeReset => '저장소 재설정';

  @override
  String get storeResetBody =>
      '이 기기에만 있는 항목은 사라집니다. 라이브러리는 다시 동기화되고 썸네일은 돌아옵니다.';

  @override
  String get storeUnavailable => '이 기기의 저장소를 사용할 수 없습니다. 설정과 컬렉션이 보관되지 않습니다';

  @override
  String get tabCollections => '컬렉션';

  @override
  String get tabLibrary => '라이브러리';

  @override
  String get tabSearch => '검색';

  @override
  String get themeDark => '어둡게';

  @override
  String get themeLight => '밝게';

  @override
  String get themeSystem => '시스템 기본값';

  @override
  String get timelineBenchmark => '타임라인 벤치마크';

  @override
  String get timelineBenchmarkCopy => '결과 복사';

  @override
  String get timelineCannotPlay => '이 브라우저에서는 재생할 수 없음';

  @override
  String timelineCell(String date, int position, int count) {
    return '$date, $count개 중 $position번째';
  }

  @override
  String timelineCellNoPreview(String date, int position, int count) {
    return '$date, $count개 중 $position번째, 미리보기 없음';
  }

  @override
  String get timelineExcluded => '제외한 폴더에 있음';

  @override
  String get timelineScrubber => '날짜별로 스크롤';

  @override
  String get timelineSphere => '360°';

  @override
  String get timelineUndated => '날짜 알 수 없음';

  @override
  String timelineWeek(String date) {
    return '$date 주';
  }

  @override
  String toolbarAdd(String action) {
    return '막대에 $action 추가';
  }

  @override
  String toolbarDown(String action) {
    return '$action 아래로 이동';
  }

  @override
  String get toolbarInBar => '막대에 표시';

  @override
  String get toolbarInMenu => '⋮ 메뉴에 표시';

  @override
  String toolbarRemove(String action) {
    return '막대에서 $action 제거';
  }

  @override
  String get toolbarReset => '기본값으로 재설정';

  @override
  String toolbarUp(String action) {
    return '$action 위로 이동';
  }

  @override
  String transferHere(String move) {
    String _temp0 = intl.Intl.selectLogic(move, {
      'true': '여기로 이동',
      'other': '여기로 복사',
    });
    return '$_temp0';
  }

  @override
  String transferProblem(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'exists': '같은 이름의 파일이나 폴더가 이미 있습니다',
      'changed': '사본이 원본과 일치하지 않아 삭제했습니다',
      'cancelled': '취소됨',
      'invalid': '올바른 폴더 이름이 아닙니다',
      'other': '실패',
    });
    return '$_temp0';
  }

  @override
  String get transferRecent => '최근';

  @override
  String trashConfirm(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $countString개를 영구 삭제할까요? 되돌릴 수 없습니다.',
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
      other: '$daysString일 남음',
      zero: '오늘 영구 삭제됨',
    );
    return '$_temp0';
  }

  @override
  String get trashEmpty => '휴지통이 비어 있습니다';

  @override
  String get trashEmptyAll => '휴지통 비우기';

  @override
  String trashMoved(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $countString개를 휴지통으로 이동했습니다',
    );
    return '$_temp0';
  }

  @override
  String trashRetention(int days) {
    return 'Photolib은 휴지통에 보관한 항목을 $days일 후 영구 삭제합니다. 각 항목에 남은 시간이 표시됩니다.';
  }

  @override
  String get trashTitle => '휴지통';

  @override
  String get undo => '실행 취소';

  @override
  String get uploadAction => '사진 및 동영상 업로드';

  @override
  String get uploadClear => '지우기';

  @override
  String uploadProgress(int done, int total) {
    final intl.NumberFormat doneNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$totalString개 중 $doneString개 업로드됨';
  }

  @override
  String uploadsFailed(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '실패: $countString';
  }

  @override
  String veilArchived(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $countString개를 보관했습니다',
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
      other: '항목 $countString개를 숨겼습니다',
    );
    return '$_temp0';
  }

  @override
  String viewerBackground(String background) {
    String _temp0 = intl.Intl.selectLogic(background, {
      'black': '검은색',
      'white': '흰색',
      'other': '바둑판',
    });
    return '$_temp0';
  }

  @override
  String get viewerCannotPlay => '이 기기에서 이 동영상을 재생할 수 없습니다';

  @override
  String get viewerCaptions => '자막';

  @override
  String get viewerCompass => '나침반 고정';

  @override
  String get viewerCopy => '복사';

  @override
  String get viewerCopyText => '텍스트 복사';

  @override
  String get viewerCustomize => '도구 모음 사용자 지정…';

  @override
  String get viewerDial =>
      '방향. 클릭하면 정면을 봅니다. 드래그하여 둘러보고, 스크롤하거나 손가락을 오므려 확대/축소하고, 두 번 클릭하여 초기화합니다';

  @override
  String get viewerFilmstrip => '필름 스트립';

  @override
  String get viewerFirst => '처음';

  @override
  String get viewerFisheye => '어안';

  @override
  String get viewerGyroscope => '기기를 움직여 둘러보기';

  @override
  String get viewerHdr => 'HDR로 보기';

  @override
  String get viewerInfo => '정보';

  @override
  String get viewerInfoLoading => '이 항목의 정보를 불러오는 중';

  @override
  String viewerItem(int position, int count) {
    final intl.NumberFormat positionNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString개 중 $positionString번째';
  }

  @override
  String get viewerLast => '마지막';

  @override
  String get viewerLenses => '렌즈 선택';

  @override
  String get viewerMap => '지도';

  @override
  String get viewerMotion => '모션 재생';

  @override
  String get viewerMotionDenied => '이 브라우저에서 동작 센서 접근을 허용하지 않았습니다';

  @override
  String get viewerMotionMissing => '이 기기에는 둘러보기에 필요한 자이로스코프가 없습니다';

  @override
  String get viewerMute => '음소거';

  @override
  String get viewerNext => '다음';

  @override
  String get viewerNextFrame => '다음 프레임';

  @override
  String get viewerPause => '일시정지';

  @override
  String get viewerPlanet => '작은 행성';

  @override
  String get viewerPlay => '재생';

  @override
  String get viewerPrevious => '이전';

  @override
  String get viewerPreviousFrame => '이전 프레임';

  @override
  String get viewerRotate => '회전';

  @override
  String get viewerSdr => 'SDR로 보기';

  @override
  String get viewerSeek => '위치';

  @override
  String get viewerSetAs => '다른 용도로 설정';

  @override
  String get viewerShare => '공유';

  @override
  String get viewerSpeed => '재생 속도';

  @override
  String get viewerSphere => '360° 보기. 드래그하여 둘러보고 핀치하여 확대/축소';

  @override
  String get viewerText => '이 사진의 텍스트';

  @override
  String get viewerTextCopied => '텍스트를 복사했습니다';

  @override
  String get viewerTextNone => '이 사진에서 텍스트를 찾지 못했습니다';

  @override
  String get viewerTextUnread => '이 사진의 텍스트를 아직 읽지 않았습니다';

  @override
  String get viewerUnmute => '음소거 해제';

  @override
  String get viewerZoomIn => '확대';

  @override
  String get viewerZoomOut => '축소';

  @override
  String volumeBadge(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {'sd': 'SD 카드', 'other': '내부'});
    return '$_temp0';
  }

  @override
  String get zoomIn => '확대';

  @override
  String get zoomOut => '축소';
}
