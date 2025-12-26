import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/presentation/providers/ai_question_provider.dart';
import 'widgets/question_card.dart';
import 'widgets/ai_app_bar.dart';

/// AI 问题流程页面
class AiQuestionFlowPage extends ConsumerStatefulWidget {
  const AiQuestionFlowPage({super.key});

  @override
  ConsumerState<AiQuestionFlowPage> createState() => _AiQuestionFlowPageState();
}

class _AiQuestionFlowPageState extends ConsumerState<AiQuestionFlowPage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final flowState = ref.watch(aiQuestionFlowProvider);
    final flowNotifier = ref.read(aiQuestionFlowProvider.notifier);
    final currentQuestion = flowNotifier.getCurrentQuestion();

    if (currentQuestion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentStep = flowState.currentIndex + 1;
    final totalSteps = flowState.totalQuestions;
    final selectedOptions = flowState.answers[currentQuestion.id] ?? [];
    final canProceed = flowNotifier.canProceed();
    final isLastStep = flowNotifier.isLastStep;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/splash/img-bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const AiAppBar(),
              const SizedBox(height: 20),
              // 顶部欢迎信息
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'ai_welcome_message'.tr(),
                  style: context.textStyles.aiWelcomeText,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 20),
              // 问题卡片
              Expanded(
                child: SingleChildScrollView(
                  child: QuestionCard(
                    question: currentQuestion,
                    currentStep: currentStep,
                    totalSteps: totalSteps,
                    selectedOptionIds: selectedOptions,
                    onOptionSelected: (optionId) {
                      flowNotifier.selectOption(currentQuestion.id, optionId);
                    },
                  ),
                ),
              ),
              // 底部按钮
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        canProceed
                            ? () async {
                              if (isLastStep) {
                                // 完成所有问题
                                await ref
                                    .read(aiQuestionsCompletedProvider.notifier)
                                    .markCompleted();
                                if (mounted) {
                                  // 刷新页面以显示AI聊天界面
                                  ref.invalidate(aiQuestionsCompletedProvider);
                                }
                              } else {
                                // 进入下一步
                                flowNotifier.next();
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canProceed
                              ? (colors.primaryColor ?? const Color(0xFF9556FF))
                              : colors.lightGray,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastStep ? 'button_all_set'.tr() : 'button_next'.tr(),
                      style:
                          canProceed
                              ? context.textStyles.aiButtonText
                              : context.textStyles.aiButtonTextDisabled,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
