import 'dart:io';
import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../api/dio_client.dart';
import '../model/user_model.dart';

abstract class DataSource {
  Future<void> changePassword(String oldPassword,String newPassword);
  Future<String> uploadProfileImage(File imageFile);
  Future<bool> updateUser(String username, String profileImage);
  Future<User?> getUser();
}

class UserSource implements DataSource {

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final String url = '${AppConstants.changePasswordEndpoint}';

      final dio = await DioClient.getDio();

      final response = await dio.patch(
        url,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['EC'] == 0) {
          print('Change password successful');
        } else {
          print('Change password failed: ${body['EM']}');
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  @override
  Future<bool> updateUser(String username, String profileImage) async {
    final String url = '${AppConstants.updateUserEndpoint}';

    final dio = await DioClient.getDio();

    try {
      final response = await dio.put(
        url,
        data: {
          "username": username,
          "profile_image": profileImage,
        },
      );

      if (response.statusCode == 200) {
        print("Updated user successfully");
        return true;
      } else {
        print("Update user failed ");
        return false;
      }
    } catch (e) {
      print("Dio error: $e");
      return false;
    }
  }


  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final String url = '${AppConstants.uploadProfileImageEndpoint}';

      final dio = await DioClient.getDio();

      final fileName = imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        'profile_image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body['url'] != null) {
          return body['url']; // ✅ Trả về URL ảnh mới
        } else {
          throw Exception('Upload failed: ${body['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      final String url = '${AppConstants.baseUrl}${AppConstants.getUserEndpoint}';

      final dio = await DioClient.getDio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['EC'] == 0) {
          final user = data['DT'] as Map<String, dynamic>;
          return User.fromJson(user);
        } else {
          print("Get user failed: ${data['EM']}");
          return null;
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }
}