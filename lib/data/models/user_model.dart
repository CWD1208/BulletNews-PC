import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String username;
  final String? avatar;
  final int? handle;
  final String? language;
  final int bubu_daily_used;
  final int bubu_daily_max;
  final int planb_daily_used;
  final int planb_daily_max;

  UserModel({
    required this.id,
    required this.username,
    this.avatar,
    this.handle,
    this.language,
    this.bubu_daily_used = 0,
    this.bubu_daily_max = 0,
    this.planb_daily_used = 0,
    this.planb_daily_max = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
