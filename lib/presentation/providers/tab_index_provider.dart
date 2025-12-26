import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_index_provider.g.dart';

/// 当前选中的 tab index provider
@riverpod
class TabIndexNotifier extends _$TabIndexNotifier {
  @override
  int build() {
    return 0; // 默认选中第一个 tab (AI)
  }

  /// 设置当前 tab index
  void setIndex(int index) {
    state = index;
  }
}
