import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/utils/toast_util.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/common_util.dart';
import 'package:stockc/data/models/news_model.dart';
import 'package:stockc/data/repositories/home_repository.dart';

/// 新闻详情页面
class NewsDetailPage extends StatefulWidget {
  final NewsModel news;

  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late bool _isLiked;
  final StorageService _storage = StorageService();
  final HomeRepository _repository = HomeRepository();

  NewsModel? _newsDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
    _loadNewsDetail();
  }

  /// 加载新闻详情
  Future<void> _loadNewsDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newsDetail = await _repository.getNewsDetails(widget.news.id);
      if (mounted) {
        setState(() {
          _newsDetail = newsDetail;
          _isLoading = false;
          // 更新点赞状态（如果详情中有）
          _loadLikeStatus();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
          // 如果加载失败，使用传入的 news 作为后备
          _newsDetail = widget.news;
        });
        Toast.error('home_failed_to_load_data'.tr());
      }
    }
  }

  /// 加载点赞状态
  void _loadLikeStatus() {
    final newsId = _newsDetail?.id ?? widget.news.id;
    final key = AppConstants.getNewsLikedKey(newsId);
    _isLiked = _storage.getBool(key) ?? false;
  }

  /// 切换点赞状态
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    final newsId = _newsDetail?.id ?? widget.news.id;
    final key = AppConstants.getNewsLikedKey(newsId);
    _storage.setBool(key, _isLiked);
  }

  /// 获取当前使用的新闻数据（优先使用详情，否则使用传入的）
  NewsModel _getNews() {
    return _newsDetail ?? widget.news;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.globalBackground,
      appBar: AppBar(
        backgroundColor: colors.globalBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          color: colors.textPrimaryLight ?? const Color(0xFF333333),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null && _newsDetail == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'home_failed_to_load_data'.tr(),
                        style: context.textStyles.auxiliaryText,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadNewsDetail,
                        child: Text('common_retry'.tr()),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题和作者信息
                      _buildHeader(context, colors),
                      // 主图
                      // if (_getNews().imageUrl != null)
                      // _buildMainImage(context, colors),
                      // 文章内容
                      _buildArticleContent(context, colors),
                      // 原文链接和免责声明
                      _buildFooter(context, colors),
                      // 点赞按钮（跟着内容滚动）
                      _buildLikeButton(context, colors),
                    ],
                  ),
                ),
      ),
    );
  }

  /// 构建标题和作者信息
  Widget _buildHeader(BuildContext context, ExtColors colors) {
    final news = _getNews();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            news.title,
            style: context.textStyles.title.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          // 作者和时间
          Text(
            '${news.source} ${news.formattedTimeAgo(context)}',
            style: context.textStyles.auxiliaryText.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// 构建主图
  Widget _buildMainImage(BuildContext context, ExtColors colors) {
    final news = _getNews();
    return Container(
      width: double.infinity,
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.lightGray ?? const Color(0xFFF0F1F3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            news.imageUrl != null && news.imageUrl!.startsWith('http')
                ? Image.network(
                  news.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder(colors);
                  },
                )
                : _buildImagePlaceholder(colors),
      ),
    );
  }

  /// 构建图片占位符
  Widget _buildImagePlaceholder(ExtColors colors) {
    return Container(
      color: colors.lightGray ?? const Color(0xFFF0F1F3),
      child: Icon(
        Icons.image,
        color: colors.textAuxiliaryLight3 ?? const Color(0xFF999999),
        size: 60,
      ),
    );
  }

  /// 构建文章内容
  Widget _buildArticleContent(BuildContext context, ExtColors colors) {
    final news = _getNews();
    if (news.content == null || news.content!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          news.summary ?? news.title,
          style: context.textStyles.body.copyWith(fontSize: 16, height: 1.6),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Html(
        data: news.content!,
        extensions: [
          IframeHtmlExtension(),
          VideoHtmlExtension(),
          SvgHtmlExtension(),
        ],
        style: {
          'body': Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(16),
            lineHeight: const LineHeight(1.6),
            color: colors.textPrimary ?? const Color(0xFF333333),
          ),
          'p': Style(margin: Margins.only(bottom: 12)),
          'h1, h2, h3, h4, h5, h6': Style(
            margin: Margins.only(top: 16, bottom: 12),
            fontWeight: FontWeight.bold,
          ),
          'img': Style(
            width: Width(MediaQuery.of(context).size.width - 40),
            margin: Margins.symmetric(vertical: 12),
          ),
          'a': Style(
            color: colors.primaryColor ?? const Color(0xFF9556FF),
            textDecoration: TextDecoration.underline,
          ),
        },
        onLinkTap: (url, attributes, element) {
          if (url != null) {
            CommonUtil.launchUrlExternal(url);
          }
        },
      ),
    );
  }

  /// 构建底部（原文链接和免责声明）
  Widget _buildFooter(BuildContext context, ExtColors colors) {
    final news = _getNews();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 原文链接
          if (news.originalUrl != null)
            GestureDetector(
              onTap: () {
                CommonUtil.launchUrlExternal(news.originalUrl!);
              },
              child: Text(
                'article_original_link'.tr(),
                style: context.textStyles.body.copyWith(
                  fontSize: 14,
                  color: colors.primaryColor ?? const Color(0xFF9556FF),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          if (widget.news.originalUrl != null) const SizedBox(height: 16),
          // 免责声明
          Text(
            'article_disclaimer'.tr(),
            style: context.textStyles.auxiliaryText.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// 构建点赞按钮（跟着内容滚动）
  Widget _buildLikeButton(BuildContext context, ExtColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: colors.globalBackground,
        border: Border(
          top: BorderSide(
            color: colors.gray ?? const Color(0xFFD0D2D5),
            width: 0.5,
          ),
        ),
      ),
      child: Center(
        child: GestureDetector(
          onTap: _toggleLike,
          child: Image.asset(
            _isLiked
                ? 'assets/icons/home/like-sel.png'
                : 'assets/icons/home/like-def.png',
            width: 48,
            height: 48,
            errorBuilder: (context, error, stackTrace) {
              // 如果图片加载失败，使用图标作为后备
              return Icon(
                _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 48,
                color:
                    _isLiked
                        ? (colors.primaryColor ?? const Color(0xFF9556FF))
                        : (colors.textAuxiliaryLight3 ??
                            const Color(0xFF999999)),
              );
            },
          ),
        ),
      ),
    );
  }
}
