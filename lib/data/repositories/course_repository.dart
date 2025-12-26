import 'dart:convert';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/data/models/course_model.dart';
import 'package:stockc/data/models/chapter_model.dart';
import 'package:stockc/data/models/lesson_model.dart';
import 'package:stockc/data/models/quiz_question_model.dart';
import 'package:stockc/data/models/quiz_result_model.dart';

/// 课程 Repository
class CourseRepository {
  final StorageService _storage = StorageService();

  /// 获取所有课程列表
  List<CourseModel> getAllCourses() {
    return const [
      CourseModel(
        id: 'course_01',
        titleKey: 'learn_course_01_title',
        iconPath: 'assets/icons/book/learn-01.png',
        bannerPath: 'assets/icons/book/learn01-banner.png',
      ),
      CourseModel(
        id: 'course_02',
        titleKey: 'learn_course_02_title',
        iconPath: 'assets/icons/book/learn-02.png',
        bannerPath: 'assets/icons/book/learn02-banner.png',
      ),
      CourseModel(
        id: 'course_03',
        titleKey: 'learn_course_03_title',
        iconPath: 'assets/icons/book/learn-03.png',
        bannerPath: 'assets/icons/book/learn03-banner.png',
      ),
      CourseModel(
        id: 'course_04',
        titleKey: 'learn_course_04_title',
        iconPath: 'assets/icons/book/learn-04.png',
        bannerPath: 'assets/icons/book/learn04-banner.png',
      ),
    ];
  }

  /// 获取课程进度（0-100）
  int getCourseProgress(String courseId) {
    final key = AppConstants.getCourseProgressKey(courseId);
    final progress = _storage.getInt(key);
    // 如果没有设置过进度，返回默认值
    if (progress == null) {
      return 0;
    }
    return progress;
  }

  /// 初始化默认进度（首次使用时调用）
  Future<void> initializeDefaultProgress() async {
    // 所有课程默认进度为0，不需要初始化
  }

  /// 设置课程进度（0-100）
  Future<bool> setCourseProgress(String courseId, int progress) async {
    final key = AppConstants.getCourseProgressKey(courseId);
    // 确保进度在0-100之间
    final clampedProgress = progress.clamp(0, 100);
    return await _storage.setInt(key, clampedProgress);
  }

  /// 获取课程的所有章节
  List<ChapterModel> getChaptersByCourse(String courseId) {
    switch (courseId) {
      case 'course_01':
        return const [
          ChapterModel(
            id: 'chapter_01_01',
            courseId: 'course_01',
            titleKey: 'learn_chapter_01_01_title',
            lessonCount: 6,
            viewCount: 19321,
          ),
        ];
      case 'course_02':
        return const [
          ChapterModel(
            id: 'chapter_02_01',
            courseId: 'course_02',
            titleKey: 'learn_chapter_02_01_title',
            lessonCount: 6,
            viewCount: 15234,
          ),
        ];
      case 'course_03':
        return const [
          ChapterModel(
            id: 'chapter_03_01',
            courseId: 'course_03',
            titleKey: 'learn_chapter_03_01_title',
            lessonCount: 5,
            viewCount: 12890,
          ),
        ];
      case 'course_04':
        return const [
          ChapterModel(
            id: 'chapter_04_01',
            courseId: 'course_04',
            titleKey: 'learn_chapter_04_01_title',
            lessonCount: 5,
            viewCount: 11234,
          ),
        ];
      default:
        return [];
    }
  }

  /// 获取章节的所有课程小节
  List<LessonModel> getLessonsByChapter(String chapterId) {
    switch (chapterId) {
      case 'chapter_01_01':
        return const [
          LessonModel(
            id: 'lesson_01_01_01',
            chapterId: 'chapter_01_01',
            titleKey: 'learn_lesson_01_01_01_title',
            aiQuestion: 'Explain what a stock is and what it means to own one.',
          ),
          LessonModel(
            id: 'lesson_01_01_02',
            chapterId: 'chapter_01_01',
            titleKey: 'learn_lesson_01_01_02_title',
            aiQuestion:
                'How do stock exchanges work and what role do they play in trading?',
          ),
          LessonModel(
            id: 'lesson_01_01_03',
            chapterId: 'chapter_01_01',
            titleKey: 'learn_lesson_01_01_03_title',
            aiQuestion:
                'How do stock exchanges work and what role do they play in trading?',
          ),
          LessonModel(
            id: 'lesson_01_01_04',
            chapterId: 'chapter_01_01',
            titleKey: 'learn_lesson_01_01_04_title',
            aiQuestion:
                'Explain bid, ask, and spread in stocks and how they affect trading.',
          ),
          LessonModel(
            id: 'lesson_01_01_05',
            chapterId: 'chapter_01_01',
            titleKey: 'learn_lesson_01_01_05_title',
            aiQuestion:
                'What are market orders and limit orders, and how are they different?',
          ),
          LessonModel(
            id: 'lesson_01_01_06',
            chapterId: 'chapter_01_01',
            titleKey: 'learn_lesson_01_01_06_title',
            aiQuestion: 'What are stock indices and what do they measure?',
          ),
        ];
      case 'chapter_02_01':
        return const [
          LessonModel(
            id: 'lesson_02_01_01',
            chapterId: 'chapter_02_01',
            titleKey: 'learn_lesson_02_01_01_title',
            aiQuestion: 'What factors can cause stock prices to change?',
          ),
          LessonModel(
            id: 'lesson_02_01_02',
            chapterId: 'chapter_02_01',
            titleKey: 'learn_lesson_02_01_02_title',
            aiQuestion: 'Explain how supply and demand affect stock prices.',
          ),
          LessonModel(
            id: 'lesson_02_01_03',
            chapterId: 'chapter_02_01',
            titleKey: 'learn_lesson_02_01_03_title',
            aiQuestion:
                'What are company financial statements and why are they important?',
          ),
          LessonModel(
            id: 'lesson_02_01_04',
            chapterId: 'chapter_02_01',
            titleKey: 'learn_lesson_02_01_04_title',
            aiQuestion:
                'How do earnings reports work and what can they tell investors?',
          ),
          LessonModel(
            id: 'lesson_02_01_05',
            chapterId: 'chapter_02_01',
            titleKey: 'learn_lesson_02_01_05_title',
            aiQuestion:
                'How does market sentiment and news affect stock prices?',
          ),
          LessonModel(
            id: 'lesson_02_01_06',
            chapterId: 'chapter_02_01',
            titleKey: 'learn_lesson_02_01_06_title',
            aiQuestion:
                'What are dividends and how do they affect stock returns?',
          ),
        ];
      case 'chapter_03_01':
        return const [
          LessonModel(
            id: 'lesson_03_01_01',
            chapterId: 'chapter_03_01',
            titleKey: 'learn_lesson_03_01_01_title',
            aiQuestion:
                'What is an investment portfolio and why is it important?',
          ),
          LessonModel(
            id: 'lesson_03_01_02',
            chapterId: 'chapter_03_01',
            titleKey: 'learn_lesson_03_01_02_title',
            aiQuestion:
                'What is diversification and how does it help reduce risk?',
          ),
          LessonModel(
            id: 'lesson_03_01_03',
            chapterId: 'chapter_03_01',
            titleKey: 'learn_lesson_03_01_03_title',
            aiQuestion:
                'Explain the relationship between risk and reward in investing.',
          ),
          LessonModel(
            id: 'lesson_03_01_04',
            chapterId: 'chapter_03_01',
            titleKey: 'learn_lesson_03_01_04_title',
            aiQuestion:
                'What\'s the difference between growth and value stocks?',
          ),
          LessonModel(
            id: 'lesson_03_01_05',
            chapterId: 'chapter_03_01',
            titleKey: 'learn_lesson_03_01_05_title',
            aiQuestion:
                'What\'s the difference between long-term and short-term investing?',
          ),
        ];
      case 'chapter_04_01':
        return const [
          LessonModel(
            id: 'lesson_04_01_01',
            chapterId: 'chapter_04_01',
            titleKey: 'learn_lesson_04_01_01_title',
            aiQuestion:
                'Explain how to read a stock quote and what information it shows.',
          ),
          LessonModel(
            id: 'lesson_04_01_02',
            chapterId: 'chapter_04_01',
            titleKey: 'learn_lesson_04_01_02_title',
            aiQuestion:
                'How do candlestick charts work and what do they tell investors?',
          ),
          LessonModel(
            id: 'lesson_04_01_03',
            chapterId: 'chapter_04_01',
            titleKey: 'learn_lesson_04_01_03_title',
            aiQuestion:
                'What are key financial ratios and how are they used to analyze stocks?',
          ),
          LessonModel(
            id: 'lesson_04_01_04',
            chapterId: 'chapter_04_01',
            titleKey: 'learn_lesson_04_01_04_title',
            aiQuestion: 'What is EPS and why is it important for investors?',
          ),
          LessonModel(
            id: 'lesson_04_01_05',
            chapterId: 'chapter_04_01',
            titleKey: 'learn_lesson_04_01_05_title',
            aiQuestion: 'What is the P/E ratio and how is it interpreted?',
          ),
        ];
      default:
        return [];
    }
  }

  /// 获取章节的练习题目
  List<QuizQuestionModel> getQuizQuestionsByChapter(String chapterId) {
    switch (chapterId) {
      case 'chapter_01_01':
        return const [
          QuizQuestionModel(
            id: 'quiz_01_01_01',
            chapterId: 'chapter_01_01',
            questionKey: 'learn_quiz_01_01_01_question',
            options: [
              'learn_quiz_01_01_01_option_a',
              'learn_quiz_01_01_01_option_b',
              'learn_quiz_01_01_01_option_c',
              'learn_quiz_01_01_01_option_d',
            ],
            correctAnswerIndex: 1,
          ),
          QuizQuestionModel(
            id: 'quiz_01_01_02',
            chapterId: 'chapter_01_01',
            questionKey: 'learn_quiz_01_01_02_question',
            options: [
              'learn_quiz_01_01_02_option_a',
              'learn_quiz_01_01_02_option_b',
              'learn_quiz_01_01_02_option_c',
              'learn_quiz_01_01_02_option_d',
            ],
            correctAnswerIndex: 2,
          ),
          QuizQuestionModel(
            id: 'quiz_01_01_03',
            chapterId: 'chapter_01_01',
            questionKey: 'learn_quiz_01_01_03_question',
            options: [
              'learn_quiz_01_01_03_option_a',
              'learn_quiz_01_01_03_option_b',
              'learn_quiz_01_01_03_option_c',
              'learn_quiz_01_01_03_option_d',
            ],
            correctAnswerIndex: 1,
          ),
          QuizQuestionModel(
            id: 'quiz_01_01_04',
            chapterId: 'chapter_01_01',
            questionKey: 'learn_quiz_01_01_04_question',
            options: [
              'learn_quiz_01_01_04_option_a',
              'learn_quiz_01_01_04_option_b',
              'learn_quiz_01_01_04_option_c',
              'learn_quiz_01_01_04_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_01_01_05',
            chapterId: 'chapter_01_01',
            questionKey: 'learn_quiz_01_01_05_question',
            options: [
              'learn_quiz_01_01_05_option_a',
              'learn_quiz_01_01_05_option_b',
              'learn_quiz_01_01_05_option_c',
              'learn_quiz_01_01_05_option_d',
            ],
            correctAnswerIndex: 1,
          ),
          QuizQuestionModel(
            id: 'quiz_01_01_06',
            chapterId: 'chapter_01_01',
            questionKey: 'learn_quiz_01_01_06_question',
            options: [
              'learn_quiz_01_01_06_option_a',
              'learn_quiz_01_01_06_option_b',
              'learn_quiz_01_01_06_option_c',
              'learn_quiz_01_01_06_option_d',
            ],
            correctAnswerIndex: 1,
          ),
        ];
      case 'chapter_02_01':
        return const [
          QuizQuestionModel(
            id: 'quiz_02_01_01',
            chapterId: 'chapter_02_01',
            questionKey: 'learn_quiz_02_01_01_question',
            options: [
              'learn_quiz_02_01_01_option_a',
              'learn_quiz_02_01_01_option_b',
              'learn_quiz_02_01_01_option_c',
              'learn_quiz_02_01_01_option_d',
            ],
            correctAnswerIndex: 3,
          ),
          QuizQuestionModel(
            id: 'quiz_02_01_02',
            chapterId: 'chapter_02_01',
            questionKey: 'learn_quiz_02_01_02_question',
            options: [
              'learn_quiz_02_01_02_option_a',
              'learn_quiz_02_01_02_option_b',
              'learn_quiz_02_01_02_option_c',
              'learn_quiz_02_01_02_option_d',
            ],
            correctAnswerIndex: 1,
          ),
          QuizQuestionModel(
            id: 'quiz_02_01_03',
            chapterId: 'chapter_02_01',
            questionKey: 'learn_quiz_02_01_03_question',
            options: [
              'learn_quiz_02_01_03_option_a',
              'learn_quiz_02_01_03_option_b',
              'learn_quiz_02_01_03_option_c',
              'learn_quiz_02_01_03_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_02_01_04',
            chapterId: 'chapter_02_01',
            questionKey: 'learn_quiz_02_01_04_question',
            options: [
              'learn_quiz_02_01_04_option_a',
              'learn_quiz_02_01_04_option_b',
              'learn_quiz_02_01_04_option_c',
              'learn_quiz_02_01_04_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_02_01_05',
            chapterId: 'chapter_02_01',
            questionKey: 'learn_quiz_02_01_05_question',
            options: [
              'learn_quiz_02_01_05_option_a',
              'learn_quiz_02_01_05_option_b',
              'learn_quiz_02_01_05_option_c',
              'learn_quiz_02_01_05_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_02_01_06',
            chapterId: 'chapter_02_01',
            questionKey: 'learn_quiz_02_01_06_question',
            options: [
              'learn_quiz_02_01_06_option_a',
              'learn_quiz_02_01_06_option_b',
              'learn_quiz_02_01_06_option_c',
              'learn_quiz_02_01_06_option_d',
            ],
            correctAnswerIndex: 2,
          ),
        ];
      case 'chapter_03_01':
        return const [
          QuizQuestionModel(
            id: 'quiz_03_01_01',
            chapterId: 'chapter_03_01',
            questionKey: 'learn_quiz_03_01_01_question',
            options: [
              'learn_quiz_03_01_01_option_a',
              'learn_quiz_03_01_01_option_b',
              'learn_quiz_03_01_01_option_c',
              'learn_quiz_03_01_01_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_03_01_02',
            chapterId: 'chapter_03_01',
            questionKey: 'learn_quiz_03_01_02_question',
            options: [
              'learn_quiz_03_01_02_option_a',
              'learn_quiz_03_01_02_option_b',
              'learn_quiz_03_01_02_option_c',
              'learn_quiz_03_01_02_option_d',
            ],
            correctAnswerIndex: 1,
          ),
          QuizQuestionModel(
            id: 'quiz_03_01_03',
            chapterId: 'chapter_03_01',
            questionKey: 'learn_quiz_03_01_03_question',
            options: [
              'learn_quiz_03_01_03_option_a',
              'learn_quiz_03_01_03_option_b',
              'learn_quiz_03_01_03_option_c',
              'learn_quiz_03_01_03_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_03_01_04',
            chapterId: 'chapter_03_01',
            questionKey: 'learn_quiz_03_01_04_question',
            options: [
              'learn_quiz_03_01_04_option_a',
              'learn_quiz_03_01_04_option_b',
              'learn_quiz_03_01_04_option_c',
              'learn_quiz_03_01_04_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_03_01_05',
            chapterId: 'chapter_03_01',
            questionKey: 'learn_quiz_03_01_05_question',
            options: [
              'learn_quiz_03_01_05_option_a',
              'learn_quiz_03_01_05_option_b',
              'learn_quiz_03_01_05_option_c',
              'learn_quiz_03_01_05_option_d',
            ],
            correctAnswerIndex: 1,
          ),
        ];
      case 'chapter_04_01':
        return const [
          QuizQuestionModel(
            id: 'quiz_04_01_01',
            chapterId: 'chapter_04_01',
            questionKey: 'learn_quiz_04_01_01_question',
            options: [
              'learn_quiz_04_01_01_option_a',
              'learn_quiz_04_01_01_option_b',
              'learn_quiz_04_01_01_option_c',
              'learn_quiz_04_01_01_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_04_01_02',
            chapterId: 'chapter_04_01',
            questionKey: 'learn_quiz_04_01_02_question',
            options: [
              'learn_quiz_04_01_02_option_a',
              'learn_quiz_04_01_02_option_b',
              'learn_quiz_04_01_02_option_c',
              'learn_quiz_04_01_02_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_04_01_03',
            chapterId: 'chapter_04_01',
            questionKey: 'learn_quiz_04_01_03_question',
            options: [
              'learn_quiz_04_01_03_option_a',
              'learn_quiz_04_01_03_option_b',
              'learn_quiz_04_01_03_option_c',
              'learn_quiz_04_01_03_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_04_01_04',
            chapterId: 'chapter_04_01',
            questionKey: 'learn_quiz_04_01_04_question',
            options: [
              'learn_quiz_04_01_04_option_a',
              'learn_quiz_04_01_04_option_b',
              'learn_quiz_04_01_04_option_c',
              'learn_quiz_04_01_04_option_d',
            ],
            correctAnswerIndex: 0,
          ),
          QuizQuestionModel(
            id: 'quiz_04_01_05',
            chapterId: 'chapter_04_01',
            questionKey: 'learn_quiz_05_01_05_question',
            options: [
              'learn_quiz_04_01_05_option_a',
              'learn_quiz_04_01_05_option_b',
              'learn_quiz_04_01_05_option_c',
              'learn_quiz_04_01_05_option_d',
            ],
            correctAnswerIndex: 0,
          ),
        ];
      default:
        return [];
    }
  }

  /// 获取章节进度（0或100）
  int getChapterProgress(String chapterId) {
    final key = AppConstants.getChapterProgressKey(chapterId);
    return _storage.getInt(key) ?? 0;
  }

  /// 设置章节进度（0或100）
  Future<bool> setChapterProgress(String chapterId, int progress) async {
    final key = AppConstants.getChapterProgressKey(chapterId);
    final clampedProgress = progress.clamp(0, 100);
    final result = await _storage.setInt(key, clampedProgress);
    // 更新课程进度（等待保存完成后再更新）
    await _updateCourseProgress(chapterId);
    return result;
  }

  /// 更新课程进度（根据所有章节进度计算平均值）
  Future<void> _updateCourseProgress(String chapterId) async {
    // 找到章节所属的课程
    String? courseId;
    if (chapterId.startsWith('chapter_01')) {
      courseId = 'course_01';
    } else if (chapterId.startsWith('chapter_02')) {
      courseId = 'course_02';
    } else if (chapterId.startsWith('chapter_03')) {
      courseId = 'course_03';
    } else if (chapterId.startsWith('chapter_04')) {
      courseId = 'course_04';
    }

    if (courseId != null) {
      final chapters = getChaptersByCourse(courseId);
      if (chapters.isEmpty) return;

      int totalProgress = 0;
      for (var chapter in chapters) {
        totalProgress += getChapterProgress(chapter.id);
      }
      final avgProgress = (totalProgress / chapters.length).round();
      await setCourseProgress(courseId, avgProgress);
    }
  }

  /// 获取上次学习的课程ID
  String? getLastLearnedLesson(String chapterId) {
    final key = AppConstants.getLastLearnedLessonKey(chapterId);
    return _storage.getString(key);
  }

  /// 设置上次学习的课程ID
  Future<bool> setLastLearnedLesson(String chapterId, String lessonId) async {
    final key = AppConstants.getLastLearnedLessonKey(chapterId);
    return await _storage.setString(key, lessonId);
  }

  /// 保存练习结果
  Future<bool> saveQuizResult(QuizResultModel result) async {
    final key = AppConstants.getQuizResultKey(result.chapterId);
    // 将结果序列化为JSON字符串存储
    final resultJson = {
      'chapterId': result.chapterId,
      'totalScore': result.totalScore,
      'maxScore': result.maxScore,
      'passed': result.passed,
      'answers':
          result.answers
              .map(
                (a) => {
                  'questionId': a.questionId,
                  'selectedIndex': a.selectedIndex,
                  'correctIndex': a.correctIndex,
                  'isCorrect': a.isCorrect,
                },
              )
              .toList(),
      'completedAt': result.completedAt.toIso8601String(),
    };
    // 使用JSON编码保存
    return await _storage.setString(key, jsonEncode(resultJson));
  }

  /// 获取练习结果
  QuizResultModel? getQuizResult(String chapterId) {
    final key = AppConstants.getQuizResultKey(chapterId);
    final resultStr = _storage.getString(key);
    if (resultStr == null) return null;

    try {
      // 解析JSON
      final resultJson = jsonDecode(resultStr) as Map<String, dynamic>;

      // 解析answers
      final answersList = resultJson['answers'] as List<dynamic>;
      final answers =
          answersList.map((a) {
            final answerMap = a as Map<String, dynamic>;
            return QuestionAnswer(
              questionId: answerMap['questionId'] as String,
              selectedIndex: answerMap['selectedIndex'] as int,
              correctIndex: answerMap['correctIndex'] as int,
              isCorrect: answerMap['isCorrect'] as bool,
            );
          }).toList();

      // 创建结果对象
      return QuizResultModel(
        chapterId: resultJson['chapterId'] as String,
        totalScore: resultJson['totalScore'] as int,
        maxScore: resultJson['maxScore'] as int,
        passed: resultJson['passed'] as bool,
        answers: answers,
        completedAt: DateTime.parse(resultJson['completedAt'] as String),
      );
    } catch (e) {
      // 解析失败，返回null
      return null;
    }
  }

  /// 检查章节是否已通过练习
  bool isChapterPassed(String chapterId) {
    return getChapterProgress(chapterId) == 100;
  }
}
