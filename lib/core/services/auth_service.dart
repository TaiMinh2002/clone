import 'package:dio/dio.dart';
import 'package:instagram/core/models/auth.dart';
import 'package:instagram/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  static String? _accessToken;
  static String? _refreshToken;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      contentType: 'application/json',
    ),
  );

  AuthService() {
    _loadTokens();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 && _refreshToken != null) {
            try {
              // ignore: inference_failure_on_function_invocation
              final refreshResponse = await _dio.post(
                '/auth/refresh',
                data: {'refreshToken': _refreshToken},
              );
              if (refreshResponse.statusCode == 200) {
                final data = refreshResponse.data as Map<String, dynamic>;
                _accessToken = data['accessToken'] as String?;
                _refreshToken = data['refreshToken'] as String?;
                error.requestOptions.headers['Authorization'] =
                    'Bearer $_accessToken';
                final opts = Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                );
                // ignore: inference_failure_on_function_invocation
                final cloneReq = await _dio.request(
                  error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                return handler.resolve(cloneReq);
              }
            } catch (e) {
              _accessToken = null;
              _refreshToken = null;
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);
  }

  Future<void> _saveTokens(String? accessToken, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    if (accessToken != null) {
      await prefs.setString(_accessTokenKey, accessToken);
      _accessToken = accessToken;
    }
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
      _refreshToken = refreshToken;
    }
  }

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
        _accessToken = userData['accessToken']?.toString();
        _refreshToken = userData['refreshToken']?.toString();
        await _saveTokens(_accessToken, _refreshToken);
        return Auth(
          success: true,
          data: AuthData(
            user: User(
              id: userData['id'] as int?,
              email: userData['email'] as String?,
              username: userData['username'] as String?,
              password: userData['password'] as String?,
              image: userData['image'] as String?,
            ),
            accessToken: _accessToken ?? '',
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
        _accessToken = userData['accessToken'] as String?;
        _refreshToken = userData['refreshToken'] as String?;
        await _saveTokens(_accessToken, _refreshToken);
        return Auth(
          success: true,
          data: AuthData(
            user: User(
              id: userData['id'] as int?,
              email: userData['email'] as String?,
              username: userData['username'] as String?,
              password: password,
              image: userData['image'] as String?,
            ),
            accessToken: _accessToken ?? '',
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
        errorMsg = e.response!.data['message'];
      }
      return Auth(success: false, message: errorMsg);
    } catch (e) {
      return Auth(success: false, message: e.toString());
    }
  }
}
