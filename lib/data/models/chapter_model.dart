/// 章节模型
class ChapterModel {
  final String id;
  final String courseId; // 所属课程ID
  final String titleKey; // 多语言key
  final int lessonCount; // 课程数量
  final int viewCount; // 观看人数（模拟数据）

  const ChapterModel({
    required this.id,
    required this.courseId,
    required this.titleKey,
    required this.lessonCount,
    this.viewCount = 0,
  });
}
