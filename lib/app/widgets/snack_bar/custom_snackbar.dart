import 'package:flutter/material.dart';

import '../../constants/app_font_sizes.dart';
import '../../constants/color_res.dart';

/// Custom SnackBar widget with different types and animations
class CustomSnackBar {
  static void show(
      BuildContext context, {
        required String message,
        SnackBarType type = SnackBarType.info,
        Duration? duration = const Duration(seconds: 3),
        VoidCallback? onActionPressed,
        String? actionLabel,
      }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _CustomSnackBarWidget(
        message: message,
        type: type,
        duration: duration??Duration(),
        onDismiss: () => overlayEntry.remove(),
        onActionPressed: onActionPressed,
        actionLabel: actionLabel,
      ),
    );

    overlay.insert(overlayEntry);
  }
}

enum SnackBarType { success, error, warning, info }

class _CustomSnackBarWidget extends StatefulWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback onDismiss;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const _CustomSnackBarWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  State<_CustomSnackBarWidget> createState() => _CustomSnackBarWidgetState();
}

class _CustomSnackBarWidgetState extends State<_CustomSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case SnackBarType.success:
        return const Color(0xFF4CAF50);
      case SnackBarType.error:
        return const Color(0xFFE53935);
      case SnackBarType.warning:
        return const Color(0xFFFFA726);
      case SnackBarType.info:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.warning:
        return Icons.warning;
      case SnackBarType.info:
        return Icons.info;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: ColorRes.transparentColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(_getIcon(), color: ColorRes.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style:  TextStyle(
                        color: ColorRes.white,
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                  if (widget.actionLabel != null &&
                      widget.onActionPressed != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        widget.onActionPressed!();
                        _dismiss();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: ColorRes.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(
                        widget.actionLabel!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  IconButton(
                    icon: const Icon(Icons.close, color: ColorRes.white),
                    onPressed: _dismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
