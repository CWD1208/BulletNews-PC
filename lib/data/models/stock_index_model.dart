/// 股票指数模型
class StockIndexModel {
  final String id;
  final String name;
  final double currentValue;
  final double change;
  final double changePercent;
  final List<double>? chartData; // 用于图表数据

  const StockIndexModel({
    required this.id,
    required this.name,
    required this.currentValue,
    required this.change,
    required this.changePercent,
    this.chartData,
  });

  /// 是否为上涨（绿色）
  bool get isPositive => change >= 0;

  /// 格式化当前值
  String get formattedValue {
    return currentValue.toStringAsFixed(2);
  }

  /// 格式化变化值
  String get formattedChange {
    final sign = isPositive ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}';
  }

  /// 格式化变化百分比
  String get formattedChangePercent {
    final sign = isPositive ? '+' : '';
    return '$sign${changePercent.toStringAsFixed(2)}%';
  }

  /// 从JSON创建
  factory StockIndexModel.fromJson(Map<String, dynamic> json) {
    final price = (json['price'] as num?)?.toDouble() ?? 0.0;
    final change = (json['change'] as num?)?.toDouble() ?? 0.0;
    // 根据实际API返回，change 可能是百分比，也可能是点数
    // 如果有 change_points，优先使用它来计算百分比
    final changePoints = (json['change_points'] as num?)?.toDouble();
    double changePercent;
    if (changePoints != null && price != 0) {
      // 使用 change_points 和 price 计算百分比
      changePercent = (changePoints / price) * 100;
    } else if (change != 0 && price != 0) {
      // 如果 change 是点数，计算百分比
      changePercent = (change / price) * 100;
    } else {
      // 如果 change 已经是百分比，直接使用
      changePercent = change;
    }

    return StockIndexModel(
      id: json['slug'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      currentValue: price,
      change: changePoints ?? change, // 优先使用 change_points
      changePercent: changePercent,
      chartData:
          json['chart_data'] != null
              ? (json['chart_data'] as List)
                  .map((e) => (e as num).toDouble())
                  .toList()
              : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'current_value': currentValue,
      'change': change,
      'change_percent': changePercent,
      'chart_data': chartData,
    };
  }
}
