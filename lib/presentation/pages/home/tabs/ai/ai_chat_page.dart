import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockc/core/network/app_exception.dart';
import 'package:stockc/core/services/user_service.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/toast_util.dart';
import 'package:stockc/data/models/chat_history_model.dart';
import 'package:stockc/data/models/user_model.dart';
import 'package:stockc/data/repositories/ai_chat_repository.dart';
import 'package:stockc/data/repositories/chat_history_repository.dart';
import 'package:stockc/presentation/providers/ai_chat_provider.dart';
import 'widgets/ai_app_bar.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/suggested_topic_button.dart';

/// AI 聊天页面
class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final ScrollController _scrollController = ScrollController();
  final AiChatRepository _repository = AiChatRepository();
  final ChatHistoryRepository _historyRepository = ChatHistoryRepository();
  bool _showWelcome = true;
  DateTime? _lastScrollTime; // 用于节流滚动
  String? _currentChatTitle; // 当前聊天标题
  String? _currentChatId; // 当前聊天ID
  String? _pendingLoadingMessageId; // 当前待处理的加载消息ID

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSendMessage(
    String content, {
    ChatHistoryType? chatType,
  }) async {
    // 隐藏欢迎区域
    if (_showWelcome) {
      setState(() {
        _showWelcome = false;
      });
    }

    // 如果是第一条消息，创建新的聊天记录
    final messages = ref.read(aiChatProvider);
    if (messages.isEmpty) {
      _currentChatId = DateTime.now().millisecondsSinceEpoch.toString();
      _currentChatTitle =
          content.length > 30 ? '${content.substring(0, 30)}...' : content;
      // 判断类型：如果传入了chatType，使用传入的类型，否则判断是否为默认话题
      final type = chatType ?? _determineChatType(content);
      // 保存聊天历史（先保存，后续收到回复后更新）
      final history = ChatHistoryModel(
        id: _currentChatId!,
        title: _currentChatTitle!,
        type: type,
        createdAt: DateTime.now(),
      );
      await _historyRepository.saveChatHistory(history);
    }

    // 添加用户消息
    ref.read(aiChatProvider.notifier).addUserMessage(content);

    // 设置发送按钮为pending状态（打字机效果期间保持此状态）
    ref
        .read(chatSendButtonStateNotifierProvider.notifier)
        .setState(ChatSendButtonState.pending);

    // 滚动到底部（显示用户消息）
    _scrollToBottom();

    // 添加AI加载消息（显示 "..." 动画）
    final loadingMessageId =
        ref.read(aiChatProvider.notifier).addAiLoadingMessage();
    _pendingLoadingMessageId = loadingMessageId;
    _scrollToBottom();

    // 调用API获取AI回复
    try {
      final aiResponse = await _repository.getAiResponse(content);

      if (mounted) {
        // 将加载消息替换为AI消息（开始打字机效果）
        // 注意：此时sendButtonState保持pending，直到打字机效果完成
        ref
            .read(aiChatProvider.notifier)
            .replaceLoadingWithAiMessage(_pendingLoadingMessageId, aiResponse);
        _pendingLoadingMessageId = null;

        // 更新用户使用次数（每次使用增加10）
        final userService = UserService();
        final user = userService.getUserInfo();
        if (user != null) {
          final updatedUser = UserModel(
            id: user.id,
            username: user.username,
            avatar: user.avatar,
            handle: user.handle,
            language: user.language,
            bubu_daily_used: user.bubu_daily_used + 10,
            bubu_daily_max: user.bubu_daily_max,
            planb_daily_used: user.planb_daily_used,
            planb_daily_max: user.planb_daily_max,
          );
          await userService.setUserInfo(updatedUser);
        }

        // 滚动到底部（显示AI消息）
        _scrollToBottom();
      }
    } on BusinessException catch (e) {
      // 处理业务异常（如使用次数用完）
      if (mounted) {
        // 移除加载消息
        final loadingId = _pendingLoadingMessageId;
        if (loadingId != null) {
          ref.read(aiChatProvider.notifier).removeMessage(loadingId);
          _pendingLoadingMessageId = null;
        }

        // 显示错误提示
        if (e.code == 600001) {
          // 使用次数用完，更新用户信息：将使用次数设置为最大值
          final userService = UserService();
          final user = userService.getUserInfo();
          if (user != null) {
            final updatedUser = UserModel(
              id: user.id,
              username: user.username,
              avatar: user.avatar,
              handle: user.handle,
              language: user.language,
              bubu_daily_used: user.bubu_daily_max, // 设置为最大值，表示已用完
              bubu_daily_max: user.bubu_daily_max,
              planb_daily_used: user.planb_daily_used,
              planb_daily_max: user.planb_daily_max,
            );
            await userService.setUserInfo(updatedUser);

            // 使用次数用完
            Toast.error('ai_no_remaining_uses'.tr());

            // 重置发送按钮状态为 disabled（因为次数已用完）
            ref
                .read(chatSendButtonStateNotifierProvider.notifier)
                .setState(ChatSendButtonState.disabled);

            // 触发 UI 刷新（通过 setState），让 ChatInputField 重新计算剩余次数
            if (mounted) {
              setState(() {});
            }
          } else {
            // 如果没有用户信息，只显示错误提示
            Toast.error('ai_no_remaining_uses'.tr());
            ref
                .read(chatSendButtonStateNotifierProvider.notifier)
                .setState(ChatSendButtonState.disabled);
          }
        } else {
          Toast.error(e.message);
          // 其他错误，重置为 enabled 状态
          ref
              .read(chatSendButtonStateNotifierProvider.notifier)
              .setState(ChatSendButtonState.enabled);
        }
      }
    } catch (e) {
      // 其他错误处理
      if (mounted) {
        // 将加载消息替换为错误消息
        ref
            .read(aiChatProvider.notifier)
            .replaceLoadingWithAiMessage(
              _pendingLoadingMessageId,
              'ai_error_message'.tr(),
            );
        _pendingLoadingMessageId = null;
        // 错误情况下也保持pending，直到打字机效果完成
        _scrollToBottom();
      }
    }
  }

  /// 判断聊天类型
  ChatHistoryType _determineChatType(String content) {
    // 检查是否是默认话题
    final defaultTopics = [
      'ai_topic_1'.tr(),
      'ai_topic_2'.tr(),
      'ai_topic_3'.tr(),
    ];
    if (defaultTopics.contains(content)) {
      return ChatHistoryType.defaultTopic;
    }
    // 检查是否是学习话题（可以从lesson页面传入）
    // 暂时返回normal，后续可以根据实际需求调整
    return ChatHistoryType.normal;
  }

  void _handleTopicTap(String topicText) {
    // 默认话题使用defaultTopic类型
    _handleSendMessage(topicText, chatType: ChatHistoryType.defaultTopic);
  }

  void _scrollToBottom({bool force = false}) {
    // 节流：每100ms最多滚动一次，避免频繁滚动导致卡顿
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

    // 监听消息变化，在打字机效果时自动滚动
    // 同时监听打字机效果完成，恢复输入框状态
    ref.listen(aiChatProvider, (previous, next) {
      // 如果消息被清空，重置欢迎状态和聊天ID
      if (next.isEmpty && previous != null && previous.isNotEmpty) {
        setState(() {
          _showWelcome = true;
          _currentChatTitle = null;
          _currentChatId = null;
        });
      } else if (next.isNotEmpty) {
        final lastMessage = next.last;
        // 如果最后一条消息正在加载或正在打字，自动滚动到底部（节流）
        if (lastMessage.isLoading || lastMessage.isTyping) {
          _scrollToBottom();
        } else if (!lastMessage.isUser &&
            previous != null &&
            previous.isNotEmpty) {
          // 如果最后一条AI消息刚完成打字，恢复输入框状态
          final prevLastMessage = previous.last;
          if (prevLastMessage.isTyping && !lastMessage.isTyping) {
            // 打字机效果完成，恢复输入框为disabled状态
            ref
                .read(chatSendButtonStateNotifierProvider.notifier)
                .setState(ChatSendButtonState.disabled);
            // 强制滚动到底部，确保看到完整内容
            _scrollToBottom(force: true);
          }
        }
      }
    });

    return Scaffold(
      backgroundColor: colors.globalBackground,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/splash/img-bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // AppBar（固定在顶部，不随滚动）
            const AiAppBar(),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 欢迎消息和建议话题（仅在无消息时显示）
                    if (_showWelcome && messages.isEmpty) ...[
                      Text(
                        'ai_chat_welcome'.tr(),
                        style: context.textStyles.aiWelcomeText,
                      ),
                      const SizedBox(height: 24),
                      SuggestedTopicButton(
                        topicKey: 'ai_topic_1',
                        onTap: () => _handleTopicTap('ai_topic_1'.tr()),
                      ),
                      SuggestedTopicButton(
                        topicKey: 'ai_topic_2',
                        onTap: () => _handleTopicTap('ai_topic_2'.tr()),
                      ),
                      SuggestedTopicButton(
                        topicKey: 'ai_topic_3',
                        onTap: () => _handleTopicTap('ai_topic_3'.tr()),
                      ),
                    ],
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
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'ai_disclaimer'.tr(),
                          style: context.textStyles.auxiliaryText.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // 输入框（固定在底部）
            ChatInputField(onSend: _handleSendMessage),
          ],
        ),
      ),
    );
  }
}
