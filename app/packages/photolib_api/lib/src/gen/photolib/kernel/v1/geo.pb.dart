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

import 'geo.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'geo.pbenum.dart';

/// Loads the places packs into the keyring; its handle is used by the other geo calls until it is dropped.
class GeoLoadRequest extends $pb.GeneratedMessage {
  factory GeoLoadRequest({
    $core.List<$core.int>? core,
    $core.List<$core.int>? names,
  }) {
    final result = GeoLoadRequest._();
    if (core != null) result.core = core;
    if (names != null) result.names = names;
    return result;
  }

  GeoLoadRequest._();

  factory GeoLoadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoLoadRequest()..mergeFromBuffer(data, registry);
  factory GeoLoadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoLoadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoLoadRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoLoadRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'core', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'names', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoLoadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoLoadRequest copyWith(void Function(GeoLoadRequest) updates) =>
      super.copyWith((message) => updates(message as GeoLoadRequest))
          as GeoLoadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoLoadRequest() / GeoLoadRequest.new instead')
  static GeoLoadRequest create() => GeoLoadRequest._();
  static $pb.GeneratedMessage $_createMessage() => GeoLoadRequest._();
  @$core.override
  GeoLoadRequest createEmptyInstance() => GeoLoadRequest._();
  @$core.pragma('dart2js:noInline')
  static GeoLoadRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoLoadRequest>(
          GeoLoadRequest.$_createMessage);
  static GeoLoadRequest? _defaultInstance;

  /// The bytes of places.bin.
  @$pb.TagNumber(1)
  $core.List<$core.int> get core => $_getN(0);
  @$pb.TagNumber(1)
  set core($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCore() => $_has(0);
  @$pb.TagNumber(1)
  void clearCore() => $_clearField(1);

  /// The bytes of a names-<locale>.bin that localises the names, or none for English.
  @$pb.TagNumber(2)
  $core.List<$core.int> get names => $_getN(1);
  @$pb.TagNumber(2)
  set names($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNames() => $_has(1);
  @$pb.TagNumber(2)
  void clearNames() => $_clearField(2);
}

/// The pack the keyring now holds.
class GeoLoadResponse extends $pb.GeneratedMessage {
  factory GeoLoadResponse({
    $core.int? pack,
    $core.int? countries,
    $core.int? regions,
    $core.int? cities,
  }) {
    final result = GeoLoadResponse._();
    if (pack != null) result.pack = pack;
    if (countries != null) result.countries = countries;
    if (regions != null) result.regions = regions;
    if (cities != null) result.cities = cities;
    return result;
  }

  GeoLoadResponse._();

  factory GeoLoadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoLoadResponse()..mergeFromBuffer(data, registry);
  factory GeoLoadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoLoadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoLoadResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoLoadResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pack', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'countries', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'regions', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'cities', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoLoadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoLoadResponse copyWith(void Function(GeoLoadResponse) updates) =>
      super.copyWith((message) => updates(message as GeoLoadResponse))
          as GeoLoadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoLoadResponse() / GeoLoadResponse.new instead')
  static GeoLoadResponse create() => GeoLoadResponse._();
  static $pb.GeneratedMessage $_createMessage() => GeoLoadResponse._();
  @$core.override
  GeoLoadResponse createEmptyInstance() => GeoLoadResponse._();
  @$core.pragma('dart2js:noInline')
  static GeoLoadResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoLoadResponse>(
          GeoLoadResponse.$_createMessage);
  static GeoLoadResponse? _defaultInstance;

  /// The handle of the pack in the keyring.
  @$pb.TagNumber(1)
  $core.int get pack => $_getIZ(0);
  @$pb.TagNumber(1)
  set pack($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get countries => $_getIZ(1);
  @$pb.TagNumber(2)
  set countries($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCountries() => $_has(1);
  @$pb.TagNumber(2)
  void clearCountries() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get regions => $_getIZ(2);
  @$pb.TagNumber(3)
  set regions($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegions() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegions() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get cities => $_getIZ(3);
  @$pb.TagNumber(4)
  set cities($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCities() => $_has(3);
  @$pb.TagNumber(4)
  void clearCities() => $_clearField(4);
}

/// A place the user named: the first one whose circle holds a position takes it (a nearer centre wins among several).
class GeoUserPlace extends $pb.GeneratedMessage {
  factory GeoUserPlace({
    $core.String? id,
    $core.String? name,
    $core.double? latitude,
    $core.double? longitude,
    $core.int? radiusM,
    $core.bool? sensitive,
  }) {
    final result = GeoUserPlace._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (radiusM != null) result.radiusM = radiusM;
    if (sensitive != null) result.sensitive = sensitive;
    return result;
  }

  GeoUserPlace._();

  factory GeoUserPlace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoUserPlace()..mergeFromBuffer(data, registry);
  factory GeoUserPlace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoUserPlace()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoUserPlace',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoUserPlace.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aD(3, _omitFieldNames ? '' : 'latitude')
    ..aD(4, _omitFieldNames ? '' : 'longitude')
    ..aI(5, _omitFieldNames ? '' : 'radiusM', fieldType: $pb.PbFieldType.OU3)
    ..aOB(6, _omitFieldNames ? '' : 'sensitive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoUserPlace clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoUserPlace copyWith(void Function(GeoUserPlace) updates) =>
      super.copyWith((message) => updates(message as GeoUserPlace))
          as GeoUserPlace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoUserPlace() / GeoUserPlace.new instead')
  static GeoUserPlace create() => GeoUserPlace._();
  static $pb.GeneratedMessage $_createMessage() => GeoUserPlace._();
  @$core.override
  GeoUserPlace createEmptyInstance() => GeoUserPlace._();
  @$core.pragma('dart2js:noInline')
  static GeoUserPlace getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoUserPlace>(
          GeoUserPlace.$_createMessage);
  static GeoUserPlace? _defaultInstance;

  /// The caller's id for it, returned as the node's code.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get latitude => $_getN(2);
  @$pb.TagNumber(3)
  set latitude($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLatitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatitude() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get longitude => $_getN(3);
  @$pb.TagNumber(4)
  set longitude($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLongitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLongitude() => $_clearField(4);

  /// Radius in metres; 0 means 200.
  @$pb.TagNumber(5)
  $core.int get radiusM => $_getIZ(4);
  @$pb.TagNumber(5)
  set radiusM($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRadiusM() => $_has(4);
  @$pb.TagNumber(5)
  void clearRadiusM() => $_clearField(5);

  /// A sensitive place (a home, say) is never named, counted or listed unless the request includes sensitive places:
  /// its positions resolve to no place at all, so nothing derived from them shows where they are.
  @$pb.TagNumber(6)
  $core.bool get sensitive => $_getBF(5);
  @$pb.TagNumber(6)
  set sensitive($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSensitive() => $_has(5);
  @$pb.TagNumber(6)
  void clearSensitive() => $_clearField(6);
}

/// The places of a list of positions, as a tree of countries, regions and cities, and the user's places beside it.
class GeoResolveRequest extends $pb.GeneratedMessage {
  factory GeoResolveRequest({
    $core.int? pack,
    $core.Iterable<$core.double>? latitudes,
    $core.Iterable<$core.double>? longitudes,
    $core.Iterable<GeoUserPlace>? userPlaces,
    $core.bool? includeSensitive,
    GeoSort? sort,
  }) {
    final result = GeoResolveRequest._();
    if (pack != null) result.pack = pack;
    if (latitudes != null) result.latitudes.addAll(latitudes);
    if (longitudes != null) result.longitudes.addAll(longitudes);
    if (userPlaces != null) result.userPlaces.addAll(userPlaces);
    if (includeSensitive != null) result.includeSensitive = includeSensitive;
    if (sort != null) result.sort = sort;
    return result;
  }

  GeoResolveRequest._();

  factory GeoResolveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoResolveRequest()..mergeFromBuffer(data, registry);
  factory GeoResolveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoResolveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoResolveRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoResolveRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pack', fieldType: $pb.PbFieldType.OU3)
    ..p<$core.double>(2, _omitFieldNames ? '' : 'latitudes', $pb.PbFieldType.KD)
    ..p<$core.double>(
        3, _omitFieldNames ? '' : 'longitudes', $pb.PbFieldType.KD)
    ..pPM<GeoUserPlace>(4, _omitFieldNames ? '' : 'userPlaces',
        subBuilder: GeoUserPlace.$_createMessage)
    ..aOB(5, _omitFieldNames ? '' : 'includeSensitive')
    ..aE<GeoSort>(6, _omitFieldNames ? '' : 'sort', enumValues: GeoSort.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoResolveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoResolveRequest copyWith(void Function(GeoResolveRequest) updates) =>
      super.copyWith((message) => updates(message as GeoResolveRequest))
          as GeoResolveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoResolveRequest() / GeoResolveRequest.new instead')
  static GeoResolveRequest create() => GeoResolveRequest._();
  static $pb.GeneratedMessage $_createMessage() => GeoResolveRequest._();
  @$core.override
  GeoResolveRequest createEmptyInstance() => GeoResolveRequest._();
  @$core.pragma('dart2js:noInline')
  static GeoResolveRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoResolveRequest>(
          GeoResolveRequest.$_createMessage);
  static GeoResolveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pack => $_getIZ(0);
  @$pb.TagNumber(1)
  set pack($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);

  /// Latitude in degrees, one per position (as MapIndexBuildRequest's).
  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get latitudes => $_getList(1);

  /// Longitude in degrees, as many as latitudes, else the request is invalid.
  @$pb.TagNumber(3)
  $pb.PbList<$core.double> get longitudes => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<GeoUserPlace> get userPlaces => $_getList(3);

  /// Whether sensitive user places are named and counted.
  @$pb.TagNumber(5)
  $core.bool get includeSensitive => $_getBF(4);
  @$pb.TagNumber(5)
  set includeSensitive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIncludeSensitive() => $_has(4);
  @$pb.TagNumber(5)
  void clearIncludeSensitive() => $_clearField(5);

  @$pb.TagNumber(6)
  GeoSort get sort => $_getN(5);
  @$pb.TagNumber(6)
  set sort(GeoSort value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSort() => $_has(5);
  @$pb.TagNumber(6)
  void clearSort() => $_clearField(6);
}

/// One place of the tree.
class GeoNode extends $pb.GeneratedMessage {
  factory GeoNode({
    GeoLevel? level,
    $core.String? name,
    $core.String? code,
    $core.int? parent,
    $core.int? count,
    $core.double? latitude,
    $core.double? longitude,
    $core.String? timezone,
    $core.bool? sensitive,
  }) {
    final result = GeoNode._();
    if (level != null) result.level = level;
    if (name != null) result.name = name;
    if (code != null) result.code = code;
    if (parent != null) result.parent = parent;
    if (count != null) result.count = count;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (timezone != null) result.timezone = timezone;
    if (sensitive != null) result.sensitive = sensitive;
    return result;
  }

  GeoNode._();

  factory GeoNode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoNode()..mergeFromBuffer(data, registry);
  factory GeoNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoNode()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoNode',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoNode.$_createMessage)
    ..aE<GeoLevel>(1, _omitFieldNames ? '' : 'level',
        enumValues: GeoLevel.values)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aI(4, _omitFieldNames ? '' : 'parent', fieldType: $pb.PbFieldType.OS3)
    ..aI(5, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.OU3)
    ..aD(6, _omitFieldNames ? '' : 'latitude')
    ..aD(7, _omitFieldNames ? '' : 'longitude')
    ..aOS(8, _omitFieldNames ? '' : 'timezone')
    ..aOB(9, _omitFieldNames ? '' : 'sensitive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoNode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoNode copyWith(void Function(GeoNode) updates) =>
      super.copyWith((message) => updates(message as GeoNode)) as GeoNode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoNode() / GeoNode.new instead')
  static GeoNode create() => GeoNode._();
  static $pb.GeneratedMessage $_createMessage() => GeoNode._();
  @$core.override
  GeoNode createEmptyInstance() => GeoNode._();
  @$core.pragma('dart2js:noInline')
  static GeoNode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GeoNode>(GeoNode.$_createMessage);
  static GeoNode? _defaultInstance;

  @$pb.TagNumber(1)
  GeoLevel get level => $_getN(0);
  @$pb.TagNumber(1)
  set level(GeoLevel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLevel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLevel() => $_clearField(1);

  /// In the pack's language, else English.
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// A country's ISO 3166 alpha-2 code, a region's GeoNames admin1 code (US.CA), a city's GeoNames id, a user place's id.
  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  /// The index of its parent in the nodes, or -1.
  @$pb.TagNumber(4)
  $core.int get parent => $_getIZ(3);
  @$pb.TagNumber(4)
  set parent($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParent() => $_has(3);
  @$pb.TagNumber(4)
  void clearParent() => $_clearField(4);

  /// The positions at it or beneath it.
  @$pb.TagNumber(5)
  $core.int get count => $_getIZ(4);
  @$pb.TagNumber(5)
  set count($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearCount() => $_clearField(5);

  /// A city's or a user place's centre.
  @$pb.TagNumber(6)
  $core.double get latitude => $_getN(5);
  @$pb.TagNumber(6)
  set latitude($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLatitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearLatitude() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get longitude => $_getN(6);
  @$pb.TagNumber(7)
  set longitude($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLongitude() => $_has(6);
  @$pb.TagNumber(7)
  void clearLongitude() => $_clearField(7);

  /// A city's IANA time zone.
  @$pb.TagNumber(8)
  $core.String get timezone => $_getSZ(7);
  @$pb.TagNumber(8)
  set timezone($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTimezone() => $_has(7);
  @$pb.TagNumber(8)
  void clearTimezone() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get sensitive => $_getBF(8);
  @$pb.TagNumber(9)
  set sensitive($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSensitive() => $_has(8);
  @$pb.TagNumber(9)
  void clearSensitive() => $_clearField(9);
}

/// The places found.
class GeoResolveResponse extends $pb.GeneratedMessage {
  factory GeoResolveResponse({
    $core.Iterable<GeoNode>? nodes,
    $core.Iterable<$core.int>? assignment,
  }) {
    final result = GeoResolveResponse._();
    if (nodes != null) result.nodes.addAll(nodes);
    if (assignment != null) result.assignment.addAll(assignment);
    return result;
  }

  GeoResolveResponse._();

  factory GeoResolveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoResolveResponse()..mergeFromBuffer(data, registry);
  factory GeoResolveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoResolveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoResolveResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoResolveResponse.$_createMessage)
    ..pPM<GeoNode>(1, _omitFieldNames ? '' : 'nodes',
        subBuilder: GeoNode.$_createMessage)
    ..p<$core.int>(2, _omitFieldNames ? '' : 'assignment', $pb.PbFieldType.KS3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoResolveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoResolveResponse copyWith(void Function(GeoResolveResponse) updates) =>
      super.copyWith((message) => updates(message as GeoResolveResponse))
          as GeoResolveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoResolveResponse() / GeoResolveResponse.new instead')
  static GeoResolveResponse create() => GeoResolveResponse._();
  static $pb.GeneratedMessage $_createMessage() => GeoResolveResponse._();
  @$core.override
  GeoResolveResponse createEmptyInstance() => GeoResolveResponse._();
  @$core.pragma('dart2js:noInline')
  static GeoResolveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GeoResolveResponse>(
          GeoResolveResponse.$_createMessage);
  static GeoResolveResponse? _defaultInstance;

  /// Siblings are in the requested order; a parent comes before its children.
  @$pb.TagNumber(1)
  $pb.PbList<GeoNode> get nodes => $_getList(0);

  /// One per position: the index of its deepest node, or -1 for none (at sea, off the map, or in a hidden sensitive place).
  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get assignment => $_getList(1);
}

/// The IANA time zone at a position, for resolving a capture time that has none.
class GeoTimezoneRequest extends $pb.GeneratedMessage {
  factory GeoTimezoneRequest({
    $core.int? pack,
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final result = GeoTimezoneRequest._();
    if (pack != null) result.pack = pack;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    return result;
  }

  GeoTimezoneRequest._();

  factory GeoTimezoneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoTimezoneRequest()..mergeFromBuffer(data, registry);
  factory GeoTimezoneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoTimezoneRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoTimezoneRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoTimezoneRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pack', fieldType: $pb.PbFieldType.OU3)
    ..aD(2, _omitFieldNames ? '' : 'latitude')
    ..aD(3, _omitFieldNames ? '' : 'longitude')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoTimezoneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoTimezoneRequest copyWith(void Function(GeoTimezoneRequest) updates) =>
      super.copyWith((message) => updates(message as GeoTimezoneRequest))
          as GeoTimezoneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoTimezoneRequest() / GeoTimezoneRequest.new instead')
  static GeoTimezoneRequest create() => GeoTimezoneRequest._();
  static $pb.GeneratedMessage $_createMessage() => GeoTimezoneRequest._();
  @$core.override
  GeoTimezoneRequest createEmptyInstance() => GeoTimezoneRequest._();
  @$core.pragma('dart2js:noInline')
  static GeoTimezoneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GeoTimezoneRequest>(
          GeoTimezoneRequest.$_createMessage);
  static GeoTimezoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pack => $_getIZ(0);
  @$pb.TagNumber(1)
  set pack($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get longitude => $_getN(2);
  @$pb.TagNumber(3)
  set longitude($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLongitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitude() => $_clearField(3);
}

/// The zone: a city's of the same country, else the nearest city's within 500 km, else the nautical zone (Etc/GMT+n).
class GeoTimezoneResponse extends $pb.GeneratedMessage {
  factory GeoTimezoneResponse({
    $core.String? timezone,
    $core.String? country,
  }) {
    final result = GeoTimezoneResponse._();
    if (timezone != null) result.timezone = timezone;
    if (country != null) result.country = country;
    return result;
  }

  GeoTimezoneResponse._();

  factory GeoTimezoneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoTimezoneResponse()..mergeFromBuffer(data, registry);
  factory GeoTimezoneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoTimezoneResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoTimezoneResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoTimezoneResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'timezone')
    ..aOS(2, _omitFieldNames ? '' : 'country')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoTimezoneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoTimezoneResponse copyWith(void Function(GeoTimezoneResponse) updates) =>
      super.copyWith((message) => updates(message as GeoTimezoneResponse))
          as GeoTimezoneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GeoTimezoneResponse() / GeoTimezoneResponse.new instead')
  static GeoTimezoneResponse create() => GeoTimezoneResponse._();
  static $pb.GeneratedMessage $_createMessage() => GeoTimezoneResponse._();
  @$core.override
  GeoTimezoneResponse createEmptyInstance() => GeoTimezoneResponse._();
  @$core.pragma('dart2js:noInline')
  static GeoTimezoneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GeoTimezoneResponse>(
          GeoTimezoneResponse.$_createMessage);
  static GeoTimezoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get timezone => $_getSZ(0);
  @$pb.TagNumber(1)
  set timezone($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimezone() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimezone() => $_clearField(1);

  /// The country's alpha-2 code when the position lies in one, else empty.
  @$pb.TagNumber(2)
  $core.String get country => $_getSZ(1);
  @$pb.TagNumber(2)
  set country($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCountry() => $_has(1);
  @$pb.TagNumber(2)
  void clearCountry() => $_clearField(2);
}

/// Forgets a pack.
class GeoDropRequest extends $pb.GeneratedMessage {
  factory GeoDropRequest({
    $core.int? pack,
  }) {
    final result = GeoDropRequest._();
    if (pack != null) result.pack = pack;
    return result;
  }

  GeoDropRequest._();

  factory GeoDropRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoDropRequest()..mergeFromBuffer(data, registry);
  factory GeoDropRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoDropRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoDropRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoDropRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pack', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoDropRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoDropRequest copyWith(void Function(GeoDropRequest) updates) =>
      super.copyWith((message) => updates(message as GeoDropRequest))
          as GeoDropRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoDropRequest() / GeoDropRequest.new instead')
  static GeoDropRequest create() => GeoDropRequest._();
  static $pb.GeneratedMessage $_createMessage() => GeoDropRequest._();
  @$core.override
  GeoDropRequest createEmptyInstance() => GeoDropRequest._();
  @$core.pragma('dart2js:noInline')
  static GeoDropRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoDropRequest>(
          GeoDropRequest.$_createMessage);
  static GeoDropRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pack => $_getIZ(0);
  @$pb.TagNumber(1)
  set pack($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);
}

/// Nothing: the pack is gone.
class GeoDropResponse extends $pb.GeneratedMessage {
  factory GeoDropResponse() => GeoDropResponse._();

  GeoDropResponse._();

  factory GeoDropResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoDropResponse()..mergeFromBuffer(data, registry);
  factory GeoDropResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoDropResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoDropResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'photolib.kernel.v1'),
      createEmptyInstance: GeoDropResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoDropResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoDropResponse copyWith(void Function(GeoDropResponse) updates) =>
      super.copyWith((message) => updates(message as GeoDropResponse))
          as GeoDropResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoDropResponse() / GeoDropResponse.new instead')
  static GeoDropResponse create() => GeoDropResponse._();
  static $pb.GeneratedMessage $_createMessage() => GeoDropResponse._();
  @$core.override
  GeoDropResponse createEmptyInstance() => GeoDropResponse._();
  @$core.pragma('dart2js:noInline')
  static GeoDropResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoDropResponse>(
          GeoDropResponse.$_createMessage);
  static GeoDropResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
