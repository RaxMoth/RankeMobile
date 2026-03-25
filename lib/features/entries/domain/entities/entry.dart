import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';

<<<<<<< HEAD
@freezed
class RankedEntry with _$RankedEntry {
  const factory RankedEntry({
    required String id,
    required String userId,
    required String displayName,
    required int rank,
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    int? manualRank,
    String? note,
    required DateTime submittedAt,
  }) = _RankedEntry;
}

=======
/// Input model for submitting an entry
>>>>>>> 88d3438 (good progress)
@freezed
class EntryInput with _$EntryInput {
  const factory EntryInput({
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    String? note,
  }) = _EntryInput;
}
