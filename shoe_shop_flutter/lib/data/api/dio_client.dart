import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/app_constants.dart';

class DioClient {
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static Dio? _dio;

  static Future<Dio> getDio() async {
    if (_dio != null) return _dio!;

    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },

      onError: (error, handler) async {
        final responseData = error.response?.data;
        final refreshToken = await _secureStorage.read(key: 'refresh_token');

        bool isTokenExpired = responseData != null &&
            responseData is Map<String, dynamic> &&
            responseData['EM'] == "Token has expired.";

        if (error.response?.statusCode == 401 && isTokenExpired) {
          try {
            final newToken = await _refreshAccessToken(refreshToken);

            if (newToken != null) {
              await _secureStorage.write(key: 'access_token', value: newToken);

              print("Goi lai accessToken thanh cong");

              final requestOptions = error.requestOptions;
              requestOptions.headers['Authorization'] = 'Bearer $newToken';

              final clonedResponse = await _dio!.fetch(requestOptions);
              return handler.resolve(clonedResponse);
            } else {
              // Xoá token & logout nếu refresh token cũng hết hạn
              await _secureStorage.deleteAll();
              return handler.reject(error);
            }
          } catch (e) {
            return handler.reject(error);
          }
        }

        return handler.reject(error);
      },
    ));

    return _dio!;
  }

  static Future<String?> _refreshAccessToken(String? refreshToken) async {
    if (refreshToken == null) return null;

    try {
      final response = await Dio().post(
        '${AppConstants.baseUrl}/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['EC'] == 0) {
          return data['DT']['accessToken'];
        }
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }

    return null;
  }
}
