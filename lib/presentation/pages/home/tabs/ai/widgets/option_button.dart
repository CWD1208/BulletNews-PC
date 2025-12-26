import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/ai_question_model.dart';

class OptionButton extends StatelessWidget {
  final OptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (colors.primaryColor?.withOpacity(0.1) ??
                      const Color(0xFF9556FF).withOpacity(0.1))
                  : Colors.white,
          border: Border.all(
            color:
                isSelected
                    ? (colors.primaryColor ?? const Color(0xFF9556FF))
                    : colors.textAuxiliaryLight2 ?? const Color(0xFFF0F1F3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // 选项文本 - 居中
            Padding(
              padding: EdgeInsets.only(left: 0, right: isSelected ? 24 : 0),
              child: Text(
                option.textKey.tr(),
                textAlign: TextAlign.center,
                style:
                    isSelected
                        ? context.textStyles.aiOptionTextSelected
                        : context.textStyles.aiOptionTextUnselected,
              ),
            ),
            // 选中图标 - 紧贴右上角
            if (isSelected)
              Positioned(
                right: -18,
                top: -16,
                child: Image.asset(
                  'assets/icons/ai/selected.png',
                  width: 24,
                  height: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
