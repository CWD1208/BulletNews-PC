/// 练习结果模型
class QuizResultModel {
  final String chapterId;
  final int totalScore; // 总分
  final int maxScore; // 满分
  final bool passed; // 是否通过
  final List<QuestionAnswer> answers; // 答题记录
  final DateTime completedAt; // 完成时间

  const QuizResultModel({
    required this.chapterId,
    required this.totalScore,
    required this.maxScore,
    required this.passed,
    required this.answers,
    required this.completedAt,
  });
}

/// 单题答题记录
class QuestionAnswer {
  final String questionId;
  final int selectedIndex; // 用户选择的答案索引
  final int correctIndex; // 正确答案索引
  final bool isCorrect; // 是否正确

  const QuestionAnswer({
    required this.questionId,
    required this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
  });
}
