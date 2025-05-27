import 'package:dio/dio.dart';
import 'package:instagram/core/models/user.dart';
import 'package:instagram/core/services/auth_service.dart';

class ProfileService {
  final Dio _dio;

  ProfileService() : _dio = AuthService().dio;

  Future<User> getCurrentUser() async {
    try {
      // ignore: inference_failure_on_function_invocation
      final response = await _dio.get('/user/me');
      if (response.statusCode == 200) {
        return User.fromJson(response.data as Map<String, dynamic>);
      }
      throw Exception('Failed to load user profile');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load user profile');
    }
  }
}
