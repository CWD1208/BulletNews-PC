import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    _checkSplashStatus();
  }

  Future<void> _checkSplashStatus() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.go('/splash/pb');
      }
    });
    return;

    // 检查是否展示过 splash 页面
    final splashCompleted =
        StorageService().getBool(AppConstants.keySplashCompleted) ?? false;

    if (mounted) {
      if (!splashCompleted) {
        // 如果没有展示过，跳转到 splash_flow
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.go('/splash');
          }
        });
      } else {
        // 如果展示过，跳转到 home 页面
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.go('/home');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.sidebarColor,
      body: Container(
        decoration: BoxDecoration(
          image:
              isDark
                  ? null
                  : const DecorationImage(
                    image: AssetImage('assets/icons/splash/img-bg.png'),
                    fit: BoxFit.cover,
                  ),
          color: isDark ? colors.sidebarColor : null,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/icons/global/logo.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  'app_name'.tr(),
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.functionInfo ?? const Color(0xFF9556FF),
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'app_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
