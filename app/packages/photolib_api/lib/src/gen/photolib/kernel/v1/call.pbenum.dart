// This is a generated file - do not edit.
//
// Generated from photolib/kernel/v1/call.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// The kernel functions; the value is the method_id of a call. Keys cross the boundary only as handles into a keyring
/// (docs/dev/crypto-v1.md names the formats).
class Method extends $pb.ProtobufEnum {
  static const Method METHOD_UNSPECIFIED =
      Method._(0, _omitEnumNames ? '' : 'METHOD_UNSPECIFIED');

  /// ResolveCaptureTimeRequest to ResolveCaptureTimeResponse.
  static const Method METHOD_RESOLVE_CAPTURE_TIME =
      Method._(2, _omitEnumNames ? '' : 'METHOD_RESOLVE_CAPTURE_TIME');

  /// ParseQueryRequest to ParseQueryResponse.
  static const Method METHOD_PARSE_QUERY =
      Method._(3, _omitEnumNames ? '' : 'METHOD_PARSE_QUERY');

  /// ReadMetadataRequest to ReadMetadataResponse.
  static const Method METHOD_READ_METADATA =
      Method._(4, _omitEnumNames ? '' : 'METHOD_READ_METADATA');

  /// ImportKeyRequest to KeyResponse.
  static const Method METHOD_IMPORT_KEY =
      Method._(5, _omitEnumNames ? '' : 'METHOD_IMPORT_KEY');

  /// DropKeyRequest to DropKeyResponse.
  static const Method METHOD_DROP_KEY =
      Method._(6, _omitEnumNames ? '' : 'METHOD_DROP_KEY');

  /// DeriveKeyRequest to KeyResponse.
  static const Method METHOD_DERIVE_KEY =
      Method._(7, _omitEnumNames ? '' : 'METHOD_DERIVE_KEY');

  /// DerivePasswordKeyRequest to KeyResponse.
  static const Method METHOD_DERIVE_PASSWORD_KEY =
      Method._(8, _omitEnumNames ? '' : 'METHOD_DERIVE_PASSWORD_KEY');

  /// CheckKdfParamsRequest to CheckKdfParamsResponse.
  static const Method METHOD_CHECK_KDF_PARAMS =
      Method._(9, _omitEnumNames ? '' : 'METHOD_CHECK_KDF_PARAMS');

  /// EncryptBlobRequest to EncryptBlobResponse; also streams.
  static const Method METHOD_ENCRYPT_BLOB =
      Method._(10, _omitEnumNames ? '' : 'METHOD_ENCRYPT_BLOB');

  /// DecryptBlobRequest to DecryptBlobResponse; also streams.
  static const Method METHOD_DECRYPT_BLOB =
      Method._(11, _omitEnumNames ? '' : 'METHOD_DECRYPT_BLOB');

  /// WrapKeyRequest to WrapKeyResponse.
  static const Method METHOD_WRAP_KEY =
      Method._(12, _omitEnumNames ? '' : 'METHOD_WRAP_KEY');

  /// UnwrapKeyRequest to KeyResponse.
  static const Method METHOD_UNWRAP_KEY =
      Method._(13, _omitEnumNames ? '' : 'METHOD_UNWRAP_KEY');

  /// SealLockboxRequest to SealLockboxResponse.
  static const Method METHOD_SEAL_LOCKBOX =
      Method._(14, _omitEnumNames ? '' : 'METHOD_SEAL_LOCKBOX');

  /// ReadLockboxRequest to ReadLockboxResponse.
  static const Method METHOD_READ_LOCKBOX =
      Method._(15, _omitEnumNames ? '' : 'METHOD_READ_LOCKBOX');

  /// OpenLockboxRequest to KeyResponse.
  static const Method METHOD_OPEN_LOCKBOX =
      Method._(16, _omitEnumNames ? '' : 'METHOD_OPEN_LOCKBOX');

  /// InboxPublicKeyRequest to InboxPublicKeyResponse.
  static const Method METHOD_INBOX_PUBLIC_KEY =
      Method._(17, _omitEnumNames ? '' : 'METHOD_INBOX_PUBLIC_KEY');

  /// SealJournalEntryRequest to SealJournalEntryResponse.
  static const Method METHOD_SEAL_JOURNAL_ENTRY =
      Method._(18, _omitEnumNames ? '' : 'METHOD_SEAL_JOURNAL_ENTRY');

  /// OpenJournalEntryRequest to OpenJournalEntryResponse.
  static const Method METHOD_OPEN_JOURNAL_ENTRY =
      Method._(19, _omitEnumNames ? '' : 'METHOD_OPEN_JOURNAL_ENTRY');

  /// PairLivePhotosRequest to PairLivePhotosResponse.
  static const Method METHOD_PAIR_LIVE_PHOTOS =
      Method._(20, _omitEnumNames ? '' : 'METHOD_PAIR_LIVE_PHOTOS');

  /// PublicKeyRequest to PublicKeyResponse.
  static const Method METHOD_PUBLIC_KEY =
      Method._(21, _omitEnumNames ? '' : 'METHOD_PUBLIC_KEY');

  /// ShareKeyRequest to ShareKeyResponse.
  static const Method METHOD_SHARE_KEY =
      Method._(22, _omitEnumNames ? '' : 'METHOD_SHARE_KEY');

  /// AcceptKeyRequest to KeyResponse.
  static const Method METHOD_ACCEPT_KEY =
      Method._(23, _omitEnumNames ? '' : 'METHOD_ACCEPT_KEY');

  /// SignEntryRequest to SignEntryResponse.
  static const Method METHOD_SIGN_ENTRY =
      Method._(24, _omitEnumNames ? '' : 'METHOD_SIGN_ENTRY');

  /// VerifyIdentityLogRequest to VerifyIdentityLogResponse.
  static const Method METHOD_VERIFY_IDENTITY_LOG =
      Method._(25, _omitEnumNames ? '' : 'METHOD_VERIFY_IDENTITY_LOG');

  /// VerifyMembershipLogRequest to VerifyMembershipLogResponse.
  static const Method METHOD_VERIFY_MEMBERSHIP_LOG =
      Method._(26, _omitEnumNames ? '' : 'METHOD_VERIFY_MEMBERSHIP_LOG');

  /// SafetyNumberRequest to CodeResponse.
  static const Method METHOD_SAFETY_NUMBER =
      Method._(27, _omitEnumNames ? '' : 'METHOD_SAFETY_NUMBER');

  /// EpochCodeRequest to CodeResponse.
  static const Method METHOD_EPOCH_CODE =
      Method._(28, _omitEnumNames ? '' : 'METHOD_EPOCH_CODE');

  /// DedupTokenRequest to DedupTokenResponse.
  static const Method METHOD_DEDUP_TOKEN =
      Method._(29, _omitEnumNames ? '' : 'METHOD_DEDUP_TOKEN');

  /// LinkKeysRequest to LinkKeysResponse.
  static const Method METHOD_LINK_KEYS =
      Method._(30, _omitEnumNames ? '' : 'METHOD_LINK_KEYS');

  /// LinkFragmentRequest to LinkFragmentResponse.
  static const Method METHOD_LINK_FRAGMENT =
      Method._(31, _omitEnumNames ? '' : 'METHOD_LINK_FRAGMENT');

  /// OpaqueRegisterRequest to OpaqueClientResponse.
  static const Method METHOD_OPAQUE_REGISTER =
      Method._(32, _omitEnumNames ? '' : 'METHOD_OPAQUE_REGISTER');

  /// OpaqueLoginRequest to OpaqueClientResponse.
  static const Method METHOD_OPAQUE_LOGIN =
      Method._(33, _omitEnumNames ? '' : 'METHOD_OPAQUE_LOGIN');

  /// OpaqueServerRegisterRequest to OpaqueServerResponse.
  static const Method METHOD_OPAQUE_SERVER_REGISTER =
      Method._(34, _omitEnumNames ? '' : 'METHOD_OPAQUE_SERVER_REGISTER');

  /// OpaqueServerLoginRequest to OpaqueServerResponse.
  static const Method METHOD_OPAQUE_SERVER_LOGIN =
      Method._(35, _omitEnumNames ? '' : 'METHOD_OPAQUE_SERVER_LOGIN');

  /// DevelopRequest to DevelopResponse.
  static const Method METHOD_DEVELOP =
      Method._(36, _omitEnumNames ? '' : 'METHOD_DEVELOP');

  /// DatabaseKeyRequest to DatabaseKeyResponse.
  static const Method METHOD_DATABASE_KEY =
      Method._(37, _omitEnumNames ? '' : 'METHOD_DATABASE_KEY');

  /// PrepareImageRequest to PrepareImageResponse.
  static const Method METHOD_PREPARE_IMAGE =
      Method._(38, _omitEnumNames ? '' : 'METHOD_PREPARE_IMAGE');

  /// EncodeThumbHashRequest to EncodeThumbHashResponse.
  static const Method METHOD_ENCODE_THUMB_HASH =
      Method._(39, _omitEnumNames ? '' : 'METHOD_ENCODE_THUMB_HASH');

  /// RecoveryPhraseRequest to RecoveryPhraseResponse.
  static const Method METHOD_RECOVERY_PHRASE =
      Method._(40, _omitEnumNames ? '' : 'METHOD_RECOVERY_PHRASE');

  /// RecoveryKeyRequest to KeyResponse.
  static const Method METHOD_RECOVERY_KEY =
      Method._(41, _omitEnumNames ? '' : 'METHOD_RECOVERY_KEY');

  /// EditCopyRequest to EditCopyResponse.
  static const Method METHOD_EDIT_COPY =
      Method._(42, _omitEnumNames ? '' : 'METHOD_EDIT_COPY');

  /// ReadHeifRequest to ReadHeifResponse.
  static const Method METHOD_READ_HEIF =
      Method._(43, _omitEnumNames ? '' : 'METHOD_READ_HEIF');

  /// MapIndexBuildRequest to MapIndexBuildResponse; the index lives in the keyring until dropped.
  static const Method METHOD_MAP_INDEX_BUILD =
      Method._(44, _omitEnumNames ? '' : 'METHOD_MAP_INDEX_BUILD');

  /// MapQueryRequest to MapQueryResponse.
  static const Method METHOD_MAP_QUERY =
      Method._(45, _omitEnumNames ? '' : 'METHOD_MAP_QUERY');

  /// MapAssetsRequest to MapAssetsResponse.
  static const Method METHOD_MAP_ASSETS =
      Method._(46, _omitEnumNames ? '' : 'METHOD_MAP_ASSETS');

  /// MapIndexDropRequest to MapIndexDropResponse.
  static const Method METHOD_MAP_INDEX_DROP =
      Method._(47, _omitEnumNames ? '' : 'METHOD_MAP_INDEX_DROP');

  /// PrepareFaceDetectionRequest to PrepareFaceDetectionResponse.
  static const Method METHOD_PREPARE_FACE_DETECTION =
      Method._(48, _omitEnumNames ? '' : 'METHOD_PREPARE_FACE_DETECTION');

  /// DecodeFacesRequest to DecodeFacesResponse.
  static const Method METHOD_DECODE_FACES =
      Method._(49, _omitEnumNames ? '' : 'METHOD_DECODE_FACES');

  /// AlignFaceRequest to AlignFaceResponse.
  static const Method METHOD_ALIGN_FACE =
      Method._(50, _omitEnumNames ? '' : 'METHOD_ALIGN_FACE');

  /// NormalizeFaceEmbeddingRequest to NormalizeFaceEmbeddingResponse.
  static const Method METHOD_NORMALIZE_FACE_EMBEDDING =
      Method._(51, _omitEnumNames ? '' : 'METHOD_NORMALIZE_FACE_EMBEDDING');

  /// MapFacesRequest to MapFacesResponse.
  static const Method METHOD_MAP_FACES =
      Method._(52, _omitEnumNames ? '' : 'METHOD_MAP_FACES');

  /// ResolveRecipeRequest to ResolveRecipeResponse.
  static const Method METHOD_RESOLVE_RECIPE =
      Method._(53, _omitEnumNames ? '' : 'METHOD_RESOLVE_RECIPE');

  /// CompareRecipesRequest to CompareRecipesResponse.
  static const Method METHOD_COMPARE_RECIPES =
      Method._(54, _omitEnumNames ? '' : 'METHOD_COMPARE_RECIPES');

  /// MapRegionsRequest to MapRegionsResponse.
  static const Method METHOD_MAP_REGIONS =
      Method._(55, _omitEnumNames ? '' : 'METHOD_MAP_REGIONS');

  /// RenderRecipeRequest to RenderRecipeResponse.
  static const Method METHOD_RENDER_RECIPE =
      Method._(56, _omitEnumNames ? '' : 'METHOD_RENDER_RECIPE');

  /// RecipeFromDevelopRequest to RecipeFromDevelopResponse.
  static const Method METHOD_RECIPE_FROM_DEVELOP =
      Method._(57, _omitEnumNames ? '' : 'METHOD_RECIPE_FROM_DEVELOP');

  /// GeoLoadRequest to GeoLoadResponse; the places pack lives in the keyring until dropped.
  static const Method METHOD_GEO_LOAD =
      Method._(58, _omitEnumNames ? '' : 'METHOD_GEO_LOAD');

  /// GeoResolveRequest to GeoResolveResponse.
  static const Method METHOD_GEO_RESOLVE =
      Method._(59, _omitEnumNames ? '' : 'METHOD_GEO_RESOLVE');

  /// GeoTimezoneRequest to GeoTimezoneResponse.
  static const Method METHOD_GEO_TIMEZONE =
      Method._(60, _omitEnumNames ? '' : 'METHOD_GEO_TIMEZONE');

  /// GeoDropRequest to GeoDropResponse.
  static const Method METHOD_GEO_DROP =
      Method._(61, _omitEnumNames ? '' : 'METHOD_GEO_DROP');

  static const $core.List<Method> values = <Method>[
    METHOD_UNSPECIFIED,
    METHOD_RESOLVE_CAPTURE_TIME,
    METHOD_PARSE_QUERY,
    METHOD_READ_METADATA,
    METHOD_IMPORT_KEY,
    METHOD_DROP_KEY,
    METHOD_DERIVE_KEY,
    METHOD_DERIVE_PASSWORD_KEY,
    METHOD_CHECK_KDF_PARAMS,
    METHOD_ENCRYPT_BLOB,
    METHOD_DECRYPT_BLOB,
    METHOD_WRAP_KEY,
    METHOD_UNWRAP_KEY,
    METHOD_SEAL_LOCKBOX,
    METHOD_READ_LOCKBOX,
    METHOD_OPEN_LOCKBOX,
    METHOD_INBOX_PUBLIC_KEY,
    METHOD_SEAL_JOURNAL_ENTRY,
    METHOD_OPEN_JOURNAL_ENTRY,
    METHOD_PAIR_LIVE_PHOTOS,
    METHOD_PUBLIC_KEY,
    METHOD_SHARE_KEY,
    METHOD_ACCEPT_KEY,
    METHOD_SIGN_ENTRY,
    METHOD_VERIFY_IDENTITY_LOG,
    METHOD_VERIFY_MEMBERSHIP_LOG,
    METHOD_SAFETY_NUMBER,
    METHOD_EPOCH_CODE,
    METHOD_DEDUP_TOKEN,
    METHOD_LINK_KEYS,
    METHOD_LINK_FRAGMENT,
    METHOD_OPAQUE_REGISTER,
    METHOD_OPAQUE_LOGIN,
    METHOD_OPAQUE_SERVER_REGISTER,
    METHOD_OPAQUE_SERVER_LOGIN,
    METHOD_DEVELOP,
    METHOD_DATABASE_KEY,
    METHOD_PREPARE_IMAGE,
    METHOD_ENCODE_THUMB_HASH,
    METHOD_RECOVERY_PHRASE,
    METHOD_RECOVERY_KEY,
    METHOD_EDIT_COPY,
    METHOD_READ_HEIF,
    METHOD_MAP_INDEX_BUILD,
    METHOD_MAP_QUERY,
    METHOD_MAP_ASSETS,
    METHOD_MAP_INDEX_DROP,
    METHOD_PREPARE_FACE_DETECTION,
    METHOD_DECODE_FACES,
    METHOD_ALIGN_FACE,
    METHOD_NORMALIZE_FACE_EMBEDDING,
    METHOD_MAP_FACES,
    METHOD_RESOLVE_RECIPE,
    METHOD_COMPARE_RECIPES,
    METHOD_MAP_REGIONS,
    METHOD_RENDER_RECIPE,
    METHOD_RECIPE_FROM_DEVELOP,
    METHOD_GEO_LOAD,
    METHOD_GEO_RESOLVE,
    METHOD_GEO_TIMEZONE,
    METHOD_GEO_DROP,
  ];

  static final $core.List<Method?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 61);
  static Method? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Method._(super.value, super.name);
}

/// The reason a kernel call failed.
class CallErrorCode extends $pb.ProtobufEnum {
  static const CallErrorCode CALL_ERROR_CODE_UNSPECIFIED =
      CallErrorCode._(0, _omitEnumNames ? '' : 'CALL_ERROR_CODE_UNSPECIFIED');
  static const CallErrorCode CALL_ERROR_CODE_UNKNOWN_METHOD = CallErrorCode._(
      1, _omitEnumNames ? '' : 'CALL_ERROR_CODE_UNKNOWN_METHOD');

  /// The request is malformed; params.field names the field, e.g. a key handle the keyring does not hold.
  static const CallErrorCode CALL_ERROR_CODE_INVALID_REQUEST = CallErrorCode._(
      2, _omitEnumNames ? '' : 'CALL_ERROR_CODE_INVALID_REQUEST');

  /// The input is in no format the function reads, or fails a check after decryption; params.reason is the error of
  /// the crypto specification, e.g. bad_header or wrong_kind.
  static const CallErrorCode CALL_ERROR_CODE_INVALID_INPUT =
      CallErrorCode._(3, _omitEnumNames ? '' : 'CALL_ERROR_CODE_INVALID_INPUT');

  /// Authentication failed: params.reason is commitment_mismatch (a wrong key) or auth_failed (tampered data).
  static const CallErrorCode CALL_ERROR_CODE_DECRYPTION_FAILED =
      CallErrorCode._(
          4, _omitEnumNames ? '' : 'CALL_ERROR_CODE_DECRYPTION_FAILED');

  /// kernel.panic: the kernel panicked on this input, a bug. The binding caught it, so only this call failed; on the web,
  /// where WebAssembly cannot unwind, the module trapped and must be loaded again.
  static const CallErrorCode CALL_ERROR_CODE_PANIC =
      CallErrorCode._(5, _omitEnumNames ? '' : 'CALL_ERROR_CODE_PANIC');

  static const $core.List<CallErrorCode> values = <CallErrorCode>[
    CALL_ERROR_CODE_UNSPECIFIED,
    CALL_ERROR_CODE_UNKNOWN_METHOD,
    CALL_ERROR_CODE_INVALID_REQUEST,
    CALL_ERROR_CODE_INVALID_INPUT,
    CALL_ERROR_CODE_DECRYPTION_FAILED,
    CALL_ERROR_CODE_PANIC,
  ];

  static final $core.List<CallErrorCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CallErrorCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CallErrorCode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
