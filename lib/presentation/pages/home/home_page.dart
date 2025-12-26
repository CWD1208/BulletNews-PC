import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockc/core/theme/theme_context_extension.dart';
import 'package:stockc/presentation/providers/tab_index_provider.dart';
import 'tabs/ai_tab.dart';
import 'tabs/book_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/me_tab.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final currentIndex = ref.watch(tabIndexNotifierProvider);

    // AI 页面在第一位
    final tabs = const [AiTab(), HomeTab(), BookTab(), MeTab()];

    return Scaffold(
      backgroundColor: colors.globalBackground,
      body: IndexedStack(index: currentIndex, children: tabs),
      bottomNavigationBar: Container(
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
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  ref,
                  index: 0,
                  icon: 'AI',
                  label: 'tab_ai',
                ),
                _buildNavItem(
                  context,
                  ref,
                  index: 1,
                  icon: 'home',
                  label: 'tab_home',
                ),
                _buildNavItem(
                  context,
                  ref,
                  index: 2,
                  icon: 'book',
                  label: 'tab_book',
                ),
                _buildNavItem(
                  context,
                  ref,
                  index: 3,
                  icon: 'me',
                  label: 'tab_me',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref, {
    required int index,
    required String icon,
    required String label,
  }) {
    final currentIndex = ref.watch(tabIndexNotifierProvider);
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(tabIndexNotifierProvider.notifier).setIndex(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Image.asset(
          'assets/icons/tabbar/${icon}${isSelected ? '-selected' : ''}.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
