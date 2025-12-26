import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

/// AI 页面 AppBar
class AiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;

  const AiAppBar({super.key, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // 确保背景透明，不会变色
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: null, // 防止系统覆盖层影响
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onBack != null) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
                color: context.colors.textPrimary,
              ),
            ] else ...[
              const SizedBox(width: 16),
              Image.asset('assets/icons/tabbar/AI.png', width: 32, height: 32),
              const SizedBox(width: 8),
              Text('app_name'.tr(), style: context.textStyles.subtitle),
            ],
          ],
        ),
        leadingWidth: 200,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/ai/more.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // 导航到聊天历史记录页面
              context.push('/ai/history');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
