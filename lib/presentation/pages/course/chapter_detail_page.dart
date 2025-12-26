import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/chapter_model.dart';
import 'package:stockc/data/models/course_model.dart';
import 'package:stockc/data/models/lesson_model.dart';
import 'package:stockc/data/repositories/course_repository.dart';

/// 章节详情页面
class ChapterDetailPage extends StatefulWidget {
  final ChapterModel chapter;

  const ChapterDetailPage({super.key, required this.chapter});

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  final CourseRepository _repository = CourseRepository();
  late List<LessonModel> _lessons;
  late CourseModel _course;
  String? _lastLearnedLessonId;

  @override
  void initState() {
    super.initState();
    _lessons = _repository.getLessonsByChapter(widget.chapter.id);
    _lastLearnedLessonId = _repository.getLastLearnedLesson(widget.chapter.id);
    // 获取课程信息
    final courses = _repository.getAllCourses();
    _course = courses.firstWhere((c) => c.id == widget.chapter.courseId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 刷新上次学习位置
    final newLastLearned = _repository.getLastLearnedLesson(widget.chapter.id);
    if (newLastLearned != _lastLearnedLessonId) {
      _lastLearnedLessonId = newLastLearned;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPassed = _repository.isChapterPassed(widget.chapter.id);

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // 课程Banner
                      _buildCourseBanner(context, colors),
                      const SizedBox(height: 16),
                      // 课程列表
                      Container(
                        decoration: BoxDecoration(
                          color: colors.alwaysWhite,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chapters标题
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  Text(
                                    'learn_chapters_title'.tr(),
                                    style: context.textStyles.title.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'learn_chapters_subtitle'.tr(),
                                    style: context
                                        .textStyles
                                        .aiButtonTextDisabled
                                        .copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: colors.lightGray, height: 0.5),
                            ..._lessons.asMap().entries.map((entry) {
                              final index = entry.key;
                              final lesson = entry.value;
                              final isLastLearned =
                                  lesson.id == _lastLearnedLessonId;
                              return _buildLessonCard(
                                context,
                                colors,
                                lesson,
                                index + 1,
                                isLastLearned,
                              );
                            }),
                            // const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      // 底部按钮
                      _buildBottomButtons(context, colors, isPassed),
                    ],
                  ),
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            color: colors.textPrimary,
          ),
        ],
      ),
    );
  }

  /// 构建课程Banner
  Widget _buildCourseBanner(BuildContext context, ExtColors colors) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(_course.bannerPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _course.titleKey.tr(),
                style: context.textStyles.title.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.chapter.viewCount}',
                    style: context.textStyles.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建课程卡片
  Widget _buildLessonCard(
    BuildContext context,
    ExtColors colors,
    LessonModel lesson,
    int index,
    bool isLastLearned,
  ) {
    return GestureDetector(
      onTap: () {
        _repository.setLastLearnedLesson(widget.chapter.id, lesson.id);
        // 跳转到AI学习页面
        context.push('/lesson/${lesson.id}', extra: lesson);
      },
      child: Container(
        // margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: colors.alwaysWhite),
        child: Row(
          children: [
            // 课程序号图标
            Image.asset(
              'assets/icons/book/${isLastLearned ? 'book-sel' : 'book'}.png',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 12),
            // 课程标题
            Expanded(
              child: Text(
                lesson.titleKey.tr(),
                style: context.textStyles.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButtons(
    BuildContext context,
    ExtColors colors,
    bool isPassed,
  ) {
    return Row(
      children: [
        // 开始学习按钮
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // 从上次学习的位置开始，如果没有则从第一课开始
              final lessonId = _lastLearnedLessonId ?? _lessons.first.id;
              final lesson = _lessons.firstWhere((l) => l.id == lessonId);
              _repository.setLastLearnedLesson(widget.chapter.id, lesson.id);
              context.push('/lesson/${lesson.id}', extra: lesson);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryColor ?? const Color(0xFF9556FF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'learn_start_learning'.tr(),
              style: context.textStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 课后练习按钮
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final result = await context.push(
                '/quiz/${widget.chapter.id}',
                extra: widget.chapter,
              );
              // 如果quiz完成返回，刷新页面状态
              if (result != null && mounted) {
                // 使用 addPostFrameCallback 确保在下一帧更新，避免在导航过程中更新状态
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {});
                  }
                });
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color:
                    isPassed
                        ? Colors.green
                        : (colors.primaryColor ?? const Color(0xFF9556FF)),
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              isPassed ? 'learn_quiz_completed'.tr() : 'learn_quiz_button'.tr(),
              style: context.textStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    isPassed
                        ? Colors.green
                        : (colors.primaryColor ?? const Color(0xFF9556FF)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
