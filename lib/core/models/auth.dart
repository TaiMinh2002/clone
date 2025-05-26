import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:instagram/core/models/user.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class Auth with _$Auth {
  const factory Auth({
    required bool success,
    AuthData? data,
    required String message,
  }) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
}

@freezed
class AuthData with _$AuthData {
  const factory AuthData({required User? user, required String accessToken}) =
      _AuthData;

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);
}
