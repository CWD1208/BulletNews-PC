import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/services/appsflyer_service.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:go_router/go_router.dart';

/// Splash PB 页面 - Welcome to Vestor AI
class SplashPbPage extends StatefulWidget {
  final VoidCallback? onNext;
  const SplashPbPage({super.key, this.onNext});

  @override
  State<SplashPbPage> createState() => _SplashPbPageState();
}

class _SplashPbPageState extends State<SplashPbPage> {
  @override
  void initState() {
    super.initState();

    // Splash 界面成功展示时触发 splash_show 埋点
    _logSplashShow();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        context.go('/splash/pb/2');
      }
    });
  }

  Future<void> _logSplashShow() async {
    try {
      await AppsFlyerService().logEvent('splash_show');
    } catch (e) {
      // 埋点失败不影响页面展示
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colors.primaryColor ?? const Color(0xFF9556FF);

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // AI Icon - 紫色圆形图标
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/ai/ai-icon.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Welcome Title
                  Text(
                    'Welcome to Vestor AI',
                    textAlign: TextAlign.center,
                    style: context.textStyles.rubikBold(
                      fontSize: 32,
                      color:
                          isDark
                              ? colors.textPrimaryDark ?? Colors.white
                              : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Subtitle with highlighted "30s"
                  _buildSubtitle(context, colors, isDark, primaryColor),
                  if (widget.onNext != null) ...[
                    const SizedBox(height: 60),
                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: widget.onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'button_get_started'.tr(),
                          style: context.textStyles.splashButtonText,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建副标题，其中 "30s" 使用紫色高亮
  Widget _buildSubtitle(
    BuildContext context,
    ExtColors colors,
    bool isDark,
    Color primaryColor,
  ) {
    final subtitleText =
        'Get deep, AI-driven analysis on any stock in just 30s';
    final parts = subtitleText.split('30s');

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: context.textStyles.rubikMedium(
          fontSize: 16,
          color:
              isDark
                  ? colors.textAuxiliaryDark ?? const Color(0x99FFFFFF)
                  : const Color(0xFF666666),
        ),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: '30s',
            style: context.textStyles.rubikMedium(
              fontSize: 16,
              color: primaryColor,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
