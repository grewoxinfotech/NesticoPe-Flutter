import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedIconScaler extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double minSize;
  final double maxSize;
  final Duration duration;

  const AnimatedIconScaler({
    super.key,
    required this.icon,
    this.color = Colors.purple,
    this.minSize = 24,
    this.maxSize = 36,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedIconScaler> createState() => _AnimatedIconScalerState();
}

class _AnimatedIconScalerState extends State<AnimatedIconScaler>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        // Smooth scaling between min and max size
        final scale =
            widget.minSize + (widget.maxSize - widget.minSize) * (sin(_controller.value * 2 * pi) + 1) / 2;
        return Icon(
          widget.icon,
          color: widget.color,
          size: scale,
        );
      },
    );
  }
}




class AnimatedContainerScaler extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;
  final Curve curve;

  const AnimatedContainerScaler({
    super.key,
    required this.child,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.duration = const Duration(seconds: 2),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedContainerScaler> createState() =>
      _AnimatedContainerScalerState();
}

class _AnimatedContainerScalerState extends State<AnimatedContainerScaler>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        // Create a smooth oscillation between min and max scale
     /*   final double scale = widget.minScale +
            (widget.maxScale - widget.minScale) *
                (sin(_controller.value * 2 * pi) + 1) /
                2;*/
        final double dy=cos(_controller.value*2*pi)*2;

        return Transform.translate(
          // scale: scale,
          offset: Offset(0, dy),
          child: widget.child,
        );
      },
    );
  }
}
class ProgressWithLabel extends StatelessWidget {
  final double progressValue; // between 0 and 1
  final Color progressColor;
  final Color backgroundColor;
  final double thickness;
  final Color labelColor;

  const ProgressWithLabel({
    super.key,
    required this.progressValue,
    this.progressColor = const Color(0xff725AB7),
    this.backgroundColor = const Color(0xff725AB7),
    this.thickness = 8.0,
    this.labelColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth; // full width
        final double clampedProgress = progressValue.clamp(0.0, 1.0);
        final double labelPosition =
            (barWidth - 40) * clampedProgress; // adjust 40 for bubble width

        final percent = (clampedProgress * 100).toInt();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 🟣 Progress bar with shimmer
            ClipRRect(
              borderRadius: BorderRadius.circular(thickness),
              child: Stack(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: clampedProgress),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: backgroundColor.withOpacity(0.1),

                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      minHeight: thickness,
                    ),
                  ),
                  // ✨ Shimmer overlay (optional)
                  Positioned.fill(
                    child: Shimmer.fromColors(
                      baseColor: Colors.transparent,

                      highlightColor: Colors.white.withOpacity(0.4),
                      period: const Duration(seconds: 2),
                      child: Container(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // 🎯 Floating percentage bubble
            Positioned(
              left: labelPosition,
              top: thickness + 6,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  "$percent%",
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
class TiltingIcon extends StatefulWidget {
  /// The icon widget to animate (required)
  final Icon icon;

  /// Duration of one full back-and-forth cycle
  final Duration duration;

  /// Maximum tilt angle (in radians) — e.g., 0.2 ≈ 11.5°
  final double tiltAmount;

  /// Direction of tilt:
  /// - "horizontal" → tilts left & right
  /// - "vertical" → tilts up & down
  final TiltDirection direction;

  const TiltingIcon({
    super.key,
    required this.icon,
    this.duration = const Duration(seconds: 2),
    this.tiltAmount = 0.1,
    this.direction = TiltDirection.horizontal,
  });

  @override
  State<TiltingIcon> createState() => _TiltingIconState();
}

enum TiltDirection { horizontal, vertical }

class _TiltingIconState extends State<TiltingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Create a smooth oscillating motion
        final value = math.sin(_controller.value * 2 * math.pi);
        final angle = value * widget.tiltAmount;

        // Choose rotation axis based on direction
        final transform = widget.direction == TiltDirection.horizontal
            ? Matrix4.rotationZ(angle)
            : (Matrix4.identity()..rotateX(angle));

        return Transform(
          alignment: Alignment.bottomCenter,
          transform: transform,
          child: child,
        );
      },
      child: widget.icon,
    );
  }
}




class RotationIconWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const RotationIconWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 0.9,
    this.maxScale = 1.1,
  });

  @override
  State<RotationIconWidget> createState() => _RotationIconWidgetState();
}

class _RotationIconWidgetState extends State<RotationIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        // full rotation from 0 → 2π (360°)
        final double angle = _controller.value * 2 * math.pi;

        // smooth oscillation for scaling
        final double scale = widget.minScale +
            (widget.maxScale - widget.minScale) *
                (math.sin(_controller.value * 2 * math.pi) + 1) / 2;

        return Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}


class ScaleIconWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const ScaleIconWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 0.9,
    this.maxScale = 1.1,
  });

  @override
  State<ScaleIconWidget> createState() => _ScaleIconWidgetState();
}

class _ScaleIconWidgetState extends State<ScaleIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        // full rotation from 0 → 2π (360°)

        // smooth oscillation for scaling
        final double scale = widget.minScale +
            (widget.maxScale - widget.minScale) *
                (math.sin(_controller.value * 2 * math.pi) + 1) / 2;

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}



