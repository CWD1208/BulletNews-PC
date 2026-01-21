/// 应用常量
/// 包含所有存储key、URL等常量
class AppConstants {
  AppConstants._(); // 私有构造函数，防止实例化

  // ==================== 存储 Key ====================

  /// 启动页完成标记
  static const String keySplashCompleted = 'splash_completed';

  /// AI问题完成标记
  static const String keyAiQuestionsCompleted = 'ai_questions_completed';

  /// 课程进度初始化标记
  static const String keyCourseProgressInitialized =
      'course_progress_initialized';

  // ==================== 用户相关 Key ====================

  /// 用户Token
  static const String keyUserToken = 'user_token';

  /// 用户信息（JSON格式）
  static const String keyUserInfo = 'user_info';

  /// 登录状态
  static const String keyIsLoggedIn = 'is_logged_in';

  /// 用户名（兼容旧代码）
  static const String keyUserUsername = 'user_username';

  /// 用户邮箱（兼容旧代码）
  static const String keyUserEmail = 'user_email';

  /// UUID
  static const String keyUuid = 'uuid';

  /// afID
  static const String keyAppsflyerId = 'appsflyer_id';

  /// afApiKey
  static const String keyAppsflyerApiKey = 'appsflyer_api_key';

  // ==================== 课程相关 Key ====================

  /// 课程进度 Key（需要拼接 courseId）
  /// 使用方式：${AppConstants.keyCourseProgress}_$courseId
  static const String keyCourseProgress = 'course_progress';

  /// 章节进度 Key（需要拼接 chapterId）
  /// 使用方式：${AppConstants.keyChapterProgress}_$chapterId
  static const String keyChapterProgress = 'chapter_progress';

  /// 上次学习的课程 Key（需要拼接 chapterId）
  /// 使用方式：${AppConstants.keyLastLearnedLesson}_$chapterId
  static const String keyLastLearnedLesson = 'last_learned_lesson';

  /// 练习结果 Key（需要拼接 chapterId）
  /// 使用方式：${AppConstants.keyQuizResult}_$chapterId
  static const String keyQuizResult = 'quiz_result';

  // ==================== 新闻相关 Key ====================

  /// 新闻点赞状态 Key（需要拼接 newsId）
  /// 使用方式：${AppConstants.keyNewsLiked}_$newsId
  static const String keyNewsLiked = 'news_liked';

  // ==================== AI聊天相关 Key ====================

  /// AI聊天历史记录列表 Key
  static const String keyChatHistoryList = 'chat_history_list';

  // ==================== URL 常量 ====================

  /// 隐私政策 URL
  static const String urlPrivacyPolicy =
      'https://vestorai.notion.site/Privacy-Policy-2d133f42632280bfb52dc400f0dad6e5';

  /// 服务条款 URL
  static const String urlTermsOfService =
      'https://vestorai.notion.site/Terms-of-Service-2d133f426322804a9f94c762a56d1b6a';

  /// FAQ URL（如果需要）
  static const String urlFaq = 'https://vestorai.notion.site/FAQ';

  // ==================== 辅助方法 ====================

  /// 获取课程进度存储key
  static String getCourseProgressKey(String courseId) {
    return '${keyCourseProgress}_$courseId';
  }

  /// 获取章节进度存储key
  static String getChapterProgressKey(String chapterId) {
    return '${keyChapterProgress}_$chapterId';
  }

  /// 获取上次学习的课程存储key
  static String getLastLearnedLessonKey(String chapterId) {
    return '${keyLastLearnedLesson}_$chapterId';
  }

  /// 获取练习结果存储key
  static String getQuizResultKey(String chapterId) {
    return '${keyQuizResult}_$chapterId';
  }

  /// 获取新闻点赞状态存储key
  static String getNewsLikedKey(String newsId) {
    return '${keyNewsLiked}_$newsId';
  }
}
