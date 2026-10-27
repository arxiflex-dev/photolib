// This is a generated file - do not edit.
//
// Generated from photolib/api/v1/admin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'package:protobuf/well_known_types/google/protobuf/timestamp.pbjson.dart'
    as $0;

@$core.Deprecated('Use libraryKindDescriptor instead')
const LibraryKind$json = {
  '1': 'LibraryKind',
  '2': [
    {'1': 'LIBRARY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'LIBRARY_KIND_MANAGED', '2': 1},
    {'1': 'LIBRARY_KIND_EXTERNAL', '2': 2},
  ],
};

/// Descriptor for `LibraryKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List libraryKindDescriptor = $convert.base64Decode(
    'CgtMaWJyYXJ5S2luZBIcChhMSUJSQVJZX0tJTkRfVU5TUEVDSUZJRUQQABIYChRMSUJSQVJZX0'
    'tJTkRfTUFOQUdFRBABEhkKFUxJQlJBUllfS0lORF9FWFRFUk5BTBAC');

@$core.Deprecated('Use libraryStateDescriptor instead')
const LibraryState$json = {
  '1': 'LibraryState',
  '2': [
    {'1': 'LIBRARY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'LIBRARY_STATE_ONLINE', '2': 1},
    {'1': 'LIBRARY_STATE_OFFLINE', '2': 2},
    {'1': 'LIBRARY_STATE_SCANNING', '2': 3},
    {'1': 'LIBRARY_STATE_ERROR', '2': 4},
  ],
};

/// Descriptor for `LibraryState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List libraryStateDescriptor = $convert.base64Decode(
    'CgxMaWJyYXJ5U3RhdGUSHQoZTElCUkFSWV9TVEFURV9VTlNQRUNJRklFRBAAEhgKFExJQlJBUl'
    'lfU1RBVEVfT05MSU5FEAESGQoVTElCUkFSWV9TVEFURV9PRkZMSU5FEAISGgoWTElCUkFSWV9T'
    'VEFURV9TQ0FOTklORxADEhcKE0xJQlJBUllfU1RBVEVfRVJST1IQBA==');

@$core.Deprecated('Use findingKindDescriptor instead')
const FindingKind$json = {
  '1': 'FindingKind',
  '2': [
    {'1': 'FINDING_KIND_UNSPECIFIED', '2': 0},
    {'1': 'FINDING_KIND_CONTENT', '2': 1},
    {'1': 'FINDING_KIND_MISSING', '2': 2},
    {'1': 'FINDING_KIND_SIZE', '2': 3},
    {'1': 'FINDING_KIND_HASH', '2': 4},
    {'1': 'FINDING_KIND_ORPHAN', '2': 5},
  ],
};

/// Descriptor for `FindingKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List findingKindDescriptor = $convert.base64Decode(
    'CgtGaW5kaW5nS2luZBIcChhGSU5ESU5HX0tJTkRfVU5TUEVDSUZJRUQQABIYChRGSU5ESU5HX0'
    'tJTkRfQ09OVEVOVBABEhgKFEZJTkRJTkdfS0lORF9NSVNTSU5HEAISFQoRRklORElOR19LSU5E'
    'X1NJWkUQAxIVChFGSU5ESU5HX0tJTkRfSEFTSBAEEhcKE0ZJTkRJTkdfS0lORF9PUlBIQU4QBQ'
    '==');

@$core.Deprecated('Use jobStatusDescriptor instead')
const JobStatus$json = {
  '1': 'JobStatus',
  '2': [
    {'1': 'JOB_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'JOB_STATUS_QUEUED', '2': 1},
    {'1': 'JOB_STATUS_RUNNING', '2': 2},
    {'1': 'JOB_STATUS_DONE', '2': 3},
    {'1': 'JOB_STATUS_DEAD', '2': 4},
    {'1': 'JOB_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `JobStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List jobStatusDescriptor = $convert.base64Decode(
    'CglKb2JTdGF0dXMSGgoWSk9CX1NUQVRVU19VTlNQRUNJRklFRBAAEhUKEUpPQl9TVEFUVVNfUV'
    'VFVUVEEAESFgoSSk9CX1NUQVRVU19SVU5OSU5HEAISEwoPSk9CX1NUQVRVU19ET05FEAMSEwoP'
    'Sk9CX1NUQVRVU19ERUFEEAQSGAoUSk9CX1NUQVRVU19DQU5DRUxMRUQQBQ==');

@$core.Deprecated('Use checkStatusDescriptor instead')
const CheckStatus$json = {
  '1': 'CheckStatus',
  '2': [
    {'1': 'CHECK_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CHECK_STATUS_OK', '2': 1},
    {'1': 'CHECK_STATUS_WARN', '2': 2},
    {'1': 'CHECK_STATUS_FAIL', '2': 3},
  ],
};

/// Descriptor for `CheckStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List checkStatusDescriptor = $convert.base64Decode(
    'CgtDaGVja1N0YXR1cxIcChhDSEVDS19TVEFUVVNfVU5TUEVDSUZJRUQQABITCg9DSEVDS19TVE'
    'FUVVNfT0sQARIVChFDSEVDS19TVEFUVVNfV0FSThACEhUKEUNIRUNLX1NUQVRVU19GQUlMEAM=');

@$core.Deprecated('Use reprocessKindDescriptor instead')
const ReprocessKind$json = {
  '1': 'ReprocessKind',
  '2': [
    {'1': 'REPROCESS_KIND_UNSPECIFIED', '2': 0},
    {'1': 'REPROCESS_KIND_METADATA', '2': 1},
    {'1': 'REPROCESS_KIND_RENDITIONS', '2': 2},
    {'1': 'REPROCESS_KIND_FACES', '2': 3},
  ],
};

/// Descriptor for `ReprocessKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reprocessKindDescriptor = $convert.base64Decode(
    'Cg1SZXByb2Nlc3NLaW5kEh4KGlJFUFJPQ0VTU19LSU5EX1VOU1BFQ0lGSUVEEAASGwoXUkVQUk'
    '9DRVNTX0tJTkRfTUVUQURBVEEQARIdChlSRVBST0NFU1NfS0lORF9SRU5ESVRJT05TEAISGAoU'
    'UkVQUk9DRVNTX0tJTkRfRkFDRVMQAw==');

@$core.Deprecated('Use capabilityDescriptor instead')
const Capability$json = {
  '1': 'Capability',
  '2': [
    {'1': 'CAPABILITY_UNSPECIFIED', '2': 0},
    {'1': 'CAPABILITY_MANAGED_LIBRARIES', '2': 1},
    {'1': 'CAPABILITY_UPLOADS', '2': 2},
    {'1': 'CAPABILITY_FOLDER_BROWSER', '2': 3},
    {'1': 'CAPABILITY_DEVICE_FOLDERS', '2': 4},
    {'1': 'CAPABILITY_SHARING', '2': 5},
    {'1': 'CAPABILITY_EDITS', '2': 6},
    {'1': 'CAPABILITY_DELETES', '2': 7},
    {'1': 'CAPABILITY_XMP_WRITES', '2': 8},
    {'1': 'CAPABILITY_FACE_RECOGNITION', '2': 9},
    {'1': 'CAPABILITY_ML_SEARCH', '2': 10},
  ],
};

/// Descriptor for `Capability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List capabilityDescriptor = $convert.base64Decode(
    'CgpDYXBhYmlsaXR5EhoKFkNBUEFCSUxJVFlfVU5TUEVDSUZJRUQQABIgChxDQVBBQklMSVRZX0'
    '1BTkFHRURfTElCUkFSSUVTEAESFgoSQ0FQQUJJTElUWV9VUExPQURTEAISHQoZQ0FQQUJJTElU'
    'WV9GT0xERVJfQlJPV1NFUhADEh0KGUNBUEFCSUxJVFlfREVWSUNFX0ZPTERFUlMQBBIWChJDQV'
    'BBQklMSVRZX1NIQVJJTkcQBRIUChBDQVBBQklMSVRZX0VESVRTEAYSFgoSQ0FQQUJJTElUWV9E'
    'RUxFVEVTEAcSGQoVQ0FQQUJJTElUWV9YTVBfV1JJVEVTEAgSHwobQ0FQQUJJTElUWV9GQUNFX1'
    'JFQ09HTklUSU9OEAkSGAoUQ0FQQUJJTElUWV9NTF9TRUFSQ0gQCg==');

@$core.Deprecated('Use policySourceDescriptor instead')
const PolicySource$json = {
  '1': 'PolicySource',
  '2': [
    {'1': 'POLICY_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'POLICY_SOURCE_DEFAULT', '2': 1},
    {'1': 'POLICY_SOURCE_SERVER', '2': 2},
    {'1': 'POLICY_SOURCE_USER', '2': 3},
    {'1': 'POLICY_SOURCE_LIBRARY', '2': 4},
    {'1': 'POLICY_SOURCE_CONFIG', '2': 5},
  ],
};

/// Descriptor for `PolicySource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List policySourceDescriptor = $convert.base64Decode(
    'CgxQb2xpY3lTb3VyY2USHQoZUE9MSUNZX1NPVVJDRV9VTlNQRUNJRklFRBAAEhkKFVBPTElDWV'
    '9TT1VSQ0VfREVGQVVMVBABEhgKFFBPTElDWV9TT1VSQ0VfU0VSVkVSEAISFgoSUE9MSUNZX1NP'
    'VVJDRV9VU0VSEAMSGQoVUE9MSUNZX1NPVVJDRV9MSUJSQVJZEAQSGAoUUE9MSUNZX1NPVVJDRV'
    '9DT05GSUcQBQ==');

@$core.Deprecated('Use presetDescriptor instead')
const Preset$json = {
  '1': 'Preset',
  '2': [
    {'1': 'PRESET_UNSPECIFIED', '2': 0},
    {'1': 'PRESET_ARCHIVE_VIEWER', '2': 1},
    {'1': 'PRESET_FAMILY_BACKUP', '2': 2},
    {'1': 'PRESET_PERSONAL', '2': 3},
  ],
};

/// Descriptor for `Preset`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List presetDescriptor = $convert.base64Decode(
    'CgZQcmVzZXQSFgoSUFJFU0VUX1VOU1BFQ0lGSUVEEAASGQoVUFJFU0VUX0FSQ0hJVkVfVklFV0'
    'VSEAESGAoUUFJFU0VUX0ZBTUlMWV9CQUNLVVAQAhITCg9QUkVTRVRfUEVSU09OQUwQAw==');

@$core.Deprecated('Use getStatusRequestDescriptor instead')
const GetStatusRequest$json = {
  '1': 'GetStatusRequest',
};

/// Descriptor for `GetStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusRequestDescriptor =
    $convert.base64Decode('ChBHZXRTdGF0dXNSZXF1ZXN0');

@$core.Deprecated('Use getStatusResponseDescriptor instead')
const GetStatusResponse$json = {
  '1': 'GetStatusResponse',
  '2': [
    {
      '1': 'accounts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.AccountUsage',
      '10': 'accounts'
    },
    {
      '1': 'files',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.FileUsage',
      '10': 'files'
    },
    {
      '1': 'libraries',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.LibraryStatus',
      '10': 'libraries'
    },
    {
      '1': 'backups',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.Backup',
      '10': 'backups'
    },
    {
      '1': 'jobs',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.JobCount',
      '10': 'jobs'
    },
    {
      '1': 'pauses',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.JobPause',
      '10': 'pauses'
    },
    {
      '1': 'findings',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.IntegrityFinding',
      '10': 'findings'
    },
    {
      '1': 'scrubs',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.StoreScrub',
      '10': 'scrubs'
    },
    {
      '1': 'device_backups',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.DeviceBackup',
      '10': 'deviceBackups'
    },
    {
      '1': 'last_drill',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.BackupRun',
      '10': 'lastDrill'
    },
    {
      '1': 'last_verified_restore',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.BackupRun',
      '10': 'lastVerifiedRestore'
    },
    {
      '1': 'last_restore',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.BackupRun',
      '10': 'lastRestore'
    },
  ],
};

/// Descriptor for `GetStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusResponseDescriptor = $convert.base64Decode(
    'ChFHZXRTdGF0dXNSZXNwb25zZRI5CghhY2NvdW50cxgBIAMoCzIdLnBob3RvbGliLmFwaS52MS'
    '5BY2NvdW50VXNhZ2VSCGFjY291bnRzEjAKBWZpbGVzGAIgAygLMhoucGhvdG9saWIuYXBpLnYx'
    'LkZpbGVVc2FnZVIFZmlsZXMSPAoJbGlicmFyaWVzGAMgAygLMh4ucGhvdG9saWIuYXBpLnYxLk'
    'xpYnJhcnlTdGF0dXNSCWxpYnJhcmllcxIxCgdiYWNrdXBzGAQgAygLMhcucGhvdG9saWIuYXBp'
    'LnYxLkJhY2t1cFIHYmFja3VwcxItCgRqb2JzGAUgAygLMhkucGhvdG9saWIuYXBpLnYxLkpvYk'
    'NvdW50UgRqb2JzEjEKBnBhdXNlcxgGIAMoCzIZLnBob3RvbGliLmFwaS52MS5Kb2JQYXVzZVIG'
    'cGF1c2VzEj0KCGZpbmRpbmdzGAcgAygLMiEucGhvdG9saWIuYXBpLnYxLkludGVncml0eUZpbm'
    'RpbmdSCGZpbmRpbmdzEjMKBnNjcnVicxgIIAMoCzIbLnBob3RvbGliLmFwaS52MS5TdG9yZVNj'
    'cnViUgZzY3J1YnMSRAoOZGV2aWNlX2JhY2t1cHMYCSADKAsyHS5waG90b2xpYi5hcGkudjEuRG'
    'V2aWNlQmFja3VwUg1kZXZpY2VCYWNrdXBzEjkKCmxhc3RfZHJpbGwYCiABKAsyGi5waG90b2xp'
    'Yi5hcGkudjEuQmFja3VwUnVuUglsYXN0RHJpbGwSTgoVbGFzdF92ZXJpZmllZF9yZXN0b3JlGA'
    'sgASgLMhoucGhvdG9saWIuYXBpLnYxLkJhY2t1cFJ1blITbGFzdFZlcmlmaWVkUmVzdG9yZRI9'
    'CgxsYXN0X3Jlc3RvcmUYDCABKAsyGi5waG90b2xpYi5hcGkudjEuQmFja3VwUnVuUgtsYXN0Um'
    'VzdG9yZQ==');

@$core.Deprecated('Use accountUsageDescriptor instead')
const AccountUsage$json = {
  '1': 'AccountUsage',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'handle', '3': 2, '4': 1, '5': 9, '10': 'handle'},
    {'1': 'asset_count', '3': 3, '4': 1, '5': 3, '10': 'assetCount'},
    {'1': 'size_bytes', '3': 4, '4': 1, '5': 3, '10': 'sizeBytes'},
  ],
};

/// Descriptor for `AccountUsage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountUsageDescriptor = $convert.base64Decode(
    'CgxBY2NvdW50VXNhZ2USFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhYKBmhhbmRsZRgCIAEoCV'
    'IGaGFuZGxlEh8KC2Fzc2V0X2NvdW50GAMgASgDUgphc3NldENvdW50Eh0KCnNpemVfYnl0ZXMY'
    'BCABKANSCXNpemVCeXRlcw==');

@$core.Deprecated('Use fileUsageDescriptor instead')
const FileUsage$json = {
  '1': 'FileUsage',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    {'1': 'file_count', '3': 2, '4': 1, '5': 3, '10': 'fileCount'},
    {'1': 'size_bytes', '3': 3, '4': 1, '5': 3, '10': 'sizeBytes'},
  ],
};

/// Descriptor for `FileUsage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileUsageDescriptor = $convert.base64Decode(
    'CglGaWxlVXNhZ2USEgoEcm9sZRgBIAEoCVIEcm9sZRIdCgpmaWxlX2NvdW50GAIgASgDUglmaW'
    'xlQ291bnQSHQoKc2l6ZV9ieXRlcxgDIAEoA1IJc2l6ZUJ5dGVz');

@$core.Deprecated('Use libraryStatusDescriptor instead')
const LibraryStatus$json = {
  '1': 'LibraryStatus',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 9, '10': 'libraryId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'owner_handle', '3': 3, '4': 1, '5': 9, '10': 'ownerHandle'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.LibraryKind',
      '10': 'kind'
    },
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.LibraryState',
      '10': 'state'
    },
    {'1': 'asset_count', '3': 6, '4': 1, '5': 3, '10': 'assetCount'},
    {
      '1': 'held',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.Confirmation',
      '10': 'held'
    },
    {
      '1': 'polled_folder_count',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'polledFolderCount'
    },
  ],
};

/// Descriptor for `LibraryStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List libraryStatusDescriptor = $convert.base64Decode(
    'Cg1MaWJyYXJ5U3RhdHVzEh0KCmxpYnJhcnlfaWQYASABKAlSCWxpYnJhcnlJZBISCgRuYW1lGA'
    'IgASgJUgRuYW1lEiEKDG93bmVyX2hhbmRsZRgDIAEoCVILb3duZXJIYW5kbGUSMAoEa2luZBgE'
    'IAEoDjIcLnBob3RvbGliLmFwaS52MS5MaWJyYXJ5S2luZFIEa2luZBIzCgVzdGF0ZRgFIAEoDj'
    'IdLnBob3RvbGliLmFwaS52MS5MaWJyYXJ5U3RhdGVSBXN0YXRlEh8KC2Fzc2V0X2NvdW50GAYg'
    'ASgDUgphc3NldENvdW50EjEKBGhlbGQYByABKAsyHS5waG90b2xpYi5hcGkudjEuQ29uZmlybW'
    'F0aW9uUgRoZWxkEi4KE3BvbGxlZF9mb2xkZXJfY291bnQYCCABKANSEXBvbGxlZEZvbGRlckNv'
    'dW50');

@$core.Deprecated('Use confirmationDescriptor instead')
const Confirmation$json = {
  '1': 'Confirmation',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 3, '10': 'count'},
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
    {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `Confirmation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmationDescriptor = $convert.base64Decode(
    'CgxDb25maXJtYXRpb24SFAoFY291bnQYASABKANSBWNvdW50EhQKBXRvdGFsGAIgASgDUgV0b3'
    'RhbBIUCgV0b2tlbhgDIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use integrityFindingDescriptor instead')
const IntegrityFinding$json = {
  '1': 'IntegrityFinding',
  '2': [
    {'1': 'store', '3': 1, '4': 1, '5': 9, '10': 'store'},
    {'1': 'key', '3': 2, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.FindingKind',
      '10': 'kind'
    },
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'found_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'foundAt'
    },
    {'1': 'asset_id', '3': 6, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'file_name', '3': 7, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'owner_handle', '3': 8, '4': 1, '5': 9, '10': 'ownerHandle'},
  ],
};

/// Descriptor for `IntegrityFinding`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List integrityFindingDescriptor = $convert.base64Decode(
    'ChBJbnRlZ3JpdHlGaW5kaW5nEhQKBXN0b3JlGAEgASgJUgVzdG9yZRIQCgNrZXkYAiABKAlSA2'
    'tleRIwCgRraW5kGAMgASgOMhwucGhvdG9saWIuYXBpLnYxLkZpbmRpbmdLaW5kUgRraW5kEhYK'
    'BmRldGFpbBgEIAEoCVIGZGV0YWlsEjUKCGZvdW5kX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIHZm91bmRBdBIZCghhc3NldF9pZBgGIAEoCVIHYXNzZXRJZBIbCglmaWxl'
    'X25hbWUYByABKAlSCGZpbGVOYW1lEiEKDG93bmVyX2hhbmRsZRgIIAEoCVILb3duZXJIYW5kbG'
    'U=');

@$core.Deprecated('Use storeScrubDescriptor instead')
const StoreScrub$json = {
  '1': 'StoreScrub',
  '2': [
    {'1': 'store', '3': 1, '4': 1, '5': 9, '10': 'store'},
    {
      '1': 'cycle_ended_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'cycleEndedAt'
    },
  ],
};

/// Descriptor for `StoreScrub`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeScrubDescriptor = $convert.base64Decode(
    'CgpTdG9yZVNjcnViEhQKBXN0b3JlGAEgASgJUgVzdG9yZRJACg5jeWNsZV9lbmRlZF9hdBgCIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGN5Y2xlRW5kZWRBdA==');

@$core.Deprecated('Use deviceBackupDescriptor instead')
const DeviceBackup$json = {
  '1': 'DeviceBackup',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'owner_handle', '3': 3, '4': 1, '5': 9, '10': 'ownerHandle'},
    {
      '1': 'last_seen_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSeenAt'
    },
    {
      '1': 'reported_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'pending_count', '3': 6, '4': 1, '5': 3, '10': 'pendingCount'},
    {'1': 'silent', '3': 7, '4': 1, '5': 8, '10': 'silent'},
  ],
};

/// Descriptor for `DeviceBackup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceBackupDescriptor = $convert.base64Decode(
    'CgxEZXZpY2VCYWNrdXASGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBISCgRuYW1lGAIgAS'
    'gJUgRuYW1lEiEKDG93bmVyX2hhbmRsZRgDIAEoCVILb3duZXJIYW5kbGUSPAoMbGFzdF9zZWVu'
    'X2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKbGFzdFNlZW5BdBI7CgtyZX'
    'BvcnRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlcG9ydGVkQXQS'
    'IwoNcGVuZGluZ19jb3VudBgGIAEoA1IMcGVuZGluZ0NvdW50EhYKBnNpbGVudBgHIAEoCFIGc2'
    'lsZW50');

@$core.Deprecated('Use backupDescriptor instead')
const Backup$json = {
  '1': 'Backup',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size_bytes', '3': 2, '4': 1, '5': 3, '10': 'sizeBytes'},
    {
      '1': 'created_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'store', '3': 4, '4': 1, '5': 9, '10': 'store'},
  ],
};

/// Descriptor for `Backup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupDescriptor = $convert.base64Decode(
    'CgZCYWNrdXASEgoEbmFtZRgBIAEoCVIEbmFtZRIdCgpzaXplX2J5dGVzGAIgASgDUglzaXplQn'
    'l0ZXMSOQoKY3JlYXRlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNy'
    'ZWF0ZWRBdBIUCgVzdG9yZRgEIAEoCVIFc3RvcmU=');

@$core.Deprecated('Use backupRunDescriptor instead')
const BackupRun$json = {
  '1': 'BackupRun',
  '2': [
    {'1': 'store', '3': 1, '4': 1, '5': 9, '10': 'store'},
    {'1': 'dump', '3': 2, '4': 1, '5': 9, '10': 'dump'},
    {'1': 'ok', '3': 3, '4': 1, '5': 8, '10': 'ok'},
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'finished_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'finishedAt'
    },
  ],
};

/// Descriptor for `BackupRun`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupRunDescriptor = $convert.base64Decode(
    'CglCYWNrdXBSdW4SFAoFc3RvcmUYASABKAlSBXN0b3JlEhIKBGR1bXAYAiABKAlSBGR1bXASDg'
    'oCb2sYAyABKAhSAm9rEhYKBmRldGFpbBgEIAEoCVIGZGV0YWlsEjsKC2ZpbmlzaGVkX2F0GAUg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKZmluaXNoZWRBdA==');

@$core.Deprecated('Use jobCountDescriptor instead')
const JobCount$json = {
  '1': 'JobCount',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.JobStatus',
      '10': 'status'
    },
    {'1': 'count', '3': 3, '4': 1, '5': 3, '10': 'count'},
  ],
};

/// Descriptor for `JobCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobCountDescriptor = $convert.base64Decode(
    'CghKb2JDb3VudBISCgR0eXBlGAEgASgJUgR0eXBlEjIKBnN0YXR1cxgCIAEoDjIaLnBob3RvbG'
    'liLmFwaS52MS5Kb2JTdGF0dXNSBnN0YXR1cxIUCgVjb3VudBgDIAEoA1IFY291bnQ=');

@$core.Deprecated('Use jobPauseDescriptor instead')
const JobPause$json = {
  '1': 'JobPause',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {
      '1': 'until_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'untilAt'
    },
    {'1': 'paused_by_user_id', '3': 3, '4': 1, '5': 9, '10': 'pausedByUserId'},
  ],
};

/// Descriptor for `JobPause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobPauseDescriptor = $convert.base64Decode(
    'CghKb2JQYXVzZRISCgR0eXBlGAEgASgJUgR0eXBlEjUKCHVudGlsX2F0GAIgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIHdW50aWxBdBIpChFwYXVzZWRfYnlfdXNlcl9pZBgDIAEo'
    'CVIOcGF1c2VkQnlVc2VySWQ=');

@$core.Deprecated('Use listStoresRequestDescriptor instead')
const ListStoresRequest$json = {
  '1': 'ListStoresRequest',
};

/// Descriptor for `ListStoresRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStoresRequestDescriptor =
    $convert.base64Decode('ChFMaXN0U3RvcmVzUmVxdWVzdA==');

@$core.Deprecated('Use listStoresResponseDescriptor instead')
const ListStoresResponse$json = {
  '1': 'ListStoresResponse',
  '2': [
    {
      '1': 'stores',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.StoreStatus',
      '10': 'stores'
    },
  ],
};

/// Descriptor for `ListStoresResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStoresResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0U3RvcmVzUmVzcG9uc2USNAoGc3RvcmVzGAEgAygLMhwucGhvdG9saWIuYXBpLnYxLl'
    'N0b3JlU3RhdHVzUgZzdG9yZXM=');

@$core.Deprecated('Use storeStatusDescriptor instead')
const StoreStatus$json = {
  '1': 'StoreStatus',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.CheckStatus',
      '10': 'status'
    },
    {'1': 'detail', '3': 3, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'free_bytes',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'freeBytes',
      '17': true
    },
  ],
  '8': [
    {'1': '_free_bytes'},
  ],
};

/// Descriptor for `StoreStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeStatusDescriptor = $convert.base64Decode(
    'CgtTdG9yZVN0YXR1cxISCgRuYW1lGAEgASgJUgRuYW1lEjQKBnN0YXR1cxgCIAEoDjIcLnBob3'
    'RvbGliLmFwaS52MS5DaGVja1N0YXR1c1IGc3RhdHVzEhYKBmRldGFpbBgDIAEoCVIGZGV0YWls'
    'EiIKCmZyZWVfYnl0ZXMYBCABKANIAFIJZnJlZUJ5dGVziAEBQg0KC19mcmVlX2J5dGVz');

@$core.Deprecated('Use listJobsRequestDescriptor instead')
const ListJobsRequest$json = {
  '1': 'ListJobsRequest',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.JobStatus',
      '10': 'status'
    },
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListJobsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0Sm9ic1JlcXVlc3QSMgoGc3RhdHVzGAEgASgOMhoucGhvdG9saWIuYXBpLnYxLkpvYl'
    'N0YXR1c1IGc3RhdHVzEhIKBHR5cGUYAiABKAlSBHR5cGUSGwoJcGFnZV9zaXplGAMgASgFUghw'
    'YWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAQgASgJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use listJobsResponseDescriptor instead')
const ListJobsResponse$json = {
  '1': 'ListJobsResponse',
  '2': [
    {
      '1': 'jobs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.Job',
      '10': 'jobs'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListJobsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listJobsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0Sm9ic1Jlc3BvbnNlEigKBGpvYnMYASADKAsyFC5waG90b2xpYi5hcGkudjEuSm9iUg'
    'Rqb2JzEiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVINbmV4dFBhZ2VUb2tlbg==');

@$core.Deprecated('Use jobDescriptor instead')
const Job$json = {
  '1': 'Job',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.JobStatus',
      '10': 'status'
    },
    {'1': 'attempts', '3': 4, '4': 1, '5': 5, '10': 'attempts'},
    {'1': 'error', '3': 5, '4': 1, '5': 9, '10': 'error'},
    {'1': 'progress_percent', '3': 6, '4': 1, '5': 13, '10': 'progressPercent'},
    {'1': 'key', '3': 7, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'run_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'runAt'
    },
  ],
};

/// Descriptor for `Job`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobDescriptor = $convert.base64Decode(
    'CgNKb2ISFQoGam9iX2lkGAEgASgJUgVqb2JJZBISCgR0eXBlGAIgASgJUgR0eXBlEjIKBnN0YX'
    'R1cxgDIAEoDjIaLnBob3RvbGliLmFwaS52MS5Kb2JTdGF0dXNSBnN0YXR1cxIaCghhdHRlbXB0'
    'cxgEIAEoBVIIYXR0ZW1wdHMSFAoFZXJyb3IYBSABKAlSBWVycm9yEikKEHByb2dyZXNzX3Blcm'
    'NlbnQYBiABKA1SD3Byb2dyZXNzUGVyY2VudBIQCgNrZXkYByABKAlSA2tleRI5CgpjcmVhdGVk'
    'X2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjEKBnJ1bl'
    '9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBXJ1bkF0');

@$core.Deprecated('Use retryJobRequestDescriptor instead')
const RetryJobRequest$json = {
  '1': 'RetryJobRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `RetryJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryJobRequestDescriptor = $convert
    .base64Decode('Cg9SZXRyeUpvYlJlcXVlc3QSFQoGam9iX2lkGAEgASgJUgVqb2JJZA==');

@$core.Deprecated('Use retryJobResponseDescriptor instead')
const RetryJobResponse$json = {
  '1': 'RetryJobResponse',
};

/// Descriptor for `RetryJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryJobResponseDescriptor =
    $convert.base64Decode('ChBSZXRyeUpvYlJlc3BvbnNl');

@$core.Deprecated('Use cancelJobRequestDescriptor instead')
const CancelJobRequest$json = {
  '1': 'CancelJobRequest',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `CancelJobRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelJobRequestDescriptor = $convert
    .base64Decode('ChBDYW5jZWxKb2JSZXF1ZXN0EhUKBmpvYl9pZBgBIAEoCVIFam9iSWQ=');

@$core.Deprecated('Use cancelJobResponseDescriptor instead')
const CancelJobResponse$json = {
  '1': 'CancelJobResponse',
};

/// Descriptor for `CancelJobResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelJobResponseDescriptor =
    $convert.base64Decode('ChFDYW5jZWxKb2JSZXNwb25zZQ==');

@$core.Deprecated('Use pauseJobTypeRequestDescriptor instead')
const PauseJobTypeRequest$json = {
  '1': 'PauseJobTypeRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'pause_minutes', '3': 2, '4': 1, '5': 13, '10': 'pauseMinutes'},
  ],
};

/// Descriptor for `PauseJobTypeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseJobTypeRequestDescriptor = $convert.base64Decode(
    'ChNQYXVzZUpvYlR5cGVSZXF1ZXN0EhIKBHR5cGUYASABKAlSBHR5cGUSIwoNcGF1c2VfbWludX'
    'RlcxgCIAEoDVIMcGF1c2VNaW51dGVz');

@$core.Deprecated('Use pauseJobTypeResponseDescriptor instead')
const PauseJobTypeResponse$json = {
  '1': 'PauseJobTypeResponse',
  '2': [
    {
      '1': 'pause',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.JobPause',
      '10': 'pause'
    },
  ],
};

/// Descriptor for `PauseJobTypeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseJobTypeResponseDescriptor = $convert.base64Decode(
    'ChRQYXVzZUpvYlR5cGVSZXNwb25zZRIvCgVwYXVzZRgBIAEoCzIZLnBob3RvbGliLmFwaS52MS'
    '5Kb2JQYXVzZVIFcGF1c2U=');

@$core.Deprecated('Use resumeJobTypeRequestDescriptor instead')
const ResumeJobTypeRequest$json = {
  '1': 'ResumeJobTypeRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `ResumeJobTypeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeJobTypeRequestDescriptor = $convert
    .base64Decode('ChRSZXN1bWVKb2JUeXBlUmVxdWVzdBISCgR0eXBlGAEgASgJUgR0eXBl');

@$core.Deprecated('Use resumeJobTypeResponseDescriptor instead')
const ResumeJobTypeResponse$json = {
  '1': 'ResumeJobTypeResponse',
};

/// Descriptor for `ResumeJobTypeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeJobTypeResponseDescriptor =
    $convert.base64Decode('ChVSZXN1bWVKb2JUeXBlUmVzcG9uc2U=');

@$core.Deprecated('Use reprocessRequestDescriptor instead')
const ReprocessRequest$json = {
  '1': 'ReprocessRequest',
  '2': [
    {'1': 'asset_ids', '3': 1, '4': 3, '5': 9, '10': 'assetIds'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 9, '10': 'libraryId'},
    {'1': 'folder', '3': 3, '4': 1, '5': 9, '10': 'folder'},
    {
      '1': 'kinds',
      '3': 4,
      '4': 3,
      '5': 14,
      '6': '.photolib.api.v1.ReprocessKind',
      '10': 'kinds'
    },
  ],
};

/// Descriptor for `ReprocessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reprocessRequestDescriptor = $convert.base64Decode(
    'ChBSZXByb2Nlc3NSZXF1ZXN0EhsKCWFzc2V0X2lkcxgBIAMoCVIIYXNzZXRJZHMSHQoKbGlicm'
    'FyeV9pZBgCIAEoCVIJbGlicmFyeUlkEhYKBmZvbGRlchgDIAEoCVIGZm9sZGVyEjQKBWtpbmRz'
    'GAQgAygOMh4ucGhvdG9saWIuYXBpLnYxLlJlcHJvY2Vzc0tpbmRSBWtpbmRz');

@$core.Deprecated('Use reprocessResponseDescriptor instead')
const ReprocessResponse$json = {
  '1': 'ReprocessResponse',
  '2': [
    {'1': 'job_count', '3': 1, '4': 1, '5': 3, '10': 'jobCount'},
  ],
};

/// Descriptor for `ReprocessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reprocessResponseDescriptor = $convert.base64Decode(
    'ChFSZXByb2Nlc3NSZXNwb25zZRIbCglqb2JfY291bnQYASABKANSCGpvYkNvdW50');

@$core.Deprecated('Use listAuditEventsRequestDescriptor instead')
const ListAuditEventsRequest$json = {
  '1': 'ListAuditEventsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListAuditEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuditEventsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0QXVkaXRFdmVudHNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemUSHQ'
        'oKcGFnZV90b2tlbhgCIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use listAuditEventsResponseDescriptor instead')
const ListAuditEventsResponse$json = {
  '1': 'ListAuditEventsResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.AuditEvent',
      '10': 'events'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListAuditEventsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuditEventsResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0QXVkaXRFdmVudHNSZXNwb25zZRIzCgZldmVudHMYASADKAsyGy5waG90b2xpYi5hcG'
    'kudjEuQXVkaXRFdmVudFIGZXZlbnRzEiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVINbmV4dFBh'
    'Z2VUb2tlbg==');

@$core.Deprecated('Use auditEventDescriptor instead')
const AuditEvent$json = {
  '1': 'AuditEvent',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 3, '10': 'sequence'},
    {
      '1': 'recorded_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'actor_user_id', '3': 3, '4': 1, '5': 9, '10': 'actorUserId'},
    {'1': 'action', '3': 4, '4': 1, '5': 9, '10': 'action'},
    {'1': 'target_json', '3': 5, '4': 1, '5': 9, '10': 'targetJson'},
    {'1': 'details_json', '3': 6, '4': 1, '5': 9, '10': 'detailsJson'},
  ],
};

/// Descriptor for `AuditEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List auditEventDescriptor = $convert.base64Decode(
    'CgpBdWRpdEV2ZW50EhoKCHNlcXVlbmNlGAEgASgDUghzZXF1ZW5jZRI7CgtyZWNvcmRlZF9hdB'
    'gCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSIgoNYWN0b3Jf'
    'dXNlcl9pZBgDIAEoCVILYWN0b3JVc2VySWQSFgoGYWN0aW9uGAQgASgJUgZhY3Rpb24SHwoLdG'
    'FyZ2V0X2pzb24YBSABKAlSCnRhcmdldEpzb24SIQoMZGV0YWlsc19qc29uGAYgASgJUgtkZXRh'
    'aWxzSnNvbg==');

@$core.Deprecated('Use tailLogsRequestDescriptor instead')
const TailLogsRequest$json = {
  '1': 'TailLogsRequest',
  '2': [
    {'1': 'line_count', '3': 1, '4': 1, '5': 13, '10': 'lineCount'},
  ],
};

/// Descriptor for `TailLogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tailLogsRequestDescriptor = $convert.base64Decode(
    'Cg9UYWlsTG9nc1JlcXVlc3QSHQoKbGluZV9jb3VudBgBIAEoDVIJbGluZUNvdW50');

@$core.Deprecated('Use tailLogsResponseDescriptor instead')
const TailLogsResponse$json = {
  '1': 'TailLogsResponse',
  '2': [
    {'1': 'lines', '3': 1, '4': 3, '5': 9, '10': 'lines'},
  ],
};

/// Descriptor for `TailLogsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tailLogsResponseDescriptor = $convert
    .base64Decode('ChBUYWlsTG9nc1Jlc3BvbnNlEhQKBWxpbmVzGAEgAygJUgVsaW5lcw==');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {
      '1': 'require_two_factor',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'requireTwoFactor'
    },
    {
      '1': 'face_recognition_default',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'faceRecognitionDefault'
    },
    {
      '1': 'trash_retention_days',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'trashRetentionDays'
    },
    {
      '1': 'min_free_disk_percent',
      '3': 4,
      '4': 1,
      '5': 13,
      '10': 'minFreeDiskPercent'
    },
    {'1': 'scrub_days', '3': 5, '4': 1, '5': 13, '10': 'scrubDays'},
    {
      '1': 'backup_silent_hours',
      '3': 6,
      '4': 1,
      '5': 13,
      '10': 'backupSilentHours'
    },
    {'1': 'min_free_disk_gb', '3': 7, '4': 1, '5': 13, '10': 'minFreeDiskGb'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxIsChJyZXF1aXJlX3R3b19mYWN0b3IYASABKAhSEHJlcXVpcmVUd29GYWN0b3'
    'ISOAoYZmFjZV9yZWNvZ25pdGlvbl9kZWZhdWx0GAIgASgIUhZmYWNlUmVjb2duaXRpb25EZWZh'
    'dWx0EjAKFHRyYXNoX3JldGVudGlvbl9kYXlzGAMgASgNUhJ0cmFzaFJldGVudGlvbkRheXMSMQ'
    'oVbWluX2ZyZWVfZGlza19wZXJjZW50GAQgASgNUhJtaW5GcmVlRGlza1BlcmNlbnQSHQoKc2Ny'
    'dWJfZGF5cxgFIAEoDVIJc2NydWJEYXlzEi4KE2JhY2t1cF9zaWxlbnRfaG91cnMYBiABKA1SEW'
    'JhY2t1cFNpbGVudEhvdXJzEicKEG1pbl9mcmVlX2Rpc2tfZ2IYByABKA1SDW1pbkZyZWVEaXNr'
    'R2I=');

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor =
    $convert.base64Decode('ChJHZXRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use getSettingsResponseDescriptor instead')
const GetSettingsResponse$json = {
  '1': 'GetSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.Settings',
      '10': 'settings'
    },
    {'1': 'pinned', '3': 2, '4': 3, '5': 9, '10': 'pinned'},
  ],
};

/// Descriptor for `GetSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTZXR0aW5nc1Jlc3BvbnNlEjUKCHNldHRpbmdzGAEgASgLMhkucGhvdG9saWIuYXBpLn'
    'YxLlNldHRpbmdzUghzZXR0aW5ncxIWCgZwaW5uZWQYAiADKAlSBnBpbm5lZA==');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSNQoIc2V0dGluZ3MYASABKAsyGS5waG90b2xpYi5hcG'
    'kudjEuU2V0dGluZ3NSCHNldHRpbmdz');

@$core.Deprecated('Use updateSettingsResponseDescriptor instead')
const UpdateSettingsResponse$json = {
  '1': 'UpdateSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.photolib.api.v1.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `UpdateSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVTZXR0aW5nc1Jlc3BvbnNlEjUKCHNldHRpbmdzGAEgASgLMhkucGhvdG9saWIuYX'
        'BpLnYxLlNldHRpbmdzUghzZXR0aW5ncw==');

@$core.Deprecated('Use policySwitchDescriptor instead')
const PolicySwitch$json = {
  '1': 'PolicySwitch',
  '2': [
    {
      '1': 'capability',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.Capability',
      '10': 'capability'
    },
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'source',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.PolicySource',
      '10': 'source'
    },
    {'1': 'set', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'set', '17': true},
  ],
  '8': [
    {'1': '_set'},
  ],
};

/// Descriptor for `PolicySwitch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List policySwitchDescriptor = $convert.base64Decode(
    'CgxQb2xpY3lTd2l0Y2gSOwoKY2FwYWJpbGl0eRgBIAEoDjIbLnBob3RvbGliLmFwaS52MS5DYX'
    'BhYmlsaXR5UgpjYXBhYmlsaXR5EhgKB2VuYWJsZWQYAiABKAhSB2VuYWJsZWQSNQoGc291cmNl'
    'GAMgASgOMh0ucGhvdG9saWIuYXBpLnYxLlBvbGljeVNvdXJjZVIGc291cmNlEhUKA3NldBgEIA'
    'EoCEgAUgNzZXSIAQFCBgoEX3NldA==');

@$core.Deprecated('Use getPolicyRequestDescriptor instead')
const GetPolicyRequest$json = {
  '1': 'GetPolicyRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 9, '10': 'libraryId'},
  ],
};

/// Descriptor for `GetPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPolicyRequestDescriptor = $convert.base64Decode(
    'ChBHZXRQb2xpY3lSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpsaWJyYXJ5X2'
    'lkGAIgASgJUglsaWJyYXJ5SWQ=');

@$core.Deprecated('Use getPolicyResponseDescriptor instead')
const GetPolicyResponse$json = {
  '1': 'GetPolicyResponse',
  '2': [
    {
      '1': 'switches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.PolicySwitch',
      '10': 'switches'
    },
  ],
};

/// Descriptor for `GetPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPolicyResponseDescriptor = $convert.base64Decode(
    'ChFHZXRQb2xpY3lSZXNwb25zZRI5Cghzd2l0Y2hlcxgBIAMoCzIdLnBob3RvbGliLmFwaS52MS'
    '5Qb2xpY3lTd2l0Y2hSCHN3aXRjaGVz');

@$core.Deprecated('Use updatePolicyRequestDescriptor instead')
const UpdatePolicyRequest$json = {
  '1': 'UpdatePolicyRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 9, '10': 'libraryId'},
    {
      '1': 'capability',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.Capability',
      '10': 'capability'
    },
    {
      '1': 'enabled',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
  ],
  '8': [
    {'1': '_enabled'},
  ],
};

/// Descriptor for `UpdatePolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePolicyRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVQb2xpY3lSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpsaWJyYX'
    'J5X2lkGAIgASgJUglsaWJyYXJ5SWQSOwoKY2FwYWJpbGl0eRgDIAEoDjIbLnBob3RvbGliLmFw'
    'aS52MS5DYXBhYmlsaXR5UgpjYXBhYmlsaXR5Eh0KB2VuYWJsZWQYBCABKAhIAFIHZW5hYmxlZI'
    'gBAUIKCghfZW5hYmxlZA==');

@$core.Deprecated('Use updatePolicyResponseDescriptor instead')
const UpdatePolicyResponse$json = {
  '1': 'UpdatePolicyResponse',
  '2': [
    {
      '1': 'switches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.PolicySwitch',
      '10': 'switches'
    },
  ],
};

/// Descriptor for `UpdatePolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePolicyResponseDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQb2xpY3lSZXNwb25zZRI5Cghzd2l0Y2hlcxgBIAMoCzIdLnBob3RvbGliLmFwaS'
    '52MS5Qb2xpY3lTd2l0Y2hSCHN3aXRjaGVz');

@$core.Deprecated('Use applyPresetRequestDescriptor instead')
const ApplyPresetRequest$json = {
  '1': 'ApplyPresetRequest',
  '2': [
    {
      '1': 'preset',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.Preset',
      '10': 'preset'
    },
  ],
};

/// Descriptor for `ApplyPresetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyPresetRequestDescriptor = $convert.base64Decode(
    'ChJBcHBseVByZXNldFJlcXVlc3QSLwoGcHJlc2V0GAEgASgOMhcucGhvdG9saWIuYXBpLnYxLl'
    'ByZXNldFIGcHJlc2V0');

@$core.Deprecated('Use applyPresetResponseDescriptor instead')
const ApplyPresetResponse$json = {
  '1': 'ApplyPresetResponse',
  '2': [
    {
      '1': 'switches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.PolicySwitch',
      '10': 'switches'
    },
  ],
};

/// Descriptor for `ApplyPresetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyPresetResponseDescriptor = $convert.base64Decode(
    'ChNBcHBseVByZXNldFJlc3BvbnNlEjkKCHN3aXRjaGVzGAEgAygLMh0ucGhvdG9saWIuYXBpLn'
    'YxLlBvbGljeVN3aXRjaFIIc3dpdGNoZXM=');

@$core.Deprecated('Use getDiagnosticsRequestDescriptor instead')
const GetDiagnosticsRequest$json = {
  '1': 'GetDiagnosticsRequest',
};

/// Descriptor for `GetDiagnosticsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDiagnosticsRequestDescriptor =
    $convert.base64Decode('ChVHZXREaWFnbm9zdGljc1JlcXVlc3Q=');

@$core.Deprecated('Use getDiagnosticsResponseDescriptor instead')
const GetDiagnosticsResponse$json = {
  '1': 'GetDiagnosticsResponse',
  '2': [
    {
      '1': 'checks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.api.v1.Check',
      '10': 'checks'
    },
    {'1': 'bundle_json', '3': 2, '4': 1, '5': 9, '10': 'bundleJson'},
  ],
};

/// Descriptor for `GetDiagnosticsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDiagnosticsResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXREaWFnbm9zdGljc1Jlc3BvbnNlEi4KBmNoZWNrcxgBIAMoCzIWLnBob3RvbGliLmFwaS'
        '52MS5DaGVja1IGY2hlY2tzEh8KC2J1bmRsZV9qc29uGAIgASgJUgpidW5kbGVKc29u');

@$core.Deprecated('Use checkDescriptor instead')
const Check$json = {
  '1': 'Check',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.photolib.api.v1.CheckStatus',
      '10': 'status'
    },
    {'1': 'detail', '3': 3, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `Check`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkDescriptor = $convert.base64Decode(
    'CgVDaGVjaxISCgRuYW1lGAEgASgJUgRuYW1lEjQKBnN0YXR1cxgCIAEoDjIcLnBob3RvbGliLm'
    'FwaS52MS5DaGVja1N0YXR1c1IGc3RhdHVzEhYKBmRldGFpbBgDIAEoCVIGZGV0YWls');

@$core.Deprecated('Use createExternalLibraryRequestDescriptor instead')
const CreateExternalLibraryRequest$json = {
  '1': 'CreateExternalLibraryRequest',
  '2': [
    {'1': 'owner_user_id', '3': 1, '4': 1, '5': 9, '10': 'ownerUserId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'root', '3': 3, '4': 1, '5': 9, '10': 'root'},
    {
      '1': 'files_per_second',
      '3': 4,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'filesPerSecond',
      '17': true
    },
    {
      '1': 'bytes_per_second',
      '3': 5,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'bytesPerSecond',
      '17': true
    },
  ],
  '8': [
    {'1': '_files_per_second'},
    {'1': '_bytes_per_second'},
  ],
};

/// Descriptor for `CreateExternalLibraryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createExternalLibraryRequestDescriptor = $convert.base64Decode(
    'ChxDcmVhdGVFeHRlcm5hbExpYnJhcnlSZXF1ZXN0EiIKDW93bmVyX3VzZXJfaWQYASABKAlSC2'
    '93bmVyVXNlcklkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEcm9vdBgDIAEoCVIEcm9vdBItChBm'
    'aWxlc19wZXJfc2Vjb25kGAQgASgNSABSDmZpbGVzUGVyU2Vjb25kiAEBEi0KEGJ5dGVzX3Blcl'
    '9zZWNvbmQYBSABKARIAVIOYnl0ZXNQZXJTZWNvbmSIAQFCEwoRX2ZpbGVzX3Blcl9zZWNvbmRC'
    'EwoRX2J5dGVzX3Blcl9zZWNvbmQ=');

@$core.Deprecated('Use createExternalLibraryResponseDescriptor instead')
const CreateExternalLibraryResponse$json = {
  '1': 'CreateExternalLibraryResponse',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 9, '10': 'libraryId'},
  ],
};

/// Descriptor for `CreateExternalLibraryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createExternalLibraryResponseDescriptor =
    $convert.base64Decode(
        'Ch1DcmVhdGVFeHRlcm5hbExpYnJhcnlSZXNwb25zZRIdCgpsaWJyYXJ5X2lkGAEgASgJUglsaW'
        'JyYXJ5SWQ=');

@$core.Deprecated('Use scanLibraryRequestDescriptor instead')
const ScanLibraryRequest$json = {
  '1': 'ScanLibraryRequest',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 9, '10': 'libraryId'},
  ],
};

/// Descriptor for `ScanLibraryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanLibraryRequestDescriptor =
    $convert.base64Decode(
        'ChJTY2FuTGlicmFyeVJlcXVlc3QSHQoKbGlicmFyeV9pZBgBIAEoCVIJbGlicmFyeUlk');

@$core.Deprecated('Use scanLibraryResponseDescriptor instead')
const ScanLibraryResponse$json = {
  '1': 'ScanLibraryResponse',
};

/// Descriptor for `ScanLibraryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanLibraryResponseDescriptor =
    $convert.base64Decode('ChNTY2FuTGlicmFyeVJlc3BvbnNl');

@$core.Deprecated('Use backUpNowRequestDescriptor instead')
const BackUpNowRequest$json = {
  '1': 'BackUpNowRequest',
};

/// Descriptor for `BackUpNowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backUpNowRequestDescriptor =
    $convert.base64Decode('ChBCYWNrVXBOb3dSZXF1ZXN0');

@$core.Deprecated('Use backUpNowResponseDescriptor instead')
const BackUpNowResponse$json = {
  '1': 'BackUpNowResponse',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `BackUpNowResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backUpNowResponseDescriptor = $convert
    .base64Decode('ChFCYWNrVXBOb3dSZXNwb25zZRIVCgZqb2JfaWQYASABKAlSBWpvYklk');

@$core.Deprecated('Use restoreBackupRequestDescriptor instead')
const RestoreBackupRequest$json = {
  '1': 'RestoreBackupRequest',
  '2': [
    {'1': 'store', '3': 1, '4': 1, '5': 9, '10': 'store'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RestoreBackupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreBackupRequestDescriptor = $convert.base64Decode(
    'ChRSZXN0b3JlQmFja3VwUmVxdWVzdBIUCgVzdG9yZRgBIAEoCVIFc3RvcmUSEgoEbmFtZRgCIA'
    'EoCVIEbmFtZQ==');

@$core.Deprecated('Use restoreBackupResponseDescriptor instead')
const RestoreBackupResponse$json = {
  '1': 'RestoreBackupResponse',
};

/// Descriptor for `RestoreBackupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreBackupResponseDescriptor =
    $convert.base64Decode('ChVSZXN0b3JlQmFja3VwUmVzcG9uc2U=');

@$core.Deprecated('Use confirmScanRequestDescriptor instead')
const ConfirmScanRequest$json = {
  '1': 'ConfirmScanRequest',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 9, '10': 'libraryId'},
    {
      '1': 'confirmation_token',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'confirmationToken'
    },
  ],
};

/// Descriptor for `ConfirmScanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmScanRequestDescriptor = $convert.base64Decode(
    'ChJDb25maXJtU2NhblJlcXVlc3QSHQoKbGlicmFyeV9pZBgBIAEoCVIJbGlicmFyeUlkEi0KEm'
    'NvbmZpcm1hdGlvbl90b2tlbhgCIAEoCVIRY29uZmlybWF0aW9uVG9rZW4=');

@$core.Deprecated('Use confirmScanResponseDescriptor instead')
const ConfirmScanResponse$json = {
  '1': 'ConfirmScanResponse',
  '2': [
    {'1': 'hidden_count', '3': 1, '4': 1, '5': 3, '10': 'hiddenCount'},
  ],
};

/// Descriptor for `ConfirmScanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmScanResponseDescriptor = $convert.base64Decode(
    'ChNDb25maXJtU2NhblJlc3BvbnNlEiEKDGhpZGRlbl9jb3VudBgBIAEoA1ILaGlkZGVuQ291bn'
    'Q=');

@$core.Deprecated('Use hintPathsRequestDescriptor instead')
const HintPathsRequest$json = {
  '1': 'HintPathsRequest',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 9, '10': 'libraryId'},
    {'1': 'paths', '3': 2, '4': 3, '5': 9, '10': 'paths'},
  ],
};

/// Descriptor for `HintPathsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hintPathsRequestDescriptor = $convert.base64Decode(
    'ChBIaW50UGF0aHNSZXF1ZXN0Eh0KCmxpYnJhcnlfaWQYASABKAlSCWxpYnJhcnlJZBIUCgVwYX'
    'RocxgCIAMoCVIFcGF0aHM=');

@$core.Deprecated('Use hintPathsResponseDescriptor instead')
const HintPathsResponse$json = {
  '1': 'HintPathsResponse',
};

/// Descriptor for `HintPathsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hintPathsResponseDescriptor =
    $convert.base64Decode('ChFIaW50UGF0aHNSZXNwb25zZQ==');

@$core.Deprecated('Use relocateLibraryRequestDescriptor instead')
const RelocateLibraryRequest$json = {
  '1': 'RelocateLibraryRequest',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 9, '10': 'libraryId'},
    {'1': 'root', '3': 2, '4': 1, '5': 9, '10': 'root'},
  ],
};

/// Descriptor for `RelocateLibraryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relocateLibraryRequestDescriptor =
    $convert.base64Decode(
        'ChZSZWxvY2F0ZUxpYnJhcnlSZXF1ZXN0Eh0KCmxpYnJhcnlfaWQYASABKAlSCWxpYnJhcnlJZB'
        'ISCgRyb290GAIgASgJUgRyb290');

@$core.Deprecated('Use relocateLibraryResponseDescriptor instead')
const RelocateLibraryResponse$json = {
  '1': 'RelocateLibraryResponse',
};

/// Descriptor for `RelocateLibraryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relocateLibraryResponseDescriptor =
    $convert.base64Decode('ChdSZWxvY2F0ZUxpYnJhcnlSZXNwb25zZQ==');

@$core.Deprecated('Use setRenditionQualityRequestDescriptor instead')
const SetRenditionQualityRequest$json = {
  '1': 'SetRenditionQualityRequest',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 9, '10': 'libraryId'},
    {'1': 'quality', '3': 2, '4': 1, '5': 9, '10': 'quality'},
  ],
};

/// Descriptor for `SetRenditionQualityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setRenditionQualityRequestDescriptor =
    $convert.base64Decode(
        'ChpTZXRSZW5kaXRpb25RdWFsaXR5UmVxdWVzdBIdCgpsaWJyYXJ5X2lkGAEgASgJUglsaWJyYX'
        'J5SWQSGAoHcXVhbGl0eRgCIAEoCVIHcXVhbGl0eQ==');

@$core.Deprecated('Use setRenditionQualityResponseDescriptor instead')
const SetRenditionQualityResponse$json = {
  '1': 'SetRenditionQualityResponse',
};

/// Descriptor for `SetRenditionQualityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setRenditionQualityResponseDescriptor =
    $convert.base64Decode('ChtTZXRSZW5kaXRpb25RdWFsaXR5UmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> AdminServiceBase$json = {
  '1': 'AdminService',
  '2': [
    {
      '1': 'GetStatus',
      '2': '.photolib.api.v1.GetStatusRequest',
      '3': '.photolib.api.v1.GetStatusResponse'
    },
    {
      '1': 'ListStores',
      '2': '.photolib.api.v1.ListStoresRequest',
      '3': '.photolib.api.v1.ListStoresResponse'
    },
    {
      '1': 'ListJobs',
      '2': '.photolib.api.v1.ListJobsRequest',
      '3': '.photolib.api.v1.ListJobsResponse'
    },
    {
      '1': 'RetryJob',
      '2': '.photolib.api.v1.RetryJobRequest',
      '3': '.photolib.api.v1.RetryJobResponse'
    },
    {
      '1': 'CancelJob',
      '2': '.photolib.api.v1.CancelJobRequest',
      '3': '.photolib.api.v1.CancelJobResponse'
    },
    {
      '1': 'PauseJobType',
      '2': '.photolib.api.v1.PauseJobTypeRequest',
      '3': '.photolib.api.v1.PauseJobTypeResponse'
    },
    {
      '1': 'ResumeJobType',
      '2': '.photolib.api.v1.ResumeJobTypeRequest',
      '3': '.photolib.api.v1.ResumeJobTypeResponse'
    },
    {
      '1': 'Reprocess',
      '2': '.photolib.api.v1.ReprocessRequest',
      '3': '.photolib.api.v1.ReprocessResponse'
    },
    {
      '1': 'ListAuditEvents',
      '2': '.photolib.api.v1.ListAuditEventsRequest',
      '3': '.photolib.api.v1.ListAuditEventsResponse'
    },
    {
      '1': 'TailLogs',
      '2': '.photolib.api.v1.TailLogsRequest',
      '3': '.photolib.api.v1.TailLogsResponse'
    },
    {
      '1': 'GetSettings',
      '2': '.photolib.api.v1.GetSettingsRequest',
      '3': '.photolib.api.v1.GetSettingsResponse'
    },
    {
      '1': 'UpdateSettings',
      '2': '.photolib.api.v1.UpdateSettingsRequest',
      '3': '.photolib.api.v1.UpdateSettingsResponse'
    },
    {
      '1': 'GetPolicy',
      '2': '.photolib.api.v1.GetPolicyRequest',
      '3': '.photolib.api.v1.GetPolicyResponse'
    },
    {
      '1': 'UpdatePolicy',
      '2': '.photolib.api.v1.UpdatePolicyRequest',
      '3': '.photolib.api.v1.UpdatePolicyResponse'
    },
    {
      '1': 'ApplyPreset',
      '2': '.photolib.api.v1.ApplyPresetRequest',
      '3': '.photolib.api.v1.ApplyPresetResponse'
    },
    {
      '1': 'GetDiagnostics',
      '2': '.photolib.api.v1.GetDiagnosticsRequest',
      '3': '.photolib.api.v1.GetDiagnosticsResponse'
    },
    {
      '1': 'CreateExternalLibrary',
      '2': '.photolib.api.v1.CreateExternalLibraryRequest',
      '3': '.photolib.api.v1.CreateExternalLibraryResponse'
    },
    {
      '1': 'ScanLibrary',
      '2': '.photolib.api.v1.ScanLibraryRequest',
      '3': '.photolib.api.v1.ScanLibraryResponse'
    },
    {
      '1': 'BackUpNow',
      '2': '.photolib.api.v1.BackUpNowRequest',
      '3': '.photolib.api.v1.BackUpNowResponse'
    },
    {
      '1': 'RestoreBackup',
      '2': '.photolib.api.v1.RestoreBackupRequest',
      '3': '.photolib.api.v1.RestoreBackupResponse'
    },
    {
      '1': 'ConfirmScan',
      '2': '.photolib.api.v1.ConfirmScanRequest',
      '3': '.photolib.api.v1.ConfirmScanResponse'
    },
    {
      '1': 'HintPaths',
      '2': '.photolib.api.v1.HintPathsRequest',
      '3': '.photolib.api.v1.HintPathsResponse'
    },
    {
      '1': 'RelocateLibrary',
      '2': '.photolib.api.v1.RelocateLibraryRequest',
      '3': '.photolib.api.v1.RelocateLibraryResponse'
    },
    {
      '1': 'SetRenditionQuality',
      '2': '.photolib.api.v1.SetRenditionQualityRequest',
      '3': '.photolib.api.v1.SetRenditionQualityResponse'
    },
  ],
};

@$core.Deprecated('Use adminServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AdminServiceBase$messageJson = {
  '.photolib.api.v1.GetStatusRequest': GetStatusRequest$json,
  '.photolib.api.v1.GetStatusResponse': GetStatusResponse$json,
  '.photolib.api.v1.AccountUsage': AccountUsage$json,
  '.photolib.api.v1.FileUsage': FileUsage$json,
  '.photolib.api.v1.LibraryStatus': LibraryStatus$json,
  '.photolib.api.v1.Confirmation': Confirmation$json,
  '.photolib.api.v1.Backup': Backup$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.photolib.api.v1.JobCount': JobCount$json,
  '.photolib.api.v1.JobPause': JobPause$json,
  '.photolib.api.v1.IntegrityFinding': IntegrityFinding$json,
  '.photolib.api.v1.StoreScrub': StoreScrub$json,
  '.photolib.api.v1.DeviceBackup': DeviceBackup$json,
  '.photolib.api.v1.BackupRun': BackupRun$json,
  '.photolib.api.v1.ListStoresRequest': ListStoresRequest$json,
  '.photolib.api.v1.ListStoresResponse': ListStoresResponse$json,
  '.photolib.api.v1.StoreStatus': StoreStatus$json,
  '.photolib.api.v1.ListJobsRequest': ListJobsRequest$json,
  '.photolib.api.v1.ListJobsResponse': ListJobsResponse$json,
  '.photolib.api.v1.Job': Job$json,
  '.photolib.api.v1.RetryJobRequest': RetryJobRequest$json,
  '.photolib.api.v1.RetryJobResponse': RetryJobResponse$json,
  '.photolib.api.v1.CancelJobRequest': CancelJobRequest$json,
  '.photolib.api.v1.CancelJobResponse': CancelJobResponse$json,
  '.photolib.api.v1.PauseJobTypeRequest': PauseJobTypeRequest$json,
  '.photolib.api.v1.PauseJobTypeResponse': PauseJobTypeResponse$json,
  '.photolib.api.v1.ResumeJobTypeRequest': ResumeJobTypeRequest$json,
  '.photolib.api.v1.ResumeJobTypeResponse': ResumeJobTypeResponse$json,
  '.photolib.api.v1.ReprocessRequest': ReprocessRequest$json,
  '.photolib.api.v1.ReprocessResponse': ReprocessResponse$json,
  '.photolib.api.v1.ListAuditEventsRequest': ListAuditEventsRequest$json,
  '.photolib.api.v1.ListAuditEventsResponse': ListAuditEventsResponse$json,
  '.photolib.api.v1.AuditEvent': AuditEvent$json,
  '.photolib.api.v1.TailLogsRequest': TailLogsRequest$json,
  '.photolib.api.v1.TailLogsResponse': TailLogsResponse$json,
  '.photolib.api.v1.GetSettingsRequest': GetSettingsRequest$json,
  '.photolib.api.v1.GetSettingsResponse': GetSettingsResponse$json,
  '.photolib.api.v1.Settings': Settings$json,
  '.photolib.api.v1.UpdateSettingsRequest': UpdateSettingsRequest$json,
  '.photolib.api.v1.UpdateSettingsResponse': UpdateSettingsResponse$json,
  '.photolib.api.v1.GetPolicyRequest': GetPolicyRequest$json,
  '.photolib.api.v1.GetPolicyResponse': GetPolicyResponse$json,
  '.photolib.api.v1.PolicySwitch': PolicySwitch$json,
  '.photolib.api.v1.UpdatePolicyRequest': UpdatePolicyRequest$json,
  '.photolib.api.v1.UpdatePolicyResponse': UpdatePolicyResponse$json,
  '.photolib.api.v1.ApplyPresetRequest': ApplyPresetRequest$json,
  '.photolib.api.v1.ApplyPresetResponse': ApplyPresetResponse$json,
  '.photolib.api.v1.GetDiagnosticsRequest': GetDiagnosticsRequest$json,
  '.photolib.api.v1.GetDiagnosticsResponse': GetDiagnosticsResponse$json,
  '.photolib.api.v1.Check': Check$json,
  '.photolib.api.v1.CreateExternalLibraryRequest':
      CreateExternalLibraryRequest$json,
  '.photolib.api.v1.CreateExternalLibraryResponse':
      CreateExternalLibraryResponse$json,
  '.photolib.api.v1.ScanLibraryRequest': ScanLibraryRequest$json,
  '.photolib.api.v1.ScanLibraryResponse': ScanLibraryResponse$json,
  '.photolib.api.v1.BackUpNowRequest': BackUpNowRequest$json,
  '.photolib.api.v1.BackUpNowResponse': BackUpNowResponse$json,
  '.photolib.api.v1.RestoreBackupRequest': RestoreBackupRequest$json,
  '.photolib.api.v1.RestoreBackupResponse': RestoreBackupResponse$json,
  '.photolib.api.v1.ConfirmScanRequest': ConfirmScanRequest$json,
  '.photolib.api.v1.ConfirmScanResponse': ConfirmScanResponse$json,
  '.photolib.api.v1.HintPathsRequest': HintPathsRequest$json,
  '.photolib.api.v1.HintPathsResponse': HintPathsResponse$json,
  '.photolib.api.v1.RelocateLibraryRequest': RelocateLibraryRequest$json,
  '.photolib.api.v1.RelocateLibraryResponse': RelocateLibraryResponse$json,
  '.photolib.api.v1.SetRenditionQualityRequest':
      SetRenditionQualityRequest$json,
  '.photolib.api.v1.SetRenditionQualityResponse':
      SetRenditionQualityResponse$json,
};

/// Descriptor for `AdminService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List adminServiceDescriptor = $convert.base64Decode(
    'CgxBZG1pblNlcnZpY2USUgoJR2V0U3RhdHVzEiEucGhvdG9saWIuYXBpLnYxLkdldFN0YXR1c1'
    'JlcXVlc3QaIi5waG90b2xpYi5hcGkudjEuR2V0U3RhdHVzUmVzcG9uc2USVQoKTGlzdFN0b3Jl'
    'cxIiLnBob3RvbGliLmFwaS52MS5MaXN0U3RvcmVzUmVxdWVzdBojLnBob3RvbGliLmFwaS52MS'
    '5MaXN0U3RvcmVzUmVzcG9uc2USTwoITGlzdEpvYnMSIC5waG90b2xpYi5hcGkudjEuTGlzdEpv'
    'YnNSZXF1ZXN0GiEucGhvdG9saWIuYXBpLnYxLkxpc3RKb2JzUmVzcG9uc2USTwoIUmV0cnlKb2'
    'ISIC5waG90b2xpYi5hcGkudjEuUmV0cnlKb2JSZXF1ZXN0GiEucGhvdG9saWIuYXBpLnYxLlJl'
    'dHJ5Sm9iUmVzcG9uc2USUgoJQ2FuY2VsSm9iEiEucGhvdG9saWIuYXBpLnYxLkNhbmNlbEpvYl'
    'JlcXVlc3QaIi5waG90b2xpYi5hcGkudjEuQ2FuY2VsSm9iUmVzcG9uc2USWwoMUGF1c2VKb2JU'
    'eXBlEiQucGhvdG9saWIuYXBpLnYxLlBhdXNlSm9iVHlwZVJlcXVlc3QaJS5waG90b2xpYi5hcG'
    'kudjEuUGF1c2VKb2JUeXBlUmVzcG9uc2USXgoNUmVzdW1lSm9iVHlwZRIlLnBob3RvbGliLmFw'
    'aS52MS5SZXN1bWVKb2JUeXBlUmVxdWVzdBomLnBob3RvbGliLmFwaS52MS5SZXN1bWVKb2JUeX'
    'BlUmVzcG9uc2USUgoJUmVwcm9jZXNzEiEucGhvdG9saWIuYXBpLnYxLlJlcHJvY2Vzc1JlcXVl'
    'c3QaIi5waG90b2xpYi5hcGkudjEuUmVwcm9jZXNzUmVzcG9uc2USZAoPTGlzdEF1ZGl0RXZlbn'
    'RzEicucGhvdG9saWIuYXBpLnYxLkxpc3RBdWRpdEV2ZW50c1JlcXVlc3QaKC5waG90b2xpYi5h'
    'cGkudjEuTGlzdEF1ZGl0RXZlbnRzUmVzcG9uc2USTwoIVGFpbExvZ3MSIC5waG90b2xpYi5hcG'
    'kudjEuVGFpbExvZ3NSZXF1ZXN0GiEucGhvdG9saWIuYXBpLnYxLlRhaWxMb2dzUmVzcG9uc2US'
    'WAoLR2V0U2V0dGluZ3MSIy5waG90b2xpYi5hcGkudjEuR2V0U2V0dGluZ3NSZXF1ZXN0GiQucG'
    'hvdG9saWIuYXBpLnYxLkdldFNldHRpbmdzUmVzcG9uc2USYQoOVXBkYXRlU2V0dGluZ3MSJi5w'
    'aG90b2xpYi5hcGkudjEuVXBkYXRlU2V0dGluZ3NSZXF1ZXN0GicucGhvdG9saWIuYXBpLnYxLl'
    'VwZGF0ZVNldHRpbmdzUmVzcG9uc2USUgoJR2V0UG9saWN5EiEucGhvdG9saWIuYXBpLnYxLkdl'
    'dFBvbGljeVJlcXVlc3QaIi5waG90b2xpYi5hcGkudjEuR2V0UG9saWN5UmVzcG9uc2USWwoMVX'
    'BkYXRlUG9saWN5EiQucGhvdG9saWIuYXBpLnYxLlVwZGF0ZVBvbGljeVJlcXVlc3QaJS5waG90'
    'b2xpYi5hcGkudjEuVXBkYXRlUG9saWN5UmVzcG9uc2USWAoLQXBwbHlQcmVzZXQSIy5waG90b2'
    'xpYi5hcGkudjEuQXBwbHlQcmVzZXRSZXF1ZXN0GiQucGhvdG9saWIuYXBpLnYxLkFwcGx5UHJl'
    'c2V0UmVzcG9uc2USYQoOR2V0RGlhZ25vc3RpY3MSJi5waG90b2xpYi5hcGkudjEuR2V0RGlhZ2'
    '5vc3RpY3NSZXF1ZXN0GicucGhvdG9saWIuYXBpLnYxLkdldERpYWdub3N0aWNzUmVzcG9uc2US'
    'dgoVQ3JlYXRlRXh0ZXJuYWxMaWJyYXJ5Ei0ucGhvdG9saWIuYXBpLnYxLkNyZWF0ZUV4dGVybm'
    'FsTGlicmFyeVJlcXVlc3QaLi5waG90b2xpYi5hcGkudjEuQ3JlYXRlRXh0ZXJuYWxMaWJyYXJ5'
    'UmVzcG9uc2USWAoLU2NhbkxpYnJhcnkSIy5waG90b2xpYi5hcGkudjEuU2NhbkxpYnJhcnlSZX'
    'F1ZXN0GiQucGhvdG9saWIuYXBpLnYxLlNjYW5MaWJyYXJ5UmVzcG9uc2USUgoJQmFja1VwTm93'
    'EiEucGhvdG9saWIuYXBpLnYxLkJhY2tVcE5vd1JlcXVlc3QaIi5waG90b2xpYi5hcGkudjEuQm'
    'Fja1VwTm93UmVzcG9uc2USXgoNUmVzdG9yZUJhY2t1cBIlLnBob3RvbGliLmFwaS52MS5SZXN0'
    'b3JlQmFja3VwUmVxdWVzdBomLnBob3RvbGliLmFwaS52MS5SZXN0b3JlQmFja3VwUmVzcG9uc2'
    'USWAoLQ29uZmlybVNjYW4SIy5waG90b2xpYi5hcGkudjEuQ29uZmlybVNjYW5SZXF1ZXN0GiQu'
    'cGhvdG9saWIuYXBpLnYxLkNvbmZpcm1TY2FuUmVzcG9uc2USUgoJSGludFBhdGhzEiEucGhvdG'
    '9saWIuYXBpLnYxLkhpbnRQYXRoc1JlcXVlc3QaIi5waG90b2xpYi5hcGkudjEuSGludFBhdGhz'
    'UmVzcG9uc2USZAoPUmVsb2NhdGVMaWJyYXJ5EicucGhvdG9saWIuYXBpLnYxLlJlbG9jYXRlTG'
    'licmFyeVJlcXVlc3QaKC5waG90b2xpYi5hcGkudjEuUmVsb2NhdGVMaWJyYXJ5UmVzcG9uc2US'
    'cAoTU2V0UmVuZGl0aW9uUXVhbGl0eRIrLnBob3RvbGliLmFwaS52MS5TZXRSZW5kaXRpb25RdW'
    'FsaXR5UmVxdWVzdBosLnBob3RvbGliLmFwaS52MS5TZXRSZW5kaXRpb25RdWFsaXR5UmVzcG9u'
    'c2U=');
