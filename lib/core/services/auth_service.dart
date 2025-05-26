import 'package:dio/dio.dart';
import 'package:instagram/core/models/auth.dart';
import 'package:instagram/core/models/user.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      contentType: 'application/json',
    ),
  );

  Future<Auth> signUp({
    required String username,
    required String password,
  }) async {
    try {
      // ignore: inference_failure_on_function_invocation
      final response = await _dio.post(
        '/users/add',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data as Map<String, dynamic>;
        return Auth(
          success: true,
          data: AuthData(
            user: User(
              id: userData['id'] as int,
              email: userData['email'] as String,
              username: userData['username'] as String,
              password: userData['password'] as String,
              image: userData['image'] as String,
            ),
            accessToken: userData['accessToken']?.toString() ?? '',
          ),
          message: 'Sign up successful',
        );
      } else {
        return const Auth(success: false, message: 'Sign up failed');
      }
    } catch (e) {
      return Auth(success: false, message: e.toString());
    }
  }

  Future<Auth> signIn({
    required String username,
    required String password,
  }) async {
    try {
      // ignore: inference_failure_on_function_invocation
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final userData = response.data as Map<String, dynamic>;
        return Auth(
          success: true,
          data: AuthData(
            user: User(
              username: userData['username'] as String,
              password: password,
            ),
            accessToken: userData['accessToken'] as String,
          ),
          message: 'Sign in successful',
        );
      } else {
        return const Auth(success: false, message: 'Sign in failed');
      }
    } on DioException catch (e) {
      var errorMsg = 'Sign in failed';
      // ignore: avoid_dynamic_calls
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        // ignore: avoid_dynamic_calls
        errorMsg = e.response!.data['message'];
      }
      return Auth(success: false, message: errorMsg);
    } catch (e) {
      return Auth(success: false, message: e.toString());
    }
  }
}
