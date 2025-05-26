import 'dart:convert';
import 'package:flutter/services.dart';
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

    // Load mock data from JSON file
    final response = await rootBundle.loadString('assets/jsons/sign_up.json');
    final data = json.decode(response) as Map<String, dynamic>;

    // Validation
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

    // Check if email matches the mock data
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

    // For demo purposes, we'll accept any password
    return AuthResponse.fromJson(data);
  }
}
