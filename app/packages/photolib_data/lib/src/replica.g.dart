// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replica.dart';

// ignore_for_file: type=lint
class Library extends Table with TableInfo<Library, LibraryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Library(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> privacy = GeneratedColumn<String>(
    'privacy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> access = GeneratedColumn<String>(
    'access',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> rootUri = GeneratedColumn<String>(
    'root_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> isUploadTarget = GeneratedColumn<int>(
    'is_upload_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    kind,
    privacy,
    access,
    rootUri,
    isUploadTarget,
    state,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      privacy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}privacy'],
      )!,
      access: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access'],
      )!,
      rootUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_uri'],
      ),
      isUploadTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_upload_target'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  Library createAlias(String alias) {
    return Library(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class LibraryData extends DataClass implements Insertable<LibraryData> {
  final Uint8List id;
  final Uint8List ownerId;
  final String kind;

  /// managed, external, or local for a standalone library (local:<device>)
  final String privacy;

  /// standard, private
  final String access;

  /// ro, rw
  final String? rootUri;
  final int isUploadTarget;
  final String state;

  /// online, offline, scanning, error
  final int? txid;
  const LibraryData({
    required this.id,
    required this.ownerId,
    required this.kind,
    required this.privacy,
    required this.access,
    this.rootUri,
    required this.isUploadTarget,
    required this.state,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['owner_id'] = Variable<Uint8List>(ownerId);
    map['kind'] = Variable<String>(kind);
    map['privacy'] = Variable<String>(privacy);
    map['access'] = Variable<String>(access);
    if (!nullToAbsent || rootUri != null) {
      map['root_uri'] = Variable<String>(rootUri);
    }
    map['is_upload_target'] = Variable<int>(isUploadTarget);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory LibraryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryData(
      id: serializer.fromJson<Uint8List>(json['id']),
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      kind: serializer.fromJson<String>(json['kind']),
      privacy: serializer.fromJson<String>(json['privacy']),
      access: serializer.fromJson<String>(json['access']),
      rootUri: serializer.fromJson<String?>(json['root_uri']),
      isUploadTarget: serializer.fromJson<int>(json['is_upload_target']),
      state: serializer.fromJson<String>(json['state']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'kind': serializer.toJson<String>(kind),
      'privacy': serializer.toJson<String>(privacy),
      'access': serializer.toJson<String>(access),
      'root_uri': serializer.toJson<String?>(rootUri),
      'is_upload_target': serializer.toJson<int>(isUploadTarget),
      'state': serializer.toJson<String>(state),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  LibraryData copyWith({
    Uint8List? id,
    Uint8List? ownerId,
    String? kind,
    String? privacy,
    String? access,
    Value<String?> rootUri = const Value.absent(),
    int? isUploadTarget,
    String? state,
    Value<int?> txid = const Value.absent(),
  }) => LibraryData(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    kind: kind ?? this.kind,
    privacy: privacy ?? this.privacy,
    access: access ?? this.access,
    rootUri: rootUri.present ? rootUri.value : this.rootUri,
    isUploadTarget: isUploadTarget ?? this.isUploadTarget,
    state: state ?? this.state,
    txid: txid.present ? txid.value : this.txid,
  );
  LibraryData copyWithCompanion(LibraryCompanion data) {
    return LibraryData(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      kind: data.kind.present ? data.kind.value : this.kind,
      privacy: data.privacy.present ? data.privacy.value : this.privacy,
      access: data.access.present ? data.access.value : this.access,
      rootUri: data.rootUri.present ? data.rootUri.value : this.rootUri,
      isUploadTarget: data.isUploadTarget.present
          ? data.isUploadTarget.value
          : this.isUploadTarget,
      state: data.state.present ? data.state.value : this.state,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryData(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('kind: $kind, ')
          ..write('privacy: $privacy, ')
          ..write('access: $access, ')
          ..write('rootUri: $rootUri, ')
          ..write('isUploadTarget: $isUploadTarget, ')
          ..write('state: $state, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(ownerId),
    kind,
    privacy,
    access,
    rootUri,
    isUploadTarget,
    state,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          other.kind == this.kind &&
          other.privacy == this.privacy &&
          other.access == this.access &&
          other.rootUri == this.rootUri &&
          other.isUploadTarget == this.isUploadTarget &&
          other.state == this.state &&
          other.txid == this.txid);
}

class LibraryCompanion extends UpdateCompanion<LibraryData> {
  final Value<Uint8List> id;
  final Value<Uint8List> ownerId;
  final Value<String> kind;
  final Value<String> privacy;
  final Value<String> access;
  final Value<String?> rootUri;
  final Value<int> isUploadTarget;
  final Value<String> state;
  final Value<int?> txid;
  final Value<int> rowid;
  const LibraryCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.kind = const Value.absent(),
    this.privacy = const Value.absent(),
    this.access = const Value.absent(),
    this.rootUri = const Value.absent(),
    this.isUploadTarget = const Value.absent(),
    this.state = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryCompanion.insert({
    required Uint8List id,
    required Uint8List ownerId,
    required String kind,
    required String privacy,
    required String access,
    this.rootUri = const Value.absent(),
    this.isUploadTarget = const Value.absent(),
    required String state,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       kind = Value(kind),
       privacy = Value(privacy),
       access = Value(access),
       state = Value(state);
  static Insertable<LibraryData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? ownerId,
    Expression<String>? kind,
    Expression<String>? privacy,
    Expression<String>? access,
    Expression<String>? rootUri,
    Expression<int>? isUploadTarget,
    Expression<String>? state,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (kind != null) 'kind': kind,
      if (privacy != null) 'privacy': privacy,
      if (access != null) 'access': access,
      if (rootUri != null) 'root_uri': rootUri,
      if (isUploadTarget != null) 'is_upload_target': isUploadTarget,
      if (state != null) 'state': state,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? ownerId,
    Value<String>? kind,
    Value<String>? privacy,
    Value<String>? access,
    Value<String?>? rootUri,
    Value<int>? isUploadTarget,
    Value<String>? state,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return LibraryCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      kind: kind ?? this.kind,
      privacy: privacy ?? this.privacy,
      access: access ?? this.access,
      rootUri: rootUri ?? this.rootUri,
      isUploadTarget: isUploadTarget ?? this.isUploadTarget,
      state: state ?? this.state,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (privacy.present) {
      map['privacy'] = Variable<String>(privacy.value);
    }
    if (access.present) {
      map['access'] = Variable<String>(access.value);
    }
    if (rootUri.present) {
      map['root_uri'] = Variable<String>(rootUri.value);
    }
    if (isUploadTarget.present) {
      map['is_upload_target'] = Variable<int>(isUploadTarget.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('kind: $kind, ')
          ..write('privacy: $privacy, ')
          ..write('access: $access, ')
          ..write('rootUri: $rootUri, ')
          ..write('isUploadTarget: $isUploadTarget, ')
          ..write('state: $state, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Asset extends Table with TableInfo<Asset, AssetData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Asset(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> libraryId = GeneratedColumn<Uint8List>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> originalFilename = GeneratedColumn<String>(
    'original_filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> contentHash =
      GeneratedColumn<Uint8List>(
        'content_hash',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<String> mediaKind = GeneratedColumn<String>(
    'media_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> facets = GeneratedColumn<String>(
    'facets',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumn<String> takenLocal = GeneratedColumn<String>(
    'taken_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> tzOffsetMin = GeneratedColumn<int>(
    'tz_offset_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> tzName = GeneratedColumn<String>(
    'tz_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> takenUtc = GeneratedColumn<int>(
    'taken_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> timeSource = GeneratedColumn<String>(
    'time_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'unknown\'',
    defaultValue: const CustomExpression('\'unknown\''),
  );
  late final GeneratedColumn<int> timeConfidence = GeneratedColumn<int>(
    'time_confidence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> timePrecision = GeneratedColumn<String>(
    'time_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> tzAssumed = GeneratedColumn<int>(
    'tz_assumed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<double> alt = GeneratedColumn<double>(
    'alt',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<double> accuracyM = GeneratedColumn<double>(
    'accuracy_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> locationSource = GeneratedColumn<String>(
    'location_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> placeId = GeneratedColumn<Uint8List>(
    'place_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> orientation = GeneratedColumn<int>(
    'orientation',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> fileSizeTotal = GeneratedColumn<int>(
    'file_size_total',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> lens = GeneratedColumn<String>(
    'lens',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> colorLabel = GeneratedColumn<String>(
    'color_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> locked = GeneratedColumn<int>(
    'locked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> trashedAt = GeneratedColumn<int>(
    'trashed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> stackId = GeneratedColumn<Uint8List>(
    'stack_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> stackOrder = GeneratedColumn<int>(
    'stack_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> currentVersionId =
      GeneratedColumn<Uint8List>(
        'current_version_id',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<double> fps = GeneratedColumn<double>(
    'fps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> thumbhash = GeneratedColumn<Uint8List>(
    'thumbhash',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> onDevice = GeneratedColumn<int>(
    'on_device',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    libraryId,
    ownerId,
    originalFilename,
    source,
    sourceRef,
    contentHash,
    mediaKind,
    facets,
    takenLocal,
    tzOffsetMin,
    tzName,
    takenUtc,
    timeSource,
    timeConfidence,
    timePrecision,
    tzAssumed,
    lat,
    lon,
    alt,
    accuracyM,
    locationSource,
    placeId,
    width,
    height,
    orientation,
    durationMs,
    fileSizeTotal,
    make,
    model,
    lens,
    title,
    description,
    rating,
    colorLabel,
    archived,
    locked,
    trashedAt,
    stackId,
    stackOrder,
    currentVersionId,
    createdAt,
    txid,
    fps,
    thumbhash,
    onDevice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}library_id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      originalFilename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_filename'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      ),
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content_hash'],
      ),
      mediaKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_kind'],
      )!,
      facets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facets'],
      )!,
      takenLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}taken_local'],
      ),
      tzOffsetMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tz_offset_min'],
      ),
      tzName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tz_name'],
      ),
      takenUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taken_utc'],
      ),
      timeSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_source'],
      )!,
      timeConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_confidence'],
      )!,
      timePrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_precision'],
      ),
      tzAssumed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tz_assumed'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      ),
      alt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}alt'],
      ),
      accuracyM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_m'],
      ),
      locationSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_source'],
      ),
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}place_id'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      orientation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orientation'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      fileSizeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_total'],
      ),
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      lens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lens'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      colorLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_label'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      locked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}locked'],
      )!,
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trashed_at'],
      ),
      stackId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}stack_id'],
      ),
      stackOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stack_order'],
      ),
      currentVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}current_version_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
      fps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fps'],
      ),
      thumbhash: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumbhash'],
      ),
      onDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}on_device'],
      )!,
    );
  }

  @override
  Asset createAlias(String alias) {
    return Asset(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AssetData extends DataClass implements Insertable<AssetData> {
  final Uint8List id;
  final Uint8List libraryId;
  final Uint8List ownerId;
  final String originalFilename;
  final String source;

  /// upload, scan, import, edit-copy
  final String? sourceRef;
  final Uint8List? contentHash;
  final String mediaKind;

  /// image, video
  final String facets;

  /// comma-separated: live, motion_photo, animated, panorama, raw, …
  final String? takenLocal;

  /// naive ISO 8601 date-time
  final int? tzOffsetMin;
  final String? tzName;
  final int? takenUtc;
  final String timeSource;
  final int timeConfidence;
  final String? timePrecision;

  /// year, month, day, minute, second, ms
  final int tzAssumed;
  final double? lat;
  final double? lon;
  final double? alt;
  final double? accuracyM;
  final String? locationSource;

  /// exif, sidecar, user, import, estimated
  final Uint8List? placeId;
  final int? width;
  final int? height;
  final int? orientation;
  final int? durationMs;
  final int? fileSizeTotal;
  final String? make;
  final String? model;
  final String? lens;
  final String? title;
  final String? description;
  final int rating;

  /// -1 reject, 0 to 5
  final String? colorLabel;
  final int archived;
  final int locked;
  final int? trashedAt;
  final Uint8List? stackId;
  final int? stackOrder;
  final Uint8List? currentVersionId;
  final int createdAt;
  final int? txid;

  /// Schema 16: a video's frames a second, which ingest read (assets.fps), which the viewer steps by.
  final double? fps;

  /// Schema 22: the ThumbHash of its smallest rendition, which a cell paints until the server's thumbnail shows
  /// (docs/10-client-app.md §3.4, T0).
  final Uint8List? thumbhash;

  /// Schema 27, device-only: a present item of the device index links it, and so shows it (local_asset.tile).
  final int onDevice;
  const AssetData({
    required this.id,
    required this.libraryId,
    required this.ownerId,
    required this.originalFilename,
    required this.source,
    this.sourceRef,
    this.contentHash,
    required this.mediaKind,
    required this.facets,
    this.takenLocal,
    this.tzOffsetMin,
    this.tzName,
    this.takenUtc,
    required this.timeSource,
    required this.timeConfidence,
    this.timePrecision,
    required this.tzAssumed,
    this.lat,
    this.lon,
    this.alt,
    this.accuracyM,
    this.locationSource,
    this.placeId,
    this.width,
    this.height,
    this.orientation,
    this.durationMs,
    this.fileSizeTotal,
    this.make,
    this.model,
    this.lens,
    this.title,
    this.description,
    required this.rating,
    this.colorLabel,
    required this.archived,
    required this.locked,
    this.trashedAt,
    this.stackId,
    this.stackOrder,
    this.currentVersionId,
    required this.createdAt,
    this.txid,
    this.fps,
    this.thumbhash,
    required this.onDevice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['library_id'] = Variable<Uint8List>(libraryId);
    map['owner_id'] = Variable<Uint8List>(ownerId);
    map['original_filename'] = Variable<String>(originalFilename);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceRef != null) {
      map['source_ref'] = Variable<String>(sourceRef);
    }
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<Uint8List>(contentHash);
    }
    map['media_kind'] = Variable<String>(mediaKind);
    map['facets'] = Variable<String>(facets);
    if (!nullToAbsent || takenLocal != null) {
      map['taken_local'] = Variable<String>(takenLocal);
    }
    if (!nullToAbsent || tzOffsetMin != null) {
      map['tz_offset_min'] = Variable<int>(tzOffsetMin);
    }
    if (!nullToAbsent || tzName != null) {
      map['tz_name'] = Variable<String>(tzName);
    }
    if (!nullToAbsent || takenUtc != null) {
      map['taken_utc'] = Variable<int>(takenUtc);
    }
    map['time_source'] = Variable<String>(timeSource);
    map['time_confidence'] = Variable<int>(timeConfidence);
    if (!nullToAbsent || timePrecision != null) {
      map['time_precision'] = Variable<String>(timePrecision);
    }
    map['tz_assumed'] = Variable<int>(tzAssumed);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lon != null) {
      map['lon'] = Variable<double>(lon);
    }
    if (!nullToAbsent || alt != null) {
      map['alt'] = Variable<double>(alt);
    }
    if (!nullToAbsent || accuracyM != null) {
      map['accuracy_m'] = Variable<double>(accuracyM);
    }
    if (!nullToAbsent || locationSource != null) {
      map['location_source'] = Variable<String>(locationSource);
    }
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<Uint8List>(placeId);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || orientation != null) {
      map['orientation'] = Variable<int>(orientation);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || fileSizeTotal != null) {
      map['file_size_total'] = Variable<int>(fileSizeTotal);
    }
    if (!nullToAbsent || make != null) {
      map['make'] = Variable<String>(make);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || lens != null) {
      map['lens'] = Variable<String>(lens);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['rating'] = Variable<int>(rating);
    if (!nullToAbsent || colorLabel != null) {
      map['color_label'] = Variable<String>(colorLabel);
    }
    map['archived'] = Variable<int>(archived);
    map['locked'] = Variable<int>(locked);
    if (!nullToAbsent || trashedAt != null) {
      map['trashed_at'] = Variable<int>(trashedAt);
    }
    if (!nullToAbsent || stackId != null) {
      map['stack_id'] = Variable<Uint8List>(stackId);
    }
    if (!nullToAbsent || stackOrder != null) {
      map['stack_order'] = Variable<int>(stackOrder);
    }
    if (!nullToAbsent || currentVersionId != null) {
      map['current_version_id'] = Variable<Uint8List>(currentVersionId);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    if (!nullToAbsent || fps != null) {
      map['fps'] = Variable<double>(fps);
    }
    if (!nullToAbsent || thumbhash != null) {
      map['thumbhash'] = Variable<Uint8List>(thumbhash);
    }
    map['on_device'] = Variable<int>(onDevice);
    return map;
  }

  factory AssetData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetData(
      id: serializer.fromJson<Uint8List>(json['id']),
      libraryId: serializer.fromJson<Uint8List>(json['library_id']),
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      originalFilename: serializer.fromJson<String>(json['original_filename']),
      source: serializer.fromJson<String>(json['source']),
      sourceRef: serializer.fromJson<String?>(json['source_ref']),
      contentHash: serializer.fromJson<Uint8List?>(json['content_hash']),
      mediaKind: serializer.fromJson<String>(json['media_kind']),
      facets: serializer.fromJson<String>(json['facets']),
      takenLocal: serializer.fromJson<String?>(json['taken_local']),
      tzOffsetMin: serializer.fromJson<int?>(json['tz_offset_min']),
      tzName: serializer.fromJson<String?>(json['tz_name']),
      takenUtc: serializer.fromJson<int?>(json['taken_utc']),
      timeSource: serializer.fromJson<String>(json['time_source']),
      timeConfidence: serializer.fromJson<int>(json['time_confidence']),
      timePrecision: serializer.fromJson<String?>(json['time_precision']),
      tzAssumed: serializer.fromJson<int>(json['tz_assumed']),
      lat: serializer.fromJson<double?>(json['lat']),
      lon: serializer.fromJson<double?>(json['lon']),
      alt: serializer.fromJson<double?>(json['alt']),
      accuracyM: serializer.fromJson<double?>(json['accuracy_m']),
      locationSource: serializer.fromJson<String?>(json['location_source']),
      placeId: serializer.fromJson<Uint8List?>(json['place_id']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      orientation: serializer.fromJson<int?>(json['orientation']),
      durationMs: serializer.fromJson<int?>(json['duration_ms']),
      fileSizeTotal: serializer.fromJson<int?>(json['file_size_total']),
      make: serializer.fromJson<String?>(json['make']),
      model: serializer.fromJson<String?>(json['model']),
      lens: serializer.fromJson<String?>(json['lens']),
      title: serializer.fromJson<String?>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      rating: serializer.fromJson<int>(json['rating']),
      colorLabel: serializer.fromJson<String?>(json['color_label']),
      archived: serializer.fromJson<int>(json['archived']),
      locked: serializer.fromJson<int>(json['locked']),
      trashedAt: serializer.fromJson<int?>(json['trashed_at']),
      stackId: serializer.fromJson<Uint8List?>(json['stack_id']),
      stackOrder: serializer.fromJson<int?>(json['stack_order']),
      currentVersionId: serializer.fromJson<Uint8List?>(
        json['current_version_id'],
      ),
      createdAt: serializer.fromJson<int>(json['created_at']),
      txid: serializer.fromJson<int?>(json['txid']),
      fps: serializer.fromJson<double?>(json['fps']),
      thumbhash: serializer.fromJson<Uint8List?>(json['thumbhash']),
      onDevice: serializer.fromJson<int>(json['on_device']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'library_id': serializer.toJson<Uint8List>(libraryId),
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'original_filename': serializer.toJson<String>(originalFilename),
      'source': serializer.toJson<String>(source),
      'source_ref': serializer.toJson<String?>(sourceRef),
      'content_hash': serializer.toJson<Uint8List?>(contentHash),
      'media_kind': serializer.toJson<String>(mediaKind),
      'facets': serializer.toJson<String>(facets),
      'taken_local': serializer.toJson<String?>(takenLocal),
      'tz_offset_min': serializer.toJson<int?>(tzOffsetMin),
      'tz_name': serializer.toJson<String?>(tzName),
      'taken_utc': serializer.toJson<int?>(takenUtc),
      'time_source': serializer.toJson<String>(timeSource),
      'time_confidence': serializer.toJson<int>(timeConfidence),
      'time_precision': serializer.toJson<String?>(timePrecision),
      'tz_assumed': serializer.toJson<int>(tzAssumed),
      'lat': serializer.toJson<double?>(lat),
      'lon': serializer.toJson<double?>(lon),
      'alt': serializer.toJson<double?>(alt),
      'accuracy_m': serializer.toJson<double?>(accuracyM),
      'location_source': serializer.toJson<String?>(locationSource),
      'place_id': serializer.toJson<Uint8List?>(placeId),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'orientation': serializer.toJson<int?>(orientation),
      'duration_ms': serializer.toJson<int?>(durationMs),
      'file_size_total': serializer.toJson<int?>(fileSizeTotal),
      'make': serializer.toJson<String?>(make),
      'model': serializer.toJson<String?>(model),
      'lens': serializer.toJson<String?>(lens),
      'title': serializer.toJson<String?>(title),
      'description': serializer.toJson<String?>(description),
      'rating': serializer.toJson<int>(rating),
      'color_label': serializer.toJson<String?>(colorLabel),
      'archived': serializer.toJson<int>(archived),
      'locked': serializer.toJson<int>(locked),
      'trashed_at': serializer.toJson<int?>(trashedAt),
      'stack_id': serializer.toJson<Uint8List?>(stackId),
      'stack_order': serializer.toJson<int?>(stackOrder),
      'current_version_id': serializer.toJson<Uint8List?>(currentVersionId),
      'created_at': serializer.toJson<int>(createdAt),
      'txid': serializer.toJson<int?>(txid),
      'fps': serializer.toJson<double?>(fps),
      'thumbhash': serializer.toJson<Uint8List?>(thumbhash),
      'on_device': serializer.toJson<int>(onDevice),
    };
  }

  AssetData copyWith({
    Uint8List? id,
    Uint8List? libraryId,
    Uint8List? ownerId,
    String? originalFilename,
    String? source,
    Value<String?> sourceRef = const Value.absent(),
    Value<Uint8List?> contentHash = const Value.absent(),
    String? mediaKind,
    String? facets,
    Value<String?> takenLocal = const Value.absent(),
    Value<int?> tzOffsetMin = const Value.absent(),
    Value<String?> tzName = const Value.absent(),
    Value<int?> takenUtc = const Value.absent(),
    String? timeSource,
    int? timeConfidence,
    Value<String?> timePrecision = const Value.absent(),
    int? tzAssumed,
    Value<double?> lat = const Value.absent(),
    Value<double?> lon = const Value.absent(),
    Value<double?> alt = const Value.absent(),
    Value<double?> accuracyM = const Value.absent(),
    Value<String?> locationSource = const Value.absent(),
    Value<Uint8List?> placeId = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> orientation = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<int?> fileSizeTotal = const Value.absent(),
    Value<String?> make = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> lens = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? rating,
    Value<String?> colorLabel = const Value.absent(),
    int? archived,
    int? locked,
    Value<int?> trashedAt = const Value.absent(),
    Value<Uint8List?> stackId = const Value.absent(),
    Value<int?> stackOrder = const Value.absent(),
    Value<Uint8List?> currentVersionId = const Value.absent(),
    int? createdAt,
    Value<int?> txid = const Value.absent(),
    Value<double?> fps = const Value.absent(),
    Value<Uint8List?> thumbhash = const Value.absent(),
    int? onDevice,
  }) => AssetData(
    id: id ?? this.id,
    libraryId: libraryId ?? this.libraryId,
    ownerId: ownerId ?? this.ownerId,
    originalFilename: originalFilename ?? this.originalFilename,
    source: source ?? this.source,
    sourceRef: sourceRef.present ? sourceRef.value : this.sourceRef,
    contentHash: contentHash.present ? contentHash.value : this.contentHash,
    mediaKind: mediaKind ?? this.mediaKind,
    facets: facets ?? this.facets,
    takenLocal: takenLocal.present ? takenLocal.value : this.takenLocal,
    tzOffsetMin: tzOffsetMin.present ? tzOffsetMin.value : this.tzOffsetMin,
    tzName: tzName.present ? tzName.value : this.tzName,
    takenUtc: takenUtc.present ? takenUtc.value : this.takenUtc,
    timeSource: timeSource ?? this.timeSource,
    timeConfidence: timeConfidence ?? this.timeConfidence,
    timePrecision: timePrecision.present
        ? timePrecision.value
        : this.timePrecision,
    tzAssumed: tzAssumed ?? this.tzAssumed,
    lat: lat.present ? lat.value : this.lat,
    lon: lon.present ? lon.value : this.lon,
    alt: alt.present ? alt.value : this.alt,
    accuracyM: accuracyM.present ? accuracyM.value : this.accuracyM,
    locationSource: locationSource.present
        ? locationSource.value
        : this.locationSource,
    placeId: placeId.present ? placeId.value : this.placeId,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    orientation: orientation.present ? orientation.value : this.orientation,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    fileSizeTotal: fileSizeTotal.present
        ? fileSizeTotal.value
        : this.fileSizeTotal,
    make: make.present ? make.value : this.make,
    model: model.present ? model.value : this.model,
    lens: lens.present ? lens.value : this.lens,
    title: title.present ? title.value : this.title,
    description: description.present ? description.value : this.description,
    rating: rating ?? this.rating,
    colorLabel: colorLabel.present ? colorLabel.value : this.colorLabel,
    archived: archived ?? this.archived,
    locked: locked ?? this.locked,
    trashedAt: trashedAt.present ? trashedAt.value : this.trashedAt,
    stackId: stackId.present ? stackId.value : this.stackId,
    stackOrder: stackOrder.present ? stackOrder.value : this.stackOrder,
    currentVersionId: currentVersionId.present
        ? currentVersionId.value
        : this.currentVersionId,
    createdAt: createdAt ?? this.createdAt,
    txid: txid.present ? txid.value : this.txid,
    fps: fps.present ? fps.value : this.fps,
    thumbhash: thumbhash.present ? thumbhash.value : this.thumbhash,
    onDevice: onDevice ?? this.onDevice,
  );
  AssetData copyWithCompanion(AssetCompanion data) {
    return AssetData(
      id: data.id.present ? data.id.value : this.id,
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      originalFilename: data.originalFilename.present
          ? data.originalFilename.value
          : this.originalFilename,
      source: data.source.present ? data.source.value : this.source,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      mediaKind: data.mediaKind.present ? data.mediaKind.value : this.mediaKind,
      facets: data.facets.present ? data.facets.value : this.facets,
      takenLocal: data.takenLocal.present
          ? data.takenLocal.value
          : this.takenLocal,
      tzOffsetMin: data.tzOffsetMin.present
          ? data.tzOffsetMin.value
          : this.tzOffsetMin,
      tzName: data.tzName.present ? data.tzName.value : this.tzName,
      takenUtc: data.takenUtc.present ? data.takenUtc.value : this.takenUtc,
      timeSource: data.timeSource.present
          ? data.timeSource.value
          : this.timeSource,
      timeConfidence: data.timeConfidence.present
          ? data.timeConfidence.value
          : this.timeConfidence,
      timePrecision: data.timePrecision.present
          ? data.timePrecision.value
          : this.timePrecision,
      tzAssumed: data.tzAssumed.present ? data.tzAssumed.value : this.tzAssumed,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      alt: data.alt.present ? data.alt.value : this.alt,
      accuracyM: data.accuracyM.present ? data.accuracyM.value : this.accuracyM,
      locationSource: data.locationSource.present
          ? data.locationSource.value
          : this.locationSource,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      orientation: data.orientation.present
          ? data.orientation.value
          : this.orientation,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      fileSizeTotal: data.fileSizeTotal.present
          ? data.fileSizeTotal.value
          : this.fileSizeTotal,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      lens: data.lens.present ? data.lens.value : this.lens,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      rating: data.rating.present ? data.rating.value : this.rating,
      colorLabel: data.colorLabel.present
          ? data.colorLabel.value
          : this.colorLabel,
      archived: data.archived.present ? data.archived.value : this.archived,
      locked: data.locked.present ? data.locked.value : this.locked,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
      stackId: data.stackId.present ? data.stackId.value : this.stackId,
      stackOrder: data.stackOrder.present
          ? data.stackOrder.value
          : this.stackOrder,
      currentVersionId: data.currentVersionId.present
          ? data.currentVersionId.value
          : this.currentVersionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      txid: data.txid.present ? data.txid.value : this.txid,
      fps: data.fps.present ? data.fps.value : this.fps,
      thumbhash: data.thumbhash.present ? data.thumbhash.value : this.thumbhash,
      onDevice: data.onDevice.present ? data.onDevice.value : this.onDevice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetData(')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('ownerId: $ownerId, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('source: $source, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('contentHash: $contentHash, ')
          ..write('mediaKind: $mediaKind, ')
          ..write('facets: $facets, ')
          ..write('takenLocal: $takenLocal, ')
          ..write('tzOffsetMin: $tzOffsetMin, ')
          ..write('tzName: $tzName, ')
          ..write('takenUtc: $takenUtc, ')
          ..write('timeSource: $timeSource, ')
          ..write('timeConfidence: $timeConfidence, ')
          ..write('timePrecision: $timePrecision, ')
          ..write('tzAssumed: $tzAssumed, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('alt: $alt, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('locationSource: $locationSource, ')
          ..write('placeId: $placeId, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('orientation: $orientation, ')
          ..write('durationMs: $durationMs, ')
          ..write('fileSizeTotal: $fileSizeTotal, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('lens: $lens, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rating: $rating, ')
          ..write('colorLabel: $colorLabel, ')
          ..write('archived: $archived, ')
          ..write('locked: $locked, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('stackId: $stackId, ')
          ..write('stackOrder: $stackOrder, ')
          ..write('currentVersionId: $currentVersionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid, ')
          ..write('fps: $fps, ')
          ..write('thumbhash: $thumbhash, ')
          ..write('onDevice: $onDevice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(libraryId),
    $driftBlobEquality.hash(ownerId),
    originalFilename,
    source,
    sourceRef,
    $driftBlobEquality.hash(contentHash),
    mediaKind,
    facets,
    takenLocal,
    tzOffsetMin,
    tzName,
    takenUtc,
    timeSource,
    timeConfidence,
    timePrecision,
    tzAssumed,
    lat,
    lon,
    alt,
    accuracyM,
    locationSource,
    $driftBlobEquality.hash(placeId),
    width,
    height,
    orientation,
    durationMs,
    fileSizeTotal,
    make,
    model,
    lens,
    title,
    description,
    rating,
    colorLabel,
    archived,
    locked,
    trashedAt,
    $driftBlobEquality.hash(stackId),
    stackOrder,
    $driftBlobEquality.hash(currentVersionId),
    createdAt,
    txid,
    fps,
    $driftBlobEquality.hash(thumbhash),
    onDevice,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.libraryId, this.libraryId) &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          other.originalFilename == this.originalFilename &&
          other.source == this.source &&
          other.sourceRef == this.sourceRef &&
          $driftBlobEquality.equals(other.contentHash, this.contentHash) &&
          other.mediaKind == this.mediaKind &&
          other.facets == this.facets &&
          other.takenLocal == this.takenLocal &&
          other.tzOffsetMin == this.tzOffsetMin &&
          other.tzName == this.tzName &&
          other.takenUtc == this.takenUtc &&
          other.timeSource == this.timeSource &&
          other.timeConfidence == this.timeConfidence &&
          other.timePrecision == this.timePrecision &&
          other.tzAssumed == this.tzAssumed &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.alt == this.alt &&
          other.accuracyM == this.accuracyM &&
          other.locationSource == this.locationSource &&
          $driftBlobEquality.equals(other.placeId, this.placeId) &&
          other.width == this.width &&
          other.height == this.height &&
          other.orientation == this.orientation &&
          other.durationMs == this.durationMs &&
          other.fileSizeTotal == this.fileSizeTotal &&
          other.make == this.make &&
          other.model == this.model &&
          other.lens == this.lens &&
          other.title == this.title &&
          other.description == this.description &&
          other.rating == this.rating &&
          other.colorLabel == this.colorLabel &&
          other.archived == this.archived &&
          other.locked == this.locked &&
          other.trashedAt == this.trashedAt &&
          $driftBlobEquality.equals(other.stackId, this.stackId) &&
          other.stackOrder == this.stackOrder &&
          $driftBlobEquality.equals(
            other.currentVersionId,
            this.currentVersionId,
          ) &&
          other.createdAt == this.createdAt &&
          other.txid == this.txid &&
          other.fps == this.fps &&
          $driftBlobEquality.equals(other.thumbhash, this.thumbhash) &&
          other.onDevice == this.onDevice);
}

class AssetCompanion extends UpdateCompanion<AssetData> {
  final Value<Uint8List> id;
  final Value<Uint8List> libraryId;
  final Value<Uint8List> ownerId;
  final Value<String> originalFilename;
  final Value<String> source;
  final Value<String?> sourceRef;
  final Value<Uint8List?> contentHash;
  final Value<String> mediaKind;
  final Value<String> facets;
  final Value<String?> takenLocal;
  final Value<int?> tzOffsetMin;
  final Value<String?> tzName;
  final Value<int?> takenUtc;
  final Value<String> timeSource;
  final Value<int> timeConfidence;
  final Value<String?> timePrecision;
  final Value<int> tzAssumed;
  final Value<double?> lat;
  final Value<double?> lon;
  final Value<double?> alt;
  final Value<double?> accuracyM;
  final Value<String?> locationSource;
  final Value<Uint8List?> placeId;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> orientation;
  final Value<int?> durationMs;
  final Value<int?> fileSizeTotal;
  final Value<String?> make;
  final Value<String?> model;
  final Value<String?> lens;
  final Value<String?> title;
  final Value<String?> description;
  final Value<int> rating;
  final Value<String?> colorLabel;
  final Value<int> archived;
  final Value<int> locked;
  final Value<int?> trashedAt;
  final Value<Uint8List?> stackId;
  final Value<int?> stackOrder;
  final Value<Uint8List?> currentVersionId;
  final Value<int> createdAt;
  final Value<int?> txid;
  final Value<double?> fps;
  final Value<Uint8List?> thumbhash;
  final Value<int> onDevice;
  final Value<int> rowid;
  const AssetCompanion({
    this.id = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.originalFilename = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.mediaKind = const Value.absent(),
    this.facets = const Value.absent(),
    this.takenLocal = const Value.absent(),
    this.tzOffsetMin = const Value.absent(),
    this.tzName = const Value.absent(),
    this.takenUtc = const Value.absent(),
    this.timeSource = const Value.absent(),
    this.timeConfidence = const Value.absent(),
    this.timePrecision = const Value.absent(),
    this.tzAssumed = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.alt = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.locationSource = const Value.absent(),
    this.placeId = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.orientation = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.fileSizeTotal = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.lens = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rating = const Value.absent(),
    this.colorLabel = const Value.absent(),
    this.archived = const Value.absent(),
    this.locked = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.stackId = const Value.absent(),
    this.stackOrder = const Value.absent(),
    this.currentVersionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.txid = const Value.absent(),
    this.fps = const Value.absent(),
    this.thumbhash = const Value.absent(),
    this.onDevice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetCompanion.insert({
    required Uint8List id,
    required Uint8List libraryId,
    required Uint8List ownerId,
    required String originalFilename,
    required String source,
    this.sourceRef = const Value.absent(),
    this.contentHash = const Value.absent(),
    required String mediaKind,
    this.facets = const Value.absent(),
    this.takenLocal = const Value.absent(),
    this.tzOffsetMin = const Value.absent(),
    this.tzName = const Value.absent(),
    this.takenUtc = const Value.absent(),
    this.timeSource = const Value.absent(),
    this.timeConfidence = const Value.absent(),
    this.timePrecision = const Value.absent(),
    this.tzAssumed = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.alt = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.locationSource = const Value.absent(),
    this.placeId = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.orientation = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.fileSizeTotal = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.lens = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rating = const Value.absent(),
    this.colorLabel = const Value.absent(),
    this.archived = const Value.absent(),
    this.locked = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.stackId = const Value.absent(),
    this.stackOrder = const Value.absent(),
    this.currentVersionId = const Value.absent(),
    required int createdAt,
    this.txid = const Value.absent(),
    this.fps = const Value.absent(),
    this.thumbhash = const Value.absent(),
    this.onDevice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       libraryId = Value(libraryId),
       ownerId = Value(ownerId),
       originalFilename = Value(originalFilename),
       source = Value(source),
       mediaKind = Value(mediaKind),
       createdAt = Value(createdAt);
  static Insertable<AssetData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? libraryId,
    Expression<Uint8List>? ownerId,
    Expression<String>? originalFilename,
    Expression<String>? source,
    Expression<String>? sourceRef,
    Expression<Uint8List>? contentHash,
    Expression<String>? mediaKind,
    Expression<String>? facets,
    Expression<String>? takenLocal,
    Expression<int>? tzOffsetMin,
    Expression<String>? tzName,
    Expression<int>? takenUtc,
    Expression<String>? timeSource,
    Expression<int>? timeConfidence,
    Expression<String>? timePrecision,
    Expression<int>? tzAssumed,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? alt,
    Expression<double>? accuracyM,
    Expression<String>? locationSource,
    Expression<Uint8List>? placeId,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? orientation,
    Expression<int>? durationMs,
    Expression<int>? fileSizeTotal,
    Expression<String>? make,
    Expression<String>? model,
    Expression<String>? lens,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? rating,
    Expression<String>? colorLabel,
    Expression<int>? archived,
    Expression<int>? locked,
    Expression<int>? trashedAt,
    Expression<Uint8List>? stackId,
    Expression<int>? stackOrder,
    Expression<Uint8List>? currentVersionId,
    Expression<int>? createdAt,
    Expression<int>? txid,
    Expression<double>? fps,
    Expression<Uint8List>? thumbhash,
    Expression<int>? onDevice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (libraryId != null) 'library_id': libraryId,
      if (ownerId != null) 'owner_id': ownerId,
      if (originalFilename != null) 'original_filename': originalFilename,
      if (source != null) 'source': source,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (contentHash != null) 'content_hash': contentHash,
      if (mediaKind != null) 'media_kind': mediaKind,
      if (facets != null) 'facets': facets,
      if (takenLocal != null) 'taken_local': takenLocal,
      if (tzOffsetMin != null) 'tz_offset_min': tzOffsetMin,
      if (tzName != null) 'tz_name': tzName,
      if (takenUtc != null) 'taken_utc': takenUtc,
      if (timeSource != null) 'time_source': timeSource,
      if (timeConfidence != null) 'time_confidence': timeConfidence,
      if (timePrecision != null) 'time_precision': timePrecision,
      if (tzAssumed != null) 'tz_assumed': tzAssumed,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (alt != null) 'alt': alt,
      if (accuracyM != null) 'accuracy_m': accuracyM,
      if (locationSource != null) 'location_source': locationSource,
      if (placeId != null) 'place_id': placeId,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (orientation != null) 'orientation': orientation,
      if (durationMs != null) 'duration_ms': durationMs,
      if (fileSizeTotal != null) 'file_size_total': fileSizeTotal,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (lens != null) 'lens': lens,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (rating != null) 'rating': rating,
      if (colorLabel != null) 'color_label': colorLabel,
      if (archived != null) 'archived': archived,
      if (locked != null) 'locked': locked,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (stackId != null) 'stack_id': stackId,
      if (stackOrder != null) 'stack_order': stackOrder,
      if (currentVersionId != null) 'current_version_id': currentVersionId,
      if (createdAt != null) 'created_at': createdAt,
      if (txid != null) 'txid': txid,
      if (fps != null) 'fps': fps,
      if (thumbhash != null) 'thumbhash': thumbhash,
      if (onDevice != null) 'on_device': onDevice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? libraryId,
    Value<Uint8List>? ownerId,
    Value<String>? originalFilename,
    Value<String>? source,
    Value<String?>? sourceRef,
    Value<Uint8List?>? contentHash,
    Value<String>? mediaKind,
    Value<String>? facets,
    Value<String?>? takenLocal,
    Value<int?>? tzOffsetMin,
    Value<String?>? tzName,
    Value<int?>? takenUtc,
    Value<String>? timeSource,
    Value<int>? timeConfidence,
    Value<String?>? timePrecision,
    Value<int>? tzAssumed,
    Value<double?>? lat,
    Value<double?>? lon,
    Value<double?>? alt,
    Value<double?>? accuracyM,
    Value<String?>? locationSource,
    Value<Uint8List?>? placeId,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? orientation,
    Value<int?>? durationMs,
    Value<int?>? fileSizeTotal,
    Value<String?>? make,
    Value<String?>? model,
    Value<String?>? lens,
    Value<String?>? title,
    Value<String?>? description,
    Value<int>? rating,
    Value<String?>? colorLabel,
    Value<int>? archived,
    Value<int>? locked,
    Value<int?>? trashedAt,
    Value<Uint8List?>? stackId,
    Value<int?>? stackOrder,
    Value<Uint8List?>? currentVersionId,
    Value<int>? createdAt,
    Value<int?>? txid,
    Value<double?>? fps,
    Value<Uint8List?>? thumbhash,
    Value<int>? onDevice,
    Value<int>? rowid,
  }) {
    return AssetCompanion(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      ownerId: ownerId ?? this.ownerId,
      originalFilename: originalFilename ?? this.originalFilename,
      source: source ?? this.source,
      sourceRef: sourceRef ?? this.sourceRef,
      contentHash: contentHash ?? this.contentHash,
      mediaKind: mediaKind ?? this.mediaKind,
      facets: facets ?? this.facets,
      takenLocal: takenLocal ?? this.takenLocal,
      tzOffsetMin: tzOffsetMin ?? this.tzOffsetMin,
      tzName: tzName ?? this.tzName,
      takenUtc: takenUtc ?? this.takenUtc,
      timeSource: timeSource ?? this.timeSource,
      timeConfidence: timeConfidence ?? this.timeConfidence,
      timePrecision: timePrecision ?? this.timePrecision,
      tzAssumed: tzAssumed ?? this.tzAssumed,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      alt: alt ?? this.alt,
      accuracyM: accuracyM ?? this.accuracyM,
      locationSource: locationSource ?? this.locationSource,
      placeId: placeId ?? this.placeId,
      width: width ?? this.width,
      height: height ?? this.height,
      orientation: orientation ?? this.orientation,
      durationMs: durationMs ?? this.durationMs,
      fileSizeTotal: fileSizeTotal ?? this.fileSizeTotal,
      make: make ?? this.make,
      model: model ?? this.model,
      lens: lens ?? this.lens,
      title: title ?? this.title,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      colorLabel: colorLabel ?? this.colorLabel,
      archived: archived ?? this.archived,
      locked: locked ?? this.locked,
      trashedAt: trashedAt ?? this.trashedAt,
      stackId: stackId ?? this.stackId,
      stackOrder: stackOrder ?? this.stackOrder,
      currentVersionId: currentVersionId ?? this.currentVersionId,
      createdAt: createdAt ?? this.createdAt,
      txid: txid ?? this.txid,
      fps: fps ?? this.fps,
      thumbhash: thumbhash ?? this.thumbhash,
      onDevice: onDevice ?? this.onDevice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<Uint8List>(libraryId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (originalFilename.present) {
      map['original_filename'] = Variable<String>(originalFilename.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<Uint8List>(contentHash.value);
    }
    if (mediaKind.present) {
      map['media_kind'] = Variable<String>(mediaKind.value);
    }
    if (facets.present) {
      map['facets'] = Variable<String>(facets.value);
    }
    if (takenLocal.present) {
      map['taken_local'] = Variable<String>(takenLocal.value);
    }
    if (tzOffsetMin.present) {
      map['tz_offset_min'] = Variable<int>(tzOffsetMin.value);
    }
    if (tzName.present) {
      map['tz_name'] = Variable<String>(tzName.value);
    }
    if (takenUtc.present) {
      map['taken_utc'] = Variable<int>(takenUtc.value);
    }
    if (timeSource.present) {
      map['time_source'] = Variable<String>(timeSource.value);
    }
    if (timeConfidence.present) {
      map['time_confidence'] = Variable<int>(timeConfidence.value);
    }
    if (timePrecision.present) {
      map['time_precision'] = Variable<String>(timePrecision.value);
    }
    if (tzAssumed.present) {
      map['tz_assumed'] = Variable<int>(tzAssumed.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (alt.present) {
      map['alt'] = Variable<double>(alt.value);
    }
    if (accuracyM.present) {
      map['accuracy_m'] = Variable<double>(accuracyM.value);
    }
    if (locationSource.present) {
      map['location_source'] = Variable<String>(locationSource.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<Uint8List>(placeId.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (orientation.present) {
      map['orientation'] = Variable<int>(orientation.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (fileSizeTotal.present) {
      map['file_size_total'] = Variable<int>(fileSizeTotal.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (lens.present) {
      map['lens'] = Variable<String>(lens.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (colorLabel.present) {
      map['color_label'] = Variable<String>(colorLabel.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (locked.present) {
      map['locked'] = Variable<int>(locked.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<int>(trashedAt.value);
    }
    if (stackId.present) {
      map['stack_id'] = Variable<Uint8List>(stackId.value);
    }
    if (stackOrder.present) {
      map['stack_order'] = Variable<int>(stackOrder.value);
    }
    if (currentVersionId.present) {
      map['current_version_id'] = Variable<Uint8List>(currentVersionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (fps.present) {
      map['fps'] = Variable<double>(fps.value);
    }
    if (thumbhash.present) {
      map['thumbhash'] = Variable<Uint8List>(thumbhash.value);
    }
    if (onDevice.present) {
      map['on_device'] = Variable<int>(onDevice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetCompanion(')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('ownerId: $ownerId, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('source: $source, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('contentHash: $contentHash, ')
          ..write('mediaKind: $mediaKind, ')
          ..write('facets: $facets, ')
          ..write('takenLocal: $takenLocal, ')
          ..write('tzOffsetMin: $tzOffsetMin, ')
          ..write('tzName: $tzName, ')
          ..write('takenUtc: $takenUtc, ')
          ..write('timeSource: $timeSource, ')
          ..write('timeConfidence: $timeConfidence, ')
          ..write('timePrecision: $timePrecision, ')
          ..write('tzAssumed: $tzAssumed, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('alt: $alt, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('locationSource: $locationSource, ')
          ..write('placeId: $placeId, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('orientation: $orientation, ')
          ..write('durationMs: $durationMs, ')
          ..write('fileSizeTotal: $fileSizeTotal, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('lens: $lens, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rating: $rating, ')
          ..write('colorLabel: $colorLabel, ')
          ..write('archived: $archived, ')
          ..write('locked: $locked, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('stackId: $stackId, ')
          ..write('stackOrder: $stackOrder, ')
          ..write('currentVersionId: $currentVersionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid, ')
          ..write('fps: $fps, ')
          ..write('thumbhash: $thumbhash, ')
          ..write('onDevice: $onDevice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AssetUserState extends Table
    with TableInfo<AssetUserState, AssetUserStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AssetUserState(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<int> favorite = GeneratedColumn<int>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> hiddenFromMemories = GeneratedColumn<int>(
    'hidden_from_memories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> lastViewedAt = GeneratedColumn<int>(
    'last_viewed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> playbackPositionMs = GeneratedColumn<int>(
    'playback_position_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> albumHidesTimeline = GeneratedColumn<int>(
    'album_hides_timeline',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> albumHidesMemories = GeneratedColumn<int>(
    'album_hides_memories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    assetId,
    favorite,
    hiddenFromMemories,
    lastViewedAt,
    playbackPositionMs,
    txid,
    albumHidesTimeline,
    albumHidesMemories,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_user_state';
  @override
  Set<GeneratedColumn> get $primaryKey => {assetId};
  @override
  AssetUserStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetUserStateData(
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}favorite'],
      )!,
      hiddenFromMemories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden_from_memories'],
      )!,
      lastViewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_viewed_at'],
      ),
      playbackPositionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playback_position_ms'],
      ),
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
      albumHidesTimeline: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}album_hides_timeline'],
      )!,
      albumHidesMemories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}album_hides_memories'],
      )!,
    );
  }

  @override
  AssetUserState createAlias(String alias) {
    return AssetUserState(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AssetUserStateData extends DataClass
    implements Insertable<AssetUserStateData> {
  final Uint8List assetId;
  final int favorite;
  final int hiddenFromMemories;
  final int? lastViewedAt;
  final int? playbackPositionMs;
  final int? txid;

  /// Schema 29 (ORG-17): the asset is in an album this account hides from its timeline or memories; the server keeps it.
  final int albumHidesTimeline;
  final int albumHidesMemories;
  const AssetUserStateData({
    required this.assetId,
    required this.favorite,
    required this.hiddenFromMemories,
    this.lastViewedAt,
    this.playbackPositionMs,
    this.txid,
    required this.albumHidesTimeline,
    required this.albumHidesMemories,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<Uint8List>(assetId);
    map['favorite'] = Variable<int>(favorite);
    map['hidden_from_memories'] = Variable<int>(hiddenFromMemories);
    if (!nullToAbsent || lastViewedAt != null) {
      map['last_viewed_at'] = Variable<int>(lastViewedAt);
    }
    if (!nullToAbsent || playbackPositionMs != null) {
      map['playback_position_ms'] = Variable<int>(playbackPositionMs);
    }
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    map['album_hides_timeline'] = Variable<int>(albumHidesTimeline);
    map['album_hides_memories'] = Variable<int>(albumHidesMemories);
    return map;
  }

  factory AssetUserStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetUserStateData(
      assetId: serializer.fromJson<Uint8List>(json['asset_id']),
      favorite: serializer.fromJson<int>(json['favorite']),
      hiddenFromMemories: serializer.fromJson<int>(
        json['hidden_from_memories'],
      ),
      lastViewedAt: serializer.fromJson<int?>(json['last_viewed_at']),
      playbackPositionMs: serializer.fromJson<int?>(
        json['playback_position_ms'],
      ),
      txid: serializer.fromJson<int?>(json['txid']),
      albumHidesTimeline: serializer.fromJson<int>(
        json['album_hides_timeline'],
      ),
      albumHidesMemories: serializer.fromJson<int>(
        json['album_hides_memories'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'asset_id': serializer.toJson<Uint8List>(assetId),
      'favorite': serializer.toJson<int>(favorite),
      'hidden_from_memories': serializer.toJson<int>(hiddenFromMemories),
      'last_viewed_at': serializer.toJson<int?>(lastViewedAt),
      'playback_position_ms': serializer.toJson<int?>(playbackPositionMs),
      'txid': serializer.toJson<int?>(txid),
      'album_hides_timeline': serializer.toJson<int>(albumHidesTimeline),
      'album_hides_memories': serializer.toJson<int>(albumHidesMemories),
    };
  }

  AssetUserStateData copyWith({
    Uint8List? assetId,
    int? favorite,
    int? hiddenFromMemories,
    Value<int?> lastViewedAt = const Value.absent(),
    Value<int?> playbackPositionMs = const Value.absent(),
    Value<int?> txid = const Value.absent(),
    int? albumHidesTimeline,
    int? albumHidesMemories,
  }) => AssetUserStateData(
    assetId: assetId ?? this.assetId,
    favorite: favorite ?? this.favorite,
    hiddenFromMemories: hiddenFromMemories ?? this.hiddenFromMemories,
    lastViewedAt: lastViewedAt.present ? lastViewedAt.value : this.lastViewedAt,
    playbackPositionMs: playbackPositionMs.present
        ? playbackPositionMs.value
        : this.playbackPositionMs,
    txid: txid.present ? txid.value : this.txid,
    albumHidesTimeline: albumHidesTimeline ?? this.albumHidesTimeline,
    albumHidesMemories: albumHidesMemories ?? this.albumHidesMemories,
  );
  AssetUserStateData copyWithCompanion(AssetUserStateCompanion data) {
    return AssetUserStateData(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      hiddenFromMemories: data.hiddenFromMemories.present
          ? data.hiddenFromMemories.value
          : this.hiddenFromMemories,
      lastViewedAt: data.lastViewedAt.present
          ? data.lastViewedAt.value
          : this.lastViewedAt,
      playbackPositionMs: data.playbackPositionMs.present
          ? data.playbackPositionMs.value
          : this.playbackPositionMs,
      txid: data.txid.present ? data.txid.value : this.txid,
      albumHidesTimeline: data.albumHidesTimeline.present
          ? data.albumHidesTimeline.value
          : this.albumHidesTimeline,
      albumHidesMemories: data.albumHidesMemories.present
          ? data.albumHidesMemories.value
          : this.albumHidesMemories,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetUserStateData(')
          ..write('assetId: $assetId, ')
          ..write('favorite: $favorite, ')
          ..write('hiddenFromMemories: $hiddenFromMemories, ')
          ..write('lastViewedAt: $lastViewedAt, ')
          ..write('playbackPositionMs: $playbackPositionMs, ')
          ..write('txid: $txid, ')
          ..write('albumHidesTimeline: $albumHidesTimeline, ')
          ..write('albumHidesMemories: $albumHidesMemories')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(assetId),
    favorite,
    hiddenFromMemories,
    lastViewedAt,
    playbackPositionMs,
    txid,
    albumHidesTimeline,
    albumHidesMemories,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetUserStateData &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          other.favorite == this.favorite &&
          other.hiddenFromMemories == this.hiddenFromMemories &&
          other.lastViewedAt == this.lastViewedAt &&
          other.playbackPositionMs == this.playbackPositionMs &&
          other.txid == this.txid &&
          other.albumHidesTimeline == this.albumHidesTimeline &&
          other.albumHidesMemories == this.albumHidesMemories);
}

class AssetUserStateCompanion extends UpdateCompanion<AssetUserStateData> {
  final Value<Uint8List> assetId;
  final Value<int> favorite;
  final Value<int> hiddenFromMemories;
  final Value<int?> lastViewedAt;
  final Value<int?> playbackPositionMs;
  final Value<int?> txid;
  final Value<int> albumHidesTimeline;
  final Value<int> albumHidesMemories;
  final Value<int> rowid;
  const AssetUserStateCompanion({
    this.assetId = const Value.absent(),
    this.favorite = const Value.absent(),
    this.hiddenFromMemories = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.playbackPositionMs = const Value.absent(),
    this.txid = const Value.absent(),
    this.albumHidesTimeline = const Value.absent(),
    this.albumHidesMemories = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetUserStateCompanion.insert({
    required Uint8List assetId,
    this.favorite = const Value.absent(),
    this.hiddenFromMemories = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.playbackPositionMs = const Value.absent(),
    this.txid = const Value.absent(),
    this.albumHidesTimeline = const Value.absent(),
    this.albumHidesMemories = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId);
  static Insertable<AssetUserStateData> custom({
    Expression<Uint8List>? assetId,
    Expression<int>? favorite,
    Expression<int>? hiddenFromMemories,
    Expression<int>? lastViewedAt,
    Expression<int>? playbackPositionMs,
    Expression<int>? txid,
    Expression<int>? albumHidesTimeline,
    Expression<int>? albumHidesMemories,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (favorite != null) 'favorite': favorite,
      if (hiddenFromMemories != null)
        'hidden_from_memories': hiddenFromMemories,
      if (lastViewedAt != null) 'last_viewed_at': lastViewedAt,
      if (playbackPositionMs != null)
        'playback_position_ms': playbackPositionMs,
      if (txid != null) 'txid': txid,
      if (albumHidesTimeline != null)
        'album_hides_timeline': albumHidesTimeline,
      if (albumHidesMemories != null)
        'album_hides_memories': albumHidesMemories,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetUserStateCompanion copyWith({
    Value<Uint8List>? assetId,
    Value<int>? favorite,
    Value<int>? hiddenFromMemories,
    Value<int?>? lastViewedAt,
    Value<int?>? playbackPositionMs,
    Value<int?>? txid,
    Value<int>? albumHidesTimeline,
    Value<int>? albumHidesMemories,
    Value<int>? rowid,
  }) {
    return AssetUserStateCompanion(
      assetId: assetId ?? this.assetId,
      favorite: favorite ?? this.favorite,
      hiddenFromMemories: hiddenFromMemories ?? this.hiddenFromMemories,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      playbackPositionMs: playbackPositionMs ?? this.playbackPositionMs,
      txid: txid ?? this.txid,
      albumHidesTimeline: albumHidesTimeline ?? this.albumHidesTimeline,
      albumHidesMemories: albumHidesMemories ?? this.albumHidesMemories,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<Uint8List>(assetId.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<int>(favorite.value);
    }
    if (hiddenFromMemories.present) {
      map['hidden_from_memories'] = Variable<int>(hiddenFromMemories.value);
    }
    if (lastViewedAt.present) {
      map['last_viewed_at'] = Variable<int>(lastViewedAt.value);
    }
    if (playbackPositionMs.present) {
      map['playback_position_ms'] = Variable<int>(playbackPositionMs.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (albumHidesTimeline.present) {
      map['album_hides_timeline'] = Variable<int>(albumHidesTimeline.value);
    }
    if (albumHidesMemories.present) {
      map['album_hides_memories'] = Variable<int>(albumHidesMemories.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetUserStateCompanion(')
          ..write('assetId: $assetId, ')
          ..write('favorite: $favorite, ')
          ..write('hiddenFromMemories: $hiddenFromMemories, ')
          ..write('lastViewedAt: $lastViewedAt, ')
          ..write('playbackPositionMs: $playbackPositionMs, ')
          ..write('txid: $txid, ')
          ..write('albumHidesTimeline: $albumHidesTimeline, ')
          ..write('albumHidesMemories: $albumHidesMemories, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AlbumUserState extends Table
    with TableInfo<AlbumUserState, AlbumUserStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AlbumUserState(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> albumId = GeneratedColumn<Uint8List>(
    'album_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<int> hideFromTimeline = GeneratedColumn<int>(
    'hide_from_timeline',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> hideFromMemories = GeneratedColumn<int>(
    'hide_from_memories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    albumId,
    hideFromTimeline,
    hideFromMemories,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'album_user_state';
  @override
  Set<GeneratedColumn> get $primaryKey => {albumId};
  @override
  AlbumUserStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumUserStateData(
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}album_id'],
      )!,
      hideFromTimeline: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hide_from_timeline'],
      )!,
      hideFromMemories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hide_from_memories'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  AlbumUserState createAlias(String alias) {
    return AlbumUserState(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AlbumUserStateData extends DataClass
    implements Insertable<AlbumUserStateData> {
  final Uint8List albumId;
  final int hideFromTimeline;
  final int hideFromMemories;
  final int? txid;
  const AlbumUserStateData({
    required this.albumId,
    required this.hideFromTimeline,
    required this.hideFromMemories,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['album_id'] = Variable<Uint8List>(albumId);
    map['hide_from_timeline'] = Variable<int>(hideFromTimeline);
    map['hide_from_memories'] = Variable<int>(hideFromMemories);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AlbumUserStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumUserStateData(
      albumId: serializer.fromJson<Uint8List>(json['album_id']),
      hideFromTimeline: serializer.fromJson<int>(json['hide_from_timeline']),
      hideFromMemories: serializer.fromJson<int>(json['hide_from_memories']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'album_id': serializer.toJson<Uint8List>(albumId),
      'hide_from_timeline': serializer.toJson<int>(hideFromTimeline),
      'hide_from_memories': serializer.toJson<int>(hideFromMemories),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AlbumUserStateData copyWith({
    Uint8List? albumId,
    int? hideFromTimeline,
    int? hideFromMemories,
    Value<int?> txid = const Value.absent(),
  }) => AlbumUserStateData(
    albumId: albumId ?? this.albumId,
    hideFromTimeline: hideFromTimeline ?? this.hideFromTimeline,
    hideFromMemories: hideFromMemories ?? this.hideFromMemories,
    txid: txid.present ? txid.value : this.txid,
  );
  AlbumUserStateData copyWithCompanion(AlbumUserStateCompanion data) {
    return AlbumUserStateData(
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      hideFromTimeline: data.hideFromTimeline.present
          ? data.hideFromTimeline.value
          : this.hideFromTimeline,
      hideFromMemories: data.hideFromMemories.present
          ? data.hideFromMemories.value
          : this.hideFromMemories,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumUserStateData(')
          ..write('albumId: $albumId, ')
          ..write('hideFromTimeline: $hideFromTimeline, ')
          ..write('hideFromMemories: $hideFromMemories, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(albumId),
    hideFromTimeline,
    hideFromMemories,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumUserStateData &&
          $driftBlobEquality.equals(other.albumId, this.albumId) &&
          other.hideFromTimeline == this.hideFromTimeline &&
          other.hideFromMemories == this.hideFromMemories &&
          other.txid == this.txid);
}

class AlbumUserStateCompanion extends UpdateCompanion<AlbumUserStateData> {
  final Value<Uint8List> albumId;
  final Value<int> hideFromTimeline;
  final Value<int> hideFromMemories;
  final Value<int?> txid;
  final Value<int> rowid;
  const AlbumUserStateCompanion({
    this.albumId = const Value.absent(),
    this.hideFromTimeline = const Value.absent(),
    this.hideFromMemories = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumUserStateCompanion.insert({
    required Uint8List albumId,
    this.hideFromTimeline = const Value.absent(),
    this.hideFromMemories = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : albumId = Value(albumId);
  static Insertable<AlbumUserStateData> custom({
    Expression<Uint8List>? albumId,
    Expression<int>? hideFromTimeline,
    Expression<int>? hideFromMemories,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (albumId != null) 'album_id': albumId,
      if (hideFromTimeline != null) 'hide_from_timeline': hideFromTimeline,
      if (hideFromMemories != null) 'hide_from_memories': hideFromMemories,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumUserStateCompanion copyWith({
    Value<Uint8List>? albumId,
    Value<int>? hideFromTimeline,
    Value<int>? hideFromMemories,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AlbumUserStateCompanion(
      albumId: albumId ?? this.albumId,
      hideFromTimeline: hideFromTimeline ?? this.hideFromTimeline,
      hideFromMemories: hideFromMemories ?? this.hideFromMemories,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (albumId.present) {
      map['album_id'] = Variable<Uint8List>(albumId.value);
    }
    if (hideFromTimeline.present) {
      map['hide_from_timeline'] = Variable<int>(hideFromTimeline.value);
    }
    if (hideFromMemories.present) {
      map['hide_from_memories'] = Variable<int>(hideFromMemories.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumUserStateCompanion(')
          ..write('albumId: $albumId, ')
          ..write('hideFromTimeline: $hideFromTimeline, ')
          ..write('hideFromMemories: $hideFromMemories, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class LibraryUserState extends Table
    with TableInfo<LibraryUserState, LibraryUserStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LibraryUserState(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> libraryId = GeneratedColumn<Uint8List>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<int> hideFromTimeline = GeneratedColumn<int>(
    'hide_from_timeline',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> hideFromMemories = GeneratedColumn<int>(
    'hide_from_memories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    libraryId,
    hideFromTimeline,
    hideFromMemories,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_user_state';
  @override
  Set<GeneratedColumn> get $primaryKey => {libraryId};
  @override
  LibraryUserStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryUserStateData(
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}library_id'],
      )!,
      hideFromTimeline: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hide_from_timeline'],
      )!,
      hideFromMemories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hide_from_memories'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  LibraryUserState createAlias(String alias) {
    return LibraryUserState(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class LibraryUserStateData extends DataClass
    implements Insertable<LibraryUserStateData> {
  final Uint8List libraryId;
  final int hideFromTimeline;
  final int hideFromMemories;
  final int? txid;
  const LibraryUserStateData({
    required this.libraryId,
    required this.hideFromTimeline,
    required this.hideFromMemories,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['library_id'] = Variable<Uint8List>(libraryId);
    map['hide_from_timeline'] = Variable<int>(hideFromTimeline);
    map['hide_from_memories'] = Variable<int>(hideFromMemories);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory LibraryUserStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryUserStateData(
      libraryId: serializer.fromJson<Uint8List>(json['library_id']),
      hideFromTimeline: serializer.fromJson<int>(json['hide_from_timeline']),
      hideFromMemories: serializer.fromJson<int>(json['hide_from_memories']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'library_id': serializer.toJson<Uint8List>(libraryId),
      'hide_from_timeline': serializer.toJson<int>(hideFromTimeline),
      'hide_from_memories': serializer.toJson<int>(hideFromMemories),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  LibraryUserStateData copyWith({
    Uint8List? libraryId,
    int? hideFromTimeline,
    int? hideFromMemories,
    Value<int?> txid = const Value.absent(),
  }) => LibraryUserStateData(
    libraryId: libraryId ?? this.libraryId,
    hideFromTimeline: hideFromTimeline ?? this.hideFromTimeline,
    hideFromMemories: hideFromMemories ?? this.hideFromMemories,
    txid: txid.present ? txid.value : this.txid,
  );
  LibraryUserStateData copyWithCompanion(LibraryUserStateCompanion data) {
    return LibraryUserStateData(
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      hideFromTimeline: data.hideFromTimeline.present
          ? data.hideFromTimeline.value
          : this.hideFromTimeline,
      hideFromMemories: data.hideFromMemories.present
          ? data.hideFromMemories.value
          : this.hideFromMemories,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryUserStateData(')
          ..write('libraryId: $libraryId, ')
          ..write('hideFromTimeline: $hideFromTimeline, ')
          ..write('hideFromMemories: $hideFromMemories, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(libraryId),
    hideFromTimeline,
    hideFromMemories,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryUserStateData &&
          $driftBlobEquality.equals(other.libraryId, this.libraryId) &&
          other.hideFromTimeline == this.hideFromTimeline &&
          other.hideFromMemories == this.hideFromMemories &&
          other.txid == this.txid);
}

class LibraryUserStateCompanion extends UpdateCompanion<LibraryUserStateData> {
  final Value<Uint8List> libraryId;
  final Value<int> hideFromTimeline;
  final Value<int> hideFromMemories;
  final Value<int?> txid;
  final Value<int> rowid;
  const LibraryUserStateCompanion({
    this.libraryId = const Value.absent(),
    this.hideFromTimeline = const Value.absent(),
    this.hideFromMemories = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryUserStateCompanion.insert({
    required Uint8List libraryId,
    this.hideFromTimeline = const Value.absent(),
    this.hideFromMemories = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : libraryId = Value(libraryId);
  static Insertable<LibraryUserStateData> custom({
    Expression<Uint8List>? libraryId,
    Expression<int>? hideFromTimeline,
    Expression<int>? hideFromMemories,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (libraryId != null) 'library_id': libraryId,
      if (hideFromTimeline != null) 'hide_from_timeline': hideFromTimeline,
      if (hideFromMemories != null) 'hide_from_memories': hideFromMemories,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryUserStateCompanion copyWith({
    Value<Uint8List>? libraryId,
    Value<int>? hideFromTimeline,
    Value<int>? hideFromMemories,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return LibraryUserStateCompanion(
      libraryId: libraryId ?? this.libraryId,
      hideFromTimeline: hideFromTimeline ?? this.hideFromTimeline,
      hideFromMemories: hideFromMemories ?? this.hideFromMemories,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (libraryId.present) {
      map['library_id'] = Variable<Uint8List>(libraryId.value);
    }
    if (hideFromTimeline.present) {
      map['hide_from_timeline'] = Variable<int>(hideFromTimeline.value);
    }
    if (hideFromMemories.present) {
      map['hide_from_memories'] = Variable<int>(hideFromMemories.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryUserStateCompanion(')
          ..write('libraryId: $libraryId, ')
          ..write('hideFromTimeline: $hideFromTimeline, ')
          ..write('hideFromMemories: $hideFromMemories, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AssetFile extends Table with TableInfo<AssetFile, AssetFileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AssetFile(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> contentHash =
      GeneratedColumn<Uint8List>(
        'content_hash',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetId,
    role,
    mime,
    size,
    contentHash,
    state,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_file';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetFileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetFileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content_hash'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  AssetFile createAlias(String alias) {
    return AssetFile(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AssetFileData extends DataClass implements Insertable<AssetFileData> {
  final Uint8List id;
  final Uint8List assetId;
  final String role;

  /// original, original_alt, live_motion, sidecar, render, thumb_s, preview, …
  final String mime;
  final int size;
  final Uint8List? contentHash;
  final String state;

  /// present, missing, offline, pending_upload, integrity_error
  final int? txid;
  const AssetFileData({
    required this.id,
    required this.assetId,
    required this.role,
    required this.mime,
    required this.size,
    this.contentHash,
    required this.state,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['asset_id'] = Variable<Uint8List>(assetId);
    map['role'] = Variable<String>(role);
    map['mime'] = Variable<String>(mime);
    map['size'] = Variable<int>(size);
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<Uint8List>(contentHash);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AssetFileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetFileData(
      id: serializer.fromJson<Uint8List>(json['id']),
      assetId: serializer.fromJson<Uint8List>(json['asset_id']),
      role: serializer.fromJson<String>(json['role']),
      mime: serializer.fromJson<String>(json['mime']),
      size: serializer.fromJson<int>(json['size']),
      contentHash: serializer.fromJson<Uint8List?>(json['content_hash']),
      state: serializer.fromJson<String>(json['state']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'asset_id': serializer.toJson<Uint8List>(assetId),
      'role': serializer.toJson<String>(role),
      'mime': serializer.toJson<String>(mime),
      'size': serializer.toJson<int>(size),
      'content_hash': serializer.toJson<Uint8List?>(contentHash),
      'state': serializer.toJson<String>(state),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AssetFileData copyWith({
    Uint8List? id,
    Uint8List? assetId,
    String? role,
    String? mime,
    int? size,
    Value<Uint8List?> contentHash = const Value.absent(),
    String? state,
    Value<int?> txid = const Value.absent(),
  }) => AssetFileData(
    id: id ?? this.id,
    assetId: assetId ?? this.assetId,
    role: role ?? this.role,
    mime: mime ?? this.mime,
    size: size ?? this.size,
    contentHash: contentHash.present ? contentHash.value : this.contentHash,
    state: state ?? this.state,
    txid: txid.present ? txid.value : this.txid,
  );
  AssetFileData copyWithCompanion(AssetFileCompanion data) {
    return AssetFileData(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      role: data.role.present ? data.role.value : this.role,
      mime: data.mime.present ? data.mime.value : this.mime,
      size: data.size.present ? data.size.value : this.size,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      state: data.state.present ? data.state.value : this.state,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetFileData(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('role: $role, ')
          ..write('mime: $mime, ')
          ..write('size: $size, ')
          ..write('contentHash: $contentHash, ')
          ..write('state: $state, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(assetId),
    role,
    mime,
    size,
    $driftBlobEquality.hash(contentHash),
    state,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetFileData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          other.role == this.role &&
          other.mime == this.mime &&
          other.size == this.size &&
          $driftBlobEquality.equals(other.contentHash, this.contentHash) &&
          other.state == this.state &&
          other.txid == this.txid);
}

class AssetFileCompanion extends UpdateCompanion<AssetFileData> {
  final Value<Uint8List> id;
  final Value<Uint8List> assetId;
  final Value<String> role;
  final Value<String> mime;
  final Value<int> size;
  final Value<Uint8List?> contentHash;
  final Value<String> state;
  final Value<int?> txid;
  final Value<int> rowid;
  const AssetFileCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.role = const Value.absent(),
    this.mime = const Value.absent(),
    this.size = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.state = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetFileCompanion.insert({
    required Uint8List id,
    required Uint8List assetId,
    required String role,
    required String mime,
    required int size,
    this.contentHash = const Value.absent(),
    required String state,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetId = Value(assetId),
       role = Value(role),
       mime = Value(mime),
       size = Value(size),
       state = Value(state);
  static Insertable<AssetFileData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? assetId,
    Expression<String>? role,
    Expression<String>? mime,
    Expression<int>? size,
    Expression<Uint8List>? contentHash,
    Expression<String>? state,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (role != null) 'role': role,
      if (mime != null) 'mime': mime,
      if (size != null) 'size': size,
      if (contentHash != null) 'content_hash': contentHash,
      if (state != null) 'state': state,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetFileCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? assetId,
    Value<String>? role,
    Value<String>? mime,
    Value<int>? size,
    Value<Uint8List?>? contentHash,
    Value<String>? state,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AssetFileCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      role: role ?? this.role,
      mime: mime ?? this.mime,
      size: size ?? this.size,
      contentHash: contentHash ?? this.contentHash,
      state: state ?? this.state,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<Uint8List>(assetId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<Uint8List>(contentHash.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetFileCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('role: $role, ')
          ..write('mime: $mime, ')
          ..write('size: $size, ')
          ..write('contentHash: $contentHash, ')
          ..write('state: $state, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AssetVersion extends Table
    with TableInfo<AssetVersion, AssetVersionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AssetVersion(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> parentId = GeneratedColumn<Uint8List>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> recipe = GeneratedColumn<Uint8List>(
    'recipe',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> renderFileId =
      GeneratedColumn<Uint8List>(
        'render_file_id',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetId,
    parentId,
    kind,
    label,
    recipe,
    renderFileId,
    createdAt,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_version';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetVersionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetVersionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}parent_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      recipe: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}recipe'],
      ),
      renderFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}render_file_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  AssetVersion createAlias(String alias) {
    return AssetVersion(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AssetVersionData extends DataClass
    implements Insertable<AssetVersionData> {
  final Uint8List id;
  final Uint8List assetId;
  final Uint8List? parentId;
  final String kind;

  /// original, edit, external_change, import_variant
  final String? label;
  final Uint8List? recipe;

  /// EditRecipe protobuf
  final Uint8List? renderFileId;
  final int createdAt;
  final int? txid;
  const AssetVersionData({
    required this.id,
    required this.assetId,
    this.parentId,
    required this.kind,
    this.label,
    this.recipe,
    this.renderFileId,
    required this.createdAt,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['asset_id'] = Variable<Uint8List>(assetId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<Uint8List>(parentId);
    }
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || recipe != null) {
      map['recipe'] = Variable<Uint8List>(recipe);
    }
    if (!nullToAbsent || renderFileId != null) {
      map['render_file_id'] = Variable<Uint8List>(renderFileId);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AssetVersionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetVersionData(
      id: serializer.fromJson<Uint8List>(json['id']),
      assetId: serializer.fromJson<Uint8List>(json['asset_id']),
      parentId: serializer.fromJson<Uint8List?>(json['parent_id']),
      kind: serializer.fromJson<String>(json['kind']),
      label: serializer.fromJson<String?>(json['label']),
      recipe: serializer.fromJson<Uint8List?>(json['recipe']),
      renderFileId: serializer.fromJson<Uint8List?>(json['render_file_id']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'asset_id': serializer.toJson<Uint8List>(assetId),
      'parent_id': serializer.toJson<Uint8List?>(parentId),
      'kind': serializer.toJson<String>(kind),
      'label': serializer.toJson<String?>(label),
      'recipe': serializer.toJson<Uint8List?>(recipe),
      'render_file_id': serializer.toJson<Uint8List?>(renderFileId),
      'created_at': serializer.toJson<int>(createdAt),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AssetVersionData copyWith({
    Uint8List? id,
    Uint8List? assetId,
    Value<Uint8List?> parentId = const Value.absent(),
    String? kind,
    Value<String?> label = const Value.absent(),
    Value<Uint8List?> recipe = const Value.absent(),
    Value<Uint8List?> renderFileId = const Value.absent(),
    int? createdAt,
    Value<int?> txid = const Value.absent(),
  }) => AssetVersionData(
    id: id ?? this.id,
    assetId: assetId ?? this.assetId,
    parentId: parentId.present ? parentId.value : this.parentId,
    kind: kind ?? this.kind,
    label: label.present ? label.value : this.label,
    recipe: recipe.present ? recipe.value : this.recipe,
    renderFileId: renderFileId.present ? renderFileId.value : this.renderFileId,
    createdAt: createdAt ?? this.createdAt,
    txid: txid.present ? txid.value : this.txid,
  );
  AssetVersionData copyWithCompanion(AssetVersionCompanion data) {
    return AssetVersionData(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      label: data.label.present ? data.label.value : this.label,
      recipe: data.recipe.present ? data.recipe.value : this.recipe,
      renderFileId: data.renderFileId.present
          ? data.renderFileId.value
          : this.renderFileId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetVersionData(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('parentId: $parentId, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('recipe: $recipe, ')
          ..write('renderFileId: $renderFileId, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(assetId),
    $driftBlobEquality.hash(parentId),
    kind,
    label,
    $driftBlobEquality.hash(recipe),
    $driftBlobEquality.hash(renderFileId),
    createdAt,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetVersionData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          $driftBlobEquality.equals(other.parentId, this.parentId) &&
          other.kind == this.kind &&
          other.label == this.label &&
          $driftBlobEquality.equals(other.recipe, this.recipe) &&
          $driftBlobEquality.equals(other.renderFileId, this.renderFileId) &&
          other.createdAt == this.createdAt &&
          other.txid == this.txid);
}

class AssetVersionCompanion extends UpdateCompanion<AssetVersionData> {
  final Value<Uint8List> id;
  final Value<Uint8List> assetId;
  final Value<Uint8List?> parentId;
  final Value<String> kind;
  final Value<String?> label;
  final Value<Uint8List?> recipe;
  final Value<Uint8List?> renderFileId;
  final Value<int> createdAt;
  final Value<int?> txid;
  final Value<int> rowid;
  const AssetVersionCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.label = const Value.absent(),
    this.recipe = const Value.absent(),
    this.renderFileId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetVersionCompanion.insert({
    required Uint8List id,
    required Uint8List assetId,
    this.parentId = const Value.absent(),
    required String kind,
    this.label = const Value.absent(),
    this.recipe = const Value.absent(),
    this.renderFileId = const Value.absent(),
    required int createdAt,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetId = Value(assetId),
       kind = Value(kind),
       createdAt = Value(createdAt);
  static Insertable<AssetVersionData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? assetId,
    Expression<Uint8List>? parentId,
    Expression<String>? kind,
    Expression<String>? label,
    Expression<Uint8List>? recipe,
    Expression<Uint8List>? renderFileId,
    Expression<int>? createdAt,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (parentId != null) 'parent_id': parentId,
      if (kind != null) 'kind': kind,
      if (label != null) 'label': label,
      if (recipe != null) 'recipe': recipe,
      if (renderFileId != null) 'render_file_id': renderFileId,
      if (createdAt != null) 'created_at': createdAt,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetVersionCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? assetId,
    Value<Uint8List?>? parentId,
    Value<String>? kind,
    Value<String?>? label,
    Value<Uint8List?>? recipe,
    Value<Uint8List?>? renderFileId,
    Value<int>? createdAt,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AssetVersionCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      parentId: parentId ?? this.parentId,
      kind: kind ?? this.kind,
      label: label ?? this.label,
      recipe: recipe ?? this.recipe,
      renderFileId: renderFileId ?? this.renderFileId,
      createdAt: createdAt ?? this.createdAt,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<Uint8List>(assetId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<Uint8List>(parentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (recipe.present) {
      map['recipe'] = Variable<Uint8List>(recipe.value);
    }
    if (renderFileId.present) {
      map['render_file_id'] = Variable<Uint8List>(renderFileId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetVersionCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('parentId: $parentId, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('recipe: $recipe, ')
          ..write('renderFileId: $renderFileId, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Stack extends Table with TableInfo<Stack, StackData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Stack(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> coverAssetId =
      GeneratedColumn<Uint8List>(
        'cover_asset_id',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<String> reviewState = GeneratedColumn<String>(
    'review_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'unreviewed\'',
    defaultValue: const CustomExpression('\'unreviewed\''),
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    kind,
    coverAssetId,
    reviewState,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stack';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StackData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StackData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      coverAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}cover_asset_id'],
      ),
      reviewState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_state'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  Stack createAlias(String alias) {
    return Stack(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class StackData extends DataClass implements Insertable<StackData> {
  final Uint8List id;
  final Uint8List ownerId;
  final String kind;

  /// burst, similar_series, raw_jpeg, bracket, manual
  final Uint8List? coverAssetId;
  final String reviewState;
  final int? txid;
  const StackData({
    required this.id,
    required this.ownerId,
    required this.kind,
    this.coverAssetId,
    required this.reviewState,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['owner_id'] = Variable<Uint8List>(ownerId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || coverAssetId != null) {
      map['cover_asset_id'] = Variable<Uint8List>(coverAssetId);
    }
    map['review_state'] = Variable<String>(reviewState);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory StackData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StackData(
      id: serializer.fromJson<Uint8List>(json['id']),
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      kind: serializer.fromJson<String>(json['kind']),
      coverAssetId: serializer.fromJson<Uint8List?>(json['cover_asset_id']),
      reviewState: serializer.fromJson<String>(json['review_state']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'kind': serializer.toJson<String>(kind),
      'cover_asset_id': serializer.toJson<Uint8List?>(coverAssetId),
      'review_state': serializer.toJson<String>(reviewState),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  StackData copyWith({
    Uint8List? id,
    Uint8List? ownerId,
    String? kind,
    Value<Uint8List?> coverAssetId = const Value.absent(),
    String? reviewState,
    Value<int?> txid = const Value.absent(),
  }) => StackData(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    kind: kind ?? this.kind,
    coverAssetId: coverAssetId.present ? coverAssetId.value : this.coverAssetId,
    reviewState: reviewState ?? this.reviewState,
    txid: txid.present ? txid.value : this.txid,
  );
  StackData copyWithCompanion(StackCompanion data) {
    return StackData(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      kind: data.kind.present ? data.kind.value : this.kind,
      coverAssetId: data.coverAssetId.present
          ? data.coverAssetId.value
          : this.coverAssetId,
      reviewState: data.reviewState.present
          ? data.reviewState.value
          : this.reviewState,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StackData(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('kind: $kind, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('reviewState: $reviewState, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(ownerId),
    kind,
    $driftBlobEquality.hash(coverAssetId),
    reviewState,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StackData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          other.kind == this.kind &&
          $driftBlobEquality.equals(other.coverAssetId, this.coverAssetId) &&
          other.reviewState == this.reviewState &&
          other.txid == this.txid);
}

class StackCompanion extends UpdateCompanion<StackData> {
  final Value<Uint8List> id;
  final Value<Uint8List> ownerId;
  final Value<String> kind;
  final Value<Uint8List?> coverAssetId;
  final Value<String> reviewState;
  final Value<int?> txid;
  final Value<int> rowid;
  const StackCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.kind = const Value.absent(),
    this.coverAssetId = const Value.absent(),
    this.reviewState = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StackCompanion.insert({
    required Uint8List id,
    required Uint8List ownerId,
    required String kind,
    this.coverAssetId = const Value.absent(),
    this.reviewState = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       kind = Value(kind);
  static Insertable<StackData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? ownerId,
    Expression<String>? kind,
    Expression<Uint8List>? coverAssetId,
    Expression<String>? reviewState,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (kind != null) 'kind': kind,
      if (coverAssetId != null) 'cover_asset_id': coverAssetId,
      if (reviewState != null) 'review_state': reviewState,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StackCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? ownerId,
    Value<String>? kind,
    Value<Uint8List?>? coverAssetId,
    Value<String>? reviewState,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return StackCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      kind: kind ?? this.kind,
      coverAssetId: coverAssetId ?? this.coverAssetId,
      reviewState: reviewState ?? this.reviewState,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (coverAssetId.present) {
      map['cover_asset_id'] = Variable<Uint8List>(coverAssetId.value);
    }
    if (reviewState.present) {
      map['review_state'] = Variable<String>(reviewState.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StackCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('kind: $kind, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('reviewState: $reviewState, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AlbumFolder extends Table with TableInfo<AlbumFolder, AlbumFolderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AlbumFolder(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> parentId = GeneratedColumn<Uint8List>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> sortKey = GeneratedColumn<String>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    parentId,
    name,
    sortKey,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'album_folder';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlbumFolderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumFolderData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_key'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  AlbumFolder createAlias(String alias) {
    return AlbumFolder(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AlbumFolderData extends DataClass implements Insertable<AlbumFolderData> {
  final Uint8List id;
  final Uint8List ownerId;
  final Uint8List? parentId;
  final String name;
  final String sortKey;
  final int? txid;
  const AlbumFolderData({
    required this.id,
    required this.ownerId,
    this.parentId,
    required this.name,
    required this.sortKey,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['owner_id'] = Variable<Uint8List>(ownerId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<Uint8List>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['sort_key'] = Variable<String>(sortKey);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AlbumFolderData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumFolderData(
      id: serializer.fromJson<Uint8List>(json['id']),
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      parentId: serializer.fromJson<Uint8List?>(json['parent_id']),
      name: serializer.fromJson<String>(json['name']),
      sortKey: serializer.fromJson<String>(json['sort_key']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'parent_id': serializer.toJson<Uint8List?>(parentId),
      'name': serializer.toJson<String>(name),
      'sort_key': serializer.toJson<String>(sortKey),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AlbumFolderData copyWith({
    Uint8List? id,
    Uint8List? ownerId,
    Value<Uint8List?> parentId = const Value.absent(),
    String? name,
    String? sortKey,
    Value<int?> txid = const Value.absent(),
  }) => AlbumFolderData(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    sortKey: sortKey ?? this.sortKey,
    txid: txid.present ? txid.value : this.txid,
  );
  AlbumFolderData copyWithCompanion(AlbumFolderCompanion data) {
    return AlbumFolderData(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      sortKey: data.sortKey.present ? data.sortKey.value : this.sortKey,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumFolderData(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('sortKey: $sortKey, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(ownerId),
    $driftBlobEquality.hash(parentId),
    name,
    sortKey,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumFolderData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          $driftBlobEquality.equals(other.parentId, this.parentId) &&
          other.name == this.name &&
          other.sortKey == this.sortKey &&
          other.txid == this.txid);
}

class AlbumFolderCompanion extends UpdateCompanion<AlbumFolderData> {
  final Value<Uint8List> id;
  final Value<Uint8List> ownerId;
  final Value<Uint8List?> parentId;
  final Value<String> name;
  final Value<String> sortKey;
  final Value<int?> txid;
  final Value<int> rowid;
  const AlbumFolderCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortKey = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumFolderCompanion.insert({
    required Uint8List id,
    required Uint8List ownerId,
    this.parentId = const Value.absent(),
    required String name,
    required String sortKey,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       name = Value(name),
       sortKey = Value(sortKey);
  static Insertable<AlbumFolderData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? ownerId,
    Expression<Uint8List>? parentId,
    Expression<String>? name,
    Expression<String>? sortKey,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (sortKey != null) 'sort_key': sortKey,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumFolderCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? ownerId,
    Value<Uint8List?>? parentId,
    Value<String>? name,
    Value<String>? sortKey,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AlbumFolderCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      sortKey: sortKey ?? this.sortKey,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<Uint8List>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortKey.present) {
      map['sort_key'] = Variable<String>(sortKey.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumFolderCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('sortKey: $sortKey, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Album extends Table with TableInfo<Album, AlbumData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Album(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> folderId = GeneratedColumn<Uint8List>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> coverAssetId =
      GeneratedColumn<Uint8List>(
        'cover_asset_id',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<String> sortMode = GeneratedColumn<String>(
    'sort_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'custom\'',
    defaultValue: const CustomExpression('\'custom\''),
  );
  late final GeneratedColumn<String> layout = GeneratedColumn<String>(
    'layout',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'grid\'',
    defaultValue: const CustomExpression('\'grid\''),
  );
  late final GeneratedColumn<String> privacy = GeneratedColumn<String>(
    'privacy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'standard\'',
    defaultValue: const CustomExpression('\'standard\''),
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    folderId,
    title,
    description,
    coverAssetId,
    sortMode,
    layout,
    privacy,
    createdAt,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'album';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlbumData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}folder_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}cover_asset_id'],
      ),
      sortMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_mode'],
      )!,
      layout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout'],
      )!,
      privacy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}privacy'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  Album createAlias(String alias) {
    return Album(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AlbumData extends DataClass implements Insertable<AlbumData> {
  final Uint8List id;
  final Uint8List ownerId;
  final Uint8List? folderId;
  final String title;
  final String? description;
  final Uint8List? coverAssetId;
  final String sortMode;

  /// custom, taken_asc, taken_desc, added_desc, name, rating
  final String layout;

  /// grid, justified, story
  final String privacy;
  final int createdAt;
  final int? txid;
  const AlbumData({
    required this.id,
    required this.ownerId,
    this.folderId,
    required this.title,
    this.description,
    this.coverAssetId,
    required this.sortMode,
    required this.layout,
    required this.privacy,
    required this.createdAt,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['owner_id'] = Variable<Uint8List>(ownerId);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<Uint8List>(folderId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverAssetId != null) {
      map['cover_asset_id'] = Variable<Uint8List>(coverAssetId);
    }
    map['sort_mode'] = Variable<String>(sortMode);
    map['layout'] = Variable<String>(layout);
    map['privacy'] = Variable<String>(privacy);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AlbumData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumData(
      id: serializer.fromJson<Uint8List>(json['id']),
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      folderId: serializer.fromJson<Uint8List?>(json['folder_id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      coverAssetId: serializer.fromJson<Uint8List?>(json['cover_asset_id']),
      sortMode: serializer.fromJson<String>(json['sort_mode']),
      layout: serializer.fromJson<String>(json['layout']),
      privacy: serializer.fromJson<String>(json['privacy']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'folder_id': serializer.toJson<Uint8List?>(folderId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'cover_asset_id': serializer.toJson<Uint8List?>(coverAssetId),
      'sort_mode': serializer.toJson<String>(sortMode),
      'layout': serializer.toJson<String>(layout),
      'privacy': serializer.toJson<String>(privacy),
      'created_at': serializer.toJson<int>(createdAt),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AlbumData copyWith({
    Uint8List? id,
    Uint8List? ownerId,
    Value<Uint8List?> folderId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    Value<Uint8List?> coverAssetId = const Value.absent(),
    String? sortMode,
    String? layout,
    String? privacy,
    int? createdAt,
    Value<int?> txid = const Value.absent(),
  }) => AlbumData(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    folderId: folderId.present ? folderId.value : this.folderId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    coverAssetId: coverAssetId.present ? coverAssetId.value : this.coverAssetId,
    sortMode: sortMode ?? this.sortMode,
    layout: layout ?? this.layout,
    privacy: privacy ?? this.privacy,
    createdAt: createdAt ?? this.createdAt,
    txid: txid.present ? txid.value : this.txid,
  );
  AlbumData copyWithCompanion(AlbumCompanion data) {
    return AlbumData(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverAssetId: data.coverAssetId.present
          ? data.coverAssetId.value
          : this.coverAssetId,
      sortMode: data.sortMode.present ? data.sortMode.value : this.sortMode,
      layout: data.layout.present ? data.layout.value : this.layout,
      privacy: data.privacy.present ? data.privacy.value : this.privacy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumData(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('folderId: $folderId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('sortMode: $sortMode, ')
          ..write('layout: $layout, ')
          ..write('privacy: $privacy, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(ownerId),
    $driftBlobEquality.hash(folderId),
    title,
    description,
    $driftBlobEquality.hash(coverAssetId),
    sortMode,
    layout,
    privacy,
    createdAt,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          $driftBlobEquality.equals(other.folderId, this.folderId) &&
          other.title == this.title &&
          other.description == this.description &&
          $driftBlobEquality.equals(other.coverAssetId, this.coverAssetId) &&
          other.sortMode == this.sortMode &&
          other.layout == this.layout &&
          other.privacy == this.privacy &&
          other.createdAt == this.createdAt &&
          other.txid == this.txid);
}

class AlbumCompanion extends UpdateCompanion<AlbumData> {
  final Value<Uint8List> id;
  final Value<Uint8List> ownerId;
  final Value<Uint8List?> folderId;
  final Value<String> title;
  final Value<String?> description;
  final Value<Uint8List?> coverAssetId;
  final Value<String> sortMode;
  final Value<String> layout;
  final Value<String> privacy;
  final Value<int> createdAt;
  final Value<int?> txid;
  final Value<int> rowid;
  const AlbumCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.folderId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.coverAssetId = const Value.absent(),
    this.sortMode = const Value.absent(),
    this.layout = const Value.absent(),
    this.privacy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumCompanion.insert({
    required Uint8List id,
    required Uint8List ownerId,
    this.folderId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.coverAssetId = const Value.absent(),
    this.sortMode = const Value.absent(),
    this.layout = const Value.absent(),
    this.privacy = const Value.absent(),
    required int createdAt,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<AlbumData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? ownerId,
    Expression<Uint8List>? folderId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<Uint8List>? coverAssetId,
    Expression<String>? sortMode,
    Expression<String>? layout,
    Expression<String>? privacy,
    Expression<int>? createdAt,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (folderId != null) 'folder_id': folderId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (coverAssetId != null) 'cover_asset_id': coverAssetId,
      if (sortMode != null) 'sort_mode': sortMode,
      if (layout != null) 'layout': layout,
      if (privacy != null) 'privacy': privacy,
      if (createdAt != null) 'created_at': createdAt,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? ownerId,
    Value<Uint8List?>? folderId,
    Value<String>? title,
    Value<String?>? description,
    Value<Uint8List?>? coverAssetId,
    Value<String>? sortMode,
    Value<String>? layout,
    Value<String>? privacy,
    Value<int>? createdAt,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AlbumCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverAssetId: coverAssetId ?? this.coverAssetId,
      sortMode: sortMode ?? this.sortMode,
      layout: layout ?? this.layout,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<Uint8List>(folderId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverAssetId.present) {
      map['cover_asset_id'] = Variable<Uint8List>(coverAssetId.value);
    }
    if (sortMode.present) {
      map['sort_mode'] = Variable<String>(sortMode.value);
    }
    if (layout.present) {
      map['layout'] = Variable<String>(layout.value);
    }
    if (privacy.present) {
      map['privacy'] = Variable<String>(privacy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('folderId: $folderId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverAssetId: $coverAssetId, ')
          ..write('sortMode: $sortMode, ')
          ..write('layout: $layout, ')
          ..write('privacy: $privacy, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AlbumItem extends Table with TableInfo<AlbumItem, AlbumItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AlbumItem(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> albumId = GeneratedColumn<Uint8List>(
    'album_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> anchorAssetId =
      GeneratedColumn<Uint8List>(
        'anchor_asset_id',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> sortKey = GeneratedColumn<String>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    albumId,
    kind,
    assetId,
    anchorAssetId,
    payload,
    sortKey,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'album_item';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlbumItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}album_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      ),
      anchorAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}anchor_asset_id'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_key'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  AlbumItem createAlias(String alias) {
    return AlbumItem(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class AlbumItemData extends DataClass implements Insertable<AlbumItemData> {
  final Uint8List id;
  final Uint8List albumId;
  final String kind;

  /// asset, text, heading, location, divider, date
  final Uint8List? assetId;
  final Uint8List? anchorAssetId;

  /// the asset a text, location or divider block stays before under any sort
  final String? payload;
  final String sortKey;
  final int? txid;
  const AlbumItemData({
    required this.id,
    required this.albumId,
    required this.kind,
    this.assetId,
    this.anchorAssetId,
    this.payload,
    required this.sortKey,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['album_id'] = Variable<Uint8List>(albumId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<Uint8List>(assetId);
    }
    if (!nullToAbsent || anchorAssetId != null) {
      map['anchor_asset_id'] = Variable<Uint8List>(anchorAssetId);
    }
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['sort_key'] = Variable<String>(sortKey);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AlbumItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumItemData(
      id: serializer.fromJson<Uint8List>(json['id']),
      albumId: serializer.fromJson<Uint8List>(json['album_id']),
      kind: serializer.fromJson<String>(json['kind']),
      assetId: serializer.fromJson<Uint8List?>(json['asset_id']),
      anchorAssetId: serializer.fromJson<Uint8List?>(json['anchor_asset_id']),
      payload: serializer.fromJson<String?>(json['payload']),
      sortKey: serializer.fromJson<String>(json['sort_key']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'album_id': serializer.toJson<Uint8List>(albumId),
      'kind': serializer.toJson<String>(kind),
      'asset_id': serializer.toJson<Uint8List?>(assetId),
      'anchor_asset_id': serializer.toJson<Uint8List?>(anchorAssetId),
      'payload': serializer.toJson<String?>(payload),
      'sort_key': serializer.toJson<String>(sortKey),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AlbumItemData copyWith({
    Uint8List? id,
    Uint8List? albumId,
    String? kind,
    Value<Uint8List?> assetId = const Value.absent(),
    Value<Uint8List?> anchorAssetId = const Value.absent(),
    Value<String?> payload = const Value.absent(),
    String? sortKey,
    Value<int?> txid = const Value.absent(),
  }) => AlbumItemData(
    id: id ?? this.id,
    albumId: albumId ?? this.albumId,
    kind: kind ?? this.kind,
    assetId: assetId.present ? assetId.value : this.assetId,
    anchorAssetId: anchorAssetId.present
        ? anchorAssetId.value
        : this.anchorAssetId,
    payload: payload.present ? payload.value : this.payload,
    sortKey: sortKey ?? this.sortKey,
    txid: txid.present ? txid.value : this.txid,
  );
  AlbumItemData copyWithCompanion(AlbumItemCompanion data) {
    return AlbumItemData(
      id: data.id.present ? data.id.value : this.id,
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      kind: data.kind.present ? data.kind.value : this.kind,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      anchorAssetId: data.anchorAssetId.present
          ? data.anchorAssetId.value
          : this.anchorAssetId,
      payload: data.payload.present ? data.payload.value : this.payload,
      sortKey: data.sortKey.present ? data.sortKey.value : this.sortKey,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumItemData(')
          ..write('id: $id, ')
          ..write('albumId: $albumId, ')
          ..write('kind: $kind, ')
          ..write('assetId: $assetId, ')
          ..write('anchorAssetId: $anchorAssetId, ')
          ..write('payload: $payload, ')
          ..write('sortKey: $sortKey, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(albumId),
    kind,
    $driftBlobEquality.hash(assetId),
    $driftBlobEquality.hash(anchorAssetId),
    payload,
    sortKey,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumItemData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.albumId, this.albumId) &&
          other.kind == this.kind &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          $driftBlobEquality.equals(other.anchorAssetId, this.anchorAssetId) &&
          other.payload == this.payload &&
          other.sortKey == this.sortKey &&
          other.txid == this.txid);
}

class AlbumItemCompanion extends UpdateCompanion<AlbumItemData> {
  final Value<Uint8List> id;
  final Value<Uint8List> albumId;
  final Value<String> kind;
  final Value<Uint8List?> assetId;
  final Value<Uint8List?> anchorAssetId;
  final Value<String?> payload;
  final Value<String> sortKey;
  final Value<int?> txid;
  final Value<int> rowid;
  const AlbumItemCompanion({
    this.id = const Value.absent(),
    this.albumId = const Value.absent(),
    this.kind = const Value.absent(),
    this.assetId = const Value.absent(),
    this.anchorAssetId = const Value.absent(),
    this.payload = const Value.absent(),
    this.sortKey = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumItemCompanion.insert({
    required Uint8List id,
    required Uint8List albumId,
    required String kind,
    this.assetId = const Value.absent(),
    this.anchorAssetId = const Value.absent(),
    this.payload = const Value.absent(),
    required String sortKey,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       albumId = Value(albumId),
       kind = Value(kind),
       sortKey = Value(sortKey);
  static Insertable<AlbumItemData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? albumId,
    Expression<String>? kind,
    Expression<Uint8List>? assetId,
    Expression<Uint8List>? anchorAssetId,
    Expression<String>? payload,
    Expression<String>? sortKey,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (albumId != null) 'album_id': albumId,
      if (kind != null) 'kind': kind,
      if (assetId != null) 'asset_id': assetId,
      if (anchorAssetId != null) 'anchor_asset_id': anchorAssetId,
      if (payload != null) 'payload': payload,
      if (sortKey != null) 'sort_key': sortKey,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumItemCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? albumId,
    Value<String>? kind,
    Value<Uint8List?>? assetId,
    Value<Uint8List?>? anchorAssetId,
    Value<String?>? payload,
    Value<String>? sortKey,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AlbumItemCompanion(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      kind: kind ?? this.kind,
      assetId: assetId ?? this.assetId,
      anchorAssetId: anchorAssetId ?? this.anchorAssetId,
      payload: payload ?? this.payload,
      sortKey: sortKey ?? this.sortKey,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<Uint8List>(albumId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<Uint8List>(assetId.value);
    }
    if (anchorAssetId.present) {
      map['anchor_asset_id'] = Variable<Uint8List>(anchorAssetId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (sortKey.present) {
      map['sort_key'] = Variable<String>(sortKey.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumItemCompanion(')
          ..write('id: $id, ')
          ..write('albumId: $albumId, ')
          ..write('kind: $kind, ')
          ..write('assetId: $assetId, ')
          ..write('anchorAssetId: $anchorAssetId, ')
          ..write('payload: $payload, ')
          ..write('sortKey: $sortKey, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AlbumMember extends Table with TableInfo<AlbumMember, AlbumMemberData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AlbumMember(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> albumId = GeneratedColumn<Uint8List>(
    'album_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> userId = GeneratedColumn<Uint8List>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [albumId, userId, role, txid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'album_member';
  @override
  Set<GeneratedColumn> get $primaryKey => {albumId, userId};
  @override
  AlbumMemberData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumMemberData(
      albumId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}album_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  AlbumMember createAlias(String alias) {
    return AlbumMember(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(album_id, user_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class AlbumMemberData extends DataClass implements Insertable<AlbumMemberData> {
  final Uint8List albumId;
  final Uint8List userId;
  final String role;

  /// viewer, contributor, editor
  final int? txid;
  const AlbumMemberData({
    required this.albumId,
    required this.userId,
    required this.role,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['album_id'] = Variable<Uint8List>(albumId);
    map['user_id'] = Variable<Uint8List>(userId);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AlbumMemberData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumMemberData(
      albumId: serializer.fromJson<Uint8List>(json['album_id']),
      userId: serializer.fromJson<Uint8List>(json['user_id']),
      role: serializer.fromJson<String>(json['role']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'album_id': serializer.toJson<Uint8List>(albumId),
      'user_id': serializer.toJson<Uint8List>(userId),
      'role': serializer.toJson<String>(role),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AlbumMemberData copyWith({
    Uint8List? albumId,
    Uint8List? userId,
    String? role,
    Value<int?> txid = const Value.absent(),
  }) => AlbumMemberData(
    albumId: albumId ?? this.albumId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    txid: txid.present ? txid.value : this.txid,
  );
  AlbumMemberData copyWithCompanion(AlbumMemberCompanion data) {
    return AlbumMemberData(
      albumId: data.albumId.present ? data.albumId.value : this.albumId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumMemberData(')
          ..write('albumId: $albumId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(albumId),
    $driftBlobEquality.hash(userId),
    role,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumMemberData &&
          $driftBlobEquality.equals(other.albumId, this.albumId) &&
          $driftBlobEquality.equals(other.userId, this.userId) &&
          other.role == this.role &&
          other.txid == this.txid);
}

class AlbumMemberCompanion extends UpdateCompanion<AlbumMemberData> {
  final Value<Uint8List> albumId;
  final Value<Uint8List> userId;
  final Value<String> role;
  final Value<int?> txid;
  final Value<int> rowid;
  const AlbumMemberCompanion({
    this.albumId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumMemberCompanion.insert({
    required Uint8List albumId,
    required Uint8List userId,
    required String role,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : albumId = Value(albumId),
       userId = Value(userId),
       role = Value(role);
  static Insertable<AlbumMemberData> custom({
    Expression<Uint8List>? albumId,
    Expression<Uint8List>? userId,
    Expression<String>? role,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (albumId != null) 'album_id': albumId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumMemberCompanion copyWith({
    Value<Uint8List>? albumId,
    Value<Uint8List>? userId,
    Value<String>? role,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AlbumMemberCompanion(
      albumId: albumId ?? this.albumId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (albumId.present) {
      map['album_id'] = Variable<Uint8List>(albumId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<Uint8List>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumMemberCompanion(')
          ..write('albumId: $albumId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Tag extends Table with TableInfo<Tag, TagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Tag(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> parentId = GeneratedColumn<Uint8List>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> isAlbum = GeneratedColumn<int>(
    'is_album',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'user\'',
    defaultValue: const CustomExpression('\'user\''),
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    parentId,
    name,
    path,
    color,
    isAlbum,
    origin,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      isAlbum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_album'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  Tag createAlias(String alias) {
    return Tag(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class TagData extends DataClass implements Insertable<TagData> {
  final Uint8List id;
  final Uint8List ownerId;
  final Uint8List? parentId;
  final String name;
  final String path;

  /// materialised, e.g. Places|Europe|Paris
  final String? color;
  final int isAlbum;
  final String origin;

  /// user, import, auto-accepted
  final int? txid;
  const TagData({
    required this.id,
    required this.ownerId,
    this.parentId,
    required this.name,
    required this.path,
    this.color,
    required this.isAlbum,
    required this.origin,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['owner_id'] = Variable<Uint8List>(ownerId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<Uint8List>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['is_album'] = Variable<int>(isAlbum);
    map['origin'] = Variable<String>(origin);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory TagData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagData(
      id: serializer.fromJson<Uint8List>(json['id']),
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      parentId: serializer.fromJson<Uint8List?>(json['parent_id']),
      name: serializer.fromJson<String>(json['name']),
      path: serializer.fromJson<String>(json['path']),
      color: serializer.fromJson<String?>(json['color']),
      isAlbum: serializer.fromJson<int>(json['is_album']),
      origin: serializer.fromJson<String>(json['origin']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'parent_id': serializer.toJson<Uint8List?>(parentId),
      'name': serializer.toJson<String>(name),
      'path': serializer.toJson<String>(path),
      'color': serializer.toJson<String?>(color),
      'is_album': serializer.toJson<int>(isAlbum),
      'origin': serializer.toJson<String>(origin),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  TagData copyWith({
    Uint8List? id,
    Uint8List? ownerId,
    Value<Uint8List?> parentId = const Value.absent(),
    String? name,
    String? path,
    Value<String?> color = const Value.absent(),
    int? isAlbum,
    String? origin,
    Value<int?> txid = const Value.absent(),
  }) => TagData(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    path: path ?? this.path,
    color: color.present ? color.value : this.color,
    isAlbum: isAlbum ?? this.isAlbum,
    origin: origin ?? this.origin,
    txid: txid.present ? txid.value : this.txid,
  );
  TagData copyWithCompanion(TagCompanion data) {
    return TagData(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      path: data.path.present ? data.path.value : this.path,
      color: data.color.present ? data.color.value : this.color,
      isAlbum: data.isAlbum.present ? data.isAlbum.value : this.isAlbum,
      origin: data.origin.present ? data.origin.value : this.origin,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagData(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('color: $color, ')
          ..write('isAlbum: $isAlbum, ')
          ..write('origin: $origin, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(ownerId),
    $driftBlobEquality.hash(parentId),
    name,
    path,
    color,
    isAlbum,
    origin,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          $driftBlobEquality.equals(other.parentId, this.parentId) &&
          other.name == this.name &&
          other.path == this.path &&
          other.color == this.color &&
          other.isAlbum == this.isAlbum &&
          other.origin == this.origin &&
          other.txid == this.txid);
}

class TagCompanion extends UpdateCompanion<TagData> {
  final Value<Uint8List> id;
  final Value<Uint8List> ownerId;
  final Value<Uint8List?> parentId;
  final Value<String> name;
  final Value<String> path;
  final Value<String?> color;
  final Value<int> isAlbum;
  final Value<String> origin;
  final Value<int?> txid;
  final Value<int> rowid;
  const TagCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.path = const Value.absent(),
    this.color = const Value.absent(),
    this.isAlbum = const Value.absent(),
    this.origin = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagCompanion.insert({
    required Uint8List id,
    required Uint8List ownerId,
    this.parentId = const Value.absent(),
    required String name,
    required String path,
    this.color = const Value.absent(),
    this.isAlbum = const Value.absent(),
    this.origin = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       name = Value(name),
       path = Value(path);
  static Insertable<TagData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? ownerId,
    Expression<Uint8List>? parentId,
    Expression<String>? name,
    Expression<String>? path,
    Expression<String>? color,
    Expression<int>? isAlbum,
    Expression<String>? origin,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (path != null) 'path': path,
      if (color != null) 'color': color,
      if (isAlbum != null) 'is_album': isAlbum,
      if (origin != null) 'origin': origin,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? ownerId,
    Value<Uint8List?>? parentId,
    Value<String>? name,
    Value<String>? path,
    Value<String?>? color,
    Value<int>? isAlbum,
    Value<String>? origin,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return TagCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      path: path ?? this.path,
      color: color ?? this.color,
      isAlbum: isAlbum ?? this.isAlbum,
      origin: origin ?? this.origin,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<Uint8List>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isAlbum.present) {
      map['is_album'] = Variable<int>(isAlbum.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('path: $path, ')
          ..write('color: $color, ')
          ..write('isAlbum: $isAlbum, ')
          ..write('origin: $origin, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AssetTag extends Table with TableInfo<AssetTag, AssetTagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AssetTag(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> tagId = GeneratedColumn<Uint8List>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'user\'',
    defaultValue: const CustomExpression('\'user\''),
  );
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    assetId,
    tagId,
    origin,
    confidence,
    createdAt,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_tag';
  @override
  Set<GeneratedColumn> get $primaryKey => {assetId, tagId};
  @override
  AssetTagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetTagData(
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}tag_id'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  AssetTag createAlias(String alias) {
    return AssetTag(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const ['PRIMARY KEY(asset_id, tag_id)'];
  @override
  bool get dontWriteConstraints => true;
}

class AssetTagData extends DataClass implements Insertable<AssetTagData> {
  final Uint8List assetId;
  final Uint8List tagId;
  final String origin;

  /// user, import, ml
  final double? confidence;
  final int createdAt;
  final int? txid;
  const AssetTagData({
    required this.assetId,
    required this.tagId,
    required this.origin,
    this.confidence,
    required this.createdAt,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<Uint8List>(assetId);
    map['tag_id'] = Variable<Uint8List>(tagId);
    map['origin'] = Variable<String>(origin);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory AssetTagData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetTagData(
      assetId: serializer.fromJson<Uint8List>(json['asset_id']),
      tagId: serializer.fromJson<Uint8List>(json['tag_id']),
      origin: serializer.fromJson<String>(json['origin']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'asset_id': serializer.toJson<Uint8List>(assetId),
      'tag_id': serializer.toJson<Uint8List>(tagId),
      'origin': serializer.toJson<String>(origin),
      'confidence': serializer.toJson<double?>(confidence),
      'created_at': serializer.toJson<int>(createdAt),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  AssetTagData copyWith({
    Uint8List? assetId,
    Uint8List? tagId,
    String? origin,
    Value<double?> confidence = const Value.absent(),
    int? createdAt,
    Value<int?> txid = const Value.absent(),
  }) => AssetTagData(
    assetId: assetId ?? this.assetId,
    tagId: tagId ?? this.tagId,
    origin: origin ?? this.origin,
    confidence: confidence.present ? confidence.value : this.confidence,
    createdAt: createdAt ?? this.createdAt,
    txid: txid.present ? txid.value : this.txid,
  );
  AssetTagData copyWithCompanion(AssetTagCompanion data) {
    return AssetTagData(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      origin: data.origin.present ? data.origin.value : this.origin,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetTagData(')
          ..write('assetId: $assetId, ')
          ..write('tagId: $tagId, ')
          ..write('origin: $origin, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(assetId),
    $driftBlobEquality.hash(tagId),
    origin,
    confidence,
    createdAt,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetTagData &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          $driftBlobEquality.equals(other.tagId, this.tagId) &&
          other.origin == this.origin &&
          other.confidence == this.confidence &&
          other.createdAt == this.createdAt &&
          other.txid == this.txid);
}

class AssetTagCompanion extends UpdateCompanion<AssetTagData> {
  final Value<Uint8List> assetId;
  final Value<Uint8List> tagId;
  final Value<String> origin;
  final Value<double?> confidence;
  final Value<int> createdAt;
  final Value<int?> txid;
  final Value<int> rowid;
  const AssetTagCompanion({
    this.assetId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.origin = const Value.absent(),
    this.confidence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetTagCompanion.insert({
    required Uint8List assetId,
    required Uint8List tagId,
    this.origin = const Value.absent(),
    this.confidence = const Value.absent(),
    required int createdAt,
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : assetId = Value(assetId),
       tagId = Value(tagId),
       createdAt = Value(createdAt);
  static Insertable<AssetTagData> custom({
    Expression<Uint8List>? assetId,
    Expression<Uint8List>? tagId,
    Expression<String>? origin,
    Expression<double>? confidence,
    Expression<int>? createdAt,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (tagId != null) 'tag_id': tagId,
      if (origin != null) 'origin': origin,
      if (confidence != null) 'confidence': confidence,
      if (createdAt != null) 'created_at': createdAt,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetTagCompanion copyWith({
    Value<Uint8List>? assetId,
    Value<Uint8List>? tagId,
    Value<String>? origin,
    Value<double?>? confidence,
    Value<int>? createdAt,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return AssetTagCompanion(
      assetId: assetId ?? this.assetId,
      tagId: tagId ?? this.tagId,
      origin: origin ?? this.origin,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<Uint8List>(assetId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<Uint8List>(tagId.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetTagCompanion(')
          ..write('assetId: $assetId, ')
          ..write('tagId: $tagId, ')
          ..write('origin: $origin, ')
          ..write('confidence: $confidence, ')
          ..write('createdAt: $createdAt, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Person extends Table with TableInfo<Person, PersonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Person(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'human\'',
    defaultValue: const CustomExpression('\'human\''),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> coverFaceId =
      GeneratedColumn<Uint8List>(
        'cover_face_id',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<int> hidden = GeneratedColumn<int>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<Uint8List> mergedInto = GeneratedColumn<Uint8List>(
    'merged_into',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    kind,
    name,
    birthDate,
    coverFaceId,
    hidden,
    mergedInto,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'person';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      ),
      coverFaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}cover_face_id'],
      ),
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden'],
      )!,
      mergedInto: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}merged_into'],
      ),
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  Person createAlias(String alias) {
    return Person(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class PersonData extends DataClass implements Insertable<PersonData> {
  final Uint8List id;
  final Uint8List ownerId;
  final String kind;

  /// human, pet
  final String? name;
  final String? birthDate;
  final Uint8List? coverFaceId;
  final int hidden;
  final Uint8List? mergedInto;
  final int? txid;
  const PersonData({
    required this.id,
    required this.ownerId,
    required this.kind,
    this.name,
    this.birthDate,
    this.coverFaceId,
    required this.hidden,
    this.mergedInto,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['owner_id'] = Variable<Uint8List>(ownerId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(birthDate);
    }
    if (!nullToAbsent || coverFaceId != null) {
      map['cover_face_id'] = Variable<Uint8List>(coverFaceId);
    }
    map['hidden'] = Variable<int>(hidden);
    if (!nullToAbsent || mergedInto != null) {
      map['merged_into'] = Variable<Uint8List>(mergedInto);
    }
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory PersonData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonData(
      id: serializer.fromJson<Uint8List>(json['id']),
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      kind: serializer.fromJson<String>(json['kind']),
      name: serializer.fromJson<String?>(json['name']),
      birthDate: serializer.fromJson<String?>(json['birth_date']),
      coverFaceId: serializer.fromJson<Uint8List?>(json['cover_face_id']),
      hidden: serializer.fromJson<int>(json['hidden']),
      mergedInto: serializer.fromJson<Uint8List?>(json['merged_into']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'kind': serializer.toJson<String>(kind),
      'name': serializer.toJson<String?>(name),
      'birth_date': serializer.toJson<String?>(birthDate),
      'cover_face_id': serializer.toJson<Uint8List?>(coverFaceId),
      'hidden': serializer.toJson<int>(hidden),
      'merged_into': serializer.toJson<Uint8List?>(mergedInto),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  PersonData copyWith({
    Uint8List? id,
    Uint8List? ownerId,
    String? kind,
    Value<String?> name = const Value.absent(),
    Value<String?> birthDate = const Value.absent(),
    Value<Uint8List?> coverFaceId = const Value.absent(),
    int? hidden,
    Value<Uint8List?> mergedInto = const Value.absent(),
    Value<int?> txid = const Value.absent(),
  }) => PersonData(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    kind: kind ?? this.kind,
    name: name.present ? name.value : this.name,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    coverFaceId: coverFaceId.present ? coverFaceId.value : this.coverFaceId,
    hidden: hidden ?? this.hidden,
    mergedInto: mergedInto.present ? mergedInto.value : this.mergedInto,
    txid: txid.present ? txid.value : this.txid,
  );
  PersonData copyWithCompanion(PersonCompanion data) {
    return PersonData(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      coverFaceId: data.coverFaceId.present
          ? data.coverFaceId.value
          : this.coverFaceId,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      mergedInto: data.mergedInto.present
          ? data.mergedInto.value
          : this.mergedInto,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonData(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('coverFaceId: $coverFaceId, ')
          ..write('hidden: $hidden, ')
          ..write('mergedInto: $mergedInto, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(ownerId),
    kind,
    name,
    birthDate,
    $driftBlobEquality.hash(coverFaceId),
    hidden,
    $driftBlobEquality.hash(mergedInto),
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          $driftBlobEquality.equals(other.coverFaceId, this.coverFaceId) &&
          other.hidden == this.hidden &&
          $driftBlobEquality.equals(other.mergedInto, this.mergedInto) &&
          other.txid == this.txid);
}

class PersonCompanion extends UpdateCompanion<PersonData> {
  final Value<Uint8List> id;
  final Value<Uint8List> ownerId;
  final Value<String> kind;
  final Value<String?> name;
  final Value<String?> birthDate;
  final Value<Uint8List?> coverFaceId;
  final Value<int> hidden;
  final Value<Uint8List?> mergedInto;
  final Value<int?> txid;
  final Value<int> rowid;
  const PersonCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.coverFaceId = const Value.absent(),
    this.hidden = const Value.absent(),
    this.mergedInto = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonCompanion.insert({
    required Uint8List id,
    required Uint8List ownerId,
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.coverFaceId = const Value.absent(),
    this.hidden = const Value.absent(),
    this.mergedInto = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId);
  static Insertable<PersonData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? ownerId,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? birthDate,
    Expression<Uint8List>? coverFaceId,
    Expression<int>? hidden,
    Expression<Uint8List>? mergedInto,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (coverFaceId != null) 'cover_face_id': coverFaceId,
      if (hidden != null) 'hidden': hidden,
      if (mergedInto != null) 'merged_into': mergedInto,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? ownerId,
    Value<String>? kind,
    Value<String?>? name,
    Value<String?>? birthDate,
    Value<Uint8List?>? coverFaceId,
    Value<int>? hidden,
    Value<Uint8List?>? mergedInto,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return PersonCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      coverFaceId: coverFaceId ?? this.coverFaceId,
      hidden: hidden ?? this.hidden,
      mergedInto: mergedInto ?? this.mergedInto,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (coverFaceId.present) {
      map['cover_face_id'] = Variable<Uint8List>(coverFaceId.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<int>(hidden.value);
    }
    if (mergedInto.present) {
      map['merged_into'] = Variable<Uint8List>(mergedInto.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('coverFaceId: $coverFaceId, ')
          ..write('hidden: $hidden, ')
          ..write('mergedInto: $mergedInto, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Face extends Table with TableInfo<Face, FaceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Face(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> bbox = GeneratedColumn<String>(
    'bbox',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> quality = GeneratedColumn<double>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> personId = GeneratedColumn<Uint8List>(
    'person_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> assignment = GeneratedColumn<String>(
    'assignment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'auto\'',
    defaultValue: const CustomExpression('\'auto\''),
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetId,
    bbox,
    quality,
    personId,
    assignment,
    txid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'face';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FaceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FaceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      )!,
      bbox: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bbox'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quality'],
      ),
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}person_id'],
      ),
      assignment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignment'],
      )!,
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  Face createAlias(String alias) {
    return Face(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class FaceData extends DataClass implements Insertable<FaceData> {
  final Uint8List id;
  final Uint8List assetId;
  final String bbox;

  /// normalised x,y,w,h
  final double? quality;
  final Uint8List? personId;
  final String assignment;

  /// auto, user, import
  final int? txid;
  const FaceData({
    required this.id,
    required this.assetId,
    required this.bbox,
    this.quality,
    this.personId,
    required this.assignment,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['asset_id'] = Variable<Uint8List>(assetId);
    map['bbox'] = Variable<String>(bbox);
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<double>(quality);
    }
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<Uint8List>(personId);
    }
    map['assignment'] = Variable<String>(assignment);
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory FaceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FaceData(
      id: serializer.fromJson<Uint8List>(json['id']),
      assetId: serializer.fromJson<Uint8List>(json['asset_id']),
      bbox: serializer.fromJson<String>(json['bbox']),
      quality: serializer.fromJson<double?>(json['quality']),
      personId: serializer.fromJson<Uint8List?>(json['person_id']),
      assignment: serializer.fromJson<String>(json['assignment']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'asset_id': serializer.toJson<Uint8List>(assetId),
      'bbox': serializer.toJson<String>(bbox),
      'quality': serializer.toJson<double?>(quality),
      'person_id': serializer.toJson<Uint8List?>(personId),
      'assignment': serializer.toJson<String>(assignment),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  FaceData copyWith({
    Uint8List? id,
    Uint8List? assetId,
    String? bbox,
    Value<double?> quality = const Value.absent(),
    Value<Uint8List?> personId = const Value.absent(),
    String? assignment,
    Value<int?> txid = const Value.absent(),
  }) => FaceData(
    id: id ?? this.id,
    assetId: assetId ?? this.assetId,
    bbox: bbox ?? this.bbox,
    quality: quality.present ? quality.value : this.quality,
    personId: personId.present ? personId.value : this.personId,
    assignment: assignment ?? this.assignment,
    txid: txid.present ? txid.value : this.txid,
  );
  FaceData copyWithCompanion(FaceCompanion data) {
    return FaceData(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      bbox: data.bbox.present ? data.bbox.value : this.bbox,
      quality: data.quality.present ? data.quality.value : this.quality,
      personId: data.personId.present ? data.personId.value : this.personId,
      assignment: data.assignment.present
          ? data.assignment.value
          : this.assignment,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FaceData(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('bbox: $bbox, ')
          ..write('quality: $quality, ')
          ..write('personId: $personId, ')
          ..write('assignment: $assignment, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(id),
    $driftBlobEquality.hash(assetId),
    bbox,
    quality,
    $driftBlobEquality.hash(personId),
    assignment,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FaceData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          other.bbox == this.bbox &&
          other.quality == this.quality &&
          $driftBlobEquality.equals(other.personId, this.personId) &&
          other.assignment == this.assignment &&
          other.txid == this.txid);
}

class FaceCompanion extends UpdateCompanion<FaceData> {
  final Value<Uint8List> id;
  final Value<Uint8List> assetId;
  final Value<String> bbox;
  final Value<double?> quality;
  final Value<Uint8List?> personId;
  final Value<String> assignment;
  final Value<int?> txid;
  final Value<int> rowid;
  const FaceCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.bbox = const Value.absent(),
    this.quality = const Value.absent(),
    this.personId = const Value.absent(),
    this.assignment = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FaceCompanion.insert({
    required Uint8List id,
    required Uint8List assetId,
    required String bbox,
    this.quality = const Value.absent(),
    this.personId = const Value.absent(),
    this.assignment = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetId = Value(assetId),
       bbox = Value(bbox);
  static Insertable<FaceData> custom({
    Expression<Uint8List>? id,
    Expression<Uint8List>? assetId,
    Expression<String>? bbox,
    Expression<double>? quality,
    Expression<Uint8List>? personId,
    Expression<String>? assignment,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (bbox != null) 'bbox': bbox,
      if (quality != null) 'quality': quality,
      if (personId != null) 'person_id': personId,
      if (assignment != null) 'assignment': assignment,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FaceCompanion copyWith({
    Value<Uint8List>? id,
    Value<Uint8List>? assetId,
    Value<String>? bbox,
    Value<double?>? quality,
    Value<Uint8List?>? personId,
    Value<String>? assignment,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return FaceCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      bbox: bbox ?? this.bbox,
      quality: quality ?? this.quality,
      personId: personId ?? this.personId,
      assignment: assignment ?? this.assignment,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<Uint8List>(assetId.value);
    }
    if (bbox.present) {
      map['bbox'] = Variable<String>(bbox.value);
    }
    if (quality.present) {
      map['quality'] = Variable<double>(quality.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<Uint8List>(personId.value);
    }
    if (assignment.present) {
      map['assignment'] = Variable<String>(assignment.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FaceCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('bbox: $bbox, ')
          ..write('quality: $quality, ')
          ..write('personId: $personId, ')
          ..write('assignment: $assignment, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class LocalAsset extends Table with TableInfo<LocalAsset, LocalAssetData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LocalAsset(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> volume = GeneratedColumn<String>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> generation = GeneratedColumn<String>(
    'generation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> mtime = GeneratedColumn<int>(
    'mtime',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> contentHash =
      GeneratedColumn<Uint8List>(
        'content_hash',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'present\'',
    defaultValue: const CustomExpression('\'present\''),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> bucketName = GeneratedColumn<String>(
    'bucket_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> taken = GeneratedColumn<int>(
    'taken',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> orientation = GeneratedColumn<int>(
    'orientation',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> favorite = GeneratedColumn<int>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> trashed = GeneratedColumn<int>(
    'trashed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> expires = GeneratedColumn<int>(
    'expires',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> extracted = GeneratedColumn<int>(
    'extracted',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> takenLocal = GeneratedColumn<String>(
    'taken_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> tzOffsetMin = GeneratedColumn<int>(
    'tz_offset_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> takenUtc = GeneratedColumn<int>(
    'taken_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> timeSource = GeneratedColumn<String>(
    'time_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> timeConfidence = GeneratedColumn<int>(
    'time_confidence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> timePrecision = GeneratedColumn<String>(
    'time_precision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> facets = GeneratedColumn<String>(
    'facets',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> cloudId = GeneratedColumn<String>(
    'cloud_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> burstId = GeneratedColumn<String>(
    'burst_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> edited = GeneratedColumn<int>(
    'edited',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> added = GeneratedColumn<int>(
    'added',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> thumbhash = GeneratedColumn<Uint8List>(
    'thumbhash',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> motionOffset = GeneratedColumn<int>(
    'motion_offset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> motionLength = GeneratedColumn<int>(
    'motion_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<double> frameRate = GeneratedColumn<double>(
    'frame_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> projection = GeneratedColumn<String>(
    'projection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
    'crop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> stereo = GeneratedColumn<String>(
    'stereo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
    'heading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> hidden = GeneratedColumn<int>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> bin = GeneratedColumn<String>(
    'bin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<Uint8List> fingerprint =
      GeneratedColumn<Uint8List>(
        'fingerprint',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  late final GeneratedColumn<int> tile = GeneratedColumn<int>(
    'tile',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    volume,
    sourceId,
    generation,
    size,
    mtime,
    contentHash,
    assetId,
    path,
    fileId,
    state,
    name,
    bucketId,
    bucketName,
    mime,
    taken,
    width,
    height,
    orientation,
    durationMs,
    favorite,
    trashed,
    expires,
    extracted,
    takenLocal,
    tzOffsetMin,
    takenUtc,
    timeSource,
    timeConfidence,
    timePrecision,
    lat,
    lon,
    make,
    model,
    facets,
    cloudId,
    burstId,
    edited,
    added,
    thumbhash,
    motionOffset,
    motionLength,
    frameRate,
    projection,
    crop,
    stereo,
    folder,
    heading,
    hidden,
    archived,
    bin,
    fingerprint,
    tile,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_asset';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {source, volume, sourceId},
  ];
  @override
  LocalAssetData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAssetData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}volume'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      generation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generation'],
      ),
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mtime'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content_hash'],
      ),
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      ),
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      ),
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      ),
      bucketName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_name'],
      ),
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      ),
      taken: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taken'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      orientation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orientation'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}favorite'],
      )!,
      trashed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trashed'],
      )!,
      expires: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires'],
      ),
      extracted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}extracted'],
      ),
      takenLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}taken_local'],
      ),
      tzOffsetMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tz_offset_min'],
      ),
      takenUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taken_utc'],
      ),
      timeSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_source'],
      ),
      timeConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_confidence'],
      ),
      timePrecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_precision'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      ),
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      facets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facets'],
      ),
      cloudId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cloud_id'],
      ),
      burstId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}burst_id'],
      ),
      edited: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edited'],
      )!,
      added: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added'],
      ),
      thumbhash: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumbhash'],
      ),
      motionOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motion_offset'],
      ),
      motionLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motion_length'],
      ),
      frameRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}frame_rate'],
      ),
      projection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}projection'],
      ),
      crop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop'],
      ),
      stereo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stereo'],
      ),
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      heading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading'],
      ),
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      bin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bin'],
      ),
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}fingerprint'],
      ),
      tile: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tile'],
      )!,
    );
  }

  @override
  LocalAsset createAlias(String alias) {
    return LocalAsset(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
    'UNIQUE(source, volume, source_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class LocalAssetData extends DataClass implements Insertable<LocalAssetData> {
  final Uint8List id;
  final String source;

  /// mediastore, photokit, folder, web
  final String volume;

  /// for a folder file, the root of its media_source
  /// MediaStore id or PHAsset localIdentifier. A folder file's path and file id both change (moves, remounts), so it
  /// is the row's own id in hex, and the scanner matches path and file_id (folders.dart).
  final String sourceId;
  final String? generation;

  /// MediaStore GENERATION_ADDED; for PhotoKit, the sync that last read the asset
  final int size;
  final int mtime;
  final Uint8List? contentHash;

  /// computed lazily
  final Uint8List? assetId;

  /// set once matched or uploaded
  final String? path;

  /// a folder file's path under its root, '/'-separated; MediaStore's, relative to the volume, ending in '/'
  final String? fileId;

  /// a folder file's inode or NTFS file id, which a rename keeps
  final String state;

  /// present, offline (its drive is away), missing; never deleted for either
  /// Schema 3: what MediaStore says of the item until its metadata is extracted (docs/10-client-app.md §5.2).
  final String? name;
  final String? bucketId;

  /// the folder, which device galleries show as an album
  final String? bucketName;
  final String? mime;
  final int? taken;

  /// DATE_TAKEN, a provisional sort key
  /// Extraction fills in what the platform left NULL.
  final int? width;
  final int? height;
  final int? orientation;

  /// clockwise degrees
  final int? durationMs;
  final int favorite;
  final int trashed;

  /// in the system trash, until expires
  final int? expires;

  /// Schema 4: what metadata extraction read in the file (metadata.dart), as in asset; NULL until it ran.
  final int? extracted;

  /// when it read this version of the file; NULL while pending
  final String? takenLocal;

  /// the kernel's capture time
  final int? tzOffsetMin;
  final int? takenUtc;
  final String? timeSource;
  final int? timeConfidence;
  final String? timePrecision;
  final double? lat;
  final double? lon;
  final String? make;
  final String? model;
  final String? facets;

  /// comma-separated: motion_photo, panorama, animated, hdr; PhotoKit's subtypes and bursts (photo_kit.dart)
  /// Schema 5: what PhotoKit says of an asset (docs/10-client-app.md §6.1).
  final String? cloudId;

  /// PHCloudIdentifier, which names the asset on every device of the iCloud library
  final String? burstId;
  final int edited;

  /// Photos holds an edit over the original
  /// Schema 6: when this device's index first saw the item, the time in its UUIDv7 id: its date added (VIEW-06).
  final int? added;

  /// Schema 8: the ThumbHash of its thumbnail, which a cell paints until the thumbnail shows (docs/10-client-app.md
  /// §3.4, T0); the thumbnail warm-up computes it.
  final Uint8List? thumbhash;

  /// Schema 9: where extraction found a motion photo's video in the file (docs/10-client-app.md §4.3).
  final int? motionOffset;
  final int? motionLength;

  /// Schema 12: a video's frames a second, on average, which the viewer steps by (ReadMetadataResponse.frame_rate).
  final double? frameRate;

  /// Schema 13: how a photo sphere or 360° video is projected, from its metadata (docs/10-client-app.md §4.4); NULL when
  /// flat. The kernel's projection, its GPano crop as `left,top,width,height,full width,full height` when it is partial,
  /// and its stereo packing: top_bottom, left_right or right_left.
  final String? projection;
  final String? crop;
  final String? stereo;

  /// Schema 14: a MediaStore item's device_folder, schema 21 a folder file's too; 0 for PhotoKit's, which no folder
  /// setting hides.
  final int folder;

  /// Schema 16: GPano's PoseHeadingDegrees, the compass heading of the full panorama's middle, which compass lock aligns.
  final double? heading;

  /// Schema 24, Photolib's own state of the item, never read from a .nomedia or the OS (ADR-0245): hidden is out of
  /// every view, archived out of the timeline; `bin` is where the platform's trash keeps a file Photolib moved there,
  /// for its restore; `fingerprint` names its content (kept_state).
  final int hidden;
  final int archived;
  final String? bin;
  final Uint8List? fingerprint;

  /// Schema 27: how the timeline shows a present item (ADR-0267), kept by the triggers below: 0 a tile not backed up, 1
  /// a tile backed up (its asset is in a managed library), 2 none (its asset is trashed, archived or locked, or a copy
  /// with a smaller id shows it).
  final int tile;
  const LocalAssetData({
    required this.id,
    required this.source,
    required this.volume,
    required this.sourceId,
    this.generation,
    required this.size,
    required this.mtime,
    this.contentHash,
    this.assetId,
    this.path,
    this.fileId,
    required this.state,
    this.name,
    this.bucketId,
    this.bucketName,
    this.mime,
    this.taken,
    this.width,
    this.height,
    this.orientation,
    this.durationMs,
    required this.favorite,
    required this.trashed,
    this.expires,
    this.extracted,
    this.takenLocal,
    this.tzOffsetMin,
    this.takenUtc,
    this.timeSource,
    this.timeConfidence,
    this.timePrecision,
    this.lat,
    this.lon,
    this.make,
    this.model,
    this.facets,
    this.cloudId,
    this.burstId,
    required this.edited,
    this.added,
    this.thumbhash,
    this.motionOffset,
    this.motionLength,
    this.frameRate,
    this.projection,
    this.crop,
    this.stereo,
    required this.folder,
    this.heading,
    required this.hidden,
    required this.archived,
    this.bin,
    this.fingerprint,
    required this.tile,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<Uint8List>(id);
    map['source'] = Variable<String>(source);
    map['volume'] = Variable<String>(volume);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || generation != null) {
      map['generation'] = Variable<String>(generation);
    }
    map['size'] = Variable<int>(size);
    map['mtime'] = Variable<int>(mtime);
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<Uint8List>(contentHash);
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<Uint8List>(assetId);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || fileId != null) {
      map['file_id'] = Variable<String>(fileId);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || bucketId != null) {
      map['bucket_id'] = Variable<String>(bucketId);
    }
    if (!nullToAbsent || bucketName != null) {
      map['bucket_name'] = Variable<String>(bucketName);
    }
    if (!nullToAbsent || mime != null) {
      map['mime'] = Variable<String>(mime);
    }
    if (!nullToAbsent || taken != null) {
      map['taken'] = Variable<int>(taken);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || orientation != null) {
      map['orientation'] = Variable<int>(orientation);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['favorite'] = Variable<int>(favorite);
    map['trashed'] = Variable<int>(trashed);
    if (!nullToAbsent || expires != null) {
      map['expires'] = Variable<int>(expires);
    }
    if (!nullToAbsent || extracted != null) {
      map['extracted'] = Variable<int>(extracted);
    }
    if (!nullToAbsent || takenLocal != null) {
      map['taken_local'] = Variable<String>(takenLocal);
    }
    if (!nullToAbsent || tzOffsetMin != null) {
      map['tz_offset_min'] = Variable<int>(tzOffsetMin);
    }
    if (!nullToAbsent || takenUtc != null) {
      map['taken_utc'] = Variable<int>(takenUtc);
    }
    if (!nullToAbsent || timeSource != null) {
      map['time_source'] = Variable<String>(timeSource);
    }
    if (!nullToAbsent || timeConfidence != null) {
      map['time_confidence'] = Variable<int>(timeConfidence);
    }
    if (!nullToAbsent || timePrecision != null) {
      map['time_precision'] = Variable<String>(timePrecision);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lon != null) {
      map['lon'] = Variable<double>(lon);
    }
    if (!nullToAbsent || make != null) {
      map['make'] = Variable<String>(make);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || facets != null) {
      map['facets'] = Variable<String>(facets);
    }
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<String>(cloudId);
    }
    if (!nullToAbsent || burstId != null) {
      map['burst_id'] = Variable<String>(burstId);
    }
    map['edited'] = Variable<int>(edited);
    if (!nullToAbsent || added != null) {
      map['added'] = Variable<int>(added);
    }
    if (!nullToAbsent || thumbhash != null) {
      map['thumbhash'] = Variable<Uint8List>(thumbhash);
    }
    if (!nullToAbsent || motionOffset != null) {
      map['motion_offset'] = Variable<int>(motionOffset);
    }
    if (!nullToAbsent || motionLength != null) {
      map['motion_length'] = Variable<int>(motionLength);
    }
    if (!nullToAbsent || frameRate != null) {
      map['frame_rate'] = Variable<double>(frameRate);
    }
    if (!nullToAbsent || projection != null) {
      map['projection'] = Variable<String>(projection);
    }
    if (!nullToAbsent || crop != null) {
      map['crop'] = Variable<String>(crop);
    }
    if (!nullToAbsent || stereo != null) {
      map['stereo'] = Variable<String>(stereo);
    }
    map['folder'] = Variable<int>(folder);
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<double>(heading);
    }
    map['hidden'] = Variable<int>(hidden);
    map['archived'] = Variable<int>(archived);
    if (!nullToAbsent || bin != null) {
      map['bin'] = Variable<String>(bin);
    }
    if (!nullToAbsent || fingerprint != null) {
      map['fingerprint'] = Variable<Uint8List>(fingerprint);
    }
    map['tile'] = Variable<int>(tile);
    return map;
  }

  factory LocalAssetData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAssetData(
      id: serializer.fromJson<Uint8List>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      volume: serializer.fromJson<String>(json['volume']),
      sourceId: serializer.fromJson<String>(json['source_id']),
      generation: serializer.fromJson<String?>(json['generation']),
      size: serializer.fromJson<int>(json['size']),
      mtime: serializer.fromJson<int>(json['mtime']),
      contentHash: serializer.fromJson<Uint8List?>(json['content_hash']),
      assetId: serializer.fromJson<Uint8List?>(json['asset_id']),
      path: serializer.fromJson<String?>(json['path']),
      fileId: serializer.fromJson<String?>(json['file_id']),
      state: serializer.fromJson<String>(json['state']),
      name: serializer.fromJson<String?>(json['name']),
      bucketId: serializer.fromJson<String?>(json['bucket_id']),
      bucketName: serializer.fromJson<String?>(json['bucket_name']),
      mime: serializer.fromJson<String?>(json['mime']),
      taken: serializer.fromJson<int?>(json['taken']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      orientation: serializer.fromJson<int?>(json['orientation']),
      durationMs: serializer.fromJson<int?>(json['duration_ms']),
      favorite: serializer.fromJson<int>(json['favorite']),
      trashed: serializer.fromJson<int>(json['trashed']),
      expires: serializer.fromJson<int?>(json['expires']),
      extracted: serializer.fromJson<int?>(json['extracted']),
      takenLocal: serializer.fromJson<String?>(json['taken_local']),
      tzOffsetMin: serializer.fromJson<int?>(json['tz_offset_min']),
      takenUtc: serializer.fromJson<int?>(json['taken_utc']),
      timeSource: serializer.fromJson<String?>(json['time_source']),
      timeConfidence: serializer.fromJson<int?>(json['time_confidence']),
      timePrecision: serializer.fromJson<String?>(json['time_precision']),
      lat: serializer.fromJson<double?>(json['lat']),
      lon: serializer.fromJson<double?>(json['lon']),
      make: serializer.fromJson<String?>(json['make']),
      model: serializer.fromJson<String?>(json['model']),
      facets: serializer.fromJson<String?>(json['facets']),
      cloudId: serializer.fromJson<String?>(json['cloud_id']),
      burstId: serializer.fromJson<String?>(json['burst_id']),
      edited: serializer.fromJson<int>(json['edited']),
      added: serializer.fromJson<int?>(json['added']),
      thumbhash: serializer.fromJson<Uint8List?>(json['thumbhash']),
      motionOffset: serializer.fromJson<int?>(json['motion_offset']),
      motionLength: serializer.fromJson<int?>(json['motion_length']),
      frameRate: serializer.fromJson<double?>(json['frame_rate']),
      projection: serializer.fromJson<String?>(json['projection']),
      crop: serializer.fromJson<String?>(json['crop']),
      stereo: serializer.fromJson<String?>(json['stereo']),
      folder: serializer.fromJson<int>(json['folder']),
      heading: serializer.fromJson<double?>(json['heading']),
      hidden: serializer.fromJson<int>(json['hidden']),
      archived: serializer.fromJson<int>(json['archived']),
      bin: serializer.fromJson<String?>(json['bin']),
      fingerprint: serializer.fromJson<Uint8List?>(json['fingerprint']),
      tile: serializer.fromJson<int>(json['tile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'source': serializer.toJson<String>(source),
      'volume': serializer.toJson<String>(volume),
      'source_id': serializer.toJson<String>(sourceId),
      'generation': serializer.toJson<String?>(generation),
      'size': serializer.toJson<int>(size),
      'mtime': serializer.toJson<int>(mtime),
      'content_hash': serializer.toJson<Uint8List?>(contentHash),
      'asset_id': serializer.toJson<Uint8List?>(assetId),
      'path': serializer.toJson<String?>(path),
      'file_id': serializer.toJson<String?>(fileId),
      'state': serializer.toJson<String>(state),
      'name': serializer.toJson<String?>(name),
      'bucket_id': serializer.toJson<String?>(bucketId),
      'bucket_name': serializer.toJson<String?>(bucketName),
      'mime': serializer.toJson<String?>(mime),
      'taken': serializer.toJson<int?>(taken),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'orientation': serializer.toJson<int?>(orientation),
      'duration_ms': serializer.toJson<int?>(durationMs),
      'favorite': serializer.toJson<int>(favorite),
      'trashed': serializer.toJson<int>(trashed),
      'expires': serializer.toJson<int?>(expires),
      'extracted': serializer.toJson<int?>(extracted),
      'taken_local': serializer.toJson<String?>(takenLocal),
      'tz_offset_min': serializer.toJson<int?>(tzOffsetMin),
      'taken_utc': serializer.toJson<int?>(takenUtc),
      'time_source': serializer.toJson<String?>(timeSource),
      'time_confidence': serializer.toJson<int?>(timeConfidence),
      'time_precision': serializer.toJson<String?>(timePrecision),
      'lat': serializer.toJson<double?>(lat),
      'lon': serializer.toJson<double?>(lon),
      'make': serializer.toJson<String?>(make),
      'model': serializer.toJson<String?>(model),
      'facets': serializer.toJson<String?>(facets),
      'cloud_id': serializer.toJson<String?>(cloudId),
      'burst_id': serializer.toJson<String?>(burstId),
      'edited': serializer.toJson<int>(edited),
      'added': serializer.toJson<int?>(added),
      'thumbhash': serializer.toJson<Uint8List?>(thumbhash),
      'motion_offset': serializer.toJson<int?>(motionOffset),
      'motion_length': serializer.toJson<int?>(motionLength),
      'frame_rate': serializer.toJson<double?>(frameRate),
      'projection': serializer.toJson<String?>(projection),
      'crop': serializer.toJson<String?>(crop),
      'stereo': serializer.toJson<String?>(stereo),
      'folder': serializer.toJson<int>(folder),
      'heading': serializer.toJson<double?>(heading),
      'hidden': serializer.toJson<int>(hidden),
      'archived': serializer.toJson<int>(archived),
      'bin': serializer.toJson<String?>(bin),
      'fingerprint': serializer.toJson<Uint8List?>(fingerprint),
      'tile': serializer.toJson<int>(tile),
    };
  }

  LocalAssetData copyWith({
    Uint8List? id,
    String? source,
    String? volume,
    String? sourceId,
    Value<String?> generation = const Value.absent(),
    int? size,
    int? mtime,
    Value<Uint8List?> contentHash = const Value.absent(),
    Value<Uint8List?> assetId = const Value.absent(),
    Value<String?> path = const Value.absent(),
    Value<String?> fileId = const Value.absent(),
    String? state,
    Value<String?> name = const Value.absent(),
    Value<String?> bucketId = const Value.absent(),
    Value<String?> bucketName = const Value.absent(),
    Value<String?> mime = const Value.absent(),
    Value<int?> taken = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> orientation = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    int? favorite,
    int? trashed,
    Value<int?> expires = const Value.absent(),
    Value<int?> extracted = const Value.absent(),
    Value<String?> takenLocal = const Value.absent(),
    Value<int?> tzOffsetMin = const Value.absent(),
    Value<int?> takenUtc = const Value.absent(),
    Value<String?> timeSource = const Value.absent(),
    Value<int?> timeConfidence = const Value.absent(),
    Value<String?> timePrecision = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lon = const Value.absent(),
    Value<String?> make = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> facets = const Value.absent(),
    Value<String?> cloudId = const Value.absent(),
    Value<String?> burstId = const Value.absent(),
    int? edited,
    Value<int?> added = const Value.absent(),
    Value<Uint8List?> thumbhash = const Value.absent(),
    Value<int?> motionOffset = const Value.absent(),
    Value<int?> motionLength = const Value.absent(),
    Value<double?> frameRate = const Value.absent(),
    Value<String?> projection = const Value.absent(),
    Value<String?> crop = const Value.absent(),
    Value<String?> stereo = const Value.absent(),
    int? folder,
    Value<double?> heading = const Value.absent(),
    int? hidden,
    int? archived,
    Value<String?> bin = const Value.absent(),
    Value<Uint8List?> fingerprint = const Value.absent(),
    int? tile,
  }) => LocalAssetData(
    id: id ?? this.id,
    source: source ?? this.source,
    volume: volume ?? this.volume,
    sourceId: sourceId ?? this.sourceId,
    generation: generation.present ? generation.value : this.generation,
    size: size ?? this.size,
    mtime: mtime ?? this.mtime,
    contentHash: contentHash.present ? contentHash.value : this.contentHash,
    assetId: assetId.present ? assetId.value : this.assetId,
    path: path.present ? path.value : this.path,
    fileId: fileId.present ? fileId.value : this.fileId,
    state: state ?? this.state,
    name: name.present ? name.value : this.name,
    bucketId: bucketId.present ? bucketId.value : this.bucketId,
    bucketName: bucketName.present ? bucketName.value : this.bucketName,
    mime: mime.present ? mime.value : this.mime,
    taken: taken.present ? taken.value : this.taken,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    orientation: orientation.present ? orientation.value : this.orientation,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    favorite: favorite ?? this.favorite,
    trashed: trashed ?? this.trashed,
    expires: expires.present ? expires.value : this.expires,
    extracted: extracted.present ? extracted.value : this.extracted,
    takenLocal: takenLocal.present ? takenLocal.value : this.takenLocal,
    tzOffsetMin: tzOffsetMin.present ? tzOffsetMin.value : this.tzOffsetMin,
    takenUtc: takenUtc.present ? takenUtc.value : this.takenUtc,
    timeSource: timeSource.present ? timeSource.value : this.timeSource,
    timeConfidence: timeConfidence.present
        ? timeConfidence.value
        : this.timeConfidence,
    timePrecision: timePrecision.present
        ? timePrecision.value
        : this.timePrecision,
    lat: lat.present ? lat.value : this.lat,
    lon: lon.present ? lon.value : this.lon,
    make: make.present ? make.value : this.make,
    model: model.present ? model.value : this.model,
    facets: facets.present ? facets.value : this.facets,
    cloudId: cloudId.present ? cloudId.value : this.cloudId,
    burstId: burstId.present ? burstId.value : this.burstId,
    edited: edited ?? this.edited,
    added: added.present ? added.value : this.added,
    thumbhash: thumbhash.present ? thumbhash.value : this.thumbhash,
    motionOffset: motionOffset.present ? motionOffset.value : this.motionOffset,
    motionLength: motionLength.present ? motionLength.value : this.motionLength,
    frameRate: frameRate.present ? frameRate.value : this.frameRate,
    projection: projection.present ? projection.value : this.projection,
    crop: crop.present ? crop.value : this.crop,
    stereo: stereo.present ? stereo.value : this.stereo,
    folder: folder ?? this.folder,
    heading: heading.present ? heading.value : this.heading,
    hidden: hidden ?? this.hidden,
    archived: archived ?? this.archived,
    bin: bin.present ? bin.value : this.bin,
    fingerprint: fingerprint.present ? fingerprint.value : this.fingerprint,
    tile: tile ?? this.tile,
  );
  LocalAssetData copyWithCompanion(LocalAssetCompanion data) {
    return LocalAssetData(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      volume: data.volume.present ? data.volume.value : this.volume,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      generation: data.generation.present
          ? data.generation.value
          : this.generation,
      size: data.size.present ? data.size.value : this.size,
      mtime: data.mtime.present ? data.mtime.value : this.mtime,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      path: data.path.present ? data.path.value : this.path,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      state: data.state.present ? data.state.value : this.state,
      name: data.name.present ? data.name.value : this.name,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      bucketName: data.bucketName.present
          ? data.bucketName.value
          : this.bucketName,
      mime: data.mime.present ? data.mime.value : this.mime,
      taken: data.taken.present ? data.taken.value : this.taken,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      orientation: data.orientation.present
          ? data.orientation.value
          : this.orientation,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      trashed: data.trashed.present ? data.trashed.value : this.trashed,
      expires: data.expires.present ? data.expires.value : this.expires,
      extracted: data.extracted.present ? data.extracted.value : this.extracted,
      takenLocal: data.takenLocal.present
          ? data.takenLocal.value
          : this.takenLocal,
      tzOffsetMin: data.tzOffsetMin.present
          ? data.tzOffsetMin.value
          : this.tzOffsetMin,
      takenUtc: data.takenUtc.present ? data.takenUtc.value : this.takenUtc,
      timeSource: data.timeSource.present
          ? data.timeSource.value
          : this.timeSource,
      timeConfidence: data.timeConfidence.present
          ? data.timeConfidence.value
          : this.timeConfidence,
      timePrecision: data.timePrecision.present
          ? data.timePrecision.value
          : this.timePrecision,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      facets: data.facets.present ? data.facets.value : this.facets,
      cloudId: data.cloudId.present ? data.cloudId.value : this.cloudId,
      burstId: data.burstId.present ? data.burstId.value : this.burstId,
      edited: data.edited.present ? data.edited.value : this.edited,
      added: data.added.present ? data.added.value : this.added,
      thumbhash: data.thumbhash.present ? data.thumbhash.value : this.thumbhash,
      motionOffset: data.motionOffset.present
          ? data.motionOffset.value
          : this.motionOffset,
      motionLength: data.motionLength.present
          ? data.motionLength.value
          : this.motionLength,
      frameRate: data.frameRate.present ? data.frameRate.value : this.frameRate,
      projection: data.projection.present
          ? data.projection.value
          : this.projection,
      crop: data.crop.present ? data.crop.value : this.crop,
      stereo: data.stereo.present ? data.stereo.value : this.stereo,
      folder: data.folder.present ? data.folder.value : this.folder,
      heading: data.heading.present ? data.heading.value : this.heading,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      archived: data.archived.present ? data.archived.value : this.archived,
      bin: data.bin.present ? data.bin.value : this.bin,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      tile: data.tile.present ? data.tile.value : this.tile,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAssetData(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('volume: $volume, ')
          ..write('sourceId: $sourceId, ')
          ..write('generation: $generation, ')
          ..write('size: $size, ')
          ..write('mtime: $mtime, ')
          ..write('contentHash: $contentHash, ')
          ..write('assetId: $assetId, ')
          ..write('path: $path, ')
          ..write('fileId: $fileId, ')
          ..write('state: $state, ')
          ..write('name: $name, ')
          ..write('bucketId: $bucketId, ')
          ..write('bucketName: $bucketName, ')
          ..write('mime: $mime, ')
          ..write('taken: $taken, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('orientation: $orientation, ')
          ..write('durationMs: $durationMs, ')
          ..write('favorite: $favorite, ')
          ..write('trashed: $trashed, ')
          ..write('expires: $expires, ')
          ..write('extracted: $extracted, ')
          ..write('takenLocal: $takenLocal, ')
          ..write('tzOffsetMin: $tzOffsetMin, ')
          ..write('takenUtc: $takenUtc, ')
          ..write('timeSource: $timeSource, ')
          ..write('timeConfidence: $timeConfidence, ')
          ..write('timePrecision: $timePrecision, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('facets: $facets, ')
          ..write('cloudId: $cloudId, ')
          ..write('burstId: $burstId, ')
          ..write('edited: $edited, ')
          ..write('added: $added, ')
          ..write('thumbhash: $thumbhash, ')
          ..write('motionOffset: $motionOffset, ')
          ..write('motionLength: $motionLength, ')
          ..write('frameRate: $frameRate, ')
          ..write('projection: $projection, ')
          ..write('crop: $crop, ')
          ..write('stereo: $stereo, ')
          ..write('folder: $folder, ')
          ..write('heading: $heading, ')
          ..write('hidden: $hidden, ')
          ..write('archived: $archived, ')
          ..write('bin: $bin, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('tile: $tile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    $driftBlobEquality.hash(id),
    source,
    volume,
    sourceId,
    generation,
    size,
    mtime,
    $driftBlobEquality.hash(contentHash),
    $driftBlobEquality.hash(assetId),
    path,
    fileId,
    state,
    name,
    bucketId,
    bucketName,
    mime,
    taken,
    width,
    height,
    orientation,
    durationMs,
    favorite,
    trashed,
    expires,
    extracted,
    takenLocal,
    tzOffsetMin,
    takenUtc,
    timeSource,
    timeConfidence,
    timePrecision,
    lat,
    lon,
    make,
    model,
    facets,
    cloudId,
    burstId,
    edited,
    added,
    $driftBlobEquality.hash(thumbhash),
    motionOffset,
    motionLength,
    frameRate,
    projection,
    crop,
    stereo,
    folder,
    heading,
    hidden,
    archived,
    bin,
    $driftBlobEquality.hash(fingerprint),
    tile,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAssetData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          other.source == this.source &&
          other.volume == this.volume &&
          other.sourceId == this.sourceId &&
          other.generation == this.generation &&
          other.size == this.size &&
          other.mtime == this.mtime &&
          $driftBlobEquality.equals(other.contentHash, this.contentHash) &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          other.path == this.path &&
          other.fileId == this.fileId &&
          other.state == this.state &&
          other.name == this.name &&
          other.bucketId == this.bucketId &&
          other.bucketName == this.bucketName &&
          other.mime == this.mime &&
          other.taken == this.taken &&
          other.width == this.width &&
          other.height == this.height &&
          other.orientation == this.orientation &&
          other.durationMs == this.durationMs &&
          other.favorite == this.favorite &&
          other.trashed == this.trashed &&
          other.expires == this.expires &&
          other.extracted == this.extracted &&
          other.takenLocal == this.takenLocal &&
          other.tzOffsetMin == this.tzOffsetMin &&
          other.takenUtc == this.takenUtc &&
          other.timeSource == this.timeSource &&
          other.timeConfidence == this.timeConfidence &&
          other.timePrecision == this.timePrecision &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.make == this.make &&
          other.model == this.model &&
          other.facets == this.facets &&
          other.cloudId == this.cloudId &&
          other.burstId == this.burstId &&
          other.edited == this.edited &&
          other.added == this.added &&
          $driftBlobEquality.equals(other.thumbhash, this.thumbhash) &&
          other.motionOffset == this.motionOffset &&
          other.motionLength == this.motionLength &&
          other.frameRate == this.frameRate &&
          other.projection == this.projection &&
          other.crop == this.crop &&
          other.stereo == this.stereo &&
          other.folder == this.folder &&
          other.heading == this.heading &&
          other.hidden == this.hidden &&
          other.archived == this.archived &&
          other.bin == this.bin &&
          $driftBlobEquality.equals(other.fingerprint, this.fingerprint) &&
          other.tile == this.tile);
}

class LocalAssetCompanion extends UpdateCompanion<LocalAssetData> {
  final Value<Uint8List> id;
  final Value<String> source;
  final Value<String> volume;
  final Value<String> sourceId;
  final Value<String?> generation;
  final Value<int> size;
  final Value<int> mtime;
  final Value<Uint8List?> contentHash;
  final Value<Uint8List?> assetId;
  final Value<String?> path;
  final Value<String?> fileId;
  final Value<String> state;
  final Value<String?> name;
  final Value<String?> bucketId;
  final Value<String?> bucketName;
  final Value<String?> mime;
  final Value<int?> taken;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> orientation;
  final Value<int?> durationMs;
  final Value<int> favorite;
  final Value<int> trashed;
  final Value<int?> expires;
  final Value<int?> extracted;
  final Value<String?> takenLocal;
  final Value<int?> tzOffsetMin;
  final Value<int?> takenUtc;
  final Value<String?> timeSource;
  final Value<int?> timeConfidence;
  final Value<String?> timePrecision;
  final Value<double?> lat;
  final Value<double?> lon;
  final Value<String?> make;
  final Value<String?> model;
  final Value<String?> facets;
  final Value<String?> cloudId;
  final Value<String?> burstId;
  final Value<int> edited;
  final Value<int?> added;
  final Value<Uint8List?> thumbhash;
  final Value<int?> motionOffset;
  final Value<int?> motionLength;
  final Value<double?> frameRate;
  final Value<String?> projection;
  final Value<String?> crop;
  final Value<String?> stereo;
  final Value<int> folder;
  final Value<double?> heading;
  final Value<int> hidden;
  final Value<int> archived;
  final Value<String?> bin;
  final Value<Uint8List?> fingerprint;
  final Value<int> tile;
  final Value<int> rowid;
  const LocalAssetCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.volume = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.generation = const Value.absent(),
    this.size = const Value.absent(),
    this.mtime = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.assetId = const Value.absent(),
    this.path = const Value.absent(),
    this.fileId = const Value.absent(),
    this.state = const Value.absent(),
    this.name = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.bucketName = const Value.absent(),
    this.mime = const Value.absent(),
    this.taken = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.orientation = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.favorite = const Value.absent(),
    this.trashed = const Value.absent(),
    this.expires = const Value.absent(),
    this.extracted = const Value.absent(),
    this.takenLocal = const Value.absent(),
    this.tzOffsetMin = const Value.absent(),
    this.takenUtc = const Value.absent(),
    this.timeSource = const Value.absent(),
    this.timeConfidence = const Value.absent(),
    this.timePrecision = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.facets = const Value.absent(),
    this.cloudId = const Value.absent(),
    this.burstId = const Value.absent(),
    this.edited = const Value.absent(),
    this.added = const Value.absent(),
    this.thumbhash = const Value.absent(),
    this.motionOffset = const Value.absent(),
    this.motionLength = const Value.absent(),
    this.frameRate = const Value.absent(),
    this.projection = const Value.absent(),
    this.crop = const Value.absent(),
    this.stereo = const Value.absent(),
    this.folder = const Value.absent(),
    this.heading = const Value.absent(),
    this.hidden = const Value.absent(),
    this.archived = const Value.absent(),
    this.bin = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.tile = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAssetCompanion.insert({
    required Uint8List id,
    required String source,
    this.volume = const Value.absent(),
    required String sourceId,
    this.generation = const Value.absent(),
    required int size,
    required int mtime,
    this.contentHash = const Value.absent(),
    this.assetId = const Value.absent(),
    this.path = const Value.absent(),
    this.fileId = const Value.absent(),
    this.state = const Value.absent(),
    this.name = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.bucketName = const Value.absent(),
    this.mime = const Value.absent(),
    this.taken = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.orientation = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.favorite = const Value.absent(),
    this.trashed = const Value.absent(),
    this.expires = const Value.absent(),
    this.extracted = const Value.absent(),
    this.takenLocal = const Value.absent(),
    this.tzOffsetMin = const Value.absent(),
    this.takenUtc = const Value.absent(),
    this.timeSource = const Value.absent(),
    this.timeConfidence = const Value.absent(),
    this.timePrecision = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.facets = const Value.absent(),
    this.cloudId = const Value.absent(),
    this.burstId = const Value.absent(),
    this.edited = const Value.absent(),
    this.added = const Value.absent(),
    this.thumbhash = const Value.absent(),
    this.motionOffset = const Value.absent(),
    this.motionLength = const Value.absent(),
    this.frameRate = const Value.absent(),
    this.projection = const Value.absent(),
    this.crop = const Value.absent(),
    this.stereo = const Value.absent(),
    this.folder = const Value.absent(),
    this.heading = const Value.absent(),
    this.hidden = const Value.absent(),
    this.archived = const Value.absent(),
    this.bin = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.tile = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       source = Value(source),
       sourceId = Value(sourceId),
       size = Value(size),
       mtime = Value(mtime);
  static Insertable<LocalAssetData> custom({
    Expression<Uint8List>? id,
    Expression<String>? source,
    Expression<String>? volume,
    Expression<String>? sourceId,
    Expression<String>? generation,
    Expression<int>? size,
    Expression<int>? mtime,
    Expression<Uint8List>? contentHash,
    Expression<Uint8List>? assetId,
    Expression<String>? path,
    Expression<String>? fileId,
    Expression<String>? state,
    Expression<String>? name,
    Expression<String>? bucketId,
    Expression<String>? bucketName,
    Expression<String>? mime,
    Expression<int>? taken,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? orientation,
    Expression<int>? durationMs,
    Expression<int>? favorite,
    Expression<int>? trashed,
    Expression<int>? expires,
    Expression<int>? extracted,
    Expression<String>? takenLocal,
    Expression<int>? tzOffsetMin,
    Expression<int>? takenUtc,
    Expression<String>? timeSource,
    Expression<int>? timeConfidence,
    Expression<String>? timePrecision,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? make,
    Expression<String>? model,
    Expression<String>? facets,
    Expression<String>? cloudId,
    Expression<String>? burstId,
    Expression<int>? edited,
    Expression<int>? added,
    Expression<Uint8List>? thumbhash,
    Expression<int>? motionOffset,
    Expression<int>? motionLength,
    Expression<double>? frameRate,
    Expression<String>? projection,
    Expression<String>? crop,
    Expression<String>? stereo,
    Expression<int>? folder,
    Expression<double>? heading,
    Expression<int>? hidden,
    Expression<int>? archived,
    Expression<String>? bin,
    Expression<Uint8List>? fingerprint,
    Expression<int>? tile,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (volume != null) 'volume': volume,
      if (sourceId != null) 'source_id': sourceId,
      if (generation != null) 'generation': generation,
      if (size != null) 'size': size,
      if (mtime != null) 'mtime': mtime,
      if (contentHash != null) 'content_hash': contentHash,
      if (assetId != null) 'asset_id': assetId,
      if (path != null) 'path': path,
      if (fileId != null) 'file_id': fileId,
      if (state != null) 'state': state,
      if (name != null) 'name': name,
      if (bucketId != null) 'bucket_id': bucketId,
      if (bucketName != null) 'bucket_name': bucketName,
      if (mime != null) 'mime': mime,
      if (taken != null) 'taken': taken,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (orientation != null) 'orientation': orientation,
      if (durationMs != null) 'duration_ms': durationMs,
      if (favorite != null) 'favorite': favorite,
      if (trashed != null) 'trashed': trashed,
      if (expires != null) 'expires': expires,
      if (extracted != null) 'extracted': extracted,
      if (takenLocal != null) 'taken_local': takenLocal,
      if (tzOffsetMin != null) 'tz_offset_min': tzOffsetMin,
      if (takenUtc != null) 'taken_utc': takenUtc,
      if (timeSource != null) 'time_source': timeSource,
      if (timeConfidence != null) 'time_confidence': timeConfidence,
      if (timePrecision != null) 'time_precision': timePrecision,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (facets != null) 'facets': facets,
      if (cloudId != null) 'cloud_id': cloudId,
      if (burstId != null) 'burst_id': burstId,
      if (edited != null) 'edited': edited,
      if (added != null) 'added': added,
      if (thumbhash != null) 'thumbhash': thumbhash,
      if (motionOffset != null) 'motion_offset': motionOffset,
      if (motionLength != null) 'motion_length': motionLength,
      if (frameRate != null) 'frame_rate': frameRate,
      if (projection != null) 'projection': projection,
      if (crop != null) 'crop': crop,
      if (stereo != null) 'stereo': stereo,
      if (folder != null) 'folder': folder,
      if (heading != null) 'heading': heading,
      if (hidden != null) 'hidden': hidden,
      if (archived != null) 'archived': archived,
      if (bin != null) 'bin': bin,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (tile != null) 'tile': tile,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAssetCompanion copyWith({
    Value<Uint8List>? id,
    Value<String>? source,
    Value<String>? volume,
    Value<String>? sourceId,
    Value<String?>? generation,
    Value<int>? size,
    Value<int>? mtime,
    Value<Uint8List?>? contentHash,
    Value<Uint8List?>? assetId,
    Value<String?>? path,
    Value<String?>? fileId,
    Value<String>? state,
    Value<String?>? name,
    Value<String?>? bucketId,
    Value<String?>? bucketName,
    Value<String?>? mime,
    Value<int?>? taken,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? orientation,
    Value<int?>? durationMs,
    Value<int>? favorite,
    Value<int>? trashed,
    Value<int?>? expires,
    Value<int?>? extracted,
    Value<String?>? takenLocal,
    Value<int?>? tzOffsetMin,
    Value<int?>? takenUtc,
    Value<String?>? timeSource,
    Value<int?>? timeConfidence,
    Value<String?>? timePrecision,
    Value<double?>? lat,
    Value<double?>? lon,
    Value<String?>? make,
    Value<String?>? model,
    Value<String?>? facets,
    Value<String?>? cloudId,
    Value<String?>? burstId,
    Value<int>? edited,
    Value<int?>? added,
    Value<Uint8List?>? thumbhash,
    Value<int?>? motionOffset,
    Value<int?>? motionLength,
    Value<double?>? frameRate,
    Value<String?>? projection,
    Value<String?>? crop,
    Value<String?>? stereo,
    Value<int>? folder,
    Value<double?>? heading,
    Value<int>? hidden,
    Value<int>? archived,
    Value<String?>? bin,
    Value<Uint8List?>? fingerprint,
    Value<int>? tile,
    Value<int>? rowid,
  }) {
    return LocalAssetCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      volume: volume ?? this.volume,
      sourceId: sourceId ?? this.sourceId,
      generation: generation ?? this.generation,
      size: size ?? this.size,
      mtime: mtime ?? this.mtime,
      contentHash: contentHash ?? this.contentHash,
      assetId: assetId ?? this.assetId,
      path: path ?? this.path,
      fileId: fileId ?? this.fileId,
      state: state ?? this.state,
      name: name ?? this.name,
      bucketId: bucketId ?? this.bucketId,
      bucketName: bucketName ?? this.bucketName,
      mime: mime ?? this.mime,
      taken: taken ?? this.taken,
      width: width ?? this.width,
      height: height ?? this.height,
      orientation: orientation ?? this.orientation,
      durationMs: durationMs ?? this.durationMs,
      favorite: favorite ?? this.favorite,
      trashed: trashed ?? this.trashed,
      expires: expires ?? this.expires,
      extracted: extracted ?? this.extracted,
      takenLocal: takenLocal ?? this.takenLocal,
      tzOffsetMin: tzOffsetMin ?? this.tzOffsetMin,
      takenUtc: takenUtc ?? this.takenUtc,
      timeSource: timeSource ?? this.timeSource,
      timeConfidence: timeConfidence ?? this.timeConfidence,
      timePrecision: timePrecision ?? this.timePrecision,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      make: make ?? this.make,
      model: model ?? this.model,
      facets: facets ?? this.facets,
      cloudId: cloudId ?? this.cloudId,
      burstId: burstId ?? this.burstId,
      edited: edited ?? this.edited,
      added: added ?? this.added,
      thumbhash: thumbhash ?? this.thumbhash,
      motionOffset: motionOffset ?? this.motionOffset,
      motionLength: motionLength ?? this.motionLength,
      frameRate: frameRate ?? this.frameRate,
      projection: projection ?? this.projection,
      crop: crop ?? this.crop,
      stereo: stereo ?? this.stereo,
      folder: folder ?? this.folder,
      heading: heading ?? this.heading,
      hidden: hidden ?? this.hidden,
      archived: archived ?? this.archived,
      bin: bin ?? this.bin,
      fingerprint: fingerprint ?? this.fingerprint,
      tile: tile ?? this.tile,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<Uint8List>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (volume.present) {
      map['volume'] = Variable<String>(volume.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (generation.present) {
      map['generation'] = Variable<String>(generation.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (mtime.present) {
      map['mtime'] = Variable<int>(mtime.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<Uint8List>(contentHash.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<Uint8List>(assetId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (bucketName.present) {
      map['bucket_name'] = Variable<String>(bucketName.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (taken.present) {
      map['taken'] = Variable<int>(taken.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (orientation.present) {
      map['orientation'] = Variable<int>(orientation.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<int>(favorite.value);
    }
    if (trashed.present) {
      map['trashed'] = Variable<int>(trashed.value);
    }
    if (expires.present) {
      map['expires'] = Variable<int>(expires.value);
    }
    if (extracted.present) {
      map['extracted'] = Variable<int>(extracted.value);
    }
    if (takenLocal.present) {
      map['taken_local'] = Variable<String>(takenLocal.value);
    }
    if (tzOffsetMin.present) {
      map['tz_offset_min'] = Variable<int>(tzOffsetMin.value);
    }
    if (takenUtc.present) {
      map['taken_utc'] = Variable<int>(takenUtc.value);
    }
    if (timeSource.present) {
      map['time_source'] = Variable<String>(timeSource.value);
    }
    if (timeConfidence.present) {
      map['time_confidence'] = Variable<int>(timeConfidence.value);
    }
    if (timePrecision.present) {
      map['time_precision'] = Variable<String>(timePrecision.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (facets.present) {
      map['facets'] = Variable<String>(facets.value);
    }
    if (cloudId.present) {
      map['cloud_id'] = Variable<String>(cloudId.value);
    }
    if (burstId.present) {
      map['burst_id'] = Variable<String>(burstId.value);
    }
    if (edited.present) {
      map['edited'] = Variable<int>(edited.value);
    }
    if (added.present) {
      map['added'] = Variable<int>(added.value);
    }
    if (thumbhash.present) {
      map['thumbhash'] = Variable<Uint8List>(thumbhash.value);
    }
    if (motionOffset.present) {
      map['motion_offset'] = Variable<int>(motionOffset.value);
    }
    if (motionLength.present) {
      map['motion_length'] = Variable<int>(motionLength.value);
    }
    if (frameRate.present) {
      map['frame_rate'] = Variable<double>(frameRate.value);
    }
    if (projection.present) {
      map['projection'] = Variable<String>(projection.value);
    }
    if (crop.present) {
      map['crop'] = Variable<String>(crop.value);
    }
    if (stereo.present) {
      map['stereo'] = Variable<String>(stereo.value);
    }
    if (folder.present) {
      map['folder'] = Variable<int>(folder.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<int>(hidden.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (bin.present) {
      map['bin'] = Variable<String>(bin.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<Uint8List>(fingerprint.value);
    }
    if (tile.present) {
      map['tile'] = Variable<int>(tile.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAssetCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('volume: $volume, ')
          ..write('sourceId: $sourceId, ')
          ..write('generation: $generation, ')
          ..write('size: $size, ')
          ..write('mtime: $mtime, ')
          ..write('contentHash: $contentHash, ')
          ..write('assetId: $assetId, ')
          ..write('path: $path, ')
          ..write('fileId: $fileId, ')
          ..write('state: $state, ')
          ..write('name: $name, ')
          ..write('bucketId: $bucketId, ')
          ..write('bucketName: $bucketName, ')
          ..write('mime: $mime, ')
          ..write('taken: $taken, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('orientation: $orientation, ')
          ..write('durationMs: $durationMs, ')
          ..write('favorite: $favorite, ')
          ..write('trashed: $trashed, ')
          ..write('expires: $expires, ')
          ..write('extracted: $extracted, ')
          ..write('takenLocal: $takenLocal, ')
          ..write('tzOffsetMin: $tzOffsetMin, ')
          ..write('takenUtc: $takenUtc, ')
          ..write('timeSource: $timeSource, ')
          ..write('timeConfidence: $timeConfidence, ')
          ..write('timePrecision: $timePrecision, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('facets: $facets, ')
          ..write('cloudId: $cloudId, ')
          ..write('burstId: $burstId, ')
          ..write('edited: $edited, ')
          ..write('added: $added, ')
          ..write('thumbhash: $thumbhash, ')
          ..write('motionOffset: $motionOffset, ')
          ..write('motionLength: $motionLength, ')
          ..write('frameRate: $frameRate, ')
          ..write('projection: $projection, ')
          ..write('crop: $crop, ')
          ..write('stereo: $stereo, ')
          ..write('folder: $folder, ')
          ..write('heading: $heading, ')
          ..write('hidden: $hidden, ')
          ..write('archived: $archived, ')
          ..write('bin: $bin, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('tile: $tile, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class LinkedTileData extends DataClass {
  final Uint8List id;
  final int tile;
  const LinkedTileData({required this.id, required this.tile});
  factory LinkedTileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinkedTileData(
      id: serializer.fromJson<Uint8List>(json['id']),
      tile: serializer.fromJson<int>(json['tile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'tile': serializer.toJson<int>(tile),
    };
  }

  LinkedTileData copyWith({Uint8List? id, int? tile}) =>
      LinkedTileData(id: id ?? this.id, tile: tile ?? this.tile);
  @override
  String toString() {
    return (StringBuffer('LinkedTileData(')
          ..write('id: $id, ')
          ..write('tile: $tile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash($driftBlobEquality.hash(id), tile);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinkedTileData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          other.tile == this.tile);
}

class LinkedTile extends ViewInfo<LinkedTile, LinkedTileData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Replica attachedDatabase;
  LinkedTile(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [id, tile];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'linked_tile';
  @override
  Map<SqlDialect, String> get createViewStatements => {
    SqlDialect.sqlite:
        'CREATE VIEW linked_tile AS SELECT l.id, CASE WHEN EXISTS (SELECT 1 FROM local_asset AS o WHERE o.asset_id = l.asset_id AND o.state = \'present\' AND o.trashed = 0 AND o.id < l.id) THEN 2 WHEN EXISTS (SELECT 1 FROM asset AS a WHERE a.id = l.asset_id AND(a.trashed_at IS NOT NULL OR a.archived <> 0 OR a.locked <> 0)) THEN 2 WHEN EXISTS (SELECT 1 FROM asset_user_state AS s WHERE s.asset_id = l.asset_id AND s.album_hides_timeline <> 0) THEN 2 WHEN EXISTS (SELECT 1 FROM asset AS a JOIN library_user_state AS h ON h.library_id = a.library_id WHERE a.id = l.asset_id AND h.hide_from_timeline <> 0) THEN 2 WHEN EXISTS (SELECT 1 FROM asset AS a JOIN library AS k ON k.id = a.library_id WHERE a.id = l.asset_id AND k.kind = \'managed\') THEN 1 ELSE 0 END AS tile FROM local_asset AS l WHERE l.asset_id IS NOT NULL',
  };
  @override
  LinkedTile get asDslTable => this;
  @override
  LinkedTileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LinkedTileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      tile: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tile'],
      )!,
    );
  }

  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<int> tile = GeneratedColumn<int>(
    'tile',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  @override
  LinkedTile createAlias(String alias) {
    return LinkedTile(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {
    'local_asset',
    'asset',
    'asset_user_state',
    'library_user_state',
    'library',
  };
}

class PartnerShare extends Table
    with TableInfo<PartnerShare, PartnerShareData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PartnerShare(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> partnerId = GeneratedColumn<Uint8List>(
    'partner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> takenSince = GeneratedColumn<String>(
    'taken_since',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> txid = GeneratedColumn<int>(
    'txid',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [ownerId, partnerId, takenSince, txid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partner_share';
  @override
  Set<GeneratedColumn> get $primaryKey => {ownerId, partnerId};
  @override
  PartnerShareData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnerShareData(
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      partnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}partner_id'],
      )!,
      takenSince: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}taken_since'],
      ),
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}txid'],
      ),
    );
  }

  @override
  PartnerShare createAlias(String alias) {
    return PartnerShare(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(owner_id, partner_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class PartnerShareData extends DataClass
    implements Insertable<PartnerShareData> {
  final Uint8List ownerId;
  final Uint8List partnerId;
  final String? takenSince;

  /// the date the share starts at, e.g. 2020-01-31
  final int? txid;
  const PartnerShareData({
    required this.ownerId,
    required this.partnerId,
    this.takenSince,
    this.txid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_id'] = Variable<Uint8List>(ownerId);
    map['partner_id'] = Variable<Uint8List>(partnerId);
    if (!nullToAbsent || takenSince != null) {
      map['taken_since'] = Variable<String>(takenSince);
    }
    if (!nullToAbsent || txid != null) {
      map['txid'] = Variable<int>(txid);
    }
    return map;
  }

  factory PartnerShareData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnerShareData(
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      partnerId: serializer.fromJson<Uint8List>(json['partner_id']),
      takenSince: serializer.fromJson<String?>(json['taken_since']),
      txid: serializer.fromJson<int?>(json['txid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'partner_id': serializer.toJson<Uint8List>(partnerId),
      'taken_since': serializer.toJson<String?>(takenSince),
      'txid': serializer.toJson<int?>(txid),
    };
  }

  PartnerShareData copyWith({
    Uint8List? ownerId,
    Uint8List? partnerId,
    Value<String?> takenSince = const Value.absent(),
    Value<int?> txid = const Value.absent(),
  }) => PartnerShareData(
    ownerId: ownerId ?? this.ownerId,
    partnerId: partnerId ?? this.partnerId,
    takenSince: takenSince.present ? takenSince.value : this.takenSince,
    txid: txid.present ? txid.value : this.txid,
  );
  PartnerShareData copyWithCompanion(PartnerShareCompanion data) {
    return PartnerShareData(
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      partnerId: data.partnerId.present ? data.partnerId.value : this.partnerId,
      takenSince: data.takenSince.present
          ? data.takenSince.value
          : this.takenSince,
      txid: data.txid.present ? data.txid.value : this.txid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartnerShareData(')
          ..write('ownerId: $ownerId, ')
          ..write('partnerId: $partnerId, ')
          ..write('takenSince: $takenSince, ')
          ..write('txid: $txid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(ownerId),
    $driftBlobEquality.hash(partnerId),
    takenSince,
    txid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnerShareData &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          $driftBlobEquality.equals(other.partnerId, this.partnerId) &&
          other.takenSince == this.takenSince &&
          other.txid == this.txid);
}

class PartnerShareCompanion extends UpdateCompanion<PartnerShareData> {
  final Value<Uint8List> ownerId;
  final Value<Uint8List> partnerId;
  final Value<String?> takenSince;
  final Value<int?> txid;
  final Value<int> rowid;
  const PartnerShareCompanion({
    this.ownerId = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.takenSince = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnerShareCompanion.insert({
    required Uint8List ownerId,
    required Uint8List partnerId,
    this.takenSince = const Value.absent(),
    this.txid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerId = Value(ownerId),
       partnerId = Value(partnerId);
  static Insertable<PartnerShareData> custom({
    Expression<Uint8List>? ownerId,
    Expression<Uint8List>? partnerId,
    Expression<String>? takenSince,
    Expression<int>? txid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerId != null) 'owner_id': ownerId,
      if (partnerId != null) 'partner_id': partnerId,
      if (takenSince != null) 'taken_since': takenSince,
      if (txid != null) 'txid': txid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnerShareCompanion copyWith({
    Value<Uint8List>? ownerId,
    Value<Uint8List>? partnerId,
    Value<String?>? takenSince,
    Value<int?>? txid,
    Value<int>? rowid,
  }) {
    return PartnerShareCompanion(
      ownerId: ownerId ?? this.ownerId,
      partnerId: partnerId ?? this.partnerId,
      takenSince: takenSince ?? this.takenSince,
      txid: txid ?? this.txid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<Uint8List>(partnerId.value);
    }
    if (takenSince.present) {
      map['taken_since'] = Variable<String>(takenSince.value);
    }
    if (txid.present) {
      map['txid'] = Variable<int>(txid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnerShareCompanion(')
          ..write('ownerId: $ownerId, ')
          ..write('partnerId: $partnerId, ')
          ..write('takenSince: $takenSince, ')
          ..write('txid: $txid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class PartnerLibrary extends Table
    with TableInfo<PartnerLibrary, PartnerLibraryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PartnerLibrary(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> ownerId = GeneratedColumn<Uint8List>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> libraryId = GeneratedColumn<Uint8List>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> whole = GeneratedColumn<int>(
    'whole',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [ownerId, libraryId, whole];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partner_library';
  @override
  Set<GeneratedColumn> get $primaryKey => {ownerId, libraryId};
  @override
  PartnerLibraryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnerLibraryData(
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}owner_id'],
      )!,
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}library_id'],
      )!,
      whole: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}whole'],
      )!,
    );
  }

  @override
  PartnerLibrary createAlias(String alias) {
    return PartnerLibrary(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(owner_id, library_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class PartnerLibraryData extends DataClass
    implements Insertable<PartnerLibraryData> {
  final Uint8List ownerId;
  final Uint8List libraryId;
  final int whole;
  const PartnerLibraryData({
    required this.ownerId,
    required this.libraryId,
    required this.whole,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_id'] = Variable<Uint8List>(ownerId);
    map['library_id'] = Variable<Uint8List>(libraryId);
    map['whole'] = Variable<int>(whole);
    return map;
  }

  factory PartnerLibraryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnerLibraryData(
      ownerId: serializer.fromJson<Uint8List>(json['owner_id']),
      libraryId: serializer.fromJson<Uint8List>(json['library_id']),
      whole: serializer.fromJson<int>(json['whole']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'owner_id': serializer.toJson<Uint8List>(ownerId),
      'library_id': serializer.toJson<Uint8List>(libraryId),
      'whole': serializer.toJson<int>(whole),
    };
  }

  PartnerLibraryData copyWith({
    Uint8List? ownerId,
    Uint8List? libraryId,
    int? whole,
  }) => PartnerLibraryData(
    ownerId: ownerId ?? this.ownerId,
    libraryId: libraryId ?? this.libraryId,
    whole: whole ?? this.whole,
  );
  PartnerLibraryData copyWithCompanion(PartnerLibraryCompanion data) {
    return PartnerLibraryData(
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      whole: data.whole.present ? data.whole.value : this.whole,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartnerLibraryData(')
          ..write('ownerId: $ownerId, ')
          ..write('libraryId: $libraryId, ')
          ..write('whole: $whole')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(ownerId),
    $driftBlobEquality.hash(libraryId),
    whole,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnerLibraryData &&
          $driftBlobEquality.equals(other.ownerId, this.ownerId) &&
          $driftBlobEquality.equals(other.libraryId, this.libraryId) &&
          other.whole == this.whole);
}

class PartnerLibraryCompanion extends UpdateCompanion<PartnerLibraryData> {
  final Value<Uint8List> ownerId;
  final Value<Uint8List> libraryId;
  final Value<int> whole;
  final Value<int> rowid;
  const PartnerLibraryCompanion({
    this.ownerId = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.whole = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnerLibraryCompanion.insert({
    required Uint8List ownerId,
    required Uint8List libraryId,
    this.whole = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerId = Value(ownerId),
       libraryId = Value(libraryId);
  static Insertable<PartnerLibraryData> custom({
    Expression<Uint8List>? ownerId,
    Expression<Uint8List>? libraryId,
    Expression<int>? whole,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerId != null) 'owner_id': ownerId,
      if (libraryId != null) 'library_id': libraryId,
      if (whole != null) 'whole': whole,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnerLibraryCompanion copyWith({
    Value<Uint8List>? ownerId,
    Value<Uint8List>? libraryId,
    Value<int>? whole,
    Value<int>? rowid,
  }) {
    return PartnerLibraryCompanion(
      ownerId: ownerId ?? this.ownerId,
      libraryId: libraryId ?? this.libraryId,
      whole: whole ?? this.whole,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerId.present) {
      map['owner_id'] = Variable<Uint8List>(ownerId.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<Uint8List>(libraryId.value);
    }
    if (whole.present) {
      map['whole'] = Variable<int>(whole.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnerLibraryCompanion(')
          ..write('ownerId: $ownerId, ')
          ..write('libraryId: $libraryId, ')
          ..write('whole: $whole, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class TimelineItemData extends DataClass {
  final Uint8List id;
  final String source;
  final String volume;
  final String sourceId;
  final String? path;
  final int size;
  final int mtime;
  final String? mime;
  final Uint8List? thumbhash;
  final String? projection;
  final int favorite;
  final int hidden;
  final int archived;
  final int added;
  final int day;
  final int sortKey;
  final int folder;
  final String? facets;
  final Uint8List? assetId;
  final String backup;
  final Uint8List? thumbS;
  final Uint8List? thumbM;
  const TimelineItemData({
    required this.id,
    required this.source,
    required this.volume,
    required this.sourceId,
    this.path,
    required this.size,
    required this.mtime,
    this.mime,
    this.thumbhash,
    this.projection,
    required this.favorite,
    required this.hidden,
    required this.archived,
    required this.added,
    required this.day,
    required this.sortKey,
    required this.folder,
    this.facets,
    this.assetId,
    required this.backup,
    this.thumbS,
    this.thumbM,
  });
  factory TimelineItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineItemData(
      id: serializer.fromJson<Uint8List>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      volume: serializer.fromJson<String>(json['volume']),
      sourceId: serializer.fromJson<String>(json['source_id']),
      path: serializer.fromJson<String?>(json['path']),
      size: serializer.fromJson<int>(json['size']),
      mtime: serializer.fromJson<int>(json['mtime']),
      mime: serializer.fromJson<String?>(json['mime']),
      thumbhash: serializer.fromJson<Uint8List?>(json['thumbhash']),
      projection: serializer.fromJson<String?>(json['projection']),
      favorite: serializer.fromJson<int>(json['favorite']),
      hidden: serializer.fromJson<int>(json['hidden']),
      archived: serializer.fromJson<int>(json['archived']),
      added: serializer.fromJson<int>(json['added']),
      day: serializer.fromJson<int>(json['day']),
      sortKey: serializer.fromJson<int>(json['sort_key']),
      folder: serializer.fromJson<int>(json['folder']),
      facets: serializer.fromJson<String?>(json['facets']),
      assetId: serializer.fromJson<Uint8List?>(json['asset_id']),
      backup: serializer.fromJson<String>(json['backup']),
      thumbS: serializer.fromJson<Uint8List?>(json['thumb_s']),
      thumbM: serializer.fromJson<Uint8List?>(json['thumb_m']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'source': serializer.toJson<String>(source),
      'volume': serializer.toJson<String>(volume),
      'source_id': serializer.toJson<String>(sourceId),
      'path': serializer.toJson<String?>(path),
      'size': serializer.toJson<int>(size),
      'mtime': serializer.toJson<int>(mtime),
      'mime': serializer.toJson<String?>(mime),
      'thumbhash': serializer.toJson<Uint8List?>(thumbhash),
      'projection': serializer.toJson<String?>(projection),
      'favorite': serializer.toJson<int>(favorite),
      'hidden': serializer.toJson<int>(hidden),
      'archived': serializer.toJson<int>(archived),
      'added': serializer.toJson<int>(added),
      'day': serializer.toJson<int>(day),
      'sort_key': serializer.toJson<int>(sortKey),
      'folder': serializer.toJson<int>(folder),
      'facets': serializer.toJson<String?>(facets),
      'asset_id': serializer.toJson<Uint8List?>(assetId),
      'backup': serializer.toJson<String>(backup),
      'thumb_s': serializer.toJson<Uint8List?>(thumbS),
      'thumb_m': serializer.toJson<Uint8List?>(thumbM),
    };
  }

  TimelineItemData copyWith({
    Uint8List? id,
    String? source,
    String? volume,
    String? sourceId,
    Value<String?> path = const Value.absent(),
    int? size,
    int? mtime,
    Value<String?> mime = const Value.absent(),
    Value<Uint8List?> thumbhash = const Value.absent(),
    Value<String?> projection = const Value.absent(),
    int? favorite,
    int? hidden,
    int? archived,
    int? added,
    int? day,
    int? sortKey,
    int? folder,
    Value<String?> facets = const Value.absent(),
    Value<Uint8List?> assetId = const Value.absent(),
    String? backup,
    Value<Uint8List?> thumbS = const Value.absent(),
    Value<Uint8List?> thumbM = const Value.absent(),
  }) => TimelineItemData(
    id: id ?? this.id,
    source: source ?? this.source,
    volume: volume ?? this.volume,
    sourceId: sourceId ?? this.sourceId,
    path: path.present ? path.value : this.path,
    size: size ?? this.size,
    mtime: mtime ?? this.mtime,
    mime: mime.present ? mime.value : this.mime,
    thumbhash: thumbhash.present ? thumbhash.value : this.thumbhash,
    projection: projection.present ? projection.value : this.projection,
    favorite: favorite ?? this.favorite,
    hidden: hidden ?? this.hidden,
    archived: archived ?? this.archived,
    added: added ?? this.added,
    day: day ?? this.day,
    sortKey: sortKey ?? this.sortKey,
    folder: folder ?? this.folder,
    facets: facets.present ? facets.value : this.facets,
    assetId: assetId.present ? assetId.value : this.assetId,
    backup: backup ?? this.backup,
    thumbS: thumbS.present ? thumbS.value : this.thumbS,
    thumbM: thumbM.present ? thumbM.value : this.thumbM,
  );
  @override
  String toString() {
    return (StringBuffer('TimelineItemData(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('volume: $volume, ')
          ..write('sourceId: $sourceId, ')
          ..write('path: $path, ')
          ..write('size: $size, ')
          ..write('mtime: $mtime, ')
          ..write('mime: $mime, ')
          ..write('thumbhash: $thumbhash, ')
          ..write('projection: $projection, ')
          ..write('favorite: $favorite, ')
          ..write('hidden: $hidden, ')
          ..write('archived: $archived, ')
          ..write('added: $added, ')
          ..write('day: $day, ')
          ..write('sortKey: $sortKey, ')
          ..write('folder: $folder, ')
          ..write('facets: $facets, ')
          ..write('assetId: $assetId, ')
          ..write('backup: $backup, ')
          ..write('thumbS: $thumbS, ')
          ..write('thumbM: $thumbM')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    $driftBlobEquality.hash(id),
    source,
    volume,
    sourceId,
    path,
    size,
    mtime,
    mime,
    $driftBlobEquality.hash(thumbhash),
    projection,
    favorite,
    hidden,
    archived,
    added,
    day,
    sortKey,
    folder,
    facets,
    $driftBlobEquality.hash(assetId),
    backup,
    $driftBlobEquality.hash(thumbS),
    $driftBlobEquality.hash(thumbM),
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineItemData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          other.source == this.source &&
          other.volume == this.volume &&
          other.sourceId == this.sourceId &&
          other.path == this.path &&
          other.size == this.size &&
          other.mtime == this.mtime &&
          other.mime == this.mime &&
          $driftBlobEquality.equals(other.thumbhash, this.thumbhash) &&
          other.projection == this.projection &&
          other.favorite == this.favorite &&
          other.hidden == this.hidden &&
          other.archived == this.archived &&
          other.added == this.added &&
          other.day == this.day &&
          other.sortKey == this.sortKey &&
          other.folder == this.folder &&
          other.facets == this.facets &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          other.backup == this.backup &&
          $driftBlobEquality.equals(other.thumbS, this.thumbS) &&
          $driftBlobEquality.equals(other.thumbM, this.thumbM));
}

class TimelineItem extends ViewInfo<TimelineItem, TimelineItemData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Replica attachedDatabase;
  TimelineItem(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    volume,
    sourceId,
    path,
    size,
    mtime,
    mime,
    thumbhash,
    projection,
    favorite,
    hidden,
    archived,
    added,
    day,
    sortKey,
    folder,
    facets,
    assetId,
    backup,
    thumbS,
    thumbM,
  ];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'timeline_item';
  @override
  Map<SqlDialect, String> get createViewStatements => {
    SqlDialect.sqlite:
        'CREATE VIEW timeline_item AS SELECT id, source, volume, source_id, path, size, mtime, mime, thumbhash, projection, favorite, hidden, archived, COALESCE(added, 0) AS added, CAST(COALESCE(strftime(\'%Y%m%d\', taken_local), strftime(\'%Y%m%d\', COALESCE(taken, mtime) / 1000, \'unixepoch\')) AS INTEGER) AS day, COALESCE(taken_utc, taken, mtime) AS sort_key, folder, facets, asset_id, CASE tile WHEN 1 THEN \'backed_up\' ELSE \'not_backed_up\' END AS backup, CAST(NULL AS BLOB) AS thumb_s, CAST(NULL AS BLOB) AS thumb_m FROM local_asset WHERE state = \'present\' AND trashed = 0 AND tile < 2',
  };
  @override
  TimelineItem get asDslTable => this;
  @override
  TimelineItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}volume'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      ),
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mtime'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      ),
      thumbhash: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumbhash'],
      ),
      projection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}projection'],
      ),
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}favorite'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      added: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_key'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      facets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facets'],
      ),
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      ),
      backup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup'],
      )!,
      thumbS: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumb_s'],
      ),
      thumbM: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumb_m'],
      ),
    );
  }

  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<String> volume = GeneratedColumn<String>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> mtime = GeneratedColumn<int>(
    'mtime',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<Uint8List> thumbhash = GeneratedColumn<Uint8List>(
    'thumbhash',
    aliasedName,
    true,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<String> projection = GeneratedColumn<String>(
    'projection',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<int> favorite = GeneratedColumn<int>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> hidden = GeneratedColumn<int>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> added = GeneratedColumn<int>(
    'added',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> sortKey = GeneratedColumn<int>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<String> facets = GeneratedColumn<String>(
    'facets',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    true,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<String> backup = GeneratedColumn<String>(
    'backup',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<Uint8List> thumbS = GeneratedColumn<Uint8List>(
    'thumb_s',
    aliasedName,
    true,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<Uint8List> thumbM = GeneratedColumn<Uint8List>(
    'thumb_m',
    aliasedName,
    true,
    type: DriftSqlType.blob,
  );
  @override
  TimelineItem createAlias(String alias) {
    return TimelineItem(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {'local_asset'};
}

class DeviceFolder extends Table
    with TableInfo<DeviceFolder, DeviceFolderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DeviceFolder(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<String> volume = GeneratedColumn<String>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumn<String> visibility = GeneratedColumn<String>(
    'visibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'inherit\'',
    defaultValue: const CustomExpression('\'inherit\''),
  );
  late final GeneratedColumn<int> fresh = GeneratedColumn<int>(
    'fresh',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    volume,
    path,
    name,
    visibility,
    fresh,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_folder';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {volume, path},
  ];
  @override
  DeviceFolderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceFolderData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}volume'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      visibility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visibility'],
      )!,
      fresh: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fresh'],
      )!,
    );
  }

  @override
  DeviceFolder createAlias(String alias) {
    return DeviceFolder(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const ['UNIQUE(volume, path)'];
  @override
  bool get dontWriteConstraints => true;
}

class DeviceFolderData extends DataClass
    implements Insertable<DeviceFolderData> {
  final int id;

  /// what local_asset.folder holds
  final String volume;
  final String path;

  /// RELATIVE_PATH, ending in '/', or '' for the volume or root itself
  final String name;

  /// BUCKET_DISPLAY_NAME, or '' for the path's last folder
  /// Schema 21: the folder's own visibility, shown, hidden or inherit: the nearest folder above with its own decides.
  final String visibility;
  final int fresh;
  const DeviceFolderData({
    required this.id,
    required this.volume,
    required this.path,
    required this.name,
    required this.visibility,
    required this.fresh,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['volume'] = Variable<String>(volume);
    map['path'] = Variable<String>(path);
    map['name'] = Variable<String>(name);
    map['visibility'] = Variable<String>(visibility);
    map['fresh'] = Variable<int>(fresh);
    return map;
  }

  factory DeviceFolderData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceFolderData(
      id: serializer.fromJson<int>(json['id']),
      volume: serializer.fromJson<String>(json['volume']),
      path: serializer.fromJson<String>(json['path']),
      name: serializer.fromJson<String>(json['name']),
      visibility: serializer.fromJson<String>(json['visibility']),
      fresh: serializer.fromJson<int>(json['fresh']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'volume': serializer.toJson<String>(volume),
      'path': serializer.toJson<String>(path),
      'name': serializer.toJson<String>(name),
      'visibility': serializer.toJson<String>(visibility),
      'fresh': serializer.toJson<int>(fresh),
    };
  }

  DeviceFolderData copyWith({
    int? id,
    String? volume,
    String? path,
    String? name,
    String? visibility,
    int? fresh,
  }) => DeviceFolderData(
    id: id ?? this.id,
    volume: volume ?? this.volume,
    path: path ?? this.path,
    name: name ?? this.name,
    visibility: visibility ?? this.visibility,
    fresh: fresh ?? this.fresh,
  );
  DeviceFolderData copyWithCompanion(DeviceFolderCompanion data) {
    return DeviceFolderData(
      id: data.id.present ? data.id.value : this.id,
      volume: data.volume.present ? data.volume.value : this.volume,
      path: data.path.present ? data.path.value : this.path,
      name: data.name.present ? data.name.value : this.name,
      visibility: data.visibility.present
          ? data.visibility.value
          : this.visibility,
      fresh: data.fresh.present ? data.fresh.value : this.fresh,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceFolderData(')
          ..write('id: $id, ')
          ..write('volume: $volume, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('visibility: $visibility, ')
          ..write('fresh: $fresh')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, volume, path, name, visibility, fresh);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceFolderData &&
          other.id == this.id &&
          other.volume == this.volume &&
          other.path == this.path &&
          other.name == this.name &&
          other.visibility == this.visibility &&
          other.fresh == this.fresh);
}

class DeviceFolderCompanion extends UpdateCompanion<DeviceFolderData> {
  final Value<int> id;
  final Value<String> volume;
  final Value<String> path;
  final Value<String> name;
  final Value<String> visibility;
  final Value<int> fresh;
  const DeviceFolderCompanion({
    this.id = const Value.absent(),
    this.volume = const Value.absent(),
    this.path = const Value.absent(),
    this.name = const Value.absent(),
    this.visibility = const Value.absent(),
    this.fresh = const Value.absent(),
  });
  DeviceFolderCompanion.insert({
    this.id = const Value.absent(),
    required String volume,
    required String path,
    this.name = const Value.absent(),
    this.visibility = const Value.absent(),
    this.fresh = const Value.absent(),
  }) : volume = Value(volume),
       path = Value(path);
  static Insertable<DeviceFolderData> custom({
    Expression<int>? id,
    Expression<String>? volume,
    Expression<String>? path,
    Expression<String>? name,
    Expression<String>? visibility,
    Expression<int>? fresh,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (volume != null) 'volume': volume,
      if (path != null) 'path': path,
      if (name != null) 'name': name,
      if (visibility != null) 'visibility': visibility,
      if (fresh != null) 'fresh': fresh,
    });
  }

  DeviceFolderCompanion copyWith({
    Value<int>? id,
    Value<String>? volume,
    Value<String>? path,
    Value<String>? name,
    Value<String>? visibility,
    Value<int>? fresh,
  }) {
    return DeviceFolderCompanion(
      id: id ?? this.id,
      volume: volume ?? this.volume,
      path: path ?? this.path,
      name: name ?? this.name,
      visibility: visibility ?? this.visibility,
      fresh: fresh ?? this.fresh,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (volume.present) {
      map['volume'] = Variable<String>(volume.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (visibility.present) {
      map['visibility'] = Variable<String>(visibility.value);
    }
    if (fresh.present) {
      map['fresh'] = Variable<int>(fresh.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceFolderCompanion(')
          ..write('id: $id, ')
          ..write('volume: $volume, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('visibility: $visibility, ')
          ..write('fresh: $fresh')
          ..write(')'))
        .toString();
  }
}

class DeviceFolderMode extends Table
    with TableInfo<DeviceFolderMode, DeviceFolderModeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DeviceFolderMode(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (id = 0)',
  );
  late final GeneratedColumn<int> onlyChosen = GeneratedColumn<int>(
    'only_chosen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> revealUntil = GeneratedColumn<int>(
    'reveal_until',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [id, onlyChosen, revealUntil];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_folder_mode';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceFolderModeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceFolderModeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      onlyChosen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}only_chosen'],
      )!,
      revealUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reveal_until'],
      ),
    );
  }

  @override
  DeviceFolderMode createAlias(String alias) {
    return DeviceFolderMode(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class DeviceFolderModeData extends DataClass
    implements Insertable<DeviceFolderModeData> {
  final int id;
  final int onlyChosen;
  final int? revealUntil;
  const DeviceFolderModeData({
    required this.id,
    required this.onlyChosen,
    this.revealUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['only_chosen'] = Variable<int>(onlyChosen);
    if (!nullToAbsent || revealUntil != null) {
      map['reveal_until'] = Variable<int>(revealUntil);
    }
    return map;
  }

  factory DeviceFolderModeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceFolderModeData(
      id: serializer.fromJson<int>(json['id']),
      onlyChosen: serializer.fromJson<int>(json['only_chosen']),
      revealUntil: serializer.fromJson<int?>(json['reveal_until']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'only_chosen': serializer.toJson<int>(onlyChosen),
      'reveal_until': serializer.toJson<int?>(revealUntil),
    };
  }

  DeviceFolderModeData copyWith({
    int? id,
    int? onlyChosen,
    Value<int?> revealUntil = const Value.absent(),
  }) => DeviceFolderModeData(
    id: id ?? this.id,
    onlyChosen: onlyChosen ?? this.onlyChosen,
    revealUntil: revealUntil.present ? revealUntil.value : this.revealUntil,
  );
  DeviceFolderModeData copyWithCompanion(DeviceFolderModeCompanion data) {
    return DeviceFolderModeData(
      id: data.id.present ? data.id.value : this.id,
      onlyChosen: data.onlyChosen.present
          ? data.onlyChosen.value
          : this.onlyChosen,
      revealUntil: data.revealUntil.present
          ? data.revealUntil.value
          : this.revealUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceFolderModeData(')
          ..write('id: $id, ')
          ..write('onlyChosen: $onlyChosen, ')
          ..write('revealUntil: $revealUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, onlyChosen, revealUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceFolderModeData &&
          other.id == this.id &&
          other.onlyChosen == this.onlyChosen &&
          other.revealUntil == this.revealUntil);
}

class DeviceFolderModeCompanion extends UpdateCompanion<DeviceFolderModeData> {
  final Value<int> id;
  final Value<int> onlyChosen;
  final Value<int?> revealUntil;
  const DeviceFolderModeCompanion({
    this.id = const Value.absent(),
    this.onlyChosen = const Value.absent(),
    this.revealUntil = const Value.absent(),
  });
  DeviceFolderModeCompanion.insert({
    this.id = const Value.absent(),
    this.onlyChosen = const Value.absent(),
    this.revealUntil = const Value.absent(),
  });
  static Insertable<DeviceFolderModeData> custom({
    Expression<int>? id,
    Expression<int>? onlyChosen,
    Expression<int>? revealUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (onlyChosen != null) 'only_chosen': onlyChosen,
      if (revealUntil != null) 'reveal_until': revealUntil,
    });
  }

  DeviceFolderModeCompanion copyWith({
    Value<int>? id,
    Value<int>? onlyChosen,
    Value<int?>? revealUntil,
  }) {
    return DeviceFolderModeCompanion(
      id: id ?? this.id,
      onlyChosen: onlyChosen ?? this.onlyChosen,
      revealUntil: revealUntil ?? this.revealUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (onlyChosen.present) {
      map['only_chosen'] = Variable<int>(onlyChosen.value);
    }
    if (revealUntil.present) {
      map['reveal_until'] = Variable<int>(revealUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceFolderModeCompanion(')
          ..write('id: $id, ')
          ..write('onlyChosen: $onlyChosen, ')
          ..write('revealUntil: $revealUntil')
          ..write(')'))
        .toString();
  }
}

class ExcludedFolderData extends DataClass {
  final int id;
  const ExcludedFolderData({required this.id});
  factory ExcludedFolderData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExcludedFolderData(id: serializer.fromJson<int>(json['id']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<int>(id)};
  }

  ExcludedFolderData copyWith({int? id}) =>
      ExcludedFolderData(id: id ?? this.id);
  @override
  String toString() {
    return (StringBuffer('ExcludedFolderData(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExcludedFolderData && other.id == this.id);
}

class ExcludedFolder extends ViewInfo<ExcludedFolder, ExcludedFolderData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Replica attachedDatabase;
  ExcludedFolder(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [id];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'excluded_folder';
  @override
  Map<SqlDialect, String> get createViewStatements => {
    SqlDialect.sqlite:
        'CREATE VIEW excluded_folder AS SELECT id FROM device_folder AS f WHERE IFNULL((SELECT g.visibility FROM device_folder AS g WHERE g.volume = f.volume AND g.visibility <> \'inherit\' AND g.path <= f.path AND substr(f.path, 1, length(g.path)) = g.path ORDER BY g.path DESC LIMIT 1), (SELECT IIF(only_chosen, \'hidden\', \'shown\') FROM device_folder_mode)) = \'hidden\'',
  };
  @override
  ExcludedFolder get asDslTable => this;
  @override
  ExcludedFolderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExcludedFolderData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
    );
  }

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  @override
  ExcludedFolder createAlias(String alias) {
    return ExcludedFolder(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {'device_folder', 'device_folder_mode'};
}

class HiddenFolderData extends DataClass {
  final int id;
  const HiddenFolderData({required this.id});
  factory HiddenFolderData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiddenFolderData(id: serializer.fromJson<int>(json['id']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<int>(id)};
  }

  HiddenFolderData copyWith({int? id}) => HiddenFolderData(id: id ?? this.id);
  @override
  String toString() {
    return (StringBuffer('HiddenFolderData(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiddenFolderData && other.id == this.id);
}

class HiddenFolder extends ViewInfo<HiddenFolder, HiddenFolderData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Replica attachedDatabase;
  HiddenFolder(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [id];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'hidden_folder';
  @override
  Map<SqlDialect, String> get createViewStatements => {
    SqlDialect.sqlite:
        'CREATE VIEW hidden_folder AS SELECT id FROM excluded_folder WHERE NOT EXISTS (SELECT 1 FROM device_folder_mode WHERE reveal_until > unixepoch() * 1000)',
  };
  @override
  HiddenFolder get asDslTable => this;
  @override
  HiddenFolderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiddenFolderData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
    );
  }

  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  @override
  HiddenFolder createAlias(String alias) {
    return HiddenFolder(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {'device_folder_mode', 'device_folder'};
}

class TimelineDay extends Table with TableInfo<TimelineDay, TimelineDayData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TimelineDay(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> veiled = GeneratedColumn<int>(
    'veiled',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [day, folder, veiled, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timeline_day';
  @override
  Set<GeneratedColumn> get $primaryKey => {day, folder, veiled};
  @override
  TimelineDayData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineDayData(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      veiled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veiled'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  TimelineDay createAlias(String alias) {
    return TimelineDay(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(day, folder, veiled)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class TimelineDayData extends DataClass implements Insertable<TimelineDayData> {
  final int day;
  final int folder;
  final int veiled;
  final int count;
  const TimelineDayData({
    required this.day,
    required this.folder,
    required this.veiled,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    map['folder'] = Variable<int>(folder);
    map['veiled'] = Variable<int>(veiled);
    map['count'] = Variable<int>(count);
    return map;
  }

  factory TimelineDayData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineDayData(
      day: serializer.fromJson<int>(json['day']),
      folder: serializer.fromJson<int>(json['folder']),
      veiled: serializer.fromJson<int>(json['veiled']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'folder': serializer.toJson<int>(folder),
      'veiled': serializer.toJson<int>(veiled),
      'count': serializer.toJson<int>(count),
    };
  }

  TimelineDayData copyWith({int? day, int? folder, int? veiled, int? count}) =>
      TimelineDayData(
        day: day ?? this.day,
        folder: folder ?? this.folder,
        veiled: veiled ?? this.veiled,
        count: count ?? this.count,
      );
  TimelineDayData copyWithCompanion(TimelineDayCompanion data) {
    return TimelineDayData(
      day: data.day.present ? data.day.value : this.day,
      folder: data.folder.present ? data.folder.value : this.folder,
      veiled: data.veiled.present ? data.veiled.value : this.veiled,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimelineDayData(')
          ..write('day: $day, ')
          ..write('folder: $folder, ')
          ..write('veiled: $veiled, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, folder, veiled, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineDayData &&
          other.day == this.day &&
          other.folder == this.folder &&
          other.veiled == this.veiled &&
          other.count == this.count);
}

class TimelineDayCompanion extends UpdateCompanion<TimelineDayData> {
  final Value<int> day;
  final Value<int> folder;
  final Value<int> veiled;
  final Value<int> count;
  const TimelineDayCompanion({
    this.day = const Value.absent(),
    this.folder = const Value.absent(),
    this.veiled = const Value.absent(),
    this.count = const Value.absent(),
  });
  TimelineDayCompanion.insert({
    required int day,
    required int folder,
    required int veiled,
    required int count,
  }) : day = Value(day),
       folder = Value(folder),
       veiled = Value(veiled),
       count = Value(count);
  static Insertable<TimelineDayData> custom({
    Expression<int>? day,
    Expression<int>? folder,
    Expression<int>? veiled,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (folder != null) 'folder': folder,
      if (veiled != null) 'veiled': veiled,
      if (count != null) 'count': count,
    });
  }

  TimelineDayCompanion copyWith({
    Value<int>? day,
    Value<int>? folder,
    Value<int>? veiled,
    Value<int>? count,
  }) {
    return TimelineDayCompanion(
      day: day ?? this.day,
      folder: folder ?? this.folder,
      veiled: veiled ?? this.veiled,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (folder.present) {
      map['folder'] = Variable<int>(folder.value);
    }
    if (veiled.present) {
      map['veiled'] = Variable<int>(veiled.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimelineDayCompanion(')
          ..write('day: $day, ')
          ..write('folder: $folder, ')
          ..write('veiled: $veiled, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class TimelineAdded extends Table
    with TableInfo<TimelineAdded, TimelineAddedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TimelineAdded(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> veiled = GeneratedColumn<int>(
    'veiled',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [slot, folder, veiled, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timeline_added';
  @override
  Set<GeneratedColumn> get $primaryKey => {slot, folder, veiled};
  @override
  TimelineAddedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineAddedData(
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      veiled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veiled'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  TimelineAdded createAlias(String alias) {
    return TimelineAdded(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(slot, folder, veiled)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class TimelineAddedData extends DataClass
    implements Insertable<TimelineAddedData> {
  final int slot;
  final int folder;
  final int veiled;
  final int count;
  const TimelineAddedData({
    required this.slot,
    required this.folder,
    required this.veiled,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot'] = Variable<int>(slot);
    map['folder'] = Variable<int>(folder);
    map['veiled'] = Variable<int>(veiled);
    map['count'] = Variable<int>(count);
    return map;
  }

  factory TimelineAddedData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineAddedData(
      slot: serializer.fromJson<int>(json['slot']),
      folder: serializer.fromJson<int>(json['folder']),
      veiled: serializer.fromJson<int>(json['veiled']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<int>(slot),
      'folder': serializer.toJson<int>(folder),
      'veiled': serializer.toJson<int>(veiled),
      'count': serializer.toJson<int>(count),
    };
  }

  TimelineAddedData copyWith({
    int? slot,
    int? folder,
    int? veiled,
    int? count,
  }) => TimelineAddedData(
    slot: slot ?? this.slot,
    folder: folder ?? this.folder,
    veiled: veiled ?? this.veiled,
    count: count ?? this.count,
  );
  TimelineAddedData copyWithCompanion(TimelineAddedCompanion data) {
    return TimelineAddedData(
      slot: data.slot.present ? data.slot.value : this.slot,
      folder: data.folder.present ? data.folder.value : this.folder,
      veiled: data.veiled.present ? data.veiled.value : this.veiled,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimelineAddedData(')
          ..write('slot: $slot, ')
          ..write('folder: $folder, ')
          ..write('veiled: $veiled, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, folder, veiled, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineAddedData &&
          other.slot == this.slot &&
          other.folder == this.folder &&
          other.veiled == this.veiled &&
          other.count == this.count);
}

class TimelineAddedCompanion extends UpdateCompanion<TimelineAddedData> {
  final Value<int> slot;
  final Value<int> folder;
  final Value<int> veiled;
  final Value<int> count;
  const TimelineAddedCompanion({
    this.slot = const Value.absent(),
    this.folder = const Value.absent(),
    this.veiled = const Value.absent(),
    this.count = const Value.absent(),
  });
  TimelineAddedCompanion.insert({
    required int slot,
    required int folder,
    required int veiled,
    required int count,
  }) : slot = Value(slot),
       folder = Value(folder),
       veiled = Value(veiled),
       count = Value(count);
  static Insertable<TimelineAddedData> custom({
    Expression<int>? slot,
    Expression<int>? folder,
    Expression<int>? veiled,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (folder != null) 'folder': folder,
      if (veiled != null) 'veiled': veiled,
      if (count != null) 'count': count,
    });
  }

  TimelineAddedCompanion copyWith({
    Value<int>? slot,
    Value<int>? folder,
    Value<int>? veiled,
    Value<int>? count,
  }) {
    return TimelineAddedCompanion(
      slot: slot ?? this.slot,
      folder: folder ?? this.folder,
      veiled: veiled ?? this.veiled,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (folder.present) {
      map['folder'] = Variable<int>(folder.value);
    }
    if (veiled.present) {
      map['veiled'] = Variable<int>(veiled.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimelineAddedCompanion(')
          ..write('slot: $slot, ')
          ..write('folder: $folder, ')
          ..write('veiled: $veiled, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class KeptState extends Table with TableInfo<KeptState, KeptStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  KeptState(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> fingerprint =
      GeneratedColumn<Uint8List>(
        'fingerprint',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL PRIMARY KEY',
      );
  late final GeneratedColumn<int> favorite = GeneratedColumn<int>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> hidden = GeneratedColumn<int>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    fingerprint,
    favorite,
    hidden,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kept_state';
  @override
  Set<GeneratedColumn> get $primaryKey => {fingerprint};
  @override
  KeptStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeptStateData(
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}fingerprint'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}favorite'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  KeptState createAlias(String alias) {
    return KeptState(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class KeptStateData extends DataClass implements Insertable<KeptStateData> {
  final Uint8List fingerprint;
  final int favorite;
  final int hidden;
  final int archived;
  const KeptStateData({
    required this.fingerprint,
    required this.favorite,
    required this.hidden,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fingerprint'] = Variable<Uint8List>(fingerprint);
    map['favorite'] = Variable<int>(favorite);
    map['hidden'] = Variable<int>(hidden);
    map['archived'] = Variable<int>(archived);
    return map;
  }

  factory KeptStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeptStateData(
      fingerprint: serializer.fromJson<Uint8List>(json['fingerprint']),
      favorite: serializer.fromJson<int>(json['favorite']),
      hidden: serializer.fromJson<int>(json['hidden']),
      archived: serializer.fromJson<int>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fingerprint': serializer.toJson<Uint8List>(fingerprint),
      'favorite': serializer.toJson<int>(favorite),
      'hidden': serializer.toJson<int>(hidden),
      'archived': serializer.toJson<int>(archived),
    };
  }

  KeptStateData copyWith({
    Uint8List? fingerprint,
    int? favorite,
    int? hidden,
    int? archived,
  }) => KeptStateData(
    fingerprint: fingerprint ?? this.fingerprint,
    favorite: favorite ?? this.favorite,
    hidden: hidden ?? this.hidden,
    archived: archived ?? this.archived,
  );
  KeptStateData copyWithCompanion(KeptStateCompanion data) {
    return KeptStateData(
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeptStateData(')
          ..write('fingerprint: $fingerprint, ')
          ..write('favorite: $favorite, ')
          ..write('hidden: $hidden, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(fingerprint),
    favorite,
    hidden,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeptStateData &&
          $driftBlobEquality.equals(other.fingerprint, this.fingerprint) &&
          other.favorite == this.favorite &&
          other.hidden == this.hidden &&
          other.archived == this.archived);
}

class KeptStateCompanion extends UpdateCompanion<KeptStateData> {
  final Value<Uint8List> fingerprint;
  final Value<int> favorite;
  final Value<int> hidden;
  final Value<int> archived;
  final Value<int> rowid;
  const KeptStateCompanion({
    this.fingerprint = const Value.absent(),
    this.favorite = const Value.absent(),
    this.hidden = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeptStateCompanion.insert({
    required Uint8List fingerprint,
    this.favorite = const Value.absent(),
    this.hidden = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : fingerprint = Value(fingerprint);
  static Insertable<KeptStateData> custom({
    Expression<Uint8List>? fingerprint,
    Expression<int>? favorite,
    Expression<int>? hidden,
    Expression<int>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (favorite != null) 'favorite': favorite,
      if (hidden != null) 'hidden': hidden,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeptStateCompanion copyWith({
    Value<Uint8List>? fingerprint,
    Value<int>? favorite,
    Value<int>? hidden,
    Value<int>? archived,
    Value<int>? rowid,
  }) {
    return KeptStateCompanion(
      fingerprint: fingerprint ?? this.fingerprint,
      favorite: favorite ?? this.favorite,
      hidden: hidden ?? this.hidden,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fingerprint.present) {
      map['fingerprint'] = Variable<Uint8List>(fingerprint.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<int>(favorite.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<int>(hidden.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeptStateCompanion(')
          ..write('fingerprint: $fingerprint, ')
          ..write('favorite: $favorite, ')
          ..write('hidden: $hidden, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CloudItemData extends DataClass {
  final Uint8List id;
  final String source;
  final String volume;
  final String sourceId;
  final String path;
  final int size;
  final int mtime;
  final String mime;
  final Uint8List? thumbhash;
  final String? projection;
  final int favorite;
  final int hidden;
  final int archived;
  final int added;
  final int day;
  final int sortKey;
  final int folder;
  final String facets;
  final Uint8List assetId;
  final String backup;
  final Uint8List? thumbS;
  final Uint8List? thumbM;
  const CloudItemData({
    required this.id,
    required this.source,
    required this.volume,
    required this.sourceId,
    required this.path,
    required this.size,
    required this.mtime,
    required this.mime,
    this.thumbhash,
    this.projection,
    required this.favorite,
    required this.hidden,
    required this.archived,
    required this.added,
    required this.day,
    required this.sortKey,
    required this.folder,
    required this.facets,
    required this.assetId,
    required this.backup,
    this.thumbS,
    this.thumbM,
  });
  factory CloudItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CloudItemData(
      id: serializer.fromJson<Uint8List>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      volume: serializer.fromJson<String>(json['volume']),
      sourceId: serializer.fromJson<String>(json['source_id']),
      path: serializer.fromJson<String>(json['path']),
      size: serializer.fromJson<int>(json['size']),
      mtime: serializer.fromJson<int>(json['mtime']),
      mime: serializer.fromJson<String>(json['mime']),
      thumbhash: serializer.fromJson<Uint8List?>(json['thumbhash']),
      projection: serializer.fromJson<String?>(json['projection']),
      favorite: serializer.fromJson<int>(json['favorite']),
      hidden: serializer.fromJson<int>(json['hidden']),
      archived: serializer.fromJson<int>(json['archived']),
      added: serializer.fromJson<int>(json['added']),
      day: serializer.fromJson<int>(json['day']),
      sortKey: serializer.fromJson<int>(json['sort_key']),
      folder: serializer.fromJson<int>(json['folder']),
      facets: serializer.fromJson<String>(json['facets']),
      assetId: serializer.fromJson<Uint8List>(json['asset_id']),
      backup: serializer.fromJson<String>(json['backup']),
      thumbS: serializer.fromJson<Uint8List?>(json['thumb_s']),
      thumbM: serializer.fromJson<Uint8List?>(json['thumb_m']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'source': serializer.toJson<String>(source),
      'volume': serializer.toJson<String>(volume),
      'source_id': serializer.toJson<String>(sourceId),
      'path': serializer.toJson<String>(path),
      'size': serializer.toJson<int>(size),
      'mtime': serializer.toJson<int>(mtime),
      'mime': serializer.toJson<String>(mime),
      'thumbhash': serializer.toJson<Uint8List?>(thumbhash),
      'projection': serializer.toJson<String?>(projection),
      'favorite': serializer.toJson<int>(favorite),
      'hidden': serializer.toJson<int>(hidden),
      'archived': serializer.toJson<int>(archived),
      'added': serializer.toJson<int>(added),
      'day': serializer.toJson<int>(day),
      'sort_key': serializer.toJson<int>(sortKey),
      'folder': serializer.toJson<int>(folder),
      'facets': serializer.toJson<String>(facets),
      'asset_id': serializer.toJson<Uint8List>(assetId),
      'backup': serializer.toJson<String>(backup),
      'thumb_s': serializer.toJson<Uint8List?>(thumbS),
      'thumb_m': serializer.toJson<Uint8List?>(thumbM),
    };
  }

  CloudItemData copyWith({
    Uint8List? id,
    String? source,
    String? volume,
    String? sourceId,
    String? path,
    int? size,
    int? mtime,
    String? mime,
    Value<Uint8List?> thumbhash = const Value.absent(),
    Value<String?> projection = const Value.absent(),
    int? favorite,
    int? hidden,
    int? archived,
    int? added,
    int? day,
    int? sortKey,
    int? folder,
    String? facets,
    Uint8List? assetId,
    String? backup,
    Value<Uint8List?> thumbS = const Value.absent(),
    Value<Uint8List?> thumbM = const Value.absent(),
  }) => CloudItemData(
    id: id ?? this.id,
    source: source ?? this.source,
    volume: volume ?? this.volume,
    sourceId: sourceId ?? this.sourceId,
    path: path ?? this.path,
    size: size ?? this.size,
    mtime: mtime ?? this.mtime,
    mime: mime ?? this.mime,
    thumbhash: thumbhash.present ? thumbhash.value : this.thumbhash,
    projection: projection.present ? projection.value : this.projection,
    favorite: favorite ?? this.favorite,
    hidden: hidden ?? this.hidden,
    archived: archived ?? this.archived,
    added: added ?? this.added,
    day: day ?? this.day,
    sortKey: sortKey ?? this.sortKey,
    folder: folder ?? this.folder,
    facets: facets ?? this.facets,
    assetId: assetId ?? this.assetId,
    backup: backup ?? this.backup,
    thumbS: thumbS.present ? thumbS.value : this.thumbS,
    thumbM: thumbM.present ? thumbM.value : this.thumbM,
  );
  @override
  String toString() {
    return (StringBuffer('CloudItemData(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('volume: $volume, ')
          ..write('sourceId: $sourceId, ')
          ..write('path: $path, ')
          ..write('size: $size, ')
          ..write('mtime: $mtime, ')
          ..write('mime: $mime, ')
          ..write('thumbhash: $thumbhash, ')
          ..write('projection: $projection, ')
          ..write('favorite: $favorite, ')
          ..write('hidden: $hidden, ')
          ..write('archived: $archived, ')
          ..write('added: $added, ')
          ..write('day: $day, ')
          ..write('sortKey: $sortKey, ')
          ..write('folder: $folder, ')
          ..write('facets: $facets, ')
          ..write('assetId: $assetId, ')
          ..write('backup: $backup, ')
          ..write('thumbS: $thumbS, ')
          ..write('thumbM: $thumbM')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    $driftBlobEquality.hash(id),
    source,
    volume,
    sourceId,
    path,
    size,
    mtime,
    mime,
    $driftBlobEquality.hash(thumbhash),
    projection,
    favorite,
    hidden,
    archived,
    added,
    day,
    sortKey,
    folder,
    facets,
    $driftBlobEquality.hash(assetId),
    backup,
    $driftBlobEquality.hash(thumbS),
    $driftBlobEquality.hash(thumbM),
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CloudItemData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          other.source == this.source &&
          other.volume == this.volume &&
          other.sourceId == this.sourceId &&
          other.path == this.path &&
          other.size == this.size &&
          other.mtime == this.mtime &&
          other.mime == this.mime &&
          $driftBlobEquality.equals(other.thumbhash, this.thumbhash) &&
          other.projection == this.projection &&
          other.favorite == this.favorite &&
          other.hidden == this.hidden &&
          other.archived == this.archived &&
          other.added == this.added &&
          other.day == this.day &&
          other.sortKey == this.sortKey &&
          other.folder == this.folder &&
          other.facets == this.facets &&
          $driftBlobEquality.equals(other.assetId, this.assetId) &&
          other.backup == this.backup &&
          $driftBlobEquality.equals(other.thumbS, this.thumbS) &&
          $driftBlobEquality.equals(other.thumbM, this.thumbM));
}

class CloudItem extends ViewInfo<CloudItem, CloudItemData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Replica attachedDatabase;
  CloudItem(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    volume,
    sourceId,
    path,
    size,
    mtime,
    mime,
    thumbhash,
    projection,
    favorite,
    hidden,
    archived,
    added,
    day,
    sortKey,
    folder,
    facets,
    assetId,
    backup,
    thumbS,
    thumbM,
  ];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'cloud_item';
  @override
  Map<SqlDialect, String> get createViewStatements => {
    SqlDialect.sqlite:
        'CREATE VIEW cloud_item AS SELECT id, \'server\' AS source, \'\' AS volume, \'\' AS source_id, original_filename AS path, COALESCE(file_size_total, 0) AS size, created_at AS mtime, CASE media_kind WHEN \'video\' THEN \'video/*\' ELSE \'image/*\' END AS mime, thumbhash, CAST(NULL AS TEXT) AS projection, 0 AS favorite, 0 AS hidden, 0 AS archived, created_at AS added, CAST(COALESCE(strftime(\'%Y%m%d\', taken_local), strftime(\'%Y%m%d\', taken_utc / 1000, \'unixepoch\'), 0) AS INTEGER) AS day, COALESCE(taken_utc, created_at) AS sort_key, 0 AS folder, facets, id AS asset_id, \'cloud_only\' AS backup, (SELECT f.content_hash FROM asset_file AS f WHERE f.asset_id = asset.id AND f.role = \'thumb_s\' AND f.state = \'present\') AS thumb_s, (SELECT f.content_hash FROM asset_file AS f WHERE f.asset_id = asset.id AND f.role = \'thumb_m\' AND f.state = \'present\') AS thumb_m FROM asset WHERE trashed_at IS NULL AND archived = 0 AND locked = 0 AND on_device = 0 AND media_kind IN (\'image\', \'video\') AND +library_id IN (SELECT id FROM library) AND NOT EXISTS (SELECT 1 FROM asset_user_state AS s WHERE s.asset_id = asset.id AND s.album_hides_timeline <> 0) AND NOT EXISTS (SELECT 1 FROM library_user_state AS h WHERE h.library_id = asset.library_id AND h.hide_from_timeline <> 0)',
  };
  @override
  CloudItem get asDslTable => this;
  @override
  CloudItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CloudItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}volume'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mtime'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      )!,
      thumbhash: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumbhash'],
      ),
      projection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}projection'],
      ),
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}favorite'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      added: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_key'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      facets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}facets'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}asset_id'],
      )!,
      backup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backup'],
      )!,
      thumbS: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumb_s'],
      ),
      thumbM: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}thumb_m'],
      ),
    );
  }

  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<String> volume = GeneratedColumn<String>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> mtime = GeneratedColumn<int>(
    'mtime',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<Uint8List> thumbhash = GeneratedColumn<Uint8List>(
    'thumbhash',
    aliasedName,
    true,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<String> projection = GeneratedColumn<String>(
    'projection',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<int> favorite = GeneratedColumn<int>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> hidden = GeneratedColumn<int>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> added = GeneratedColumn<int>(
    'added',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> sortKey = GeneratedColumn<int>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<String> facets = GeneratedColumn<String>(
    'facets',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<Uint8List> assetId = GeneratedColumn<Uint8List>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<String> backup = GeneratedColumn<String>(
    'backup',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<Uint8List> thumbS = GeneratedColumn<Uint8List>(
    'thumb_s',
    aliasedName,
    true,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<Uint8List> thumbM = GeneratedColumn<Uint8List>(
    'thumb_m',
    aliasedName,
    true,
    type: DriftSqlType.blob,
  );
  @override
  CloudItem createAlias(String alias) {
    return CloudItem(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {
    'asset',
    'asset_file',
    'library',
    'asset_user_state',
    'library_user_state',
  };
}

class MediaSource extends Table with TableInfo<MediaSource, MediaSourceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MediaSource(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'online\'',
    defaultValue: const CustomExpression('\'online\''),
  );
  late final GeneratedColumn<String> checkpoint = GeneratedColumn<String>(
    'checkpoint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [root, state, checkpoint];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_source';
  @override
  Set<GeneratedColumn> get $primaryKey => {root};
  @override
  MediaSourceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaSourceData(
      root: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      checkpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint'],
      ),
    );
  }

  @override
  MediaSource createAlias(String alias) {
    return MediaSource(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class MediaSourceData extends DataClass implements Insertable<MediaSourceData> {
  final String root;

  /// absolute path
  /// scanning: from when it is added until a full scan ends; online; offline: missing, unreadable or empty, as a drive
  /// away leaves it
  final String state;
  final String? checkpoint;
  const MediaSourceData({
    required this.root,
    required this.state,
    this.checkpoint,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['root'] = Variable<String>(root);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || checkpoint != null) {
      map['checkpoint'] = Variable<String>(checkpoint);
    }
    return map;
  }

  factory MediaSourceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaSourceData(
      root: serializer.fromJson<String>(json['root']),
      state: serializer.fromJson<String>(json['state']),
      checkpoint: serializer.fromJson<String?>(json['checkpoint']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'root': serializer.toJson<String>(root),
      'state': serializer.toJson<String>(state),
      'checkpoint': serializer.toJson<String?>(checkpoint),
    };
  }

  MediaSourceData copyWith({
    String? root,
    String? state,
    Value<String?> checkpoint = const Value.absent(),
  }) => MediaSourceData(
    root: root ?? this.root,
    state: state ?? this.state,
    checkpoint: checkpoint.present ? checkpoint.value : this.checkpoint,
  );
  MediaSourceData copyWithCompanion(MediaSourceCompanion data) {
    return MediaSourceData(
      root: data.root.present ? data.root.value : this.root,
      state: data.state.present ? data.state.value : this.state,
      checkpoint: data.checkpoint.present
          ? data.checkpoint.value
          : this.checkpoint,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaSourceData(')
          ..write('root: $root, ')
          ..write('state: $state, ')
          ..write('checkpoint: $checkpoint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(root, state, checkpoint);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaSourceData &&
          other.root == this.root &&
          other.state == this.state &&
          other.checkpoint == this.checkpoint);
}

class MediaSourceCompanion extends UpdateCompanion<MediaSourceData> {
  final Value<String> root;
  final Value<String> state;
  final Value<String?> checkpoint;
  final Value<int> rowid;
  const MediaSourceCompanion({
    this.root = const Value.absent(),
    this.state = const Value.absent(),
    this.checkpoint = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaSourceCompanion.insert({
    required String root,
    this.state = const Value.absent(),
    this.checkpoint = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : root = Value(root);
  static Insertable<MediaSourceData> custom({
    Expression<String>? root,
    Expression<String>? state,
    Expression<String>? checkpoint,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (root != null) 'root': root,
      if (state != null) 'state': state,
      if (checkpoint != null) 'checkpoint': checkpoint,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaSourceCompanion copyWith({
    Value<String>? root,
    Value<String>? state,
    Value<String?>? checkpoint,
    Value<int>? rowid,
  }) {
    return MediaSourceCompanion(
      root: root ?? this.root,
      state: state ?? this.state,
      checkpoint: checkpoint ?? this.checkpoint,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (checkpoint.present) {
      map['checkpoint'] = Variable<String>(checkpoint.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaSourceCompanion(')
          ..write('root: $root, ')
          ..write('state: $state, ')
          ..write('checkpoint: $checkpoint, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class VolumeCursor extends Table
    with TableInfo<VolumeCursor, VolumeCursorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  VolumeCursor(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> volume = GeneratedColumn<String>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> installId = GeneratedColumn<String>(
    'install_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> generation = GeneratedColumn<int>(
    'generation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    source,
    volume,
    installId,
    version,
    generation,
    root,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'volume_cursor';
  @override
  Set<GeneratedColumn> get $primaryKey => {source, volume};
  @override
  VolumeCursorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VolumeCursorData(
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}volume'],
      )!,
      installId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}install_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      generation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generation'],
      )!,
      root: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root'],
      ),
    );
  }

  @override
  VolumeCursor createAlias(String alias) {
    return VolumeCursor(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const ['PRIMARY KEY(source, volume)'];
  @override
  bool get dontWriteConstraints => true;
}

class VolumeCursorData extends DataClass
    implements Insertable<VolumeCursorData> {
  final String source;
  final String volume;
  final String installId;

  /// the install that indexed it
  /// MediaStore.getVersion, whose generations another version cannot compare; PhotoKit's persistent change token
  final String version;
  final int generation;

  /// the volume's generation the index has caught up with
  final String? root;
  const VolumeCursorData({
    required this.source,
    required this.volume,
    required this.installId,
    required this.version,
    required this.generation,
    this.root,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source'] = Variable<String>(source);
    map['volume'] = Variable<String>(volume);
    map['install_id'] = Variable<String>(installId);
    map['version'] = Variable<String>(version);
    map['generation'] = Variable<int>(generation);
    if (!nullToAbsent || root != null) {
      map['root'] = Variable<String>(root);
    }
    return map;
  }

  factory VolumeCursorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VolumeCursorData(
      source: serializer.fromJson<String>(json['source']),
      volume: serializer.fromJson<String>(json['volume']),
      installId: serializer.fromJson<String>(json['install_id']),
      version: serializer.fromJson<String>(json['version']),
      generation: serializer.fromJson<int>(json['generation']),
      root: serializer.fromJson<String?>(json['root']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'source': serializer.toJson<String>(source),
      'volume': serializer.toJson<String>(volume),
      'install_id': serializer.toJson<String>(installId),
      'version': serializer.toJson<String>(version),
      'generation': serializer.toJson<int>(generation),
      'root': serializer.toJson<String?>(root),
    };
  }

  VolumeCursorData copyWith({
    String? source,
    String? volume,
    String? installId,
    String? version,
    int? generation,
    Value<String?> root = const Value.absent(),
  }) => VolumeCursorData(
    source: source ?? this.source,
    volume: volume ?? this.volume,
    installId: installId ?? this.installId,
    version: version ?? this.version,
    generation: generation ?? this.generation,
    root: root.present ? root.value : this.root,
  );
  VolumeCursorData copyWithCompanion(VolumeCursorCompanion data) {
    return VolumeCursorData(
      source: data.source.present ? data.source.value : this.source,
      volume: data.volume.present ? data.volume.value : this.volume,
      installId: data.installId.present ? data.installId.value : this.installId,
      version: data.version.present ? data.version.value : this.version,
      generation: data.generation.present
          ? data.generation.value
          : this.generation,
      root: data.root.present ? data.root.value : this.root,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VolumeCursorData(')
          ..write('source: $source, ')
          ..write('volume: $volume, ')
          ..write('installId: $installId, ')
          ..write('version: $version, ')
          ..write('generation: $generation, ')
          ..write('root: $root')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(source, volume, installId, version, generation, root);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VolumeCursorData &&
          other.source == this.source &&
          other.volume == this.volume &&
          other.installId == this.installId &&
          other.version == this.version &&
          other.generation == this.generation &&
          other.root == this.root);
}

class VolumeCursorCompanion extends UpdateCompanion<VolumeCursorData> {
  final Value<String> source;
  final Value<String> volume;
  final Value<String> installId;
  final Value<String> version;
  final Value<int> generation;
  final Value<String?> root;
  final Value<int> rowid;
  const VolumeCursorCompanion({
    this.source = const Value.absent(),
    this.volume = const Value.absent(),
    this.installId = const Value.absent(),
    this.version = const Value.absent(),
    this.generation = const Value.absent(),
    this.root = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VolumeCursorCompanion.insert({
    required String source,
    required String volume,
    required String installId,
    required String version,
    required int generation,
    this.root = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : source = Value(source),
       volume = Value(volume),
       installId = Value(installId),
       version = Value(version),
       generation = Value(generation);
  static Insertable<VolumeCursorData> custom({
    Expression<String>? source,
    Expression<String>? volume,
    Expression<String>? installId,
    Expression<String>? version,
    Expression<int>? generation,
    Expression<String>? root,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (source != null) 'source': source,
      if (volume != null) 'volume': volume,
      if (installId != null) 'install_id': installId,
      if (version != null) 'version': version,
      if (generation != null) 'generation': generation,
      if (root != null) 'root': root,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VolumeCursorCompanion copyWith({
    Value<String>? source,
    Value<String>? volume,
    Value<String>? installId,
    Value<String>? version,
    Value<int>? generation,
    Value<String?>? root,
    Value<int>? rowid,
  }) {
    return VolumeCursorCompanion(
      source: source ?? this.source,
      volume: volume ?? this.volume,
      installId: installId ?? this.installId,
      version: version ?? this.version,
      generation: generation ?? this.generation,
      root: root ?? this.root,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (volume.present) {
      map['volume'] = Variable<String>(volume.value);
    }
    if (installId.present) {
      map['install_id'] = Variable<String>(installId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (generation.present) {
      map['generation'] = Variable<int>(generation.value);
    }
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VolumeCursorCompanion(')
          ..write('source: $source, ')
          ..write('volume: $volume, ')
          ..write('installId: $installId, ')
          ..write('version: $version, ')
          ..write('generation: $generation, ')
          ..write('root: $root, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class BackupState extends Table with TableInfo<BackupState, BackupStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  BackupState(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> localAssetId =
      GeneratedColumn<Uint8List>(
        'local_asset_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL PRIMARY KEY',
      );
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> retryAt = GeneratedColumn<int>(
    'retry_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> upload = GeneratedColumn<String>(
    'upload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localAssetId,
    state,
    reason,
    retryAt,
    updatedAt,
    upload,
    attempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_state';
  @override
  Set<GeneratedColumn> get $primaryKey => {localAssetId};
  @override
  BackupStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupStateData(
      localAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}local_asset_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      retryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      upload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
    );
  }

  @override
  BackupState createAlias(String alias) {
    return BackupState(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class BackupStateData extends DataClass implements Insertable<BackupStateData> {
  final Uint8List localAssetId;
  final String state;
  final String? reason;
  final int? retryAt;
  final int updatedAt;

  /// Schema 25: the upload's path on the server, kept before its first byte is sent, so that a restart resumes it;
  /// and the failures in a row, which space the retries out (ADR-0226).
  final String? upload;
  final int attempts;
  const BackupStateData({
    required this.localAssetId,
    required this.state,
    this.reason,
    this.retryAt,
    required this.updatedAt,
    this.upload,
    required this.attempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_asset_id'] = Variable<Uint8List>(localAssetId);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || retryAt != null) {
      map['retry_at'] = Variable<int>(retryAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || upload != null) {
      map['upload'] = Variable<String>(upload);
    }
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  factory BackupStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupStateData(
      localAssetId: serializer.fromJson<Uint8List>(json['local_asset_id']),
      state: serializer.fromJson<String>(json['state']),
      reason: serializer.fromJson<String?>(json['reason']),
      retryAt: serializer.fromJson<int?>(json['retry_at']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
      upload: serializer.fromJson<String?>(json['upload']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_asset_id': serializer.toJson<Uint8List>(localAssetId),
      'state': serializer.toJson<String>(state),
      'reason': serializer.toJson<String?>(reason),
      'retry_at': serializer.toJson<int?>(retryAt),
      'updated_at': serializer.toJson<int>(updatedAt),
      'upload': serializer.toJson<String?>(upload),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  BackupStateData copyWith({
    Uint8List? localAssetId,
    String? state,
    Value<String?> reason = const Value.absent(),
    Value<int?> retryAt = const Value.absent(),
    int? updatedAt,
    Value<String?> upload = const Value.absent(),
    int? attempts,
  }) => BackupStateData(
    localAssetId: localAssetId ?? this.localAssetId,
    state: state ?? this.state,
    reason: reason.present ? reason.value : this.reason,
    retryAt: retryAt.present ? retryAt.value : this.retryAt,
    updatedAt: updatedAt ?? this.updatedAt,
    upload: upload.present ? upload.value : this.upload,
    attempts: attempts ?? this.attempts,
  );
  BackupStateData copyWithCompanion(BackupStateCompanion data) {
    return BackupStateData(
      localAssetId: data.localAssetId.present
          ? data.localAssetId.value
          : this.localAssetId,
      state: data.state.present ? data.state.value : this.state,
      reason: data.reason.present ? data.reason.value : this.reason,
      retryAt: data.retryAt.present ? data.retryAt.value : this.retryAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      upload: data.upload.present ? data.upload.value : this.upload,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupStateData(')
          ..write('localAssetId: $localAssetId, ')
          ..write('state: $state, ')
          ..write('reason: $reason, ')
          ..write('retryAt: $retryAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('upload: $upload, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(localAssetId),
    state,
    reason,
    retryAt,
    updatedAt,
    upload,
    attempts,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupStateData &&
          $driftBlobEquality.equals(other.localAssetId, this.localAssetId) &&
          other.state == this.state &&
          other.reason == this.reason &&
          other.retryAt == this.retryAt &&
          other.updatedAt == this.updatedAt &&
          other.upload == this.upload &&
          other.attempts == this.attempts);
}

class BackupStateCompanion extends UpdateCompanion<BackupStateData> {
  final Value<Uint8List> localAssetId;
  final Value<String> state;
  final Value<String?> reason;
  final Value<int?> retryAt;
  final Value<int> updatedAt;
  final Value<String?> upload;
  final Value<int> attempts;
  final Value<int> rowid;
  const BackupStateCompanion({
    this.localAssetId = const Value.absent(),
    this.state = const Value.absent(),
    this.reason = const Value.absent(),
    this.retryAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.upload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupStateCompanion.insert({
    required Uint8List localAssetId,
    required String state,
    this.reason = const Value.absent(),
    this.retryAt = const Value.absent(),
    required int updatedAt,
    this.upload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localAssetId = Value(localAssetId),
       state = Value(state),
       updatedAt = Value(updatedAt);
  static Insertable<BackupStateData> custom({
    Expression<Uint8List>? localAssetId,
    Expression<String>? state,
    Expression<String>? reason,
    Expression<int>? retryAt,
    Expression<int>? updatedAt,
    Expression<String>? upload,
    Expression<int>? attempts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localAssetId != null) 'local_asset_id': localAssetId,
      if (state != null) 'state': state,
      if (reason != null) 'reason': reason,
      if (retryAt != null) 'retry_at': retryAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (upload != null) 'upload': upload,
      if (attempts != null) 'attempts': attempts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupStateCompanion copyWith({
    Value<Uint8List>? localAssetId,
    Value<String>? state,
    Value<String?>? reason,
    Value<int?>? retryAt,
    Value<int>? updatedAt,
    Value<String?>? upload,
    Value<int>? attempts,
    Value<int>? rowid,
  }) {
    return BackupStateCompanion(
      localAssetId: localAssetId ?? this.localAssetId,
      state: state ?? this.state,
      reason: reason ?? this.reason,
      retryAt: retryAt ?? this.retryAt,
      updatedAt: updatedAt ?? this.updatedAt,
      upload: upload ?? this.upload,
      attempts: attempts ?? this.attempts,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localAssetId.present) {
      map['local_asset_id'] = Variable<Uint8List>(localAssetId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (retryAt.present) {
      map['retry_at'] = Variable<int>(retryAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (upload.present) {
      map['upload'] = Variable<String>(upload.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupStateCompanion(')
          ..write('localAssetId: $localAssetId, ')
          ..write('state: $state, ')
          ..write('reason: $reason, ')
          ..write('retryAt: $retryAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('upload: $upload, ')
          ..write('attempts: $attempts, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class BackupRun extends Table with TableInfo<BackupRun, BackupRunData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  BackupRun(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<int> started = GeneratedColumn<int>(
    'started',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> ended = GeneratedColumn<int>(
    'ended',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> uploaded = GeneratedColumn<int>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> linked = GeneratedColumn<int>(
    'linked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> failed = GeneratedColumn<int>(
    'failed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> pending = GeneratedColumn<int>(
    'pending',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> stopped = GeneratedColumn<String>(
    'stopped',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    started,
    ended,
    uploaded,
    linked,
    failed,
    pending,
    stopped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_run';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupRunData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupRunData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      started: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started'],
      )!,
      ended: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended'],
      ),
      uploaded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded'],
      )!,
      linked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked'],
      )!,
      failed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed'],
      )!,
      pending: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending'],
      )!,
      stopped: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stopped'],
      ),
    );
  }

  @override
  BackupRun createAlias(String alias) {
    return BackupRun(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class BackupRunData extends DataClass implements Insertable<BackupRunData> {
  final int id;
  final int started;
  final int? ended;

  /// NULL while it runs, or once the app was stopped during it
  final int uploaded;
  final int linked;
  final int failed;
  final int pending;
  final String? stopped;
  const BackupRunData({
    required this.id,
    required this.started,
    this.ended,
    required this.uploaded,
    required this.linked,
    required this.failed,
    required this.pending,
    this.stopped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started'] = Variable<int>(started);
    if (!nullToAbsent || ended != null) {
      map['ended'] = Variable<int>(ended);
    }
    map['uploaded'] = Variable<int>(uploaded);
    map['linked'] = Variable<int>(linked);
    map['failed'] = Variable<int>(failed);
    map['pending'] = Variable<int>(pending);
    if (!nullToAbsent || stopped != null) {
      map['stopped'] = Variable<String>(stopped);
    }
    return map;
  }

  factory BackupRunData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupRunData(
      id: serializer.fromJson<int>(json['id']),
      started: serializer.fromJson<int>(json['started']),
      ended: serializer.fromJson<int?>(json['ended']),
      uploaded: serializer.fromJson<int>(json['uploaded']),
      linked: serializer.fromJson<int>(json['linked']),
      failed: serializer.fromJson<int>(json['failed']),
      pending: serializer.fromJson<int>(json['pending']),
      stopped: serializer.fromJson<String?>(json['stopped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'started': serializer.toJson<int>(started),
      'ended': serializer.toJson<int?>(ended),
      'uploaded': serializer.toJson<int>(uploaded),
      'linked': serializer.toJson<int>(linked),
      'failed': serializer.toJson<int>(failed),
      'pending': serializer.toJson<int>(pending),
      'stopped': serializer.toJson<String?>(stopped),
    };
  }

  BackupRunData copyWith({
    int? id,
    int? started,
    Value<int?> ended = const Value.absent(),
    int? uploaded,
    int? linked,
    int? failed,
    int? pending,
    Value<String?> stopped = const Value.absent(),
  }) => BackupRunData(
    id: id ?? this.id,
    started: started ?? this.started,
    ended: ended.present ? ended.value : this.ended,
    uploaded: uploaded ?? this.uploaded,
    linked: linked ?? this.linked,
    failed: failed ?? this.failed,
    pending: pending ?? this.pending,
    stopped: stopped.present ? stopped.value : this.stopped,
  );
  BackupRunData copyWithCompanion(BackupRunCompanion data) {
    return BackupRunData(
      id: data.id.present ? data.id.value : this.id,
      started: data.started.present ? data.started.value : this.started,
      ended: data.ended.present ? data.ended.value : this.ended,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      linked: data.linked.present ? data.linked.value : this.linked,
      failed: data.failed.present ? data.failed.value : this.failed,
      pending: data.pending.present ? data.pending.value : this.pending,
      stopped: data.stopped.present ? data.stopped.value : this.stopped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupRunData(')
          ..write('id: $id, ')
          ..write('started: $started, ')
          ..write('ended: $ended, ')
          ..write('uploaded: $uploaded, ')
          ..write('linked: $linked, ')
          ..write('failed: $failed, ')
          ..write('pending: $pending, ')
          ..write('stopped: $stopped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    started,
    ended,
    uploaded,
    linked,
    failed,
    pending,
    stopped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupRunData &&
          other.id == this.id &&
          other.started == this.started &&
          other.ended == this.ended &&
          other.uploaded == this.uploaded &&
          other.linked == this.linked &&
          other.failed == this.failed &&
          other.pending == this.pending &&
          other.stopped == this.stopped);
}

class BackupRunCompanion extends UpdateCompanion<BackupRunData> {
  final Value<int> id;
  final Value<int> started;
  final Value<int?> ended;
  final Value<int> uploaded;
  final Value<int> linked;
  final Value<int> failed;
  final Value<int> pending;
  final Value<String?> stopped;
  const BackupRunCompanion({
    this.id = const Value.absent(),
    this.started = const Value.absent(),
    this.ended = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.linked = const Value.absent(),
    this.failed = const Value.absent(),
    this.pending = const Value.absent(),
    this.stopped = const Value.absent(),
  });
  BackupRunCompanion.insert({
    this.id = const Value.absent(),
    required int started,
    this.ended = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.linked = const Value.absent(),
    this.failed = const Value.absent(),
    this.pending = const Value.absent(),
    this.stopped = const Value.absent(),
  }) : started = Value(started);
  static Insertable<BackupRunData> custom({
    Expression<int>? id,
    Expression<int>? started,
    Expression<int>? ended,
    Expression<int>? uploaded,
    Expression<int>? linked,
    Expression<int>? failed,
    Expression<int>? pending,
    Expression<String>? stopped,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (started != null) 'started': started,
      if (ended != null) 'ended': ended,
      if (uploaded != null) 'uploaded': uploaded,
      if (linked != null) 'linked': linked,
      if (failed != null) 'failed': failed,
      if (pending != null) 'pending': pending,
      if (stopped != null) 'stopped': stopped,
    });
  }

  BackupRunCompanion copyWith({
    Value<int>? id,
    Value<int>? started,
    Value<int?>? ended,
    Value<int>? uploaded,
    Value<int>? linked,
    Value<int>? failed,
    Value<int>? pending,
    Value<String?>? stopped,
  }) {
    return BackupRunCompanion(
      id: id ?? this.id,
      started: started ?? this.started,
      ended: ended ?? this.ended,
      uploaded: uploaded ?? this.uploaded,
      linked: linked ?? this.linked,
      failed: failed ?? this.failed,
      pending: pending ?? this.pending,
      stopped: stopped ?? this.stopped,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (started.present) {
      map['started'] = Variable<int>(started.value);
    }
    if (ended.present) {
      map['ended'] = Variable<int>(ended.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<int>(uploaded.value);
    }
    if (linked.present) {
      map['linked'] = Variable<int>(linked.value);
    }
    if (failed.present) {
      map['failed'] = Variable<int>(failed.value);
    }
    if (pending.present) {
      map['pending'] = Variable<int>(pending.value);
    }
    if (stopped.present) {
      map['stopped'] = Variable<String>(stopped.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupRunCompanion(')
          ..write('id: $id, ')
          ..write('started: $started, ')
          ..write('ended: $ended, ')
          ..write('uploaded: $uploaded, ')
          ..write('linked: $linked, ')
          ..write('failed: $failed, ')
          ..write('pending: $pending, ')
          ..write('stopped: $stopped')
          ..write(')'))
        .toString();
  }
}

class Outbox extends Table with TableInfo<Outbox, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Outbox(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> mutationId = GeneratedColumn<Uint8List>(
    'mutation_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> entityId = GeneratedColumn<Uint8List>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> mutation = GeneratedColumn<Uint8List>(
    'mutation',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> retryAt = GeneratedColumn<int>(
    'retry_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    mutationId,
    entity,
    entityId,
    mutation,
    attempts,
    retryAt,
    error,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      mutationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}mutation_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}entity_id'],
      )!,
      mutation: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}mutation'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      retryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_at'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  Outbox createAlias(String alias) {
    return Outbox(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final int seq;
  final Uint8List mutationId;

  /// the idempotency key
  final String entity;
  final Uint8List entityId;
  final Uint8List mutation;

  /// photolib.sync.v1.Mutation
  final int attempts;
  final int? retryAt;
  final String? error;
  final int createdAt;
  const OutboxData({
    required this.seq,
    required this.mutationId,
    required this.entity,
    required this.entityId,
    required this.mutation,
    required this.attempts,
    this.retryAt,
    this.error,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['mutation_id'] = Variable<Uint8List>(mutationId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<Uint8List>(entityId);
    map['mutation'] = Variable<Uint8List>(mutation);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || retryAt != null) {
      map['retry_at'] = Variable<int>(retryAt);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      seq: serializer.fromJson<int>(json['seq']),
      mutationId: serializer.fromJson<Uint8List>(json['mutation_id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<Uint8List>(json['entity_id']),
      mutation: serializer.fromJson<Uint8List>(json['mutation']),
      attempts: serializer.fromJson<int>(json['attempts']),
      retryAt: serializer.fromJson<int?>(json['retry_at']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<int>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'mutation_id': serializer.toJson<Uint8List>(mutationId),
      'entity': serializer.toJson<String>(entity),
      'entity_id': serializer.toJson<Uint8List>(entityId),
      'mutation': serializer.toJson<Uint8List>(mutation),
      'attempts': serializer.toJson<int>(attempts),
      'retry_at': serializer.toJson<int?>(retryAt),
      'error': serializer.toJson<String?>(error),
      'created_at': serializer.toJson<int>(createdAt),
    };
  }

  OutboxData copyWith({
    int? seq,
    Uint8List? mutationId,
    String? entity,
    Uint8List? entityId,
    Uint8List? mutation,
    int? attempts,
    Value<int?> retryAt = const Value.absent(),
    Value<String?> error = const Value.absent(),
    int? createdAt,
  }) => OutboxData(
    seq: seq ?? this.seq,
    mutationId: mutationId ?? this.mutationId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    mutation: mutation ?? this.mutation,
    attempts: attempts ?? this.attempts,
    retryAt: retryAt.present ? retryAt.value : this.retryAt,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      seq: data.seq.present ? data.seq.value : this.seq,
      mutationId: data.mutationId.present
          ? data.mutationId.value
          : this.mutationId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      mutation: data.mutation.present ? data.mutation.value : this.mutation,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      retryAt: data.retryAt.present ? data.retryAt.value : this.retryAt,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('seq: $seq, ')
          ..write('mutationId: $mutationId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('mutation: $mutation, ')
          ..write('attempts: $attempts, ')
          ..write('retryAt: $retryAt, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    $driftBlobEquality.hash(mutationId),
    entity,
    $driftBlobEquality.hash(entityId),
    $driftBlobEquality.hash(mutation),
    attempts,
    retryAt,
    error,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.seq == this.seq &&
          $driftBlobEquality.equals(other.mutationId, this.mutationId) &&
          other.entity == this.entity &&
          $driftBlobEquality.equals(other.entityId, this.entityId) &&
          $driftBlobEquality.equals(other.mutation, this.mutation) &&
          other.attempts == this.attempts &&
          other.retryAt == this.retryAt &&
          other.error == this.error &&
          other.createdAt == this.createdAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<int> seq;
  final Value<Uint8List> mutationId;
  final Value<String> entity;
  final Value<Uint8List> entityId;
  final Value<Uint8List> mutation;
  final Value<int> attempts;
  final Value<int?> retryAt;
  final Value<String?> error;
  final Value<int> createdAt;
  const OutboxCompanion({
    this.seq = const Value.absent(),
    this.mutationId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.mutation = const Value.absent(),
    this.attempts = const Value.absent(),
    this.retryAt = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.seq = const Value.absent(),
    required Uint8List mutationId,
    required String entity,
    required Uint8List entityId,
    required Uint8List mutation,
    this.attempts = const Value.absent(),
    this.retryAt = const Value.absent(),
    this.error = const Value.absent(),
    required int createdAt,
  }) : mutationId = Value(mutationId),
       entity = Value(entity),
       entityId = Value(entityId),
       mutation = Value(mutation),
       createdAt = Value(createdAt);
  static Insertable<OutboxData> custom({
    Expression<int>? seq,
    Expression<Uint8List>? mutationId,
    Expression<String>? entity,
    Expression<Uint8List>? entityId,
    Expression<Uint8List>? mutation,
    Expression<int>? attempts,
    Expression<int>? retryAt,
    Expression<String>? error,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (mutationId != null) 'mutation_id': mutationId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (mutation != null) 'mutation': mutation,
      if (attempts != null) 'attempts': attempts,
      if (retryAt != null) 'retry_at': retryAt,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? seq,
    Value<Uint8List>? mutationId,
    Value<String>? entity,
    Value<Uint8List>? entityId,
    Value<Uint8List>? mutation,
    Value<int>? attempts,
    Value<int?>? retryAt,
    Value<String?>? error,
    Value<int>? createdAt,
  }) {
    return OutboxCompanion(
      seq: seq ?? this.seq,
      mutationId: mutationId ?? this.mutationId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      mutation: mutation ?? this.mutation,
      attempts: attempts ?? this.attempts,
      retryAt: retryAt ?? this.retryAt,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (mutationId.present) {
      map['mutation_id'] = Variable<Uint8List>(mutationId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<Uint8List>(entityId.value);
    }
    if (mutation.present) {
      map['mutation'] = Variable<Uint8List>(mutation.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (retryAt.present) {
      map['retry_at'] = Variable<int>(retryAt.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('seq: $seq, ')
          ..write('mutationId: $mutationId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('mutation: $mutation, ')
          ..write('attempts: $attempts, ')
          ..write('retryAt: $retryAt, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class Clock extends Table with TableInfo<Clock, ClockData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Clock(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> deviceId = GeneratedColumn<Uint8List>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<int> ms = GeneratedColumn<int>(
    'ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> counter = GeneratedColumn<int>(
    'counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, ms, counter];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clock';
  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  ClockData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClockData(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}device_id'],
      )!,
      ms: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ms'],
      )!,
      counter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counter'],
      )!,
    );
  }

  @override
  Clock createAlias(String alias) {
    return Clock(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class ClockData extends DataClass implements Insertable<ClockData> {
  final Uint8List deviceId;
  final int ms;
  final int counter;
  const ClockData({
    required this.deviceId,
    required this.ms,
    required this.counter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<Uint8List>(deviceId);
    map['ms'] = Variable<int>(ms);
    map['counter'] = Variable<int>(counter);
    return map;
  }

  factory ClockData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClockData(
      deviceId: serializer.fromJson<Uint8List>(json['device_id']),
      ms: serializer.fromJson<int>(json['ms']),
      counter: serializer.fromJson<int>(json['counter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'device_id': serializer.toJson<Uint8List>(deviceId),
      'ms': serializer.toJson<int>(ms),
      'counter': serializer.toJson<int>(counter),
    };
  }

  ClockData copyWith({Uint8List? deviceId, int? ms, int? counter}) => ClockData(
    deviceId: deviceId ?? this.deviceId,
    ms: ms ?? this.ms,
    counter: counter ?? this.counter,
  );
  ClockData copyWithCompanion(ClockCompanion data) {
    return ClockData(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      ms: data.ms.present ? data.ms.value : this.ms,
      counter: data.counter.present ? data.counter.value : this.counter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClockData(')
          ..write('deviceId: $deviceId, ')
          ..write('ms: $ms, ')
          ..write('counter: $counter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash($driftBlobEquality.hash(deviceId), ms, counter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClockData &&
          $driftBlobEquality.equals(other.deviceId, this.deviceId) &&
          other.ms == this.ms &&
          other.counter == this.counter);
}

class ClockCompanion extends UpdateCompanion<ClockData> {
  final Value<Uint8List> deviceId;
  final Value<int> ms;
  final Value<int> counter;
  final Value<int> rowid;
  const ClockCompanion({
    this.deviceId = const Value.absent(),
    this.ms = const Value.absent(),
    this.counter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClockCompanion.insert({
    required Uint8List deviceId,
    required int ms,
    required int counter,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       ms = Value(ms),
       counter = Value(counter);
  static Insertable<ClockData> custom({
    Expression<Uint8List>? deviceId,
    Expression<int>? ms,
    Expression<int>? counter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (ms != null) 'ms': ms,
      if (counter != null) 'counter': counter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClockCompanion copyWith({
    Value<Uint8List>? deviceId,
    Value<int>? ms,
    Value<int>? counter,
    Value<int>? rowid,
  }) {
    return ClockCompanion(
      deviceId: deviceId ?? this.deviceId,
      ms: ms ?? this.ms,
      counter: counter ?? this.counter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<Uint8List>(deviceId.value);
    }
    if (ms.present) {
      map['ms'] = Variable<int>(ms.value);
    }
    if (counter.present) {
      map['counter'] = Variable<int>(counter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClockCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('ms: $ms, ')
          ..write('counter: $counter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SyncCursor extends Table with TableInfo<SyncCursor, SyncCursorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SyncCursor(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> stream = GeneratedColumn<String>(
    'stream',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<Uint8List> cursor = GeneratedColumn<Uint8List>(
    'cursor',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> epoch = GeneratedColumn<String>(
    'epoch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [stream, cursor, updatedAt, epoch];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursor';
  @override
  Set<GeneratedColumn> get $primaryKey => {stream};
  @override
  SyncCursorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursorData(
      stream: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stream'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}cursor'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      epoch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}epoch'],
      ),
    );
  }

  @override
  SyncCursor createAlias(String alias) {
    return SyncCursor(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class SyncCursorData extends DataClass implements Insertable<SyncCursorData> {
  final String stream;
  final Uint8List cursor;
  final int updatedAt;
  final String? epoch;
  const SyncCursorData({
    required this.stream,
    required this.cursor,
    required this.updatedAt,
    this.epoch,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stream'] = Variable<String>(stream);
    map['cursor'] = Variable<Uint8List>(cursor);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || epoch != null) {
      map['epoch'] = Variable<String>(epoch);
    }
    return map;
  }

  factory SyncCursorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursorData(
      stream: serializer.fromJson<String>(json['stream']),
      cursor: serializer.fromJson<Uint8List>(json['cursor']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
      epoch: serializer.fromJson<String?>(json['epoch']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stream': serializer.toJson<String>(stream),
      'cursor': serializer.toJson<Uint8List>(cursor),
      'updated_at': serializer.toJson<int>(updatedAt),
      'epoch': serializer.toJson<String?>(epoch),
    };
  }

  SyncCursorData copyWith({
    String? stream,
    Uint8List? cursor,
    int? updatedAt,
    Value<String?> epoch = const Value.absent(),
  }) => SyncCursorData(
    stream: stream ?? this.stream,
    cursor: cursor ?? this.cursor,
    updatedAt: updatedAt ?? this.updatedAt,
    epoch: epoch.present ? epoch.value : this.epoch,
  );
  SyncCursorData copyWithCompanion(SyncCursorCompanion data) {
    return SyncCursorData(
      stream: data.stream.present ? data.stream.value : this.stream,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      epoch: data.epoch.present ? data.epoch.value : this.epoch,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorData(')
          ..write('stream: $stream, ')
          ..write('cursor: $cursor, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('epoch: $epoch')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(stream, $driftBlobEquality.hash(cursor), updatedAt, epoch);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursorData &&
          other.stream == this.stream &&
          $driftBlobEquality.equals(other.cursor, this.cursor) &&
          other.updatedAt == this.updatedAt &&
          other.epoch == this.epoch);
}

class SyncCursorCompanion extends UpdateCompanion<SyncCursorData> {
  final Value<String> stream;
  final Value<Uint8List> cursor;
  final Value<int> updatedAt;
  final Value<String?> epoch;
  final Value<int> rowid;
  const SyncCursorCompanion({
    this.stream = const Value.absent(),
    this.cursor = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.epoch = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorCompanion.insert({
    required String stream,
    required Uint8List cursor,
    required int updatedAt,
    this.epoch = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : stream = Value(stream),
       cursor = Value(cursor),
       updatedAt = Value(updatedAt);
  static Insertable<SyncCursorData> custom({
    Expression<String>? stream,
    Expression<Uint8List>? cursor,
    Expression<int>? updatedAt,
    Expression<String>? epoch,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stream != null) 'stream': stream,
      if (cursor != null) 'cursor': cursor,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (epoch != null) 'epoch': epoch,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorCompanion copyWith({
    Value<String>? stream,
    Value<Uint8List>? cursor,
    Value<int>? updatedAt,
    Value<String?>? epoch,
    Value<int>? rowid,
  }) {
    return SyncCursorCompanion(
      stream: stream ?? this.stream,
      cursor: cursor ?? this.cursor,
      updatedAt: updatedAt ?? this.updatedAt,
      epoch: epoch ?? this.epoch,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stream.present) {
      map['stream'] = Variable<String>(stream.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<Uint8List>(cursor.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (epoch.present) {
      map['epoch'] = Variable<String>(epoch.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorCompanion(')
          ..write('stream: $stream, ')
          ..write('cursor: $cursor, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('epoch: $epoch, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ExtJournalCursor extends Table
    with TableInfo<ExtJournalCursor, ExtJournalCursorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ExtJournalCursor(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> journal = GeneratedColumn<String>(
    'journal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  late final GeneratedColumn<int> merged = GeneratedColumn<int>(
    'merged',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [journal, merged];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ext_journal_cursor';
  @override
  Set<GeneratedColumn> get $primaryKey => {journal};
  @override
  ExtJournalCursorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtJournalCursorData(
      journal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal'],
      )!,
      merged: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}merged'],
      )!,
    );
  }

  @override
  ExtJournalCursor createAlias(String alias) {
    return ExtJournalCursor(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class ExtJournalCursorData extends DataClass
    implements Insertable<ExtJournalCursorData> {
  final String journal;
  final int merged;
  const ExtJournalCursorData({required this.journal, required this.merged});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['journal'] = Variable<String>(journal);
    map['merged'] = Variable<int>(merged);
    return map;
  }

  factory ExtJournalCursorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtJournalCursorData(
      journal: serializer.fromJson<String>(json['journal']),
      merged: serializer.fromJson<int>(json['merged']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'journal': serializer.toJson<String>(journal),
      'merged': serializer.toJson<int>(merged),
    };
  }

  ExtJournalCursorData copyWith({String? journal, int? merged}) =>
      ExtJournalCursorData(
        journal: journal ?? this.journal,
        merged: merged ?? this.merged,
      );
  ExtJournalCursorData copyWithCompanion(ExtJournalCursorCompanion data) {
    return ExtJournalCursorData(
      journal: data.journal.present ? data.journal.value : this.journal,
      merged: data.merged.present ? data.merged.value : this.merged,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtJournalCursorData(')
          ..write('journal: $journal, ')
          ..write('merged: $merged')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(journal, merged);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtJournalCursorData &&
          other.journal == this.journal &&
          other.merged == this.merged);
}

class ExtJournalCursorCompanion extends UpdateCompanion<ExtJournalCursorData> {
  final Value<String> journal;
  final Value<int> merged;
  final Value<int> rowid;
  const ExtJournalCursorCompanion({
    this.journal = const Value.absent(),
    this.merged = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtJournalCursorCompanion.insert({
    required String journal,
    required int merged,
    this.rowid = const Value.absent(),
  }) : journal = Value(journal),
       merged = Value(merged);
  static Insertable<ExtJournalCursorData> custom({
    Expression<String>? journal,
    Expression<int>? merged,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (journal != null) 'journal': journal,
      if (merged != null) 'merged': merged,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtJournalCursorCompanion copyWith({
    Value<String>? journal,
    Value<int>? merged,
    Value<int>? rowid,
  }) {
    return ExtJournalCursorCompanion(
      journal: journal ?? this.journal,
      merged: merged ?? this.merged,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (journal.present) {
      map['journal'] = Variable<String>(journal.value);
    }
    if (merged.present) {
      map['merged'] = Variable<int>(merged.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtJournalCursorCompanion(')
          ..write('journal: $journal, ')
          ..write('merged: $merged, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class LocalMl extends Table with TableInfo<LocalMl, LocalMlData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LocalMl(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<Uint8List> localAssetId =
      GeneratedColumn<Uint8List>(
        'local_asset_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      );
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> mtime = GeneratedColumn<int>(
    'mtime',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<Uint8List> vec = GeneratedColumn<Uint8List>(
    'vec',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> failure = GeneratedColumn<String>(
    'failure',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> rtFlags = GeneratedColumn<String>(
    'rt_flags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> ocrText = GeneratedColumn<String>(
    'ocr_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumn<String> ocrFolded = GeneratedColumn<String>(
    'ocr_folded',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    localAssetId,
    model,
    size,
    mtime,
    vec,
    failure,
    rtFlags,
    ocrText,
    ocrFolded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_ml';
  @override
  Set<GeneratedColumn> get $primaryKey => {localAssetId, model};
  @override
  LocalMlData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMlData(
      localAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}local_asset_id'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mtime'],
      )!,
      vec: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}vec'],
      ),
      failure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure'],
      ),
      rtFlags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rt_flags'],
      )!,
      ocrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_text'],
      ),
      ocrFolded: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_folded'],
      ),
    );
  }

  @override
  LocalMl createAlias(String alias) {
    return LocalMl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(local_asset_id, model)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class LocalMlData extends DataClass implements Insertable<LocalMlData> {
  final Uint8List localAssetId;
  final String model;

  /// id@revision
  final int size;

  /// the file's when it was read
  final int mtime;
  final Uint8List? vec;

  /// the output, half floats (binary16) little-endian; NULL when it failed
  final String? failure;

  /// why there is no output: 'unreadable by <decoder>', read again by another
  final String rtFlags;

  /// the runtime, execution provider and precision that computed it
  /// Schema 28: what OCR read in the picture (ADR-0388), as read and in lower case for the search to match; NULL for
  /// the other models and when it failed.
  final String? ocrText;
  final String? ocrFolded;
  const LocalMlData({
    required this.localAssetId,
    required this.model,
    required this.size,
    required this.mtime,
    this.vec,
    this.failure,
    required this.rtFlags,
    this.ocrText,
    this.ocrFolded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_asset_id'] = Variable<Uint8List>(localAssetId);
    map['model'] = Variable<String>(model);
    map['size'] = Variable<int>(size);
    map['mtime'] = Variable<int>(mtime);
    if (!nullToAbsent || vec != null) {
      map['vec'] = Variable<Uint8List>(vec);
    }
    if (!nullToAbsent || failure != null) {
      map['failure'] = Variable<String>(failure);
    }
    map['rt_flags'] = Variable<String>(rtFlags);
    if (!nullToAbsent || ocrText != null) {
      map['ocr_text'] = Variable<String>(ocrText);
    }
    if (!nullToAbsent || ocrFolded != null) {
      map['ocr_folded'] = Variable<String>(ocrFolded);
    }
    return map;
  }

  factory LocalMlData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMlData(
      localAssetId: serializer.fromJson<Uint8List>(json['local_asset_id']),
      model: serializer.fromJson<String>(json['model']),
      size: serializer.fromJson<int>(json['size']),
      mtime: serializer.fromJson<int>(json['mtime']),
      vec: serializer.fromJson<Uint8List?>(json['vec']),
      failure: serializer.fromJson<String?>(json['failure']),
      rtFlags: serializer.fromJson<String>(json['rt_flags']),
      ocrText: serializer.fromJson<String?>(json['ocr_text']),
      ocrFolded: serializer.fromJson<String?>(json['ocr_folded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'local_asset_id': serializer.toJson<Uint8List>(localAssetId),
      'model': serializer.toJson<String>(model),
      'size': serializer.toJson<int>(size),
      'mtime': serializer.toJson<int>(mtime),
      'vec': serializer.toJson<Uint8List?>(vec),
      'failure': serializer.toJson<String?>(failure),
      'rt_flags': serializer.toJson<String>(rtFlags),
      'ocr_text': serializer.toJson<String?>(ocrText),
      'ocr_folded': serializer.toJson<String?>(ocrFolded),
    };
  }

  LocalMlData copyWith({
    Uint8List? localAssetId,
    String? model,
    int? size,
    int? mtime,
    Value<Uint8List?> vec = const Value.absent(),
    Value<String?> failure = const Value.absent(),
    String? rtFlags,
    Value<String?> ocrText = const Value.absent(),
    Value<String?> ocrFolded = const Value.absent(),
  }) => LocalMlData(
    localAssetId: localAssetId ?? this.localAssetId,
    model: model ?? this.model,
    size: size ?? this.size,
    mtime: mtime ?? this.mtime,
    vec: vec.present ? vec.value : this.vec,
    failure: failure.present ? failure.value : this.failure,
    rtFlags: rtFlags ?? this.rtFlags,
    ocrText: ocrText.present ? ocrText.value : this.ocrText,
    ocrFolded: ocrFolded.present ? ocrFolded.value : this.ocrFolded,
  );
  LocalMlData copyWithCompanion(LocalMlCompanion data) {
    return LocalMlData(
      localAssetId: data.localAssetId.present
          ? data.localAssetId.value
          : this.localAssetId,
      model: data.model.present ? data.model.value : this.model,
      size: data.size.present ? data.size.value : this.size,
      mtime: data.mtime.present ? data.mtime.value : this.mtime,
      vec: data.vec.present ? data.vec.value : this.vec,
      failure: data.failure.present ? data.failure.value : this.failure,
      rtFlags: data.rtFlags.present ? data.rtFlags.value : this.rtFlags,
      ocrText: data.ocrText.present ? data.ocrText.value : this.ocrText,
      ocrFolded: data.ocrFolded.present ? data.ocrFolded.value : this.ocrFolded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMlData(')
          ..write('localAssetId: $localAssetId, ')
          ..write('model: $model, ')
          ..write('size: $size, ')
          ..write('mtime: $mtime, ')
          ..write('vec: $vec, ')
          ..write('failure: $failure, ')
          ..write('rtFlags: $rtFlags, ')
          ..write('ocrText: $ocrText, ')
          ..write('ocrFolded: $ocrFolded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(localAssetId),
    model,
    size,
    mtime,
    $driftBlobEquality.hash(vec),
    failure,
    rtFlags,
    ocrText,
    ocrFolded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMlData &&
          $driftBlobEquality.equals(other.localAssetId, this.localAssetId) &&
          other.model == this.model &&
          other.size == this.size &&
          other.mtime == this.mtime &&
          $driftBlobEquality.equals(other.vec, this.vec) &&
          other.failure == this.failure &&
          other.rtFlags == this.rtFlags &&
          other.ocrText == this.ocrText &&
          other.ocrFolded == this.ocrFolded);
}

class LocalMlCompanion extends UpdateCompanion<LocalMlData> {
  final Value<Uint8List> localAssetId;
  final Value<String> model;
  final Value<int> size;
  final Value<int> mtime;
  final Value<Uint8List?> vec;
  final Value<String?> failure;
  final Value<String> rtFlags;
  final Value<String?> ocrText;
  final Value<String?> ocrFolded;
  final Value<int> rowid;
  const LocalMlCompanion({
    this.localAssetId = const Value.absent(),
    this.model = const Value.absent(),
    this.size = const Value.absent(),
    this.mtime = const Value.absent(),
    this.vec = const Value.absent(),
    this.failure = const Value.absent(),
    this.rtFlags = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.ocrFolded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMlCompanion.insert({
    required Uint8List localAssetId,
    required String model,
    required int size,
    required int mtime,
    this.vec = const Value.absent(),
    this.failure = const Value.absent(),
    required String rtFlags,
    this.ocrText = const Value.absent(),
    this.ocrFolded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localAssetId = Value(localAssetId),
       model = Value(model),
       size = Value(size),
       mtime = Value(mtime),
       rtFlags = Value(rtFlags);
  static Insertable<LocalMlData> custom({
    Expression<Uint8List>? localAssetId,
    Expression<String>? model,
    Expression<int>? size,
    Expression<int>? mtime,
    Expression<Uint8List>? vec,
    Expression<String>? failure,
    Expression<String>? rtFlags,
    Expression<String>? ocrText,
    Expression<String>? ocrFolded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localAssetId != null) 'local_asset_id': localAssetId,
      if (model != null) 'model': model,
      if (size != null) 'size': size,
      if (mtime != null) 'mtime': mtime,
      if (vec != null) 'vec': vec,
      if (failure != null) 'failure': failure,
      if (rtFlags != null) 'rt_flags': rtFlags,
      if (ocrText != null) 'ocr_text': ocrText,
      if (ocrFolded != null) 'ocr_folded': ocrFolded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMlCompanion copyWith({
    Value<Uint8List>? localAssetId,
    Value<String>? model,
    Value<int>? size,
    Value<int>? mtime,
    Value<Uint8List?>? vec,
    Value<String?>? failure,
    Value<String>? rtFlags,
    Value<String?>? ocrText,
    Value<String?>? ocrFolded,
    Value<int>? rowid,
  }) {
    return LocalMlCompanion(
      localAssetId: localAssetId ?? this.localAssetId,
      model: model ?? this.model,
      size: size ?? this.size,
      mtime: mtime ?? this.mtime,
      vec: vec ?? this.vec,
      failure: failure ?? this.failure,
      rtFlags: rtFlags ?? this.rtFlags,
      ocrText: ocrText ?? this.ocrText,
      ocrFolded: ocrFolded ?? this.ocrFolded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localAssetId.present) {
      map['local_asset_id'] = Variable<Uint8List>(localAssetId.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (mtime.present) {
      map['mtime'] = Variable<int>(mtime.value);
    }
    if (vec.present) {
      map['vec'] = Variable<Uint8List>(vec.value);
    }
    if (failure.present) {
      map['failure'] = Variable<String>(failure.value);
    }
    if (rtFlags.present) {
      map['rt_flags'] = Variable<String>(rtFlags.value);
    }
    if (ocrText.present) {
      map['ocr_text'] = Variable<String>(ocrText.value);
    }
    if (ocrFolded.present) {
      map['ocr_folded'] = Variable<String>(ocrFolded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMlCompanion(')
          ..write('localAssetId: $localAssetId, ')
          ..write('model: $model, ')
          ..write('size: $size, ')
          ..write('mtime: $mtime, ')
          ..write('vec: $vec, ')
          ..write('failure: $failure, ')
          ..write('rtFlags: $rtFlags, ')
          ..write('ocrText: $ocrText, ')
          ..write('ocrFolded: $ocrFolded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MlPhotoData extends DataClass {
  final Uint8List id;
  final int folder;
  final int size;
  final int mtime;
  final int tile;
  const MlPhotoData({
    required this.id,
    required this.folder,
    required this.size,
    required this.mtime,
    required this.tile,
  });
  factory MlPhotoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MlPhotoData(
      id: serializer.fromJson<Uint8List>(json['id']),
      folder: serializer.fromJson<int>(json['folder']),
      size: serializer.fromJson<int>(json['size']),
      mtime: serializer.fromJson<int>(json['mtime']),
      tile: serializer.fromJson<int>(json['tile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'folder': serializer.toJson<int>(folder),
      'size': serializer.toJson<int>(size),
      'mtime': serializer.toJson<int>(mtime),
      'tile': serializer.toJson<int>(tile),
    };
  }

  MlPhotoData copyWith({
    Uint8List? id,
    int? folder,
    int? size,
    int? mtime,
    int? tile,
  }) => MlPhotoData(
    id: id ?? this.id,
    folder: folder ?? this.folder,
    size: size ?? this.size,
    mtime: mtime ?? this.mtime,
    tile: tile ?? this.tile,
  );
  @override
  String toString() {
    return (StringBuffer('MlPhotoData(')
          ..write('id: $id, ')
          ..write('folder: $folder, ')
          ..write('size: $size, ')
          ..write('mtime: $mtime, ')
          ..write('tile: $tile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash($driftBlobEquality.hash(id), folder, size, mtime, tile);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MlPhotoData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          other.folder == this.folder &&
          other.size == this.size &&
          other.mtime == this.mtime &&
          other.tile == this.tile);
}

class MlPhoto extends ViewInfo<MlPhoto, MlPhotoData> implements HasResultSet {
  final String? _alias;
  @override
  final _$Replica attachedDatabase;
  MlPhoto(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [id, folder, size, mtime, tile];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'ml_photo';
  @override
  Map<SqlDialect, String> get createViewStatements => {
    SqlDialect.sqlite:
        'CREATE VIEW ml_photo AS SELECT id, folder, size, mtime, tile FROM local_asset WHERE state = \'present\' AND trashed = 0 AND NOT(IFNULL(mime, \'\') LIKE \'video/%\' OR IFNULL(mime, \'\') = \'\' AND path IS NOT NULL AND(path LIKE \'%.mp4\' OR path LIKE \'%.mov\' OR path LIKE \'%.m4v\' OR path LIKE \'%.avi\' OR path LIKE \'%.mkv\' OR path LIKE \'%.webm\' OR path LIKE \'%.3gp\' OR path LIKE \'%.mts\' OR path LIKE \'%.m2ts\'))',
  };
  @override
  MlPhoto get asDslTable => this;
  @override
  MlPhotoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MlPhotoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mtime'],
      )!,
      tile: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tile'],
      )!,
    );
  }

  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> mtime = GeneratedColumn<int>(
    'mtime',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<int> tile = GeneratedColumn<int>(
    'tile',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  @override
  MlPhoto createAlias(String alias) {
    return MlPhoto(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {'local_asset'};
}

class MlCountedData extends DataClass {
  final Uint8List id;
  final int folder;
  final String model;
  final int failed;
  const MlCountedData({
    required this.id,
    required this.folder,
    required this.model,
    required this.failed,
  });
  factory MlCountedData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MlCountedData(
      id: serializer.fromJson<Uint8List>(json['id']),
      folder: serializer.fromJson<int>(json['folder']),
      model: serializer.fromJson<String>(json['model']),
      failed: serializer.fromJson<int>(json['failed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<Uint8List>(id),
      'folder': serializer.toJson<int>(folder),
      'model': serializer.toJson<String>(model),
      'failed': serializer.toJson<int>(failed),
    };
  }

  MlCountedData copyWith({
    Uint8List? id,
    int? folder,
    String? model,
    int? failed,
  }) => MlCountedData(
    id: id ?? this.id,
    folder: folder ?? this.folder,
    model: model ?? this.model,
    failed: failed ?? this.failed,
  );
  @override
  String toString() {
    return (StringBuffer('MlCountedData(')
          ..write('id: $id, ')
          ..write('folder: $folder, ')
          ..write('model: $model, ')
          ..write('failed: $failed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash($driftBlobEquality.hash(id), folder, model, failed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MlCountedData &&
          $driftBlobEquality.equals(other.id, this.id) &&
          other.folder == this.folder &&
          other.model == this.model &&
          other.failed == this.failed);
}

class MlCounted extends ViewInfo<MlCounted, MlCountedData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Replica attachedDatabase;
  MlCounted(this.attachedDatabase, [this._alias]);
  @override
  List<GeneratedColumn> get $columns => [id, folder, model, failed];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'ml_counted';
  @override
  Map<SqlDialect, String> get createViewStatements => {
    SqlDialect.sqlite:
        'CREATE VIEW ml_counted AS SELECT id, folder, \'\' AS model, 0 AS failed FROM ml_photo UNION ALL SELECT p.id, p.folder, m.model, m.failure IS NOT NULL FROM ml_photo AS p INNER JOIN local_ml AS m ON m.local_asset_id = p.id AND m.size = p.size AND m.mtime = p.mtime',
  };
  @override
  MlCounted get asDslTable => this;
  @override
  MlCountedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MlCountedData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}id'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      failed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed'],
      )!,
    );
  }

  late final GeneratedColumn<Uint8List> id = GeneratedColumn<Uint8List>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
  );
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );
  late final GeneratedColumn<int> failed = GeneratedColumn<int>(
    'failed',
    aliasedName,
    false,
    type: DriftSqlType.int,
  );
  @override
  MlCounted createAlias(String alias) {
    return MlCounted(attachedDatabase, alias);
  }

  @override
  Query? get query => null;
  @override
  Set<String> get readTables => const {'local_ml', 'local_asset'};
}

class MlCount extends Table with TableInfo<MlCount, MlCountData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MlCount(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> folder = GeneratedColumn<int>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> done = GeneratedColumn<int>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> failed = GeneratedColumn<int>(
    'failed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [folder, model, done, failed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ml_count';
  @override
  Set<GeneratedColumn> get $primaryKey => {folder, model};
  @override
  MlCountData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MlCountData(
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done'],
      )!,
      failed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed'],
      )!,
    );
  }

  @override
  MlCount createAlias(String alias) {
    return MlCount(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  bool get isStrict => true;
  @override
  List<String> get customConstraints => const ['PRIMARY KEY(folder, model)'];
  @override
  bool get dontWriteConstraints => true;
}

class MlCountData extends DataClass implements Insertable<MlCountData> {
  final int folder;
  final String model;
  final int done;
  final int failed;
  const MlCountData({
    required this.folder,
    required this.model,
    required this.done,
    required this.failed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['folder'] = Variable<int>(folder);
    map['model'] = Variable<String>(model);
    map['done'] = Variable<int>(done);
    map['failed'] = Variable<int>(failed);
    return map;
  }

  factory MlCountData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MlCountData(
      folder: serializer.fromJson<int>(json['folder']),
      model: serializer.fromJson<String>(json['model']),
      done: serializer.fromJson<int>(json['done']),
      failed: serializer.fromJson<int>(json['failed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'folder': serializer.toJson<int>(folder),
      'model': serializer.toJson<String>(model),
      'done': serializer.toJson<int>(done),
      'failed': serializer.toJson<int>(failed),
    };
  }

  MlCountData copyWith({int? folder, String? model, int? done, int? failed}) =>
      MlCountData(
        folder: folder ?? this.folder,
        model: model ?? this.model,
        done: done ?? this.done,
        failed: failed ?? this.failed,
      );
  MlCountData copyWithCompanion(MlCountCompanion data) {
    return MlCountData(
      folder: data.folder.present ? data.folder.value : this.folder,
      model: data.model.present ? data.model.value : this.model,
      done: data.done.present ? data.done.value : this.done,
      failed: data.failed.present ? data.failed.value : this.failed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MlCountData(')
          ..write('folder: $folder, ')
          ..write('model: $model, ')
          ..write('done: $done, ')
          ..write('failed: $failed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(folder, model, done, failed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MlCountData &&
          other.folder == this.folder &&
          other.model == this.model &&
          other.done == this.done &&
          other.failed == this.failed);
}

class MlCountCompanion extends UpdateCompanion<MlCountData> {
  final Value<int> folder;
  final Value<String> model;
  final Value<int> done;
  final Value<int> failed;
  const MlCountCompanion({
    this.folder = const Value.absent(),
    this.model = const Value.absent(),
    this.done = const Value.absent(),
    this.failed = const Value.absent(),
  });
  MlCountCompanion.insert({
    required int folder,
    required String model,
    required int done,
    required int failed,
  }) : folder = Value(folder),
       model = Value(model),
       done = Value(done),
       failed = Value(failed);
  static Insertable<MlCountData> custom({
    Expression<int>? folder,
    Expression<String>? model,
    Expression<int>? done,
    Expression<int>? failed,
  }) {
    return RawValuesInsertable({
      if (folder != null) 'folder': folder,
      if (model != null) 'model': model,
      if (done != null) 'done': done,
      if (failed != null) 'failed': failed,
    });
  }

  MlCountCompanion copyWith({
    Value<int>? folder,
    Value<String>? model,
    Value<int>? done,
    Value<int>? failed,
  }) {
    return MlCountCompanion(
      folder: folder ?? this.folder,
      model: model ?? this.model,
      done: done ?? this.done,
      failed: failed ?? this.failed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (folder.present) {
      map['folder'] = Variable<int>(folder.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (done.present) {
      map['done'] = Variable<int>(done.value);
    }
    if (failed.present) {
      map['failed'] = Variable<int>(failed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MlCountCompanion(')
          ..write('folder: $folder, ')
          ..write('model: $model, ')
          ..write('done: $done, ')
          ..write('failed: $failed')
          ..write(')'))
        .toString();
  }
}

abstract class _$Replica extends GeneratedDatabase {
  _$Replica(QueryExecutor e) : super(e);
  late final Library library = Library(this);
  late final Asset asset = Asset(this);
  late final Index assetTaken = Index(
    'asset_taken',
    'CREATE INDEX asset_taken ON asset (taken_utc DESC, id)',
  );
  late final Index assetLibrary = Index(
    'asset_library',
    'CREATE INDEX asset_library ON asset (library_id)',
  );
  late final AssetUserState assetUserState = AssetUserState(this);
  late final AlbumUserState albumUserState = AlbumUserState(this);
  late final LibraryUserState libraryUserState = LibraryUserState(this);
  late final AssetFile assetFile = AssetFile(this);
  late final Index assetFileAsset = Index(
    'asset_file_asset',
    'CREATE INDEX asset_file_asset ON asset_file (asset_id)',
  );
  late final AssetVersion assetVersion = AssetVersion(this);
  late final Index assetVersionAsset = Index(
    'asset_version_asset',
    'CREATE INDEX asset_version_asset ON asset_version (asset_id)',
  );
  late final Stack stack = Stack(this);
  late final AlbumFolder albumFolder = AlbumFolder(this);
  late final Album album = Album(this);
  late final AlbumItem albumItem = AlbumItem(this);
  late final Index albumItemOrder = Index(
    'album_item_order',
    'CREATE INDEX album_item_order ON album_item (album_id, sort_key)',
  );
  late final AlbumMember albumMember = AlbumMember(this);
  late final Tag tag = Tag(this);
  late final AssetTag assetTag = AssetTag(this);
  late final Index assetTagTag = Index(
    'asset_tag_tag',
    'CREATE INDEX asset_tag_tag ON asset_tag (tag_id)',
  );
  late final Person person = Person(this);
  late final Face face = Face(this);
  late final Index facePerson = Index(
    'face_person',
    'CREATE INDEX face_person ON face (person_id)',
  );
  late final Index faceAsset = Index(
    'face_asset',
    'CREATE INDEX face_asset ON face (asset_id)',
  );
  late final LocalAsset localAsset = LocalAsset(this);
  late final LinkedTile linkedTile = LinkedTile(this);
  late final Trigger assetDeleted = Trigger(
    'CREATE TRIGGER asset_deleted AFTER DELETE ON asset BEGIN DELETE FROM asset_file WHERE asset_id = old.id;DELETE FROM asset_version WHERE asset_id = old.id;DELETE FROM face WHERE asset_id = old.id;UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id = old.id;END',
    'asset_deleted',
  );
  late final PartnerShare partnerShare = PartnerShare(this);
  late final PartnerLibrary partnerLibrary = PartnerLibrary(this);
  late final Index localAssetPath = Index(
    'local_asset_path',
    'CREATE INDEX local_asset_path ON local_asset (volume, path)',
  );
  late final Index localAssetHash = Index(
    'local_asset_hash',
    'CREATE INDEX local_asset_hash ON local_asset (content_hash) WHERE content_hash IS NOT NULL',
  );
  late final Index localAssetFile = Index(
    'local_asset_file',
    'CREATE INDEX local_asset_file ON local_asset (volume, file_id)',
  );
  late final Index localAssetPending = Index(
    'local_asset_pending',
    'CREATE INDEX local_asset_pending ON local_asset (COALESCE(taken, mtime) DESC, id DESC) WHERE extracted IS NULL',
  );
  late final Index localAssetRoot = Index(
    'local_asset_root',
    'CREATE INDEX local_asset_root ON local_asset (volume, state) WHERE source = \'folder\'',
  );
  late final TimelineItem timelineItem = TimelineItem(this);
  late final Index localAssetTimeline = Index(
    'local_asset_timeline',
    'CREATE INDEX local_asset_timeline ON local_asset (CAST(COALESCE(strftime(\'%Y%m%d\', taken_local), strftime(\'%Y%m%d\', COALESCE(taken, mtime) / 1000, \'unixepoch\')) AS INTEGER) DESC, COALESCE(taken_utc, taken, mtime) DESC, id DESC, folder, tile, hidden, archived) WHERE state = \'present\' AND trashed = 0 AND tile < 2',
  );
  late final Index localAssetAdded = Index(
    'local_asset_added',
    'CREATE INDEX local_asset_added ON local_asset (COALESCE(added, 0) DESC, id DESC, folder, tile, hidden, archived) WHERE state = \'present\' AND trashed = 0 AND tile < 2',
  );
  late final DeviceFolder deviceFolder = DeviceFolder(this);
  late final Index deviceFolderOwn = Index(
    'device_folder_own',
    'CREATE INDEX device_folder_own ON device_folder (volume, path) WHERE visibility <> \'inherit\'',
  );
  late final DeviceFolderMode deviceFolderMode = DeviceFolderMode(this);
  late final ExcludedFolder excludedFolder = ExcludedFolder(this);
  late final HiddenFolder hiddenFolder = HiddenFolder(this);
  late final TimelineDay timelineDay = TimelineDay(this);
  late final Trigger timelineDayInsert = Trigger(
    'CREATE TRIGGER timeline_day_insert AFTER INSERT ON local_asset WHEN new.state = \'present\' AND new.trashed = 0 AND new.tile < 2 BEGIN INSERT INTO timeline_day VALUES (CAST(COALESCE(strftime(\'%Y%m%d\', new.taken_local), strftime(\'%Y%m%d\', COALESCE(new.taken, new.mtime) / 1000, \'unixepoch\')) AS INTEGER), new.folder, new.hidden + new.archived > 0, 1) ON CONFLICT DO UPDATE SET count = count + 1;END',
    'timeline_day_insert',
  );
  late final Trigger timelineDayDelete = Trigger(
    'CREATE TRIGGER timeline_day_delete AFTER DELETE ON local_asset WHEN old.state = \'present\' AND old.trashed = 0 AND old.tile < 2 BEGIN INSERT INTO timeline_day VALUES (CAST(COALESCE(strftime(\'%Y%m%d\', old.taken_local), strftime(\'%Y%m%d\', COALESCE(old.taken, old.mtime) / 1000, \'unixepoch\')) AS INTEGER), old.folder, old.hidden + old.archived > 0, -1) ON CONFLICT DO UPDATE SET count = count - 1;END',
    'timeline_day_delete',
  );
  late final Trigger timelineDayUpdate = Trigger(
    'CREATE TRIGGER timeline_day_update AFTER UPDATE OF state, trashed, taken_local, taken, mtime, folder, hidden, archived, tile ON local_asset BEGIN INSERT INTO timeline_day SELECT CAST(COALESCE(strftime(\'%Y%m%d\', old.taken_local), strftime(\'%Y%m%d\', COALESCE(old.taken, old.mtime) / 1000, \'unixepoch\')) AS INTEGER), old.folder, old.hidden + old.archived > 0, -1 WHERE old.state = \'present\' AND old.trashed = 0 AND old.tile < 2 ON CONFLICT DO UPDATE SET count = count - 1;INSERT INTO timeline_day SELECT CAST(COALESCE(strftime(\'%Y%m%d\', new.taken_local), strftime(\'%Y%m%d\', COALESCE(new.taken, new.mtime) / 1000, \'unixepoch\')) AS INTEGER), new.folder, new.hidden + new.archived > 0, 1 WHERE new.state = \'present\' AND new.trashed = 0 AND new.tile < 2 ON CONFLICT DO UPDATE SET count = count + 1;END',
    'timeline_day_update',
  );
  late final Trigger timelineDayEmpty = Trigger(
    'CREATE TRIGGER timeline_day_empty AFTER UPDATE OF count ON timeline_day WHEN new.count = 0 BEGIN DELETE FROM timeline_day WHERE day = new.day AND folder = new.folder AND veiled = new.veiled;END',
    'timeline_day_empty',
  );
  late final TimelineAdded timelineAdded = TimelineAdded(this);
  late final Trigger timelineAddedInsert = Trigger(
    'CREATE TRIGGER timeline_added_insert AFTER INSERT ON local_asset WHEN new.state = \'present\' AND new.trashed = 0 AND new.tile < 2 BEGIN INSERT INTO timeline_added VALUES (COALESCE(new.added, 0) / 900000, new.folder, new.hidden + new.archived > 0, 1) ON CONFLICT DO UPDATE SET count = count + 1;END',
    'timeline_added_insert',
  );
  late final Trigger timelineAddedDelete = Trigger(
    'CREATE TRIGGER timeline_added_delete AFTER DELETE ON local_asset WHEN old.state = \'present\' AND old.trashed = 0 AND old.tile < 2 BEGIN INSERT INTO timeline_added VALUES (COALESCE(old.added, 0) / 900000, old.folder, old.hidden + old.archived > 0, -1) ON CONFLICT DO UPDATE SET count = count - 1;END',
    'timeline_added_delete',
  );
  late final Trigger timelineAddedUpdate = Trigger(
    'CREATE TRIGGER timeline_added_update AFTER UPDATE OF state, trashed, added, folder, hidden, archived, tile ON local_asset BEGIN INSERT INTO timeline_added SELECT COALESCE(old.added, 0) / 900000, old.folder, old.hidden + old.archived > 0, -1 WHERE old.state = \'present\' AND old.trashed = 0 AND old.tile < 2 ON CONFLICT DO UPDATE SET count = count - 1;INSERT INTO timeline_added SELECT COALESCE(new.added, 0) / 900000, new.folder, new.hidden + new.archived > 0, 1 WHERE new.state = \'present\' AND new.trashed = 0 AND new.tile < 2 ON CONFLICT DO UPDATE SET count = count + 1;END',
    'timeline_added_update',
  );
  late final Trigger timelineAddedEmpty = Trigger(
    'CREATE TRIGGER timeline_added_empty AFTER UPDATE OF count ON timeline_added WHEN new.count = 0 BEGIN DELETE FROM timeline_added WHERE slot = new.slot AND folder = new.folder AND veiled = new.veiled;END',
    'timeline_added_empty',
  );
  late final KeptState keptState = KeptState(this);
  late final Trigger localAssetKept = Trigger(
    'CREATE TRIGGER local_asset_kept AFTER UPDATE OF favorite, hidden, archived ON local_asset WHEN new.fingerprint IS NOT NULL AND(old.favorite <> new.favorite OR old.hidden <> new.hidden OR old.archived <> new.archived)BEGIN INSERT INTO kept_state VALUES (new.fingerprint, new.favorite, new.hidden, new.archived) ON CONFLICT (fingerprint) DO UPDATE SET favorite = excluded.favorite, hidden = excluded.hidden, archived = excluded.archived;DELETE FROM kept_state WHERE fingerprint = new.fingerprint AND favorite = 0 AND hidden = 0 AND archived = 0;END',
    'local_asset_kept',
  );
  late final Trigger localAssetFingerprint = Trigger(
    'CREATE TRIGGER local_asset_fingerprint AFTER UPDATE OF fingerprint ON local_asset WHEN new.fingerprint IS NOT NULL BEGIN INSERT INTO kept_state VALUES (new.fingerprint, new.favorite, new.hidden, new.archived) ON CONFLICT (fingerprint) DO UPDATE SET favorite = favorite | excluded.favorite, hidden = hidden | excluded.hidden, archived = archived | excluded.archived;UPDATE local_asset SET favorite = (SELECT favorite FROM kept_state WHERE fingerprint = new.fingerprint), hidden = (SELECT hidden FROM kept_state WHERE fingerprint = new.fingerprint), archived = (SELECT archived FROM kept_state WHERE fingerprint = new.fingerprint) WHERE id = new.id;DELETE FROM kept_state WHERE fingerprint = new.fingerprint AND favorite = 0 AND hidden = 0 AND archived = 0;END',
    'local_asset_fingerprint',
  );
  late final Index localAssetAsset = Index(
    'local_asset_asset',
    'CREATE INDEX local_asset_asset ON local_asset (asset_id) WHERE asset_id IS NOT NULL',
  );
  late final CloudItem cloudItem = CloudItem(this);
  late final Index assetTimeline = Index(
    'asset_timeline',
    'CREATE INDEX asset_timeline ON asset (CAST(COALESCE(strftime(\'%Y%m%d\', taken_local), strftime(\'%Y%m%d\', taken_utc / 1000, \'unixepoch\'), 0) AS INTEGER) DESC, COALESCE(taken_utc, created_at) DESC, id DESC, library_id) WHERE trashed_at IS NULL AND archived = 0 AND locked = 0 AND on_device = 0 AND media_kind IN (\'image\', \'video\')',
  );
  late final Index assetAdded = Index(
    'asset_added',
    'CREATE INDEX asset_added ON asset (created_at DESC, id DESC, library_id) WHERE trashed_at IS NULL AND archived = 0 AND locked = 0 AND on_device = 0 AND media_kind IN (\'image\', \'video\')',
  );
  late final Trigger localAssetLinked = Trigger(
    'CREATE TRIGGER local_asset_linked AFTER INSERT ON local_asset WHEN new.asset_id IS NOT NULL BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id = new.asset_id;UPDATE asset SET on_device = 1 WHERE id = new.asset_id AND new.state = \'present\' AND new.trashed = 0;END',
    'local_asset_linked',
  );
  late final Trigger localAssetRelinked = Trigger(
    'CREATE TRIGGER local_asset_relinked AFTER UPDATE OF asset_id, state, trashed ON local_asset WHEN old.asset_id IS NOT NULL OR new.asset_id IS NOT NULL BEGIN UPDATE local_asset SET tile = 0 WHERE id = new.id AND new.asset_id IS NULL;UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id IN (old.asset_id, new.asset_id);UPDATE asset SET on_device = EXISTS (SELECT 1 FROM local_asset AS l WHERE l.asset_id = asset.id AND l.state = \'present\' AND l.trashed = 0) WHERE id IN (old.asset_id, new.asset_id);END',
    'local_asset_relinked',
  );
  late final Trigger localAssetUnlinked = Trigger(
    'CREATE TRIGGER local_asset_unlinked AFTER DELETE ON local_asset WHEN old.asset_id IS NOT NULL BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id = old.asset_id;UPDATE asset SET on_device = EXISTS (SELECT 1 FROM local_asset AS l WHERE l.asset_id = asset.id AND l.state = \'present\' AND l.trashed = 0) WHERE id = old.asset_id;END',
    'local_asset_unlinked',
  );
  late final Trigger assetStateHiddenInsert = Trigger(
    'CREATE TRIGGER asset_state_hidden_insert AFTER INSERT ON asset_user_state WHEN new.album_hides_timeline <> 0 BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id = new.asset_id;END',
    'asset_state_hidden_insert',
  );
  late final Trigger assetStateHiddenUpdate = Trigger(
    'CREATE TRIGGER asset_state_hidden_update AFTER UPDATE OF album_hides_timeline ON asset_user_state BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id = new.asset_id;END',
    'asset_state_hidden_update',
  );
  late final Trigger libraryStateHiddenInsert = Trigger(
    'CREATE TRIGGER library_state_hidden_insert AFTER INSERT ON library_user_state WHEN new.hide_from_timeline <> 0 BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id IN (SELECT id FROM asset WHERE library_id = new.library_id);END',
    'library_state_hidden_insert',
  );
  late final Trigger libraryStateHiddenUpdate = Trigger(
    'CREATE TRIGGER library_state_hidden_update AFTER UPDATE OF hide_from_timeline ON library_user_state BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id IN (SELECT id FROM asset WHERE library_id = new.library_id);END',
    'library_state_hidden_update',
  );
  late final Trigger libraryStateHiddenDelete = Trigger(
    'CREATE TRIGGER library_state_hidden_delete AFTER DELETE ON library_user_state WHEN old.hide_from_timeline <> 0 BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id IN (SELECT id FROM asset WHERE library_id = old.library_id);END',
    'library_state_hidden_delete',
  );
  late final Trigger assetLinked = Trigger(
    'CREATE TRIGGER asset_linked AFTER INSERT ON asset WHEN EXISTS (SELECT 1 FROM local_asset WHERE asset_id = new.id) BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id = new.id;UPDATE asset SET on_device = EXISTS (SELECT 1 FROM local_asset AS l WHERE l.asset_id = asset.id AND l.state = \'present\' AND l.trashed = 0) WHERE id = new.id;END',
    'asset_linked',
  );
  late final Trigger assetChanged = Trigger(
    'CREATE TRIGGER asset_changed AFTER UPDATE OF trashed_at, archived, locked, library_id ON asset WHEN EXISTS (SELECT 1 FROM local_asset WHERE asset_id = new.id) BEGIN UPDATE local_asset SET tile = t.tile FROM linked_tile AS t WHERE t.id = local_asset.id AND asset_id = new.id;END',
    'asset_changed',
  );
  late final MediaSource mediaSource = MediaSource(this);
  late final VolumeCursor volumeCursor = VolumeCursor(this);
  late final BackupState backupState = BackupState(this);
  late final Index backupStateState = Index(
    'backup_state_state',
    'CREATE INDEX backup_state_state ON backup_state (state)',
  );
  late final BackupRun backupRun = BackupRun(this);
  late final Outbox outbox = Outbox(this);
  late final Index outboxEntity = Index(
    'outbox_entity',
    'CREATE INDEX outbox_entity ON outbox (entity, entity_id)',
  );
  late final Clock clock = Clock(this);
  late final SyncCursor syncCursor = SyncCursor(this);
  late final ExtJournalCursor extJournalCursor = ExtJournalCursor(this);
  late final LocalMl localMl = LocalMl(this);
  late final MlPhoto mlPhoto = MlPhoto(this);
  late final MlCounted mlCounted = MlCounted(this);
  late final MlCount mlCount = MlCount(this);
  late final Trigger mlCountInsert = Trigger(
    'CREATE TRIGGER ml_count_insert AFTER INSERT ON local_asset WHEN new.tile < 2 BEGIN INSERT INTO ml_count SELECT folder, model, 1, failed FROM ml_counted WHERE id = new.id ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_insert',
  );
  late final Trigger mlCountDelete = Trigger(
    'CREATE TRIGGER ml_count_delete BEFORE DELETE ON local_asset WHEN old.tile < 2 BEGIN INSERT INTO ml_count SELECT folder, model, -1, -failed FROM ml_counted WHERE id = old.id ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_delete',
  );
  late final Trigger mlCountUnset = Trigger(
    'CREATE TRIGGER ml_count_unset BEFORE UPDATE OF id, state, trashed, folder, size, mtime, mime, path, tile ON local_asset WHEN (old.id, old.state, old.trashed, old.folder, old.size, old.mtime, old.mime, old.path, old.tile < 2) IS NOT (new.id, new.state, new.trashed, new.folder, new.size, new.mtime, new.mime, new.path, new.tile < 2) BEGIN INSERT INTO ml_count SELECT folder, model, -1, -failed FROM ml_counted WHERE id = old.id AND old.tile < 2 ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_unset',
  );
  late final Trigger mlCountSet = Trigger(
    'CREATE TRIGGER ml_count_set AFTER UPDATE OF id, state, trashed, folder, size, mtime, mime, path, tile ON local_asset WHEN (old.id, old.state, old.trashed, old.folder, old.size, old.mtime, old.mime, old.path, old.tile < 2) IS NOT (new.id, new.state, new.trashed, new.folder, new.size, new.mtime, new.mime, new.path, new.tile < 2) BEGIN INSERT INTO ml_count SELECT folder, model, 1, failed FROM ml_counted WHERE id = new.id AND new.tile < 2 ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_set',
  );
  late final Trigger mlCountMlReplace = Trigger(
    'CREATE TRIGGER ml_count_ml_replace BEFORE INSERT ON local_ml BEGIN INSERT INTO ml_count SELECT p.folder, m.model, -1, -(m.failure IS NOT NULL)FROM ml_photo AS p INNER JOIN local_ml AS m ON m.local_asset_id = p.id AND m.size = p.size AND m.mtime = p.mtime WHERE m.local_asset_id = new.local_asset_id AND m.model = new.model AND p.tile < 2 ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_ml_replace',
  );
  late final Trigger mlCountMlInsert = Trigger(
    'CREATE TRIGGER ml_count_ml_insert AFTER INSERT ON local_ml BEGIN INSERT INTO ml_count SELECT folder, new.model, 1, new.failure IS NOT NULL FROM ml_photo WHERE id = new.local_asset_id AND size = new.size AND mtime = new.mtime AND tile < 2 ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_ml_insert',
  );
  late final Trigger mlCountMlDelete = Trigger(
    'CREATE TRIGGER ml_count_ml_delete AFTER DELETE ON local_ml BEGIN INSERT INTO ml_count SELECT folder, old.model, -1, -(old.failure IS NOT NULL)FROM ml_photo WHERE id = old.local_asset_id AND size = old.size AND mtime = old.mtime AND tile < 2 ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_ml_delete',
  );
  late final Trigger mlCountMlUpdate = Trigger(
    'CREATE TRIGGER ml_count_ml_update AFTER UPDATE ON local_ml BEGIN INSERT INTO ml_count SELECT folder, old.model, -1, -(old.failure IS NOT NULL)FROM ml_photo WHERE id = old.local_asset_id AND size = old.size AND mtime = old.mtime AND tile < 2 ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;INSERT INTO ml_count SELECT folder, new.model, 1, new.failure IS NOT NULL FROM ml_photo WHERE id = new.local_asset_id AND size = new.size AND mtime = new.mtime AND tile < 2 ON CONFLICT DO UPDATE SET done = done + excluded.done, failed = failed + excluded.failed;END',
    'ml_count_ml_update',
  );
  Selectable<BackupSummaryResult> backupSummary() {
    return customSelect(
      'SELECT state, COUNT(*) AS count FROM backup_state GROUP BY state ORDER BY state',
      variables: [],
      readsFrom: {this.backupState},
    ).map(
      (QueryRow row) => BackupSummaryResult(
        state: row.read<String>('state'),
        count: row.read<int>('count'),
      ),
    );
  }

  Selectable<BackupReasonsResult> backupReasons() {
    return customSelect(
      'SELECT b.state, b.reason, COUNT(*) AS count, MIN(b.retry_at) AS retry_at FROM backup_state AS b INNER JOIN local_asset AS a ON a.id = b.local_asset_id WHERE a.state = \'present\' AND a.trashed = 0 AND b.state NOT IN (\'backed_up\', \'linked\') GROUP BY b.state, b.reason ORDER BY b.state, b.reason',
      variables: [],
      readsFrom: {this.backupState, this.localAsset},
    ).map(
      (QueryRow row) => BackupReasonsResult(
        state: row.read<String>('state'),
        reason: row.readNullable<String>('reason'),
        count: row.read<int>('count'),
        retryAt: row.readNullable<int>('retry_at'),
      ),
    );
  }

  Selectable<BackupItemsResult> backupItems(
    String state,
    String? reason,
    int limit,
  ) {
    return customSelect(
      'SELECT a.name, a.path, a.source_id FROM backup_state AS b INNER JOIN local_asset AS a ON a.id = b.local_asset_id WHERE a.state = \'present\' AND a.trashed = 0 AND b.state = ?1 AND b.reason IS ?2 ORDER BY b.local_asset_id DESC LIMIT ?3',
      variables: [
        Variable<String>(state),
        Variable<String>(reason),
        Variable<int>(limit),
      ],
      readsFrom: {this.localAsset, this.backupState},
    ).map(
      (QueryRow row) => BackupItemsResult(
        name: row.readNullable<String>('name'),
        path: row.readNullable<String>('path'),
        sourceId: row.read<String>('source_id'),
      ),
    );
  }

  Selectable<FolderSummaryResult> folderSummary() {
    return customSelect(
      'SELECT root, state, (SELECT COUNT(*) FROM local_asset AS a WHERE a.source = \'folder\' AND a.volume = s.root AND a.state <> \'missing\') AS items FROM media_source AS s ORDER BY root',
      variables: [],
      readsFrom: {this.mediaSource, this.localAsset},
    ).map(
      (QueryRow row) => FolderSummaryResult(
        root: row.read<String>('root'),
        state: row.read<String>('state'),
        items: row.read<int>('items'),
      ),
    );
  }

  Selectable<DeviceBucketsResult> deviceBuckets() {
    return customSelect(
      'SELECT bucket_id, bucket_name, COUNT(*) AS items FROM local_asset WHERE state = \'present\' AND trashed = 0 AND hidden = 0 AND folder NOT IN (SELECT id FROM hidden_folder) GROUP BY source, bucket_id ORDER BY MAX(COALESCE(taken, mtime)) DESC',
      variables: [],
      readsFrom: {this.localAsset, this.deviceFolderMode, this.deviceFolder},
    ).map(
      (QueryRow row) => DeviceBucketsResult(
        bucketId: row.readNullable<String>('bucket_id'),
        bucketName: row.readNullable<String>('bucket_name'),
        items: row.read<int>('items'),
      ),
    );
  }

  Selectable<LocalSearchResult> localSearch(
    int limit,
    int offset, {
    LocalSearch$filters? filters,
  }) {
    var $arrayStartIndex = 3;
    final generatedfilters = $write(
      filters?.call(alias(this.localAsset, 'a')) ??
          const CustomExpression('(TRUE)'),
      startIndex: $arrayStartIndex,
    );
    $arrayStartIndex += generatedfilters.amountOfVariables;
    return customSelect(
      'WITH hit AS MATERIALIZED (SELECT id, COALESCE(taken_utc, taken, mtime) AS k FROM local_asset AS a WHERE a.state <> \'missing\' AND a.trashed = 0 AND a.folder NOT IN (SELECT id FROM hidden_folder) AND ${generatedfilters.sql}) SELECT"r"."id" AS "nested_0.id", "r"."source" AS "nested_0.source", "r"."volume" AS "nested_0.volume", "r"."source_id" AS "nested_0.source_id", "r"."generation" AS "nested_0.generation", "r"."size" AS "nested_0.size", "r"."mtime" AS "nested_0.mtime", "r"."content_hash" AS "nested_0.content_hash", "r"."asset_id" AS "nested_0.asset_id", "r"."path" AS "nested_0.path", "r"."file_id" AS "nested_0.file_id", "r"."state" AS "nested_0.state", "r"."name" AS "nested_0.name", "r"."bucket_id" AS "nested_0.bucket_id", "r"."bucket_name" AS "nested_0.bucket_name", "r"."mime" AS "nested_0.mime", "r"."taken" AS "nested_0.taken", "r"."width" AS "nested_0.width", "r"."height" AS "nested_0.height", "r"."orientation" AS "nested_0.orientation", "r"."duration_ms" AS "nested_0.duration_ms", "r"."favorite" AS "nested_0.favorite", "r"."trashed" AS "nested_0.trashed", "r"."expires" AS "nested_0.expires", "r"."extracted" AS "nested_0.extracted", "r"."taken_local" AS "nested_0.taken_local", "r"."tz_offset_min" AS "nested_0.tz_offset_min", "r"."taken_utc" AS "nested_0.taken_utc", "r"."time_source" AS "nested_0.time_source", "r"."time_confidence" AS "nested_0.time_confidence", "r"."time_precision" AS "nested_0.time_precision", "r"."lat" AS "nested_0.lat", "r"."lon" AS "nested_0.lon", "r"."make" AS "nested_0.make", "r"."model" AS "nested_0.model", "r"."facets" AS "nested_0.facets", "r"."cloud_id" AS "nested_0.cloud_id", "r"."burst_id" AS "nested_0.burst_id", "r"."edited" AS "nested_0.edited", "r"."added" AS "nested_0.added", "r"."thumbhash" AS "nested_0.thumbhash", "r"."motion_offset" AS "nested_0.motion_offset", "r"."motion_length" AS "nested_0.motion_length", "r"."frame_rate" AS "nested_0.frame_rate", "r"."projection" AS "nested_0.projection", "r"."crop" AS "nested_0.crop", "r"."stereo" AS "nested_0.stereo", "r"."folder" AS "nested_0.folder", "r"."heading" AS "nested_0.heading", "r"."hidden" AS "nested_0.hidden", "r"."archived" AS "nested_0.archived", "r"."bin" AS "nested_0.bin", "r"."fingerprint" AS "nested_0.fingerprint", "r"."tile" AS "nested_0.tile", (SELECT COUNT(*) FROM hit) AS total FROM (SELECT id, k FROM hit ORDER BY k DESC, id DESC LIMIT ?1 OFFSET ?2) AS h INNER JOIN local_asset AS r ON r.id = h.id ORDER BY h.k DESC, h.id DESC',
      variables: [
        Variable<int>(limit),
        Variable<int>(offset),
        ...generatedfilters.introducedVariables,
      ],
      readsFrom: {
        this.localAsset,
        this.deviceFolderMode,
        this.deviceFolder,
        ...generatedfilters.watchedTables,
      },
    ).asyncMap(
      (QueryRow row) async => LocalSearchResult(
        r: await this.localAsset.mapFromRow(row, tablePrefix: 'nested_0'),
        total: row.read<int>('total'),
      ),
    );
  }

  Selectable<LocalFoldersResult> localFolders() {
    return customSelect(
      'SELECT source, volume, CASE source WHEN \'folder\' THEN rtrim(path, "replace"(path, \'/\', \'\')) ELSE path END AS dir, COUNT(*) AS items FROM local_asset WHERE state <> \'missing\' AND trashed = 0 AND folder NOT IN (SELECT id FROM hidden_folder) GROUP BY 1, 2, 3 ORDER BY 1, 2, 3',
      variables: [],
      readsFrom: {this.localAsset, this.deviceFolderMode, this.deviceFolder},
    ).map(
      (QueryRow row) => LocalFoldersResult(
        source: row.read<String>('source'),
        volume: row.read<String>('volume'),
        dir: row.readNullable<String>('dir'),
        items: row.read<int>('items'),
      ),
    );
  }

  Selectable<LocalCamerasResult> localCameras() {
    return customSelect(
      'SELECT make, model, COUNT(*) AS items FROM local_asset WHERE state <> \'missing\' AND trashed = 0 AND hidden = 0 AND(make IS NOT NULL OR model IS NOT NULL)AND folder NOT IN (SELECT id FROM hidden_folder) GROUP BY make, model ORDER BY items DESC, make, model',
      variables: [],
      readsFrom: {this.localAsset, this.deviceFolderMode, this.deviceFolder},
    ).map(
      (QueryRow row) => LocalCamerasResult(
        make: row.readNullable<String>('make'),
        model: row.readNullable<String>('model'),
        items: row.read<int>('items'),
      ),
    );
  }

  Selectable<OtherFilesResult> otherFiles() {
    return customSelect(
      'SELECT a.id, a.original_filename AS name, a.created_at, f.size, f.mime FROM asset AS a LEFT JOIN asset_file AS f ON f.asset_id = a.id AND f.role = \'original\' WHERE a.media_kind = \'\' AND a.trashed_at IS NULL ORDER BY a.created_at DESC, a.id DESC',
      variables: [],
      readsFrom: {this.asset, this.assetFile},
    ).map(
      (QueryRow row) => OtherFilesResult(
        id: row.read<Uint8List>('id'),
        name: row.read<String>('name'),
        createdAt: row.read<int>('created_at'),
        size: row.readNullable<int>('size'),
        mime: row.readNullable<String>('mime'),
      ),
    );
  }

  Selectable<OutboxData> pendingOutbox(int? now, int limit) {
    return customSelect(
      'SELECT * FROM outbox WHERE error IS NULL AND(retry_at IS NULL OR retry_at <= ?1)ORDER BY seq LIMIT ?2',
      variables: [Variable<int>(now), Variable<int>(limit)],
      readsFrom: {this.outbox},
    ).asyncMap(this.outbox.mapFromRow);
  }

  Selectable<ExtractionQueueResult> extractionQueue(
    int key,
    Uint8List id,
    int limit,
  ) {
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."source" AS "nested_0.source", "a"."volume" AS "nested_0.volume", "a"."source_id" AS "nested_0.source_id", "a"."generation" AS "nested_0.generation", "a"."size" AS "nested_0.size", "a"."mtime" AS "nested_0.mtime", "a"."content_hash" AS "nested_0.content_hash", "a"."asset_id" AS "nested_0.asset_id", "a"."path" AS "nested_0.path", "a"."file_id" AS "nested_0.file_id", "a"."state" AS "nested_0.state", "a"."name" AS "nested_0.name", "a"."bucket_id" AS "nested_0.bucket_id", "a"."bucket_name" AS "nested_0.bucket_name", "a"."mime" AS "nested_0.mime", "a"."taken" AS "nested_0.taken", "a"."width" AS "nested_0.width", "a"."height" AS "nested_0.height", "a"."orientation" AS "nested_0.orientation", "a"."duration_ms" AS "nested_0.duration_ms", "a"."favorite" AS "nested_0.favorite", "a"."trashed" AS "nested_0.trashed", "a"."expires" AS "nested_0.expires", "a"."extracted" AS "nested_0.extracted", "a"."taken_local" AS "nested_0.taken_local", "a"."tz_offset_min" AS "nested_0.tz_offset_min", "a"."taken_utc" AS "nested_0.taken_utc", "a"."time_source" AS "nested_0.time_source", "a"."time_confidence" AS "nested_0.time_confidence", "a"."time_precision" AS "nested_0.time_precision", "a"."lat" AS "nested_0.lat", "a"."lon" AS "nested_0.lon", "a"."make" AS "nested_0.make", "a"."model" AS "nested_0.model", "a"."facets" AS "nested_0.facets", "a"."cloud_id" AS "nested_0.cloud_id", "a"."burst_id" AS "nested_0.burst_id", "a"."edited" AS "nested_0.edited", "a"."added" AS "nested_0.added", "a"."thumbhash" AS "nested_0.thumbhash", "a"."motion_offset" AS "nested_0.motion_offset", "a"."motion_length" AS "nested_0.motion_length", "a"."frame_rate" AS "nested_0.frame_rate", "a"."projection" AS "nested_0.projection", "a"."crop" AS "nested_0.crop", "a"."stereo" AS "nested_0.stereo", "a"."folder" AS "nested_0.folder", "a"."heading" AS "nested_0.heading", "a"."hidden" AS "nested_0.hidden", "a"."archived" AS "nested_0.archived", "a"."bin" AS "nested_0.bin", "a"."fingerprint" AS "nested_0.fingerprint", "a"."tile" AS "nested_0.tile", CASE a.source WHEN \'folder\' THEN a.volume ELSE c.root END AS root FROM local_asset AS a LEFT JOIN volume_cursor AS c ON c.source = a.source AND c.volume = a.volume WHERE a.extracted IS NULL AND a.state = \'present\' AND(a.source = \'folder\' OR c.root IS NOT NULL)AND (COALESCE(a.taken, a.mtime), a.id) < (?1, ?2) ORDER BY COALESCE(a.taken, a.mtime) DESC, a.id DESC LIMIT ?3',
      variables: [
        Variable<int>(key),
        Variable<Uint8List>(id),
        Variable<int>(limit),
      ],
      readsFrom: {this.localAsset, this.volumeCursor},
    ).asyncMap(
      (QueryRow row) async => ExtractionQueueResult(
        a: await this.localAsset.mapFromRow(row, tablePrefix: 'nested_0'),
        root: row.readNullable<String>('root'),
      ),
    );
  }

  Selectable<ExtractionQueueOfResult> extractionQueueOf(List<Uint8List> ids) {
    var $arrayStartIndex = 1;
    final expandedids = $expandVar($arrayStartIndex, ids.length);
    $arrayStartIndex += ids.length;
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."source" AS "nested_0.source", "a"."volume" AS "nested_0.volume", "a"."source_id" AS "nested_0.source_id", "a"."generation" AS "nested_0.generation", "a"."size" AS "nested_0.size", "a"."mtime" AS "nested_0.mtime", "a"."content_hash" AS "nested_0.content_hash", "a"."asset_id" AS "nested_0.asset_id", "a"."path" AS "nested_0.path", "a"."file_id" AS "nested_0.file_id", "a"."state" AS "nested_0.state", "a"."name" AS "nested_0.name", "a"."bucket_id" AS "nested_0.bucket_id", "a"."bucket_name" AS "nested_0.bucket_name", "a"."mime" AS "nested_0.mime", "a"."taken" AS "nested_0.taken", "a"."width" AS "nested_0.width", "a"."height" AS "nested_0.height", "a"."orientation" AS "nested_0.orientation", "a"."duration_ms" AS "nested_0.duration_ms", "a"."favorite" AS "nested_0.favorite", "a"."trashed" AS "nested_0.trashed", "a"."expires" AS "nested_0.expires", "a"."extracted" AS "nested_0.extracted", "a"."taken_local" AS "nested_0.taken_local", "a"."tz_offset_min" AS "nested_0.tz_offset_min", "a"."taken_utc" AS "nested_0.taken_utc", "a"."time_source" AS "nested_0.time_source", "a"."time_confidence" AS "nested_0.time_confidence", "a"."time_precision" AS "nested_0.time_precision", "a"."lat" AS "nested_0.lat", "a"."lon" AS "nested_0.lon", "a"."make" AS "nested_0.make", "a"."model" AS "nested_0.model", "a"."facets" AS "nested_0.facets", "a"."cloud_id" AS "nested_0.cloud_id", "a"."burst_id" AS "nested_0.burst_id", "a"."edited" AS "nested_0.edited", "a"."added" AS "nested_0.added", "a"."thumbhash" AS "nested_0.thumbhash", "a"."motion_offset" AS "nested_0.motion_offset", "a"."motion_length" AS "nested_0.motion_length", "a"."frame_rate" AS "nested_0.frame_rate", "a"."projection" AS "nested_0.projection", "a"."crop" AS "nested_0.crop", "a"."stereo" AS "nested_0.stereo", "a"."folder" AS "nested_0.folder", "a"."heading" AS "nested_0.heading", "a"."hidden" AS "nested_0.hidden", "a"."archived" AS "nested_0.archived", "a"."bin" AS "nested_0.bin", "a"."fingerprint" AS "nested_0.fingerprint", "a"."tile" AS "nested_0.tile", CASE a.source WHEN \'folder\' THEN a.volume ELSE c.root END AS root FROM local_asset AS a LEFT JOIN volume_cursor AS c ON c.source = a.source AND c.volume = a.volume WHERE a.extracted IS NULL AND a.state = \'present\' AND(a.source = \'folder\' OR c.root IS NOT NULL)AND a.id IN ($expandedids)',
      variables: [for (var $ in ids) Variable<Uint8List>($)],
      readsFrom: {this.localAsset, this.volumeCursor},
    ).asyncMap(
      (QueryRow row) async => ExtractionQueueOfResult(
        a: await this.localAsset.mapFromRow(row, tablePrefix: 'nested_0'),
        root: row.readNullable<String>('root'),
      ),
    );
  }

  Selectable<MlQueueResult> mlQueue(
    int tier,
    int since,
    int year,
    int day,
    int key,
    Uint8List id,
    String model,
    String failure,
    int limit, {
    MlQueue$photo? photo,
  }) {
    var $arrayStartIndex = 10;
    final generatedphoto = $write(
      photo?.call(alias(this.timelineItem, 't'), alias(this.localAsset, 'a')) ??
          const CustomExpression('(TRUE)'),
      hasMultipleTables: true,
      startIndex: $arrayStartIndex,
    );
    $arrayStartIndex += generatedphoto.amountOfVariables;
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."source" AS "nested_0.source", "a"."volume" AS "nested_0.volume", "a"."source_id" AS "nested_0.source_id", "a"."generation" AS "nested_0.generation", "a"."size" AS "nested_0.size", "a"."mtime" AS "nested_0.mtime", "a"."content_hash" AS "nested_0.content_hash", "a"."asset_id" AS "nested_0.asset_id", "a"."path" AS "nested_0.path", "a"."file_id" AS "nested_0.file_id", "a"."state" AS "nested_0.state", "a"."name" AS "nested_0.name", "a"."bucket_id" AS "nested_0.bucket_id", "a"."bucket_name" AS "nested_0.bucket_name", "a"."mime" AS "nested_0.mime", "a"."taken" AS "nested_0.taken", "a"."width" AS "nested_0.width", "a"."height" AS "nested_0.height", "a"."orientation" AS "nested_0.orientation", "a"."duration_ms" AS "nested_0.duration_ms", "a"."favorite" AS "nested_0.favorite", "a"."trashed" AS "nested_0.trashed", "a"."expires" AS "nested_0.expires", "a"."extracted" AS "nested_0.extracted", "a"."taken_local" AS "nested_0.taken_local", "a"."tz_offset_min" AS "nested_0.tz_offset_min", "a"."taken_utc" AS "nested_0.taken_utc", "a"."time_source" AS "nested_0.time_source", "a"."time_confidence" AS "nested_0.time_confidence", "a"."time_precision" AS "nested_0.time_precision", "a"."lat" AS "nested_0.lat", "a"."lon" AS "nested_0.lon", "a"."make" AS "nested_0.make", "a"."model" AS "nested_0.model", "a"."facets" AS "nested_0.facets", "a"."cloud_id" AS "nested_0.cloud_id", "a"."burst_id" AS "nested_0.burst_id", "a"."edited" AS "nested_0.edited", "a"."added" AS "nested_0.added", "a"."thumbhash" AS "nested_0.thumbhash", "a"."motion_offset" AS "nested_0.motion_offset", "a"."motion_length" AS "nested_0.motion_length", "a"."frame_rate" AS "nested_0.frame_rate", "a"."projection" AS "nested_0.projection", "a"."crop" AS "nested_0.crop", "a"."stereo" AS "nested_0.stereo", "a"."folder" AS "nested_0.folder", "a"."heading" AS "nested_0.heading", "a"."hidden" AS "nested_0.hidden", "a"."archived" AS "nested_0.archived", "a"."bin" AS "nested_0.bin", "a"."fingerprint" AS "nested_0.fingerprint", "a"."tile" AS "nested_0.tile", t.day AS day, t.sort_key AS sort_key FROM timeline_item AS t INNER JOIN local_asset AS a ON a.id = t.id WHERE t.folder NOT IN (SELECT id FROM hidden_folder) AND ${generatedphoto.sql} AND CASE ?1 WHEN 0 THEN t.added >= ?2 WHEN 1 THEN a.favorite = 1 WHEN 2 THEN t.day >= ?3 ELSE 1 END AND (t.day, t.sort_key, t.id) < (?4, ?5, ?6) AND NOT EXISTS (SELECT 1 AS _c0 FROM local_ml AS m WHERE m.local_asset_id = a.id AND m.model = ?7 AND m.size = a.size AND m.mtime = a.mtime AND(m.failure IS NULL OR m.failure = ?8)) ORDER BY t.day DESC, t.sort_key DESC, t.id DESC LIMIT ?9',
      variables: [
        Variable<int>(tier),
        Variable<int>(since),
        Variable<int>(year),
        Variable<int>(day),
        Variable<int>(key),
        Variable<Uint8List>(id),
        Variable<String>(model),
        Variable<String>(failure),
        Variable<int>(limit),
        ...generatedphoto.introducedVariables,
      ],
      readsFrom: {
        this.localAsset,
        this.localMl,
        this.deviceFolderMode,
        this.deviceFolder,
        ...generatedphoto.watchedTables,
      },
    ).asyncMap(
      (QueryRow row) async => MlQueueResult(
        a: await this.localAsset.mapFromRow(row, tablePrefix: 'nested_0'),
        day: row.read<int>('day'),
        sortKey: row.read<int>('sort_key'),
      ),
    );
  }

  Selectable<MlProgressResult> mlProgress(String? model) {
    return customSelect(
      'SELECT CAST(TOTAL(IIF(model = \'\', done, 0)) AS INTEGER) AS total, CAST(TOTAL(IIF(model = \'\', 0, done)) AS INTEGER) AS done, CAST(TOTAL(failed) AS INTEGER) AS failed FROM ml_count WHERE model IN (\'\', IFNULL(?1, (SELECT model FROM local_ml ORDER BY "rowid" DESC LIMIT 1))) AND folder NOT IN (SELECT id FROM hidden_folder)',
      variables: [Variable<String>(model)],
      readsFrom: {
        this.mlCount,
        this.localMl,
        this.deviceFolderMode,
        this.deviceFolder,
      },
    ).map(
      (QueryRow row) => MlProgressResult(
        total: row.read<int>('total'),
        done: row.read<int>('done'),
        failed: row.read<int>('failed'),
      ),
    );
  }

  Selectable<MlFailuresResult> mlFailures(
    String? model, {
    MlFailures$photo? photo,
  }) {
    var $arrayStartIndex = 2;
    final generatedphoto = $write(
      photo?.call(
            alias(this.localMl, 'm'),
            alias(this.timelineItem, 't'),
            alias(this.localAsset, 'a'),
          ) ??
          const CustomExpression('(TRUE)'),
      hasMultipleTables: true,
      startIndex: $arrayStartIndex,
    );
    $arrayStartIndex += generatedphoto.amountOfVariables;
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."source" AS "nested_0.source", "a"."volume" AS "nested_0.volume", "a"."source_id" AS "nested_0.source_id", "a"."generation" AS "nested_0.generation", "a"."size" AS "nested_0.size", "a"."mtime" AS "nested_0.mtime", "a"."content_hash" AS "nested_0.content_hash", "a"."asset_id" AS "nested_0.asset_id", "a"."path" AS "nested_0.path", "a"."file_id" AS "nested_0.file_id", "a"."state" AS "nested_0.state", "a"."name" AS "nested_0.name", "a"."bucket_id" AS "nested_0.bucket_id", "a"."bucket_name" AS "nested_0.bucket_name", "a"."mime" AS "nested_0.mime", "a"."taken" AS "nested_0.taken", "a"."width" AS "nested_0.width", "a"."height" AS "nested_0.height", "a"."orientation" AS "nested_0.orientation", "a"."duration_ms" AS "nested_0.duration_ms", "a"."favorite" AS "nested_0.favorite", "a"."trashed" AS "nested_0.trashed", "a"."expires" AS "nested_0.expires", "a"."extracted" AS "nested_0.extracted", "a"."taken_local" AS "nested_0.taken_local", "a"."tz_offset_min" AS "nested_0.tz_offset_min", "a"."taken_utc" AS "nested_0.taken_utc", "a"."time_source" AS "nested_0.time_source", "a"."time_confidence" AS "nested_0.time_confidence", "a"."time_precision" AS "nested_0.time_precision", "a"."lat" AS "nested_0.lat", "a"."lon" AS "nested_0.lon", "a"."make" AS "nested_0.make", "a"."model" AS "nested_0.model", "a"."facets" AS "nested_0.facets", "a"."cloud_id" AS "nested_0.cloud_id", "a"."burst_id" AS "nested_0.burst_id", "a"."edited" AS "nested_0.edited", "a"."added" AS "nested_0.added", "a"."thumbhash" AS "nested_0.thumbhash", "a"."motion_offset" AS "nested_0.motion_offset", "a"."motion_length" AS "nested_0.motion_length", "a"."frame_rate" AS "nested_0.frame_rate", "a"."projection" AS "nested_0.projection", "a"."crop" AS "nested_0.crop", "a"."stereo" AS "nested_0.stereo", "a"."folder" AS "nested_0.folder", "a"."heading" AS "nested_0.heading", "a"."hidden" AS "nested_0.hidden", "a"."archived" AS "nested_0.archived", "a"."bin" AS "nested_0.bin", "a"."fingerprint" AS "nested_0.fingerprint", "a"."tile" AS "nested_0.tile", m.failure AS failure FROM local_ml AS m INNER JOIN timeline_item AS t ON t.id = m.local_asset_id INNER JOIN local_asset AS a ON a.id = t.id WHERE m.model = IFNULL(?1, (SELECT model FROM local_ml ORDER BY "rowid" DESC LIMIT 1)) AND m.failure IS NOT NULL AND m.size = a.size AND m.mtime = a.mtime AND t.folder NOT IN (SELECT id FROM hidden_folder) AND ${generatedphoto.sql} ORDER BY t.day DESC, t.sort_key DESC, t.id DESC',
      variables: [
        Variable<String>(model),
        ...generatedphoto.introducedVariables,
      ],
      readsFrom: {
        this.localMl,
        this.localAsset,
        this.deviceFolderMode,
        this.deviceFolder,
        ...generatedphoto.watchedTables,
      },
    ).asyncMap(
      (QueryRow row) async => MlFailuresResult(
        a: await this.localAsset.mapFromRow(row, tablePrefix: 'nested_0'),
        failure: row.readNullable<String>('failure'),
      ),
    );
  }

  Selectable<TimelineDaysResult> timelineDays(bool veiled, String? backup) {
    return customSelect(
      'SELECT day, CAST(IFNULL(SUM(n), 0) AS INTEGER) AS count FROM (SELECT day, SUM(count) AS n FROM timeline_day WHERE(?1 OR veiled = 0)AND ?2 IS NULL AND folder NOT IN (SELECT id FROM hidden_folder) GROUP BY day UNION ALL SELECT day, COUNT(*) FROM timeline_item WHERE ?2 IS NOT NULL AND backup = ?2 AND(?1 OR hidden + archived = 0)AND folder NOT IN (SELECT id FROM hidden_folder) GROUP BY day UNION ALL SELECT day, COUNT(*) FROM cloud_item WHERE ?2 IS NULL OR ?2 = \'cloud_only\' GROUP BY day) GROUP BY day ORDER BY day DESC',
      variables: [Variable<bool>(veiled), Variable<String>(backup)],
      readsFrom: {
        this.timelineDay,
        this.deviceFolderMode,
        this.deviceFolder,
        this.localAsset,
        this.asset,
        this.assetFile,
        this.library,
        this.assetUserState,
        this.libraryUserState,
      },
    ).map(
      (QueryRow row) => TimelineDaysResult(
        day: row.read<int>('day'),
        count: row.read<int>('count'),
      ),
    );
  }

  Selectable<TimelineItemData> timelinePage(
    int day,
    bool veiled,
    String? backup,
    int limit,
    int skip,
  ) {
    return customSelect(
      'SELECT * FROM timeline_item WHERE day <= ?1 AND(?2 OR hidden + archived = 0)AND(?3 IS NULL OR backup = ?3)AND folder NOT IN (SELECT id FROM hidden_folder) UNION ALL SELECT * FROM cloud_item WHERE day <= ?1 AND(?3 IS NULL OR ?3 = \'cloud_only\')ORDER BY day DESC, sort_key DESC, id DESC LIMIT ?4 OFFSET ?5',
      variables: [
        Variable<int>(day),
        Variable<bool>(veiled),
        Variable<String>(backup),
        Variable<int>(limit),
        Variable<int>(skip),
      ],
      readsFrom: {
        this.localAsset,
        this.deviceFolderMode,
        this.deviceFolder,
        this.asset,
        this.assetFile,
        this.library,
        this.assetUserState,
        this.libraryUserState,
      },
    ).asyncMap(this.timelineItem.mapFromRow);
  }

  Selectable<TimelineAddedDaysResult> timelineAddedDays(
    int offset,
    bool veiled,
    String? backup,
  ) {
    return customSelect(
      'SELECT CAST(strftime(\'%Y%m%d\', d * 86400, \'unixepoch\') AS INTEGER) AS day, CAST(IFNULL(SUM(n), 0) AS INTEGER) AS count FROM (SELECT(slot * 900000 + ?1)/ 86400000 AS d, SUM(count) AS n FROM timeline_added WHERE(?2 OR veiled = 0)AND ?3 IS NULL AND folder NOT IN (SELECT id FROM hidden_folder) GROUP BY d UNION ALL SELECT(added + ?1)/ 86400000, COUNT(*) FROM timeline_item WHERE ?3 IS NOT NULL AND backup = ?3 AND(?2 OR hidden + archived = 0)AND folder NOT IN (SELECT id FROM hidden_folder) GROUP BY 1 UNION ALL SELECT(added + ?1)/ 86400000, COUNT(*) FROM cloud_item WHERE ?3 IS NULL OR ?3 = \'cloud_only\' GROUP BY 1) GROUP BY d ORDER BY d DESC',
      variables: [
        Variable<int>(offset),
        Variable<bool>(veiled),
        Variable<String>(backup),
      ],
      readsFrom: {
        this.timelineAdded,
        this.deviceFolderMode,
        this.deviceFolder,
        this.localAsset,
        this.asset,
        this.assetFile,
        this.library,
        this.assetUserState,
        this.libraryUserState,
      },
    ).map(
      (QueryRow row) => TimelineAddedDaysResult(
        day: row.read<int>('day'),
        count: row.read<int>('count'),
      ),
    );
  }

  Selectable<TimelineItemData> timelineAddedPage(
    int before,
    bool veiled,
    String? backup,
    int limit,
    int skip,
  ) {
    return customSelect(
      'SELECT * FROM timeline_item WHERE added < ?1 AND(?2 OR hidden + archived = 0)AND(?3 IS NULL OR backup = ?3)AND folder NOT IN (SELECT id FROM hidden_folder) UNION ALL SELECT * FROM cloud_item WHERE added < ?1 AND(?3 IS NULL OR ?3 = \'cloud_only\')ORDER BY added DESC, id DESC LIMIT ?4 OFFSET ?5',
      variables: [
        Variable<int>(before),
        Variable<bool>(veiled),
        Variable<String>(backup),
        Variable<int>(limit),
        Variable<int>(skip),
      ],
      readsFrom: {
        this.localAsset,
        this.deviceFolderMode,
        this.deviceFolder,
        this.asset,
        this.assetFile,
        this.library,
        this.assetUserState,
        this.libraryUserState,
      },
    ).asyncMap(this.timelineItem.mapFromRow);
  }

  Selectable<TimelineItemData> folderContext(int folder) {
    return customSelect(
      'SELECT * FROM timeline_item WHERE folder = ?1 ORDER BY day DESC, sort_key DESC, id DESC',
      variables: [Variable<int>(folder)],
      readsFrom: {this.localAsset},
    ).asyncMap(this.timelineItem.mapFromRow);
  }

  Selectable<DeviceFoldersResult> deviceFolders() {
    return customSelect(
      'SELECT f.*, CAST(IFNULL(SUM(d.count), 0) AS INTEGER) AS items, MAX(d.day) AS newest, f.id IN (SELECT id FROM excluded_folder) AS out FROM device_folder AS f LEFT JOIN timeline_day AS d ON d.folder = f.id GROUP BY f.id ORDER BY f.volume, f.path',
      variables: [],
      readsFrom: {this.timelineDay, this.deviceFolder, this.deviceFolderMode},
    ).map(
      (QueryRow row) => DeviceFoldersResult(
        id: row.read<int>('id'),
        volume: row.read<String>('volume'),
        path: row.read<String>('path'),
        name: row.read<String>('name'),
        visibility: row.read<String>('visibility'),
        fresh: row.read<int>('fresh'),
        items: row.read<int>('items'),
        newest: row.readNullable<int>('newest'),
        out: row.read<bool>('out'),
      ),
    );
  }

  Selectable<ShownInFoldersResult> shownInFolders() {
    return customSelect(
      'SELECT folder, CAST(SUM(count) AS INTEGER) AS items, MAX(day) AS newest FROM timeline_day WHERE NOT veiled GROUP BY folder',
      variables: [],
      readsFrom: {this.timelineDay},
    ).map(
      (QueryRow row) => ShownInFoldersResult(
        folder: row.read<int>('folder'),
        items: row.readNullable<int>('items'),
        newest: row.readNullable<int>('newest'),
      ),
    );
  }

  Selectable<ExcludedFolderData> excludedFolders() {
    return customSelect(
      'SELECT id FROM excluded_folder',
      variables: [],
      readsFrom: {this.deviceFolder, this.deviceFolderMode},
    ).asyncMap(this.excludedFolder.mapFromRow);
  }

  Selectable<FreshFolderResult> freshFolder() {
    return customSelect(
      'SELECT f.id, f.name, CAST(IFNULL(SUM(d.count), 0) AS INTEGER) AS items FROM device_folder AS f INNER JOIN timeline_day AS d ON d.folder = f.id WHERE f.fresh GROUP BY f.id ORDER BY f.id LIMIT 1',
      variables: [],
      readsFrom: {this.deviceFolder, this.timelineDay},
    ).map(
      (QueryRow row) => FreshFolderResult(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        items: row.read<int>('items'),
      ),
    );
  }

  Selectable<LocalAssetData> trashItems(bool veiled) {
    return customSelect(
      'SELECT * FROM local_asset WHERE trashed = 1 AND(?1 OR hidden = 0)AND folder NOT IN (SELECT id FROM hidden_folder) ORDER BY expires IS NULL, expires, id',
      variables: [Variable<bool>(veiled)],
      readsFrom: {this.localAsset, this.deviceFolderMode, this.deviceFolder},
    ).asyncMap(this.localAsset.mapFromRow);
  }

  Selectable<TimelineItemData> folderItems(
    String? volume,
    bool hashless,
    int day,
    int key,
    Uint8List id,
    int limit,
  ) {
    return customSelect(
      'SELECT * FROM timeline_item WHERE +source = \'folder\' AND(?1 IS NULL OR +volume = ?1)AND(NOT ?2 OR thumbhash IS NULL)AND day <= ?3 AND (day, sort_key, id) < (?3, ?4, ?5) ORDER BY day DESC, sort_key DESC, id DESC LIMIT ?6',
      variables: [
        Variable<String>(volume),
        Variable<bool>(hashless),
        Variable<int>(day),
        Variable<int>(key),
        Variable<Uint8List>(id),
        Variable<int>(limit),
      ],
      readsFrom: {this.localAsset},
    ).asyncMap(this.timelineItem.mapFromRow);
  }

  Selectable<TimelineItemData> mapItems(List<Uint8List> ids) {
    var $arrayStartIndex = 1;
    final expandedids = $expandVar($arrayStartIndex, ids.length);
    $arrayStartIndex += ids.length;
    return customSelect(
      'SELECT * FROM timeline_item WHERE id IN ($expandedids) AND folder NOT IN (SELECT id FROM hidden_folder) UNION ALL SELECT * FROM cloud_item WHERE id IN ($expandedids) ORDER BY day DESC, sort_key DESC, id DESC',
      variables: [for (var $ in ids) Variable<Uint8List>($)],
      readsFrom: {
        this.localAsset,
        this.deviceFolderMode,
        this.deviceFolder,
        this.asset,
        this.assetFile,
        this.library,
        this.assetUserState,
        this.libraryUserState,
      },
    ).asyncMap(this.timelineItem.mapFromRow);
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    library,
    asset,
    assetTaken,
    assetLibrary,
    assetUserState,
    albumUserState,
    libraryUserState,
    assetFile,
    assetFileAsset,
    assetVersion,
    assetVersionAsset,
    stack,
    albumFolder,
    album,
    albumItem,
    albumItemOrder,
    albumMember,
    tag,
    assetTag,
    assetTagTag,
    person,
    face,
    facePerson,
    faceAsset,
    localAsset,
    linkedTile,
    assetDeleted,
    partnerShare,
    partnerLibrary,
    localAssetPath,
    localAssetHash,
    localAssetFile,
    localAssetPending,
    localAssetRoot,
    timelineItem,
    localAssetTimeline,
    localAssetAdded,
    deviceFolder,
    deviceFolderOwn,
    deviceFolderMode,
    excludedFolder,
    hiddenFolder,
    timelineDay,
    timelineDayInsert,
    timelineDayDelete,
    timelineDayUpdate,
    timelineDayEmpty,
    timelineAdded,
    timelineAddedInsert,
    timelineAddedDelete,
    timelineAddedUpdate,
    timelineAddedEmpty,
    keptState,
    localAssetKept,
    localAssetFingerprint,
    localAssetAsset,
    cloudItem,
    assetTimeline,
    assetAdded,
    localAssetLinked,
    localAssetRelinked,
    localAssetUnlinked,
    assetStateHiddenInsert,
    assetStateHiddenUpdate,
    libraryStateHiddenInsert,
    libraryStateHiddenUpdate,
    libraryStateHiddenDelete,
    assetLinked,
    assetChanged,
    mediaSource,
    volumeCursor,
    backupState,
    backupStateState,
    backupRun,
    outbox,
    outboxEntity,
    clock,
    syncCursor,
    extJournalCursor,
    localMl,
    mlPhoto,
    mlCounted,
    mlCount,
    mlCountInsert,
    mlCountDelete,
    mlCountUnset,
    mlCountSet,
    mlCountMlReplace,
    mlCountMlInsert,
    mlCountMlDelete,
    mlCountMlUpdate,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'asset',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('asset_file', kind: UpdateKind.delete),
        TableUpdate('asset_version', kind: UpdateKind.delete),
        TableUpdate('face', kind: UpdateKind.delete),
        TableUpdate('local_asset', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('timeline_day', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('timeline_day', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('timeline_day', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'timeline_day',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('timeline_day', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('timeline_added', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('timeline_added', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('timeline_added', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'timeline_added',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('timeline_added', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('kept_state', kind: UpdateKind.insert),
        TableUpdate('kept_state', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('kept_state', kind: UpdateKind.insert),
        TableUpdate('local_asset', kind: UpdateKind.update),
        TableUpdate('kept_state', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('local_asset', kind: UpdateKind.update),
        TableUpdate('asset', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [
        TableUpdate('local_asset', kind: UpdateKind.update),
        TableUpdate('asset', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('local_asset', kind: UpdateKind.update),
        TableUpdate('asset', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'asset_user_state',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('local_asset', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'asset_user_state',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('local_asset', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'library_user_state',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('local_asset', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'library_user_state',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('local_asset', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'library_user_state',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('local_asset', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'asset',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('local_asset', kind: UpdateKind.update),
        TableUpdate('asset', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('local_asset', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_asset',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_ml',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_ml',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_ml',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'local_ml',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('ml_count', kind: UpdateKind.insert)],
    ),
  ]);
}

class BackupSummaryResult {
  final String state;
  final int count;
  BackupSummaryResult({required this.state, required this.count});
}

class BackupReasonsResult {
  final String state;
  final String? reason;
  final int count;
  final int? retryAt;
  BackupReasonsResult({
    required this.state,
    this.reason,
    required this.count,
    this.retryAt,
  });
}

class BackupItemsResult {
  final String? name;
  final String? path;
  final String sourceId;
  BackupItemsResult({this.name, this.path, required this.sourceId});
}

class FolderSummaryResult {
  final String root;
  final String state;
  final int items;
  FolderSummaryResult({
    required this.root,
    required this.state,
    required this.items,
  });
}

class DeviceBucketsResult {
  final String? bucketId;
  final String? bucketName;
  final int items;
  DeviceBucketsResult({this.bucketId, this.bucketName, required this.items});
}

class LocalSearchResult {
  final LocalAssetData r;
  final int total;
  LocalSearchResult({required this.r, required this.total});
}

typedef LocalSearch$filters = Expression<bool> Function(LocalAsset a);

class LocalFoldersResult {
  final String source;
  final String volume;
  final String? dir;
  final int items;
  LocalFoldersResult({
    required this.source,
    required this.volume,
    this.dir,
    required this.items,
  });
}

class LocalCamerasResult {
  final String? make;
  final String? model;
  final int items;
  LocalCamerasResult({this.make, this.model, required this.items});
}

class OtherFilesResult {
  final Uint8List id;
  final String name;
  final int createdAt;
  final int? size;
  final String? mime;
  OtherFilesResult({
    required this.id,
    required this.name,
    required this.createdAt,
    this.size,
    this.mime,
  });
}

class ExtractionQueueResult {
  final LocalAssetData a;
  final String? root;
  ExtractionQueueResult({required this.a, this.root});
}

class ExtractionQueueOfResult {
  final LocalAssetData a;
  final String? root;
  ExtractionQueueOfResult({required this.a, this.root});
}

class MlQueueResult {
  final LocalAssetData a;
  final int day;
  final int sortKey;
  MlQueueResult({required this.a, required this.day, required this.sortKey});
}

typedef MlQueue$photo = Expression<bool> Function(TimelineItem t, LocalAsset a);

class MlProgressResult {
  final int total;
  final int done;
  final int failed;
  MlProgressResult({
    required this.total,
    required this.done,
    required this.failed,
  });
}

class MlFailuresResult {
  final LocalAssetData a;
  final String? failure;
  MlFailuresResult({required this.a, this.failure});
}

typedef MlFailures$photo =
    Expression<bool> Function(LocalMl m, TimelineItem t, LocalAsset a);

class TimelineDaysResult {
  final int day;
  final int count;
  TimelineDaysResult({required this.day, required this.count});
}

class TimelineAddedDaysResult {
  final int day;
  final int count;
  TimelineAddedDaysResult({required this.day, required this.count});
}

class DeviceFoldersResult {
  final int id;
  final String volume;
  final String path;
  final String name;
  final String visibility;
  final int fresh;
  final int items;
  final int? newest;
  final bool out;
  DeviceFoldersResult({
    required this.id,
    required this.volume,
    required this.path,
    required this.name,
    required this.visibility,
    required this.fresh,
    required this.items,
    this.newest,
    required this.out,
  });
}

class ShownInFoldersResult {
  final int folder;
  final int? items;
  final int? newest;
  ShownInFoldersResult({required this.folder, this.items, this.newest});
}

class FreshFolderResult {
  final int id;
  final String name;
  final int items;
  FreshFolderResult({
    required this.id,
    required this.name,
    required this.items,
  });
}
