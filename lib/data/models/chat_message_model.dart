/// 聊天消息模型
class ChatMessage {
  final String id;
  final String content;
  final bool isUser; // true: 用户消息, false: AI消息
  final DateTime timestamp;
  final bool isTyping; // 是否正在打字机效果中
  final bool isLoading; // 是否正在加载中（请求接口时）
  final String? _originalContent; // 原始完整内容（用于打字机效果）

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
    this.isLoading = false,
    String? originalContent,
  }) : _originalContent = originalContent;

  /// 获取原始完整内容（如果存在），否则返回当前内容
  String get fullContent => _originalContent ?? content;

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    bool? isTyping,
    bool? isLoading,
    String? originalContent,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
      isLoading: isLoading ?? this.isLoading,
      originalContent: originalContent ?? _originalContent,
    );
  }
}
