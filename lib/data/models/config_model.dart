import 'package:json_annotation/json_annotation.dart';

part 'config_model.g.dart';

/// 推广链接模型
@JsonSerializable()
class PromotionLink {
  final String name;
  final List<String> links;

  PromotionLink({required this.name, required this.links});

  factory PromotionLink.fromJson(Map<String, dynamic> json) =>
      _$PromotionLinkFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionLinkToJson(this);
}

/// 百分比设置模型
@JsonSerializable()
class PercentageSetting {
  final int ios;
  final int android;
  @JsonKey(name: 'ios_url')
  final String? iosUrl;
  @JsonKey(name: 'android_url')
  final String? androidUrl;

  PercentageSetting({
    required this.ios,
    required this.android,
    this.iosUrl,
    this.androidUrl,
  });

  factory PercentageSetting.fromJson(Map<String, dynamic> json) =>
      _$PercentageSettingFromJson(json);

  Map<String, dynamic> toJson() => _$PercentageSettingToJson(this);
}

/// 通用设置模型
@JsonSerializable()
class CommonSettings {
  @JsonKey(name: 'splash_ai_percentage')
  final PercentageSetting? splashAiPercentage;
  @JsonKey(name: 'splash_ai_c_percentage')
  final PercentageSetting? splashAiCPercentage;

  CommonSettings({this.splashAiPercentage, this.splashAiCPercentage});

  factory CommonSettings.fromJson(Map<String, dynamic> json) =>
      _$CommonSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$CommonSettingsToJson(this);
}

/// 联系人模型
@JsonSerializable()
class Contact {
  final String url;
  final String source;
  final bool enabled;

  Contact({required this.url, required this.source, required this.enabled});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

/// 联系人职业开关元数据模型
@JsonSerializable()
class ContactProfessionSwitchMeta {
  final String? url;
  final List<Contact>? contacts;
  final int? probability;

  ContactProfessionSwitchMeta({this.url, this.contacts, this.probability});

  factory ContactProfessionSwitchMeta.fromJson(Map<String, dynamic> json) =>
      _$ContactProfessionSwitchMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ContactProfessionSwitchMetaToJson(this);
}

/// 联系人职业开关模型
@JsonSerializable()
class ContactProfessionSwitch {
  final String value;
  final ContactProfessionSwitchMeta? meta;

  ContactProfessionSwitch({required this.value, this.meta});

  factory ContactProfessionSwitch.fromJson(Map<String, dynamic> json) =>
      _$ContactProfessionSwitchFromJson(json);

  Map<String, dynamic> toJson() => _$ContactProfessionSwitchToJson(this);
}

/// 配置模型
@JsonSerializable()
class ConfigModel {
  @JsonKey(name: 'language_codes')
  final List<String>? languageCodes;
  @JsonKey(name: 'official_telegram_group_link')
  final String? officialTelegramGroupLink;
  @JsonKey(name: 'official_twitter_link')
  final String? officialTwitterLink;
  @JsonKey(name: 'show_official_link')
  final int? showOfficialLink;
  @JsonKey(name: 'community_link')
  final String? communityLink;
  @JsonKey(name: 'bubu_referral_sentence')
  final String? bubuReferralSentence;
  @JsonKey(name: 'bubu_referral_sentence_list')
  final List<String>? bubuReferralSentenceList;
  @JsonKey(name: 'promotion_links')
  final List<PromotionLink>? promotionLinks;
  @JsonKey(name: 'common_settings')
  final CommonSettings? commonSettings;
  @JsonKey(name: 'contact_profession_switch')
  final ContactProfessionSwitch? contactProfessionSwitch;

  ConfigModel({
    this.languageCodes,
    this.officialTelegramGroupLink,
    this.officialTwitterLink,
    this.showOfficialLink,
    this.communityLink,
    this.bubuReferralSentence,
    this.bubuReferralSentenceList,
    this.promotionLinks,
    this.commonSettings,
    this.contactProfessionSwitch,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigModelToJson(this);
}
