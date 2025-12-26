import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Toast 类型
enum ToastType {
  success, // 成功 - 绿色背景，白色对勾图标
  error, // 失败 - 红色背景，白色X图标
  normal, // 正常 - 白色背景，无图标
}

class InAppToast {
  static OverlayEntry? _entry;
  static Timer? _timer;
  static GlobalKey<_AnimatedBannerState>? _bannerKey;

  static Widget _buildToastContent(ToastType type, String message) {
    Color backgroundColor;
    Color textColor;
    Widget? icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = const Color(0xFF4CAF50); // 绿色
        textColor = Colors.white;
        icon = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/icons/global/succeed.png',
            width: 24,
            height: 24,
          ),
        );
        break;
      case ToastType.error:
        backgroundColor = const Color(0xFFF44336); // 红色
        textColor = Colors.white;
        icon = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFF44336),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/icons/global/failed.png',
            width: 24,
            height: 24,
          ),
        );
        break;
      case ToastType.normal:
        backgroundColor = Colors.white;
        textColor = const Color(0xFF333333); // 深灰色
        icon = null;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1E3A8A), // 深蓝色边框
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[icon, const SizedBox(width: 12)],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(
    BuildContext context,
    ToastType type,
    String message, {
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    // 判断app是否在前台,不在前台则不展示
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState != AppLifecycleState.resumed) {
      return;
    }

    // 如果已有横幅在显示，先关闭后再展示，避免 GlobalKey 冲突
    if (_entry != null) {
      _timer?.cancel();
      _timer = null;
      _bannerKey?.currentState?.dismiss(() {
        _removeEntry();
        // 递归调用，重新展示
        show(context, type, message, duration: duration);
      });
      return;
    }

    // 尝试获取 Overlay，使用 rootOverlay 或当前 Navigator 的 overlay
    OverlayState? overlay;
    try {
      // 首先尝试使用 rootOverlay（适用于 MaterialApp.router）
      overlay = Overlay.of(context, rootOverlay: true);
    } catch (e) {
      // 如果失败，尝试使用 Navigator 的 overlay
      try {
        final navigator = Navigator.of(context, rootNavigator: true);
        overlay = navigator.overlay;
      } catch (e2) {
        // 如果还是失败，无法显示 Toast
        return;
      }
    }

    if (overlay == null) {
      return;
    }

    // 为本次展示生成新的 key
    final key = GlobalKey<_AnimatedBannerState>();
    _bannerKey = key;

    _entry = OverlayEntry(
      builder: (context) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _AnimatedBanner(
                key: key,
                child: _buildToastContent(type, message),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_entry!);

    _timer = Timer(duration, () {
      _bannerKey?.currentState?.dismiss(() {
        _removeEntry();
      });
    });
  }

  static void hide() {
    _timer?.cancel();
    _timer = null;
    if (_bannerKey?.currentState != null) {
      _bannerKey!.currentState!.dismiss(() {
        _removeEntry();
      });
    } else {
      _removeEntry();
    }
  }

  static void _removeEntry() {
    _entry?.remove();
    _entry = null;
    _bannerKey = null;
  }
}

class _AnimatedBanner extends StatefulWidget {
  final Widget child;
  const _AnimatedBanner({super.key, required this.child});

  @override
  State<_AnimatedBanner> createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<_AnimatedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    // 入场动画：从上往下
    _controller.forward();
  }

  void dismiss(VoidCallback onFinished) {
    if (!_controller.isAnimating) {
      _controller.reverse().whenComplete(onFinished);
    } else {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse().whenComplete(onFinished);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(opacity: _fade, child: widget.child),
    );
  }
}
