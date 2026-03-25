// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranked_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
<<<<<<< HEAD
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);
=======
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');
>>>>>>> 88d3438 (good progress)

/// @nodoc
mixin _$RankedList {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ValueType get valueType => throw _privateConstructorUsedError;
  RankOrder get rankOrder => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  String? get inviteToken => throw _privateConstructorUsedError;
  List<RankedEntry> get entries => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;

<<<<<<< HEAD
  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  $RankedListCopyWith<RankedList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankedListCopyWith<$Res> {
  factory $RankedListCopyWith(
<<<<<<< HEAD
    RankedList value,
    $Res Function(RankedList) then,
  ) = _$RankedListCopyWithImpl<$Res, RankedList>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    ValueType valueType,
    RankOrder rankOrder,
    bool isPublic,
    String? inviteToken,
    List<RankedEntry> entries,
    int memberCount,
  });
=======
          RankedList value, $Res Function(RankedList) then) =
      _$RankedListCopyWithImpl<$Res, RankedList>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      ValueType valueType,
      RankOrder rankOrder,
      bool isPublic,
      String? inviteToken,
      List<RankedEntry> entries,
      int memberCount});
>>>>>>> 88d3438 (good progress)
}

/// @nodoc
class _$RankedListCopyWithImpl<$Res, $Val extends RankedList>
    implements $RankedListCopyWith<$Res> {
  _$RankedListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

<<<<<<< HEAD
  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
=======
>>>>>>> 88d3438 (good progress)
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? valueType = null,
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? inviteToken = freezed,
    Object? entries = null,
    Object? memberCount = null,
  }) {
<<<<<<< HEAD
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            valueType: null == valueType
                ? _value.valueType
                : valueType // ignore: cast_nullable_to_non_nullable
                      as ValueType,
            rankOrder: null == rankOrder
                ? _value.rankOrder
                : rankOrder // ignore: cast_nullable_to_non_nullable
                      as RankOrder,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
            inviteToken: freezed == inviteToken
                ? _value.inviteToken
                : inviteToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<RankedEntry>,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
=======
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as ValueType,
      rankOrder: null == rankOrder
          ? _value.rankOrder
          : rankOrder // ignore: cast_nullable_to_non_nullable
              as RankOrder,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      inviteToken: freezed == inviteToken
          ? _value.inviteToken
          : inviteToken // ignore: cast_nullable_to_non_nullable
              as String?,
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<RankedEntry>,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
>>>>>>> 88d3438 (good progress)
  }
}

/// @nodoc
abstract class _$$RankedListImplCopyWith<$Res>
    implements $RankedListCopyWith<$Res> {
  factory _$$RankedListImplCopyWith(
<<<<<<< HEAD
    _$RankedListImpl value,
    $Res Function(_$RankedListImpl) then,
  ) = __$$RankedListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    ValueType valueType,
    RankOrder rankOrder,
    bool isPublic,
    String? inviteToken,
    List<RankedEntry> entries,
    int memberCount,
  });
=======
          _$RankedListImpl value, $Res Function(_$RankedListImpl) then) =
      __$$RankedListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      ValueType valueType,
      RankOrder rankOrder,
      bool isPublic,
      String? inviteToken,
      List<RankedEntry> entries,
      int memberCount});
>>>>>>> 88d3438 (good progress)
}

/// @nodoc
class __$$RankedListImplCopyWithImpl<$Res>
    extends _$RankedListCopyWithImpl<$Res, _$RankedListImpl>
    implements _$$RankedListImplCopyWith<$Res> {
  __$$RankedListImplCopyWithImpl(
<<<<<<< HEAD
    _$RankedListImpl _value,
    $Res Function(_$RankedListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
=======
      _$RankedListImpl _value, $Res Function(_$RankedListImpl) _then)
      : super(_value, _then);

>>>>>>> 88d3438 (good progress)
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? valueType = null,
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? inviteToken = freezed,
    Object? entries = null,
    Object? memberCount = null,
  }) {
<<<<<<< HEAD
    return _then(
      _$RankedListImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        valueType: null == valueType
            ? _value.valueType
            : valueType // ignore: cast_nullable_to_non_nullable
                  as ValueType,
        rankOrder: null == rankOrder
            ? _value.rankOrder
            : rankOrder // ignore: cast_nullable_to_non_nullable
                  as RankOrder,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
        inviteToken: freezed == inviteToken
            ? _value.inviteToken
            : inviteToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<RankedEntry>,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
=======
    return _then(_$RankedListImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as ValueType,
      rankOrder: null == rankOrder
          ? _value.rankOrder
          : rankOrder // ignore: cast_nullable_to_non_nullable
              as RankOrder,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      inviteToken: freezed == inviteToken
          ? _value.inviteToken
          : inviteToken // ignore: cast_nullable_to_non_nullable
              as String?,
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<RankedEntry>,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
>>>>>>> 88d3438 (good progress)
  }
}

/// @nodoc

class _$RankedListImpl implements _RankedList {
<<<<<<< HEAD
  const _$RankedListImpl({
    required this.id,
    required this.title,
    this.description,
    required this.valueType,
    required this.rankOrder,
    required this.isPublic,
    this.inviteToken,
    required final List<RankedEntry> entries,
    required this.memberCount,
  }) : _entries = entries;
=======
  const _$RankedListImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.valueType,
      required this.rankOrder,
      required this.isPublic,
      this.inviteToken,
      required final List<RankedEntry> entries,
      required this.memberCount})
      : _entries = entries;
>>>>>>> 88d3438 (good progress)

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final ValueType valueType;
  @override
  final RankOrder rankOrder;
  @override
  final bool isPublic;
  @override
  final String? inviteToken;
  final List<RankedEntry> _entries;
  @override
  List<RankedEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final int memberCount;

  @override
  String toString() {
    return 'RankedList(id: $id, title: $title, description: $description, valueType: $valueType, rankOrder: $rankOrder, isPublic: $isPublic, inviteToken: $inviteToken, entries: $entries, memberCount: $memberCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankedListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.valueType, valueType) ||
                other.valueType == valueType) &&
            (identical(other.rankOrder, rankOrder) ||
                other.rankOrder == rankOrder) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.inviteToken, inviteToken) ||
                other.inviteToken == inviteToken) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount));
  }

  @override
  int get hashCode => Object.hash(
<<<<<<< HEAD
    runtimeType,
    id,
    title,
    description,
    valueType,
    rankOrder,
    isPublic,
    inviteToken,
    const DeepCollectionEquality().hash(_entries),
    memberCount,
  );

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
      runtimeType,
      id,
      title,
      description,
      valueType,
      rankOrder,
      isPublic,
      inviteToken,
      const DeepCollectionEquality().hash(_entries),
      memberCount);

  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  @override
  @pragma('vm:prefer-inline')
  _$$RankedListImplCopyWith<_$RankedListImpl> get copyWith =>
      __$$RankedListImplCopyWithImpl<_$RankedListImpl>(this, _$identity);
}

abstract class _RankedList implements RankedList {
<<<<<<< HEAD
  const factory _RankedList({
    required final String id,
    required final String title,
    final String? description,
    required final ValueType valueType,
    required final RankOrder rankOrder,
    required final bool isPublic,
    final String? inviteToken,
    required final List<RankedEntry> entries,
    required final int memberCount,
  }) = _$RankedListImpl;
=======
  const factory _RankedList(
      {required final String id,
      required final String title,
      final String? description,
      required final ValueType valueType,
      required final RankOrder rankOrder,
      required final bool isPublic,
      final String? inviteToken,
      required final List<RankedEntry> entries,
      required final int memberCount}) = _$RankedListImpl;
>>>>>>> 88d3438 (good progress)

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  ValueType get valueType;
  @override
  RankOrder get rankOrder;
  @override
  bool get isPublic;
  @override
  String? get inviteToken;
  @override
  List<RankedEntry> get entries;
  @override
  int get memberCount;
<<<<<<< HEAD

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  @override
  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  _$$RankedListImplCopyWith<_$RankedListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
<<<<<<< HEAD
=======
mixin _$RankedEntry {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  double? get valueNumber => throw _privateConstructorUsedError;
  int? get valueDurationMs => throw _privateConstructorUsedError;
  String? get valueText => throw _privateConstructorUsedError;
  int? get manualRank => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get submittedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RankedEntryCopyWith<RankedEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankedEntryCopyWith<$Res> {
  factory $RankedEntryCopyWith(
          RankedEntry value, $Res Function(RankedEntry) then) =
      _$RankedEntryCopyWithImpl<$Res, RankedEntry>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String displayName,
      int rank,
      double? valueNumber,
      int? valueDurationMs,
      String? valueText,
      int? manualRank,
      String? note,
      DateTime submittedAt});
}

/// @nodoc
class _$RankedEntryCopyWithImpl<$Res, $Val extends RankedEntry>
    implements $RankedEntryCopyWith<$Res> {
  _$RankedEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? displayName = null,
    Object? rank = null,
    Object? valueNumber = freezed,
    Object? valueDurationMs = freezed,
    Object? valueText = freezed,
    Object? manualRank = freezed,
    Object? note = freezed,
    Object? submittedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      valueNumber: freezed == valueNumber
          ? _value.valueNumber
          : valueNumber // ignore: cast_nullable_to_non_nullable
              as double?,
      valueDurationMs: freezed == valueDurationMs
          ? _value.valueDurationMs
          : valueDurationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      valueText: freezed == valueText
          ? _value.valueText
          : valueText // ignore: cast_nullable_to_non_nullable
              as String?,
      manualRank: freezed == manualRank
          ? _value.manualRank
          : manualRank // ignore: cast_nullable_to_non_nullable
              as int?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RankedEntryImplCopyWith<$Res>
    implements $RankedEntryCopyWith<$Res> {
  factory _$$RankedEntryImplCopyWith(
          _$RankedEntryImpl value, $Res Function(_$RankedEntryImpl) then) =
      __$$RankedEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String displayName,
      int rank,
      double? valueNumber,
      int? valueDurationMs,
      String? valueText,
      int? manualRank,
      String? note,
      DateTime submittedAt});
}

/// @nodoc
class __$$RankedEntryImplCopyWithImpl<$Res>
    extends _$RankedEntryCopyWithImpl<$Res, _$RankedEntryImpl>
    implements _$$RankedEntryImplCopyWith<$Res> {
  __$$RankedEntryImplCopyWithImpl(
      _$RankedEntryImpl _value, $Res Function(_$RankedEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? displayName = null,
    Object? rank = null,
    Object? valueNumber = freezed,
    Object? valueDurationMs = freezed,
    Object? valueText = freezed,
    Object? manualRank = freezed,
    Object? note = freezed,
    Object? submittedAt = null,
  }) {
    return _then(_$RankedEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      valueNumber: freezed == valueNumber
          ? _value.valueNumber
          : valueNumber // ignore: cast_nullable_to_non_nullable
              as double?,
      valueDurationMs: freezed == valueDurationMs
          ? _value.valueDurationMs
          : valueDurationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      valueText: freezed == valueText
          ? _value.valueText
          : valueText // ignore: cast_nullable_to_non_nullable
              as String?,
      manualRank: freezed == manualRank
          ? _value.manualRank
          : manualRank // ignore: cast_nullable_to_non_nullable
              as int?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      submittedAt: null == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$RankedEntryImpl implements _RankedEntry {
  const _$RankedEntryImpl(
      {required this.id,
      required this.userId,
      required this.displayName,
      required this.rank,
      this.valueNumber,
      this.valueDurationMs,
      this.valueText,
      this.manualRank,
      this.note,
      required this.submittedAt});

  @override
  final String id;
  @override
  final String userId;
  @override
  final String displayName;
  @override
  final int rank;
  @override
  final double? valueNumber;
  @override
  final int? valueDurationMs;
  @override
  final String? valueText;
  @override
  final int? manualRank;
  @override
  final String? note;
  @override
  final DateTime submittedAt;

  @override
  String toString() {
    return 'RankedEntry(id: $id, userId: $userId, displayName: $displayName, rank: $rank, valueNumber: $valueNumber, valueDurationMs: $valueDurationMs, valueText: $valueText, manualRank: $manualRank, note: $note, submittedAt: $submittedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankedEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.valueNumber, valueNumber) ||
                other.valueNumber == valueNumber) &&
            (identical(other.valueDurationMs, valueDurationMs) ||
                other.valueDurationMs == valueDurationMs) &&
            (identical(other.valueText, valueText) ||
                other.valueText == valueText) &&
            (identical(other.manualRank, manualRank) ||
                other.manualRank == manualRank) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, displayName, rank,
      valueNumber, valueDurationMs, valueText, manualRank, note, submittedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RankedEntryImplCopyWith<_$RankedEntryImpl> get copyWith =>
      __$$RankedEntryImplCopyWithImpl<_$RankedEntryImpl>(this, _$identity);
}

abstract class _RankedEntry implements RankedEntry {
  const factory _RankedEntry(
      {required final String id,
      required final String userId,
      required final String displayName,
      required final int rank,
      final double? valueNumber,
      final int? valueDurationMs,
      final String? valueText,
      final int? manualRank,
      final String? note,
      required final DateTime submittedAt}) = _$RankedEntryImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get displayName;
  @override
  int get rank;
  @override
  double? get valueNumber;
  @override
  int? get valueDurationMs;
  @override
  String? get valueText;
  @override
  int? get manualRank;
  @override
  String? get note;
  @override
  DateTime get submittedAt;
  @override
  @JsonKey(ignore: true)
  _$$RankedEntryImplCopyWith<_$RankedEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
>>>>>>> 88d3438 (good progress)
mixin _$ListSummary {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  ValueType get valueType => throw _privateConstructorUsedError;
<<<<<<< HEAD
  RankOrder get rankOrder => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  int? get ownRank => throw _privateConstructorUsedError;

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  int get memberCount => throw _privateConstructorUsedError;
  int? get ownRank => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  $ListSummaryCopyWith<ListSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListSummaryCopyWith<$Res> {
  factory $ListSummaryCopyWith(
<<<<<<< HEAD
    ListSummary value,
    $Res Function(ListSummary) then,
  ) = _$ListSummaryCopyWithImpl<$Res, ListSummary>;
  @useResult
  $Res call({
    String id,
    String title,
    ValueType valueType,
    RankOrder rankOrder,
    bool isPublic,
    int memberCount,
    int? ownRank,
  });
=======
          ListSummary value, $Res Function(ListSummary) then) =
      _$ListSummaryCopyWithImpl<$Res, ListSummary>;
  @useResult
  $Res call(
      {String id,
      String title,
      ValueType valueType,
      int memberCount,
      int? ownRank});
>>>>>>> 88d3438 (good progress)
}

/// @nodoc
class _$ListSummaryCopyWithImpl<$Res, $Val extends ListSummary>
    implements $ListSummaryCopyWith<$Res> {
  _$ListSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

<<<<<<< HEAD
  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
=======
>>>>>>> 88d3438 (good progress)
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? valueType = null,
<<<<<<< HEAD
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? memberCount = null,
    Object? ownRank = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            valueType: null == valueType
                ? _value.valueType
                : valueType // ignore: cast_nullable_to_non_nullable
                      as ValueType,
            rankOrder: null == rankOrder
                ? _value.rankOrder
                : rankOrder // ignore: cast_nullable_to_non_nullable
                      as RankOrder,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
            ownRank: freezed == ownRank
                ? _value.ownRank
                : ownRank // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
=======
    Object? memberCount = null,
    Object? ownRank = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as ValueType,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      ownRank: freezed == ownRank
          ? _value.ownRank
          : ownRank // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
>>>>>>> 88d3438 (good progress)
  }
}

/// @nodoc
abstract class _$$ListSummaryImplCopyWith<$Res>
    implements $ListSummaryCopyWith<$Res> {
  factory _$$ListSummaryImplCopyWith(
<<<<<<< HEAD
    _$ListSummaryImpl value,
    $Res Function(_$ListSummaryImpl) then,
  ) = __$$ListSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    ValueType valueType,
    RankOrder rankOrder,
    bool isPublic,
    int memberCount,
    int? ownRank,
  });
=======
          _$ListSummaryImpl value, $Res Function(_$ListSummaryImpl) then) =
      __$$ListSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      ValueType valueType,
      int memberCount,
      int? ownRank});
>>>>>>> 88d3438 (good progress)
}

/// @nodoc
class __$$ListSummaryImplCopyWithImpl<$Res>
    extends _$ListSummaryCopyWithImpl<$Res, _$ListSummaryImpl>
    implements _$$ListSummaryImplCopyWith<$Res> {
  __$$ListSummaryImplCopyWithImpl(
<<<<<<< HEAD
    _$ListSummaryImpl _value,
    $Res Function(_$ListSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
=======
      _$ListSummaryImpl _value, $Res Function(_$ListSummaryImpl) _then)
      : super(_value, _then);

>>>>>>> 88d3438 (good progress)
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? valueType = null,
<<<<<<< HEAD
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? memberCount = null,
    Object? ownRank = freezed,
  }) {
    return _then(
      _$ListSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        valueType: null == valueType
            ? _value.valueType
            : valueType // ignore: cast_nullable_to_non_nullable
                  as ValueType,
        rankOrder: null == rankOrder
            ? _value.rankOrder
            : rankOrder // ignore: cast_nullable_to_non_nullable
                  as RankOrder,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        ownRank: freezed == ownRank
            ? _value.ownRank
            : ownRank // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
=======
    Object? memberCount = null,
    Object? ownRank = freezed,
  }) {
    return _then(_$ListSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      valueType: null == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as ValueType,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      ownRank: freezed == ownRank
          ? _value.ownRank
          : ownRank // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
>>>>>>> 88d3438 (good progress)
  }
}

/// @nodoc

class _$ListSummaryImpl implements _ListSummary {
<<<<<<< HEAD
  const _$ListSummaryImpl({
    required this.id,
    required this.title,
    required this.valueType,
    required this.rankOrder,
    required this.isPublic,
    required this.memberCount,
    this.ownRank,
  });
=======
  const _$ListSummaryImpl(
      {required this.id,
      required this.title,
      required this.valueType,
      required this.memberCount,
      this.ownRank});
>>>>>>> 88d3438 (good progress)

  @override
  final String id;
  @override
  final String title;
  @override
  final ValueType valueType;
  @override
<<<<<<< HEAD
  final RankOrder rankOrder;
  @override
  final bool isPublic;
  @override
=======
>>>>>>> 88d3438 (good progress)
  final int memberCount;
  @override
  final int? ownRank;

  @override
  String toString() {
<<<<<<< HEAD
    return 'ListSummary(id: $id, title: $title, valueType: $valueType, rankOrder: $rankOrder, isPublic: $isPublic, memberCount: $memberCount, ownRank: $ownRank)';
=======
    return 'ListSummary(id: $id, title: $title, valueType: $valueType, memberCount: $memberCount, ownRank: $ownRank)';
>>>>>>> 88d3438 (good progress)
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.valueType, valueType) ||
                other.valueType == valueType) &&
<<<<<<< HEAD
            (identical(other.rankOrder, rankOrder) ||
                other.rankOrder == rankOrder) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
=======
>>>>>>> 88d3438 (good progress)
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.ownRank, ownRank) || other.ownRank == ownRank));
  }

  @override
<<<<<<< HEAD
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    valueType,
    rankOrder,
    isPublic,
    memberCount,
    ownRank,
  );

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  int get hashCode =>
      Object.hash(runtimeType, id, title, valueType, memberCount, ownRank);

  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  @override
  @pragma('vm:prefer-inline')
  _$$ListSummaryImplCopyWith<_$ListSummaryImpl> get copyWith =>
      __$$ListSummaryImplCopyWithImpl<_$ListSummaryImpl>(this, _$identity);
}

abstract class _ListSummary implements ListSummary {
<<<<<<< HEAD
  const factory _ListSummary({
    required final String id,
    required final String title,
    required final ValueType valueType,
    required final RankOrder rankOrder,
    required final bool isPublic,
    required final int memberCount,
    final int? ownRank,
  }) = _$ListSummaryImpl;
=======
  const factory _ListSummary(
      {required final String id,
      required final String title,
      required final ValueType valueType,
      required final int memberCount,
      final int? ownRank}) = _$ListSummaryImpl;
>>>>>>> 88d3438 (good progress)

  @override
  String get id;
  @override
  String get title;
  @override
  ValueType get valueType;
  @override
<<<<<<< HEAD
  RankOrder get rankOrder;
  @override
  bool get isPublic;
  @override
  int get memberCount;
  @override
  int? get ownRank;

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  int get memberCount;
  @override
  int? get ownRank;
  @override
  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  _$$ListSummaryImplCopyWith<_$ListSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ListMember {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  MemberRole get role => throw _privateConstructorUsedError;

<<<<<<< HEAD
  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  $ListMemberCopyWith<ListMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListMemberCopyWith<$Res> {
  factory $ListMemberCopyWith(
<<<<<<< HEAD
    ListMember value,
    $Res Function(ListMember) then,
  ) = _$ListMemberCopyWithImpl<$Res, ListMember>;
=======
          ListMember value, $Res Function(ListMember) then) =
      _$ListMemberCopyWithImpl<$Res, ListMember>;
>>>>>>> 88d3438 (good progress)
  @useResult
  $Res call({String userId, String displayName, MemberRole role});
}

/// @nodoc
class _$ListMemberCopyWithImpl<$Res, $Val extends ListMember>
    implements $ListMemberCopyWith<$Res> {
  _$ListMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

<<<<<<< HEAD
  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
=======
>>>>>>> 88d3438 (good progress)
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
  }) {
<<<<<<< HEAD
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as MemberRole,
          )
          as $Val,
    );
=======
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MemberRole,
    ) as $Val);
>>>>>>> 88d3438 (good progress)
  }
}

/// @nodoc
abstract class _$$ListMemberImplCopyWith<$Res>
    implements $ListMemberCopyWith<$Res> {
  factory _$$ListMemberImplCopyWith(
<<<<<<< HEAD
    _$ListMemberImpl value,
    $Res Function(_$ListMemberImpl) then,
  ) = __$$ListMemberImplCopyWithImpl<$Res>;
=======
          _$ListMemberImpl value, $Res Function(_$ListMemberImpl) then) =
      __$$ListMemberImplCopyWithImpl<$Res>;
>>>>>>> 88d3438 (good progress)
  @override
  @useResult
  $Res call({String userId, String displayName, MemberRole role});
}

/// @nodoc
class __$$ListMemberImplCopyWithImpl<$Res>
    extends _$ListMemberCopyWithImpl<$Res, _$ListMemberImpl>
    implements _$$ListMemberImplCopyWith<$Res> {
  __$$ListMemberImplCopyWithImpl(
<<<<<<< HEAD
    _$ListMemberImpl _value,
    $Res Function(_$ListMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
=======
      _$ListMemberImpl _value, $Res Function(_$ListMemberImpl) _then)
      : super(_value, _then);

>>>>>>> 88d3438 (good progress)
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
  }) {
<<<<<<< HEAD
    return _then(
      _$ListMemberImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as MemberRole,
      ),
    );
=======
    return _then(_$ListMemberImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MemberRole,
    ));
>>>>>>> 88d3438 (good progress)
  }
}

/// @nodoc

class _$ListMemberImpl implements _ListMember {
<<<<<<< HEAD
  const _$ListMemberImpl({
    required this.userId,
    required this.displayName,
    required this.role,
  });
=======
  const _$ListMemberImpl(
      {required this.userId, required this.displayName, required this.role});
>>>>>>> 88d3438 (good progress)

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final MemberRole role;

  @override
  String toString() {
    return 'ListMember(userId: $userId, displayName: $displayName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListMemberImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, displayName, role);

<<<<<<< HEAD
  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  @override
  @pragma('vm:prefer-inline')
  _$$ListMemberImplCopyWith<_$ListMemberImpl> get copyWith =>
      __$$ListMemberImplCopyWithImpl<_$ListMemberImpl>(this, _$identity);
}

abstract class _ListMember implements ListMember {
<<<<<<< HEAD
  const factory _ListMember({
    required final String userId,
    required final String displayName,
    required final MemberRole role,
  }) = _$ListMemberImpl;
=======
  const factory _ListMember(
      {required final String userId,
      required final String displayName,
      required final MemberRole role}) = _$ListMemberImpl;
>>>>>>> 88d3438 (good progress)

  @override
  String get userId;
  @override
  String get displayName;
  @override
  MemberRole get role;
<<<<<<< HEAD

  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
=======
  @override
  @JsonKey(ignore: true)
>>>>>>> 88d3438 (good progress)
  _$$ListMemberImplCopyWith<_$ListMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
