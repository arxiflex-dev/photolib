// This is a generated file - do not edit.
//
// Generated from photolib/kernel/v1/call.proto.

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

@$core.Deprecated('Use methodDescriptor instead')
const Method$json = {
  '1': 'Method',
  '2': [
    {'1': 'METHOD_UNSPECIFIED', '2': 0},
    {'1': 'METHOD_RESOLVE_CAPTURE_TIME', '2': 2},
    {'1': 'METHOD_PARSE_QUERY', '2': 3},
    {'1': 'METHOD_READ_METADATA', '2': 4},
    {'1': 'METHOD_IMPORT_KEY', '2': 5},
    {'1': 'METHOD_DROP_KEY', '2': 6},
    {'1': 'METHOD_DERIVE_KEY', '2': 7},
    {'1': 'METHOD_DERIVE_PASSWORD_KEY', '2': 8},
    {'1': 'METHOD_CHECK_KDF_PARAMS', '2': 9},
    {'1': 'METHOD_ENCRYPT_BLOB', '2': 10},
    {'1': 'METHOD_DECRYPT_BLOB', '2': 11},
    {'1': 'METHOD_WRAP_KEY', '2': 12},
    {'1': 'METHOD_UNWRAP_KEY', '2': 13},
    {'1': 'METHOD_SEAL_LOCKBOX', '2': 14},
    {'1': 'METHOD_READ_LOCKBOX', '2': 15},
    {'1': 'METHOD_OPEN_LOCKBOX', '2': 16},
    {'1': 'METHOD_INBOX_PUBLIC_KEY', '2': 17},
    {'1': 'METHOD_SEAL_JOURNAL_ENTRY', '2': 18},
    {'1': 'METHOD_OPEN_JOURNAL_ENTRY', '2': 19},
    {'1': 'METHOD_PAIR_LIVE_PHOTOS', '2': 20},
    {'1': 'METHOD_PUBLIC_KEY', '2': 21},
    {'1': 'METHOD_SHARE_KEY', '2': 22},
    {'1': 'METHOD_ACCEPT_KEY', '2': 23},
    {'1': 'METHOD_SIGN_ENTRY', '2': 24},
    {'1': 'METHOD_VERIFY_IDENTITY_LOG', '2': 25},
    {'1': 'METHOD_VERIFY_MEMBERSHIP_LOG', '2': 26},
    {'1': 'METHOD_SAFETY_NUMBER', '2': 27},
    {'1': 'METHOD_EPOCH_CODE', '2': 28},
    {'1': 'METHOD_DEDUP_TOKEN', '2': 29},
    {'1': 'METHOD_LINK_KEYS', '2': 30},
    {'1': 'METHOD_LINK_FRAGMENT', '2': 31},
    {'1': 'METHOD_OPAQUE_REGISTER', '2': 32},
    {'1': 'METHOD_OPAQUE_LOGIN', '2': 33},
    {'1': 'METHOD_OPAQUE_SERVER_REGISTER', '2': 34},
    {'1': 'METHOD_OPAQUE_SERVER_LOGIN', '2': 35},
    {'1': 'METHOD_DEVELOP', '2': 36},
    {'1': 'METHOD_DATABASE_KEY', '2': 37},
    {'1': 'METHOD_PREPARE_IMAGE', '2': 38},
    {'1': 'METHOD_ENCODE_THUMB_HASH', '2': 39},
    {'1': 'METHOD_RECOVERY_PHRASE', '2': 40},
    {'1': 'METHOD_RECOVERY_KEY', '2': 41},
    {'1': 'METHOD_EDIT_COPY', '2': 42},
    {'1': 'METHOD_READ_HEIF', '2': 43},
    {'1': 'METHOD_MAP_INDEX_BUILD', '2': 44},
    {'1': 'METHOD_MAP_QUERY', '2': 45},
    {'1': 'METHOD_MAP_ASSETS', '2': 46},
    {'1': 'METHOD_MAP_INDEX_DROP', '2': 47},
    {'1': 'METHOD_PREPARE_FACE_DETECTION', '2': 48},
    {'1': 'METHOD_DECODE_FACES', '2': 49},
    {'1': 'METHOD_ALIGN_FACE', '2': 50},
    {'1': 'METHOD_NORMALIZE_FACE_EMBEDDING', '2': 51},
    {'1': 'METHOD_MAP_FACES', '2': 52},
    {'1': 'METHOD_RESOLVE_RECIPE', '2': 53},
    {'1': 'METHOD_COMPARE_RECIPES', '2': 54},
    {'1': 'METHOD_MAP_REGIONS', '2': 55},
    {'1': 'METHOD_RENDER_RECIPE', '2': 56},
    {'1': 'METHOD_RECIPE_FROM_DEVELOP', '2': 57},
    {'1': 'METHOD_GEO_LOAD', '2': 58},
    {'1': 'METHOD_GEO_RESOLVE', '2': 59},
    {'1': 'METHOD_GEO_TIMEZONE', '2': 60},
    {'1': 'METHOD_GEO_DROP', '2': 61},
  ],
  '4': [
    {'1': 1, '2': 1},
  ],
  '5': ['METHOD_DECRYPT_ENVELOPE'],
};

/// Descriptor for `Method`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List methodDescriptor = $convert.base64Decode(
    'CgZNZXRob2QSFgoSTUVUSE9EX1VOU1BFQ0lGSUVEEAASHwobTUVUSE9EX1JFU09MVkVfQ0FQVF'
    'VSRV9USU1FEAISFgoSTUVUSE9EX1BBUlNFX1FVRVJZEAMSGAoUTUVUSE9EX1JFQURfTUVUQURB'
    'VEEQBBIVChFNRVRIT0RfSU1QT1JUX0tFWRAFEhMKD01FVEhPRF9EUk9QX0tFWRAGEhUKEU1FVE'
    'hPRF9ERVJJVkVfS0VZEAcSHgoaTUVUSE9EX0RFUklWRV9QQVNTV09SRF9LRVkQCBIbChdNRVRI'
    'T0RfQ0hFQ0tfS0RGX1BBUkFNUxAJEhcKE01FVEhPRF9FTkNSWVBUX0JMT0IQChIXChNNRVRIT0'
    'RfREVDUllQVF9CTE9CEAsSEwoPTUVUSE9EX1dSQVBfS0VZEAwSFQoRTUVUSE9EX1VOV1JBUF9L'
    'RVkQDRIXChNNRVRIT0RfU0VBTF9MT0NLQk9YEA4SFwoTTUVUSE9EX1JFQURfTE9DS0JPWBAPEh'
    'cKE01FVEhPRF9PUEVOX0xPQ0tCT1gQEBIbChdNRVRIT0RfSU5CT1hfUFVCTElDX0tFWRAREh0K'
    'GU1FVEhPRF9TRUFMX0pPVVJOQUxfRU5UUlkQEhIdChlNRVRIT0RfT1BFTl9KT1VSTkFMX0VOVF'
    'JZEBMSGwoXTUVUSE9EX1BBSVJfTElWRV9QSE9UT1MQFBIVChFNRVRIT0RfUFVCTElDX0tFWRAV'
    'EhQKEE1FVEhPRF9TSEFSRV9LRVkQFhIVChFNRVRIT0RfQUNDRVBUX0tFWRAXEhUKEU1FVEhPRF'
    '9TSUdOX0VOVFJZEBgSHgoaTUVUSE9EX1ZFUklGWV9JREVOVElUWV9MT0cQGRIgChxNRVRIT0Rf'
    'VkVSSUZZX01FTUJFUlNISVBfTE9HEBoSGAoUTUVUSE9EX1NBRkVUWV9OVU1CRVIQGxIVChFNRV'
    'RIT0RfRVBPQ0hfQ09ERRAcEhYKEk1FVEhPRF9ERURVUF9UT0tFThAdEhQKEE1FVEhPRF9MSU5L'
    'X0tFWVMQHhIYChRNRVRIT0RfTElOS19GUkFHTUVOVBAfEhoKFk1FVEhPRF9PUEFRVUVfUkVHSV'
    'NURVIQIBIXChNNRVRIT0RfT1BBUVVFX0xPR0lOECESIQodTUVUSE9EX09QQVFVRV9TRVJWRVJf'
    'UkVHSVNURVIQIhIeChpNRVRIT0RfT1BBUVVFX1NFUlZFUl9MT0dJThAjEhIKDk1FVEhPRF9ERV'
    'ZFTE9QECQSFwoTTUVUSE9EX0RBVEFCQVNFX0tFWRAlEhgKFE1FVEhPRF9QUkVQQVJFX0lNQUdF'
    'ECYSHAoYTUVUSE9EX0VOQ09ERV9USFVNQl9IQVNIECcSGgoWTUVUSE9EX1JFQ09WRVJZX1BIUk'
    'FTRRAoEhcKE01FVEhPRF9SRUNPVkVSWV9LRVkQKRIUChBNRVRIT0RfRURJVF9DT1BZECoSFAoQ'
    'TUVUSE9EX1JFQURfSEVJRhArEhoKFk1FVEhPRF9NQVBfSU5ERVhfQlVJTEQQLBIUChBNRVRIT0'
    'RfTUFQX1FVRVJZEC0SFQoRTUVUSE9EX01BUF9BU1NFVFMQLhIZChVNRVRIT0RfTUFQX0lOREVY'
    'X0RST1AQLxIhCh1NRVRIT0RfUFJFUEFSRV9GQUNFX0RFVEVDVElPThAwEhcKE01FVEhPRF9ERU'
    'NPREVfRkFDRVMQMRIVChFNRVRIT0RfQUxJR05fRkFDRRAyEiMKH01FVEhPRF9OT1JNQUxJWkVf'
    'RkFDRV9FTUJFRERJTkcQMxIUChBNRVRIT0RfTUFQX0ZBQ0VTEDQSGQoVTUVUSE9EX1JFU09MVk'
    'VfUkVDSVBFEDUSGgoWTUVUSE9EX0NPTVBBUkVfUkVDSVBFUxA2EhYKEk1FVEhPRF9NQVBfUkVH'
    'SU9OUxA3EhgKFE1FVEhPRF9SRU5ERVJfUkVDSVBFEDgSHgoaTUVUSE9EX1JFQ0lQRV9GUk9NX0'
    'RFVkVMT1AQORITCg9NRVRIT0RfR0VPX0xPQUQQOhIWChJNRVRIT0RfR0VPX1JFU09MVkUQOxIX'
    'ChNNRVRIT0RfR0VPX1RJTUVaT05FEDwSEwoPTUVUSE9EX0dFT19EUk9QED0iBAgBEAEqF01FVE'
    'hPRF9ERUNSWVBUX0VOVkVMT1BF');

@$core.Deprecated('Use callErrorCodeDescriptor instead')
const CallErrorCode$json = {
  '1': 'CallErrorCode',
  '2': [
    {'1': 'CALL_ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'CALL_ERROR_CODE_UNKNOWN_METHOD', '2': 1},
    {'1': 'CALL_ERROR_CODE_INVALID_REQUEST', '2': 2},
    {'1': 'CALL_ERROR_CODE_INVALID_INPUT', '2': 3},
    {'1': 'CALL_ERROR_CODE_DECRYPTION_FAILED', '2': 4},
    {'1': 'CALL_ERROR_CODE_PANIC', '2': 5},
  ],
};

/// Descriptor for `CallErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List callErrorCodeDescriptor = $convert.base64Decode(
    'Cg1DYWxsRXJyb3JDb2RlEh8KG0NBTExfRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEiIKHkNBTE'
    'xfRVJST1JfQ09ERV9VTktOT1dOX01FVEhPRBABEiMKH0NBTExfRVJST1JfQ09ERV9JTlZBTElE'
    'X1JFUVVFU1QQAhIhCh1DQUxMX0VSUk9SX0NPREVfSU5WQUxJRF9JTlBVVBADEiUKIUNBTExfRV'
    'JST1JfQ09ERV9ERUNSWVBUSU9OX0ZBSUxFRBAEEhkKFUNBTExfRVJST1JfQ09ERV9QQU5JQxAF');

@$core.Deprecated('Use callRequestDescriptor instead')
const CallRequest$json = {
  '1': 'CallRequest',
  '2': [
    {'1': 'method_id', '3': 1, '4': 1, '5': 13, '10': 'methodId'},
    {'1': 'request', '3': 2, '4': 1, '5': 12, '10': 'request'},
  ],
};

/// Descriptor for `CallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callRequestDescriptor = $convert.base64Decode(
    'CgtDYWxsUmVxdWVzdBIbCgltZXRob2RfaWQYASABKA1SCG1ldGhvZElkEhgKB3JlcXVlc3QYAi'
    'ABKAxSB3JlcXVlc3Q=');

@$core.Deprecated('Use callResponseDescriptor instead')
const CallResponse$json = {
  '1': 'CallResponse',
  '2': [
    {'1': 'response', '3': 1, '4': 1, '5': 12, '9': 0, '10': 'response'},
    {
      '1': 'error',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.photolib.kernel.v1.CallError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `CallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callResponseDescriptor = $convert.base64Decode(
    'CgxDYWxsUmVzcG9uc2USHAoIcmVzcG9uc2UYASABKAxIAFIIcmVzcG9uc2USNQoFZXJyb3IYAi'
    'ABKAsyHS5waG90b2xpYi5rZXJuZWwudjEuQ2FsbEVycm9ySABSBWVycm9yQggKBnJlc3VsdA==');

@$core.Deprecated('Use callErrorDescriptor instead')
const CallError$json = {
  '1': 'CallError',
  '2': [
    {
      '1': 'code',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.photolib.kernel.v1.CallErrorCode',
      '10': 'code'
    },
    {
      '1': 'params',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.photolib.kernel.v1.CallError.ParamsEntry',
      '10': 'params'
    },
  ],
  '3': [CallError_ParamsEntry$json],
};

@$core.Deprecated('Use callErrorDescriptor instead')
const CallError_ParamsEntry$json = {
  '1': 'ParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CallError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callErrorDescriptor = $convert.base64Decode(
    'CglDYWxsRXJyb3ISNQoEY29kZRgBIAEoDjIhLnBob3RvbGliLmtlcm5lbC52MS5DYWxsRXJyb3'
    'JDb2RlUgRjb2RlEkEKBnBhcmFtcxgCIAMoCzIpLnBob3RvbGliLmtlcm5lbC52MS5DYWxsRXJy'
    'b3IuUGFyYW1zRW50cnlSBnBhcmFtcxo5CgtQYXJhbXNFbnRyeRIQCgNrZXkYASABKAlSA2tleR'
    'IUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');
