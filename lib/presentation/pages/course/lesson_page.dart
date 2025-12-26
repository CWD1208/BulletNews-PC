import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/lesson_model.dart';
import 'package:stockc/data/models/chat_history_model.dart';
import 'package:stockc/data/repositories/ai_chat_repository.dart';
import 'package:stockc/data/repositories/chat_history_repository.dart';
import 'package:stockc/presentation/providers/ai_chat_provider.dart';
import 'package:stockc/presentation/pages/home/tabs/ai/widgets/chat_input_field.dart';
import 'package:stockc/presentation/pages/home/tabs/ai/widgets/chat_message_bubble.dart';

/// 课程学习页面（复用AI聊天页面，自动发送问题）
class LessonPage extends ConsumerStatefulWidget {
  final LessonModel lesson;

  const LessonPage({super.key, required this.lesson});

  @override
  ConsumerState<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends ConsumerState<LessonPage> {
  final ScrollController _scrollController = ScrollController();
  final AiChatRepository _repository = AiChatRepository();
  final ChatHistoryRepository _historyRepository = ChatHistoryRepository();
  bool _hasAutoSent = false;
  DateTime? _lastScrollTime;
  String? _currentChatId;
  String? _currentChatTitle;

  @override
  void initState() {
    super.initState();
    // 清除之前的消息
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiChatProvider.notifier).clearMessages();
      // 延迟发送，确保页面已加载
      Future.delayed(const Duration(milliseconds: 300), () {
        _autoSendQuestion();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _autoSendQuestion() {
    if (!_hasAutoSent && mounted) {
      _hasAutoSent = true;
      // 自动发送课程问题（学习话题类型）
      _handleSendMessage(
        widget.lesson.aiQuestion,
        chatType: ChatHistoryType.learningTopic,
      );
    }
  }

  Future<void> _handleSendMessage(
    String content, {
    ChatHistoryType? chatType,
  }) async {
    // 如果是第一条消息，创建新的聊天记录
    final messages = ref.read(aiChatProvider);
    if (messages.isEmpty) {
      _currentChatId = DateTime.now().millisecondsSinceEpoch.toString();
      _currentChatTitle = widget.lesson.titleKey.tr();
      // 保存聊天历史（学习话题类型）
      final history = ChatHistoryModel(
        id: _currentChatId!,
        title: _currentChatTitle!,
        type: ChatHistoryType.learningTopic,
        createdAt: DateTime.now(),
      );
      await _historyRepository.saveChatHistory(history);
    }
    // 添加用户消息
    ref.read(aiChatProvider.notifier).addUserMessage(content);

    // 设置发送按钮为pending状态
    ref
        .read(chatSendButtonStateNotifierProvider.notifier)
        .setState(ChatSendButtonState.pending);

    // 滚动到底部
    _scrollToBottom();

    // 添加AI加载消息（显示 "..." 动画）
    final loadingMessageId =
        ref.read(aiChatProvider.notifier).addAiLoadingMessage();
    _scrollToBottom();

    // 模拟API调用获取AI回复
    try {
      final aiResponse = await _repository.getAiResponse(content);

      if (mounted) {
        // 将加载消息替换为AI消息（开始打字机效果）
        ref
            .read(aiChatProvider.notifier)
            .replaceLoadingWithAiMessage(loadingMessageId, aiResponse);
        _scrollToBottom();
      }
    } catch (e) {
      // 错误处理
      if (mounted) {
        // 将加载消息替换为错误消息
        ref
            .read(aiChatProvider.notifier)
            .replaceLoadingWithAiMessage(
              loadingMessageId,
              'ai_error_message'.tr(),
            );
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom({bool force = false}) {
    final now = DateTime.now();
    if (!force && _lastScrollTime != null) {
      final diff = now.difference(_lastScrollTime!);
      if (diff.inMilliseconds < 100) {
        return;
      }
    }
    _lastScrollTime = now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final messages = ref.watch(aiChatProvider);

    // 监听消息变化，自动滚动
    ref.listen(aiChatProvider, (previous, next) {
      if (next.isNotEmpty) {
        final lastMessage = next.last;
        if (lastMessage.isTyping) {
          _scrollToBottom();
        } else if (!lastMessage.isUser &&
            previous != null &&
            previous.isNotEmpty) {
          final prevLastMessage = previous.last;
          if (prevLastMessage.isTyping && !lastMessage.isTyping) {
            ref
                .read(chatSendButtonStateNotifierProvider.notifier)
                .setState(ChatSendButtonState.disabled);
            _scrollToBottom(force: true);
          }
        }
      }
    });

    return Scaffold(
      backgroundColor: colors.globalBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
          color: colors.textPrimary,
        ),
        title: Text(
          widget.lesson.titleKey.tr(),
          style: context.textStyles.title.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: colors.globalBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // 消息列表
                ...messages.map(
                  (message) => ChatMessageBubble(
                    key: ValueKey(message.id),
                    message: message,
                    onCopy: () {
                      // 复制功能已在组件内部实现
                    },
                    onReport: () {
                      // TODO: 打开举报页面
                    },
                  ),
                ),
                // 免责声明（仅在AI消息存在时显示）
                if (messages.any((msg) => !msg.isUser)) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'ai_disclaimer'.tr(),
                      style: context.textStyles.auxiliaryText.copyWith(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 输入框（课程学习页面也允许继续提问）
          ChatInputField(onSend: _handleSendMessage),
        ],
      ),
    );
  }
}
