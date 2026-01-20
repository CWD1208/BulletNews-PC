import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/services/user_service.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

/// Splash PB 页面 5 - 报告领取页面
class SplashPbPage5 extends StatefulWidget {
  final VoidCallback? onNext;

  const SplashPbPage5({super.key, this.onNext});

  @override
  State<SplashPbPage5> createState() => _SplashPbPage5State();
}

class _SplashPbPage5State extends State<SplashPbPage5>
    with SingleTickerProviderStateMixin {
  int _countdown = 60; // 倒计时从60秒开始
  Timer? _countdownTimer;
  bool _hasClaimed = false; // 是否已领取
  bool _isLoading = false; // 是否正在加载
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _initButtonAnimation();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  /// 初始化按钮动画
  void _initButtonAnimation() {
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1秒一个周期
    )..repeat(reverse: true); // 来回循环

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05, // 放大5%
    ).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
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
        if (mounted) {
          context.go('/home');
        }
      }
    });
  }

  /// 处理领取按钮点击
  Future<void> _handleClaim() async {
    if (_hasClaimed || _isLoading) return;

    // 设置loading状态，停止按钮动画
    setState(() {
      _isLoading = true;
      _hasClaimed = true;
    });

    // 停止按钮动画
    _buttonAnimationController.stop();
    _buttonAnimationController.reset();

    try {
      // 获取url
      final professorUrl = await UserService().getProfessorUrl();
      if (professorUrl != null) {
        await launchUrl(
          Uri.parse(professorUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // 处理错误，即使失败也继续跳转
      debugPrint('Error launching URL: $e');
    } finally {
      // 请求完成后跳转到home
      if (mounted) {
        await StorageService().setBool(AppConstants.keySplashCompleted, true);
        context.go('/home');
      }
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
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 148),
            child: Image.asset(
              'assets/icons/splash/splash-pb-bg.png',
              width: double.infinity,
              height: 587,
              fit: BoxFit.contain,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 深灰色卡片
                      _buildInfoCard(context, colors, isDark, primaryColor),
                      const SizedBox(height: 84),
                      // 领取按钮
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 33),
                        alignment: Alignment.center,
                        child: _buildClaimButton(context, primaryColor),
                      ),
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
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // AI Icon - 紫色圆形图标
        Container(
          padding: const EdgeInsets.only(
            top: 46,
            left: 45,
            right: 45,
            bottom: 34,
          ),
          decoration: BoxDecoration(
            color: const Color(0x99000000), // 深灰色
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
        ),
        Positioned(
          top: -30,
          child: Image.asset(
            'assets/icons/ai/ai-icon.png',
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  /// 构建领取按钮（带放大缩小动画）
  Widget _buildClaimButton(BuildContext context, Color primaryColor) {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale:
              (_hasClaimed || _isLoading) ? 1.0 : _buttonScaleAnimation.value,
          child: SizedBox(
            width: double.infinity,
            height: 62,
            child: ElevatedButton(
              onPressed: (_hasClaimed || _isLoading) ? null : _handleClaim,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child:
                  _isLoading
                      ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Claim Your Free Report',
                            style: context.textStyles.splashButtonText.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'on WhatsApp Now',
                            style: context.textStyles.splashButtonText.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        );
      },
    );
  }
}
