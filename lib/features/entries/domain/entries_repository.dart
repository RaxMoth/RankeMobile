import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import 'entities/entry.dart';

abstract class EntriesRepository {
  Future<Either<ApiError, RankedEntry>> submitEntry({
    required String listId,
    required EntryInput input,
  });
}
