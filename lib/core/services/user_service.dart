import 'dart:convert';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/data/models/user_model.dart';
import 'package:stockc/data/repositories/auth_repository.dart';
import 'package:stockc/data/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

/// 用户服务类
/// 负责管理当前用户的登录状态、token、用户信息等
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final StorageService _storage = StorageService();
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();
  final DioClient _dioClient = DioClient();

  UserModel? _currentUser;
  String? _token;

  /// 获取当前用户信息（从内存）
  UserModel? get currentUser => _currentUser;

  /// 获取当前token（从内存）
  String? get token => _token;

  /// 初始化服务（应用启动时调用）
  Future<void> init() async {
    await _loadToken();
    // 先加载本地用户信息（包含本地更新的使用次数）
    await _loadUserInfo();
    if (!isLoggedIn()) {
      await autoLogin();
    }
    // 然后刷新服务器数据（会保留本地的使用次数）
    await refreshUserInfo();
  }

  /// 检查是否已登录
  bool isLoggedIn() {
    final userInfo = _storage.getString(AppConstants.keyUserInfo);
    final isLoggedIn = userInfo != null && userInfo.isNotEmpty;
    final hasToken = _token != null && _token!.isNotEmpty;
    return isLoggedIn && hasToken;
  }

  /// 获取token（从本地存储）
  String? getToken() {
    if (_token != null) {
      return _token;
    }
    _token = _storage.getString(AppConstants.keyUserToken);
    return _token;
  }

  /// 设置token
  Future<void> setToken(String token) async {
    _token = token;
    await _storage.setString(AppConstants.keyUserToken, token);
    // 同时设置到 DioClient
    _dioClient.setToken(token);
  }

  /// 获取当前用户信息（从本地存储）
  UserModel? getUserInfo() {
    if (_currentUser != null) {
      return _currentUser;
    }
    return _loadUserInfoSync();
  }

  /// 设置用户信息
  Future<void> setUserInfo(UserModel user) async {
    _currentUser = user;
    final userJson = jsonEncode(user.toJson());
    await _storage.setString(AppConstants.keyUserInfo, userJson);
  }

  /// 自动登录
  Future<void> autoLogin() async {
    // 从本地获取uuid
    String? uuid = _storage.getString(AppConstants.keyUuid);
    if (uuid == null || uuid.isEmpty) {
      uuid = Uuid().v4();
      _storage.setString(AppConstants.keyUuid, uuid);
    }
    // 调用自动登录接口
    final response = await _userRepository.autoLogin(uuid);
    await setToken(response.token);
    await setUserInfo(response.account);
  }

  /// 登录
  /// [username] 用户名
  /// [password] 密码
  /// 返回是否登录成功
  Future<bool> login(String username, String password) async {
    try {
      // 调用登录接口
      await _authRepository.login(username, password);

      // 获取token（从DioClient）
      final token = _dioClient.token;
      if (token == null || token.isEmpty) {
        return false;
      }

      // 保存token
      await setToken(token);

      // 获取用户信息
      try {
        final handle = _currentUser?.handle;
        if (handle == null) {
          return false;
        }
        final user = await _userRepository.getProfile();
        await setUserInfo(user);
      } catch (e) {
        // 如果获取用户信息失败，仍然认为登录成功（token已保存）
        // 可以后续再获取用户信息
      }

      // 设置登录状态
      await _storage.setBool(AppConstants.keyIsLoggedIn, true);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 退出登录
  /// [clearUserData] 是否清除用户数据（默认true）
  Future<void> logout({bool clearUserData = true}) async {
    try {
      // 调用登出接口
      await _authRepository.logout();
    } catch (e) {
      // 即使登出接口失败，也继续清除本地数据
    }

    // 清除token
    _token = null;
    await _storage.remove(AppConstants.keyUserToken);
    _dioClient.setToken(null);

    // 清除用户信息
    _currentUser = null;
    if (clearUserData) {
      await _storage.remove(AppConstants.keyUserInfo);
    }

    // 清除登录状态
    await _storage.setBool(AppConstants.keyIsLoggedIn, false);
  }

  /// 清除所有用户相关数据
  Future<void> clearAllUserData() async {
    await logout(clearUserData: true);
  }

  /// 刷新用户信息（从服务器获取最新信息）
  /// 注意：会保留本地的 bubu_daily_used 和 planb_daily_used（如果本地值更大）
  Future<UserModel?> refreshUserInfo() async {
    try {
      // 先获取本地保存的使用次数（如果存在）
      final localUser = getUserInfo();
      final localBubuUsed = localUser?.bubu_daily_used ?? 0;
      final localPlanbUsed = localUser?.planb_daily_used ?? 0;

      // 从服务器获取最新信息
      final serverUser = await _userRepository.getProfile();

      // 合并数据：保留更大的使用次数值（本地可能已更新但服务器未同步）
      final mergedUser = UserModel(
        id: serverUser.id,
        username: serverUser.username,
        avatar: serverUser.avatar,
        handle: serverUser.handle,
        language: serverUser.language,
        bubu_daily_used:
            localBubuUsed > serverUser.bubu_daily_used
                ? localBubuUsed
                : serverUser.bubu_daily_used,
        bubu_daily_max: serverUser.bubu_daily_max,
        planb_daily_used:
            localPlanbUsed > serverUser.planb_daily_used
                ? localPlanbUsed
                : serverUser.planb_daily_used,
        planb_daily_max: serverUser.planb_daily_max,
      );

      await setUserInfo(mergedUser);
      return mergedUser;
    } catch (e) {
      return null;
    }
  }

  /// 从本地存储加载token
  Future<void> _loadToken() async {
    _token = _storage.getString(AppConstants.keyUserToken);
    if (_token != null && _token!.isNotEmpty) {
      _dioClient.setToken(_token);
    }
  }

  /// 从本地存储加载用户信息
  Future<void> _loadUserInfo() async {
    final userJson = _storage.getString(AppConstants.keyUserInfo);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final json = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(json);
      } catch (e) {
        // 解析失败，清除无效数据
        await _storage.remove(AppConstants.keyUserInfo);
      }
    }
  }

  /// 从本地存储同步加载用户信息（同步方法）
  UserModel? _loadUserInfoSync() {
    final userJson = _storage.getString(AppConstants.keyUserInfo);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final json = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(json);
        return _currentUser;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
