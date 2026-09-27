import '../../../core/network/api_client.dart';
import '../../../core/network/api_helpers.dart';
import '../../../core/network/api_paths.dart';

/// Remote data source for authentication API calls.
///
/// Every method returns the **unwrapped** `data` payload from the backend's
/// response envelope (`{ "data": ... }`). Callers should never see the
/// envelope — it's stripped here so repo/use-case layers can treat responses
/// as plain domain JSON.
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Map<String, dynamic>> signInWithApple({
    required String identityToken,
    String? fullName,
  });

  Future<void> logout({String? refreshToken});

  Future<Map<String, dynamic>> refreshToken({required String refreshToken});

  /// The signed-in user (`GET /users/me`).
  Future<Map<String, dynamic>> getMe();

  /// Permanently deletes the signed-in user's account.
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiPaths.authLogin,
      data: {'email': email, 'password': password},
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiPaths.authRegister,
      data: {'email': email, 'password': password, 'displayName': displayName},
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> signInWithApple({
    required String identityToken,
    String? fullName,
  }) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiPaths.authApple,
      data: {'identityToken': identityToken, 'fullName': ?fullName},
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<void> logout({String? refreshToken}) async {
    await _apiClient.dio.post<void>(
      ApiPaths.authLogout,
      data: refreshToken == null ? null : {'refreshToken': refreshToken},
    );
  }

  @override
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiPaths.authRefresh,
      data: {'refreshToken': refreshToken},
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> getMe() async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.usersMe,
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<void> deleteAccount() async {
    await _apiClient.dio.delete<void>(ApiPaths.usersMe);
  }
}
