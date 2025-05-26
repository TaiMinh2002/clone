import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:instagram/r.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService();

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    final response = await rootBundle.loadString(AssetJsons.signUp);
    final data = json.decode(response) as Map<String, dynamic>;

    if (email.isEmpty || password.isEmpty) {
      return const AuthResponse(
        success: false,
        data: AuthData(
          user: User(
            id: '',
            email: '',
            username: '',
            fullName: '',
            profilePicture: '',
            bio: '',
            followers: 0,
            following: 0,
            posts: 0,
          ),
          token: '',
        ),
        message: 'Vui lòng nhập email và mật khẩu',
      );
    }

    if (email != data['data']['user']['email']) {
      return const AuthResponse(
        success: false,
        data: AuthData(
          user: User(
            id: '',
            email: '',
            username: '',
            fullName: '',
            profilePicture: '',
            bio: '',
            followers: 0,
            following: 0,
            posts: 0,
          ),
          token: '',
        ),
        message: 'Email hoặc mật khẩu không đúng',
      );
    }

    return AuthResponse.fromJson(data);
  }
}
