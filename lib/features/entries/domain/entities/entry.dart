import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';

/// Input model for submitting an entry
@freezed
class EntryInput with _$EntryInput {
  const factory EntryInput({
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    String? note,
  }) = _EntryInput;
}
