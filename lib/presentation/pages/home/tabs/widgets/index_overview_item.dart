import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/stock_index_model.dart';

/// 股票指数概览项（用于顶部网格）
class IndexOverviewItem extends StatelessWidget {
  final StockIndexModel index;

  const IndexOverviewItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = index.isPositive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 圆点指示器
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPositive
                  ? (colors.primaryColor ?? const Color(0xFF9556FF))
                  : (colors.auxiliaryRed ?? Colors.red),
            ),
          ),
          const SizedBox(width: 8),
          // 指数名称
          Text(
            _getIndexNameKey(index.name),
            style: context.textStyles.body.copyWith(fontSize: 14),
          ),
          const SizedBox(width: 8),
          // 变化百分比
          Text(
            index.formattedChangePercent,
            style: context.textStyles.body.copyWith(
              fontSize: 14,
              color: isPositive
                  ? (colors.auxiliaryGreen ?? Colors.green)
                  : (colors.auxiliaryRed ?? Colors.red),
            ),
          ),
        ],
      ),
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

