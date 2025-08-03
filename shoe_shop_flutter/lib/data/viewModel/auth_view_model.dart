import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoe_shop_flutter/data/model/user_account_model.dart';
import '../repository/auth_repository.dart';


class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  String? _userId;
  String? get userId => _userId;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  UserAccount? _userAccount;

  UserAccount? get userAccount => _userAccount;


  Future<void> checkLogin() async {
    try {
      final token = await _authRepository.getAccessToken();
      _isLoggedIn = token != null;
      notifyListeners();
    } catch (e) {
      print('Error checking login status: $e');

      _isLoggedIn = false;
      notifyListeners();
    }
  }

  // Đăng nhập
  Future<bool> login(String username, String password) async {
    try {
      final loginResponse = await _authRepository.login(username, password);
      if (loginResponse != null) {
        _isLoggedIn = true;

        _userId = await _authRepository.getUserId();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error during login: $e');

      return false;
    }
  }

  // Đăng ký
  Future<bool> register(String username, String password) async {
    try {
      final success = await _authRepository.register(username, password);
      return success;
    } catch (e) {
      print('Error during registration: $e');

      return false;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _isLoggedIn = false;
      _userId = null;
      _userAccount = null;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> getAccount() async {
    try {
      _userAccount = await _authRepository.getAccount();
      print('Lấy userAccount thành công: $_userAccount'); // 👈 Thêm dòng này
      notifyListeners();
    } catch (e) {
      print('Error during getAccount: $e');
    }
  }
}