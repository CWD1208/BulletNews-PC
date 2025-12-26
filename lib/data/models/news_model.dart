import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// 新闻模型
class NewsModel {
  final String id; // guid
  final String title;
  final String source; // channel_nickname
  final DateTime publishTime; // published_at_ts (时间戳)
  final String? imageUrl; // thumbnail
  final bool isLargeCard; // 是否为大卡片样式（根据位置判断或默认false）
  final String? content; // 新闻内容（HTML格式）
  final String? originalUrl; // source_link
  final String? summary; // 摘要
  final int? likeCount; // like_cnt
  final int? collectCount; // collect_cnt
  final bool isLiked; // feed_state.like
  final bool isCollected; // feed_state.collect
  final bool isFollowed; // channel_state.follow
  final int? category; // 分类

  const NewsModel({
    required this.id,
    required this.title,
    required this.source,
    required this.publishTime,
    this.imageUrl,
    this.isLargeCard = false,
    this.content,
    this.originalUrl,
    this.summary,
    this.likeCount,
    this.collectCount,
    this.isLiked = false,
    this.isCollected = false,
    this.isFollowed = false,
    this.category,
  });

  /// 从JSON创建
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    // 处理时间戳：published_at_ts 是毫秒时间戳
    DateTime publishTime;
    if (json['published_at_ts'] != null) {
      final ts = json['published_at_ts'] as num;
      publishTime = DateTime.fromMillisecondsSinceEpoch(ts.toInt());
    } else if (json['publish_time'] != null) {
      publishTime = DateTime.parse(json['publish_time'] as String);
    } else if (json['created_at'] != null) {
      publishTime = DateTime.parse(json['created_at'] as String);
    } else {
      publishTime = DateTime.now();
    }

    // 处理 feed_state
    final feedState = json['feed_state'] as Map<String, dynamic>?;
    final isLiked = (feedState?['like'] as num?)?.toInt() == 1;
    final isCollected = (feedState?['collect'] as num?)?.toInt() == 1;

    // 处理 channel_state
    final channelState = json['channel_state'] as Map<String, dynamic>?;
    final isFollowed = (channelState?['follow'] as num?)?.toInt() == 1;

    return NewsModel(
      id: json['guid'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      source:
          json['channel_nickname'] as String? ??
          json['source'] as String? ??
          '',
      publishTime: publishTime,
      imageUrl:
          json['thumbnail'] as String? ??
          json['image_url'] as String? ??
          json['imageUrl'] as String?,
      isLargeCard:
          json['is_large_card'] as bool? ??
          json['isLargeCard'] as bool? ??
          false,
      content: json['content'] as String? ?? json['body'] as String?,
      originalUrl:
          json['source_link'] as String? ??
          json['original_url'] as String? ??
          json['url'] as String?,
      summary: json['summary'] as String?,
      likeCount: (json['like_cnt'] as num?)?.toInt(),
      collectCount: (json['collect_cnt'] as num?)?.toInt(),
      isLiked: isLiked,
      isCollected: isCollected,
      isFollowed: isFollowed,
      category: (json['category'] as num?)?.toInt(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'guid': id,
      'title': title,
      'channel_nickname': source,
      'published_at_ts': publishTime.millisecondsSinceEpoch,
      'thumbnail': imageUrl,
      'is_large_card': isLargeCard,
      'content': content,
      'source_link': originalUrl,
      'summary': summary,
      'like_cnt': likeCount,
      'collect_cnt': collectCount,
      'feed_state': {'like': isLiked ? 1 : 0, 'collect': isCollected ? 1 : 0},
      'channel_state': {'follow': isFollowed ? 1 : 0},
      'category': category,
    };
  }

  /// 获取时间差（用于格式化）
  Duration get timeDifference {
    return DateTime.now().difference(publishTime);
  }

  /// 格式化发布时间（如 "25 mins ago"）
  String formattedTimeAgo(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(publishTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${'home_time_ago_day'.tr(context: context)}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${'home_time_ago_hour'.tr(context: context)}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${'home_time_ago_min'.tr(context: context)}';
    } else {
      return 'home_time_ago_just_now'.tr(context: context);
    }
  }
}
