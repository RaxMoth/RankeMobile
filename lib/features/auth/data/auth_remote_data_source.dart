<<<<<<< HEAD
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRemoteDataSource(this._apiClient, this._secureStorage);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    await _saveTokens(response.data);
    return response.data['user'] as Map<String, dynamic>;
  }
=======
import '../../../core/network/api_client.dart';

/// Remote data source for authentication API calls
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
>>>>>>> 88d3438 (good progress)

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
<<<<<<< HEAD
  }) async {
    final response = await _apiClient.dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'displayName': displayName,
      },
    );
    await _saveTokens(response.data);
    return response.data['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> appleSignIn({
    required String identityToken,
    String? fullName,
  }) async {
    final response = await _apiClient.dio.post(
      '/auth/apple',
      data: {
        'identityToken': identityToken,
        if (fullName != null) 'fullName': fullName,
      },
    );
    await _saveTokens(response.data);
    return response.data['user'] as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await _apiClient.dio.post('/auth/logout');
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _apiClient.dio.get('/auth/me');
    return response.data as Map<String, dynamic>;
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    await _secureStorage.write(
      key: AppConstants.accessTokenKey,
      value: accessToken,
    );
    await _secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: refreshToken,
    );
=======
  });

  Future<Map<String, dynamic>> signInWithApple({
    required String identityToken,
  });

  Future<void> logout();

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await _apiClient.dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'display_name': displayName,
    });
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> signInWithApple({
    required String identityToken,
  }) async {
    final response = await _apiClient.dio.post('/auth/apple', data: {
      'identity_token': identityToken,
    });
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await _apiClient.dio.post('/auth/logout');
  }

  @override
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await _apiClient.dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    return response.data as Map<String, dynamic>;
>>>>>>> 88d3438 (good progress)
  }
}
