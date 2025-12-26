import 'package:stockc/core/constants/api_endpoints.dart';
import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/core/network/app_exception.dart';

/// AI 聊天 Repository
class AiChatRepository {
  final DioClient _client = DioClient();

  /// 根据用户消息生成 mock AI 回复（保留作为fallback）
  String generateMockResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    // 根据关键词匹配不同的回复
    if (message.contains('apple') || message.contains('苹果')) {
      return '''Apple Inc. (AAPL) has been showing strong performance recently. Here are some key highlights:

• Recent News: Apple announced new product launches in Q4 2024, focusing on AI integration across their ecosystem.

• Financial Performance: Revenue growth of 8% YoY, driven by strong iPhone sales and services revenue.

• Market Sentiment: Analysts are bullish on Apple's long-term prospects, with price targets ranging from 180-200 dollars.

• Key Metrics:
  - P/E Ratio: 28.5
  - Market Cap: 3.2T
  - Dividend Yield: 0.5%

Would you like more detailed analysis on any specific aspect?''';
    } else if (message.contains('nvidia') || message.contains('英伟达')) {
      return '''NVIDIA Corporation (NVDA) recently released their year-end financial report. Here's a comprehensive summary:

• Earnings Highlights:
  - Revenue: 22.1B (up 126% YoY)
  - Net Income: 12.3B (up 288% YoY)
  - EPS: 4.93 (beating estimates by 8%)

• Key Drivers:
  - Strong demand for AI chips (H100, A100)
  - Data center revenue up 409%
  - Gaming segment stable growth

• Outlook: Management raised guidance for next quarter, citing strong AI infrastructure demand.

• Analyst Consensus: Strong Buy rating, average price target 650 dollars.

The stock has been volatile but trending upward. Would you like to dive deeper into any specific segment?''';
    } else if (message.contains('evaluate') ||
        message.contains('评估') ||
        message.contains('投资价值')) {
      return '''Evaluating a stock's investment value involves multiple factors. Here's a comprehensive framework:

1. Fundamental Analysis
• Financial Health: Revenue growth, profit margins, debt levels
• Valuation Metrics: P/E, P/B, PEG ratios
• Competitive Position: Market share, moat, industry trends

2. Technical Analysis
• Price trends and patterns
• Support and resistance levels
• Trading volume analysis

3. Qualitative Factors
• Management quality
• Business model sustainability
• Industry outlook and regulatory environment

4. Risk Assessment
• Market risk
• Company-specific risks
• Macroeconomic factors

5. Investment Thesis
• Why invest now?
• What could go wrong?
• Expected returns vs. risk

Would you like me to analyze a specific stock using this framework?''';
    } else if (message.contains('stock') || message.contains('股票')) {
      return '''I'd be happy to help you with stock analysis! Here are some things I can assist with:

• Stock Research: Get detailed information about specific companies
• Market Analysis: Understand market trends and sentiment
• Portfolio Advice: Evaluate your investment strategy
• Risk Assessment: Analyze potential risks and opportunities

What specific stock or topic would you like to explore? You can ask me about:
- Company financials and earnings
- Market trends and sector analysis
- Investment strategies
- Risk management

Feel free to ask me anything about the stock market!''';
    } else {
      // 默认回复
      return '''Thank you for your question! I'm here to help you with stock market insights and analysis.

Based on your query, I can provide:
• Detailed company analysis
• Market trends and sentiment
• Financial metrics and ratios
• Investment recommendations
• Risk assessment

Could you provide more specific details about what you'd like to know? For example:
- A specific stock ticker or company name
- A particular sector or industry
- Investment goals or time horizon

I'm ready to dive deeper into any topic you're interested in!''';
    }
  }

  /// 获取AI回复
  /// 请求参数：{"data": {"messages": [{"role": "user", "content": "..."}]}}
  /// 返回格式：{"code":200,"data":{"content":"...","type":1}}
  /// 错误格式：{"code":600001,"data":{},"error_msg":"ai use limited"}
  /// 只返回 content 字段
  ///
  /// 抛出 BusinessException(code: 600001) 当使用次数用完时
  Future<String> getAiResponse(String userMessage) async {
    try {
      final response = await _client.post<String>(
        ApiEndpoints.aiChat,
        data: {
          'data': {
            'messages': [
              {'role': 'user', 'content': userMessage},
            ],
          },
        },
        fromJson: (json) {
          // json 是 data 部分，直接返回 content 字段
          final data = json as Map<String, dynamic>;
          final content = data['content'] as String?;
          return content ?? '';
        },
      );

      // 如果API返回为空，使用mock回复作为fallback
      if (response.isEmpty) {
        return generateMockResponse(userMessage);
      }

      return response;
    } on BusinessException catch (e) {
      // 检查是否是使用次数用完的错误（code 600001）
      if (e.code == 600001) {
        // 重新抛出，让调用方处理
        rethrow;
      }
      // 其他业务异常，使用mock回复作为fallback
      return generateMockResponse(userMessage);
    } catch (e) {
      // 如果API调用失败，使用mock回复作为fallback
      return generateMockResponse(userMessage);
    }
  }
}
