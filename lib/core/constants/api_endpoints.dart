class ApiEndpoints {
  // Routes

  /// 自动登录接口
  static const String autoLogin = '/bn/v1/account/login';

  /// 获取用户信息接口
  static const String getProfile = '/bn/v1/account/profile';

  /// 市场概览接口
  static const String marketSummary = '/bn/v1/market/summary';

  /// trending 文章接口
  static const String trendingArticles = '/bn/v1/feeds/trending';

  /// 新闻详情接口
  static const String newsDetails = '/bn/v1/feeds/feed';

  /// AI 聊天接口
  static const String aiChat = '/bn/v1/planb/chat';

  /// List of endpoints that do not require authentication token
  static const List<String> noTokenEndpoints = [autoLogin];

  /// 获取config接口
  static const String getConfig = '/bn/v1/config';

  /// 获取 contact 接口
  static const String getContact = '/bn/v1/account/contact_url';
}
