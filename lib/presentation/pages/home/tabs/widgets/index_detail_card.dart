import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/stock_index_model.dart';

/// 股票指数详细卡片
class IndexDetailCard extends StatelessWidget {
  final StockIndexModel index;

  const IndexDetailCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = index.isPositive;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 指数名称
          Container(
            width: double.infinity,
            child: Text(
              _getIndexNameKey(index.name),
              style: context.textStyles.body.copyWith(
                fontSize: 12,
                color: colors.textAuxiliaryLight3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 18),
          // 当前值
          Text(
            index.formattedValue,
            style: context.textStyles.title.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // 变化值
          Row(
            children: [
              Text(
                index.formattedChange,
                style: context.textStyles.content.copyWith(fontSize: 10),
                maxLines: 1,
              ),
              const SizedBox(width: 4),
              Text(
                index.formattedChangePercent,
                style: context.textStyles.body.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color:
                      isPositive
                          ? (colors.auxiliaryGreen ?? Colors.green)
                          : (colors.auxiliaryRed ?? Colors.red),
                ),
                maxLines: 1,
              ),
            ],
          ),
          // const SizedBox(height: 12),
          Image.asset(
            'assets/icons/home/${isPositive ? 'upper' : 'down'}.png',
            // width: double.infinity,
            // height: 24,
            fit: BoxFit.cover,
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
      default:
        return name;
    }
  }
}
