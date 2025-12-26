import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/course_model.dart';
import 'package:stockc/data/repositories/course_repository.dart';
import 'package:stockc/presentation/pages/home/tabs/book/widgets/course_card.dart';

class BookTab extends StatefulWidget {
  const BookTab({super.key});

  @override
  State<BookTab> createState() => _BookTabState();
}

class _BookTabState extends State<BookTab> {
  final CourseRepository _courseRepository = CourseRepository();
  late List<CourseModel> _courses;

  @override
  void initState() {
    super.initState();
    _courses = _courseRepository.getAllCourses();
    // 初始化默认进度
    _courseRepository.initializeDefaultProgress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 当页面重新显示时刷新进度
    setState(() {});
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
              // 标题
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'learn_title'.tr(),
                    style: context.textStyles.title.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // 课程列表
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // 课程卡片列表
                      ..._courses.map((course) {
                        final progress = _courseRepository.getCourseProgress(
                          course.id,
                        );
                        return CourseCard(
                          course: course,
                          progress: progress,
                          onTap: () {
                            // 直接跳转到章节详情页（获取第一个章节）
                            final chapters = _courseRepository
                                .getChaptersByCourse(course.id);
                            if (chapters.isNotEmpty) {
                              context.push(
                                '/chapter/${chapters.first.id}',
                                extra: chapters.first,
                              );
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 24),
                      // Vestor AI FAQ 按钮
                      _buildFaqButton(context, colors),
                      const SizedBox(height: 20),
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

  /// 构建 FAQ 按钮
  Widget _buildFaqButton(BuildContext context, ExtColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.primaryColor ?? const Color(0xFF9556FF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'learn_faq_button'.tr(),
        style: context.textStyles.body.copyWith(
          fontSize: 12,
          color: colors.primaryColor ?? const Color(0xFF9556FF),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
