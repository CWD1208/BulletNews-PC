import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

/// Splash PB 页面 4 - 分析进度页面
class SplashPbPage4 extends StatefulWidget {
  final VoidCallback? onNext;

  const SplashPbPage4({super.key, this.onNext});

  @override
  State<SplashPbPage4> createState() => _SplashPbPage4State();
}

class _SplashPbPage4State extends State<SplashPbPage4>
    with SingleTickerProviderStateMixin {
  double _marketProgress = 0.0;
  double _dataProgress = 0.0;
  double _riskProgress = 0.0;
  Timer? _progressTimer;
  late AnimationController _shieldAnimationController;
  late Animation<double> _shieldRotationAnimation;

  // 进度阈值
  static const double _marketStartThreshold = 0.6; // 第一个到60%时，第二个开始
  static const double _dataStartThreshold = 0.4; // 第二个到40%时，第三个开始
  static const double _progressSpeed = 0.01; // 每次更新的进度增量

  @override
  void initState() {
    super.initState();
    // 初始化盾牌旋转动画
    _shieldAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _shieldRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1, // 轻微旋转
    ).animate(
      CurvedAnimation(
        parent: _shieldAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // 启动进度更新
    _startProgress();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _shieldAnimationController.dispose();
    super.dispose();
  }

  /// 启动进度更新
  void _startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        // 第一个进度条持续增长
        if (_marketProgress < 1.0) {
          _marketProgress += _progressSpeed;
          if (_marketProgress > 1.0) {
            _marketProgress = 1.0;
          }
        }

        // 当第一个进度条达到60%时，第二个开始
        if (_marketProgress >= _marketStartThreshold) {
          if (_dataProgress < 1.0) {
            _dataProgress += _progressSpeed;
            if (_dataProgress > 1.0) {
              _dataProgress = 1.0;
            }
          }
        }

        // 当第二个进度条达到40%时，第三个开始
        if (_dataProgress >= _dataStartThreshold) {
          if (_riskProgress < 1.0) {
            _riskProgress += _progressSpeed;
            if (_riskProgress > 1.0) {
              _riskProgress = 1.0;
            }
          }
        }

        // 检查是否所有进度条都完成
        if (_marketProgress >= 1.0 &&
            _dataProgress >= 1.0 &&
            _riskProgress >= 1.0) {
          timer.cancel();
          // 延迟一小段时间后进入下一个页面
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              // 跳转到报告领取页面
              context.push(
                '/splash/pb/5',
                extra: widget.onNext, // 传递下一步回调
              );
            }
          });
        }
      });
    });
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 盾牌图标（带动画）
                  AnimatedBuilder(
                    animation: _shieldRotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _shieldRotationAnimation.value,
                        child: Image.asset(
                          'assets/icons/splash/splash-shield.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // "Running Analysis..." 文本
                  Text(
                    'Running Analysis...',
                    style: context.textStyles.rubikBold(
                      fontSize: 24,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // 进度条列表
                  _buildProgressItem(
                    context,
                    colors,
                    isDark,
                    primaryColor,
                    'Market Analysis',
                    _marketProgress,
                  ),
                  const SizedBox(height: 24),
                  _buildProgressItem(
                    context,
                    colors,
                    isDark,
                    primaryColor,
                    'Data Analysis',
                    _dataProgress,
                  ),
                  const SizedBox(height: 24),
                  _buildProgressItem(
                    context,
                    colors,
                    isDark,
                    primaryColor,
                    'Risk Analysis',
                    _riskProgress,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建单个进度项
  Widget _buildProgressItem(
    BuildContext context,
    ExtColors colors,
    bool isDark,
    Color primaryColor,
    String label,
    double progress,
  ) {
    return Row(
      children: [
        // 标签
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: context.textStyles.rubikMedium(
              fontSize: 16,
              color:
                  isDark
                      ? colors.textPrimaryDark ?? Colors.white
                      : const Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 进度条
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  isDark
                      ? colors.textAuxiliaryDark?.withOpacity(0.2) ??
                          Colors.white.withOpacity(0.2)
                      : primaryColor.withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  // 背景
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                  // 进度条（使用 LayoutBuilder 实现响应式宽度）
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                        width: constraints.maxWidth * progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.8),
                                primaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
