import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/ai_question_model.dart';
import 'option_button.dart';
import 'question_progress_indicator.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int currentStep;
  final int totalSteps;
  final List<String> selectedOptionIds;
  final void Function(String optionId) onOptionSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.currentStep,
    required this.totalSteps,
    required this.selectedOptionIds,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 进度指示器
          QuestionProgressIndicator(
            currentStep: currentStep,
            totalSteps: totalSteps,
          ),
          const SizedBox(height: 24),
          // 问题文本
          Text(
            question.questionKey.tr(),
            style: context.textStyles.aiQuestionText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // 选项列表
          ...question.options.map(
            (option) => OptionButton(
              option: option,
              isSelected: selectedOptionIds.contains(option.id),
              onTap: () => onOptionSelected(option.id),
            ),
          ),
        ],
      ),
    );
  }
}
