import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockc/core/services/user_service.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/toast_util.dart';
import 'package:stockc/presentation/providers/ai_chat_provider.dart';

/// 聊天输入框组件
class ChatInputField extends ConsumerStatefulWidget {
  final void Function(String) onSend;

  const ChatInputField({super.key, required this.onSend});

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _listenerAdded = false;

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  /// 计算剩余次数
  int _getRemainingCount() {
    final user = UserService().getUserInfo();
    if (user == null) return 0;

    // 计算剩余次数：剩余次数 = (bubu_daily_max / 10) - (bubu_daily_used / 10)
    final maxCount = (user.bubu_daily_max / 10).floor();
    final usedCount = (user.bubu_daily_used / 10).floor();
    final remaining = maxCount - usedCount;
    return remaining > 0 ? remaining : 0;
  }

  /// 检查是否可以发送（有剩余次数且有文本）
  bool _canSend() {
    final remaining = _getRemainingCount();
    final hasText = _controller.text.trim().isNotEmpty;
    return remaining > 0 && hasText;
  }

  void _handleTextChange() {
    final sendButtonState = ref.read(chatSendButtonStateNotifierProvider);
    // 如果处于pending状态，不处理输入变化
    if (sendButtonState == ChatSendButtonState.pending) {
      return;
    }

    final canSend = _canSend();
    if (canSend && sendButtonState == ChatSendButtonState.disabled) {
      ref
          .read(chatSendButtonStateNotifierProvider.notifier)
          .setState(ChatSendButtonState.enabled);
    } else if (!canSend && sendButtonState == ChatSendButtonState.enabled) {
      ref
          .read(chatSendButtonStateNotifierProvider.notifier)
          .setState(ChatSendButtonState.disabled);
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    final remaining = _getRemainingCount();

    // 检查是否有剩余次数
    if (remaining <= 0) {
      // 显示提示信息
      Toast.error('ai_no_remaining_uses'.tr());
      return;
    }

    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      // 发送后状态会由ai_chat_page设置为pending，这里不需要手动设置
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sendButtonState = ref.watch(chatSendButtonStateNotifierProvider);
    final isPending = sendButtonState == ChatSendButtonState.pending;

    // 每次 build 时重新计算剩余次数（确保获取最新数据）
    // 注意：这里每次 build 都会重新获取用户信息，所以能获取到最新值
    final remaining = _getRemainingCount();
    final canSend = _canSend() && !isPending;

    // 如果剩余次数为 0 且按钮状态不是 disabled，更新按钮状态
    if (remaining <= 0 &&
        sendButtonState != ChatSendButtonState.disabled &&
        !isPending) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(chatSendButtonStateNotifierProvider.notifier)
              .setState(ChatSendButtonState.disabled);
        }
      });
    }

    // 只在第一次build时添加监听器
    if (!_listenerAdded) {
      _controller.addListener(_handleTextChange);
      _listenerAdded = true;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.alwaysWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          // 输入框
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.globalBackground ?? const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                enabled: !isPending, // pending状态下禁用输入
                decoration: InputDecoration(
                  hintText: 'ai_input_placeholder'.tr(),
                  hintStyle: context.textStyles.auxiliaryText,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: context.textStyles.body,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: canSend ? (_) => _handleSend() : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 发送按钮（带剩余次数显示）
          GestureDetector(
            onTap: () {
              // 即使不能发送，也允许点击以显示提示
              if (canSend) {
                _handleSend();
              } else {
                // 如果没有剩余次数，显示提示
                final remaining = _getRemainingCount();
                if (remaining <= 0) {
                  Toast.error('ai_no_remaining_uses'.tr());
                }
              }
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    canSend
                        ? (colors.primaryColor ?? const Color(0xFF9556FF))
                        : (colors.lightGray ?? const Color(0xFFE5E5E5)),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 图标
                  Image.asset(
                    _getSendButtonIcon(sendButtonState),
                    width: 48,
                    height: 48,
                  ),
                  // 剩余次数（显示在按钮上，包括0）
                  if (!isPending)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA100), // 橙色背景 #FFA100
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white, // 白色边框
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$remaining',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSendButtonIcon(ChatSendButtonState state) {
    switch (state) {
      case ChatSendButtonState.enabled:
        return 'assets/icons/ai/chat.png';
      case ChatSendButtonState.disabled:
        return 'assets/icons/ai/chat-disable.png';
      case ChatSendButtonState.pending:
        return 'assets/icons/ai/chat-pending.png';
    }
  }
}
