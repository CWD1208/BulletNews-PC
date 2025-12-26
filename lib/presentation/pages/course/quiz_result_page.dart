import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/chapter_model.dart';
import 'package:stockc/data/models/quiz_result_model.dart';
import 'package:stockc/data/models/quiz_question_model.dart';
import 'package:stockc/data/repositories/course_repository.dart';

/// 练习结果页面
class QuizResultPage extends StatefulWidget {
  final QuizResultModel result;
  final ChapterModel chapter;

  const QuizResultPage({
    super.key,
    required this.result,
    required this.chapter,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  final CourseRepository _repository = CourseRepository();
  final PageController _pageController = PageController();
  late List<QuizQuestionModel> _questions;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _questions = _repository.getQuizQuestionsByChapter(widget.chapter.id);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.globalBackground,
      body: Container(
        decoration: BoxDecoration(
          image:
              isDark
                  ? null
                  : const DecorationImage(
                    image: AssetImage('assets/icons/splash/img-bg.png'),
                    fit: BoxFit.cover,
                  ),
          color: isDark ? colors.globalBackground : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              _buildAppBar(context, colors),
              // 分数头部
              _buildScoreHeader(context, colors),
              // 题目内容
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colors.alwaysWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // 进度指示器
                      _buildProgressIndicator(context, colors),
                      // 题目内容
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            return _buildQuestionCard(
                              context,
                              colors,
                              _questions[index],
                              index,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 底部按钮
              // _buildBottomButton(context, colors, widget.result.passed),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建AppBar
  Widget _buildAppBar(BuildContext context, ExtColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(true),
            color: colors.textPrimary,
          ),
          Text(
            'learn_quiz_title'.tr(),
            style: context.textStyles.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分数头部
  Widget _buildScoreHeader(BuildContext context, ExtColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Text(
            'learn_quiz_your_score'.tr(),
            style: context.textStyles.body.copyWith(
              fontSize: 16,
              color: colors.textAuxiliaryLight3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.result.totalScore}',
            style: context.textStyles.title.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建进度指示器
  Widget _buildProgressIndicator(BuildContext context, ExtColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // 进度条
          ...List.generate(
            _questions.length,
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < _questions.length - 1 ? 4 : 0,
                ),
                height: 4,
                decoration: BoxDecoration(
                  color:
                      index <= _currentIndex
                          ? (colors.primaryColor ?? const Color(0xFF9556FF))
                          : (colors.lightGray ?? const Color(0xFFF0F1F3)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 60),
          // 进度文本
          Text(
            '${_currentIndex + 1}/${_questions.length}',
            style: context.textStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建题目卡片
  Widget _buildQuestionCard(
    BuildContext context,
    ExtColors colors,
    QuizQuestionModel question,
    int index,
  ) {
    // 找到对应的答案
    final answer = widget.result.answers.firstWhere(
      (a) => a.questionId == question.id,
      orElse:
          () => QuestionAnswer(
            questionId: question.id,
            selectedIndex: -1,
            correctIndex: question.correctAnswerIndex,
            isCorrect: false,
          ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题目
          Text(
            question.questionKey.tr(),
            style: context.textStyles.title.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // 选项
          ...question.options.asMap().entries.map((entry) {
            final optionIndex = entry.key;
            final optionKey = entry.value;
            final isSelected = answer.selectedIndex == optionIndex;
            final isCorrect = optionIndex == question.correctAnswerIndex;

            Color? backgroundColor;
            Color? textColor;
            Color? borderColor;

            // 查看模式：显示正确答案和用户答案
            if (isCorrect) {
              backgroundColor = (colors.primaryColor ?? const Color(0xFF9556FF))
                  .withOpacity(0.1);
              textColor = colors.primaryColor ?? const Color(0xFF9556FF);
              borderColor = colors.primaryColor ?? const Color(0xFF9556FF);
            } else if (isSelected) {
              backgroundColor = Colors.red.withOpacity(0.1);
              textColor = Colors.red;
              borderColor = Colors.red;
            }

            return Container(
              margin: EdgeInsets.only(
                bottom: optionIndex == question.options.length - 1 ? 0 : 12,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor ?? colors.alwaysWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      borderColor ??
                      (colors.lightGray ?? const Color(0xFFE0E0E0)),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // 选项字母
                  Container(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + optionIndex), // A, B, C, D
                        style: context.textStyles.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor ?? colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 选项文本
                  Expanded(
                    child: Text(
                      optionKey.tr(),
                      style: context.textStyles.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor ?? colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          // 答案对比
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  colors.lightGray?.withOpacity(0.3) ?? const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 用户答案
                Text(
                  'learn_quiz_your_answer'.tr() +
                      ': ${answer.selectedIndex >= 0 ? String.fromCharCode(65 + answer.selectedIndex) : '-'}',
                  style: context.textStyles.body.copyWith(
                    fontSize: 14,
                    color: colors.textPrimary,
                  ),
                ),
                // 正确答案
                Text(
                  'learn_quiz_correct_answer'.tr() +
                      ': ${String.fromCharCode(65 + question.correctAnswerIndex)}',
                  style: context.textStyles.body.copyWith(
                    fontSize: 14,
                    color: colors.primaryColor ?? const Color(0xFF9556FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton(
    BuildContext context,
    ExtColors colors,
    bool passed,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.alwaysWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // 返回章节页，并传递true表示quiz已完成，需要刷新进度
              context.pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryColor ?? const Color(0xFF9556FF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              passed
                  ? 'learn_quiz_back_to_course'.tr()
                  : 'learn_quiz_back_to_study'.tr(),
              style: context.textStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
