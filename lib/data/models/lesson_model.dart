/// 课程小节模型
class LessonModel {
  final String id;
  final String chapterId; // 所属章节ID
  final String titleKey; // 多语言key
  final String aiQuestion; // 发送给AI的问题

  const LessonModel({
    required this.id,
    required this.chapterId,
    required this.titleKey,
    required this.aiQuestion,
  });
}
