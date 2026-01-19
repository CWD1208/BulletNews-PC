import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/storage/storage_service.dart';
import 'package:stockc/core/theme/ext_colors.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';

/// 语言选择页面
class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final StorageService _storage = StorageService();
  Locale? _selectedLocale;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() {
    // 从本地存储获取已选择的语言
    final savedLanguageCode = _storage.getString('selected_language');
    if (savedLanguageCode != null) {
      // 根据语言代码创建对应的 Locale
      Locale? locale;
      switch (savedLanguageCode) {
        case 'en':
          locale = const Locale('en', 'US');
          break;
        case 'zh':
          locale = const Locale('zh', 'CN');
          break;
        case 'de':
          locale = const Locale('de', 'DE');
          break;
        case 'es':
          locale = const Locale('es', 'ES');
          break;
        case 'ja':
          locale = const Locale('ja', 'JP');
          break;
        case 'ko':
          locale = const Locale('ko', 'KR');
          break;
      }
      if (locale != null) {
        _selectedLocale = locale;
      }
    } else {
      // 延迟获取当前语言，确保 context 已完全初始化
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedLocale = context.locale;
          });
        }
      });
      return;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _selectLanguage(Locale locale) async {
    setState(() {
      _selectedLocale = locale;
    });
    // 保存选择的语言
    await _storage.setString('selected_language', locale.languageCode);
    // 更新应用语言
    context.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // AppBar
              _buildAppBar(context, colors),
              // 语言列表
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // English
                      _buildLanguageItem(
                        context,
                        colors,
                        const Locale('en', 'US'),
                        'language_english',
                      ),
                      const SizedBox(height: 12),
                      // 简体中文
                      _buildLanguageItem(
                        context,
                        colors,
                        const Locale('zh', 'CN'),
                        'language_chinese',
                      ),
                      const SizedBox(height: 12),
                      // Deutsch
                      _buildLanguageItem(
                        context,
                        colors,
                        const Locale('de', 'DE'),
                        'language_german',
                      ),
                      const SizedBox(height: 12),
                      // Español
                      _buildLanguageItem(
                        context,
                        colors,
                        const Locale('es', 'ES'),
                        'language_spanish',
                      ),
                      const SizedBox(height: 12),
                      // 日本語
                      _buildLanguageItem(
                        context,
                        colors,
                        const Locale('ja', 'JP'),
                        'language_japanese',
                      ),
                      const SizedBox(height: 12),
                      // 한국어
                      _buildLanguageItem(
                        context,
                        colors,
                        const Locale('ko', 'KR'),
                        'language_korean',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建AppBar
  Widget _buildAppBar(BuildContext context, ExtColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
            color: colors.textPrimary,
          ),
          Text(
            'me_setting_language'.tr(),
            style: context.textStyles.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建语言选项
  Widget _buildLanguageItem(
    BuildContext context,
    ExtColors colors,
    Locale locale,
    String languageKey,
  ) {
    final isSelected = _selectedLocale?.languageCode == locale.languageCode;

    return GestureDetector(
      onTap: () => _selectLanguage(locale),
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
            Expanded(
              child: Text(
                languageKey.tr(),
                style: context.textStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: colors.primaryColor ?? const Color(0xFF9556FF),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
