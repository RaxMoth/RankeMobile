import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String displayName,
<<<<<<< HEAD
    required DateTime createdAt,
=======
    DateTime? createdAt,
>>>>>>> 88d3438 (good progress)
  }) = _User;
}
