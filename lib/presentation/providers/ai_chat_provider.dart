import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockc/data/models/chat_message_model.dart';

part 'ai_chat_provider.g.dart';

/// AI 聊天状态管理
@riverpod
class AiChat extends _$AiChat {
  @override
  List<ChatMessage> build() {
    return [];
  }

  /// 添加用户消息
  void addUserMessage(String content) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = [...state, message];
  }

  /// 添加AI加载消息（显示 "..." 动画）
  /// 返回加载消息的ID
  String addAiLoadingMessage() {
    // 使用更精确的时间戳和随机数确保唯一性
    final id =
        '${DateTime.now().millisecondsSinceEpoch}_${state.length}_${DateTime.now().microsecondsSinceEpoch}';
    final message = ChatMessage(
      id: id,
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    state = [...state, message];
    return id;
  }

  /// 将加载消息替换为AI消息（开始打字机效果）
  void replaceLoadingWithAiMessage(String? loadingMessageId, String content) {
    // 如果提供了加载消息ID，使用ID查找；否则查找最后一个加载消息
    int loadingIndex = -1;
    if (loadingMessageId != null) {
      loadingIndex = state.indexWhere(
        (msg) => msg.id == loadingMessageId && msg.isLoading,
      );
    }

    // 如果没找到，尝试查找最后一个加载消息（向后兼容）
    if (loadingIndex == -1) {
      loadingIndex = state.lastIndexWhere((msg) => msg.isLoading);
    }

    if (loadingIndex != -1) {
      final newMessage = ChatMessage(
        id: state[loadingIndex].id, // 保持相同的ID
        content: '', // 初始为空，打字机效果逐步显示
        isUser: false,
        timestamp: DateTime.now(),
        isTyping: true,
        originalContent: content, // 保存原始完整内容
      );
      state = [
        ...state.sublist(0, loadingIndex),
        newMessage,
        ...state.sublist(loadingIndex + 1),
      ];
    } else {
      // 如果没有找到加载消息，直接添加新消息
      addAiMessage(content);
    }
  }

  /// 添加AI消息（开始打字机效果）
  void addAiMessage(String content) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '', // 初始为空，打字机效果逐步显示
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: true,
      originalContent: content, // 保存原始完整内容
    );
    state = [...state, message];
  }

  /// 完成AI消息的打字机效果
  void completeAiMessageTyping(String messageId) {
    state =
        state.map((msg) {
          if (msg.id == messageId) {
            return msg.copyWith(content: msg.fullContent, isTyping: false);
          }
          return msg;
        }).toList();
  }

  /// 移除指定ID的消息
  void removeMessage(String messageId) {
    state = state.where((msg) => msg.id != messageId).toList();
  }

  /// 清除所有消息
  void clearMessages() {
    state = [];
  }
}

/// 发送按钮状态
enum ChatSendButtonState {
  enabled, // 正常状态
  disabled, // 禁用状态（输入框为空）
  pending, // 发送中/等待状态
}

/// 发送按钮状态管理
@riverpod
class ChatSendButtonStateNotifier extends _$ChatSendButtonStateNotifier {
  @override
  ChatSendButtonState build() => ChatSendButtonState.disabled;

  void setState(ChatSendButtonState newState) {
    state = newState;
  }
}
