// This is a generated file - do not edit.
//
// Generated from photolib/kernel/v1/geo.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How siblings are ordered.
class GeoSort extends $pb.ProtobufEnum {
  /// Most items first, then by name.
  static const GeoSort GEO_SORT_COUNT =
      GeoSort._(0, _omitEnumNames ? '' : 'GEO_SORT_COUNT');

  /// By name, as the locale's lower-cased text compares.
  static const GeoSort GEO_SORT_NAME =
      GeoSort._(1, _omitEnumNames ? '' : 'GEO_SORT_NAME');

  static const $core.List<GeoSort> values = <GeoSort>[
    GEO_SORT_COUNT,
    GEO_SORT_NAME,
  ];

  static final $core.List<GeoSort?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static GeoSort? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GeoSort._(super.value, super.name);
}

/// The level of a node.
class GeoLevel extends $pb.ProtobufEnum {
  static const GeoLevel GEO_LEVEL_UNSPECIFIED =
      GeoLevel._(0, _omitEnumNames ? '' : 'GEO_LEVEL_UNSPECIFIED');
  static const GeoLevel GEO_LEVEL_COUNTRY =
      GeoLevel._(1, _omitEnumNames ? '' : 'GEO_LEVEL_COUNTRY');
  static const GeoLevel GEO_LEVEL_REGION =
      GeoLevel._(2, _omitEnumNames ? '' : 'GEO_LEVEL_REGION');
  static const GeoLevel GEO_LEVEL_CITY =
      GeoLevel._(3, _omitEnumNames ? '' : 'GEO_LEVEL_CITY');

  /// A place of the user's, which has no parent.
  static const GeoLevel GEO_LEVEL_USER =
      GeoLevel._(4, _omitEnumNames ? '' : 'GEO_LEVEL_USER');

  static const $core.List<GeoLevel> values = <GeoLevel>[
    GEO_LEVEL_UNSPECIFIED,
    GEO_LEVEL_COUNTRY,
    GEO_LEVEL_REGION,
    GEO_LEVEL_CITY,
    GEO_LEVEL_USER,
  ];

  static final $core.List<GeoLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static GeoLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GeoLevel._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
