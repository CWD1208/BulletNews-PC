import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/chat_history_model.dart';
import 'package:stockc/data/repositories/chat_history_repository.dart';
import 'package:stockc/presentation/providers/ai_chat_provider.dart';

/// AI聊天历史记录页面
class AiChatHistoryPage extends ConsumerStatefulWidget {
  const AiChatHistoryPage({super.key});

  @override
  ConsumerState<AiChatHistoryPage> createState() =>
      _AiChatHistoryPageState();
}

class _AiChatHistoryPageState extends ConsumerState<AiChatHistoryPage> {
  final ChatHistoryRepository _repository = ChatHistoryRepository();
  List<ChatHistoryModel> _histories = [];

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  void _loadHistories() {
    setState(() {
      _histories = _repository.getAllChatHistories();
    });
  }

  Future<void> _deleteHistory(String id) async {
    await _repository.deleteChatHistory(id);
    _loadHistories();
  }

  void _startNewChat() {
    // 清空所有消息
    ref.read(aiChatProvider.notifier).clearMessages();
    // 返回到原来的 AI 聊天页面
    context.pop(true); // 传递 true 表示需要清空数据
  }

  void _openChat(ChatHistoryModel history) {
    // 清空所有消息
    ref.read(aiChatProvider.notifier).clearMessages();
    // 返回到原来的 AI 聊天页面
    context.pop(true); // 传递 true 表示需要清空数据
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.globalBackground,
      appBar: AppBar(
        backgroundColor: colors.globalBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          color: colors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Start New Chat 按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startNewChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryColor ?? const Color(0xFF9556FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'ai_start_new_chat'.tr(),
                    style: context.textStyles.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Chat History 标题
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ai_chat_history'.tr(),
                  style: context.textStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // 历史记录列表
            Expanded(
              child: _histories.isEmpty
                  ? Center(
                      child: Text(
                        'ai_no_chat_history'.tr(),
                        style: context.textStyles.auxiliaryText,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _histories.length,
                      itemBuilder: (context, index) {
                        final history = _histories[index];
                        return _buildHistoryItem(context, colors, history);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    ExtColors colors,
    ChatHistoryModel history,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.alwaysWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon（根据类型显示）
          if (history.type != ChatHistoryType.normal)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primaryColor ?? const Color(0xFF9556FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  history.type == ChatHistoryType.defaultTopic ? '#' : '=',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (history.type != ChatHistoryType.normal) const SizedBox(width: 12),
          // 标题
          Expanded(
            child: GestureDetector(
              onTap: () => _openChat(history),
              child: Text(
                history.title,
                style: context.textStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // 箭头
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: colors.textAuxiliaryLight3,
            ),
            onPressed: () => _openChat(history),
          ),
          // 删除按钮
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: colors.textAuxiliaryLight3,
            ),
            onPressed: () => _deleteHistory(history.id),
          ),
        ],
      ),
    );
  }
}

