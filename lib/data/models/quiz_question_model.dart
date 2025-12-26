/// 练习题目模型
class QuizQuestionModel {
  final String id;
  final String chapterId; // 所属章节ID
  final String questionKey; // 多语言问题key
  final List<String> options; // 选项列表
  final int correctAnswerIndex; // 正确答案索引（0-based）
  final int score; // 每题分数

  const QuizQuestionModel({
    required this.id,
    required this.chapterId,
    required this.questionKey,
    required this.options,
    required this.correctAnswerIndex,
    this.score = 20,
  });
}
