 import 'package:flutter/material.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.value, // e.g. 4.6, 4.7, etc.
    this.starCount = 5,
    this.size = 20,
    this.spacing = 4,
    this.fillColor =  ColorRes.homeYellow,
    this.emptyColor = const Color(0xFFBDBDBD),
    this.showValue = true, // show numeric text beside stars
    this.textStyle = const TextStyle(fontSize: AppFontSizes.medium, fontWeight: AppFontWeights.medium),
  });

  final double value;
  final int starCount;
  final double size;
  final double spacing;
  final Color fillColor;
  final Color emptyColor;
  final bool showValue;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, starCount.toDouble());

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ⭐ Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(starCount, (i) {
            final starIndex = i.toDouble();
            double fill = (clamped - starIndex).clamp(0.0, 1.0);

            return Padding(
              padding: EdgeInsets.only(right: i == starCount - 1 ? 0 : spacing),
              child: _FractionalStar(
                size: size,
                fillFraction: fill,
                fillColor: fillColor,
                emptyColor: emptyColor,
              ),
            );
          }),
        ),

        if (showValue) ...[const SizedBox(width: 6)],
      ],
    );
  }
}

class _FractionalStar extends StatelessWidget {
  const _FractionalStar({
    required this.size,
    required this.fillFraction,
    required this.fillColor,
    required this.emptyColor,
  });

  final double size;
  final double fillFraction; // 0.0..1.0
  final Color fillColor;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Icon(Icons.star_border_rounded, size: size, color: emptyColor),
          ClipRect(
            clipper: _HorizontalClipper(fraction: fillFraction),
            child: Icon(Icons.star_rounded, size: size, color: fillColor),
          ),
        ],
      ),
    );
  }
}

class _HorizontalClipper extends CustomClipper<Rect> {
  _HorizontalClipper({required this.fraction});

  final double fraction;

  @override
  Rect getClip(Size size) {
    final w = size.width * fraction.clamp(0.0, 1.0);
    return Rect.fromLTWH(0, 0, w, size.height);
  }

  @override
  bool shouldReclip(_HorizontalClipper oldClipper) =>
      oldClipper.fraction != fraction;
}
