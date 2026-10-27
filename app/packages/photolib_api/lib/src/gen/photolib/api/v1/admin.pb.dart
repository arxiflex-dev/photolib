// This is a generated file - do not edit.
//
// Generated from photolib/api/v1/admin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'admin.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'admin.pbenum.dart';

/// Asks for the status.
class GetStatusRequest extends $pb.GeneratedMessage {
  factory GetStatusRequest() => GetStatusRequest._();

  GetStatusRequest._();

  factory GetStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusRequest()..mergeFromBuffer(data, registry);
  factory GetStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetStatusRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest copyWith(void Function(GetStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatusRequest))
          as GetStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatusRequest() / GetStatusRequest.new instead')
  static GetStatusRequest create() => GetStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetStatusRequest._();
  @$core.override
  GetStatusRequest createEmptyInstance() => GetStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatusRequest>(
          GetStatusRequest.$_createMessage);
  static GetStatusRequest? _defaultInstance;
}

/// The server at a glance.
class GetStatusResponse extends $pb.GeneratedMessage {
  factory GetStatusResponse({
    $core.Iterable<AccountUsage>? accounts,
    $core.Iterable<FileUsage>? files,
    $core.Iterable<LibraryStatus>? libraries,
    $core.Iterable<Backup>? backups,
    $core.Iterable<JobCount>? jobs,
    $core.Iterable<JobPause>? pauses,
    $core.Iterable<IntegrityFinding>? findings,
    $core.Iterable<StoreScrub>? scrubs,
    $core.Iterable<DeviceBackup>? deviceBackups,
    BackupRun? lastDrill,
    BackupRun? lastVerifiedRestore,
    BackupRun? lastRestore,
  }) {
    final result = GetStatusResponse._();
    if (accounts != null) result.accounts.addAll(accounts);
    if (files != null) result.files.addAll(files);
    if (libraries != null) result.libraries.addAll(libraries);
    if (backups != null) result.backups.addAll(backups);
    if (jobs != null) result.jobs.addAll(jobs);
    if (pauses != null) result.pauses.addAll(pauses);
    if (findings != null) result.findings.addAll(findings);
    if (scrubs != null) result.scrubs.addAll(scrubs);
    if (deviceBackups != null) result.deviceBackups.addAll(deviceBackups);
    if (lastDrill != null) result.lastDrill = lastDrill;
    if (lastVerifiedRestore != null)
      result.lastVerifiedRestore = lastVerifiedRestore;
    if (lastRestore != null) result.lastRestore = lastRestore;
    return result;
  }

  GetStatusResponse._();

  factory GetStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusResponse()..mergeFromBuffer(data, registry);
  factory GetStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetStatusResponse.$_createMessage)
    ..pPM<AccountUsage>(1, _omitFieldNames ? '' : 'accounts',
        subBuilder: AccountUsage.$_createMessage)
    ..pPM<FileUsage>(2, _omitFieldNames ? '' : 'files',
        subBuilder: FileUsage.$_createMessage)
    ..pPM<LibraryStatus>(3, _omitFieldNames ? '' : 'libraries',
        subBuilder: LibraryStatus.$_createMessage)
    ..pPM<Backup>(4, _omitFieldNames ? '' : 'backups',
        subBuilder: Backup.$_createMessage)
    ..pPM<JobCount>(5, _omitFieldNames ? '' : 'jobs',
        subBuilder: JobCount.$_createMessage)
    ..pPM<JobPause>(6, _omitFieldNames ? '' : 'pauses',
        subBuilder: JobPause.$_createMessage)
    ..pPM<IntegrityFinding>(7, _omitFieldNames ? '' : 'findings',
        subBuilder: IntegrityFinding.$_createMessage)
    ..pPM<StoreScrub>(8, _omitFieldNames ? '' : 'scrubs',
        subBuilder: StoreScrub.$_createMessage)
    ..pPM<DeviceBackup>(9, _omitFieldNames ? '' : 'deviceBackups',
        subBuilder: DeviceBackup.$_createMessage)
    ..aOM<BackupRun>(10, _omitFieldNames ? '' : 'lastDrill',
        subBuilder: BackupRun.$_createMessage)
    ..aOM<BackupRun>(11, _omitFieldNames ? '' : 'lastVerifiedRestore',
        subBuilder: BackupRun.$_createMessage)
    ..aOM<BackupRun>(12, _omitFieldNames ? '' : 'lastRestore',
        subBuilder: BackupRun.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse copyWith(void Function(GetStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetStatusResponse))
          as GetStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatusResponse() / GetStatusResponse.new instead')
  static GetStatusResponse create() => GetStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetStatusResponse._();
  @$core.override
  GetStatusResponse createEmptyInstance() => GetStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatusResponse>(
          GetStatusResponse.$_createMessage);
  static GetStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AccountUsage> get accounts => $_getList(0);

  /// Originals and each derivative class (OPS-20, LIB-19).
  @$pb.TagNumber(2)
  $pb.PbList<FileUsage> get files => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<LibraryStatus> get libraries => $_getList(2);

  /// Database dumps in the data directory, newest first.
  @$pb.TagNumber(4)
  $pb.PbList<Backup> get backups => $_getList(3);

  /// Open and dead jobs by type and status.
  @$pb.TagNumber(5)
  $pb.PbList<JobCount> get jobs => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<JobPause> get pauses => $_getList(5);

  /// Integrity findings no scrub has seen fixed yet, newest first, at most 100 (OPS-10).
  @$pb.TagNumber(7)
  $pb.PbList<IntegrityFinding> get findings => $_getList(6);

  /// Each store's scrub (ADR-0234).
  @$pb.TagNumber(8)
  $pb.PbList<StoreScrub> get scrubs => $_getList(7);

  /// Every device that reports its backup, the longest silent first (ING-26).
  @$pb.TagNumber(9)
  $pb.PbList<DeviceBackup> get deviceBackups => $_getList(8);

  /// The newest restore drill of a backup, and the newest that passed: when a restore was last verified.
  @$pb.TagNumber(10)
  BackupRun get lastDrill => $_getN(9);
  @$pb.TagNumber(10)
  set lastDrill(BackupRun value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLastDrill() => $_has(9);
  @$pb.TagNumber(10)
  void clearLastDrill() => $_clearField(10);
  @$pb.TagNumber(10)
  BackupRun ensureLastDrill() => $_ensure(9);

  @$pb.TagNumber(11)
  BackupRun get lastVerifiedRestore => $_getN(10);
  @$pb.TagNumber(11)
  set lastVerifiedRestore(BackupRun value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLastVerifiedRestore() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastVerifiedRestore() => $_clearField(11);
  @$pb.TagNumber(11)
  BackupRun ensureLastVerifiedRestore() => $_ensure(10);

  /// The newest restore the console asked for.
  @$pb.TagNumber(12)
  BackupRun get lastRestore => $_getN(11);
  @$pb.TagNumber(12)
  set lastRestore(BackupRun value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasLastRestore() => $_has(11);
  @$pb.TagNumber(12)
  void clearLastRestore() => $_clearField(12);
  @$pb.TagNumber(12)
  BackupRun ensureLastRestore() => $_ensure(11);
}

/// What an account stores (OPS-21).
class AccountUsage extends $pb.GeneratedMessage {
  factory AccountUsage({
    $core.String? userId,
    $core.String? handle,
    $fixnum.Int64? assetCount,
    $fixnum.Int64? sizeBytes,
  }) {
    final result = AccountUsage._();
    if (userId != null) result.userId = userId;
    if (handle != null) result.handle = handle;
    if (assetCount != null) result.assetCount = assetCount;
    if (sizeBytes != null) result.sizeBytes = sizeBytes;
    return result;
  }

  AccountUsage._();

  factory AccountUsage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AccountUsage()..mergeFromBuffer(data, registry);
  factory AccountUsage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AccountUsage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountUsage',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: AccountUsage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'handle')
    ..aInt64(3, _omitFieldNames ? '' : 'assetCount')
    ..aInt64(4, _omitFieldNames ? '' : 'sizeBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountUsage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountUsage copyWith(void Function(AccountUsage) updates) =>
      super.copyWith((message) => updates(message as AccountUsage))
          as AccountUsage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AccountUsage() / AccountUsage.new instead')
  static AccountUsage create() => AccountUsage._();
  static $pb.GeneratedMessage $_createMessage() => AccountUsage._();
  @$core.override
  AccountUsage createEmptyInstance() => AccountUsage._();
  @$core.pragma('dart2js:noInline')
  static AccountUsage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountUsage>(
          AccountUsage.$_createMessage);
  static AccountUsage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get handle => $_getSZ(1);
  @$pb.TagNumber(2)
  set handle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHandle() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandle() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get assetCount => $_getI64(2);
  @$pb.TagNumber(3)
  set assetCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get sizeBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set sizeBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSizeBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearSizeBytes() => $_clearField(4);
}

/// The files of one role (`original`, `thumb_s`, `preview`, …).
class FileUsage extends $pb.GeneratedMessage {
  factory FileUsage({
    $core.String? role,
    $fixnum.Int64? fileCount,
    $fixnum.Int64? sizeBytes,
  }) {
    final result = FileUsage._();
    if (role != null) result.role = role;
    if (fileCount != null) result.fileCount = fileCount;
    if (sizeBytes != null) result.sizeBytes = sizeBytes;
    return result;
  }

  FileUsage._();

  factory FileUsage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FileUsage()..mergeFromBuffer(data, registry);
  factory FileUsage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FileUsage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileUsage',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: FileUsage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aInt64(2, _omitFieldNames ? '' : 'fileCount')
    ..aInt64(3, _omitFieldNames ? '' : 'sizeBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileUsage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileUsage copyWith(void Function(FileUsage) updates) =>
      super.copyWith((message) => updates(message as FileUsage)) as FileUsage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FileUsage() / FileUsage.new instead')
  static FileUsage create() => FileUsage._();
  static $pb.GeneratedMessage $_createMessage() => FileUsage._();
  @$core.override
  FileUsage createEmptyInstance() => FileUsage._();
  @$core.pragma('dart2js:noInline')
  static FileUsage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileUsage>(FileUsage.$_createMessage);
  static FileUsage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fileCount => $_getI64(1);
  @$pb.TagNumber(2)
  set fileCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sizeBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set sizeBytes($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSizeBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearSizeBytes() => $_clearField(3);
}

/// A library and its state.
class LibraryStatus extends $pb.GeneratedMessage {
  factory LibraryStatus({
    $core.String? libraryId,
    $core.String? name,
    $core.String? ownerHandle,
    LibraryKind? kind,
    LibraryState? state,
    $fixnum.Int64? assetCount,
    Confirmation? held,
    $fixnum.Int64? polledFolderCount,
  }) {
    final result = LibraryStatus._();
    if (libraryId != null) result.libraryId = libraryId;
    if (name != null) result.name = name;
    if (ownerHandle != null) result.ownerHandle = ownerHandle;
    if (kind != null) result.kind = kind;
    if (state != null) result.state = state;
    if (assetCount != null) result.assetCount = assetCount;
    if (held != null) result.held = held;
    if (polledFolderCount != null) result.polledFolderCount = polledFolderCount;
    return result;
  }

  LibraryStatus._();

  factory LibraryStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LibraryStatus()..mergeFromBuffer(data, registry);
  factory LibraryStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LibraryStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LibraryStatus',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: LibraryStatus.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'libraryId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'ownerHandle')
    ..aE<LibraryKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: LibraryKind.values)
    ..aE<LibraryState>(5, _omitFieldNames ? '' : 'state',
        enumValues: LibraryState.values)
    ..aInt64(6, _omitFieldNames ? '' : 'assetCount')
    ..aOM<Confirmation>(7, _omitFieldNames ? '' : 'held',
        subBuilder: Confirmation.$_createMessage)
    ..aInt64(8, _omitFieldNames ? '' : 'polledFolderCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LibraryStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LibraryStatus copyWith(void Function(LibraryStatus) updates) =>
      super.copyWith((message) => updates(message as LibraryStatus))
          as LibraryStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LibraryStatus() / LibraryStatus.new instead')
  static LibraryStatus create() => LibraryStatus._();
  static $pb.GeneratedMessage $_createMessage() => LibraryStatus._();
  @$core.override
  LibraryStatus createEmptyInstance() => LibraryStatus._();
  @$core.pragma('dart2js:noInline')
  static LibraryStatus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LibraryStatus>(
          LibraryStatus.$_createMessage);
  static LibraryStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerHandle => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerHandle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerHandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerHandle() => $_clearField(3);

  @$pb.TagNumber(4)
  LibraryKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(LibraryKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  LibraryState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(LibraryState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get assetCount => $_getI64(5);
  @$pb.TagNumber(6)
  set assetCount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssetCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssetCount() => $_clearField(6);

  /// What its last scan did not find and holds back, more than 1,000 assets or 5 % of them, until ConfirmScan.
  @$pb.TagNumber(7)
  Confirmation get held => $_getN(6);
  @$pb.TagNumber(7)
  set held(Confirmation value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasHeld() => $_has(6);
  @$pb.TagNumber(7)
  void clearHeld() => $_clearField(7);
  @$pb.TagNumber(7)
  Confirmation ensureHeld() => $_ensure(6);

  /// How many of its folders no watch covers: they are polled hourly (a network file system, or past the system's
  /// limit of watches, which the log names).
  @$pb.TagNumber(8)
  $fixnum.Int64 get polledFolderCount => $_getI64(7);
  @$pb.TagNumber(8)
  set polledFolderCount($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPolledFolderCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearPolledFolderCount() => $_clearField(8);
}

/// What an operation would hide, trash, delete or purge when that is more than 1,000 items or 5 % of its scope: it
/// runs only once the same token comes back, and a token stands for that count in that state only.
class Confirmation extends $pb.GeneratedMessage {
  factory Confirmation({
    $fixnum.Int64? count,
    $fixnum.Int64? total,
    $core.String? token,
  }) {
    final result = Confirmation._();
    if (count != null) result.count = count;
    if (total != null) result.total = total;
    if (token != null) result.token = token;
    return result;
  }

  Confirmation._();

  factory Confirmation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Confirmation()..mergeFromBuffer(data, registry);
  factory Confirmation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Confirmation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Confirmation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: Confirmation.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'count')
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..aOS(3, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Confirmation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Confirmation copyWith(void Function(Confirmation) updates) =>
      super.copyWith((message) => updates(message as Confirmation))
          as Confirmation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Confirmation() / Confirmation.new instead')
  static Confirmation create() => Confirmation._();
  static $pb.GeneratedMessage $_createMessage() => Confirmation._();
  @$core.override
  Confirmation createEmptyInstance() => Confirmation._();
  @$core.pragma('dart2js:noInline')
  static Confirmation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Confirmation>(
          Confirmation.$_createMessage);
  static Confirmation? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get count => $_getI64(0);
  @$pb.TagNumber(1)
  set count($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get token => $_getSZ(2);
  @$pb.TagNumber(3)
  set token($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearToken() => $_clearField(3);
}

/// An object of a store that is not as recorded, and whose it is.
class IntegrityFinding extends $pb.GeneratedMessage {
  factory IntegrityFinding({
    $core.String? store,
    $core.String? key,
    FindingKind? kind,
    $core.String? detail,
    $0.Timestamp? foundAt,
    $core.String? assetId,
    $core.String? fileName,
    $core.String? ownerHandle,
  }) {
    final result = IntegrityFinding._();
    if (store != null) result.store = store;
    if (key != null) result.key = key;
    if (kind != null) result.kind = kind;
    if (detail != null) result.detail = detail;
    if (foundAt != null) result.foundAt = foundAt;
    if (assetId != null) result.assetId = assetId;
    if (fileName != null) result.fileName = fileName;
    if (ownerHandle != null) result.ownerHandle = ownerHandle;
    return result;
  }

  IntegrityFinding._();

  factory IntegrityFinding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IntegrityFinding()..mergeFromBuffer(data, registry);
  factory IntegrityFinding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IntegrityFinding()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IntegrityFinding',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: IntegrityFinding.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'store')
    ..aOS(2, _omitFieldNames ? '' : 'key')
    ..aE<FindingKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: FindingKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'foundAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'assetId')
    ..aOS(7, _omitFieldNames ? '' : 'fileName')
    ..aOS(8, _omitFieldNames ? '' : 'ownerHandle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IntegrityFinding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IntegrityFinding copyWith(void Function(IntegrityFinding) updates) =>
      super.copyWith((message) => updates(message as IntegrityFinding))
          as IntegrityFinding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IntegrityFinding() / IntegrityFinding.new instead')
  static IntegrityFinding create() => IntegrityFinding._();
  static $pb.GeneratedMessage $_createMessage() => IntegrityFinding._();
  @$core.override
  IntegrityFinding createEmptyInstance() => IntegrityFinding._();
  @$core.pragma('dart2js:noInline')
  static IntegrityFinding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IntegrityFinding>(
          IntegrityFinding.$_createMessage);
  static IntegrityFinding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get store => $_getSZ(0);
  @$pb.TagNumber(1)
  set store($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStore() => $_has(0);
  @$pb.TagNumber(1)
  void clearStore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => $_clearField(2);

  @$pb.TagNumber(3)
  FindingKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(FindingKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  /// What was found, in English for the administrator.
  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get foundAt => $_getN(4);
  @$pb.TagNumber(5)
  set foundAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFoundAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearFoundAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureFoundAt() => $_ensure(4);

  /// The asset the object holds a file of, its file name and its owner; empty for an orphan.
  @$pb.TagNumber(6)
  $core.String get assetId => $_getSZ(5);
  @$pb.TagNumber(6)
  set assetId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssetId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssetId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get fileName => $_getSZ(6);
  @$pb.TagNumber(7)
  set fileName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFileName() => $_has(6);
  @$pb.TagNumber(7)
  void clearFileName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get ownerHandle => $_getSZ(7);
  @$pb.TagNumber(8)
  set ownerHandle($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOwnerHandle() => $_has(7);
  @$pb.TagNumber(8)
  void clearOwnerHandle() => $_clearField(8);
}

/// Where a store's scrub is.
class StoreScrub extends $pb.GeneratedMessage {
  factory StoreScrub({
    $core.String? store,
    $0.Timestamp? cycleEndedAt,
  }) {
    final result = StoreScrub._();
    if (store != null) result.store = store;
    if (cycleEndedAt != null) result.cycleEndedAt = cycleEndedAt;
    return result;
  }

  StoreScrub._();

  factory StoreScrub.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreScrub()..mergeFromBuffer(data, registry);
  factory StoreScrub.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreScrub()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreScrub',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: StoreScrub.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'store')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'cycleEndedAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreScrub clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreScrub copyWith(void Function(StoreScrub) updates) =>
      super.copyWith((message) => updates(message as StoreScrub)) as StoreScrub;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoreScrub() / StoreScrub.new instead')
  static StoreScrub create() => StoreScrub._();
  static $pb.GeneratedMessage $_createMessage() => StoreScrub._();
  @$core.override
  StoreScrub createEmptyInstance() => StoreScrub._();
  @$core.pragma('dart2js:noInline')
  static StoreScrub getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreScrub>(StoreScrub.$_createMessage);
  static StoreScrub? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get store => $_getSZ(0);
  @$pb.TagNumber(1)
  set store($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStore() => $_has(0);
  @$pb.TagNumber(1)
  void clearStore() => $_clearField(1);

  /// When it last finished checking every file of the store; absent before its first cycle ends.
  @$pb.TagNumber(2)
  $0.Timestamp get cycleEndedAt => $_getN(1);
  @$pb.TagNumber(2)
  set cycleEndedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCycleEndedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCycleEndedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureCycleEndedAt() => $_ensure(1);
}

/// A device's backup as it last reported it.
class DeviceBackup extends $pb.GeneratedMessage {
  factory DeviceBackup({
    $core.String? deviceId,
    $core.String? name,
    $core.String? ownerHandle,
    $0.Timestamp? lastSeenAt,
    $0.Timestamp? reportedAt,
    $fixnum.Int64? pendingCount,
    $core.bool? silent,
  }) {
    final result = DeviceBackup._();
    if (deviceId != null) result.deviceId = deviceId;
    if (name != null) result.name = name;
    if (ownerHandle != null) result.ownerHandle = ownerHandle;
    if (lastSeenAt != null) result.lastSeenAt = lastSeenAt;
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (pendingCount != null) result.pendingCount = pendingCount;
    if (silent != null) result.silent = silent;
    return result;
  }

  DeviceBackup._();

  factory DeviceBackup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeviceBackup()..mergeFromBuffer(data, registry);
  factory DeviceBackup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeviceBackup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceBackup',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: DeviceBackup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'ownerHandle')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'lastSeenAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'pendingCount')
    ..aOB(7, _omitFieldNames ? '' : 'silent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceBackup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceBackup copyWith(void Function(DeviceBackup) updates) =>
      super.copyWith((message) => updates(message as DeviceBackup))
          as DeviceBackup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeviceBackup() / DeviceBackup.new instead')
  static DeviceBackup create() => DeviceBackup._();
  static $pb.GeneratedMessage $_createMessage() => DeviceBackup._();
  @$core.override
  DeviceBackup createEmptyInstance() => DeviceBackup._();
  @$core.pragma('dart2js:noInline')
  static DeviceBackup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceBackup>(
          DeviceBackup.$_createMessage);
  static DeviceBackup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerHandle => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerHandle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerHandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerHandle() => $_clearField(3);

  /// Its last request of any kind.
  @$pb.TagNumber(4)
  $0.Timestamp get lastSeenAt => $_getN(3);
  @$pb.TagNumber(4)
  set lastSeenAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLastSeenAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastSeenAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureLastSeenAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get reportedAt => $_getN(4);
  @$pb.TagNumber(5)
  set reportedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReportedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearReportedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureReportedAt() => $_ensure(4);

  /// Items it still had to back up then.
  @$pb.TagNumber(6)
  $fixnum.Int64 get pendingCount => $_getI64(5);
  @$pb.TagNumber(6)
  set pendingCount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPendingCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearPendingCount() => $_clearField(6);

  /// It has not reported for longer than the settings' `backup_silent_hours`.
  @$pb.TagNumber(7)
  $core.bool get silent => $_getBF(6);
  @$pb.TagNumber(7)
  set silent($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSilent() => $_has(6);
  @$pb.TagNumber(7)
  void clearSilent() => $_clearField(7);
}

/// A database dump.
class Backup extends $pb.GeneratedMessage {
  factory Backup({
    $core.String? name,
    $fixnum.Int64? sizeBytes,
    $0.Timestamp? createdAt,
    $core.String? store,
  }) {
    final result = Backup._();
    if (name != null) result.name = name;
    if (sizeBytes != null) result.sizeBytes = sizeBytes;
    if (createdAt != null) result.createdAt = createdAt;
    if (store != null) result.store = store;
    return result;
  }

  Backup._();

  factory Backup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Backup()..mergeFromBuffer(data, registry);
  factory Backup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Backup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Backup',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: Backup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'sizeBytes')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'store')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Backup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Backup copyWith(void Function(Backup) updates) =>
      super.copyWith((message) => updates(message as Backup)) as Backup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Backup() / Backup.new instead')
  static Backup create() => Backup._();
  static $pb.GeneratedMessage $_createMessage() => Backup._();
  @$core.override
  Backup createEmptyInstance() => Backup._();
  @$core.pragma('dart2js:noInline')
  static Backup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Backup>(Backup.$_createMessage);
  static Backup? _defaultInstance;

  /// Its key in the store, such as `backups/backup-20261021T030000Z.dump`.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sizeBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set sizeBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSizeBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearSizeBytes() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureCreatedAt() => $_ensure(2);

  /// `local`, the data directory, or a configured store.
  @$pb.TagNumber(4)
  $core.String get store => $_getSZ(3);
  @$pb.TagNumber(4)
  set store($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStore() => $_has(3);
  @$pb.TagNumber(4)
  void clearStore() => $_clearField(4);
}

/// How a backup, a restore drill or a restore ended.
class BackupRun extends $pb.GeneratedMessage {
  factory BackupRun({
    $core.String? store,
    $core.String? dump,
    $core.bool? ok,
    $core.String? detail,
    $0.Timestamp? finishedAt,
  }) {
    final result = BackupRun._();
    if (store != null) result.store = store;
    if (dump != null) result.dump = dump;
    if (ok != null) result.ok = ok;
    if (detail != null) result.detail = detail;
    if (finishedAt != null) result.finishedAt = finishedAt;
    return result;
  }

  BackupRun._();

  factory BackupRun.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackupRun()..mergeFromBuffer(data, registry);
  factory BackupRun.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackupRun()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupRun',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: BackupRun.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'store')
    ..aOS(2, _omitFieldNames ? '' : 'dump')
    ..aOB(3, _omitFieldNames ? '' : 'ok')
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'finishedAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupRun clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupRun copyWith(void Function(BackupRun) updates) =>
      super.copyWith((message) => updates(message as BackupRun)) as BackupRun;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BackupRun() / BackupRun.new instead')
  static BackupRun create() => BackupRun._();
  static $pb.GeneratedMessage $_createMessage() => BackupRun._();
  @$core.override
  BackupRun createEmptyInstance() => BackupRun._();
  @$core.pragma('dart2js:noInline')
  static BackupRun getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupRun>(BackupRun.$_createMessage);
  static BackupRun? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get store => $_getSZ(0);
  @$pb.TagNumber(1)
  set store($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStore() => $_has(0);
  @$pb.TagNumber(1)
  void clearStore() => $_clearField(1);

  /// The dump's key in the store.
  @$pb.TagNumber(2)
  $core.String get dump => $_getSZ(1);
  @$pb.TagNumber(2)
  set dump($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDump() => $_has(1);
  @$pb.TagNumber(2)
  void clearDump() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get ok => $_getBF(2);
  @$pb.TagNumber(3)
  set ok($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOk() => $_has(2);
  @$pb.TagNumber(3)
  void clearOk() => $_clearField(3);

  /// In English for the administrator: what a drill restored, or why it failed.
  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get finishedAt => $_getN(4);
  @$pb.TagNumber(5)
  set finishedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFinishedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearFinishedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureFinishedAt() => $_ensure(4);
}

/// How many jobs of a type have a status.
class JobCount extends $pb.GeneratedMessage {
  factory JobCount({
    $core.String? type,
    JobStatus? status,
    $fixnum.Int64? count,
  }) {
    final result = JobCount._();
    if (type != null) result.type = type;
    if (status != null) result.status = status;
    if (count != null) result.count = count;
    return result;
  }

  JobCount._();

  factory JobCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JobCount()..mergeFromBuffer(data, registry);
  factory JobCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JobCount()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JobCount',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: JobCount.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aE<JobStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: JobStatus.values)
    ..aInt64(3, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobCount copyWith(void Function(JobCount) updates) =>
      super.copyWith((message) => updates(message as JobCount)) as JobCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use JobCount() / JobCount.new instead')
  static JobCount create() => JobCount._();
  static $pb.GeneratedMessage $_createMessage() => JobCount._();
  @$core.override
  JobCount createEmptyInstance() => JobCount._();
  @$core.pragma('dart2js:noInline')
  static JobCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JobCount>(JobCount.$_createMessage);
  static JobCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  JobStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(JobStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get count => $_getI64(2);
  @$pb.TagNumber(3)
  set count($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);
}

/// A paused job type.
class JobPause extends $pb.GeneratedMessage {
  factory JobPause({
    $core.String? type,
    $0.Timestamp? untilAt,
    $core.String? pausedByUserId,
  }) {
    final result = JobPause._();
    if (type != null) result.type = type;
    if (untilAt != null) result.untilAt = untilAt;
    if (pausedByUserId != null) result.pausedByUserId = pausedByUserId;
    return result;
  }

  JobPause._();

  factory JobPause.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JobPause()..mergeFromBuffer(data, registry);
  factory JobPause.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JobPause()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JobPause',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: JobPause.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'untilAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'pausedByUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobPause clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JobPause copyWith(void Function(JobPause) updates) =>
      super.copyWith((message) => updates(message as JobPause)) as JobPause;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use JobPause() / JobPause.new instead')
  static JobPause create() => JobPause._();
  static $pb.GeneratedMessage $_createMessage() => JobPause._();
  @$core.override
  JobPause createEmptyInstance() => JobPause._();
  @$core.pragma('dart2js:noInline')
  static JobPause getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JobPause>(JobPause.$_createMessage);
  static JobPause? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// When the pause ends by itself.
  @$pb.TagNumber(2)
  $0.Timestamp get untilAt => $_getN(1);
  @$pb.TagNumber(2)
  set untilAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUntilAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearUntilAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureUntilAt() => $_ensure(1);

  /// Who paused it; empty when the account is gone.
  @$pb.TagNumber(3)
  $core.String get pausedByUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set pausedByUserId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPausedByUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPausedByUserId() => $_clearField(3);
}

/// Asks for the stores.
class ListStoresRequest extends $pb.GeneratedMessage {
  factory ListStoresRequest() => ListStoresRequest._();

  ListStoresRequest._();

  factory ListStoresRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStoresRequest()..mergeFromBuffer(data, registry);
  factory ListStoresRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStoresRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStoresRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ListStoresRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStoresRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStoresRequest copyWith(void Function(ListStoresRequest) updates) =>
      super.copyWith((message) => updates(message as ListStoresRequest))
          as ListStoresRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListStoresRequest() / ListStoresRequest.new instead')
  static ListStoresRequest create() => ListStoresRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListStoresRequest._();
  @$core.override
  ListStoresRequest createEmptyInstance() => ListStoresRequest._();
  @$core.pragma('dart2js:noInline')
  static ListStoresRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListStoresRequest>(
          ListStoresRequest.$_createMessage);
  static ListStoresRequest? _defaultInstance;
}

/// Every store, the data directory (`local`) first.
class ListStoresResponse extends $pb.GeneratedMessage {
  factory ListStoresResponse({
    $core.Iterable<StoreStatus>? stores,
  }) {
    final result = ListStoresResponse._();
    if (stores != null) result.stores.addAll(stores);
    return result;
  }

  ListStoresResponse._();

  factory ListStoresResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStoresResponse()..mergeFromBuffer(data, registry);
  factory ListStoresResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStoresResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStoresResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ListStoresResponse.$_createMessage)
    ..pPM<StoreStatus>(1, _omitFieldNames ? '' : 'stores',
        subBuilder: StoreStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStoresResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStoresResponse copyWith(void Function(ListStoresResponse) updates) =>
      super.copyWith((message) => updates(message as ListStoresResponse))
          as ListStoresResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListStoresResponse() / ListStoresResponse.new instead')
  static ListStoresResponse create() => ListStoresResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListStoresResponse._();
  @$core.override
  ListStoresResponse createEmptyInstance() => ListStoresResponse._();
  @$core.pragma('dart2js:noInline')
  static ListStoresResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStoresResponse>(
          ListStoresResponse.$_createMessage);
  static ListStoresResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StoreStatus> get stores => $_getList(0);
}

/// A store as checked now.
class StoreStatus extends $pb.GeneratedMessage {
  factory StoreStatus({
    $core.String? name,
    CheckStatus? status,
    $core.String? detail,
    $fixnum.Int64? freeBytes,
  }) {
    final result = StoreStatus._();
    if (name != null) result.name = name;
    if (status != null) result.status = status;
    if (detail != null) result.detail = detail;
    if (freeBytes != null) result.freeBytes = freeBytes;
    return result;
  }

  StoreStatus._();

  factory StoreStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreStatus()..mergeFromBuffer(data, registry);
  factory StoreStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreStatus',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: StoreStatus.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<CheckStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: CheckStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'detail')
    ..aInt64(4, _omitFieldNames ? '' : 'freeBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreStatus copyWith(void Function(StoreStatus) updates) =>
      super.copyWith((message) => updates(message as StoreStatus))
          as StoreStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoreStatus() / StoreStatus.new instead')
  static StoreStatus create() => StoreStatus._();
  static $pb.GeneratedMessage $_createMessage() => StoreStatus._();
  @$core.override
  StoreStatus createEmptyInstance() => StoreStatus._();
  @$core.pragma('dart2js:noInline')
  static StoreStatus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoreStatus>(
          StoreStatus.$_createMessage);
  static StoreStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  CheckStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(CheckStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// What the check found, in English for the administrator: the marker's store id, or why the store is offline.
  @$pb.TagNumber(3)
  $core.String get detail => $_getSZ(2);
  @$pb.TagNumber(3)
  set detail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetail() => $_clearField(3);

  /// Free space on a filesystem store; absent on an object store.
  @$pb.TagNumber(4)
  $fixnum.Int64 get freeBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set freeBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFreeBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearFreeBytes() => $_clearField(4);
}

/// Which jobs to list.
class ListJobsRequest extends $pb.GeneratedMessage {
  factory ListJobsRequest({
    JobStatus? status,
    $core.String? type,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = ListJobsRequest._();
    if (status != null) result.status = status;
    if (type != null) result.type = type;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListJobsRequest._();

  factory ListJobsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListJobsRequest()..mergeFromBuffer(data, registry);
  factory ListJobsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListJobsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ListJobsRequest.$_createMessage)
    ..aE<JobStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: JobStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aOS(4, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsRequest copyWith(void Function(ListJobsRequest) updates) =>
      super.copyWith((message) => updates(message as ListJobsRequest))
          as ListJobsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListJobsRequest() / ListJobsRequest.new instead')
  static ListJobsRequest create() => ListJobsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListJobsRequest._();
  @$core.override
  ListJobsRequest createEmptyInstance() => ListJobsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListJobsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListJobsRequest>(
          ListJobsRequest.$_createMessage);
  static ListJobsRequest? _defaultInstance;

  /// Unspecified lists every status.
  @$pb.TagNumber(1)
  JobStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(JobStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  /// Empty lists every type.
  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// At most 500; 0 means 100.
  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  /// From a previous response.
  @$pb.TagNumber(4)
  $core.String get pageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set pageToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageToken() => $_clearField(4);
}

/// A page of jobs.
class ListJobsResponse extends $pb.GeneratedMessage {
  factory ListJobsResponse({
    $core.Iterable<Job>? jobs,
    $core.String? nextPageToken,
  }) {
    final result = ListJobsResponse._();
    if (jobs != null) result.jobs.addAll(jobs);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListJobsResponse._();

  factory ListJobsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListJobsResponse()..mergeFromBuffer(data, registry);
  factory ListJobsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListJobsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListJobsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ListJobsResponse.$_createMessage)
    ..pPM<Job>(1, _omitFieldNames ? '' : 'jobs',
        subBuilder: Job.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListJobsResponse copyWith(void Function(ListJobsResponse) updates) =>
      super.copyWith((message) => updates(message as ListJobsResponse))
          as ListJobsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListJobsResponse() / ListJobsResponse.new instead')
  static ListJobsResponse create() => ListJobsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListJobsResponse._();
  @$core.override
  ListJobsResponse createEmptyInstance() => ListJobsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListJobsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListJobsResponse>(
          ListJobsResponse.$_createMessage);
  static ListJobsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Job> get jobs => $_getList(0);

  /// Empty on the last page.
  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

/// A job of the queue.
class Job extends $pb.GeneratedMessage {
  factory Job({
    $core.String? jobId,
    $core.String? type,
    JobStatus? status,
    $core.int? attempts,
    $core.String? error,
    $core.int? progressPercent,
    $core.String? key,
    $0.Timestamp? createdAt,
    $0.Timestamp? runAt,
  }) {
    final result = Job._();
    if (jobId != null) result.jobId = jobId;
    if (type != null) result.type = type;
    if (status != null) result.status = status;
    if (attempts != null) result.attempts = attempts;
    if (error != null) result.error = error;
    if (progressPercent != null) result.progressPercent = progressPercent;
    if (key != null) result.key = key;
    if (createdAt != null) result.createdAt = createdAt;
    if (runAt != null) result.runAt = runAt;
    return result;
  }

  Job._();

  factory Job.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Job()..mergeFromBuffer(data, registry);
  factory Job.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Job()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Job',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: Job.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aE<JobStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: JobStatus.values)
    ..aI(4, _omitFieldNames ? '' : 'attempts')
    ..aOS(5, _omitFieldNames ? '' : 'error')
    ..aI(6, _omitFieldNames ? '' : 'progressPercent',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(7, _omitFieldNames ? '' : 'key')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'runAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Job clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Job copyWith(void Function(Job) updates) =>
      super.copyWith((message) => updates(message as Job)) as Job;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Job() / Job.new instead')
  static Job create() => Job._();
  static $pb.GeneratedMessage $_createMessage() => Job._();
  @$core.override
  Job createEmptyInstance() => Job._();
  @$core.pragma('dart2js:noInline')
  static Job getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Job>(Job.$_createMessage);
  static Job? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  JobStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(JobStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get attempts => $_getIZ(3);
  @$pb.TagNumber(4)
  set attempts($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAttempts() => $_has(3);
  @$pb.TagNumber(4)
  void clearAttempts() => $_clearField(4);

  /// The last failure.
  @$pb.TagNumber(5)
  $core.String get error => $_getSZ(4);
  @$pb.TagNumber(5)
  set error($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(5)
  void clearError() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get progressPercent => $_getIZ(5);
  @$pb.TagNumber(6)
  set progressPercent($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProgressPercent() => $_has(5);
  @$pb.TagNumber(6)
  void clearProgressPercent() => $_clearField(6);

  /// What the job is for, such as `render:<asset>:<role>:<spec>`; empty if unkeyed.
  @$pb.TagNumber(7)
  $core.String get key => $_getSZ(6);
  @$pb.TagNumber(7)
  set key($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearKey() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureCreatedAt() => $_ensure(7);

  /// When it may run next.
  @$pb.TagNumber(9)
  $0.Timestamp get runAt => $_getN(8);
  @$pb.TagNumber(9)
  set runAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRunAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearRunAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureRunAt() => $_ensure(8);
}

/// The job to retry.
class RetryJobRequest extends $pb.GeneratedMessage {
  factory RetryJobRequest({
    $core.String? jobId,
  }) {
    final result = RetryJobRequest._();
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  RetryJobRequest._();

  factory RetryJobRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryJobRequest()..mergeFromBuffer(data, registry);
  factory RetryJobRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryJobRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetryJobRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: RetryJobRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryJobRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryJobRequest copyWith(void Function(RetryJobRequest) updates) =>
      super.copyWith((message) => updates(message as RetryJobRequest))
          as RetryJobRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RetryJobRequest() / RetryJobRequest.new instead')
  static RetryJobRequest create() => RetryJobRequest._();
  static $pb.GeneratedMessage $_createMessage() => RetryJobRequest._();
  @$core.override
  RetryJobRequest createEmptyInstance() => RetryJobRequest._();
  @$core.pragma('dart2js:noInline')
  static RetryJobRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryJobRequest>(
          RetryJobRequest.$_createMessage);
  static RetryJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

/// A job that was neither dead nor cancelled is failed_precondition `job.not_retryable`.
class RetryJobResponse extends $pb.GeneratedMessage {
  factory RetryJobResponse() => RetryJobResponse._();

  RetryJobResponse._();

  factory RetryJobResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryJobResponse()..mergeFromBuffer(data, registry);
  factory RetryJobResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryJobResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetryJobResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: RetryJobResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryJobResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryJobResponse copyWith(void Function(RetryJobResponse) updates) =>
      super.copyWith((message) => updates(message as RetryJobResponse))
          as RetryJobResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RetryJobResponse() / RetryJobResponse.new instead')
  static RetryJobResponse create() => RetryJobResponse._();
  static $pb.GeneratedMessage $_createMessage() => RetryJobResponse._();
  @$core.override
  RetryJobResponse createEmptyInstance() => RetryJobResponse._();
  @$core.pragma('dart2js:noInline')
  static RetryJobResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryJobResponse>(
          RetryJobResponse.$_createMessage);
  static RetryJobResponse? _defaultInstance;
}

/// The job to cancel.
class CancelJobRequest extends $pb.GeneratedMessage {
  factory CancelJobRequest({
    $core.String? jobId,
  }) {
    final result = CancelJobRequest._();
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  CancelJobRequest._();

  factory CancelJobRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelJobRequest()..mergeFromBuffer(data, registry);
  factory CancelJobRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelJobRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelJobRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: CancelJobRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelJobRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelJobRequest copyWith(void Function(CancelJobRequest) updates) =>
      super.copyWith((message) => updates(message as CancelJobRequest))
          as CancelJobRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelJobRequest() / CancelJobRequest.new instead')
  static CancelJobRequest create() => CancelJobRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelJobRequest._();
  @$core.override
  CancelJobRequest createEmptyInstance() => CancelJobRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelJobRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelJobRequest>(
          CancelJobRequest.$_createMessage);
  static CancelJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

/// A job that was neither queued nor running is failed_precondition `job.not_cancellable`.
class CancelJobResponse extends $pb.GeneratedMessage {
  factory CancelJobResponse() => CancelJobResponse._();

  CancelJobResponse._();

  factory CancelJobResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelJobResponse()..mergeFromBuffer(data, registry);
  factory CancelJobResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelJobResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelJobResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: CancelJobResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelJobResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelJobResponse copyWith(void Function(CancelJobResponse) updates) =>
      super.copyWith((message) => updates(message as CancelJobResponse))
          as CancelJobResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelJobResponse() / CancelJobResponse.new instead')
  static CancelJobResponse create() => CancelJobResponse._();
  static $pb.GeneratedMessage $_createMessage() => CancelJobResponse._();
  @$core.override
  CancelJobResponse createEmptyInstance() => CancelJobResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelJobResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelJobResponse>(
          CancelJobResponse.$_createMessage);
  static CancelJobResponse? _defaultInstance;
}

/// The type to pause and for how long.
class PauseJobTypeRequest extends $pb.GeneratedMessage {
  factory PauseJobTypeRequest({
    $core.String? type,
    $core.int? pauseMinutes,
  }) {
    final result = PauseJobTypeRequest._();
    if (type != null) result.type = type;
    if (pauseMinutes != null) result.pauseMinutes = pauseMinutes;
    return result;
  }

  PauseJobTypeRequest._();

  factory PauseJobTypeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseJobTypeRequest()..mergeFromBuffer(data, registry);
  factory PauseJobTypeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseJobTypeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseJobTypeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: PauseJobTypeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aI(2, _omitFieldNames ? '' : 'pauseMinutes',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseJobTypeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseJobTypeRequest copyWith(void Function(PauseJobTypeRequest) updates) =>
      super.copyWith((message) => updates(message as PauseJobTypeRequest))
          as PauseJobTypeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PauseJobTypeRequest() / PauseJobTypeRequest.new instead')
  static PauseJobTypeRequest create() => PauseJobTypeRequest._();
  static $pb.GeneratedMessage $_createMessage() => PauseJobTypeRequest._();
  @$core.override
  PauseJobTypeRequest createEmptyInstance() => PauseJobTypeRequest._();
  @$core.pragma('dart2js:noInline')
  static PauseJobTypeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseJobTypeRequest>(
          PauseJobTypeRequest.$_createMessage);
  static PauseJobTypeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// 1 to 1440, or to 10080 (7 days) for backup, storage-purge and scrub; 0 means 60.
  @$pb.TagNumber(2)
  $core.int get pauseMinutes => $_getIZ(1);
  @$pb.TagNumber(2)
  set pauseMinutes($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPauseMinutes() => $_has(1);
  @$pb.TagNumber(2)
  void clearPauseMinutes() => $_clearField(2);
}

/// The pause.
class PauseJobTypeResponse extends $pb.GeneratedMessage {
  factory PauseJobTypeResponse({
    JobPause? pause,
  }) {
    final result = PauseJobTypeResponse._();
    if (pause != null) result.pause = pause;
    return result;
  }

  PauseJobTypeResponse._();

  factory PauseJobTypeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseJobTypeResponse()..mergeFromBuffer(data, registry);
  factory PauseJobTypeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseJobTypeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseJobTypeResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: PauseJobTypeResponse.$_createMessage)
    ..aOM<JobPause>(1, _omitFieldNames ? '' : 'pause',
        subBuilder: JobPause.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseJobTypeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseJobTypeResponse copyWith(void Function(PauseJobTypeResponse) updates) =>
      super.copyWith((message) => updates(message as PauseJobTypeResponse))
          as PauseJobTypeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PauseJobTypeResponse() / PauseJobTypeResponse.new instead')
  static PauseJobTypeResponse create() => PauseJobTypeResponse._();
  static $pb.GeneratedMessage $_createMessage() => PauseJobTypeResponse._();
  @$core.override
  PauseJobTypeResponse createEmptyInstance() => PauseJobTypeResponse._();
  @$core.pragma('dart2js:noInline')
  static PauseJobTypeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseJobTypeResponse>(
          PauseJobTypeResponse.$_createMessage);
  static PauseJobTypeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  JobPause get pause => $_getN(0);
  @$pb.TagNumber(1)
  set pause(JobPause value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPause() => $_has(0);
  @$pb.TagNumber(1)
  void clearPause() => $_clearField(1);
  @$pb.TagNumber(1)
  JobPause ensurePause() => $_ensure(0);
}

/// The type to resume.
class ResumeJobTypeRequest extends $pb.GeneratedMessage {
  factory ResumeJobTypeRequest({
    $core.String? type,
  }) {
    final result = ResumeJobTypeRequest._();
    if (type != null) result.type = type;
    return result;
  }

  ResumeJobTypeRequest._();

  factory ResumeJobTypeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeJobTypeRequest()..mergeFromBuffer(data, registry);
  factory ResumeJobTypeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeJobTypeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeJobTypeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ResumeJobTypeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeJobTypeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeJobTypeRequest copyWith(void Function(ResumeJobTypeRequest) updates) =>
      super.copyWith((message) => updates(message as ResumeJobTypeRequest))
          as ResumeJobTypeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResumeJobTypeRequest() / ResumeJobTypeRequest.new instead')
  static ResumeJobTypeRequest create() => ResumeJobTypeRequest._();
  static $pb.GeneratedMessage $_createMessage() => ResumeJobTypeRequest._();
  @$core.override
  ResumeJobTypeRequest createEmptyInstance() => ResumeJobTypeRequest._();
  @$core.pragma('dart2js:noInline')
  static ResumeJobTypeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeJobTypeRequest>(
          ResumeJobTypeRequest.$_createMessage);
  static ResumeJobTypeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);
}

/// A type that was not paused is failed_precondition `job.not_paused`.
class ResumeJobTypeResponse extends $pb.GeneratedMessage {
  factory ResumeJobTypeResponse() => ResumeJobTypeResponse._();

  ResumeJobTypeResponse._();

  factory ResumeJobTypeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeJobTypeResponse()..mergeFromBuffer(data, registry);
  factory ResumeJobTypeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResumeJobTypeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeJobTypeResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ResumeJobTypeResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeJobTypeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeJobTypeResponse copyWith(
          void Function(ResumeJobTypeResponse) updates) =>
      super.copyWith((message) => updates(message as ResumeJobTypeResponse))
          as ResumeJobTypeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResumeJobTypeResponse() / ResumeJobTypeResponse.new instead')
  static ResumeJobTypeResponse create() => ResumeJobTypeResponse._();
  static $pb.GeneratedMessage $_createMessage() => ResumeJobTypeResponse._();
  @$core.override
  ResumeJobTypeResponse createEmptyInstance() => ResumeJobTypeResponse._();
  @$core.pragma('dart2js:noInline')
  static ResumeJobTypeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeJobTypeResponse>(
          ResumeJobTypeResponse.$_createMessage);
  static ResumeJobTypeResponse? _defaultInstance;
}

/// A scope and what to redo in it: either assets, or a library and optionally a folder in it. Private libraries are
/// skipped: their devices process them.
class ReprocessRequest extends $pb.GeneratedMessage {
  factory ReprocessRequest({
    $core.Iterable<$core.String>? assetIds,
    $core.String? libraryId,
    $core.String? folder,
    $core.Iterable<ReprocessKind>? kinds,
  }) {
    final result = ReprocessRequest._();
    if (assetIds != null) result.assetIds.addAll(assetIds);
    if (libraryId != null) result.libraryId = libraryId;
    if (folder != null) result.folder = folder;
    if (kinds != null) result.kinds.addAll(kinds);
    return result;
  }

  ReprocessRequest._();

  factory ReprocessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReprocessRequest()..mergeFromBuffer(data, registry);
  factory ReprocessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReprocessRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReprocessRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ReprocessRequest.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'assetIds')
    ..aOS(2, _omitFieldNames ? '' : 'libraryId')
    ..aOS(3, _omitFieldNames ? '' : 'folder')
    ..pc<ReprocessKind>(4, _omitFieldNames ? '' : 'kinds', $pb.PbFieldType.KE,
        valueOf: ReprocessKind.valueOf,
        enumValues: ReprocessKind.values,
        defaultEnumValue: ReprocessKind.REPROCESS_KIND_UNSPECIFIED)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprocessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprocessRequest copyWith(void Function(ReprocessRequest) updates) =>
      super.copyWith((message) => updates(message as ReprocessRequest))
          as ReprocessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReprocessRequest() / ReprocessRequest.new instead')
  static ReprocessRequest create() => ReprocessRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReprocessRequest._();
  @$core.override
  ReprocessRequest createEmptyInstance() => ReprocessRequest._();
  @$core.pragma('dart2js:noInline')
  static ReprocessRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReprocessRequest>(
          ReprocessRequest.$_createMessage);
  static ReprocessRequest? _defaultInstance;

  /// A selection.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get assetIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get libraryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set libraryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

  /// A folder of the library's originals, with its subfolders, as `2024/05`; empty means the whole library.
  @$pb.TagNumber(3)
  $core.String get folder => $_getSZ(2);
  @$pb.TagNumber(3)
  set folder($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFolder() => $_has(2);
  @$pb.TagNumber(3)
  void clearFolder() => $_clearField(3);

  /// At least one.
  @$pb.TagNumber(4)
  $pb.PbList<ReprocessKind> get kinds => $_getList(3);
}

/// What was queued.
class ReprocessResponse extends $pb.GeneratedMessage {
  factory ReprocessResponse({
    $fixnum.Int64? jobCount,
  }) {
    final result = ReprocessResponse._();
    if (jobCount != null) result.jobCount = jobCount;
    return result;
  }

  ReprocessResponse._();

  factory ReprocessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReprocessResponse()..mergeFromBuffer(data, registry);
  factory ReprocessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReprocessResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReprocessResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ReprocessResponse.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'jobCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprocessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprocessResponse copyWith(void Function(ReprocessResponse) updates) =>
      super.copyWith((message) => updates(message as ReprocessResponse))
          as ReprocessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReprocessResponse() / ReprocessResponse.new instead')
  static ReprocessResponse create() => ReprocessResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReprocessResponse._();
  @$core.override
  ReprocessResponse createEmptyInstance() => ReprocessResponse._();
  @$core.pragma('dart2js:noInline')
  static ReprocessResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReprocessResponse>(
          ReprocessResponse.$_createMessage);
  static ReprocessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get jobCount => $_getI64(0);
  @$pb.TagNumber(1)
  set jobCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobCount() => $_clearField(1);
}

/// Which events to list.
class ListAuditEventsRequest extends $pb.GeneratedMessage {
  factory ListAuditEventsRequest({
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = ListAuditEventsRequest._();
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ListAuditEventsRequest._();

  factory ListAuditEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAuditEventsRequest()..mergeFromBuffer(data, registry);
  factory ListAuditEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAuditEventsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuditEventsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ListAuditEventsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditEventsRequest copyWith(
          void Function(ListAuditEventsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAuditEventsRequest))
          as ListAuditEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAuditEventsRequest() / ListAuditEventsRequest.new instead')
  static ListAuditEventsRequest create() => ListAuditEventsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListAuditEventsRequest._();
  @$core.override
  ListAuditEventsRequest createEmptyInstance() => ListAuditEventsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListAuditEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuditEventsRequest>(
          ListAuditEventsRequest.$_createMessage);
  static ListAuditEventsRequest? _defaultInstance;

  /// At most 500; 0 means 100.
  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  /// From a previous response.
  @$pb.TagNumber(2)
  $core.String get pageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageToken() => $_clearField(2);
}

/// A page of events.
class ListAuditEventsResponse extends $pb.GeneratedMessage {
  factory ListAuditEventsResponse({
    $core.Iterable<AuditEvent>? events,
    $core.String? nextPageToken,
  }) {
    final result = ListAuditEventsResponse._();
    if (events != null) result.events.addAll(events);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListAuditEventsResponse._();

  factory ListAuditEventsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAuditEventsResponse()..mergeFromBuffer(data, registry);
  factory ListAuditEventsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAuditEventsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAuditEventsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ListAuditEventsResponse.$_createMessage)
    ..pPM<AuditEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: AuditEvent.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditEventsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAuditEventsResponse copyWith(
          void Function(ListAuditEventsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAuditEventsResponse))
          as ListAuditEventsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAuditEventsResponse() / ListAuditEventsResponse.new instead')
  static ListAuditEventsResponse create() => ListAuditEventsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListAuditEventsResponse._();
  @$core.override
  ListAuditEventsResponse createEmptyInstance() => ListAuditEventsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListAuditEventsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAuditEventsResponse>(
          ListAuditEventsResponse.$_createMessage);
  static ListAuditEventsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AuditEvent> get events => $_getList(0);

  /// Empty on the last page.
  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

/// An event of the hash-chained audit log.
class AuditEvent extends $pb.GeneratedMessage {
  factory AuditEvent({
    $fixnum.Int64? sequence,
    $0.Timestamp? recordedAt,
    $core.String? actorUserId,
    $core.String? action,
    $core.String? targetJson,
    $core.String? detailsJson,
  }) {
    final result = AuditEvent._();
    if (sequence != null) result.sequence = sequence;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (actorUserId != null) result.actorUserId = actorUserId;
    if (action != null) result.action = action;
    if (targetJson != null) result.targetJson = targetJson;
    if (detailsJson != null) result.detailsJson = detailsJson;
    return result;
  }

  AuditEvent._();

  factory AuditEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuditEvent()..mergeFromBuffer(data, registry);
  factory AuditEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AuditEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuditEvent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: AuditEvent.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'sequence')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'actorUserId')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'targetJson')
    ..aOS(6, _omitFieldNames ? '' : 'detailsJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuditEvent copyWith(void Function(AuditEvent) updates) =>
      super.copyWith((message) => updates(message as AuditEvent)) as AuditEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AuditEvent() / AuditEvent.new instead')
  static AuditEvent create() => AuditEvent._();
  static $pb.GeneratedMessage $_createMessage() => AuditEvent._();
  @$core.override
  AuditEvent createEmptyInstance() => AuditEvent._();
  @$core.pragma('dart2js:noInline')
  static AuditEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuditEvent>(AuditEvent.$_createMessage);
  static AuditEvent? _defaultInstance;

  /// Its place in the chain.
  @$pb.TagNumber(1)
  $fixnum.Int64 get sequence => $_getI64(0);
  @$pb.TagNumber(1)
  set sequence($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get recordedAt => $_getN(1);
  @$pb.TagNumber(2)
  set recordedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureRecordedAt() => $_ensure(1);

  /// Empty when the change was made around photolibd.
  @$pb.TagNumber(3)
  $core.String get actorUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set actorUserId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActorUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearActorUserId() => $_clearField(3);

  /// Such as `user.update` or `settings.update`.
  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  /// JSON objects.
  @$pb.TagNumber(5)
  $core.String get targetJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get detailsJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set detailsJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDetailsJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearDetailsJson() => $_clearField(6);
}

/// How many lines to return.
class TailLogsRequest extends $pb.GeneratedMessage {
  factory TailLogsRequest({
    $core.int? lineCount,
  }) {
    final result = TailLogsRequest._();
    if (lineCount != null) result.lineCount = lineCount;
    return result;
  }

  TailLogsRequest._();

  factory TailLogsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TailLogsRequest()..mergeFromBuffer(data, registry);
  factory TailLogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TailLogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TailLogsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: TailLogsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'lineCount', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TailLogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TailLogsRequest copyWith(void Function(TailLogsRequest) updates) =>
      super.copyWith((message) => updates(message as TailLogsRequest))
          as TailLogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TailLogsRequest() / TailLogsRequest.new instead')
  static TailLogsRequest create() => TailLogsRequest._();
  static $pb.GeneratedMessage $_createMessage() => TailLogsRequest._();
  @$core.override
  TailLogsRequest createEmptyInstance() => TailLogsRequest._();
  @$core.pragma('dart2js:noInline')
  static TailLogsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TailLogsRequest>(
          TailLogsRequest.$_createMessage);
  static TailLogsRequest? _defaultInstance;

  /// At most 1000; 0 means 200.
  @$pb.TagNumber(1)
  $core.int get lineCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set lineCount($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLineCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearLineCount() => $_clearField(1);
}

/// The newest lines, oldest first.
class TailLogsResponse extends $pb.GeneratedMessage {
  factory TailLogsResponse({
    $core.Iterable<$core.String>? lines,
  }) {
    final result = TailLogsResponse._();
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  TailLogsResponse._();

  factory TailLogsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TailLogsResponse()..mergeFromBuffer(data, registry);
  factory TailLogsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TailLogsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TailLogsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: TailLogsResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'lines')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TailLogsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TailLogsResponse copyWith(void Function(TailLogsResponse) updates) =>
      super.copyWith((message) => updates(message as TailLogsResponse))
          as TailLogsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TailLogsResponse() / TailLogsResponse.new instead')
  static TailLogsResponse create() => TailLogsResponse._();
  static $pb.GeneratedMessage $_createMessage() => TailLogsResponse._();
  @$core.override
  TailLogsResponse createEmptyInstance() => TailLogsResponse._();
  @$core.pragma('dart2js:noInline')
  static TailLogsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TailLogsResponse>(
          TailLogsResponse.$_createMessage);
  static TailLogsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get lines => $_getList(0);
}

/// The instance's policies and defaults (OPS-20, OPS-23).
class Settings extends $pb.GeneratedMessage {
  factory Settings({
    $core.bool? requireTwoFactor,
    $core.bool? faceRecognitionDefault,
    $core.int? trashRetentionDays,
    $core.int? minFreeDiskPercent,
    $core.int? scrubDays,
    $core.int? backupSilentHours,
    $core.int? minFreeDiskGb,
  }) {
    final result = Settings._();
    if (requireTwoFactor != null) result.requireTwoFactor = requireTwoFactor;
    if (faceRecognitionDefault != null)
      result.faceRecognitionDefault = faceRecognitionDefault;
    if (trashRetentionDays != null)
      result.trashRetentionDays = trashRetentionDays;
    if (minFreeDiskPercent != null)
      result.minFreeDiskPercent = minFreeDiskPercent;
    if (scrubDays != null) result.scrubDays = scrubDays;
    if (backupSilentHours != null) result.backupSilentHours = backupSilentHours;
    if (minFreeDiskGb != null) result.minFreeDiskGb = minFreeDiskGb;
    return result;
  }

  Settings._();

  factory Settings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Settings()..mergeFromBuffer(data, registry);
  factory Settings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Settings()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Settings',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: Settings.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'requireTwoFactor')
    ..aOB(2, _omitFieldNames ? '' : 'faceRecognitionDefault')
    ..aI(3, _omitFieldNames ? '' : 'trashRetentionDays',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'minFreeDiskPercent',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'scrubDays', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'backupSilentHours',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'minFreeDiskGb',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings copyWith(void Function(Settings) updates) =>
      super.copyWith((message) => updates(message as Settings)) as Settings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Settings() / Settings.new instead')
  static Settings create() => Settings._();
  static $pb.GeneratedMessage $_createMessage() => Settings._();
  @$core.override
  Settings createEmptyInstance() => Settings._();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Settings>(Settings.$_createMessage);
  static Settings? _defaultInstance;

  /// Accounts without a passkey or TOTP can do nothing but set one up (ADR-0088).
  @$pb.TagNumber(1)
  $core.bool get requireTwoFactor => $_getBF(0);
  @$pb.TagNumber(1)
  set requireTwoFactor($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequireTwoFactor() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequireTwoFactor() => $_clearField(1);

  /// Whether face recognition starts switched on for new accounts; each user may change it.
  @$pb.TagNumber(2)
  $core.bool get faceRecognitionDefault => $_getBF(1);
  @$pb.TagNumber(2)
  set faceRecognitionDefault($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFaceRecognitionDefault() => $_has(1);
  @$pb.TagNumber(2)
  void clearFaceRecognitionDefault() => $_clearField(2);

  /// How long trashed items stay, 1 to 3650.
  @$pb.TagNumber(3)
  $core.int get trashRetentionDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set trashRetentionDays($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrashRetentionDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrashRetentionDays() => $_clearField(3);

  /// Uploads pause while a filesystem they fill has less free space than this share of its size, or than
  /// min_free_disk_gb if that is less (ADR-0063); 0 to 50.
  @$pb.TagNumber(4)
  $core.int get minFreeDiskPercent => $_getIZ(3);
  @$pb.TagNumber(4)
  set minFreeDiskPercent($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinFreeDiskPercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinFreeDiskPercent() => $_clearField(4);

  /// The scrub checks every original once in this many days, 1 to 3650; 0 in an update keeps it, as older clients send.
  @$pb.TagNumber(5)
  $core.int get scrubDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set scrubDays($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScrubDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearScrubDays() => $_clearField(5);

  /// A device that has not reported its backup for this many hours is silent, 1 to 8760; 0 in an update keeps it.
  @$pb.TagNumber(6)
  $core.int get backupSilentHours => $_getIZ(5);
  @$pb.TagNumber(6)
  set backupSilentHours($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBackupSilentHours() => $_has(5);
  @$pb.TagNumber(6)
  void clearBackupSilentHours() => $_clearField(6);

  /// The free space in GB (10^9 bytes) below which uploads pause, if less than min_free_disk_percent; 0 to 100000.
  @$pb.TagNumber(7)
  $core.int get minFreeDiskGb => $_getIZ(6);
  @$pb.TagNumber(7)
  set minFreeDiskGb($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMinFreeDiskGb() => $_has(6);
  @$pb.TagNumber(7)
  void clearMinFreeDiskGb() => $_clearField(7);
}

/// Asks for the settings.
class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => GetSettingsRequest._();

  GetSettingsRequest._();

  factory GetSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsRequest()..mergeFromBuffer(data, registry);
  factory GetSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetSettingsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsRequest))
          as GetSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetSettingsRequest() / GetSettingsRequest.new instead')
  static GetSettingsRequest create() => GetSettingsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSettingsRequest._();
  @$core.override
  GetSettingsRequest createEmptyInstance() => GetSettingsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(
          GetSettingsRequest.$_createMessage);
  static GetSettingsRequest? _defaultInstance;
}

/// The settings.
class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    Settings? settings,
    $core.Iterable<$core.String>? pinned,
  }) {
    final result = GetSettingsResponse._();
    if (settings != null) result.settings = settings;
    if (pinned != null) result.pinned.addAll(pinned);
    return result;
  }

  GetSettingsResponse._();

  factory GetSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsResponse()..mergeFromBuffer(data, registry);
  factory GetSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetSettingsResponse.$_createMessage)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'pinned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSettingsResponse))
          as GetSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetSettingsResponse() / GetSettingsResponse.new instead')
  static GetSettingsResponse create() => GetSettingsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSettingsResponse._();
  @$core.override
  GetSettingsResponse createEmptyInstance() => GetSettingsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(
          GetSettingsResponse.$_createMessage);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);

  /// The fields the configuration file pins, such as `trash_retention_days`: read-only.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get pinned => $_getList(1);
}

/// The new settings, every field.
class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    Settings? settings,
  }) {
    final result = UpdateSettingsRequest._();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsRequest()..mergeFromBuffer(data, registry);
  factory UpdateSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: UpdateSettingsRequest.$_createMessage)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest copyWith(
          void Function(UpdateSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsRequest))
          as UpdateSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateSettingsRequest() / UpdateSettingsRequest.new instead')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateSettingsRequest._();
  @$core.override
  UpdateSettingsRequest createEmptyInstance() => UpdateSettingsRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(
          UpdateSettingsRequest.$_createMessage);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);
}

/// The settings as stored.
class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    Settings? settings,
  }) {
    final result = UpdateSettingsResponse._();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsResponse._();

  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsResponse()..mergeFromBuffer(data, registry);
  factory UpdateSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: UpdateSettingsResponse.$_createMessage)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse copyWith(
          void Function(UpdateSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsResponse))
          as UpdateSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateSettingsResponse() / UpdateSettingsResponse.new instead')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateSettingsResponse._();
  @$core.override
  UpdateSettingsResponse createEmptyInstance() => UpdateSettingsResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(
          UpdateSettingsResponse.$_createMessage);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);
}

/// A capability's switch as a level sees it.
class PolicySwitch extends $pb.GeneratedMessage {
  factory PolicySwitch({
    Capability? capability,
    $core.bool? enabled,
    PolicySource? source,
    $core.bool? set,
  }) {
    final result = PolicySwitch._();
    if (capability != null) result.capability = capability;
    if (enabled != null) result.enabled = enabled;
    if (source != null) result.source = source;
    if (set != null) result.set = set;
    return result;
  }

  PolicySwitch._();

  factory PolicySwitch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PolicySwitch()..mergeFromBuffer(data, registry);
  factory PolicySwitch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PolicySwitch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PolicySwitch',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: PolicySwitch.$_createMessage)
    ..aE<Capability>(1, _omitFieldNames ? '' : 'capability',
        enumValues: Capability.values)
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..aE<PolicySource>(3, _omitFieldNames ? '' : 'source',
        enumValues: PolicySource.values)
    ..aOB(4, _omitFieldNames ? '' : 'set')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicySwitch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicySwitch copyWith(void Function(PolicySwitch) updates) =>
      super.copyWith((message) => updates(message as PolicySwitch))
          as PolicySwitch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PolicySwitch() / PolicySwitch.new instead')
  static PolicySwitch create() => PolicySwitch._();
  static $pb.GeneratedMessage $_createMessage() => PolicySwitch._();
  @$core.override
  PolicySwitch createEmptyInstance() => PolicySwitch._();
  @$core.pragma('dart2js:noInline')
  static PolicySwitch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PolicySwitch>(
          PolicySwitch.$_createMessage);
  static PolicySwitch? _defaultInstance;

  @$pb.TagNumber(1)
  Capability get capability => $_getN(0);
  @$pb.TagNumber(1)
  set capability(Capability value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCapability() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapability() => $_clearField(1);

  /// The effective value.
  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  PolicySource get source => $_getN(2);
  @$pb.TagNumber(3)
  set source(PolicySource value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  /// What the level asked about sets itself; unset when it leaves the capability to the wider levels.
  @$pb.TagNumber(4)
  $core.bool get set => $_getBF(3);
  @$pb.TagNumber(4)
  set set($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSet() => $_has(3);
  @$pb.TagNumber(4)
  void clearSet() => $_clearField(4);
}

/// A level: a library's when `library_id` is set, else an account's when `user_id` is, else the server's. A library's
/// effective values are its owner's there, or those of the account `user_id` names; an unknown account or library is
/// not_found `user.not_found` or `library.not_found`.
class GetPolicyRequest extends $pb.GeneratedMessage {
  factory GetPolicyRequest({
    $core.String? userId,
    $core.String? libraryId,
  }) {
    final result = GetPolicyRequest._();
    if (userId != null) result.userId = userId;
    if (libraryId != null) result.libraryId = libraryId;
    return result;
  }

  GetPolicyRequest._();

  factory GetPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPolicyRequest()..mergeFromBuffer(data, registry);
  factory GetPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPolicyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPolicyRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetPolicyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'libraryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPolicyRequest copyWith(void Function(GetPolicyRequest) updates) =>
      super.copyWith((message) => updates(message as GetPolicyRequest))
          as GetPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetPolicyRequest() / GetPolicyRequest.new instead')
  static GetPolicyRequest create() => GetPolicyRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPolicyRequest._();
  @$core.override
  GetPolicyRequest createEmptyInstance() => GetPolicyRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPolicyRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPolicyRequest>(
          GetPolicyRequest.$_createMessage);
  static GetPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get libraryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set libraryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);
}

/// Every capability, in the order of `Capability`.
class GetPolicyResponse extends $pb.GeneratedMessage {
  factory GetPolicyResponse({
    $core.Iterable<PolicySwitch>? switches,
  }) {
    final result = GetPolicyResponse._();
    if (switches != null) result.switches.addAll(switches);
    return result;
  }

  GetPolicyResponse._();

  factory GetPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPolicyResponse()..mergeFromBuffer(data, registry);
  factory GetPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPolicyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPolicyResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetPolicyResponse.$_createMessage)
    ..pPM<PolicySwitch>(1, _omitFieldNames ? '' : 'switches',
        subBuilder: PolicySwitch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPolicyResponse copyWith(void Function(GetPolicyResponse) updates) =>
      super.copyWith((message) => updates(message as GetPolicyResponse))
          as GetPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetPolicyResponse() / GetPolicyResponse.new instead')
  static GetPolicyResponse create() => GetPolicyResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPolicyResponse._();
  @$core.override
  GetPolicyResponse createEmptyInstance() => GetPolicyResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPolicyResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPolicyResponse>(
          GetPolicyResponse.$_createMessage);
  static GetPolicyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PolicySwitch> get switches => $_getList(0);
}

/// One capability's switch at the level `user_id` and `library_id` name, as in GetPolicyRequest.
class UpdatePolicyRequest extends $pb.GeneratedMessage {
  factory UpdatePolicyRequest({
    $core.String? userId,
    $core.String? libraryId,
    Capability? capability,
    $core.bool? enabled,
  }) {
    final result = UpdatePolicyRequest._();
    if (userId != null) result.userId = userId;
    if (libraryId != null) result.libraryId = libraryId;
    if (capability != null) result.capability = capability;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  UpdatePolicyRequest._();

  factory UpdatePolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePolicyRequest()..mergeFromBuffer(data, registry);
  factory UpdatePolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePolicyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePolicyRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: UpdatePolicyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'libraryId')
    ..aE<Capability>(3, _omitFieldNames ? '' : 'capability',
        enumValues: Capability.values)
    ..aOB(4, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePolicyRequest copyWith(void Function(UpdatePolicyRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePolicyRequest))
          as UpdatePolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdatePolicyRequest() / UpdatePolicyRequest.new instead')
  static UpdatePolicyRequest create() => UpdatePolicyRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdatePolicyRequest._();
  @$core.override
  UpdatePolicyRequest createEmptyInstance() => UpdatePolicyRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdatePolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePolicyRequest>(
          UpdatePolicyRequest.$_createMessage);
  static UpdatePolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get libraryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set libraryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

  @$pb.TagNumber(3)
  Capability get capability => $_getN(2);
  @$pb.TagNumber(3)
  set capability(Capability value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCapability() => $_has(2);
  @$pb.TagNumber(3)
  void clearCapability() => $_clearField(3);

  /// Unset clears the level's own value.
  @$pb.TagNumber(4)
  $core.bool get enabled => $_getBF(3);
  @$pb.TagNumber(4)
  set enabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnabled() => $_clearField(4);
}

/// The level's switches after the change.
class UpdatePolicyResponse extends $pb.GeneratedMessage {
  factory UpdatePolicyResponse({
    $core.Iterable<PolicySwitch>? switches,
  }) {
    final result = UpdatePolicyResponse._();
    if (switches != null) result.switches.addAll(switches);
    return result;
  }

  UpdatePolicyResponse._();

  factory UpdatePolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePolicyResponse()..mergeFromBuffer(data, registry);
  factory UpdatePolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePolicyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePolicyResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: UpdatePolicyResponse.$_createMessage)
    ..pPM<PolicySwitch>(1, _omitFieldNames ? '' : 'switches',
        subBuilder: PolicySwitch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePolicyResponse copyWith(void Function(UpdatePolicyResponse) updates) =>
      super.copyWith((message) => updates(message as UpdatePolicyResponse))
          as UpdatePolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePolicyResponse() / UpdatePolicyResponse.new instead')
  static UpdatePolicyResponse create() => UpdatePolicyResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdatePolicyResponse._();
  @$core.override
  UpdatePolicyResponse createEmptyInstance() => UpdatePolicyResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdatePolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePolicyResponse>(
          UpdatePolicyResponse.$_createMessage);
  static UpdatePolicyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PolicySwitch> get switches => $_getList(0);
}

/// The preset to apply.
class ApplyPresetRequest extends $pb.GeneratedMessage {
  factory ApplyPresetRequest({
    Preset? preset,
  }) {
    final result = ApplyPresetRequest._();
    if (preset != null) result.preset = preset;
    return result;
  }

  ApplyPresetRequest._();

  factory ApplyPresetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyPresetRequest()..mergeFromBuffer(data, registry);
  factory ApplyPresetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyPresetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyPresetRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ApplyPresetRequest.$_createMessage)
    ..aE<Preset>(1, _omitFieldNames ? '' : 'preset', enumValues: Preset.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyPresetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyPresetRequest copyWith(void Function(ApplyPresetRequest) updates) =>
      super.copyWith((message) => updates(message as ApplyPresetRequest))
          as ApplyPresetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ApplyPresetRequest() / ApplyPresetRequest.new instead')
  static ApplyPresetRequest create() => ApplyPresetRequest._();
  static $pb.GeneratedMessage $_createMessage() => ApplyPresetRequest._();
  @$core.override
  ApplyPresetRequest createEmptyInstance() => ApplyPresetRequest._();
  @$core.pragma('dart2js:noInline')
  static ApplyPresetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyPresetRequest>(
          ApplyPresetRequest.$_createMessage);
  static ApplyPresetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Preset get preset => $_getN(0);
  @$pb.TagNumber(1)
  set preset(Preset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPreset() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreset() => $_clearField(1);
}

/// The server's switches after the preset.
class ApplyPresetResponse extends $pb.GeneratedMessage {
  factory ApplyPresetResponse({
    $core.Iterable<PolicySwitch>? switches,
  }) {
    final result = ApplyPresetResponse._();
    if (switches != null) result.switches.addAll(switches);
    return result;
  }

  ApplyPresetResponse._();

  factory ApplyPresetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyPresetResponse()..mergeFromBuffer(data, registry);
  factory ApplyPresetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyPresetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyPresetResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ApplyPresetResponse.$_createMessage)
    ..pPM<PolicySwitch>(1, _omitFieldNames ? '' : 'switches',
        subBuilder: PolicySwitch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyPresetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyPresetResponse copyWith(void Function(ApplyPresetResponse) updates) =>
      super.copyWith((message) => updates(message as ApplyPresetResponse))
          as ApplyPresetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ApplyPresetResponse() / ApplyPresetResponse.new instead')
  static ApplyPresetResponse create() => ApplyPresetResponse._();
  static $pb.GeneratedMessage $_createMessage() => ApplyPresetResponse._();
  @$core.override
  ApplyPresetResponse createEmptyInstance() => ApplyPresetResponse._();
  @$core.pragma('dart2js:noInline')
  static ApplyPresetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyPresetResponse>(
          ApplyPresetResponse.$_createMessage);
  static ApplyPresetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PolicySwitch> get switches => $_getList(0);
}

/// Asks for the diagnostics.
class GetDiagnosticsRequest extends $pb.GeneratedMessage {
  factory GetDiagnosticsRequest() => GetDiagnosticsRequest._();

  GetDiagnosticsRequest._();

  factory GetDiagnosticsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsRequest()..mergeFromBuffer(data, registry);
  factory GetDiagnosticsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDiagnosticsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetDiagnosticsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsRequest copyWith(
          void Function(GetDiagnosticsRequest) updates) =>
      super.copyWith((message) => updates(message as GetDiagnosticsRequest))
          as GetDiagnosticsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDiagnosticsRequest() / GetDiagnosticsRequest.new instead')
  static GetDiagnosticsRequest create() => GetDiagnosticsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDiagnosticsRequest._();
  @$core.override
  GetDiagnosticsRequest createEmptyInstance() => GetDiagnosticsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDiagnosticsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDiagnosticsRequest>(
          GetDiagnosticsRequest.$_createMessage);
  static GetDiagnosticsRequest? _defaultInstance;
}

/// The doctor's checks and the bundle.
class GetDiagnosticsResponse extends $pb.GeneratedMessage {
  factory GetDiagnosticsResponse({
    $core.Iterable<Check>? checks,
    $core.String? bundleJson,
  }) {
    final result = GetDiagnosticsResponse._();
    if (checks != null) result.checks.addAll(checks);
    if (bundleJson != null) result.bundleJson = bundleJson;
    return result;
  }

  GetDiagnosticsResponse._();

  factory GetDiagnosticsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsResponse()..mergeFromBuffer(data, registry);
  factory GetDiagnosticsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDiagnosticsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: GetDiagnosticsResponse.$_createMessage)
    ..pPM<Check>(1, _omitFieldNames ? '' : 'checks',
        subBuilder: Check.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'bundleJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsResponse copyWith(
          void Function(GetDiagnosticsResponse) updates) =>
      super.copyWith((message) => updates(message as GetDiagnosticsResponse))
          as GetDiagnosticsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDiagnosticsResponse() / GetDiagnosticsResponse.new instead')
  static GetDiagnosticsResponse create() => GetDiagnosticsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDiagnosticsResponse._();
  @$core.override
  GetDiagnosticsResponse createEmptyInstance() => GetDiagnosticsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDiagnosticsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDiagnosticsResponse>(
          GetDiagnosticsResponse.$_createMessage);
  static GetDiagnosticsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Check> get checks => $_getList(0);

  /// Versions, the configuration's differences from the defaults (secrets hidden), the checks and the log tail, as
  /// JSON to attach to a bug report.
  @$pb.TagNumber(2)
  $core.String get bundleJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set bundleJson($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBundleJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearBundleJson() => $_clearField(2);
}

/// One check of `photolibd doctor`.
class Check extends $pb.GeneratedMessage {
  factory Check({
    $core.String? name,
    CheckStatus? status,
    $core.String? detail,
  }) {
    final result = Check._();
    if (name != null) result.name = name;
    if (status != null) result.status = status;
    if (detail != null) result.detail = detail;
    return result;
  }

  Check._();

  factory Check.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Check()..mergeFromBuffer(data, registry);
  factory Check.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Check()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Check',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: Check.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<CheckStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: CheckStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Check clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Check copyWith(void Function(Check) updates) =>
      super.copyWith((message) => updates(message as Check)) as Check;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Check() / Check.new instead')
  static Check create() => Check._();
  static $pb.GeneratedMessage $_createMessage() => Check._();
  @$core.override
  Check createEmptyInstance() => Check._();
  @$core.pragma('dart2js:noInline')
  static Check getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Check>(Check.$_createMessage);
  static Check? _defaultInstance;

  /// Such as `postgres` or `store b2`.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  CheckStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(CheckStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// What the check found, in English for the administrator.
  @$pb.TagNumber(3)
  $core.String get detail => $_getSZ(2);
  @$pb.TagNumber(3)
  set detail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetail() => $_clearField(3);
}

/// The external library to add.
class CreateExternalLibraryRequest extends $pb.GeneratedMessage {
  factory CreateExternalLibraryRequest({
    $core.String? ownerUserId,
    $core.String? name,
    $core.String? root,
    $core.int? filesPerSecond,
    $fixnum.Int64? bytesPerSecond,
  }) {
    final result = CreateExternalLibraryRequest._();
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (name != null) result.name = name;
    if (root != null) result.root = root;
    if (filesPerSecond != null) result.filesPerSecond = filesPerSecond;
    if (bytesPerSecond != null) result.bytesPerSecond = bytesPerSecond;
    return result;
  }

  CreateExternalLibraryRequest._();

  factory CreateExternalLibraryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExternalLibraryRequest()..mergeFromBuffer(data, registry);
  factory CreateExternalLibraryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExternalLibraryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateExternalLibraryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: CreateExternalLibraryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'ownerUserId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'root')
    ..aI(4, _omitFieldNames ? '' : 'filesPerSecond',
        fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'bytesPerSecond', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExternalLibraryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExternalLibraryRequest copyWith(
          void Function(CreateExternalLibraryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CreateExternalLibraryRequest))
          as CreateExternalLibraryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateExternalLibraryRequest() / CreateExternalLibraryRequest.new instead')
  static CreateExternalLibraryRequest create() =>
      CreateExternalLibraryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateExternalLibraryRequest._();
  @$core.override
  CreateExternalLibraryRequest createEmptyInstance() =>
      CreateExternalLibraryRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateExternalLibraryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateExternalLibraryRequest>(
          CreateExternalLibraryRequest.$_createMessage);
  static CreateExternalLibraryRequest? _defaultInstance;

  /// Whose library it is; not_found `user.not_found` when there is no such account.
  @$pb.TagNumber(1)
  $core.String get ownerUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ownerUserId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOwnerUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// An absolute path on the server, such as `/srv/photos/ann`.
  @$pb.TagNumber(3)
  $core.String get root => $_getSZ(2);
  @$pb.TagNumber(3)
  set root($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoot() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoot() => $_clearField(3);

  /// How many files the server may list or open in it per second, and how many bytes it may read whole (to render or
  /// hash them) per second, to spare a spinning disk or a NAS. Unset: 1000 files and 64 MiB; 0: no limit.
  @$pb.TagNumber(4)
  $core.int get filesPerSecond => $_getIZ(3);
  @$pb.TagNumber(4)
  set filesPerSecond($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFilesPerSecond() => $_has(3);
  @$pb.TagNumber(4)
  void clearFilesPerSecond() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get bytesPerSecond => $_getI64(4);
  @$pb.TagNumber(5)
  set bytesPerSecond($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBytesPerSecond() => $_has(4);
  @$pb.TagNumber(5)
  void clearBytesPerSecond() => $_clearField(5);
}

/// The new library, scanning.
class CreateExternalLibraryResponse extends $pb.GeneratedMessage {
  factory CreateExternalLibraryResponse({
    $core.String? libraryId,
  }) {
    final result = CreateExternalLibraryResponse._();
    if (libraryId != null) result.libraryId = libraryId;
    return result;
  }

  CreateExternalLibraryResponse._();

  factory CreateExternalLibraryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExternalLibraryResponse()..mergeFromBuffer(data, registry);
  factory CreateExternalLibraryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateExternalLibraryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateExternalLibraryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: CreateExternalLibraryResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'libraryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExternalLibraryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateExternalLibraryResponse copyWith(
          void Function(CreateExternalLibraryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateExternalLibraryResponse))
          as CreateExternalLibraryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateExternalLibraryResponse() / CreateExternalLibraryResponse.new instead')
  static CreateExternalLibraryResponse create() =>
      CreateExternalLibraryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateExternalLibraryResponse._();
  @$core.override
  CreateExternalLibraryResponse createEmptyInstance() =>
      CreateExternalLibraryResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateExternalLibraryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateExternalLibraryResponse>(
          CreateExternalLibraryResponse.$_createMessage);
  static CreateExternalLibraryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);
}

/// The library to scan.
class ScanLibraryRequest extends $pb.GeneratedMessage {
  factory ScanLibraryRequest({
    $core.String? libraryId,
  }) {
    final result = ScanLibraryRequest._();
    if (libraryId != null) result.libraryId = libraryId;
    return result;
  }

  ScanLibraryRequest._();

  factory ScanLibraryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLibraryRequest()..mergeFromBuffer(data, registry);
  factory ScanLibraryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLibraryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanLibraryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ScanLibraryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'libraryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLibraryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLibraryRequest copyWith(void Function(ScanLibraryRequest) updates) =>
      super.copyWith((message) => updates(message as ScanLibraryRequest))
          as ScanLibraryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ScanLibraryRequest() / ScanLibraryRequest.new instead')
  static ScanLibraryRequest create() => ScanLibraryRequest._();
  static $pb.GeneratedMessage $_createMessage() => ScanLibraryRequest._();
  @$core.override
  ScanLibraryRequest createEmptyInstance() => ScanLibraryRequest._();
  @$core.pragma('dart2js:noInline')
  static ScanLibraryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanLibraryRequest>(
          ScanLibraryRequest.$_createMessage);
  static ScanLibraryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);
}

/// No such library is not_found `library.not_found`; a managed one is failed_precondition `library.not_external`, and
/// one being scanned `library.scanning`.
class ScanLibraryResponse extends $pb.GeneratedMessage {
  factory ScanLibraryResponse() => ScanLibraryResponse._();

  ScanLibraryResponse._();

  factory ScanLibraryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLibraryResponse()..mergeFromBuffer(data, registry);
  factory ScanLibraryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLibraryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanLibraryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ScanLibraryResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLibraryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLibraryResponse copyWith(void Function(ScanLibraryResponse) updates) =>
      super.copyWith((message) => updates(message as ScanLibraryResponse))
          as ScanLibraryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ScanLibraryResponse() / ScanLibraryResponse.new instead')
  static ScanLibraryResponse create() => ScanLibraryResponse._();
  static $pb.GeneratedMessage $_createMessage() => ScanLibraryResponse._();
  @$core.override
  ScanLibraryResponse createEmptyInstance() => ScanLibraryResponse._();
  @$core.pragma('dart2js:noInline')
  static ScanLibraryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanLibraryResponse>(
          ScanLibraryResponse.$_createMessage);
  static ScanLibraryResponse? _defaultInstance;
}

/// Asks for a backup.
class BackUpNowRequest extends $pb.GeneratedMessage {
  factory BackUpNowRequest() => BackUpNowRequest._();

  BackUpNowRequest._();

  factory BackUpNowRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackUpNowRequest()..mergeFromBuffer(data, registry);
  factory BackUpNowRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackUpNowRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackUpNowRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: BackUpNowRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackUpNowRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackUpNowRequest copyWith(void Function(BackUpNowRequest) updates) =>
      super.copyWith((message) => updates(message as BackUpNowRequest))
          as BackUpNowRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BackUpNowRequest() / BackUpNowRequest.new instead')
  static BackUpNowRequest create() => BackUpNowRequest._();
  static $pb.GeneratedMessage $_createMessage() => BackUpNowRequest._();
  @$core.override
  BackUpNowRequest createEmptyInstance() => BackUpNowRequest._();
  @$core.pragma('dart2js:noInline')
  static BackUpNowRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackUpNowRequest>(
          BackUpNowRequest.$_createMessage);
  static BackUpNowRequest? _defaultInstance;
}

/// The queued backup.
class BackUpNowResponse extends $pb.GeneratedMessage {
  factory BackUpNowResponse({
    $core.String? jobId,
  }) {
    final result = BackUpNowResponse._();
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  BackUpNowResponse._();

  factory BackUpNowResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackUpNowResponse()..mergeFromBuffer(data, registry);
  factory BackUpNowResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackUpNowResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackUpNowResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: BackUpNowResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackUpNowResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackUpNowResponse copyWith(void Function(BackUpNowResponse) updates) =>
      super.copyWith((message) => updates(message as BackUpNowResponse))
          as BackUpNowResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BackUpNowResponse() / BackUpNowResponse.new instead')
  static BackUpNowResponse create() => BackUpNowResponse._();
  static $pb.GeneratedMessage $_createMessage() => BackUpNowResponse._();
  @$core.override
  BackUpNowResponse createEmptyInstance() => BackUpNowResponse._();
  @$core.pragma('dart2js:noInline')
  static BackUpNowResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackUpNowResponse>(
          BackUpNowResponse.$_createMessage);
  static BackUpNowResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

/// The backup to restore.
class RestoreBackupRequest extends $pb.GeneratedMessage {
  factory RestoreBackupRequest({
    $core.String? store,
    $core.String? name,
  }) {
    final result = RestoreBackupRequest._();
    if (store != null) result.store = store;
    if (name != null) result.name = name;
    return result;
  }

  RestoreBackupRequest._();

  factory RestoreBackupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RestoreBackupRequest()..mergeFromBuffer(data, registry);
  factory RestoreBackupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RestoreBackupRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreBackupRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: RestoreBackupRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'store')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreBackupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreBackupRequest copyWith(void Function(RestoreBackupRequest) updates) =>
      super.copyWith((message) => updates(message as RestoreBackupRequest))
          as RestoreBackupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RestoreBackupRequest() / RestoreBackupRequest.new instead')
  static RestoreBackupRequest create() => RestoreBackupRequest._();
  static $pb.GeneratedMessage $_createMessage() => RestoreBackupRequest._();
  @$core.override
  RestoreBackupRequest createEmptyInstance() => RestoreBackupRequest._();
  @$core.pragma('dart2js:noInline')
  static RestoreBackupRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreBackupRequest>(
          RestoreBackupRequest.$_createMessage);
  static RestoreBackupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get store => $_getSZ(0);
  @$pb.TagNumber(1)
  set store($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStore() => $_has(0);
  @$pb.TagNumber(1)
  void clearStore() => $_clearField(1);

  /// Its key, as `Backup.name` gives it.
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

/// photolibd stops once it has answered.
class RestoreBackupResponse extends $pb.GeneratedMessage {
  factory RestoreBackupResponse() => RestoreBackupResponse._();

  RestoreBackupResponse._();

  factory RestoreBackupResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RestoreBackupResponse()..mergeFromBuffer(data, registry);
  factory RestoreBackupResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RestoreBackupResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreBackupResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: RestoreBackupResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreBackupResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreBackupResponse copyWith(
          void Function(RestoreBackupResponse) updates) =>
      super.copyWith((message) => updates(message as RestoreBackupResponse))
          as RestoreBackupResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RestoreBackupResponse() / RestoreBackupResponse.new instead')
  static RestoreBackupResponse create() => RestoreBackupResponse._();
  static $pb.GeneratedMessage $_createMessage() => RestoreBackupResponse._();
  @$core.override
  RestoreBackupResponse createEmptyInstance() => RestoreBackupResponse._();
  @$core.pragma('dart2js:noInline')
  static RestoreBackupResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreBackupResponse>(
          RestoreBackupResponse.$_createMessage);
  static RestoreBackupResponse? _defaultInstance;
}

/// The scan to confirm.
class ConfirmScanRequest extends $pb.GeneratedMessage {
  factory ConfirmScanRequest({
    $core.String? libraryId,
    $core.String? confirmationToken,
  }) {
    final result = ConfirmScanRequest._();
    if (libraryId != null) result.libraryId = libraryId;
    if (confirmationToken != null) result.confirmationToken = confirmationToken;
    return result;
  }

  ConfirmScanRequest._();

  factory ConfirmScanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmScanRequest()..mergeFromBuffer(data, registry);
  factory ConfirmScanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmScanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmScanRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ConfirmScanRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'libraryId')
    ..aOS(2, _omitFieldNames ? '' : 'confirmationToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmScanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmScanRequest copyWith(void Function(ConfirmScanRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmScanRequest))
          as ConfirmScanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ConfirmScanRequest() / ConfirmScanRequest.new instead')
  static ConfirmScanRequest create() => ConfirmScanRequest._();
  static $pb.GeneratedMessage $_createMessage() => ConfirmScanRequest._();
  @$core.override
  ConfirmScanRequest createEmptyInstance() => ConfirmScanRequest._();
  @$core.pragma('dart2js:noInline')
  static ConfirmScanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmScanRequest>(
          ConfirmScanRequest.$_createMessage);
  static ConfirmScanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);

  /// The token of LibraryStatus.held. Another is failed_precondition `confirmation.required`, with the count, total and
  /// token of what would be hidden now as parameters.
  @$pb.TagNumber(2)
  $core.String get confirmationToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set confirmationToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConfirmationToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfirmationToken() => $_clearField(2);
}

/// What was hidden. No such library is not_found `library.not_found`; one whose last scan holds nothing back is
/// failed_precondition `library.nothing_held`.
class ConfirmScanResponse extends $pb.GeneratedMessage {
  factory ConfirmScanResponse({
    $fixnum.Int64? hiddenCount,
  }) {
    final result = ConfirmScanResponse._();
    if (hiddenCount != null) result.hiddenCount = hiddenCount;
    return result;
  }

  ConfirmScanResponse._();

  factory ConfirmScanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmScanResponse()..mergeFromBuffer(data, registry);
  factory ConfirmScanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmScanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmScanResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: ConfirmScanResponse.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'hiddenCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmScanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmScanResponse copyWith(void Function(ConfirmScanResponse) updates) =>
      super.copyWith((message) => updates(message as ConfirmScanResponse))
          as ConfirmScanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ConfirmScanResponse() / ConfirmScanResponse.new instead')
  static ConfirmScanResponse create() => ConfirmScanResponse._();
  static $pb.GeneratedMessage $_createMessage() => ConfirmScanResponse._();
  @$core.override
  ConfirmScanResponse createEmptyInstance() => ConfirmScanResponse._();
  @$core.pragma('dart2js:noInline')
  static ConfirmScanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmScanResponse>(
          ConfirmScanResponse.$_createMessage);
  static ConfirmScanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get hiddenCount => $_getI64(0);
  @$pb.TagNumber(1)
  set hiddenCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHiddenCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearHiddenCount() => $_clearField(1);
}

/// The paths a sync tool wrote.
class HintPathsRequest extends $pb.GeneratedMessage {
  factory HintPathsRequest({
    $core.String? libraryId,
    $core.Iterable<$core.String>? paths,
  }) {
    final result = HintPathsRequest._();
    if (libraryId != null) result.libraryId = libraryId;
    if (paths != null) result.paths.addAll(paths);
    return result;
  }

  HintPathsRequest._();

  factory HintPathsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HintPathsRequest()..mergeFromBuffer(data, registry);
  factory HintPathsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HintPathsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HintPathsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: HintPathsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'libraryId')
    ..pPS(2, _omitFieldNames ? '' : 'paths')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HintPathsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HintPathsRequest copyWith(void Function(HintPathsRequest) updates) =>
      super.copyWith((message) => updates(message as HintPathsRequest))
          as HintPathsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HintPathsRequest() / HintPathsRequest.new instead')
  static HintPathsRequest create() => HintPathsRequest._();
  static $pb.GeneratedMessage $_createMessage() => HintPathsRequest._();
  @$core.override
  HintPathsRequest createEmptyInstance() => HintPathsRequest._();
  @$core.pragma('dart2js:noInline')
  static HintPathsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HintPathsRequest>(
          HintPathsRequest.$_createMessage);
  static HintPathsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);

  /// Files or folders, absolute under the library's root or relative to it; at most 1000, else invalid_argument
  /// `field.invalid` on `paths`, as is one outside the root.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get paths => $_getList(1);
}

/// The folders are queued. No such library is not_found `library.not_found`, a managed one failed_precondition
/// `library.not_external`.
class HintPathsResponse extends $pb.GeneratedMessage {
  factory HintPathsResponse() => HintPathsResponse._();

  HintPathsResponse._();

  factory HintPathsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HintPathsResponse()..mergeFromBuffer(data, registry);
  factory HintPathsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HintPathsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HintPathsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: HintPathsResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HintPathsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HintPathsResponse copyWith(void Function(HintPathsResponse) updates) =>
      super.copyWith((message) => updates(message as HintPathsResponse))
          as HintPathsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HintPathsResponse() / HintPathsResponse.new instead')
  static HintPathsResponse create() => HintPathsResponse._();
  static $pb.GeneratedMessage $_createMessage() => HintPathsResponse._();
  @$core.override
  HintPathsResponse createEmptyInstance() => HintPathsResponse._();
  @$core.pragma('dart2js:noInline')
  static HintPathsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HintPathsResponse>(
          HintPathsResponse.$_createMessage);
  static HintPathsResponse? _defaultInstance;
}

/// Where the library is now.
class RelocateLibraryRequest extends $pb.GeneratedMessage {
  factory RelocateLibraryRequest({
    $core.String? libraryId,
    $core.String? root,
  }) {
    final result = RelocateLibraryRequest._();
    if (libraryId != null) result.libraryId = libraryId;
    if (root != null) result.root = root;
    return result;
  }

  RelocateLibraryRequest._();

  factory RelocateLibraryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelocateLibraryRequest()..mergeFromBuffer(data, registry);
  factory RelocateLibraryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelocateLibraryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelocateLibraryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: RelocateLibraryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'libraryId')
    ..aOS(2, _omitFieldNames ? '' : 'root')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelocateLibraryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelocateLibraryRequest copyWith(
          void Function(RelocateLibraryRequest) updates) =>
      super.copyWith((message) => updates(message as RelocateLibraryRequest))
          as RelocateLibraryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RelocateLibraryRequest() / RelocateLibraryRequest.new instead')
  static RelocateLibraryRequest create() => RelocateLibraryRequest._();
  static $pb.GeneratedMessage $_createMessage() => RelocateLibraryRequest._();
  @$core.override
  RelocateLibraryRequest createEmptyInstance() => RelocateLibraryRequest._();
  @$core.pragma('dart2js:noInline')
  static RelocateLibraryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelocateLibraryRequest>(
          RelocateLibraryRequest.$_createMessage);
  static RelocateLibraryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);

  /// An absolute path on the server.
  @$pb.TagNumber(2)
  $core.String get root => $_getSZ(1);
  @$pb.TagNumber(2)
  set root($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoot() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoot() => $_clearField(2);
}

/// The library, scanning at its new root; while it scans already, failed_precondition `library.scanning`.
class RelocateLibraryResponse extends $pb.GeneratedMessage {
  factory RelocateLibraryResponse() => RelocateLibraryResponse._();

  RelocateLibraryResponse._();

  factory RelocateLibraryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelocateLibraryResponse()..mergeFromBuffer(data, registry);
  factory RelocateLibraryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelocateLibraryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelocateLibraryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: RelocateLibraryResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelocateLibraryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelocateLibraryResponse copyWith(
          void Function(RelocateLibraryResponse) updates) =>
      super.copyWith((message) => updates(message as RelocateLibraryResponse))
          as RelocateLibraryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RelocateLibraryResponse() / RelocateLibraryResponse.new instead')
  static RelocateLibraryResponse create() => RelocateLibraryResponse._();
  static $pb.GeneratedMessage $_createMessage() => RelocateLibraryResponse._();
  @$core.override
  RelocateLibraryResponse createEmptyInstance() => RelocateLibraryResponse._();
  @$core.pragma('dart2js:noInline')
  static RelocateLibraryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelocateLibraryResponse>(
          RelocateLibraryResponse.$_createMessage);
  static RelocateLibraryResponse? _defaultInstance;
}

/// Which library, and the quality its universal JPEG gets.
class SetRenditionQualityRequest extends $pb.GeneratedMessage {
  factory SetRenditionQualityRequest({
    $core.String? libraryId,
    $core.String? quality,
  }) {
    final result = SetRenditionQualityRequest._();
    if (libraryId != null) result.libraryId = libraryId;
    if (quality != null) result.quality = quality;
    return result;
  }

  SetRenditionQualityRequest._();

  factory SetRenditionQualityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetRenditionQualityRequest()..mergeFromBuffer(data, registry);
  factory SetRenditionQualityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetRenditionQualityRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetRenditionQualityRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: SetRenditionQualityRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'libraryId')
    ..aOS(2, _omitFieldNames ? '' : 'quality')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRenditionQualityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRenditionQualityRequest copyWith(
          void Function(SetRenditionQualityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetRenditionQualityRequest))
          as SetRenditionQualityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetRenditionQualityRequest() / SetRenditionQualityRequest.new instead')
  static SetRenditionQualityRequest create() => SetRenditionQualityRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetRenditionQualityRequest._();
  @$core.override
  SetRenditionQualityRequest createEmptyInstance() =>
      SetRenditionQualityRequest._();
  @$core.pragma('dart2js:noInline')
  static SetRenditionQualityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetRenditionQualityRequest>(
          SetRenditionQualityRequest.$_createMessage);
  static SetRenditionQualityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);

  /// `high` or `standard`.
  @$pb.TagNumber(2)
  $core.String get quality => $_getSZ(1);
  @$pb.TagNumber(2)
  set quality($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuality() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuality() => $_clearField(2);
}

/// The library's previews are rendered again.
class SetRenditionQualityResponse extends $pb.GeneratedMessage {
  factory SetRenditionQualityResponse() => SetRenditionQualityResponse._();

  SetRenditionQualityResponse._();

  factory SetRenditionQualityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetRenditionQualityResponse()..mergeFromBuffer(data, registry);
  factory SetRenditionQualityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetRenditionQualityResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetRenditionQualityResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.api.v1'),
      createEmptyInstance: SetRenditionQualityResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRenditionQualityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRenditionQualityResponse copyWith(
          void Function(SetRenditionQualityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetRenditionQualityResponse))
          as SetRenditionQualityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetRenditionQualityResponse() / SetRenditionQualityResponse.new instead')
  static SetRenditionQualityResponse create() =>
      SetRenditionQualityResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetRenditionQualityResponse._();
  @$core.override
  SetRenditionQualityResponse createEmptyInstance() =>
      SetRenditionQualityResponse._();
  @$core.pragma('dart2js:noInline')
  static SetRenditionQualityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetRenditionQualityResponse>(
          SetRenditionQualityResponse.$_createMessage);
  static SetRenditionQualityResponse? _defaultInstance;
}

/// Runs the server, for its administrators: the admin console (OPS-02). Changes are recorded in the audit log.
class AdminServiceApi {
  final $pb.RpcClient _client;

  AdminServiceApi(this._client);

  /// The server at a glance: usage per account and per file role, libraries, backups, jobs and pauses.
  $async.Future<GetStatusResponse> getStatus(
          $pb.ClientContext? ctx, GetStatusRequest request) =>
      _client.invoke<GetStatusResponse>(
          ctx, 'AdminService', 'GetStatus', request, GetStatusResponse());

  /// Checks every store now: reachable, marker, credentials and clock, free space where known.
  $async.Future<ListStoresResponse> listStores(
          $pb.ClientContext? ctx, ListStoresRequest request) =>
      _client.invoke<ListStoresResponse>(
          ctx, 'AdminService', 'ListStores', request, ListStoresResponse());

  /// Jobs, newest first.
  $async.Future<ListJobsResponse> listJobs(
          $pb.ClientContext? ctx, ListJobsRequest request) =>
      _client.invoke<ListJobsResponse>(
          ctx, 'AdminService', 'ListJobs', request, ListJobsResponse());

  /// Queues a dead or cancelled job again from its first attempt.
  $async.Future<RetryJobResponse> retryJob(
          $pb.ClientContext? ctx, RetryJobRequest request) =>
      _client.invoke<RetryJobResponse>(
          ctx, 'AdminService', 'RetryJob', request, RetryJobResponse());

  /// Cancels a queued or running job.
  $async.Future<CancelJobResponse> cancelJob(
          $pb.ClientContext? ctx, CancelJobRequest request) =>
      _client.invoke<CancelJobResponse>(
          ctx, 'AdminService', 'CancelJob', request, CancelJobResponse());

  /// Starts no job of a type until the pause ends by itself. Pausing a maintenance type (backup, purge, scrub)
  /// needs an administrator's session; an API key gets permission_denied with reason `job.maintenance`.
  $async.Future<PauseJobTypeResponse> pauseJobType(
          $pb.ClientContext? ctx, PauseJobTypeRequest request) =>
      _client.invoke<PauseJobTypeResponse>(
          ctx, 'AdminService', 'PauseJobType', request, PauseJobTypeResponse());

  /// Ends a pause now.
  $async.Future<ResumeJobTypeResponse> resumeJobType(
          $pb.ClientContext? ctx, ResumeJobTypeRequest request) =>
      _client.invoke<ResumeJobTypeResponse>(ctx, 'AdminService',
          'ResumeJobType', request, ResumeJobTypeResponse());

  /// Re-reads metadata, regenerates renditions or re-detects faces of the assets in a scope, and of no others.
  $async.Future<ReprocessResponse> reprocess(
          $pb.ClientContext? ctx, ReprocessRequest request) =>
      _client.invoke<ReprocessResponse>(
          ctx, 'AdminService', 'Reprocess', request, ReprocessResponse());

  /// The audit log, newest first.
  $async.Future<ListAuditEventsResponse> listAuditEvents(
          $pb.ClientContext? ctx, ListAuditEventsRequest request) =>
      _client.invoke<ListAuditEventsResponse>(ctx, 'AdminService',
          'ListAuditEvents', request, ListAuditEventsResponse());

  /// The newest lines this process logged.
  $async.Future<TailLogsResponse> tailLogs(
          $pb.ClientContext? ctx, TailLogsRequest request) =>
      _client.invoke<TailLogsResponse>(
          ctx, 'AdminService', 'TailLogs', request, TailLogsResponse());

  /// The instance's policies and defaults.
  $async.Future<GetSettingsResponse> getSettings(
          $pb.ClientContext? ctx, GetSettingsRequest request) =>
      _client.invoke<GetSettingsResponse>(
          ctx, 'AdminService', 'GetSettings', request, GetSettingsResponse());

  /// Replaces the settings; a value out of range is invalid_argument `field.invalid` naming the field, and a change to
  /// one the configuration file pins failed_precondition `setting.pinned` naming it as `field`.
  $async.Future<UpdateSettingsResponse> updateSettings(
          $pb.ClientContext? ctx, UpdateSettingsRequest request) =>
      _client.invoke<UpdateSettingsResponse>(ctx, 'AdminService',
          'UpdateSettings', request, UpdateSettingsResponse());

  /// The capability switches of the server, an account or a library, each with its effective value and where it comes
  /// from (R-MODE-5, ADR-0240).
  $async.Future<GetPolicyResponse> getPolicy(
          $pb.ClientContext? ctx, GetPolicyRequest request) =>
      _client.invoke<GetPolicyResponse>(
          ctx, 'AdminService', 'GetPolicy', request, GetPolicyResponse());

  /// Sets or clears one capability's switch at one level. One the configuration file pins is failed_precondition
  /// `setting.pinned` naming it as `field`.
  $async.Future<UpdatePolicyResponse> updatePolicy(
          $pb.ClientContext? ctx, UpdatePolicyRequest request) =>
      _client.invoke<UpdatePolicyResponse>(
          ctx, 'AdminService', 'UpdatePolicy', request, UpdatePolicyResponse());

  /// Sets the server's switch of every capability the configuration file does not pin as a preset says, and clears what
  /// accounts and libraries set of them; the switches stay editable.
  $async.Future<ApplyPresetResponse> applyPreset(
          $pb.ClientContext? ctx, ApplyPresetRequest request) =>
      _client.invoke<ApplyPresetResponse>(
          ctx, 'AdminService', 'ApplyPreset', request, ApplyPresetResponse());

  /// Runs `photolibd doctor` in the server, with the diagnostics bundle for a bug report (OPS-19).
  $async.Future<GetDiagnosticsResponse> getDiagnostics(
          $pb.ClientContext? ctx, GetDiagnosticsRequest request) =>
      _client.invoke<GetDiagnosticsResponse>(ctx, 'AdminService',
          'GetDiagnostics', request, GetDiagnosticsResponse());

  /// Gives a user a read-only external library of the files under a folder of the server, and starts scanning it. The
  /// folder must lie under one of the configured `external_roots`, else permission_denied `library.root_not_allowed`,
  /// and neither hold nor lie in another library or photolibd's own directories, else failed_precondition
  /// `library.root_overlaps`.
  $async.Future<CreateExternalLibraryResponse> createExternalLibrary(
          $pb.ClientContext? ctx, CreateExternalLibraryRequest request) =>
      _client.invoke<CreateExternalLibraryResponse>(ctx, 'AdminService',
          'CreateExternalLibrary', request, CreateExternalLibraryResponse());

  /// Scans an external library again now: new files are added, moved ones keep their assets and those it does not find
  /// turn missing, unless that is more than 1,000 assets or 5 % of the library, when the scan waits for ConfirmScan.
  $async.Future<ScanLibraryResponse> scanLibrary(
          $pb.ClientContext? ctx, ScanLibraryRequest request) =>
      _client.invoke<ScanLibraryResponse>(
          ctx, 'AdminService', 'ScanLibrary', request, ScanLibraryResponse());

  /// Queues a backup of the database now, into the store `placement.backups` names; its restore drill follows.
  $async.Future<BackUpNowResponse> backUpNow(
          $pb.ClientContext? ctx, BackUpNowRequest request) =>
      _client.invoke<BackUpNowResponse>(
          ctx, 'AdminService', 'BackUpNow', request, BackUpNowResponse());

  /// Stops photolibd, which replaces the database with a backup when it starts again: what changed since the backup is
  /// lost, and devices sync from scratch. A dump that is not there is not_found `backup.not_found`. Needs an
  /// administrator's session; an API key gets permission_denied with reason `backup.restore`.
  $async.Future<RestoreBackupResponse> restoreBackup(
          $pb.ClientContext? ctx, RestoreBackupRequest request) =>
      _client.invoke<RestoreBackupResponse>(ctx, 'AdminService',
          'RestoreBackup', request, RestoreBackupResponse());

  /// Hides what the last scan of an external library did not find, which it held back (LibraryStatus.held).
  $async.Future<ConfirmScanResponse> confirmScan(
          $pb.ClientContext? ctx, ConfirmScanRequest request) =>
      _client.invoke<ConfirmScanResponse>(
          ctx, 'AdminService', 'ConfirmScan', request, ConfirmScanResponse());

  /// Finds files a sync tool announces before other work (API-11): the folders that the paths name or lie in are
  /// listed for new files at once. Nothing is hidden: a scan does that.
  $async.Future<HintPathsResponse> hintPaths(
          $pb.ClientContext? ctx, HintPathsRequest request) =>
      _client.invoke<HintPathsResponse>(
          ctx, 'AdminService', 'HintPaths', request, HintPathsResponse());

  /// Moves an external library to another folder, such as its share mounted elsewhere, and scans it there: every asset
  /// keeps its id, albums, faces and edits, and nothing is read again. The folder must hold a name the library's root
  /// held, else failed_precondition `library.root_differs`; it is checked as CreateExternalLibrary checks a root.
  $async.Future<RelocateLibraryResponse> relocateLibrary(
          $pb.ClientContext? ctx, RelocateLibraryRequest request) =>
      _client.invoke<RelocateLibraryResponse>(ctx, 'AdminService',
          'RelocateLibrary', request, RelocateLibraryResponse());

  /// Sets how big the universal JPEG of a library's stills is (M2-49): `high` (the default) is as big as the original,
  /// `standard` is 2160 px for a small disk. The reconciler renders every preview of the library again. No such library
  /// is not_found `library.not_found`; any other quality is invalid_argument `field.invalid` on `quality`.
  $async.Future<SetRenditionQualityResponse> setRenditionQuality(
          $pb.ClientContext? ctx, SetRenditionQualityRequest request) =>
      _client.invoke<SetRenditionQualityResponse>(ctx, 'AdminService',
          'SetRenditionQuality', request, SetRenditionQualityResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
