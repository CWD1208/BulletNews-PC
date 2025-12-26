import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/data/models/news_model.dart';

/// 新闻卡片组件
class NewsCard extends StatelessWidget {
  final NewsModel news;
  final int? index;

  const NewsCard({super.key, required this.news, this.index});

  @override
  Widget build(BuildContext context) {
    if (news.isLargeCard || index == 0) {
      return _buildLargeCard(context);
    } else {
      return _buildSmallCard(context);
    }
  }

  /// 构建大卡片
  Widget _buildLargeCard(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        context.push('/news/${news.id}', extra: news);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域（占位）
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: colors.lightGray ?? const Color(0xFFF0F1F3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child:
                  news.imageUrl != null
                      ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: news.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  _buildPlaceholderImage(colors, size: 80),
                          errorWidget:
                              (context, url, error) =>
                                  _buildPlaceholderImage(colors, size: 80),
                        ),
                      )
                      : _buildPlaceholderImage(colors),
            ),
            // 内容区域
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    news.title,
                    style: context.textStyles.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // 来源和时间
                  Text(
                    '${news.source} ${_formatTimeAgo(context, news.timeDifference)}',
                    style: context.textStyles.auxiliaryText.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建小卡片
  Widget _buildSmallCard(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        context.push('/news/${news.id}', extra: news);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.lightGray ?? const Color(0xFFF0F1F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  news.imageUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: news.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  _buildPlaceholderImage(colors, size: 80),
                          errorWidget:
                              (context, url, error) =>
                                  _buildPlaceholderImage(colors, size: 80),
                        ),
                      )
                      : _buildPlaceholderImage(colors, size: 80),
            ),
            const SizedBox(width: 12),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    news.title,
                    style: context.textStyles.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // 来源和时间
                  Text(
                    '${news.source} ${_formatTimeAgo(context, news.timeDifference)}',
                    style: context.textStyles.auxiliaryText.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建占位图片
  Widget _buildPlaceholderImage(ExtColors colors, {double size = 200}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.lightGray ?? const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(size == 200 ? 16 : 8),
      ),
      child: Icon(
        Icons.image,
        color: colors.textAuxiliaryLight3 ?? const Color(0xFF999999),
        size: size * 0.3,
      ),
    );
  }

  /// 格式化时间差（支持多语言）
  String _formatTimeAgo(BuildContext context, Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays} ${'home_time_ago_day'.tr()}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${'home_time_ago_hour'.tr()}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${'home_time_ago_min'.tr()}';
    } else {
      return 'home_time_ago_just_now'.tr();
    }
  }
}
