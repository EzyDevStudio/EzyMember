import 'package:dio/dio.dart';

class LoginApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://ezymember.ezymember.com.my/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/ezymember123/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      } else {
        throw Exception('Network error occurred');
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}