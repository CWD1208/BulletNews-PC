import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

/// Splash PB 页面 5 - 报告领取页面
class SplashPbPage5 extends StatefulWidget {
  final VoidCallback? onNext;

  const SplashPbPage5({super.key, this.onNext});

  @override
  State<SplashPbPage5> createState() => _SplashPbPage5State();
}

class _SplashPbPage5State extends State<SplashPbPage5> {
  int _countdown = 60; // 倒计时从60秒开始
  Timer? _countdownTimer;
  bool _hasClaimed = false; // 是否已领取

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// 启动倒计时
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _countdown--;
      });

      // 倒计时到0时，自动跳转到首页
      if (_countdown <= 0) {
        timer.cancel();
        if (!_hasClaimed && mounted) {
          context.go('/home');
        }
      }
    });
  }

  /// 处理领取按钮点击
  void _handleClaim() {
    if (_hasClaimed) return;

    setState(() {
      _hasClaimed = true;
    });

    // 取消倒计时
    _countdownTimer?.cancel();

    // 执行下一步（如果提供了回调）
    if (widget.onNext != null) {
      widget.onNext!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colors.primaryColor ?? const Color(0xFF9556FF);

    return Scaffold(
      backgroundColor: colors.sidebarColor,
      body: Stack(
        children: [
          // 最底层背景图片
          Container(
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
          ),
          // 上层毛玻璃效果图片
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  image:
                      isDark
                          ? null
                          : const DecorationImage(
                            image: AssetImage(
                              'assets/icons/splash/splash-pb-bg.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                  color: Colors.white.withOpacity(0.1), // 轻微白色遮罩，增强毛玻璃效果
                ),
              ),
            ),
          ),
          // 内容层
          SafeArea(
            child: Column(
              children: [
                // AppBar
                _buildAppBar(context, colors),
                // 内容区域
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
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
                          // 深灰色卡片
                          _buildInfoCard(context, colors, isDark, primaryColor),
                          const SizedBox(height: 24),
                          // 领取按钮
                          _buildClaimButton(context, primaryColor),
                          const SizedBox(height: 40),
                          // 底部文字
                          Text(
                            'Powered by OpenAI',
                            style: context.textStyles.rubikRegular(
                              fontSize: 12,
                              color:
                                  isDark
                                      ? colors.textAuxiliaryDark ??
                                          const Color(0x99FFFFFF)
                                      : const Color(0xFF999999),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建 AppBar
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
          Expanded(
            child: Text(
              'AI Stock Analysis',
              textAlign: TextAlign.center,
              style: context.textStyles.rubikBold(
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 48), // 平衡左侧返回按钮
        ],
      ),
    );
  }

  /// 构建信息卡片
  Widget _buildInfoCard(
    BuildContext context,
    ExtColors colors,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            isDark ? const Color(0xFF2A2A2A) : const Color(0xFF333333), // 深灰色
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Your analysis is ready. Get it',
            textAlign: TextAlign.center,
            style: context.textStyles.rubikMedium(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'free before time runs out!',
            textAlign: TextAlign.center,
            style: context.textStyles.rubikMedium(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          // 倒计时显示
          Text(
            '${_countdown}s',
            style: context.textStyles.rubikBold(
              fontSize: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建领取按钮
  Widget _buildClaimButton(BuildContext context, Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _hasClaimed ? null : _handleClaim,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Claim Your Free Report',
              style: context.textStyles.splashButtonText.copyWith(fontSize: 18),
            ),
            Text(
              'on WhatsApp Now',
              style: context.textStyles.splashButtonText.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
