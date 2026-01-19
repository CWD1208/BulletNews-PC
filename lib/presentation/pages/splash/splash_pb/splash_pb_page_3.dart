import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

/// Splash PB 页面 3 - AI Stock Analysis 输入页面
class SplashPbPage3 extends StatefulWidget {
  final VoidCallback? onNext;

  const SplashPbPage3({super.key, this.onNext});

  @override
  State<SplashPbPage3> createState() => _SplashPbPage3State();
}

class _SplashPbPage3State extends State<SplashPbPage3> {
  final TextEditingController _tickerController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _tickerController.addListener(_onTextChanged);
    // 页面加载后自动弹出键盘
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _tickerController.removeListener(_onTextChanged);
    _tickerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasInput = _tickerController.text.trim().isNotEmpty;
    if (hasInput != _hasInput) {
      setState(() {
        _hasInput = hasInput;
      });
    }
  }

  void _handlePredict() {
    if (_hasInput) {
      // 隐藏键盘
      _focusNode.unfocus();
      // 跳转到分析进度页面
      context.push(
        '/splash/pb/4',
        extra: widget.onNext, // 传递下一步回调
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colors.primaryColor ?? const Color(0xFF9556FF);
    final disabledColor =
        isDark
            ? colors.textAuxiliaryDark?.withOpacity(0.3) ??
                Colors.white.withOpacity(0.3)
            : const Color(0xFFE0E0E0);

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // 标题：The prediction accuracy rate reaches 95%
                        _buildTitle(context, colors, isDark, primaryColor),
                        const SizedBox(height: 24),
                        // 说明文字
                        _buildDescription(context, colors, isDark),
                        const SizedBox(height: 24),
                        // 观看人数
                        _buildViewerCount(
                          context,
                          colors,
                          isDark,
                          primaryColor,
                        ),
                        const SizedBox(height: 40),
                        // 输入框
                        _buildInputField(context, colors, isDark, primaryColor),
                        const SizedBox(height: 24),
                        // 按钮
                        _buildPredictButton(
                          context,
                          primaryColor,
                          disabledColor,
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

  /// 构建标题
  Widget _buildTitle(
    BuildContext context,
    ExtColors colors,
    bool isDark,
    Color primaryColor,
  ) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: context.textStyles.rubikBold(
          fontSize: 28,
          color:
              isDark
                  ? colors.textPrimaryDark ?? Colors.white
                  : const Color(0xFF333333),
        ),
        children: [
          const TextSpan(text: 'The prediction accuracy rate reaches '),
          TextSpan(
            text: '95%',
            style: context.textStyles.rubikBold(
              fontSize: 28,
              color: primaryColor,
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  /// 构建说明文字
  Widget _buildDescription(
    BuildContext context,
    ExtColors colors,
    bool isDark,
  ) {
    return Text(
      'Enter a ticker below to get instant, in-depth analysis on any asset you own or are watching.',
      textAlign: TextAlign.center,
      style: context.textStyles.rubikMedium(
        fontSize: 16,
        color:
            isDark
                ? colors.textAuxiliaryDark ?? const Color(0x99FFFFFF)
                : const Color(0xFF666666),
      ),
    );
  }

  /// 构建观看人数
  Widget _buildViewerCount(
    BuildContext context,
    ExtColors colors,
    bool isDark,
    Color primaryColor,
  ) {
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
          const TextSpan(text: 'Currently, '),
          TextSpan(
            text: '96,573',
            style: context.textStyles.rubikMedium(
              fontSize: 16,
              color: primaryColor,
            ),
          ),
          const TextSpan(text: ' people are viewing the full report for free!'),
        ],
      ),
    );
  }

  /// 构建输入框
  Widget _buildInputField(
    BuildContext context,
    ExtColors colors,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color:
            isDark
                ? colors.alwaysWhite?.withOpacity(0.1) ??
                    Colors.white.withOpacity(0.1)
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _hasInput
                  ? primaryColor.withOpacity(0.5)
                  : (isDark
                      ? colors.textAuxiliaryDark?.withOpacity(0.2) ??
                          Colors.white.withOpacity(0.2)
                      : const Color(0xFFE0E0E0)),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _tickerController,
        focusNode: _focusNode,
        autofocus: false,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _handlePredict(),
        style: context.textStyles.rubikMedium(
          fontSize: 16,
          color:
              isDark
                  ? colors.textPrimaryDark ?? Colors.white
                  : const Color(0xFF333333),
        ),
        decoration: InputDecoration(
          hintText: 'Search and analyze stocks (e.g.AAPL)',
          hintStyle: context.textStyles.rubikRegular(
            fontSize: 16,
            color:
                isDark
                    ? colors.textAuxiliaryDark ?? const Color(0x99FFFFFF)
                    : const Color(0xFF999999),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /// 构建预测按钮
  Widget _buildPredictButton(
    BuildContext context,
    Color primaryColor,
    Color disabledColor,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _hasInput ? _handlePredict : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _hasInput ? primaryColor : disabledColor,
          disabledBackgroundColor: disabledColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        child: Text(
          'Predict and Analyze',
          style: context.textStyles.splashButtonText.copyWith(
            color:
                _hasInput
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.5)
                        : const Color(0xFF999999)),
          ),
        ),
      ),
    );
  }
}
