import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entities/ranked_list.dart';
import '../lists_repository.dart';

class GetInvitePreviewUseCase {
  final ListsRepository _repository;

  GetInvitePreviewUseCase(this._repository);

  Future<Either<ApiError, RankedList>> call(String token) {
    return _repository.getInvitePreview(token);
  }
}
