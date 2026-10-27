// This is a generated file - do not edit.
//
// Generated from photolib/kernel/v1/geo.proto.

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

@$core.Deprecated('Use geoSortDescriptor instead')
const GeoSort$json = {
  '1': 'GeoSort',
  '2': [
    {'1': 'GEO_SORT_COUNT', '2': 0},
    {'1': 'GEO_SORT_NAME', '2': 1},
  ],
};

/// Descriptor for `GeoSort`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List geoSortDescriptor = $convert.base64Decode(
    'CgdHZW9Tb3J0EhIKDkdFT19TT1JUX0NPVU5UEAASEQoNR0VPX1NPUlRfTkFNRRAB');

@$core.Deprecated('Use geoLevelDescriptor instead')
const GeoLevel$json = {
  '1': 'GeoLevel',
  '2': [
    {'1': 'GEO_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'GEO_LEVEL_COUNTRY', '2': 1},
    {'1': 'GEO_LEVEL_REGION', '2': 2},
    {'1': 'GEO_LEVEL_CITY', '2': 3},
    {'1': 'GEO_LEVEL_USER', '2': 4},
  ],
};

/// Descriptor for `GeoLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List geoLevelDescriptor = $convert.base64Decode(
    'CghHZW9MZXZlbBIZChVHRU9fTEVWRUxfVU5TUEVDSUZJRUQQABIVChFHRU9fTEVWRUxfQ09VTl'
    'RSWRABEhQKEEdFT19MRVZFTF9SRUdJT04QAhISCg5HRU9fTEVWRUxfQ0lUWRADEhIKDkdFT19M'
    'RVZFTF9VU0VSEAQ=');

@$core.Deprecated('Use geoLoadRequestDescriptor instead')
const GeoLoadRequest$json = {
  '1': 'GeoLoadRequest',
  '2': [
    {'1': 'core', '3': 1, '4': 1, '5': 12, '10': 'core'},
    {'1': 'names', '3': 2, '4': 1, '5': 12, '10': 'names'},
  ],
};

/// Descriptor for `GeoLoadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoLoadRequestDescriptor = $convert.base64Decode(
    'Cg5HZW9Mb2FkUmVxdWVzdBISCgRjb3JlGAEgASgMUgRjb3JlEhQKBW5hbWVzGAIgASgMUgVuYW'
    '1lcw==');

@$core.Deprecated('Use geoLoadResponseDescriptor instead')
const GeoLoadResponse$json = {
  '1': 'GeoLoadResponse',
  '2': [
    {'1': 'pack', '3': 1, '4': 1, '5': 13, '10': 'pack'},
    {'1': 'countries', '3': 2, '4': 1, '5': 13, '10': 'countries'},
    {'1': 'regions', '3': 3, '4': 1, '5': 13, '10': 'regions'},
    {'1': 'cities', '3': 4, '4': 1, '5': 13, '10': 'cities'},
  ],
};

/// Descriptor for `GeoLoadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoLoadResponseDescriptor = $convert.base64Decode(
    'Cg9HZW9Mb2FkUmVzcG9uc2USEgoEcGFjaxgBIAEoDVIEcGFjaxIcCgljb3VudHJpZXMYAiABKA'
    '1SCWNvdW50cmllcxIYCgdyZWdpb25zGAMgASgNUgdyZWdpb25zEhYKBmNpdGllcxgEIAEoDVIG'
    'Y2l0aWVz');

@$core.Deprecated('Use geoUserPlaceDescriptor instead')
const GeoUserPlace$json = {
  '1': 'GeoUserPlace',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'latitude', '3': 3, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 4, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'radius_m', '3': 5, '4': 1, '5': 13, '10': 'radiusM'},
    {'1': 'sensitive', '3': 6, '4': 1, '5': 8, '10': 'sensitive'},
  ],
};

/// Descriptor for `GeoUserPlace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoUserPlaceDescriptor = $convert.base64Decode(
    'CgxHZW9Vc2VyUGxhY2USDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSGgoIbG'
    'F0aXR1ZGUYAyABKAFSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgEIAEoAVIJbG9uZ2l0dWRlEhkK'
    'CHJhZGl1c19tGAUgASgNUgdyYWRpdXNNEhwKCXNlbnNpdGl2ZRgGIAEoCFIJc2Vuc2l0aXZl');

@$core.Deprecated('Use geoResolveRequestDescriptor instead')
const GeoResolveRequest$json = {
  '1': 'GeoResolveRequest',
  '2': [
    {'1': 'pack', '3': 1, '4': 1, '5': 13, '10': 'pack'},
    {
      '1': 'latitudes',
      '3': 2,
      '4': 3,
      '5': 1,
      '8': {'2': true},
      '10': 'latitudes',
    },
    {
      '1': 'longitudes',
      '3': 3,
      '4': 3,
      '5': 1,
      '8': {'2': true},
      '10': 'longitudes',
    },
    {
      '1': 'user_places',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.photolib.kernel.v1.GeoUserPlace',
      '10': 'userPlaces'
    },
    {
      '1': 'include_sensitive',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'includeSensitive'
    },
    {
      '1': 'sort',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.photolib.kernel.v1.GeoSort',
      '10': 'sort'
    },
  ],
};

/// Descriptor for `GeoResolveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoResolveRequestDescriptor = $convert.base64Decode(
    'ChFHZW9SZXNvbHZlUmVxdWVzdBISCgRwYWNrGAEgASgNUgRwYWNrEiAKCWxhdGl0dWRlcxgCIA'
    'MoAUICEAFSCWxhdGl0dWRlcxIiCgpsb25naXR1ZGVzGAMgAygBQgIQAVIKbG9uZ2l0dWRlcxJB'
    'Cgt1c2VyX3BsYWNlcxgEIAMoCzIgLnBob3RvbGliLmtlcm5lbC52MS5HZW9Vc2VyUGxhY2VSCn'
    'VzZXJQbGFjZXMSKwoRaW5jbHVkZV9zZW5zaXRpdmUYBSABKAhSEGluY2x1ZGVTZW5zaXRpdmUS'
    'LwoEc29ydBgGIAEoDjIbLnBob3RvbGliLmtlcm5lbC52MS5HZW9Tb3J0UgRzb3J0');

@$core.Deprecated('Use geoNodeDescriptor instead')
const GeoNode$json = {
  '1': 'GeoNode',
  '2': [
    {
      '1': 'level',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.photolib.kernel.v1.GeoLevel',
      '10': 'level'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'parent', '3': 4, '4': 1, '5': 17, '10': 'parent'},
    {'1': 'count', '3': 5, '4': 1, '5': 13, '10': 'count'},
    {'1': 'latitude', '3': 6, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 7, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'timezone', '3': 8, '4': 1, '5': 9, '10': 'timezone'},
    {'1': 'sensitive', '3': 9, '4': 1, '5': 8, '10': 'sensitive'},
  ],
};

/// Descriptor for `GeoNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoNodeDescriptor = $convert.base64Decode(
    'CgdHZW9Ob2RlEjIKBWxldmVsGAEgASgOMhwucGhvdG9saWIua2VybmVsLnYxLkdlb0xldmVsUg'
    'VsZXZlbBISCgRuYW1lGAIgASgJUgRuYW1lEhIKBGNvZGUYAyABKAlSBGNvZGUSFgoGcGFyZW50'
    'GAQgASgRUgZwYXJlbnQSFAoFY291bnQYBSABKA1SBWNvdW50EhoKCGxhdGl0dWRlGAYgASgBUg'
    'hsYXRpdHVkZRIcCglsb25naXR1ZGUYByABKAFSCWxvbmdpdHVkZRIaCgh0aW1lem9uZRgIIAEo'
    'CVIIdGltZXpvbmUSHAoJc2Vuc2l0aXZlGAkgASgIUglzZW5zaXRpdmU=');

@$core.Deprecated('Use geoResolveResponseDescriptor instead')
const GeoResolveResponse$json = {
  '1': 'GeoResolveResponse',
  '2': [
    {
      '1': 'nodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.photolib.kernel.v1.GeoNode',
      '10': 'nodes'
    },
    {
      '1': 'assignment',
      '3': 2,
      '4': 3,
      '5': 17,
      '8': {'2': true},
      '10': 'assignment',
    },
  ],
};

/// Descriptor for `GeoResolveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoResolveResponseDescriptor = $convert.base64Decode(
    'ChJHZW9SZXNvbHZlUmVzcG9uc2USMQoFbm9kZXMYASADKAsyGy5waG90b2xpYi5rZXJuZWwudj'
    'EuR2VvTm9kZVIFbm9kZXMSIgoKYXNzaWdubWVudBgCIAMoEUICEAFSCmFzc2lnbm1lbnQ=');

@$core.Deprecated('Use geoTimezoneRequestDescriptor instead')
const GeoTimezoneRequest$json = {
  '1': 'GeoTimezoneRequest',
  '2': [
    {'1': 'pack', '3': 1, '4': 1, '5': 13, '10': 'pack'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 3, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `GeoTimezoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoTimezoneRequestDescriptor = $convert.base64Decode(
    'ChJHZW9UaW1lem9uZVJlcXVlc3QSEgoEcGFjaxgBIAEoDVIEcGFjaxIaCghsYXRpdHVkZRgCIA'
    'EoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAMgASgBUglsb25naXR1ZGU=');

@$core.Deprecated('Use geoTimezoneResponseDescriptor instead')
const GeoTimezoneResponse$json = {
  '1': 'GeoTimezoneResponse',
  '2': [
    {'1': 'timezone', '3': 1, '4': 1, '5': 9, '10': 'timezone'},
    {'1': 'country', '3': 2, '4': 1, '5': 9, '10': 'country'},
  ],
};

/// Descriptor for `GeoTimezoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoTimezoneResponseDescriptor = $convert.base64Decode(
    'ChNHZW9UaW1lem9uZVJlc3BvbnNlEhoKCHRpbWV6b25lGAEgASgJUgh0aW1lem9uZRIYCgdjb3'
    'VudHJ5GAIgASgJUgdjb3VudHJ5');

@$core.Deprecated('Use geoDropRequestDescriptor instead')
const GeoDropRequest$json = {
  '1': 'GeoDropRequest',
  '2': [
    {'1': 'pack', '3': 1, '4': 1, '5': 13, '10': 'pack'},
  ],
};

/// Descriptor for `GeoDropRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoDropRequestDescriptor =
    $convert.base64Decode('Cg5HZW9Ecm9wUmVxdWVzdBISCgRwYWNrGAEgASgNUgRwYWNr');

@$core.Deprecated('Use geoDropResponseDescriptor instead')
const GeoDropResponse$json = {
  '1': 'GeoDropResponse',
};

/// Descriptor for `GeoDropResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoDropResponseDescriptor =
    $convert.base64Decode('Cg9HZW9Ecm9wUmVzcG9uc2U=');
