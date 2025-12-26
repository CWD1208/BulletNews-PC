import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stockc/data/models/chat_message_model.dart';
import 'package:stockc/presentation/providers/ai_chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 打字机效果组件
class TypingEffectWidget extends ConsumerStatefulWidget {
  final ChatMessage message;
  final TextStyle textStyle;
  final Duration delay; // 每个字符的延迟时间

  const TypingEffectWidget({
    super.key,
    required this.message,
    required this.textStyle,
    this.delay = const Duration(milliseconds: 30),
  });

  @override
  ConsumerState<TypingEffectWidget> createState() => _TypingEffectWidgetState();
}

class _TypingEffectWidgetState extends ConsumerState<TypingEffectWidget> {
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.message.isTyping) {
      _startTyping();
    } else {
      _currentIndex = widget.message.fullContent.length;
    }
  }

  @override
  void didUpdateWidget(TypingEffectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.isTyping && !oldWidget.message.isTyping) {
      _startTyping();
    } else if (!widget.message.isTyping && oldWidget.message.isTyping) {
      _stopTyping();
    }
  }

  void _startTyping() {
    _currentIndex = widget.message.content.length; // 从当前已显示内容继续
    _timer?.cancel();
    final fullContent = widget.message.fullContent;

    // 如果已经显示完，直接完成
    if (_currentIndex >= fullContent.length) {
      _stopTyping();
      ref
          .read(aiChatProvider.notifier)
          .completeAiMessageTyping(widget.message.id);
      return;
    }

    _timer = Timer.periodic(widget.delay, (timer) {
      if (mounted) {
        _currentIndex++;

        // 仅本地刷新，避免全局状态频繁重建
        setState(() {});

        if (_currentIndex >= fullContent.length) {
          _stopTyping();
          // 完成时一次性更新全局状态，写入完整内容并关闭打字标记
          ref
              .read(aiChatProvider.notifier)
              .completeAiMessageTyping(widget.message.id);
        }
      }
    });
  }

  void _stopTyping() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTyping();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullContent = widget.message.fullContent;
    final displayedText = fullContent.substring(
      0,
      _currentIndex.clamp(0, fullContent.length),
    );

    return Text(displayedText, style: widget.textStyle);
  }
}
