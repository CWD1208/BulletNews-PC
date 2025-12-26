import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/stock_index_model.dart';

/// 全球市场地图组件
class GlobalMarketMap extends StatelessWidget {
  final List<StockIndexModel> indices;

  const GlobalMarketMap({super.key, required this.indices});

  @override
  Widget build(BuildContext context) {
    // 如果indices为空，返回空容器
    if (indices.isEmpty) {
      return const SizedBox.shrink();
    }

    // 创建指数映射表，方便根据名称查找
    final Map<String, StockIndexModel> indexMap = {};
    for (var index in indices) {
      indexMap[index.name] = index;
    }

    // 创建一个默认的index，用于fallback
    final defaultIndex = indices.first;

    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 世界地图背景
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/icons/home/earth.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          // 市场指数标签
          _buildMarketIndexLabel(
            context,
            indexMap['NASDAQ'] ?? defaultIndex,
            Alignment.centerLeft,
            top: 2,
            left: 50,
          ),
          // _buildMarketIndexLabel(
          //   context,
          //   indexMap['S&P 500'] ?? defaultIndex,
          //   Alignment.centerLeft,
          //   top: 46,
          //   left: 18,
          //   showLocationRight: false,
          // ),
          _buildMarketIndexLabel(
            context,
            indexMap['Dow Jones'] ?? defaultIndex,
            Alignment.bottomLeft,
            top: 72,
            left: 10,
            showLocationRight: false,
          ),
          _buildMarketIndexLabel(
            context,
            indexMap['DAX'] ?? defaultIndex,
            Alignment.topRight,
            top: -8,
            left: 170,
            showLocationRight: false,
          ),
          _buildMarketIndexLabel(
            context,
            indexMap['CAC 40'] ?? defaultIndex,
            Alignment.center,
            top: 35,
            left: 150,
          ),
          _buildMarketIndexLabel(
            context,
            indexMap['Nikkei'] ?? defaultIndex,
            Alignment.topRight,
            top: 10,
            right: 30,
          ),
          _buildMarketIndexLabel(
            context,
            indexMap['HSI'] ?? defaultIndex,
            Alignment.centerRight,
            top: 35,
            right: 100,
          ),
          _buildMarketIndexLabel(
            context,
            indexMap['ASX200'] ?? defaultIndex,
            Alignment.bottomRight,
            top: 60,
            right: 30,
          ),
        ],
      ),
    );
  }

  /// 构建市场指数标签
  Widget _buildMarketIndexLabel(
    BuildContext context,
    StockIndexModel index,
    Alignment alignment, {
    double? top,
    double? left,
    double? right,
    double? bottom,
    bool showLocationRight = true,
  }) {
    final colors = context.colors;
    final isPositive = index.isPositive;

    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (!showLocationRight) _buildLocationIcon(colors),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _getIndexNameKey(index.name),
                style: context.textStyles.body.copyWith(
                  fontSize: 11,
                  color: colors.textPrimary,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -4),
                child: Text(
                  index.formattedChangePercent,
                  style: context.textStyles.body.copyWith(
                    fontSize: 10,
                    color:
                        isPositive
                            ? (colors.auxiliaryGreen ?? Colors.green)
                            : (colors.auxiliaryRed ?? Colors.red),
                  ),
                ),
              ),
              _buildLocationIcon(colors),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建位置图标（带雷达波动画）
  Widget _buildLocationIcon(ExtColors colors) {
    return RadarLocationIcon(
      color: colors.primaryColor ?? const Color(0xFF9556FF),
    );
  }

  String _getIndexNameKey(String name) {
    switch (name) {
      case 'Dow Jones':
        return 'home_index_dow_jones'.tr();
      case 'NASDAQ':
        return 'home_index_nasdaq'.tr();
      case 'S&P 500':
        return 'home_index_sp500'.tr();
      case 'DAX':
        return 'home_index_dax'.tr();
      case 'CAC 40':
        return 'home_index_cac40'.tr();
      case 'Nikkei':
        return 'home_index_nikkei'.tr();
      case 'HSI':
        return 'home_index_hsi'.tr();
      case 'ASX200':
        return 'home_index_asx200'.tr();
      default:
        return name;
    }
  }
}

/// 雷达波动画位置图标
class RadarLocationIcon extends StatefulWidget {
  final Color color;

  const RadarLocationIcon({super.key, required this.color});

  @override
  State<RadarLocationIcon> createState() => _RadarLocationIconState();
}

class _RadarLocationIconState extends State<RadarLocationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Duration _duration;
  late final Duration _delay;

  @override
  void initState() {
    super.initState();
    // 随机生成动画持续时间（2.5秒到4秒之间）
    final random = Random();
    final durationMs = 2500 + random.nextInt(2500); // 2500-4000ms
    _duration = Duration(milliseconds: durationMs);

    // 随机生成延迟时间（0到1.5秒之间）
    final delayMs = random.nextInt(1500); // 0-1500ms
    _delay = Duration(milliseconds: delayMs);

    _controller = AnimationController(vsync: this, duration: _duration);

    // 延迟启动动画
    Future.delayed(_delay, () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 10,
      margin: const EdgeInsets.only(left: 4, right: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 雷达波动画圆环
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(30, 30),
                painter: _RadarWavePainter(
                  animationValue: _controller.value,
                  color: widget.color,
                ),
              );
            },
          ),
          // 中心点
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// 雷达波绘制器
class _RadarWavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _RadarWavePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // 绘制多个雷达波圆环
    for (int i = 0; i < 3; i++) {
      final progress = (animationValue + i * 0.33) % 1.0;
      final radius = maxRadius * progress;

      if (radius > 0 && radius < maxRadius) {
        final opacity = 1.0 - progress;
        final paint =
            Paint()
              ..color = color.withOpacity(opacity * 0.6)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5;

        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadarWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}
