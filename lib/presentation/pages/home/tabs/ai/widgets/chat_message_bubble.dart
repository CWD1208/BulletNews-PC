import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/toast_util.dart';
import 'package:stockc/data/models/chat_message_model.dart';
import 'typing_effect_widget.dart';

/// 聊天消息气泡组件
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onCopy;
  final VoidCallback? onReport;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onCopy,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (message.isUser) {
      // 用户消息：右侧紫色气泡
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 60, right: 20, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.primaryColor ?? const Color(0xFF9556FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            message.content,
            style: context.textStyles.body.copyWith(color: Colors.white),
          ),
        ),
      );
    } else {
      // AI消息：左侧白色气泡
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 消息气泡
            Container(
              margin: const EdgeInsets.only(left: 20, right: 60, bottom: 4),
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  message.isLoading
                      ? _buildLoadingAnimation()
                      : message.isTyping
                      ? TypingEffectWidget(
                        message: message,
                        textStyle: context.textStyles.body,
                      )
                      : Text(message.content, style: context.textStyles.body),
            ),
            // 操作按钮（复制、举报）- 仅在打字完成且不在加载时显示
            if (!message.isTyping && !message.isLoading)
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      context,
                      icon: 'assets/icons/ai/copy.png',
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: message.content));
                        Toast.success('ai_copied'.tr());
                        onCopy?.call();
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      context,
                      icon: 'assets/icons/ai/report.png',
                      onTap: () {
                        context.push('/report');
                        onReport?.call();
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Image.asset(icon, width: 32, height: 32),
      ),
    );
  }

  /// 构建加载动画（"..." 动画）
  Widget _buildLoadingAnimation() {
    return _LoadingDots();
  }
}

/// 加载动画组件（三个点的动画）
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // 每个点的延迟时间
            final delay = index * 0.2;
            final animationValue = (_controller.value + delay) % 1.0;
            // 透明度动画：0 -> 1 -> 0
            final opacity =
                animationValue < 0.5
                    ? animationValue * 2
                    : 2 - (animationValue * 2);
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Opacity(
                opacity: opacity.clamp(0.3, 1.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
