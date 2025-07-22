import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoe_shop_flutter/data/model/user_account_model.dart';

import '../model/login_response.dart';
import '../source/auth_source.dart';


abstract class AuthRepository {
  Future<LoginResponse?> login(String username, String password);
  Future<bool> register(String username, String password);
  Future<void> logout();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getUserId();
  Future<UserAccount?> getAccount();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthSource _authDataSource;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<LoginResponse?> login(String username, String password) async {
    final loginResponse = await _authDataSource.login(username, password);
    if (loginResponse != null) {
      await _secureStorage.write(
          key: 'access_token', value: loginResponse.accessToken);
      await _secureStorage.write(
          key: 'refresh_token', value: loginResponse.refreshToken);
      await _secureStorage.write(
          key: 'user_name', value: loginResponse.username);
      await _secureStorage.write(
          key: 'user_id', value: loginResponse.id.toString());
    }
    return loginResponse;
  }

  @override
  Future<bool> register(String username, String password) async {
    try {
      return await _authDataSource.register(username, password);
    } catch (e) {
      print('Error in AuthRepositoryImpl.register: $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken != null) {
        await _authDataSource.logout(refreshToken);
      }
      await _secureStorage.deleteAll(); // Có thể dùng cách này nếu muốn xoá sạch
    } catch (e) {
      print('Logout error: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: 'access_token');
    } catch (e) {
      print('Get access token failed: $e');
      return null;
    }
  }
  @override
  Future<String?> getRefreshToken() async {
    try{
      return await _secureStorage.read(key: 'refresh_token');
    }catch (e){
      print('Get refresh token failed: $e');
      return null;
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: 'user_id');
    }catch(e){
      print('Get userId failed: $e');
      return null;
    }
  }

  @override
  Future<UserAccount?> getAccount() async {
    try {
      return await _authDataSource.getAccount();
    } catch (e) {
      print('Get account failed: $e');
      return null;
    }
  }
}