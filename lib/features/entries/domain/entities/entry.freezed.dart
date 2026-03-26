// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EntryInput {
  double? get valueNumber => throw _privateConstructorUsedError;
  int? get valueDurationMs => throw _privateConstructorUsedError;
  String? get valueText => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of EntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntryInputCopyWith<EntryInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryInputCopyWith<$Res> {
  factory $EntryInputCopyWith(
    EntryInput value,
    $Res Function(EntryInput) then,
  ) = _$EntryInputCopyWithImpl<$Res, EntryInput>;
  @useResult
  $Res call({
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    String? note,
  });
}

/// @nodoc
class _$EntryInputCopyWithImpl<$Res, $Val extends EntryInput>
    implements $EntryInputCopyWith<$Res> {
  _$EntryInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueNumber = freezed,
    Object? valueDurationMs = freezed,
    Object? valueText = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EntryInputImplCopyWith<$Res>
    implements $EntryInputCopyWith<$Res> {
  factory _$$EntryInputImplCopyWith(
    _$EntryInputImpl value,
    $Res Function(_$EntryInputImpl) then,
  ) = __$$EntryInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    String? note,
  });
}

/// @nodoc
class __$$EntryInputImplCopyWithImpl<$Res>
    extends _$EntryInputCopyWithImpl<$Res, _$EntryInputImpl>
    implements _$$EntryInputImplCopyWith<$Res> {
  __$$EntryInputImplCopyWithImpl(
    _$EntryInputImpl _value,
    $Res Function(_$EntryInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EntryInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valueNumber = freezed,
    Object? valueDurationMs = freezed,
    Object? valueText = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _$EntryInputImpl(
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
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$EntryInputImpl implements _EntryInput {
  const _$EntryInputImpl({
    this.valueNumber,
    this.valueDurationMs,
    this.valueText,
    this.note,
  });

  @override
  final double? valueNumber;
  @override
  final int? valueDurationMs;
  @override
  final String? valueText;
  @override
  final String? note;

  @override
  String toString() {
    return 'EntryInput(valueNumber: $valueNumber, valueDurationMs: $valueDurationMs, valueText: $valueText, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryInputImpl &&
            (identical(other.valueNumber, valueNumber) ||
                other.valueNumber == valueNumber) &&
            (identical(other.valueDurationMs, valueDurationMs) ||
                other.valueDurationMs == valueDurationMs) &&
            (identical(other.valueText, valueText) ||
                other.valueText == valueText) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, valueNumber, valueDurationMs, valueText, note);

  /// Create a copy of EntryInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryInputImplCopyWith<_$EntryInputImpl> get copyWith =>
      __$$EntryInputImplCopyWithImpl<_$EntryInputImpl>(this, _$identity);
}

abstract class _EntryInput implements EntryInput {
  const factory _EntryInput({
    final double? valueNumber,
    final int? valueDurationMs,
    final String? valueText,
    final String? note,
  }) = _$EntryInputImpl;

  @override
  double? get valueNumber;
  @override
  int? get valueDurationMs;
  @override
  String? get valueText;
  @override
  String? get note;

  /// Create a copy of EntryInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntryInputImplCopyWith<_$EntryInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
