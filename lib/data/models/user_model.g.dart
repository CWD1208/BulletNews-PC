// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  avatar: json['avatar'] as String?,
  handle: (json['handle'] as num?)?.toInt(),
  language: json['language'] as String?,
  bubu_daily_used: (json['bubu_daily_used'] as num?)?.toInt() ?? 0,
  bubu_daily_max: (json['bubu_daily_max'] as num?)?.toInt() ?? 0,
  planb_daily_used: (json['planb_daily_used'] as num?)?.toInt() ?? 0,
  planb_daily_max: (json['planb_daily_max'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatar': instance.avatar,
  'handle': instance.handle,
  'language': instance.language,
  'bubu_daily_used': instance.bubu_daily_used,
  'bubu_daily_max': instance.bubu_daily_max,
  'planb_daily_used': instance.planb_daily_used,
  'planb_daily_max': instance.planb_daily_max,
};
