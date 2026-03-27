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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RankedList {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ValueType get valueType => throw _privateConstructorUsedError;
  RankOrder get rankOrder => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  bool get locked => throw _privateConstructorUsedError;
  String? get inviteToken => throw _privateConstructorUsedError;
  List<RankedEntry> get entries => throw _privateConstructorUsedError;
  List<RankedEntry> get pendingEntries => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  MemberRole? get currentUserRole => throw _privateConstructorUsedError;
  String? get telegramLink => throw _privateConstructorUsedError;
  String? get whatsappLink => throw _privateConstructorUsedError;
  String? get discordLink => throw _privateConstructorUsedError;

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankedListCopyWith<RankedList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankedListCopyWith<$Res> {
  factory $RankedListCopyWith(
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
    bool locked,
    String? inviteToken,
    List<RankedEntry> entries,
    List<RankedEntry> pendingEntries,
    int memberCount,
    MemberRole? currentUserRole,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  });
}

/// @nodoc
class _$RankedListCopyWithImpl<$Res, $Val extends RankedList>
    implements $RankedListCopyWith<$Res> {
  _$RankedListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? valueType = null,
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? locked = null,
    Object? inviteToken = freezed,
    Object? entries = null,
    Object? pendingEntries = null,
    Object? memberCount = null,
    Object? currentUserRole = freezed,
    Object? telegramLink = freezed,
    Object? whatsappLink = freezed,
    Object? discordLink = freezed,
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
            locked: null == locked
                ? _value.locked
                : locked // ignore: cast_nullable_to_non_nullable
                      as bool,
            inviteToken: freezed == inviteToken
                ? _value.inviteToken
                : inviteToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<RankedEntry>,
            pendingEntries: null == pendingEntries
                ? _value.pendingEntries
                : pendingEntries // ignore: cast_nullable_to_non_nullable
                      as List<RankedEntry>,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
            currentUserRole: freezed == currentUserRole
                ? _value.currentUserRole
                : currentUserRole // ignore: cast_nullable_to_non_nullable
                      as MemberRole?,
            telegramLink: freezed == telegramLink
                ? _value.telegramLink
                : telegramLink // ignore: cast_nullable_to_non_nullable
                      as String?,
            whatsappLink: freezed == whatsappLink
                ? _value.whatsappLink
                : whatsappLink // ignore: cast_nullable_to_non_nullable
                      as String?,
            discordLink: freezed == discordLink
                ? _value.discordLink
                : discordLink // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RankedListImplCopyWith<$Res>
    implements $RankedListCopyWith<$Res> {
  factory _$$RankedListImplCopyWith(
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
    bool locked,
    String? inviteToken,
    List<RankedEntry> entries,
    List<RankedEntry> pendingEntries,
    int memberCount,
    MemberRole? currentUserRole,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  });
}

/// @nodoc
class __$$RankedListImplCopyWithImpl<$Res>
    extends _$RankedListCopyWithImpl<$Res, _$RankedListImpl>
    implements _$$RankedListImplCopyWith<$Res> {
  __$$RankedListImplCopyWithImpl(
    _$RankedListImpl _value,
    $Res Function(_$RankedListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? valueType = null,
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? locked = null,
    Object? inviteToken = freezed,
    Object? entries = null,
    Object? pendingEntries = null,
    Object? memberCount = null,
    Object? currentUserRole = freezed,
    Object? telegramLink = freezed,
    Object? whatsappLink = freezed,
    Object? discordLink = freezed,
  }) {
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
        locked: null == locked
            ? _value.locked
            : locked // ignore: cast_nullable_to_non_nullable
                  as bool,
        inviteToken: freezed == inviteToken
            ? _value.inviteToken
            : inviteToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<RankedEntry>,
        pendingEntries: null == pendingEntries
            ? _value._pendingEntries
            : pendingEntries // ignore: cast_nullable_to_non_nullable
                  as List<RankedEntry>,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        currentUserRole: freezed == currentUserRole
            ? _value.currentUserRole
            : currentUserRole // ignore: cast_nullable_to_non_nullable
                  as MemberRole?,
        telegramLink: freezed == telegramLink
            ? _value.telegramLink
            : telegramLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        whatsappLink: freezed == whatsappLink
            ? _value.whatsappLink
            : whatsappLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        discordLink: freezed == discordLink
            ? _value.discordLink
            : discordLink // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$RankedListImpl implements _RankedList {
  const _$RankedListImpl({
    required this.id,
    required this.title,
    this.description,
    required this.valueType,
    required this.rankOrder,
    required this.isPublic,
    this.locked = false,
    this.inviteToken,
    required final List<RankedEntry> entries,
    final List<RankedEntry> pendingEntries = const [],
    required this.memberCount,
    this.currentUserRole,
    this.telegramLink,
    this.whatsappLink,
    this.discordLink,
  }) : _entries = entries,
       _pendingEntries = pendingEntries;

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
  @JsonKey()
  final bool locked;
  @override
  final String? inviteToken;
  final List<RankedEntry> _entries;
  @override
  List<RankedEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  final List<RankedEntry> _pendingEntries;
  @override
  @JsonKey()
  List<RankedEntry> get pendingEntries {
    if (_pendingEntries is EqualUnmodifiableListView) return _pendingEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingEntries);
  }

  @override
  final int memberCount;
  @override
  final MemberRole? currentUserRole;
  @override
  final String? telegramLink;
  @override
  final String? whatsappLink;
  @override
  final String? discordLink;

  @override
  String toString() {
    return 'RankedList(id: $id, title: $title, description: $description, valueType: $valueType, rankOrder: $rankOrder, isPublic: $isPublic, locked: $locked, inviteToken: $inviteToken, entries: $entries, pendingEntries: $pendingEntries, memberCount: $memberCount, currentUserRole: $currentUserRole, telegramLink: $telegramLink, whatsappLink: $whatsappLink, discordLink: $discordLink)';
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
            (identical(other.locked, locked) || other.locked == locked) &&
            (identical(other.inviteToken, inviteToken) ||
                other.inviteToken == inviteToken) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            const DeepCollectionEquality().equals(
              other._pendingEntries,
              _pendingEntries,
            ) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.currentUserRole, currentUserRole) ||
                other.currentUserRole == currentUserRole) &&
            (identical(other.telegramLink, telegramLink) ||
                other.telegramLink == telegramLink) &&
            (identical(other.whatsappLink, whatsappLink) ||
                other.whatsappLink == whatsappLink) &&
            (identical(other.discordLink, discordLink) ||
                other.discordLink == discordLink));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    valueType,
    rankOrder,
    isPublic,
    locked,
    inviteToken,
    const DeepCollectionEquality().hash(_entries),
    const DeepCollectionEquality().hash(_pendingEntries),
    memberCount,
    currentUserRole,
    telegramLink,
    whatsappLink,
    discordLink,
  );

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankedListImplCopyWith<_$RankedListImpl> get copyWith =>
      __$$RankedListImplCopyWithImpl<_$RankedListImpl>(this, _$identity);
}

abstract class _RankedList implements RankedList {
  const factory _RankedList({
    required final String id,
    required final String title,
    final String? description,
    required final ValueType valueType,
    required final RankOrder rankOrder,
    required final bool isPublic,
    final bool locked,
    final String? inviteToken,
    required final List<RankedEntry> entries,
    final List<RankedEntry> pendingEntries,
    required final int memberCount,
    final MemberRole? currentUserRole,
    final String? telegramLink,
    final String? whatsappLink,
    final String? discordLink,
  }) = _$RankedListImpl;

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
  bool get locked;
  @override
  String? get inviteToken;
  @override
  List<RankedEntry> get entries;
  @override
  List<RankedEntry> get pendingEntries;
  @override
  int get memberCount;
  @override
  MemberRole? get currentUserRole;
  @override
  String? get telegramLink;
  @override
  String? get whatsappLink;
  @override
  String? get discordLink;

  /// Create a copy of RankedList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankedListImplCopyWith<_$RankedListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
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
  EntryStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of RankedEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankedEntryCopyWith<RankedEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankedEntryCopyWith<$Res> {
  factory $RankedEntryCopyWith(
    RankedEntry value,
    $Res Function(RankedEntry) then,
  ) = _$RankedEntryCopyWithImpl<$Res, RankedEntry>;
  @useResult
  $Res call({
    String id,
    String userId,
    String displayName,
    int rank,
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    int? manualRank,
    String? note,
    DateTime submittedAt,
    EntryStatus status,
  });
}

/// @nodoc
class _$RankedEntryCopyWithImpl<$Res, $Val extends RankedEntry>
    implements $RankedEntryCopyWith<$Res> {
  _$RankedEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankedEntry
  /// with the given fields replaced by the non-null parameter values.
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
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EntryStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RankedEntryImplCopyWith<$Res>
    implements $RankedEntryCopyWith<$Res> {
  factory _$$RankedEntryImplCopyWith(
    _$RankedEntryImpl value,
    $Res Function(_$RankedEntryImpl) then,
  ) = __$$RankedEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String displayName,
    int rank,
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    int? manualRank,
    String? note,
    DateTime submittedAt,
    EntryStatus status,
  });
}

/// @nodoc
class __$$RankedEntryImplCopyWithImpl<$Res>
    extends _$RankedEntryCopyWithImpl<$Res, _$RankedEntryImpl>
    implements _$$RankedEntryImplCopyWith<$Res> {
  __$$RankedEntryImplCopyWithImpl(
    _$RankedEntryImpl _value,
    $Res Function(_$RankedEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankedEntry
  /// with the given fields replaced by the non-null parameter values.
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
    Object? status = null,
  }) {
    return _then(
      _$RankedEntryImpl(
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EntryStatus,
      ),
    );
  }
}

/// @nodoc

class _$RankedEntryImpl implements _RankedEntry {
  const _$RankedEntryImpl({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.rank,
    this.valueNumber,
    this.valueDurationMs,
    this.valueText,
    this.manualRank,
    this.note,
    required this.submittedAt,
    this.status = EntryStatus.approved,
  });

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
  @JsonKey()
  final EntryStatus status;

  @override
  String toString() {
    return 'RankedEntry(id: $id, userId: $userId, displayName: $displayName, rank: $rank, valueNumber: $valueNumber, valueDurationMs: $valueDurationMs, valueText: $valueText, manualRank: $manualRank, note: $note, submittedAt: $submittedAt, status: $status)';
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
                other.submittedAt == submittedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    displayName,
    rank,
    valueNumber,
    valueDurationMs,
    valueText,
    manualRank,
    note,
    submittedAt,
    status,
  );

  /// Create a copy of RankedEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankedEntryImplCopyWith<_$RankedEntryImpl> get copyWith =>
      __$$RankedEntryImplCopyWithImpl<_$RankedEntryImpl>(this, _$identity);
}

abstract class _RankedEntry implements RankedEntry {
  const factory _RankedEntry({
    required final String id,
    required final String userId,
    required final String displayName,
    required final int rank,
    final double? valueNumber,
    final int? valueDurationMs,
    final String? valueText,
    final int? manualRank,
    final String? note,
    required final DateTime submittedAt,
    final EntryStatus status,
  }) = _$RankedEntryImpl;

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
  EntryStatus get status;

  /// Create a copy of RankedEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankedEntryImplCopyWith<_$RankedEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ListSummary {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  ValueType get valueType => throw _privateConstructorUsedError;
  RankOrder get rankOrder => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  int? get ownRank => throw _privateConstructorUsedError;
  MemberRole? get currentUserRole => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListSummaryCopyWith<ListSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListSummaryCopyWith<$Res> {
  factory $ListSummaryCopyWith(
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
    MemberRole? currentUserRole,
    String? category,
  });
}

/// @nodoc
class _$ListSummaryCopyWithImpl<$Res, $Val extends ListSummary>
    implements $ListSummaryCopyWith<$Res> {
  _$ListSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? valueType = null,
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? memberCount = null,
    Object? ownRank = freezed,
    Object? currentUserRole = freezed,
    Object? category = freezed,
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
            currentUserRole: freezed == currentUserRole
                ? _value.currentUserRole
                : currentUserRole // ignore: cast_nullable_to_non_nullable
                      as MemberRole?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ListSummaryImplCopyWith<$Res>
    implements $ListSummaryCopyWith<$Res> {
  factory _$$ListSummaryImplCopyWith(
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
    MemberRole? currentUserRole,
    String? category,
  });
}

/// @nodoc
class __$$ListSummaryImplCopyWithImpl<$Res>
    extends _$ListSummaryCopyWithImpl<$Res, _$ListSummaryImpl>
    implements _$$ListSummaryImplCopyWith<$Res> {
  __$$ListSummaryImplCopyWithImpl(
    _$ListSummaryImpl _value,
    $Res Function(_$ListSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? valueType = null,
    Object? rankOrder = null,
    Object? isPublic = null,
    Object? memberCount = null,
    Object? ownRank = freezed,
    Object? currentUserRole = freezed,
    Object? category = freezed,
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
        currentUserRole: freezed == currentUserRole
            ? _value.currentUserRole
            : currentUserRole // ignore: cast_nullable_to_non_nullable
                  as MemberRole?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ListSummaryImpl implements _ListSummary {
  const _$ListSummaryImpl({
    required this.id,
    required this.title,
    required this.valueType,
    required this.rankOrder,
    required this.isPublic,
    required this.memberCount,
    this.ownRank,
    this.currentUserRole,
    this.category,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final ValueType valueType;
  @override
  final RankOrder rankOrder;
  @override
  final bool isPublic;
  @override
  final int memberCount;
  @override
  final int? ownRank;
  @override
  final MemberRole? currentUserRole;
  @override
  final String? category;

  @override
  String toString() {
    return 'ListSummary(id: $id, title: $title, valueType: $valueType, rankOrder: $rankOrder, isPublic: $isPublic, memberCount: $memberCount, ownRank: $ownRank, currentUserRole: $currentUserRole, category: $category)';
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
            (identical(other.rankOrder, rankOrder) ||
                other.rankOrder == rankOrder) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.ownRank, ownRank) || other.ownRank == ownRank) &&
            (identical(other.currentUserRole, currentUserRole) ||
                other.currentUserRole == currentUserRole) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    valueType,
    rankOrder,
    isPublic,
    memberCount,
    ownRank,
    currentUserRole,
    category,
  );

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListSummaryImplCopyWith<_$ListSummaryImpl> get copyWith =>
      __$$ListSummaryImplCopyWithImpl<_$ListSummaryImpl>(this, _$identity);
}

abstract class _ListSummary implements ListSummary {
  const factory _ListSummary({
    required final String id,
    required final String title,
    required final ValueType valueType,
    required final RankOrder rankOrder,
    required final bool isPublic,
    required final int memberCount,
    final int? ownRank,
    final MemberRole? currentUserRole,
    final String? category,
  }) = _$ListSummaryImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  ValueType get valueType;
  @override
  RankOrder get rankOrder;
  @override
  bool get isPublic;
  @override
  int get memberCount;
  @override
  int? get ownRank;
  @override
  MemberRole? get currentUserRole;
  @override
  String? get category;

  /// Create a copy of ListSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListSummaryImplCopyWith<_$ListSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ListMember {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  MemberRole get role => throw _privateConstructorUsedError;

  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListMemberCopyWith<ListMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListMemberCopyWith<$Res> {
  factory $ListMemberCopyWith(
    ListMember value,
    $Res Function(ListMember) then,
  ) = _$ListMemberCopyWithImpl<$Res, ListMember>;
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

  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
  }) {
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
  }
}

/// @nodoc
abstract class _$$ListMemberImplCopyWith<$Res>
    implements $ListMemberCopyWith<$Res> {
  factory _$$ListMemberImplCopyWith(
    _$ListMemberImpl value,
    $Res Function(_$ListMemberImpl) then,
  ) = __$$ListMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String displayName, MemberRole role});
}

/// @nodoc
class __$$ListMemberImplCopyWithImpl<$Res>
    extends _$ListMemberCopyWithImpl<$Res, _$ListMemberImpl>
    implements _$$ListMemberImplCopyWith<$Res> {
  __$$ListMemberImplCopyWithImpl(
    _$ListMemberImpl _value,
    $Res Function(_$ListMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
  }) {
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
  }
}

/// @nodoc

class _$ListMemberImpl implements _ListMember {
  const _$ListMemberImpl({
    required this.userId,
    required this.displayName,
    required this.role,
  });

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

  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListMemberImplCopyWith<_$ListMemberImpl> get copyWith =>
      __$$ListMemberImplCopyWithImpl<_$ListMemberImpl>(this, _$identity);
}

abstract class _ListMember implements ListMember {
  const factory _ListMember({
    required final String userId,
    required final String displayName,
    required final MemberRole role,
  }) = _$ListMemberImpl;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  MemberRole get role;

  /// Create a copy of ListMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListMemberImplCopyWith<_$ListMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
