import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/core/utils/toast_util.dart';

/// 举报页面
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? _selectedOption;

  // 举报选项列表
  final List<String> _reportOptions = [
    'report_option_false_info',
    'report_option_investment_advice',
    'report_option_harmful',
    'report_option_bias',
    'report_option_irrelevant',
    'report_option_other',
  ];

  void _handleOptionSelected(String optionKey) {
    setState(() {
      _selectedOption = optionKey;
    });
  }

  void _handleSubmit() {
    if (_selectedOption == null) {
      return;
    }

    // TODO: 实现提交逻辑
    // 可以在这里调用 API 提交举报信息

    // 显示成功提示
    Toast.success('report_submit'.tr());

    // 返回上一页
    // context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canSubmit = _selectedOption != null;

    return Scaffold(
      backgroundColor: colors.globalBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          color: colors.textPrimaryLight ?? const Color(0xFF333333),
        ),
        title: Text('report_title'.tr(), style: context.textStyles.subtitle),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 选项列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: _reportOptions.length,
                itemBuilder: (context, index) {
                  final optionKey = _reportOptions[index];
                  final isSelected = _selectedOption == optionKey;

                  return _buildReportOption(
                    context,
                    optionKey: optionKey,
                    isSelected: isSelected,
                    onTap: () => _handleOptionSelected(optionKey),
                  );
                },
              ),
            ),
            // 提交按钮
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.globalBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: canSubmit ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canSubmit
                              ? (colors.primaryColor ?? const Color(0xFF9556FF))
                              : (colors.lightGray ?? const Color(0xFFE5E5E5)),
                      disabledBackgroundColor:
                          colors.lightGray ?? const Color(0xFFE5E5E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'report_submit'.tr(),
                      style:
                          canSubmit
                              ? context.textStyles.buttonText.copyWith(
                                color: Colors.white,
                              )
                              : context.textStyles.buttonText.copyWith(
                                color:
                                    colors.textAuxiliaryLight3 ??
                                    const Color(0xFF999999),
                              ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(
    BuildContext context, {
    required String optionKey,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 选择指示器
            Image.asset(
              isSelected
                  ? 'assets/icons/global/check-selected.png'
                  : 'assets/icons/global/check-unsel.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 16),
            // 选项文本
            Expanded(
              child: Text(optionKey.tr(), style: context.textStyles.body),
            ),
          ],
        ),
      ),
    );
  }
}
