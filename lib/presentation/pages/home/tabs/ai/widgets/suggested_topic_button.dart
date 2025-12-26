import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

/// 建议话题按钮
class SuggestedTopicButton extends StatelessWidget {
  final String topicKey; // 翻译键值
  final VoidCallback onTap;

  const SuggestedTopicButton({
    super.key,
    required this.topicKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.alwaysWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // # 图标
            Image.asset('assets/icons/ai/topic.png', width: 16, height: 16),
            const SizedBox(width: 4),
            // 话题文本 - 使用 Flexible 允许换行，但不强制占满空间
            Flexible(
              child: Text(
                topicKey.tr(),
                style: context.textStyles.aiTopicText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // 右箭头
            Image.asset(
              'assets/icons/ai/more-arrow.png',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
