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

import 'package:protobuf/protobuf.dart' as $pb;

import 'admin.pb.dart' as $1;
import 'admin.pbjson.dart';

export 'admin.pb.dart';

abstract class AdminServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GetStatusResponse> getStatus(
      $pb.ServerContext ctx, $1.GetStatusRequest request);
  $async.Future<$1.ListStoresResponse> listStores(
      $pb.ServerContext ctx, $1.ListStoresRequest request);
  $async.Future<$1.ListJobsResponse> listJobs(
      $pb.ServerContext ctx, $1.ListJobsRequest request);
  $async.Future<$1.RetryJobResponse> retryJob(
      $pb.ServerContext ctx, $1.RetryJobRequest request);
  $async.Future<$1.CancelJobResponse> cancelJob(
      $pb.ServerContext ctx, $1.CancelJobRequest request);
  $async.Future<$1.PauseJobTypeResponse> pauseJobType(
      $pb.ServerContext ctx, $1.PauseJobTypeRequest request);
  $async.Future<$1.ResumeJobTypeResponse> resumeJobType(
      $pb.ServerContext ctx, $1.ResumeJobTypeRequest request);
  $async.Future<$1.ReprocessResponse> reprocess(
      $pb.ServerContext ctx, $1.ReprocessRequest request);
  $async.Future<$1.ListAuditEventsResponse> listAuditEvents(
      $pb.ServerContext ctx, $1.ListAuditEventsRequest request);
  $async.Future<$1.TailLogsResponse> tailLogs(
      $pb.ServerContext ctx, $1.TailLogsRequest request);
  $async.Future<$1.GetSettingsResponse> getSettings(
      $pb.ServerContext ctx, $1.GetSettingsRequest request);
  $async.Future<$1.UpdateSettingsResponse> updateSettings(
      $pb.ServerContext ctx, $1.UpdateSettingsRequest request);
  $async.Future<$1.GetPolicyResponse> getPolicy(
      $pb.ServerContext ctx, $1.GetPolicyRequest request);
  $async.Future<$1.UpdatePolicyResponse> updatePolicy(
      $pb.ServerContext ctx, $1.UpdatePolicyRequest request);
  $async.Future<$1.ApplyPresetResponse> applyPreset(
      $pb.ServerContext ctx, $1.ApplyPresetRequest request);
  $async.Future<$1.GetDiagnosticsResponse> getDiagnostics(
      $pb.ServerContext ctx, $1.GetDiagnosticsRequest request);
  $async.Future<$1.CreateExternalLibraryResponse> createExternalLibrary(
      $pb.ServerContext ctx, $1.CreateExternalLibraryRequest request);
  $async.Future<$1.ScanLibraryResponse> scanLibrary(
      $pb.ServerContext ctx, $1.ScanLibraryRequest request);
  $async.Future<$1.BackUpNowResponse> backUpNow(
      $pb.ServerContext ctx, $1.BackUpNowRequest request);
  $async.Future<$1.RestoreBackupResponse> restoreBackup(
      $pb.ServerContext ctx, $1.RestoreBackupRequest request);
  $async.Future<$1.ConfirmScanResponse> confirmScan(
      $pb.ServerContext ctx, $1.ConfirmScanRequest request);
  $async.Future<$1.HintPathsResponse> hintPaths(
      $pb.ServerContext ctx, $1.HintPathsRequest request);
  $async.Future<$1.RelocateLibraryResponse> relocateLibrary(
      $pb.ServerContext ctx, $1.RelocateLibraryRequest request);
  $async.Future<$1.SetRenditionQualityResponse> setRenditionQuality(
      $pb.ServerContext ctx, $1.SetRenditionQualityRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetStatus':
        return $1.GetStatusRequest();
      case 'ListStores':
        return $1.ListStoresRequest();
      case 'ListJobs':
        return $1.ListJobsRequest();
      case 'RetryJob':
        return $1.RetryJobRequest();
      case 'CancelJob':
        return $1.CancelJobRequest();
      case 'PauseJobType':
        return $1.PauseJobTypeRequest();
      case 'ResumeJobType':
        return $1.ResumeJobTypeRequest();
      case 'Reprocess':
        return $1.ReprocessRequest();
      case 'ListAuditEvents':
        return $1.ListAuditEventsRequest();
      case 'TailLogs':
        return $1.TailLogsRequest();
      case 'GetSettings':
        return $1.GetSettingsRequest();
      case 'UpdateSettings':
        return $1.UpdateSettingsRequest();
      case 'GetPolicy':
        return $1.GetPolicyRequest();
      case 'UpdatePolicy':
        return $1.UpdatePolicyRequest();
      case 'ApplyPreset':
        return $1.ApplyPresetRequest();
      case 'GetDiagnostics':
        return $1.GetDiagnosticsRequest();
      case 'CreateExternalLibrary':
        return $1.CreateExternalLibraryRequest();
      case 'ScanLibrary':
        return $1.ScanLibraryRequest();
      case 'BackUpNow':
        return $1.BackUpNowRequest();
      case 'RestoreBackup':
        return $1.RestoreBackupRequest();
      case 'ConfirmScan':
        return $1.ConfirmScanRequest();
      case 'HintPaths':
        return $1.HintPathsRequest();
      case 'RelocateLibrary':
        return $1.RelocateLibraryRequest();
      case 'SetRenditionQuality':
        return $1.SetRenditionQualityRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetStatus':
        return getStatus(ctx, request as $1.GetStatusRequest);
      case 'ListStores':
        return listStores(ctx, request as $1.ListStoresRequest);
      case 'ListJobs':
        return listJobs(ctx, request as $1.ListJobsRequest);
      case 'RetryJob':
        return retryJob(ctx, request as $1.RetryJobRequest);
      case 'CancelJob':
        return cancelJob(ctx, request as $1.CancelJobRequest);
      case 'PauseJobType':
        return pauseJobType(ctx, request as $1.PauseJobTypeRequest);
      case 'ResumeJobType':
        return resumeJobType(ctx, request as $1.ResumeJobTypeRequest);
      case 'Reprocess':
        return reprocess(ctx, request as $1.ReprocessRequest);
      case 'ListAuditEvents':
        return listAuditEvents(ctx, request as $1.ListAuditEventsRequest);
      case 'TailLogs':
        return tailLogs(ctx, request as $1.TailLogsRequest);
      case 'GetSettings':
        return getSettings(ctx, request as $1.GetSettingsRequest);
      case 'UpdateSettings':
        return updateSettings(ctx, request as $1.UpdateSettingsRequest);
      case 'GetPolicy':
        return getPolicy(ctx, request as $1.GetPolicyRequest);
      case 'UpdatePolicy':
        return updatePolicy(ctx, request as $1.UpdatePolicyRequest);
      case 'ApplyPreset':
        return applyPreset(ctx, request as $1.ApplyPresetRequest);
      case 'GetDiagnostics':
        return getDiagnostics(ctx, request as $1.GetDiagnosticsRequest);
      case 'CreateExternalLibrary':
        return createExternalLibrary(
            ctx, request as $1.CreateExternalLibraryRequest);
      case 'ScanLibrary':
        return scanLibrary(ctx, request as $1.ScanLibraryRequest);
      case 'BackUpNow':
        return backUpNow(ctx, request as $1.BackUpNowRequest);
      case 'RestoreBackup':
        return restoreBackup(ctx, request as $1.RestoreBackupRequest);
      case 'ConfirmScan':
        return confirmScan(ctx, request as $1.ConfirmScanRequest);
      case 'HintPaths':
        return hintPaths(ctx, request as $1.HintPathsRequest);
      case 'RelocateLibrary':
        return relocateLibrary(ctx, request as $1.RelocateLibraryRequest);
      case 'SetRenditionQuality':
        return setRenditionQuality(
            ctx, request as $1.SetRenditionQualityRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AdminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AdminServiceBase$messageJson;
}
