import 'dart:io';

import '../model/user_model.dart';
import '../source/user_source.dart';

abstract class UserRepository {
  Future<void> changePassword(String oldPassword,String newPassword);
  Future<String> uploadProfileImage(File imageFile);
  Future<bool> updateUser(String username, String profileImage);
  Future<User?> getUser();
}
class UserRepositoryImpl implements UserRepository {

  final UserSource _userSource;
  UserRepositoryImpl(this._userSource);

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _userSource.changePassword( oldPassword, newPassword);
    } catch (e) {
      print('Error occurred while change password: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final url = await _userSource.uploadProfileImage(imageFile);
      return url;
    } catch (e) {
      print('Error occurred while uploading profile image: $e');
      return "";
    }
  }

  @override
  Future<bool> updateUser(String username, String profileImage) async {
    try {
      await _userSource.updateUser(username,profileImage);
      return true;
    } catch (e) {
      print('Error occurred while updating user: $e');
      return false;
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      return await _userSource.getUser();
    } catch (e) {
      print('Get account failed: $e');
      return null;
    }
  }

}