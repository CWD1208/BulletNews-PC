import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockc/core/router/router.dart';
import 'package:stockc/core/services/user_service.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/core/theme/app_theme.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/presentation/providers/theme_provider.dart';

import 'package:stockc/core/config/env_config.dart';
import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/core/services/appsflyer_service.dart';
import 'package:toastification/toastification.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await StorageService().init();


  // 初始化 AppsFlyer 并触发 app_open 埋点
  await _initAppsFlyerAndLogAppOpen();

  // 初始化用户服务
  await UserService().init();

  // 读取保存的语言设置
  final storage = StorageService();
  final savedLanguageCode = storage.getString('selected_language');
  Locale? startLocale;
  if (savedLanguageCode != null) {
    if (savedLanguageCode == 'zh') {
      startLocale = const Locale('zh', 'CN');
    } else if (savedLanguageCode == 'en') {
      startLocale = const Locale('en', 'US');
    } else if (savedLanguageCode == 'de') {
      startLocale = const Locale('de', 'DE');
    } else if (savedLanguageCode == 'es') {
      startLocale = const Locale('es', 'ES');
    } else if (savedLanguageCode == 'ja') {
      startLocale = const Locale('ja', 'JP');
    } else if (savedLanguageCode == 'ko') {
      startLocale = const Locale('ko', 'KR');
    }
  } else {
    startLocale = const Locale('en', 'US');
  }

  // 设置系统 UI 样式（启动初始值，后续在 MyApp 中根据主题更新）
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFF5F6F8),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Color(0xFFF5F6F8),
        systemNavigationBarContrastEnforced: false,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Initialize Dio with Environment (DEV by default)
  DioClient().init(EnvConfig.dev); // TODO: 线上环境记得修改

  // Setup Global Auth Listener
  setupAuthListener();


  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('de', 'DE'),
        Locale('es', 'ES'),
        Locale('ja', 'JP'),
        Locale('ko', 'KR'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: startLocale,
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

/// 初始化 AppsFlyer 并记录 app_open 埋点
Future<void> _initAppsFlyerAndLogAppOpen() async {
  try {
    // 初始化 AppsFlyer
    await AppsFlyerService().init(isDebug: false);
    // 触发 app_open 埋点
    await AppsFlyerService().logEvent('app_open');
  } catch (e) {
    debugPrint('Failed to initialize AppsFlyer or log app_open: $e');
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;
    final extColors = Theme.of(context).extension<ExtColors>();
    final navColor =
        extColors?.globalBackground ??
        (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F6F8));

    // 根据主题模式更新系统 UI 样式
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: navColor,
          systemNavigationBarDividerColor: navColor,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarContrastEnforced: false,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      );
    }
    return MaterialApp.router(
      title: 'Vestor AI',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ToastificationWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
