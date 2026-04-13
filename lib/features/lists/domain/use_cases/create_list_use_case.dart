import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entities/ranked_list.dart';
import '../lists_repository.dart';

class CreateListUseCase {
  final ListsRepository _repository;

  CreateListUseCase(this._repository);

  Future<Either<ApiError, RankedList>> call({
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
    String? category,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) {
    return _repository.createList(
      title: title,
      description: description,
      valueType: valueType,
      rankOrder: rankOrder,
      isPublic: isPublic,
      category: category,
      telegramLink: telegramLink,
      whatsappLink: whatsappLink,
      discordLink: discordLink,
    );
  }
}
