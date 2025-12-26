import 'package:json_annotation/json_annotation.dart';
import 'package:stockc/data/models/user_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class AutoLoginResponse {
  final UserModel account;
  final String token;

  AutoLoginResponse({required this.account, required this.token});

  factory AutoLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$AutoLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AutoLoginResponseToJson(this);
}
