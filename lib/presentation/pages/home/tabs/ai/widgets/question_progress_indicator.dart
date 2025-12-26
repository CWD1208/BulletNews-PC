import 'package:flutter/material.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

class QuestionProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const QuestionProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        // 进度条
        Expanded(
          child: Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index < currentStep;
              final isCurrent = index == currentStep - 1;

              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < totalSteps - 1 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isActive || isCurrent
                            ? (colors.primaryColor ?? const Color(0xFF9556FF))
                            : colors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        // 步骤文字
        Text(
          '$currentStep/$totalSteps',
          style: context.textStyles.aiProgressText,
        ),
      ],
    );
  }
}
