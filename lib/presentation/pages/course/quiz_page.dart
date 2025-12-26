import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/toast_util.dart';
import 'package:stockc/data/models/chapter_model.dart';
import 'package:stockc/data/models/quiz_question_model.dart';
import 'package:stockc/data/models/quiz_result_model.dart';
import 'package:stockc/data/repositories/course_repository.dart';
import 'package:stockc/presentation/pages/course/quiz_result_page.dart';

/// 练习页面
class QuizPage extends StatefulWidget {
  final ChapterModel chapter;

  const QuizPage({super.key, required this.chapter});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final CourseRepository _repository = CourseRepository();
  final PageController _pageController = PageController();
  late List<QuizQuestionModel> _questions;
  final Map<String, int?> _answers = {}; // questionId -> selectedIndex
  int _currentIndex = 0;
  bool _showResult = false;
  QuizResultModel? _result;

  @override
  void initState() {
    super.initState();
    _questions = _repository.getQuizQuestionsByChapter(widget.chapter.id);
    // 检查是否有已完成的记录（如果已完成，直接显示结果页）
    final savedResult = _repository.getQuizResult(widget.chapter.id);
    if (savedResult != null) {
      _result = savedResult;
      _showResult = true;
      // 恢复答案
      for (var answer in savedResult.answers) {
        _answers[answer.questionId] = answer.selectedIndex;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    setState(() {
      _answers[_questions[_currentIndex].id] = index;
    });
  }

  Future<void> _nextQuestion() async {
    final currentQuestion = _questions[_currentIndex];
    if (_answers[currentQuestion.id] == null) {
      // 显示提示
      Toast.normal('learn_quiz_please_answer'.tr());
      return;
    }

    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 完成所有题目，计算分数
      await _calculateResult();
    }
  }

  Future<void> _calculateResult() async {
    int totalScore = 0;
    final List<QuestionAnswer> answers = [];

    for (var question in _questions) {
      final selectedIndex = _answers[question.id];
      final isCorrect = selectedIndex == question.correctAnswerIndex;
      if (isCorrect) {
        totalScore += question.score;
      }
      answers.add(
        QuestionAnswer(
          questionId: question.id,
          selectedIndex: selectedIndex ?? -1,
          correctIndex: question.correctAnswerIndex,
          isCorrect: isCorrect,
        ),
      );
    }

    // 固定5道题，每题20分，满分100分
    final maxScore = 100;
    // 计算实际得分（限制在100分以内）
    final actualScore = (totalScore * 100 / (_questions.length * 20))
        .round()
        .clamp(0, 100);
    final passed = actualScore >= 80;

    _result = QuizResultModel(
      chapterId: widget.chapter.id,
      totalScore: actualScore,
      maxScore: maxScore,
      passed: passed,
      answers: answers,
      completedAt: DateTime.now(),
    );

    // 保存结果
    await _repository.saveQuizResult(_result!);

    // 更新章节进度：超过80分就是100%，80分以下根据分数计算进度
    final progress = passed ? 100 : actualScore;
    await _repository.setChapterProgress(widget.chapter.id, progress);

    if (mounted) {
      setState(() {
        _showResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 如果已完成quiz，显示结果页面
    if (_showResult && _result != null) {
      return QuizResultPage(result: _result!, chapter: widget.chapter);
    }

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
              Expanded(
                child: Container(
                  // height: _questions.length * 80,
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
                          physics: const PageScrollPhysics(), // 练习模式允许滑动
                          itemCount: _questions.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
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
              _buildBottomButton(context, colors),
              Container(
                constraints: BoxConstraints(minHeight: 100),
                // child: Text('test'),
              ),
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
            onPressed: () => context.pop(),
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
    final selectedIndex = _answers[question.id];

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
            final isSelected = selectedIndex == optionIndex;
            final isLast = optionIndex == question.options.length - 1;

            Color? backgroundColor;
            Color? textColor;
            Color? borderColor;

            if (isSelected) {
              backgroundColor = (colors.primaryColor ?? const Color(0xFF9556FF))
                  .withOpacity(0.1);
              textColor = colors.primaryColor ?? const Color(0xFF9556FF);
              borderColor = colors.primaryColor ?? const Color(0xFF9556FF);
            }

            return GestureDetector(
              onTap: () => _selectAnswer(optionIndex),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
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
                              String.fromCharCode(
                                65 + optionIndex,
                              ), // A, B, C, D
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
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child:
                        selectedIndex != null && selectedIndex == optionIndex
                            ? Image.asset(
                              'assets/icons/ai/selected.png',
                              width: 24,
                              height: 24,
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton(BuildContext context, ExtColors colors) {
    // 练习模式：显示下一题/提交按钮
    final isLastQuestion = _currentIndex == _questions.length - 1;
    final hasAnswer = _answers[_questions[_currentIndex].id] != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: hasAnswer ? _nextQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryColor ?? const Color(0xFF9556FF),
              disabledBackgroundColor: colors.lightGray,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              isLastQuestion
                  ? 'learn_quiz_submit'.tr()
                  : 'learn_quiz_next'.tr(),
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
