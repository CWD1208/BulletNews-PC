import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/toast_util.dart';
import 'package:stockc/data/models/market_summary_model.dart';
import 'package:stockc/data/models/news_model.dart';
import 'package:stockc/data/models/stock_index_model.dart';
import 'package:stockc/data/repositories/home_repository.dart';
import 'package:stockc/presentation/providers/tab_index_provider.dart';
import 'widgets/global_market_map.dart';
import 'widgets/index_detail_card.dart';
import 'widgets/news_card.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final HomeRepository _repository = HomeRepository();
  final ScrollController _scrollController = ScrollController();

  List<StockIndexModel> _overviewIndices = [];
  List<StockIndexModel> _detailedIndices = [];
  List<NewsModel> _trendingNews = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动监听，实现上拉加载更多
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      // 距离底部200px时开始加载更多
      if (!_isLoadingMore && _hasMore) {
        _loadMoreNews();
      }
    }
  }

  /// 加载数据（首次加载和刷新）
  Future<void> _loadData({bool isRefresh = false}) async {
    if (_isLoading && !isRefresh) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _currentPage = 1;
        _hasMore = true;
        _trendingNews.clear();
      }
    });

    try {
      // 并行加载市场概览和新闻列表
      final results = await Future.wait([
        _repository.getMarketSummary(),
        _repository.getTrendingArticles(page: 1, pageSize: _pageSize),
      ]);

      final marketSummary = results[0] as MarketSummaryModel;
      final news = results[1] as List<NewsModel>;

      if (mounted) {
        setState(() {
          _overviewIndices = marketSummary.items;
          // 取前3个作为详细指数卡片
          _detailedIndices = marketSummary.items.take(3).toList();
          _trendingNews = news;
          _currentPage = 1;
          _hasMore = news.length >= _pageSize;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // 可以显示错误提示
        Toast.error('home_failed_to_load_data'.tr());
      }
    }
  }

  /// 下拉刷新
  Future<void> _refreshData() async {
    await _loadData(isRefresh: true);
  }

  /// 加载更多新闻
  Future<void> _loadMoreNews() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final news = await _repository.getTrendingArticles(
        page: nextPage,
        pageSize: _pageSize,
      );

      if (mounted) {
        setState(() {
          _trendingNews.addAll(news);
          _currentPage = nextPage;
          _hasMore = news.length >= _pageSize;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        Toast.error('home_failed_to_load_more'.tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.globalBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                color: colors.globalBackground,
                child: Text(
                  'home_discover'.tr(),
                  style: context.textStyles.title.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            // 全球市场地图（在标题下方，固定位置，可以被内容覆盖）
            Positioned(
              top: 60, // Discover 标题高度 + padding
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: _buildTopMapWithGradient(
                  context,
                  colors,
                  _overviewIndices,
                ),
              ),
            ),

            // 可滚动内容（从顶部开始，可以向上滚动覆盖地图）
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              bottom: 0,
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顶部留白，让初始显示位置在地图下方（260 = 60标题 + 200地图）
                      SizedBox(height: 157),
                      // 加载状态
                      if (_isLoading && _trendingNews.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else ...[
                        // 详细指数卡片
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildDetailCards(context, _detailedIndices),
                        ),
                        const SizedBox(height: 32),
                        // Trending News 标题
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: Text(
                            'home_trending_news'.tr(),
                            style: context.textStyles.title.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        // 新闻列表
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildNewsList(context, _trendingNews),
                        ),
                        // 加载更多指示器
                        if (_isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (!_hasMore && _trendingNews.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                'home_no_more_news'.tr(),
                                style: context.textStyles.auxiliaryText,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Discover 标题（固定在顶部，类似 AppBar，始终可见）
          ],
        ),
      ),
    );
  }

  /// 构建顶部地图（带底部渐变遮罩）
  Widget _buildTopMapWithGradient(
    BuildContext context,
    ExtColors colors,
    List<StockIndexModel> indices,
  ) {
    return Stack(
      children: [
        // 全球市场地图
        GlobalMarketMap(indices: indices),
        // 底部渐变遮罩（从透明到背景色，实现渐变隐藏效果）
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (colors.globalBackground ?? Colors.white).withOpacity(0),
                    colors.globalBackground ?? Colors.white,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建详细卡片
  Widget _buildDetailCards(
    BuildContext context,
    List<StockIndexModel> indices,
  ) {
    return Row(
      children: [
        for (int i = 0; i < indices.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: IndexDetailCard(index: indices[i])),
        ],
      ],
    );
  }

  /// 构建新闻列表
  Widget _buildNewsList(BuildContext context, List<NewsModel> news) {
    if (news.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'home_no_news_available'.tr(),
            style: context.textStyles.auxiliaryText,
          ),
        ),
      );
    }

    return Column(
      children:
          news.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NewsCard(news: item, index: news.indexOf(item)),
            );
          }).toList(),
    );
  }
}
