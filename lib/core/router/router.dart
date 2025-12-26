import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/presentation/pages/splash/splash_flow.dart';
import 'package:stockc/presentation/pages/startPage/start_page.dart';
import 'package:stockc/presentation/pages/home/home_page.dart';
import 'package:stockc/presentation/pages/report/report_page.dart';
import 'package:stockc/presentation/pages/news/news_detail_page.dart';
import 'package:stockc/data/models/news_model.dart';
import 'package:stockc/data/models/course_model.dart';
import 'package:stockc/data/models/chapter_model.dart';
import 'package:stockc/data/models/lesson_model.dart';
import 'package:stockc/presentation/pages/course/course_detail_page.dart';
import 'package:stockc/presentation/pages/course/chapter_detail_page.dart';
import 'package:stockc/presentation/pages/course/lesson_page.dart';
import 'package:stockc/presentation/pages/course/quiz_page.dart';
import 'package:stockc/presentation/pages/settings/language_page.dart';
import 'package:stockc/presentation/pages/settings/faq_page.dart';
import 'package:stockc/presentation/pages/home/tabs/ai/ai_chat_history_page.dart';
import 'package:stockc/presentation/pages/home/tabs/ai/ai_chat_page.dart';

/// 全局 Navigator Key，用于在无 context 的情况下显示 Toast
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

// Very basic Login Page for demo
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate login success -> Back to Home
            context.go('/');
          },
          child: const Text('Simulate Login Success'),
        ),
      ),
    );
  }
}

/// 路由配置
///
/// 如何添加新路由：
/// 1. 在 routes 数组中添加新的 GoRoute
/// 2. 指定 path（路径）和 builder（页面构建器）
///
/// 示例：
/// ```dart
/// GoRoute(
///   path: '/home',
///   builder: (context, state) => const HomePage(),
/// ),
/// ```
///
/// 嵌套路由示例：
/// ```dart
/// GoRoute(
///   path: '/user',
///   builder: (context, state) => const UserPage(),
///   routes: [
///     GoRoute(
///       path: 'profile',
///       builder: (context, state) => const UserProfilePage(),
///     ),
///   ],
/// ),
/// ```
///
/// 使用路由导航：
/// - context.go('/path') - 跳转到新路由（替换当前路由栈）
/// - context.push('/path') - 推入新路由（保留路由栈）
/// - context.pop() - 返回上一页
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const StartPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/splash', builder: (context, state) => const SplashFlow()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/report', builder: (context, state) => const ReportPage()),
    GoRoute(
      path: '/news/:id',
      builder: (context, state) {
        final news = state.extra as NewsModel?;
        if (news == null) {
          // 如果没有传递 news，返回首页
          return const HomePage();
        }
        return NewsDetailPage(news: news);
      },
    ),
    // 课程详情页
    GoRoute(
      path: '/course/:id',
      builder: (context, state) {
        final course = state.extra as CourseModel?;
        if (course == null) {
          return const HomePage();
        }
        return CourseDetailPage(course: course);
      },
    ),
    // 章节详情页
    GoRoute(
      path: '/chapter/:id',
      builder: (context, state) {
        final chapter = state.extra as ChapterModel?;
        if (chapter == null) {
          return const HomePage();
        }
        return ChapterDetailPage(chapter: chapter);
      },
    ),
    // 课程学习页
    GoRoute(
      path: '/lesson/:id',
      builder: (context, state) {
        final lesson = state.extra as LessonModel?;
        if (lesson == null) {
          return const HomePage();
        }
        return LessonPage(lesson: lesson);
      },
    ),
    // 练习页
    GoRoute(
      path: '/quiz/:id',
      builder: (context, state) {
        final chapter = state.extra as ChapterModel?;
        if (chapter == null) {
          return const HomePage();
        }
        return QuizPage(chapter: chapter);
      },
    ),
    // 语言选择页
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguagePage(),
    ),
    // FAQ页
    GoRoute(path: '/faq', builder: (context, state) => const FaqPage()),
    // AI聊天历史记录页
    GoRoute(
      path: '/ai/history',
      builder: (context, state) => const AiChatHistoryPage(),
    ),
    // AI聊天页
    GoRoute(path: '/ai/chat', builder: (context, state) => const AiChatPage()),
  ],
);

/// A top-level function to setup 401 listener
void setupAuthListener() {
  DioClient().onUnauthorized.listen((_) {
    router.go('/login');
  });
}
