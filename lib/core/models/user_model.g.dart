// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      profilePicture: json['profilePicture'] as String,
      bio: json['bio'] as String,
      followers: (json['followers'] as num).toInt(),
      following: (json['following'] as num).toInt(),
      posts: (json['posts'] as num).toInt(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'fullName': instance.fullName,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
      'followers': instance.followers,
      'following': instance.following,
      'posts': instance.posts,
    };
