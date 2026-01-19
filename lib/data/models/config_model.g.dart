// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionLink _$PromotionLinkFromJson(Map<String, dynamic> json) =>
    PromotionLink(
      name: json['name'] as String,
      links: (json['links'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PromotionLinkToJson(PromotionLink instance) =>
    <String, dynamic>{'name': instance.name, 'links': instance.links};

PercentageSetting _$PercentageSettingFromJson(Map<String, dynamic> json) =>
    PercentageSetting(
      ios: (json['ios'] as num).toInt(),
      android: (json['android'] as num).toInt(),
      iosUrl: json['ios_url'] as String?,
      androidUrl: json['android_url'] as String?,
    );

Map<String, dynamic> _$PercentageSettingToJson(PercentageSetting instance) =>
    <String, dynamic>{
      'ios': instance.ios,
      'android': instance.android,
      'ios_url': instance.iosUrl,
      'android_url': instance.androidUrl,
    };

CommonSettings _$CommonSettingsFromJson(Map<String, dynamic> json) =>
    CommonSettings(
      splashAiPercentage:
          json['splash_ai_percentage'] == null
              ? null
              : PercentageSetting.fromJson(
                json['splash_ai_percentage'] as Map<String, dynamic>,
              ),
      splashAiCPercentage:
          json['splash_ai_c_percentage'] == null
              ? null
              : PercentageSetting.fromJson(
                json['splash_ai_c_percentage'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$CommonSettingsToJson(CommonSettings instance) =>
    <String, dynamic>{
      'splash_ai_percentage': instance.splashAiPercentage,
      'splash_ai_c_percentage': instance.splashAiCPercentage,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
  url: json['url'] as String,
  source: json['source'] as String,
  enabled: json['enabled'] as bool,
);

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
  'url': instance.url,
  'source': instance.source,
  'enabled': instance.enabled,
};

ContactProfessionSwitchMeta _$ContactProfessionSwitchMetaFromJson(
  Map<String, dynamic> json,
) => ContactProfessionSwitchMeta(
  url: json['url'] as String?,
  contacts:
      (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
  probability: (json['probability'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContactProfessionSwitchMetaToJson(
  ContactProfessionSwitchMeta instance,
) => <String, dynamic>{
  'url': instance.url,
  'contacts': instance.contacts,
  'probability': instance.probability,
};

ContactProfessionSwitch _$ContactProfessionSwitchFromJson(
  Map<String, dynamic> json,
) => ContactProfessionSwitch(
  value: json['value'] as String,
  meta:
      json['meta'] == null
          ? null
          : ContactProfessionSwitchMeta.fromJson(
            json['meta'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$ContactProfessionSwitchToJson(
  ContactProfessionSwitch instance,
) => <String, dynamic>{'value': instance.value, 'meta': instance.meta};

ConfigModel _$ConfigModelFromJson(Map<String, dynamic> json) => ConfigModel(
  languageCodes:
      (json['language_codes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  officialTelegramGroupLink: json['official_telegram_group_link'] as String?,
  officialTwitterLink: json['official_twitter_link'] as String?,
  showOfficialLink: (json['show_official_link'] as num?)?.toInt(),
  communityLink: json['community_link'] as String?,
  bubuReferralSentence: json['bubu_referral_sentence'] as String?,
  bubuReferralSentenceList:
      (json['bubu_referral_sentence_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  promotionLinks:
      (json['promotion_links'] as List<dynamic>?)
          ?.map((e) => PromotionLink.fromJson(e as Map<String, dynamic>))
          .toList(),
  commonSettings:
      json['common_settings'] == null
          ? null
          : CommonSettings.fromJson(
            json['common_settings'] as Map<String, dynamic>,
          ),
  contactProfessionSwitch:
      json['contact_profession_switch'] == null
          ? null
          : ContactProfessionSwitch.fromJson(
            json['contact_profession_switch'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$ConfigModelToJson(ConfigModel instance) =>
    <String, dynamic>{
      'language_codes': instance.languageCodes,
      'official_telegram_group_link': instance.officialTelegramGroupLink,
      'official_twitter_link': instance.officialTwitterLink,
      'show_official_link': instance.showOfficialLink,
      'community_link': instance.communityLink,
      'bubu_referral_sentence': instance.bubuReferralSentence,
      'bubu_referral_sentence_list': instance.bubuReferralSentenceList,
      'promotion_links': instance.promotionLinks,
      'common_settings': instance.commonSettings,
      'contact_profession_switch': instance.contactProfessionSwitch,
    };
