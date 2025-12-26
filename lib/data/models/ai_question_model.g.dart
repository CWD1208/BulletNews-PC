// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionModel _$OptionModelFromJson(Map<String, dynamic> json) =>
    OptionModel(id: json['id'] as String, textKey: json['textKey'] as String);

Map<String, dynamic> _$OptionModelToJson(OptionModel instance) =>
    <String, dynamic>{'id': instance.id, 'textKey': instance.textKey};

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['id'] as String,
      questionKey: json['questionKey'] as String,
      isMultipleChoice: json['isMultipleChoice'] as bool,
      options:
          (json['options'] as List<dynamic>)
              .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionKey': instance.questionKey,
      'isMultipleChoice': instance.isMultipleChoice,
      'options': instance.options,
    };
