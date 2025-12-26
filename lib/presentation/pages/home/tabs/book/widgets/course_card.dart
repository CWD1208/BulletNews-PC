import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/course_model.dart';

/// 课程卡片组件
class CourseCard extends StatelessWidget {
  final CourseModel course;
  final int progress; // 0-100
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progressPercent = progress.clamp(0, 100);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Row(
          children: [
            // 课程图标
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colors.lightGray ?? const Color(0xFFF0F1F3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  course.iconPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colors.lightGray ?? const Color(0xFFF0F1F3),
                      child: Icon(
                        Icons.book,
                        color:
                            colors.textAuxiliaryLight3 ??
                            const Color(0xFF999999),
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 课程信息和进度
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 课程标题
                  Text(
                    course.titleKey.tr(),
                    style: context.textStyles.title.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // 进度条
                  Stack(
                    children: [
                      // 背景进度条
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.lightGray ?? const Color(0xFFF0F1F3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // 实际进度条
                      if (progressPercent > 0)
                        FractionallySizedBox(
                          widthFactor: progressPercent / 100,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color:
                                  colors.primaryColor ??
                                  const Color(0xFF9556FF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 进度百分比
            Text(
              '$progressPercent%',
              style: context.textStyles.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
