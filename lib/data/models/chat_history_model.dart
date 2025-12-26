/// 聊天历史记录模型
class ChatHistoryModel {
  final String id;
  final String title;
  final ChatHistoryType type; // 类型：默认话题、学习话题、普通
  final DateTime createdAt;

  const ChatHistoryModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
  });

  /// 从JSON创建
  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'normal';
    ChatHistoryType type;
    switch (typeStr) {
      case 'default_topic':
        type = ChatHistoryType.defaultTopic;
        break;
      case 'learning_topic':
        type = ChatHistoryType.learningTopic;
        break;
      default:
        type = ChatHistoryType.normal;
    }
    
    return ChatHistoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: type,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.toJsonString(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// 聊天历史类型
enum ChatHistoryType {
  defaultTopic, // 默认话题
  learningTopic, // 学习话题
  normal, // 普通聊天
}

/// ChatHistoryType 扩展方法
extension ChatHistoryTypeExtension on ChatHistoryType {
  String toJsonString() {
    switch (this) {
      case ChatHistoryType.defaultTopic:
        return 'default_topic';
      case ChatHistoryType.learningTopic:
        return 'learning_topic';
      case ChatHistoryType.normal:
        return 'normal';
    }
  }
}

