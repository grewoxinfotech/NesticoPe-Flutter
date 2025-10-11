import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';

import '../../app/constants/color_res.dart';

class NesticoPeCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Color? color;
  final Gradient? gradient;
  final DecorationImage? image;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BoxShape shape;
  final BlendMode? backgroundBlendMode;
  final Widget? child;

  const NesticoPeCard({
    super.key,
    this.width,
    this.height,
    this.alignment,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.image,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.shape = BoxShape.rectangle,
    this.backgroundBlendMode,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? Get.theme.colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.large),
        gradient: gradient,
        image: image,
        shape: shape,
        border: border,
        backgroundBlendMode: backgroundBlendMode,
        boxShadow:
        boxShadow ??
            [
              BoxShadow(
                  color: ColorRes.blackShade12,
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(0,10)
              )

            ],
      ),
      child: child,
    );
  }
}
