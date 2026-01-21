import 'package:flutter/foundation.dart';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/services/user_service.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

/// AppsFlyer 服务类
/// 负责初始化 AppsFlyer SDK 和埋点统计
class AppsFlyerService {
  static final AppsFlyerService _instance = AppsFlyerService._internal();
  factory AppsFlyerService() => _instance;
  AppsFlyerService._internal();

  final StorageService _storage = StorageService();

  AppsflyerSdk? _appsflyerSdk;
  bool _isInitialized = false;

  /// 是否已初始化
  bool get isInitialized => _isInitialized;

  /// 初始化 AppsFlyer
  /// [devKey] AppsFlyer Dev Key
  /// [appId] iOS App ID (可选，仅 iOS 需要)
  /// [isDebug] 是否为调试模式
  Future<void> init({bool isDebug = false}) async {
    if (_isInitialized) {
      debugPrint('AppsFlyer already initialized');
      return;
    }

    try {
      // 从存储中获取配置，如果没有则使用传入的参数
      final savedDevKey = AppConstants.keyAppsflyerApiKey;
      final savedAppId = AppConstants.keyAppsflyerId;

      // 创建 AppsFlyer 选项
      final appsFlyerOptions = AppsFlyerOptions(
        afDevKey: savedDevKey,
        appId: savedAppId,
        showDebug: isDebug,
        timeToWaitForATTUserAuthorization: 60, // iOS 14+ ATT 授权等待时间
      );

      // 初始化 SDK
      _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

      // 设置回调监听
      _appsflyerSdk?.onInstallConversionData((data) {
        debugPrint('AppsFlyer onInstallConversionData: $data');
        // 保存 AppsFlyer ID
        if (data['af_status'] == 'Non-organic') {
          final afId = data['media_source'];
          if (afId != null) {
            _storage.setString(AppConstants.keyAppsflyerId, afId.toString());
          }
        }
      });

      _appsflyerSdk?.onDeepLinking((data) {
        debugPrint('AppsFlyer onDeepLinking: $data');
      });

      // 启动 SDK
      await _appsflyerSdk?.initSdk(
        registerConversionDataCallback: true,
        registerOnDeepLinkingCallback: true,
        registerOnAppOpenAttributionCallback: true,
      );
      _isInitialized = true;

      // 设置用户 ID（如果用户已登录）
      _updateCustomUserId();
    } catch (e) {
      debugPrint('AppsFlyer initialization error: $e');
    }
  }

  /// 更新自定义用户 ID（使用当前用户的 handle）
  Future<void> _updateCustomUserId() async {
    if (!_isInitialized || _appsflyerSdk == null) {
      return;
    }

    try {
      final user = UserService().currentUser;
      if (user?.handle != null) {
        _appsflyerSdk?.setCustomerUserId(user!.handle.toString());
      }
    } catch (e) {
      debugPrint('AppsFlyer setCustomUserId error: $e');
    }
  }

  /// 设置自定义用户 ID（公开方法，供外部调用）
  /// 当用户登录或更新信息时调用
  Future<void> setCustomUserId() async {
    await _updateCustomUserId();
  }

  /// 记录事件
  /// [eventName] 事件名称
  /// [eventValues] 事件参数（可选）
  Future<void> logEvent(
    String eventName, {
    Map<String, dynamic>? eventValues,
  }) async {
    if (!_isInitialized || _appsflyerSdk == null) {
      debugPrint('AppsFlyer not initialized, skip logEvent: $eventName');
      return;
    }

    try {
      await _appsflyerSdk?.logEvent(eventName, eventValues ?? {});
      debugPrint('AppsFlyer logEvent: $eventName, values: $eventValues');
    } catch (e) {
      debugPrint('AppsFlyer logEvent error: $e');
    }
  }

  /// 获取 AppsFlyer UID
  Future<String?> getAppsFlyerUID() async {
    if (!_isInitialized || _appsflyerSdk == null) {
      return null;
    }

    try {
      return await _appsflyerSdk?.getAppsFlyerUID();
    } catch (e) {
      debugPrint('AppsFlyer getAppsFlyerUID error: $e');
      return null;
    }
  }
}
