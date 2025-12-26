import 'package:stockc/data/models/stock_index_model.dart';

/// 市场概览响应模型
class MarketSummaryModel {
  /// 指数列表
  final List<StockIndexModel> items;

  MarketSummaryModel({required this.items});

  factory MarketSummaryModel.fromJson(Map<String, dynamic> json) {
    return MarketSummaryModel(
      items:
          json['items'] != null
              ? (json['items'] as List)
                  .map(
                    (e) => StockIndexModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((e) => e.toJson()).toList()};
  }
}
