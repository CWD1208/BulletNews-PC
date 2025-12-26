import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockc/presentation/pages/home/tabs/ai/ai_chat_page.dart';
import 'package:stockc/presentation/pages/home/tabs/ai/ai_question_flow_page.dart';
import 'package:stockc/presentation/providers/ai_question_provider.dart';

class AiTab extends ConsumerWidget {
  const AiTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 检查是否已回答过问题
    final hasCompleted = ref.watch(aiQuestionsCompletedProvider);

    // 如果已回答过，显示AI聊天页面；否则显示问题流程
    if (hasCompleted) {
      return const AiChatPage();
    } else {
      return const AiQuestionFlowPage();
    }
  }
}
