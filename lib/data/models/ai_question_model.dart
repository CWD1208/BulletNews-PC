import 'package:json_annotation/json_annotation.dart';

part 'ai_question_model.g.dart';

/// AI 问题选项模型
@JsonSerializable()
class OptionModel {
  final String id;
  final String textKey; // 翻译键值

  const OptionModel({required this.id, required this.textKey});

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionModelToJson(this);
}

/// AI 问题模型
@JsonSerializable()
class QuestionModel {
  final String id;
  final String questionKey; // 翻译键值
  final bool isMultipleChoice; // 是否多选
  final List<OptionModel> options;

  const QuestionModel({
    required this.id,
    required this.questionKey,
    required this.isMultipleChoice,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

/// AI 问题答案模型
class QuestionAnswer {
  final String questionId;
  final List<String> selectedOptionIds; // 选中的选项ID列表

  const QuestionAnswer({
    required this.questionId,
    required this.selectedOptionIds,
  });
}
