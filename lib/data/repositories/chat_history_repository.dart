import 'dart:convert';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/data/models/chat_history_model.dart';

/// 聊天历史记录 Repository
class ChatHistoryRepository {
  final StorageService _storage = StorageService();

  /// 保存聊天历史记录
  Future<bool> saveChatHistory(ChatHistoryModel history) async {
    final histories = getAllChatHistories();
    // 检查是否已存在（根据id）
    final existingIndex = histories.indexWhere((h) => h.id == history.id);
    if (existingIndex >= 0) {
      // 如果存在，更新
      histories[existingIndex] = history;
    } else {
      // 如果不存在，添加到开头
      histories.insert(0, history);
    }
    // 限制最多保存100条记录
    if (histories.length > 100) {
      histories.removeRange(100, histories.length);
    }
    return await _saveChatHistories(histories);
  }

  /// 获取所有聊天历史记录（按时间倒序）
  List<ChatHistoryModel> getAllChatHistories() {
    final jsonStr = _storage.getString(AppConstants.keyChatHistoryList);
    if (jsonStr == null || jsonStr.isEmpty) {
      return [];
    }
    try {
      final jsonList = jsonDecode(jsonStr) as List<dynamic>;
      final histories =
          jsonList
              .map((e) => ChatHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
      histories.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 按时间倒序
      return histories;
    } catch (e) {
      return [];
    }
  }

  /// 删除聊天历史记录
  Future<bool> deleteChatHistory(String id) async {
    final histories = getAllChatHistories();
    histories.removeWhere((h) => h.id == id);
    return await _saveChatHistories(histories);
  }

  /// 清除所有聊天历史记录
  Future<bool> clearAllChatHistories() async {
    return await _storage.remove(AppConstants.keyChatHistoryList);
  }

  /// 保存聊天历史记录列表
  Future<bool> _saveChatHistories(List<ChatHistoryModel> histories) async {
    try {
      // 如果列表为空，直接清除存储
      if (histories.isEmpty) {
        return await _storage.remove(AppConstants.keyChatHistoryList);
      }
      final jsonList = histories.map((h) => h.toJson()).toList();
      final jsonStr = jsonEncode(jsonList);
      return await _storage.setString(AppConstants.keyChatHistoryList, jsonStr);
    } catch (e) {
      // 如果保存失败，返回false
      return false;
    }
  }
}
