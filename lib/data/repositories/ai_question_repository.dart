import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/data/models/ai_question_model.dart';

/// AI 问题 Repository
/// 负责业务逻辑和本地存储
class AiQuestionRepository {
  /// 检查是否已回答过问题
  bool hasCompletedQuestions() {
    return StorageService().getBool(AppConstants.keyAiQuestionsCompleted) ??
        false;
  }

  /// 标记问题已回答
  Future<bool> markQuestionsCompleted() async {
    return await StorageService().setBool(
      AppConstants.keyAiQuestionsCompleted,
      true,
    );
  }

  /// 重置问题状态（用于测试或重新回答）
  Future<bool> resetQuestions() async {
    return await StorageService().remove(AppConstants.keyAiQuestionsCompleted);
  }

  /// 获取所有问题数据
  List<QuestionModel> getAllQuestions() {
    return [
      // Q1: 投资经验（单选）
      const QuestionModel(
        id: 'q1',
        questionKey: 'ai_question_1',
        isMultipleChoice: false,
        options: [
          OptionModel(id: 'q1_o1', textKey: 'ai_option_beginner'),
          OptionModel(id: 'q1_o2', textKey: 'ai_option_some_experience'),
          OptionModel(id: 'q1_o3', textKey: 'ai_option_active_investor'),
          OptionModel(id: 'q1_o4', textKey: 'ai_option_experienced'),
          OptionModel(id: 'q1_o5', textKey: 'ai_option_prefer_not_say'),
        ],
      ),
      // Q2: 投资目标（单选）
      const QuestionModel(
        id: 'q2',
        questionKey: 'ai_question_2',
        isMultipleChoice: false,
        options: [
          OptionModel(id: 'q2_o1', textKey: 'ai_option_fast_growth'),
          OptionModel(id: 'q2_o2', textKey: 'ai_option_steady_growth'),
          OptionModel(id: 'q2_o3', textKey: 'ai_option_preserve_assets'),
          OptionModel(id: 'q2_o4', textKey: 'ai_option_learn_first'),
        ],
      ),
      // Q3: 感兴趣的行业（多选）
      const QuestionModel(
        id: 'q3',
        questionKey: 'ai_question_3',
        isMultipleChoice: true,
        options: [
          OptionModel(id: 'q3_o1', textKey: 'ai_option_technology'),
          OptionModel(id: 'q3_o2', textKey: 'ai_option_consumer'),
          OptionModel(id: 'q3_o3', textKey: 'ai_option_new_energy'),
          OptionModel(id: 'q3_o4', textKey: 'ai_option_healthcare'),
          OptionModel(id: 'q3_o5', textKey: 'ai_option_finance'),
          OptionModel(id: 'q3_o6', textKey: 'ai_option_ai_data'),
          OptionModel(id: 'q3_o7', textKey: 'ai_option_media'),
          OptionModel(id: 'q3_o8', textKey: 'ai_option_industrials'),
        ],
      ),
      // Q4: 想关注的更新（多选）
      const QuestionModel(
        id: 'q4',
        questionKey: 'ai_question_4',
        isMultipleChoice: true,
        options: [
          OptionModel(id: 'q4_o1', textKey: 'ai_option_company_news'),
          OptionModel(id: 'q4_o2', textKey: 'ai_option_earnings'),
          OptionModel(id: 'q4_o3', textKey: 'ai_option_market_sentiment'),
          OptionModel(id: 'q4_o4', textKey: 'ai_option_macro_trends'),
          OptionModel(id: 'q4_o5', textKey: 'ai_option_price_movement'),
          OptionModel(id: 'q4_o6', textKey: 'ai_option_research_tips'),
        ],
      ),
    ];
  }
}
