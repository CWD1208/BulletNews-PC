/// 课程模型
class CourseModel {
  final String id;
  final String titleKey; // 多语言key
  final String iconPath; // 图标路径
  final String bannerPath; // Banner路径（用于详情页）

  const CourseModel({
    required this.id,
    required this.titleKey,
    required this.iconPath,
    required this.bannerPath,
  });
}

