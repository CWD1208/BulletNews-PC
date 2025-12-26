import 'package:stockc/core/constants/api_endpoints.dart';
import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/data/models/market_summary_model.dart';
import 'package:stockc/data/models/news_model.dart';
import 'package:stockc/data/models/stock_index_model.dart';

/// Home页面数据Repository
class HomeRepository {
  final DioClient _client = DioClient();

  /// 获取市场概览（指数列表）
  /// 返回格式：{"code":200,"data":{"items":[...]}}
  Future<MarketSummaryModel> getMarketSummary() async {
    return await _client.get<MarketSummaryModel>(
      ApiEndpoints.marketSummary,
      fromJson: (json) {
        // json 是 data 部分，包含 items
        return MarketSummaryModel.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  /// 获取trending文章列表
  /// 返回格式：{"code":200,"data":{"items":[...]}}
  Future<List<NewsModel>> getTrendingArticles({
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['page_size'] = pageSize;

    return await _client.get<List<NewsModel>>(
      ApiEndpoints.trendingArticles,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (json) {
        // json 是 data 部分，包含 items 数组
        final data = json as Map<String, dynamic>;
        final items = data['items'] as List?;
        // 第一个的isLargeCard为true

        if (items != null) {
          final newsList =
              items
                  .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
                  .toList();

          return newsList;
        }
        return [];
      },
    );
  }

  /// 获取新闻详情
  /// 请求参数：guid
  /// 返回格式：{"code":200,"data":{"item":{...}}}
  Future<NewsModel> getNewsDetails(String guid) async {
    return await _client.get<NewsModel>(
      ApiEndpoints.newsDetails,
      queryParameters: {'guid': guid},
      fromJson: (json) {
        // json 是 data 部分，包含 item 对象
        final data = json as Map<String, dynamic>;
        final item = data['item'] as Map<String, dynamic>?;
        if (item != null) {
          return NewsModel.fromJson(item);
        }
        throw Exception('News detail not found');
      },
    );
  }

  /// 获取概览指数列表（用于顶部网格）
  List<StockIndexModel> getOverviewIndices() {
    return const [
      StockIndexModel(
        id: 'dow_jones',
        name: 'Dow Jones',
        currentValue: 47954.99,
        change: 4.3,
        changePercent: 4.3,
      ),
      StockIndexModel(
        id: 'nasdaq',
        name: 'NASDAQ',
        currentValue: 23578.12,
        change: 4.3,
        changePercent: 4.3,
      ),
      StockIndexModel(
        id: 'dax',
        name: 'DAX',
        currentValue: 18500.0,
        change: 4.3,
        changePercent: 4.3,
      ),
      StockIndexModel(
        id: 'cac40',
        name: 'CAC 40',
        currentValue: 8200.0,
        change: -4.3,
        changePercent: -4.3,
      ),
      StockIndexModel(
        id: 'nikkei',
        name: 'Nikkei',
        currentValue: 38500.0,
        change: -0.33,
        changePercent: -0.33,
      ),
      StockIndexModel(
        id: 'hsi',
        name: 'HSI',
        currentValue: 18500.0,
        change: 4.3,
        changePercent: 4.3,
      ),
      StockIndexModel(
        id: 'asx200',
        name: 'ASX200',
        currentValue: 7800.0,
        change: 4.3,
        changePercent: 4.3,
      ),
    ];
  }

  /// 获取详细指数卡片（用于三个大卡片）
  List<StockIndexModel> getDetailedIndices() {
    return [
      StockIndexModel(
        id: 'dow_jones',
        name: 'Dow Jones',
        currentValue: 47954.99,
        change: 104.09,
        changePercent: 0.22,
        chartData: [47800, 47850, 47900, 47950, 47954.99],
      ),
      StockIndexModel(
        id: 'nasdaq',
        name: 'NASDAQ',
        currentValue: 23578.12,
        change: 104.09,
        changePercent: 0.42,
        chartData: [23400, 23450, 23500, 23550, 23578.12],
      ),
      StockIndexModel(
        id: 'sp500',
        name: 'S&P 500',
        currentValue: 6870.40,
        change: -104.09,
        changePercent: -0.28,
        chartData: [6900, 6880, 6875, 6872, 6870.40],
      ),
    ];
  }

  /// 获取热门新闻列表
  List<NewsModel> getTrendingNews() {
    final now = DateTime.now();
    return [
      NewsModel(
        id: 'news_1',
        title:
            'BlockBeats News, February 10, DeepSeek has acquired the premium domain nam...',
        source: 'Benzijnga',
        publishTime: now.subtract(const Duration(minutes: 25)),
        imageUrl: 'assets/icons/home/news_large.png',
        isLargeCard: true,
        content: _getNews1Content(),
        originalUrl: 'https://example.com/news/deepseek-domain',
      ),
      NewsModel(
        id: 'news_2',
        title: 'February 10, DeepSeek 12345 ndanpremium domain nam...',
        source: 'Benzijnga',
        publishTime: now.subtract(const Duration(minutes: 25)),
        imageUrl: 'assets/icons/home/news_small.png',
        isLargeCard: false,
        content: _getNews2Content(),
        originalUrl: 'https://example.com/news/tech-trends',
      ),
      NewsModel(
        id: 'news_3',
        title: 'Market Analysis: Tech Stocks Show Strong Momentum',
        source: 'Financial Times',
        publishTime: now.subtract(const Duration(hours: 2)),
        imageUrl: 'assets/icons/home/news_small.png',
        isLargeCard: false,
        content: _getNews3Content(),
        originalUrl: 'https://example.com/news/tech-stocks',
      ),
    ];
  }

  /// 根据ID获取新闻详情
  NewsModel? getNewsById(String id) {
    final allNews = getTrendingNews();
    try {
      return allNews.firstWhere((news) => news.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 新闻1的详细内容
  String _getNews1Content() {
    return '''
      <p>DeepSeek, a leading AI research company, has successfully acquired a premium domain name, marking a significant milestone in its brand development strategy. The acquisition demonstrates DeepSeek's commitment to establishing a strong online presence and reflects the company's growing influence in the AI industry.</p>
      
      <h2>Strategic Brand Development</h2>
      <p>This strategic move is expected to enhance DeepSeek's brand recognition and facilitate better communication with its global user base. The premium domain will serve as a cornerstone for the company's digital identity, enabling more effective marketing and user engagement strategies.</p>
      
      <h3>Key Highlights</h3>
      <ul>
        <li><strong>Premium Domain Acquisition:</strong> Strengthens brand identity and online credibility</li>
        <li><strong>Enhanced Global Market Presence:</strong> Expands reach to international markets</li>
        <li><strong>Improved User Accessibility:</strong> Provides a more memorable and professional web address</li>
        <li><strong>Brand Consistency:</strong> Aligns domain with company's brand values and mission</li>
      </ul>
      
      <h3>Market Impact</h3>
      <p>The domain acquisition comes at a time when DeepSeek is experiencing rapid growth in the AI sector. Industry analysts believe this move will further solidify the company's position as a key player in artificial intelligence research and development.</p>
      
      <p>Market observers note that premium domain acquisitions have become increasingly important for tech companies looking to establish credibility and trust with users. DeepSeek's investment in this area signals its long-term commitment to building a sustainable and recognizable brand.</p>
      
      <h3>Future Outlook</h3>
      <p>Looking ahead, DeepSeek plans to leverage this premium domain to launch new initiatives and expand its service offerings. The company expects this strategic investment to pay dividends in terms of brand recognition and user acquisition over the coming years.</p>
      
      <p>For more information about DeepSeek's services and research, visit their <a href="https://example.com/deepseek">official website</a>.</p>
    ''';
  }

  /// 新闻2的详细内容
  String _getNews2Content() {
    return '''
      <p>Recent developments in the technology sector have captured the attention of investors and market analysts worldwide. The rapid pace of innovation and the emergence of new technologies are reshaping the investment landscape.</p>
      
      <h2>Technology Sector Trends</h2>
      <p>Market analysts are closely watching these trends as they may impact future investment decisions. The convergence of artificial intelligence, cloud computing, and edge technologies is creating new opportunities for growth and innovation.</p>
      
      <h3>Key Developments</h3>
      <ol>
        <li><strong>AI Integration:</strong> Companies are increasingly integrating AI capabilities into their products and services</li>
        <li><strong>Cloud Migration:</strong> Businesses continue to move operations to cloud-based platforms</li>
        <li><strong>Edge Computing:</strong> Growing adoption of edge computing solutions for real-time processing</li>
        <li><strong>Cybersecurity:</strong> Enhanced focus on security measures as digital transformation accelerates</li>
      </ol>
      
      <h3>Investment Implications</h3>
      <p>These technological trends present both opportunities and challenges for investors. While the potential for significant returns exists, investors must also consider the risks associated with rapid technological change and market volatility.</p>
      
      <p>Financial advisors recommend a balanced approach, diversifying investments across different technology subsectors and maintaining a long-term perspective when evaluating tech stocks.</p>
      
      <h3>Expert Analysis</h3>
      <p>Industry experts suggest that investors should pay close attention to companies that demonstrate strong fundamentals, innovative capabilities, and sustainable business models. The ability to adapt to changing market conditions will be crucial for long-term success.</p>
    ''';
  }

  /// 新闻3的详细内容
  String _getNews3Content() {
    return '''
      <p>Technology stocks have demonstrated remarkable resilience and growth in recent trading sessions, outperforming broader market indices and attracting significant investor interest.</p>
      
      <h2>Strong Performance Metrics</h2>
      <p>Investors are showing increased confidence in the sector, driven by strong earnings reports and positive market sentiment. The technology sector's performance has been particularly strong, with many companies reporting better-than-expected quarterly results.</p>
      
      <h3>Market Dynamics</h3>
      <p>The technology sector's momentum can be attributed to several key factors:</p>
      <ul>
        <li>Robust earnings growth across major tech companies</li>
        <li>Strong demand for cloud services and software solutions</li>
        <li>Continued innovation in artificial intelligence and machine learning</li>
        <li>Favorable regulatory environment in key markets</li>
        <li>Increased enterprise spending on digital transformation</li>
      </ul>
      
      <h3>Sector Analysis</h3>
      <p>Within the technology sector, certain subsectors have shown particularly strong performance:</p>
      <ul>
        <li><strong>Cloud Computing:</strong> Continued strong growth as businesses accelerate digital transformation</li>
        <li><strong>Semiconductors:</strong> Strong demand driven by AI and data center expansion</li>
        <li><strong>Software:</strong> Sustained growth in enterprise software and SaaS solutions</li>
        <li><strong>Cybersecurity:</strong> Increasing importance as digital threats evolve</li>
      </ul>
      
      <h3>Investment Outlook</h3>
      <p>Looking forward, market analysts remain optimistic about the technology sector's prospects. However, they also caution investors to be mindful of potential headwinds, including regulatory changes, supply chain disruptions, and market volatility.</p>
      
      <p>For investors considering technology stocks, experts recommend:</p>
      <ol>
        <li>Conducting thorough research on individual companies</li>
        <li>Diversifying across different technology subsectors</li>
        <li>Maintaining a long-term investment horizon</li>
        <li>Staying informed about industry trends and developments</li>
      </ol>
      
      <h3>Risk Considerations</h3>
      <p>While the technology sector offers significant growth potential, investors should also be aware of the risks involved. These include market volatility, regulatory uncertainty, and the rapid pace of technological change that can quickly make products or services obsolete.</p>
      
      <p>As always, investors should consult with financial advisors and conduct their own research before making investment decisions. Past performance does not guarantee future results.</p>
    ''';
  }
}
