import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shoe_shop_flutter/data/repository/user_repository.dart';

import '../model/user_model.dart';

class UserViewModel extends ChangeNotifier {

  final UserRepository _repository;

  UserViewModel(this._repository);

  User? user;


  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      await _repository.changePassword(oldPassword, newPassword);
      return true;
    } catch (e) {
      print('Error change password: $e');
      return false;
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final url = await _repository.uploadProfileImage(imageFile);
      return url;
    } catch (e) {
      print('Error upload profile image: $e');
      return null;
    }
  }

  Future<bool> updateUser(String username, String profileImage) async {
    try {
      await _repository.updateUser(username, profileImage);
      return true;
    } catch (e) {
      print('Error update user: $e');
      return false;
    }
  }

  Future<User?> getUser() async {
    try {
      user = await _repository.getUser();
      notifyListeners();
      return user;
    } catch (e) {
      print('Error during getAccount: $e');
      return null;
    }
  }
}