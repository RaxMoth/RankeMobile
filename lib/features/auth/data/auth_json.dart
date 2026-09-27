import '../domain/entities/user.dart';

/// JSON ↔ [User] for the backend's user payload (`/users/me`, and `user`
/// inside every auth response). See `test/contract`.
abstract class AuthJson {
  static User user(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
  );

  /// The shape [user] reads — used to cache the signed-in user locally.
  static Map<String, dynamic> userToJson(User user) => {
    'id': user.id,
    'email': user.email,
    'displayName': user.displayName,
    if (user.createdAt != null)
      'createdAt': user.createdAt!.toUtc().toIso8601String(),
  };
}
