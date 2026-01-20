import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

/// Splash PB 页面 2 - 专业人士介绍页面
class SplashPbPage2 extends StatefulWidget {
  final VoidCallback? onNext;

  const SplashPbPage2({super.key, this.onNext});

  @override
  State<SplashPbPage2> createState() => _SplashPbPage2State();
}

class _SplashPbPage2State extends State<SplashPbPage2> {
  // 专业人士列表
  static const List<ProfessionalProfile> professionals = [
    ProfessionalProfile(
      name: 'Ray Dalio',
      imagePath: 'assets/icons/splash/Ray Dalio.png',
    ),
    ProfessionalProfile(
      name: 'Michael Saylor',
      imagePath: 'assets/icons/splash/Michael Saylor.png',
    ),
    ProfessionalProfile(
      name: 'Abigail Johnson',
      imagePath: 'assets/icons/splash/Abigail Johnson.png',
    ),
    ProfessionalProfile(
      name: 'Howard Marks',
      imagePath: 'assets/icons/splash/Howard Marks.png',
    ),
    ProfessionalProfile(
      name: 'Philippe Laffont',
      imagePath: 'assets/icons/splash/Philippe Laffont.png',
    ),
    ProfessionalProfile(
      name: 'Warren Buffet',
      imagePath: 'assets/icons/splash/Warren Buffet.png',
    ),
    ProfessionalProfile(
      name: 'Cathie Wood',
      imagePath: 'assets/icons/splash/Cathie Wood.png',
    ),
    ProfessionalProfile(
      name: 'Chamath Palihapitiya',
      imagePath: 'assets/icons/splash/Chamath Palihapitiya.png',
    ),
    ProfessionalProfile(
      name: 'Jim Cramer',
      imagePath: 'assets/icons/splash/Jim Cramer.png',
    ),
    ProfessionalProfile(
      name: 'Peter Thiel',
      imagePath: 'assets/icons/splash/Peter Thiel.png',
    ),
  ];

  late ScrollController _scrollController;
  Timer? _scrollTimer;
  static const double _itemWidth = 96.0; // 64 (头像) + 32 (间距)
  static const double _scrollSpeed = 0.5; // 每次滚动的像素数（越小越平滑）
  static const Duration _scrollInterval = Duration(
    milliseconds: 16,
  ); // 每16ms更新一次（约60fps，实现平滑滚动）

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // 添加滚动监听，实现无缝循环
    _scrollController.addListener(_onScroll);
    // 延迟启动自动滚动，等待页面渲染完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 初始位置设置为中间部分（第二组数据），这样可以向两个方向滚动
      if (_scrollController.hasClients) {
        final initialPosition = professionals.length * _itemWidth;
        _scrollController.jumpTo(initialPosition);
      }
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动监听，实现无缝循环
  /// 注意：由于使用持续滚动，这个监听主要用于边界检测
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentPosition = position.pixels;

    // 如果滚动到接近末尾（第三组的末尾），无缝跳转到中间部分（第二组的相同位置）
    if (currentPosition >= maxScroll - _itemWidth * 2) {
      final jumpPosition = professionals.length * _itemWidth;
      _scrollController.jumpTo(jumpPosition);
    }
    // 如果滚动到接近开头（第一组的开头），无缝跳转到中间部分（第二组的相同位置）
    else if (currentPosition <= _itemWidth) {
      final jumpPosition = professionals.length * _itemWidth + currentPosition;
      _scrollController.jumpTo(jumpPosition);
    }
  }

  /// 启动自动滚动（持续平滑滚动）
  void _startAutoScroll() {
    if (!mounted) return;

    _scrollTimer = Timer.periodic(_scrollInterval, (timer) {
      if (!mounted || !_scrollController.hasClients) return;

      final currentPosition = _scrollController.position.pixels;
      final maxScroll = _scrollController.position.maxScrollExtent;

      // 持续平滑滚动
      double newPosition = currentPosition + _scrollSpeed;

      // 如果接近末尾，无缝跳转到中间部分
      if (newPosition >= maxScroll - _itemWidth) {
        newPosition = professionals.length * _itemWidth;
      }

      // 直接设置位置，实现平滑滚动
      _scrollController.jumpTo(newPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colors.primaryColor ?? const Color(0xFF9556FF);
    final yellowColor = const Color(0xFFFFD700); // 黄色用于高亮"Free"

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
                  // 描述文字
                  Text(
                    'We break down the markets for you with free,\nAI-powered insights, backed by viewpoints\nfrom top stock professionals:',
                    textAlign: TextAlign.center,
                    style: context.textStyles.rubikMedium(
                      fontSize: 16,
                      color:
                          isDark
                              ? colors.textPrimaryDark ?? Colors.white
                              : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 可滚动的人头像列表（自动循环滚动）
                  _buildProfessionalsList(context, colors, isDark),
                  const SizedBox(height: 40),
                  // 统计信息框
                  _buildStatisticsBox(context, colors, isDark, primaryColor),
                  const SizedBox(height: 40),
                  // 按钮
                  if (widget.onNext != null) ...[
                    _buildActionButton(context, primaryColor, yellowColor),
                    const SizedBox(height: 20),
                  ],
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
                  const SizedBox(height: 64),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/splash/pb/3');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: context.textStyles.splashButtonTextSmall,
                          children: [
                            TextSpan(text: 'Start '),
                            TextSpan(
                              text: 'Free',
                              style: context.textStyles.splashButtonText
                                  .copyWith(color: yellowColor),
                            ),
                            TextSpan(text: ' Analysis'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建专业人士头像列表（自动循环横向滚动）
  Widget _buildProfessionalsList(
    BuildContext context,
    ExtColors colors,
    bool isDark,
  ) {
    // 为了无缝循环，复制列表项（显示3次，实现无限循环效果）
    final extendedList = [...professionals, ...professionals, ...professionals];

    return SizedBox(
      height: 110, // 增加高度以避免溢出
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(), // 禁用用户滚动，只允许自动滚动
        itemCount: extendedList.length,
        itemBuilder: (context, index) {
          final professional = extendedList[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 头像
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isDark
                                ? colors.textAuxiliaryDark ??
                                    const Color(0x33FFFFFF)
                                : const Color(0xFFE0E0E0),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        professional.imagePath,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 32),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 名字 - 使用 Flexible 避免溢出
                  Flexible(
                    child: Text(
                      professional.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.rubikRegular(
                        fontSize: 11,
                        color:
                            isDark
                                ? colors.textAuxiliaryDark ??
                                    const Color(0x99FFFFFF)
                                : const Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建统计信息框
  Widget _buildStatisticsBox(
    BuildContext context,
    ExtColors colors,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color:
            isDark
                ? colors.alwaysWhite?.withOpacity(0.1) ??
                    Colors.white.withOpacity(0.1)
                : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatisticItem(
            context,
            '95%+',
            'Prediction\nAccuracy',
            primaryColor,
            isDark,
            colors,
          ),
          Container(
            width: 1,
            height: 50,
            color:
                isDark
                    ? colors.textAuxiliaryDark?.withOpacity(0.2) ??
                        Colors.white.withOpacity(0.2)
                    : const Color(0xFFE0E0E0),
          ),
          _buildStatisticItem(
            context,
            '10M+',
            'Reports\nGenerated',
            primaryColor,
            isDark,
            colors,
          ),
          Container(
            width: 1,
            height: 50,
            color:
                isDark
                    ? colors.textAuxiliaryDark?.withOpacity(0.2) ??
                        Colors.white.withOpacity(0.2)
                    : const Color(0xFFE0E0E0),
          ),
          _buildStatisticItem(
            context,
            '1M+',
            'Clients\nServed',
            primaryColor,
            isDark,
            colors,
          ),
        ],
      ),
    );
  }

  /// 构建单个统计项
  Widget _buildStatisticItem(
    BuildContext context,
    String value,
    String label,
    Color primaryColor,
    bool isDark,
    ExtColors colors,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: context.textStyles.rubikBold(
              fontSize: 24,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.textStyles.rubikRegular(
              fontSize: 12,
              color:
                  isDark
                      ? colors.textAuxiliaryDark ?? const Color(0x99FFFFFF)
                      : const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(
    BuildContext context,
    Color primaryColor,
    Color yellowColor,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // 跳转到输入页面
          context.push(
            '/splash/pb/3',
            extra: widget.onNext, // 传递下一步回调
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        child: RichText(
          text: TextSpan(
            style: context.textStyles.splashButtonText,
            children: [
              const TextSpan(text: 'Start '),
              TextSpan(
                text: 'Free',
                style: context.textStyles.splashButtonText.copyWith(
                  color: yellowColor,
                ),
              ),
              const TextSpan(text: ' Analysis'),
            ],
          ),
        ),
      ),
    );
  }
}

/// 专业人士资料模型
class ProfessionalProfile {
  final String name;
  final String imagePath;

  const ProfessionalProfile({required this.name, required this.imagePath});
}
