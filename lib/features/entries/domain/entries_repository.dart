import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import '../../lists/domain/entities/ranked_list.dart';
import 'entities/entry.dart';

/// Entries and their moderation. Moderation is always on: a submitted
/// entry waits in the board's review queue until an owner, admin or
/// moderator approves it.
abstract class EntriesRepository {
  /// Queues the caller's entry for review (replacing a pending one) and
  /// returns the pending submission. Their approved entry, if any, stays on
  /// the board meanwhile.
  Future<Either<ApiError, Submission>> submitEntry({
    required String listId,
    required EntryInput input,
  });

  /// Deletes the caller's own entry and withdraws a pending submission.
  Future<Either<ApiError, void>> deleteMyEntry(String listId);

  /// The board's review queue, oldest first (owner/admin/moderator).
  Future<Either<ApiError, List<Submission>>> getPendingSubmissions(
    String listId,
  );

  Future<Either<ApiError, void>> approveSubmission({
    required String listId,
    required String submissionId,
  });

  Future<Either<ApiError, void>> rejectSubmission({
    required String listId,
    required String submissionId,
  });
}
