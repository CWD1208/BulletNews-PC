import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'splash_page_1.dart';
import 'splash_page_2.dart';
import 'splash_page_3.dart';

class SplashFlow extends StatefulWidget {
  const SplashFlow({super.key});

  @override
  State<SplashFlow> createState() => _SplashFlowState();
}

class _SplashFlowState extends State<SplashFlow> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _completeSplash();
    }
  }

  Future<void> _completeSplash() async {
    await StorageService().setBool(AppConstants.keySplashCompleted, true);
    if (mounted) {
      // 跳转到 home 页面
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SplashPage1(onNext: _nextPage),
        SplashPage2(onNext: _nextPage),
        SplashPage3(onNext: _completeSplash),
      ],
    );
  }
}
