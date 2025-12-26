import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/constants/app_constants.dart';
import 'package:stockc/core/services/user_service.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/common_util.dart';
import 'package:stockc/data/models/user_model.dart';
import 'package:stockc/presentation/providers/tab_index_provider.dart';

class MeTab extends ConsumerStatefulWidget {
  const MeTab({super.key});

  @override
  ConsumerState<MeTab> createState() => _MeTabState();
}

class _MeTabState extends ConsumerState<MeTab> {
  final UserService _userService = UserService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  /// 加载用户信息  当切换tab的时候也要重新加载用户信息
  void _loadUserInfo() {
    // 从UserService获取用户信息
    _user = _userService.getUserInfo();
    final handle = _user?.handle;
    if (handle != null) {
      _userService.refreshUserInfo();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听 tab index 变化，当切换到 MeTab (index 3) 时刷新用户信息
    ref.listen<int>(tabIndexNotifierProvider, (previous, next) {
      // 如果切换到 MeTab (index 3)，刷新用户信息
      if (next == 3 && previous != 3) {
        // 延迟到下一帧执行，避免在构建过程中调用 setState
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _loadUserInfo();
          }
        });
      }
    });

    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.globalBackground,
      body: Container(
        decoration: BoxDecoration(
          image:
              isDark
                  ? null
                  : const DecorationImage(
                    image: AssetImage('assets/icons/splash/img-bg.png'),
                    fit: BoxFit.cover,
                  ),
          color: isDark ? colors.globalBackground : null,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Text(
                    'tab_me'.tr(),
                    style: context.textStyles.title.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // 用户资料部分
                _buildUserProfile(context, colors),
                const SizedBox(height: 24),
                // 设置列表
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        context,
                        colors,
                        'me_setting_language',
                        Icons.language,
                        onTap: () {
                          // 延迟执行，确保在构建完成后才进行导航
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              context.push('/language');
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingItem(
                        context,
                        colors,
                        'me_setting_faq',
                        Icons.help_outline,
                        onTap: () {
                          // 延迟执行，确保在构建完成后才进行导航
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              context.push('/faq');
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingItem(
                        context,
                        colors,
                        'me_setting_privacy',
                        Icons.privacy_tip_outlined,
                        onTap: () {
                          CommonUtil.launchUrlExternal(
                            AppConstants.urlPrivacyPolicy,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingItem(
                        context,
                        colors,
                        'me_setting_terms',
                        Icons.description_outlined,
                        onTap: () {
                          CommonUtil.launchUrlExternal(
                            AppConstants.urlTermsOfService,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingItem(
                        context,
                        colors,
                        'me_setting_logout',
                        Icons.logout,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingItem(
                        context,
                        colors,
                        'me_setting_delete_account',
                        Icons.delete_outline,
                        textColor: Colors.red,
                        onTap: () {
                          _showDeleteAccountDialog(context);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建用户资料部分
  Widget _buildUserProfile(BuildContext context, ExtColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 头像
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.lightGray,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/icons/me/avatar.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colors.lightGray,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: colors.textAuxiliaryLight3,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 用户名和邮箱
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user?.username ?? 'Username',
                  style: context.textStyles.title.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_user?.handle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '@${_user!.handle}',
                    style: context.textStyles.auxiliaryText.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建设置项
  Widget _buildSettingItem(
    BuildContext context,
    ExtColors colors,
    String titleKey,
    IconData icon, {
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: colors.alwaysWhite,
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
          children: [
            Icon(icon, size: 24, color: textColor ?? colors.textPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                titleKey.tr(),
                style: context.textStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? colors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colors.textAuxiliaryLight3,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示退出登录对话框
  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('me_logout_title'.tr()),
            content: Text('me_logout_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('me_cancel'.tr()),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // 执行退出登录逻辑
                  await _userService.logout();
                  // 刷新用户信息显示
                  _loadUserInfo();
                },
                child: Text('me_confirm'.tr()),
              ),
            ],
          ),
    );
  }

  /// 显示删除账户对话框
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('me_delete_account_title'.tr()),
            content: Text('me_delete_account_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('me_cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: 执行删除账户逻辑
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('me_confirm'.tr()),
              ),
            ],
          ),
    );
  }
}
