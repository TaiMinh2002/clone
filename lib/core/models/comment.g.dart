// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: (json['id'] as num).toInt(),
      body: json['body'] as String,
      postId: (json['postId'] as num).toInt(),
      likes: (json['likes'] as num).toInt(),
      user: UserComment.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'postId': instance.postId,
      'likes': instance.likes,
      'user': instance.user,
    };

_$UserCommentImpl _$$UserCommentImplFromJson(Map<String, dynamic> json) =>
    _$UserCommentImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$$UserCommentImplToJson(_$UserCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
    };
