import 'package:flutter/material.dart';

/// A customizable shimmer effect widget that can be used for loading states
class ShimmerWidget extends StatefulWidget {
  /// The child widget to apply shimmer effect on
  final Widget? child;

  /// Width of the shimmer container
  final double? width;

  /// Height of the shimmer container
  final double? height;

  /// Base color of the shimmer (background)
  final Color baseColor;

  /// Highlight color of the shimmer (animated color)
  final Color highlightColor;

  /// Border radius of the shimmer container
  final BorderRadius? borderRadius;

  /// Duration of the shimmer animation
  final Duration duration;

  /// Shape of the shimmer container
  final BoxShape shape;

  /// Whether the shimmer is enabled
  final bool enabled;

  const ShimmerWidget({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.borderRadius,
    this.duration = const Duration(milliseconds: 1500),
    this.shape = BoxShape.rectangle,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child ?? const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.rectangle
                ? widget.borderRadius
                : null,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                0.0,
                _animation.value.clamp(0.0, 1.0),
                1.0,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Transform for the sliding gradient animation
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Pre-built shimmer shapes for common use cases
class ShimmerShapes {
  /// Circular shimmer (for avatars, profile pictures)
  static Widget circle({
    required double size,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return ShimmerWidget(
      width: size,
      height: size,
      shape: BoxShape.circle,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  /// Rectangular shimmer with rounded corners (for cards, images)
  static Widget rounded({
    double? width,
    double? height,
    double borderRadius = 8.0,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return ShimmerWidget(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  /// Text shimmer (for loading text lines)
  static Widget text({
    double width = 100,
    double height = 16,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return ShimmerWidget(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  /// Rectangular shimmer (for full-width elements)
  static Widget rectangle({
    double? width,
    double? height,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return ShimmerWidget(
      width: width,
      height: height,
      borderRadius: BorderRadius.zero,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}

/// Example shimmer layouts for common UI patterns
class ShimmerLayouts {
  /// List tile shimmer (for list items)
  static Widget listTile({
    bool hasLeading = true,
    bool hasTrailing = false,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (hasLeading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ShimmerShapes.circle(size: 48),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerShapes.text(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 150, height: 14),
              ],
            ),
          ),
          if (hasTrailing)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ShimmerShapes.rounded(width: 60, height: 30),
            ),
        ],
      ),
    );
  }

  /// Card shimmer (for card layouts)
  static Widget card({
    double? width,
    double height = 200,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: width,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerShapes.rounded(
            width: double.infinity,
            height: height * 0.6,
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          ShimmerShapes.text(width: double.infinity, height: 18),
          const SizedBox(height: 8),
          ShimmerShapes.text(width: 200, height: 14),
        ],
      ),
    );
  }

  /// Profile shimmer (for user profile sections)
  static Widget profile({
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          ShimmerShapes.circle(size: 80),
          const SizedBox(height: 16),
          ShimmerShapes.text(width: 150, height: 20),
          const SizedBox(height: 8),
          ShimmerShapes.text(width: 200, height: 14),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ShimmerShapes.text(width: 60, height: 24),
                  const SizedBox(height: 4),
                  ShimmerShapes.text(width: 60, height: 12),
                ],
              ),
              Column(
                children: [
                  ShimmerShapes.text(width: 60, height: 24),
                  const SizedBox(height: 4),
                  ShimmerShapes.text(width: 60, height: 12),
                ],
              ),
              Column(
                children: [
                  ShimmerShapes.text(width: 60, height: 24),
                  const SizedBox(height: 4),
                  ShimmerShapes.text(width: 60, height: 12),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}