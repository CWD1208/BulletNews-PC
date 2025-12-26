// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutoLoginResponse _$AutoLoginResponseFromJson(Map<String, dynamic> json) =>
    AutoLoginResponse(
      account: UserModel.fromJson(json['account'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$AutoLoginResponseToJson(AutoLoginResponse instance) =>
    <String, dynamic>{'account': instance.account, 'token': instance.token};
