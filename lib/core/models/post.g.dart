// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  reactions: Reactions.fromJson(json['reactions'] as Map<String, dynamic>),
  views: (json['views'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'tags': instance.tags,
      'reactions': instance.reactions,
      'views': instance.views,
      'userId': instance.userId,
    };

_$ReactionsImpl _$$ReactionsImplFromJson(Map<String, dynamic> json) =>
    _$ReactionsImpl(
      likes: (json['likes'] as num).toInt(),
      dislikes: (json['dislikes'] as num).toInt(),
    );

Map<String, dynamic> _$$ReactionsImplToJson(_$ReactionsImpl instance) =>
    <String, dynamic>{'likes': instance.likes, 'dislikes': instance.dislikes};
